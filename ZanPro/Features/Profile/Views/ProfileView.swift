import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    var body: some View {
        VStack {
            ProfileMenuBar()
            content
            Spacer(minLength: 0)
        }
    }
    
    var content: some View {
        ScrollView(.vertical) {
            VStack(spacing: 24.0) {
                ProfileHeaderView()
                if viewModel.editMode {
                    EditPhotoView()
                    EditUserInfoView()
                    ForEach($viewModel.legals, id: \.keyId) { $legal in
                        EditSpecializationView(legal: $legal)
                    }
                    if viewModel.canAddSpecialization {
                       addSecialization
                    }
                    saveButton
                } else {
                    ProfilePhotoView()
                    ProfileUserInfoView()
                }
            }
            .padding(15)
        }
    }
    
    var addSecialization: some View {
        Button(action: {
            viewModel.legals.append(Legal(id: nil, license: "", specializationRefKeyId: nil, careerStartDate: "", activityAreasWithOffers: []))
        }) {
            Label("Добавить специализацию", systemImage: "plus.circle")
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 72)
                .padding(.horizontal, 13)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
        }
    }
        
    var saveButton: some View {
        Button(action: {
            viewModel.save()
        }) {
            Text("Отправить на модерацию")
                .font(.montserrat(size: 14))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.zpBlue))
        }
    }
}
