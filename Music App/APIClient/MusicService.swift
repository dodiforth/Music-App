//
//  MusicService.swift
//  Music App
//
//  Created by Dowon Kim on 29/08/2023.
//

import Foundation

// MARK: - Network Error Enum
enum NetworkError: Error {
    case networkingError
    case dataCorrupted
    case parseError
}

// MARK: - Networking Class Model

final class NetworkManager {
    
    // To communicate from one server to anywhere of Views ==> Singleton
    static let shared = NetworkManager()
    // Prevent to create various instance of the class
    private init() {}
    
    typealias NetworkCompletion = (Result<[Music], NetworkError>) -> Void
    
    // Networking request function (Bring Music DATA from API)
    func fetchMusic(searchTerm: String, completion: @escaping NetworkCompletion) {
        let urlString = "\(MusicApi.requestUrl)\(MusicApi.mediaParam)&term=\(searchTerm)"
        print(urlString)
        performRequest(with: urlString) { result in
            completion(result)
        }
    }
    
    // Actual REQUEST function ! Asynchronous ! Think of Get method among of Get Post Put Delete
    func performRequest(with urlString: String, completion: @escaping NetworkCompletion) {
        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!)
                completion(.failure(.networkingError))
                return
            }
            guard let safeData = data else {
                completion(.failure(.dataCorrupted))
                return
            }
            
            if let musics = self.parseJSON(safeData) {
                print("Execute Parsing!")
                completion(.success(musics))
            } else {
                print("Failing Parsing!")
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    // Analyze the data just arrived
    private func parseJSON(_ musicData: Data) -> [Music]? {
        do {
            let decoder = JSONDecoder()
            let musicData = try decoder.decode(MusicData.self, from: musicData)
            return musicData.results
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

