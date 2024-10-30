# AR Indoor and Outdoor Navigation App

An Augmented Reality (AR) navigation app designed for seamless, real-time navigation across large environments, such as university campuses. This app leverages AR to provide clear indoor and outdoor navigation, integrating GPS, QR codes, and advanced pathfinding to guide users intuitively through complex spaces.
##Overview
This app is designed for use on campuses or other large venues, where it helps users seamlessly navigate between indoor and outdoor spaces. By utilizing both GPS and QR codes, this app provides accurate positioning and navigation regardless of GPS limitations indoors. Real-time AR overlays make navigation clear and intuitive, adapting dynamically to the users path.

## Overview
This app is designed for use on campuses or other large venues, where it helps users seamlessly navigate between indoor and outdoor spaces. By utilizing both GPS and QR codes, this app provides accurate positioning and navigation regardless of GPS limitations indoors. Real-time AR overlays make navigation clear and intuitive, adapting dynamically to the users path.

<img src="Archietechture diagramn.jpg"/>

## Features

### Outdoor Navigation
- **GPS Integration**: Real-time, accurate outdoor navigation using GPS and device sensors.
- **Route Calculation and Display**: Calculates optimal routes and displays real-time paths, adapting dynamically to changes.
- **AR Overlays**: Displays directional arrows and markers over the camera view for intuitive navigation.
- **Transition to Indoor Navigation**: Automatically switches to indoor navigation when close to a building entrance.

### Indoor Navigation
- **QR Code Positioning**: Uses QR codes for precise indoor localization, even in GPS-restricted areas.
- **NavMesh-Based Pathfinding**: Guides users along calculated routes, avoiding obstacles within indoor spaces.
- **AR Path Visualization**: Visual overlays display the indoor path, including waypoints and directional cues.
- **Accessibility Options**: Includes accessible routing for users with mobility impairments.

### Additional Functionalities
- **Dynamic Content Updates**: Real-time updates on room availability, events, and temporary route changes.
- **Offline Support**: Basic navigation is available without an internet connection through pre-downloaded maps.
- **Personalization**: Users can save frequently visited locations and customize route preferences.

## Installation and Setup Guide

### Prerequisites
- **Flutter**: Install Flutter SDK [here](https://flutter.dev/docs/get-started/install).
- **Unity**: Install Unity (2021.2 or later) with the AR Foundation package.
- **Flutter Unity Widget**: Integrate the `flutter_unity_widget` package for Unity-Flutter communication.

### Step 1: Clone the Repository
```bash
git clone https://github.com/your-username/AR-Indoor-Outdoor-Navigation.git
cd AR-Indoor-Outdoor-Navigation
```
### Step 2: Unity Project Setup (continued)
3. **Import Flutter Unity Widget**:
   - Download `fuw.unitypackage` from the official repo and import it into Unity by selecting `Assets > Import Package > Custom Package`.
4. **Configure Build Settings in Unity**:
   - In **Project Settings > Player > Android tab**, set the following:
     - **Disable Multithreaded Rendering**
     - Set **Minimum API Level** to 28 and **Target API Level** to 32 or higher.
     - Ensure **Scripting Backend** is set to **IL2CPP** and select **ARM64** under **Target Architectures**.
   - In **Resolution and Presentation**:
     - Set **Fullscreen Mode** to **Windowed**.
     - Enable **Resizable Window** if needed.
5. **Export to Flutter**: Go to the **Flutter** tab in Unity and select **Export to Flutter (Release)** to generate the `unityLibrary`.

### Step 3: Flutter Project Configuration
1. **Configure `build.gradle`**:
   - In `android/app/build.gradle`, update **compileSdkVersion**, **minSdkVersion**, and **targetSdkVersion** to match the Unity project.
   - Set the `ndkVersion` to match Unity’s version. (Find it in **Preferences > External Tools** in Unity and locate `Pkg.Revision` in `source.properties`.)
2. **Link Unity to Flutter**:
   - In your Flutter project, add dependencies for `flutter_unity_widget` in `pubspec.yaml`.
   - Follow the `flutter_unity_widget` integration steps to complete the Unity-Flutter connection.

### Step 4: Running the App
To run the app:
1. **Build and Run on an Android or iOS Device**:
   ```bash
   flutter run
   ```
2. **Select Navigation Mode**: Once the app launches, choose between indoor or outdoor navigation modes depending on your location. 

3. **Select Destination**: Use the app's interface to choose your destination on campus or within a building.

4. **Follow AR Guidance**: The app will display AR overlays:
   - For **Outdoor Navigation**: GPS-based arrows and markers will guide you along the path.
   - For **Indoor Navigation**: Follow the AR path overlaid with directional arrows and waypoints. QR codes placed within buildings ensure precise positioning.

5. **Seamless Indoor-Outdoor Transition**: As you approach an indoor area, the app will automatically transition from GPS-based navigation to QR-based indoor positioning, keeping your path uninterrupted.

6. **Access Additional Features**:
   - **Dynamic Updates**: Real-time notifications about room availability or temporary route changes.
   - **Offline Navigation**: Access pre-downloaded maps for navigation in low-connectivity areas.
## Videos
<h3>App Demo</h3>

https://github.com/user-attachments/assets/9d36899a-2db5-4bae-9fa2-223af009f96d

<h3>Indoor Navigation Example</h3>

https://github.com/user-attachments/assets/d407b68c-b655-47c1-98c8-d6a08607df82

