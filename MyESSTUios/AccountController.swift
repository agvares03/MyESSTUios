//
//  AccountController.swift
//  MyESSTUios
//
//  Created by Sergey Ivanov on 13.02.18.
//  Copyright © 2018 agvares. All rights reserved.
//

import UIKit
import CoreData

class AccountController: UIViewController {

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
