import Haptico

@objc(Haptics)
class Haptics: NSObject {
    
    @objc(haptic:)
    func haptic(type: String) {
        print("running haptic", type)
        var notification: HapticoNotification? = nil
        var impact: HapticoImpact? = nil
        switch type {
        case "light":
            impact = HapticoImpact.light
        case "medium":
            impact = HapticoImpact.medium
        case "heavy":
            impact = HapticoImpact.heavy
        case "success":
            notification = HapticoNotification.success
        case "warning":
            notification = HapticoNotification.warning
        default:
            notification = HapticoNotification.error
        }
        if let notification {
            DispatchQueue.main.async {
                Haptico.shared().generate(notification)
            }
        }
        if let impact {
            DispatchQueue.main.async {
                Haptico.shared().generate(impact)
            }
        }
    }
    
    @objc(hapticWithPattern:delay:)
    func hapticWithPattern(pattern: [String], delay: Double) {
        print("running haptic pattern", pattern)
        let toPattern = pattern.joined(separator: "")
        // run on main
        DispatchQueue.main.async {
            Haptico.shared().generateFeedbackFromPattern(toPattern, delay: delay)
        }
    }
}
