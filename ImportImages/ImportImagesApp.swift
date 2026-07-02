import SwiftUI
import SwiftData

@main
struct ImportImagesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Photo.self)
    }
}
