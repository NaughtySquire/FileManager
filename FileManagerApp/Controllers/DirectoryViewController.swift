import UIKit

class DirectoryViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: - properties
    let fileManagerService: FileManagerServiceProtocol
    let directoryURL: URL
    let userDefaults = UserDefaults.standard
    var contentURLs: [URL]!

    // MARK: - views

    private lazy var contentTable: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    // MARK: - init

    init(_ fileManagerService: FileManagerServiceProtocol, _ directoryURL: URL) {
        self.fileManagerService = fileManagerService
        self.directoryURL = directoryURL
        super.init(nibName: nil, bundle: nil)
        tabBarItem.image = UIImage(systemName: "doc")

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        view.addSubview(contentTable)
        setupNavigationBar()
        makeConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        fileManagerService.setCurrentDirectoryURL(directoryURL)
        updateContentURLs()

        navigationController?.navigationBar.isHidden = false
        contentTable.reloadData()
    }

    // MARK: - functions

    func updateContentURLs() {
        let result = fileManagerService.contentsOfDirectory()
        switch result {
        case .success(let urls):
            contentURLs = urls
            if userDefaults.bool(forKey: "sortByNormalOrder") {
                contentURLs.sort(by: <)
            } else {
                contentURLs.sort(by: >)
            }
        case .failure(let error):
            contentURLs = []
            print(error)
        }
    }

    func setupNavigationBar() {
        self.parent?.navigationItem.title = directoryURL.lastPathComponent
        let addFolder = UIBarButtonItem(image:
                                            UIImage(systemName: "folder.badge.plus"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(addFolderTapped))
        let addFile = UIBarButtonItem(barButtonSystemItem: .add,
                                      target: self,
                                      action: #selector(addFileTapped))
        let removeAll = UIBarButtonItem(image: UIImage(systemName: "trash"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(removeContent))
        self.parent?.navigationItem.rightBarButtonItems = [addFolder, addFile, removeAll]
    }

    @objc
    func addFolderTapped() {
        let alert = UIAlertController(title: "Create new folder",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Folder name"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Create", style: .default) {[weak self] _ in
            guard let self = self,
                  let directoryName = alert.textFields![0].text,
                  !directoryName.isEmpty else {
                return
            }
            self.fileManagerService.createDirectory(with: directoryName)
            self.updateContentURLs()
            self.contentTable.reloadData()
        })
        present(alert, animated: true)
    }

    @objc
    func addFileTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }

    @objc
    func removeContent() {
        fileManagerService.removeContent()
        updateContentURLs()
        contentTable.reloadData()
    }

    // MARK: - constraints

    func makeConstraints() {
        contentTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentTable.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentTable.topAnchor.constraint(equalTo: view.topAnchor),
            contentTable.rightAnchor.constraint(equalTo: view.rightAnchor),
            contentTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}
// MARK: - extensions

extension DirectoryViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                                 info: [UIImagePickerController.InfoKey: Any]) {
        guard let url = info[.imageURL] as? URL else { return }
        fileManagerService.createFile(url: url)
        updateContentURLs()
        contentTable.reloadData()
        dismiss(animated: true)
    }
}

extension DirectoryViewController: UITableViewDelegate {

}
extension DirectoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contentURLs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var cellContent = UIListContentConfiguration.cell()
        let dirContentURL = contentURLs[indexPath.row]
        if dirContentURL.hasDirectoryPath {
            cell.accessoryType = .disclosureIndicator
        } else {
            if userDefaults.bool(forKey: "showPhotoSize") {
                if let imageData = try? Data(contentsOf: dirContentURL) {
                    cellContent.secondaryText = String(imageData.count) + " bytes"
                    cellContent.image = UIImage(data: imageData)
                }
            }
            cell.accessoryType = .none
        }

        cellContent.text = dirContentURL.lastPathComponent

        cell.contentConfiguration = cellContent
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        if contentURLs[indexPath.row].hasDirectoryPath {
            let newDirectoryUrl = contentURLs[indexPath.row]
            let newDirectoryVC = DirectoryViewController(fileManagerService,
                                                         newDirectoryUrl)
            navigationController?.pushViewController(newDirectoryVC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
                     indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, _) in
            guard let self = self else { return }
            self.fileManagerService.removeItem(url: self.contentURLs[indexPath.row])
            self.updateContentURLs()
            self.contentTable.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }

}
