#!/bin/bash
set -euo pipefail
if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "Este empacotamento precisa ser executado no macOS." >&2
  exit 2
fi
if [[ $# -ne 2 ]]; then
  echo "Uso: bash empacotar-macos.sh /caminho/owncloud.app /caminho/entrega" >&2
  exit 2
fi
APP="$1"
OUTPUT="$2"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
[[ -d "$APP/Contents/MacOS" ]] || { echo "Aplicativo compilado nao encontrado." >&2; exit 1; }
command -v macdeployqt >/dev/null || { echo "Execute dentro do ambiente Qt/Craft com macdeployqt disponivel." >&2; exit 1; }
mkdir -p "$OUTPUT"
OUTPUT="$(cd "$OUTPUT" && pwd)"
STAGE="$(mktemp -d "$OUTPUT/macos-stage.XXXXXX")"
BUNDLE="$STAGE/Cloud System BR.app"
ditto "$APP" "$BUNDLE"
macdeployqt "$BUNDLE" -qmldir="$ROOT/source/src/gui" -always-overwrite -no-strip
PLIST="$BUNDLE/Contents/Info.plist"
[[ "$(/usr/libexec/PlistBuddy -c 'Print CFBundleDisplayName' "$PLIST")" == "Cloud System BR" ]]
[[ "$(/usr/libexec/PlistBuddy -c 'Print CFBundleIdentifier' "$PLIST")" == "br.com.systembr.cloud.desktop" ]]
EXECUTABLE="$(/usr/libexec/PlistBuddy -c 'Print CFBundleExecutable' "$PLIST")"
ARCH="$(lipo -archs "$BUNDLE/Contents/MacOS/$EXECUTABLE")"
case "$ARCH" in
  arm64) SUFFIX=arm64 ;;
  x86_64) SUFFIX=intel ;;
  *) echo "Arquitetura nao homologada: $ARCH. Gerar cada arquitetura separadamente." >&2; exit 1 ;;
esac
# Ad-hoc signing supports local testing; this is not an Apple Developer ID identity/notarization.
codesign --force --deep --sign - "$BUNDLE"
codesign --verify --deep --strict --verbose=2 "$BUNDLE"
ln -s /Applications "$STAGE/Applications"
DMG="$OUTPUT/Cloud-System-BR-6.0.3.18041-macOS-$SUFFIX.dmg"
[[ ! -e "$DMG" ]] || { echo "O DMG ja existe; use outra pasta de saida para preservar a revisao anterior." >&2; exit 1; }
hdiutil create -volname "Cloud System BR" -srcfolder "$STAGE" -format UDZO "$DMG"
hdiutil verify "$DMG"
shasum -a 256 "$DMG" > "$DMG.sha256"
echo "Candidato para testes criado: $DMG"
echo "Validar login, sincronizacao e abertura em outro Mac. Assinatura Developer ID/notarizacao nao realizadas."
