
# 👕 폼생폼사 
> ### 중고 축구 유니폼 거래 앱
<br />
<br />
<p align="center">
  <img width="19%" src="https://github.com/user-attachments/assets/cb537bc8-a4a8-4eb8-81db-b22830caefbc" />
  <img width="19%" src="https://github.com/user-attachments/assets/d0b1953c-0cf9-43c3-a50f-631b01d45f7a" />
  <img width="19%" src="https://github.com/user-attachments/assets/b3a245a3-b371-4668-82ea-e6d52c99fd88" />
  <img width="19%" src="https://github.com/user-attachments/assets/48716570-be7f-4fc5-b273-11bc3330c87c" />
</p>
 
## 프로젝트 소개
> **개발 기간** : 2024.08.14 ~ 2024.08.31 (약 2주)<br />
> **개발 인원** :  iOS 1명, 백엔드 1명<br />
> **최소 버전** : iOS 16.0+<br />

## 사용 기술 및 개발 환경
- **iOS** : Swift 5, Xcode 15.3
- **UI** : UIKit, Codebase UI, SnapKit, Then, Kingfisher
- **Architecture** : MVVM (Input-Output), Repository 
- **Reactive** : RxSwift
- **Network** : Alamofire
- **Local DB** : Realm
- **Payments** : iamport-iOS
- **App-Monitoring** : Firebase Crashlytics
<br />

## 주요 기능
- 다양한 리그 필터링을 통한 중고 유니폼 확인
- 해당 유니폼 판매자 다른 게시글 확인
- 중고 유니폼 게시물 (추가, 수정, 삭제)
- 인기 유니폼 실착 피드
- 유니폼 결제 기능
<br />

## 프로젝트 주요 구현사항
### URLRequestConvertible 기반 Router 패턴 적용
- API 요청마다 중복되는 baseURL, header(token, key) 설정을 Router enum case로 분리하여 재사용성 향상
- 다수의 API 엔드포인트(상품 조회/등록/수정/삭제, 좋아요, 결제 등)를 효율적으로 관리하기 위해 열거형 기반 라우터 도입결합하여 표시

### Cursor 기반 페이지네이션 
- 리그별 유니폼 필터링 시 실시간으로 추가/삭제되는 상품 목록을 안정적으로 처리하기 위해 Cursor 방식 선택
- prefetchItems 시점을 계산하여 무한 스크롤 구현

### Alamofire Interceptor를 활용한 토큰 만료 대응
- RequestInterceptor에서 419 상태 코드(Refresh토큰 만료) 감지하여 토큰 자동 갱신
- 갱신 성공 시 retry 메서드로 실패했던 API 자동 재시도
<br />

## 트러블 슈팅
### 중고 유니폼 게시물 등록시 여러 이미지 선택 후 비동기 로드 문제
- 문제 상황
    - PHPicker로 여러 이미지 선택 후 화면에 이미지가 보이지 않는 오류 발생
    - 이미지 로드 완료 시점이 각각 달라 UI 업데이트 시점 파악 어려움
- 해결 방안
    - DispatchGroup을 활용하여 비동기로 로드되는 이미지들의 완료 시점 동기화
    - selectedImages 배열에 이미지를 순차적으로 추가하고, 모든 이미지 로드 완료 시점에 한 번에 UI 업데이트
    ```swift
        private func selectedImage(_ results: [PHPickerResult]) {
            let maxImageCount = 5
            var selectedImages = [UIImage]()
            let dispatchGroup = DispatchGroup()
            for result in results.prefix(maxImageCount) {
                dispatchGroup.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                    defer { dispatchGroup.leave() }
                    guard let self = self  else { return }
                    if let error = error {
                        print("이미지 로드 오류: \(error)")
                        return
                    }
                    if let image = object as? UIImage {
                        print("12312",image)
                        selectedImages.append(image)
                    }
                }
            }
            dispatchGroup.notify(queue: .main) {
                self.selectedImages.onNext(selectedImages)
        }
    }

### iamport-ios와 Then 라이브러리 의존성 충돌 문제
- 문제 상황
    - iamport-ios가 Then 2.7.0 버전을 의존하고 있으나, 프로젝트에서는 Then 3.0.0 사용
- 해결 방안
    - iamport 라이브러리에서 사용 중인 Then 2.7.0과 호환성을 위해 프로젝트의 Then 버전을 수정하여 의존성 충돌 해결
```swift
//iamport-ios
dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
        .package(name: "RxBusForPort", url: "https://github.com/iamport/RxBus-Swift", .upToNextMinor(from: "1.3.0")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.4.0")),
        .package(url: "https://github.com/devxoul/Then.git", .upToNextMajor(from: "2.7.0")),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.50.4")
    ],
