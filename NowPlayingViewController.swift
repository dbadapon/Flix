//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Dominique Adapon on 6/21/17.
//  Copyright © 2017 Dominique Adapon. All rights reserved.
//

import UIKit

class NowPlayingViewController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
    
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=4ebc5c93641dbfe7e043da153b03fea4")! // contains an optional URL object...? so you can "force unwrap" with !
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main) //when our network request returns, it will jump back on our main thread...
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            // Network requests are asynchronous: they go out and do their thing on a different thread/queue than our main queue
            // Our main queue is handling UI updates
            // we want the user to still be able to interact with the app and not get stuck just because a slow network request is clogging up the pipe
            
            if let error = error { // this error is optional (the second one?)
                // peek under the hood to see if it's nil and act accordingly
                // "if let..." syntax is gonna check whether (second) error is nil
                // IF NILL, ignore everything in the curly braces
                // IF NOT NILL, assign value of second error to first error
                
                print(error.localizedDescription)
            } else if let data = data { // if we get data back, it's gonna be JSON data
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] //methods like JSONSerialization can go wrong in many ways, so we want to put in a try to catch errors if they pop up
                // uh... apparently kind of like force unwrapping this...
                // so if an error happens, our program will just crash (important -- this is actually what we want in this case)
                // if you option-click dataDictionary, you'll notice that it's of type "Any", but we want a Swift dictionary so we're gonna CAST it with as!
                // our key may be a String, but our value may be anything
                
                // print(dataDictionary)
                
                let movies = dataDictionary["results"] as! [[String: Any]]// check type of movies and see that it's Any...
                // but we want this to be a dictionary too!
                // you're going to be doing a lot of casting...so if you've gone into a key and you haven't cast, question yourself....
                // here, movies is actually an array of dictionaries
                
                for movie in movies {
                    let title = movie["title"] as! String // heh
                    print(title)
                }

            }
    
        }
        // data task to go and get the data
        //
        // "?" = optional...
        // data, response, and error are all optional (could tell before we changed names to local variables)
        
        task.resume() // actually starts the task
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 // MUST change this later!!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
