type retryObject = {
  processor: string,
  redirectUrl: string,
}

type hyperProviderData = {publishableKey: string, customBackendUrl?: string}
let defaultVal: hyperProviderData = {publishableKey: ""}

let hyperProviderContext = React.createContext((defaultVal, (_: hyperProviderData) => ()))

module Provider = {
  let make = React.Context.provider(hyperProviderContext)
}
@react.component
let make = (~children, ~publishableKey="", ~customBackendUrl=None) => {
  let defaultVal: hyperProviderData = {publishableKey: publishableKey}
  let (state, setState) = React.useState(_ => defaultVal)

  React.useEffect1(() => {
    if (publishableKey != "") {
      setState(_ => {publishableKey, ?customBackendUrl})
    }
    None
  }, [publishableKey])

  let setState = React.useCallback1(val => {
    setState(_ => val)
  }, [setState])

  <Provider value=(state, setState)> children </Provider>
}
