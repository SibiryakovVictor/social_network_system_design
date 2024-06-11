// Use DBML to define your database structure
// Docs: https://dbml.dbdiagram.io/docs

Table users {
  id uuid [primary key]
  location_id uuid
  created_at timestamp
  updated_at timestamp
  login text [unique]
  name text
  password_hash text
  description text
  avatar json
}

Table posts {
  id uuid [primary key]
  author_user_id uuid
  location_id uuid
  created_at timestamp
  updated_at timestamp
  edited_at timestamp
  title text
  cover json
  description text
  content text
  rating json
}

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

Table posts_by_locations_views {
  location_id uuid [pk]
  posts_count int
}

Table posts_views {
  user_id uuid
  post_id uuid
  created_at timestamp

  indexes {
    (user_id, post_id) [pk]
  }
}

Table posts_ratings {
  user_id uuid
  post_id uuid
  created_at timestamp
  is_like bool

  indexes {
    (user_id, post_id) [pk]
  }
}

Table posts_ratings_counters {
  post_id uuid [pk]
  like_count int
  dislike_count int
}

Table posts_comments {
  id uuid [primary key]
  author_user_id uuid
  post_id uuid
  response_to_id uuid
  created_at timestamp
  content text
}

Table follows {
  following_user_id uuid
  subscriber_user_id uuid
  created_at timestamp

  indexes {
    (following_user_id, subscriber_user_id) [pk]
  }
}

Table chat_messages {
  id uuid [pk]
  sender_user_id uuid
  recipient_user_id uuid
  created_at timestamp
  content text
  photo json

  indexes {
    (sender_user_id, recipient_user_id) [type: btree, note: "ORDER BY created_at DESC"]
    content [type: rum]
  }
}

Table chat_dialogs {
  user_id uuid
  participant_user_id uuid
  last_chat_message_id uuid
  created_at timestamp

  indexes {
    (user_id, participant_user_id) [pk]
  }
}