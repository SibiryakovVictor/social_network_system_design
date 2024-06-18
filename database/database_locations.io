// Use DBML to define your database structure
// Docs: https://dbml.dbdiagram.io/docs

Table locations {
  id uuid [primary key]
  country_code text
  country_name text
  place_code text
  place_name text

  indexes {
    (country_code, place_code) [unique]
    (country_name, place_name) [type: RUM]
  }
}
