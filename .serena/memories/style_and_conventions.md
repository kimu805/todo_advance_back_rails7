# Code Style & Conventions

## Ruby/Rails Conventions
- Standard Ruby naming: snake_case for methods/variables, CamelCase for classes
- No `.rubocop.yml` found — uses default RuboCop rules
- File encoding: UTF-8
- RSpec with `--format documentation`

## Project-Specific Patterns
- **Service Objects**: Inherit from `ApplicationService`, implement `#call` instance method
  - Use `ServiceResult.success(data)` / `ServiceResult.failure(errors)` for return values
  - Params normalized via `normalize_params` (camelCase -> snake_case)
- **Controllers**: Use Jbuilder views for JSON responses
  - `tasks_all` helper renders all tasks via `all_tasks.json.jbuilder`
  - Params come in camelCase from frontend, mapped manually (e.g., `genreId` -> `genre_id`)
- **Models**: Use constants for config values (e.g., `INITIAL_STATUS`, `COPY_SUFFIX`)
  - Enum definitions use symbol syntax: `enum :priority, { low: 0, medium: 1, high: 2 }`
- **Tests**: Located in `spec/` with subdirectories mirroring `app/`
  - Models: `spec/models/`
  - Requests: `spec/requests/`
  - Services: `spec/services/`

## Task Completion Checklist
1. All tests pass (`bundle exec rspec`)
2. No RuboCop errors (`bundle exec rubocop`)
3. Rails app starts correctly
