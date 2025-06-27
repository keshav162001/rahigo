plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter plugin after Android/Kotlin
    id("com.google.gms.google-services") // Firebase plugin
}

android {
    namespace = "com.example.travel"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" // ✅ Required for firebase_auth

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.travel"
        minSdk = 23 // ✅ Firebase Auth requires at least 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Firebase BoM (Bill of Materials)
    implementation(platform("com.google.firebase:firebase-bom:33.15.0"))

    // ✅ Firebase core services (required)
    implementation("com.google.firebase:firebase-analytics")

    // ✅ Firebase Auth (required for signup/login)
    implementation("com.google.firebase:firebase-auth")

    // (Optional) Firestore if you want to save user data:
    // implementation("com.google.firebase:firebase-firestore")
}
