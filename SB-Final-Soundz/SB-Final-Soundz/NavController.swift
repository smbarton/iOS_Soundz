//
//  NavController.swift
//  SB-Final-Soundz
//
//  Created by Shane on 11/19/16.
//  Copyright © 2016 ssd. All rights reserved.
//

import UIKit

class ViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .darkGray
        
        self.isToolbarHidden = false
        
        let vc1 = ViewControllerMenu()
        //let vc2 = ViewController2()
        //let vc3 = ViewController3()
        
        self.setViewControllers([vc1], animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
