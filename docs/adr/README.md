# Registro de decisiones de diseño (ADR)

Cada decisión técnica importante se documenta en un archivo numerado con su contexto, la decisión, las alternativas descartadas y sus consecuencias. Una decisión no se borra: si cambia, se crea un ADR nuevo que la reemplaza y el anterior pasa a estado *Reemplazada*.

| # | Decisión | Estado |
|---|---|---|
| [001](001-django-como-framework.md) | Django como framework | Aceptada |
| [002](002-postgresql-postgis.md) | PostgreSQL + PostGIS | Aceptada |
| [003](003-monolito-modular-celery.md) | Monolito modular + Celery | Aceptada |
| [004](004-telegram-segundo-canal.md) | Telegram como segundo canal | Aceptada |
| [005](005-leaflet-para-mapas.md) | Leaflet para mapas | Aceptada |
| [006](006-yolov8-clasificacion.md) | YOLOv8 de clasificación | Aceptada |
| [007](007-prioridad-por-reglas.md) | Prioridad por puntaje con reglas | Aceptada |
| [008](008-reporte-e-incidencia.md) | Reporte e Incidencia como entidades separadas | Aceptada |

Para una decisión nueva, copia [`plantilla.md`](plantilla.md) con el siguiente número.
