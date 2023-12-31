//
//  ViewControllerMovieListBioskop.swift
//  PROYEK_IOS
//
//  Created by Alloysius Steven on 17/12/23.
//

import UIKit
import FirebaseFirestore

class ViewControllerMovieListBioskop: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtered {
            print("filtered")
            return filteredBioskop.count
        } else {
            print("origin")
            return arBioskop.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMovieListBioskop")! as! MovieListBioskopCell
        
        if filtered {
            cell.namaTheater.text = filteredBioskop[indexPath.row].nama
        } else {
            cell.namaTheater.text = arBioskop[indexPath.row].nama
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewControllerListJadwal2") as! ViewControllerListJadwal2
        var selectedItem = Bioskop(bioskopId: "", alamat: "", nama: "", telp: "", kota: "", movieId: [])
        
        if filtered {
            selectedItem = filteredBioskop[indexPath.row]
        } else {
            selectedItem = arBioskop[indexPath.row]
        }
        vc.idBioskop = selectedItem.bioskopId
        vc.idMovieFix = self.movieID
        
//        print("pass id bioskop : \(selectedItem.bioskopId)")
//        print("pass id movie : \(self.movieID)")
        self.navigationController?.pushViewController(vc, animated: true)
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
                filtered = true
            }
        }
        
        if filteredBioskop.isEmpty {
            filtered = false
        }
//        print(query + "----")
//        if query == "" {
//            filtered = false
//        }
        
        tableView.reloadData()
        filtered = false
    }
    
    var filtered = false
    
    let db = Firestore.firestore()
    
    var arBioskop: [Bioskop] = []
    var filteredBioskop : [Bioskop] = []

    @IBAction func BtnLocation(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewControllerListKota") as! ViewControllerListKota
        vc.mode = 1
        vc.namaMovie = nama_film
        vc.movieID = movieID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBOutlet weak var judulMovie: UILabel!
    
    @IBAction func btnRefresh(_ sender: UIButton) {
        loadData(movieID)
    }
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var btnLocationLabel: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var movieID = ""
    var nama_film = ""
    var idKota = "SURABAYA"
    
    func loadData(_ movieID: String) {
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
                    
                    if let bioskopId = document.documentID as? String, let nama = readData["nama"] as? String,
                       let alamat = readData["alamat"] as? String,
                       let telp = readData["telp"] as? String,
                       let kota = readData["kota"] as? String,
                       let movieId = readData["movieId"] as? [String] {
                        for item in movieId {
                            if item == movieID && kota == self.idKota {
                                let bioskop = Bioskop(bioskopId: bioskopId, alamat: alamat, nama: nama, telp: telp, kota: kota, movieId: movieId)
                                self.arBioskop.append(bioskop)
                                break
                            }
                        }
                    }
                }
                self.arBioskop.sort(by: {$0.nama < $1.nama})
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfSearch?.delegate = self
        judulMovie.text = nama_film
        btnLocationLabel.setTitle(idKota, for: .normal)
        print(idKota)
        print(nama_film)
        loadData(movieID)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
