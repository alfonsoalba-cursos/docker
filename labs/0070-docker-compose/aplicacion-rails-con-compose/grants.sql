create database "blog-development" ;
CREATE ROLE "blog-development" with PASSWORD '12345678' LOGIN;
grant all privileges on database "blog-development" to "blog-development";
ALTER USER "blog-development" CREATEDB;
ALTER DATABASE "blog-development" OWNER TO "blog-development";

create database "blog-test" ;
CREATE ROLE "blog-test" with PASSWORD '12345678' LOGIN;
grant all privileges on database "blog-test" to "blog-test";
ALTER USER "blog-test" CREATEDB;
ALTER DATABASE "blog-test" OWNER TO "blog-test";