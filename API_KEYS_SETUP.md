# API Keys Setup Guide

This guide explains how to set up API keys for the Estate app without exposing them to version control.

## 🔐 Security Notice

**NEVER commit API keys or sensitive configuration files to version control!**

## 📱 Setup Instructions

### Android Setup

1. **Copy the template file:**
   ```bash
   cp android/app/src/main/res/values/secrets.xml.template android/app/src/main/res/values/secrets.xml
   ```

2. **Edit the secrets.xml file:**
   - Open `android/app/src/main/res/values/secrets.xml`
   - Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual Google Maps API key
   - Add any other API keys you need

3. **Verify the file is ignored:**
   - Check that `android/app/src/main/res/values/secrets.xml` is listed in `.gitignore`
   - The file should NOT appear in `git status`

### iOS Setup

1. **Copy the template file:**
   ```bash
   cp ios/Runner/Secrets.plist.template ios/Runner/Secrets.plist
   ```

2. **Edit the Secrets.plist file:**
   - Open `ios/Runner/Secrets.plist`
   - Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with your actual Google Maps API key
   - Add any other API keys you need

3. **Verify the file is ignored:**
   - Check that `ios/Runner/Secrets.plist` is listed in `.gitignore`
   - The file should NOT appear in `git status`

### Firebase Setup

1. **Download Firebase configuration files:**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Select your project
   - Go to Project Settings > General
   - Download the configuration files:
     - `google-services.json` for Android
     - `GoogleService-Info.plist` for iOS

2. **Place the files:**
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`
   - macOS: `macos/Runner/GoogleService-Info.plist`

3. **Verify the files are ignored:**
   - These files should be listed in `.gitignore`
   - They should NOT appear in `git status`

## 🔑 Required API Keys

### Google Maps API Key
- **Purpose**: Display maps and location services
- **Where to get it**: [Google Cloud Console](https://console.cloud.google.com/)
- **Required APIs**: Maps SDK for Android/iOS, Places API

### Firebase Configuration
- **Purpose**: Authentication, database, and other Firebase services
- **Where to get it**: [Firebase Console](https://console.firebase.google.com/)

## 🚨 Important Security Notes

1. **Never commit secrets files** - They are in `.gitignore` for a reason
2. **Use different API keys** for development and production
3. **Restrict API keys** in Google Cloud Console to your app's bundle ID
4. **Monitor API usage** to detect unauthorized access
5. **Rotate keys regularly** for better security

## 🔍 Verification

After setup, verify that:

1. **Files are ignored:**
   ```bash
   git status
   ```
   The secrets files should NOT appear in the output.

2. **App works correctly:**
   - Maps display properly
   - Firebase services work
   - No API key errors in console

## 🆘 Troubleshooting

### "API key not found" errors
- Check that the secrets files exist and contain valid API keys
- Verify the file paths in the code match your actual file locations
- Ensure API keys are properly formatted (no extra spaces, quotes, etc.)

### "Permission denied" errors
- Check that your API keys have the necessary permissions
- Verify that the API keys are enabled for the required services
- Check that your app's bundle ID is authorized in Google Cloud Console

## 📞 Support

If you encounter issues:
1. Check the Firebase and Google Cloud Console documentation
2. Verify your API key permissions and restrictions
3. Test with a simple API call to isolate the issue
