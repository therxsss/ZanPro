import SwiftUI

struct LawerView: View {
    @ObservedObject var viewModel: MainViewModel
    var body: some View {
        ScrollView {
            VStack(spacing: 24.0) {
                let roundRect = RoundedRectangle(cornerRadius: 12)
                HStack {
                    Image("person")
                    Text("Личный кабинет")
                        .font(.openSans(size: 14))
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding(.horizontal, 12)
                .frame(height: 64)
                .background(roundRect.fill(Color.white))
                .overlay(roundRect.stroke(Color.blue))
                
                Image("lawer")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 304)
                    .clipShape(roundRect)
                
                VStack(alignment: .leading, spacing: 12.0) {
                    Text("\(viewModel.person.lastName ?? "") \(viewModel.person.firstName ?? "")")
                        .font(.montserrat(size: 20))
                        .foregroundColor(Color("ZPDark"))
                        .padding(.bottom, 24)
                    
                    LawProfileRow(title: "Контактный номер телефона", value: viewModel.person.mobile)
                    LawProfileRow(title: "Контактная почта", value: viewModel.person.email ?? "")
                    Divider()
                    LawProfileRow(title: "Населенный пункт", value: "г. Алматы")
                    Divider()
                    LawProfileRow(title: "Информация о себе", value: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five...")
                    
                }
                .padding(12)
                .background(roundRect.fill(Color.white))
                
                VStack(alignment: .leading) {
                    Text("Частный судебный эксперт")
                        .font(.montserrat(size: 20))
                        .foregroundColor(Color("ZPDark"))
                    
                    
                    LawProfileRowH(title: "Лицензия", value: "123456789")
                    LawProfileRowH(title: "Стаж работы", value: "3 года")
                    Divider()
                }
                .padding(12)
                .background(roundRect.fill(Color.white))
            }
            .padding(.horizontal, 12)
        }
    }
}

struct LawProfileRow: View {
    let title: String
    let value: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.openSans(size: 12))
                    .foregroundColor(Color("ZPGrey"))
                Text(value)
                    .font(.openSans(size: 14))
                    .foregroundColor(Color("ZPDark"))
            }
    }
}

struct LawProfileRowH: View {
    let title: String
    let value: String
    var body: some View {
        HStack {
            Text(title)
                .font(.openSans(size: 12))
                .foregroundColor(Color("ZPGrey"))
            Text(value)
                .font(.openSans(size: 14))
                .foregroundColor(Color("ZPDark"))
        }
    }
}

struct LawerView_Previews: PreviewProvider {
    static var previews: some View {
        LawerView(viewModel: MainViewModel())
            .frame(maxHeight: .infinity)
            .background(
                Color("ZPGreyBG").ignoresSafeArea()
            )
    }
}
