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
    
    @objc(hapticWithPattern:)
    func hapticWithPattern(pattern: [String]) {
        print("running haptic pattern", pattern)
        try? HapticsHelper.initialize()
        var components: [HapticsHelper.HapticPatternComponent] = []
        for char in pattern {
            guard char.count == 1 else {
                print("error: \(char)")
                return
            }
            switch char {
            case "O":
                components.append(.impact(.hard, .sharp))
            case "o":
                components.append(.impact(.hard, .dull))
            case ".":
                components.append(.impact(.soft, .sharp))
            case ":":
                components.append(.impact(.soft, .dull))
            case "-":
                components.append(.delay(0.1))
            case "=":
                components.append(.delay(1))
            default:
                print("Invalid input")
            }
        }
        try? HapticsHelper.generateHaptic(fromComponents: components).play()
    }
    
    @objc(play:loop:)
    func play(fileName: String, loop: Bool) {
        Vibrator.shared.startHaptic(named: fileName, loop: loop)
    }
}
