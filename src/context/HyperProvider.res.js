// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as JsxRuntime from "react/jsx-runtime";

var defaultVal = {
  publishableKey: ""
};

var hyperProviderContext = React.createContext([
      defaultVal,
      (function (param) {
          
        })
    ]);

var make = hyperProviderContext.Provider;

var Provider = {
  make: make
};

function HyperProvider(props) {
  var __customBackendUrl = props.customBackendUrl;
  var __publishableKey = props.publishableKey;
  var publishableKey = __publishableKey !== undefined ? __publishableKey : "";
  var customBackendUrl = __customBackendUrl !== undefined ? Caml_option.valFromOption(__customBackendUrl) : undefined;
  var match = React.useState(function () {
        return defaultVal;
      });
  var setState = match[1];
  React.useEffect((function () {
          setState(function (param) {
                return {
                        publishableKey: publishableKey,
                        customBackendUrl: customBackendUrl
                      };
              });
        }), [publishableKey]);
  var setState$1 = React.useCallback((function (val) {
          setState(function (param) {
                return val;
              });
        }), [setState]);
  return JsxRuntime.jsx(make, {
              value: [
                match[0],
                setState$1
              ],
              children: props.children
            });
}

var make$1 = HyperProvider;

export {
  defaultVal ,
  hyperProviderContext ,
  Provider ,
  make$1 as make,
}
/* hyperProviderContext Not a pure module */
