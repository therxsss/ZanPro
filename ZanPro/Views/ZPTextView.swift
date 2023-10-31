import SwiftUI

struct ZPTextView: View {
    @Binding var zpField: ZPTextField
    @Binding var focusedField: ZPTextFieldType?
    var body: some View {
        VStack {
            ZPUITextView(fieldKind: .about, placeholder: "", text: $zpField.text, focusedField: $focusedField)
        }
        .background(Text(zpField.title)
            .font(.openSans(size: zpField.text.isEmpty && (.about != focusedField) ? 14 : 8))
            .offset(y: zpField.text.isEmpty && (.about != focusedField) ? 0 : -8), alignment: .topLeading)
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.zpGreyBG))
        .overlay(RoundedRectangle(cornerRadius: 12)
            .stroke(.about == focusedField ? .blue : .zpGreyElements))
    }
}

struct ZPTextView_Previews: PreviewProvider {
    
    static var previews: some View {
        ZPTextView(zpField: .constant(ZPTextField(keyboardType: .default, title: "Title", image: nil)), focusedField: .constant(.about))
            .padding()
    }
}
