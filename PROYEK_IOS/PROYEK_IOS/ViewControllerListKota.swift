import UIKit
import FirebaseFirestore

protocol sendCity {
    func relaodCity(kota : String)
}
class ViewControllerListKota: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arKota.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellListKota")! as! TableViewCellListKota
        cell.labelKota.text = arKota[indexPath.row].nama
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if mode == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewControllerListBioskop") as! ViewControllerListBioskop
            let selectedItem = arKota[indexPath.row]
            vc.idKota = selectedItem.nama
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewControllerMovieListBioskop") as! ViewControllerMovieListBioskop
            let selectedItem = arKota[indexPath.row]
            vc.idKota = selectedItem.nama
            vc.nama_film = namaMovie
            vc.movieID = movieID
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    let db = Firestore.firestore()
    
    var kotaID = ""
    var movieID = ""
    var mode = 0
    var namaMovie = ""
    var arKota: [Kota] = []
    
    func loadData() {
        db.collection("Kota").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.arKota.removeAll()
                self.tableView.reloadData()
                for document in querySnapshot!.documents {
                    print(document.data())
                    let readData = document.data()
                    let bioskopId = document.documentID // Get the document ID
                    if let nama = readData["nama"] as? String {
                        let kota = Kota(bioskopId: bioskopId, nama: nama) // Use document ID here
                        self.arKota.append(kota)
                    }
                }
                self.arKota.sort(by: {$0.nama < $1.nama})
                self.tableView.reloadData()
            }
        }
    }

    
}
