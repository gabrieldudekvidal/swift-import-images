// Learn how to import and store images using SwiftData
import PhotosUI
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var photos: [Photo]
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageDisplay: Image?
    @State private var imageInsertData: Data?
    
    var body: some View {
        VStack {
            PhotosPicker(selection: $selectedImage) {
                if let imageDisplay {
                    imageDisplay
                        .resizable()
                        .scaledToFit()
                } else {
                    ContentUnavailableView("No Image", systemImage: "photo.badge.plus", description: Text("Tap to import an Image"))
                }
            }
            .buttonStyle(.plain)
            .onChange(of: selectedImage) {
                loadImage()
            }
            
            Button("Insert") {
                saveImage()
            }
            
            ScrollView {
                ForEach(photos) { photo in
                    if let uiImage = UIImage(data: photo.imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    } else {
                        Text("No images")
                    }
                }
            }
            
            Text("Photos: \(photos.count)")
        }
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedImage?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            
            imageDisplay = Image(uiImage: inputImage)
            imageInsertData = imageData
        }
    }
    
    func saveImage() {
        guard let imageInsertData else { return }
        
        let imageInsert = Photo(imageData: imageInsertData)
        modelContext.insert(imageInsert)
        
        do {
            try modelContext.save()
        } catch {
            print(error)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Photo.self, inMemory: true)
        // Creates its own temporary SwiftData database for preview.
}
