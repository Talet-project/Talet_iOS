//
//  NetworkManager.swift
//  Talet
//
//  Created by 김승희 on 11/23/25.
//

import UIKit

import Alamofire
import RxSwift
import Then


protocol NetworkManagerProtocol {
    func request<T:Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: Encodable?,
        headers: [String:String]?,
        responseType: T.Type
    ) -> Single<T>
}


//MARK: - NetworkManager (AlamoFire)
final class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    
    private init() { }
    
    private let baseURL = "https://talet.site"
    
    private let encoder = JSONEncoder().then {
        $0.keyEncodingStrategy = .convertToSnakeCase
    }
    
    private let decoder = JSONDecoder().then {
        $0.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func request<T:Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        body: Encodable? = nil,
        headers: [String:String]? = nil,
        responseType: T.Type
    ) -> Single<T> {
        return Single.create { single in
            
            //MARK: URL 생성
            let url = self.baseURL + endpoint
            
            //MARK: Alamofire Parameters 생성 (body)
            var parameters: Parameters?
            if let body = body,
               let data = try? self.encoder.encode(body),
               let dict = try? JSONSerialization.jsonObject(with: data) as? [String:Any] {
                parameters = dict
            }
            
            //MARK: Alamofire Headers 생성
            let httpHeaders = HTTPHeaders(headers ?? [:])
            
            // 확인용 로그 출력
            print("API 요청:")
            print("URL:", url)
            print("METHOD:", method.rawValue)
            print("Headers:", headers ?? [:])
            print("Body:", parameters ?? [:])
            
            //MARK: 네트워크 요청
            let request = AF.request(
                url,
                method: method,
                parameters: parameters,
                encoding: method == .get ? URLEncoding.default : JSONEncoding.default,
                headers: httpHeaders
            )
                .validate(statusCode: 200...599)
                .responseData { response in
                    if let error = response.error {
                        single(.failure(error))
                        return
                    }
                    
                    guard let status = response.response?.statusCode else {
                        single(.failure(NetworkError.unknown))
                        return
                    }
                    
                    guard let data = response.data else {
                        single(.failure(NetworkError.noData))
                        return
                    }
                    
                    //확인용 로그 출력
                    print("응답 STATUS:", status)
                    if let json = String(data: data, encoding: .utf8) {
                        print("RESPONSE:", json)
                    }
                    
                    //MARK: 상태 코드 처리
                    switch status {
                    case 200...299:
                        break
                        
                    case 401:
                        single(.failure(NetworkError.unauthorized))
                        return
                        
                    case 400...499, 500...599:
                        if let serverError = try? self.decoder.decode(ErrorResponse.self, from: data) {
                            let serverErrorMsg = serverError.message ?? "서버 에러 메시지가 없습니다."
                            single(.failure(NetworkError.apiError(serverErrorMsg)))
                        } else {
                            single(.failure(NetworkError.serverError(status)))
                        }
                        return
                        
                    default:
                        single(.failure(NetworkError.unknown))
                        return
                    }
                    
                    //MARK: 정상 응답 JSON 디코딩
                    do {
                        let decoded = try self.decoder.decode(responseType, from: data)
                        single(.success(decoded))
                    } catch {
                        single(.failure(NetworkError.decodingError))
                    }
                }
            
            return Disposables.create { request.cancel() }
        }
    }
}


//  //MARK: - NetworkManager (URLSession)
//  //MARK: - HTTPMethod
//enum HTTPMethod: String {
//    case get = "GET"
//    case post = "POST"
//    case put = "PUT"
//    case delete = "DELETE"
//    case patch = "PATCH"
//}
//final class NetworkManager {
//    static let shared = NetworkManager()
//    
//    private let baseURL = "https://talet.site"
//    private let session: URLSession
//    
//    private let encoder = JSONEncoder().then {
//        $0.keyEncodingStrategy = .convertToSnakeCase
//    }
//    
//    private let decoder = JSONDecoder().then {
//        $0.keyDecodingStrategy = .convertFromSnakeCase
//    }
//    
//    private init() {
//        let configuration = URLSessionConfiguration.default
//        // 타임아웃을 30초로 설정, 각각 요청 타임아웃 / 전체 작업 타임아웃
//        configuration.timeoutIntervalForRequest = 30
//        configuration.timeoutIntervalForResource = 30
//        self.session = URLSession(configuration: configuration)
//    }
//    
//    //MARK: Request Method: 실제 API 요청 보내는 메인 함수
//    func request<T: Decodable>(
//        endpoint: String,
//        method: HTTPMethod = .get,
//        body: Encodable? = nil,
//        headers: [String: String]? = nil,
//        responseType: T.Type
//    ) -> Single<T> {
//        return Single.create { single in
//            
//            //MARK: URL 생성
//            guard let url = URL(string: self.baseURL + endpoint) else {
//                single(.failure(NetworkError.invalidURL))
//                return Disposables.create()
//            }
//            
//            //MARK: URLRequest 생성
//            var request = URLRequest(url: url)
//            request.httpMethod = method.rawValue
//            
//            //MARK: Header 추가
//            headers?.forEach{ key, value in
//                request.setValue(value, forHTTPHeaderField: key)
//            }
//
//            //MARK: Body 추가
//            if let body = body {
//                // body가 있을 경우에만
//                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//                request.httpBody = try? self.encoder.encode(body)
//            }
//            
//            // 확인용 로그 출력
//            print("API 요청:")
//            print("URL: \(url)")
//            print("Method: \(method.rawValue)")
//            if let headers = headers {
//                print("Headers: \(headers)")
//            }
//            if let body = body,
//               let jsonData = try? self.encoder.encode(body),
//               let jsonString = String(data: jsonData, encoding: .utf8) {
//                print("Body: \(jsonString)")
//            }
//            
//            //MARK: 네트워크 요청
//            let task = self.session.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    single(.failure(error))
//                    return
//                }
//                
//                guard let data = data else {
//                    single(.failure(NetworkError.noData))
//                    return
//                }
//                
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    single(.failure(NetworkError.unknown))
//                    return
//                }
//                
//                // 확인용 응답 로그 출력
//                print("응답:")
//                print("Status Code: \(httpResponse.statusCode)")
//                if let jsonString = String(data: data, encoding: .utf8) {
//                    print("Response: \(jsonString)")
//                }
//                
//                //MARK: 상태 코드 검사
//                switch httpResponse.statusCode {
//                case 200...299:
//                    break
//                    
//                case 401:
//                    single(.failure(NetworkError.unauthorized))
//                    return
//                    
//                case 400...499, 500...599:
//                    if let serverError = try? self.decoder.decode(ErrorResponse.self, from: data) {
//                        let serverErrorMsg = serverError.message ?? "서버 에러 메시지가 없습니다."
//                        single(.failure(NetworkError.apiError(serverError.message)))
//                    } else {
//                        single(.failure(NetworkError.serverError(httpResponse.statusCode)))
//                    }
//                    return
//                    
//                default:
//                    single(.failure(NetworkError.unknown))
//                    return
//                }
//                
//                //MARK: 정상 응답 JSON 디코딩
//                do {
//                    let decoded = try self.decoder.decode(responseType, from: data)
//                    print("디코딩 성공")
//                    single(.success(decoded))
//                } catch {
//                    single(.failure(NetworkError.decodingError))
//                }
//            }
//            
//            //MARK: 요청 시작
//            task.resume()
//            
//            //Disposable 반환
//            return Disposables.create {
//                task.cancel()
//            }
//        }
//    }
//}
