import android.app.Activity
import android.content.Intent
import android.os.Bundle

import android.util.Log
import com.facebook.react.ReactActivity
import com.facebook.react.bridge.*


import com.hyperswitchsdkreactnative.react.Utils
import com.juspaytech.reactnativehyperswitch.payments.gpay.GooglePayActivity
import io.hyperswitch.PaymentMethod

import io.hyperswitch.PaymentSession
import io.hyperswitch.PaymentSessionHandler

import io.hyperswitch.payments.paymentlauncher.PaymentResult


class ReactNativeHyperswitchModule(reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return NAME
  }

  fun callBackResultHandler(callBack: Callback, map: ReadableMap) {
    Log.d("MY_CALLBACK_HANDLER", "called")
    try {
      Log.d("MY_CALLBACK_HANDLER", "flow in try")
      callBack.invoke(map)
    } catch (err: RuntimeException) {
      Log.d("MY_CALLBACK_HANDLER", "flow in catch")
      Log.e("Callback Log--", err.toString())
    }
  }


  @ReactMethod
  fun initPaymentSession(request: ReadableMap, callBack: Callback) {
    Log.i("Inside InitPayentSession", request.toString())
    val publishableKey = request.getString("publishableKey")

    Companion.publishableKey = publishableKey ?: ""
    val clientSecret = request.getString("clientSecret")
    val paymentSession = PaymentSession(currentActivity as Activity, publishableKey)
    paymentSession.initPaymentSession(clientSecret ?: "")
    Companion.paymentSession = paymentSession

      val map = Arguments.createMap()
      map.putString("type_", "")
      map.putString("code", "")
      map.putString("message", "initPaymentSession successful")
      map.putString("status", "success")

      callBackResultHandler(callBack, map)
  }

  @ReactMethod
  fun getCustomerSavedPaymentMethods(request: ReadableMap,callBack: Callback)
  {
    paymentSession.getCustomerSavedPaymentMethods {
      Companion.paymentSessionHandler = it

      val map = Arguments.createMap()
      map.putString("type_", "")
      map.putString("code", "")
      map.putString("message", "getCustomerSavedPaymentMethods successful")
      map.putString("status", "success")

      callBackResultHandler(callBack, map)

    }
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
  fun getCustomerDefaultSavedPaymentMethodData(request: ReadableMap, callBack: Callback) {

    Log.i("Register Headless", "called on Native Side")

    val map = Arguments.createMap()


    currentActivity?.runOnUiThread {

      val paymentMethod =
        Companion.paymentSessionHandler?.getCustomerDefaultSavedPaymentMethodData()
      when (paymentMethod) {
        is PaymentMethod.Card -> {
          map.putString("type", "card")
          map.putMap("message", Arguments.makeNativeMap(paymentMethod.toHashMap()))

        }

        is PaymentMethod.Wallet -> {
          map.putString("type", "wallet")
          map.putMap("message", Arguments.makeNativeMap(paymentMethod.toHashMap()))
        }

        is PaymentMethod.Error -> {
          map.putString("type", "error")
          map.putMap("message", Arguments.makeNativeMap(paymentMethod.toHashMap()))
        }

        else -> {
          map.putString("type", "error")
          map.putString("message", "unknown error")
        }

      }
      callBackResultHandler(callBack, map)
      paymentSession.destroyInstance()


    }

  }

  @ReactMethod
  fun getCustomerLastUsedPaymentMethodData(request: ReadableMap, callBack: Callback) {

    val map = Arguments.createMap()

    currentActivity?.runOnUiThread {


      val paymentMethod = Companion.paymentSessionHandler.getCustomerLastUsedPaymentMethodData()
      val map = Arguments.createMap()

      when (paymentMethod) {
        is PaymentMethod.Card -> {
          map.putString("type", "card")
          map.putMap("message", Arguments.makeNativeMap(paymentMethod.toHashMap()))

        }

        is PaymentMethod.Wallet -> {
          map.putString("type", "wallet")
          map.putMap("message", Arguments.makeNativeMap(paymentMethod.toHashMap()))
        }

        is PaymentMethod.Error -> {
          map.putString("type", "wallet")
          map.putMap("message", Arguments.makeNativeMap(paymentMethod.toHashMap()))
        }

        else -> {
          map.putString("type", "wallet")
          map.putString("message", "unknown error")
        }

      }

      callBackResultHandler(callBack, map)
      paymentSession.destroyInstance()

    }

  }

  @ReactMethod
  fun getCustomerSavedPaymentMethodData(request: ReadableMap, callBack: Callback) {

    val map = Arguments.createMap()

    currentActivity?.runOnUiThread {

      val paymentMethods = Companion.paymentSessionHandler.getCustomerSavedPaymentMethodData()

      paymentMethods.forEach {
        println(it.toString())
      }

      val pmArray = Arguments.createArray()

      paymentMethods.forEach {
        val map = Arguments.createMap()
        val paymentMethod = it
        when (paymentMethod) {
          is PaymentMethod.Card -> {
            map.putString("type", "card")
            map.putMap("message", Arguments.makeNativeMap(paymentMethod.toHashMap()))

            pmArray.pushMap(map)

          }

          is PaymentMethod.Wallet -> {
            map.putString("type", "wallet")
            map.putMap("message", Arguments.makeNativeMap(paymentMethod.toHashMap()))
            pmArray.pushMap(map)
          }

          is PaymentMethod.Error -> {
            map.putString("type", "wallet")
            map.putMap("message", Arguments.makeNativeMap(paymentMethod.toHashMap()))
            pmArray.pushMap(map)
          }

          else -> {
            map.putString("type", "wallet")
            map.putString("message", "unknown error")
            pmArray.pushMap(map)
          }

        }

      }

      map.putArray("paymentMethods", pmArray)
      callBackResultHandler(callBack, map)
      paymentSession.destroyInstance()


    }

  }

  @ReactMethod
  fun confirmWithCustomerDefaultPaymentMethod(request: ReadableMap,cvc:String?=null, callBack: Callback) {


    Log.i("Register Headless", "called on Native Side")
    val publishableKey = request.getString("publishableKey")
    val clientSecret = request.getString("clientSecret")
    val map = Arguments.createMap()

    currentActivity?.runOnUiThread {
      val paymentSession = PaymentSession(currentActivity as Activity, publishableKey)
      paymentSession.initPaymentSession(clientSecret ?: "")

      fun resultHandler(paymentResult: PaymentResult) {

        when (paymentResult) {
          is PaymentResult.Canceled -> {
            map.putString("type", "canceled")
            map.putString("message", paymentResult.data)
          }

          is PaymentResult.Failed -> {

            map.putString("type", "failed")
            map.putString("message", paymentResult.throwable.message ?: "")
          }

          is PaymentResult.Completed -> {
            map.putString("type", "completed")
            map.putString("message", paymentResult.data)
          }
        }

        callBackResultHandler(callBack, map)
        paymentSession.destroyInstance()
      }



      Companion.paymentSessionHandler.confirmWithCustomerDefaultPaymentMethod(cvc = cvc, resultHandler = ::resultHandler)
    }

  }

  @ReactMethod
  fun confirmWithCustomerLastUsedPaymentMethod(request: ReadableMap,cvc:String?=null, callBack: Callback) {

    Log.i("Register Headless", "called on Native Side")
    val publishableKey = request.getString("publishableKey")
    val clientSecret = request.getString("clientSecret")
    val map = Arguments.createMap()



    currentActivity?.runOnUiThread {

      fun resultHandler(paymentResult: PaymentResult) {

        when (paymentResult) {
          is PaymentResult.Canceled -> {
            map.putString("type", "canceled")
            map.putString("message", paymentResult.data)
          }

          is PaymentResult.Failed -> {

            map.putString("type", "failed")
            map.putString("message", paymentResult.throwable.message ?: "")
          }

          is PaymentResult.Completed -> {
            map.putString("type", "completed")
            map.putString("message", paymentResult.data)
          }
        }

        callBackResultHandler(callBack, map)
        paymentSession.destroyInstance()

      }
      Companion.paymentSessionHandler.confirmWithCustomerLastUsedPaymentMethod(cvc=cvc,resultHandler = ::resultHandler)
    }

  }

  @ReactMethod
  fun confirmWithCustomerPaymentToken(request: ReadableMap,cvc:String?=null,paymentToken:String, callBack: Callback) {

    Log.i("Register Headless", "called on Native Side")
    val publishableKey = request.getString("publishableKey")
    val clientSecret = request.getString("clientSecret")
    val map = Arguments.createMap()



    currentActivity?.runOnUiThread {

      fun resultHandler(paymentResult: PaymentResult) {

        when (paymentResult) {
          is PaymentResult.Canceled -> {
            map.putString("type", "canceled")
            map.putString("message", paymentResult.data)
          }

          is PaymentResult.Failed -> {

            map.putString("type", "failed")
            map.putString("message", paymentResult.throwable.message ?: "")
          }

          is PaymentResult.Completed -> {
            map.putString("type", "completed")
            map.putString("message", paymentResult.data)
          }
        }

        callBackResultHandler(callBack, map)
        paymentSession.destroyInstance()

      }
      Companion.paymentSessionHandler.confirmWithCustomerPaymentToken(cvc=cvc, paymentToken = paymentToken,resultHandler = ::resultHandler)
    }

  }



//  @ReactMethod
//  fun registerHeadless(request: ReadableMap, callBack: Callback) {
//
//    Log.i("Register Headless", "called on Native Side")
//    val publishableKey = request.getString("publishableKey")
//    val clientSecret = request.getString("clientSecret")
//
//
//
//    currentActivity?.runOnUiThread {
//      val paymentSession = PaymentSession(currentActivity as Activity, publishableKey)
//      fun resultHandler(paymentResult: PaymentResult) {
//        val map = HashMap<String, Any>()
//        when (paymentResult) {
//          is PaymentResult.Canceled -> {
//            map["type"] = "canceled"
//            map["message"] = paymentResult.data
//          }
//
//          is PaymentResult.Failed -> {
//            map["type"] = "failed"
//            map["message"] = paymentResult.throwable.message ?: ""
//            println("status here--------" + paymentResult.throwable.message ?: "")
//          }
//
//          is PaymentResult.Completed -> {
//            println("status here--------" + paymentResult.data)
//            map["type"] = "completed"
//            map["message"] = paymentResult.data
//          }
//        }
//
//      }
////        Handler().postDelayed({
//      paymentSession.initPaymentSession(clientSecret ?: "")
//      paymentSession.getCustomerSavedPaymentMethods {
////            val x=it.getCustomerDefaultSavedPaymentMethodData()
//        it.confirmWithCustomerDefaultPaymentMethod(resultHandler = ::resultHandler)
////            val y=it.
////            println("resp------------"+x.toString())
//      }
////        }, 2000)
//    }
//
//
//    val map = Arguments.createMap()
//    map.putString("type_", "headlessRegistration")
//    map.putString("message", "ok")
//    callBackResultHandler(callBack, map)
//
//  }


  @ReactMethod
  fun exitPaymentsheet(rootTag: Int, paymentResult: String, reset: Boolean) {
    Utils.hideFragment(currentActivity as ReactActivity, reset)
    sheetCallback.invoke(paymentResult)
  }

  @ReactMethod
  fun sendMessageToNative(rnMessage: String?) {
    Log.d("This log is from java", rnMessage!!)
  }

  fun gPayWalletCall(gPayRequest: String, callback: Callback) {
    googlePayCallback = callback
    val myIntent = Intent(
      currentActivity, GooglePayActivity::class.java
    )
    myIntent.putExtra("gPayRequest", gPayRequest)
    currentActivity?.startActivity(myIntent)
  }

  @ReactMethod
  fun launchGPay(gPayRequest: String, callBack: Callback) {
    gPayWalletCall(gPayRequest, callBack)
  }

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

    @JvmStatic
    lateinit var paymentSession: PaymentSession

    @JvmStatic
    lateinit var paymentSessionHandler: PaymentSessionHandler

    @JvmStatic
    lateinit var googlePayCallback: Callback

    @JvmStatic
    lateinit var sheetCallback: Callback

    @JvmStatic
    lateinit var publishableKey: String


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

