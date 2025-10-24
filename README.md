# Drawing App - Flutter Test Assignment

Мобильное iOS-приложение для рисования с интеграцией Firebase, созданное на Flutter с использованием Clean Architecture и BLoC pattern.

## 🎯 Функциональность

### ✅ Реализованные требования

- **Авторизация и регистрация**
  - Email/Password аутентификация через Firebase Auth
  - Валидация email и пароля (минимум 8 символов)
  - Обработка ошибок Firebase (пользователь существует, неверный пароль и т.д.)
  - Автоматическая проверка статуса авторизации при запуске

- **Редактор рисования**
  - Холст для рисования с touch-событиями
  - Настройка кисти: размер (1-50px) и цвет
  - Режим ластика
  - Отмена последнего штриха (Undo)
  - Очистка холста
  - Импорт изображений из галереи
  - Экспорт через нативный Share-попап

- **Галерея рисунков**
  - Отображение сетки рисунков (2 колонки)
  - Thumbnail превью
  - Pull-to-refresh для обновления списка
  - Удаление рисунков с подтверждением
  - Empty state для пустой галереи
  - Переход к редактору по клику

- **Хранение данных**
  - Сохранение рисунков в Firestore (в виде Base64)
  - Метаданные: название, дата, автор
  - Thumbnail для быстрой загрузки
  - Все изображения хранятся в Firestore (Firebase Storage не используется)

- **Уведомления**
  - Локальные уведомления через flutter_local_notifications
  - Уведомление при успешном сохранении рисунка
  - Уведомление при экспорте

- **UI/UX**
  - Material Design 3
  - Адаптивный интерфейс
  - Индикаторы загрузки (скелетоны/лоадеры)
  - Обработка ошибок с понятными сообщениями
  - Диалоги подтверждения для критических действий

## 🏗️ Архитектура

### Clean Architecture + Feature-First

Проект следует принципам Clean Architecture с разделением на слои:
```
lib/
├── core/                    # Общая функциональность
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

- **BLoC Pattern** - для управления состоянием
- **Repository Pattern** - абстракция работы с данными
- **Dependency Injection** - GetIt для управления зависимостями
- **Use Cases** - бизнес-логика в отдельных классах
- **Either Pattern** - обработка ошибок через Dartz

### Слои архитектуры

1. **Presentation Layer** - UI, BLoC, виджеты
2. **Domain Layer** - бизнес-логика, entities, use cases
3. **Data Layer** - работа с внешними источниками (Firebase, локальное хранилище)

## 🛠️ Технологический стек

### Основные зависимости
```yaml
dependencies:
  # Core
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: 3.6.0
  firebase_auth: 5.3.1
  cloud_firestore: 5.4.4

  # State Management
  flutter_bloc: 8.1.6
  equatable: 2.0.5

  # Dependency Injection
  get_it: 8.0.0

  # Functional Programming
  dartz: 0.10.1

  # UI & Drawing
  flutter_colorpicker: 1.1.0
  image_picker: 1.1.2

  # Notifications
  flutter_local_notifications: 18.0.1

  # Utilities
  share_plus: 10.1.1
  path_provider: 2.1.4
  connectivity_plus: 6.0.5
```

Все версии зафиксированы жестко (без символа `^`) согласно требованиям ТЗ.

## 🚀 Установка и запуск

### Предварительные требования

- Flutter SDK (последняя стабильная версия)
- Xcode (для iOS)
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
cd ios && pod install && cd ..
```

3. **Настроить Firebase**
   - Создать проект в Firebase Console
   - Включить Authentication (Email/Password)
   - Создать Firestore Database
   - Запустить FlutterFire CLI:
```bash
flutterfire configure --platforms=ios
```

4. **Создать индекс Firestore**

Для работы запросов в галерее нужен composite index:
- Collection: `drawings`
- Fields:
  - `userId` (Ascending)
  - `date` (Descending)

Индекс создастся автоматически при первом запросе (откроется ссылка в консоли).

5. **Запустить приложение**
```bash
flutter run
```

## 📱 Минимальные требования

- iOS 12.0+
- iPhone / iPad

## 🎨 Дизайн

Дизайн следует требованиям из Figma макетов (предоставлены отдельно).

### Основные экраны

1. **Login Screen** - вход в систему
2. **Register Screen** - регистрация нового пользователя
3. **Gallery Screen** - список рисунков
4. **Editor Screen** - редактор рисования

## 🧪 Тестирование

### Ручное тестирование

1. **Авторизация**
   - Регистрация нового пользователя
   - Вход существующего пользователя
   - Валидация форм
   - Обработка ошибок Firebase

2. **Рисование**
   - Рисование пальцем
   - Изменение размера кисти
   - Изменение цвета
   - Использование ластика
   - Отмена штрихов
   - Очистка холста

3. **Сохранение**
   - Сохранение в Firebase
   - Отображение в галерее
   - Локальное уведомление

4. **Галерея**
   - Отображение списка
   - Pull-to-refresh
   - Удаление рисунка
   - Открытие в редакторе

## 📝 Решения и компромиссы

### Firebase Storage vs Firestore

**Решение:** Хранение изображений в Firestore как Base64 строки.

**Обоснование:** ТЗ указывает "Изображения необязательно должны храниться в Firebase Storage (он может быть недоступен у вас), но обязательно в самом Firebase".

**Ограничения:**
- Максимальный размер документа Firestore: 1MB
- Для больших изображений можно использовать compression

**Преимущества:**
- Простота реализации
- Все данные в одном месте
- Атомарные операции

### Navigator 1.0 vs 2.0

**Решение:** Используется классический Navigator 1.0.

**Обоснование:**
- Простота для небольшого приложения (3-4 экрана)
- Фокус на архитектуре и бизнес-логике
- Легко масштабируется на Navigator 2.0 / go_router при необходимости

## 🔧 Возможные улучшения

- [ ] Добавить темную тему
- [ ] Реализовать Redo (возврат отмененного штриха)
- [ ] Добавить фильтры и эффекты для изображений
- [ ] Реализовать collaborative drawing
- [ ] Добавить экспорт в разные форматы (PNG, JPG, SVG)
- [ ] Оптимизировать размер изображений (compression)
- [ ] Добавить поиск и фильтрацию в галерее
- [ ] Реализовать offline-first подход с синхронизацией

## 👨‍💻 Автор

Тестовое задание для Flutter-разработчика

## 📄 Лицензия

Проект создан в учебных целях.