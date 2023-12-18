//
//  ViewControllerDetailFilm.swift
//  PROYEK_IOS
//
//  Created by Catherine Rosalind on 16/12/23.
//

import UIKit
import FirebaseFirestore

class ViewControllerDetailFilm: UIViewController {
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var judul: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var durasi: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    @IBOutlet weak var sinopsis: UILabel!
    @IBOutlet weak var producer: UILabel!
    @IBOutlet weak var director: UILabel!
    @IBOutlet weak var writer: UILabel!
    @IBOutlet weak var distributor: UILabel!
    @IBOutlet weak var cast: UILabel!

    //    var idFilm : String = ""
    var idFilm : String = ""
    var db: Firestore!
    
    
    @IBAction func btnPlayingAt(_ sender: UIButton) {
        let playingAt = self.storyboard?.instantiateViewController(withIdentifier: "ViewControllerMovieListBioskop") as! ViewControllerMovieListBioskop
        playingAt.nama_film = (judul.text)!
        playingAt.movieID = idFilm
        self.navigationController?.pushViewController(playingAt, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sinopsis.numberOfLines = 0
        sinopsis.lineBreakMode = .byWordWrapping
        
        producer.numberOfLines = 0
        producer.lineBreakMode = .byWordWrapping
        
        cast.numberOfLines = 0
        cast.lineBreakMode = .byWordWrapping
        
        judul.font = UIFont.boldSystemFont(ofSize: 17.0)
        judul.numberOfLines = 0
        judul.lineBreakMode = .byWordWrapping
    

        
        db = Firestore.firestore()
        db.collection("Movie").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                
                    let idMovie = document.documentID
                    
                    if(idMovie == self.idFilm){
                        let data = document.data()
                        print(data["nama"] as? String ?? "")
                        self.judul.text = data["nama"] as? String ?? ""
                        if let imageData = data["image"] as? String {
                            self.image.image = UIImage(named: imageData)
                        } else {
                            self.image.image = UIImage(named: "placeholder_image")
                        }
                        if let durasi = data["durasi"] as? Int {
                            self.durasi.text = String(durasi)  + " minutes"
                        } else if let durasi = data["durasi"] as? NSNumber {
                            self.durasi.text = durasi.isEqual(to: durasi.intValue as NSNumber) ? "\(durasi.intValue)" : "\(durasi.doubleValue)"
                        } else {
                            self.durasi.text = "N/A"
                        }
                        self.rating.text =  data["rate"] as? String ?? ""
                        print("2 \(idMovie)")
                        self.db.collection("detailMovie").whereField("movieId", isEqualTo: idMovie).getDocuments { (querySnapshot, error) in
                            if let error = error {
                                print("Error getting documents: \(error)")
                            } else {
                                for document in querySnapshot!.documents {
                                    print("masukk")
                                    let data2 = document.data()
                                    print(data2["distributor"] as? String ?? "")
                                    self.genre.text = data2["genre"] as? String ?? ""
                                    self.cast.text = data2["cast"] as? String ?? ""
                                    self.director.text = data2["director"] as? String ?? ""
                                    self.distributor.text = data2["distributor"] as? String ?? ""
                                    self.producer.text = data2["producer"] as? String ?? ""
                                    self.sinopsis.text = data2["synopsis"] as? String ?? ""
                                    self.writer.text = data2["writer"] as? String ?? ""
                                }
                            }
                        }
                        
                    }
                }
            }
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
}
