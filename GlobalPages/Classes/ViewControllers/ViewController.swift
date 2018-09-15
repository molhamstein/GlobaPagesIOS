//
//  ViewController.swift
//  GlobalPages
//
//  Created by Nour  on 9/8/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       imageView.kf.setImage(with: URL(string: "https://www.google.com/imgres?imgurl=https%3A%2F%2Fwww.arabgt.com%2Fwp-content%2Fuploads%2F2018%2F01%2F%25D8%25A3%25D9%2582%25D9%2588%25D9%2589-%25D8%25B3%25D9%258A%25D8%25A7%25D8%25B1%25D8%25A9-%25D9%2583%25D9%2587%25D8%25B1%25D8%25A8%25D8%25A7%25D8%25A6%25D9%258A%25D8%25A9-%25D9%2581%25D9%258A-%25D8%25A7%25D9%2584%25D8%25B9%25D8%25A7%25D9%2584%25D9%2585.jpg&imgrefurl=https%3A%2F%2Fwww.arabgt.com%2F%25D8%25A7%25D8%25AE%25D8%25A8%25D8%25A7%25D8%25B1-%25D8%25B3%25D9%258A%25D8%25A7%25D8%25B1%25D8%25A7%25D8%25AA%2F%25D9%2585%25D8%25AA%25D9%2581%25D8%25B1%25D9%2582%25D8%25A7%25D8%25AA%2F%25D8%25A3%25D9%2582%25D9%2588%25D9%2589-%25D8%25B3%25D9%258A%25D8%25A7%25D8%25B1%25D8%25A7%25D8%25AA-%25D9%2581%25D9%258A-%25D8%25A7%25D9%2584%25D8%25B9%25D8%25A7%25D9%2584%25D9%2585-top-5%2F&docid=wQ83r177CBahTM&tbnid=4Dk2Xc6OeK5hRM%3A&vet=10ahUKEwjs86bwiqvdAhVI9IMKHR3lATEQMwikASgFMAU..i&w=800&h=497&bih=751&biw=1440&q=%D8%B3%D9%8A%D8%A7%D8%B1%D8%A7%D8%AA&ved=0ahUKEwjs86bwiqvdAhVI9IMKHR3lATEQMwikASgFMAU&iact=mrc&uact=8"))
    }


}
