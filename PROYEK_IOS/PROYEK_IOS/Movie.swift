//
//  Movie.swift
//  PROYEK_IOS
//
//  Created by Alloysius Steven on 18/12/23.
//

import Foundation

struct Movie: Codable {
    var image: String
    var nama: String
    var dimensi: String
    var rate: String
    var status: String
    var durasi: Int
    
}

//let movies: [Movie] = [
//    Movie(gambarFilm: "wonka.jpg", judu: "Willy Wonka", dimensi: "2D", rate: "SU", status: "nowPlaying"),
//    Movie(gambarFilm: "transformers.jpg", judulFilm: "Transformers", dimensi: "2D", rate: "R13+", status: "nowPlaying"),
//    Movie(gambarFilm: "insidious.jpg", judulFilm: "Insidious", dimensi: "2D", rate: "R13+", status: "nowPlaying"),
//    Movie(gambarFilm: "readyornot.jpg", judulFilm: "Ready or Not", dimensi: "2D", rate: "D17+", status: "nowPlaying"),
//    Movie(gambarFilm: "thesmurf.jpg", judulFilm: "The Smurfs", dimensi: "2D", rate: "SU", status: "upComing"),
//    Movie(gambarFilm: "jumanji.jpg", judulFilm: "Jumanji", dimensi: "2D", rate: "R13+", status: "upComing"),
//    Movie(gambarFilm: "endgame.jpg", judulFilm: "Avengers Endgame", dimensi: "2D", rate: "R13+", status: "upComing"),
//    Movie(gambarFilm: "uncharted.jpg", judulFilm: "Uncharted", dimensi: "2D", rate: "R13+", status: "upComing")
//]
