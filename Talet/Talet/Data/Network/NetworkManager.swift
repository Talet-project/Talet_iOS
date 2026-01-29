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
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod,
        body: Encodable?,
        headers: [String: String]?,
        responseType: T.Type
    ) -> Single<T>
    
    func requestVoid(
        endpoint: String,
        method: HTTPMethod,
        body: Encodable?,
        headers: [String: String]?
    ) -> Single<Void>

    func upload<T: Decodable>(
        endpoint: String,
        imageData: Data,
        headers: [String: String]?,
        responseType: T.Type
    ) -> Single<T>
}


//MARK: - NetworkManager (AlamoFire)
final class NetworkManager: NetworkManagerProtocol {

    static let shared = NetworkManager()
    init() { }
    
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
            
            //MARK: 네트워크 요청
            let request = AF.request(
                url,
                method: method,
                parameters: parameters,
                encoding: method == .get ? URLEncoding.default : JSONEncoding.default,
                headers: httpHeaders
            )
                .responseData { response in
                    if let error = response.error {
                        single(.failure(error))
                        return
                    }
                    
                    guard let status = response.response?.statusCode else {
                        single(.failure(NetworkError.unknown))
                        return
                    }
                    
                    switch status {
                    case 202:
                        //TODO: 추후 보이스클로닝 음성 폴링 처리시 사용예정
                        single(.success(() as! T))
                        return
                        
                    case 200...299:
                        guard let data = response.data else {
                            single(.failure(NetworkError.noData))
                            return
                        }
                        
                        do {
                            let decoded = try self.decoder.decode(responseType, from: data)
                            single(.success(decoded))
                        } catch {
                            single(.failure(NetworkError.decodingError))
                        }
                        return
                        
                    case 401:
                        if let data = response.data,
                           let base = try? self.decoder.decode(BaseErrorResponse.self, from: data),
                           let error = base.error {
                            single(.failure(NetworkError.detailedError(error)))
                        }
                        else {
                            single(.failure(NetworkError.serverError(status)))
                        }
                        return
                        
                    case 400...599:
                        if let data = response.data,
                           let base = try? self.decoder.decode(BaseErrorResponse.self, from: data),
                           let error = base.error {
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
                }
            
            return Disposables.create { request.cancel() }
        }
    }
    
    // 응답 data 없는 204 처리
    func requestVoid(
        endpoint: String,
        method: HTTPMethod = .get,
        body: Encodable? = nil,
        headers: [String:String]? = nil
    ) -> Single<Void> {
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
            
            //MARK: 네트워크 요청
            let request = AF.request(
                url,
                method: method,
                parameters: parameters,
                encoding: method == .get ? URLEncoding.default : JSONEncoding.default,
                headers: httpHeaders
            )
                .responseData { response in
                    if let error = response.error {
                        single(.failure(error))
                        return
                    }
                    
                    guard let status = response.response?.statusCode else {
                        single(.failure(NetworkError.unknown))
                        return
                    }
                    
                    switch status {
                    case 204:
                        single(.success(()))
                        return
                        
                    case 400...599:
                        if let data = response.data,
                           let base = try? self.decoder.decode(BaseErrorResponse.self, from: data),
                           let error = base.error {
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
                }
            
            return Disposables.create { request.cancel() }
        }
    }
    
    
    // multipart 업로드
    func upload<T: Decodable>(
        endpoint: String,
        imageData: Data,
        headers: [String: String]?,
        responseType: T.Type
    ) -> Single<T> {
        
        return Single.create { single in
            let url = self.baseURL + endpoint
            let httpHeaders = HTTPHeaders(headers ?? [:])
            
            AF.upload(
                multipartFormData: { multipart in
                    multipart.append(
                        imageData,
                        withName: "profile",
                        fileName: "profile.jpg",
                        mimeType: "image/jpeg"
                    )
                },
                to: url,
                headers: httpHeaders
            )
            .responseData { response in
                if let error = response.error {
                    single(.failure(error))
                    return
                }
                
                guard let data = response.data else {
                    single(.failure(NetworkError.noData))
                    return
                }
                
                do {
                    let decoded = try self.decoder.decode(responseType, from: data)
                    single(.success(decoded))
                } catch {
                    single(.failure(NetworkError.decodingError))
                }
            }
            
            return Disposables.create()
        }
        
    }
}
