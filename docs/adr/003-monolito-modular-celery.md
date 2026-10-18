# ADR-003: Monolito modular + Celery

- **Estado:** Aceptada
- **Fecha:** 2026-10-17

## Contexto

Hay procesos lentos (clasificación con IA, difuminado de rostros, envío de notificaciones) que no deben bloquear la petición web, y procesos periódicos (escalamiento de casos vencidos, cierre automático). El equipo es de una persona.

## Decisión

Un solo proyecto Django dividido en apps por responsabilidad, con Celery y Redis para tareas en segundo plano y Celery Beat para tareas programadas.

## Alternativas consideradas

| Alternativa | Por qué se descartó |
|---|---|
| Microservicios | Multiplica despliegues, comunicación entre servicios y depuración para una sola persona. |
| Hilos dentro de Django | No sobreviven a reinicios, no tienen reintentos ni programación periódica. |

## Consecuencias

- Un solo código base, fácil de probar y desplegar.
- La separación por apps permite extraer un servicio más adelante si hiciera falta.
- Se agregan dos servicios al entorno (Redis y worker), cubiertos por Docker Compose.
