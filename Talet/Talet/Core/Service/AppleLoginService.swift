//
//  AppleLoginService.swift
//  Talet
//
//  Created by 김승희 on 11/26/25.
//

import AuthenticationServices
import Foundation

import RxSwift


protocol AppleLoginServiceProtocol {
    func authorize() -> Observable<SocialTokenEntity>
}

final class AppleLoginService: NSObject,
                               AppleLoginServiceProtocol,
                               ASAuthorizationControllerDelegate,
                               ASAuthorizationControllerPresentationContextProviding {
    
    private let idTokenSubject = PublishSubject<SocialTokenEntity>()
    
    func authorize() -> Observable<SocialTokenEntity> {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [] //이메일, 이름 요청 x
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
        return idTokenSubject.asObservable()
    }
    
    //MARK: Delegate
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            guard let idTokenData = appleIDCredential.identityToken,
            let stringToken = String(data: idTokenData, encoding: .utf8) else {
                idTokenSubject.onError(NetworkError.noData)
                return
            }
            let idTokenEntity = SocialTokenEntity(socialToken: stringToken, platform: LoginPlatform.apple.rawValue)
            idTokenSubject.onNext(idTokenEntity)
            idTokenSubject.onCompleted()
            
        default:
            idTokenSubject.onError(NetworkError.unknown)
        }
    }
    
    //MARK: Error
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithError error: any Error) {
        idTokenSubject.onError(error)
    }
    
    //MARK: Presentation Anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let currentWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first { $0.isKeyWindow }
        return currentWindow ?? UIWindow()
    }
}
