//
//  GamesViewController.swift
//  TopGames
//
//  Created by Arthur Junqueira Cançado on 28/02/2018.
//  Copyright © 2018 Arthur Junqueira Cançado. All rights reserved.
//

import UIKit
import PKHUD
import Kingfisher

class GamesViewController: UIViewController {
    
    let viewModel = GamesViewModel()
        
    @IBOutlet weak var collectionView: UICollectionView!
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPullToRefresh()
        
        setupCollectionView()
        
        setupViewModel()
        
        if traitCollection.forceTouchCapability == .available {
            self.registerForPreviewing(with: self, sourceView: collectionView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = Constants.Messages.gamesTitle
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationItem.title = Constants.Messages.empty
    }
    
    func setupCollectionView() {
        
        collectionView.register(GameCell.nib, forCellWithReuseIdentifier: GameCell.identifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setupPullToRefresh(){
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: Constants.Messages.pullToRefresh)
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        
        collectionView.addSubview(refreshControl)
    }

    func setupViewModel() {
        
        viewModel.showLoadingHud.bind { [weak self] visible in
            if let `self` = self {
                PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
                visible ? PKHUD.sharedHUD.show(onView: self.view) : PKHUD.sharedHUD.hide()
            }
        }
        
        fetchGames()
        
        viewModel.showErrorAlert.bind { [weak self] visible in
            
            if let `self` = self {
                
                if visible {
                    
                    var message = Constants.Messages.youAreOffline
                    
                    if let updateDate = DatabaseHelper.shared.getLastUpdateDate() {
                        
                        message += " Last update date: \(updateDate)"
                    }
                    
                    let alertController = UIAlertController(title: Constants.Messages.defaultTile, message: message, preferredStyle: .alert)
                
                    alertController.addAction(UIAlertAction(title: Constants.Messages.ok, style: .default))
                
                    self.present(alertController, animated: true)
                }
            }
        }
    }
    
    func fetchGames() {
        
        viewModel.fetchGames {
            
            DispatchQueue.main.async {
                
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
                
                self.viewModel.getLimitedGames()
                
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func pullToRefresh() {
        
        viewModel.restartLimit()
    
        fetchGames()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.SegueIds.segueToGameDetail {
            
            let svc = segue.destination as! GameDetailViewController
            
            let indexPaths: NSArray = collectionView.indexPathsForSelectedItems! as NSArray
            let index: IndexPath = indexPaths.firstObject as! IndexPath

            let game = viewModel.getGame(at: index)
            
            svc.viewModel.game = game
        }
    }
}

extension GamesViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.numberOfItemsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.identifier, for: indexPath) as! GameCell
        
        let game = viewModel.getGame(at: indexPath)
        
        let boxUrl = game.getBoxWith(width: cell.gameLogo.frame.width, andHeight: cell.gameLogo.frame.height)
        
        cell.gameLogo?.kf.setImage(with: URL(string: boxUrl),
                              placeholder: UIImage(named: "img_placeholder"),
                              options: [.transition(.fade(1))],
                              progressBlock: nil,
                              completionHandler: nil)
        
        cell.gameName.text = "#\(indexPath.row+1) - \(game.name.capitalized)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row >= viewModel.games.count-1 && viewModel.limit < 100 {

            viewModel.limit += 20

            viewModel.getLimitedGames()
            
            DispatchQueue.main.async {
                collectionView.reloadData()
            }
        }
    }
}

extension GamesViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: Constants.SegueIds.segueToGameDetail, sender: self)
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension GamesViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView.indexPathForItem(at: location) else {
            return nil
        }
        
        let gameDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameDetailID") as! GameDetailViewController
        
        gameDetailVC.viewModel.game = viewModel.getGame(at: indexPath)
        
        return gameDetailVC
        
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
}
