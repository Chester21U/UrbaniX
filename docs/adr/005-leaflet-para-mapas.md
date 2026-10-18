# ADR-005: Leaflet para mapas

- **Estado:** Aceptada
- **Fecha:** 2026-10-17

## Contexto

El Centro de Comando y el portal público necesitan mapas interactivos que se actualicen con filtros y muestren mapas de calor.

## Decisión

Usar Leaflet con Leaflet.heat en el navegador, alimentado por la API REST en formato GeoJSON.

## Alternativas consideradas

| Alternativa | Por qué se descartó |
|---|---|
| Folium | Genera HTML estático desde Python; cada cambio de filtro obliga a regenerar el mapa. |
| Google Maps | Requiere clave de API y facturación. |

## Consecuencias

- Mapas que se actualizan en tiempo real sin recargar la página.
- Gratuito, sin clave, con teselas de OpenStreetMap.
- Requiere algo de JavaScript en las plantillas.
