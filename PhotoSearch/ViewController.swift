//
//  ViewController.swift
//  PhotoSearch
//
//  Created by Sanjay on 1/30/15.
//  Copyright (c) 2015 sanjay. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var scrollView: UIScrollView!;
    @IBOutlet weak var searchBar: UISearchBar!
    var searchTag = "homes";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadImages(searchTag);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        for subview in self.scrollView.subviews{
            subview.removeFromSuperview();
        }
        searchBar.resignFirstResponder();
        searchTag = searchBar.text;
        loadImages(searchTag);
    }
    
    func loadImages(searchTag:String){
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET( "https://api.instagram.com/v1/tags/\(searchTag)/media/recent?client_id=2114dd3597684003976acae978d8bb5b",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                //println("JSON: " + responseObject.description)
                if let dataArray = responseObject["data"] as? [AnyObject]{
                    var urlArray:[String] = [String]();
                    for dataObject in dataArray{
                        if let imageUrl = dataObject.valueForKeyPath("images.standard_resolution.url") as? String{
                            urlArray.append(imageUrl);
                            //println(imageUrl);
                        }
                    }
                    //println("Number of images: \(urlArray.count)");
                    var width = self.scrollView.frame.width;
                    self.scrollView.contentSize = CGSizeMake(width, width * CGFloat(dataArray.count));
                    
                    for (var i = 0; i < urlArray.count; i++) {
                        let imageView = UIImageView(frame: CGRectMake(0, width*CGFloat(i), width, width));
                        imageView.setImageWithURL( NSURL(string: urlArray[i]));                          
                        self.scrollView.addSubview(imageView);
                    }
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                println("Error: " + error.localizedDescription)
        })
    }
}

