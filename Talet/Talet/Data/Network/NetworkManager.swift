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


protocol NetworkManagerProtocol: AnyObject {
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
    
    private let encoder = JSONEncoder()
//        .then {
//        $0.keyEncodingStrategy = .convertToSnakeCase
//    }
    
    private let decoder = JSONDecoder()
//        .then {
//        $0.keyDecodingStrategy = .convertFromSnakeCase
//    }
    
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
                        if let error = try? self.decoder.decode(ErrorResponse.self, from: data) {
                            single(.failure(NetworkError.detailedError(error)))
                        } else {
                            single(.failure(NetworkError.serverError(status)))
                        }
                        return
                        
                    case 400...499, 500...599:
                        if let error = try? self.decoder.decode(ErrorResponse.self, from: data) {
                            let errorMsg = error.message ?? "서버 에러 메시지가 없습니다."
                            single(.failure(NetworkError.apiError(errorMsg)))
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
