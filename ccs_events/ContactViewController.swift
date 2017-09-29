//
//  ContactViewController.swift
//  ccs_events
//
//  Created by Amir Nazari on 11/6/16.
//  Copyright © 2016 Amir Nazari. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet weak var daScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBarController?.tabBar.isTranslucent = false
        daScrollView.contentSize.height = 1251
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UserDefaults.standard.set(false, forKey: "badgeUpdate")
        UserDefaults.standard.set(false, forKey: "notificationBadgeUpdate")
    }
    
    @IBAction func socialLinkTapped(_ sender: UIButton) {
        var urlString = ""
        var secondaryString = ""
        let alert = UIAlertController.alert(withTitle: "Error", message: "Error al Cargar el Vínculo Social", actions: [], alertType: .alert)
        
        switch sender.tag {
        case 0:
            urlString = Constants.facebookSocialLink
            secondaryString = Constants.facebookSocialWebLink
            break
        case 1:
            urlString = Constants.twitterSocialLink
            secondaryString = Constants.twitterSocialWebLink
            break
        default:
            break
        }
        
        guard let url = URL.init(string:urlString) else {
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if #available(iOS 10.0, *) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                guard let webURL = URL.init(string: secondaryString) else {
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
            }
        } else {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            } else {
                guard let webURL = URL.init(string: secondaryString) else {
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                UIApplication.shared.openURL(webURL)
            }
        }
    }
}
