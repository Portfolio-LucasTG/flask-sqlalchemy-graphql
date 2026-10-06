# Flask | SQLAlchemy | GraphQL

A hands-on Python study project that implements **the same API in both REST and GraphQL**, sharing the same domain, services and PostgreSQL database, so the two approaches can be compared side by side.

## Goal

Learn new technologies and understand, with real code, the differences between REST and GraphQL:

- number of requests needed to build the same screen
- over-fetching and under-fetching
- payload size
- effort to evolve the API (new fields, new relationships)
- error handling, validation and documentation
- the N+1 problem and DataLoader
- pagination and filtering

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Python 3.12+ |
| Web framework | Flask (application factory + Blueprints) |
| ORM | SQLAlchemy (Flask-SQLAlchemy) |
| Migrations | Alembic (Flask-Migrate) |
| Database | PostgreSQL |
| REST API | flask-smorest + marshmallow (OpenAPI/Swagger) |
| GraphQL API | Ariadne or Strawberry (TBD) |
| Testing | pytest |
| Local infra | Docker Compose |

## Architecture

REST and GraphQL are just two entry points into the same business logic:

```
REST route ──────┐
                 ├──> Service ──> Repository ──> SQLAlchemy ──> PostgreSQL
GraphQL resolver ┘
```

Neither API talks to the database directly. This keeps the REST vs GraphQL comparison fair, since only the API layer changes.

## Project Structure

```
.
├── app/
│   ├── __init__.py          # create_app() (application factory)
│   ├── config.py            # per-environment settings
│   ├── extensions.py        # db, migrate
│   ├── models/              # SQLAlchemy models
│   ├── repositories/        # data access
│   ├── services/            # business logic (shared)
│   ├── api/
│   │   ├── rest/            # blueprints, schemas and errors
│   │   └── graphql/         # schema, queries, mutations and resolvers
│   └── utils/
├── migrations/
├── tests/
├── scripts/
│   └── seed.py              # sample data
├── docker-compose.yml
├── .env.example
├── requirements.txt
├── wsgi.py
└── README.md
```

## Getting Started

> Work in progress. These steps will be updated as the project evolves.

```bash
# 1. Clone the repository
git clone <repository-url>
cd <project-folder>

# 2. Create and activate a virtual environment
python -m venv .venv
source .venv/bin/activate        # Windows: .venv\Scripts\activate

# 3. Install dependencies
pip install -r requirements.txt

# 4. Configure environment variables
cp .env.example .env

# 5. Start PostgreSQL
docker compose up -d

# 6. Apply migrations
flask db upgrade

# 7. (Optional) Seed the database with sample data
python scripts/seed.py

# 8. Run the application
flask run
```

## Endpoints

| API | URL |
|---|---|
| Health check | `GET /health` |
| REST | `/api/v1/...` |
| REST docs (Swagger) | `/api/v1/docs` |
| GraphQL | `POST /graphql` |

## Roadmap

- [ ] Initial structure: application factory, config and `/health`
- [ ] PostgreSQL with Docker Compose
- [ ] SQLAlchemy models and migrations
- [ ] REST CRUD
- [ ] Same use cases in GraphQL, reusing the services
- [ ] Pagination and filtering in both APIs
- [ ] Solve N+1 in GraphQL with DataLoader
- [ ] Automated tests (services, REST and GraphQL)
- [ ] REST vs GraphQL comparison document

## REST vs GraphQL Comparison

Findings from this study will be recorded in `docs/comparison.md` as the project evolves.

## License

TBD.
