#  Architecture

### Different types of views
- Root views (L)
- Isolated views (M)
- Single-screen views (S)

* All views should be done in SwiftUI or at least wrapped in a UIViewControllerRepresentable/UIViewRepresentable

1. Root Views - Used as the starting point for features which should be its own navigation entry point
    - There should be very few of these
    
2. Isolated Views - Starting point for isolated screens which will have limited navigation events
    - UIViewControllerRepresentable with its view controller being a UIViewController
    - These should have some Root View being its entry point
    - Show SwiftUI Views

3. Single-Screen - Simple views which just display simple information and no navigation
    - Just SwiftUI views
    - Can be nested in an inline UIHostingController
    - Use these for the majority of components
