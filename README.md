# MyPortfolio Mobile

MyPortfolio Mobile is a Flutter application that introduces my personal portfolio. It displays my student information and connects to my Django REST API to load projects, authenticate users, and save project data.

This project continues the personal portfolio ecosystem that I previously built with Django. The mobile application is stored in a separate repository from the Django project.

## Features

- Displays my NPM, full name, and PBP class
- Provides four portfolio action cards with different colors
- Provides a drawer for navigation between Home, Projects, Add Project, and Add Experience
- Loads real project data from Django with loading, error, empty, retry, and refresh states
- Displays project details, contributions, technologies, dates, and optional images
- Uses token login and logout with protected project creation
- Validates project information and saves it through the authenticated API
- Displays submitted project information in a confirmation dialog
- Provides an experience form with categories, dates, and ongoing status
- Checks empty spaces, text length, required dates, and date order
- Uses a date picker to make date input easier and more accurate
- Displays all submitted experience information in a confirmation dialog
- Adjusts the card layout for desktop, tablet, and mobile screens
- Uses reusable and separated model and widget files
- Includes unit and widget tests for API calls, authentication, navigation, validation, and form submission
- Uses GitHub Actions to run checks and build a downloadable release APK

## Requirements

- Flutter 3.47.9 or a compatible stable version
- Dart 3.13.7 or a compatible version
- Chrome, an Android emulator, or an Android device
- The Django portfolio backend from Tutorial 07 and Tutorial 10

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

4. Generate the JSON serialization file.

   ```bash
   dart run build_runner build
   ```

5. Start the Django backend from the separate `myportfolio` repository.

   ```bash
   python manage.py runserver
   ```

6. Run the application in Chrome and point it to the local backend.

   ```bash
   flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000
   ```

Android emulators use `http://10.0.2.2:8000` by default, so no Dart define is needed when running with `flutter run` on an emulator.

## Code Quality Checks

Run these commands from the project root before committing changes.

```bash
dart run build_runner build
dart format .
flutter analyze
flutter test
```

## Project Structure

```text
lib/
  main.dart
  config.dart
  models/
    item_homepage.dart
    project.dart
  screens/
    experience_form.dart
    login_screen.dart
    menu.dart
    project_form.dart
    project_list_screen.dart
    project_detail_screen.dart
  services/
    api_client.dart
    auth_state.dart
  theme/
    portfolio_theme.dart
  utils/
    form_validators.dart
  widgets/
    date_form_field.dart
    auth_guard.dart
    form_intro.dart
    info_card.dart
    left_drawer.dart
    project_card.dart
test/
  api_client_test.dart
  auth_state_test.dart
  widget_test.dart
```

- `main.dart` starts the application and defines its theme.
- `menu.dart` arranges the main portfolio page.
- `project_form.dart` validates and submits authenticated project data to Django.
- `project_list_screen.dart` loads projects and handles loading, error, empty, and refresh states.
- `project_detail_screen.dart` displays complete information for one project.
- `login_screen.dart` validates Django account credentials.
- `api_client.dart` handles API requests and safe error messages.
- `auth_state.dart` stores the current in-memory token and updates the interface.
- `auth_guard.dart` protects actions that require login.
- `experience_form.dart` provides experience inputs, date selection, validation, and confirmation.
- `item_homepage.dart` stores the name, icon, color, and action of each menu item.
- `portfolio_theme.dart` stores the colors and shared visual theme from the Django portfolio.
- `form_validators.dart` stores validation rules that can be reused by different forms.
- `date_form_field.dart` provides a reusable field that opens a date picker.
- `form_intro.dart` provides the matching dark introduction panel for both forms.
- `info_card.dart` displays one piece of owner information.
- `left_drawer.dart` provides navigation between the application screens.
- `project_card.dart` displays a tappable portfolio action.
- `widget_test.dart` checks content, navigation, validation, and interactions.

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

### Tutorial 09

- Added the `material_ui` dependency and updated Material imports
- Organized portfolio pages inside the `screens` directory
- Added a reusable navigation drawer for Home and Add Project
- Added navigation with `push` and `pushReplacement`
- Created a responsive project form with text inputs and a category dropdown
- Added required field validation and optional URL validation
- Displayed submitted project data in a confirmation dialog
- Reset every form field after a successful submission
- Added widget tests for the drawer, routes, validation, dialog, and form reset

### Assignment 8

- Created an Experience Form in a separate screen file
- Added title, organization, category, dates, description, and responsibilities inputs
- Added an ongoing experience switch that disables the end date field
- Added validation for empty spaces, input length, required dates, and date order
- Added a date picker for safer date selection
- Connected the form through a new action card and the navigation drawer
- Reused the same Scaffold, AppBar, theme color, and drawer across pages
- Matched the mobile colors and rounded cards to the Django portfolio design
- Displayed every submitted value in a confirmation dialog
- Reset the complete form after a successful submission
- Added widget tests for navigation, invalid input, valid input, dialog content, and reset behavior

### Tutorial 10

- Enabled token authentication and CORS in the Django backend
- Added token login and logout API endpoints
- Added `http`, `provider`, `json_annotation`, and code generation packages
- Created a serializable Project model that matches the real Django API
- Added an API client with safe request and validation error handling
- Loaded real projects with loading, error, empty, retry, and refresh states
- Added a complete project detail screen using the portfolio theme
- Added login, logout, shared authentication state, and protected navigation
- Connected the project form to authenticated Django project creation
- Added unit and widget tests for API, authentication, navigation, and submission
- Added GitHub Actions checks and release APK artifact generation

## Reflective Questions

### Assignment 7

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

### Assignment 8

1. **What is the difference between Navigator.push, Navigator.pushReplacement, and Navigator.pop?**

   `Navigator.push` adds a new page on top of the current page. I use it when the Add Experience card opens the form. This keeps Home below the form, so the Back button can return to Home.

   `Navigator.pushReplacement` replaces the current page. I use it for drawer navigation because it prevents repeated copies of Home or a form from building up in the navigation history.

   `Navigator.pop` removes the current page or dialog. The OK button uses it to close the confirmation dialog. The normal Back button also removes the form page and returns to Home when the form was opened with `push`.

2. **How do Scaffold, AppBar, Drawer, and the theme keep the pages consistent?**

   Each main page uses a `Scaffold` for the same page structure. The project and experience forms use an `AppBar` with the same title style and primary theme color. They also reuse the same `LeftDrawer`, so users can find Home and both forms in the same place. The colors come from `Theme.of(context).colorScheme.primary`, which keeps the design consistent and avoids repeating a fixed color in every file.

3. **How does the form stay usable on a small screen?**

   The form uses `SingleChildScrollView`, so users can reach every field even when the screen is short or the keyboard is open. Padding separates the form from the screen edges. `SizedBox` gives clear space between inputs. A `ConstrainedBox` limits the width on a large screen while allowing the form to use the available width on a small screen. Multiline fields give enough space for longer descriptions without making other fields difficult to reach.

4. **How do GlobalKey, validators, and validate work in this form?**

   `GlobalKey<FormState>` gives the page access to the current `Form` state. Each field has a validator that returns an error message when its value is not acceptable. The Save button calls `validate()`. Flutter runs every validator and only opens the confirmation dialog when they all return `null`.

   For example, a title containing only spaces is rejected because the validator trims the input before checking it. An end date earlier than the start date is also rejected. A keyboard type or input widget cannot replace these validators. A keyboard can make input easier, but it cannot understand rules such as required text, minimum length, or valid date order.

## AI Usage Disclosure

I used OpenAI Codex in ChatGPT as a learning and development assistant for Tutorial 08, Assignment 7, Tutorial 09, Assignment 8, and Tutorial 10.

### How AI Assisted Me

- Read the assignment requirements and helped divide the work into clear phases
- Suggested storing each action color inside the `ItemHomepage` model instead of using repeated conditions
- Helped separate the model, information card, and action card into reusable files
- Helped create a responsive layout with `LayoutBuilder`, `Wrap`, and `GridView`
- Helped write and run widget tests for the page content and SnackBar messages
- Helped organize navigation with a drawer and Navigator routes
- Helped build form validation and a confirmation dialog
- Helped test project form submission and reset behavior
- Helped plan and build the Experience Form for Assignment 8
- Helped separate shared validators and the reusable date field
- Helped test date input, ongoing status, navigation, dialog content, and form reset
- Helped adapt the navy, brown, nude, and white web portfolio theme for Flutter
- Helped adapt the Tutorial 10 API schema to my existing Django Project model
- Helped implement token authentication, API loading, project submission, and CI/CD
- Helped add tests for network errors, authentication state, and JSON requests
- Helped organize this README and explain Flutter concepts in simple English

### Prompt Strategy

I gave the AI the complete tutorial and assignment instructions. I asked it to create a roadmap before editing the code. I then asked it to complete one phase at a time, explain the purpose of each change, run checks, and create descriptive conventional commits. I also asked for short and useful code comments instead of comments on every line.

### AI Limitations and Manual Fixes

AI output still required verification. The first tutorial version used sample identity data, so I provided and confirmed my correct NPM, full name, and PBP class. I also checked that the proposed features matched the assignment instead of accepting unrelated additions. Automated tests can confirm widget behavior, but they cannot guarantee that every layout matches my visual preference. Because of this, I also review the application manually in the browser.

During Tutorial 09, the first drawer header was too tall for the widget test screen. The expanded test suite found the overflow, so the header was simplified and tested again. The tests also helped verify that the category dropdown returned to its default value after submission. This showed that generated code still needed automated and visual verification.

During Assignment 8, the first reusable validator produced an awkward error message for some field names. I changed the article rule and used a clearer field name for the responsibility summary. One test also tried to tap a button after validation messages changed the form height. The feature worked, but the test produced a warning. I removed the unnecessary tap and ran all checks again. This showed that passing tests are not enough when the test output still contains warnings.

During Tutorial 10, the provided Project example did not match all fields in my existing Django serializer. I kept my real project structure and adapted the Flutter model and form instead of replacing working backend data. I also moved slug generation to Django because a slug is an internal URL value and should not be entered manually in the mobile form. The tests identified older assertions that expected `403` for anonymous requests. I updated them to `401` because token authentication now correctly distinguishes unauthenticated and unauthorized requests.

The date picker prevents users from selecting an end date before the chosen start date. The form still includes a date order validator as a second safety check. I kept both because interface limits and data validation have different purposes.

The AI could not know my identity, class, design preference, or repository setup without my input. I reviewed the explanations, selected the final feature scope, and kept control of the GitHub repository and push process.

### AI Prompt Log

1. I asked the AI to read the Assignment 7 rubric and create a phased roadmap with planned commits.
2. I asked the AI to implement one phase at a time so every commit represented a clear change.
3. I asked the AI to add different action colors using a clean model attribute.
4. I asked the AI to separate reusable models and widgets into clear files.
5. I asked the AI to improve responsiveness and prevent overflow on smaller screens.
6. I asked the AI to add tests for all menu actions and explain the reflective questions in simple English.
7. I asked the AI to read Tutorial 09 and plan navigation, form, testing, and documentation phases.
8. I asked the AI to add Material UI and reorganize screens and widgets without breaking existing features.
9. I asked the AI to build a validated project form and connect it through the drawer and project card.
10. I asked the AI to test every route, validation message, dialog value, and form reset behavior.
11. I asked the AI to read Assignment 8 and create a phased roadmap that targets every scoring criterion.
12. I asked the AI to build an Experience Form with suitable fields and stronger date validation.
13. I asked the AI to reuse validation and date field code instead of repeating the same logic.
14. I asked the AI to connect the form through the action card and drawer without breaking existing navigation.
15. I asked the AI to test valid and invalid input, ongoing experience, dialog values, and form reset behavior.
16. I asked the AI to audit the code, documentation, Git history, and assignment rubric before submission.
17. I asked the AI to simplify the UI while matching the colors and rounded design of my Django portfolio.
18. I asked the AI to rewrite the visible interface text in natural English that matches the tone of my web portfolio.
19. I asked the AI to read Tutorial 10 and divide backend integration into clear commits.
20. I asked the AI to merge Assignment 8 and complete the first half without pushing.
21. I asked the AI to finish authentication, project submission, CI/CD, tests, and documentation before the deadline.
