//import SwiftUI
//
//struct LawerRegistrationView: View {
//    @State private var text = ""
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 24.0) {
//                let roundRect = RoundedRectangle(cornerRadius: 12)
//                HStack {
//                    Image("person")
//                    Text("Регистрация специалиста")
//                        .font(.openSans(size: 14))
//                    Spacer()
//                    Image(systemName: "chevron.down")
//                }
//                .padding(.horizontal, 12)
//                .frame(height: 64)
//                .background(roundRect.fill(Color.white))
//                .overlay(roundRect.stroke(Color.blue))
//                
//                Image("lawer")
//                    .resizable()
//                    .scaledToFill()
//                    .frame(height: 304)
//                    .clipShape(roundRect)
//                
//                VStack(alignment: .leading, spacing: 24) {
//                    Text("Личная информация")
//                        .font(.montserrat(size: 20))
//                        .foregroundColor(Color("ZPDark"))
//                    
//                    ZPTextField(title: "Имя и Отчество*", text: $text)
//                    
//                    ZPTextField(title: "Населенный пункт*", text: $text)
//                    
//                    phones
//                    
//                    emails
//                    
//                    ZPTextField(title: "Расскажите о себе", text: $text)
//                    
//                }
//                .padding(12)
//                .background(roundRect.fill(Color.white))
//                
//                VStack(alignment: .leading, spacing: 24) {
//                    Text("Профессиональная информация")
//                        .font(.montserrat(size: 20))
//                        .foregroundColor(Color("ZPDark"))
//                    
//                    ZPTextField(title: "Специализация*", text: .constant("Нотариус"))
//                    
//                    
//                    
//                    ZPTextField(title: "№ лицензии*", text: .constant("123456789"))
//                    
//                    ZPTextField(title: "Дата начала карьеры*", text: .constant("01.11.2022"))
//                    
//                    ZPTextField(title: "Специальность / сфера*", text: .constant("Работа с физическими и юридическими лицами (иные виды услуг, не вошедшие в предыдущие категории)"))
//                    
//                    services
//                    
//                }
//                .padding(12)
//                .background(roundRect.fill(Color.white))
//                
//                VStack(alignment: .leading) {
//                    HStack {
//                        Image("circle_plus")
//                        Text("Добавить специализацию")
//                        Spacer()
//                    }
//                }
//                .padding(12)
//                .frame(height: 72)
//                .background(roundRect.fill(Color.white))
//                
//                Text("Отправить на модерацию")
//                    .font(.montserrat(size: 14))
//                    .frame(height: 56)
//                    .frame(maxWidth: .infinity)
//                    .foregroundColor(.white)
//                    .background(Color("ZPBlue"))
//                    .cornerRadius(12)
//            }
//            .padding(.horizontal, 12)
//            .background(Color("ZPGreyBG").ignoresSafeArea())
//        }
//    }
//    
//    var phones: some View {
//        VStack(alignment: .leading) {
//            ZPText(title: "Номер телефона", image: "phone", text: "+7 (777)-123-45-67")
//            
//            ZPTextField(title: "+7 (777)-123-45-67", image: "phone", text: $text)
//            
//            Text("Текст оповещения об разницы между номером телефона и контактным номером")
//                .font(.openSans(size: 12))
//                .foregroundColor(Color("ZPGrey"))
//        }
//    }
//    
//    var emails: some View {
//        VStack(alignment: .leading) {
//            ZPTextField(title: "Электронная почта*", image: "mail", text: $text)
//            
//            Text("На эту почту будет выслана ссылка для подтверждения")
//                .font(.openSans(size: 12))
//                .foregroundColor(Color("ZPGrey"))
//            
//            ZPTextField(title: "mail@mail.ru", image: "mail", text: $text)
//
//            Text("Без указания контактной электронной почты будет использована основная электронная почта для связи с вами.")
//                .font(.openSans(size: 12))
//                .foregroundColor(Color("ZPGrey"))
//        }
//    }
//    
//    var services: some View {
//        VStack {
//            ForEach(0..<10) { _ in
//                VStack {
//                    HStack {
//                        Image("checkbox")
//                        Text("Работа с физическими и юридическими лицами (иные виды услуг, не вошедшие в предыдущие категории)")
//                            .font(.openSans(size: 12))
//                    }
//                    Divider()
//                }
//            }
//        }
//    }
//}
//
//struct LawerRegistrationView_Previews: PreviewProvider {
//    static var previews: some View {
//        LawerRegistrationView()
//    }
//}
