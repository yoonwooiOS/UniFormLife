//
//  AddPostViewModel.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/27/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

final class AddPostViewModel: ViewModelType {
    let sizePickerData = Observable.just(["XS(85)", "S(90)", "M(95)", "L(100)", "XL(105)", "XXL(110)"])
    let conditionPickerData = Observable.just(["새 상품", "거의 새것", "중고 상품"])
    let seasonPickerData = Observable.just(["01-02", "02-03", "03-04", "04-05", "05-06", "06-07", "07-08", "08-09", "09-10", "10-11", "11-12", "12-13", "13-14", "14-15", "15-16", "16-17", "17-18", "18-19", "19-20", "20-21", "21-22", "22-23", "23-24", "24-25"])
    let leaguePickerData = Observable.just(["프리미어리그", "라리가", "세리에A", "리그 1", "K 리그", "국가대표", "기타"])
    
    let disposeBag = DisposeBag()
    let imageArray = BehaviorSubject<[UIImage?]>(value: [nil])
    struct Input {
        let addPhotoTapped: Observable<Void>
        let selectedImages: Observable<[UIImage?]>
        let title: ControlProperty<String>
        let content: ControlProperty<String>
        let price: ControlProperty<String>
        let sizeSelected: Observable<String>
        let conditionSelected: Observable<String>
        let seasonSelected: Observable<String>
        let leagueSelected: Observable<String>
        let completeButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let images: Observable<[UIImage?]>
        let isPlaceholderHidden: Observable<Bool>
        let sizePickerData: Observable<[String]>
        let conditionPickerData: Observable<[String]>
        let seasonPickerData: Observable<[String]>
        let leaguePickerData: Observable<[String]>
        let selectedImagesCount: Observable<Int>
    }
    
    func transform(input: Input) -> Output {
        let isPlaceholderHidden = input.content.map { !$0.isEmpty }
        input.selectedImages
            .withLatestFrom(imageArray) { newImages, existingImages in
                var updatedImages = existingImages
                updatedImages.append(contentsOf: newImages)
                return updatedImages
            }
            .bind(to: imageArray)
            .disposed(by: disposeBag)
        let selectedImagesCount = imageArray
            .map { images in
                images.filter { $0 != nil }.count
            }
        let postRequestModel = Observable.combineLatest(
            input.title,
            input.content,
            input.price,
            input.sizeSelected,
            input.conditionSelected,
            input.seasonSelected,
            input.leagueSelected,
            imageArray.compactMap { $0 as? [String] } // files 추가
        ) { title, content, price, size, condition, season, league, files in
            return PostRequestModel(
                title: title,
                content: content,
                price: price,
                size: size,
                condition: condition,
                season: season,
                league: league,
                files: files
            )
        }
        
        input.completeButtonTapped
            .withLatestFrom(Observable.combineLatest(
                imageArray,  // 업로드할 이미지 배열
                input.title,  // 제목
                input.content,  // 내용
                input.price,  // 가격 (String)
                input.sizeSelected,  // 사이즈
                input.conditionSelected,  // 상태
                input.seasonSelected,  // 시즌
                input.leagueSelected  // 리그
            ))
            .map { images, title, content, price, size, condition, season, league in
                (
                    images.compactMap { $0 },  // nil이 아닌 이미지를 필터링
                    title,
                    content,
                    Int(price) ?? 0,  // String을 Int로 변환, 변환 실패 시 기본값 0
                    size,
                    condition,
                    season,
                    self.mapLeagueToProductID(league: league)
                )
            }
            .bind(with: self) { owner, data in
                let (images, title, content, price, size, condition, season, productID) = data
                owner.uploadImages(
                    images: images,
                    title: title,
                    content: content,
                    price: price,  // 여기서 Int 타입의 price를 사용
                    size: size,
                    condition: condition,
                    season: season,
                    league: productID  // 변환된 product_id를 사용
                )
            }
            .disposed(by: disposeBag)
        
        return Output(
            images: imageArray.asObservable(),
            isPlaceholderHidden: isPlaceholderHidden,
            sizePickerData: sizePickerData,
            conditionPickerData: conditionPickerData,
            seasonPickerData: seasonPickerData,
            leaguePickerData: leaguePickerData,
            selectedImagesCount: selectedImagesCount
        )
    }
    private func mapLeagueToProductID(league: String) -> String {
        switch league {
        case "프리미어리그":
            return "uniformLife_PremierLeague"
        case "라리가":
            return "uniformLife_LaLiga"
        case "세리에A":
            return "uniformLife_SerieA"
        case "리그 1":
            return "uniformLife_Ligue1"
        case "K 리그":
            return "uniformLife_KLeague"
        case "국가대표":
            return "uniformLife_Nationalteam"
        default:
            return "uniformLife_Others"
        }
    }
    private func uploadImages(images: [UIImage], title: String, content: String, price: Int, size: String, condition: String, season: String, league: String) {
        NetworkManager.shared.uploadImagefiles(images: images)
            .subscribe(onSuccess: { result in
                switch result {
                case .success(let files):
                    
                    let postRequestModel = UploadPostQuery(
                        title: title,
                        content: content,
                        price: price,
                        size: size,
                        condition: condition,
                        season: season,
                        league: league,
                        imageUrls: files
                    )
                    self.uploadPostRequest(postRequestModel)
                    
                case .failure(let error):
                    print("이미지 업로드 실패: \(error)")
                }
            }, onFailure: { error in
                print("이미지 업로드 실패: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    
    private func uploadPostRequest(_ postRequestModel: UploadPostQuery) {
        NetworkManager.shared.callRequest(router: .uploadPost(postData: postRequestModel), type: PostData.self)
            .subscribe(onSuccess: { result in
                switch result {
                case .success(let fetchPost):
                    print("업로드 성공: \(fetchPost)")
                    // 서버에서 반환된 fetchPost 데이터를 활용
                case .failure(let error):
                    print("업로드 실패: \(error)")
                    // 필요 시 상태 코드 처리
                }
            }, onFailure: { error in
                print("요청 실패: \(error)")
            })
            .disposed(by: disposeBag)
    
    }
}

