import React from 'react';
import { StatusBar, useColorScheme } from 'react-native';
import { Colors } from 'react-native/Libraries/NewAppScreen';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import Section from './Section';
import PaymentScreen from './PaymentScreen';
import HeadlessScreen from './HeadlessScreen';
import getPublishableKey from './utils/getPublishableKey';
import { HyperProvider } from 'hyperswitch-sdk-react-native';

const navOptions = ['Payment', 'Headless'];

const HomeScreen = ({ navigation }: any) => (
  <Section title="Payment" navigation={navigation} options={navOptions}>
    <PaymentScreen />
  </Section>
);

const Headless = ({ navigation }: any) => (
  <Section title="Headless" navigation={navigation} options={navOptions}>
    <HeadlessScreen />
  </Section>
);

const Stack = createNativeStackNavigator();
function App(): React.JSX.Element {
  const isDarkMode = useColorScheme() === 'dark';
  const [publishableKey, setPublishableKey] = React.useState<string | null>(
    null
  );

  // Memoize the backgroundStyle
  const backgroundStyle = React.useMemo(
    () => ({
      backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
    }),
    [isDarkMode]
  );

  React.useEffect(() => {
    const getKey = async () => {
      const key = await getPublishableKey();
      setPublishableKey(key);
    };

    // Fetch publishable key if not already set
    if (!publishableKey) {
      getKey();
    }
  }, [publishableKey]);

  return (
    <HyperProvider publishableKey={publishableKey}>
      <StatusBar
        barStyle={isDarkMode ? 'light-content' : 'dark-content'}
        backgroundColor={backgroundStyle.backgroundColor}
      />
      <NavigationContainer>
        <Stack.Navigator
          initialRouteName="Payment"
          screenOptions={{
            headerShown: false,
          }}
        >
          <Stack.Screen name="Payment" component={HomeScreen} />
          <Stack.Screen name="Headless" component={Headless} />
        </Stack.Navigator>
      </NavigationContainer>
    </HyperProvider>
  );
}

export default App;
