import SwiftUI

struct AreaTitleView: View {
    let title: String?
    let action: VoidCallback
    let label = "Специальность / сфера"
    var body: some View {
        HStack {
            if let title {
                Button(action: action) {
                    Image("close18")
                }
                Text(title)
                    .lineLimit(1)
                    .overlay(Text(label)
                        .font(.openSans(size: 8))
                        .foregroundColor(.zpGrey)
                        .offset(y: -12), alignment: .topLeading)
            } else {
                Text(label)
            }
            Spacer()
            Image("angledown18")
        }
        .font(.openSans(size: 14))
        .foregroundColor(.zpDark)
        .padding(.horizontal, 14)
        .frame(height: 64)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.zpGreyBG))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.zpGreyElements))
    }
}
