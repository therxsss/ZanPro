import SwiftUI

struct ZPTextFieldView: View {
    @Binding var zpField: ZPTextField
    @Binding var focusedField: ZPTextFieldType?
    @State private var isSeureTextEntry: Bool
    var isSecure: Bool
    var message: String
    var checkErrors: Bool
    let kind: ZPTextFieldType
    init(zpField: Binding<ZPTextField>,
         focusedField: Binding<ZPTextFieldType?>,
         isSecure: Bool = false,
         message: String = "",
         checkErrors: Bool,
         kind: ZPTextFieldType) {
        self._zpField = zpField
        self._focusedField = focusedField
        self.message = message
        self.isSecure = isSecure
        self.isSeureTextEntry = isSecure
        self.checkErrors = checkErrors
        self.kind = kind
    }

    var body: some View {
        HStack(spacing: 14) {
            if let image = zpField.image {
                Image(image)
            }
            ZPUITextField(textFieldType: kind,
                          placeholder: kind == .phone ? "+7 (___) ___-__-__" : zpField.title,
                          keyboardType: zpField.keyboardType,
                          text: $zpField.text,
                          focusedField: $focusedField,
                          isSecureTextEntry: $isSeureTextEntry)
                .frame(height: 24)
                .overlay(Text(checkErrors ? message
                              : zpField.text.isEmpty ? "" : zpField.title)
                    .font(.openSans(size: 8))
                    .foregroundColor((checkErrors && !message.isEmpty) ? .red : .gray)
                    .offset(y: -12), alignment: .topLeading)
            Spacer()
        }
        .padding(.leading, 14)
        .frame(height: 64)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color("ZPGreyBG")))
        .overlay(RoundedRectangle(cornerRadius: 12)
            .stroke((checkErrors && !message.isEmpty) ? .red : (kind == focusedField ? .blue : Color("ZPGreyElements"))))
        .overlay(
            VStack {
                if isSecure {
                    Button(action: {
                        isSeureTextEntry.toggle()
                    }, label: {
                        Image(isSeureTextEntry ? "eye" : "closeEye")
                    }).padding(.trailing)
                }
            }
            , alignment: .trailing)
    }
}

struct ZPSimpleField: View {
    let placeholder: String
    let image: String?
    @Binding var text: String
    var body: some View {
        HStack(spacing: 14) {
            if let image {
                Image(image)
            }
            TextField(placeholder, text: $text)
                .frame(height: 24)
                .overlay(Text(text.isEmpty ? "" : placeholder)
                    .font(.openSans(size: 8))
                    .foregroundColor(.gray)
                    .offset(y: -12), alignment: .topLeading)
            Spacer()
        }
        .padding(.leading, 14)
        .frame(height: 64)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.zpGreyBG))
        .overlay(RoundedRectangle(cornerRadius: 12)
            .stroke(Color.zpGreyElements))

    }
}
