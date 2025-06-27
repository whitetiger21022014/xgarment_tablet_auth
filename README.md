# XGarment Tablet Auth

- Đăng nhập bằng QR code + PIN cho thiết bị dùng chung
- Cấu hình API bằng mã truy cập: 11118888 (bấm biểu tượng bánh răng)
- Hỗ trợ đổi logo theo công ty (companyBrief)
- Build APK: `flutter build apk --debug` hoặc dùng workflow GitHub Actions 

## Thư mục cần có:
- /lib/
- /assets/config.json
- /assets/companyDefault_logo.png
- /.github/workflows/build-apk.yml (nếu cần auto build)

## Các bước build
1. flutter pub get
2. flutter build apk --debug
3. sẽ test thử, test
