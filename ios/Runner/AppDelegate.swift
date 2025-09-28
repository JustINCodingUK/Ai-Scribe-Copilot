import Flutter
import UIKit

@main @objc class AppDelegate: FlutterAppDelegate {
    override func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let micController = MicController()

        let eventChannel = FlutterEventChannel(
            name: "io.github.justincodinguk.ai_scribe_copilot/MicStream",
            binaryMessenger: controller.binaryMessenger
        )

        eventChannel.setStreamHandler(
            StreamHandler(
                onListen: {
                    eventSink in
                    self.micController?.onAudioData = {
                        data in
                        eventSink(data)
                    }
                    self.micController?.startRecording()
                },
                onCancel: {
                    _ in
                    self.micController?.stopRecording()
                }
            )
        )

        let methodChannel = FlutterMethodChannel(name: "io.github.justincodinguk.ai_scribe_copilot/MicController", binaryMessenger: controller.binaryMessenger)
        methodChannel.setMethodCallHandler {
            [weak self] call, result in
            guard let self = self else {
                return
            }
            switch call.method {
            case "startRecording":
                self.micController?.startRecording()
                result(nil)
            case "stopRecording":
                self.micController?.stopRecording()
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
