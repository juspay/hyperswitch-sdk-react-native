import * as React from 'react';
import { Button, Text, View } from 'react-native';
import type { NativeStackScreenProps } from '@react-navigation/native-stack';

type HomeScreenProps = NativeStackScreenProps<RootStackParamList, 'Home'>;
export type RootStackParamList = {
  Home: undefined;
  PaymentSheet: undefined;
  Headless: undefined;
};

const HomeScreen: React.FC<HomeScreenProps> = ({ navigation }) => {
  return (
    <View style={{ margin: 20 }}>
      <Button
        title="payment sheet"
        onPress={() => {
          navigation.navigate('PaymentSheet');
        }}
      />
      <View style={{ marginTop: 15 }} />
      <Button
        title="HyperSwitch Headless SDK"
        onPress={() => {
          navigation.navigate('Headless');
        }}
      />
    </View>
  );
};

export default HomeScreen;
