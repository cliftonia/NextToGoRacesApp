# NextToGoRacesApp

## Overview
NextToGoRacesApp is an iOS application that displays a real-time list of upcoming races using the Entain Racing API. The app ensures that users always see a minimum of five upcoming races, sorted by start time in ascending order, and allows filtering by race category.

## Features
- Displays a time-ordered list of races.
- Filters races by category: **Horse**, **Harness**, and **Greyhound**.
- Removes races from the list if they are more than **1 minute past** their advertised start time.
- Ensures that **five races** are always visible, fetching additional races as needed.
- Uses **SwiftUI** for UI implementation.
- Implements **Structured Concurrency (async/await)** for API interactions.
- Supports **Dynamic Type** and **VoiceOver** for accessibility.

## API Details
**Endpoint:**  
```
https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=10
```

### Categories:
- **Greyhound racing:** `9daef0d7-bf3c-4f50-921d-8e818c60fe61`
- **Harness racing:** `161d9be2-e909-4326-8c2c-35ed71fb460b`
- **Horse racing:** `4a2788f8-e825-4d36-9894-efd4baf1cfae`

## Technical Implementation
### Architecture
- **MVVM (Model-View-ViewModel)**
- **Swift Concurrency (async/await)**
- **SwiftUI Lifecycle**
- **Decodable API Models**
- **Actor-based RaceService** for API calls

### Code Structure
- **Models:** Defines race-related data structures.
- **Services:** Handles API calls and data parsing.
- **ViewModels:** Manages race data and UI state.
- **Views:** SwiftUI-based UI components.
- **Tests:** Implements **unit tests** and **UI tests** using **Swift Testing** and **XCTest**.

### Screenshots
![image](https://github.com/user-attachments/assets/418035d4-974b-46b9-aa06-1694a3d19962)
![image](https://github.com/user-attachments/assets/29f232b8-1ff2-479e-83ec-2106846c917a)
![image](https://github.com/user-attachments/assets/4ab1a758-048b-4f7a-a1fc-719e26a9aaf4)
![image](https://github.com/user-attachments/assets/f1253ee9-38ac-47d9-896f-eb88972b360f)
![image](https://github.com/user-attachments/assets/e9b80cea-7393-434c-88a5-5f04955d0ed9)

## Dependencies
- **Swift Package Manager (SPM)**
- **No third-party dependencies used.**

## Running the App
### Prerequisites
- **Xcode** (Latest Stable Version)

### Steps to Run
1. Clone the repository:
   ```sh
   git clone https://github.com/cliftonia/NextToGoRacesApp.git
   cd NextToGoRacesApp
   ```
2. Open `NextToGoRacesApp.xcodeproj` in Xcode.
3. Select an **iOS simulator** and run the project (`Cmd + R`).

## Testing
- **Unit tests** are written using **Swift Testing**.
- **UI tests** are implemented using **XCTest**.
- Run tests using:
  - `Cmd + U` (Run Tests in Xcode)
- Tests cover:
  - **Race filtering**
  - **Countdown logic**
  - **API response handling**
  - **UI behavior in different states (loading, error, empty, and data loaded)**
  - **Accessibility support**

## Accessibility Considerations
- **Supports Dynamic Type** for scalable UI.
- **Includes VoiceOver labels** for improved accessibility.
- **Ensures tap targets** are large enough for easy interaction.

## Future Improvements
- Implement **caching** for better performance.
- Add **UI animations** for smoother updates.
- Support **localization** for multiple languages.
- Enhance UI with **custom SF Symbols** and themes.
