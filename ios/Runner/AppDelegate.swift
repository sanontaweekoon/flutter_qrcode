import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {

       // add
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let shareChannel = FlutterMethodChannel(name: "cm.share/share",
                                                binaryMessenger: controller as! FlutterBinaryMessenger)
        shareChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            if (call.method == "shareFile") {
                self.shareFile(sharedItems: call.arguments!,controller: controller);
            }
        });


    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // add
      func shareFile(sharedItems:Any, controller:UIViewController) {
          let filePath:NSMutableString = NSMutableString.init(string: sharedItems as! String);
          let docsPath:NSString = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]) as NSString;
          let imagePath = docsPath.appendingPathComponent(filePath as String);

          let imageUrl = URL.init(fileURLWithPath: imagePath)

          do {
              let imageData = try Data.init(contentsOf: imageUrl);
              let shareImage = UIImage.init(data: imageData);
              let activityViewController:UIActivityViewController = UIActivityViewController.init(activityItems: [shareImage!], applicationActivities: nil);
              controller.present(activityViewController, animated: true, completion: nil);
          } catch let error {
              print(error.localizedDescription);
          }
      }

}
