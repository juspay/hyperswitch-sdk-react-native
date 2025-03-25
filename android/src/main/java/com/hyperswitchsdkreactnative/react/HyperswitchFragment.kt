package com.hyperswitchsdkreactnative.react

import android.annotation.TargetApi
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.KeyEvent
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.facebook.hermes.reactexecutor.HermesExecutorFactory
import com.facebook.react.HyperPackageList
import com.facebook.react.ReactDelegate
import com.facebook.react.ReactFragment
import com.facebook.react.ReactInstanceManager
import com.facebook.react.ReactRootView
import com.facebook.react.common.LifecycleState
import com.facebook.react.modules.core.PermissionAwareActivity
import com.facebook.react.modules.core.PermissionListener
import com.hyperswitchsdkreactnative.ReactNativeHyperswitchPackage

// TODO: Rename parameter arguments, choose names that match
// the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
private const val ARG_PARAM1 = "param1"
private const val ARG_PARAM2 = "param2"

/**
 * A simple [Fragment] subclass.
 * Use the [HyperswitchFragment.newInstance] factory method to
 * create an instance of this fragment.
 */
open class HyperswitchFragment : ReactFragment(),
  PermissionAwareActivity {
  private var reactDelegate: ReactDelegate? = null
  private var mPermissionListener: PermissionListener? = null
  // private var originalSoftInputMode: Int = WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    var mainComponentName: String? = null
    var launchOptions: Bundle? = null
    if (this.arguments != null) {
      mainComponentName = this.requireArguments().getString("arg_component_name")
      launchOptions = this.requireArguments().getBundle("arg_launch_options")
    }
    checkNotNull(mainComponentName) { "Cannot loadApp if component name is null" }

    reactDelegate = ReactDelegate(
      this.activity,
      reactNativeHost, mainComponentName, launchOptions
    )
  }
  override fun onCreateView(
    inflater: LayoutInflater,
    container: ViewGroup?,
    savedInstanceState: Bundle?
  ): View? {

    val mReactRootView = ReactRootView(context)

    val packages = HyperPackageList(activity?.application, context).packages
    packages.add(ReactNativeHyperswitchPackage())

    val mReactInstanceManager = ReactInstanceManager.builder()
      .setApplication(activity?.application)
      .setCurrentActivity(activity)
      .addPackages(packages)
      .setBundleAssetName("hyperswitch.bundle")
      .setJSMainModulePath("index")
      .setJSBundleFile("assets://hyperswitch.bundle")
      .setJavaScriptExecutorFactory(HermesExecutorFactory())
      .setUseDeveloperSupport(false)
      .setInitialLifecycleState(LifecycleState.RESUMED)
      .build()

    var mainComponentName: String? = null
    var launchOptions: Bundle? = null
    if (this.arguments != null) {
      mainComponentName = this.requireArguments().getString("arg_component_name")
      launchOptions = this.requireArguments().getBundle("arg_launch_options")
      Log.i("called", launchOptions.toString())
    }
    checkNotNull(mainComponentName) { "Cannot loadApp if component name is null" }
    mReactRootView.startReactApplication(mReactInstanceManager, mainComponentName, launchOptions)

    // originalSoftInputMode = activity?.window?.attributes?.softInputMode ?: WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE
    // setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);

    return mReactRootView
  }

  private fun setSoftInputMode(inputMode: Int) {
    // if(originalSoftInputMode != WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE)
      activity?.window?.setSoftInputMode(inputMode)
  }

  override fun onResume() {
    super.onResume()
    reactDelegate!!.onHostResume()
    // setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE)
  }

  override fun onPause() {
    super.onPause()
    reactDelegate!!.onHostPause()
    // setSoftInputMode(originalSoftInputMode)
  }

  override fun onDestroy() {
    super.onDestroy()
    reactDelegate!!.onHostDestroy()
    // setSoftInputMode(originalSoftInputMode)
  }

  override fun onHiddenChanged(hidden: Boolean) {
    super.onHiddenChanged(hidden)

    if (hidden) {
      // setSoftInputMode(originalSoftInputMode)
    } else {
      // setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE)
    }
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    super.onActivityResult(requestCode, resultCode, data)
    reactDelegate!!.onActivityResult(requestCode, resultCode, data, false)
  }

  override fun onBackPressed(): Boolean {
    return reactDelegate!!.onBackPressed()
  }

  override fun onKeyUp(keyCode: Int, event: KeyEvent?): Boolean {
    return reactDelegate!!.shouldShowDevMenuOrReload(keyCode, event)
  }

  override fun onRequestPermissionsResult(
    requestCode: Int,
    permissions: Array<String>,
    grantResults: IntArray
  ) {
    super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    if (mPermissionListener != null && mPermissionListener!!.onRequestPermissionsResult(
        requestCode,
        permissions,
        grantResults
      )
    ) {
      mPermissionListener = null
    }
  }

  override fun checkPermission(permission: String, pid: Int, uid: Int): Int {
    return this.requireActivity().checkPermission(permission, pid, uid)
  }

  @TargetApi(23)
  override fun checkSelfPermission(permission: String): Int {
    return this.requireActivity().checkSelfPermission(permission)
  }

  @TargetApi(23)
  override fun requestPermissions(
    permissions: Array<String>,
    requestCode: Int,
    listener: PermissionListener
  ) {
    mPermissionListener = listener
    this.requestPermissions(permissions, requestCode)
  }

  class Builder: ReactFragment.Builder() {
    private lateinit var mComponentName: String
    private lateinit var mLaunchOptions: Bundle
    override fun setComponentName(componentName: String): Builder {
      mComponentName = componentName
      return this
    }

    override fun setLaunchOptions(launchOptions: Bundle): Builder {
      mLaunchOptions = launchOptions
      return this
    }

    override fun build(): HyperswitchFragment {
      return newInstance(
        mComponentName,
        mLaunchOptions
      )
    }
  }

  companion object {
    private fun newInstance(componentName: String, launchOptions: Bundle): HyperswitchFragment {
      val fragment = HyperswitchFragment()
      val args = Bundle()
      args.putString("arg_component_name", componentName)
      args.putBundle("arg_launch_options", launchOptions)
      fragment.arguments = args
      return fragment
    }
  }
}
