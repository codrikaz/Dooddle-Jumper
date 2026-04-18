# Hoplet Bird

Flutter game project for Android and iOS.

## Android release signing

This app is already linked to a Play Console signing certificate. If Play Console says:

`You uploaded an APK or Android App Bundle that is signed with a different certificate`

then creating a new `.jks` file alone will not fix uploads for the existing Play Store app.

You have two valid options:

1. Keep using the original upload keystore that matches the app already on Play Console.
2. Request an `upload key reset` in Play Console, then sign future bundles with the new keystore.

## Create a new upload keystore

Run this from the project folder:

```powershell
& 'C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe' -genkeypair -v -keystore android\app\hoplet_bird-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Then create `android/key.properties` from [android/key.properties.example](C:/Users/codrikaz/StudioProjects/Dooddle-Jumper/android/key.properties.example) and fill in your real values.

Example:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=hoplet_bird-upload.jks
```

The Android build now supports either:

- `android/key.properties`
- environment variables: `ANDROID_STORE_FILE`, `ANDROID_STORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`

## Build the release bundle

```powershell
flutter clean
flutter pub get
flutter build appbundle --release
```

Upload this file:

`build\app\outputs\bundle\release\app-release.aab`

## If Play Console still rejects the bundle

Your app is using a different upload key than the one currently registered in Play Console. In that case:

1. Open Play Console.
2. Go to `Setup` > `App integrity`.
3. Find the `Upload key certificate`.
4. Choose the option to request an upload key reset.
5. Export the certificate from your new `.jks` and submit it to Google.

Export the certificate with:

```powershell
& 'C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe' -export -rfc -keystore android\app\hoplet_bird-upload.jks -alias upload -file upload_certificate.pem
```

After Google approves the reset, rebuild the `.aab` with the same new keystore and upload again.
