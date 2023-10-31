import SwiftUI

struct EditEmailSectionView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    var body: some View {
        VStack(alignment: .leading) {
            
            ZPTextFieldView(
                zpField: $viewModel.mailField,
                focusedField: $viewModel.focusedField,
                checkErrors: false,
                kind: .mail)
            
            Text("На эту почту будет выслана ссылка для подтверждения ")
                .font(.openSans(size: 12))
                .foregroundColor(Color("ZPGrey"))
            if viewModel.person.email != nil {
                Button(action: viewModel.updateRegMail) {
                    Text("Изменить почту")
                        .font(.openSans(size: 14))
                        .foregroundColor(.zpBlue)
                }
            }
            
            ZPTextFieldView(
                zpField: $viewModel.contactMailField,
                focusedField: $viewModel.focusedField,
                checkErrors: false,
                kind: .contactMail)
            
            Text("Без указания контактной электронной почты будет использована основная электронная почта для связи с вами.")
                .font(.openSans(size: 12))
                .foregroundColor(Color("ZPGrey"))
        }
    }
}

struct EditEmailSectionView_Previews: PreviewProvider {
    static var previews: some View {
        EditEmailSectionView()
            .environmentObject(ProfileViewModel())
    }
}
