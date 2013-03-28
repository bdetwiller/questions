CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  is_instructor INTEGER
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL
);

CREATE TABLE questions_followers (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL
);

CREATE TABLE question_replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  question_id INTEGER NOT NULL,
  parent_id INTEGER NOT NULL
);

CREATE TABLE question_actions (
  id INTEGER PRIMARY KEY,
  question_id INTEGER,
  redact INTEGER,
  close INTEGER,
  reopen INTEGER
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER,
  question_id INTEGER

);

INSERT INTO users ('fname','lname','is_instructor')
VALUES ('Bryant', 'Detwiller',0),
('Mickey', 'Mouse',0),
('Donald', 'Duck',0),
('Ned', 'Ruggeri',1),
('Ben', 'Shope',0);

INSERT INTO questions ('title','body','author_id')
VALUES ('Why', 'Why is the sky blue?',1),
('Nooo', 'Why must we learn SQL?',2),
('Help', 'Hipchat is angry at me',2);

INSERT INTO questions_followers ('user_id','question_id')
VALUES (1,1), (1,2), (2,2), (3,2), (4,2);

INSERT INTO question_likes ('user_id','question_id')
VALUES (1,1), (1,2), (2,2), (3,2), (4,2);

-- INSERT INTO question_replies ('body','question_id','parent_id')
-- VALUES ('Why', 'First question reply for one',1),
-- ('First question reply for two',2),
-- ('Second question reply for two',2);

