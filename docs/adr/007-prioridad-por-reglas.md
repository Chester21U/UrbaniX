# ADR-007: Prioridad por puntaje con reglas

- **Estado:** Aceptada
- **Fecha:** 2026-10-17

## Contexto

La urgencia de un daño depende del contexto: un bache frente a un hospital es más urgente que uno en una calle sin salida, y eso no se ve en la foto.

## Decisión

Calcular la prioridad con un puntaje configurable desde el administrador:

```
Prioridad = 0.35·T + 0.25·A + 0.25·C + 0.15·E
```

T = severidad base de la categoría, A = apoyos, C = cercanía a punto crítico, E = antigüedad. Niveles: Alta ≥ 0.70 (48 h), Media 0.40–0.69 (7 días), Baja < 0.40 (15 días).

## Alternativas consideradas

| Alternativa | Por qué se descartó |
|---|---|
| Prioridad predicha por la IA | No ve el contexto, no hay datos etiquetados de urgencia y no es explicable. |

## Consecuencias

- Prioridad explicable y auditable: cada factor se puede mostrar al operador.
- Los pesos son una decisión de diseño que se documenta y puede ajustarse.
