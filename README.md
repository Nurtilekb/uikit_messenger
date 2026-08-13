# UIKit Messenger

**UIKit Messenger** — это кроссплатформенное Flutter-приложение для обмена сообщениями, с поддержкой авторизации через Email/Password и Google Sign-In, а также сохранением данных пользователей в Firebase.

---

## 🚀 Возможности

- Авторизация и регистрация через Email/Password
- Вход через Google Sign-In
- Сохранение профиля пользователя в Firebase Firestore
- Реактивное управление состоянием через `flutter_bloc`
- Маршрутизация через `auto_route`
- Локализация интерфейса с `easy_localization`
- Тёмная и светлая тема

---

## 🧱 Стек технологий

- Flutter
- Firebase Auth
- Cloud Firestore
- google_sign_in
- flutter_bloc
- auto_route
- easy_localization
- shared_preferences

---

## ⚙️ Установка

1. Клонируйте репозиторий:

```bash
git clone https://github.com/your-username/uikit.git
cd uikit
```

2. Установите зависимости:

```bash
flutter pub get
```

3. Настройте Firebase:

- Добавьте `google-services.json` в `android/app/`
- Если требуется, добавьте iOS-конфигурацию
- Включите в Firebase Authentication провайдеры Email/Password и Google

4. Запустите приложение:

```bash
flutter run
```

---

## 🔐 Настройка Google Sign-In

Для Android с `google_sign_in` версии `7.x` необходим `serverClientId`.

1. Откройте Google Cloud Console: `https://console.cloud.google.com/apis/credentials?project=YOUR_PROJECT_ID`
2. Настройте `OAuth consent screen`, если потребуется
3. Создайте `OAuth client ID` типа `Web application`
4. Скопируйте `Client ID`
5. Передайте его в `AuthRepository`:

```dart
final authRepository = AuthRepository(
  googleServerClientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
);
```

---

## 🧭 Структура проекта

- `lib/main.dart` — точка входа, настройка провайдеров и роутера
- `lib/blocs/` — бизнес-логика авторизации и состояния
- `lib/repositories/` — работа с Firebase Auth, Firestore и Google Sign-In
- `lib/screens/` — пользовательские экраны
- `lib/models/` — модели данных
- `lib/router/` — маршрутизация через `auto_route`
- `lib/theme/` — тема приложения
- `lib/widgets/` — общие виджеты

---

## 🧪 Полезные команды

```bash
flutter pub get
flutter analyze
flutter run
flutter clean
```

---

## 💡 Примечания

- После изменения настроек Firebase обязательно делайте полный рестарт приложения
- Если Google Sign-In не открывает окно выбора аккаунта, проверьте `serverClientId` и `google-services.json`
- Логи можно смотреть в терминале или Android Studio

---
<img width="2108" height="2945" alt="github_app_showcase" src="https://github.com/user-attachments/assets/3be7e694-6a83-4d20-8ac8-8095a086c6ab" />

 

Этот проект можно свободно использовать и модифицировать.
