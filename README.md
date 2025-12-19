This is a Flutter application that implements a daily checklist using the Hive local database. The app allows users to add tasks, mark them as completed, and delete them. All data is stored locally and persists across app restarts.

The project demonstrates practical usage of local storage, reactive UI updates, and clean UI structuring in Flutter.

Features

Add daily checklist tasks

Mark tasks as completed or incomplete

Delete tasks from the list

Automatically load saved tasks on app startup

Display task completion progress

Offline-first local storage using Hive

Technology Stack

Flutter (Dart)

Hive

hive_flutter

Material Design 3

Data Storage

The app uses a Hive box named checklist to store tasks locally.

Each task is stored as a key-value map:

title: String

done: Boolean

This ensures fast access and persistence without relying on external databases.

Architecture

Single main.dart file

Stateful widgets for UI control

Hive for local data persistence

ValueListenableBuilder for real-time UI updates


![WhatsApp Image 2025-12-19 at 17 41 51](https://github.com/user-attachments/assets/bfe06a83-8e5e-4008-b31d-b830a3b2afa8)
