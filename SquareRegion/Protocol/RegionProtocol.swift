//
//  RegionProtocolDelegate.swift
//  Square geofence region
//
//  Created by Yves Songolo on 2/8/19.
//  Copyright © 2019 Yves Songolo. All rights reserved.
//
import Foundation

protocol RegionProtocol {


    func updateRegion(region: CKSquareRegion, location: CLLocation)

    func didEnterRegion(region: CKSquareRegion)
    func didExitRegion(region: CKSquareRegion)
}

extension RegionProtocol{

    //    TODO: get the location and check weither the user was already in or out, If the user was marked in the region, when exited mark the user out of the region, also, keep track of user when they still inside or outside


    /// Method to check wether the user user walk in or out of the square region
    func updateRegion(region: CKSquareRegion, location: CLLocation){

        // check if the current location is within the square region
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

