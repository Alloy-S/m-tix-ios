//
//  ViewControllerListBioskop.swift
//  PROYEK_IOS
//
//  Created by Alloysius Steven on 16/12/23.
//

import UIKit
import FirebaseFirestore

class ViewControllerListBioskop: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtered {
            return filteredBioskop.count
        } else {
            return arBioskop.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellListBioskop")! as! TableViewCellListBioskop
        if filtered {
            cell.namaBioskop.text = filteredBioskop[indexPath.row].nama
        } else {
            cell.namaBioskop.text = arBioskop[indexPath.row].nama
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedItem = Bioskop(bioskopId: "", alamat: "", nama: "", telp: "", movieId: [])
        if filtered {
            selectedItem = filteredBioskop[indexPath.row]
        } else {
            selectedItem = arBioskop[indexPath.row]
        }
        let detailVC = ViewControllerListJadwal(nibName: "ViewControllerListJadwal", bundle: nil)
        detailVC.idBioskop = selectedItem.bioskopId
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = tfSearch.text {
            filterData(text + string)
        }
        
        return true
    }
    
    func filterData(_ query: String) {
        filteredBioskop.removeAll()
        for i in 0...arBioskop.count-1 {
            if arBioskop[i].nama.lowercased().contains(query.lowercased()) {
                filteredBioskop.append(arBioskop[i])
            }
        }
        
        if filteredBioskop.isEmpty {
            filtered = false
        }
        tableView.reloadData()
        filtered = true
    }
    
    var filtered = false
    
    @IBAction func btnReload(_ sender: UIButton) {
        loadData()
    }
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tfSearch: UITextField!
    
    let db = Firestore.firestore()
    
    var arBioskop: [Bioskop] = []
    var filteredBioskop: [Bioskop] = []
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
            self.tfSearch?.delegate = self
            loadData()
            
        
    }
}
