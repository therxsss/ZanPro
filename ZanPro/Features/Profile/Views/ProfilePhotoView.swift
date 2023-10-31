//
//  ProfilePhotoView.swift
//  ZanPro
//
//  Created by Vladimir on 06.06.2023.
//

import SwiftUI

struct ProfilePhotoView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    var body: some View {
        VStack {
            if let uiImage = viewModel.uiImage {
                Image(uiImage: uiImage).resizable()
            } else {
                Image("Avatar").resizable()
            }
        }
        .aspectRatio(contentMode: .fill)
        .frame(width: UIScreen.main.bounds.width - 30, height: 304)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .contentShape(Rectangle())
    }
}

struct ProfilePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePhotoView()
            .environmentObject(ProfileViewModel())
    }
}
