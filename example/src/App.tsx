import { createStackNavigator } from '@react-navigation/stack';
import * as React from 'react';
import { StyleSheet, View } from 'react-native';
import { HyperProvider } from 'hyperswitch-sdk-react-native';
import HeadlessExampleComponent from './HeadlessExampleComponent';
import Home from './Home';
import { NavigationContainer } from '@react-navigation/native';
import { enableScreens } from 'react-native-screens';
import PaymentScreen from './PaymentScreen';
import type { RootStackParamList } from './Home';
enableScreens();
export default function App() {
  const Stack = createStackNavigator<RootStackParamList>();
  const publishableKey = 'pk_snd_3b33cd9404234113804aa1accaabe22f';
  return (
    <HyperProvider
      publishableKey={publishableKey}
      // customBackendUrl="YOUR_CUSTOM_BACKEND_URL"
    >
      <NavigationContainer>
        <Stack.Navigator initialRouteName="Home">
          <Stack.Screen
            name="Home"
            options={{ title: 'HyperSwitch React Native SDK' }}
            component={Home}
          />
          <Stack.Screen
            name="Headless"
            options={{ title: 'HyperSwitch Headless SDK' }}
            component={HeadlessExampleComponent}
          />
          <Stack.Screen
            name="PaymentSheet"
            options={{ title: 'HyperSwitch SDK Payment Sheet' }}
            component={PaymentScreen}
          />
        </Stack.Navigator>
      </NavigationContainer>
    </HyperProvider>
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
