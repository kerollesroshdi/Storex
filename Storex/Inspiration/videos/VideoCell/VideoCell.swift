//
//  VideoCell.swift
//  Storex
//
//  Created by admin on 2/4/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

class VideoCell: UITableViewCell {
    @IBOutlet weak var playerView: WKYTPlayerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        playerView.load(withVideoId: "dh1FSLyXDJo")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
