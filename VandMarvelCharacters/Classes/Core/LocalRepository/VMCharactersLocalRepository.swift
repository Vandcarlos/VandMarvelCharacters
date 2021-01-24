// Created on 23/01/21.

import RealmSwift

public final class VMCharactersLocalRepository {

    class func save(character: VMCharacter) {
        let characterRealm = VMCharacterRealm(character: character)

        if let image = character.image {
            VMCharacterThumbnailManager.save(image: image, withName: character.imageName)
        }

        let realm = VandMarvelCharacters.shared.realmInstance

        try? realm.write {
            realm.add(characterRealm)
        }
    }

    class func find(byId id: Int) -> VMCharacter? {
        let realm = VandMarvelCharacters.shared.realmInstance

        guard let characterRealm = realm.objects(VMCharacterRealm.self).filter("id == \(id)").first else {
            return nil
        }

        let character = VMCharacter(characterRealm: characterRealm)

        character.image = VMCharacterThumbnailManager.get(withName: character.imageName)

        return character
    }

    class func getAll(filterByName name: String?, completion: @escaping ([VMCharacter]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            autoreleasepool {
                let realm = VandMarvelCharacters.shared.realmInstance

                var realmCharacters = realm.objects(VMCharacterRealm.self)

                if let name = name {
                    realmCharacters = realmCharacters.filter("name BEGINSWITH '\(name)'")
                }

                realmCharacters = realmCharacters.sorted(byKeyPath: "name")

                let characters: [VMCharacter] = realmCharacters.compactMap {
                    let character = VMCharacter(characterRealm: $0)

                    character.image = VMCharacterThumbnailManager.get(withName: character.imageName)

                    return character
                }

                completion(characters)
            }
        }
    }

    class func delete(character: VMCharacter) {
        let realm = VandMarvelCharacters.shared.realmInstance

        let characterRealm = realm
            .objects(VMCharacterRealm.self)
            .filter("id == \(character.id)")

        try? realm.write {
            realm.delete(characterRealm)
        }

        VMCharacterThumbnailManager.delete(withName: character.imageName)
    }

}

fileprivate extension VMCharacterRealm {

    convenience init(character: VMCharacter) {
        self.init()
        id = character.id
        name = character.name
        desc = character.description
    }

}

fileprivate extension VMCharacter {

    convenience init(characterRealm: VMCharacterRealm) {
        self.init(id: characterRealm.id, name: characterRealm.name, description: characterRealm.desc)
    }

    var imageName: String { "\(id)_\(name)" }

}
