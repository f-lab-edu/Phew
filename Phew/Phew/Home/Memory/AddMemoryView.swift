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
        VStack {
            KeyboardAvoidingScrollView {
                VStack(alignment: .leading) {
                    HStack {
                        Spacer()
                        
                        closeButton()
                    }
                    
                    Text("Question")
                        .font(.title2)
                    
                    selectedImageWithCloseButton()
                    
                    textEditorWithPlaceholder()
                    
                    Spacer()
                }
                .padding(.bottom, 100)
            }
            
            footerView()
                .frame(maxWidth: .infinity)
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
    
    @ViewBuilder
    private func footerView() -> some View {
        HStack(spacing: 20) {
            photosPicker()
            
            Spacer()
            
            saveButton()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 0)
    }
    
    @ViewBuilder
    private func selectedImageWithCloseButton() -> some View {
        if let image = selectedImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .cornerRadius(12)
                .overlay(alignment: .topTrailing) {
                    Button {
                        selectedImage = nil
                        selectedItem = nil
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size: 10, weight: .bold))
                            .padding(8)
                            .background(Color.black)
                            .clipShape(Circle())
                    }
                }
                .transition(.opacity)
                .animation(.easeInOut, value: selectedImage)
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
            Image(systemName: "photo")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(Color.blue)
                .clipShape(Circle())
                .shadow(radius: 4)
        }

    }
    
    @ViewBuilder
    private func saveButton() -> some View {
        Button {
            store.send(.saveButtonTapped(text))
        } label: {
            Image(systemName: "checkmark")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(Color.blue)
                .clipShape(Circle())
                .shadow(radius: 4)
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
