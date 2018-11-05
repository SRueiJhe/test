//
//  FurnitureImageList.swift
//  ARKitPhyscsDetectionSample
//
//  Created by 泳鏡 on 2018/2/6.
//  Copyright © 2018年 SAPPOROWORKS. All rights reserved.
//

import Foundation

struct FurnitureImageList{
    static var furnitureList: Dictionary<String, String> = {
        let furnitureImage = [
            "0" : "art.scnassets/Sofa/BritishSofa/BritishSofa.dae",
            "1" : "art.scnassets/Appliances/BeoVisionAvant/BeoVisionAvant.dae",
            "2" : "art.scnassets/Bathroom/Bad/Bad.dae",
            "3" : "art.scnassets/Chair/ACEasyChair/ACEasyChair.dae",
            "4" : "art.scnassets/Chair/ArmChair/ArmChair.dae",
            "5" : "art.scnassets/CoffeeTable/AdessoCafeTableAndChairsWoodFMH/AdessoCafeTableAndChairsWoodFMH.dae",
            "6" : "art.scnassets/Sofa/BlackSofa/BlackSofa.dae",
            "7" : "art.scnassets/Sofa/BonTonChair/BonTonChair.dae",
            "8" : "art.scnassets/Chair/StudyChair/StudyChair.dae",
            "9" : "art.scnassets/Appliances/TV43/TV43.dae",
            "10" : "art.scnassets/Bathroom/DOUBLESINKBATHROOM/DOUBLESINKBATHROOM.dae",
            "11" : "art.scnassets/Sofa/ZatteraSofa/ZatteraSofa.dae",
            "12" : "art.scnassets/Sofa/ZebraSofa/ZebraSofa.dae",
            "13" : "art.scnassets/Table/ButterflytSU6/ButterflytSU6.dae",
            "14" : "art.scnassets/Table/CoffeeTable/CoffeeTable.dae",
            "15" : "art.scnassets/Table/ConferenceTable/ConferenceTable.dae",
            "16" : "art.scnassets/Table/TeakCoffeeTable/TeakCoffeeTable.dae",
            "17" : "art.scnassets/Table/VilabyCoffeeTable/VilabyCoffeeTable.dae"
        ]
        var urls = Dictionary<String, String>()
        for(key, value) in furnitureImage {
            urls[key] = value
        }
        return urls
    }()
}
