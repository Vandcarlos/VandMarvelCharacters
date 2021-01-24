import VandMarvelAPI

public final class VMCharactersAPIRepository {

    public class func fetchCharcters(
        limit: Int,
        offset: Int,
        nameStartsWith: String?,
        completion: @escaping (Result<[VMCharacter], VMError>) -> Void
    ) {
        let request = VMCharactersRequest(limit: limit, offset: offset, nameStartsWith: nameStartsWith)

        VMAPI.request(request, dto: VMCharacterDataWrapperDTO.self) { result in
            switch result {
            case .success(let dataWrapperDTO):
                let charactersDTO = dataWrapperDTO.data.results
                let characters: [VMCharacter] = charactersDTO.compactMap {
                    let character = VMCharacter(dto: $0)

                    character?.image = UIImage(url: $0.thumbnail?.url)

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
        guard let id = dto.id, let name = dto.name, let description = dto.description else { return nil }

        self.init(id: id, name: name, description: description)
    }

}

fileprivate extension VMImageDTO {

    var url: URL? {
        URL(string: "\(path).\(self.extension)")
    }

}

fileprivate extension UIImage {

    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

}
