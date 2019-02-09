# SQUARE REGION GEOFENCE

## Overview

square region geofence is a lightweight geofence pod that allows you to cfreate a squared region which is an alternative to circular region.

## Demo


![ima](https://imgur.com/mpPMBfw.gif)


## Installing with CocoaPods

1. Add the following line to your Podfile:

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
let center =  CLLocationCoordinate2D.init(latitude: 37.787689, longitude: -122.410929)

// length is in kilometers, 
//so you need to convert to meters
// for this exemple it is 35 meters
  let length =  0.035 


let squareRegion = CKSquareRegion.init(regionWithCenter: center, sideLength: length, identifier: "myIdentifier")

delegate.updateRegion(region: squareRegion!, location: location)

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

## Note:

The sideLength is in kilometers, so you will have to convert to meters

## License

MIT License