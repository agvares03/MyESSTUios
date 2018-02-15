//
//  MessagViewController.swift
//  MyESSTUios
//
//  Created by Sergey Ivanov on 17.11.17.
//  Copyright © 2017 agvares. All rights reserved.
//

import UIKit
import CoreData

class MessageViewController: UIViewController, SlidingContainerViewControllerDelegate {
    
    var title1: [NSManagedObject] = []
    var text1: [NSManagedObject] = []
    var toDoItems :[String] = []
    var erors: Bool = false
    var name = [NSManagedObject]()
    var people = [NSManagedObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //getTokenValue()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let vc1 = viewControllerWithColorAndTitle(UIColor.white)
        let vc2 = viewControllerWithColorAndTitle(UIColor.white)
        let vc3 = viewControllerWithColorAndTitle(UIColor.white)
        let vc4 = viewControllerWithColorAndTitle(UIColor.white)
        
        let slidingContainerViewController = SlidingContainerViewController (
            parent: self,
            contentViewControllers: [vc1, vc2, vc3, vc4],
            titles: ["Диалоги", "Обсуждения", "Объявления", "Техподдержка"])
        
        view.addSubview(slidingContainerViewController.view)
        
        slidingContainerViewController.sliderView.appearance.outerPadding = 0
        slidingContainerViewController.sliderView.appearance.innerPadding = 50
        slidingContainerViewController.sliderView.appearance.fixedWidth = true
        slidingContainerViewController.setCurrentViewControllerAtIndex(0)
        slidingContainerViewController.delegate = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoItems.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell  = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = "Example"
        
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
    /*func getTokenValue() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = CoreDataManager.instance.saveContext()
        let contxt = managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity =  NSEntityDescription.entity(forEntityName: "AuthData", in: managedObjectContext)
        let authData = NSManagedObject(entity: entity!, insertInto:managedObjectContext)
        
        fetchRequest.entity = entity
        do {
            let result = try contxt.fetch(fetchRequest)
            if (result.count > 0) {
                _ = result[0] as! NSManagedObject
                
                if let token = authData.value(forKey: "token"){
                    self.updateSchedule(token: token as! String)
                }
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }*/

}
