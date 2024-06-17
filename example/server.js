const express = require('express');
const app = express();
const { resolve } = require('path');

// Replace if using a different env file or config
const env = require('dotenv').config({ path: './.env' });
app.use(express.static(process.env.STATIC_DIR));
app.get('/', (req, res) => {
  const path = resolve(process.env.STATIC_DIR + '/index.html');
  res.sendFile(path);
});

// replace the test api key with your hyperswitch api key
const hyper = require('@juspay-tech/hyperswitch-node')(
  process.env.HYPERSWITCH_SECRET_KEY
);

app.get('/config', (req, res) => {
  res.send({
    publishableKey: process.env.HYPERSWITCH_PUBLISHABLE_KEY,
  });
});

app.post('/create-payment-intent', async (req, res) => {
  try {
    const paymentIntent = await hyper.paymentIntents.create({
      currency: 'USD',
      amount: 2999,
      confirm: false,
      capture_method: 'automatic',
      authentication_type: 'no_three_ds',
      customer_id: 'hyperswitch_sdk_demo_id',
      description: 'Joseph First Crypto',
      shipping: {
        address: {
          line1: '1467',
          line2: 'Harrison Street',
          line3: 'Harrison Street',
          city: 'San Fransico',
          state: 'California',
          zip: '94122',
          country: 'US',
          first_name: 'joseph',
          last_name: 'Doe',
        },
        phone: {
          number: '8056594427',
          country_code: '+91',
        },
      },
      billing: {
        address: {
          line1: '1467',
          line2: 'Harrison Street',
          line3: 'Harrison Street',
          city: 'San Fransico',
          state: 'California',
          zip: '94122',
          country: 'US',
          first_name: 'joseph',
          last_name: 'Doe',
        },
        phone: {
          number: '8056594427',
          country_code: '+91',
        },
      },
      metadata: {
        order_details: {
          product_name: 'Apple iphone 15',
          quantity: 1,
        },
      },
      business_country: 'US',
      business_label: 'default',
    });

    // Send publishable key and PaymentIntent details to client
    res.send({
      clientSecret: paymentIntent.client_secret,
      customerId: paymentIntent.ephemeral_key.customer_id,
      ephemeralKey: paymentIntent.ephemeral_key.secret,
    });
  } catch (err) {
    return res.status(400).send({
      error: {
        message: err.message,
      },
    });
  }
});

app.listen(4242, () =>
  console.log(`Node server listening at http://localhost:4242`)
);
