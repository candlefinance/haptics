import Foundation
import CoreHaptics

public typealias EngineResetHandler = (CHHapticEngine?) -> Void
public typealias EngineStopHandler = (CHHapticEngine?, CHHapticEngine.StoppedReason) -> Void
public typealias PlayersFinishedHandler = (CHHapticEngine?, Error?) -> CHHapticEngine.FinishedAction

/// AllujaHaptics control class
public final class HapticsHelper {

    public enum HapticsError: LocalizedError {
        case engineNil
        case emptyPattern
    }

    /// A generated haptic pattern, ready to be played
    public final class GeneratedHapticPattern {
        fileprivate init(pattern: CHHapticPattern, generatePlayer: Bool) throws {
            self.pattern = pattern
            if generatePlayer {
                try createPlayer()
            }
        }

        private let pattern: CHHapticPattern
        private var player: CHHapticPatternPlayer!

        /// Attempts to play the pattern
        public func play() throws {
            guard let engine = HapticsHelper.shared.engine else { throw HapticsError.engineNil }
            if player == nil {
                try createPlayer()
            }
            try engine.start()
            try player.start(atTime: 0)
        }

        private func createPlayer() throws {
            guard let engine = HapticsHelper.shared.engine else { throw HapticsError.engineNil }
            player = try engine.makePlayer(with: pattern)
        }
    }

    public static private(set) var shared: HapticsHelper!

    private let engine: CHHapticEngine?
    public let deviceSupportsHaptics: Bool

    private init(withEngineResetHandler engineReset: @escaping EngineResetHandler, withAutoShutdown autoShutdown: Bool, withStopHandler stopHandler: @escaping EngineStopHandler, withPlayersFinishedHandler playersFinished: @escaping PlayersFinishedHandler) throws {
        deviceSupportsHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics
        if deviceSupportsHaptics {
            engine = try CHHapticEngine()

            try completeEngineSetup(withEngineResetHandler: engineReset, withAutoShutdown: autoShutdown, withStopHandler: stopHandler, withPlayersFinishedHandler: playersFinished)
        } else {
            engine = nil
        }
    }
    
    /// Initializes the shared `Haptics` instance, optionally changing various behaviors
    /// - `engineReset`: Callback for when the engine resets due to the app losing focus
    /// - `autoShutdown`: Whether the engine should shutdown automatically
    /// - `stopHandler`: Callback for when the engine stops
    /// - `playersFinished`: What the engine should do when all haptics finish playing
    public static func initialize(withEngineResetHandler engineReset: @escaping EngineResetHandler = { try? $0?.start() }, withAutoShutdown autoShutdown: Bool = false, withStopHandler stopHandler: @escaping EngineStopHandler = { _,_  in }, withPlayersFinishedHandler playersFinished: @escaping PlayersFinishedHandler = { $1 != nil ? .stopEngine : .leaveEngineRunning }) throws {
        shared = try .init(withEngineResetHandler: engineReset, withAutoShutdown: autoShutdown, withStopHandler: stopHandler, withPlayersFinishedHandler: playersFinished)
    }

    deinit {
        engine?.stop(completionHandler: nil)
    }

    /// Forcefully tries to start the haptics engine
    public func startEngine() throws {
        try engine?.start()
    }

    public enum HapticPatternSharpness {
        case dull
        case sharp
        case custom(Float)
        
        var value: Float {
            switch self {
            case .dull:
                return 0
            case .sharp:
                return 1
            case .custom(let float):
                return float
            }
        }
    }
    
    public enum HapticPatternStrength {
        case hard
        case soft
        case custom(Float)
        
        var value: Float {
            switch self {
            case .hard:
                return 1
            case .soft:
                return 0.6
            case .custom(let float):
                return float
            }
        }
    }

    public enum HapticPatternComponent {
        /// Delay in a haptic pattern, nothing will be played
        case delay(TimeInterval)
        /// A haptic impact that will produce a force for the user
        case impact(HapticPatternStrength, HapticPatternSharpness)
    }

    /// Generates a haptic pattern from the given components
    /// - `components`: The components to create the haptic pattern from
    /// - `generatePlayer`: Whether to immediately generate a haptic player, may be disabled if the haptic won't be used immediately as there is a performance penalty to creating one
    public static func generateHaptic(fromComponents components: [HapticPatternComponent],
                               generatePlayer: Bool = true) throws -> GeneratedHapticPattern {
        if components.isEmpty {
            throw HapticsError.emptyPattern
        }

        var hapticArray: [CHHapticEvent] = []

        var totalDelayTime: Double = 0.0

        for component in components {
            switch component {
            case .delay(let delay):
                let params = [CHHapticEventParameter(parameterID: .hapticIntensity, value: 0)]
                hapticArray.append(CHHapticEvent(eventType: .hapticContinuous, parameters: params,
                                                 relativeTime: totalDelayTime, duration: delay))
                totalDelayTime += delay
            case .impact(let strength, let sharpness):
                let params = [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: strength.value),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness.value)
                ]
                hapticArray.append(CHHapticEvent(eventType: .hapticTransient, parameters: params, relativeTime: totalDelayTime))
            }
        }

        return try GeneratedHapticPattern(pattern: try CHHapticPattern(events: hapticArray, parameters: []),
                                          generatePlayer: generatePlayer)
    }

    private func completeEngineSetup(withEngineResetHandler engineReset: @escaping EngineResetHandler, withAutoShutdown autoShutdown: Bool, withStopHandler stopHandler: @escaping EngineStopHandler, withPlayersFinishedHandler playersFinished: @escaping PlayersFinishedHandler) throws { // swiftlint:disable:this cyclomatic_complexity
        engine!.resetHandler = {
            engineReset(self.engine)
        }

        engine!.isAutoShutdownEnabled = autoShutdown

        engine!.stoppedHandler = { reason in
            stopHandler(self.engine, reason)
        }

        engine!.notifyWhenPlayersFinished { error in
            playersFinished(self.engine, error)
        }

        // Try to prestart engine
        try engine!.start()
    }
}
