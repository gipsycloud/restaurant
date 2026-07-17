┌─────────────────────────────────────────────────────────────┐
│                     DATABASE SCHEMA                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐       ┌──────────────┐                    │
│  │  restaurants  │       │    users     │                    │
│  ├──────────────┤       ├──────────────┤                    │
│  │ id           │       │ id           │                    │
│  │ name         │       │ name         │                    │
│  │ address      │       │ email        │                    │
│  │ phone        │       │ role         │                    │
│  │ owner_id ────┼──┐    │ restaurant_id│                    │
│  └──────────────┘  │    └──────────────┘                    │
│                    │                                        │
│  ┌──────────────┐  │    ┌──────────────┐                    │
│  │    tables    │  │    │    menus     │                    │
│  ├──────────────┤  │    ├──────────────┤                    │
│  │ id           │  │    │ id           │                    │
│  │ restaurant_id├──┘    │ restaurant_id│                    │
│  │ table_number │       │ name         │                    │
│  │ capacity     │       │ category     │                    │
│  │ status       │       │ price        │                    │
│  └──────────────┘       │ is_available │                    │
│                         └──────────────┘                    │
│  ┌──────────────┐                                           │
│  │  reservations │                                          │
│  ├──────────────┤       ┌──────────────┐                    │
│  │ id           │       │   orders     │                    │
│  │ table_id     │       ├──────────────┤                    │
│  │ customer_name│       │ id           │                    │
│  │ phone        │       │ table_id     │                    │
│  │ guest_count  │       │ reservation_id│                   │
│  │ reserved_at  │       │ status       │                    │
│  │ status       │       │ total_amount │                    │
│  └──────────────┘       │ payment_status│                   │
│                         └──────────────┘                    │
│  ┌──────────────┐           │                               │
│  │ order_items  │           │                               │
│  ├──────────────┤           │                               │
│  │ id           │           │                               │
│  │ order_id ────┼───────────┘                               │
│  │ menu_item_id │                                           │
│  │ quantity     │       ┌──────────────┐                    │
│  │ unit_price   │       │  payments    │                    │
│  │ subtotal     │       ├──────────────┤                    │
│  └──────────────┘       │ id           │                    │
│                         │ order_id     │                    │
│  ┌──────────────┐       │ method       │                    │
│  │   receipts   │       │ amount       │                    │
│  ├──────────────┤       │ status       │                    │
│  │ id           │       │ transaction_id│                   │
│  │ order_id     │       └──────────────┘                    │
│  │ pdf_url      │                                           │
│  │ generated_at │                                           │
│  └──────────────┘                                           │
│                                                              │
└─────────────────────────────────────────────────────────────┘

dine_flow/
├── app/
│   ├── controllers/
│   │   └── api/
│   │       └── v1/
│   │           ├── base_controller.rb
│   │           ├── menus_controller.rb
│   │           ├── orders_controller.rb
│   │           ├── payments_controller.rb
│   │           └── reservations_controller.rb
│   ├── jobs/
│   │   ├── application_job.rb
│   │   ├── process_order_job.rb
│   │   ├── notify_kitchen_job.rb
│   │   ├── generate_receipt_job.rb
│   │   ├── send_reservation_confirmation_job.rb
│   │   ├── cleanup_old_reservations_job.rb
│   │   └── daily_sales_report_job.rb
│   ├── models/
│   │   ├── application_record.rb
│   │   ├── restaurant.rb
│   │   ├── user.rb
│   │   ├── table.rb
│   │   ├── menu.rb
│   │   ├── order.rb
│   │   ├── order_item.rb
│   │   ├── reservation.rb
│   │   ├── payment.rb
│   │   └── receipt.rb
│   ├── pdfs/
│   │   └── receipt_pdf.rb
│   ├── services/
│   │   ├── payment_service.rb
│   │   └── report_export_service.rb
│   └── views/
├── config/
│   ├── routes.rb
│   └── sidekiq.yml
├── db/
│   ├── migrate/
│   └── seeds.rb
├── spec/
│   ├── factories/
│   ├── models/
│   └── requests/
├── Gemfile
└── README.md


┌─────────────┐       ┌─────────────────┐       ┌─────────────┐
│   orders    │       │  order_items    │       │    menus    │
├─────────────┤       ├─────────────────┤       ├─────────────┤
│ id: 1       │──────▶│ id: 1           │──────▶│ id: 10      │
│ table_id: 5 │  1:N  │ order_id: 1     │  N:1  │ name: Steak │
│ status: ... │       │ menu_id: 10     │       │ price: 18   │
└─────────────┘       │ quantity: 2     │       └─────────────┘
                      └─────────────────┘
                      │ id: 2           │──────▶│ id: 12      │
                      │ order_id: 1     │  N:1  │ name: Beer  │
                      │ menu_id: 12     │       │ price: 4    │
                      │ quantity: 3     │       └─────────────┘
                      └─────────────────┘