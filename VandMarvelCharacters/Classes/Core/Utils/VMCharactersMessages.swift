// Created on 23/01/21. 

public protocol VMCharactersMessages {

    var alertTitle: String { get }
    var alertMessage: String { get }
    var confirmAction: String { get }
    var cancelAction: String { get }
    var tryAgainAction: String { get }

    var withoutInternetConnection: String { get }

    // MARK: List characters
    var listCharactersEmptyState: String { get }
    var listCharactersTitle: String { get }

    // MARK: Favorite characters
    var favoriteCharactersEmptyState: String { get }
    var favoriteCharactersTitle: String { get }

    // MARK: Character details

    var characterDetailsTitle: String { get }

}

public class VMCharactersMessagesDefault: VMCharactersMessages {

    public var alertTitle: String { "Ops" }
    public var alertMessage: String { "Try again later" }
    public var tryAgainAction: String { "Try again" }
    public var confirmAction: String { "Confirm" }
    public var cancelAction: String { "Cancel" }

    public var withoutInternetConnection: String { "Without internet" }

    public var listCharactersEmptyState: String { "No characters to show" }
    public var listCharactersTitle: String { "Characters" }

    public var favoriteCharactersEmptyState: String { "No favorite characters to show" }
    public var favoriteCharactersTitle: String { "Favorites" }

    public var characterDetailsTitle: String { "Details" }

}
