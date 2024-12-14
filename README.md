# MedMinder
Senior Project

Objective:
To create a friendly and easy to use medication reminder mobile application.

Features:
Medication reminders and notifications
Prescription Information

Link to github:
https://github.com/Ruben725/MedMinder

Download Links:
Flutter: https://docs.flutter.dev/get-started/install?gad_source=1&gclid=CjwKCAiAjeW6BhBAEiwAdKltMtREmGqXc5ZARzsaWHRev1YZsBijhhZ1XjyCgWjaxW0Lghen9HUJGBoCgcIQAvD_BwE&gclsrc=aw.ds

Android Studio: https://developer.android.com/studio/archive 
(Make sure it is Android Studio Hedgehog | 2023.1.1 November 30, 2023 for compatibility)

https://www.oracle.com/java/technologies/downloads/?er=221886 
(Java needs to be 17 or below, Java 8 is recommended for guaranteed compatibility)

**Instructions to run MedMinder:**
VS code was used so install the flutter and dart extensions. Make sure the android studio downloaded is the one listed above since newer versions may not be compatible since they automatically have java 21 built in which may cause issues even if you have correct java installed. Java 17 and below should be compatible with our project but to guarantee it working with no issues java 8 is recommended. If you already have for example java 11, you would have to go into the build.gradle file in android/app and make sure to change the numbers in the following code section to match your java to look like this:
    
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_11
        targetCompatibility JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = '11'
    }

Configure Android Studio:
In android studio go to settings and then go to Android SDK to make sure the SDK and tools are installed. The android tool chain must be version 34 at least. While in android studio go to tools and AVD manager to create a new virtual device which is the emulator we will be using.

Final step in VS Code:
Once all of these things have been done you can go into VS Code and beginning running MedMinder. To start off, run the command: flutter pub get. This makes sure that all dependencies are downloaded. Make sure these commands are run in the VS Code terminal. Next, in the bottom right corner you can select a device. This is where you select the emulator that you set up in android studio. The emulator should be booting up, it may take a while to load the first time. After it is up you can run the command: flutter run. Now as soon as the build is complete, MedMinder will start botting up on the emulator.
