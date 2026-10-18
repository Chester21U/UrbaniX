#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-}"
if [[ -z "$REPO" || "$REPO" != */* ]]; then
  echo "Uso: bash scripts/github_setup.sh USUARIO/UrbaniX"
  exit 1
fi
OWNER="${REPO%%/*}"
NAME="${REPO#*/}"

if ! gh auth status >/dev/null 2>&1; then
  echo "Primero inicia sesión: gh auth login"
  exit 1
fi

echo "== Configuración del repositorio"
gh repo edit "$REPO" \
  --description "Centro de Comando Cívico Inteligente: reporte, priorización y seguimiento de daños urbanos en San Miguel, El Salvador." \
  --add-topic django --add-topic postgis --add-topic python --add-topic civic-tech \
  --add-topic geodjango --add-topic yolov8 --add-topic el-salvador \
  --enable-issues --enable-projects --enable-wiki=false \
  --enable-merge-commit --enable-squash-merge --enable-rebase-merge=false >/dev/null
echo "Descripción, temas y opciones de fusión aplicados"

echo "== Etiquetas"
label() {
  gh label create "$1" --repo "$REPO" --color "$2" --description "$3" --force >/dev/null
  echo "  $1"
}
label "rf"                "5319E7" "Requisito funcional del documento de diseño"
label "setup"             "BFD4F2" "Configuración e infraestructura"
label "tipo:feature"      "1D76DB" "Funcionalidad nueva"
label "tipo:fix"          "D73A4A" "Corrección de errores"
label "tipo:docs"         "0075CA" "Documentación"
label "tipo:test"         "FBCA04" "Pruebas"
label "futuro"            "C5DEF5" "Fuera del alcance de la versión 1.0"
label "app:accounts"      "C2E0C6" "Usuarios y roles"
label "app:geo"           "C2E0C6" "Zonas y puntos críticos"
label "app:reports"       "C2E0C6" "Reportes, incidencias y duplicados"
label "app:triage"        "C2E0C6" "IA, prioridad y fecha límite"
label "app:operations"    "C2E0C6" "Cuadrillas y órdenes de trabajo"
label "app:notifications" "C2E0C6" "Correo y Telegram"
label "app:bot"           "C2E0C6" "Bot de Telegram"
label "app:analytics"     "C2E0C6" "Indicadores y mapas de calor"
label "app:public"        "C2E0C6" "Portal de transparencia"
label "ml"                "F9D0C4" "Dataset y modelo de clasificación"
label "infra"             "E4E669" "Docker, CI y entorno"

echo "== Hitos"
EXISTING_MILESTONES=$(gh api "repos/$REPO/milestones?state=all&per_page=100" --jq '.[].title')
milestone() {
  local title="$1" due="$2" desc="$3"
  if grep -Fxq "$title" <<<"$EXISTING_MILESTONES"; then
    echo "  ya existe: $title"
    return
  fi
  local args=(-f "title=$title" -f "description=$desc")
  [[ -n "$due" ]] && args+=(-f "due_on=$due")
  gh api "repos/$REPO/milestones" "${args[@]}" >/dev/null
  echo "  $title"
}
milestone "Entrega 1"          "2026-11-15T12:00:00Z" "Informe de diseño, repositorio y prototipo: RF-01 a RF-08"
milestone "Entrega 2"          "2026-11-29T12:00:00Z" "Versión casi completa con manejo de errores y pruebas: RF-09 a RF-19"
milestone "Feria"              "2026-12-01T12:00:00Z" "Datos semilla, guion de demo y afiche"
milestone "Presentación final" ""                     "Demo en vivo, manual de usuario, documentación final y v1.0"

echo "== Issues"
EXISTING_ISSUES=$(gh issue list --repo "$REPO" --state all --limit 500 --json title --jq '.[].title')
issue() {
  local title="$1" ms="$2" labels="$3" body="$4"
  if grep -Fxq "$title" <<<"$EXISTING_ISSUES"; then
    echo "  ya existe: $title"
    return
  fi
  local args=(--repo "$REPO" --title "$title" --label "$labels" --body "$body")
  [[ -n "$ms" ]] && args+=(--milestone "$ms")
  gh issue create "${args[@]}" >/dev/null
  echo "  $title"
}

criteria() {
  printf '%s\n\n**Rol:** %s\n\n### Criterios de aceptación\n%s\n- [ ] Validaciones y manejo de errores\n- [ ] Pruebas con pytest\n- [ ] Documentación actualizada\n' "$1" "$2" "$3"
}

rf() {
  local id="$1" short="$2" long="$3" rol="$4" ms="$5" labels="$6" checks="$7"
  issue "$id · $short" "$ms" "rf,$labels" "$(criteria "$long" "$rol" "$checks")"
}

task() {
  local id="$1" short="$2" ms="$3" labels="$4" checks="$5"
  issue "$id · $short" "$ms" "$labels" "$(printf '### Tareas\n%s\n' "$checks")"
}

task "SETUP-01" "Repositorio, ramas, protección y tablero" "Entrega 1" "setup,infra" \
"- [ ] Repositorio público con README, licencia y .gitignore
- [ ] Ramas main y develop protegidas
- [ ] Etiquetas, hitos e issues creados
- [ ] Tablero de GitHub Projects vinculado
- [ ] Enlace publicado en el foro"

task "SETUP-02" "Docker Compose con PostGIS y Redis" "Entrega 1" "setup,infra" \
"- [ ] Dockerfile con GDAL y GEOS
- [ ] Servicios web, db, redis, worker y beat
- [ ] Volúmenes para la base de datos y media
- [ ] docker compose up levanta sin errores"

task "SETUP-03" "Proyecto Django con settings separados" "Entrega 1" "setup,infra" \
"- [ ] config/settings/base.py, dev.py y prod.py
- [ ] Variables de entorno con django-environ
- [ ] requirements.txt y requirements-ml.txt
- [ ] Estructura apps/ con las nueve apps
- [ ] Configuración de Celery"

task "SETUP-04" "Modelos base de geo y reports con migraciones" "Entrega 1" "setup,app:geo,app:reports" \
"- [ ] Zona, Categoria y PuntoCritico
- [ ] Incidencia, Reporte, Foto e HistorialEstado
- [ ] Índices espaciales GiST
- [ ] Registro en el admin"

task "SETUP-05" "README con instalación probada (Docker y venv)" "Entrega 1" "tipo:docs" \
"- [ ] Instalación con Docker paso a paso
- [ ] Instalación con entorno virtual paso a paso
- [ ] Variables de entorno explicadas
- [ ] Probado desde un clon limpio"

task "ML-01" "Recolectar y organizar el dataset de imágenes" "Entrega 2" "ml" \
"- [ ] Descargar datasets públicos (Kaggle, Roboflow Universe)
- [ ] Tomar fotos propias en San Miguel
- [ ] Organizar por las seis categorías
- [ ] División 70/15/15
- [ ] Documentar fuentes y licencias de cada dataset"

task "DOC-01" "Informe de diseño de la Entrega 1" "Entrega 1" "tipo:docs" \
"- [ ] Actualizar el documento inicial v0.1 a trabajo individual
- [ ] Agregar capturas del prototipo
- [ ] docs/arquitectura.md
- [ ] Revisar ADR"

rf "RF-01" "Registro e inicio de sesión con roles" \
"Registro, inicio de sesión y recuperación de contraseña con roles." "Todos" "Entrega 1" "tipo:feature,app:accounts" \
"- [ ] Usuario personalizado con email único
- [ ] Roles: ciudadano, operador, cuadrilla y administrador
- [ ] Recuperación de contraseña por correo"

rf "RF-02" "Reporte web con foto y ubicación" \
"Crear reporte web con foto, categoría, descripción y ubicación GPS o seleccionada en el mapa." "Ciudadano" "Entrega 1" "tipo:feature,app:reports" \
"- [ ] Formulario adaptado a móvil
- [ ] Ubicación por GPS o selección en el mapa
- [ ] Código de seguimiento con formato UX-AAAA-000000"

rf "RF-03" "Validación de imagen y zona piloto" \
"Validar la imagen (formato JPG/PNG, máximo 5 MB) y que la ubicación esté dentro de la zona piloto." "Sistema" "Entrega 1" "tipo:feature,app:reports,app:geo" \
"- [ ] Rechazo de formatos no permitidos y archivos mayores a 5 MB
- [ ] Rechazo de ubicaciones fuera del polígono de la zona"

rf "RF-04" "Historial de reportes del ciudadano" \
"Consultar el historial de reportes propios con su estado y código de seguimiento." "Ciudadano" "Entrega 1" "tipo:feature,app:reports" \
"- [ ] Lista con estado y código
- [ ] Solo muestra los reportes del usuario autenticado"

rf "RF-05" "Mapa del Centro de Comando con filtros" \
"Mapa del Centro de Comando con filtros por estado, categoría, prioridad, zona y fechas." "Operador" "Entrega 1" "tipo:feature,app:reports" \
"- [ ] Endpoint GeoJSON /api/v1/incidencias/
- [ ] Mapa Leaflet con marcadores por categoría
- [ ] Filtros combinables"

rf "RF-06" "Cambio de estado con historial auditado" \
"Cambiar el estado de una incidencia dejando registro auditado (quién, cuándo, comentario)." "Operador" "Entrega 1" "tipo:feature,app:reports" \
"- [ ] Solo transiciones válidas del ciclo de vida
- [ ] Registro en HistorialEstado"

rf "RF-07" "Detección y agrupación de duplicados" \
"Detectar y agrupar reportes duplicados por cercanía (30 m) y categoría." "Sistema" "Entrega 1" "tipo:feature,app:reports" \
"- [ ] Consulta ST_DWithin a 30 m, misma categoría, últimos 30 días
- [ ] Incremento de apoyos
- [ ] Fusión y separación manual por el operador"

rf "RF-08" "Administración de catálogos y parámetros" \
"Administrar categorías, zonas, puntos críticos y tiempos límite." "Administrador" "Entrega 1" "tipo:feature,app:geo" \
"- [ ] Admin de Django configurado para cada catálogo
- [ ] Carga de polígonos de zona y puntos críticos"

rf "RF-09" "Reportes por bot de Telegram" \
"Recibir reportes por bot de Telegram (foto + ubicación) y responder con el código de seguimiento." "Ciudadano" "Entrega 2" "tipo:feature,app:bot" \
"- [ ] Conversación para pedir foto, ubicación y categoría
- [ ] Webhook protegido con token secreto
- [ ] Modo polling para desarrollo"

rf "RF-10" "Clasificación automática con IA" \
"Clasificar automáticamente la foto con IA y guardar categoría predicha y confianza." "Sistema" "Entrega 2" "tipo:feature,app:triage,ml" \
"- [ ] Inferencia en el worker de Celery
- [ ] Revisión manual si la confianza es menor a 0.60 o contradice la categoría elegida
- [ ] F1 macro ≥ 0.80 en el conjunto de prueba"

rf "RF-11" "Cálculo de prioridad y fecha límite" \
"Calcular prioridad y fecha límite automáticamente al crear o actualizar una incidencia." "Sistema" "Entrega 2" "tipo:feature,app:triage" \
"- [ ] Fórmula con pesos configurables
- [ ] Niveles Alta, Media y Baja con su tiempo límite"

rf "RF-12" "Cuadrillas y órdenes de trabajo con evidencia" \
"Gestionar cuadrillas y órdenes de trabajo; subir evidencia del antes y el después." "Operador / Cuadrilla" "Entrega 2" "tipo:feature,app:operations" \
"- [ ] Asignación de órdenes por el operador
- [ ] Vista móvil de la cuadrilla
- [ ] Fotos antes y después"

rf "RF-13" "Notificaciones por correo y Telegram" \
"Notificar al ciudadano por correo o Telegram cada cambio de estado." "Sistema" "Entrega 2" "tipo:feature,app:notifications" \
"- [ ] Envío asíncrono con reintentos
- [ ] Registro de envíos y errores"

rf "RF-14" "Escalamiento de casos vencidos" \
"Escalar al supervisor los casos que superan su fecha límite." "Sistema" "Entrega 2" "tipo:feature,app:triage" \
"- [ ] Tarea periódica en Celery Beat
- [ ] Cierre automático a las 72 h sin respuesta del ciudadano"

rf "RF-15" "Panel analítico" \
"Panel analítico: mapa de calor, tiempos promedio, cumplimiento de plazos, zonas reincidentes." "Operador" "Entrega 2" "tipo:feature,app:analytics" \
"- [ ] Mapa de calor con Leaflet.heat
- [ ] Indicadores calculados con pandas
- [ ] Gráficos con Chart.js"

rf "RF-16" "Portal público de transparencia" \
"Portal público de transparencia con mapa y estadísticas agregadas." "Visitante" "Entrega 2" "tipo:feature,app:public" \
"- [ ] Sin nombres, correos ni teléfonos
- [ ] Solo fotos difuminadas"

rf "RF-17" "Difuminado de rostros" \
"Difuminar rostros en las fotos antes de mostrarlas públicamente." "Sistema" "Entrega 2" "tipo:feature,app:reports,ml" \
"- [ ] Detección con YuNet y desenfoque gaussiano
- [ ] Versión original y versión pública de cada foto"

rf "RF-18" "Confirmación ciudadana y reapertura" \
"Confirmación ciudadana de la reparación y reapertura si no se reparó." "Ciudadano" "Entrega 2" "tipo:feature,app:reports" \
"- [ ] Confirmar o reabrir desde web y Telegram"

rf "RF-19" "Moderación de reportes" \
"Moderación: marcar reportes falsos y limitar reportes por usuario por día." "Operador / Sistema" "Entrega 2" "tipo:feature,app:reports" \
"- [ ] Marcado como falso por el operador
- [ ] Límite diario configurable"

rf "RF-20" "Exportación a CSV y PDF" \
"Exportar reportes a CSV y PDF para la jefatura." "Operador" "" "tipo:feature,app:analytics,futuro" \
"- [ ] Exportación CSV con filtros
- [ ] Exportación PDF"

echo "== Protección de main y develop"
if gh api "repos/$REPO/rulesets" --jq '.[].name' 2>/dev/null | grep -Fxq "Ramas protegidas"; then
  echo "  ya existe"
elif gh api "repos/$REPO/rulesets" --method POST --input - >/dev/null 2>&1 <<'JSON'
{
  "name": "Ramas protegidas",
  "target": "branch",
  "enforcement": "active",
  "conditions": {"ref_name": {"include": ["refs/heads/main", "refs/heads/develop"], "exclude": []}},
  "rules": [
    {"type": "deletion"},
    {"type": "non_fast_forward"},
    {"type": "pull_request", "parameters": {
      "required_approving_review_count": 0,
      "dismiss_stale_reviews_on_push": false,
      "require_code_owner_review": false,
      "require_last_push_approval": false,
      "required_review_thread_resolution": false
    }}
  ]
}
JSON
then
  echo "  main y develop solo aceptan cambios por pull request"
else
  echo "  No se pudo crear la regla. Si el repositorio es privado con plan gratuito, hazlo público y vuelve a ejecutar."
fi

echo "== Tablero de GitHub Projects"
setup_project() {
  local number
  number=$(gh project list --owner "$OWNER" --format json --jq '.projects[] | select(.title=="UrbaniX") | .number' 2>/dev/null) || return 1
  if [[ -z "$number" ]]; then
    number=$(gh project create --owner "$OWNER" --title "UrbaniX" --format json --jq '.number') || return 1
  fi
  gh project link "$number" --owner "$OWNER" --repo "$NAME" >/dev/null 2>&1 || true
  local url
  while IFS= read -r url; do
    [[ -n "$url" ]] && gh project item-add "$number" --owner "$OWNER" --url "$url" >/dev/null
  done < <(gh issue list --repo "$REPO" --state open --limit 500 --json url --jq '.[].url')
  echo "  https://github.com/users/$OWNER/projects/$number"
}
if ! setup_project; then
  echo "  Falta el permiso de proyectos. Ejecuta: gh auth refresh -s project"
  echo "  Luego vuelve a correr este script; lo ya creado no se duplica."
fi

echo "== Listo: https://github.com/$REPO"
