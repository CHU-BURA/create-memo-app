//
//  MemoViewController.swift
//  MemoApp
//
//  Created by Sho Nozaki on 2018/05/20.
//  Copyright © 2018年 Sho Nozaki. All rights reserved.
//

import UIKit

class MemoViewController: UIViewController {

    /* TableViewに渡すデータを保持するための変数 */
    var memo: String? // 入力値は何も入力されたいこともあるためOptional型とする
    
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* 編集時の処理 */
        // MemoTableViewControllerでタップされた編集行のメモ値を取得する
        if let memo = self.memo {
            self.memoTextField.text = memo // 渡されたmemoをmemoTextFieldに代入する
            self.navigationItem.title = "Edit Memo" // タイトルを変更する
        }
        self.updateSaveButtonState() // saveボタンを有効に切り替える
    }
    
    /* textFieldの中身によって、saveボタンの有効・無効を切り替える */
    private func updateSaveButtonState() {
        let memo = self.memoTextField.text ?? ""
        self.saveButton.isEnabled = !memo.isEmpty
    }
    
    /* TextFieldの中身が変わった時の処理 */
    @IBAction func memoTextFieldChanged(_ sender: Any) {
        self.updateSaveButtonState() // saveボタンを無効に切り替える
    }
    
    /* cancelボタン押下時の処理 */
    @IBAction func cancel(_ sender: Any) {
        // 現在のViewControllerをチェック
        if self.presentingViewController is UINavigationController {
            // モーダル処理の場合 → UINavigationController
            self.dismiss(animated: true, completion: nil) // モーダルを消す
        } else {
            // モーダル処理でない場合 → メモ編集時の処理
            self.navigationController?.popViewController(animated: true) // Showしたsegueを逆に戻る
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* segueによる遷移が行われる前に実行される */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /* 変数memoに値を設定する */
        // saveボタンを押下したかどうかのチェック
        // → ① senderをUIBarButtonItemでキャストしbuttonに代入する
        //   ② ①でキャストしたbuttonが変数saveButtonと同オブジェクトであるかチェックする
        guard let button = sender as? UIBarButtonItem, button == self.saveButton else {
            return
        }
        // 正常の場合は、入力値memoTextFieldを変数memoに値を設定する
        self.memo = self.memoTextField.text ?? "" // 入力値memoTextFieldはOptional型のため、nilの場合は空文字""を返却させる
        
        
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
