// Created on 22/01/21. 

import Foundation

open class VMCharacter {

    public init(id: Int, name: String, desc: String) {
        self.id = id
        self.name = name
        self.desc = desc
    }

    public let id: Int
    public let name: String
    public let desc: String

    public var image: UIImage?
    public var isFavorited: Bool = false

}
