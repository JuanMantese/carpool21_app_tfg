import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyBwylGszcGHB5poVVHIDBUaTj9oNqwYk3Y")

    // Configuracion de las variables de entorno para ios
    // if let apiKey = ProcessInfo.processInfo.environment["API_KEY_GOOGLE_MAPS"] {
    //   GMSServices.provideAPIKey(apiKey)
    // } else {
    //   print("Google Maps API key not found")
    // }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
