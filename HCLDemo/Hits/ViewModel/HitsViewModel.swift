//
//  HitsViewModel.swift
//  HCLDemo
//
//  Created by Pichuka, Anvesh (623-Extern) on 19/06/24.
//
import Foundation

class HitsViewModel {
    
    var hits: [Hits] = []
    var onHitsFetched: (() -> Void)?
    var onError: ((Error) -> Void)?
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchHits() {
        let url = URL(string: "https://www.jsonkeeper.com/b/6JS0")!
        
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.onError?(error)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.onError?(NSError(domain: "DataError", code: -1, userInfo: nil))
                }
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode(Responsedata.self, from: data)
                DispatchQueue.main.async {
                    self.hits = responseData.hits ?? []
                    self.onHitsFetched?()
                }
            } catch {
                DispatchQueue.main.async {
                    self.onError?(error)
                }
            }
        }.resume()
    }
}
