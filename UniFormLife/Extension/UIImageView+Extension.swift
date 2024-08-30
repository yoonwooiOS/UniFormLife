//
//  UIImageView+Extension.swift
//  UniFormLife
//
//  Created by 김윤우 on 8/29/24.
//

import UIKit
import Kingfisher

extension UIImageView {
    //MARK: ImageView Kingfisher Image DownLaod Func
    func setDownloadToImageView(urlString: String, placeholder: UIImage? = nil) {
        guard let url = URL(string: APIKey.baseURL + "v1/" + urlString) else {
            print("Invalid URL")
            print("Invalid URL: \(APIKey.baseURL + "v1/" + urlString)")
            
            return
        }
        
        let imageDownloadRequest = AnyModifier { request in
            var request = request
            request.setValue(UserDefaultsManeger.shared.token, forHTTPHeaderField: "Authorization")
            request.setValue(APIKey.key, forHTTPHeaderField: "SesacKey")
            return request
        }
        
        self.kf.setImage(with: url, placeholder: placeholder, options: [.requestModifier(imageDownloadRequest)])
    }
    
}
