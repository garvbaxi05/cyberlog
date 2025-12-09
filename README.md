# SESSION 1

## What I Learned

### **1. Native vs. Cross‑Platform Development**

* **Native apps** are built specifically for one platform (Android → Kotlin/Java, iOS → Swift/Objective‑C).
* They offer **best performance**, **full hardware access**, and **platform‑specific UI**.
* **Cross‑platform apps** (like Flutter) allow writing **one codebase** that runs on Android, iOS, Windows, macOS, Linux, and Web.
* Flutter uses the **Dart** language and its own rendering engine, giving **near‑native performance**.

### **2. Hot Reload**

* One of Flutter’s best features.
* Allows you to **instantly apply code changes** without restarting the entire app.
* Improves productivity while designing UI or fixing bugs.
* Keeps the current app state intact.

### **3. Widgets in Flutter**

* Everything in Flutter is a **widget**.
* Widgets describe **what the UI should look like**.
* Two types of widgets:

  * **StatelessWidget** → UI does not change.
  * **StatefulWidget** → UI updates when state changes.
* Complex UIs are built by **nesting smaller widgets**.

---

## Steps to Install and Run the App

### **1. Install Flutter SDK**

Follow the official installation guide for your OS:

* [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)

After installing, add Flutter to PATH.

### **2. Check Flutter Installation**

Run the following command:

```bash
flutter doctor
```

This checks:

* Flutter SDK setup
* Android Studio / Xcode
* Device configuration
* Dart SDK

Fix any issues shown by `flutter doctor`.

---

## Running the Flutter App

### **1. Project Creation**

I created this Flutter app locally using the following command:

```bash
flutter create <project-name>
```

Then I opened the project folder in VS Code only and continued development.

### **2. Install Dependencies**

```bash
flutter pub get
```

### **2. Install Dependencies**

```bash
flutter pub get
```

### **3. Connect a Device / Start Emulator**

* Plug in a real device → enable USB debugging
* Or start an Android emulator

Check available devices:

```bash
flutter devices
```

### **4. Run the App**

```bash
flutter run
```

# SESSION 2

### **JIT vs. AOT Compilation**

* **JIT (Just-in-Time)** compilation compiles code **during runtime**, making development faster with features like *Hot Reload*.
* **AOT (Ahead-of-Time)** compilation compiles the app **before runtime**, producing faster, optimized release builds.
* Flutter uses **JIT in debug mode** and **AOT in release mode** for best performance.

### **Using Dart Conditionals for Even/Odd Check**

I used an `if-else` conditional statement in Dart to check whether the entered number is even or odd using:

```dart
number % 2 == 0
```

This condition returns `true` for even numbers and `false` for odd numbers.

### **String Interpolation for Output Message**

The final message displayed to the user was constructed using **string interpolation**, such as:

```dart
"The number $number is Even."
```

This makes the output cleaner and easier to format dynamically.

# SESSION 3

### Using Classes to Structure Log Data

I created a custom `Log` class with three properties: `String action`, `DateTime timestamp`, and `String status`. This class allowed me to organize each log entry as a structured object rather than using unorganized variables. By encapsulating the data in a class, the logs became easier to manage, read, and expand in the future.

### Using Lists and Iteration to Render Multiple Widgets

Inside a `StatelessWidget`, I created a `List<Log>` containing 3 sample log objects. To display all logs in the UI, I used list iteration. This allowed me to efficiently transform each `Log` object into a widget.

Each log generated a `Text` widget displaying the log action and a formatted timestamp. Using iteration ensured the UI updated automatically based on the number of log entries, making the rendering both clean and scalable.
