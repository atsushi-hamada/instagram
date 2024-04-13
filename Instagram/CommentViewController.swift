//
//  CommentViewController.swift
//  Instagram
//
//  Created by 濱田純史 on 2024/04/07.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SVProgressHUD

class CommentViewController: UIViewController {
    
    @IBOutlet weak var commentText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 投稿ボタンをタップしたときに呼ばれるメソッド
    @IBAction func commentPostButton(_ sender: Any) {
        //コメントデータの保存先を定義
        let commentRef = Firestore.firestore().collection(Const.PostPath).document()
        
        // HUDで投稿処理中の表示を開始
        SVProgressHUD.show()
        
        // FireStoreに投稿データを保存する
        let name = Auth.auth().currentUser?.displayName
        
        // 更新データを作成する
        var updateValue: FieldValue
        var comment = commentText.text!
        updateValue = FieldValue.arrayUnion([name!,comment])
        commentRef.updateData(["comment": updateValue])
        
        //let postDic = [
        //    "name": name!,
        //    "comment": self.commentText.text!
        //    ] as [String : Any]
        //commentRef.setData(postDic)
        
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "投稿しました")
        
        // 投稿処理が完了したので先頭画面に戻る
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        // commentに更新データを書き込む
        //let postRef = Firestore.firestore().collection(Const.PostPath).document(PostData.comment)
        //postRef.updateData(["comment"])
    }
    
    // キャンセルボタンをタップしたときに呼ばれるメソッド
    @IBAction func commentCancelButton(_ sender: Any) {
        // 加工画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
