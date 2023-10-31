import SwiftUI

struct ZPDataPicker: View {
    @Binding var legal: Legal
   let title = "Дата начала карьеры*"
    @State var showsDatePicker = false
    let dateFormatter: DateFormatter = {
        $0.locale = Locale(identifier: "ru_RU")
        $0.dateStyle = .short
        return $0
    }(DateFormatter())
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 1920, month: 1, day: 1)
        let endComponents = DateComponents(year: 2023, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(legal.careerStartDate.isEmpty ? title : "\(dateFormatter.string(from: legal.startDate))")
                .font(.openSans(size: 14))
                .frame(height: 24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay(Text(legal.careerStartDate.isEmpty ? "" : title)
                    .font(.openSans(size: 8))
                    .foregroundColor(.gray)
                    .offset(y: -12), alignment: .topLeading)
                .padding(.leading, 14)
                .frame(height: 64)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.zpGreyBG))
                .overlay(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.zpGreyElements))
                .overlay(Image("calendar18").padding(.trailing), alignment: .trailing)
                .onTapGesture(perform: showToggle)
            
            if showsDatePicker {
                VStack(alignment: .trailing) {
                    DatePicker("",
                               selection: $legal.startDate,
                               in: dateRange,
                               displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    Button(action: showToggle) {
                        Text("Выбрать")
                    }
                }

            }
        }
    }
    func showToggle() {
        showsDatePicker.toggle()
        legal.careerStartDate = Date.stringFromISODate(legal.startDate)
    }
}
