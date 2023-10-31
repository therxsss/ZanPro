import SwiftUI

struct EditPhotoView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    var body: some View {
        VStack {
            if let uiImage = viewModel.showImage {
                Menu {
                    Button(action: {
                        viewModel.presentPhotoPicker?()
                    }) {
                        Label("Изменить фото", image: "camera-plus")
                    }
                    Button(action: {
                        viewModel.removeAvatar()
                    }) {
                        Label("Удалить фото", image: "trash-alt")
                    }
                } label: {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width - 30, height: 304)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .contentShape(Rectangle())
                }
            } else {
                VStack(spacing: 34.0) {
                    Image("capture")
                    Text("Прикрепить фотографию")
                        .font(.openSans(size: 14))
                        .foregroundColor(Color("ZPGrey"))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 304)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color("ZPGreyElements")))
                .onTapGesture {
                    viewModel.presentPhotoPicker?()
                }
            }
        }
    }
}

struct EditPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        EditPhotoView()
            .environmentObject(ProfileViewModel())
    }
}
