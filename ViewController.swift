//
//  ViewController.swift
//  ARKitPhyscsDetectionSample
//
//  Created by . SIN on 2017/08/27.
//  Copyright © 2017年 SAPPOROWORKS. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    
    @IBOutlet weak var sceneView: ARSCNView!
    //@IBOutlet var sceneView: ARSCNView!
    private var currentTrackingPosition: CGPoint?
    var nodeIsPaned: SCNNode? = nil
    var nodeIsTaped: SCNNode? = nil
    var moveAxis: String = "null"
    var planeMaterial: String = "BlueMesh"
    var dragOffset = CGPoint()
    var manual: String = "透過移動捕捉平面資訊\n≡ : 傢俱選單 \nRESET:清除場面傢俱\n＿＿＿＿＿＿＿＿＿＿＿\n對於單一傢俱:\n選取可拖曳搬移也可透過雙指進行旋轉\nDelete:刪除傢俱\nRotate:傢俱旋轉九十度"

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var showAlert: UIButton!
    
    var furniteArray:[Furniture] = []
    var planeNodes:[PlaneNode] = []
    
    fileprivate var NavigationContentType           : main_menu0_contentType = .main_menu0_menu0
    fileprivate var main_menu1_NavigationContentType: main_menu1_contentType = .main_menu1_menu0
    fileprivate var main_menu2_NavigationContentType: main_menu2_contentType = .main_menu2_menu0
    fileprivate var main_menu3_NavigationContentType: main_menu3_contentType = .main_menu3_menu0
    fileprivate var main_menu4_NavigationContentType: main_menu4_contentType = .main_menu4_menu0
    fileprivate var main_menu5_NavigationContentType: main_menu5_contentType = .main_menu5_menu0
    fileprivate var main_menu6_NavigationContentType: main_menu6_contentType = .main_menu6_menu0
    fileprivate var main_menu7_NavigationContentType: main_menu7_contentType = .main_menu7_menu0
    fileprivate var main_menu8_NavigationContentType: main_menu8_contentType = .main_menu8_menu0
    fileprivate var main_menu9_NavigationContentType: main_menu9_contentType = .main_menu9_menu0

    
    fileprivate var FirstselectedIndex = 0
    fileprivate var transitionPoint: CGPoint!                       //動畫用
    lazy fileprivate var menuAnimator : MenuTransitionAnimator! = MenuTransitionAnimator(mode: .presentation, shouldPassEventsOutsideMenu: false) { [unowned self] in
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch (segue.identifier, segue.destination) {
            
        case (.some("presentMenu"), let menu as MenuViewController):
            DispatchQueue.main.async {
                menu.delegate = self
            }
            menu.transitioningDelegate = self
            menu.modalPresentationStyle = .custom
            
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    
    
    //view 被載入時呼叫
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        addGestureRecongnizer()
        deleteButton.isHidden = true
        rotateButton.isHidden = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    //view 要被呈現前，viewDidLoad()之後
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpSceneView()
    }
    
    func setUpSceneView(){
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    //view 要結束前，viewWillAppear()之後
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    //告訴委託人，新的AR錨點對應的SceneKit節點已被添加到場景中。
    // MARK: - ARSCNViewDelegate      ARAnchor : AR場景中的真實世界位置和方向
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let planeAnchor = anchor as? ARPlaneAnchor {
                // 平面を表現するノードを追加する
                let panelNode = PlaneNode(anchor: planeAnchor)
                panelNode.setPlaneMaterial(material: self.planeMaterial)
                node.addChildNode(panelNode)
                self.planeNodes.append(panelNode)
            }
        }//End of DispatchQueue.main.async
    }//End of renderer(didAdd)
    
    //告訴委託人SceneKit節點的屬性已經更新
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        DispatchQueue.main.async {
            var configuration: ARWorldTrackingConfiguration
            configuration = self.sceneView.session.configuration as! ARWorldTrackingConfiguration
            if let planeAnchor = anchor as? ARPlaneAnchor, let planeNode = node.childNodes[0] as? PlaneNode {
                self.sceneView.session.run(configuration)
                switch self.FirstselectedIndex{
                    case 10:
                        planeNode.update(anchor: planeAnchor, material: self.main_menu9_NavigationContentType.rawValue)
                        self.planeMaterial = self.main_menu9_NavigationContentType.rawValue
                    default:
                planeNode.update(anchor: planeAnchor, material: self.planeMaterial)
                }//End of switch
            }//
        }//End of DispatchQueue.main.async
    }//End of renderer(didUpdate)
    
    //加入手勢識別器
    func addGestureRecongnizer() {
        //UITapGestureRecognizer : 手勢識別器 (手指點擊)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapRecognizer)
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(paned))
        self.sceneView.addGestureRecognizer(panRecognizer)
        let rotationRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(rotation))
        self.sceneView.addGestureRecognizer(rotationRecognizer)
    }
    
    //觸發手勢後執行動作的方法 (手指點擊)
    @objc func tapped(_ recognizer: UITapGestureRecognizer) {
        deleteButton.isHidden = true
        rotateButton.isHidden = true
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        var node = hitTestResults.first?.node
        if node?.name == nil{
            let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
            if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                switch FirstselectedIndex{
                case 0:
                    break;
                case 1:
                    let furnitureObject = Furniture(sceneName: NavigationContentType.rawValue)
                    furnitureObject.setLoation(hitTestResult: hitTestResultWithFeaturePoints)
                    furniteArray.append(furnitureObject)
                    sceneView.scene.rootNode.addChildNode((furnitureObject.getNode()))
                    FirstselectedIndex = 0
                case 2:
                    let furnitureObject = Furniture(sceneName: main_menu1_NavigationContentType.rawValue)
                    furnitureObject.setLoation(hitTestResult: hitTestResultWithFeaturePoints)
                    furniteArray.append(furnitureObject)
                    sceneView.scene.rootNode.addChildNode((furnitureObject.getNode()))
                    FirstselectedIndex = 0
                case 3:
                    let furnitureObject = Furniture(sceneName: main_menu2_NavigationContentType.rawValue)
                    furnitureObject.setLoation(hitTestResult: hitTestResultWithFeaturePoints)
                    furniteArray.append(furnitureObject)
                    sceneView.scene.rootNode.addChildNode((furnitureObject.getNode()))
                    FirstselectedIndex = 0
                case 4:
                    let furnitureObject = Furniture(sceneName: main_menu3_NavigationContentType.rawValue)
                    furnitureObject.setLoation(hitTestResult: hitTestResultWithFeaturePoints)
                    furniteArray.append(furnitureObject)
                    sceneView.scene.rootNode.addChildNode((furnitureObject.getNode()))
                    FirstselectedIndex = 0
                case 5:
                    let furnitureObject = Furniture(sceneName: main_menu4_NavigationContentType.rawValue)
                    furnitureObject.setLoation(hitTestResult: hitTestResultWithFeaturePoints)
                    furniteArray.append(furnitureObject)
                    sceneView.scene.rootNode.addChildNode((furnitureObject.getNode()))
                    FirstselectedIndex = 0
                case 6:
                    let furnitureObject = Furniture(sceneName: main_menu5_NavigationContentType.rawValue)
                    furnitureObject.setLoation(hitTestResult: hitTestResultWithFeaturePoints)
                    furniteArray.append(furnitureObject)
                    sceneView.scene.rootNode.addChildNode((furnitureObject.getNode()))
                    FirstselectedIndex = 0
                case 7:
                    let furnitureObject = Furniture(sceneName: main_menu6_NavigationContentType.rawValue)
                    furnitureObject.setLoation(hitTestResult: hitTestResultWithFeaturePoints)
                    furniteArray.append(furnitureObject)
                    sceneView.scene.rootNode.addChildNode((furnitureObject.getNode()))
                    FirstselectedIndex = 0
                case 8:
                    let furnitureObject = Furniture(sceneName: main_menu7_NavigationContentType.rawValue)
                    furnitureObject.setLoation(hitTestResult: hitTestResultWithFeaturePoints)
                    furniteArray.append(furnitureObject)
                    sceneView.scene.rootNode.addChildNode((furnitureObject.getNode()))
                    FirstselectedIndex = 0
                case 9:
                    let furnitureObject = Furniture(sceneName: main_menu8_NavigationContentType.rawValue)
                    furnitureObject.setLoation(hitTestResult: hitTestResultWithFeaturePoints)
                    furniteArray.append(furnitureObject)
                    sceneView.scene.rootNode.addChildNode((furnitureObject.getNode()))
                    FirstselectedIndex = 0
                default:
                    break;
                }//End of switch
                nodeIsTaped = nil
            }//
        }else{
            deleteButton.isHidden = false
            rotateButton.isHidden = false
            if node?.name != nil{
                if node?.name == "AddedObject"{
                    nodeIsTaped = node
                }else{
                    while node?.parent?.name != "AddedObject"{
                        node = node?.parent
                    }
                    nodeIsTaped = node?.parent
                }

            }
        }///
    }//End of taped method
    
    //觸發手勢後執行動作的方法 (手指滑移)
    @objc func paned(_ recognizer: UIPanGestureRecognizer) {
        if nodeIsTaped?.name == nil{
            switch recognizer.state{
            case .began:
                let touchLocation = recognizer.location(in: sceneView)
                let hitTestResults = sceneView.hitTest(touchLocation)
                var node = hitTestResults.first?.node
                if node?.name != nil{
                    if node?.name == "AddedObject"{
                        nodeIsPaned = node
                    }else{
                        while node?.parent?.name != "AddedObject"{
                            node = node?.parent
                        }
                        nodeIsPaned = node?.parent
                    }
                }
            case .changed:
                moveNodeByPanGR(recognizer: recognizer)
            case .ended:
                moveNodeByPanGR(recognizer: recognizer)
                nodeIsPaned = nil
                currentTrackingPosition = nil
            default:
                break
            }
        }
    }//End of paned Method
    func moveNodeByPanGR(recognizer: UIPanGestureRecognizer) {
        if nodeIsPaned?.name != nil{
            let latestTouchLocation = recognizer.location(in: sceneView)
            let planeHitTestResults = sceneView.hitTest(latestTouchLocation, types: .estimatedHorizontalPlane)
            var newPosition = float3()
            if let result = planeHitTestResults.first {
                newPosition = result.worldTransform.translation
                nodeIsPaned?.simdPosition = newPosition
            }
        }///
    }//End of moveNodeByPanGR method
    
    @objc func rotation(_ recognizer: UIRotationGestureRecognizer) {
        if nodeIsTaped?.name != nil{
            let touchLocation = recognizer.location(in: sceneView)
            let hitTestResults = sceneView.hitTest(touchLocation, options: nil)
            var node = hitTestResults.first?.node
            if node?.name != nil{
                if node?.name == "AddedObject"{
                    let angle = recognizer.rotation
                    node?.eulerAngles = SCNVector3(0, -angle, 0)
                }else{
                    while node?.parent?.name != "AddedObject"{
                        node = node?.parent
                    }
                    let angle = recognizer.rotation
                    node?.eulerAngles = SCNVector3(0, -angle, 0)
                }
            }
        }
    }//End of rotation method
    @IBAction func showAlert(_ sender: Any) {
        let alert = UIAlertController(title:"使用方法", message: manual, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func featuresButtonClick(_ sender: UIButton) {
        switch (sender.titleLabel?.text)!{
        case "Delete":
            nodeIsTaped?.removeFromParentNode()
            deleteButton.isHidden = true
            rotateButton.isHidden = true
            moveAxis = "null"
        case "Rotate":
            let oldTransform = nodeIsTaped?.transform
            let rotation = SCNMatrix4MakeRotation(Float(Double.pi/2), 0, 1, 0)
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            nodeIsTaped?.transform = SCNMatrix4Mult(rotation, oldTransform!)
            SCNTransaction.commit()
        case "RESET":
            for furnite in furniteArray{
                furnite.getNode().removeFromParentNode()
            }
            furniteArray.removeAll()
        default:
            moveAxis = (sender.titleLabel?.text)!
        }//End of switch
    }//End of featureButtonClick Method
    
    
    
    func isNodePartOfVirtualObject(_ node: SCNNode) -> Furniture? {
        if node.parent?.name != "AddedObject"{
            return isNodePartOfVirtualObject(node.parent!)
        }else{
            return nil
        }
    }
    
    
}//End of ViewController

extension ViewController: MenuViewControllerDelegate {
    /*-----------------------------contentValueReturn 各種型態-----------------------------*/
    func contentValueReturn(_ menu: MenuViewController, _ contentValue: main_menu0_contentType, at point: CGPoint){
        NavigationContentType = contentValue
        transitionPoint = point
    }
    
    func contentValueReturn(_ menu: MenuViewController, _ contentValue: main_menu1_contentType, at point: CGPoint){
        main_menu1_NavigationContentType = contentValue
        transitionPoint = point
    }
    func contentValueReturn(_ menu: MenuViewController, _ contentValue: main_menu2_contentType, at point: CGPoint){
        main_menu2_NavigationContentType = contentValue
        transitionPoint = point
    }
    func contentValueReturn(_ menu: MenuViewController, _ contentValue: main_menu3_contentType, at point: CGPoint){
        main_menu3_NavigationContentType = contentValue
        transitionPoint = point
    }
    func contentValueReturn(_ menu: MenuViewController, _ contentValue: main_menu4_contentType, at point: CGPoint){
        main_menu4_NavigationContentType = contentValue
        transitionPoint = point
    }
    func contentValueReturn(_ menu: MenuViewController, _ contentValue: main_menu5_contentType, at point: CGPoint){
        main_menu5_NavigationContentType = contentValue
        transitionPoint = point
    }
    func contentValueReturn(_ menu: MenuViewController, _ contentValue: main_menu6_contentType, at point: CGPoint){
        main_menu6_NavigationContentType = contentValue
        transitionPoint = point
    }
    func contentValueReturn(_ menu: MenuViewController, _ contentValue: main_menu7_contentType, at point: CGPoint){
        main_menu7_NavigationContentType = contentValue
        transitionPoint = point
    }
    func contentValueReturn(_ menu: MenuViewController, _ contentValue: main_menu8_contentType, at point: CGPoint){
        main_menu8_NavigationContentType = contentValue
        transitionPoint = point
    }
    func contentValueReturn(_ menu: MenuViewController, _ contentValue: main_menu9_contentType, at point: CGPoint){
        main_menu9_NavigationContentType = contentValue
        transitionPoint = point
    }
    /*-----------------------------contentValueReturn 各種型態-----------------------------*/
    
    func menu(didSelectItemAt FirstIndex: Int){
     FirstselectedIndex = FirstIndex+1
    }
    
    func menuDidCancel(_: MenuViewController) {
        dismiss(animated: true, completion:nil)
    }
    
//    func session(_ session: ARSession, didUpdate frame: ARFrame){
//        let currentTransform = frame.camera.transform
//
//    }
}



extension float4x4 {
    /// Treats matrix as a (right-hand column-major convention) transform matrix
    /// and factors out the translation component of the transform.
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}

extension CGPoint {
    
    init(_ size: CGSize) {
        self.init()
        self.x = size.width
        self.y = size.height
    }
    
    init(_ vector: SCNVector3) {
        self.init()
        self.x = CGFloat(vector.x)
        self.y = CGFloat(vector.y)
    }
    
    func distanceTo(_ point: CGPoint) -> CGFloat {
        return (self - point).length()
    }
    
    func length() -> CGFloat {
        return sqrt(self.x * self.x + self.y * self.y)
    }
    
    func midpoint(_ point: CGPoint) -> CGPoint {
        return (self + point) / 2
    }
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static func += (left: inout CGPoint, right: CGPoint) {
        left = left + right
    }
    
    static func -= (left: inout CGPoint, right: CGPoint) {
        left = left - right
    }
    
    static func / (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x / right, y: left.y / right)
    }
    
    static func * (left: CGPoint, right: CGFloat) -> CGPoint {
        return CGPoint(x: left.x * right, y: left.y * right)
    }
    
    static func /= (left: inout CGPoint, right: CGFloat) {
        left = left / right
    }
    
    static func *= (left: inout CGPoint, right: CGFloat) {
        left = left * right
    }
}


extension ViewController: UINavigationControllerDelegate {
    
    func navigationController(_: UINavigationController, animationControllerFor _: UINavigationControllerOperation,
                              from _: UIViewController, to _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let transitionPoint = transitionPoint {
            return CircularRevealTransitionAnimator(center: transitionPoint)
        }
        return nil
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting _: UIViewController,
                             source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return menuAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MenuTransitionAnimator(mode: .dismissal)
    }
}
