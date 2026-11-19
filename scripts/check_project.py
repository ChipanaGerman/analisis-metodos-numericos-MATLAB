"""Comprobaciones de integridad; no ejecutan ni validan sintaxis MATLAB."""
from pathlib import Path
import json
import re

ROOT = Path(__file__).resolve().parents[1]
EXPECTED = {
    'main.m': 'main',
    'src/acquire_data.m': 'acquire_data',
    'src/load_series.m': 'load_series',
    'src/sha256_file.m': 'sha256_file',
    'src/analyze_series.m': 'analyze_series',
    'src/export_results.m': 'export_results',
    'src/mn_gauss.m': 'mn_gauss',
    'src/mn_fit.m': 'mn_fit',
    'src/mn_predict.m': 'mn_predict',
    'src/mn_metrics.m': 'mn_metrics',
    'src/mn_linear.m': 'mn_linear',
    'src/mn_roots.m': 'mn_roots',
    'src/mn_calculus.m': 'mn_calculus',
    'tests/run_tests.m': 'run_tests',
}
for relative, name in EXPECTED.items():
    text = (ROOT / relative).read_text(encoding='utf-8')
    first = text.splitlines()[0]
    assert first.startswith('function '), relative
    assert re.search(r'\b' + name + r'\b', first), relative
    assert '\x00' not in text, relative
    assert not any(marker in text for marker in ['<<<<<<<', '=======', '>>>>>>>']), relative
    if relative.startswith('src/mn_'):
        assert name + '(' in (ROOT / 'tests/run_tests.m').read_text(encoding='utf-8'), name
workflow = (ROOT / '.github/workflows/matlab.yml').read_text(encoding='utf-8')
assert 'run_tests' in workflow and 'command: main' in workflow
assert 'actions/upload-artifact@v4' in workflow
assert 'permissions:\n  contents: read' in workflow
print(json.dumps({
    'matlab_files_checked': len(EXPECTED),
    'file_integrity': 'PASS',
    'workflow_presence': 'PASS',
    'matlab_execution': 'NOT_RUN',
    'owid_analysis': 'NOT_RUN',
}, indent=2))

