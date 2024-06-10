import { Platform } from 'react-native';

const fetchPaymentParams = async () => {
  try {
    const response = await fetch(
      Platform.OS == 'ios'
        ? 'http://localhost:4242/create-payment-intent'
        : 'http://10.0.2.2:4242/create-payment-intent',
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
      }
    );
    const key = await response.json();
    return key;
  } catch (err) {
    console.log(err);
  }
};
export default fetchPaymentParams;
