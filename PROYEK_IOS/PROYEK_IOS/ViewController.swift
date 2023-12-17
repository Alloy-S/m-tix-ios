//
//  ViewController.swift
//  PROYEK_IOS
//
//  Created by Alloysius Steven on 15/12/23.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func detail(_ sender: UIButton) {
        let vc = ViewControllerDetailFilm(nibName: "ViewControllerDetailFilm", bundle: nil)
           vc.idFilm = "lsaFIZONK1QSfUD9bldh"
           navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func detailPage(_ sender: UIButton) {
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("hello")
    }


}

