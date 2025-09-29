.PHONY: up down demo test lint migrate seed diagrams export
up:            ## Start services
\tdocker compose up -d --build
down:          ## Stop services
\tdocker compose down
migrate:       ## Apply SQL migrations
\tpsql $$PGDATABASE -h $$PGHOST -U $$PGUSER -f sql/migrations/2025-10-01_init.sql
seed:          ## Load demo data
\tpsql $$PGDATABASE -h $$PGHOST -U $$PGUSER -f sql/seeds/sample_sections.sql
diagrams:      ## Render Mermaid → PNG/SVG
\tbash tools/generate_diagrams.sh
export:        ## Export Metabase dashboards JSON
\tbash tools/export_metabase.sh
test:
\tpytest -q
lint:
\trufflehog --fail   # or flake8/ruff checks
demo: up migrate seed diagrams export
\t@echo "Demo ready: API on http://localhost:8000, Metabase on http://localhost:3000"
