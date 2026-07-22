// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ExpoBrownfieldPackage",
    platforms: [.iOS("16.4")],
    products: [
      .library(name: "ExpoBrownfieldPackage", targets: ["ExpoBrownfield", "ExpoBrownfieldKit", "ExpoFileSystem", "ExpoFont", "ExpoModulesCore", "ExpoModulesJSI", "ExpoModulesWorklets", "React", "ReactNativeDependencies", "hermesvm"]),
    ],
    targets: [
      .binaryTarget(
        name: "ExpoBrownfield",
        path: "xcframeworks/ExpoBrownfield.xcframework"
      ),
      .binaryTarget(
        name: "ExpoBrownfieldKit",
        path: "xcframeworks/ExpoBrownfieldKit.xcframework"
      ),
      .binaryTarget(
        name: "ExpoFileSystem",
        path: "xcframeworks/ExpoFileSystem.xcframework"
      ),
      .binaryTarget(
        name: "ExpoFont",
        path: "xcframeworks/ExpoFont.xcframework"
      ),
      .binaryTarget(
        name: "ExpoModulesCore",
        path: "xcframeworks/ExpoModulesCore.xcframework"
      ),
      .binaryTarget(
        name: "ExpoModulesJSI",
        path: "xcframeworks/ExpoModulesJSI.xcframework"
      ),
      .binaryTarget(
        name: "ExpoModulesWorklets",
        path: "xcframeworks/ExpoModulesWorklets.xcframework"
      ),
      .binaryTarget(
        name: "React",
        path: "xcframeworks/React.xcframework"
      ),
      .binaryTarget(
        name: "ReactNativeDependencies",
        path: "xcframeworks/ReactNativeDependencies.xcframework"
      ),
      .binaryTarget(
        name: "hermesvm",
        path: "xcframeworks/hermesvm.xcframework"
      ),
    ]
)
