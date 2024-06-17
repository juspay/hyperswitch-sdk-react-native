import * as React from 'react';

import { StyleSheet, View, Button, Text } from 'react-native';
import { presentPaymentSheet, useHyper } from 'hyperswitch-sdk-react-native';

export default function HeadlessExampleComponent() {
  const {
    initPaymentSheet,
    presentPaymentSheet,
    initHeadless,
    getCustomerSavedPaymentMethodData,
  } = useHyper()();

  const [response, setResponse] = React.useState('');

  const fetchPaymentParams = async () => {
    const response = await fetch(
      Platform.OS == 'ios'
        ? `http://localhost:4242/create-payment-intent`
        : `http://10.0.2.2:4242/create-payment-intent`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ items: [{ id: 'xl-tshirt' }] }),
      }
    );
    const val = await response.json();

    return val;
  };

  // const initializePaymentSheet = async () => {
  //   const { clientSecret, customerId, ephemeralKey } =
  //     await fetchPaymentParams();

  //   console.log('clientSecret', clientSecret);

  //   const paymentSheetProps = {
  //     clientSecret: clientSecret,
  //   };

  //   const paymentSheetParams = initPaymentSheet(paymentSheetProps);

  //   console.log('paymentSheet Params-------------->' + paymentSheetParams);
  //   let res = await presentPaymentSheet(paymentSheetParams);
  //   console.log('Payment Result dfdsfknsdjkf' + res.status);
  //   const stringifiedResponse = JSON.stringify(res);
  //   setResponse(stringifiedResponse);
  // };
  let initialiseHeadless = async () => {
    const { clientSecret, customerId, ephemeralKey } =
      await fetchPaymentParams();
    let params = {
      clientSecret: clientSecret,
    };
    initHeadless(params);
  };

  let getSavedPaymentMethods = async () => {
    console.log('called!!!!!!!!!!!!!!!!');
    let params = {
      clientSecret: '',
    };

    getCustomerSavedPaymentMethodData(params);
  };

  // React.useEffect(() => {
  //   test();
  // }, []);

  return (
    <View>
      <View style={{ marginTop: 50 }}>
        <Text style={{ fontSize: 20 }}>Headless Mode</Text>
        <Button title="Initialize Headless" onPress={initialiseHeadless} />
        <View style={{ marginTop: 10 }} />
        <Button title="Confirm Payment" onPress={getSavedPaymentMethods} />
      </View>
      <Text style={{ marginTop: 40, fontWeight: 'bold', fontSize: 15 }}>
        {response}
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
