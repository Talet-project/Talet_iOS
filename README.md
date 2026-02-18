# Talet iOS

부모의 목소리로 전래동화를 들려주는 음성 기반 동화 애플리케이션입니다.
다문화 가정 아이들이 부모의 음성을 통해 한국어에 자연스럽게 노출되고, 정서적 유대와 언어 학습을 동시에 경험할 수 있도록 설계했습니다.

**Voice Cloning 기반 개인화 스토리텔링 경험**을 제공하는 것을 목표로 합니다.

---

## 주요 기능

### 1. 홈

* 인기 랭킹 제공
* 배너 영역을 통한 추천 콘텐츠 노출
* 전체 도서 리스트 조회

| 화면   | 스크린샷                            | 설명                |
| ---- | ------------------------------- | ----------------- |
| Home |  | 개발중 |

---

### 2. 둘러보기 (Explore)

* 태그 기반 콘텐츠 필터링 (용기, 지혜, 우정, 성장 등)
* 카테고리 중심 탐색 UX

| 화면      | 스크린샷                                  | 설명              |
| ------- | ------------------------------------- | --------------- |
| Explore |  | 개발중 |

---

### 3. 마이페이지

* 사용자 프로필 관리
* 설정 관리
* 로그인 상태 및 계정 관리

| 화면     | 스크린샷                                |
| ------ | ----------------------------------- |
| 마이페이지 | <img width="200" height="600" alt="KakaoTalk_Photo_2026-01-01-02-10-36 006" src="https://github.com/user-attachments/assets/a0b16c3c-af75-4dc3-9e86-bf73a2d3316f" /> |
 | 내 정보 수정 | <img width="200" height="600" alt="KakaoTalk_Photo_2026-02-18-22-15-46" src="https://github.com/user-attachments/assets/313fcc09-397b-412b-a77e-a9c115c77dbe" /> |
 | 설정 | <img width="200" height="600" alt="KakaoTalk_Photo_2026-02-18-22-15-52" src="https://github.com/user-attachments/assets/0d1eef83-e06b-4d63-ae8e-14a6a4111440" />|

---

### 4. 음성 클로닝

* 사용자 음성 녹음
* 서버 기반 Voice Cloning 처리
* 스토리 낭독 시 사용자 음성 적용

| 화면            | 스크린샷                              | 설명                |
| ------------- | --------------------------------- | ----------------- |
| Voice Cloning | <img width="200" height="600" alt="KakaoTalk_Photo_2026-01-01-02-10-36 008" src="https://github.com/user-attachments/assets/57b18439-e1ef-473d-a304-d292dc722452" /> | 음성 녹음 및 클로닝 설정 화면 (개발중) |

---

### 5. 소셜 로그인

* Apple Sign-In
* Google 로그인
* Kakao 로그인

| 화면    | 스크린샷                              |
| ----- | --------------------------------- |
| 초기 화면 | <img width="200" height="600" alt="KakaoTalk_Photo_2026-01-01-02-10-35 001" src="https://github.com/user-attachments/assets/c1e7dd43-a4e9-492c-b268-272e2d78ee35" /> |
 | 회원가입 화면 | <img width="200" height="600" alt="KakaoTalk_Photo_2026-01-01-02-10-36 002" src="https://github.com/user-attachments/assets/0fab27c0-253f-42ab-b87e-aedd04613495" /> |

---

## 기술 스택

| 분류             | 사용 기술                                |
| -------------- | ------------------------------------ |
| Language       | Swift 5                              |
| UI             | UIKit, SnapKit                       |
| Reactive       | RxSwift 6.9.0                        |
| Network        | Alamofire 5.10.2, Moya 15.0.3        |
| DI             | Swinject 2.9.1                       |
| Image          | Kingfisher 8.3.3                     |
| Authentication | Apple Sign-In, Google SDK, Kakao SDK |

---

## 아키텍처

Clean Architecture + MVVM + Repository Pattern

```
Features (Presentation)
    └── Domain (Entity, UseCase, Repository Protocol)
            └── Data (Repository Impl, DTO, Network)
                    └── Core (Error, Security, Extensions)
```

### 설계 의도

* Presentation → Domain → Data 단방향 의존성 유지
* Repository Protocol을 Domain에 정의하여 DIP 원칙 준수
* DTO ↔ Entity 분리로 계층 간 책임 명확화
* Swinject 기반 Assembly 단위 DI 구성
* Feature 모듈 단위로 독립성 유지

---

## 의존성 주입 구조

* Swinject Container 기반 DI
* Feature별 Assembly 구성
* ViewModel, UseCase, Repository 단위 분리 주입
* 테스트 환경에서 Mock Repository로 대체 가능하도록 설계

---

## 프로젝트 구조

```
Talet/
├── App/             
│   ├── AppDelegate
│   ├── SceneDelegate
│   ├── TabBar
│   └── DIContainer
│
├── Core/            
│   ├── Error
│   ├── Security
│   ├── Extensions
│   └── Service
│
├── Domain/          
│   ├── Entity
│   ├── UseCase
│   └── Repository Protocol
│
├── Data/            
│   ├── Repository
│   ├── DTO
│   └── Network
│
└── Features/        
    ├── Home
    ├── Explore
    ├── MyPage
    ├── Onboarding
    └── Voice
```

---

## 요구 사항

* iOS 16.6+
* Xcode 15+
* Swift 5
