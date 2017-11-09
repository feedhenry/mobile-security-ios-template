//
//  BaseViewController.swift
//  secure-ios-app
//
//  Created by Wei Li on 03/11/2017.
//  Copyright © 2017 Wei Li. All rights reserved.
//

import UIKit

struct MenuItem {
    var title: String
    var icon: String
}

class BaseViewController: UIViewController {

    var menuDelegate: DrawerMenuDelegate?
    
    var arrayMenuOptions = [MenuItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentViewController(_ subViewNew:UIViewController, _ animated: Bool = true){
        //Add new view
        addChildViewController(subViewNew)
        subViewNew.view.frame = (self.parent?.view.frame)!
        view.addSubview(subViewNew.view)
        subViewNew.didMove(toParentViewController: self)
        
        //Remove old view
        if self.childViewControllers.count > 1 {
            //Remove old view
            let oldViewController: UIViewController = self.childViewControllers.first!
            oldViewController.willMove(toParentViewController: nil)
            oldViewController.view.removeFromSuperview()
            oldViewController.removeFromParentViewController()
        }
    }
    
    func addSlideMenuButton(){
        let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height
        let btnShowMenu = UIButton(type: UIButtonType.system)
        btnShowMenu.tintColor = UIColor.white
        btnShowMenu.setImage(UIImage(named: "ic_view_headline"), for: UIControlState())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: navigationBarHeight, height: navigationBarHeight)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.menuDelegate?.drawerMenuItemSelectedAtIndex(-1, false);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let menuVC : MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuVC.setMenuItems(arrayMenuOptions)
        menuVC.btnMenu = sender
        menuVC.delegate = self.menuDelegate
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        menuVC.resizeView()
        menuVC.appearWithAnimation()
        
    }
    
    func addMenuItem(titleOfChildView: String, iconName: String) {
        let menuItem: MenuItem = MenuItem(title: titleOfChildView, icon: iconName)
        arrayMenuOptions.append(menuItem)
    }
    
    func showFirstChild() {
        self.menuDelegate?.drawerMenuItemSelectedAtIndex(0, false)
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
