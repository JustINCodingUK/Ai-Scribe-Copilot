package io.github.justincodinguk.ai_scribe_copilot

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ServiceInfo
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.ServiceCompat
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.EventChannel
import kotlin.concurrent.thread

class MicService : Service() {

    private val streamChannel = "io.github.justincodinguk.ai_scribe_copilot/MicStream"
    private val methodChannel = "io.github.justincodinguk.ai_scribe_copilot/MicController"
    private val micControlChannel = "io.github.justincodinguk.ai_scribe_copilot/MicControl"

    private var audioRecord: AudioRecord? = null
    private var recordingThread: Thread? = null

    private var micControlSink: EventChannel.EventSink? = null
    private lateinit var callStateHandler: CallStateHandler

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        callStateHandler = CallStateHandler(
            this,
            {
                audioRecord?.startRecording()
                micControlSink?.success(1)
            },
            {
                audioRecord?.stop()
                micControlSink?.success(0)
            }
        )
        val notificationChannel = NotificationChannel(
            "mic_channel",
            "Mic Channel",
            NotificationManager.IMPORTANCE_LOW
        )
        val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.createNotificationChannel(notificationChannel)
        val notification = NotificationCompat.Builder(this, "mic_channel")
            .setContentTitle("Recording audio")
            .setContentText("Streaming audio")
            .setSmallIcon(android.R.drawable.ic_media_play)
            .build()
        ServiceCompat.startForeground(this, 100, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_MICROPHONE)
        callStateHandler.startListening()
        val flutterEngine = FlutterEngineCache.getInstance()["main"]!!
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, streamChannel)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(
                    arguments: Any?,
                    events: EventChannel.EventSink?
                ) {
                    startStreaming(events)
                }

                override fun onCancel(arguments: Any?) {
                    stopStreaming()
                }
            })

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, micControlChannel)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(
                    arguments: Any?,
                    events: EventChannel.EventSink?
                ) {
                    micControlSink = events
                }

                override fun onCancel(arguments: Any?) {
                    TODO("Not yet implemented")
                }

            })

        return START_STICKY
    }

    private fun startStreaming(events: EventChannel.EventSink?) {
        val bufferSize = AudioRecord.getMinBufferSize(
            16000,
            AudioFormat.CHANNEL_IN_MONO,
            AudioFormat.ENCODING_PCM_FLOAT
        )


        if (checkPermission(Manifest.permission.RECORD_AUDIO, 0, 0) == PackageManager.PERMISSION_GRANTED) {
            audioRecord = AudioRecord(
                MediaRecorder.AudioSource.MIC,
                16000,
                AudioFormat.CHANNEL_IN_MONO,
                AudioFormat.ENCODING_PCM_FLOAT,
                bufferSize
            )
        }

        audioRecord?.startRecording()

        recordingThread = thread(start = true) {
            val buffer = FloatArray(bufferSize)
            while (audioRecord?.recordingState == AudioRecord.RECORDSTATE_RECORDING) {
                val read = audioRecord?.read(buffer, 0, buffer.size, AudioRecord.READ_NON_BLOCKING) ?: 0
                if (read > 0) {
                    Handler(Looper.getMainLooper()).post {
                        events?.success(buffer.copyOf(read))
                    }
                }
            }
        }
    }

    private fun stopStreaming() {
        audioRecord?.stop()
        audioRecord?.release()
        audioRecord = null
        recordingThread = null
    }

    override fun onDestroy() {
        super.onDestroy()
        callStateHandler.stopListening()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

}