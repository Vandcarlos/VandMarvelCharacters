// Created on 22/01/21. 

import Foundation

open class VMCharacter {

    public init(id: Int, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
    }

    public let id: Int
    public let name: String
    public let description: String

    public var image: UIImage?

    public var isFavorited: Bool {
        get { VMCharactersLocalRepository.find(byId: id) != nil }
        set {
            if newValue {
                VMCharactersLocalRepository.save(character: self)
            } else {
                VMCharactersLocalRepository.delete(character: self)
            }
        }
    }

}
