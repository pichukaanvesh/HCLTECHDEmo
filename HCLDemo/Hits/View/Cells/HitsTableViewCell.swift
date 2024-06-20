//
//  HitsTableViewCell.swift
//  HCLDemo
//
//  Created by Pichuka, Anvesh (623-Extern) on 19/06/24.
//

import UIKit

class HitsTableViewCell: UITableViewCell {
    @IBOutlet var hitsImage: UIImageView!
    @IBOutlet var hitsTags: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(with hit: Hits) {
        hitsTags.text = hit.tags
            loadImage(from: hit.previewURL ?? "")
        }
        
        private func loadImage(from urlString: String) {
            guard let url = URL(string: urlString) else {
                hitsImage.image = UIImage(named: "dummy")
                return
            }
            
            // Fetch the image asynchronously
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let data = data, error == nil else {
                    DispatchQueue.main.async {
                        self?.hitsImage.image = UIImage(named: "dummy")
                    }
                    return
                }
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.hitsImage.image = image
                }
            }.resume()
        }
    }
