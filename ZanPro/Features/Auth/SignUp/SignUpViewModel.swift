import Foundation

final class SignUpViewModel: ObservableObject {
    @Published var isInFocus = true
    @Published var focusedField: ZPTextFieldType? = nil { didSet {
        if (focusedField == .phone) && phoneField.text.isEmpty { phoneField.text = "+7 "}
//        if oldValue == .mail { checkErrors = !isValidEmail }
//        else
        if oldValue == .phone { checkErrors = !isValidPhone}
        else if oldValue == .password { checkErrors = !isValidPassword}
    }}
    var sendSMS: ((String) -> ())?
    var register: ((String, String, String, String?) -> ())?
    var close: VoidCallback?
    @Published var phoneField = ZPTextField(keyboardType: .phonePad,
                                        title: "Номер телефона*",
                                        image: "phone",
                                        text: "")
    @Published var passwordField = ZPTextField(keyboardType: .default,
                                           title: "Придумайте пароль*",
                                           image: "lock")
    @Published var emailField = ZPTextField(keyboardType: .emailAddress,
                                        title: "Электронная почта",
                                        image: "mail")
    @Published var sms = ""
    @Published var showSMSField = false
    @Published var showAlert = false { didSet { if !showAlert {
        alertMessage = ""
    }}}
    @Published var alertMessage = ""
    @Published var count = 0 // sms
    @Published var showRed = false
    var timer: Timer?
    @Published var seconds = 60
    @Published var checkErrors = false
    
    var alertText: String {
        alertMessage.isEmpty ? "Повторный SMS код, на этот номер телефона может быть выслан через \(seconds)" : alertMessage
    }
    var moreInfo: Bool {
        isValidPassword && isValidPhone && isValidEmail
    }

    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: emailField.text) || emailField.text.isEmpty
    }
    
    var isValidPhone: Bool {
        onlyDigit(phoneField.text).count == 11
    }

    var isValidPassword: Bool {
        NSPredicate(format: "SELF MATCHES %@",  "^(?=.*[a-zа-яё])(?=.*[A-ZА-ЯЁ])(?=.*\\d)(?=.*[\\[\\]*#$%^,()\"'+.:|?@/{}_`!;\\-~<>№]).{6,25}$").evaluate(with: passwordField.text)
    }
    
    var isSmallLetter: Bool {
        NSPredicate(format: "SELF MATCHES %@",  "^(?=.*[a-zа-я]).{1,}$").evaluate(with: passwordField.text)
    }
    
    var isCapitalLetter: Bool {
        NSPredicate(format: "SELF MATCHES %@",  "^(?=.*[A-ZА-Я]).{1,}$").evaluate(with: passwordField.text)
    }
    
    var isDigit: Bool {
        NSPredicate(format: "SELF MATCHES %@",  "^(?=.*\\d).{1,}$").evaluate(with: passwordField.text)
    }
    
    var isSymbol: Bool {
        NSPredicate(format: "SELF MATCHES %@",  "^(?=.*[\\[\\]*#$%^,()\"'+.:|?@/{}_`!;\\-~<>№]).{1,}$").evaluate(with: passwordField.text)
    }
    
    var passwordMessage: String {
        if passwordField.text.isEmpty { return "Обязательное поле"}
        if !isSmallLetter { return "Введите хотя бы одну строчную букву"}
        if !isCapitalLetter { return "Введите хотя бы одну заглавную букву"}
        if !isDigit { return "Введите хотя бы одну цифру"}
        if !isSymbol { return "Введите хотя бы один спец символ"}
        if passwordField.text.count < 6 { return "Минимальное количество символов 6"}
        if passwordField.text.count > 25 { return "Максимальное количество символов 25"}
        return ""
    }
    
    var phoneMessage: String {
        onlyDigit(phoneField.text).count == 11 ? "" : "Некорректный номер телефона"
    }
    
    var mailMassage: String {
        isValidEmail ? "" : "Некорректный Email"
    }
    
    func sendSMSHandler() {
        focusedField = nil
        guard moreInfo else {
            checkErrors = true
            return
        }
        if showSMSField {
            stopTimer()
            register?(onlyDigit(phoneField.text), passwordField.text, sms, emailField.text.isEmpty ? nil : emailField.text)
        } else {
            if seconds < 60 {
                showAlert = true
            } else {
                startTimer()
                sendSMS?(onlyDigit(phoneField.text))

            }
        }
    }
    
    var titleButton: String {
        sms.count == 4 ? "Зарегистрироваться" : "Получить SMS код"
    }
    
    func format(_ value: String) {
        if seconds < 60 { stopTimer() }
        let mask = "+X (XXX) XXX-XX-XX"
        let numbers = (value.count == 1 ? "7" : "") + onlyDigit(value)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        phoneField.text = result
    }
    
    func onlyDigit(_ phone: String) -> String {
        phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
    }
    
    func startTimer() {
        count += 1
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            if self.seconds > 0 {
                self.seconds -= 1
            }
            else {
                self.stopTimer()
            }
        })
    }
    
    func stopTimer() {
        timer?.invalidate()
        seconds = 60
        showAlert = false
    }
}
