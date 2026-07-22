# expo-brownfield-shared-ios

A **shared, prebuilt [expo-brownfield](https://docs.expo.dev/brownfield/overview/) Swift Package** built once from a single Expo app (SDK **57.0.0**) and consumed by multiple native iOS host apps as a React Native screen — without each host needing Node, Yarn, or the RN build toolchain.

This repo is the reusable artifact behind a batch of brownfield integrations in [`expo/expo-brownfield-examples`](https://github.com/expo/expo-brownfield-examples): the RN screen is built once here and embedded into many unrelated native apps.

## What's here

| Path | Description |
| --- | --- |
| `Package.swift` + `xcframeworks/` | Self-contained binary Swift Package (product **`ExpoBrownfieldPackage`**, Swift module **`ExpoBrownfieldKit`**). Release flavor, `usePrecompiledModules`. Includes device + simulator slices. |
| everything else | The source Expo app it was built from (default template, SDK 57.0.0). |

## Consume it from a native iOS app

1. In Xcode: **File → Add Package Dependencies… → paste** `https://github.com/briones-agent/expo-brownfield-shared-ios` → add the **`ExpoBrownfieldPackage`** product to your app target.
2. Ensure the host target's **iOS Deployment Target is ≥ 16.4**.
3. Initialize RN once at launch, then present the screen:

```swift
import ExpoBrownfieldKit

// AppDelegate.didFinishLaunchingWithOptions:
ReactNativeHostManager.shared.initialize()

// From any UIViewController:
let vc = ReactNativeViewController(moduleName: "main")
navigationController?.pushViewController(vc, animated: true)
```

The JS bundle is embedded in the release frameworks — no Metro server needed at runtime.

## Rebuild

```sh
npm install
npx expo-brownfield build:ios --release --package ExpoBrownfieldPackage --verbose
```

Then copy `artifacts/ExpoBrownfieldPackage-release/Package.swift` + `xcframeworks/` to the repo root (dereferencing symlinked deps), and dedupe the `ExpoBrownfield` target in `Package.swift`.
