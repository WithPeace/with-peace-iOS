# 청하(청년하랑) - 청년들을 위한 청년정책 공유 커뮤니티

<p>
    <img src="https://github.com/user-attachments/assets/e6e65925-1013-4a35-bdb4-89cff02e69df" align="center" width="100%"/>
</p>

<br/>

## 청하(청년하랑)

- 서비스 소개: 청년들을 위한 청년정책 정보 공유와 소통을 도와주는 커뮤니티 플랫폼
- 개발 인원: 5인(PM 1인, Design 1인, AOS 1인, iOS 1인, Server 1인)
- 개발 기간: 24.11.01 ~ (진행중)
- 개발 환경
  - 최소버전: iOS 15.2
  - Portrait Orientation 지원
  - 라이트 모드 지원
- 사용 협업 툴
  - Notion, Swagger, Figma
- 링크
  - [랜딩 페이지](https://withpeace.github.io/cheongha.github.io/)
  - [플레이 스토어](https://play.google.com/store/apps/details?id=com.withpeace.withpeace)
  - [앱 스토어](https://apps.apple.com/kr/app/청하/id6504498223)

<br/>

## 💪 주요 기능

- 회원 인증
  - 소셜 로그인 회원 가입
  - 소셜 로그인(구글 / 애플) / 자동 로그인
  - 로그아웃
  - 회원탈퇴
- 청년정책
   - 청년정책 조회 / 필터링 기능 / 상세 정보 조회
- 커뮤니티 기능 **(구현 진행중)**
  - 커뮤니티 생성 / 조회 / 편집 / 삭제
- 프로필 조회 / 편집 **(구현 예정)**
- 댓글 기능 **(구현 예정)**
  - 댓글 생성 / 조회 / 편집 / 삭제
- 밸런스 게임 **(구현 예정)**
- Push 알림 기능 **(구현 예정)**
  - 댓글 작성 알림 / 밸런스 게임 관련 알림 / 오늘의 청년 정책 추천 알림
<br/>

## 📱 동작 화면

|회원가입|소셜 로그인 - 구글|로그아웃|회원탈퇴|
|:---:|:---:|:---:|:---:|
|![회원가입](https://github.com/user-attachments/assets/5e5bda2b-dab2-40f1-861b-ada697bc1f4c)|![소셜 로그인 - 구글](https://github.com/user-attachments/assets/dd1936a4-913f-41b9-a67c-1878f4b81c90)|![로그아웃](https://github.com/user-attachments/assets/14b941eb-8409-4f50-a759-c247975cee13)|![회원탈퇴](https://github.com/user-attachments/assets/634a62ac-80cb-444f-ad0c-600707ccba4a)|

|청년정책 필터링 및 조회|청년정책 상세 조회|카테고리별 커뮤니티 조회|카테고리 상세 조회|
|:---:|:---:|:---:|:---:|
|![청년정책 필터링 및 조회](https://github.com/user-attachments/assets/0ba6233a-42ac-4880-90b5-9326933662c6)|![청년정책 상세 조회](https://github.com/user-attachments/assets/9aad4411-7e6f-446e-b393-2088a881c4df)|![카테고리별 커뮤니티 조회](https://github.com/user-attachments/assets/8a3a497d-549d-4f23-8f2d-38151d8eb405)|![카테고리 상세 조회](https://github.com/user-attachments/assets/7638c235-5064-48c3-bc75-fedc60cd497a)|

<br/>

## 🛠 기술 소개

- UIKit, RxSwift
- MVVM Inout/Output Pattern + Clean Architecture, 
- Router Pattern, Moya, Keychain
- PinLayout & FlexLayout, SnapKit
- GoogleSignIn(Google Login) / AuthenticationServices(Apple Login)

<br/>

## 💻 기술 적용

- **MVVM In/Out Pattern**과 **Clean Architecture를 결합**를 활용하여 Presentation 영역 / Domain 영역 / Data 영역으로 관심사 분리
- **Router** 패턴을 활용한 소셜 로그인 구현으로 소셜 로그인 비지니스 로직과 화면 전환 로직 분리
- **Keychain**을 활용한 Token 관리
- **Moya**의 **Router** 패턴 구현으로 네트워크 통신 모듈화
- **PinLayout와 FlexLayout**으로 UI 구성으로 인한 애니메이션 성능 향상 도모

<br/>

## ⚙️ 아키텍처

<img src="https://github.com/user-attachments/assets/efa9c383-55e5-4673-bb88-2d1272e2bf3f" align="image" width="100%"/>

<br/>
