#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

BUILD_CONFIG="${1:-release}"
echo "==> Building MarkLook (${BUILD_CONFIG})..."

cd "${ROOT_DIR}"
swift build -c "${BUILD_CONFIG}"

BIN_DIR="${ROOT_DIR}/.build/${BUILD_CONFIG}"
APP_BUNDLE="${ROOT_DIR}/build/MarkLook.app"
EXT_BUNDLE="${APP_BUNDLE}/Contents/PlugIns/MarkLookPreview.appex"

echo "==> Packaging ${APP_BUNDLE}..."
rm -rf "${ROOT_DIR}/build"
mkdir -p "${APP_BUNDLE}/Contents/MacOS"
mkdir -p "${APP_BUNDLE}/Contents/Resources"
mkdir -p "${EXT_BUNDLE}/Contents/MacOS"
mkdir -p "${EXT_BUNDLE}/Contents/Resources"

# Copy App binaries and Plists
cp "${BIN_DIR}/MarkLook" "${APP_BUNDLE}/Contents/MacOS/MarkLook"
cp "${ROOT_DIR}/Sources/MarkLook/Resources/Info.plist" "${APP_BUNDLE}/Contents/Info.plist"

# Copy Extension binaries and Plists
cp "${BIN_DIR}/MarkLookPreview" "${EXT_BUNDLE}/Contents/MacOS/MarkLookPreview"
cp "${ROOT_DIR}/Sources/MarkLookPreview/Resources/Info.plist" "${EXT_BUNDLE}/Contents/Info.plist"

# Set PkgInfo
echo -n "APPL????" > "${APP_BUNDLE}/Contents/PkgInfo"
echo -n "XPC!????" > "${EXT_BUNDLE}/Contents/PkgInfo"

echo "==> Code signing bundles with entitlements..."
# Sign Extension first
codesign --force --sign - \
    --entitlements "${ROOT_DIR}/Sources/MarkLookPreview/Resources/MarkLookPreview.entitlements" \
    --timestamp=none "${EXT_BUNDLE}"

# Sign Host App
codesign --force --sign - \
    --entitlements "${ROOT_DIR}/Sources/MarkLook/Resources/MarkLook.entitlements" \
    --timestamp=none "${APP_BUNDLE}"

echo "==> Verifying signature..."
codesign --verify --deep --strict --verbose=2 "${APP_BUNDLE}"

echo "==> Registering with LaunchServices & pluginkit..."
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "${APP_BUNDLE}" || true
pluginkit -a "${EXT_BUNDLE}" || true
pluginkit -e use -i io.celox.marklook.preview || true

echo ""
echo "✔ MarkLook.app successfully built and packaged at:"
echo "  ${APP_BUNDLE}"
echo ""
