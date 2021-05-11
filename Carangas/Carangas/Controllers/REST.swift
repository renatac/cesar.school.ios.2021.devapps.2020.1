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
    
    
    class func update(car: Car, onComplete: @escaping (Bool) -> Void ) {
        // 1 -- bloco novo: o endpoint do servidor para UPDATE é: URL/id
         let urlString = basePath + "/" + car._id!
        
        // 2 -- usar a urlString ao invés da basePath
        guard let url = URL(string: urlString) else {
            onComplete(false)
            return
        }
        
        print("URL: \(url)")
        
        // 3 -- o verbo do httpMethod deve ser alterado para PUT ao invés de POST
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        
        // transformar Objeto para JSON para enviar na requisito
        // transformar objeto para um JSON, processo contrario do decoder -> Encoder
        guard let jsonData = try? JSONEncoder().encode(car) else {
            onComplete(false)
            return
        }
        request.httpBody = jsonData
        
        // 4 - requisição propriamente dita como uma CLOSURE
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            // 5 verifica resposta do servidor e retorna SUCESSO
            if error == nil {
                
                // verificar e desembrulhar em uma unica vez
                guard let response = response as? HTTPURLResponse/*, response.statusCode == 200 , let _ = data*/ else {
                    onComplete(false)
                    return
                }
                
                if response.statusCode == 200 {
                    
                    // sucesso
                    onComplete(true)
                    
                } else {
                    print("Status code: \(response.statusCode)")
                    // sucesso
                    onComplete(false)
                }                
                
            } else {
                onComplete(false)
            }
            
        }.resume()
    }
    

    class func save(car: Car, onComplete: @escaping (Bool) -> Void ) {
        
        // 1
        guard let url = URL(string: basePath) else {
            onComplete(false)
            return
        }
        
        // 2 - metodo POST precisa ser setado na URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // 3 - transformar Objeto para JSON para enviar na requisito
        // transformar objeto para um JSON, processo contrario do decoder -> Encoder
        guard let jsonData = try? JSONEncoder().encode(car) else {
            onComplete(false)
            return
        }
        request.httpBody = jsonData

                
        // 4 - requisição propriamente dita como uma CLOSURE
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            // 5 verifica resposta do servidor e retorna SUCESSO
            if error == nil {
                
                // verificar e desembrulhar em uma unica vez
                guard let response = response as? HTTPURLResponse, response.statusCode == 200, let _ = data else {
                    onComplete(false)
                    return
                }
                
                // sucesso
                onComplete(true)
                
            } else {
                onComplete(false)
            }
                        
            
        }.resume()
    }
    
    
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
