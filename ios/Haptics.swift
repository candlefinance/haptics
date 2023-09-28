import Haptica

@objc(Haptics)
class Haptics: NSObject {
    let generator = UINotificationFeedbackGenerator()
    
    @objc(haptic:)
    func haptic(type: String) {
        switch type {
        case "light":
            Haptic.impact(.light).generate()
        case "medium":
            Haptic.impact(.medium).generate()
        case "heavy":
            Haptic.impact(.heavy).generate()
        case "rigid":
            Haptic.impact(.rigid).generate()
        case "soft":
            Haptic.impact(.soft).generate()
        case "success":
            generator.notificationOccurred(.success)
        case "warning":
            generator.notificationOccurred(.warning)
        default:
            generator.notificationOccurred(.error)
        }
    }
    
    @objc(hapticWithPattern:delay:)
    func hapticWithPattern(pattern: [String], delay: Double) {
        print("running haptic pattern", pattern)
        let toPattern = pattern.joined(separator: "")
        DispatchQueue.main.async {
            Haptic.play(toPattern, delay: delay)
        }
    }
}
