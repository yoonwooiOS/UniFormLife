//
//  AddPostViewController.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/16/24.
//

import UIKit
import PhotosUI
import SnapKit
import RxSwift
import RxCocoa

class AddPostViewController: BaseViewController  {
   
    private let images = BehaviorSubject<[UIImage?]>(value: [nil])
    private let selectedImages = PublishSubject<[UIImage?]>()
    private let imageView1 = UIImageView()
    private let imageView2 = UIImageView()
    private let imageView3 = UIImageView()
    
    private let sizePickerView = UIPickerView()
    private let conditionPickerView = UIPickerView()
    private let seasonsPickerView = UIPickerView()
    private let leaguePickerview = UIPickerView()
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionView.addPhotoLayout()).then {
        $0.register(SelectPostImageCollectionViewCell.self, forCellWithReuseIdentifier: SelectPostImageCollectionViewCell.identifier)
        $0.register(AddPhotoCollectionViewCell.self, forCellWithReuseIdentifier: AddPhotoCollectionViewCell.identifier)
    }
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    private let contentView = UIView()
    private let titleTextField = RoundRectTextField("제목",inputView: nil)
    private let contentTextView = UITextView().then {
        $0.font = Font.regular16
        $0.textColor = .black
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 5.0
        $0.isScrollEnabled = true
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    private let placeholderLabel = UILabel().then {
        $0.text = "내용을 입력하세요"
        $0.textColor = UIColor.lightGray
    }
    private let priceTextField = RoundRectTextField("가격",inputView: nil).then {
        $0.keyboardType = .numberPad
    }
    private lazy var sizeTextField = RoundRectTextField("사이즈", inputView: sizePickerView)
    private lazy var conditionTextField = RoundRectTextField("상품 상태", inputView: conditionPickerView)
    private lazy var seasonTextField = RoundRectTextField("시즌", inputView: seasonsPickerView)
    private lazy var leagueTextField = RoundRectTextField("리그", inputView: leaguePickerview)
    private let uploadButton = UIBarButtonItem(title: "등록", style: .plain, target: nil, action: nil).then {
        $0.tintColor = Color.black
    }
    private let completeButton = UIButton().then {
        $0.setTitle("작성 완료", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.systemBlue
        $0.layer.cornerRadius = 5.0
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = AddPostViewModel()
    
    override func bind() {
        let addPhotoTapped = collectionView.rx.itemSelected
            .filter { $0.row == 0 }
            .map { _ in }
        let sizeSelected = sizePickerView.rx.modelSelected(String.self)
               .map { $0.first ?? "" }
              
           let conditionSelected = conditionPickerView.rx.modelSelected(String.self)
               .map { $0.first ?? "" }
              
           let seasonSelected = seasonsPickerView.rx.modelSelected(String.self)
               .map { $0.first ?? "" }
              
           let leagueSelected = leaguePickerview.rx.modelSelected(String.self)
               .map { $0.first ?? "" }
              
        let input = AddPostViewModel.Input(
            addPhotoTapped: addPhotoTapped,
            selectedImages: selectedImages,
            title: titleTextField.rx.text.orEmpty,
            content: contentTextView.rx.text.orEmpty,
            price: priceTextField.rx.text.orEmpty,
            sizeSelected: sizeSelected,
            conditionSelected: conditionSelected,
            seasonSelected: seasonSelected,
            leagueSelected: leagueSelected,
            completeButtonTapped: completeButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        output.images
            .bind(to: collectionView.rx.items) { collectionView, index, image in
                let indexPath = IndexPath(item: index, section: 0)
                if index == 0 {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoCollectionViewCell.identifier, for: indexPath) as! AddPhotoCollectionViewCell
                    output.selectedImagesCount
                        .bind { count in
                            cell.setUpCell(count)
                        }
                        .disposed(by: self.disposeBag)
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectPostImageCollectionViewCell.identifier, for: indexPath) as! SelectPostImageCollectionViewCell
                    guard let image else { return cell }
                    cell.setupCell(image: image, index: index)
                    return cell
                }
            }
            .disposed(by: disposeBag) 
        collectionView.rx.itemSelected
            .filter { $0.row != 0 }
            .withLatestFrom(output.images) { indexPath, images in
                (indexPath.row - 1, images.filter { $0 != nil })
            }
            .map { index, images -> [UIImage?] in
                var updatedImages = images
                updatedImages.remove(at: index)
                return [nil] + updatedImages
            }
            .bind(to: viewModel.imageArray)
            .disposed(by: disposeBag)
        
        input.addPhotoTapped
            .subscribe(onNext: { [weak self] in
                self?.openGallery()
            })
            .disposed(by: disposeBag)
       
        contentTextView.rx.text
            .orEmpty
            .map { !$0.isEmpty }
            .bind(to: placeholderLabel.rx.isHidden)
            .disposed(by: disposeBag)
        output.sizePickerData
               .bind(to: sizePickerView.rx.itemTitles) { _, item in item }
               .disposed(by: disposeBag)

           output.conditionPickerData
               .bind(to: conditionPickerView.rx.itemTitles) { _, item in item }
               .disposed(by: disposeBag)

           output.seasonPickerData
               .bind(to: seasonsPickerView.rx.itemTitles) { _, item in item }
               .disposed(by: disposeBag)

           output.leaguePickerData
               .bind(to: leaguePickerview.rx.itemTitles) { _, item in item }
               .disposed(by: disposeBag)
           sizeSelected
               .bind(to: sizeTextField.rx.text)
               .disposed(by: disposeBag)
           conditionSelected
               .bind(to: conditionTextField.rx.text)
               .disposed(by: disposeBag)
           seasonSelected
               .bind(to: seasonTextField.rx.text)
               .disposed(by: disposeBag)
           
           leagueSelected
               .bind(to: leagueTextField.rx.text)
               .disposed(by: disposeBag)
           output.isPlaceholderHidden
               .bind(to: placeholderLabel.rx.isHidden)
               .disposed(by: disposeBag)
           completeButton.rx.tap
               .subscribe(onNext: {
                   print("버튼탭")
               })
               .disposed(by: disposeBag)
    }
    
    override func setUpHierarchy() {
        view.addSubview(scrollView)
        contentTextView.addSubview(placeholderLabel)
        scrollView.addSubview(contentView)
        [collectionView, contentTextView, titleTextField, priceTextField, sizeTextField, conditionTextField, seasonTextField, leagueTextField,completeButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setUpLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide )
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.horizontalEdges.equalTo(contentView).inset(12)
            make.height.equalTo(80)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(44)
        }
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(16)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(300)
        }
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.textContainerInset.top)
            make.leading.equalTo(contentTextView.textContainerInset.left + 5)
        }
        priceTextField.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(44)
        }
        
        sizeTextField.snp.makeConstraints { make in
            make.top.equalTo(priceTextField.snp.bottom).offset(16)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(44)
        }
        
        conditionTextField.snp.makeConstraints { make in
            make.top.equalTo(sizeTextField.snp.bottom).offset(16)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(44)
        }
        seasonTextField.snp.makeConstraints { make in
            make.top.equalTo(conditionTextField.snp.bottom).offset(16)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(44)
        }
        leagueTextField.snp.makeConstraints { make in
            make.top.equalTo(seasonTextField.snp.bottom).offset(16)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(44)
        }
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(leagueTextField.snp.bottom).offset(16)
            make.leading.trailing.equalTo(contentView).inset(16)
            make.height.equalTo(44)
            make.bottom.equalTo(contentView).offset(-24)
        }
    }
    
    override func setUpNavigationTitle() {
        self.navigationItem.title = "유니폼 등록"
    }
}

extension AddPostViewController: PHPickerViewControllerDelegate {
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
        handlePickedResults(results)
    }
    
    private func handlePickedResults(_ results: [PHPickerResult]) {
        var selectedImages = [UIImage]()
        let dispatchGroup = DispatchGroup()
        
        for result in results {
            dispatchGroup.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                defer { dispatchGroup.leave() }
                guard let self = self else { return }
                if let image = object as? UIImage {
                    selectedImages.append(image)
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.selectedImages.onNext(selectedImages)
        }
    }
}
