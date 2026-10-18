# Flujo de trabajo

Este documento describe cómo se organiza el trabajo en el repositorio. Aunque el proyecto es individual, todo cambio pasa por un issue, una rama y un pull request para dejar trazabilidad de cada requisito.

## Ramas

| Rama | Uso | Se fusiona hacia |
|---|---|---|
| `main` | Versión estable. Solo recibe fusiones desde `develop` al cerrar una entrega o una semana estable. | — |
| `develop` | Integración del trabajo diario. | `main` |
| `feature/<issue>-descripcion` | Nueva funcionalidad. Ejemplo: `feature/5-reporte-web` | `develop` |
| `fix/<issue>-descripcion` | Corrección de errores. | `develop` |
| `docs/<issue>-descripcion` | Solo documentación. | `develop` |

`main` y `develop` están protegidas: no se puede hacer push directo ni borrarlas.

## Ciclo de una tarea

```bash
git switch develop
git pull
git switch -c feature/5-reporte-web
git add .
git commit -m "feat(reports): crear formulario de reporte con foto"
git push -u origin feature/5-reporte-web
gh pr create --base develop --fill
```

En la descripción del pull request se escribe `Closes #5` para que el issue se cierre al fusionar. Después de fusionar:

```bash
git switch develop
git pull
git branch -d feature/5-reporte-web
```

## Commits

Formato: `tipo(alcance): descripción en minúscula y en imperativo`

| Tipo | Uso |
|---|---|
| `feat` | Funcionalidad nueva |
| `fix` | Corrección de un error |
| `docs` | Documentación |
| `test` | Pruebas |
| `refactor` | Cambio interno sin alterar el comportamiento |
| `style` | Formato (ruff) |
| `chore` | Configuración, dependencias, tareas de mantenimiento |
| `build` | Docker, requirements |
| `ci` | GitHub Actions |

Alcances habituales: `accounts`, `geo`, `reports`, `triage`, `operations`, `notifications`, `bot`, `analytics`, `public`, `ml`, `config`, `docker`.

Ejemplos:

```
feat(geo): validar que la ubicación esté dentro de la zona piloto
fix(reports): corregir el conteo de apoyos al fusionar incidencias
test(triage): agregar pruebas del puntaje de prioridad
docs(adr): registrar la decisión 009 sobre almacenamiento de fotos
```

## Antes de abrir un pull request

```bash
ruff check .
ruff format .
pytest
```

## Versiones

Al cerrar cada entrega se fusiona `develop` en `main` y se crea una etiqueta:

```bash
git switch main
git pull
git tag -a v0.1-entrega1 -m "Entrega 1"
git push origin v0.1-entrega1
```
