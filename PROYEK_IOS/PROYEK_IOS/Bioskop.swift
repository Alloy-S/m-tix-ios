//
//  Bioskop.swift
//  PROYEK_IOS
//
//  Created by Alloysius Steven on 17/12/23.
//

import Foundation

struct Bioskop: Decodable, Encodable {
    let bioskopId: String
    let alamat: String
    let nama: String
    let telp: String
    let kota: String
    let movieId: [String]
}


