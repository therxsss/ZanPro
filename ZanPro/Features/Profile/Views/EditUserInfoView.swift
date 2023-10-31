import SwiftUI

struct EditUserInfoView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Личная иформация")
                .font(.montserrat(size: 20))
                .foregroundColor(.zpDark)
            ZPTextFieldView(
                zpField: $viewModel.lastname,
                focusedField: $viewModel.focusedField,
                checkErrors: false,
                kind: .lastname)
            
            
            ZPTextFieldView(
                zpField: $viewModel.firstname,
                focusedField: $viewModel.focusedField,
                checkErrors: false,
                kind: .firstname)
            
            Menu {
                ForEach(viewModel.locations) { location in
                    Button(action: {
                        viewModel.town = location
                    }) {
                        Text(location.valueRu)
                    }
                }
            } label: {
                ZPText(title: "Населённый пункт*",
                       image: nil, text: viewModel.town?.valueRu ?? "",
                       backgroundColor: Color("ZPGreyBG"))
            }
            EditPhoneSectionView()
            
            EditEmailSectionView()

            Button(action: {}) {
                Label("Изменить пароль", image: "lock")
                    .font(.openSans(size: 14))
                    .foregroundColor(.zpBlue)
            }
            
            ZPTextView(zpField: $viewModel.aboutField, focusedField: $viewModel.focusedField)
        }
        .padding(13)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
    }
}

struct EditUserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EditUserInfoView()
            .environmentObject(ProfileViewModel())
    }
}
