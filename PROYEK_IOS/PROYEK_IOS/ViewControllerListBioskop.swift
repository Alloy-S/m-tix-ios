//
//  ViewControllerListBioskop.swift
//  PROYEK_IOS
//
//  Created by Alloysius Steven on 16/12/23.
//

import UIKit
import FirebaseFirestore

class ViewControllerListBioskop: UIViewController {
    
    
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db.collection("Bioskop").getDocuments() { (querySnapshot, err)
            in
            if let err = err
            {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print(document.data())
                }
                
            }
            // Do any additional setup after loading the view.
            
            
            
            /*
             // MARK: - Navigation
             
             // In a storyboard-based application, you will often want to do a little preparation before navigation
             override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             // Get the new view controller using segue.destination.
             // Pass the selected object to the new view controller.
             }
             */
            
        }
    }
}
