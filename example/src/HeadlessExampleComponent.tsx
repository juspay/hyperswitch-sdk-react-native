import * as React from 'react';
import { Platform } from 'react-native';

import { View, Button, Text, ActivityIndicator } from 'react-native';
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

  const [isHeadlessInitialised, setIsHeadlessInitialised] =
    React.useState(false);
  const [response, setResponse] = React.useState('');

  const [showLoader, setShowLoader] = React.useState(false);

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
    setShowLoader(true);
    const { clientSecret } = await fetchPaymentParams();
    setClientSecret(clientSecret);
    const params = await initPaymentSession({
      clientSecret: clientSecret,
    });
    setIsHeadlessInitialised(true);
    setShowLoader(false);
  };

  let getDefaultCustomerPaymentMethod = async () => {
    setShowLoader(true);

    let params = await initPaymentSession({
      clientSecret: clientSecret,
    });

    const pmObj = await getCustomerDefaultSavedPaymentMethodData(params);
    console.log('Headless example component--------', pmObj);
    setResponse(JSON.stringify(pmObj));
    setShowLoader(false);
  };

  let getCustomerLastUsedPaymentMethod = async () => {
    setShowLoader(true);
    let params = await initPaymentSession({
      clientSecret: clientSecret,
    });

    const pmObj = await getCustomerLastUsedPaymentMethodData(params);
    console.log('Headless example component--------', pmObj);
    setResponse(JSON.stringify(pmObj));
    setShowLoader(false);
  };

  let getAllSavedPaymentMethodData = async () => {
    setShowLoader(true);
    let params = await initPaymentSession({
      clientSecret: clientSecret,
    });

    const savedPaymentMethodsArray =
      await getCustomerSavedPaymentMethodData(params);

    console.log('Headless example component--------', savedPaymentMethodsArray);

    savedPaymentMethodsArray.forEach((item, idx) => {
      console.log(`${idx}---> ${item.cardHolderName}`);
    });

    setResponse(`{${JSON.stringify(savedPaymentMethodsArray[0])}....}`);
    setShowLoader(false);
  };

  let confirmWithCustomerDefaultPM = async () => {
    setShowLoader(true);
    let params = await initPaymentSession({
      clientSecret: clientSecret,
    });

    const response = await confirmWithCustomerDefaultPaymentMethod(params);

    console.log('Headless example component--------', response.message);
    setResponse(JSON.stringify(response));
    setShowLoader(false);
  };

  let confirmWithLastUsedPM = async () => {
    setShowLoader(true);
    let params = await initPaymentSession({
      clientSecret: clientSecret,
    });

    const response = await confirmWithCustomerLastUsedPaymentMethod(params);

    console.log('Headless example component--------', response.message);
    setResponse(JSON.stringify(response));
    setShowLoader(false);
  };

  return (
    <View style={{ margin: 10 }}>
      <View style={{ marginTop: 50 }}>
        <Button title="Init Headless" onPress={createPayment} />
        <View style={{ marginTop: 10 }} />
        <Button
          title="get Customer Default Saved Payment Method Data"
          onPress={getDefaultCustomerPaymentMethod}
          disabled={!isHeadlessInitialised}
        />
        <View style={{ marginTop: 10 }} />
        <Button
          title="get Customer Last Used Saved Payment Method Data"
          onPress={getCustomerLastUsedPaymentMethod}
          disabled={!isHeadlessInitialised}
        />
        <View style={{ marginTop: 10 }} />
        {/* <Button title="Confirm Payment" onPress={confirmWithDefault} /> */}
        <Button
          title="get All Saved Payment Method Data"
          onPress={getAllSavedPaymentMethodData}
          disabled={!isHeadlessInitialised}
        />
        <View style={{ marginTop: 10 }} />
        <Button
          title="Confirm with Default Saved Payment Method"
          onPress={confirmWithCustomerDefaultPM}
          disabled={!isHeadlessInitialised}
        />
        <View style={{ marginTop: 10 }} />
        <Button
          title="Confirm with Last Used Saved Payment Method"
          onPress={confirmWithLastUsedPM}
          disabled={!isHeadlessInitialised}
        />
      </View>

      {showLoader == true ? (
        <ActivityIndicator size={80} style={{ marginTop: 20 }} color="black" />
      ) : (
        <Text style={{ marginTop: 40, fontWeight: 'bold', fontSize: 15 }}>
          {response}
        </Text>
      )}
    </View>
  );
}
