import SwiftUI

struct EditLawerView: View {
    @ObservedObject var viewModel: MainViewModel
    var body: some View {
        VStack {
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
            content
            Spacer()
        }
    }
    var content: some View {
        ScrollView(.vertical) {
            VStack {
                VStack(spacing: 24.0) {
                    header
                    if viewModel.editMode {
                        editPhoto
                        info
                        Button(action: {
                            viewModel.saveAvatar()
                        }) {
                            Text("Отправить на модерацию")
                                .font(.montserrat(size: 14))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color("ZPBlue")))
                        }
                    } else {
                        photo
                        
                        userInfo
                    }
                }
                .padding(.horizontal)
                .padding(.vertical)
            }
            .background(Color("ZPGreyBG").ignoresSafeArea())
            .onTapGesture { hideKeyboard()}
        }
    }
    
    var header: some View {
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
                Image("person")
                Text(viewModel.titleField)
                    .font(.openSans(size: 14))
                Spacer()
                Image(systemName: "chevron.down")
            }
            .padding(.horizontal, 12)
            .frame(height: 64)
            .foregroundColor(Color("ZPDark"))
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.blue))
        }
    }
    var photo: some View {
        VStack {
            if let uiImage = viewModel.uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 30, height: 304)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .contentShape(Rectangle())
            } else {
                Image("Avatar")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 30, height: 304)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .contentShape(Rectangle())
            }
        }
    }
    var editPhoto: some View {
        VStack {
            if let uiImage = viewModel.uiImage {
                Menu {
                    Button(action: {
                        viewModel.launchImagePicker?()
                    }) {
                        Label("Изменить фото", image: "camera-plus")
                    }
                    Button(action: {
                        viewModel.deleteAvatar()
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
                    viewModel.launchImagePicker?()
                }
            }
        }
    }
    
    var userInfo: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            Text(viewModel.fullname)
                .font(.montserrat(size: 20))
                .foregroundColor(Color("ZPDark"))
                .padding(.bottom, 24)
            
            LawProfileRow(title: "Контактный номер", value: viewModel.person.mobile.phoneFormat())
            if let email = viewModel.person.email, !email.isEmpty {
                LawProfileRow(title: "Контактная почта", value: email)
            }
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
    var info: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Личная иформация")
                .font(.montserrat(size: 20))
                .foregroundColor(Color("ZPDark"))
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
            
            phoneSection
            
            emailSection

            ZPTextFieldView(
                zpField: $viewModel.aboutField,
                focusedField: $viewModel.focusedField,
                checkErrors: false,
                kind: .about)
        }
        .padding(13)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
    }
    
    var phoneSection: some View {
        VStack {
            ZPText(title: "Номер телефона", image: "phone", text: viewModel.person.mobile.phoneFormat())
            
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
    
    var emailSection: some View {
        VStack {
            ZPTextFieldView(
                zpField: $viewModel.mailField,
                focusedField: $viewModel.focusedField,
                checkErrors: false,
                kind: .mail)
            
            Text("На эту почту будет выслана ссылка для подтверждения ")
                .font(.openSans(size: 12))
                .foregroundColor(Color("ZPGrey"))
            
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

struct EditLawerView_Previews: PreviewProvider {
    static var previews: some View {
        EditLawerView(viewModel: MainViewModel())
    }
}


/*
 Фото - GlobalStorage.BASE_URL+"api/zanpro-files/internal/v1/file/" + photoFileId + "/download"
 BASE_URL - https://zanpro-dev.alseco.kz/
 https://zanpro-dev.alseco.kz/api/zanpro-files/internal/v1/file/646de607c057d272bc0b1c4d/download
 */
