package com.candlefinance.haptics

import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableArray
import okhttp3.internal.platform.Platform


class HapticsModule(reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  var vibrator: Vibrator? = null
  private val ERROR_PATTERN = longArrayOf(0, 100, 50, 50, 50, 50, 100)
  private val SUCCESS_PATTERN = longArrayOf(0, 25, 25, 25)
  private val WARNING_PATTERN = longArrayOf(0, 100, 50, 100, 100, 50)

  override fun getName(): String {
    return NAME
  }

  @ReactMethod
  fun haptic(type: String, promise: Promise) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      vibrator = reactApplicationContext.getSystemService(Vibrator::class.java)
      val vibrationEffect = when (type) {
        "light" -> VibrationEffect.createOneShot(20, VibrationEffect.DEFAULT_AMPLITUDE)
        "medium" -> VibrationEffect.createOneShot(40, VibrationEffect.DEFAULT_AMPLITUDE)
        "rigid" -> VibrationEffect.createOneShot(60, VibrationEffect.DEFAULT_AMPLITUDE)
        "heavy" -> VibrationEffect.createOneShot(80, VibrationEffect.DEFAULT_AMPLITUDE)
        "soft" -> VibrationEffect.createOneShot(100, VibrationEffect.DEFAULT_AMPLITUDE)
        "selectionChanged" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
          VibrationEffect.createPredefined(VibrationEffect.EFFECT_TICK)
        } else {
          VibrationEffect.createOneShot(20, VibrationEffect.DEFAULT_AMPLITUDE)
        }
        "warning" -> VibrationEffect.createWaveform(WARNING_PATTERN, -1)
        "error" -> VibrationEffect.createWaveform(ERROR_PATTERN, -1 )
        "success" -> VibrationEffect.createWaveform(SUCCESS_PATTERN, -1)
        else -> VibrationEffect.createOneShot(20, VibrationEffect.DEFAULT_AMPLITUDE)
      }
      vibrator?.vibrate(vibrationEffect)
    } else {
      promise.reject("ERR_VERSION", "Vibration is not supported on this device")
    }
  }

  @ReactMethod
  fun hapticWithPattern(pattern: ReadableArray, promise: Promise) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      vibrator = reactApplicationContext.getSystemService(Vibrator::class.java)
      val patternLong = pattern.toArrayList().map {
        when (it) {
          "o" -> 40L
          "O" -> 80L
          "." -> 20L
          ":" -> 25L
          "-" -> 0L
          "=" -> 0L
          else -> 20L
        }
      }.toLongArray()
      val vibrationEffect = VibrationEffect.createWaveform(patternLong, -1)
      vibrator?.vibrate(vibrationEffect)
    } else {
      promise.reject("ERR_VERSION", "Vibration is not supported on this device")
    }
  }

  companion object {
    const val NAME = "Haptics"
  }
}
