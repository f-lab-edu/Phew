//
//  AddMemoryView.swift
//  Phew
//
//  Created by dong eun shin on 5/4/25.
//

import SwiftUI
import PhotosUI
import ComposableArchitecture

struct AddMemoryView: View {
    @State var text: String = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    var store: StoreOf<AddMemoryFeatures>
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    
                    closeButton()
                }
                
                Text("질문")
                    .font(.title2)
                
                selectedImageWithCloseButton()
                
                photosPicker()
                
                textEditorWithPlaceholder()
                
                saveButton()
                
                Spacer()
            }
            .padding()
            .onChange(of: selectedItem) { oldItem, newItem in
                if let newItem {
                    Task {
                        if let data = try? await newItem.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImage = uiImage
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func selectedImageWithCloseButton() -> some View {
        if let image = selectedImage {
            ZStack(alignment: .topTrailing) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                
                Button {
                    selectedItem = nil
                    selectedImage = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                }
            }
        }
    }
    
    @ViewBuilder
    private func textEditorWithPlaceholder() -> some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .background(Color.clear)
            
            if text.isEmpty {
                Text("Type here...")
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                    .padding(.leading, 5)
            }
        }
        .frame(height: 150)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
    }
    
    @ViewBuilder
    private func closeButton() -> some View {
        Button(action: {
            store.send(.closeButtonTapped)
        }) {
            Image(systemName: "xmark")
                .foregroundColor(.black)
                .padding(12)
                .background(Color.gray.opacity(0.2))
                .clipShape(Circle())
        }
    }
    
    @ViewBuilder
    private func photosPicker() -> some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            Text(selectedImage == nil ? "사진 선택" : "사진 다시 선택")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }

    }
    
    @ViewBuilder
    private func saveButton() -> some View {
        Button(action: {
            store.send(.saveButtonTapped(text))
        }) {
            Text("save")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        
    }
}

#Preview {
    AddMemoryView(
        store: .init(
            initialState: AddMemoryFeatures.State.init(selectedDate: .now),
            reducer: {
                AddMemoryFeatures()
            }
        )
    )
}
