//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Andy Duong on 2/4/18.
//  Copyright © 2018 Andy Duong. All rights reserved.
//

import UIKit
import AlamofireImage
// TODO: import PKHUD

class NowPlayingViewController: UIViewController, UITableViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /* Project 1
    var movies: [[String: Any]] = []
    End of Project 1 */
    
    var movies: [Movie] = []
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Using the UITableViewDataSource protocol
        moviesTableView.dataSource = self
        
        // Auto Layout of the Table View Cell
        moviesTableView.rowHeight = UITableViewAutomaticDimension
        moviesTableView.estimatedRowHeight = 10
        
        // Pull to Refresh Setup
        refreshControl = UIRefreshControl()
        //
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        moviesTableView.insertSubview(refreshControl, at: 0)
        
        // Start activity indicator
        activityIndicator.startAnimating()
        
       /*
        MovieApiManager().nowPlayingMovies { (movies: [Movie]?, error: Error?) in
            if let movies = movies {
                self.movies = movies
                self.moviesTableView.reloadData()
            }
        } End of Project*/
        
        /* Project 2
        fetchMovies()
        */
        
        fetchPopularMovies()

    }
    
    /**
     * Number of cells
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count;
    }

    /**
     * Setup for each cell
     */
    /* Lab 5 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        // Update the movie property so that the Movie class' property handlers can handle the setup of the IBOutlets.
        cell.movie = movies[indexPath.row]
        
        return cell
        
    } /* End of Lab 5 */
    /* Projects 1 and 2
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        // Generating the poster image's URL
        let baseURLStr = "https://image.tmdb.org/t/p/w500"
        let posterPathStr = movie["poster_path"] as! String
        let posterURL = URL(string: baseURLStr + posterPathStr)!
     
        // Set the image using the generated URL
        cell.posterImageView.af_setImage(withURL: posterURL)
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        return cell
    } End of Projects 1 and 2 */
    
    // MARK: Fetch Movies
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
                let movieDictionaries = dataDictionary["results"] as! [[String: Any]]
                
                self.movies = []
                for dictionary in movieDictionaries {
                    let movie = Movie(dictionary: dictionary)
                    self.movies.append(movie)
                }
                
                /* Project 2
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // Get the array of movies
                // movies is an array of dictionaries
                // Arrays and dictionaries both use square brackets but dictionaries use an additional colon.
                let movies = dataDictionary["results"] as! [[String: Any]]
                
                /* TEST: Print out movie titles
                 for movie in movies {
                    let title = movie["title"] as! String
                    print(title)
                 }
                */
                
                // Store the movies in a property to use elsewhere
                // movie is a dictionary
                self.movies = movies
 
                End of Project 2 */
 
                // Reload your table view data
                self.moviesTableView.reloadData()
                
                // Stop refreshing and activity indicator
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
                
            }
        }
        task.resume()
    }
    
    func fetchPopularMovies() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movieDictionaries = dataDictionary["results"] as! [[String: Any]]
                
                for dictionary in movieDictionaries {
                    let movie = Movie(dictionary: dictionary)
                    self.movies.append(movie)
                }
                
                // Reload your table view data
                self.moviesTableView.reloadData()
                // Stop refreshing and activity indicator
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
                
            }
        }
        task.resume()
    }
    
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = moviesTableView.indexPath(for: cell) {
            let movie = movies[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
        }
    }
    
    // TODO: Attempt at using a 3rd party HUD
    /*
     @IBAction func showAnimatedProgressHUD(_ sender: AnyObject) {
     HUD.show(.progress, onView: tableView)
     
     delay(2.0) {
     HUD.flash(.success, delay: 1.0)
     }
     }
     */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
