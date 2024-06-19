import * as React from 'react';
import { Platform } from 'react-native';

import { View, Button, Text } from 'react-native';
import { useHyper } from 'hyperswitch-sdk-react-native';

export default function HeadlessExampleComponent() {
  const {
    initPaymentSession,
    getCustomerDefaultSavedPaymentMethodData,
    getCustomerLastUsedPaymentMethodData,
    getCustomerSavedPaymentMethodData,
    confirmWithCustomerDefaultPaymentMethod,
    confirmWithCustomerLastUsedPaymentMethod,
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
    const { clientSecret } = await fetchPaymentParams();
    setClientSecret(clientSecret);
  };

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

    const savedPaymentMethodsArray =
      await getCustomerSavedPaymentMethodData(params);

    console.log('Headless example component--------', savedPaymentMethodsArray);

    savedPaymentMethodsArray.forEach((item, idx) => {
      console.log(`${idx}---> ${item.cardHolderName}`);
    });

    setResponse(`{${JSON.stringify(savedPaymentMethodsArray[0])}....}`);
  };

  let confirmWithCustomerDefaultPM = async () => {
    console.log('called!!!!!!!!!!!!!!!!');

    let params = initPaymentSession({
      clientSecret: clientSecret,
    });

    const response = await confirmWithCustomerDefaultPaymentMethod(params);

    console.log('Headless example component--------', response.message);
    setResponse(JSON.stringify(response));
  };

  let confirmWithLastUsedPM = async () => {
    console.log('called!!!!!!!!!!!!!!!!');

    let params = initPaymentSession({
      clientSecret: clientSecret,
    });

    const response = await confirmWithCustomerLastUsedPaymentMethod(params);

    console.log('Headless example component--------', response.message);
    setResponse(JSON.stringify(response));
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
        <View style={{ marginTop: 10 }} />
        <Button
          title="Confirm with Default Saved Payment Method"
          onPress={confirmWithCustomerDefaultPM}
        />
        <View style={{ marginTop: 10 }} />
        <Button
          title="Confirm with Last Used Saved Payment Method"
          onPress={confirmWithLastUsedPM}
        />
      </View>
      <Text style={{ marginTop: 40, fontWeight: 'bold', fontSize: 15 }}>
        {response}
      </Text>
    </View>
  );
}
