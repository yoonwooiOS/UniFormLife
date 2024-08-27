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
    private let sizes = Observable.just(["XS(85)","S(90)", "M(95)", "L(100)", "XL(105)", "XXL(110)"])
    private let conditions = Observable.just(["새 상품","거의 새것","중고 상품"])
    private let seasons = Observable.just(["01-02", "02-03", "03-04", "04-05", "05-06", "06-07", "07-08", "08-09", "09-10",
                                         "10-11", "11-12", "12-13", "13-14", "14-15", "15-16", "16-17", "17-18", "18-19",
                                         "19-20", "20-21", "21-22", "22-23", "23-24", "24-25"
])
    private let league = Observable.just(["프리미어리그", "라리가", "세리에A", "리그 1", "K 리그", "국가대표", "기타"])
    
    private let sizePickerView = UIPickerView()
    private let conditionPickerView = UIPickerView()
    private let seasonsPickerView = UIPickerView()
    private let leaguePickerview = UIPickerView()
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionView.leagueCollectionViewlayout()).then {
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
    private var images = BehaviorSubject<[UIImage]>(value: [UIImage(named: "addImages")!])
    private let disposeBag = DisposeBag()
    private let viewModel = AddPostViewModel()
    
    override func bind() {
        let input = AddPostViewModel.Input()
        let output = viewModel.transfrom(input: input)
        images.bind(to: collectionView.rx.items) { collectionView, index, image in
                let indexPath = IndexPath(item: index, section: 0)
                if index != 0 {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectPostImageCollectionViewCell.identifier, for: indexPath) as! SelectPostImageCollectionViewCell
                    cell.imageView.image = image
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoCollectionViewCell.identifier, for: indexPath) as! AddPhotoCollectionViewCell
                    return cell
                }
            }
            .disposed(by: disposeBag)
        contentTextView.rx.text
            .orEmpty
            .map { !$0.isEmpty }
            .bind(to: placeholderLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        sizes
            .bind(to: sizePickerView.rx.itemTitles) { _, item in
               return item
                
            }
            .disposed(by: disposeBag)
        
        sizePickerView.rx.modelSelected(String.self)
            .map { $0.first }
            .debug()
            .bind(to: sizeTextField.rx.text)
            .disposed(by: disposeBag)
    
        conditions
            .bind(to: conditionPickerView.rx.itemTitles) { _, item in
                return item
            }
            .disposed(by: disposeBag)
        
        conditionPickerView.rx.modelSelected(String.self)
            .map { $0.first }
            .debug()
            .bind(to: conditionTextField.rx.text)
            .disposed(by: disposeBag)
        
        seasons
            .bind(to: seasonsPickerView.rx.itemTitles) { _, item in
                return item
            }
            .disposed(by: disposeBag)
        
        seasonsPickerView.rx.modelSelected(String.self)
            .map { $0.first }
            .debug()
            .bind(to: seasonTextField.rx.text)
            .disposed(by: disposeBag)
        league
            .bind(to: leaguePickerview.rx.itemTitles) { _, item in
                return item
            }
            .disposed(by: disposeBag)
        leaguePickerview.rx.modelSelected(String.self)
            .map { $0.first }
            .debug()
            .bind(to: leagueTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func setUpHierarchy() {
        view.addSubview(scrollView)
//        view.addSubview(completeButton)
        contentTextView.addSubview(placeholderLabel)
        scrollView.addSubview(contentView)
        [collectionView, contentTextView, titleTextField, priceTextField, sizeTextField, conditionTextField, seasonTextField, leagueTextField].forEach {
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
            make.bottom.equalTo(contentView).offset(-24)
        }
//        completeButton.snp.makeConstraints { make in
//            make.horizontalEdges.equalTo(view).inset(16)
//            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
//            make.height.equalTo(50)
//        }
    }
    override func setUpNavigationTitle() {
        self.navigationItem.title = "유니폼 등록"
    }
    override func setUpNavigationItems() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.rightBarButtonItem = uploadButton
    }
}
