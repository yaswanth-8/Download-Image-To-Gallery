import SwiftUI


public class ImageSaver: NSObject {
    public func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc public func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}

public struct DownloadImageToGalleryFromURLStringButton: View {
    public var urlString : String?
    public init(urlString: String!) {
        self.urlString = urlString
    }
    @State private var showAlert = false
    @State private var alertMessage = ""
    public var body: some View {
        Button {
            let inputImageString: String = urlString ?? "https://ik.imagekit.io/hpapi/harry.jpg"
            guard let imageURL = URL(string: inputImageString) else { return }
            
            print("saved to gallery")
            
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let error = error {
                    print("Error downloading image data: \(error)")
                    alertMessage = "Error downloading image"
                    showAlert.toggle()
                    return
                }
                
                if let data = data, let uiImage = UIImage(data: data) {
                    let imageSaver = ImageSaver()
                    imageSaver.writeToPhotoAlbum(image: uiImage)
                    alertMessage = "image downloaded successfully"
                    showAlert.toggle()
                }
            }.resume()
        }
        
    label: {
        Image(systemName: "arrow.down.circle.fill")
            .offset(x:20)
            .font(.system(size: 30))
    }
    .alert(isPresented: $showAlert) {
                Alert(title: Text("Image Download"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
    }
}
