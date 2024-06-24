// Use DBML to define your database structure
// Docs: https://dbml.dbdiagram.io/docs

Table chat_messages {
  id uuid [pk]
  sender_user_id uuid
  recipient_user_id uuid
  created_at timestamp
  is_viewed bool
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
  last_chat_message_id uuid [ref: > chat_messages.id]
  created_at timestamp

  indexes {
    (user_id, participant_user_id) [pk]
  }
}
