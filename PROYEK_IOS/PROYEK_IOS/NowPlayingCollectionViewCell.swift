//
//  NowPlayingCollectionViewCell.swift
//  PROYEK_IOS
//
//  Created by Steven A on 18/12/23.
//

import UIKit

struct Movie: Codable {
    var gambarFilm: String
    var judulFilm: String
    var dimensi: String
    var rated: String
    var status: String
}

let movies: [Movie] = [
    Movie(gambarFilm: "wonka.jpg", judulFilm: "Willy Wonka", dimensi: "2D", rated: "SU", status: "nowPlaying"),
    Movie(gambarFilm: "transformers.jpg", judulFilm: "Transformers", dimensi: "2D", rated: "R13+", status: "nowPlaying"),
    Movie(gambarFilm: "insidious.jpg", judulFilm: "Insidious", dimensi: "2D", rated: "R13+", status: "nowPlaying"),
    Movie(gambarFilm: "readyornot.jpg", judulFilm: "Ready or Not", dimensi: "2D", rated: "D17+", status: "nowPlaying"),
    Movie(gambarFilm: "thesmurf.jpg", judulFilm: "The Smurfs", dimensi: "2D", rated: "SU", status: "upComing"),
    Movie(gambarFilm: "jumanji.jpg", judulFilm: "Jumanji", dimensi: "2D", rated: "R13+", status: "upComing"),
    Movie(gambarFilm: "endgame.jpg", judulFilm: "Avengers Endgame", dimensi: "2D", rated: "R13+", status: "upComing"),
    Movie(gambarFilm: "uncharted.jpg", judulFilm: "Uncharted", dimensi: "2D", rated: "R13+", status: "upComing")
]

class NowPlayingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageMovie: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var dimension: UILabel!
    
    @IBOutlet weak var rated: UILabel!
    
}
