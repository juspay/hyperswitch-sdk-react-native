package com.hyperswitchsdkreactnative.react
import android.util.Log
import android.content.Context
import android.content.pm.ActivityInfo
import android.net.wifi.WifiManager
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import android.webkit.WebSettings
import androidx.appcompat.app.AppCompatActivity
import com.hyperswitchsdkreactnative.R
import java.util.Locale

class Utils {
  companion object {
    @JvmStatic
    lateinit var reactNativeFragmentCard: HyperswitchFragment
    @JvmStatic
    var reactNativeFragmentSheet: HyperswitchFragment? = null
    @JvmStatic
    var lastRequest: Bundle? = null
    @JvmStatic
    var flags: Int = 0

    /**
     *
     * @param message message
     * @param clientSecret client secret
     * @param configuration Configuration
     */
    fun openReactView(
      context: AppCompatActivity,
      request: Bundle,
      message: String,
      id: Int?,
      isHidden: Boolean? = false
    ) {
      Log.i("called", "2")

      context.runOnUiThread {
        val transaction = context.supportFragmentManager.beginTransaction()
        val userAgent = getUserAgent(context)
        val ipAddress = getDeviceIPAddress(context)
        context.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_LOCKED
        if (message != "card" && message != "google_pay" && message != "paypal") {
          flags = context.window.attributes.flags
          if (message != "unifiedCheckout") {
            context.window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
            context.window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION)
          } else {
            context.window.addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
            context.window.addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION)
          }

          if (reactNativeFragmentSheet == null) {
            lastRequest = request
            reactNativeFragmentSheet = HyperswitchFragment.Builder()
              .setComponentName("hyperSwitch")
              .setLaunchOptions(
                getLaunchOptions(
                  request,
                  message,
                  context.packageName,
                  context.resources.configuration.locale.country,
                  userAgent,
                  ipAddress
                )
              )
              //.setFabricEnabled(BuildConfig.IS_NEW_ARCHITECTURE_ENABLED)
              .build()

            if (isHidden == true)
              transaction.hide(reactNativeFragmentSheet!!)

            transaction.add(android.R.id.content, reactNativeFragmentSheet!!).commit()
          } else if (areBundlesNotEqual(request, lastRequest)) {
            lastRequest = request
            reactNativeFragmentSheet = HyperswitchFragment.Builder()
              .setComponentName("hyperSwitch")
              .setLaunchOptions(
                getLaunchOptions(
                  request,
                  message,
                  context.packageName,
                  context.resources.configuration.locale.country,
                  userAgent,
                  ipAddress
                )
              )
              //.setFabricEnabled(BuildConfig.IS_NEW_ARCHITECTURE_ENABLED)
              .build()
            if (isHidden == true)
              transaction.hide(reactNativeFragmentSheet!!)
            transaction.replace(android.R.id.content, reactNativeFragmentSheet!!).commit()
          } else {

            if (isHidden == true)
              transaction.hide(reactNativeFragmentSheet!!)
            transaction.setCustomAnimations(R.anim.enter_from_bottom, R.anim.exit_to_bottom)
              .show(reactNativeFragmentSheet!!).commit();
          }
        } else {
          flags = 0
          reactNativeFragmentCard = HyperswitchFragment.Builder()
            .setComponentName("hyperSwitch")
            .setLaunchOptions(
              getLaunchOptions(
                request,
                message,
                context.packageName,
                context.resources.configuration.locale.country,
                userAgent,
                ipAddress
              )
            )
            //.setFabricEnabled(BuildConfig.IS_NEW_ARCHITECTURE_ENABLED)
            .build()
          transaction.add(id ?: android.R.id.content, reactNativeFragmentCard).commit()
        }
        context.supportFragmentManager
          .addFragmentOnAttachListener { _, _ ->
            context.savedStateRegistry.unregisterSavedStateProvider("android:support:fragments")
          }
      }
    }
    fun openReactViewInBackground(
      context: AppCompatActivity,
      request: Bundle,
      message: String,
      id: Int?,
      isHidden: Boolean? = false
    ) {
      // Initialize React context in the background
//      reactInstanceManager!!.createReactContextInBackground()

      // Run on UI thread if needed, although you are not manipulating UI here
      context.runOnUiThread {
        val userAgent = getUserAgent(context)
        val ipAddress = getDeviceIPAddress(context)
        val launchOptions = getLaunchOptions(
          request,
          message,
          context.packageName,
          context.resources.configuration.locale.country,
          userAgent,
          ipAddress
        )

        // Ensure the fragment is not added to the UI
        if (reactNativeFragmentSheet == null) {
          lastRequest = request
          reactNativeFragmentSheet = HyperswitchFragment.Builder()
            .setComponentName("hyperSwitch")
            .setLaunchOptions(launchOptions)
            .build()

          // Initialize the fragment without adding it to the UI
          context.supportFragmentManager.beginTransaction()
            .add(android.R.id.content, reactNativeFragmentSheet!!).commitNowAllowingStateLoss()
          context.supportFragmentManager.beginTransaction()
            .remove(reactNativeFragmentSheet!!).commitNowAllowingStateLoss()
        } else if (areBundlesNotEqual(request, lastRequest)) {
          lastRequest = request
          reactNativeFragmentSheet = HyperswitchFragment.Builder()
            .setComponentName("hyperSwitch")
            .setLaunchOptions(launchOptions)
            .build()

          // Initialize the fragment without adding it to the UI
          context.supportFragmentManager.beginTransaction()
            .add(android.R.id.content, reactNativeFragmentSheet!!).commitNowAllowingStateLoss()
          context.supportFragmentManager.beginTransaction()
            .remove(reactNativeFragmentSheet!!).commitNowAllowingStateLoss()
        }
      }
    }

    private fun areBundlesNotEqual(bundle1: Bundle?, bundle2: Bundle?): Boolean {
      if (bundle1 == null || bundle2 == null) {
        return true
      }
      if (bundle1.getString("publishableKey") == bundle2.getString("publishableKey")
        && bundle1.getString("clientSecret") == bundle2.getString("clientSecret")
        && bundle1.getString("type") == bundle2.getString("type")
      ) {
        return false
      }
      return true
    }


    fun getUserAgent(context: Context): String {
      return try {
        WebSettings.getDefaultUserAgent(context)
      } catch (e: RuntimeException) {
        System.getProperty("http.agent") ?: ""
      }
    }


    /**
     *
     * @param message message
     * @param request client secret params
     */

    private fun getLaunchOptions(
      request: Bundle,
      message: String,
      packageName: String,
      country: String,
      userAgent: String,
      ipAddress : String
    ): Bundle {
      request.putString("type", message)
      val hyperParams = Bundle()
      Log.i("Package Name---->", packageName)
      hyperParams.putString("appId", packageName)
      hyperParams.putString("country", country)
      hyperParams.putString("user-agent", userAgent)
      hyperParams.putString("ip", ipAddress)
      hyperParams.putDouble("launchTime", getCurrentTime())
      hyperParams.putString("sdkVersion", "")
      hyperParams.putString("device_model", Build.MODEL)
      hyperParams.putString("os_type", "android")
      hyperParams.putString("os_version", Build.VERSION.RELEASE)
      hyperParams.putString("deviceBrand", Build.BRAND)
      request.putBundle("hyperParams", hyperParams)
      val bundle = Bundle()
      bundle.putBundle("props", request)
      return bundle
    }

    fun hideFragment(context: AppCompatActivity, reset: Boolean) {
      if (reactNativeFragmentSheet != null) {
        context.supportFragmentManager
          .beginTransaction()
//          .setCustomAnimations(R.anim.enter_from_bottom, R.anim.exit_to_bottom)
          .hide(reactNativeFragmentSheet!!)
          .commit()
      }
      context.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED
      if (flags != 0) {
        context.runOnUiThread {
          context.window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
          context.window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION)
          context.window.addFlags(flags)
        }
      }
      if (reset) {
        reactNativeFragmentSheet = null
      }
    }

    fun onBackPressed(): Boolean {
      return if (reactNativeFragmentSheet == null || reactNativeFragmentSheet!!.isHidden) {
        false
      } else {
        reactNativeFragmentSheet!!.onBackPressed()
        true
      }
    }

    fun getCurrentTime(): Double {
      return System.currentTimeMillis().toDouble()
    }

    // Get device IP address
    fun getDeviceIPAddress(context: Context): String {
      val wifiManager = context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
      val wifiInfo = wifiManager.connectionInfo
      val ipAddress = wifiInfo.ipAddress
      return String.format(
        Locale.getDefault(), "%d.%d.%d.%d",
        ipAddress and 0xff,
        ipAddress shr 8 and 0xff,
        ipAddress shr 16 and 0xff,
        ipAddress shr 24 and 0xff
      )
    }
  }
}
