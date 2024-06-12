package com.hyperswitchsdkreactnative

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.Callback
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.ViewManager
import com.juspaytech.reactnativehyperswitch.ReactNativeHyperswitchModule
import java.util.ArrayList

class HyperswitchSdkReactNativeViewPackage : ReactPackage {
  override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
    val viewManagers: MutableList<ViewManager<*, *>> = ArrayList()
    println("running..............")
    viewManagers.add(HyperswitchSdkReactNativeViewManager())
    return viewManagers
  }

  override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
    val nativeModules: MutableList<NativeModule> = ArrayList()
    nativeModules.add(ReactNativeHyperswitchModule(reactContext))
    return nativeModules
  }

  @ReactMethod
  fun presentPaymentSheet(request: ReadableMap,callBack: Callback) {

    print("Function called!!!!!!!!!!!!!!!!!!!!!")
    HyperswitchSdkReactNativeViewManager.sheetCallback = callBack
//    Utils.openReactView(reactApplicationContext.currentActivity as ReactActivity, toBundleObject(request), "payment", null)
  }
}
