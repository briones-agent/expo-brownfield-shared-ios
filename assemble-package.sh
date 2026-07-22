#!/bin/bash
# Assemble the publishable Swift Package at the repo root from the brownfield
# build output. Dereferences symlinked deps, adds the omitted ExpoModulesJSI,
# and regenerates a clean deduped Package.swift.
set -e
cd "$(dirname "$0")"
SRC="artifacts/ExpoBrownfieldPackage-release"
[ -d "$SRC/xcframeworks" ] || { echo "No build output at $SRC"; exit 1; }

echo "→ copying xcframeworks (dereferencing symlinks)"
rm -rf xcframeworks
cp -RL "$SRC/xcframeworks" xcframeworks

if [ ! -d xcframeworks/ExpoModulesJSI.xcframework ]; then
  echo "→ adding omitted ExpoModulesJSI.xcframework"
  cp -RL node_modules/expo-modules-jsi/apple/Products/ExpoModulesJSI.xcframework xcframeworks/
fi

echo "→ stripping dSYMs/BCSymbolMaps (not needed to consume; keeps files < GitHub 100MB limit)"
find xcframeworks \( -name "dSYMs" -o -name "BCSymbolMaps" \) -type d -exec rm -rf {} + 2>/dev/null || true

echo "→ stripping non-iOS slices (maccatalyst/macos/tvos/xros) to shrink the package"
python3 -c "
import plistlib, glob, os, shutil
KEEP={'ios-arm64','ios-arm64_x86_64-simulator'}
for pl in glob.glob('xcframeworks/*.xcframework/Info.plist'):
    base=os.path.dirname(pl)
    with open(pl,'rb') as f: d=plistlib.load(f)
    libs=d.get('AvailableLibraries',[])
    drop=[l for l in libs if l.get('LibraryIdentifier') not in KEEP]
    for l in drop:
        p=os.path.join(base,l['LibraryIdentifier'])
        if os.path.isdir(p): shutil.rmtree(p)
    if drop:
        d['AvailableLibraries']=[l for l in libs if l.get('LibraryIdentifier') in KEEP]
        with open(pl,'wb') as f: plistlib.dump(d,f)
"
echo "→ removing xcframework-level code signatures (invalidated by slice/plist edits; unsigned is fine for local SPM)"
rm -rf xcframeworks/*/_CodeSignature

echo "→ removing dangling DebugSymbolsPath from xcframework Info.plists (dSYMs stripped)"
python3 -c "
import plistlib, glob
for pl in glob.glob('xcframeworks/*.xcframework/Info.plist'):
    with open(pl,'rb') as f: d=plistlib.load(f)
    ch=False
    for lib in d.get('AvailableLibraries',[]):
        if lib.pop('DebugSymbolsPath', None) is not None: ch=True
    if ch:
        with open(pl,'wb') as f: plistlib.dump(d,f)
"

echo "→ regenerating Package.swift"
node generate_package.js

echo "→ validating manifest"
swift package dump-package >/dev/null && echo "manifest OK"

echo "→ largest file check (GitHub 100MB limit)"
find xcframeworks -type f -size +95M -exec echo "  WARNING large: {}" \;
du -sh xcframeworks
