"""Local and CI preflight. No SDK, cloud action, account change or paid runner required."""
from pathlib import Path
import hashlib, json, plistlib, re, struct
root = Path(__file__).resolve().parent.parent
source = root / 'source'
required = ['CMakeLists.txt', '.craft.ini', '.craft.shelf', '.tag',
            '.github/workflows/.craft.ps1', 'src/gui/CMakeLists.txt',
            'src/resources/theme/systembr-cloud.icns', 'src/gui/MacOSXBundleInfo.plist']
for relative in required:
    assert (source / relative).is_file(), f'Arquivo ausente: {relative}'
plist = plistlib.loads((source / 'src/gui/MacOSXBundleInfo.plist').read_bytes())
assert plist['CFBundleDisplayName'] == 'Cloud System BR'
assert plist['CFBundleName'] == 'Cloud System BR'
branding = (source / 'OWNCLOUD.cmake').read_text(encoding='utf-8')
assert 'br.com.systembr.cloud.desktop' in branding
page = (source / 'src/gui/newwizard/pages/serverurlsetupwizardpage.cpp').read_text(encoding='utf-8')
assert 'https://cloud.systembr.com.br/' in page and 'serverUrl.isEmpty()' in page
cmake = (source / 'CMakeLists.txt').read_text(encoding='utf-8')
assert 'option(WITH_AUTO_UPDATER "WITH_AUTO_UPDATER" OFF)' in cmake
icon = (source / 'src/resources/theme/systembr-cloud.icns').read_bytes()
assert icon[:4] == b'icns' and struct.unpack('>I', icon[4:8])[0] == len(icon)
config = (source / '.craft.ini').read_text(encoding='utf-8')
assert 'CodeSigning/Enabled = False' in config
assert 'ownCloud GmbH (' not in config and 'C:/Python' not in config
workflow = (root / '.github/workflows/cloud-system-br-macos.yml').read_text(encoding='utf-8-sig')
assert '  workflow_dispatch:' in workflow
assert not re.search(r'^  (push|pull_request|schedule):', workflow, re.M)
for reference in re.findall(r'uses:\s*([^\s#]+)', workflow):
    assert reference.startswith('actions/') and re.fullmatch(r'actions/[\w-]+@[0-9a-f]{40}', reference), reference
assert 'free_quota_confirmed == true' in workflow
print(json.dumps({'status': 'preflight-passed', 'brand': 'Cloud System BR',
                  'compiled_on_macos': False, 'server': 'https://cloud.systembr.com.br/',
                  'icon_sha256': hashlib.sha256(icon).hexdigest(),
                  'automatic_build_triggers': False}, indent=2))
