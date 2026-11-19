"""Crear un bundle Git con cuatro hitos sin escribir en .git del proyecto.

No publica en GitHub. Los autores corresponden a los correos autorizados
por el usuario; los hitos agrupan el trabajo asistido de esta sesión.
"""
from pathlib import Path
import os
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
metadata = Path(tempfile.mkdtemp(prefix='mn-git-history-')) / 'metadata'
env = os.environ.copy()
env['GIT_DIR'] = str(metadata)
env['GIT_WORK_TREE'] = str(ROOT)
env['GIT_CONFIG_NOSYSTEM'] = '1'


def git(*args, author=None):
    local = env.copy()
    if author:
        name, email = author
        local.update(GIT_AUTHOR_NAME=name, GIT_AUTHOR_EMAIL=email,
                     GIT_COMMITTER_NAME=name, GIT_COMMITTER_EMAIL=email)
    return subprocess.check_output(['git', '-c', 'core.autocrlf=false', *args],
                                   cwd=ROOT, env=local, text=True, encoding='utf-8')


git('init', '-b', 'main')
git('remote', 'add', 'origin',
    'https://github.com/ChipanaGerman/analisis-metodos-numericos-MATLAB.git')
stages = [
    ('German Arturo Chipana Jeronimo', 'gchipanaj@unsa.edu.pe',
     'docs: definir alcance, equipo y requisitos del trabajo',
     ['README.md', '.gitignore', '.gitattributes', 'data/README.md',
      'results/README.md', 'docs/REQUISITOS.md']),
    ('Santiago Enrique Palma Apaza', 'spalmaa@unsa.edu.pe',
     'feat: implementar metodos numericos con controles de entrada',
     [str(p.relative_to(ROOT)).replace('\\', '/')
      for p in sorted((ROOT / 'src').glob('mn_*.m'))]),
    ('Giovanni Patrick Mejia Rondan', 'gmejiar@unsa.edu.pe',
     'feat: integrar datos OWID, analisis y pruebas de soluciones conocidas',
     ['main.m', 'src/acquire_data.m', 'src/load_series.m', 'src/sha256_file.m',
      'src/analyze_series.m', 'src/export_results.m', 'tests/run_tests.m']),
    ('Leonardo Juan Jose Baca Calsin', 'lbacac@unsa.edu.pe',
     'docs: preparar metodologia, informe, defensa y validacion automatizada',
     ['docs/METODOLOGIA.md', 'docs/INFORME.md', 'docs/EXPOSICION.md',
      'docs/ESTADO.md', '.github/workflows/matlab.yml',
      'scripts/publicar.ps1', 'scripts/check_project.py', 'scripts/build_history.py']),
]
for name, email, message, paths in stages:
    git('add', '--', *paths)
    git('commit', '-m', message, author=(name, email))
bundle = ROOT / 'historial.bundle'
if bundle.exists():
    raise RuntimeError('El bundle ya existe; no se sobrescribe un historial anterior.')
git('bundle', 'create', str(bundle), 'main')
git('bundle', 'verify', str(bundle))
print(git('log', '--reverse', '--format=%h | %an <%ae> | %s'))
print('Bundle creado y verificado:', bundle)
