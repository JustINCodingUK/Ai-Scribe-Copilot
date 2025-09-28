import Flutter
import Foundation

class StreamHandler: NSObject, FlutterStreamHandler {
    private let onListenClosure: (FlutterEventSink) -> Void
    private let onCancelClosure: (FlutterEventSink?) -> Void

    init(onListen: @escaping (FlutterEventSink) -> Void, onCancel: @escaping (FlutterEventSink?) -> Void) {
        self.onListenClosure = onListen
        self.onCancelClosure = onCancel
    }

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        onListenClosure(events)
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        onCancelClosure(nil)
        return nil
    }
}