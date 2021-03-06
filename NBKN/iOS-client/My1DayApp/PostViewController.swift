//
//  PostViewController.swift
//  My1DayApp
//
//  Created by 清 貴幸 on 2015/05/04.
//  Copyright (c) 2015年 VOYAGE GROUP, inc. All rights reserved.
//

import UIKit

protocol PostViewControllerDelagate : NSObjectProtocol {
    func postViewController(viewController : PostViewController, didTouchUpCloseButton: AnyObject)
}

class PostViewController: UIViewController {
    @IBOutlet weak private var messageTextView: UITextView!
    weak var delegate: PostViewControllerDelagate?
    @IBOutlet weak private var usernameTextField: UITextField!
    // Mission1-2 Storyboard から UITextField のインスタンス変数を追加
    
    var lastChar:String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameTextField.becomeFirstResponder()
    }
    
    // MARK: - IBAction
    
    @IBAction func didTouchUpCloseButton(sender: AnyObject) {
        self.messageTextView.resignFirstResponder()
        self.delegate?.postViewController(self, didTouchUpCloseButton: sender)
    }
    
    @IBAction func didTouchUpSendButton(sender: AnyObject) {
        self.messageTextView.resignFirstResponder()
        
        let message: String = self.messageTextView.text ?? ""
        let name: String = self.usernameTextField.text ?? ""
        // Mission1-2 UITextField のインスタンス変数から値を取得
        var firstChar = (message as NSString).substringToIndex(1)
        
        if firstChar == lastChar{
            // Mission1-2 posetMessage の第2引数に 任意の値を渡す
            APIRequest.postMessage(message, username: name) {
                [weak self] (data, response, error) -> Void in
                
                self?.delegate?.postViewController(self!, didTouchUpCloseButton: sender)
                
                if error != nil {
                    // TODO: エラー処理
                    println(error)
                    return
                }
                
                var decodeError: NSError?
                let responseBody: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &decodeError)
                if decodeError != nil{
                    println(decodeError)
                    return
                }
            }
        }
        else {
            var alert = UIAlertView()
            alert.title = "NG"
            alert.message = "NG"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
        
        
    }
}
