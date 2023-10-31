import SwiftUI

struct ProfileHeaderView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    var body: some View {
        Menu {
            Button(action: {
                viewModel.editMode = false
            }) {
                Text("Личный кабинет")
            }
            Button(action: {
                viewModel.editMode = true
            }) {
                Text("Регистрация специалиста")
            }
        } label: {
            HStack {
                Image("profile18")
                Text(viewModel.titleField)
                    .font(.openSans(size: 14))
                Spacer()
                Image("angledown18")
            }
            .padding(.horizontal, 12)
            .frame(height: 64)
            .foregroundColor(.zpDark)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.zpBlue))
            .contentShape(Rectangle())
        }
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView()
            .environmentObject(ProfileViewModel())
    }
}
