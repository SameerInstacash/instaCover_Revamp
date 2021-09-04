//
//  EntryNavigationVC.swift
//  InstaCover
//
//  Created by Sameer Khan on 05/08/21.
//

import UIKit

class EntryNavigationVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setStatusBarGradientColor()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
