import SwiftUI


public class ImageSaver: NSObject {
    public func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc public func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}

public struct DownloadImageToGalleryFromURLStringButton{
    public var urlString : String?
    public init(urlString: String!) {
        self.urlString = urlString
    }
    public var body: some View {
        Button {
            let inputImageString: String = urlString ?? "https://ik.imagekit.io/hpapi/harry.jpg"
            guard let imageURL = URL(string: inputImageString) else { return }
            
            print("saved to gallery")
            
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let error = error {
                    print("Error downloading image data: \(error)")
                    return
                }
                
                if let data = data, let uiImage = UIImage(data: data) {
                    let imageSaver = ImageSaver()
                    imageSaver.writeToPhotoAlbum(image: uiImage)
                }
            }.resume()
        }
        
    label: {
        Image(systemName: "arrow.down.circle.fill")
            .offset(x:20)
            .font(.system(size: 30))
    }
    }
}
