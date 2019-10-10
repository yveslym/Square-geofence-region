//
//  RegionProtocolDelegate.swift
//  Square geofence region
//
//  Created by Yves Songolo on 2/8/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//
import Foundation

public protocol RegionProtocol: class {


    func updateRegion(location: CLLocation)

    func didEnterRegion(region: CKSquareRegion)
    func didExitRegion(region: CKSquareRegion)
    func addRegionToMonitor(region: CKSquareRegion)
    func removeRegionFromMonitor(identifier: String)
}

public extension RegionProtocol{

    //    TODO: get the location and check weither the user was already in or out, If the user was marked in the region, when exited mark the user out of the region, also, keep track of user when they still inside or outside


    /// Method to check wether the user user walk in or out of the square region
    func updateRegion(location: CLLocation){

        // check if the current location is within the square region

        if let regions = retrieveRegions(){

//            regions.forEach { (region) in
            for (_, region) in regions {
                let RegionLocation = CLLocation.init(latitude: region.latitude, longitude: region.longitude)
                let distance = location.distance(from: RegionLocation)


                let sqRegion = CKSquareRegion.init(ckregion: region)

                // enter in the region
                if sqRegion.contains(location.coordinate) && distance < (region.sideLenghR * 1000) && region.entryRegion {

                    let defaults = UserDefaults.standard

                    // retrieve the last status
                    if let inSide = defaults.value(forKey: region.identifierR) as? Bool {

                        if !inSide{
                            didEnterRegion(region: sqRegion)
                            defaults.set(true, forKey: region.identifierR)
                        }
                    }

                    else{

                        defaults.set(true, forKey: region.identifier)
                    }

                }
                    
                else if region.exitRegion == true {
                    
                    // check wether the exit should be monitor or not
                    let defaults = UserDefaults.standard
                    if let inSide = defaults.value(forKey: sqRegion.identifier) as? Bool {
                        if inSide {
                            didExitRegion(region: sqRegion)
                            defaults.set(false, forKey: sqRegion.identifier)
                        }
                    }
                    else{

                        defaults.set(false, forKey: sqRegion.identifier)
                    }
                }
            }
        }
       
    }

    private func retrieveRegions() -> [String:YVSquareRegion]?{
        if let data = UserDefaults.standard.value(forKey: "regionData") as? Data{
            do{
                let regions = try JSONDecoder().decode([String:YVSquareRegion].self, from: data)

                return regions
            }
            catch{
                return nil
            }
        }
        return nil
    }
    /// Method to add new region to monitor
    func addRegionToMonitor(region: CKSquareRegion) {
        // TODO: - retrieve all the region from user default
        //       - if not exist create a new list
        // TODO: add new the region to the list of identifiers
        let newRegion = YVSquareRegion(region: region)
        if var regions = retrieveRegions(){

            regions[newRegion.identifierR] = newRegion

            let data =  try! JSONEncoder().encode(regions)
            UserDefaults.standard.set( data, forKey: "regionData")
        }
        else {
            let newRegion = YVSquareRegion.init(region: region)

            let data = try! JSONEncoder().encode([newRegion.identifierR:newRegion])
            UserDefaults.standard.set( data, forKey: "regionData")
        }
    }

    /// Method to remove region from monitoring
    func removeRegionFromMonitor(identifier: String) {

        // TODO: - Retrieve all region from userDefault
        //       - remove the region that correspond to the identifier

        if var regions = retrieveRegions(){

            _ = regions.removeValue(forKey: identifier)

            let data =  try! JSONEncoder().encode(regions)
            UserDefaults.standard.set( data, forKey: "regionData")
        }
    }
}

public class YVSquareRegion: CKSquareRegion, Codable{

    public var longitude: Double
    public var latitude: Double
    public var identifierR: String
    public let sideLenghR: CLLocationDistance
    public var entryRegion: Bool
    public var exitRegion: Bool

    override init!(regionWithCenter center: CLLocationCoordinate2D, sideLength: CLLocationDistance, identifier: String!, onEntry: Bool, onExit: Bool) {
        
         identifierR = identifier
        sideLenghR = sideLength
        longitude = center.longitude
        latitude = center.latitude
        self.entryRegion = onEntry
        self.exitRegion = onExit
        
        super.init(regionWithCenter: center, sideLength: sideLength, identifier: identifier, onEntry: onEntry, onExit: onExit)
        //super.init(regionWithCenter: center, sideLength: sideLength, identifier: identifier)

    }
    public init(region: CKSquareRegion) {

        //centerR = region.center
        sideLenghR = region.sideLengh
        identifierR = region.identifier
        longitude = region.center.longitude
        latitude = region.center.latitude
        self.entryRegion = region.onEntry
        self.exitRegion = region.onExit
        
        super.init(regionWithCenter: region.center, sideLength: region.sideLengh, identifier: region.identifier, onEntry: region.onEntry, onExit: region.onExit)

    }
}

extension CKSquareRegion{
    public convenience init(ckregion: YVSquareRegion) {
       let center = CLLocationCoordinate2D.init(latitude: ckregion.latitude, longitude: ckregion.longitude)
        self.init(regionWithCenter: center, sideLength: ckregion.sideLenghR, identifier: ckregion.identifierR, onEntry: ckregion.entryRegion,onExit: ckregion.onExit)
    }
}
