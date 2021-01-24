// Created on 22/01/21. 

import VandMarvelAPI

final class VMCharactersRequest: VMRequest {

    init(limit: Int, offset: Int, nameStartsWith: String?) {
        self.limit = limit
        self.offset = offset
        self.nameStartsWith = nameStartsWith
    }

    var path: String { "/characters" }

    var header: [String : String] { [:] }

    var query: [String : String?] {
        var query = [
            "limit": "\(limit)",
            "offset": "\(offset)"
        ]

        if let nameStartsWith = nameStartsWith {
            query.merge(["nameStartsWith": nameStartsWith], uniquingKeysWith: { $1 })
        }

        return query
    }

    var httpMethod: VMHttpMethod { .get }

    private let limit: Int
    private let offset: Int
    private let nameStartsWith: String?

}
