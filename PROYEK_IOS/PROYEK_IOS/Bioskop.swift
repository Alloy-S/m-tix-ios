//
//  Bioskop.swift
//  PROYEK_IOS
//
//  Created by Alloysius Steven on 17/12/23.
//

import Foundation

struct Bioskop: Decodable, Encodable {
    let alamat: String
    let nama: String
    let telp: String
    let movieId: [String]
}


