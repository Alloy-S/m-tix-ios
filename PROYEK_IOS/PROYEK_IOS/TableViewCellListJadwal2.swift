//
//  TableViewCellListJadwal2.swift
//  PROYEK_IOS
//
//  Created by Jessy Marcelyn on 17/12/23.
//

import UIKit

class TableViewCellListJadwal2: UITableViewCell {

    @IBOutlet weak var jamFilm: UILabel!
    @IBOutlet weak var hargaFilm: UILabel!
    @IBOutlet weak var tanggalFilm: UILabel!
    @IBOutlet weak var durasiFilm: UILabel!
    @IBOutlet weak var ratingFilm: UILabel!
    @IBOutlet weak var dimensiFilm: UILabel!
    @IBOutlet weak var namaFilm: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
