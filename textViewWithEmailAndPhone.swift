//  Created by yash bedi on 09/05/17.
//  Copyright © 2017 yash bedi. All rights reserved
//    textViewWithEmailAndPhone.swift
import UIKit
import MessageUI

class ViewController: UITextViewDelegate, MFMailComposeViewControllerDelegate{
  
    @IBOutlet weak var infoTextView: UITextView!
    var email = "yourEmail@domain.com"
    var phoneNumber = "3545988995"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addInfoToTextView()
    }
    
    func addInfoToTextView()  {
        let attributedString = NSMutableAttributedString(string: "For further info call us on : \(phoneNumber)\nor mail us at : \(email)")
        attributedString.addAttribute(NSLinkAttributeName, value: "tel://", range: NSRange(location: 30, length: 10))
        attributedString.addAttribute(NSLinkAttributeName, value: "mailto:", range: NSRange(location: 57, length: 18))
        self.infoTextView.attributedText = attributedString
        self.infoTextView.linkTextAttributes = [NSForegroundColorAttributeName:UIColor.blue, NSUnderlineStyleAttributeName:NSNumber(value: 0)]
        self.infoTextView.textColor = .white
        self.infoTextView.textAlignment = .center
        self.infoTextView.isEditable = false
        self.infoTextView.dataDetectorTypes = UIDataDetectorTypes.all
        self.infoTextView.delegate = self
    }
    
    @available(iOS, deprecated: 10.0)
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange) -> Bool {
        if (url.scheme?.contains("mailto"))! && characterRange.location > 55{
            openMFMail()
        }
        if (url.scheme?.contains("tel"))! && (characterRange.location > 29 && characterRange.location < 39){
            callNumber()
        }
        return false
    }
    
    //For iOS 10
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if (url.scheme?.contains("mailto"))! && characterRange.location > 55{
            openMFMail()
        }
        if (url.scheme?.contains("tel"))! && (characterRange.location > 29 && characterRange.location < 39){
            callNumber()
        }
        return false
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure: \(String(describing: error?.localizedDescription))")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func callNumber() {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)")
        {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL))
            {
                let alert = UIAlertController(title: "Call", message: "\(phoneNumber)", preferredStyle: UIAlertControllerStyle.alert)
                if #available(iOS 10.0, *)
                {
                    alert.addAction(UIAlertAction(title: "Call", style: .cancel, handler: { (UIAlertAction) in
                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                    }))
                }
                else
                {
                    alert.addAction(UIAlertAction(title: "Call", style: .cancel, handler: { (UIAlertAction) in
                        application.openURL(phoneCallURL)
                    }))
                }
                
                alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            self.showAlert("Couldn't", message: "Call, cannot open Phone Screen")
        }
    }
  
  func openMFMail(){
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["\(email)"])
        mailComposer.setSubject("Subject..")
        mailComposer.setMessageBody("Please share your problem.", isHTML: false)
        present(mailComposer, animated: true, completion: nil)
    }
  
}
