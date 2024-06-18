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

import io.hyperswitch.payments.paymentlauncher.PaymentResult


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
  fun getCustomerDefaultSavedPaymentMethodData(request: ReadableMap, callBack: Callback) {

    Log.i("Register Headless", "called on Native Side")
    val publishableKey = request.getString("publishableKey")
    val clientSecret = request.getString("clientSecret")
    val map = Arguments.createMap()

    currentActivity?.runOnUiThread {
      val paymentSession = PaymentSession(currentActivity as Activity, publishableKey)
      paymentSession.initPaymentSession(clientSecret ?: "")
      paymentSession.getCustomerSavedPaymentMethods {
        val paymentMethod = it.getCustomerDefaultSavedPaymentMethodData()
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
        callBack.invoke(map)

      }
    }

  }

  @ReactMethod
  fun getCustomerLastUsedPaymentMethodData(request: ReadableMap, callBack: Callback) {

    Log.i("Register Headless", "called on Native Side")
    val publishableKey = request.getString("publishableKey")
    val clientSecret = request.getString("clientSecret")
    val map = Arguments.createMap()

    currentActivity?.runOnUiThread {
      val paymentSession = PaymentSession(currentActivity as Activity, publishableKey)
      paymentSession.initPaymentSession(clientSecret ?: "")
      paymentSession.getCustomerSavedPaymentMethods {
        val paymentMethod = it.getCustomerLastUsedPaymentMethodData()
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
        callBack.invoke(map)

      }
    }

  }

  @ReactMethod
  fun getCustomerSavedPaymentMethodData(request: ReadableMap, callBack: Callback) {

    Log.i("Register Headless", "called on Native Side")
    val publishableKey = request.getString("publishableKey")
    val clientSecret = request.getString("clientSecret")
    val map = Arguments.createMap()

    currentActivity?.runOnUiThread {
      val paymentSession = PaymentSession(currentActivity as Activity, publishableKey)
      paymentSession.initPaymentSession(clientSecret ?: "")
      paymentSession.getCustomerSavedPaymentMethods {
        val paymentMethods = it.getCustomerSavedPaymentMethodData()




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
        callBack.invoke(map)

      }
    }

  }

  @ReactMethod
  fun confirmWithCustomerDefaultPaymentMethod(request: ReadableMap, callBack: Callback) {

    Log.i("Register Headless", "called on Native Side")
    val publishableKey = request.getString("publishableKey")
    val clientSecret = request.getString("clientSecret")
    val map = Arguments.createMap()

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

      callBack.invoke(map)

    }

    currentActivity?.runOnUiThread {
      val paymentSession = PaymentSession(currentActivity as Activity, publishableKey)
      paymentSession.initPaymentSession(clientSecret ?: "")
      paymentSession.getCustomerSavedPaymentMethods {
        val paymentMethod =
          it.confirmWithCustomerDefaultPaymentMethod(resultHandler = ::resultHandler)


      }
    }

  }

  @ReactMethod
  fun confirmWithCustomerLastUsedPaymentMethod(request: ReadableMap, callBack: Callback) {

    Log.i("Register Headless", "called on Native Side")
    val publishableKey = request.getString("publishableKey")
    val clientSecret = request.getString("clientSecret")
    val map = Arguments.createMap()

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

      callBack.invoke(map)

    }

    currentActivity?.runOnUiThread {
      val paymentSession = PaymentSession(currentActivity as Activity, publishableKey)
      paymentSession.initPaymentSession(clientSecret ?: "")
      paymentSession.getCustomerSavedPaymentMethods {
        val paymentMethod =
          it.confirmWithCustomerLastUsedPaymentMethod(resultHandler = ::resultHandler)


      }
    }

  }


  @ReactMethod
  fun registerHeadless(request: ReadableMap, callBack: Callback) {

    Log.i("Register Headless", "called on Native Side")
    val publishableKey = request.getString("publishableKey")
    val clientSecret = request.getString("clientSecret")



    currentActivity?.runOnUiThread {
      val paymentSession = PaymentSession(currentActivity as Activity, publishableKey)
      fun resultHandler(paymentResult: PaymentResult) {
        val map = HashMap<String, Any>()
        when (paymentResult) {
          is PaymentResult.Canceled -> {
            map["type"] = "canceled"
            map["message"] = paymentResult.data
          }

          is PaymentResult.Failed -> {
            map["type"] = "failed"
            map["message"] = paymentResult.throwable.message ?: ""
            println("status here--------" + paymentResult.throwable.message ?: "")
          }

          is PaymentResult.Completed -> {
            println("status here--------" + paymentResult.data)
            map["type"] = "completed"
            map["message"] = paymentResult.data
          }
        }

      }
//        Handler().postDelayed({
      paymentSession.initPaymentSession(clientSecret ?: "")
      paymentSession.getCustomerSavedPaymentMethods {
//            val x=it.getCustomerDefaultSavedPaymentMethodData()
        it.confirmWithCustomerDefaultPaymentMethod(resultHandler = ::resultHandler)
//            val y=it.
//            println("resp------------"+x.toString())
      }
//        }, 2000)
    }


    val map = Arguments.createMap()
    map.putString("type_", "headlessRegistration")
    map.putString("message", "ok")
    callBack.invoke(map)

  }


//  @ReactMethod
//  fun getCustomerSavedPaymentMethodData(request: ReadableMap, callBack: Callback) {
////    sheetCallback = callBack
//    println("getCustomerSavedP`aymentMethodData called!!!!!!" + request)
//
////    val callBackMap = Arguments.createMap()
////    reactApplicationContext.currentActivity?.runOnUiThread {
////      println("breakpoint--" + request.getString("clientSecret"))
////      val paymentSession = PaymentSession(
////        reactApplicationContext.currentActivity!!,
////        request.getString("clientSecret")!!
////      )
////
////
////      paymentSession.initPaymentSession(
////        request.getString("clientSecret")!!,
////        currentActivity as ReactActivity,
////        Companion.toBundleObject(request)
////      )
////
////
////      Companion.paymentSession = paymentSession
////
////      paymentSession.getCustomerSavedPaymentMethods {
////        val defaultPaymentMethod = it.getCustomerDefaultSavedPaymentMethodData()
////
////
////        when (defaultPaymentMethod) {
////          is PaymentMethod.Card -> {
////            println(defaultPaymentMethod.toHashMap())
////
////            callBackMap.putString("paymentMethodType", "Card")
////            callBackMap.putMap(
////              "data",
////              Arguments.makeNativeMap(defaultPaymentMethod.toHashMap())
////            )
////          }
////
////          is PaymentMethod.Wallet -> {
////            println(defaultPaymentMethod.toHashMap())
////            callBackMap.putString("paymentMethodType", "Wallet")
////            callBackMap.putString(
////              "defaultPaymentMethod",
////              defaultPaymentMethod.toHashMap().toString()
////            )
////          }
////
////          is PaymentMethod.Error -> {
////            println(defaultPaymentMethod.toHashMap())
////            callBackMap.putString(
////              "defaultPaymentMethod",
////              defaultPaymentMethod.toHashMap().toString()
////            )
////          }
////
////
////        }
////
////        callBack.invoke(callBackMap)
////        Log.i("customer saved data", defaultPaymentMethod.toString())
////      }
////
////
////    }
//  }

//  @ReactMethod
//  fun confirmWithCustomerDefaultPaymentMethod(request: ReadableMap, callBack: Callback) {
////    sheetCallback = callBack
//    println("confirmWithCustomerDefaultPaymentMethod" + request)
//
//
////    reactApplicationContext.currentActivity?.runOnUiThread {
////      val paymentSession = PaymentSession(
////        reactApplicationContext.currentActivity!!,
////        request.getString("clientSecret")!!
////      )
////
////
////      paymentSession.initPaymentSession(
////        request.getString("clientSecret")!!,
////        currentActivity as ReactActivity,
////        Companion.toBundleObject(request)
////      )
////
////      fun resultHandler(paymentResult: PaymentResult) {
////
////        val callBackMap = Arguments.createMap()
////        when (paymentResult) {
////          is PaymentResult.Canceled -> {
////            callBackMap.putString("type", "canceled")
////            callBackMap.putString("message", paymentResult.data)
////
////          }
////
////          is PaymentResult.Failed -> {
////
////            callBackMap.putString("type", "failed")
////            callBackMap.putString("message", paymentResult.throwable.message ?: "")
////          }
////
////          is PaymentResult.Completed -> {
////            callBackMap.putString("type", "completed")
////            callBackMap.putString("message", paymentResult.data)
////
////          }
////
////        }
////        callBack.invoke(callBackMap)
////      }
////      Companion.paymentSession = paymentSession
////
////      paymentSession.getCustomerSavedPaymentMethods {
////        it.confirmWithCustomerDefaultPaymentMethod(resultHandler = ::resultHandler)
////      }
////    }
//  }

  @ReactMethod
  fun initHeadless(request: ReadableMap, callBack: Callback) {

//    sheetCallback = callBack
//    println("requestObj-----" + request)
//    Companion.publishableKey = "pk_snd_3b33cd9404234113804aa1accaabe22f"
//
//    println("headless init--->" + request)
//
//    reactApplicationContext.currentActivity?.runOnUiThread {
//      println("breakpoint--" + request.getString("clientSecret"))
//      val paymentSession = PaymentSession(
//        reactApplicationContext.currentActivity!!,
//        request.getString("clientSecret")!!
//      )
//
//
//      paymentSession.initPaymentSession(
//        request.getString("clientSecret")!!,
//        currentActivity as ReactActivity,
//        Companion.toBundleObject(request)
//      )
//
//
//      Companion.paymentSession = paymentSession
//
//      paymentSession.getCustomerSavedPaymentMethods {
//        val x = it.getCustomerSavedPaymentMethodData()
//        val y = it.getCustomerDefaultSavedPaymentMethodData()
//
//        when (y) {
//          is PaymentMethod.Card -> {
//            println(y.toHashMap())
//          }
//
//          is PaymentMethod.Wallet -> {
//            println(y.toHashMap())
//          }
//
//          is PaymentMethod.Error -> {
//            println(y.toHashMap())
//          }
//
//
//        }
//
//        Log.i("customer saved data", x.toString())
//      }
//    }
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

  fun gPayWalletCall(gPayRequest: String, callback: Callback) {
    googlePayCallback = callback
    val myIntent = Intent(
      currentActivity,
      GooglePayActivity::class.java
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
    lateinit var googlePayCallback: Callback

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

