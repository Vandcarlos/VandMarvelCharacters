import RealmSwift

public final class VandMarvelCharacters {

    private init() {
        VMRealmConfig.run()
    }

    public static let shared = VandMarvelCharacters()

    public var charactersMessages: VMCharactersMessages = VMCharactersMessagesDefault()

    var realmInstance: Realm {
        // swiftlint:disable:next force_try
        try! Realm()
    }

}
