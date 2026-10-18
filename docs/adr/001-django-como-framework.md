# ADR-001: Django como framework

- **Estado:** Aceptada
- **Fecha:** 2026-10-17

## Contexto

El sistema tiene cinco roles con permisos distintos, un panel de administración para categorías, zonas y parámetros, y datos geográficos. Lo desarrolla una sola persona en seis semanas.

## Decisión

Usar Django 5 con Django REST Framework para la API y GeoDjango para los campos geográficos.

## Alternativas consideradas

| Alternativa | Por qué se descartó |
|---|---|
| FastAPI | Exige armar a mano autenticación, ORM, migraciones y panel de administración. |
| Flask | Mismo problema: cada pieza es una extensión aparte que hay que integrar. |

## Consecuencias

- Usuarios, permisos, grupos, sesiones y admin vienen resueltos.
- GeoDjango integra PostGIS en el ORM.
- Django es más pesado que un microframework, lo cual no es un problema para un monolito.
