//
//  upComing.swift
//  PROYEK_IOS
//
//  Created by Steven A on 17/12/23.
//

import Foundation
import UIKit
import FirebaseFirestore

class upComing: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var moviesItem: [Movie] = []
    let db = Firestore.firestore()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        filterMoviesNowPlaying()
    }


    func filterMoviesNowPlaying() {
        
        db.collection("Movie").getDocuments() { (querySnapshot, err)
            in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.moviesItem.removeAll()
                for document in querySnapshot!.documents {
                    let readData = document.data()
                    if let image = readData["image"] as? String,
                       let nama = readData["nama"] as? String,
                       let rate = readData["rate"] as? String,
                       let dimensi = readData["dimensi"] as? String,
                       let status = readData["status"] as? String,
                       let durasi = readData["durasi"] as? Int {
                        let movie = Movie(image: image, nama: nama, dimensi: dimensi, rate: rate, status: status, durasi: durasi)
                        if status == "UpComing" {
                            self.moviesItem.append(movie)
                        }
                    }
                    self.collectionView.reloadData()
                    
                }
            }
        }
        // Filter hanya film dengan status "nowPlaying"
//        moviesItem = movies.filter { $0.status == "upComing" }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesItem.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpComingMovieCollectionViewCell", for: indexPath) as! UpComingMovieCollectionViewCell

        let movie = moviesItem[indexPath.item]

        // Setel data ke dalam sel
        cell.imageMovie.image = UIImage(named: movie.image)
        cell.title.text = movie.nama
        cell.dimension.text = movie.dimensi
        cell.rated.text = movie.rate

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 250)
    }
}
