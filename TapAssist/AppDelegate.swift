import UIKit
import CoreMotion
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let manager = CMMotionManager()
    var knocked : Bool = false
    let motionUpdateInterval : Double = 0.05
    var knockReset : Double = 2.0
    var accelerationZ = 0.3
    
    let locationManager = CLLocationManager()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if manager.deviceMotionAvailable {
            manager.deviceMotionUpdateInterval = motionUpdateInterval // seconds
            
            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) {
                [weak self] (data: CMDeviceMotion!, error: NSError!) in
                
                
                if (data.userAcceleration.z < -self!.accelerationZ) || (data.userAcceleration.z > self!.accelerationZ) { // Check if device is knocked
                    
                    // Check for double knock
                    if self!.knocked == false {
                        // First knock
                        println("First Knock")
                        self!.knocked = true
                        
                    }else{
                        // Second knock
                        println("Double Knocked")
                        self!.knocked = false
                        self!.knockReset = 2.0
                        
                        // Action:
                    }
                }
                
                // Countdown for reset action (second knock must be within the knockReset limit)
                if (self!.knocked) && (self!.knockReset >= 0.0) {
                    
                    self!.knockReset = self!.knockReset - self!.motionUpdateInterval
                    
                }else if self!.knocked == true {
                    self!.knocked = false
                    self!.knockReset = 2.0
                    println("Reset")
                }
                
            }
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

