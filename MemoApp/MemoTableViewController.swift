//
//  MemoTableViewController.swift
//  MemoApp
//
//  Created by Sho Nozaki on 2018/05/20.
//  Copyright © 2018年 Sho Nozaki. All rights reserved.
//

import UIKit

class MemoTableViewController: UITableViewController {

    /* UserDefaults */
    let userDefaults = UserDefaults.standard // データ保持用のインスタンス取得
    
    /* メモ変数 */
//    var memos = ["キャベツ", "トマト", "タマネギ"]
    var memos = [String]()
    
    /* segueの巻き戻し処理 */
    @IBAction func unwindToMemoList(sender: UIStoryboardSegue) {
        /* MemoViewControllerのprepareメソッドによるsegueの巻き戻し処理 */
        // MemoViewControllerから渡ってきた変数memoを取得してリストmemosに追加する
        
        // 遷移元の画面を取得する
        // → ① 渡ってきた引数senderをMemoViewControllerでキャストし、sourceVCに設定する
        //   ② リストmemoに①で設定したsourceVCの変数memo(MemoViewController側で入力された値を保持している変数memo)を代入する
        guard let sourceVC = sender.source as? MemoViewController, let memo  = sourceVC.memo else {
            return
        }
        // 正常に取得できた場合
        // → メモの新規作成or更新のチェック(Cellが選択されているかどうかで判断する)
        //   Cellの選択状態はself.tableView.indexPathForSelectedRowがnilでないかでわかる
        if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
            // Cellが選択状態 → selectedIndexPathがnilでない場合
            self.memos[selectedIndexPath.row] = memo
        } else {
            // Cellが選択状態でない → selectedIndexPathがnilの場合
            self.memos.append(memo) // 渡ってきた変数memoをリストmemosに追加する
        }
        self.userDefaults.set(self.memos, forKey: "memos") // 変数memosの変更内容をuserDefaultsに保存する(データの永続化)
        self.tableView.reloadData() // tableViewを再読み込みする → tableViewが更新される
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // アプリ起動時における保持データの取得 → userDefaultsの保持データの存在チェック
        if self.userDefaults.object(forKey: "memos") != nil {
            // userDefaultsに保持データが存在する場合
            self.memos = self.userDefaults.stringArray(forKey: "memos")!
        } else {
            // userDefaultsに保持データが存在しない場合
            self.memos = ["キャベツ", "トマト", "タマネギ"] // 初期表示用のデータ取得
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /* セクション数を設定する */
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        // メモのセクション数を返却する → 今回はセクションは1つ
        return 1
//        return self.memos.count
    }

    /* セクションの行数(要素数)を設定する */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // メモの要素数だけ返却する
        return self.memos.count
//        return self.memos[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.memos[indexPath.row]

        return cell
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sections[section]
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // スワイプによる処理
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            self.memos.remove(at: indexPath.row) // メモの削除処理
            self.userDefaults.set(self.memos, forKey: "memos") // 変数memosの変更内容をuserDefaultsに保存する(データの永続化)
            tableView.deleteRows(at: [indexPath], with: .fade) // 該当する行をtableViewから削除する(既存のもの)
        }   
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // タップされた行のメモを遷移先の画面に渡す処理
        guard let identifier = segue.identifier else {
            return
        }
        if identifier == "editMemo" {
            // 遷移先のMemoViewControllerを取得する
            let memoVC = segue.destination as! MemoViewController
            // タップされている行が何番目を取得し、MemoViewControllerのメモに代入する
            memoVC.memo = self.memos[(self.tableView.indexPathForSelectedRow?.row)!]
            
        }
    }

}
