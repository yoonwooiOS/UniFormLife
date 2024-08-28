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
    private let imageArray = BehaviorSubject<[UIImage?]>(value: [nil])
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
            
            let postRequestModel = Observable.combineLatest(
                input.title.asObservable(),
                input.content.asObservable(),
                input.price.asObservable(),
                input.sizeSelected,
                input.conditionSelected,
                input.seasonSelected,
                input.leagueSelected
            ) { title, content, price, size, condition, season, league in
                return PostRequestModel(
                    title: title,
                    content: content,
                    price: price,
                    size: size,
                    condition: condition,
                    season: season,
                    league: league
                )
            }
        
            input.completeButtonTapped
                .withLatestFrom(imageArray)
                .map { $0.compactMap { $0 } }
                .bind(with: self) { owner, images in
                       owner.uploadImages(images: images)
                   }
                .disposed(by: disposeBag)
            return Output(
                images: imageArray.asObservable(),
                isPlaceholderHidden: isPlaceholderHidden,
                sizePickerData: sizePickerData,
                conditionPickerData: conditionPickerData,
                seasonPickerData: seasonPickerData,
                leaguePickerData: leaguePickerData
            )
        }
    private func uploadImages(images: [UIImage]) {
        NetworkManager.shared.uploadImagefiles(images: images)
            .subscribe(onSuccess: { files in
                print("업로드 성공: \(files)")
            }, onFailure: { error in
                print("업로드 실패: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
