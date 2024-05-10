//
//  CommentlistViewController.swift
//  Instagram
//
//  Created by cpcadmin on 2024/04/12.
//

import UIKit

class CommentlistViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    var postData : PostData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.fillerRowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    //func setPostData(_ postData: PostData) {
    //    let commentNumber = postData.comment.count
    //}
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.comment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = postData.comment[indexPath.row]
        return cell
    }

}
