// Created on 23/01/21. 

import Foundation

public final class VMCharacterThumbnailManager {

    private static let thumbnailDir = "thumbnails"

    private static let thumbnailsPath: URL = {
        let path = URL.documentsPath.appendingPathComponent(thumbnailDir, isDirectory: true)

        try? FileManager.default.createDirectory(at: path, withIntermediateDirectories: true)

        return path
    }()

    private class func filePath(toName name: String) -> URL {
        thumbnailsPath.appendingPathComponent(name)
    }

    public class func save(image: UIImage, withName name: String) {
        guard let data = image.pngData() else { return }

        let path = filePath(toName: name)

        try? data.write(to: path)
    }

    public class func get(withName name: String) -> UIImage? {
        let path = filePath(toName: name)

        guard let data = try? Data(contentsOf: path) else { return nil }

        return UIImage(data: data)
    }

    public class func delete(withName name: String) {
        let path = filePath(toName: name)

        try? FileManager.default.removeItem(at: path)
    }

}

fileprivate extension URL {

    static var documentsPath: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

}
