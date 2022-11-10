import Foundation

protocol FileManagerServiceProtocol{
    func contentsOfDirectory() -> Result<[URL], Error>
    func createDirectory(with name: String)
    func createFile(url: URL)
    func removeContent()
    func setCurrentDirectoryURL(_ directoryURL: URL)
    func removeItem(url: URL)
}

class FileManagerService: FileManagerServiceProtocol{

    private let fileManager = FileManager.default
    private var currentDirectoryURL: URL!

    func contentsOfDirectory() -> Result<[URL], Error>{
        do {
            let urls = try fileManager.contentsOfDirectory(at: currentDirectoryURL,
                                                           includingPropertiesForKeys: nil)
            return .success(urls)
        }catch let error{
            return .failure(error)
        }
    }

    func createDirectory(with name: String) {
        let newDirectoryURL = currentDirectoryURL.appendingPathComponent(name,
                                                                         isDirectory: true)
        do {
            try fileManager.createDirectory(at: newDirectoryURL,
                                            withIntermediateDirectories: true)
        }catch let error{
            print(error.localizedDescription)
        }
    }

    func createFile(url file: URL) {
        let fileData = file.dataRepresentation
        let fileName = file.lastPathComponent
        let pathMoveTo = currentDirectoryURL.appendingPathComponent(fileName).path
        fileManager.createFile(atPath: pathMoveTo, contents: fileData)
    }

    func removeContent() {
        let result = contentsOfDirectory()
        switch result{
        case .success(let urls):
            for url in urls{
                try? fileManager.removeItem(at: url)
            }
        case .failure(let error):
            print(error)
        }
    }
    func removeItem(url: URL) {
        try? fileManager.removeItem(at: url)
    }



    func setCurrentDirectoryURL(_ directoryURL: URL) {
        self.currentDirectoryURL = directoryURL
    }


}
