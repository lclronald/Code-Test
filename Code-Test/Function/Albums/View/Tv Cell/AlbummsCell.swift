//
//  AlbummsCell.swift
//  Code_Test
//
//  Created by Cheuk Long on 5/11/2022.
//

import UIKit
import SDWebImage

class AlbummsCell: UITableViewCell {
    /* IBOutlet */
    @IBOutlet weak var thumbnailIV: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupUI()
    }

    private func setupUI() {
        self.thumbnailIV.contentMode = .scaleToFill
        self.headlineLabel.font = .appBoldFont(ofSize: 12)
        self.artistLabel.font = .appFont(ofSize: 10)
        self.priceLabel.font = .appFont(ofSize: 8)
        
        self.headlineLabel.textColor = .black
        self.artistLabel.textColor = .color_aeaeae
        self.priceLabel.textColor = .black
        
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(model: AlbumsDetailModel) {
        self.thumbnailIV.sd_setImage(with: .init(string: model.artworkUrl60 ?? ""), placeholderImage: UIImage.init(named: AppConstant.defaultImage.defaultAlubmImg))
        self.headlineLabel.text = model.collectionName ?? ""
        self.priceLabel.text = model.getPrice()
        self.artistLabel.text = model.artistName ?? ""
        self.priceLabel.isHidden = model.getPrice().isEmpty
    }
}
