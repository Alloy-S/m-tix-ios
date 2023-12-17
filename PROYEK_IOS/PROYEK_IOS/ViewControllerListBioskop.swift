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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = arBioskop[indexPath.row]
        let detailVC = ViewControllerListJadwal(nibName: "ViewControllerListJadwal", bundle: nil)
        detailVC.idBioskop = selectedItem.bioskopId
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    
    @IBAction func btnReload(_ sender: UIButton) {
        loadData()
    }
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    
    var arBioskop: [Bioskop] = []
    
    func loadData() {
        db.collection("Bioskop").getDocuments() { (querySnapshot, err)
            in
            if let err = err
            {
                print("Error getting documents: \(err)")
            } else {
                self.arBioskop.removeAll()
                self.tableView.reloadData()
                for document in querySnapshot!.documents {
                    print(document.data())
                    let readData = document.data()
                    let bioskopId = document.documentID
                    if let nama = readData["nama"] as? String,
                       let alamat = readData["alamat"] as? String,
                       let telp = readData["telp"] as? String,
                       let movieId = readData["movieId"] as? [String] {
                        let bioskop = Bioskop(bioskopId : bioskopId, alamat: alamat, nama: nama, telp: telp, movieId: movieId)
                        self.arBioskop.append(bioskop)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        navigationController?.navigationBar
//        tableView.delegate = self
//        tableView.dataSource = self
        
            // Do any additional setup after loading the view.
            
            loadData()
            
        
    }
}
