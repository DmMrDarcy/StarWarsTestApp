//
//  APIManager.swift
//  Montekrist
//
//  Created by Dmitriy Lukyanov on 13.08.2023.
//

import Foundation
import Alamofire
import Combine
import Network
import UIKit

class APIManager: RequestInterceptor {
    private var sessionManager: Session!
    private var configuration: NetworkConfiguration!
    private let userAgent = UserAgentHeader()
    private var cancelBag = CancelBag()
    private let environment: EnvironmentData
    
    init(environment: EnvironmentData) {
        self.environment = environment
        
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
        let endPoint = environment.endPoint
        let sessionConfiguration = URLSessionConfiguration.default
        sessionManager = Session(configuration: sessionConfiguration, interceptor: self)
        configuration = NetworkConfiguration(endPoint: endPoint)
    }
    
    func call<Value: Decodable>(apiMethod: APIMethods) -> AnyPublisher<Value, NetworkError> {
        var headers = configuration.defaultHttpHeaders
        
        if let userAgentHeader = userAgent.httpHeaders {
            for (header, value) in userAgentHeader {
                headers[header] = value
            }
        }
        
        let url = configuration.baseURL!
        let urlProvider = apiMethod.createURLConvertible(baseURL: url)
        let method = apiMethod.httpMethod
        
        var backgroundTask: UIBackgroundTaskIdentifier?

        backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "Background request") {
            UIApplication.shared.endBackgroundTask(backgroundTask!)
        }

        switch apiMethod.parameters {
        case let .standard(parameters, encoding):
            return Future({ [weak self] promise  in
                guard let self = self else {
                    return
                }
                
                self.sessionManager.request(urlProvider,
                                            method: method,
                                            parameters: parameters,
                                            encoding: encoding.alamofireEncoding,
                                            headers: headers
                )
                .responseDecodable(of: Value.self) { response in
                    UIApplication.shared.endBackgroundTask(backgroundTask!)
                    
                    switch response.result {
                    case .success(let value):
                        promise(.success(value))
                    case .failure(let err):
                        promise(.failure(.error(err)))
                    }
                }
            })
            .eraseToAnyPublisher()
        }
    }
}
