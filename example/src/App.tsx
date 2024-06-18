import * as React from 'react';

import { StyleSheet, View } from 'react-native';
import { HyperProvider } from 'hyperswitch-sdk-react-native';
import PaymentScreen from './PaymentScreen';

export default function App() {
  const publishableKey = 'pk_snd_3b33cd9404234113804aa1accaabe22f';
  return (
    <View style={styles.container}>
      <HyperProvider
        publishableKey={publishableKey}
        // customBackendUrl="YOUR_CUSTOM_BACKEND_URL"
      >
        <PaymentScreen />
      </HyperProvider>
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
