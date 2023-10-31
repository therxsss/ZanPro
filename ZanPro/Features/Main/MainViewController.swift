import SwiftUI

final class MainViewController: BaseViewController {
    private let store = MainStore()
    private let viewModel = MainViewModel()
    private lazy var rootView: BridgedView = {
        EditLawerView(viewModel: viewModel).bridge()
    }()
    
    private func setupObservers() {
        store
            .events
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .recieve(let person):
                    DispatchQueue.main.async {
                        self.viewModel.configure(with: person)
                    }
                }
            }
            .store(in: &bag)
    }
}

extension MainViewController {
    override func setupViews() {
        super.setupViews()
        addBridgedViewAsRoot(rootView)
        setupObservers()
        store.actions.send(.fetchPerson)
        view.backgroundColor = UIColor(named: "ZPGreyBG")
        viewModel.launchImagePicker = runImagePicker
    }
}

//MARK: - edit profile
extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func runImagePicker() {
        let cameraAction = UIAlertAction(title: "Камера",
                  style: .default) { _ in
            self.launchImagePicer(sourseType: .camera)
        }
        let libraryAction = UIAlertAction(title: "Открыть галерею",
                                          style: .default) { _ in
            self.launchImagePicer(sourseType: .photoLibrary)
        }
        let destroyAction = UIAlertAction(title: "Удалить фотографию",
                  style: .destructive) { _ in
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                  style: .cancel) { _ in }
             
        let alert = UIAlertController(title: nil,
                    message: nil,
                    preferredStyle: .actionSheet)
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(destroyAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    private func launchImagePicer(sourseType: UIImagePickerController.SourceType) {
        let viewcontroller = UIImagePickerController()
        viewcontroller.sourceType = sourseType
        viewcontroller.delegate = self
        viewcontroller.allowsEditing = true
        present(viewcontroller, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            DispatchQueue.main.async {
                self.viewModel.uiImage = image //.resizeImage(2000.0)
            }
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
