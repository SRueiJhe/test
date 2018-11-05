import UIKit
import SideMenu

protocol MenuViewControllerDelegate: class {
    func menu(didSelectItemAt FirstIndex: Int)
    func menuDidCancel(_ menu: MenuViewController)
    /*---------------------------contentValueReturn 各種protocol---------------------------*/
    //func contentValueReturn(_ menu: MenuViewController, at point: CGPoint)
    func contentValueReturn(_ menu: MenuViewController, _ contentValue:main_menu0_contentType, at point: CGPoint)
    func contentValueReturn(_ menu: MenuViewController, _ contentValue:main_menu1_contentType, at point: CGPoint)
    func contentValueReturn(_ menu: MenuViewController, _ contentValue:main_menu2_contentType, at point: CGPoint)
    func contentValueReturn(_ menu: MenuViewController, _ contentValue:main_menu3_contentType, at point: CGPoint)
    func contentValueReturn(_ menu: MenuViewController, _ contentValue:main_menu4_contentType, at point: CGPoint)
    func contentValueReturn(_ menu: MenuViewController, _ contentValue:main_menu5_contentType, at point: CGPoint)
    func contentValueReturn(_ menu: MenuViewController, _ contentValue:main_menu6_contentType, at point: CGPoint)
    func contentValueReturn(_ menu: MenuViewController, _ contentValue:main_menu7_contentType, at point: CGPoint)
    func contentValueReturn(_ menu: MenuViewController, _ contentValue:main_menu8_contentType, at point: CGPoint)
    func contentValueReturn(_ menu: MenuViewController, _ contentValue:main_menu9_contentType, at point: CGPoint)

    /*---------------------------contentValueReturn 各種protocol---------------------------*/
}

class MenuViewController: UITableViewController {
    /*-------------------------------------第二層內容-------------------------------------*/
    fileprivate var main_menu0_contentType: main_menu0_contentType = .main_menu0_menu0
    fileprivate var main_menu1_contentType: main_menu1_contentType = .main_menu1_menu0
    fileprivate var main_menu2_contentType: main_menu2_contentType = .main_menu2_menu1
    fileprivate var main_menu3_contentType: main_menu3_contentType = .main_menu3_menu3
    fileprivate var main_menu4_contentType: main_menu4_contentType = .main_menu4_menu0
    fileprivate var main_menu5_contentType: main_menu5_contentType = .main_menu5_menu0
    fileprivate var main_menu6_contentType: main_menu6_contentType = .main_menu6_menu0
    fileprivate var main_menu7_contentType: main_menu7_contentType = .main_menu7_menu0
    fileprivate var main_menu8_contentType: main_menu8_contentType = .main_menu8_menu0
    fileprivate var main_menu9_contentType: main_menu9_contentType = .main_menu9_menu0

    /*-------------------------------------第二層內容-------------------------------------*/
    
    fileprivate var transitionPoint: CGPoint!
    weak var delegate: MenuViewControllerDelegate?
    
    lazy fileprivate var menuAnimator : MenuTransitionAnimator! = MenuTransitionAnimator(mode: .presentation, shouldPassEventsOutsideMenu: false) { [unowned self] in
        self.dismiss(animated: true, completion: nil)
    }                                                           //API所需
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let indexPath = IndexPath(row: 50, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch (segue.identifier, segue.destination) {
        
        case (.some("Menu0"), let SofaMenu as SofaMenuViewController):
            SofaMenu.delegate = self
            SofaMenu.transitioningDelegate = self
            SofaMenu.modalPresentationStyle = .custom
            
        case (.some("Menu1"), let main_menu1 as main_menu1_ViewController):
            main_menu1.delegate = self
            main_menu1.transitioningDelegate = self
            main_menu1.modalPresentationStyle = .custom
            
        case (.some("Menu2"), let main_menu2 as main_menu2_ViewController):
            main_menu2.delegate = self
            main_menu2.transitioningDelegate = self
            main_menu2.modalPresentationStyle = .custom
            
        case (.some("Menu3"), let main_menu3 as main_menu3_ViewController):
            main_menu3.delegate = self
            main_menu3.transitioningDelegate = self
            main_menu3.modalPresentationStyle = .custom
            
        case (.some("Menu4"), let main_menu4 as main_menu4_ViewController):
            main_menu4.delegate = self
            main_menu4.transitioningDelegate = self
            main_menu4.modalPresentationStyle = .custom
            
        case (.some("Menu5"), let main_menu5 as main_menu5_ViewController):
            main_menu5.delegate = self
            main_menu5.transitioningDelegate = self
            main_menu5.modalPresentationStyle = .custom
            
        case (.some("Menu6"), let main_menu6 as main_menu6_ViewController):
            main_menu6.delegate = self
            main_menu6.transitioningDelegate = self
            main_menu6.modalPresentationStyle = .custom
            
        case (.some("Menu7"), let main_menu7 as main_menu7_ViewController):
            main_menu7.delegate = self
            main_menu7.transitioningDelegate = self
            main_menu7.modalPresentationStyle = .custom
            
        case (.some("Menu8"), let main_menu8 as main_menu8_ViewController):
            main_menu8.delegate = self
            main_menu8.transitioningDelegate = self
            main_menu8.modalPresentationStyle = .custom
            
        case (.some("Menu9"), let main_menu9 as main_menu9_ViewController):
            main_menu9.delegate = self
            main_menu9.transitioningDelegate = self
            main_menu9.modalPresentationStyle = .custom
//
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension MenuViewController {
    @IBAction fileprivate func dismissMenu() {
        delegate?.menuDidCancel(self)
    }
}

extension MenuViewController: Menu {                                        //API所需
    var menuItems: [UIView] {
        return [tableView.tableHeaderView!] + tableView.visibleCells
    }
}

extension MenuViewController {
    
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rect = tableView.rectForRow(at: indexPath)
        var point = CGPoint(x: rect.midX, y: rect.midY)
        point = tableView.convert(point, to: nil)
        delegate?.menu(didSelectItemAt: indexPath.row)
    }
}

/*------------------------------MainMenuChild的Delegate------------------------------*/
extension MenuViewController: SofaMenuViewControllerDelegate {
    
    func SofaMenu(_: SofaMenuViewController, didSelectItemAt SecondIndex: Int, at point: CGPoint) {
        let queue = DispatchQueue(label:"queue")
        
        transitionPoint = point
        
        switch SecondIndex {
        case 0:
            main_menu0_contentType = .main_menu0_menu0
        case 1:
            main_menu0_contentType = .main_menu0_menu1
        case 2:
            main_menu0_contentType = .main_menu0_menu2
        case 3:
            main_menu0_contentType = .main_menu0_menu3
        case 4:
            main_menu0_contentType = .main_menu0_menu4
        case 5:
            main_menu0_contentType = .main_menu0_menu5
        case 6:
            main_menu0_contentType = .main_menu0_menu6
        case 7:
            main_menu0_contentType = .main_menu0_menu7
        case 8:
            main_menu0_contentType = .main_menu0_menu8
        case 9:
            main_menu0_contentType = .main_menu0_menu9
        default:
            print("安安")
        }
        delegate?.contentValueReturn(self, main_menu0_contentType, at: point)
        
        queue.sync {
            dismiss(animated: true, completion: nil)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func SofaMenuDidCancel(_: SofaMenuViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

/*-------------------------main_menu1_ViewControllerDelegate-------------------------*/
extension MenuViewController: main_menu1_ViewControllerDelegate {
    func main_menu1(_ main_menu1: main_menu1_ViewController, didSelectItemAt SecondIndex: Int, at point: CGPoint) {
        
        transitionPoint = point
        
        switch SecondIndex {
        case 0:     main_menu1_contentType = .main_menu1_menu0
        case 1:     main_menu1_contentType = .main_menu1_menu1
        case 2:     main_menu1_contentType = .main_menu1_menu2
        case 3:     main_menu1_contentType = .main_menu1_menu3
        case 4:     main_menu1_contentType = .main_menu1_menu4
        case 5:     main_menu1_contentType = .main_menu1_menu5
        case 6:     main_menu1_contentType = .main_menu1_menu6
        case 7:     main_menu1_contentType = .main_menu1_menu7
        case 8:     main_menu1_contentType = .main_menu1_menu8
        case 9:     main_menu1_contentType = .main_menu1_menu9

        default:    print("安安")
        }
        self.delegate?.contentValueReturn(self, main_menu1_contentType, at: point)
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func main_menu1_didCancel(_ main_menu1: main_menu1_ViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

/*-------------------------main_menu2_ViewControllerDelegate-------------------------*/
extension MenuViewController: main_menu2_ViewControllerDelegate {
    func main_menu2(_ main_menu2: main_menu2_ViewController, didSelectItemAt SecondIndex: Int, at point: CGPoint) {
        
        transitionPoint = point
        
        switch SecondIndex {
        case 0:     main_menu2_contentType = .main_menu2_menu0
        case 1:     main_menu2_contentType = .main_menu2_menu1
        case 2:     main_menu2_contentType = .main_menu2_menu2
        case 3:     main_menu2_contentType = .main_menu2_menu3
        case 4:     main_menu2_contentType = .main_menu2_menu4
        case 5:     main_menu2_contentType = .main_menu2_menu5
        case 6:     main_menu2_contentType = .main_menu2_menu6
        case 7:     main_menu2_contentType = .main_menu2_menu7
        case 8:     main_menu2_contentType = .main_menu2_menu8
        case 9:     main_menu2_contentType = .main_menu2_menu9
        default:    print("安安")
        }
        self.delegate?.contentValueReturn(self, main_menu2_contentType, at: point)
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func main_menu2_didCancel(_ main_menu2: main_menu2_ViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

/*-------------------------main_menu3_ViewControllerDelegate-------------------------*/
extension MenuViewController: main_menu3_ViewControllerDelegate {
    func main_menu3(_ main_menu3: main_menu3_ViewController, didSelectItemAt SecondIndex: Int, at point: CGPoint) {
        
        transitionPoint = point
        
        switch SecondIndex {
        case 0:     main_menu3_contentType = .main_menu3_menu0
        case 1:     main_menu3_contentType = .main_menu3_menu1
        case 2:     main_menu3_contentType = .main_menu3_menu2
        case 3:     main_menu3_contentType = .main_menu3_menu3
        case 4:     main_menu3_contentType = .main_menu3_menu4
        case 5:     main_menu3_contentType = .main_menu3_menu5
        case 6:     main_menu3_contentType = .main_menu3_menu6
        case 7:     main_menu3_contentType = .main_menu3_menu7
        case 8:     main_menu3_contentType = .main_menu3_menu8
        case 9:     main_menu3_contentType = .main_menu3_menu9
        default:    print("安安")
        }
        self.delegate?.contentValueReturn(self, main_menu3_contentType, at: point)
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func main_menu3_didCancel(_ main_menu3: main_menu3_ViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

/*-------------------------main_menu4_ViewControllerDelegate-------------------------*/
extension MenuViewController: main_menu4_ViewControllerDelegate {
    func main_menu4(_ main_menu4: main_menu4_ViewController, didSelectItemAt SecondIndex: Int, at point: CGPoint) {
        
        transitionPoint = point
        
        switch SecondIndex {
        case 0:     main_menu4_contentType = .main_menu4_menu0
        case 1:     main_menu4_contentType = .main_menu4_menu1
        case 2:     main_menu4_contentType = .main_menu4_menu2
        case 3:     main_menu4_contentType = .main_menu4_menu3
        case 4:     main_menu4_contentType = .main_menu4_menu4
        case 5:     main_menu4_contentType = .main_menu4_menu5
        case 6:     main_menu4_contentType = .main_menu4_menu6
        case 7:     main_menu4_contentType = .main_menu4_menu7
        case 8:     main_menu4_contentType = .main_menu4_menu8
        case 9:     main_menu4_contentType = .main_menu4_menu9
        default:    print("安安")
        }
        self.delegate?.contentValueReturn(self, main_menu4_contentType, at: point)
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func main_menu4_didCancel(_ main_menu4: main_menu4_ViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

/*-------------------------main_menu5_ViewControllerDelegate-------------------------*/
extension MenuViewController: main_menu5_ViewControllerDelegate {
    func main_menu5(_ main_menu5: main_menu5_ViewController, didSelectItemAt SecondIndex: Int, at point: CGPoint) {
        
        transitionPoint = point
        
        switch SecondIndex {
        case 0:     main_menu5_contentType = .main_menu5_menu0
        case 1:     main_menu5_contentType = .main_menu5_menu1
        case 2:     main_menu5_contentType = .main_menu5_menu2
        case 3:     main_menu5_contentType = .main_menu5_menu3
        case 4:     main_menu5_contentType = .main_menu5_menu4
        case 5:     main_menu5_contentType = .main_menu5_menu5
        case 6:     main_menu5_contentType = .main_menu5_menu6
        case 7:     main_menu5_contentType = .main_menu5_menu7
        case 8:     main_menu5_contentType = .main_menu5_menu8
        case 9:     main_menu5_contentType = .main_menu5_menu9
        default:    print("安安")
        }
        self.delegate?.contentValueReturn(self, main_menu5_contentType, at: point)
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func main_menu5_didCancel(_ main_menu5: main_menu5_ViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

/*-------------------------main_menu6_ViewControllerDelegate-------------------------*/
extension MenuViewController: main_menu6_ViewControllerDelegate {
    func main_menu6(_ main_menu6: main_menu6_ViewController, didSelectItemAt SecondIndex: Int, at point: CGPoint) {
        
        transitionPoint = point
        
        switch SecondIndex {
        case 0:     main_menu6_contentType = .main_menu6_menu0
        case 1:     main_menu6_contentType = .main_menu6_menu1
        case 2:     main_menu6_contentType = .main_menu6_menu2
        case 3:     main_menu6_contentType = .main_menu6_menu3
        case 4:     main_menu6_contentType = .main_menu6_menu4
        case 5:     main_menu6_contentType = .main_menu6_menu5
        case 6:     main_menu6_contentType = .main_menu6_menu6
        case 7:     main_menu6_contentType = .main_menu6_menu7
        case 8:     main_menu6_contentType = .main_menu6_menu8
        case 9:     main_menu6_contentType = .main_menu6_menu9
        default:    print("安安")
        }
        self.delegate?.contentValueReturn(self, main_menu6_contentType, at: point)
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func main_menu6_didCancel(_ main_menu6: main_menu6_ViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

/*-------------------------main_menu7_ViewControllerDelegate-------------------------*/
extension MenuViewController: main_menu7_ViewControllerDelegate {
    func main_menu7(_ main_menu7: main_menu7_ViewController, didSelectItemAt SecondIndex: Int, at point: CGPoint) {
        
        transitionPoint = point
        
        switch SecondIndex {
        case 0:     main_menu7_contentType = .main_menu7_menu0
        case 1:     main_menu7_contentType = .main_menu7_menu1
        case 2:     main_menu7_contentType = .main_menu7_menu2
        case 3:     main_menu7_contentType = .main_menu7_menu3
        case 4:     main_menu7_contentType = .main_menu7_menu4
        case 5:     main_menu7_contentType = .main_menu7_menu5
        case 6:     main_menu7_contentType = .main_menu7_menu6
        case 7:     main_menu7_contentType = .main_menu7_menu7
        case 8:     main_menu7_contentType = .main_menu7_menu8
        case 9:     main_menu7_contentType = .main_menu7_menu9
        default:    print("安安")
        }
        self.delegate?.contentValueReturn(self, main_menu7_contentType, at: point)

        
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func main_menu7_didCancel(_ main_menu7: main_menu7_ViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

/*-------------------------main_menu8_ViewControllerDelegate-------------------------*/
extension MenuViewController: main_menu8_ViewControllerDelegate {
    func main_menu8(_ main_menu8: main_menu8_ViewController, didSelectItemAt SecondIndex: Int, at point: CGPoint) {
        
        transitionPoint = point
        
        switch SecondIndex {
        case 0:     main_menu8_contentType = .main_menu8_menu0
        case 1:     main_menu8_contentType = .main_menu8_menu1
        case 2:     main_menu8_contentType = .main_menu8_menu2
        case 3:     main_menu8_contentType = .main_menu8_menu3
        case 4:     main_menu8_contentType = .main_menu8_menu4
        case 5:     main_menu8_contentType = .main_menu8_menu5
        case 6:     main_menu8_contentType = .main_menu8_menu6
        case 7:     main_menu8_contentType = .main_menu8_menu7
        case 8:     main_menu8_contentType = .main_menu8_menu8
        case 9:     main_menu8_contentType = .main_menu8_menu9
        default:    print("安安")
        }
        self.delegate?.contentValueReturn(self, main_menu8_contentType, at: point)
        
        
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func main_menu8_didCancel(_ main_menu8: main_menu8_ViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}

/*-------------------------main_menu9_ViewControllerDelegate-------------------------*/
extension MenuViewController: main_menu9_ViewControllerDelegate {
    func main_menu9(_ main_menu9: main_menu9_ViewController, didSelectItemAt SecondIndex: Int, at point: CGPoint) {
        
        transitionPoint = point
        
        switch SecondIndex {
        case 0:     main_menu9_contentType = .main_menu9_menu0
        case 1:     main_menu9_contentType = .main_menu9_menu1
        case 2:     main_menu9_contentType = .main_menu9_menu2
        case 3:     main_menu9_contentType = .main_menu9_menu3
        case 4:     main_menu9_contentType = .main_menu9_menu4
        case 5:     main_menu9_contentType = .main_menu9_menu5
        case 6:     main_menu9_contentType = .main_menu9_menu6
        case 7:     main_menu9_contentType = .main_menu9_menu7
        case 8:     main_menu9_contentType = .main_menu9_menu8
        case 9:     main_menu9_contentType = .main_menu9_menu9
        default:    print("安安")
        }
        self.delegate?.contentValueReturn(self, main_menu9_contentType, at: point)
        
        
        
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func main_menu9_didCancel(_ main_menu9: main_menu9_ViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
















extension MenuViewController: UINavigationControllerDelegate {
    
    func navigationController(_: UINavigationController, animationControllerFor _: UINavigationControllerOperation,
                              from _: UIViewController, to _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let transitionPoint = transitionPoint {
            return CircularRevealTransitionAnimator(center: transitionPoint)
        }
        return nil
    }
}

extension MenuViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting _: UIViewController,
                             source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return menuAnimator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MenuTransitionAnimator(mode: .dismissal)
    }
}



