//
//  nowPlaying.swift
//  PROYEK_IOS
//
//  Created by Steven A on 17/12/23.
//

import Foundation
import UIKit

class nowPlaying: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var moviesItem: [Movie] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        filterMoviesNowPlaying()
    }


    func filterMoviesNowPlaying() {
        // Filter hanya film dengan status "nowPlaying"
        moviesItem = movies.filter { $0.status == "nowPlaying" }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesItem.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NowPlayingCollectionViewCell", for: indexPath) as! NowPlayingCollectionViewCell

        let movie = moviesItem[indexPath.item]

        // Setel data ke dalam sel
        cell.imageMovie.image = UIImage(named: movie.gambarFilm)
        cell.title.text = movie.judulFilm
        cell.dimension.text = movie.dimensi
        cell.rated.text = movie.rated

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 250)
    }
}
