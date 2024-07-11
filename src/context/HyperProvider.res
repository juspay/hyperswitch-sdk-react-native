type retryObject = {
  processor: string,
  redirectUrl: string,
}

type hyperProviderData = {publishableKey: string, customBackendUrl?: string}
let dafaultVal: hyperProviderData = {publishableKey: ""}

let hyperProviderContext = React.createContext((dafaultVal, (_: hyperProviderData) => ()))

module Provider = {
  let make = React.Context.provider(hyperProviderContext)
}
@react.component
let make = (~children, ~publishableKey="", ~customBackendUrl=None) => {
  let (state, setState) = React.useState(_ => dafaultVal)

  React.useEffect1(() => {
    setState(_ => {publishableKey, ?customBackendUrl})
    None
  }, [publishableKey])

  let setState = React.useCallback1(val => {
    setState(_ => val)
  }, [setState])

  <Provider value=(state, setState)> children </Provider>
}
