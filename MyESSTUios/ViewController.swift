//
//  ViewController.swift
//  MyESSTU_ios
//
//  Created by agvares on 15.06.17.
//  Copyright © 2017 agvares. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController{
    var erors: Bool = false
    
    var name = [NSManagedObject]()
    var go = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AuthButton.layer.cornerRadius = AuthButton.frame.height / 2
        addTapGestureToHideKeyboard()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AuthData")
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for result in results as! [AuthData] {
                let first = result.value(forKey: "firstName")
                if first != nil{
                    DispatchQueue.main.async {
                        self.Label.text = "Отправка завершена!"; //данные отправлены
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar")
                        self.present(vc!, animated: true, completion: nil)
                    }
                }
                print("Пользователь не авторизован")
            }
        } catch {
            print(error)
        }
    }
    
    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var tUsername: UITextField!
    @IBOutlet weak var tPassword: UITextField!
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var AuthButton: UIButton!
    
    
    @IBAction func AuthButton(_: UIButton) {
        
        let textUsername:NSString = tUsername.text! as NSString
        let textPassword:NSString = tPassword.text! as NSString
        if tUsername.text != "" && tPassword.text != "" {
            
            DispatchQueue.main.async{
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            
            //Создаем URL на который будем отправлять данные
            let myURL = NSURL(string: "https://esstu.ru/auth/oauth/token")
            let request = NSMutableURLRequest(url: myURL! as URL)
            request.httpMethod = "POST" //выбор метода POST
            
            let postString = "response_type=token&grant_type=password&scope=trust&client_id=personal_office_mobile&client_secret=431ecc50c5be014224ec1abf8c2f99840ca4c43e15a7db56bcf8d0b1b6ef632e&username=\(textUsername)&password=\(textPassword)"
            request.httpBody = postString.data(using: String.Encoding.utf8)
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                if error != nil { // обработка ошибки при отправке
                    self.erors = true
                    DispatchQueue.main.async{
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                    print("error=\(String(describing: error))")
                    return
                }
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                let errorString = "Optional({\"error\":\"invalid_grant\",\"error_description\":\"Неверное имя пользователя или пароль\"})"
                
                if errorString == String(describing: responseString) {
                    self.erors = true
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.Label.text = "Не правильный Логин или Пароль!";
                        return
                    }
                }
                else{
                    if self.erors == false{
                        let a = self.parseJSON(data: data! as NSData)
                        if a.go == 1{
                            if (self.erors == false){
                                DispatchQueue.main.async {
                                    self.showView(erors: self.erors as Bool)
                                }
                            }
                        }
                    }
                }
                print(String(describing: responseString))
                DispatchQueue.main.async{
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            task.resume()
        }
        else{
            self.Label.text = "Заполните все поля!";
        }
        
    }
    /**
     Функция парсинга ответа от сервера.
     
     *Values*
     
     `NegativeCount` The count is less than 0.
     
     `EmptyString1` The first string argument is empty.
     
     `EmptyString2` The second string argument is empty.
     
     - Author:
     Newbie
     - Version:
     0.1
     */
    func parseJSON(data: NSData) -> (Array<NSDictionary>, go: Int){
        let json = try! JSONSerialization.jsonObject(with: data as Data) as! NSDictionary
        let token = json["access_token"] as! String
        let firstName = json["firstName"] as! String
        let lastName = json["lastName"] as! String
        let patronymic = json["patronymic"] as! String
        let userId = json["userId"] as! String
        let userType = json["userType"] as! String
        
        DispatchQueue.main.async {
            
            let managedObjectContext = CoreDataManager.instance.managedObjectContext
            let entity =  NSEntityDescription.entity(forEntityName: "AuthData", in: managedObjectContext)
            let authData = NSManagedObject(entity: entity!, insertInto:managedObjectContext)
            authData.setValue(token, forKey: "token")
            authData.setValue(firstName, forKey: "firstName")
            authData.setValue(lastName, forKey: "lastName")
            authData.setValue(patronymic, forKey: "patronymic")
            authData.setValue(userId + userType, forKey: "userCode")
            
            CoreDataManager.instance.saveContext()
            
            let token1 = authData.value(forKey: "token")
            print("TOKEN = \(String(describing: token1))")
        }
        self.go = 1
        return ([json], go)
    }
    
    func showView(erors: Bool){
        if (self.erors == false){
            DispatchQueue.main.async {
                self.Label.text = "Отправка завершена!"; //данные отправлены
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar")
                self.present(vc!, animated: true, completion: nil)
            }
        }
    }
    
        
}




