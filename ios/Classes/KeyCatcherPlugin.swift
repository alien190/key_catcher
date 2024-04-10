import Flutter
import UIKit
import Foundation
import AVFoundation
import MediaPlayer

public class KeyCatcherPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    private let notification: NotificationCenter = NotificationCenter.default
    private var eventSink: FlutterEventSink?
    private var isObserving: Bool = false
    private let volumeKey: String = "outputVolume"
    private var volumeView: MPVolumeView?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "key_catcher_method", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "key_catcher_event", binaryMessenger: registrar.messenger())
        let instance = KeyCatcherPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        eventChannel.setStreamHandler(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init":
            registerVolumeObserver()
            result(true)
        case "dispose":
            removeVolumeObserver()
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
    
    private func registerVolumeObserver() {
        audioSessionObserver()
        notification.addObserver(
            self,
            selector: #selector(audioSessionObserver),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)
    }
    
    @objc func audioSessionObserver(){
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback)
            try audioSession.setActive(true)
            if !isObserving {
                volumeView = MPVolumeView(frame: CGRect.zero)
                if let volumeView = volumeView {
                    UIApplication.shared.windows.first?.addSubview(volumeView)
                    UIApplication.shared.windows.first?.sendSubviewToBack(volumeView)
                }
                audioSession.addObserver(self,
                                         forKeyPath: volumeKey,
                                         options: .new.union(.old),
                                         context: nil)

                isObserving = true
            }
        } catch {
            print("Volume Controller Listener occurred error.")
        }
    }
    
    private func removeVolumeObserver() {
        audioSession.removeObserver(self,
                                    forKeyPath: volumeKey)
        if let volumeView = volumeView {
            volumeView.removeFromSuperview()
        }
        volumeView = nil
        isObserving = false
    }
    
    override public func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey: Any]?,
                                      context: UnsafeMutableRawPointer?) {
        if keyPath == volumeKey {
            let value = change?[NSKeyValueChangeKey.newKey] as? Float
            if(value != 0.5123) {
                eventSink?(true)
                if let view = volumeView?.subviews.first(where: { $0 is UISlider }) as? UISlider
                {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
                        view.value = 0.5123
                    }
                }
            }
        }
    }

}
