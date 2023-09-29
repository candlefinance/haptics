import Haptico

@objc(Haptics)
class Haptics: NSObject {
    lazy var generator = UINotificationFeedbackGenerator()
    lazy var selection = UISelectionFeedbackGenerator()
    
    @objc(haptic:)
    func haptic(type: String) {
        print("haptic", type)
        switch type {
        case "light":
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        case "medium":
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        case "heavy":
            let impact = UIImpactFeedbackGenerator(style: .heavy)
            impact.impactOccurred()
        case "rigid":
            let impact = UIImpactFeedbackGenerator(style: .rigid)
            impact.impactOccurred()
        case "soft":
            let impact = UIImpactFeedbackGenerator(style: .soft)
            impact.impactOccurred()
        case "success":
            generator.notificationOccurred(.success)
        case "warning":
            generator.notificationOccurred(.warning)
        case "selectionChanged":
            selection.selectionChanged()
        default:
            generator.notificationOccurred(.error)
        }
    }
    
    @objc(hapticWithPattern:delay:)
    func hapticWithPattern(pattern: [String], delay: Double) {
        print("running haptic pattern", pattern)
        let toPattern = pattern.joined(separator: "")
        DispatchQueue.main.async {
            Haptico.shared().generateFeedbackFromPattern(toPattern, delay: delay)
        }
    }
}
