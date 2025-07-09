
import Foundation
import FastpixiOSVideoDataCore
@preconcurrency import THEOplayerSDK


public class THEOplayerTracker: NSObject {
    
    public var fpCoreMetrix = FastpixMetrix()
    var automaticErrorTracking: Bool = false
    public var player : THEOplayer? = nil
    public var playerToken: String? = ""
    public var customMetadata: [String: Any] = [:]
    public var periodicTimeObserver: Any?
    public var playerTimer: Timer?
    
    public var lastPlayheadTimeUpdated: CFAbsoluteTime = 0.0
    public var lastAdvertisedBitrate : Int = 0
    public var videoTransitionState: String = ""
    public var lastTimeUpdate = 0.0
    public var isEnded: Bool = false
    public var theoPlayListener: EventListener?
    public var theoSourceListener: EventListener?
    public var theoPlayingListener: EventListener?
    public var theoPauseListener: EventListener?
    public var theoTimeListener: EventListener?
    public var theoSeekListener: EventListener?
    public var theoSeekedListener: EventListener?
    public var theoErrorListener: EventListener?
    public var theoCompleteListener: EventListener?
    public var theoPresentationChangeListener: EventListener?
    
    var size: CGSize = .zero
    var lastTrackedSize: CGSize?
    var duration: Double = 0
    
    public func trackTheoPlayer(player: THEOplayer, customMetadata: [String: Any], automaticErrorTracking: Bool) {
        initializeTheoTracking(player: player, customMetadata: customMetadata, automaticErrorTracking: automaticErrorTracking)
    }
    
    public func initializeTheoTracking(player: THEOplayer, customMetadata: [String: Any], automaticErrorTracking: Bool) {
        
        if let existingPlayer = self.player {
            self.player = nil
            fpCoreMetrix.dispatch(key: playerToken ?? "", event: "destroy", metadata: [:])
            resetInitialization()
        }
        
        attachPlayer(player: player)
        
        if playerToken == "" {
            playerToken = UUID().uuidString.lowercased() as String
        }
        
        self.player = player
        self.automaticErrorTracking = automaticErrorTracking
        self.customMetadata = customMetadata
        configureTHEOPlayerTracking()
        dispatchEvent(event: "playerReady", metadata: [:])
        videoTransitionState = "playerready"
        
    }
    
    public func configureTHEOPlayerTracking() {
        var updatedMetadata = self.customMetadata // Copy existing metadata
        updatedMetadata["player_software_name"] = "iOS THEO Player"
        updatedMetadata["player_software_version"] = "1.0.0"
        fpCoreMetrix.configure(key: self.playerToken ?? "", passableMetadata: updatedMetadata, fetchPlayheadTime: fetchPlayerCurrentTime, fetchVideoState: fetchPlayerVideoState)
    }
    
    public func dispatchEvent(event: String, metadata: [String: Any] = [:]) {
        
        if (self.playerToken != "" || self.playerToken != nil) {
            fpCoreMetrix.dispatch(key: self.playerToken ?? "", event: event, metadata: metadata)
            print("Event Name",event)
        }
    }
    
    func attachPlayer(player : THEOplayer) {
        if (self.player != nil) {
            self.detachPlayer()
        }
        self.player = player
        addEventListeners()
    }
    
    func detachPlayer() {
        removeEventListeners()
        self.player = nil
    }
    
    public func fetchPlayerCurrentTime() -> Int {
        guard let playerItem = self.player  else { return 0 }
        let currentTime = playerItem.currentTime * 1000
        return Int(currentTime)
    }
    
    public func fetchPlayerVideoState() -> [String: Any] {
        theoSourceListener = player?.addEventListener(type: PlayerEventTypes.SOURCE_CHANGE) { (evt) in
            let source = evt.source?.sources.first
            if (source != nil) {
                
                let videoURL  = source?.src
                
                if (videoURL != nil) {
                    videoState["video_source_url"] = videoURL
                }
            }
        }
        
        let duration: Double? = self.player?.duration
        
        var videoState: [String:Any] =  [
            "video_source_width": self.player?.videoWidth,
            "video_source_height": self.player?.videoHeight,
            "player_width": (player?.frame.width ?? 0.0),
            "player_height": (player?.frame.height ?? 0.0),
            "player_is_paused": NSNumber(booleanLiteral: player?.paused ?? false),
            "player_autoplay_on": "true",
            "video_source_duration": ((duration ?? 0) * 1000)
        ]
        
        return videoState
    }
    
    public func videoChange(customMetadata: [String: Any]) {
        dispatchEvent(event: "videoChange", metadata: customMetadata)
    }
    
    func addEventListeners() {
        
        guard let player = player else { return }
        
        theoPlayListener = player.addEventListener(type: PlayerEventTypes.PLAY) { (_: PlayEvent) in
            
            self.dispatchEvent(event: "play", metadata: [:])
        }
        
        theoSourceListener = player.addEventListener(type: PlayerEventTypes.SOURCE_CHANGE) { (evt) in
            let source = evt.source?.sources.first
            if (source != nil) {
                
            }
        }
        
        theoPlayingListener = player.addEventListener(type: PlayerEventTypes.PLAYING) { (_: PlayingEvent) in
            self.setSizeDimensions()
            
            self.dispatchEvent(event: "playing", metadata: [:])
        }
        
        theoPauseListener = player.addEventListener(type: PlayerEventTypes.PAUSE) { (_: PauseEvent) in
            
            let time = player.currentTime
            if let duration = player.duration, time < duration {
                self.dispatchEvent(event: "pause", metadata: [:])
            }
        }
        
        theoTimeListener = player.addEventListener(type: PlayerEventTypes.TIME_UPDATE) { (evt: TimeUpdateEvent) in
            let time = evt.currentTime
            if let duration = player.duration {
                
                if time > 0, time < duration {
                    self.dispatchEvent(event: "timeUpdate", metadata: ["viewer_timestamp": self.getUniqueTimeStamp()])
                }
            }
        }
        
        theoSeekListener = player.addEventListener(type: PlayerEventTypes.SEEKING) { (_: SeekingEvent) in
            self.dispatchEvent(event: "seeking", metadata: [:])
        }
        
        theoSeekedListener = player.addEventListener(type: PlayerEventTypes.SEEKED) { (_: SeekedEvent) in
            self.dispatchEvent(event: "seeked", metadata: [:])
        }
        
        theoErrorListener = player.addEventListener(type: PlayerEventTypes.ERROR) { [weak self] (event: ErrorEvent) in
            guard let self = self else { return }
            
            var errorMetadata: [String: Any] = [:]
            
            // Safely extract THEOplayer error
            if let theoError = event.errorObject {
                let errorCode = theoError.code.rawValue
                if errorCode != 0 && errorCode != NSNotFound {
                    errorMetadata["player_error_code"] = "\(errorCode)"
                }
                
                let errorMessage = theoError.message
                if !errorMessage.isEmpty {
                    errorMetadata["player_error_message"] = errorMessage
                }
            }
            
            // Only dispatch meaningful errors
            if errorMetadata["player_error_code"] != nil {
                self.dispatchEvent(event: "error", metadata: errorMetadata)
                self.videoTransitionState = "error"
            }
        }
        
        theoCompleteListener = player.addEventListener(type: PlayerEventTypes.ENDED) { (_: EndedEvent) in
            self.dispatchEvent(event: "viewEnd", metadata: [:])
        }
        
        theoPresentationChangeListener = player.addEventListener(type: PlayerEventTypes.PRESENTATION_MODE_CHANGE) { (_: PresentationModeChangeEvent) in
            self.setSizeDimensions()
            self.dispatchEvent(event: "timeUpdate", metadata: self.customMetadata)
        }
    }
    
    func removeEventListeners() {
        
        if let playListener = theoPlayListener {
            player?.removeEventListener(type: PlayerEventTypes.PLAY, listener: playListener)
            self.theoPlayListener = nil
        }
        if let sourceListener = theoSourceListener {
            player?.removeEventListener(type: PlayerEventTypes.SOURCE_CHANGE, listener: sourceListener)
            self.theoSourceListener = nil
        }
        if let playingListener = theoPlayingListener {
            player?.removeEventListener(type: PlayerEventTypes.PLAYING, listener: playingListener)
            self.theoPlayingListener = nil
        }
        if let pauseListener = theoPauseListener {
            player?.removeEventListener(type: PlayerEventTypes.PAUSE, listener: pauseListener)
            self.theoPauseListener = nil
        }
        if let timeListener = theoTimeListener {
            player?.removeEventListener(type: PlayerEventTypes.TIME_UPDATE, listener: timeListener)
            self.theoTimeListener = nil
        }
        if let seekListener = theoSeekListener {
            player?.removeEventListener(type: PlayerEventTypes.SEEKING, listener: seekListener)
            self.theoSeekListener = nil
        }
        if let seekedListener = theoSeekedListener {
            player?.removeEventListener(type: PlayerEventTypes.SEEKED, listener: seekedListener)
            self.theoSeekedListener = nil
        }
        if let errorListener = theoErrorListener {
            player?.removeEventListener(type: PlayerEventTypes.ERROR, listener: errorListener)
            self.theoErrorListener = nil
        }
        if let completeListener = theoCompleteListener {
            player?.removeEventListener(type: PlayerEventTypes.ENDED, listener: completeListener)
            self.theoCompleteListener = nil
        }
        if let presentationChangeListener = theoPresentationChangeListener {
            player?.removeEventListener(type: PlayerEventTypes.PRESENTATION_MODE_CHANGE, listener: presentationChangeListener)
            self.theoPresentationChangeListener = nil
        }
    }
    
    public func getUniqueTimeStamp() -> Int {
        return Int(Date().timeIntervalSince1970 * 1000)
    }
    
    func setSizeDimensions () {
        guard let player = self.player else { return }
        let size = CGSize(width: player.videoWidth, height: player.videoHeight)
        if !self.size.equalTo(size) {
            self.size = size
        }
    }
    
    public func resetInitialization() {
        
        self.playerToken = ""
        self.lastAdvertisedBitrate = 0
        self.customMetadata = [:]
        self.lastPlayheadTimeUpdated = 0.0
        self.videoTransitionState = ""
        self.lastTimeUpdate = 0.0
        self.isEnded = false
    }
    
}
