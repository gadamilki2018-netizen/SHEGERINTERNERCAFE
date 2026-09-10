# Build and install the APK without Android Studio

1. Create a GitHub account and a new repository named `cafe-manager`.
2. Upload all files in this folder to the repository, including `.github/workflows/build-apk.yml`.
3. Open the repository's **Actions** tab and select **Build Android APK**.
4. Run the workflow with **Run workflow**.
5. When it finishes, open the completed run and download the `cafe-manager-apk` artifact.
6. Extract the downloaded ZIP on your phone and open `app-release.apk`.
7. Android may ask you to allow installation from that source. Allow it, then install.

This is a release APK built from the current prototype. The business modules such as database-backed purchases, inventory, employees and reports are still planned and are not yet fully implemented in this starter.
