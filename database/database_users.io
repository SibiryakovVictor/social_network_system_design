// Use DBML to define your database structure
// Docs: https://dbml.dbdiagram.io/docs

Table users {
  id uuid [primary key]
  created_at timestamp
  updated_at timestamp
  login text [unique]
  name text
  password_hash text
  description text
  avatar json
  location_id uuid [ref: > locations.id]
}

Table follows {
  following_user_id uuid [ref: > users.id]
  subscriber_user_id uuid [ref: > users.id]
  created_at timestamp

  indexes {
    (following_user_id, subscriber_user_id) [pk]
  }
}

Table locations {
  id uuid [primary key]
  country_code text
  country_name text
  place_code text
  place_name text

  indexes {
    (country_code, place_code) [unique]
  }
}
