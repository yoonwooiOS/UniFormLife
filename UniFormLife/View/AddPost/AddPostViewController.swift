//
//  AddPostViewController.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/16/24.
//

import UIKit
import PhotosUI
import SnapKit

class AddPostViewController: BaseViewController, PHPickerViewControllerDelegate {
   
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목을 입력하세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        return textView
    }()
    
    private lazy var galleryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("갤러리에서 선택", for: .normal)
        button.addTarget(self, action: #selector(openGallery), for: .touchUpInside)
        return button
    }()
    
    private let imageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let imageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let imageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let memoTextField1: UITextField = {
        let textField = UITextField()
        textField.placeholder = "메모 1"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let memoTextField2: UITextField = {
        let textField = UITextField()
        textField.placeholder = "메모 2"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private var selectedImageViews: [UIImageView] = []
    
    override func setUpHierarchy() {
        [titleTextField, contentTextView, galleryButton, imageView1, imageView2, imageView3, memoTextField1, memoTextField2].forEach { view.addSubview($0) }
    }
    override func setUpLayout() {
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }
        
        galleryButton.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        imageView1.snp.makeConstraints { make in
            make.top.equalTo(galleryButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo((view.bounds.width - 60) / 3)
            make.height.equalTo(100)
        }
        
        imageView2.snp.makeConstraints { make in
            make.top.equalTo(imageView1)
            make.leading.equalTo(imageView1.snp.trailing).offset(10)
            make.width.height.equalTo(imageView1)
        }
        
        imageView3.snp.makeConstraints { make in
            make.top.equalTo(imageView1)
            make.leading.equalTo(imageView2.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(imageView1)
        }
        
        memoTextField1.snp.makeConstraints { make in
            make.top.equalTo(imageView1.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        memoTextField2.snp.makeConstraints { make in
            make.top.equalTo(memoTextField1.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }
    
    @objc private func openGallery() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 3
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        selectedImageViews = [imageView1, imageView2, imageView3]
        
        for (index, result) in results.enumerated() {
            guard index < 3 else { break }
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self?.selectedImageViews[index].image = image
                    }
                }
            }
        }
    }
}
