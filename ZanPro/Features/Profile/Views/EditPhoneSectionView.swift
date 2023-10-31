import SwiftUI

struct EditPhoneSectionView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    var body: some View {
        VStack(alignment: .leading) {
            ZPText(title: "Номер телефона", image: "phone", text: viewModel.person.mobile.phoneFormat())
            Button(action: {
                viewModel.updateRegMobile?("77772501231")
            }) {
                Text("Изменить номер телефона")
                    .font(.openSans(size: 14))
                    .foregroundColor(.zpBlue)
            }
            ZPTextFieldView(
                zpField: $viewModel.phoneField,
                focusedField: $viewModel.focusedField,
                checkErrors: false,
                kind: .phone)
            .onChange(of: viewModel.phoneField.text) { viewModel.format($0) }
            
            Text("Текст оповещения об разницы между номером телефона и контактным номером")
                .font(.openSans(size: 12))
                .foregroundColor(Color("ZPGrey"))
        }
    }
}

struct EditPhoneSectionView_Previews: PreviewProvider {
    static var previews: some View {
        EditPhoneSectionView()
            .environmentObject(ProfileViewModel())
    }
}
