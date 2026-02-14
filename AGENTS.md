# Project Agents Guide

This file provides guidance for AI agents working with this Ruby on Rails CRM application (Fat Free CRM).

## Communication Language

**IMPORTANT: Always respond in Russian when interacting with this project.** All communication, explanations, and comments should be in Russian.

## Build/Lint/Test Commands

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/example_spec.rb

# Run specific test within a file (by line number)
bundle exec rspec spec/models/example_spec.rb:42

# Run tests matching a pattern
bundle exec rspec spec/models/ --tag type:model

# Lint check
bundle exec rubocop

# Lint with auto-correct
bundle exec rubocop -a

# Security check (dev environment only)
bundle exec brakeman

# Run tests continuously with guard
bundle exec guard

# Default rake task (runs tests)
rake
```

## Code Style Guidelines

### General Ruby/Rails Conventions

- All source files must start with `# frozen_string_literal: true`
- Ruby version: 3.4+ (target for RuboCop)
- Follow RuboCop style guide with exceptions in `.rubocop.yml`
- Copyright header at top of files (optional for new code)

### Naming Conventions

- **Controllers**: `*Controller` (e.g., `AccountsController`)
- **Models**: `ActiveRecord::Base` subclasses, organized by namespace (entities/, users/, polymorphic/, fields/)
- **Views**: ERB templates in `app/views/`
- **Specs**: `*_spec.rb` pattern, mirroring app structure
- **Factories**: In `spec/factories/`, named after models

### Code Formatting

- Use `frozen_string_literal: true` at file start
- No line length limit (Layout/LineLength disabled)
- Empty methods should be expanded (not one-liners)
- Symbol arrays use percent style: `%i[foo bar baz]`
- String literals: Single or double quotes both acceptable
- No module length limits

### Imports and Requires

- Use `require 'spec_helper'` in spec files
- Gems managed via Bundler (Gemfile)
- Organize requires logically: stdlib, external gems, local code

### Error Handling

- Controllers use `rescue_from` for common exceptions:
  - `ActiveRecord::RecordNotFound` → `respond_to_not_found`
  - `CanCan::AccessDenied` → `respond_to_access_denied`
- Use descriptive error messages in validations
- Handle exceptions gracefully in controllers

### Testing Conventions

- RSpec with FactoryBot for test data
- Use `create(:model_name)` for FactoryBot factories
- Describe blocks for context: `describe "method_name" do`
- Use `expect(value).to eq(expected)` syntax
- Tests should be readable and self-documenting

### Database Conventions

- Use ActiveRecord migrations
- Schema info commented in model files
- Use scopes for query composition
- Validations with clear messages

### Controller Patterns

- Inherit from `ApplicationController` or appropriate base
- Use `before_action`/`after_action` filters
- `respond_with` for RESTful responses
- Private methods after public actions
- Hook system: `hook(:hook_name, self, params)`

### Model Patterns

- Associations with clear names
- Scopes for queries (`scope :name, -> { ... }`)
- Callbacks for lifecycle events
- Use `uses_user_permissions`, `acts_as_commentable`, `acts_as_taggable` patterns
- Paper trail for versioning

### View/ERB Conventions

- Bootstrap 5 for styling
- jQuery for JavaScript
- Partial templates for shared components
- Helper methods available from controllers

### File Organization

```
/app
  /assets          - CSS and JS
  /controllers     - Action controllers
  /models          - ActiveRecord models
  /views           - ERB templates
  /helpers         - View helpers
  /inputs          - Form inputs
/spec              - RSpec tests
  /factories       - FactoryBot definitions
  /support         - Test helpers
```

## Security

- Use strong parameters (`resource_params`)
- Protect from forgery (`protect_from_forgery with: :exception`)
- User permissions via CanCan
- Run `bundle exec brakeman` before committing

## Performance

- Use database indexes where needed
- N+1 queries prevention (includes, joins)
- Eager loading associations
- Background jobs for long operations
