# ADR-008: Reporte e Incidencia como entidades separadas

- **Estado:** Aceptada
- **Fecha:** 2026-10-17

## Contexto

Varios ciudadanos pueden reportar el mismo bache. Si cada reporte fuera un caso, el Centro de Comando tendría duplicados y no se sabría cuántas personas están afectadas.

## Decisión

Separar **Reporte** (lo que envía un ciudadano) de **Incidencia** (el daño físico real). Un reporte nuevo se asocia a una incidencia abierta de la misma categoría a menos de 30 m creada en los últimos 30 días; si no existe, se crea una incidencia nueva.

## Alternativas consideradas

| Alternativa | Por qué se descartó |
|---|---|
| Una sola tabla de tickets | Obliga a borrar o marcar duplicados y se pierde quién reportó qué. |

## Consecuencias

- Los apoyos se cuentan sin perder ningún reporte ni a su autor.
- Cada ciudadano recibe notificaciones del estado de la incidencia a la que pertenece su reporte.
- El operador puede deshacer o forzar fusiones.
