// Regenerate a clean, deduped Package.swift from the xcframeworks/ dir.
// Product/package name is fixed so host apps have a stable dependency to add.
const fs = require('fs');
const dir = 'xcframeworks';
const names = [...new Set(
  fs.readdirSync(dir).filter(f => f.endsWith('.xcframework')).map(f => f.replace('.xcframework', ''))
)].sort();
const list = names.map(n => `"${n}"`).join(', ');
const targets = names.map(n =>
  `      .binaryTarget(\n        name: "${n}",\n        path: "xcframeworks/${n}.xcframework"\n      ),`
).join('\n');
const pkg = `// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ExpoBrownfieldPackage",
    platforms: [.iOS("16.4")],
    products: [
      .library(name: "ExpoBrownfieldPackage", targets: [${list}]),
    ],
    targets: [
${targets}
    ]
)
`;
fs.writeFileSync('Package.swift', pkg);
console.log(`Wrote Package.swift with ${names.length} targets: ${names.join(', ')}`);
