"""Validate the candidate on the macOS runner without claiming Apple notarization."""
from pathlib import Path
import hashlib, json, plistlib, subprocess, sys
root = Path(__file__).resolve().parent.parent
folder = Path(sys.argv[1]).resolve()
assert sys.platform == 'darwin', 'Esta verificacao exige macOS'
dmgs = list(folder.glob('*.dmg'))
apps = list(folder.glob('macos-stage.*/Cloud System BR.app'))
assert len(dmgs) == len(apps) == 1, 'Esperado um DMG e um bundle'
app = apps[0]
info = plistlib.loads((app / 'Contents/Info.plist').read_bytes())
assert info['CFBundleDisplayName'] == 'Cloud System BR'
assert info['CFBundleIdentifier'] == 'br.com.systembr.cloud.desktop'
icon = app / 'Contents/Resources' / info['CFBundleIconFile']
if not icon.exists() and not str(icon).endswith('.icns'):
    icon = icon.with_suffix('.icns')
assert icon.read_bytes() == (root / 'source/src/resources/theme/systembr-cloud.icns').read_bytes()
executable = app / 'Contents/MacOS' / info['CFBundleExecutable']
subprocess.run(['codesign', '--verify', '--deep', '--strict', str(app)], check=True)
subprocess.run(['hdiutil', 'verify', str(dmgs[0])], check=True)
version = subprocess.run([str(executable), '--version'], capture_output=True, text=True, timeout=30)
assert version.returncode == 0, (version.stdout, version.stderr)
assert 'Cloud System BR' in version.stdout + version.stderr
sha256 = hashlib.sha256(dmgs[0].read_bytes()).hexdigest()
assert sha256 in Path(str(dmgs[0]) + '.sha256').read_text()
report = {'status': 'macos-candidate-verified', 'version': info['CFBundleVersion'],
          'bundle_identifier': info['CFBundleIdentifier'], 'dmg': dmgs[0].name,
          'sha256': sha256, 'version_smoke_test': version.stdout + version.stderr,
          'notarized': False, 'apple_developer_id_signed': False,
          'login_and_sync_tested': False, 'finder_extension_enabled': False}
(folder / 'verificacao-macos.json').write_text(json.dumps(report, indent=2), encoding='utf-8')
(folder / 'LEIA-ME-DISTRIBUICAO.md').write_text(
    'Candidato Cloud System BR para homologacao. Assinatura ad-hoc; nao notarizado pela Apple. '
    'Antes de distribuir, testar abertura em outro Mac, login e sincronizacao. '
    'O pacote nao utiliza a assinatura do ownCloud.\n', encoding='utf-8')
print(json.dumps(report, indent=2))
