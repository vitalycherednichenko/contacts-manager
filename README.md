# Console Contact Management Application

This is a Swift console application for managing a contact list. The application allows you to view and save contacts to a JSON file.

## Requirements

- macOS 10.15 or higher / Linux (Ubuntu 20.04 or higher)
- Swift 5.0 or higher
- Xcode 12.0 or higher (optional, macOS only)

## Installation and Running

### Method 1: Via Terminal

1. Clone the repository:
```bash
git clone [repository URL]
cd ContactsApp
```
2. Run the build script:
```bash
./build.sh
```
3. Run the application:
```bash
./ContactsApp
```

### Method 2: Via Xcode (macOS only)

1. Open `CLProject.xcodeproj` in Xcode
2. Select the "ContactsApp" scheme
3. Click the "Run" button (▶️) or use the keyboard shortcut `Cmd + R`

### Installing Swift

To install Swift on your operating system, follow the official documentation:
[Swift Installation](https://www.swift.org/install/macos/)

## Usage

After launching the application, you will see a console menu with the following options:

- Create a contact
- View all contacts
- Exit

Follow the console instructions to perform the desired actions.

## Features

- View the list of all contacts
- Automatic data saving to JSON file
- Data loading when the application starts