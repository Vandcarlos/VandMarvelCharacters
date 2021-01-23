import VandMarvelAPI

final class VMCharactersRepository {

    class func fetchCharcters(
        limit: String,
        offset: String,
        nameStartsWith: String?,
        completion: @escaping (Result<[VMCharacter], VMError>) -> Void
    ) {
        let request = VMCharactersRequest(limit: limit, offset: offset, nameStartsWith: nameStartsWith)

        VMAPI.request(request, dto: [VMCharacterDTO].self) { result in
            switch result {
            case .success(let charactersDTO):
                let characters: [VMCharacter] = charactersDTO.compactMap {
                    let character = VMCharacter(dto: $0)

                    // TODO: Download image

                    // TODO: Check if is favorited

                    return character
                }

                completion(.success(characters))
            case .failure(let error): completion(.failure(error) )
            }
        }

    }

}

fileprivate extension VMCharacter {

    convenience init?(dto: VMCharacterDTO) {
        guard let id = dto.id, let name = dto.name, let desc = dto.desc else { return nil }

        self.init(id: id, name: name, desc: desc)
    }

}
