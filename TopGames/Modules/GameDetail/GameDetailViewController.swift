//
//  GameDetailViewController.swift
//  TopGames
//
//  Created by Arthur Junqueira Cançado on 28/02/2018.
//  Copyright © 2018 Arthur Junqueira Cançado. All rights reserved.
//

import UIKit

class GameDetailViewController: UIViewController {
    
    let viewModel = GameDetailViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = viewModel.game.name.capitalized
        
        setupTableView()
    }
    
    func setupTableView(){
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView(frame: .zero)
    }
}

extension GameDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let section = indexPath.section
        
        if section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIds.imageCellId, for: indexPath)
            
            let imageView = cell.viewWithTag(1) as! UIImageView
            
            let boxUrl = viewModel.getBoxWith(width: imageView.frame.width, andHeight: imageView.frame.height)
            
            imageView.kf.setImage(with: URL(string: boxUrl),
                                  placeholder: UIImage(named: "img_placeholder"),
                                  options: [.transition(.fade(1))],
                                  progressBlock: nil,
                                  completionHandler: nil)
            
            return cell
            
        } else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIds.defaultCellId, for: indexPath)
            
            if row == 0 {
                
                cell.textLabel?.text = "Viwers:"
                cell.detailTextLabel?.text = "\(viewModel.game.viewers!)"
            }
            else if row == 1{
                
                cell.textLabel?.text = "Channels:"
                cell.detailTextLabel?.text = "\(viewModel.game.channels!)"
            }
            
            return cell
        }
    }
    
}

extension GameDetailViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return viewModel.heightOfItemsInSection(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
