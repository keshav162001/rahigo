# 🌍 Rahigo – Indian-Themed Travel App

**Rahigo** is a beautifully designed Flutter travel app inspired by the rich culture and heritage of India. It allows users to explore tourist places across various categories like Cities, Hills, Beaches, and more — all presented with an elegant glassmorphism UI and a royal Indian theme.

---

## ✨ Features

- 🔐 **Authentication**
  - Login and Signup with Firebase Authentication
  - Eye-toggle password field with validations
  - Forgot/change password functionality with Firebase

- 🏙️ **Category-Based Exploration**
  - Dynamic categories: 🏙️ Cities, 🏞️ Hills, 🏖️ Beaches, etc.
  - Category buttons open a single reusable detail page
  - Places loaded dynamically via API or Firebase integration

- ❤️ **Wishlist (Saved Places)**
  - Tap ❤️ to save places
  - View saved places from the Drawer
  - Data synced with Firebase Firestore

- 🔄 **Admin Panel Integration**
  - Web-based panel for managing places
  - Add/Edit/Delete functionality
  - Form with fields like image URL, name, state, and description

- 🖼️ **UI/UX**
  - Glassmorphism style with animated India-themed Lottie backgrounds
  - Welcome screen with fixed category bar and scrollable content
  - Smooth transitions and split-screen Drawer animation

- 🔧 **Architecture**
  - Modular folder structure (MVC)
  - Reusable widgets in `lib/widgets`
  - Fully theme-controlled using `rahiTheme`

---

## 🔧 Tech Stack

- **Flutter 3+** / **Dart 3+**
- **Firebase Auth & Firestore**
- **Lottie for Animations**
- **Provider / GetX (if used) for State Management**
- **Flutter Web Admin Panel** (HTML or Flutter Web)

---

## 📁 Folder Structure (Simplified)

