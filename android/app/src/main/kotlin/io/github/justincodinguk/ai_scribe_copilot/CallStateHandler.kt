package io.github.justincodinguk.ai_scribe_copilot

import android.content.Context
import android.telephony.PhoneStateListener
import android.telephony.TelephonyManager
import java.util.concurrent.Executors

class CallStateHandler(
    context: Context,
    resumeCallback: () -> Unit,
    pauseCallback: () -> Unit,
) {
    private val telephoneManager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager

    private val phoneStateListener = object : PhoneStateListener() {
        override fun onCallStateChanged(state: Int, incomingNumber: String?) {
            when (state) {
                TelephonyManager.CALL_STATE_RINGING -> {
                    pauseCallback()
                }
                TelephonyManager.CALL_STATE_IDLE -> {
                    resumeCallback()
                }
            }
        }
    }


    fun startListening() {
        val singleExecutor = Executors.newSingleThreadExecutor()
        telephoneManager.listen(phoneStateListener, PhoneStateListener.LISTEN_CALL_STATE)
    }

    fun stopListening() {
        telephoneManager.listen(phoneStateListener, PhoneStateListener.LISTEN_NONE)
    }
}