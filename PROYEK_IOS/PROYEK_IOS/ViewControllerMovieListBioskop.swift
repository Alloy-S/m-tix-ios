//
//  ViewControllerMovieListBioskop.swift
//  PROYEK_IOS
//
//  Created by Alloysius Steven on 17/12/23.
//

import UIKit
import FirebaseFirestore

class ViewControllerMovieListBioskop: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arBioskop.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMovieListBioskop")! as! MovieListBioskopCell
        
        cell.namaTheater.text = arBioskop[indexPath.row].nama
        
        return cell
    }
    
    let db = Firestore.firestore()
    
    var arBioskop: [Bioskop] = []

    @IBAction func BtnLocation(_ sender: UIButton) {
    }
    @IBOutlet weak var judulMovie: UILabel!
    
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var btnLocationLabel: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var movieID = ""
    var nama_film = ""
    
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
                       let movieId = readData["movieId"] as? [String] {
                        let compare = "wrkahrffa"
                        for item in movieId {
                            if item == movieID {
                                let bioskop = Bioskop(bioskopId: bioskopId, alamat: alamat, nama: nama, telp: telp, movieId: movieId)
                                self.arBioskop.append(bioskop)
                                break
                            }
                        }
                            
                        
                        
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        judulMovie.text = nama_film
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
