import SwiftUI

struct ProfileMenuBar: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    var body: some View {
        HStack(spacing: 8.0) {
            Image("logo")
            Spacer()
            HStack(spacing: 8.0) {
                Text("Профиль")
                    .font(.montserrat(size: 12))
                    .foregroundColor(Color("ZPBlue"))
                VStack {
                    if let image = viewModel.uiImage {
                        Image(uiImage: image)
                            .resizable()
                    } else {
                        Image("Avatar")
                            .resizable()
                    }
                }
                .scaledToFill()
                .frame(width: 28, height: 28)
                .cornerRadius(8)
                
            }
            .padding(2)
            .padding(.leading, 6)
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
            .shadow(color: .gray.opacity(0.5), radius: 4, x: 0, y: 4)
            Image("lines3")
                .frame(width: 32, height: 32)
                .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                .shadow(color: .gray.opacity(0.5), radius: 2, x: 0, y: 2)
        }
        .padding(.horizontal)
    }
}

struct ProfileMenuBar_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMenuBar()
            .environmentObject(ProfileViewModel())
    }
}
