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
    
    enum MemoryEmotion: String, CaseIterable, Identifiable {
        case remember
        case forget

        var id: String { self.rawValue }

        var description: String {
            switch self {
            case .remember: return "Keep it in my heart"
            case .forget: return "Let it fade away"
            }
        }
    }

    @State private var selectedEmotion: MemoryEmotion = .remember
    
    var store: StoreOf<AddMemoryFeatures>
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    
                    CloseButton {
                        store.send(.closeButtonTapped)
                    }
                }
                
                Text("Question")
                    .font(.title2)
                
                selectedImageWithCloseButton()
                
                textEditorWithPlaceholder()
                
                Picker("How would you like to keep this memory?", selection: $selectedEmotion) {
                    ForEach(MemoryEmotion.allCases) { emotion in
                        Text(emotion.description).tag(emotion)
                    }
                }
                .pickerStyle(.segmented)
                
                Spacer()
            }
        }
        .padding(.horizontal)
        .ignoresSafeArea(.keyboard)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            footerView()
                .padding()
                .cornerRadius(16)
        }
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
            
            saveButton
        }
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
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
                .background(.green)
                .clipShape(Circle())
                .shadow(radius: 4)
        }

    }
    
    private var saveButton: some View {
        Button {
            if let data = selectedImage?.jpegData(compressionQuality: 0.8) {
                store.send(
                    .saveButtonTapped(
                        text: text,
                        imageData: data,
                        isGoodMemory: selectedEmotion == .remember ? true : false
                    )
                )
            }
        } label: {
            Image(systemName: "checkmark")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(text.isEmpty ? .gray.opacity(0.5) : .green)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
        .disabled(text.isEmpty)
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
