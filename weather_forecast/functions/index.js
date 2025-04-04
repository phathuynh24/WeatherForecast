/* eslint-disable max-len */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const sgMail = require("@sendgrid/mail");
const axios = require("axios");

admin.initializeApp();
sgMail.setApiKey(functions.config().sendgrid.key);

// This function is called when the user requests a subscription
exports.requestSubscription = functions
    .region("us-central1")
    .runWith({
      timeoutSeconds: 60,
      memory: "256MB",
    })
    .https.onCall(async (data, context) => {
      const email = data.email;

      if (!email) {
        throw new functions.https.HttpsError(
            "invalid-argument",
            "Email is required.");
      }

      // Find the user by email
      const userSnapshot = await admin.firestore()
          .collection("Users")
          .where("email", "==", email)
          .limit(1)
          .get();

      if (userSnapshot.empty) {
        throw new functions.https.HttpsError("not-found", "User not found.");
      }

      const userRef = userSnapshot.docs[0].ref;

      const confirmationToken = Math.random().toString(36).substring(2);
      const unsubscribeToken = Math.random().toString(36).substring(2);

      await userRef.update({
        confirmationToken,
        unsubscribeToken,
        isEmailVerified: false,
        isSubscribedToWeatherForecast: false,
      });

      const confirmUrl = `https://weather-forecast-20c68.web.app/confirm?token=${confirmationToken}`;

      const msg = {
        to: email,
        from: "2409huynhphat@gmail.com", // your verified sender
        subject: "Confirm your weather subscription",
        html: `
        <p>Hello,</p>
        <p>Please click the link below to confirm your weather subscription:</p>
        <p><a href="${confirmUrl}">${confirmUrl}</a></p>
        <p>If you did not request this, please ignore this email.</p>
        <p>Thank you!</p>
        `,
      };

      await sgMail.send(msg);

      return {message: "Confirmation email sent."};
    },
    );


// This function is called when the user confirms their subscription
exports.confirmSubscription = functions
    .region("us-central1")
    .https.onCall(async (data, context) => {
      const token = data.token;
      if (!token) {
        throw new functions.https.HttpsError(
            "invalid-argument",
            "Missing token");
      }

      const snapshot = await admin.firestore()
          .collection("Users")
          .where("confirmationToken", "==", token)
          .limit(1)
          .get();

      if (snapshot.empty) {
        throw new functions.https.HttpsError(
            "not-found",
            "Invalid or expired token");
      }

      const userRef = snapshot.docs[0].ref;

      await userRef.update({
        isEmailVerified: true,
        isSubscribedToWeatherForecast: true,
        subscriptionDate: admin.firestore.FieldValue.serverTimestamp(),
        confirmationToken: admin.firestore.FieldValue.delete(), // Remove token
      });

      return {message: "Email confirmed successfully."};
    });

// This function sends a weather forecast email to the user
exports.unsubscribeFromWeatherForecast = functions
    .region("us-central1")
    .https.onCall(async (data, context) => {
      const token = data.token;
      if (!token) {
        throw new functions.https.HttpsError(
            "invalid-argument",
            "Missing token");
      }

      const snapshot = await admin.firestore()
          .collection("Users")
          .where("unsubscribeToken", "==", token)
          .limit(1)
          .get();

      if (snapshot.empty) {
        throw new functions.https.HttpsError(
            "not-found",
            "Invalid unsubscribe token");
      }

      const userRef = snapshot.docs[0].ref;

      await userRef.update({
        isSubscribedToWeatherForecast: false,
        lastWeatherNotificationSent: null,
        unsubscribeToken: admin.firestore.FieldValue.delete(),
      });

      return {message: "Unsubscribed successfully."};
    });

// This function sends daily weather forecast emails to subscribed users
exports.sendDailyWeatherEmails = functions
    .region("us-central1")
    .pubsub.schedule("0 6 * * *")
    .timeZone("Asia/Ho_Chi_Minh")
    .onRun(async (context) => {
      const usersSnapshot = await admin.firestore()
          .collection("Users")
          .where("isSubscribedToWeatherForecast", "==", true)
          .where("isEmailVerified", "==", true)
          .get();

      const users = usersSnapshot.docs;
      const weatherApiKey = functions.config().weatherapi.key;

      for (const doc of users) {
        const data = doc.data();
        const email = data.email;
        const unsubscribeToken = data.unsubscribeToken;
        const unsubscribeUrl = `https://weather-forecast-20c68.web.app/unsubscribe?token=${unsubscribeToken}`;

        const weather = await axios.get("https://api.weatherapi.com/v1/forecast.json", {
          params: {
            key: weatherApiKey,
            q: "Ho Chi Minh",
            days: 1,
          },
        });

        const cityName = weather.data.location.name;
        const temperature = weather.data.current.temp_c;
        const windSpeed = weather.data.current.wind_kph * 0.277778;
        const humidity = weather.data.current.humidity;
        const weatherDescription = weather.data.current.condition.text;

        await sgMail.send({
          to: email,
          from: "2409huynhphat@gmail.com",
          subject: "Today's Weather Forecast",
          html: `
            <p><strong>${cityName} (${new Date().toLocaleDateString()})</strong></p>
            <p><strong>Condition:</strong> ${weatherDescription}</p>
            <p><strong>Temperature:</strong> ${temperature}°C</p>
            <p><strong>Wind Speed:</strong> ${windSpeed.toFixed(2)} M/S</p>
            <p><strong>Humidity:</strong> ${humidity}%</p>
            <p><a href="${unsubscribeUrl}" style="color: blue; text-decoration: underline;">Unsubscribe from daily weather notifications</a></p>
            <p>Stay safe and have a great day!</p>
          `,
        });

        await doc.ref.update({
          lastWeatherNotificationSent: admin.firestore.FieldValue.serverTimestamp(),
        });
      }

      console.log(`Sent weather forecast to ${users.length} users.`);
    });
