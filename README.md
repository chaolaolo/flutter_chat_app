# Flutter Chat App

Flutter Chat App là một ứng dụng chat thời gian thực được phát triển bằng Flutter và Firebase. Ứng dụng hỗ trợ đăng ký, đăng nhập, gửi tin nhắn văn bản và quản lý danh sách bạn bè.

## 🛠 Công nghệ sử dụng
- **Flutter**: Framework phát triển ứng dụng di động đa nền tảng.
- **Firebase Authentication**: Quản lý xác thực người dùng.
- **Cloud Firestore**: Lưu trữ và quản lý tin nhắn.
- **Firebase Storage**: Lưu trữ ảnh đại diện và hình ảnh gửi trong tin nhắn.
- **Provider**: Quản lý trạng thái ứng dụng.

## 🚀 Tính năng chính
- Đăng ký và đăng nhập bằng email/password.
- Gửi và nhận tin nhắn theo thời gian thực.
- Hiển thị danh sách người dùng có trong hệ thống.
- Quản lý danh sách bạn bè(block, report..).
- Tải lên và hiển thị ảnh đại diện.
- Gửi tin nhắn kèm hình ảnh.

## 📂 Cấu trúc thư mục
```
flutter_chat_app/
│-- lib/
│   │-- main.dart
│   │-- screens/
│   │   │-- login_screen.dart
│   │   │-- register_screen.dart
│   │   │-- chat_screen.dart
│   │   │-- profile_screen.dart
│   │-- services/
│   │   │-- auth_service.dart
│   │   │-- database_service.dart
│   │-- widgets/
│       │-- message_bubble.dart
│       │-- user_tile.dart
│-- pubspec.yaml
```

## 📌 Cách cài đặt và chạy ứng dụng
### 1. Clone repository
```sh
git clone https://github.com/chaolaolo/flutter_chat_app.git
cd flutter_chat_app
```

### 2. Cấu hình Firebase
1. Truy cập [Firebase Console](https://console.firebase.google.com/).
2. Tạo một project mới và thêm Firebase vào ứng dụng Flutter.
3. Kích hoạt **Authentication** với Email/Password.
4. Tạo Firestore Database và thiết lập quy tắc bảo mật phù hợp.
5. Cấu hình Firebase Storage để lưu ảnh đại diện.
6. Tải xuống file `google-services.json` và đặt vào thư mục `android/app/`.

### 3. Cài đặt dependencies
```sh
flutter pub get
```

### 4. Chạy ứng dụng
```sh
flutter run
```


## 🤝 Đóng góp
Nếu bạn muốn đóng góp vào dự án, hãy fork repository, tạo nhánh mới và gửi pull request.

### 📩 Liên hệ  

Họ và Tên: Chảo Láo Lở

Email: chaolaolo290604@gmail.com

Zalo: 0396471382

---
Cảm ơn bạn đã sử dụng **Flutter Chat App**! 🚀

