import SwiftUI
import SwiftData

@Model
class Photo {
    var imageData: Data

    init(imageData: Data) {
        self.imageData = imageData
    }
}
