let
  pkgs = import <nixpkgs> {
    config.allowUnfree = true;
    config.android_sdk.accept_license = true;
  };

  buildToolsVersion = "34.0.0";
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    # cmdLineToolsVersion = "14.0";
    # toolsVersion = "26.1.1";
    # platformToolsVersion = "34.0.5";
    buildToolsVersions = [ "${buildToolsVersion}" ];
    includeEmulator = false;
    # platformVersions = [ "28" "29" "30" ];
    includeSources = false;
    includeSystemImages = false;
    systemImageTypes = [ "google_apis_playstore" ];
    abiVersions = [ "armeabi-v7a" "arm64-v8a" ];
    # cmakeVersions = [ "3.10.2" ];
    includeNDK = true;
    # ndkVersions = ["22.0.7026061"];
    useGoogleAPIs = false;
    useGoogleTVAddOns = false;
    includeExtras = [
      "extras;google;gcm"
    ];
  };
in
pkgs.mkShell rec {
  ANDROID_SDK_ROOT = "${androidComposition.androidsdk}/libexec/android-sdk";
  ANDROID_NDK_ROOT = "${ANDROID_SDK_ROOT}/ndk-bundle";

  # Use the same buildToolsVersion here
  GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${ANDROID_SDK_ROOT}/build-tools/${buildToolsVersion}/aapt2";

}