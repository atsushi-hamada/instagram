//
//  CommentlistViewController.swift
//  Instagram
//
//  Created by cpcadmin on 2024/04/12.
//

import UIKit

class CommentlistViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    // 投稿データを格納する配列
    var postArray: [PostData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        }
    
    
    
    func setPostData(_ postData: PostData) {
        let commentNumber = postData.comment.count
    }
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        return cell
    }

}
