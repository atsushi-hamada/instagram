//
//  HomeViewController.swift
//  Instagram
//
//  Created by cpcadmin on 2024/03/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    // 投稿データを格納する配列
    var postArray: [PostData] = []
    
    // Firestoreのリスナー
    var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // カスタムセルを登録する
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }

    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         print("DEBUG_PRINT: viewWillAppear")
         // ログイン済みか確認
         if Auth.auth().currentUser != nil {
             // listenerを登録して投稿データの更新を監視する
             let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
             listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                 if let error = error {
                     print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                     return
                 }
                 // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                 self.postArray = querySnapshot!.documents.map { document in
                     let postData = PostData(document: document)
                     print("DEBUG_PRINT: \(postData)")
                     return postData
                 }
                 // TableViewの表示を更新する
                 self.tableView.reloadData()
             }
         }
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DEBUG_PRINT: viewWillDisappear")
        // listenerを削除して監視を停止する
        listener?.remove()
    }
    
    // コメント/moreボタンで画面遷移する時に呼ばれる
       override func prepare(for segue: UIStoryboardSegue, sender: Any?){
           let postData = sender as! PostData
           if segue.identifier == "tocomment" {
               let commentViewController:CommentViewController = segue.destination as! CommentViewController
               commentViewController.postData = postData
           }
           
           if segue.identifier == "tocommentlist" {
               let commentlistViewController:CommentlistViewController = segue.destination as! CommentlistViewController
               commentlistViewController.postData = postData
           }
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])

        // セル内のボタンのアクションをソースコードで設定する
        cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
        
        cell.commentButton.addTarget(self, action:#selector(commentButton(_:forEvent:)), for: .touchUpInside)
        
        cell.moreButton.addTarget(self, action:#selector(moreButton(_:forEvent:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func commentButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: コメントボタンがタップされました。")
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)

        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        self.performSegue(withIdentifier: "tocomment", sender: postData)
    }

    @objc func moreButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: moreボタンがタップされました。")
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)

        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        self.performSegue(withIdentifier: "tocommentlist", sender: postData)
    }
    
    // セル内のボタンがタップされた時に呼ばれるメソッド
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました。")

        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)

        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]

        // likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            // 更新データを作成する
            var updateValue: FieldValue
            if postData.isLiked {
                // すでにいいねをしている場合は、いいね解除のためmyidを取り除く更新データを作成
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                // 今回新たにいいねを押した場合は、myidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            // likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes": updateValue])
        }
    }
}
