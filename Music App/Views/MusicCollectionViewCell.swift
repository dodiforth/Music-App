//
//  MusicCollectionViewCell.swift
//  Music App
//
//  Created by Dowon Kim on 29/08/2023.
//

import UIKit

final class MusicCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    // Property - handed imageURL in
    var imageUrl: String? {
        didSet {
            loadImage()
        }
    }
    
    // URL ===> image setting
    private func loadImage() {
        guard let urlString = self.imageUrl, let url = URL(string: urlString)  else { return }
        
        DispatchQueue.global().async {
            
            guard let data = try? Data(contentsOf: url) else { return }
            // Get rid of possibility to changing of URL while doing heavy task ⭐️⭐️⭐️
            guard self.imageUrl! == url.absoluteString else { return }
            
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
            }
        }
    }
    
    // Method be called before Cell is reused
    override func prepareForReuse() {
        super.prepareForReuse()
        // Get rid of lagging effect on images(changing images after loaded one time)⭐️
        self.mainImageView.image = nil
    }
    
}
