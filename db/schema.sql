CREATE TABLE IF NOT EXISTS "schema_migrations" (version varchar(128) primary key);
CREATE TABLE users (
  id integer,
  name varchar(255),
  email varchar(255) not null
);
-- Dbmate schema migrations
INSERT INTO "schema_migrations" (version) VALUES
  ('20240226054103');
