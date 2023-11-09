import SwiftUI

public class ImageSaver: NSObject {
    public func writeToPhotoAlbum(image: UIImage, completion: @escaping (Error?) -> Void) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), completion)
    }
    
    @objc public func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Save finished with error: \(error)")
        } else {
            print("Save finished successfully!")
        }
    }
}

public struct DownloadImageToGalleryFromURLStringButton: View {
    public var urlString: String?
    @State private var showAlert = false
    @State private var alertMessage = ""

    public init(urlString: String!) {
        self.urlString = urlString
    }

    public var body: some View {
        Button {
            let inputImageString: String = urlString ?? "https://ik.imagekit.io/hpapi/harry.jpg"
            guard let imageURL = URL(string: inputImageString) else { return }

            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let error = error {
                    alertMessage = "Error downloading image data: \(error)"
                    showAlert = true
                    return
                }

                if let data = data, let uiImage = UIImage(data: data) {
                    let imageSaver = ImageSaver()
                    imageSaver.writeToPhotoAlbum(image: uiImage) { saveError in
                        if let saveError = saveError {
                            alertMessage = "Error saving image to gallery: \(saveError.localizedDescription)"
                        } else {
                            alertMessage = "Image saved successfully!"
                        }
                        showAlert = true
                    }
                }
            }.resume()
        } label: {
            Image(systemName: "arrow.down.circle.fill")
                .font(.system(size: 30))
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Image Download"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}
