cmake_minimum_required(VERSION 3.10)
project(YourFlutterProject)

# Find the Flutter SDK
find_package(Flutter REQUIRED)

# Configure Firebase
set(FIREBASE_APP_NAME "YourFirebaseAppName")
set(FIREBASE_API_KEY "YourFirebaseApiKey")
set(FIREBASE_PROJECT_ID "YourFirebaseProjectId")
set(FIREBASE_DATABASE_URL "YourFirebaseDatabaseUrl")
set(FIREBASE_STORAGE_BUCKET "YourFirebaseStorageBucket")
set(FIREBASE_MESSAGING_SENDER_ID "YourFirebaseMessagingSenderId")
set(FIREBASE_APP_ID "YourFirebaseAppId")
set(FIREBASE_MEASUREMENT_ID "YourFirebaseMeasurementId")

# Add Firebase targets
add_library(flutter_firebase_app STATIC
    ${Flutter_SOURCE_DIR}/packages/firebase_core/lib/src/app.dart
    ${Flutter_SOURCE_DIR}/packages/firebase_core/lib/src/app_impl.dart
)

add_library(flutter_firebase_auth STATIC
    ${Flutter_SOURCE_DIR}/packages/firebase_auth/lib/src/auth.dart
    ${Flutter_SOURCE_DIR}/packages/firebase_auth/lib/src/auth_impl.dart
)

# Add more Firebase targets as needed (e.g., database, storage, etc.)

# Link your Flutter app to Firebase libraries
target_link_libraries(your_flutter_app
    flutter_firebase_app
    flutter_firebase_auth
    # Other Firebase libraries
)

# Set Firebase configuration options
target_compile_definitions(your_flutter_app
    PRIVATE FIREBASE_APP_NAME=${FIREBASE_APP_NAME}
    PRIVATE FIREBASE_API_KEY=${FIREBASE_API_KEY}
    PRIVATE FIREBASE_PROJECT_ID=${FIREBASE_PROJECT_ID}
    PRIVATE FIREBASE_DATABASE_URL=${FIREBASE_DATABASE_URL}
    PRIVATE FIREBASE_STORAGE_BUCKET=${FIREBASE_STORAGE_BUCKET}
    PRIVATE FIREBASE_MESSAGING_SENDER_ID=${FIREBASE_MESSAGING_SENDER_ID}
    PRIVATE FIREBASE_APP_ID=${FIREBASE_APP_ID}
    PRIVATE FIREBASE_MEASUREMENT_ID=${FIREBASE_MEASUREMENT_ID}
)