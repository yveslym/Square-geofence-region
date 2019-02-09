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
        let defaults = UserDefaults.standard
        if let regions = defaults.value(forKey: "regions") as? [CKSquareRegion]{

            regions.forEach { (region) in


                if (region.contains(location.coordinate)){


                    let defaults = UserDefaults.standard
                    if let inSide = defaults.value(forKey: "inside") as? Bool {

                        if !inSide{
                            didEnterRegion(region: region)
                            defaults.set(true, forKey: "inside")
                        }
                    }

                    else{
                        didEnterRegion(region: region)
                        defaults.set(true, forKey: "inside")
                    }

                }
                else{

                    let defaults = UserDefaults.standard
                    if let inSide = defaults.value(forKey: "inside") as? Bool {
                        if inSide{
                            didExitRegion(region: region)
                            defaults.set(false, forKey: "inside")
                        }
                    }
                    else{
                        didExitRegion(region: region)
                        defaults.set(false, forKey: "inside")
                    }
                }
            }
        }
    }

    /// Method to add new region to monitor
    func addRegionToMonitor(region: CKSquareRegion){
        // TODO: - retrieve all the identifier from user default
        //       - if not exist create a new list
        // TODO: add new the identifier to the list of identifiers
        let defaults = UserDefaults.standard
        if var regions = defaults.value(forKey: "regions") as? [CKSquareRegion]{
            regions.append(region)
            defaults.set(regions, forKey: "regions")
        }
        else{
            defaults.set([region], forKey: "regions")
        }
    }

    /// Method to remove region from monitoring
    func removeRegionFromMonitor(identifier: String){

        // TODO: - Retrieve all region from userDefault
        //       - remove the region that correspond to the identifier

        if var regions = UserDefaults.standard.value(forKey: "regions") as? [CKSquareRegion]{

            if let index = regions.firstIndex(where: {$0.identifier == identifier}){
                regions.remove(at: index)
                UserDefaults.standard.set(regions, forKey: "Regions")
            }

        }
    }
}

