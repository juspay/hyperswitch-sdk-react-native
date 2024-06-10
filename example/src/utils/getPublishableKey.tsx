import { Platform } from 'react-native';

const getPublishableKey = async () => {
  // fetching publishable key from backend api
  const response = await fetch(
    Platform.OS == 'ios'
      ? 'http://localhost:4242/config'
      : 'http://10.0.2.2:4242/config'
  );
  const key = await response.json();
  return key?.publishableKey;
  // you can use environment variable
  // return process.env.HYPERSWITCH_PUBLISHABLE_KEY
};
export default getPublishableKey;
