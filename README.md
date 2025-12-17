CyberLog is a Flutter application that demonstrates state management using Provider.
The app manages application settings and user activity logs without using setState.

Features

Dark mode toggle using Provider

User activity logging

Real-time UI updates

Clean Material 3 UI

Single-file implementation

State Management

CyberLog uses the Provider package for managing state.

ChangeNotifier is used to hold state

notifyListeners() updates the UI automatically

UI listens to state changes using context.watch

No widget uses setState

Providers Used
SettingsProvider

Manages application-wide settings

Handles dark mode state

LogProvider

Stores a list of user activity logs

Adds new logs when user actions occur

User Logs

A user log represents an action performed by the user in the app, such as:

Enabling or disabling dark mode

Adding a cyber note

Each log stores:

Action description

Timestamp




![session7](https://github.com/user-attachments/assets/0afa6b80-435b-40ab-82c5-889687062fa6)
