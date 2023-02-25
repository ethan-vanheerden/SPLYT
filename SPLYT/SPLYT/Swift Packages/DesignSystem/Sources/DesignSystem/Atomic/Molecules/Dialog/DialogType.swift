
public enum DialogType {
    case singleAction(title: String, action: () -> Void)
    case dualAction(primaryTitle: String, primaryAction: () -> Void, secondaryTitle: String, secondaryAction: () -> Void)
}
