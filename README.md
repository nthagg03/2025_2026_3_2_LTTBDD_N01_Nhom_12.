<div align="center">

# 📸 SnapVerse

*A Flutter-based social photo sharing application inspired by Locket Widget.*

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS%20|%20Web-success)
![Status](https://img.shields.io/badge/Status-In%20Development-orange)

</div>

---

# 📖 About The Project

**SnapVerse** là ứng dụng chia sẻ ảnh được phát triển bằng **Flutter**, lấy cảm hứng từ ứng dụng **Locket Widget**.

Mục tiêu của dự án là xây dựng một ứng dụng mạng xã hội nhỏ cho phép người dùng lưu giữ và chia sẻ những khoảnh khắc hằng ngày với bạn bè thông qua giao diện tối giản, hiện đại và dễ sử dụng.

Dự án được thực hiện trong khuôn khổ học phần **Lập trình Thiết bị Di động** tại **Đại học Phenikaa**.

---


# 👨‍💻 Development Team

| STT | Họ tên           | Mã sinh viên | GitHub                                            | Vai trò        |
|-----|------------------|--------------|---------------------------------------------------|----------------|
| 1   | Nguyễn Xuân Thắng| 24100529     | [nthagg03](https://github.com/nthagg03)           | Team Leader    |
| 2   | Đàm Thế Tân      | 24100270     | [TanDam06](https://github.com/TanDam06)           | Developer      |
| 3   | Trần Phương Nam  | 24100511     | [Trannam2k6](https://github.com/Trannam2k6)       | Developer      |

---

# 📑 Table of Contents

- [📖 About The Project](#-about-the-project)
- [🎯 Objectives](#-objectives)
- [✨ Features](#-features)
- [🖼 Screenshots](#-screenshots)
- [🏗 Architecture](#-architecture)
- [📂 Project Structure](#-project-structure)
- [🛠 Technologies](#-technologies)
- [📱 Application Flow](#-application-flow)
- [🗄 Data Layer](#-data-layer)
- [🚀 Getting Started](#-getting-started)
- [📊 Current Progress](#-current-progress)
- [📌 Known Limitations](#-known-limitations)
- [🛣 Roadmap](#-roadmap)
- [📚 Course Information](#-course-information)
- [📄 License](#-license)
---


---

# 🎯 Objectives

- Xây dựng ứng dụng Flutter đa nền tảng.
- Thiết kế giao diện hiện đại theo phong cách Locket.
- Áp dụng kiến trúc Feature-first Architecture.
- Tách biệt UI, Business Logic và Data Layer.
- Xây dựng mã nguồn dễ mở rộng và bảo trì.
- Mô phỏng quy trình phát triển ứng dụng thực tế.

---

# ✨ Features

## Authentication

- Welcome Screen
- Login
- Register
- Email Verification
- Password Login
- Create Password
- Forgot Password
- Fake Authentication

---

## Camera

- Camera Preview
- Capture Photo
- Flash Control
- Switch Camera
- Photo Preview
- Caption
- Select Recipients
- Fake Upload

---

## Feed

- Home Feed
- Stories
- Photo Cards
- Caption
- Reactions
- Full Screen Photo

---

## History

- Calendar View
- Photo Timeline
- History Grid
- History Detail

---

## Chat

- Conversation List
- Chat Detail
- Send Message
- Fake Conversation

---

## Profile

- User Information
- Personal Gallery
- Edit Profile (UI)
- Settings (UI)

---

## Notifications

- Local Notifications
- Notification List (Mock Data)

---

# 🏗 Architecture

Dự án được tổ chức theo **Feature-first Architecture** nhằm giúp mã nguồn dễ mở rộng và bảo trì.

```
lib
│
├── core
│   ├── constants
│   ├── errors
│   ├── services
│   ├── theme
│   ├── utils
│   └── widgets
│
├── features
│   ├── auth
│   ├── camera
│   ├── chat
│   ├── feed
│   ├── history
│   ├── notifications
│   ├── profile
│   └── splash
│
├── models
├── providers
├── repositories
├── routes
└── main.dart
```

---

# 📂 Project Structure

```
android/
ios/
linux/
macos/
web/
windows/

assets/

lib/

pubspec.yaml

README.md
```

---

# 🛠 Technologies

| Technology | Description |
|------------|-------------|
| Flutter | UI Framework |
| Dart | Programming Language |
| Provider | State Management |
| Camera | Camera Access |
| Flutter Local Notifications | Local Notifications |
| Shared Preferences | Local Storage |
| Material Design | User Interface |

---

# 📱 Application Flow

```
Splash

↓

Welcome

↓

Login / Register

↓

Authentication

↓

Home Feed

├── Camera

├── History

├── Chat

├── Profile

└── Notifications
```

---

# 🗄 Data Layer

Hiện tại dự án sử dụng **Fake Data** nhằm phục vụ quá trình phát triển và kiểm thử.

Các dữ liệu được mô phỏng bao gồm:

- User
- Post
- Story
- Notification
- Message
- History

Việc sử dụng dữ liệu giả giúp nhóm tập trung hoàn thiện giao diện và luồng chức năng trước khi tích hợp hệ thống backend.

---

# 🔮 Future Integration

Trong giai đoạn tiếp theo, dữ liệu giả sẽ được thay thế bằng:

- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Firebase Cloud Messaging

Nhờ kiến trúc Repository Pattern, việc chuyển đổi này sẽ không ảnh hưởng nhiều đến giao diện và luồng xử lý hiện tại.

---

# 🚀 Getting Started

## Clone Repository

```bash
git clone https://github.com/nthagg03/2025_2026_3_2_LTTBDD_N01_Nhom_12.git
```

---

## Install Dependencies

```bash
flutter pub get
```

---

## Run Application

Android

```bash
flutter run
```

Chrome

```bash
flutter run -d chrome
```

Windows

```bash
flutter run -d windows
```

---

# 📷 Screenshots

## Welcome

> *(Add screenshot here)*

---

## Login

> *(Add screenshot here)*

---

## Camera

> *(Add screenshot here)*

---

## Feed

> *(Add screenshot here)*

---

## History

> *(Add screenshot here)*

---

## Chat

> *(Add screenshot here)*

---

## Profile

> *(Add screenshot here)*

---

# 📊 Current Progress

| Module | Status |
|---------|--------|
| Splash | ✅ Completed |
| Authentication | ✅ Completed |
| Camera | ✅ Completed |
| Feed | ✅ Completed |
| History | ✅ Completed |
| Chat | 🟡 Basic Version |
| Profile | 🟡 Basic Version |
| Notifications | ✅ Mock Version |
| Firebase | ⏳ Planned |

---

# 📌 Known Limitations

- Chưa tích hợp Firebase.
- Dữ liệu chưa đồng bộ giữa các thiết bị.
- Chat đang sử dụng dữ liệu mô phỏng.
- Camera trên nền tảng Web phụ thuộc vào quyền truy cập trình duyệt và thiết bị.
- Widget cho Android/iOS chưa được triển khai.

---

# 🛣 Roadmap

- [x] Thiết kế giao diện
- [x] Authentication UI
- [x] Camera Module
- [x] Feed Module
- [x] History Module
- [x] Notification Mock
- [ ] Firebase Authentication
- [ ] Cloud Firestore
- [ ] Firebase Storage
- [ ] Realtime Chat
- [ ] Friend System
- [ ] Widget Support
- [ ] Push Notification

---

# 👨‍💻 Development Team

| Name | Responsibility |
|------|----------------|
| Nguyễn Xuân Thắng | Project Leader, UI/UX Design, Flutter Development, Authentication, Camera, Feed, History |

---

# 📚 Course Information

**Course:** Mobile Application Development

**Academic Year:** 2025–2026

**University:** Hanoi University of Industry

---

# 🤝 Acknowledgements

- Flutter Team
- Dart Team
- Material Design
- Locket Widget (UI Inspiration)

---

# 📄 License

This project was developed for educational purposes only as part of the Mobile Application Development course.

The source code is intended solely for learning and academic evaluation.

Commercial use of this project is not permitted without permission from the authors.
