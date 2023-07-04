# SwiftUI-library

My personal library of useful SwiftUI code snippets.
It includes most of the modifiers and views that I copy-paste from project to project.

Almost all are compatible with iOS 14 and later. Many of these views and modifiers are very useful for compatibility with iOS 14 and 15, where you can't use many of the fancy new SwiftUI components.

## Contents

* Views
    * Generic
        * QRCodeImage: Display a string/URL/data as a QR code
        * DocumentPicker: Wrapper for UIDocumentPickerViewController
        * ShareSheet: Wrapper for UIActivityViewController (for using a share sheet when you can't use Apple's ShareLink view)
        * SafariView: Wrapper for SFSafariViewController
    * Camera/photo
        * CameraView: Take a picture using the camera (full screen cover)
        * PhotoPicker: Pick a photo from the user's Photo library
        * ImageCropView: Crop an image (uses [RSKImageCropper](https://github.com/ruslanskorb/RSKImageCropper) under the hood)
* Modifiers
    * DeviceShake: Detect when the device is shaken
    * ErrorAlert: Present a LocalizedError as an alert
    * ReadableContentWidth: Constrains a view to the Apple-defined readable content guides
    * RoundedRectangleCorners: Round only certain corners of a view
    * ScreenBrightness: Brighten the screen when the view appears, dim again when it disappears

## Modifiers

### Readable content width

Restricts the maximum width of the view to the Apple-defined readable content width.

```swift
ScrollView {
    Text("On larger screens such as iPad or on iPhone in landscape mode, this view's width is restricted to the readable content guides.")
}
.readableContentWidth()
```

<img src="https://user-images.githubusercontent.com/477710/236678938-84c06253-0668-40c7-a63d-fd67df3bd1ab.png">

### Rounded rectangle corners

Applies clipping to this view using corner radius, but only for the specified corners.

```swift
Rectangle()
    .fill(.orange)
    .cornerRadius(8, corners: [.topLeft, .bottomLeft, .topRight])
```

<img width="564" src="https://user-images.githubusercontent.com/477710/236678948-a7feffe4-980f-4102-8d0e-dca1ce8d046a.png">

## Views

### Pickers

#### DocumentPicker

A document picker view that wraps `UIDocumentPickerViewController` and allows for customization options.

```swift
struct DocumentPickerView: View {
    @State var presentDocumentPicker = false

    var body: some View {
        Button("Document picker") {
            presentDocumentPicker.toggle()
        }
        .sheet(isPresented: $presentDocumentPicker) {
            DocumentPicker(contentTypes: [.image, .video], allowsMultipleSelection: true) { docs in
                // Do something with the resulting document URLs here
                print(docs)
            } dismiss: {
                presentDocumentPicker = false
            }
        }
    }
}
```

#### PhotoPicker

A photo picker view that wraps `PHPickerViewController` and allows for customization options.

```swift
struct PhotoPickerView: View {
    @State var presentPhotoPicker = false

    var body: some View {
        Button("Photo picker") {
            presentPhotoPicker.toggle()
        }
        .sheet(isPresented: $presentPhotoPicker) {
            PhotoPicker { items in
                // Do something with the resulting NSItemProviders here
                print(items) 
                presentPhotoPicker = false
            } dismiss: {
                presentPhotoPicker = false
            }
        }
    }
}
```

#### ImageCropView

An image cropper view that wraps [RSKImageCropViewController](https://github.com/ruslanskorb/RSKImageCropper).

### Sheets

#### ShareSheet

A share sheet view that wraps `UIActivityViewController`.

```swift
struct ShareSheetView: View {
    @State var presentShareSheet = false

    var body: some View {
        Button("Share sheet") {
            presentShareSheet.toggle()
        }
        .sheet(isPresented: $presentShareSheet) {
            ShareSheet(activityItems: [URL(string: "https://q42.com")!])
        }
    }
}
```

#### SafariView

A web browser sheet that view wraps `SFSafariViewController`.

```swift
struct SafariSheetView: View {
    @State var presentSafariView = false

    var body: some View {
        Button("Safari view") {
            presentSafariView.toggle()
        }
        .sheet(isPresented: $presentSafariView) {
            SafariView(url: URL(string: "https://q42.com")!)
        }
    }
}
```
