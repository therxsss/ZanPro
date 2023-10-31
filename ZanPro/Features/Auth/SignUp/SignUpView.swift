import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: SignUpViewModel
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                VStack {
                    VStack(alignment: .leading, spacing: 24) {
                        title

                        VStack(alignment: .leading, spacing: 8) {
                            ZPTextFieldView(zpField: $viewModel.phoneField,
                                        focusedField: $viewModel.focusedField,
                                        message: viewModel.phoneMessage,
                                        checkErrors: viewModel.checkErrors,
                                        kind: .phone)
                            .onChange(of: viewModel.phoneField.text) { viewModel.format($0) }
                            .padding(.bottom, 4)
                            
                            ZPTextFieldView(zpField: $viewModel.passwordField,
                                        focusedField: $viewModel.focusedField,
                                        isSecure: true,
                                        message: viewModel.passwordMessage,
                                        checkErrors: viewModel.checkErrors,
                                        kind: .password)
                            
                            Text("Не менее 6 знаков, включать минимум одну заглавную и одну строчную буквы, цифры и специальные символы")
                                .font(.openSans(size: 12))
                                .foregroundColor(Color("ZPGrey"))
                                .multilineTextAlignment(.leading)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ZPTextFieldView(zpField: $viewModel.emailField,
                                        focusedField: $viewModel.focusedField,
                                        message: viewModel.mailMassage,
                                        checkErrors: viewModel.checkErrors,
                                        kind: .mail)
                            Text("Вам необходимо указать свой адрес электронной почты для использования в качестве альтернативного способа входа и для восстановления пароля")
                                .font(.openSans(size: 12))
                                .foregroundColor(Color("ZPGrey"))
                        }
                        
                        HStack {
                            Text("Используя сервис ZanPro и продолжая регистрацию вы даете согласие на сбор и обработку Ваших данных и соглашаетесь с условиями ") + Text("пользовательского соглашения").foregroundColor(Color("ZPBlue"))
                        }
                        .font(.openSans(size: 14))
                        
                        if viewModel.showSMSField {
                            TextField("Введите код SMS", text: $viewModel.sms)
                                .padding(.leading, 14)
                                .zpInput()
                        } else {
                            VStack {}.frame(height: 64)
                        }
                        
                        Spacer(minLength: 0)
                        Button(action: {
                            hideKeyboard()
                            viewModel.sendSMSHandler()
                        }) {
                            Text(viewModel.titleButton)
                                .font(.montserrat(size: 14, weight: .medium))
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color("ZPBlue")))
                            .padding(.bottom, 12)
                            .foregroundColor(Color("ZPDark"))
                        }
                    }
                    .padding(.horizontal, 13)

                }
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                .overlay(alert, alignment: .top)
                .padding(.horizontal)
                
                Spacer()
            }
            .background(Color("ZPGreyBG").ignoresSafeArea())
            .onTapGesture {
                hideKeyboard()
                if viewModel.showAlert {
                    viewModel.showAlert = false
                }
            }
        }
    }
    
    var alert: some View {
        HStack(alignment: .top, spacing: 20.0) {
            Image("info-circle").renderingMode(.template)
            Text(LocalizedStringKey(viewModel.alertText))
                .font(.openSans(size: 12))
            Image("close").renderingMode(.template)
                .onTapGesture {
                    viewModel.showAlert.toggle()
                }
        }
        
            .padding()
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.red))
            .offset(y: viewModel.showAlert ? 0 : -300)
    }
    
    var title: some View {
        HStack {
            Text("Регистрация")
                .font(.montserrat(size: 20))
            Spacer()
            Button(action: {
                viewModel.close?()
            }) {
                Image("close")
            }
        }
        .padding([.horizontal, .top], 24)
        .foregroundColor(Color("ZPDark"))
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: SignUpViewModel())
    }
}

struct ZPInput: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 64)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color("ZPGreyBG")))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color("ZPGreyElements")))
    }
}

extension View {
    func zpInput() -> some View {
        self.modifier(ZPInput())
    }
}
