//
//  TableViewController.swift
//  MyESSTUios
//
//  Created by Sergey Ivanov on 20.11.17.
//  Copyright © 2017 agvares. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    func getTokenValue() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AuthData")
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for result in results as! [AuthData] {
                let token = result.value(forKey: "token")
                if token != nil{
                    self.updateInfo(token: token as! String)
                }
                print("TOKEN 2 = \(String(describing: token))")
            }
        } catch {
            print(error)
        }
    }
    func updateInfo(token: String){
        
        guard let myUrl = NSURL(string: "https://esstu.ru/lk/api/v1/student/getInfo") else { return }
        let request = NSMutableURLRequest(url: myUrl as URL)
        let token1 = (String(describing: token))
        request.addValue("Bearer \(String(describing: token1))", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if let response = response{
                print(response)
            }
            guard let data = data else { return }
            print(data)
            let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")
            }.resume()
    }
    
    @IBAction func LogOutButton(_ sender: Any) {
        let alert = UIAlertController(title: "Вы дейстительно хотите выйти из аккаунта?", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Закрыть", style: .default) { (_) -> Void in
        }
        let outAction = UIAlertAction(title: "Выйти", style: .default) { (_) -> Void in
            let context = CoreDataManager.instance.managedObjectContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AuthData")
            if let result = try? context.fetch(fetchRequest) {
                for object in result {
                    context.delete(object as! NSManagedObject)
                    CoreDataManager.instance.saveContext()
                }
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Authorized")
            self.present(vc!, animated: true, completion: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(outAction)
        
        self.present(alert, animated: true, completion: nil)
    }

}
