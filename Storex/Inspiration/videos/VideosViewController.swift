//
//  VideosViewController.swift
//  Storex
//
//  Created by admin on 2/4/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit

class VideosViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // register nibs:
        tableView.registerCellNib(cellClass: VideoCell.self)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension VideosViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as VideoCell
        return cell
    }
    
}
