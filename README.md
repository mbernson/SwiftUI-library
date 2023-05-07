# SwiftUI-library

My personal library of useful SwiftUI code snippets.
It includes modifiers and views that I bring from project to project.

## Modifiers

### Readable content width

Restricts the maximum width of the view to the Apple-defined readable content width.

```swift
ScrollView {
    Text("On larger screens such as iPad or on iPhone in landscape mode, this view's width is restricted to the readable content guides.")
}
.readableContentWidth()
```

### Rounded rectangle corners

Applies clipping to this view using corner radius, but only for the specified corners.

```swift
Rectangle()
    .fill(.orange)
    .cornerRadius(8, corners: [.topLeft, .bottomLeft, .topRight])
```

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
