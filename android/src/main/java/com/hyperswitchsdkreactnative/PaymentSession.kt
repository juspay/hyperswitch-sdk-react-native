package io.hyperswitch

import android.annotation.SuppressLint
import android.app.Activity
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.fragment.app.Fragment
import com.facebook.hermes.reactexecutor.HermesExecutorFactory
import com.facebook.react.HyperPackageList
import com.facebook.react.ReactApplication
import com.facebook.react.ReactInstanceManager
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.Callback
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.WritableMap
import com.facebook.react.common.LifecycleState
import com.hyperswitchsdkreactnative.ReactNativeHyperswitchPackage
import com.hyperswitchsdkreactnative.react.Utils
import io.hyperswitch.payments.paymentlauncher.PaymentResult
import io.hyperswitch.paymentsheet.PaymentSheetResult
import org.json.JSONObject

class PaymentSession {
//  private var paymentSheet: PaymentSheet? = null
  private var sheetCompletion: ((PaymentSheetResult) -> Unit)? = null
  private var reactInstanceManager: ReactInstanceManager? = null
  private var illegalState: IllegalStateException? = null

  constructor(
    activity: Activity,
    publishableKey: String? = null,
    customBackendUrl: String? = null,
    customParams: Bundle? = null,
    customLogUrl: String? = null
  ) {
    init(activity, null, publishableKey, customBackendUrl, customParams, customLogUrl)
  }

  constructor(
    fragment: Fragment,
    publishableKey: String? = null,
    customBackendUrl: String? = null,
    customParams: Bundle? = null,
    customLogUrl: String? = null
  ) {
    init(
      fragment.requireActivity(),
      fragment,
      publishableKey,
      customBackendUrl,
      customParams,
      customLogUrl
    )
  }

  private fun init(
    activity: Activity,
    fragment: Fragment?,
    publishableKey: String? = null,
    customBackendUrl: String? = null,
    customParams: Bundle? = null,
    customLogUrl: String? = null
  ) {
    try {
      Companion.activity = activity
      try {
        val application = activity.application as ReactApplication
//        reactInstanceManager = application.reactNativeHost.reactInstanceManager

//        val mReactRootView = ReactRootView(context)

        val packages = HyperPackageList(activity?.application, activity).packages
        packages.add(ReactNativeHyperswitchPackage())
        Log.i("called", "3")

        reactInstanceManager = ReactInstanceManager.builder()
          .setApplication(activity.application)
          .setCurrentActivity(activity)
          .addPackages(packages)
          .setBundleAssetName("hyperswitch.bundle")
          .setJSMainModulePath("index")
          .setJSBundleFile("assets://hyperswitch.bundle")
          .setJavaScriptExecutorFactory(HermesExecutorFactory())
          .setUseDeveloperSupport(false)
          .setInitialLifecycleState(LifecycleState.RESUMED)
          .build()

//        var mainComponentName: String? = null
//        var launchOptions: Bundle? = null
//        if (this.arguments != null) {
//          mainComponentName = this.requireArguments().getString("arg_component_name")
//          launchOptions = this.requireArguments().getBundle("arg_launch_options")
//        }
//        checkNotNull(mainComponentName) { "Cannot loadApp if component name is null" }

      } catch (ex: RuntimeException) {
        throw RuntimeException(
          "Please remove \"android:name\" from application tag in AndroidManifest.xml", ex
        )
      }

      if (publishableKey != null) {
        PaymentConfiguration.init(
          activity.applicationContext,
          publishableKey,
          "",
          customBackendUrl,
          customParams,
          customLogUrl
        )
      }

//      if (fragment == null) {
//        try {
//          paymentSheet =
//            PaymentSheet(activity as FragmentActivity, ::onPaymentSheetResult)
//          illegalState = null
//        } catch (ex: ClassCastException) {
//          Log.w(
//            "Hyperswitch Warning",
//            "Please initialise PaymentSession in androidx activity.",
//          )
//        } catch (ex: IllegalStateException) {
//          illegalState = ex
//        }
//      } else {
//        PaymentSheet(fragment, ::onPaymentSheetResult)
//      }

    } catch (ex: IllegalStateException) {
      ex.printStackTrace()
    }
  }

  fun initPaymentSession(
    paymentIntentClientSecret: String
  ) {
    Companion.paymentIntentClientSecret = paymentIntentClientSecret
  }

//  fun presentPaymentSheet(resultCallback: (PaymentSheetResult) -> Unit) {
////    presentPaymentSheet(null, resultCallback)
//  }

//  fun presentPaymentSheet(configuration: PaymentSheet.Configuration? = null, resultCallback: (PaymentSheetResult) -> Unit) {
//    try {
//      if(illegalState == null) {
//        activity as FragmentActivity
//        sheetCompletion = resultCallback
//        paymentSheet?.presentWithPaymentIntent(paymentIntentClientSecret ?: "", configuration)
//      } else {
//        throw IllegalStateException(
//          "Please initialise PaymentSession in onCreate method of activity."
//        )
//      }
//    } catch (ex: ClassCastException) {
//      throw ClassCastException(
//        "Please initialise PaymentSession in androidx activity."
//      )
//    }
//  }

  private fun onPaymentSheetResult(paymentSheetResult: PaymentSheetResult) {
    sheetCompletion?.let { it(paymentSheetResult) }
  }

  @SuppressLint("VisibleForTests")
  fun getCustomerSavedPaymentMethods(
    func: ((PaymentSessionHandler) -> Unit),
  ) {
    completion = func
    if (reactInstanceManager == null) {
      throw Exception("Payment Session Initialisation Failed")
    } else {
      val reactContext = reactInstanceManager!!.currentReactContext

      activity.runOnUiThread {
//        if (reactContext == null || !reactContext.hasCatalystInstance()) {
          reactInstanceManager!!.createReactContextInBackground()
//        } else {
//          reactInstanceManager!!.recreateReactContextInBackground()
//        }
      }
    }
  }

  fun destroyInstance() {
    completion = null
  }

  companion object {
    @SuppressLint("StaticFieldLeak")
    private lateinit var activity: Activity

    var paymentIntentClientSecret: String? = null
    var completion: ((PaymentSessionHandler) -> Unit)? = null
    var headlessCompletion: ((PaymentResult) -> Unit)? = null

    fun getPaymentSession(
      getPaymentMethodData: ReadableMap,
      getPaymentMethodData2: ReadableMap,
      getPaymentMethodDataArray: ReadableArray,
      callback: Callback
    ) {
      val handler = object : PaymentSessionHandler {
        override fun getCustomerDefaultSavedPaymentMethodData(): PaymentMethod {
          return parseGetPaymentMethodData(getPaymentMethodData)
        }

        override fun getCustomerLastUsedPaymentMethodData(): PaymentMethod {
          return parseGetPaymentMethodData(getPaymentMethodData2)
        }

        override fun getCustomerSavedPaymentMethodData(): Array<PaymentMethod> {
          val array = mutableListOf<PaymentMethod>()
          for (i in 0 until getPaymentMethodDataArray.size()) {
            array.add(parseGetPaymentMethodData(getPaymentMethodDataArray.getMap(i)))
          }
          return array.toTypedArray()
        }

        override fun confirmWithCustomerDefaultPaymentMethod(
          cvc: String?, resultHandler: (PaymentResult) -> Unit
        ) {
          getPaymentMethodData.getMap("_0")?.getString("payment_token")
            ?.let { confirmWithCustomerPaymentToken(it, cvc, resultHandler) }
        }

        override fun confirmWithCustomerLastUsedPaymentMethod(
          cvc: String?, resultHandler: (PaymentResult) -> Unit
        ) {
          getPaymentMethodData2.getMap("_0")?.getString("payment_token")
            ?.let { confirmWithCustomerPaymentToken(it, cvc, resultHandler) }
        }

        override fun confirmWithCustomerPaymentToken(
          paymentToken: String, cvc: String?, resultHandler: (PaymentResult) -> Unit
        ) {
          try {
            headlessCompletion = resultHandler
            val map = Arguments.createMap()
            map.putString("paymentToken", paymentToken)
            map.putString("cvc", cvc)
            callback.invoke(map)
          } catch (ex: Exception) {
            val throwable = Throwable("Not Initialised")
            throwable.initCause(Throwable("Not Initialised"))
            resultHandler(PaymentResult.Failed(throwable))
          }
        }
      }
      completion?.let { it(handler) }
    }


    private fun parseGetPaymentMethodData(readableMap: ReadableMap): PaymentMethod {

      val tag = try {
        readableMap.getString("TAG")
      } catch (ex: Exception) {
        ""
      }
      val dataObject: ReadableMap = readableMap.getMap("_0") ?: Arguments.createMap()

      return when (tag) {
        "SAVEDLISTCARD" -> {
          PaymentMethod.Card(
            isDefaultPaymentMethod = dataObject.getBoolean("isDefaultPaymentMethod"),
            paymentToken = dataObject.getString("payment_token") ?: "",
            cardScheme = dataObject.getString("cardScheme") ?: "",
            name = dataObject.getString("name") ?: "",
            expiryDate = dataObject.getString("expiry_date") ?: "",
            cardNumber = dataObject.getString("cardNumber") ?: "",
            nickName = dataObject.getString("nick_name") ?: "",
            cardHolderName = dataObject.getString("cardHolderName") ?: "",
            requiresCVV = dataObject.getBoolean("requiresCVV"),
            created = dataObject.getString("created") ?: "",
            lastUsedAt = dataObject.getString("lastUsedAt") ?: "",
          )
        }

        "SAVEDLISTWALLET" -> {
          PaymentMethod.Wallet(
            isDefaultPaymentMethod = dataObject.getBoolean("isDefaultPaymentMethod"),
            paymentToken = dataObject.getString("payment_token") ?: "",
            walletType = dataObject.getString("walletType") ?: "",
            created = dataObject.getString("created") ?: "",
            lastUsedAt = dataObject.getString("lastUsedAt") ?: "",
          )
        }

        else -> {
          PaymentMethod.Error(
            code = readableMap.getString("code") ?: "",
            message = readableMap.getString("message") ?: ""
          )
        }
      }
    }


    fun getHyperParams(): WritableMap? {
      val hyperParams = Arguments.createMap();
      hyperParams.putString("appId", activity.packageName)
      hyperParams.putString(
        "country", if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
          activity.resources.configuration.locales.get(0)?.country
        } else {
          activity.resources.configuration.locale.country
        }
      )
      hyperParams.putString("user-agent", Utils.getUserAgent(activity.applicationContext))
      hyperParams.putString("ip", Utils.getDeviceIPAddress(activity.applicationContext))
      hyperParams.putDouble("launchTime", Utils.getCurrentTime())
      hyperParams.putString("sdkVersion", "")
      hyperParams.putString("device_model", Build.MODEL)
      hyperParams.putString("os_type", "android")
      hyperParams.putString("os_version", Build.VERSION.RELEASE)
      hyperParams.putString("deviceBrand", Build.BRAND)
      return hyperParams
    }


    @SuppressLint("VisibleForTests")
    fun exitHeadless(paymentResult: String) {
      val message = JSONObject(paymentResult)
      when (val status = message.getString("status")) {
        "cancelled" -> headlessCompletion?.let { it(PaymentResult.Canceled(status)) }
        "failed", "requires_payment_method" -> {
          val throwable = Throwable(message.getString("message"))
          throwable.initCause(Throwable(message.getString("code")))
          headlessCompletion?.let { it(PaymentResult.Failed(throwable)) }
        }

        else -> headlessCompletion?.let { it(PaymentResult.Completed(status ?: "default")) }
      }
      // reactInstanceManager?.currentReactContext?.destroy()
      // reactInstanceManager?.destroy()
    }
  }
}

sealed class PaymentMethod {
  data class Card(
    val isDefaultPaymentMethod: Boolean,
    val paymentToken: String,
    val cardScheme: String,
    val name: String,
    val expiryDate: String,
    val cardNumber: String,
    val nickName: String,
    val cardHolderName: String,
    val requiresCVV: Boolean,
    val created: String,
    val lastUsedAt: String,
  ) : PaymentMethod() {
    fun toHashMap(): HashMap<String, Any> {
      val hashMap = HashMap<String, Any>()
      hashMap["isDefaultPaymentMethod"] = isDefaultPaymentMethod
      hashMap["paymentToken"] = paymentToken
      hashMap["cardScheme"] = cardScheme
      hashMap["name"] = name
      hashMap["expiryDate"] = expiryDate
      hashMap["cardNumber"] = cardNumber
      hashMap["nickName"] = nickName
      hashMap["cardHolderName"] = cardHolderName
      hashMap["requiresCVV"] = requiresCVV
      hashMap["created"] = created
      hashMap["lastUsedAt"] = lastUsedAt
      return hashMap
    }
  }

  data class Wallet(
    val isDefaultPaymentMethod: Boolean,
    val paymentToken: String,
    val walletType: String,
    val created: String,
    val lastUsedAt: String,
  ) : PaymentMethod() {
    fun toHashMap(): HashMap<String, Any> {
      val hashMap = HashMap<String, Any>()
      hashMap["isDefaultPaymentMethod"] = isDefaultPaymentMethod
      hashMap["paymentToken"] = paymentToken
      hashMap["walletType"] = walletType
      hashMap["created"] = created
      hashMap["lastUsedAt"] = lastUsedAt
      return hashMap
    }
  }

  data class Error(
    val code: String,
    val message: String,
  ) : PaymentMethod() {
    fun toHashMap(): HashMap<String, Any> {
      val hashMap = HashMap<String, Any>()
      hashMap["code"] = code
      hashMap["message"] = message
      return hashMap
    }
  }
}

interface PaymentSessionHandler {
  fun getCustomerDefaultSavedPaymentMethodData(): PaymentMethod
  fun getCustomerLastUsedPaymentMethodData(): PaymentMethod
  fun getCustomerSavedPaymentMethodData(): Array<PaymentMethod>
  fun confirmWithCustomerDefaultPaymentMethod(
    cvc: String? = null, resultHandler: (PaymentResult) -> Unit
  )

  fun confirmWithCustomerLastUsedPaymentMethod(
    cvc: String? = null, resultHandler: (PaymentResult) -> Unit
  )

  fun confirmWithCustomerPaymentToken(
    paymentToken: String, cvc: String? = null, resultHandler: (PaymentResult) -> Unit
  )
}
