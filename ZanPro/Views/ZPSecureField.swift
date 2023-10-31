import SwiftUI

struct ZPSecureField: View {
    var error: Bool = false
    let title: String
    let image: String
    @Binding var text: String
    @Binding var isSecure: Bool
    var body: some View {
        HStack(spacing: 14) {
            Image(image)
            SecureField("Придумайте пароль*", text: $text)
                .font(.openSans(size: 14))
                .frame(height: 24)
                .overlay(Text(text.isEmpty ? (error ? title : "") : (error ? title : "Придумайте пароль*"))
                    .font(.openSans(size: 8))
                    .foregroundColor(error ? .red : .gray)
                    .offset(y: -12), alignment: .topLeading)
            Spacer()
        }
        .padding(.leading, 14)
        .frame(height: 64)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color("ZPGreyBG")))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(error ? .red : Color("ZPGreyElements")))
        .overlay(
            Button(action: {
                isSecure.toggle()
            }, label: {
                Image(isSecure ? "closeEye" : "eye")
            }).padding(.trailing)
            , alignment: .trailing)
    }
}

struct ZPSecureField_Previews: PreviewProvider {
    static var previews: some View {
        ZPSecureField(error: true,
            title: "Придумайте пароль*",
                      image: "lock",
                      text: .constant(""),
                      isSecure: .constant(false))
        .padding()
    }
}
