public final class VandMarvelCharacters {

    private init() {}

    public static let shared = VandMarvelCharacters()

    public var charactersMessages: VMCharactersMessages = VMCharactersMessagesDefault()

}

public protocol VMCharactersMessages {

    var alertTitle: String { get }
    var alertMessage: String { get }
    var confirmAction: String { get }
    var cancelAction: String { get }
    var tryAgainAction: String { get }

    var withoutInternetConnection: String { get }

    // MARK: List characters
    var listCharactersEmptyState: String { get }

}

public final class VMCharactersMessagesDefault: VMCharactersMessages {

    public var alertTitle: String { "Ops" }
    public var alertMessage: String { "Try again later" }
    public var tryAgainAction: String { "Try again" }
    public var confirmAction: String { "Confirm" }
    public var cancelAction: String { "Cancel" }

    public var withoutInternetConnection: String { "Without internet" }

    public var listCharactersEmptyState: String { "No characters to show" }

}
