//
//  REST.swift
//  Carangas
//
//  Created by Douglas Frari on 5/10/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation


enum CarError {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJSON
}


class REST {
    
    // URL + endpoint
    private static let basePath = "https://carangas.herokuapp.com/cars"
    
    // session criada automaticamente e disponivel para reusar
    private static let session = URLSession(configuration: configuration)
    
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        config.httpAdditionalHeaders = ["Content-Type":"application/json"]
        config.timeoutIntervalForRequest = 10.0
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()
    
    
    class func loadCars(onComplete: @escaping ([Car]) -> Void, onError: @escaping (CarError) -> Void) {
         
        guard let url = URL(string: REST.basePath) else {
            onError(.url)
            return
        }
         
        REST.session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            // 1
            if error == nil {
                
                // algo válido foi retornado do servidor...
                
                // 2
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return
                }
                
                if response.statusCode == 200 {
                    
                    // servidor respondeu com sucesso :)
                    
                    // 3
                    // obter o valor de data
                    guard let data = data else {
                        // ERROR porque o data é invalido
                        onError(.noData)
                        return
                    }
                    
                    do {
                        let cars = try JSONDecoder().decode([Car].self, from: data)
                        // pronto para reter dados
                        
                        onComplete(cars) // SUCESSO
                        
                    } catch {
                        // algum erro ocorreu com os dados
                        print(error.localizedDescription)
                        onError(.invalidJSON)
                    }
                    
                } else {
                    print("Algum status inválido(-> \(response.statusCode) <-) pelo servidor!! ")
                    onError(.responseStatusCode(code: response.statusCode))
                }
                
            } else {
                print(error.debugDescription)
                onError(.taskError(error: error!))
            }
            
        }.resume()
        
    }
    
}
