import * as React from 'react';
import { Platform } from 'react-native';

import { View, Button, Text, ActivityIndicator } from 'react-native';
import { useHyper } from 'hyperswitch-sdk-react-native';
import type { sessionParams } from 'hyperswitch-sdk-react-native';
type Option<T> = T | null;
export default function HeadlessExampleComponent() {
  const {
    initPaymentSession,
    getCustomerSavedPaymentMethods,
    getCustomerDefaultSavedPaymentMethodData,
    getCustomerLastUsedPaymentMethodData,
    getCustomerSavedPaymentMethodData,
    confirmWithCustomerDefaultPaymentMethod,
    confirmWithCustomerLastUsedPaymentMethod,
    confirmWithCustomerPaymentToken,
  } = useHyper();

  const [isHeadlessInitialised, setIsHeadlessInitialised] =
    React.useState(false);
  const [response, setResponse] = React.useState('');

  const [showLoader, setShowLoader] = React.useState(false);

  const [savedPaymentSession, setSavedPaymentSession] =
    React.useState<Option<sessionParams>>(null);

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

  let initialisePaymentSession = async () => {
    setShowLoader(true);
    const { clientSecret } = await fetchPaymentParams();

    const params = await initPaymentSession({
      clientSecret: clientSecret,
    });
    const savedPaymentSession = await getCustomerSavedPaymentMethods(params);
    setSavedPaymentSession(savedPaymentSession);
    setIsHeadlessInitialised(true);
    setShowLoader(false);
  };

  let getDefaultCustomerPaymentMethod = async () => {
    setShowLoader(true);

    if (savedPaymentSession != null) {
      const pmObj =
        await getCustomerDefaultSavedPaymentMethodData(savedPaymentSession);

      setResponse(JSON.stringify(pmObj));
    }
    setShowLoader(false);
  };

  let getCustomerLastUsedPaymentMethod = async () => {
    setShowLoader(true);

    if (savedPaymentSession != null) {
      const pmObj =
        await getCustomerLastUsedPaymentMethodData(savedPaymentSession);

      setResponse(JSON.stringify(pmObj));
    }
    setShowLoader(false);
  };

  let getAllSavedPaymentMethodData = async () => {
    setShowLoader(true);

    if (savedPaymentSession != null) {
      const savedPaymentMethodsArray =
        await getCustomerSavedPaymentMethodData(savedPaymentSession);

      setResponse(`{${JSON.stringify(savedPaymentMethodsArray[0])}....}`);
    }
    setShowLoader(false);
  };

  let confirmWithCustomerDefaultPM = async () => {
    setShowLoader(true);

    if (savedPaymentSession != null) {
      const response = await confirmWithCustomerDefaultPaymentMethod({
        sessionParams: savedPaymentSession,
        cvc: '124',
      });

      setResponse(JSON.stringify(response));
      setShowLoader(false);
    }
    setIsHeadlessInitialised(false);
  };

  let confirmWithLastUsedPM = async () => {
    setShowLoader(true);

    if (savedPaymentSession != null) {
      const response = await confirmWithCustomerLastUsedPaymentMethod({
        sessionParams: savedPaymentSession,
      });

      setResponse(JSON.stringify(response));
      setShowLoader(false);
    }
    setIsHeadlessInitialised(false);
  };

  let confirmWithPaymentToken = async () => {
    setShowLoader(true);

    if (savedPaymentSession != null) {
      const response = await confirmWithCustomerPaymentToken({
        sessionParams: savedPaymentSession,
        cvc: '424',
        paymentToken: 'CUSTOMER_PAYMENT_TOKEN',
      });

      setResponse(JSON.stringify(response));
      setShowLoader(false);
    }
    setIsHeadlessInitialised(false);
  };

  return (
    <View style={{ margin: 10 }}>
      <View style={{ marginTop: 50 }}>
        <Button
          title="Init Payment Session"
          onPress={initialisePaymentSession}
        />
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
        <View style={{ marginTop: 10 }} />
        <Button
          title="Confirm with Payment Token"
          onPress={confirmWithPaymentToken}
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
