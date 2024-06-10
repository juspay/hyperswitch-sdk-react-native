package com.hyperswitchsdkreactnative

import android.graphics.Color
import android.os.Bundle
import android.view.WindowManager
import com.facebook.hermes.reactexecutor.HermesExecutorFactory
import com.facebook.react.ReactInstanceManager
import com.facebook.react.ReactRootView
import com.facebook.react.bridge.Callback
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.ReadableType
import com.facebook.react.common.LifecycleState
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp

@ReactModule(name = HyperswitchSdkReactNativeViewManager.NAME)
class HyperswitchSdkReactNativeViewManager :
  HyperswitchSdkReactNativeViewManagerSpec<HyperswitchSdkReactNativeView>() {
  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(
    context: ThemedReactContext
  ): HyperswitchSdkReactNativeView {
    return HyperswitchSdkReactNativeView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: HyperswitchSdkReactNativeView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "HyperswitchSdkReactNativeView"

    @JvmStatic
    lateinit var sheetCallback: Callback

    private fun toBundleObject(readableMap: ReadableMap?): Bundle {
      val result = Bundle()
      return if (readableMap == null) {
        result
      } else {
        val iterator = readableMap.keySetIterator()
        while (iterator.hasNextKey()) {
          val key = iterator.nextKey()
          when (readableMap.getType(key)) {
            ReadableType.Null -> result.putString(key, null)
            ReadableType.Boolean -> result.putBoolean(key, readableMap.getBoolean(key))
            ReadableType.Number -> result.putDouble(key, readableMap.getDouble(key))
            ReadableType.String -> result.putString(key, readableMap.getString(key))
            ReadableType.Map -> result.putBundle(key, toBundleObject(readableMap.getMap(key)))
            else -> result.putString(key, readableMap.getString(key))
          }
        }
        result
      }
    }
  }
}
