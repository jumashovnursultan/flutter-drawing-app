class AppStrings {
  // App
  static const String appName = 'Drawing App';

  // Auth - Titles & Labels
  static const String login = 'Войти';
  static const String loginTitle = 'Вход';
  static const String email = 'e-mail';
  static const String enterEmail = 'Введите электронную почту';
  static const String enterPassword = 'Введите пароль';
  static const String password = 'Пароль';
  static const String register = 'Регистрация';
  static const String signUp = 'Зарегистрироваться';
  static const String enterYourName = 'Введите ваше имя';
  static const String name = 'Имя';
  static const String yourEmail = 'Ваша электронная почта';
  static const String logoutTitle = 'Выход';
  static const String logoutConfirm = 'Вы уверены, что хотите выйти?';
  static const String logout = 'Выйти';

  // Auth - Errors
  static String loginError(String error) => 'Ошибка входа: $error';
  static String registrationError(String error) => 'Ошибка регистрации: $error';
  static String logoutError(String error) => 'Ошибка выхода: $error';
  static String getUserError(String error) =>
      'Ошибка получения пользователя: $error';
  static const String userNotFound = 'Пользователь с таким email не найден';
  static const String userNotFoundGeneral = 'Пользователь не найден';
  static const String wrongPassword = 'Неверный пароль';
  static const String emailAlreadyInUse = 'Email уже используется';
  static const String invalidEmail = 'Неверный формат email';
  static const String weakPassword = 'Слишком простой пароль';
  static const String operationNotAllowed = 'Операция не разрешена';
  static const String userDisabled = 'Пользователь заблокирован';
  static const String networkError =
      'Ошибка сети. Проверьте интернет-соединение';
  static String firebaseError(String? message) => 'Ошибка Firebase: $message';
  static const String registrationFailed =
      'Не удалось зарегистрировать пользователя';

  // Validation Errors
  static const String emailRequired = 'Email обязателен';
  static const String passwordRequired = 'Пароль обязателен';
  static const String passwordTooShort =
      'Пароль должен быть минимум 8 символов';
  static const String eightToSixteenCharacters = '8-16 символов';
  static const String confirmPassword = 'Подтверждение пароля';

  // Drawing
  static const String newImage = 'Новое изображение';
  static const String editing = 'Редактирование';
  static const String gallery = 'Галерея';
  static const String myDrawing = 'Мой рисунок';
  static const String saveToPhotos = 'Сохранить в Фото';
  static const String clearCanvasConfirm = 'Очистить холст?';
  static const String clearCanvasMessage =
      'Вы уверены? Это действие нельзя отменить.';
  static const String drawingExported = 'Рисунок экспортирован';
  static const String saveDrawingTitle = 'Сохранить рисунок';
  static const String drawingTitle = 'Название'; // или title
  static const String enterDrawingTitle = 'Введите название рисунка';
  static const String drawingSaved = '🎨 Рисунок сохранён';
  static const String drawingUpdated = 'Рисунок обновлен';
  static const String eraser = 'Ластик';
  static const String brush = 'Кисть';
  static String brushSize(int size) => 'Размер: $size';
  static const String saving = 'Сохранение...';
  static const String selectColor = 'Выберите цвет';
  static const String saveToGalleryFailed = 'Не удалось сохранить в галерею';

  // Drawing - Errors
  static String importImageError(String error) =>
      'Ошибка импорта изображения: $error';
  static const String imageConversionFailed =
      'Не удалось конвертировать изображение';
  static String exportError(String error) => 'Ошибка экспорта: $error';
  static String saveError(String error) => 'Ошибка сохранения: $error';
  static String importError(String error) => 'Ошибка импорта: $error';
  static String loadDrawingError(String error) =>
      'Ошибка загрузки рисунка: $error';
  static String saveDrawingError(String error) =>
      'Ошибка сохранения рисунка: $error';

  static String loadDrawingsError(String error) =>
      'Ошибка загрузки рисунков: $error';
  static const String drawingNotFound = 'Рисунок не найден';
  static String updateDrawingError(String error) =>
      'Ошибка обновления рисунка: $error';
  static String deleteDrawingError(String error) =>
      'Ошибка удаления рисунка: $error';

  // Gallery
  static const String create = 'Создать';
  static const String deleteDrawing = 'Удалить рисунок?';
  static String deleteDrawingMessage(String title) =>
      'Вы уверены, что хотите удалить "$title"?';
  static const String emptyGalleryMessage =
      'Создайте свой первый рисунок,\nчтобы начать работу';
  static const String createNew = 'Создать новый';
  static const String noDrawingsYet = 'Пока нет рисунков';

  // Common/General
  static const String checking = 'Проверка...';
  static const String retry = 'Попробовать снова';
  static const String cancel = 'Отмена';
  static const String clear = 'Очистить';
  static const String save = 'Сохранить';
  static const String done = 'Готово';
  static const String delete = 'Удалить';

  // Common Errors
  static const String noInternetStill = 'Все еще нет подключения к интернету';
  static const String noInternet = 'Нет подключения к интернету';
  static const String checkConnectionMessage =
      'Проверьте подключение к Wi-Fi или мобильным данным и попробуйте снова';
  static const String loadingError = 'Ошибка загрузки';

  // Notifications
  static const String notificationChannelDescription =
      'Notifications for drawing app events';
}
