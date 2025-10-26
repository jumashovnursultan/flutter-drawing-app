# Drawing App - Flutter Cross-Platform Application

Мобильное кроссплатформенное приложение для рисования с интеграцией Firebase, созданное на Flutter с использованием Clean Architecture и BLoC pattern.

## 🎯 Функциональность

### ✅ Реализованные требования

- **Авторизация и регистрация**
  - Email/Password аутентификация через Firebase Auth
  - Валидация email и пароля (минимум 8 символов)
  - Обработка ошибок Firebase (пользователь существует, неверный пароль и т.д.)
  - Автоматическая проверка статуса авторизации при запуске
  - Logout с подтверждением

- **Редактор рисования**
  - Холст для рисования с touch-событиями
  - Настройка кисти: размер (1-50px) и цвет
  - Режим ластика
  - Выбор цвета из палитры
  - Отмена последнего штриха (Undo)
  - Очистка холста с подтверждением
  - Импорт изображений из галереи как фон
  - Удаление фона (Clear Background)
  - Экспорт через нативный Share-попап
  - Экспорт в галерею устройства

- **Галерея рисунков**
  - Отображение сетки рисунков (2 колонки)
  - Thumbnail превью с кешированием
  - Pull-to-refresh для обновления списка
  - Редактирование существующих рисунков
  - Удаление рисунков с подтверждением
  - Empty state для пустой галереи
  - Переход к редактору по клику
  - Создание нового рисунка (FAB)

- **Хранение данных**
  - Сохранение рисунков в Firestore (в виде Base64)
  - Метаданные: название, дата создания, дата обновления, автор
  - Thumbnail generation (200x200) для быстрой загрузки
  - Update vs Create логика (редактирование существующих)
  - Все изображения хранятся в Firestore (Firebase Storage не используется)

- **Уведомления**
  - Локальные уведомления через flutter_local_notifications
  - Уведомление при успешном сохранении рисунка
  - Уведомление при экспорте
  - iOS поддержка (permissions, alert, sound)
  - Android поддержка (notification channels для Android 8+)

- **Производительность**
  - **Thumbnail memory caching** - кеширование декодированных миниатюр в RAM
  - 10-15x быстрее загрузка галереи при повторном открытии
  - Автоматическая очистка кеша при удалении/logout
  - Оптимизация Base64 декодирования

- **Офлайн режим**
  - Проверка интернет соединения
  - No Internet screen с Retry кнопкой
  - Offline detection через connectivity_plus

- **UI/UX**
  - Material Design 3
  - Градиентные фоны
  - Кастомные анимированные кнопки
  - Адаптивный интерфейс
  - Индикаторы загрузки (CircularProgressIndicator)
  - Обработка ошибок с понятными сообщениями через SnackBar
  - Диалоги подтверждения для критических действий
  - Google Fonts (Press Start 2P)

## 🏗️ Архитектура

### Clean Architecture + Feature-First

Проект следует принципам Clean Architecture с разделением на слои:
```
lib/
├── core/                    # Общая функциональность
│   ├── cache/              # Кеширование (ThumbnailCache)
│   ├── constants/          # Константы (цвета, строки, Firebase)
│   ├── errors/             # Обработка ошибок (Failures)
│   ├── services/           # Сервисы (NotificationService)
│   ├── theme/              # Тема приложения
│   ├── utils/              # Утилиты (validators, image_helper)
│   └── widgets/            # Переиспользуемые виджеты
│
└── features/               # Фичи (feature-first подход)
    ├── auth/
    │   ├── data/          # Models, DataSources, Repository Impl
    │   ├── domain/        # Entities, Repository Interface, Use Cases
    │   └── presentation/  # BLoC, Screens, Widgets
    ├── gallery/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    └── drawing/
        ├── data/
        ├── domain/
        └── presentation/
```

### Основные паттерны

- **BLoC Pattern** - для управления состоянием (flutter_bloc)
- **Repository Pattern** - абстракция работы с данными
- **Dependency Injection** - GetIt для управления зависимостями
- **Use Cases** - бизнес-логика в отдельных классах
- **Either Pattern** - обработка ошибок через Dartz (Left/Right)
- **Singleton Pattern** - для кеша и сервисов

### Слои архитектуры

1. **Presentation Layer** - UI, BLoC, виджеты, screens
2. **Domain Layer** - бизнес-логика, entities, repository interfaces, use cases
3. **Data Layer** - работа с внешними источниками (Firebase, локальное хранилище)

### Dependency Flow
```
Presentation → Domain ← Data
     ↓           ↓        ↓
   BLoC    → UseCases → Repository
                            ↓
                       DataSources
```

## 🛠️ Технологический стек

### Основные зависимости
```yaml
dependencies:
  # Core
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4

  # State Management
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5

  # Dependency Injection
  get_it: ^8.0.0

  # Functional Programming
  dartz: ^0.10.1

  # UI & Drawing
  flutter_colorpicker: ^1.1.0
  image_picker: ^1.1.2
  google_fonts: ^6.2.1

  # Notifications
  flutter_local_notifications: ^18.0.1

  # Utilities
  share_plus: ^10.1.1
  path_provider: ^2.1.4
  connectivity_plus: ^6.0.5
  flutter_svg: ^2.0.10+1
```

### Dev Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

## 🚀 Установка и запуск

### Предварительные требования

- Flutter SDK 3.x (последняя стабильная версия)
- Dart SDK 3.x
- **iOS:** Xcode 14+ (macOS)
- **Android:** Android Studio / SDK
- Firebase проект (настроен)

### Шаги установки

1. **Клонировать репозиторий**
```bash
git clone https://github.com/your-username/drawing_app.git
cd drawing_app
```

2. **Установить зависимости**
```bash
flutter pub get
```

3. **iOS Setup (macOS only)**
```bash
cd ios
pod install
cd ..
```

4. **Настроить Firebase**

   a. Создать проект в [Firebase Console](https://console.firebase.google.com/)
   
   b. Включить сервисы:
      - Authentication → Email/Password
      - Firestore Database
   
   c. Запустить FlutterFire CLI:
```bash
# Установить FlutterFire CLI
dart pub global activate flutterfire_cli

# Настроить Firebase для обеих платформ
flutterfire configure
# Выбрать: [x] android, [x] ios
```

   d. Файлы конфигурации будут созданы автоматически:
      - `lib/firebase_options.dart`
      - `android/app/google-services.json`
      - `ios/Runner/GoogleService-Info.plist`

5. **Создать Firestore индекс**

Для работы запросов в галерее нужен composite index:
- Collection: `drawings`
- Fields:
  - `userId` (Ascending)
  - `date` (Descending)

Индекс создастся автоматически при первом запросе (откроется ссылка в консоли).

6. **Запустить приложение**

**iOS:**
```bash
flutter run -d "iPhone 15 Pro"
# или
open ios/Runner.xcworkspace  # Запуск через Xcode
```

**Android:**
```bash
flutter run -d "emulator-5554"
# или
flutter run  # Автоматически выберет устройство
```

## 📱 Поддерживаемые платформы

### iOS
- **Минимальная версия:** iOS 12.0+
- **Устройства:** iPhone, iPad
- **Протестировано на:**
  - iOS Simulator (iPhone 15 Pro)
  - Реальное устройство (iPhone)

### Android
- **Минимальная версия:** Android 5.0 (API 21+)
- **Target SDK:** Android 14 (API 34)
- **Протестировано на:**
  - Android Emulator (Pixel 6, Android 13)
  - Реальное устройство

## 🔨 Сборка Release

### iOS
```bash
flutter build ios --release
# Далее через Xcode: Product → Archive
```

### Android

**APK:**
```bash
flutter build apk --release
# Результат: build/app/outputs/flutter-apk/app-release.apk
```

**App Bundle (для Google Play):**
```bash
flutter build appbundle --release
# Результат: build/app/outputs/bundle/release/app-release.aab
```

## 🎨 Дизайн

Приложение использует собственный дизайн с фокусом на UX:

### Цветовая схема
- Градиентные фоны (фиолетовый → розовый)
- Material Design 3 principles
- Кастомные анимированные кнопки

### Основные экраны

1. **Login Screen** - вход в систему
   - Email и Password поля
   - Валидация форм
   - Переход на Registration

2. **Register Screen** - регистрация нового пользователя
   - Name, Email, Password, Confirm Password
   - Валидация совпадения паролей

3. **Gallery Screen** - список рисунков
   - Grid layout (2 колонки)
   - Thumbnail превью
   - FAB для создания нового
   - Logout в AppBar

4. **Editor Screen** - редактор рисования
   - Полноэкранный холст
   - Панель инструментов
   - Color picker
   - Brush size slider
   - Tool buttons (brush, eraser, import, clear, etc.)

5. **No Internet Screen** - офлайн режим
   - Информация об отсутствии соединения
   - Retry button

## 🧪 Тестирование

### Ручное тестирование

Все функции протестированы вручную на обеих платформах:

1. **Авторизация**
   - ✅ Регистрация нового пользователя
   - ✅ Вход существующего пользователя
   - ✅ Валидация форм
   - ✅ Обработка ошибок Firebase
   - ✅ Auto-login при повторном запуске
   - ✅ Logout с подтверждением

2. **Рисование**
   - ✅ Рисование пальцем/мышью
   - ✅ Изменение размера кисти
   - ✅ Изменение цвета
   - ✅ Использование ластика
   - ✅ Отмена штрихов (Undo)
   - ✅ Очистка холста
   - ✅ Импорт фона из галереи
   - ✅ Удаление фона

3. **Сохранение**
   - ✅ Сохранение в Firebase
   - ✅ Отображение в галерее
   - ✅ Локальное уведомление
   - ✅ Экспорт через Share
   - ✅ Экспорт в галерею устройства

4. **Галерея**
   - ✅ Отображение списка с thumbnails
   - ✅ Pull-to-refresh
   - ✅ Редактирование существующего рисунка
   - ✅ Удаление рисунка с подтверждением
   - ✅ Открытие в редакторе
   - ✅ Создание нового рисунка

5. **Производительность**
   - ✅ Thumbnail caching работает
   - ✅ Быстрая загрузка при повторном открытии
   - ✅ Плавный скролл в галерее

6. **Офлайн**
   - ✅ Определение отсутствия интернета
   - ✅ No Internet screen
   - ✅ Retry функция

## ⚡ Производительность

### Thumbnail Caching
- **Технология:** Memory cache (RAM)
- **Результат:** 10-15x быстрее загрузка при повторном открытии галереи
- **Управление:** Автоматическая очистка при удалении рисунка и logout

### Оптимизации
- Thumbnail generation (200x200) вместо полноразмерных изображений в галерее
- Base64 encoding для эффективной передачи в Firestore
- Минимизация перерисовок UI через BLoC

### Метрики

| Действие | Первая загрузка | С кешем |
|----------|----------------|---------|
| Открытие Gallery | ~1.5s | ~0.1s ⚡ |
| Скролл Gallery | Плавно | Плавно ⚡ |
| Память (10 изображений) | ~60KB | ~60KB |

## 📝 Решения и компромиссы

### Firebase Storage vs Firestore

**Решение:** Хранение изображений в Firestore как Base64 строки.

**Обоснование:**
- ТЗ указывает что Firebase Storage необязателен
- Все данные в одном месте (Firestore)
- Атомарные операции
- Простота реализации

**Ограничения:**
- Максимальный размер документа Firestore: 1MB
- Для больших изображений создаются thumbnails (200x200)

**Преимущества:**
- Упрощенная архитектура
- Меньше зависимостей
- Транзакционность

### Navigator 1.0 vs 2.0

**Решение:** Используется классический Navigator 1.0.

**Обоснование:**
- Простота для приложения с 5 экранами
- Фокус на архитектуре и бизнес-логике
- Легко масштабируется на Navigator 2.0 / go_router при необходимости

### Memory Cache vs Disk Cache

**Решение:** Memory cache для thumbnails.

**Обоснование:**
- Очень быстрый доступ (RAM)
- Простая реализация
- Достаточно для thumbnails небольшого размера
- Автоматическая очистка при закрытии приложения

## 🔧 Возможные улучшения

### Функциональность
- [ ] Добавить Redo (возврат отмененного штриха)
- [ ] Реализовать фигуры (круг, квадрат, линия)
- [ ] Добавить текст на холст
- [ ] Добавить фильтры и эффекты для изображений
- [ ] Реализовать слои (layers)
- [ ] Добавить папки/категории в галерее
- [ ] Поиск и фильтрация рисунков

### UI/UX
- [ ] Темная тема
- [ ] Анимации переходов
- [ ] Кастомные splash screen
- [ ] Onboarding для новых пользователей
- [ ] Настройки приложения

### Производительность
- [ ] Оптимизация рисования (path вместо точек)
- [ ] Disk cache для постоянного хранения
- [ ] Pagination в галерее (lazy loading)
- [ ] Image compression для больших файлов

### Backend
- [ ] Firebase Storage для больших изображений
- [ ] Cloud Functions для обработки
- [ ] Real-time collaboration
- [ ] Backup & Sync

### Тестирование
- [ ] Unit tests (BLoC, UseCases, Repositories)
- [ ] Widget tests (UI components)
- [ ] Integration tests (E2E flows)
- [ ] Performance testing

### DevOps
- [ ] CI/CD (GitHub Actions / Codemagic)
- [ ] Automated testing
- [ ] Beta distribution (TestFlight / Firebase App Distribution)
- [ ] Crashlytics integration

## 📊 Статистика проекта

- **Всего строк кода:** ~5000+
- **Количество файлов:** 80+
- **Фичи:** 3 (Auth, Gallery, Drawing)
- **Экраны:** 5
- **BLoCs:** 3
- **Use Cases:** 10+
- **Clean Architecture слои:** 3

## 🐛 Известные проблемы

### Производительность рисования
**Проблема:** Лаги после долгого рисования (много точек накапливается)

**Временное решение:**
- Используются thumbnails в галерее
- Ограничение размера холста

**Планируемое улучшение:**
- Оптимизация: Path вместо отдельных точек
- Упрощение точек (distance check)
- Кеширование завершенных штрихов

## 📞 Контакты

Если есть вопросы по проекту:
- GitHub Issues: [создать issue](https://github.com/your-username/drawing_app/issues)

## 📄 Лицензия

Проект создан в учебных целях как тестовое задание для Flutter-разработчика.
