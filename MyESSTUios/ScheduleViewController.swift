//
//  DemoViewController.swift
//  SlidingContainerViewController
//
//  Created by Cem Olcay on 10/04/15.
//  Copyright (c) 2015 Cem Olcay. All rights reserved.
//

import UIKit
import CoreData

class ScheduleViewController: UIViewController, SlidingContainerViewControllerDelegate {

    var fetchedResultsController:NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AuthData")
        let sortDescriptor = NSSortDescriptor(key: "token", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    var title1: [NSManagedObject] = []
    var text1: [NSManagedObject] = []
    var toDoItems :[String] = []
    var erors: Bool = false
    var name = [NSManagedObject]()
  var people = [NSManagedObject]()
  override func viewDidLoad() {
    super.viewDidLoad()
    getTokenValue()
  }

  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    let vc1 = viewControllerWithColorAndTitle(UIColor.white)
    let vc2 = viewControllerWithColorAndTitle(UIColor.white)
    let vc3 = viewControllerWithColorAndTitle(UIColor.white)
    let vc4 = viewControllerWithColorAndTitle(UIColor.white)
    let vc5 = viewControllerWithColorAndTitle(UIColor.white)
    let vc6 = viewControllerWithColorAndTitle(UIColor.white)

    let slidingContainerViewController = SlidingContainerViewController (
      parent: self,
      contentViewControllers: [vc1, vc2, vc3, vc4, vc5, vc6],
      titles: ["ПН", "ВТ", "СР", "ЧТ", "ПТ", "СБ"])

    view.addSubview(slidingContainerViewController.view)

    slidingContainerViewController.sliderView.appearance.outerPadding = 0
    slidingContainerViewController.sliderView.appearance.innerPadding = 50
    slidingContainerViewController.sliderView.appearance.fixedWidth = true
    slidingContainerViewController.setCurrentViewControllerAtIndex(0)
    slidingContainerViewController.delegate = self
  }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
        return toDoItems.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let customer = fetchedResultsController.object(at: indexPath as IndexPath) as! AuthData
        let cell = UITableViewCell()
        cell.textLabel?.text = customer.firstName
        return cell
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard (UIApplication.shared.delegate as? AppDelegate) != nil else {return}
        
        let managedContext = CoreDataManager.instance.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AuthData")
        
        do {
            title1 = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            text1 = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Fetch error \(error)")
        }
        self.viewControllerWithColorAndTitle(UIColor.white).reloadInputViews()
    }
    
    

  func viewControllerWithColorAndTitle (_ color: UIColor) -> UITableViewController {
    let vc = UITableViewController()
    vc.view.backgroundColor = color

    let label = UILabel (frame: vc.view.frame)
    label.textColor = UIColor.black
    label.font = UIFont (name: "HelveticaNeue-Light", size: 25)
    label.text = title

    label.sizeToFit()
    label.center = view.center

    vc.view.addSubview(label)

    return vc 
  }

  // MARK: SlidingContainerViewControllerDelegate
  
  func slidingContainerViewControllerDidMoveToViewController(_ slidingContainerViewController: SlidingContainerViewController, viewController: UIViewController, atIndex: Int) {

  }

  func slidingContainerViewControllerDidShowSliderView(_ slidingContainerViewController: SlidingContainerViewController) {

  }

  func slidingContainerViewControllerDidHideSliderView(_ slidingContainerViewController: SlidingContainerViewController) {

  }
    func getTokenValue() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AuthData")
        do {
            let results = try CoreDataManager.instance.managedObjectContext.fetch(fetchRequest)
            for result in results as! [AuthData] {
                let token = result.value(forKey: "token")
                if token != nil{
                    self.updateSchedule(token: token as! String)
                }
                print("TOKEN 2 = \(String(describing: token))")
            }
        } catch {
            print(error)
        }
    }
    
    
    func updateSchedule(token: String){
        
        guard let myUrl = NSURL(string: "https://esstu.ru/lk/api/v1/schedule/getSchedule") else { return }
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
    
//    func parseJSONSchedule(data: NSData) -> (Array<NSDictionary>, go: Int){
//        let json = try! JSONSerialization.jsonObject(with: data as Data) as! NSDictionary
//        let token = json["access_token"] as! String
//        let firstName = json["firstName"] as! String
//        let lastName = json["lastName"] as! String
//        let patronymic = json["patronymic"] as! String
//        let userId = json["userId"] as! String
//        let userType = json["userType"] as! String
//
//        DispatchQueue.main.async {
//
//            let managedObjectContext = CoreDataManager.instance.managedObjectContext
//            let entity =  NSEntityDescription.entity(forEntityName: "AuthData", in: managedObjectContext)
//            let authData = NSManagedObject(entity: entity!, insertInto:managedObjectContext)
//            authData.setValue(token, forKey: "token")
//            authData.setValue(firstName, forKey: "firstName")
//            authData.setValue(lastName, forKey: "lastName")
//            authData.setValue(patronymic, forKey: "patronymic")
//            authData.setValue(userId + userType, forKey: "userCode")
//
//            CoreDataManager.instance.saveContext()
//
//            let token1 = authData.value(forKey: "token")
//            print("TOKEN = \(String(describing: token1))")
//        }
//        self.go = 1
//        return ([json], go)
//    }
    
}
