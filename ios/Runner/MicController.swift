import AVFoundation

class MicController {
    var audioEngine: AVAudioEngine?
    var onAudioData: ((Data) -> Void)?

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleInterruption),
            name: AVAudioSession.interruptionNotification,
            object: AVAudioSession.sharedInstance()
        )
    }

    func startRecording() {
        audioEngine = AVAudioEngine()
        let inputNode = audioEngine!.inputNode
        let bus = 0
        let format = inputNode.outputFormat(forBus: bus)

        inputNode.installTap(onBus: bus, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            guard let self = self else { return }
            let channelData = buffer.floatChannelData![0]
            let data = Data(bytes: channelData, count: Int(buffer.frameLength)*MemoryLayout<Float>.size)
            self.onAudioData?(data)
        }

        try? AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: [.defaultToSpeaker])
        try? AVAudioSession.sharedInstance().setActive(true)
        try? audioEngine?.start()
    }

    func stopRecording() {
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: 0)
        audioEngine = nil
    }

    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
        let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
        let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }

        switch type {
        case .began:
            stopRecording()

        case .ended:
            startRecording()
        default:
            break
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}