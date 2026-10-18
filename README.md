# UrbaniX — Centro de Comando Cívico Inteligente

[![CI](https://github.com/Chester21U/UrbaniX/actions/workflows/ci.yml/badge.svg)](https://github.com/Chester21U/UrbaniX/actions/workflows/ci.yml)
![Python](https://img.shields.io/badge/Python-3.12-3776AB)
![Django](https://img.shields.io/badge/Django-5-092E20)
![Estado](https://img.shields.io/badge/estado-en%20desarrollo-orange)
![Licencia](https://img.shields.io/badge/licencia-MIT-blue)

Plataforma web para reportar, priorizar y dar seguimiento a los daños en la infraestructura pública urbana de San Miguel, El Salvador: baches, fugas de agua, luminarias y tendido eléctrico, basura y alcantarillas.

> Pasar de una alcaldía que reacciona a reclamos dispersos a una que decide con datos, y de un ciudadano que denuncia sin respuesta a uno que puede ver qué pasó con su reporte.

Proyecto final de **Programación Computacional III** — Universidad Gerardo Barrios.

---

## Problema

En los distritos urbanos de San Miguel, los daños en la infraestructura pública se reportan por llamadas, redes sociales o de forma presencial. No existe un registro centralizado: los reportes se pierden o se duplican, el ciudadano no recibe seguimiento y la municipalidad no puede priorizar según la urgencia, controlar a sus cuadrillas ni detectar las zonas con daños recurrentes.

## Qué hace UrbaniX

1. El ciudadano reporta con foto y ubicación GPS (web o bot de Telegram) y recibe un código de seguimiento.
2. Un modelo de visión computacional clasifica el tipo de daño a partir de la foto.
3. Los reportes del mismo daño a menos de 30 m se agrupan en una sola incidencia.
4. Se calcula una prioridad y una fecha límite con reglas configurables.
5. El operador municipal gestiona todo desde un Centro de Comando con mapa y asigna órdenes de trabajo a cuadrillas.
6. La cuadrilla sube evidencia del antes y el después y marca el daño como reparado.
7. El ciudadano recibe notificaciones y confirma la reparación o la reabre.
8. Un portal público de transparencia muestra casos atendidos y tiempos de respuesta por zona.

## Roles

| Rol | Puede |
|---|---|
| Ciudadano | Crear reportes, ver su historial, confirmar o reabrir |
| Operador municipal | Validar, corregir, fusionar, asignar y rechazar incidencias |
| Cuadrilla | Ver sus órdenes, subir evidencia, marcar reparado |
| Administrador | Cuentas, categorías, zonas, puntos críticos y parámetros |
| Visitante | Portal público sin datos personales |

## Tecnologías

| Capa | Herramientas |
|---|---|
| Backend | Python 3.12, Django 5, Django REST Framework, GeoDjango |
| Datos | PostgreSQL 16 + PostGIS |
| Tareas asíncronas | Celery + Redis |
| Inteligencia artificial | ultralytics (YOLOv8 de clasificación), OpenCV |
| Análisis | pandas |
| Interfaz | Bootstrap 5, Leaflet + Leaflet.heat, Chart.js |
| Canales | Web adaptada a móvil, Bot API de Telegram |
| Calidad | pytest-django, coverage, ruff |
| Entorno | Docker Compose, entorno virtual (venv) |

La justificación de cada librería está en el documento de diseño y en [`docs/adr/`](docs/adr/).

## Estructura del repositorio

```
UrbaniX/
├── config/            Configuración de Django (settings por entorno, Celery)
├── apps/              accounts, geo, reports, triage, operations,
│                      notifications, bot, analytics, public
├── ml/                Entrenamiento y evaluación del clasificador
├── templates/  static/
├── docs/              Arquitectura, API, manual de usuario y ADR
├── scripts/           Datos semilla y utilidades
├── docker-compose.yml
├── requirements.txt   requirements-ml.txt
└── manage.py
```

## Instalación

> En construcción. Las instrucciones se completarán en la primera semana de desarrollo.

### Con Docker (recomendado)

```bash
git clone https://github.com/Chester21U/UrbaniX.git
cd UrbaniX
cp .env.example .env
docker compose up --build
docker compose exec web python manage.py migrate
docker compose exec web python manage.py createsuperuser
```

### Con entorno virtual

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

En Windows el entorno se activa con `.venv\Scripts\activate`. Esta opción requiere PostgreSQL con PostGIS, GDAL y GEOS instalados localmente.

## Flujo de trabajo

- `main`: versión estable, con una etiqueta por entrega.
- `develop`: integración del trabajo diario.
- `feature/<issue>-descripcion`: una rama por issue, fusionada a `develop` mediante pull request.
- Commits con [Conventional Commits](https://www.conventionalcommits.org/es/v1.0.0/).

Detalles en [CONTRIBUTING.md](CONTRIBUTING.md).

## Planificación

| Hito | Fecha | Alcance |
|---|---|---|
| Entrega 1 | 15/11/2026 | Registro con roles, reporte web con foto y GPS, Centro de Comando con mapa, estados y duplicados (RF-01 a RF-08) |
| Entrega 2 | 29/11/2026 | Telegram, IA, prioridad, cuadrillas, notificaciones, analítica, portal público y difuminado (RF-09 a RF-19) |
| Feria de software | 01/12/2026 | Demo estable con datos semilla |
| Presentación final | Semana de parciales | Demo en vivo, manual de usuario y documentación final |

El avance se sigue en el tablero de GitHub Projects del repositorio.

## Autor

| Nombre | Carnet | Rol |
|---|---|---|
| Abraham Bladimir Umanzor Vásquez | SMSS201426 | Representante y desarrollador |

Ingeniería en Sistemas y Redes Informáticas — Universidad Gerardo Barrios, El Salvador.

## Licencia

Distribuido bajo la licencia MIT. Ver [LICENSE](LICENSE).
