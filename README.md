# MyPortfolio Mobile

MyPortfolio Mobile is a Flutter application that introduces my personal portfolio. It displays my student information and provides simple actions to view projects, add a project, and log out.

This project continues the personal portfolio ecosystem that I previously built with Django. The mobile application is stored in a separate repository from the Django project.

## Features

- Displays my NPM, full name, and PBP class
- Provides three portfolio action cards with different colors
- Shows a matching SnackBar message when an action is selected
- Adjusts the card layout for desktop, tablet, and mobile screens
- Uses reusable and separated model and widget files
- Includes widget tests for the owner information and all menu actions

## Requirements

- Flutter 3.47.9 or a compatible stable version
- Dart 3.13.7 or a compatible version
- Chrome, an Android emulator, or an Android device

## How to Run the Project

1. Clone this repository.

   ```bash
   git clone https://github.com/rindunadhirah/myportfolio_mobile.git
   ```

2. Open the project folder.

   ```bash
   cd myportfolio_mobile
   ```

3. Install the required Flutter packages.

   ```bash
   flutter pub get
   ```

4. Run the application in Chrome.

   ```bash
   flutter run -d chrome
   ```

## Code Quality Checks

Run these commands from the project root before committing changes.

```bash
dart format .
flutter analyze
flutter test
```

## Project Structure

```text
lib/
  main.dart
  menu.dart
  models/
    item_homepage.dart
  widgets/
    info_card.dart
    item_card.dart
test/
  widget_test.dart
```

- `main.dart` starts the application and defines its theme.
- `menu.dart` arranges the main portfolio page.
- `item_homepage.dart` stores the name, icon, and color of each action.
- `info_card.dart` displays one piece of owner information.
- `item_card.dart` displays a tappable portfolio action.
- `widget_test.dart` checks the page content and button feedback.

## Weekly Progress

### Tutorial 08

- Installed and checked the Flutter development environment
- Created the `myportofolio_mobile` Flutter project
- Separated `main.dart` and `menu.dart`
- Changed `MyHomePage` into a `StatelessWidget`
- Created reusable `InfoCard` and `ItemCard` widgets
- Added three menu actions and SnackBar feedback

### Assignment 7

- Replaced the tutorial identity with my accurate NPM, name, and class
- Added a different color to every action card
- Separated the action model and reusable widgets into their own files
- Added a responsive layout for different screen sizes
- Added icons to improve the information cards
- Added widget tests for the page content and all menu interactions

## Assignment 7

1. **What is a widget tree and how do parent and child widgets work?**

   A widget tree is the structure that describes the user interface of a Flutter application. Each widget can contain other widgets. The widget that contains another widget is the parent, while the widget inside it is the child. For example, `Scaffold` is the parent of the `AppBar` and page body. The body contains a `Column`, and the `Column` contains text, cards, and a grid. Flutter follows this structure when it builds the screen.

2. **What widgets are used in this project and what does each widget do?**

   - `MaterialApp` is the root of the application and provides the theme.
   - `Scaffold` provides the main page structure, including the app bar, body, and SnackBar area.
   - `AppBar` displays the application title.
   - `LayoutBuilder` reads the available screen width for the responsive layout.
   - `SingleChildScrollView` lets the page scroll when its content is taller than the screen.
   - `Padding` gives space around content.
   - `Column` arranges widgets vertically.
   - `Wrap` arranges information cards and moves them to a new row when needed.
   - `Card` gives each piece of owner information a Material card appearance.
   - `SizedBox` controls size and adds spacing between widgets.
   - `GridView` arranges the action cards in responsive columns.
   - `Material` gives each action card its background color and shape.
   - `InkWell` makes an action card tappable and shows a touch effect.
   - `Center` places content in the center of an action card.
   - `Icon` displays a visual symbol for information and actions.
   - `Text` displays labels, identity data, and messages.
   - `SnackBar` displays short feedback after a button is pressed.
   - `MyApp`, `MyHomePage`, `InfoCard`, and `ItemCard` are custom widgets created for this application.

3. **What is the purpose of MaterialApp?**

   `MaterialApp` prepares the main features needed by a Material Design application. It provides the application theme, navigation support, text direction, and other shared settings. It is commonly used as the root widget because its settings can be accessed by widgets below it. In this project, it provides the color scheme and displays `MyHomePage` as the first page.

4. **What is the difference between StatelessWidget and StatefulWidget?**

   A `StatelessWidget` is used when a widget does not need to store changing data. Its output depends on the values provided to it. `MyHomePage`, `InfoCard`, and `ItemCard` use `StatelessWidget` because their data stays the same while the page is open.

   A `StatefulWidget` is needed when the interface must change after an event. Examples include a counter, a form whose values change, a loading indicator, and data loaded from an API. Its `State` object stores the changing values and `setState` asks Flutter to rebuild the affected interface.

5. **What is BuildContext and why is it important?**

   `BuildContext` represents the location of a widget inside the widget tree. It allows a widget to find shared information from its parent widgets. In the `build` method, this project uses `context` to access the application theme with `Theme.of(context)` and to display feedback with `ScaffoldMessenger.of(context)`. The correct context is important because Flutter searches upward from that location to find the required parent widget.

6. **What is hot reload and how is it different from hot restart?**

   Hot reload sends updated Dart code to a running application and rebuilds the interface while keeping the current application state. It is useful for quickly checking small UI and logic changes.

   Hot restart starts the Dart application again and removes its current state. It is needed when changes affect initial values, global variables, static data, or the `main` function. A full restart may be needed after changing native Android or iOS code, adding certain plugins, or changing dependencies that require a new build.

## AI Usage Disclosure

I used OpenAI Codex in ChatGPT as a learning and development assistant for Tutorial 08 and Assignment 7.

### How AI Assisted Me

- Read the assignment requirements and helped divide the work into clear phases
- Suggested storing each action color inside the `ItemHomepage` model instead of using repeated conditions
- Helped separate the model, information card, and action card into reusable files
- Helped create a responsive layout with `LayoutBuilder`, `Wrap`, and `GridView`
- Helped write and run widget tests for the page content and SnackBar messages
- Helped organize this README and explain Flutter concepts in simple English

### Prompt Strategy

I gave the AI the complete assignment instructions and rubric. I asked it to create a roadmap before editing the code. I then asked it to complete one phase at a time, explain the purpose of each change, run checks, and create descriptive conventional commits. I also asked for short and useful code comments instead of comments on every line.

### AI Limitations and Manual Fixes

AI output still required verification. The first tutorial version used sample identity data, so I provided and confirmed my correct NPM, full name, and PBP class. I also checked that the proposed features matched the assignment instead of accepting unrelated additions. Automated tests can confirm widget behavior, but they cannot guarantee that every layout matches my visual preference. Because of this, I also review the application manually in the browser.

The AI could not know my identity, class, design preference, or repository setup without my input. I reviewed the explanations, selected the final feature scope, and kept control of the GitHub repository and push process.

### AI Prompt Log

1. I asked the AI to read the Assignment 7 rubric and create a phased roadmap with planned commits.
2. I asked the AI to implement one phase at a time so every commit represented a clear change.
3. I asked the AI to add different action colors using a clean model attribute.
4. I asked the AI to separate reusable models and widgets into clear files.
5. I asked the AI to improve responsiveness and prevent overflow on smaller screens.
6. I asked the AI to add tests for all menu actions and explain the reflective questions in simple English.
