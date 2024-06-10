package com.hyperswitchsdkreactnative.view

import android.content.Context
import android.os.Bundle
import android.util.AttributeSet
import android.widget.FrameLayout
import androidx.appcompat.app.AppCompatActivity
import com.hyperswitchsdkreactnative.react.Utils
import com.facebook.react.bridge.*
class GooglePayButton constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0
) : FrameLayout(context, attrs, defStyleAttr) {
    private var ctx: Context? = null
    private var walletType: String = "google_pay"

    constructor(context: Context?) : this(context!!) {
        ctx = context
        initView(context)
    }

    constructor(context: Context?, attrs: AttributeSet?) : this(
        context!!, attrs
    ) {
        ctx = context
        initView(context)
    }

    private fun initView(context: Context) {
        val writableMap: WritableMap = Arguments.createMap()
        writableMap.putString("themes", "Dark")
        Utils.openReactView(context as AppCompatActivity, toBundleObject(writableMap as ReadableMap), walletType, id)
    }


    override fun onMeasure(width: Int, height: Int) {
        super.onMeasure(
            MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY),
            MeasureSpec.makeMeasureSpec(150, MeasureSpec.EXACTLY)
        )
    }

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
