import { Platform } from 'react-native';

const fetchPaymentParams = async () => {
  try {
    const response = await fetch(
      Platform.OS == 'ios'
        ? 'http://localhost:5252/create-payment-intent'
        : 'http://10.0.2.2:5252/create-payment-intent',
      {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      }
    );
    const key = await response.json();
    return key;
  } catch (err) {
  }
};
export default fetchPaymentParams;
