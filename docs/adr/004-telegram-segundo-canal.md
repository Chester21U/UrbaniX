# ADR-004: Telegram como segundo canal

- **Estado:** Aceptada
- **Fecha:** 2026-10-17

## Contexto

Además de la web, se quiere un canal de mensajería para que el ciudadano reporte sin abrir el navegador y reciba notificaciones.

## Decisión

Usar la Bot API de Telegram mediante webhook (y polling en desarrollo).

## Alternativas consideradas

| Alternativa | Por qué se descartó |
|---|---|
| WhatsApp Business API | Exige verificación de empresa y tiene costo por conversación. |
| SMS | Costo por mensaje y no admite fotos de forma práctica. |

## Consecuencias

- Gratuito y fácil de probar desde el primer día.
- Menor penetración que WhatsApp en El Salvador; WhatsApp queda en la hoja de ruta (v1.2).
- El webhook requiere HTTPS público; en la demo se usa polling o un túnel temporal.
