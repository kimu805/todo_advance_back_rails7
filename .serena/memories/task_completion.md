# What To Do When a Task is Completed

## Pre-Commit Checklist
1. **Run tests**: `bundle exec rspec` — all must pass
2. **Run linter**: `bundle exec rubocop` — no errors
3. **Verify app**: Ensure Rails app can start / no breaking changes

## Workflow (from CLAUDE.md)
1. Self-review the code changes
2. Present implementation report to user
3. Wait for user approval:
   - `yes` → commit and done
   - `fix` → address feedback, re-review
4. Commit only after explicit user approval

## Commit Style
- Use conventional commit-like messages (based on git log history)
- Branch naming: `feature/issue-N`
