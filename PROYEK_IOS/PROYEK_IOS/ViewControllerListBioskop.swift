import UIKit
import FirebaseFirestore

class ViewControllerListBioskop: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var cityButton: UIButton!
    
    let db = Firestore.firestore()
    var arBioskop: [Bioskop] = []
    var filteredBioskop: [Bioskop] = []
    var arBioskopCity: [Bioskop] = [] // Array to store bioskops for the selected city
    var filtered = false
    var idKota: String = "SURABAYA"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfSearch?.delegate = self
        loadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered ? filteredBioskop.count : arBioskopCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellListBioskop", for: indexPath) as! TableViewCellListBioskop
        
        if filtered {
            cell.namaBioskop.text = filteredBioskop[indexPath.row].nama
        } else {
            cell.namaBioskop.text = arBioskopCity[indexPath.row].nama
        }
        cityButton.setTitle(idKota, for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewControllerListJadwal") as! ViewControllerListJadwal
            let selectedItem = arBioskop[indexPath.row]
            vc.idBioskop = selectedItem.bioskopId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    
    func loadData() {
        db.collection("Bioskop").getDocuments() { [weak self] (querySnapshot, err) in
            guard let self = self else { return }
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.arBioskop.removeAll()
                self.arBioskopCity.removeAll() // Clear the city-specific array
                self.tableView.reloadData()
                
                for document in querySnapshot!.documents {
                    let readData = document.data()
                    let bioskopId = document.documentID
                    
                    if let nama = readData["nama"] as? String,
                       let alamat = readData["alamat"] as? String,
                       let telp = readData["telp"] as? String,
                       let kota = readData["kota"] as? String,
                       let movieId = readData["movieId"] as? [String] {
                        
                        let bioskop = Bioskop(bioskopId: bioskopId, alamat: alamat, nama: nama, telp: telp, kota: kota, movieId: movieId)
                        
                        self.arBioskop.append(bioskop)
                        
                        if kota == self.idKota {
                            self.arBioskopCity.append(bioskop)
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = tfSearch.text {
            filterData(text + string)
        }
        return true
    }
    
    func filterData(_ query: String) {
        filteredBioskop.removeAll()
        
        for i in 0..<arBioskopCity.count {
            if arBioskopCity[i].nama.lowercased().contains(query.lowercased()) {
                filteredBioskop.append(arBioskopCity[i])
                filtered = true
            }
        }
        
        if filteredBioskop.isEmpty {
            filtered = false
        }
        
        tableView.reloadData()
        filtered = false
    }
    
    @IBAction func btnKota(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewControllerListKota") as! ViewControllerListKota
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
}
