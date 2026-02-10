# Suggested Commands

## Testing
```bash
bundle exec rspec                    # Run all tests
bundle exec rspec spec/models/       # Run model tests only
bundle exec rspec spec/requests/     # Run request/controller tests only
bundle exec rspec spec/services/     # Run service tests only
bundle exec rspec spec/models/task_spec.rb:10  # Run specific test at line
```

## Linting
```bash
bundle exec rubocop                  # Run linter
bundle exec rubocop -a               # Auto-correct safe offenses
bundle exec rubocop -A               # Auto-correct all offenses (including unsafe)
```

## Rails
```bash
rails s                              # Start server
rails c                              # Open console
rails db:migrate                     # Run migrations
rails db:migrate RAILS_ENV=test      # Run migrations for test DB
rails db:rollback                    # Rollback last migration
rails routes                         # Show all routes
```

## Dependencies
```bash
bundle install                       # Install gems
```

## Git (macOS/Darwin)
```bash
git status
git diff
git add <file>
git commit -m "message"
git push origin <branch>
```

## Utilities (macOS/Darwin)
```bash
ls, find, grep                       # Standard unix tools available on macOS
```
