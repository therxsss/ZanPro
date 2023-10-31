import SwiftUI

struct EditSpecializationView: View {
    @Binding var legal: Legal
    var index: Int {
        viewModel.legals.firstIndex(where: { $0.specializationRefKeyId == legal.specializationRefKeyId}) ?? 0
    }
    @EnvironmentObject var viewModel: ProfileViewModel
    var header: some View {
        Group {
            if index == 0 {
                Text("Профессиональная информация")
                    .font(.montserrat(size: 20))
                    .foregroundColor(.zpDark)
            } else {
                Button {
                    viewModel.removeSpecialization(at: index)
                } label: {
                    Label("Убрать специализацию", systemImage: "trash")
                }
            }
        }
    }
    var specialization: some View {
        Menu {
            ForEach(viewModel.specializationMenu) { specialization in
                Button(action: {
                    viewModel.addSpecialization(at: index, id: specialization.refKeyId)
                }) {
                    Text(specialization.valueRu)
                }
            }
        } label: {
            ZPText(title: "Специальность*",
                   image: nil, text: viewModel.specializationTitle(legal),
                   backgroundColor: Color("ZPGreyBG"))
        }
    }
    
    var addArea: some View {
        VStack {
            let areas = viewModel.specializationAreas(legal)
            if !areas.isEmpty {
                Menu {
                    ForEach(viewModel.specializationAreas(legal), id: \.targetKeyId) { child in
                        Button(action: {
                            viewModel.addArea(at: index, id: child.targetKeyId)
                        }) {
                            Text(child.shortValueRu)
                        }
                    }
                    
                } label: {
                    ZPText(title: "Специальность / сфера",
                           image: nil, text: "",
                           backgroundColor: Color("ZPGreyBG"))
                }
            }
        }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            header
            specialization
            if legal.specializationRefKeyId != nil {
                ZPSimpleField(placeholder: "№ лицензии*", image: nil, text: $viewModel.legals[index].license)
                ZPDataPicker(legal: $legal)
                
                ForEach($legal.activityAreasWithOffers) { $activity in
                    ActivityView(activity: $activity, index: index)
                }
            }
            addArea
        }
        .padding(13)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
    }
}

struct ActivityView: View {
    @Binding var activity: Offers
    let index: Int
    @EnvironmentObject var viewModel: ProfileViewModel
    @State private var show = true
    var body: some View {
        VStack(alignment: .leading) {
            AreaTitleView(title: viewModel.areaTitle(activity.activityAreaId)) {
                viewModel.removeArea(at: index, id: activity.activityAreaId)
            }
            Text("Прикреплённые услуги:")
            if activity.offerRefKeyIds.isEmpty {
                Text("Выберите хотябы одну услугу")
                    .foregroundColor(.zpRed)
            } else {
                Text("(\(activity.offerRefKeyIds.count)) \(show ? "Cкрыть" : "Показать") список")
                    .onTapGesture {
                        show.toggle()
                    }
            }
            if show || activity.offerRefKeyIds.isEmpty {
                ForEach(viewModel.areaOffers(activity.activityAreaId), id: \.targetKeyId) { child in
                    let outsider = outside(child.targetKeyId)
                    HStack {
                        Image(outsider ? "box18" : "checkbox18")
                        Text(child.shortValueRu)
                        Spacer()
                    }
                    .onTapGesture {
                        if outsider {
                            activity.offerRefKeyIds.append(child.targetKeyId)
                        } else if let index = activity.offerRefKeyIds.firstIndex(of: child.targetKeyId) {
                            activity.offerRefKeyIds.remove(at: index)
                        }
                    }
                }
            }
        }
    }
    func outside(_ id: Int) -> Bool {
        activity.offerRefKeyIds.firstIndex(of: id) == nil
    }
}
