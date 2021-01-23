// Created on 22/01/21. 

import VandMarvelAPI

public class VMCharactersRequest: VMRequest {

    init(limit: String, offset: String, nameStartsWith: String?) {
        self.limit = limit
        self.offset = offset
        self.nameStartsWith = nameStartsWith
    }

    public var path: String { "characters" }

    public var header: [String : String] { [:] }

    public var query: [String : String?] {
        var query = [
            "limit": limit,
            "offset": offset
        ]

        if let nameStartsWith = nameStartsWith {
            query.merge(["nameStartsWith": nameStartsWith], uniquingKeysWith: { $1 })
        }

        return query
    }

    public var body: [String : Any?] { [:] }

    public var httpMethod: VMHttpMethod { .get }

    private let limit: String
    private let offset: String
    private let nameStartsWith: String?

}
