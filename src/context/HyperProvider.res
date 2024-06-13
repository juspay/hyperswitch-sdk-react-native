type retryObject = {
  processor: string,
  redirectUrl: string,
}

type hyperProviderData = {publishableKey: string}
let dafaultVal: hyperProviderData = {publishableKey: ""}

let hyperProviderContext = React.createContext((dafaultVal, (_: hyperProviderData) => ()))

module Provider = {
  let make = React.Context.provider(hyperProviderContext)
}
@react.component
let make = (~children, ~publishableKey="") => {
  let (state, setState) = React.useState(_ => {...dafaultVal, publishableKey})

  React.useEffect1(() => {
    setState(_ => {publishableKey: publishableKey})
    None
  }, [publishableKey])

  let setState = React.useCallback1(val => {
    setState(_ => val)
  }, [setState])

  <Provider value=(state, setState)> children </Provider>
}
