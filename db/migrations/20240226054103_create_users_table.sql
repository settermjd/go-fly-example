-- migrate:up
CREATE TABLE IF NOT EXISTS users (
  id integer,
  name varchar(255),
  email varchar(255) not null
);

-- migrate:down
DROP TABLE IF EXISTS users;
