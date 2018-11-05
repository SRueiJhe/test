//
//  Furniture.swift
//  ARKitPhyscsDetectionSample
//
//  Created by 泳鏡 on 2017/11/28.
//  Copyright © 2017年 SAPPOROWORKS. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class Furniture {
    
    // SCNScene : 存放所有3D幾何體的容器
    // SCNNode : 將幾何體包裝為node以便添加到scene
    // scene.rootNode : 所以場景都以節點層次結構組織在一個共同的根節點中
    private var furnitureNode = SCNNode()
    private var furnitureScene: SCNScene
    init(sceneName: String){
        furnitureScene = SCNScene(named: sceneName)!
        let furnitureSeceneChildNode = furnitureScene.rootNode.childNodes
        for childNode in furnitureSeceneChildNode{
            furnitureNode.addChildNode(childNode)
        }
        furnitureNode.name = "AddedObject"
        furnitureNode.scale = SCNVector3(15,15,15)
        //設定燈光（預設）
        furnitureNode.physicsBody?.categoryBitMask = 1
    }
    
    //設定物件位置
    func setLoation(hitTestResult: ARHitTestResult){
        let translation = hitTestResult.worldTransform
        let x = translation.columns.3.x
        let y = translation.columns.3.y
        let z = translation.columns.3.z
        furnitureNode.position = SCNVector3(x,y,z)
        //        furnitureNode.position = SCNVector3(hitTestResult.worldTransform.columns.3.x, hitTestResult.worldTransform.columns.3.y, hitTestResult.worldTransform.columns.3.z)
    }
    
    func getNode() -> SCNNode{
        return furnitureNode
        
    }
}

