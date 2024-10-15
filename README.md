# README

## Requirements

* Ruby version 3.3.1
* Rails 7.1.4
* Node v18.20.4 (LTS)
* Database postgresql

## Setup

1. Clone the repository
2. Run bundle install
3. yarn install
3. Set up the database: rails db:create db:migrate
4. Start the server: rails server

## Testing Import endpoint
 * Endpoint works by creating or updating restaurants existing restaurants based on name. To test it do
```

curl -X POST http://localhost:3000/restaurants/import \
  -H "Content-Type: application/json" \
  -d '{
  "restaurants": [
    {
      "name": "Gourmet Burger",
      "menus": [
        {
          "name": "Lunch Menu",
          "menu_items": [
            {
              "name": "Classic Burger",
              "price": 10.99
            },
            {
              "name": "Veggie Burger",
              "price": 9.99
            }
          ]
        },
        {
          "name": "Dinner Menu",
          "menu_items": [
            {
              "name": "Deluxe Burger",
              "price": 14.99
            },
            {
              "name": "Chicken Sandwich",
              "price": 12.99
            }
          ]
        }
      ]
    },
    {
      "name": "Pizza Paradise",
      "menus": [
        {
          "name": "Main Menu",
          "menu_items": [
            {
              "name": "Margherita Pizza",
              "price": 11.99
            },
            {
              "name": "Pepperoni Pizza",
              "price": 13.99
            }
          ]
        }
      ]
    }
  ]
}'
```