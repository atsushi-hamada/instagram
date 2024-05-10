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
    var postData : PostData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  print(postData.name)
    }
    
    // 投稿ボタンをタップしたときに呼ばれるメソッド
    @IBAction func commentPostButton(_ sender: Any) {
        
        // HUDで投稿処理中の表示を開始
        SVProgressHUD.show()
        
        // 名前を抜き出す
        let name = Auth.auth().currentUser?.displayName
        
        // 更新データを書き込む
        let commentRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
        var updateValue: FieldValue
        let comment = commentText.text!
        updateValue = FieldValue.arrayUnion([name!+" : "+comment])
        commentRef.updateData(["comment": updateValue])
        
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "投稿しました")
        
        // 投稿処理が完了したので先頭画面に戻る
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    // キャンセルボタンをタップしたときに呼ばれるメソッド
    @IBAction func commentCancelButton(_ sender: Any) {
        // 加工画面に戻る
        self.dismiss(animated: true, completion: nil)
    }
}
