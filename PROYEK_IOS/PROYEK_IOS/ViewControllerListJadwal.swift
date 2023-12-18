//
//  ViewControllerListJadwal.swift
//  PROYEK_IOS
//
//  Created by Jessy Marcelyn on 17/12/23.
//
import UIKit
import Firebase
import FirebaseFirestore
class ViewControllerListJadwal: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var namaBioskop: UILabel!
    @IBOutlet weak var alamatBioskop: UILabel!
    @IBOutlet weak var telpBioskop: UILabel!
    
    @IBOutlet weak var tableFilm: UITableView!
    
    
    //    var idBioskop = "rtAY13M2eVEWdgNJyOCp"
    var idBioskop :String = ""
    var listIdFilm: [String] = []
    var listJam: [String] = []
    
    var db: Firestore!
    
    var todayTimestamp: Timestamp {
        let currentDate = Date()
        return Timestamp(date: currentDate)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listIdFilm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellJadwal1")! as! TableViewCellListJadwal
        let idFilmIndex = indexPath.row
        let idFilm = self.listIdFilm[idFilmIndex]
        guard idFilmIndex < self.listIdFilm.count else {
            return cell
        }
        db.collection("Movie").document(idFilm).getDocument { (movieDocument, movieError) in
            guard let movieDocument = movieDocument, movieDocument.exists, let movieData = movieDocument.data() else {
                print("Error getting Movie document: \(String(describing: movieError))")
                return
            }
            print("ID FILM KAK : \(idFilm)")
            print("Doc id KAK : \(movieDocument.documentID)")
            self.db.collection("JamTayang")
                .whereField("bioskopId", isEqualTo: self.idBioskop)
                .whereField("movieId", isEqualTo: idFilm)
                .getDocuments { (jamTayangSnapshot, jamTayangError) in
                    guard let jamTayangDocuments = jamTayangSnapshot?.documents, jamTayangError == nil else {
                        print("Error getting JamTayang documents: \(String(describing: jamTayangError))")
                        return
                    }
                    if let jamTayangDocument = jamTayangDocuments.first {
                        let jamTayangData = jamTayangDocument.data()
                        print("movieId: \(idFilm)")
                        print("idjamtayang : \(jamTayangDocument.documentID)")
                        if let status = movieData["status"] as? String {
                            if (status == "UpComing") {
                                print("masuk12")
                                if let timestamp = jamTayangData["tanggalTayang"] as? Timestamp,
                                   let timestampRilis = movieData["tanggalRilis"] as? Timestamp {
                                    let dateTayang = timestamp.dateValue()
                                    let calendar = Calendar.current
                                    if calendar.isDate(dateTayang, inSameDayAs: timestampRilis.dateValue()) {
                                        if let harga = jamTayangData["harga"] as? Int {
                                            let formattedHarga = self.formatHarga(harga)
                                            cell.hargaFilm.text = formattedHarga
                                        } else if let harga = jamTayangData["harga"] as? NSNumber {
                                            let formattedHarga = self.formatHarga(harga.intValue)
                                            cell.hargaFilm.text = formattedHarga
                                        } else {
                                            cell.hargaFilm.text = "N/A"
                                        }
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "dd-MM-yyyy"
                                        cell.tanggalFilm.text = dateFormatter.string(from: dateTayang)
                                        if let jam = jamTayangData["jamTayang"] as? [String] {
                                            self.listJam.append(contentsOf: jam)
                                            // Tampilan untuk jam tayang
                                            cell.jamFilm.subviews.forEach { $0.removeFromSuperview() }
                                            var xOffset: CGFloat = 0
                                            var yOffset: CGFloat = 0
                                            let labelHeight: CGFloat = 30
                                            let labelSpacing: CGFloat = 5
                                            for timeSlot in self.listJam {
                                                let label = UILabel()
                                                label.text = timeSlot
                                                label.textAlignment = .center
                                                label.backgroundColor = UIColor.lightGray
                                                label.textColor = UIColor.white
                                                label.layer.cornerRadius = labelHeight / 2
                                                label.clipsToBounds = true
                                                label.numberOfLines = 0 // Allow multiple lines
                                                let labelWidth = (timeSlot as NSString).size(withAttributes: [NSAttributedString.Key.font: label.font!]).width + 20
                                                if xOffset + labelWidth > tableView.bounds.width - 20 {
                                                    xOffset = 0
                                                    yOffset += labelHeight + labelSpacing
                                                }
                                                label.frame = CGRect(x: xOffset, y: yOffset, width: labelWidth, height: labelHeight)
                                                xOffset += labelWidth + labelSpacing
                                                cell.jamFilm.addSubview(label)
                                            }
                                            cell.jamFilm.frame.size.height = yOffset + labelHeight
                                            cell.jamFilm.layoutIfNeeded()
                                        }
                                        self.listJam = []
                                        cell.jamFilm.frame.size.height = 0
                                        let idFilm = self.listIdFilm[idFilmIndex]
                                        self.db.collection("Movie").document(idFilm).getDocument { (document, error) in
                                            guard let document = document, document.exists, let data = document.data() else {
                                                print("Error getting document: \(String(describing: error))")
                                                return
                                            }
                                            cell.namaFilm.text = data["nama"] as? String ?? ""
                                            cell.dimensiFilm.text = data["dimensi"] as? String ?? ""
                                            if let imageData = data["image"] as? String {
                                                cell.imageFilm.image = UIImage(named: imageData)
                                            } else {
                                                cell.imageFilm.image = UIImage(named: "placeholder_image")
                                            }
                                            if let durasi = data["durasi"] as? Int {
                                                cell.durasiFilm.text = String(durasi) + " minutes"
                                            } else if let durasi = data["durasi"] as? NSNumber {
                                                cell.durasiFilm.text = durasi.isEqual(to: durasi.intValue as NSNumber) ? "\(durasi.intValue)" : "\(durasi.doubleValue)"
                                            } else {
                                                cell.durasiFilm.text = "N/A"
                                            }
                                            cell.ratingFilm.text = data["rate"] as? String ?? ""
                                        }
                                    }
                                }
                            } else if(status == "NowPlaying"){
                                print("masuk13")
                                if let timestamp = jamTayangData["tanggalTayang"] as? Timestamp {
                                    let date = timestamp.dateValue()
                                    let calendar = Calendar.current
                                    if calendar.isDate(date, inSameDayAs: self.todayTimestamp.dateValue()) {
                                        if let harga = jamTayangData["harga"] as? Int {
                                            let formattedHarga = self.formatHarga(harga)
                                            cell.hargaFilm.text = formattedHarga
                                        } else if let harga = jamTayangData["harga"] as? NSNumber {
                                            let formattedHarga = self.formatHarga(harga.intValue)
                                            cell.hargaFilm.text = formattedHarga
                                        } else {
                                            cell.hargaFilm.text = "N/A"
                                        }
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "dd-MM-yyyy" // Corrected date format
                                        cell.tanggalFilm.text = dateFormatter.string(from: date)
                                        if let jam = jamTayangData["jamTayang"] as? [String] {
                                            self.listJam.append(contentsOf: jam)
//                                            self.tableFilm.reloadData()
                                            // Tampilan untuk jam tayang
                                            cell.jamFilm.subviews.forEach { $0.removeFromSuperview() }
                                            var xOffset: CGFloat = 0
                                            var yOffset: CGFloat = 0
                                            let labelHeight: CGFloat = 30
                                            let labelSpacing: CGFloat = 5
                                            for timeSlot in self.listJam {
                                                let label = UILabel()
                                                label.text = timeSlot
                                                label.textAlignment = .center
                                                label.backgroundColor = UIColor.lightGray
                                                label.textColor = UIColor.white
                                                label.layer.cornerRadius = labelHeight / 2
                                                label.clipsToBounds = true
                                                let labelWidth = (timeSlot as NSString).size(withAttributes: [NSAttributedString.Key.font: label.font!]).width + 20
                                                if xOffset + labelWidth > tableView.bounds.width - 20 {
                                                    xOffset = 0
                                                    yOffset += labelHeight + labelSpacing
                                                }
                                                label.frame = CGRect(x: xOffset, y: yOffset, width: labelWidth, height: labelHeight)
                                                xOffset += labelWidth + labelSpacing
                                                cell.jamFilm.addSubview(label)
                                            }
                                            self.listJam = []
                                            // Adjust the height of jamFilm to accommodate the labels
                                            cell.jamFilm.frame.size.height = yOffset + labelHeight
                                            cell.jamFilm.layoutIfNeeded()
                                        }
                                        let idFilm = self.listIdFilm[idFilmIndex]
                                        self.db.collection("Movie").document(idFilm).getDocument { (document, error) in
                                            guard let document = document, document.exists, let data = document.data() else {
                                                print("Error getting document: \(String(describing: error))")
                                                return
                                            }
                                            if let imageData = data["image"] as? String {
                                                cell.imageFilm.image = UIImage(named: imageData)
                                            } else {
                                                cell.imageFilm.image = UIImage(named: "placeholder_image")
                                            }
                                            cell.namaFilm.text = data["nama"] as? String ?? ""
                                            cell.dimensiFilm.text = data["dimensi"] as? String ?? ""
                                            if let durasi = data["durasi"] as? Int {
                                                cell.durasiFilm.text = String(durasi) + " minutes"
                                            } else if let durasi = data["durasi"] as? NSNumber {
                                                cell.durasiFilm.text = durasi.isEqual(to: durasi.intValue as NSNumber) ? "\(durasi.intValue)" : "\(durasi.doubleValue)"
                                            } else {
                                                cell.durasiFilm.text = "N/A"
                                            }
                                            cell.ratingFilm.text = data["rate"] as? String ?? ""
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
        }
        return cell
    }
    
    
    // buat atur tinggi masing2 cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330.0
    }
    
    
    func formatHarga(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "id_ID") // Set the locale to Indonesian
        
        if let formattedAmount = formatter.string(from: NSNumber(value: amount)) {
            return formattedAmount
        } else {
            return "N/A"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableFilm.delegate = self
        tableFilm.dataSource = self
        
        db = Firestore.firestore()
        db.collection("Bioskop").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    // Access data from the document
                    
                    let idBioskopp = document.documentID
                    
                    print("IDBIOSKOPP = \(self.idBioskop)")
                    print("IDBIOSKOPP2 = \(idBioskopp)")
                    if(idBioskopp == self.idBioskop){
                        let data = document.data()
                        
                        self.namaBioskop.text = data["nama"] as? String ?? ""
                        self.alamatBioskop.text = data["alamat"] as? String ?? ""
                        self.telpBioskop.text = data["telp"]as? String ?? ""
                        //                        print("tes \(data["movieId"] ?? "No movieId found")")
                        if let movieIds = data["movieId"] as? [String] {
                            for movieId in movieIds {
                                self.listIdFilm.append(movieId)
                                self.tableFilm.reloadData()
                            }
                        }
                        
                        print("tes \(self.listIdFilm)")
                    }
                }
            }
        }
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
