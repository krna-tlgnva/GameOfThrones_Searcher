# Flutter Testing App

Flutter-приложение для просмотра персонажей Harry Potter, создания собственных волшебников и синхронизации пользовательских профилей между локальным хранилищем и Firebase Cloud Firestore.

Проект сделан как кроссплатформенное приложение с разделением UI, модели, сервисов и репозитория. В одном интерфейсе объединены REST API, SQLite и облачная база данных.

## Что умеет приложение

- показывает стартовый экран в стиле Hogwarts;
- загружает персонажей из публичного Harry Potter API;
- открывает детальную карточку персонажа с именем, домом/типом, способностью и изображением;
- позволяет создать собственного волшебника через форму;
- сохраняет созданных персонажей локально в SQLite;
- отправляет созданных персонажей в Firebase Cloud Firestore;
- показывает локальный список `My Wizards`;
- показывает общий облачный список `Shared Wizards`;
- позволяет удалять локально сохраненных персонажей;
- аккуратно сообщает, если Firebase еще не настроен.

## Стек

- Flutter / Dart
- Material 3
- `http` для REST-запросов
- `sqflite` и `path` для локального SQLite-хранилища
- `firebase_core` и `cloud_firestore` для Firebase
- `google_fonts` для стилизации интерфейса

## Архитектура

Проект разделен на понятные слои:

```text
lib/
  main.dart                         # точка входа, тема и сборка зависимостей
  firebase_options.dart             # конфигурация Firebase
  models/
    character.dart                  # единая модель персонажа
  repositories/
    character_repository.dart       # фасад для API, SQLite и Firestore
  services/
    api_service.dart                # загрузка персонажей из hp-api.onrender.com
    local_service.dart              # локальное SQLite-хранилище
    firestore_service.dart          # чтение и запись Cloud Firestore
  screens/
    intro_screen.dart               # стартовый экран
    main_navigation_screen.dart     # нижняя навигация
    home_screen.dart                # API-персонажи
    create_character_screen.dart    # форма создания волшебника
    my_characters_screen.dart       # локально сохраненные персонажи
    cloud_characters_screen.dart    # персонажи из Firestore
    character_details_screen.dart   # подробная карточка
  widgets/
    app_scaffold.dart               # общий каркас экранов
    character_card.dart             # переиспользуемая карточка персонажа
```

Главная идея: экраны не работают напрямую с базами данных или сетью. Они обращаются к `CharacterRepository`, а репозиторий уже делегирует задачи нужному сервису.

## Данные

Единая модель `Character` содержит:

| Поле | Описание |
| --- | --- |
| `id` | локальный SQLite ID, если персонаж сохранен на устройстве |
| `name` | имя персонажа |
| `type` | дом, тип или происхождение |
| `ability` | магическая способность, патронус, палочка или актер из API |
| `imageUrl` | ссылка на изображение, если она доступна |

## REST API

Приложение загружает персонажей из:

```text
https://hp-api.onrender.com/api/characters
```

Ответ API преобразуется в общую модель `Character`, поэтому API-персонажи, локальные персонажи и Firestore-персонажи отображаются одинаковыми карточками.

## Локальное хранилище

Для пользовательских персонажей используется SQLite-база:

```text
character_builder.db
```

Таблица:

```text
local_characters
```

Сохранение работает по принципу offline-first: персонаж сначала записывается локально, а затем приложение пытается загрузить его в Firestore. Если облачная загрузка не удалась, локальная запись остается доступной.

## Firebase и Firestore

Firestore используется для общего списка созданных волшебников.

Коллекция:

```text
custom_characters
```

Документы содержат:

- `name`
- `type`
- `ability`
- `imageUrl`
- `createdAt`

### Настройка Firebase

1. Создайте проект в [Firebase Console](https://console.firebase.google.com/).
2. Добавьте нужные приложения: Android, iOS, Web, macOS или другие платформы.
3. Установите FlutterFire CLI, если он еще не установлен:

```bash
dart pub global activate flutterfire_cli
```

4. В корне проекта выполните:

```bash
flutterfire configure
```

5. Убедитесь, что файл `lib/firebase_options.dart` содержит актуальные параметры вашего Firebase-проекта.
6. Включите Cloud Firestore в Firebase Console.
7. Проверьте, что правила Firestore разрешают нужные операции чтения и записи для вашей демонстрационной среды.

## Запуск

Установите зависимости:

```bash
flutter pub get
```

Запустите приложение:

```bash
flutter run
```

Запуск на конкретной платформе:

```bash
flutter run -d chrome
flutter run -d ios
flutter run -d android
flutter run -d macos
```

## Проверка проекта

Форматирование:

```bash
dart format .
```

Статический анализ:

```bash
flutter analyze
```

Тесты:

```bash
flutter test
```

## Основной пользовательский сценарий

1. Пользователь открывает приложение и видит intro screen.
2. На вкладке `Wizard Characters` загружается список персонажей из API.
3. Пользователь открывает карточку персонажа и смотрит детали.
4. Через кнопку `Create Wizard` пользователь создает собственного волшебника.
5. Персонаж сохраняется в SQLite и отправляется в Firestore.
6. На вкладке `My Wizards` отображаются локальные записи.
7. На вкладке `Shared Wizards` отображаются общие записи из Firestore.

## Особенности реализации

- `CharacterRepository` скрывает детали работы с API, SQLite и Firestore от UI.
- `FirestoreService.create()` не ломает запуск приложения, если Firebase не настроен: сервис возвращает состояние ошибки, а интерфейс показывает понятное сообщение.
- `CreateCharacterScreen` показывает пользователю, удалось ли сохранить персонажа только локально или еще и загрузить его в облако.
- Карточка `CharacterCard` используется для API, локального списка и облачного списка, чтобы интерфейс оставался единым.

## Автор

Тулегенова Карина
