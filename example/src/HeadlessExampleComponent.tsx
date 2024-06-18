import * as React from 'react';

import { StyleSheet, View, Button, Text } from 'react-native';
import { presentPaymentSheet, useHyper } from 'hyperswitch-sdk-react-native';

export default function HeadlessExampleComponent() {
  const {
    initPaymentSession,
    presentPaymentSheet,
    initHeadless,

    getCustomerDefaultSavedPaymentMethodData,
    getCustomerLastUsedPaymentMethodData,
    getCustomerSavedPaymentMethodData,
    // confirmWithCustomerDefaultPaymentMethod,
  } = useHyper();

  const [response, setResponse] = React.useState('');

  const [clientSecret, setClientSecret] = React.useState('');

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

  let createPayment = async () => {
    const { clientSecret, customerId, ephemeralKey } =
      await fetchPaymentParams();
    setClientSecret(clientSecret);
  };

  // let confirmWithDefault = async () => {
  //   console.log('called!!!!!!!!!!!!!!!!');
  //   let params = initPaymentSession({
  //     clientSecret: clientSecret,
  //   });

  //   const resp = await confirmWithCustomerDefaultPaymentMethod(params);
  //   console.log('Headless example component--------', resp.message);
  //   setResponse(JSON.stringify(resp));
  // };

  let getDefaultCustomerPaymentMethod = async () => {
    console.log('called!!!!!!!!!!!!!!!!');

    let params = initPaymentSession({
      clientSecret: clientSecret,
    });

    const pmObj = await getCustomerDefaultSavedPaymentMethodData(params);
    console.log('Headless example component--------', pmObj);
    setResponse(JSON.stringify(pmObj));
  };

  let getCustomerLastUsedPaymentMethod = async () => {
    console.log('called!!!!!!!!!!!!!!!!');

    let params = initPaymentSession({
      clientSecret: clientSecret,
    });

    const pmObj = await getCustomerLastUsedPaymentMethodData(params);
    console.log('Headless example component--------', pmObj);
    setResponse(JSON.stringify(pmObj));
  };

  let getAllSavedPaymentMethodData = async () => {
    console.log('called!!!!!!!!!!!!!!!!');

    let params = initPaymentSession({
      clientSecret: clientSecret,
    });

    const pmObj = await getCustomerSavedPaymentMethodData(params);

    console.log('Headless example component--------', pmObj);
    setResponse(`{${JSON.stringify(pmObj[0])}....}`);
  };

  return (
    <View>
      <View style={{ marginTop: 50 }}>
        <Text style={{ fontSize: 20 }}>Headless Mode</Text>
        <Button title="Create Payment" onPress={createPayment} />
        <View style={{ marginTop: 10 }} />
        <Button
          title="get Customer Default Saved Payment Method Data"
          onPress={getDefaultCustomerPaymentMethod}
        />
        <View style={{ marginTop: 10 }} />
        <Button
          title="get Customer Last Used Saved Payment Method Data"
          onPress={getCustomerLastUsedPaymentMethod}
        />
        <View style={{ marginTop: 10 }} />
        {/* <Button title="Confirm Payment" onPress={confirmWithDefault} /> */}
        <Button
          title="get All Saved Payment Method Data"
          onPress={getAllSavedPaymentMethodData}
        />
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
