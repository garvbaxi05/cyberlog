SESSION 1:

Flutter Even/Odd Checker App
1. What I Learned

Difference between Native and Cross-Platform development.

How Hot Reload speeds up development in Flutter.

Understanding Widgets as the building blocks of a Flutter UI.

2. Tools Used

Flutter SDK

VS Code

Android Emulator / Physical Device

3. How I Created the App

Installed Flutter and set up the environment.

Verified setup using:

flutter doctor


Created a new Flutter project in VS Code.

Built a simple UI with a TextField, Button, and Text widget.

Added logic to check whether a number is Even or Odd.

4. Run the App

Inside your project folder, run:

flutter run



SESSION 2:
JIT vs AOT Compilation

JIT (Just-In-Time) compiles code during runtime, enabling fast development features like hot reload.
AOT (Ahead-Of-Time) compiles the app into optimized machine code before execution, giving faster startup and better performance for release builds.

How Conditionals Were Used

The app reads the number entered by the user and uses an if-else statement to check:

If number % 2 == 0, it is Even

Otherwise, it is Odd

This demonstrates Dart’s basic conditional flow.

How String Interpolation Was Used

The final message shown on the screen uses Dart's string interpolation:
"The number $value is Even."
It lets variables be placed directly inside strings in a clean and readable way.
