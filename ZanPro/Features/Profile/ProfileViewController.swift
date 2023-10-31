import SwiftUI
import Photos
import PhotosUI

enum ProfileSteps {
    case fetchPerson
    case fetchLocations
    case savePerson(Person)
    case fetchAvatar(String)
    case saveAvatar(UIImage)
    case deleteAvatar
    case updateRegMail(String)
}

final class ProfileViewController: BaseViewController {
    private let viewModel = ProfileViewModel()
    private let store = ProfileStore()
    
    private lazy var rootView: BridgedView = {
        ProfileView()
            .environmentObject(viewModel)
            .bridge()
    }()
    
    private func setupObservers() {
        store
            .events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .recieve(let person):
                    self.viewModel.configure(with: person)
                    if let image = person.photoFileId {
                        self.fetchAvatar(image)
                    }
                case .logout(let step):
                    self.login(step)
                    print("LOGIN")
                case .avatar(let image):
                    self.viewModel.configure(with: image)
                case .recieveLocations(let locations):
                    self.viewModel.configure(with: locations)
                case .success(let message):
                    print("DEBUG: ", message)
                case .error(let message):
                    print("DEBUG: ", message)                    
                case .recieveSpecializations(let specializations):
                    self.viewModel.configureSpecializations(specializations)
                case .recieveActivityAreas(let areas):
                    self.viewModel.configureAreas(areas)
                case .recieveOffers(let offers):
                    self.viewModel.configureOffers(offers)
                case .recieveModerationStatus(_):
                    print("recieveModerationStatus")
                case .recieveContactTypes(_):
                    print("recieveContactTypes")
                case .recieveLegal(let legals):
                    self.viewModel.configure(with: legals)
                }
            }
            .store(in: &bag)
    }
    
    func login(_ step: ProfileSteps) {
//        print("DEBUG: token = ", RESTClient.shared.accessToken)
        let page = LoginPage()
        page.modalPresentationStyle = .fullScreen
        page.finish = { [weak self] in
            self?.afterLogin(step)
        }
        present(page, animated: true)
    }
    
    func afterLogin(_ step: ProfileSteps) {
        switch step {
        case .fetchPerson: fetchPerson()
        case .fetchAvatar(let image): fetchAvatar(image)
        case .updateRegMail(let email): updateRegEmail(email)
        case .savePerson(let person): savePerson(person)
        case .saveAvatar(let image): saveAvatar(image)
        case .deleteAvatar: deleteAvatar()
        case .fetchLocations: fetchLocations()
        }
    }
    
    func fetchPerson() {
        store.actions.send(.fetchPerson)
    }
    
    func fetchAvatar(_ image: String) {
        store.actions.send(.fetchAvatar(image))
    }
    func deleteAvatar() {
        store.actions.send(.deleteAvatar)
    }
    
    func saveAvatar(_ image: UIImage) {
        store.actions.send(.saveAvatar(image))
    }
    
    func savePerson(_ person: Person) {
        store.actions.send(.savePerson(person))
    }
    
    func updateRegEmail(_ email: String) {
        store.actions.send(.updateRegMail(email))
    }
    
    func updateRegMobile(_ mobile: String) {
        store.actions.send(.mobileOTPSending(mobile))
    }
    
    func fetchLocations() {
        store.actions.send(.fetch)
    }
    
    func saveLegals(_ legals: [Legal]) {
        if legals.isEmpty == false {
            store.actions.send(.saveLegals(legals))
        }
    }
    
    func deleteLegal(_ id: Int) {
        store.actions.send(.deleteLegal(id))
    }
}

extension ProfileViewController {
    override func setupViews() {
        super.setupViews()
        addBridgedViewAsRoot(rootView)
        setupObservers()
        fetchPerson()
        fetchLocations()
        viewModel.presentPhotoPicker = presentPhotoPicker
        viewModel.deleteAvatar = deleteAvatar
        viewModel.saveAvatar = saveAvatar
        viewModel.savePerson = savePerson
        viewModel.saveLegals = saveLegals
        viewModel.updateRegEmail = updateRegEmail
        viewModel.updateRegMobile = updateRegMobile
        viewModel.deleteLegal = deleteLegal
    }
}

extension ProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first else { return }
        result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
            guard let image = reading as? UIImage, error == nil else { return }
            DispatchQueue.main.async {
                self.viewModel.addAvatar(image)
            }
        }
    }
    
    func presentPhotoPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}
