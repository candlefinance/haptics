import Foundation
import AudioToolbox
import CoreHaptics

/// A class that allows your app to play system vibrations and Apple Haptic and Audio Pattern (AHAP) files generated with [Lofelt Composer](https://composer.lofelt.com).
public class Vibrator {
    
    /// Options for device vibration rates when looping.
    public enum Frequency {
        case high
        case low
        
        fileprivate var timeInterval: TimeInterval {
            switch self {
            case .high: return 0.01
            case .low: return 1.0
            }
        }
    }
    
    /// Indicates if the device supports haptic event playback.
    public let supportsHaptics: Bool = {
        return CHHapticEngine.capabilitiesForHardware().supportsHaptics
    }()
    
    private var hapticEngine: CHHapticEngine? {
        didSet {
            guard let hapticEngine: CHHapticEngine = hapticEngine else { return }
            hapticEngine.playsHapticsOnly = true
            hapticEngine.isAutoShutdownEnabled = false
            hapticEngine.notifyWhenPlayersFinished { (_) -> CHHapticEngine.FinishedAction in return .leaveEngineRunning }
            hapticEngine.stoppedHandler = { reason in self.hapticEngineDidStop(reason: reason) }
            hapticEngine.resetHandler = { self.hapticEngineDidRecoverFromServerError() }
        }
    }
    
    private var hapticPlayer: CHHapticPatternPlayer?
    
    private var vibrateLoopTimer: Timer?
    private var hapticLoopTimer: Timer?
    
    // MARK: - Init
    /// The shared singleton instance.
    public static let shared: Vibrator = Vibrator()
    private init() {
        guard supportsHaptics else { return }
        hapticEngine = try? CHHapticEngine()
    }
    
    /// Prepares the vibrator by acquiring hardware needed for vibrations.
    public func prepare() {
        guard let hapticEngine: CHHapticEngine = hapticEngine else { return }
        try? hapticEngine.start()
    }
    
    // MARK: - Vibrate
    /// Vibrates the device.
    /// - Parameters:
    ///   - frequency: Rate at which device vibrates when looping. Has no effect if `loop` is `false`.
    ///   - loop: Determines whether the vibration repeats itself based on the `frequency`.
    public func startVibrate(frequency: Vibrator.Frequency = Vibrator.Frequency.low, loop: Bool) {
        stopVibrate()
        
        loop
            ? playVibrateSystemSoundLoop(frequency: frequency)
            : playVibrateSystemSound()
    }
    
    /// Stops vibrating the device.
    ///
    /// Has no effect if `loop` is `false` when starting the vibration.
    public func stopVibrate() {
        stopVibrateLoopTimer()
    }
    
    @objc private func playVibrateSystemSound() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    private func playVibrateSystemSoundLoop(frequency: Vibrator.Frequency) {
        playVibrateSystemSound()
        startVibrateLoopTimer(frequency: frequency)
    }
    
    private func startVibrateLoopTimer(frequency: Vibrator.Frequency) {
        guard vibrateLoopTimer == nil else { return }
        vibrateLoopTimer = Timer.scheduledTimer(timeInterval: frequency.timeInterval,
                                                target: self,
                                                selector: #selector(playVibrateSystemSound),
                                                userInfo: nil,
                                                repeats: true)
    }
    
    private func stopVibrateLoopTimer() {
        guard
            let timer: Timer = vibrateLoopTimer,
            timer.isValid
            else { return }
        
        timer.invalidate()
        vibrateLoopTimer = nil
    }
    
    // MARK: - Haptics
    /// Plays an Apple Haptic and Audio Pattern (AHAP) file.
    /// - Parameters:
    ///   - filename: The filename of the AHAP file containing the haptic pattern.
    ///   - loop: Determines whether the haptic repeats itself on completion.
    public func startHaptic(named filename: String, loop: Bool) {
        stopHaptic()
        
        loop
            ? playHapticLoop(named: filename)
            : playHaptic(named: filename)
    }
    
    /// Stops the current playing haptic pattern.
    ///
    /// Has no effect if `loop` is `false` when starting the haptic.
    public func stopHaptic() {
        stopHapticLoopTimer()
        try? hapticPlayer?.stop(atTime: CHHapticTimeImmediate)
        hapticPlayer = nil
    }
    
    private func playHaptic(named filename: String) {
        guard
            let hapticEngine: CHHapticEngine = hapticEngine,
            let hapticPath: String = Bundle.main.path(forResource: filename, ofType: AppleHapticAudioPattern.fileExtension)
            else { return }
        
        try? hapticEngine.start()
        try? hapticEngine.playPattern(from: URL(fileURLWithPath: hapticPath))
    }
    
    private func playHapticLoop(named filename: String) {
        guard
            let hapticEngine: CHHapticEngine = hapticEngine,
            let hapticPath: String = Bundle.main.path(forResource: filename, ofType: AppleHapticAudioPattern.fileExtension),
            let hapticData: Data = try? Data(contentsOf: URL(fileURLWithPath: hapticPath)),
            let appleHapticAudioPattern: AppleHapticAudioPattern = AppleHapticAudioPattern(data: hapticData),
            let appleHapticAudioPatternDictionary: [CHHapticPattern.Key: Any] = appleHapticAudioPattern.dictionaryRepresentation(),
            let hapticDuration: TimeInterval = appleHapticAudioPattern.pattern?.first(where: { $0.event?.eventDuration != nil })?.event?.eventDuration,
            let hapticPattern: CHHapticPattern = try? CHHapticPattern(dictionary: appleHapticAudioPatternDictionary),
            let hapticPlayer: CHHapticPatternPlayer = try? hapticEngine.makePlayer(with: hapticPattern)
            else { return }
        
        try? hapticEngine.start()
        self.hapticPlayer = hapticPlayer
        try? self.hapticPlayer?.start(atTime: CHHapticTimeImmediate)
        startHapticLoopTimer(timeInterval: hapticDuration)
    }
    
    @objc private func restartHapticPlayer() {
        try? hapticPlayer?.start(atTime: 0.0)
    }
    
    private func startHapticLoopTimer(timeInterval: TimeInterval) {
        guard hapticLoopTimer == nil else { return }
        hapticLoopTimer = Timer.scheduledTimer(timeInterval: timeInterval,
                                               target: self,
                                               selector: #selector(restartHapticPlayer),
                                               userInfo: nil,
                                               repeats: true)
    }
    
    private func stopHapticLoopTimer() {
        guard
            let timer: Timer = hapticLoopTimer,
            timer.isValid
            else { return }
        
        timer.invalidate()
        hapticLoopTimer = nil
    }
    
    /// Called when the haptic engine stops due to an external reason.
    private func hapticEngineDidStop(reason: CHHapticEngine.StoppedReason) {
        log("\(#function) -> reason: \(reason)")
    }
    
    /// Called when the haptic engine fails. Will attempt to restart the haptic engine.
    private func hapticEngineDidRecoverFromServerError() {
        log("\(#function)")
        try? hapticEngine?.start()
    }
    
}

private extension Vibrator {
    
    // MARK: - Logging
    func log(_ message: String) {
        #if DEBUG
            print("\n📳 \(String(describing: Vibrator.self)): \(#function) -> message: \(message)\n")
        #endif
    }
    
}

public extension AppleHapticAudioPattern {
    
    static let fileExtension: String = "ahap"
    
    // MARK: - Init
    init?(data: Data) {
        guard let appleHapticAudioPattern: AppleHapticAudioPattern = try? JSONDecoder().decode(AppleHapticAudioPattern.self, from: data) else { return nil }
        self = appleHapticAudioPattern
    }
    
    // MARK: - Dictionary
    func dictionaryRepresentation() -> [CHHapticPattern.Key: Any]? {
        guard let data: Data = try? JSONEncoder().encode(self) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [CHHapticPattern.Key: Any]
    }
    
}

// MARK: - AppleHapticAudioPattern
/// Codable representation of an Apple Haptic and Audio Pattern (AHAP) file.
///
/// # Support
/// - Works with version 1.0 AHAP files generated with [Lofelt Composer](https://composer.lofelt.com).
///   - May work with all version 1.0 AHAP files but this has not been tested.
///
/// - Note: Apple Documentation: [Representing Haptic Patterns in AHAP Files](https://developer.apple.com/documentation/corehaptics/representing_haptic_patterns_in_ahap_files).
public struct AppleHapticAudioPattern: Codable {
    public let version: Double?
    public let pattern: [Pattern]?
    
    enum CodingKeys: CHHapticPattern.Key.RawValue, CodingKey {
        case version = "Version"
        case pattern = "Pattern"
    }
}

// MARK: - Pattern
public struct Pattern: Codable {
    public let event: Event?
    public let parameterCurve: ParameterCurve?
    
    enum CodingKeys: CHHapticPattern.Key.RawValue, CodingKey {
        case event = "Event"
        case parameterCurve = "ParameterCurve"
    }
}

// MARK: - Event
public struct Event: Codable {
    public let time: TimeInterval?
    public let eventType: EventType?
    public let eventDuration: TimeInterval?
    public let eventParameters: [EventParameter]?
    
    enum CodingKeys: CHHapticPattern.Key.RawValue, CodingKey {
        case time = "Time"
        case eventType = "EventType"
        case eventDuration = "EventDuration"
        case eventParameters = "EventParameters"
    }
}

public enum EventType: CHHapticPattern.Key.RawValue, Codable {
    case hapticContinuous = "HapticContinuous"
    case hapticTransient = "HapticTransient"
}

// MARK: - EventParameter
public struct EventParameter: Codable {
    public let parameterID: EventParameterID?
    public let parameterValue: Float?
    
    enum CodingKeys: CHHapticPattern.Key.RawValue, CodingKey {
        case parameterID = "ParameterID"
        case parameterValue = "ParameterValue"
    }
}

public enum EventParameterID: CHHapticPattern.Key.RawValue, Codable {
    case hapticIntensity = "HapticIntensity"
    case hapticSharpness = "HapticSharpness"
}

// MARK: - ParameterCurve
public struct ParameterCurve: Codable {
    public let parameterID: ParameterID?
    public let time: TimeInterval?
    public let parameterCurveControlPoints: [ParameterCurveControlPoint]?
    
    enum CodingKeys: CHHapticPattern.Key.RawValue, CodingKey {
        case parameterID = "ParameterID"
        case time = "Time"
        case parameterCurveControlPoints = "ParameterCurveControlPoints"
    }
}

public enum ParameterID: CHHapticPattern.Key.RawValue, Codable {
    case hapticIntensityControl = "HapticIntensityControl"
    case hapticSharpnessControl = "HapticSharpnessControl"
}

// MARK: - ParameterCurveControlPoint
public struct ParameterCurveControlPoint: Codable {
    public let time: TimeInterval?
    public let parameterValue: Float?
    
    enum CodingKeys: CHHapticPattern.Key.RawValue, CodingKey {
        case time = "Time"
        case parameterValue = "ParameterValue"
    }
}
