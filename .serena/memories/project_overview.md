# Project Overview: todo_advance_back_rails7

## Purpose
Todoアプリのバックエンド API サーバー。フロントエンド（別リポジトリ）からJSON APIとして利用される。

## Tech Stack
- **Ruby**: 3.2.0
- **Rails**: 7.1.x (API + Jbuilder for JSON rendering)
- **Database**: MySQL (mysql2 gem)
- **Testing**: RSpec (`rspec-rails ~> 4.0.0`)
- **CORS**: `rack-cors` gem
- **Debug**: `pry-rails`
- **Platform**: macOS (Darwin)

## Domain Models
- **Task**: name, explanation, deadline_date, status (integer), genre_id, priority (enum: low=0, medium=1, high=2)
- **Genre**: name (has_many tasks)

## Architecture & Patterns
- **Service Object Pattern**: `ApplicationService` base class with `.call(...)` class method
  - Services return `ServiceResult` (success/failure with data/errors)
  - Located in `app/services/` (namespace: `Tasks::CreateService`, `Tasks::DuplicateService`)
- **Fat Model, Skinny Controller**: Business logic in models and services
- **TDD**: Red -> Green -> Refactor cycle (stated in CLAUDE.md)
- **JSON API**: Routes default to `format: 'json'`, views use Jbuilder templates

## Key Routes
```
resources :tasks (JSON) with member routes:
  POST /tasks/:id/status  -> tasks#update_status
  POST /tasks/:id/duplicate
resources :genres
```

## Repository
- GitHub-based workflow with Issue-driven development
- Branch naming: `feature/issue-N`
- Main branch: `main`
