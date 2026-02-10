# Codebase Structure

```
app/
├── channels/          # ActionCable (default)
├── controllers/
│   ├── application_controller.rb
│   ├── tasks_controller.rb
│   └── genres_controller.rb
├── helpers/
├── jobs/
├── mailers/
├── models/
│   ├── application_record.rb
│   ├── task.rb         # Main model: belongs_to :genre, enum :priority
│   └── genre.rb
├── services/
│   ├── application_service.rb   # Base class with .call(...)
│   ├── service_result.rb        # Result object (success/failure)
│   └── tasks/
│       ├── base_service.rb
│       ├── create_service.rb
│       └── duplicate_service.rb
└── views/
    ├── layouts/
    └── tasks/
        └── all_tasks.json.jbuilder

config/
├── routes.rb
├── database.yml        # MySQL config
└── ...

db/
├── schema.rb           # Tables: tasks, genres, active_storage_*
├── migrate/
└── seeds.rb

spec/
├── models/task_spec.rb
├── requests/tasks_spec.rb
├── services/
│   ├── service_result_spec.rb
│   └── tasks/
│       ├── create_service_spec.rb
│       └── duplicate_service_spec.rb
├── spec_helper.rb
└── rails_helper.rb
```
