

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pgsodium" WITH SCHEMA "pgsodium";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE OR REPLACE FUNCTION "public"."get_last_week_exercise"() RETURNS TABLE("sets" bigint, "exerciseid" bigint)
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN QUERY
    SELECT COUNT(*), el.exerciseid
    FROM exerciselog el
    JOIN workout w ON el.workoutid = w.id
    WHERE w.date >= current_date - interval '7 days'
    GROUP BY el.exerciseid;
END;
$$;


ALTER FUNCTION "public"."get_last_week_exercise"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_last_week_exercise_sets"() RETURNS TABLE("sets" integer, "exercise_id" bigint)
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN QUERY
    SELECT sets, exerciseid
    FROM exerciselog
    WHERE date >= current_date - interval '7 days';
END;
$$;


ALTER FUNCTION "public"."get_last_week_exercise_sets"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_last_week_exercise_with_description"() RETURNS TABLE("sets" bigint, "exerciseid" bigint, "musclegroup_description" "text")
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN QUERY
    SELECT COUNT(*), el.exerciseid, mg.description
    FROM exerciselog el
    JOIN workout w ON el.workoutid = w.id
    JOIN exercises e ON el.exerciseid = e.id
    JOIN musclegroup mg ON e.primary_muscle_group = mg.id
    WHERE w.date >= current_date - interval '7 days'
    GROUP BY el.exerciseid, mg.description;
END;
$$;


ALTER FUNCTION "public"."get_last_week_exercise_with_description"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."get_last_week_exercises"() RETURNS TABLE("sets" integer, "exerciseid" bigint)
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN QUERY
    SELECT COUNT(*), el.exerciseid
    FROM exerciselog el
    JOIN workout w ON el.workoutid = w.id
    WHERE w.date >= current_date - interval '7 days'
    GROUP BY el.exerciseid;
END;
$$;


ALTER FUNCTION "public"."get_last_week_exercises"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."exerciselog" (
    "id" bigint NOT NULL,
    "workoutid" bigint,
    "reps" integer,
    "repsinreserve" integer,
    "complete" boolean,
    "exerciseid" bigint,
    "weight" numeric
);


ALTER TABLE "public"."exerciselog" OWNER TO "postgres";


ALTER TABLE "public"."exerciselog" ALTER COLUMN "id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME "public"."exerciselog_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."exercises" (
    "id" bigint NOT NULL,
    "description" "text",
    "primary_muscle_group" bigint
);


ALTER TABLE "public"."exercises" OWNER TO "postgres";


ALTER TABLE "public"."exercises" ALTER COLUMN "id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME "public"."exercises_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."mesocycle" (
    "id" bigint NOT NULL,
    "description" "text",
    "datestart" timestamp with time zone,
    "lengthweeks" integer
);


ALTER TABLE "public"."mesocycle" OWNER TO "postgres";


ALTER TABLE "public"."mesocycle" ALTER COLUMN "id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME "public"."mesocycle_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."musclegroup" (
    "id" bigint NOT NULL,
    "description" "text"
);


ALTER TABLE "public"."musclegroup" OWNER TO "postgres";


ALTER TABLE "public"."musclegroup" ALTER COLUMN "id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME "public"."musclegroup_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."savedworkout" (
    "id" bigint NOT NULL,
    "mesocycleid" bigint,
    "description" "text"
);


ALTER TABLE "public"."savedworkout" OWNER TO "postgres";


ALTER TABLE "public"."savedworkout" ALTER COLUMN "id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME "public"."savedworkout_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."savedworkoutdetail" (
    "id" bigint NOT NULL,
    "savedworkoutid" bigint,
    "exerciseid" bigint,
    "sets" integer,
    "repsinreserve" integer,
    "weight" numeric,
    "order" numeric DEFAULT '0'::numeric NOT NULL
);


ALTER TABLE "public"."savedworkoutdetail" OWNER TO "postgres";


ALTER TABLE "public"."savedworkoutdetail" ALTER COLUMN "id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME "public"."savedworkoutdetail_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."usersettings" (
    "id" bigint NOT NULL,
    "name" "text",
    "weight" numeric,
    "restInterval" bigint,
    "age" bigint
);


ALTER TABLE "public"."usersettings" OWNER TO "postgres";


ALTER TABLE "public"."usersettings" ALTER COLUMN "id" ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME "public"."usersettings_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."workout" (
    "id" bigint NOT NULL,
    "description" "text",
    "date" timestamp with time zone,
    "perceivedeffort" integer,
    "fatigue_rating" integer,
    "uuid" "uuid",
    "notes" "text"
);


ALTER TABLE "public"."workout" OWNER TO "postgres";


ALTER TABLE "public"."workout" ALTER COLUMN "id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME "public"."workouts_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



ALTER TABLE ONLY "public"."exerciselog"
    ADD CONSTRAINT "exerciselog_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."exercises"
    ADD CONSTRAINT "exercises_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."mesocycle"
    ADD CONSTRAINT "mesocycle_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."musclegroup"
    ADD CONSTRAINT "musclegroup_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."savedworkout"
    ADD CONSTRAINT "savedworkout_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."savedworkoutdetail"
    ADD CONSTRAINT "savedworkoutdetail_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."usersettings"
    ADD CONSTRAINT "usersettings_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."workout"
    ADD CONSTRAINT "workouts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."exerciselog"
    ADD CONSTRAINT "exerciselog_exerciseid_fkey" FOREIGN KEY ("exerciseid") REFERENCES "public"."exercises"("id");



ALTER TABLE ONLY "public"."exerciselog"
    ADD CONSTRAINT "exerciselog_workoutid_fkey" FOREIGN KEY ("workoutid") REFERENCES "public"."workout"("id");



ALTER TABLE ONLY "public"."exercises"
    ADD CONSTRAINT "exercises_musclegroup_fkey" FOREIGN KEY ("primary_muscle_group") REFERENCES "public"."musclegroup"("id");



ALTER TABLE ONLY "public"."savedworkout"
    ADD CONSTRAINT "savedworkout_mesocycleid_fkey" FOREIGN KEY ("mesocycleid") REFERENCES "public"."mesocycle"("id");



ALTER TABLE ONLY "public"."savedworkoutdetail"
    ADD CONSTRAINT "savedworkoutdetail_exerciseid_fkey" FOREIGN KEY ("exerciseid") REFERENCES "public"."exercises"("id");



ALTER TABLE ONLY "public"."savedworkoutdetail"
    ADD CONSTRAINT "savedworkoutdetail_savedworkoutid_fkey" FOREIGN KEY ("savedworkoutid") REFERENCES "public"."savedworkout"("id");





ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";
GRANT ALL ON SCHEMA "public" TO "prisma";
































































































































































































GRANT ALL ON FUNCTION "public"."get_last_week_exercise"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_last_week_exercise"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_last_week_exercise"() TO "service_role";
GRANT ALL ON FUNCTION "public"."get_last_week_exercise"() TO "prisma";



GRANT ALL ON FUNCTION "public"."get_last_week_exercise_sets"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_last_week_exercise_sets"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_last_week_exercise_sets"() TO "service_role";
GRANT ALL ON FUNCTION "public"."get_last_week_exercise_sets"() TO "prisma";



GRANT ALL ON FUNCTION "public"."get_last_week_exercise_with_description"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_last_week_exercise_with_description"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_last_week_exercise_with_description"() TO "service_role";
GRANT ALL ON FUNCTION "public"."get_last_week_exercise_with_description"() TO "prisma";



GRANT ALL ON FUNCTION "public"."get_last_week_exercises"() TO "anon";
GRANT ALL ON FUNCTION "public"."get_last_week_exercises"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."get_last_week_exercises"() TO "service_role";
GRANT ALL ON FUNCTION "public"."get_last_week_exercises"() TO "prisma";





















GRANT ALL ON TABLE "public"."exerciselog" TO "anon";
GRANT ALL ON TABLE "public"."exerciselog" TO "authenticated";
GRANT ALL ON TABLE "public"."exerciselog" TO "service_role";
GRANT ALL ON TABLE "public"."exerciselog" TO "prisma";



GRANT ALL ON SEQUENCE "public"."exerciselog_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."exerciselog_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."exerciselog_id_seq" TO "service_role";
GRANT ALL ON SEQUENCE "public"."exerciselog_id_seq" TO "prisma";



GRANT ALL ON TABLE "public"."exercises" TO "anon";
GRANT ALL ON TABLE "public"."exercises" TO "authenticated";
GRANT ALL ON TABLE "public"."exercises" TO "service_role";
GRANT ALL ON TABLE "public"."exercises" TO "prisma";



GRANT ALL ON SEQUENCE "public"."exercises_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."exercises_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."exercises_id_seq" TO "service_role";
GRANT ALL ON SEQUENCE "public"."exercises_id_seq" TO "prisma";



GRANT ALL ON TABLE "public"."mesocycle" TO "anon";
GRANT ALL ON TABLE "public"."mesocycle" TO "authenticated";
GRANT ALL ON TABLE "public"."mesocycle" TO "service_role";
GRANT ALL ON TABLE "public"."mesocycle" TO "prisma";



GRANT ALL ON SEQUENCE "public"."mesocycle_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."mesocycle_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."mesocycle_id_seq" TO "service_role";
GRANT ALL ON SEQUENCE "public"."mesocycle_id_seq" TO "prisma";



GRANT ALL ON TABLE "public"."musclegroup" TO "anon";
GRANT ALL ON TABLE "public"."musclegroup" TO "authenticated";
GRANT ALL ON TABLE "public"."musclegroup" TO "service_role";
GRANT ALL ON TABLE "public"."musclegroup" TO "prisma";



GRANT ALL ON SEQUENCE "public"."musclegroup_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."musclegroup_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."musclegroup_id_seq" TO "service_role";
GRANT ALL ON SEQUENCE "public"."musclegroup_id_seq" TO "prisma";



GRANT ALL ON TABLE "public"."savedworkout" TO "anon";
GRANT ALL ON TABLE "public"."savedworkout" TO "authenticated";
GRANT ALL ON TABLE "public"."savedworkout" TO "service_role";
GRANT ALL ON TABLE "public"."savedworkout" TO "prisma";



GRANT ALL ON SEQUENCE "public"."savedworkout_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."savedworkout_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."savedworkout_id_seq" TO "service_role";
GRANT ALL ON SEQUENCE "public"."savedworkout_id_seq" TO "prisma";



GRANT ALL ON TABLE "public"."savedworkoutdetail" TO "anon";
GRANT ALL ON TABLE "public"."savedworkoutdetail" TO "authenticated";
GRANT ALL ON TABLE "public"."savedworkoutdetail" TO "service_role";
GRANT ALL ON TABLE "public"."savedworkoutdetail" TO "prisma";



GRANT ALL ON SEQUENCE "public"."savedworkoutdetail_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."savedworkoutdetail_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."savedworkoutdetail_id_seq" TO "service_role";
GRANT ALL ON SEQUENCE "public"."savedworkoutdetail_id_seq" TO "prisma";



GRANT ALL ON TABLE "public"."usersettings" TO "anon";
GRANT ALL ON TABLE "public"."usersettings" TO "authenticated";
GRANT ALL ON TABLE "public"."usersettings" TO "service_role";
GRANT ALL ON TABLE "public"."usersettings" TO "prisma";



GRANT ALL ON SEQUENCE "public"."usersettings_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."usersettings_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."usersettings_id_seq" TO "service_role";
GRANT ALL ON SEQUENCE "public"."usersettings_id_seq" TO "prisma";



GRANT ALL ON TABLE "public"."workout" TO "anon";
GRANT ALL ON TABLE "public"."workout" TO "authenticated";
GRANT ALL ON TABLE "public"."workout" TO "service_role";
GRANT ALL ON TABLE "public"."workout" TO "prisma";



GRANT ALL ON SEQUENCE "public"."workouts_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."workouts_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."workouts_id_seq" TO "service_role";
GRANT ALL ON SEQUENCE "public"."workouts_id_seq" TO "prisma";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "prisma";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "prisma";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "prisma";






























RESET ALL;
