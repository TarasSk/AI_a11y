# 📱 AI Screen Narrator (ai_a11y)

An AI-powered mobile assistant that understands any app interface and provides real-time audio descriptions of on-screen elements — without relying on built-in accessibility APIs.

---

## 🚀 Overview

AI Screen Narrator is designed to make mobile applications more accessible by analyzing the visual UI directly from the screen and converting it into meaningful, spoken feedback.

Instead of depending on developer-provided accessibility semantics (which are often missing or incomplete), the app uses computer vision and on-device AI to interpret the interface like a human would.

---

## 🧠 How It Works

The system combines lightweight on-device ML with LLM reasoning:

### 1. Computer Vision (TFLite / YOLO)
- Detects UI elements such as buttons, inputs, and menus
- Trained on the [Roboflow UI Element Detect dataset](https://universe.roboflow.com/yolo-ui/ui-element-detect-yt5su-xf6rx/dataset/1)
- Uses a lightweight `YOLO11n` model to keep inference efficient on-device

### 2. LLM (Gemma)
- Interprets detected elements
- Understands context and user intent
- Converts raw UI structure into natural language

### 3. Voice Output
- Generates clear spoken descriptions using system TTS

---

## ⚙️ Architecture (MVP)

- Flutter app (cross-platform UI)
- Native screen capture (Android / iOS)
- On-device ML (TFLite)
- On-device LLM (Gemma)
- System Text-to-Speech

---

## ⚠️ Proof of Concept Limitation

Due to hackathon time constraints, the current implementation uses a **manual screenshot trigger**:

- The user taps a button to capture the current screen
- The captured frame is then processed by the AI pipeline

This approach allows us to validate the core idea quickly without implementing a continuous real-time capture system.

---

## 🔮 Future Improvements

- Real-time screen analysis (continuous capture)
- Gesture-based navigation
- Spatial audio (left/right/top/bottom awareness)
- Action execution (tap, scroll via AI)
- Improved UI understanding with multimodal models

---

## 💡 Why It Matters

Most apps are not fully accessible because they lack proper semantic annotations.

This project removes that dependency by:
- understanding UI visually
- interpreting intent with AI
- delivering accessibility as a universal layer

---
