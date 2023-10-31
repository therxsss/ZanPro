import SwiftUI

struct ProfileUserInfoView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            Text(viewModel.fullname)
                .font(.montserrat(size: 20))
                .foregroundColor(.zpDark)
                .padding(.bottom, 24)
            
            LawProfileRow(title: "Контактный номер", value: viewModel.person.mobile.phoneFormat())
            if let email = viewModel.person.email, !email.isEmpty {
                LawProfileRow(title: "Контактная почта", value: email)
            }
            ForEach(viewModel.person.pendingEmails, id: \.self) { Text($0)}
            Divider()
            if let town = viewModel.locationBy(viewModel.person.locationRefKeyId ?? 0) {
                LawProfileRow(title: "Населенный пункт", value: town.valueRu)
            }
            if let about = viewModel.person.about, !about.isEmpty {
                Divider()
                LawProfileRow(title: "Информация о себе", value: about)
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
    }
}

struct ProfileUserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileUserInfoView()
            .environmentObject(ProfileViewModel())
    }
}
