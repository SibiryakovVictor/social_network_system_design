// Use DBML to define your database structure
// Docs: https://dbml.dbdiagram.io/docs

Table posts {
  id uuid [primary key]
  author_user_id uuid
  created_at timestamp
  updated_at timestamp
  title text
  cover json
  description text
  content text
  location_id uuid [ref: > locations.id]
}

Table posts_by_locations_views {
  location_id uuid [pk, ref: - locations.id] // one-to-one
  posts_count int
}

Table posts_views {
  user_id uuid
  post_id uuid [ref: - posts.id]
  created_at timestamp

  indexes {
    (user_id, post_id) [pk]
  }
}

Table posts_views_counters {
  post_id uuid [pk, ref: - posts.id]
  views_count int
}

Table posts_ratings {
  user_id uuid
  post_id uuid [ref: - posts.id]
  created_at timestamp
  is_like bool

  indexes {
    (user_id, post_id) [pk]
  }
}

Table posts_ratings_counters {
  post_id uuid [pk, ref: - posts.id]
  like_count int
  dislike_count int
}

Table posts_comments {
  id uuid [primary key]
  user_id uuid
  post_id uuid [pk, ref: - posts.id]
  response_to_id uuid
  created_at timestamp
  content text
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
