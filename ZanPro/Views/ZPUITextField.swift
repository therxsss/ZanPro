import SwiftUI

struct ZPTextField {
    let keyboardType: UIKeyboardType
    let title: String
    let image: String?
    var text = ""
    var error = false
}

enum ZPTextFieldType {
    case lastname
    case firstname
    case phone
    case password
    case mail
    case contactMail
    case about
    case sms
    case license
}

struct ZPUITextField: UIViewRepresentable {
    let textFieldType: ZPTextFieldType
    let placeholder: String
    let keyboardType: UIKeyboardType
    @Binding var text: String
    @Binding var focusedField: ZPTextFieldType?
    @Binding var isSecureTextEntry: Bool
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.isSecureTextEntry = isSecureTextEntry
       
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textfield = UITextField(frame: .zero)
        textfield.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textfield.delegate = context.coordinator
        textfield.autocapitalizationType = .none
        textfield.placeholder = placeholder
        textfield.isSecureTextEntry = isSecureTextEntry
        textfield.keyboardType = keyboardType
        textfield.font = .openSans(size: 14)
        textfield.textColor = .zpDark
        
        return textfield
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}

struct ZPUITextField_Previews: PreviewProvider {
    static var previews: some View {
        ZPUITextField(
            textFieldType: .password,
            placeholder: "placeholder", keyboardType: .default,
            text: .constant(""),
            focusedField: .constant(.password),
            isSecureTextEntry: .constant(true))
            .padding()
    }
}

extension ZPUITextField {
    class Coordinator: NSObject, UITextFieldDelegate {
        let parent: ZPUITextField
        init(parent: ZPUITextField) {
            self.parent = parent
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.parent.text = textField.text ?? ""
            }
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            parent.focusedField = parent.textFieldType
        }
    }
    
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
