<#
  Creates the project issues with the GitHub CLI and adds them to the GitHub Project.

  Before running:
    1. Install the GitHub CLI: https://cli.github.com
    2. gh auth login
    3. gh auth refresh -s project      (permission to manage Projects)
    4. Create the repository on GitHub and edit the variables below.

  Run:
    .\create-issues.ps1             # creates everything
    .\create-issues.ps1 -DryRun     # only prints what would be created
#>

param(
    [switch]$DryRun
)

# ---------- SAFETY GUARD ----------
Write-Host "WARNING: be careful when running this script!" -ForegroundColor Yellow
Write-Host "It creates 8 labels and 8 issues in the GitHub repository and adds them to the GitHub Project."
Write-Host "Running it twice will create DUPLICATE issues."
Write-Host "To run it, comment out or remove the 'exit' line right below this message.`n"
exit
# ----------------------------------

# ---------- EDIT THESE ----------
$Owner         = "Portfolio-LucasTG"
$Repo          = "flask-sqlalchemy-graphql"
$ProjectNumber = 1    # the number at the end of github.com/orgs/<org>/projects/<number>
# --------------------------------

$FullRepo = "$Owner/$Repo"

$Labels = @(
    @{ Name = "setup";      Color = "0e8a16" },
    @{ Name = "database";   Color = "5319e7" },
    @{ Name = "rest";       Color = "1d76db" },
    @{ Name = "graphql";    Color = "e535ab" },
    @{ Name = "testing";    Color = "fbca04" },
    @{ Name = "ci";         Color = "bfd4f2" },
    @{ Name = "comparison"; Color = "d93f0b" },
    @{ Name = "docs";       Color = "0075ca" }
)

$Issues = @(
    @{
        Title  = "Project setup and infrastructure"
        Labels = "setup"
        Body   = @'
Set up the foundation of the project.

- [ ] Application factory (`create_app()`), config and extensions
- [ ] Docker Compose with PostgreSQL
- [ ] `/health` endpoint (including database check)
- [ ] Linting/formatting (Ruff) and pre-commit
- [ ] pytest setup with a separate test database
'@
    },
    @{
        Title  = "Database layer"
        Labels = "database"
        Body   = @'
Model the domain and build the data access layer.

- [ ] SQLAlchemy models (`User`, `Post`, `Category`, `Comment`)
- [ ] Alembic migrations (Flask-Migrate)
- [ ] Repositories
- [ ] Services (business logic shared by REST and GraphQL)
- [ ] Seed script (`scripts/seed.py`)
'@
    },
    @{
        Title  = "REST API"
        Labels = "rest"
        Body   = @'
Implement the REST API on top of the shared services.

- [ ] CRUD endpoints for all resources (`/api/v1/...`)
- [ ] Pagination, filtering and sorting
- [ ] Validation and standardized error handling
- [ ] OpenAPI/Swagger docs at `/api/v1/docs`
'@
    },
    @{
        Title  = "GraphQL API"
        Labels = "graphql"
        Body   = @'
Implement the GraphQL API reusing the same services as REST.

- [ ] Choose the library (Ariadne vs Strawberry) and record the decision in `docs/`
- [ ] Schema, queries and mutations at `/graphql`
- [ ] Pagination and filtering
- [ ] Reproduce and fix the N+1 problem with DataLoader
- [ ] Standardized error handling
'@
    },
    @{
        Title  = "Automated tests"
        Labels = "testing"
        Body   = @'
Cover the project with automated tests.

- [ ] Service unit tests
- [ ] REST integration tests
- [ ] GraphQL integration tests
'@
    },
    @{
        Title  = "CI with GitHub Actions"
        Labels = "ci"
        Body   = @'
Automate quality checks.

- [ ] Run lint and tests on every push and pull request
- [ ] Add a status badge to the README
'@
    },
    @{
        Title  = "REST vs GraphQL comparison"
        Labels = "comparison"
        Body   = @'
The main goal of the study: compare both approaches with real data.

- [ ] Define comparison scenarios (e.g. "post with author and categories")
- [ ] Measure number of requests, payload size and response time per scenario
- [ ] Write `docs/comparison.md` with findings and conclusions
'@
    },
    @{
        Title  = "Documentation and polish"
        Labels = "docs"
        Body   = @'
Final touches to make the repository portfolio-ready.

- [ ] Final README with usage examples (curl and GraphQL queries)
- [ ] Optional: JWT authentication in both APIs
'@
    }
)

if ($DryRun) {
    Write-Host "DRY RUN - nothing will be created in $FullRepo`n"
    foreach ($issue in $Issues) { Write-Host "[$($issue.Labels)] $($issue.Title)" }
    return
}

Write-Host "Creating labels in $FullRepo..."
foreach ($label in $Labels) {
    gh label create $label.Name --color $label.Color --repo $FullRepo --force | Out-Null
}

foreach ($issue in $Issues) {
    $bodyFile = New-TemporaryFile
    Set-Content -Path $bodyFile -Value $issue.Body -Encoding utf8

    $url = gh issue create --repo $FullRepo --title $issue.Title --body-file $bodyFile --label $issue.Labels
    Remove-Item $bodyFile

    if (-not $url) {
        Write-Warning "Failed to create issue: $($issue.Title)"
        continue
    }

    gh project item-add $ProjectNumber --owner $Owner --url $url | Out-Null
    Write-Host "Created and added to project: $($issue.Title) -> $url"
}

Write-Host "`nDone."
