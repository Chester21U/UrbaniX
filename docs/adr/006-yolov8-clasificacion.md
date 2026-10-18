# ADR-006: YOLOv8 de clasificación

- **Estado:** Aceptada
- **Fecha:** 2026-10-17

## Contexto

Se necesita confirmar automáticamente la categoría del daño a partir de la foto, con un dataset pequeño (público + fotos propias) y poco tiempo de entrenamiento.

## Decisión

Usar `yolov8n-cls` (ultralytics) afinado con transfer learning sobre las seis categorías. La inferencia corre solo en el worker de Celery.

## Alternativas consideradas

| Alternativa | Por qué se descartó |
|---|---|
| YOLOv8 de detección | Requiere etiquetar cajas en cada imagen; mucho más trabajo de anotación. |
| TensorFlow / Keras | Más código para el mismo resultado de transfer learning. |

## Consecuencias

- Solo se necesita una etiqueta por imagen.
- Modelo nano, liviano para inferencia en CPU.
- PyTorch es pesado; sus dependencias van en `requirements-ml.txt`.
- La estimación del tamaño del daño queda para la v2.0.
