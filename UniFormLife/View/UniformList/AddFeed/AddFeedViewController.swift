//
//  AddFeedViewController.swift
//  UniFormLife
//
//  Created by 김윤우 on 9/7/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import PhotosUI

final class AddFeedViewController: BaseViewController {
    private let selectedImages = PublishSubject<[UIImage?]>()
    
    private let viewModel = AddFeedViewModel()
    private let addPhotoButton = CarmeraImageButton().then {
        $0.contentMode = .scaleAspectFit 
        $0.clipsToBounds = true
    }
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private let imagesView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .gray
    }
    private let contentTextView = UITextView().then {
        $0.font = Font.regular16
        $0.textColor = .black
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 5.0
        $0.isScrollEnabled = true
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    private let completeButton = UIButton().then {
        $0.setTitle("작성 완료", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemOrange
        $0.layer.cornerRadius = 5.0
    }
    override func bind() {
        let input = AddFeedViewModel.Input(addPhotoTapped: addPhotoButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        
    }
    override func setUpHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [addPhotoButton, imagesView, completeButton, contentTextView].forEach {
            contentView.addSubview($0)
        }
    }
    override func setUpLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        addPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(20)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            make.size.equalTo(64)
        }
        imagesView.snp.makeConstraints { make in
            make.top.equalTo(addPhotoButton.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(imagesView.snp.width)
        }
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(imagesView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(100)
        }
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(contentView).inset(16)
            make.height.equalTo(44)
            make.bottom.equalTo(contentView).offset(-44)
        }
        
    }
    override func setUpNavigationTitle() {
        navigationItem.title = "피드 등록하기"
    }
}

extension AddFeedViewController: PHPickerViewControllerDelegate {
    @objc private func openGallery() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        selectedImage(results)
    }
    //MARK: 비동기 트러블슈팅
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
}
