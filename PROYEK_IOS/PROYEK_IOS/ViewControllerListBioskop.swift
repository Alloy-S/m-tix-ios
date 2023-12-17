//
//  ViewControllerListBioskop.swift
//  PROYEK_IOS
//
//  Created by Alloysius Steven on 16/12/23.
//

import UIKit
import FirebaseFirestore

class ViewControllerListBioskop: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arBioskop.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellListBioskop")! as! TableViewCellListBioskop
        cell.namaBioskop.text = arBioskop[indexPath.row].nama
        
        return cell
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    
    var arBioskop: [Bioskop] = []
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
        db.collection("Bioskop").getDocuments() { (querySnapshot, err)
            in
            if let err = err
            {
                print("Error getting documents: \(err)")
            } else {
                self.arBioskop.removeAll()
                for document in querySnapshot!.documents {
                    print(document.data())
                    let readData = document.data()
                    
                    if let nama = readData["nama"] as? String,
                       let alamat = readData["alamat"] as? String,
                       let telp = readData["telp"] as? String,
                       let movieId = readData["movieId"] as? [String] {
                        let bioskop = Bioskop(alamat: alamat, nama: nama, telp: telp, movieId: movieId)
                        self.arBioskop.append(bioskop)
                    }
                }
                self.tableView.reloadData()
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
