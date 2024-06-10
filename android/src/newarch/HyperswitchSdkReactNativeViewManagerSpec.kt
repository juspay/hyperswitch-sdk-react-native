package com.hyperswitchsdkreactnative

import android.view.View

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.viewmanagers.HyperswitchSdkReactNativeViewManagerDelegate
import com.facebook.react.viewmanagers.HyperswitchSdkReactNativeViewManagerInterface

abstract class HyperswitchSdkReactNativeViewManagerSpec<T : View> : SimpleViewManager<T>(), HyperswitchSdkReactNativeViewManagerInterface<T> {
  private val mDelegate: ViewManagerDelegate<T>

  init {
    mDelegate = HyperswitchSdkReactNativeViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<T>? {
    return mDelegate
  }
}
