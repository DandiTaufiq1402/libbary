plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle Plugin harus setelah Android & Kotlin plugin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.libbary"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.libbary"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Signing sementara pakai debug
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    implementation("androidx.fragment:fragment-ktx:1.6.2")
}

flutter {
    source = "../.."
}