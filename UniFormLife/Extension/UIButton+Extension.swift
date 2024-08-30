//
//  UIButton+Extension.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/29/24.
//

import UIKit
import Kingfisher

extension UIButton {
    //MARK: UIButton Kingfisher Image DownLaod Func
    func setDownloadToButtonImage(with urlString: String, for state: UIControl.State = .normal, placeholder: UIImage? = nil) {
        guard let url = URL(string: APIKey.baseURL + "v1/" + urlString) else {
            print("Invalid URL")
            return
        }
        
        let imageDownloadRequest = AnyModifier { request in
            var request = request
            request.setValue(UserDefaultsManeger.shared.token, forHTTPHeaderField: "Authorization")
            request.setValue(APIKey.key, forHTTPHeaderField: "SesacKey")
            return request
        }
        
        self.kf.setImage(with: url, for: state, placeholder: placeholder, options: [.requestModifier(imageDownloadRequest)])
    }
}
