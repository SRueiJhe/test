//
//  PlaneNode.swift
//  ARKitPhyscsDetectionSample
//
//  Created by . SIN on 2017/08/27.
//  Copyright © 2017年 SAPPOROWORKS. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class PlaneNode: SCNNode {
    //fileprivate : 比 private 限制少
    fileprivate override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    init(anchor: ARPlaneAnchor) {
        super.init()
        
        geometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        eulerAngles.x = -.pi/2
        physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: geometry!, options: nil))
        setPhysicsBody()
    }
    
    func update(anchor: ARPlaneAnchor, material:String) {
        (geometry as! SCNPlane).width = CGFloat(anchor.extent.x)
        (geometry as! SCNPlane).height = CGFloat(anchor.extent.z)
        position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: geometry!, options: nil))
        setPhysicsBody()
        setPlaneMaterial(material: material)
    }
    
    func setPhysicsBody() {
        physicsBody?.categoryBitMask = 2
        physicsBody?.friction = 1 // 摩擦 0〜1.0 Default:0.5。0 1.0の場合は全く滑らなくなる
    }
    
    func setPlaneMaterial(material: String) {
            let planeMaterial = SCNMaterial()
            if material == ""{
                planeMaterial.diffuse.contents = UIImage(named: "BlueMesh")
            } else {
                planeMaterial.diffuse.contents = UIImage(named: material )
            }
            geometry?.materials = [planeMaterial]
    }
}
