//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Andy Duong on 2/4/18.
//  Copyright © 2018 Andy Duong. All rights reserved.
//

import UIKit
import AlamofireImage
import PKHUD

class NowPlayingViewController: UIViewController, UITableViewDataSource {

    // MARK: Properties
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var movies: [[String: Any]] = []
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        moviesTableView.insertSubview(refreshControl, at: 0)
        
        moviesTableView.dataSource = self
        
        activityIndicator.startAnimating()
        fetchMovies()
        activityIndicator.stopAnimating()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPathStr = movie["poster_path"] as! String
        let baseURLStr = "https://image.tmdb.org/t/p/w500"
        let posterURL = URL(string: baseURLStr + posterPathStr)!
        cell.posterImageView.af_setImage(withURL: posterURL)
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        return cell
    }
    
    func fetchMovies() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // TODO: Get the array of movies
                // movies is an array of dictionaries
                // Arrays and dictionaries both use square brackets but dictionaries use an additional colon.
                let movies = dataDictionary["results"] as! [[String: Any]]
                
                // Uncomment below to print out the movie titles
                /*
                 for movie in movies {
                 let title = movie["title"] as! String
                 print(title)
                 }
                 */
                
                // TODO: Store the movies in a property to use elsewhere
                // movie is a dictionary
                self.movies = movies
                
                // TODO: Reload your table view data
                self.moviesTableView.reloadData()
                
                self.refreshControl.endRefreshing()
                
            }
        }
        task.resume()
    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }

    // Attempt at using a 3rd party HUD
    /*
    @IBAction func showAnimatedProgressHUD(_ sender: AnyObject) {
        HUD.show(.progress, onView: tableView)
        
        delay(2.0) {
            HUD.flash(.success, delay: 1.0)
        }
    }
    */
}
