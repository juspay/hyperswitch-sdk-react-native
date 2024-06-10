
package com.facebook.react;

import android.app.Application;
import android.content.Context;
import android.content.res.Resources;

import com.facebook.react.ReactPackage;
import com.facebook.react.shell.MainPackageConfig;
import com.facebook.react.shell.MainReactPackage;
import com.horcrux.svg.SvgPackage;
//import com.hyperswitchkount.HyperswitchKountPackage;
import com.microsoft.codepush.react.CodePush;
import com.proyecto26.inappbrowser.RNInAppBrowserPackage;
import com.reactnativepagerview.PagerViewPackage;
import com.swmansion.gesturehandler.RNGestureHandlerPackage;
import com.swmansion.rnscreens.RNScreensPackage;
import com.th3rdwave.safeareacontext.SafeAreaContextPackage;

import java.util.Arrays;
import java.util.ArrayList;


public class HyperPackageList {
  private Application application;
  private ReactNativeHost reactNativeHost;
  private MainPackageConfig mConfig;
  private Context mContext;

  public HyperPackageList(ReactNativeHost reactNativeHost) {
    this(reactNativeHost, null);
  }

  public HyperPackageList(Application application, Context context) {
    this(application, null, context);
  }

  public HyperPackageList(ReactNativeHost reactNativeHost, MainPackageConfig config) {
    this.reactNativeHost = reactNativeHost;
    mConfig = config;
  }

  public HyperPackageList(Application application, MainPackageConfig config, Context context) {
    this.reactNativeHost = null;
    this.application = application;
    mConfig = config;
    mContext = context;
  }

  private ReactNativeHost getReactNativeHost() {
    return this.reactNativeHost;
  }

  private Resources getResources() {
    return this.getApplication().getResources();
  }

  private Application getApplication() {
    if (this.reactNativeHost == null) return this.application;
    return this.reactNativeHost.getApplication();
  }

  private Context getApplicationContext() {
    return mContext;
  }

  public ArrayList<ReactPackage> getPackages() {
    return new ArrayList<>(Arrays.<ReactPackage>asList(
      new MainReactPackage(mConfig),
//      new RNSentryPackage(),
      new CodePush("ZAmo7uOXuDhPzU1NKlOOwGHasre9bTOKqrLLu", getApplicationContext(), true),
      new RNGestureHandlerPackage(),
//      new HyperswitchKountPackage(),
      new RNInAppBrowserPackage(),
      new PagerViewPackage(),
      new SafeAreaContextPackage(),
      new RNScreensPackage(),
      new SvgPackage()
    ));
  }
}
