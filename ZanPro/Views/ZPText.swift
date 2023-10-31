import SwiftUI

struct ZPText: View {
    let title: String
    var image: String?
    let text: String
    var backgroundColor = Color.white
    var body: some View {
        HStack(spacing: 14) {
            if let image {
                Image(image)
            }
            Text(text.isEmpty ? title : text)
                .font(.openSans(size: 14))
                .foregroundColor(.zpDark)
                .frame(height: 24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(Text(text.isEmpty ? "" : title)
                    .font(.openSans(size: 8))
                    .foregroundColor(Color("ZPGrey"))
                    .offset(y: -12), alignment: .topLeading)
            Spacer()
        }
        .padding(.leading, 14)
        .frame(height: 64)
        .background(RoundedRectangle(cornerRadius: 12).fill(backgroundColor))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.zpGreyElements))
    }
}
