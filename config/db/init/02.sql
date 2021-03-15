--
-- goadmin common tables
--

DROP TABLE IF EXISTS "articles";
DROP SEQUENCE IF EXISTS articles_id_seq;
CREATE SEQUENCE articles_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."articles" (
    "id" integer DEFAULT nextval('articles_id_seq') NOT NULL,
    "title" character varying(255),
    "url" character varying(1000),
    "created_at" timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updated_at" timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT "articles_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

DROP TABLE IF EXISTS "documents";
DROP SEQUENCE IF EXISTS documents_id_seq;
CREATE SEQUENCE documents_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."documents" (
    "id" integer DEFAULT nextval('documents_id_seq') NOT NULL,
    "year" character varying(255),
    "date" date,
    "classi_level" character varying(255),
    "category" character varying(255),
    "in_or_out" character varying(255),
    "sending_code" character varying(255),
    "ordered_number" character varying(255),
    "title" character varying(255),
    "content" character varying(255),
    "to_entity" character varying(255),
    "copy_entity" character varying(255),
    "attachment" character varying(255),
    "keyword" character varying(255),
    "work_entity" character varying(255),
    "author" character varying(255),
    "created_at" timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updated_at" timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT "documents_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

DROP TABLE IF EXISTS "flights";
DROP SEQUENCE IF EXISTS flights_id_seq;
CREATE SEQUENCE flights_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."flights" (
    "id" integer DEFAULT nextval('flights_id_seq') NOT NULL,
    "departure" character varying(255),
    "destination" character varying(255),
    "flight_duration" real DEFAULT '2.5',
    "created_at" timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updated_at" timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT "flights_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

DROP TABLE IF EXISTS "members";
DROP SEQUENCE IF EXISTS members_id_seq;
CREATE SEQUENCE members_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."members" (
    "id" integer DEFAULT nextval('members_id_seq') NOT NULL,
    "department" character varying(255),
    "name" character varying(255),
    "gender" character varying(255),
    "birthday" date,
    "etnia" character varying(255),
    "academic_background" character varying(255),
    "foreign_language" character varying(255),
    "political_role" character varying(255),
    "position_and_rank" character varying(255),
    "militant_role" character varying(255),
    "duty" character varying(255),
    "from_entity" character varying(255),
    "arriving_date" date,
    "rotating_date" date,
    "sending_entity" character varying(255),
    "conyuge_name" character varying(255),
    "conyuge_entity" character varying(255),
    "conyuge_bonus" character varying(255),
    "memo" character varying(255),
    "protocol_id" character varying(255),
    "is_active" character varying(255),
    "militant" character varying(255),
    "appraisals" character varying(255),
    "designations" character varying(255),
    "projects" character varying(255),
    "created_at" timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updated_at" timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT "members_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

DROP TABLE IF EXISTS "militants";
DROP SEQUENCE IF EXISTS militants_id_seq;
CREATE SEQUENCE militants_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."militants" (
    "id" integer DEFAULT nextval('militants_id_seq') NOT NULL,
    "admitted_at" character varying(255),
    "formalized_at" character varying(255),
    "registered_at" character varying(255),
    "transfered_at" date,
    "created_at" timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updated_at" timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT "militants_pkey" PRIMARY KEY ("id")
) WITH (oids = false);


DROP TABLE IF EXISTS "movies";
DROP SEQUENCE IF EXISTS movies_id_seq;
CREATE SEQUENCE movies_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."movies" (
    "id" integer DEFAULT nextval('movies_id_seq') NOT NULL,
    "year" character varying(255),
    "title" character varying(255),
    "subtitle" character varying(255),
    "desc" character varying(255),
    "other" character varying(255),
    "area" character varying(255),
    "tag" character varying(255),
    "star" character varying(255),
    "comment" character varying(255),
    "quote" character varying(255),
    "created_at" timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updated_at" timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT "movies_pkey" PRIMARY KEY ("id")
) WITH (oids = false);


DROP TABLE IF EXISTS "users";
DROP SEQUENCE IF EXISTS users_id_seq;
CREATE SEQUENCE users_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."users" (
    "id" integer DEFAULT nextval('users_id_seq') NOT NULL,
    "name" character varying(255),
    "password" character varying(255),
    "email" character varying(255),
    "created_at" timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updated_at" timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
) WITH (oids = false);