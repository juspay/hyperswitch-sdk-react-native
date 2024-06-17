package com.juspaytech.reactnativehyperswitch

import android.app.Activity
import android.os.Bundle
import android.util.Log
import com.facebook.react.ReactActivity
import com.facebook.react.bridge.*
import com.hyperswitchsdkreactnative.react.Utils

import io.hyperswitch.PaymentSession

import io.hyperswitch.payments.paymentlauncher.PaymentResult

// import com.juspaytech.reactnativehyperswitch.payments.gpay.GooglePayActivity
// import com.juspaytech.reactnativehyperswitch.react.Utils

class ReactNativeHyperswitchModule(reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return NAME
  }

  @ReactMethod
  fun presentPaymentSheet(request: ReadableMap, callBack: Callback) {
    println("flow reach native module!!!!!!!!!!!!" + request)
    sheetCallback = callBack
    val bundleObj = toBundleObject(request)
    Log.i("Bundle Obj", bundleObj.toString())
    Utils.openReactView(currentActivity as ReactActivity, toBundleObject(request), "payment", null)
  }

  @ReactMethod
  fun getCustomerSavedPaymentMethodData(request: ReadableMap, callBack: Callback) {
    println("getCustomerSavedPaymentMethodData called!!!!!!")
    Companion.paymentSession.getCustomerSavedPaymentMethods {
      val x = it.getCustomerSavedPaymentMethodData()
      Log.i("customer saved data", x.toString())
    }


  }

  @ReactMethod
  fun initHeadless(request: ReadableMap, callBack: Callback) {

    println("requestObj-----" + request)
    Companion.publishableKey = "pk_snd_3b33cd9404234113804aa1accaabe22f"

    println("headless init--->" + request)

    reactApplicationContext.currentActivity!!.runOnUiThread {
      val paymentSession = PaymentSession(
        reactApplicationContext.currentActivity!!,
        request.getString("clientSecret")!!
      )

      paymentSession.initPaymentSession(request.getString("clientSecret")!!)


      Companion.paymentSession = paymentSession

      paymentSession.getCustomerSavedPaymentMethods {
        val x = it.getCustomerSavedPaymentMethodData()
        Log.i("customer saved data", x.toString())
      }

      fun completionFunction(
        getCustomerDefaultSavedPaymentMethodData: () -> Any?,
        confirmWithCustomerDefaultPaymentMethod: ((PaymentResult) -> Unit) -> Unit
      ) {
        // Call the provided functions
        val paymentMethodData = getCustomerDefaultSavedPaymentMethodData()
        println("Payment Method Data: $paymentMethodData")
        fun finalCallback(paymentResult: PaymentResult) {
          Log.i("paymentResult", paymentResult.toString())
        }
        confirmWithCustomerDefaultPaymentMethod(::finalCallback)
      }


      // Initialize the saved payment method session
//      paymentSession.initSavedPaymentMethodSession(::completionFunction)
    }


  }


  @ReactMethod
  fun exitPaymentsheet(rootTag: Int, paymentResult: String, reset: Boolean) {
    Utils.hideFragment(currentActivity as ReactActivity, reset)
    sheetCallback.invoke(paymentResult)
  }

  @ReactMethod
  fun sendMessageToNative(rnMessage: String?) {
    Log.d("This log is from java", rnMessage!!)
  }

  //  fun gPayWalletCall(gPayRequest: String, callback: Callback) {
  //    googlePayCallback = callback
  //    val myIntent = Intent(
  //      currentActivity,
  //      GooglePayActivity::class.java
  //    )
  //    myIntent.putExtra("gPayRequest", gPayRequest)
  //    currentActivity?.startActivity(myIntent)
  //  }

//  @ReactMethod
//  fun launchGPay(gPayRequest: String, callBack: Callback) {
//    gPayWalletCall(gPayRequest, callBack)
//  }

  @ReactMethod
  fun exitCardForm(paymentResult: String) {
    sheetCallback.invoke(paymentResult)
  }

  private var listenerCount = 0

  @ReactMethod
  fun addListener(eventName: String?) {
    //    if (listenerCount == 0) {
    //      // Set up any upstream listeners or background tasks as necessary
    //    }
    listenerCount += 1
  }

  @ReactMethod
  fun removeListeners(count: Int) {
    listenerCount -= count
    //    if (listenerCount == 0) {
    //      // Remove upstream listeners, stop unnecessary background tasks
    //    }
  }

  companion object {
    const val NAME = "HyperModule"

    //    @JvmStatic lateinit var googlePayCallback: Callback
    @JvmStatic
    lateinit var sheetCallback: Callback

    @JvmStatic
    lateinit var publishableKey: String

    @JvmStatic
    lateinit var paymentSession: PaymentSession

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
