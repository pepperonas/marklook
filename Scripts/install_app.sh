#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Build first if not already built
if [ ! -d "${ROOT_DIR}/build/MarkLook.app" ]; then
    "${SCRIPT_DIR}/build_app.sh" release
fi

DEST_DIR="/Applications"
if [ ! -w "${DEST_DIR}" ]; then
    DEST_DIR="${HOME}/Applications"
    mkdir -p "${DEST_DIR}"
fi

TARGET_APP="${DEST_DIR}/MarkLook.app"
EXT_BUNDLE="${TARGET_APP}/Contents/PlugIns/MarkLookPreview.appex"

echo "==> Installing MarkLook to ${TARGET_APP}..."
rm -rf "${TARGET_APP}"
cp -R "${ROOT_DIR}/build/MarkLook.app" "${TARGET_APP}"

# Resign at target destination to ensure validity
codesign --force --sign - \
    --entitlements "${ROOT_DIR}/Sources/MarkLookPreview/Resources/MarkLookPreview.entitlements" \
    --timestamp=none "${EXT_BUNDLE}"
codesign --force --sign - \
    --entitlements "${ROOT_DIR}/Sources/MarkLook/Resources/MarkLook.entitlements" \
    --timestamp=none "${TARGET_APP}"

echo "==> Registering with LaunchServices & pluginkit..."
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "${TARGET_APP}"
pluginkit -a "${EXT_BUNDLE}"
pluginkit -e use -i io.celox.marklook.preview

echo "==> Reloading Quick Look daemon generators..."
qlmanage -r
qlmanage -r cache

echo ""
echo "✔ MarkLook installed successfully to ${TARGET_APP}!"
echo "  To test, select any .md file in Finder and press Space."
