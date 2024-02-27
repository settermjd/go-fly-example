-- migrate:up
INSERT INTO users(id, name, email)
VALUES (1, "Bob Hoskins", "bob@hoskins.com"),
    (2, "Dustin Hoffman", "dustin@hoffman.com");

-- migrate:down
DELETE FROM users;