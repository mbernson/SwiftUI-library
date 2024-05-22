# SwiftUI snippet library

My personal library of useful SwiftUI code snippets.
It includes most of the modifiers and views that I copy-paste from project to project.
Each Swift file from the Views or Modifiers directories stands on its own without any 3rd party dependencies, so it can easily be copied into your project.

Almost all are compatible with iOS 14 and later. Many of these views and modifiers are very useful for compatibility with iOS 14 and 15, where you can't use many of the fancy new SwiftUI components.

## Contents

* Components
  * CodeVerificationField - Text input view with separate characters/digits for entering a code.
  * GridStack - Container view that arranges its child views centered in a grid that grows vertically.
  * InAppBrowserLink - Component that acts similar to `ShareLink`, opening a URL in an in-app browser (`SFSafariViewController`).
  * LegacyShareLink - Fallback for the SwiftUI `ShareLink` component that is compatible with iOS 15.
  * NavigationDestination
  * PrintButton - Button that allows the user to print a piece of content.
* Modifiers
  * DeviceShake - Adds an action to perform when the device is shaken.
  * ErrorAlert - Presents a human-readable alert for a localized error.
  * ReadableContentWidth - Restricts the maximum width of the view to the Apple-defined readable content width.
  * RoundedRectangleCorners - Applies clipping to this view using corner radius, but only for the specified corners.
  * ScreenBrightness - Increases the screen brightness when the view appears and restores it when the view disappears.
* Pickers
  * DocumentPicker - Pick a document using `UIDocumentPickerViewController`.
  * PhotoPicker - Pick photos and/or videos using `PHPickerViewController`.
  * PickerView - Control for selecting a value (optional or non-optional) using custom labels.
* Views
  * ImageViewer - View for zooming/panning a UIImage.
  * PDFImage - Image that displays a PDF.
  * PDFViewer - View for zooming/panning a PDF.
  * QRCodeImage - Image that displays encoded data as a QR code.
  * QRCodeScanner - A view that displays a camera feed, that scans for a QR code.
  * Sheets
    * CameraView - View that lets the user take a picture using the camera
    * ImageCropView - A view that lets the user crop an image using the [RSKImageCropper](https://github.com/ruslanskorb/RSKImageCropper) library.
    * MailComposeView - A view that lets the user compose an email using the Mail app.
    * SafariView - A view that presents a URL in an in-app browser using `SFSafariViewController`.

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

#### LegacyShareLink

A share link view that wraps `UIActivityViewController`.

```swift
LegacyShareLink("Share", item: URL(string: "https://q42.com")!) {
    print("Share completion")
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
