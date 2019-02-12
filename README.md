# SQUARE REGION GEOFENCE

## Overview

square region geofence is a lightweight geofence pod that allows you to cfreate a squared region which is an alternative to circular region.

## Demo


![demo](https://imgur.com/emKNAoy.gif)



## Installing with CocoaPods

1. Add the pod SquareRegion to your Podfile:

```
pod 'SquareRegion'
```
2. Run:

```
pod install
```
## Usage:



1. import 
```
import SquareRegion
```
2. Set Delegate

```
class   ViewController: UIViewController, SquareRegionProtocol, CLLocationManagerDelegate
{
```
3. Initialize

```
var delegate : SquareRegionProtocol

```
> On viewDidload

```
delegate = self
```
4. Start Location Monitoring
> on **didUpdateLocations** delegate method of CLLocationManagerDelegate

```
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

if let location = locations.first{

delegate.updateRegion(location: location)

    }
}

```
5. Implement the SquareRegionProtocol delegate method

```
extension   ViewController: SquareRegionProtocol {

  func didEnterRegion(region: CKSquareRegion) {

  print("enter")

  }
  func didExitRegion(region: CKSquareRegion) {

  print("leave")
  }
}
```

6. Add and remove region

```
let center =  CLLocationCoordinate2D.init(latitude: 37.787689, longitude: -122.410929)

// length is in kilometers, 
//so you need to convert to meters
// for this exemple it is 35 meters
  let length =  0.035 


let squareRegion = CKSquareRegion.init(regionWithCenter: center, sideLength: length, identifier: "steakHouse")

// Add region
delegate.addRegionToMonitor(region: squareRegion!)

// remove region
delegate..removeRegionFromMonitor(identifier: "steakHouse")

```
## Note:

* The sideLength is in kilometers, so you will have to convert to meters

* you can monitor more than one location
## License

MIT License