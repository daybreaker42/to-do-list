# Copilot Instructions for the To-Do List Project

## Overview
This project is a cross-platform to-do list application designed for both mobile and desktop platforms. It features a responsive UI and integrates with a backend server for CRUD operations and user authentication.

## Architecture
- **Frontend**: Built with Flutter, supporting both mobile and desktop platforms. Key files include:
  - `lib/main.dart`: Entry point of the application.
  - `lib/config/`: Contains configuration files like `app_router.dart` for routing and `theme.dart` for theming.
  - `lib/pages/`: Contains UI pages such as `tag_list_page.dart` and `task_detail_page.dart`.
  - `lib/widgets/`: Reusable UI components.
- **Backend**: Communicates with the frontend via HTTP for CRUD operations and user authentication.

## Developer Workflows
### Build and Run
- Use `flutter run` to start the application in development mode.
- For Android, ensure an emulator or device is connected.
- For iOS, ensure Xcode is installed and configured.

### Testing
- Unit tests are located in the `test/` directory.
- Run tests using `flutter test`.

### Debugging
- Use Flutter's hot reload feature for rapid iteration.
- Debug logs can be viewed in the terminal or IDE's debug console.

## Project-Specific Conventions
- **Theming**: The app uses a custom theme defined in `lib/config/theme.dart`. All colors and text styles should reference this file.
- **Routing**: Navigation is managed using `GoRouter`, configured in `lib/config/app_router.dart`.
- **Fonts**: The app uses the Pretendard font, located in `assets/fonts/`.
- **Assets**: Images and other assets are stored in the `assets/` directory. Update `pubspec.yaml` when adding new assets.

## External Dependencies
- **Flutter ScreenUtil**: Used for responsive design.
- **GoRouter**: For navigation.

## Examples
### Adding a New Page
1. Create a new Dart file in `lib/pages/`.
2. Define a `StatelessWidget` or `StatefulWidget` for the page.
3. Add a route in `lib/config/app_router.dart`.

### Adding a New Theme Color
1. Update `AppColors` in `lib/config/theme.dart`.
2. Use the new color in your widgets.

### Adding a New Font
1. Add the font file to `assets/fonts/`.
2. Update `pubspec.yaml` to include the new font.
3. Reference the font in `lib/config/theme.dart`.

## Important Note for AI Agents
- Do not execute `flutter run`, `flutter debug`, or any similar commands without explicit permission from the user.

## Key Files and Directories
- `lib/main.dart`: Application entry point.
- `lib/config/`: Configuration files for routing and theming.
- `lib/pages/`: UI pages.
- `lib/widgets/`: Reusable components.
- `assets/`: Fonts and images.
- `test/`: Unit tests.

## Design Guide

For design-related references, please consult the `design-guides.md` file located in the `.github/` directory. This file contains detailed information about the styles and frames used in the project.

For more details, refer to the `README.md` file.
