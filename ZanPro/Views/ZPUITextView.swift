import SwiftUI

struct ZPUITextView: UIViewRepresentable {
    let fieldKind: ZPTextFieldType
    let placeholder: String
    @Binding var text: String
    @Binding var focusedField: ZPTextFieldType?
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textview = UITextView(frame: .zero)
        textview.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textview.isScrollEnabled = false
        textview.textContainer.lineBreakMode = .byCharWrapping
        textview.delegate = context.coordinator
        textview.backgroundColor = .clear
        textview.font = .openSans(size: 14)
        textview.textColor = .zpDark
        textview.translatesAutoresizingMaskIntoConstraints = false
        textview.widthAnchor.constraint(equalToConstant: 300).isActive = true
        return textview
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}

extension ZPUITextView {
    class Coordinator: NSObject, UITextViewDelegate {
        let parent: ZPUITextView
        init(parent: ZPUITextView) {
            self.parent = parent
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.text = textView.text ?? ""
            }
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            parent.focusedField = parent.fieldKind
        }
    }
}
struct ZPUITextView_Previews: PreviewProvider {
    static var previews: some View {
        ZPUITextView(fieldKind: .about, placeholder: "О себе", text: .constant(""), focusedField: .constant(.about))
    }
}


// https://raw.githubusercontent.com/KennethTsang/GrowingTextView/master/Sources/GrowingTextView/GrowingTextView.swift
