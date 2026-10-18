# ADR-002: PostgreSQL + PostGIS

- **Estado:** Aceptada
- **Fecha:** 2026-10-17

## Contexto

La detección de duplicados (mismo daño a menos de 30 m) y el cálculo de cercanía a puntos críticos (escuelas, hospitales) requieren consultas por distancia eficientes. La validación de ubicación requiere saber si un punto está dentro del polígono de la zona piloto.

## Decisión

Usar PostgreSQL 16 con la extensión PostGIS, con índices espaciales GiST y la función `ST_DWithin`.

## Alternativas consideradas

| Alternativa | Por qué se descartó |
|---|---|
| SQLite (SpatiaLite) | Soporte geográfico limitado y difícil de configurar; no apto para concurrencia del worker y la web. |
| MySQL | Funciones espaciales menos completas y peor integración con GeoDjango. |

## Consecuencias

- Consultas por distancia y contención resueltas en la base de datos con índice.
- Requiere GDAL y GEOS, difíciles de instalar en Windows; se mitiga con Docker Compose.
