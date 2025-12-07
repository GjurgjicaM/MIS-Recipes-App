# 🍽️ Flutter Recipe App

A Flutter mobile app that lets users browse, search, and view recipes using [TheMealDB API](https://www.themealdb.com/api.php). Users can explore meal categories, see meals in each category, view detailed recipes with ingredients and instructions, manage their favorite meals, and even get a random meal of the day.

---

## ✨ Features

- ✅ Browse meal categories with images and descriptions
- ✅ Search meals within categories
- ✅ View detailed recipe information including:
    - Ingredients
    - Cooking instructions
    - YouTube video links
- ✅ Random meal of the day feature
- ⭐ Favorites list with heart toggle
- 🔥 Firebase Cloud Firestore integration for storing favorites
- 🔔 In-app notifications when meals are added or removed from favorites

---

## ❤️ Favorites System

Users can mark meals as favorites by tapping the **heart icon** on any meal card.

- Favorited meals are:
    - Stored securely in **Firebase Cloud Firestore**
    - Displayed in the dedicated **Favorites Screen**
    - Shown with a **filled red heart icon**
- Removing a favorite instantly updates:
    - Firebase
    - UI state
    - Favorites screen

---

## 🔥 Firebase Integration

This app uses **Firebase Cloud Firestore** to store and manage favorite meals.

### Firebase is used for:
- ✅ Persisting favorite meals across app sessions
- ✅ Real-time updates to the favorites list
- ✅ Secure cloud storage

---

## 🔔 Notifications

The app provides **instant feedback notifications** when:
- A meal is added to favorites
- A meal is removed from favorites

This improves user experience and confirms actions immediately.

---

## 🛠️ Tech Stack (Optional Section)

- Flutter
- Dart
- Firebase Cloud Firestore
- TheMealDB API

---

## 🚀 Future Improvements

- User authentication with Firebase
- Favorite categories
- Offline mode
- Push notifications
