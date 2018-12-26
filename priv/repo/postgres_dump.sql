--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5
-- Dumped by pg_dump version 10.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: notify_about_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_about_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
  DECLARE
    product_id text;
    col_name text := quote_ident(TG_ARGV[1]);
  BEGIN
    EXECUTE format('SELECT ($1).%s::text', col_name)
    USING
      CASE
        WHEN TG_OP = 'DELETE' THEN OLD
        ELSE NEW
      END
    INTO product_id;

    PERFORM pg_notify(TG_ARGV[0], product_id);

    RETURN NULL;
  END;
  $_$;


ALTER FUNCTION public.notify_about_update() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    name character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    text_color character varying(255) NOT NULL,
    background_color character varying(255) NOT NULL
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_id_seq OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: product_ratings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_ratings (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    user_id bigint NOT NULL,
    value double precision,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.product_ratings OWNER TO postgres;

--
-- Name: product_ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_ratings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_ratings_id_seq OWNER TO postgres;

--
-- Name: product_ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_ratings_id_seq OWNED BY public.product_ratings.id;


--
-- Name: product_uses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_uses (
    id bigint NOT NULL,
    ended_at timestamp without time zone,
    user_id bigint NOT NULL,
    product_id bigint NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    return_subscribers integer[] DEFAULT ARRAY[]::integer[]
);


ALTER TABLE public.product_uses OWNER TO postgres;

--
-- Name: product_uses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_uses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_uses_id_seq OWNER TO postgres;

--
-- Name: product_uses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_uses_id_seq OWNED BY public.product_uses.id;


--
-- Name: product_votes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.product_votes (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    user_id bigint NOT NULL,
    is_upvote boolean NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.product_votes OWNER TO postgres;

--
-- Name: product_votes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.product_votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.product_votes_id_seq OWNER TO postgres;

--
-- Name: product_votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.product_votes_id_seq OWNED BY public.product_votes.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    title text,
    url text,
    author text,
    status character varying(255),
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    category_id bigint,
    requested_by_user_id bigint
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.products_id_seq OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp without time zone
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(255),
    email character varying(255) NOT NULL,
    inserted_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_admin boolean DEFAULT false,
    avatar_url character varying(255)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: product_ratings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_ratings ALTER COLUMN id SET DEFAULT nextval('public.product_ratings_id_seq'::regclass);


--
-- Name: product_uses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_uses ALTER COLUMN id SET DEFAULT nextval('public.product_uses_id_seq'::regclass);


--
-- Name: product_votes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_votes ALTER COLUMN id SET DEFAULT nextval('public.product_votes_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (id, name, inserted_at, updated_at, text_color, background_color) FROM stdin;
4	Databases	2018-06-11 12:35:18.423243	2018-06-11 12:35:18.423251	#fa732f	#fbe7db
5	Operating Systems & Security	2018-06-11 12:35:18.42898	2018-06-11 21:22:14.832474	#eb425f	#fbdbe5
7	Business & Management	2018-06-11 12:35:18.436531	2018-06-11 21:22:23.465649	#13b596	#d4f5ef
2	Design & UX	2018-06-11 12:35:18.404435	2018-06-11 21:22:36.069753	#3c79e4	#deeaff
1	Web Development	2018-06-11 12:35:18.370312	2018-06-18 15:42:51.448369	#eb42bc	#fbdbf2
6	Software Development	2018-06-11 12:35:18.434493	2018-06-18 15:42:56.828357	#fdad1f	#fbf3db
3	Mobile Development	2018-06-11 12:35:18.416534	2018-06-18 15:43:04.957533	#7142eb	#e4dbfb
\.


--
-- Data for Name: product_ratings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_ratings (id, product_id, user_id, value, inserted_at, updated_at) FROM stdin;
1	155	119	5	2018-06-12 10:24:06.987871	2018-06-12 10:24:06.987886
2	92	136	4	2018-06-12 11:00:12.552165	2018-06-12 11:00:12.552178
3	184	96	5	2018-06-12 13:07:38.541575	2018-06-12 13:07:38.541589
4	256	136	5	2018-06-13 07:08:31.68863	2018-06-13 07:08:31.688645
5	200	176	4	2018-06-13 08:38:37.633929	2018-06-13 08:38:37.633961
6	118	195	5	2018-06-13 09:41:33.28126	2018-06-13 09:41:33.281273
7	238	195	3	2018-06-13 09:42:06.646554	2018-06-13 09:42:06.646567
8	254	188	5	2018-06-13 10:12:20.095112	2018-06-13 10:12:20.095127
9	95	116	4	2018-06-14 07:24:55.207076	2018-06-14 07:24:55.207097
10	12	195	4	2018-06-14 10:01:03.310205	2018-06-14 10:01:03.310219
11	180	3	5	2018-06-14 11:53:07.728195	2018-06-14 11:53:07.728206
12	183	67	3	2018-06-14 12:12:00.788813	2018-06-14 12:12:00.788826
13	255	34	5	2018-06-14 13:57:01.504422	2018-06-14 13:57:01.504438
14	196	102	3	2018-06-15 05:41:21.202902	2018-06-15 05:41:21.202922
15	15	186	3	2018-06-15 08:53:59.871035	2018-06-15 08:53:59.871049
16	170	135	3	2018-06-15 10:09:20.362643	2018-06-15 10:09:20.362655
17	237	112	4	2018-06-15 11:29:24.618031	2018-06-15 11:29:24.618044
18	169	112	4	2018-06-15 11:29:27.04523	2018-06-15 11:29:27.045262
19	199	144	4	2018-06-18 08:23:59.093207	2018-06-18 08:23:59.093222
20	96	5	5	2018-06-18 10:19:47.291037	2018-06-18 10:19:47.291067
21	85	5	5	2018-06-18 10:19:53.143183	2018-06-18 10:19:53.143198
22	236	61	4	2018-06-20 06:20:05.287477	2018-06-20 06:20:05.28749
23	217	142	3	2018-06-20 14:31:44.911509	2018-06-20 14:31:44.911522
24	150	190	4	2018-07-02 09:53:02.153638	2018-07-02 09:53:02.153663
25	177	190	4	2018-07-02 09:53:26.69969	2018-07-02 09:53:26.699702
26	206	94	1	2018-07-05 07:00:57.485297	2018-07-05 07:00:57.48531
27	216	165	4	2018-07-15 11:08:38.450313	2018-07-15 11:08:38.450326
28	192	165	3	2018-07-15 11:08:56.569628	2018-07-15 11:08:56.569642
29	225	201	5	2018-07-17 11:08:41.413741	2018-07-17 11:08:41.413756
30	223	201	5	2018-07-17 11:08:44.154373	2018-07-17 11:08:44.154397
31	20	188	4	2018-07-19 12:13:49.989597	2018-07-19 12:13:49.989614
32	116	143	5	2018-07-23 12:32:20.079795	2018-07-23 12:32:20.079825
33	83	147	5	2018-07-27 08:04:09.574794	2018-07-27 08:04:09.574808
34	151	3	5	2018-07-27 09:33:21.670569	2018-07-27 09:33:21.670582
35	189	112	5	2018-07-30 09:46:11.510845	2018-07-30 09:46:11.510861
36	127	209	5	2018-07-30 10:20:03.725209	2018-07-30 10:20:03.725221
37	219	182	1	2018-07-31 09:33:07.98964	2018-07-31 09:33:07.989653
38	131	206	4	2018-08-01 12:24:20.52234	2018-08-01 12:24:20.522353
39	98	208	3	2018-08-02 07:55:19.64313	2018-08-02 07:55:19.643143
40	93	144	5	2018-08-07 10:39:13.216011	2018-08-07 10:39:13.216024
41	256	217	4	2018-08-14 09:02:26.030887	2018-08-14 09:02:26.030901
42	12	33	5	2018-08-19 17:33:16.534002	2018-08-19 17:33:16.534026
43	14	67	3	2018-08-20 07:30:55.729359	2018-08-20 07:30:55.729373
44	252	181	5	2018-08-22 08:13:47.198286	2018-08-22 08:13:47.1983
45	240	67	4	2018-08-22 10:35:34.406426	2018-08-22 10:35:34.406441
46	20	226	4	2018-08-27 15:48:43.793714	2018-08-27 15:48:43.793729
47	234	205	5	2018-09-03 06:10:47.703253	2018-09-03 06:10:47.703268
48	255	195	5	2018-09-03 08:47:47.625777	2018-09-03 08:47:47.625795
49	169	124	4	2018-09-06 08:40:30.569951	2018-09-06 08:40:30.569965
50	217	223	2	2018-09-12 12:20:52.800516	2018-09-12 12:20:52.800531
51	230	102	3	2018-09-18 11:25:25.366735	2018-09-18 11:25:25.366749
52	130	19	5	2018-09-18 12:11:46.061701	2018-09-18 12:11:46.061718
53	249	142	4	2018-09-26 06:02:10.156336	2018-09-26 06:02:10.156364
54	230	118	5	2018-10-03 08:06:33.651438	2018-10-03 08:06:33.65146
55	229	118	5	2018-10-03 08:06:36.042064	2018-10-03 08:06:36.04208
56	172	118	5	2018-10-03 08:06:54.623843	2018-10-03 08:06:54.623877
57	171	118	5	2018-10-03 08:06:56.615749	2018-10-03 08:06:56.615768
58	77	118	5	2018-10-03 08:07:12.69602	2018-10-03 08:07:12.696035
59	239	176	5	2018-10-03 10:07:24.966768	2018-10-03 10:07:24.966786
60	13	118	5	2018-10-05 10:04:32.265687	2018-10-05 10:04:32.265714
61	281	142	4	2018-10-08 07:13:36.666063	2018-10-08 07:13:36.666082
62	246	163	5	2018-10-10 11:17:35.828594	2018-10-10 11:17:35.82861
63	220	163	5	2018-10-10 11:17:44.686995	2018-10-10 11:17:44.687021
64	225	186	4	2018-10-17 17:21:19.136506	2018-10-17 17:21:19.136526
65	241	186	4	2018-10-17 17:21:25.813019	2018-10-17 17:21:25.813041
66	127	186	2	2018-10-17 17:21:49.627383	2018-10-17 17:21:49.627412
67	95	166	3	2018-10-22 17:58:06.441963	2018-10-22 17:58:06.441983
68	194	147	3	2018-10-23 08:19:09.609551	2018-10-23 08:19:09.609586
69	247	85	5	2018-10-25 10:07:41.116245	2018-10-25 10:07:41.116262
70	206	112	5	2018-10-25 10:39:57.76552	2018-10-25 10:39:57.765539
71	92	112	4	2018-10-25 10:40:01.151965	2018-10-25 10:40:01.151983
72	143	196	5	2018-10-26 12:21:49.892643	2018-10-26 12:21:49.8927
73	129	19	5	2018-11-02 12:40:31.698413	2018-11-02 12:40:31.698431
74	58	19	5	2018-11-02 12:40:34.36607	2018-11-02 12:40:34.366089
\.


--
-- Data for Name: product_uses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_uses (id, ended_at, user_id, product_id, inserted_at, updated_at, return_subscribers) FROM stdin;
122	\N	208	250	2018-08-01 12:09:22.468302	2018-08-01 12:09:22.468315	{}
7	\N	38	49	2017-01-17 09:06:34.738	2017-01-17 09:06:34.738	{}
8	\N	145	54	2017-04-07 14:24:28.705	2017-04-07 14:24:28.705	{}
18	\N	145	100	2017-04-07 14:24:21.136	2017-04-07 14:24:21.136	{}
19	\N	67	112	2018-03-12 16:28:40.575	2018-03-12 16:28:40.575	{}
21	\N	145	117	2017-04-07 14:24:35.521	2017-04-07 14:24:35.521	{}
135	\N	205	162	2018-09-03 06:10:56.012404	2018-09-03 06:10:56.012418	{}
30	\N	57	152	2018-04-19 10:19:38.655	2018-04-19 10:19:38.655	{}
32	\N	84	160	2017-10-04 11:51:20.855	2017-10-04 11:51:20.855	{}
33	\N	38	161	2017-01-17 09:02:31.311	2017-01-17 09:02:31.311	{}
37	\N	38	178	2017-01-25 09:57:19.218	2017-01-25 09:57:19.218	{}
39	\N	162	181	2017-03-30 14:25:24.013	2017-03-30 14:25:24.013	{}
48	\N	2	205	2017-04-21 10:09:43.02	2017-04-21 10:09:43.02	{}
51	\N	12	210	2018-01-04 14:16:39.1	2018-01-04 14:16:39.1	{}
54	\N	116	218	2018-06-07 14:21:02.391	2018-06-07 14:21:02.391	{}
104	\N	126	116	2018-07-23 12:33:54.292284	2018-07-23 12:33:54.292297	{}
126	\N	144	93	2018-08-07 10:39:14.517539	2018-08-07 10:39:14.517555	{}
130	\N	217	245	2018-08-16 13:44:15.862188	2018-08-16 13:44:15.8622	{}
132	\N	135	170	2018-08-22 10:02:37.061911	2018-08-22 10:02:37.061926	{}
133	\N	226	16	2018-08-27 16:05:58.152443	2018-08-27 16:05:58.152459	{}
138	\N	188	253	2018-09-05 19:53:28.019888	2018-09-05 19:53:28.019918	{}
140	\N	188	176	2018-09-06 10:22:32.223465	2018-09-06 10:22:32.22348	{}
141	\N	124	114	2018-09-06 13:37:54.329591	2018-09-06 13:37:54.329605	{}
149	\N	217	12	2018-09-17 09:16:01.946849	2018-09-17 09:16:01.946877	{}
150	\N	159	282	2018-09-18 11:25:40.958314	2018-09-18 11:25:40.958338	{}
151	\N	159	130	2018-09-18 12:12:05.961699	2018-09-18 12:12:05.961717	{}
94	\N	5	203	2018-06-18 10:19:59.473694	2018-06-18 10:19:59.473715	{}
152	\N	229	221	2018-09-24 14:25:43.188969	2018-09-24 14:25:43.188993	{}
158	\N	2	289	2018-10-02 10:10:24.024521	2018-10-02 10:10:24.02454	{}
159	\N	176	239	2018-10-03 10:07:26.796293	2018-10-03 10:07:26.79631	{}
131	\N	204	252	2018-08-22 08:15:58.058694	2018-08-22 08:15:58.058709	{}
160	\N	142	281	2018-10-08 07:13:39.842075	2018-10-08 07:13:39.842094	{}
161	\N	142	249	2018-10-08 07:13:56.211296	2018-10-08 07:13:56.211311	{}
162	\N	190	150	2018-10-08 11:51:13.778988	2018-10-08 11:51:13.779017	{}
163	\N	67	246	2018-10-10 11:18:22.42851	2018-10-10 11:18:22.428529	{}
164	\N	67	83	2018-10-10 11:18:27.104362	2018-10-10 11:18:27.104381	{}
165	\N	163	234	2018-10-10 11:27:15.701925	2018-10-10 11:27:15.701953	{}
166	\N	208	261	2018-10-10 11:29:57.259936	2018-10-10 11:29:57.259953	{}
167	\N	230	138	2018-10-10 11:42:17.807828	2018-10-10 11:42:17.807849	{}
168	\N	230	2	2018-10-10 11:42:21.983125	2018-10-10 11:42:21.983151	{}
173	\N	206	260	2018-10-22 13:21:38.582742	2018-10-22 13:21:38.582765	{}
174	\N	188	95	2018-10-22 19:46:07.588298	2018-10-22 19:46:07.588331	{}
177	\N	185	37	2018-11-07 09:47:26.202789	2018-11-07 09:47:26.202805	{}
185	\N	112	269	2018-12-07 18:45:26	2018-12-07 18:45:26	{}
\.


--
-- Data for Name: product_votes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.product_votes (id, product_id, user_id, is_upvote, inserted_at, updated_at) FROM stdin;
288	231	143	t	2018-06-11 12:35:20.153975	2018-06-11 12:35:20.153992
358	244	143	t	2018-06-11 12:35:20.289527	2018-06-11 12:35:20.289541
448	243	55	t	2018-06-11 12:35:20.464762	2018-06-11 12:35:20.464768
468	262	196	t	2018-06-11 12:35:20.504815	2018-06-11 12:35:20.504822
488	263	112	t	2018-06-11 12:35:20.545237	2018-06-11 12:35:20.545246
498	243	176	f	2018-06-11 12:35:20.562598	2018-06-11 12:35:20.562604
349	244	67	t	2018-06-11 12:35:20.270391	2018-06-11 12:35:20.270398
439	243	20	t	2018-06-11 12:35:20.449808	2018-06-11 12:35:20.449815
449	231	55	t	2018-06-11 12:35:20.466127	2018-06-11 12:35:20.466133
469	262	154	t	2018-06-11 12:35:20.506417	2018-06-11 12:35:20.506423
489	262	112	t	2018-06-11 12:35:20.547176	2018-06-11 12:35:20.547184
499	244	176	f	2018-06-11 12:35:20.564226	2018-06-11 12:35:20.564232
310	231	115	t	2018-06-11 12:35:20.19847	2018-06-11 12:35:20.198477
359	243	143	t	2018-06-11 12:35:20.291925	2018-09-04 10:47:51.064924
328	231	141	t	2018-06-11 12:35:20.231081	2018-06-20 08:37:32.6384
390	208	180	t	2018-06-11 12:35:20.353248	2018-06-11 12:35:20.353256
400	244	115	t	2018-06-11 12:35:20.369441	2018-06-11 12:35:20.369449
480	243	149	t	2018-06-11 12:35:20.526016	2018-06-11 12:35:20.526024
500	263	38	t	2018-06-11 12:35:20.566317	2018-06-11 12:35:20.566324
371	244	181	t	2018-06-11 12:35:20.314299	2018-06-11 12:35:20.314304
451	208	55	t	2018-06-11 12:35:20.469961	2018-06-11 12:35:20.469969
461	244	169	t	2018-06-11 12:35:20.491946	2018-06-11 12:35:20.491963
501	231	38	t	2018-06-11 12:35:20.567893	2018-06-11 12:35:20.5679
511	271	218	t	2018-06-11 12:35:20.58737	2018-06-11 12:35:20.587379
462	243	169	t	2018-06-11 12:35:20.494213	2018-06-11 12:35:20.49422
472	262	205	t	2018-06-11 12:35:20.512464	2018-06-11 12:35:20.512471
492	263	196	t	2018-06-11 12:35:20.55196	2018-06-11 12:35:20.551967
343	231	72	t	2018-06-11 12:35:20.260799	2018-06-11 12:35:20.260805
413	244	85	t	2018-06-11 12:35:20.398966	2018-06-11 12:35:20.398972
463	262	208	t	2018-06-11 12:35:20.495841	2018-06-11 12:35:20.495847
483	263	205	t	2018-06-11 12:35:20.532285	2018-06-11 12:35:20.532291
513	272	218	t	2018-06-11 12:35:20.594248	2018-06-11 12:35:20.594263
294	208	80	t	2018-06-11 12:35:20.165214	2018-06-11 12:35:20.165225
324	222	55	f	2018-06-11 12:35:20.222234	2018-06-11 12:35:20.22224
364	231	185	t	2018-06-11 12:35:20.300531	2018-06-11 12:35:20.30054
414	243	85	f	2018-06-11 12:35:20.400457	2018-06-11 12:35:20.400463
484	263	19	t	2018-06-11 12:35:20.533997	2018-06-11 12:35:20.534006
494	263	154	t	2018-06-11 12:35:20.555306	2018-06-11 12:35:20.555313
315	231	85	t	2018-06-11 12:35:20.207244	2018-06-11 12:35:20.207249
405	244	170	t	2018-06-11 12:35:20.380685	2018-06-11 12:35:20.380692
425	244	27	t	2018-06-11 12:35:20.420156	2018-06-11 12:35:20.420166
475	262	3	t	2018-06-11 12:35:20.517369	2018-06-11 12:35:20.517375
485	262	19	t	2018-06-11 12:35:20.536648	2018-06-11 12:35:20.536656
505	267	209	t	2018-06-11 12:35:20.574551	2018-06-11 12:35:20.574559
316	222	35	t	2018-06-11 12:35:20.208847	2018-06-11 12:35:20.208854
366	222	142	t	2018-06-11 12:35:20.305716	2018-06-11 12:35:20.305727
456	258	112	t	2018-06-11 12:35:20.479766	2018-06-11 12:35:20.479776
496	222	112	f	2018-06-11 12:35:20.559359	2018-06-11 12:35:20.559366
506	263	217	t	2018-06-11 12:35:20.576558	2018-06-11 12:35:20.576564
347	222	144	f	2018-06-11 12:35:20.267239	2018-06-11 12:35:20.267245
427	222	27	f	2018-06-11 12:35:20.423763	2018-06-11 12:35:20.423771
447	244	55	t	2018-06-11 12:35:20.463241	2018-06-11 12:35:20.463248
457	262	169	t	2018-06-11 12:35:20.481626	2018-06-11 12:35:20.481633
487	263	181	t	2018-06-11 12:35:20.542826	2018-06-11 12:35:20.542836
497	265	181	t	2018-06-11 12:35:20.561029	2018-06-11 12:35:20.561037
507	265	149	t	2018-06-11 12:35:20.579007	2018-06-11 12:35:20.579018
514	264	157	t	2018-06-11 12:52:58.714804	2018-06-11 12:52:58.714817
524	268	112	t	2018-06-12 06:32:48.601894	2018-06-12 06:32:48.601907
519	272	112	t	2018-06-11 15:54:05.565987	2018-07-30 12:34:54.550589
520	273	112	t	2018-06-11 21:20:51.892823	2018-06-11 21:20:51.892835
521	271	112	t	2018-06-12 06:32:43.729765	2018-06-12 06:32:43.72978
526	266	112	t	2018-06-12 06:33:02.73145	2018-06-12 06:33:02.731463
527	264	112	t	2018-06-12 06:33:12.674891	2018-06-12 06:33:12.674905
525	267	112	t	2018-06-12 06:32:54.401789	2018-06-13 13:19:41.389573
479	244	149	t	2018-06-11 12:35:20.523752	2018-06-13 14:10:45.310405
528	275	112	t	2018-06-14 11:26:05.332212	2018-06-14 11:26:05.332224
529	263	67	t	2018-06-14 12:12:14.590643	2018-06-14 12:12:14.590655
532	273	206	t	2018-06-18 08:53:44.408659	2018-06-18 08:53:44.408678
533	263	170	t	2018-06-19 11:15:36.127364	2018-06-19 11:15:39.466138
534	267	192	t	2018-06-19 11:15:45.41969	2018-06-19 11:15:45.419704
535	276	85	t	2018-06-25 14:04:47.527016	2018-06-25 14:04:47.527037
537	244	131	t	2018-07-25 10:59:11.082135	2018-07-25 10:59:11.082149
538	243	131	t	2018-07-25 10:59:13.163206	2018-07-25 10:59:13.16322
539	263	131	t	2018-07-25 10:59:16.610565	2018-07-25 10:59:16.610578
540	273	154	t	2018-08-02 15:02:01.473939	2018-08-02 15:02:01.473953
541	273	196	t	2018-08-07 09:51:10.254065	2018-08-07 09:51:10.254079
542	273	225	t	2018-08-07 14:16:23.532356	2018-08-07 14:16:28.502608
543	258	162	t	2018-08-13 07:03:51.838185	2018-08-13 07:03:51.838201
544	208	224	t	2018-08-21 12:30:34.355402	2018-08-21 12:30:34.355415
545	273	102	t	2018-08-24 12:25:17.644764	2018-08-24 12:25:17.644778
546	271	102	t	2018-08-24 12:25:21.563889	2018-08-24 12:25:21.563903
547	273	12	t	2018-09-03 13:42:03.943842	2018-09-03 13:42:03.943857
548	276	143	t	2018-09-04 10:48:24.24676	2018-09-04 10:48:24.246777
549	263	143	f	2018-09-04 10:49:31.869768	2018-09-04 10:49:31.869785
550	286	119	t	2018-09-07 09:49:28.938248	2018-09-07 09:49:28.938265
551	273	19	t	2018-09-20 16:04:25.977564	2018-09-20 16:04:25.977587
552	286	112	t	2018-09-24 21:33:13.356284	2018-09-24 21:33:13.35632
553	288	196	t	2018-09-25 09:16:30.600559	2018-09-25 09:16:30.600585
554	288	205	t	2018-09-25 09:20:41.730692	2018-09-25 09:20:41.730712
555	280	111	t	2018-10-04 15:19:07.553612	2018-10-04 15:19:07.553641
556	279	111	t	2018-10-04 15:19:12.435814	2018-10-04 15:19:12.435844
557	258	111	t	2018-10-04 15:19:40.339163	2018-10-04 15:19:40.339198
558	263	206	t	2018-10-05 14:32:53.485352	2018-10-05 14:32:53.485372
559	288	32	f	2018-12-03 17:28:28	2018-12-03 17:28:28
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (id, title, url, author, status, inserted_at, updated_at, category_id, requested_by_user_id) FROM stdin;
1	Arkana C++ Programowanie	\N	Deitel H.M., Deitel P.J.	IN_LIBRARY	2014-08-30 10:27:12.416	2014-08-30 10:27:12.416	6	\N
2	Wprowadzenie Ruby	\N	Fitzergald M.	IN_LIBRARY	2014-08-30 10:27:12.42	2014-08-30 10:27:12.42	6	\N
3	Język ANSI C	\N	Kernighan B.W., Ritchie D.M	IN_LIBRARY	2014-08-30 10:27:12.424	2014-08-30 10:27:12.424	6	\N
5	Edytor Vi	\N	Lamb L., Robbins A	IN_LIBRARY	2014-08-30 10:27:12.429	2014-08-30 10:27:12.429	6	\N
6	Struktura organizacyjna i architektura systemów komputerowych	\N	Null L., Lobur J.	IN_LIBRARY	2014-08-30 10:27:12.431	2014-08-30 10:27:12.431	6	\N
7	Shell Scripting. Expert recipes for Linux, Bash and More	\N	Parker S.	IN_LIBRARY	2014-08-30 10:27:12.433	2014-08-30 10:27:12.433	5	\N
8	UML Leksykon kieszonkowy	\N	Pilone D.	IN_LIBRARY	2014-08-30 10:27:12.435	2014-08-30 10:27:12.435	6	\N
9	CVS Leksykon kieszonkowy	\N	Purdy G.N.	IN_LIBRARY	2014-08-30 10:27:12.438	2014-08-30 10:27:12.438	6	\N
10	Organizacja i architektura systemu komputerowego. Projektowanie systemu a jego wydajność.	\N	Stallings W.	IN_LIBRARY	2014-08-30 10:27:12.44	2014-08-30 10:27:12.44	6	\N
11	Making Ideas Happen: Overcoming the Obstacles Between Vision and Reality	\N	Belsky S.	IN_LIBRARY	2014-08-30 10:27:12.443	2014-08-30 10:27:12.443	7	\N
15	Zarządzanie projektami IT Przewodnik po metodykach	\N	Koszlajda A.	IN_LIBRARY	2014-08-30 10:27:12.453	2014-08-30 10:27:12.453	7	\N
16	The Art of Readable Code	\N	Boswell D., Foucher T.	IN_LIBRARY	2014-08-30 10:27:12.455	2014-08-30 10:27:12.455	6	\N
17	Cocoa Design Patterns	\N	Buck E.	IN_LIBRARY	2014-08-30 10:27:12.458	2014-08-30 10:27:12.458	3	\N
18	Succeeding with Agile. Software development using scrum.	\N	Cohn M.	IN_LIBRARY	2014-08-30 10:27:12.46	2014-08-30 10:27:12.46	7	\N
19	Algorytmy: Almanach	\N	Heineman G. T., Pollice G., Selkow S.	IN_LIBRARY	2014-08-30 10:27:12.462	2014-08-30 10:27:12.462	6	\N
20	The pragmatic programer	\N	Hunt A., Thomas D.	IN_LIBRARY	2014-08-30 10:27:12.464	2014-08-30 10:27:12.464	6	\N
21	Delphi 2005. 303 gotowe rozwiązania.	\N	J. Matulewski, S. Orłowski, M. Zieliński	IN_LIBRARY	2014-08-30 10:27:12.466	2014-08-30 10:27:12.466	6	\N
22	Asembler. Miniprzewodnik.	\N	Michałek G.	IN_LIBRARY	2014-08-30 10:27:12.468	2014-08-30 10:27:12.468	6	\N
23	Ship it! A practical Guide to Successful Software Projects	\N	Richardson J., Gwaltney W. Jr	IN_LIBRARY	2014-08-30 10:27:12.47	2014-08-30 10:27:12.47	7	\N
24	Algorytmy, struktury danych i techniki programowania,	\N	Wróblewski P.	IN_LIBRARY	2014-08-30 10:27:12.472	2014-08-30 10:27:12.472	6	\N
25	Core Data	\N	Zarra M.S.	IN_LIBRARY	2014-08-30 10:27:12.474	2014-08-30 10:27:12.474	3	\N
26	Perełki oprogramowania	\N	Bentley J.	IN_LIBRARY	2014-08-30 10:27:12.476	2014-08-30 10:27:12.476	6	\N
27	Handbook of Usability Testing: Howto Plan, Design, and Conduct Effective Tests	\N	Rubin J.	IN_LIBRARY	2014-08-30 10:27:12.478	2014-08-30 10:27:12.478	2	\N
28	Apache. Agresja i ochrona.	\N	Anonim	IN_LIBRARY	2014-08-30 10:27:12.481	2014-08-30 10:27:12.481	5	\N
29	Jak pisać wirusy	\N	Dudek A.	IN_LIBRARY	2014-08-30 10:27:12.483	2014-08-30 10:27:12.483	5	\N
30	Cisza w sieci. Praktyczny przewodnik po pasywnym rozpoznawaniu i atakach w sieci.	\N	Zalewski M.	IN_LIBRARY	2014-08-30 10:27:12.485	2014-08-30 10:27:12.485	5	\N
31	Systemy baz danych	\N	Connolly T., Begg C.	IN_LIBRARY	2014-08-30 10:27:12.487	2014-08-30 10:27:12.487	4	\N
32	MySQL Leksykon kieszonkowy	\N	Reese G.	IN_LIBRARY	2014-08-30 10:27:12.49	2014-08-30 10:27:12.49	4	\N
33	Managing Gigabytes. Compressing and Indexing Documents and Images	\N	Witten I.H., Moffat A,, Bell T.C.	IN_LIBRARY	2014-08-30 10:27:12.492	2014-08-30 10:27:12.492	4	\N
34	MySQL High Availability	\N	Bell C., Kindahl M., Thalmann L.	IN_LIBRARY	2014-08-30 10:27:12.495	2014-08-30 10:27:12.495	4	\N
35	SQL Leksykon kieszonkowy	\N	Gennick J.	LOST	2014-08-30 10:27:12.497	2014-08-30 10:27:12.497	4	\N
36	Optymalizacja Oracle SQL Leksykon kieszonkowy	\N	Gurry M.	IN_LIBRARY	2014-08-30 10:27:12.499	2014-08-30 10:27:12.499	4	\N
37	Programming Clojure	\N	Halloway S.	IN_LIBRARY	2014-08-30 10:27:12.501	2014-08-30 10:27:12.501	6	\N
46	Pro Android 3	\N	Komatineni S., MacLean D., Hashimi S.	IN_LIBRARY	2014-08-30 10:27:12.521	2014-08-30 10:27:12.521	3	\N
47	Test-Driven iOS Development (Developer's Library)	\N	Lee G.	IN_LIBRARY	2014-08-30 10:27:12.524	2014-08-30 10:27:12.524	3	\N
48	Linux Podręcznik użytkownika	\N	Siever E.	IN_LIBRARY	2014-08-30 10:27:12.526	2014-08-30 10:27:12.526	5	\N
49	Test-Driven Development with Python	\N	Percival H.J.W	IN_LIBRARY	2014-08-30 10:27:12.528	2014-08-30 10:27:12.528	6	\N
50	How to Recruit and Hire Great Software Engineers: Building a Crack Development Team	\N	McCuller P.	IN_LIBRARY	2014-08-30 10:27:12.53	2014-08-30 10:27:12.53	7	\N
51	The Shallows: What the Internet Is Doing to Our Brains	\N	Carr N.	LOST	2014-08-30 10:27:12.532	2014-08-30 10:27:12.532	7	\N
52	The Facebook effect	\N	Kirkpatrick D.	IN_LIBRARY	2014-08-30 10:27:12.534	2014-08-30 10:27:12.534	7	\N
53	The wisdom of crowds	\N	Surowiecki J.	IN_LIBRARY	2014-08-30 10:27:12.537	2014-08-30 10:27:12.537	7	\N
54	Seductive Interaction Design: Creating Playful, Fun, and Effective User Experiences (Voices That Matter)	\N	Anderson S.P.	IN_LIBRARY	2014-08-30 10:27:12.539	2014-08-30 10:27:12.539	2	\N
55	Elementy grafiki komputerowej	\N	Jankowski M.	IN_LIBRARY	2014-08-30 10:27:12.541	2014-08-30 10:27:12.541	2	\N
56	Tworzenie stron WWW Almanach	\N	Niederst J.	IN_LIBRARY	2014-08-30 10:27:12.544	2014-08-30 10:27:12.544	2	\N
57	Wprowadzenie do grafiki komputerowej	\N	Praca zbiorowa	IN_LIBRARY	2014-08-30 10:27:12.546	2014-08-30 10:27:12.546	2	\N
58	A Project Guide to UX Design: For user experience designers in the field or in the making	\N	Unger R.	IN_LIBRARY	2014-08-30 10:27:12.548	2014-08-30 10:27:12.548	2	\N
59	JDBC Leksykon kieszonkowy	\N	Bales D.	IN_LIBRARY	2014-08-30 10:27:12.55	2014-08-30 10:27:12.55	6	\N
60	Effective Java	\N	Bloch J.	IN_LIBRARY	2014-08-30 10:27:12.552	2014-08-30 10:27:12.552	6	\N
13	Rework	https://www.amazon.com/Rework-Jason-Fried/dp/0307463745/ref=tmm_hrd_swatch_0?_encoding=UTF8&qid=1529337042&sr=1-1	Fried J.	IN_LIBRARY	2014-08-30 10:27:12.449	2018-06-18 15:51:02.74885	7	\N
61	JavaScript: The Good Parts	\N	Crockford D.	LOST	2014-08-30 10:27:12.555	2014-08-30 10:27:12.555	1	\N
71	Getting Started with Meteor.js JavaScript Framework	\N	Strack I.	IN_LIBRARY	2014-08-30 10:27:12.578	2014-08-30 10:27:12.578	1	\N
81	Symbol	http://www.amazon.com/Symbol-Steven-Bateman/dp/1856697274	Angus Hyland and Steven Bateman	IN_LIBRARY	2014-09-02 10:55:56.843	2014-09-02 10:55:56.843	2	54
98	About Face: The Essentials of Interaction Design	http://www.amazon.com/About-Face-Essentials-Interaction-Design/dp/1118766571	 Alan Cooper	IN_LIBRARY	2014-11-28 14:40:30.248	2014-11-28 14:40:30.248	2	54
107	Learning JavaScript Data Structures and Algorithms 	http://www.amazon.com/gp/product/1783554878/	Loiane Groner	LOST	2015-08-25 22:33:19.84	2015-08-25 22:33:19.84	1	101
117	Człowiek i jego znaki	https://d2d.pl/index.php?id=23 Nowe 4 wydanie w twardej oprawie już od 1 października 2015 	Adrian Frutiger	IN_LIBRARY	2015-09-28 16:22:57.024	2015-09-28 16:22:57.024	2	154
126	100 Idei, które zmieniły reklamę	http://www.ceneo.pl/35393268	Simon Veksner	IN_LIBRARY	2016-01-25 13:27:58.245	2016-01-25 13:27:58.245	7	93
63	XML Leksykon kieszonkowy	\N	Eckstein R.	IN_LIBRARY	2014-08-30 10:27:12.559	2014-08-30 10:27:12.559	1	\N
136	Pitch Perfect 	http://www.amazon.com/Pitch-Perfect-Right-First-Every/dp/0062273221/ref=sr_1_6?ie=UTF8&qid=1458124193&sr=8-6&keywords=perfect+pitch	Bill McGowan	IN_LIBRARY	2016-03-16 10:31:21.715	2016-03-16 10:31:21.715	7	110
146	You don`t know JS - THIS & OBJECT PROTOTYPES	http://www.allegro.pl	KYLE SIMPSON	LOST	2016-05-10 10:12:31.178	2016-05-10 10:12:31.178	1	135
156	Infrastructure as Code: Managing Servers in the Cloud	https://www.amazon.com/Infrastructure-Code-Managing-Servers-Cloud/dp/1491924357/ref=sr_1_4?s=books&ie=UTF8&qid=1466413523&sr=1-4&keywords=site+reliability+engineering	Kief Morris	IN_LIBRARY	2016-06-20 09:12:23.621	2016-06-20 09:12:23.621	3	8
166	Haskell programming from first principles	https://gumroad.com/l/haskellbook	Christopher Allen, Julie Moronuki	LOST	2016-06-27 00:03:20.408	2016-06-27 00:03:20.408	6	5
176	Functional Reactive Programming	https://www.manning.com/books/functional-reactive-programming	Stephen  Blackheath	IN_LIBRARY	2016-08-18 09:46:28.214	2016-08-18 09:46:28.214	6	135
186	Future Files: A Brief History of the Next 50 Years	https://www.amazon.com/Future-Files-Brief-History-Years/dp/1857885341/ref=tmm_pap_swatch_0?_encoding=UTF8&qid=1480184856&sr=8-1	Richard Watson	IN_LIBRARY	2016-11-26 18:38:21.7	2016-11-26 18:38:21.7	7	29
196	The Hard Thing About Hard Things	http://allegro.pl/ben-horowitz-the-hard-thing-about-hard-things-buil-i6676031716.html?reco_id=7a0ca182-e239-11e6-8d07-02640201d819&ars_rule_id=201	Ben Horowitz	IN_LIBRARY	2017-01-24 13:33:40.635	2017-01-24 13:33:40.635	7	164
206	The Lean Product Playbook: How to Innovate with Minimum Viable Products and Rapid Customer Feedback	https://www.amazon.com/Lean-Product-Playbook-Innovate-Products/dp/1118960874/ref=tmm_hrd_swatch_0?_encoding=UTF8&qid=1492715196&sr=8-6	Dan Olsen	IN_LIBRARY	2017-04-20 19:09:04.944	2017-04-20 19:09:04.944	7	29
216	Extreme Ownership: How U.S. Navy SEALs Lead and Win	https://www.amazon.com/Extreme-Ownership-U-S-Navy-SEALs/dp/1250067057/ref=tmm_hrd_swatch_0?_encoding=UTF8&qid=&sr=	Jocko Willink	IN_LIBRARY	2017-06-19 13:12:43.761	2017-06-19 13:12:43.761	7	164
226	Lean Software Development: An Agile Toolkit 	https://www.amazon.com/Lean-Software-Development-Agile-Toolkit/dp/0321150783	Mary Poppendieck, Tom Poppendieck	IN_LIBRARY	2017-10-04 09:53:56.086	2017-10-04 09:53:56.086	7	58
236	Labirynty Scruma	http://labiryntyscruma.pl/	Jacek Wieczorek	IN_LIBRARY	2017-12-21 14:42:43.349	2017-12-21 14:42:43.349	7	66
246	Getting to Yes: Negotiating Agreement Without Giving In	https://www.amazon.com/Getting-Yes-Negotiating-Agreement-Without/dp/0140157352	 Roger Fisher	IN_LIBRARY	2018-02-28 09:35:44.362	2018-02-28 09:35:44.362	7	67
256	The Sales Development Playbook	https://www.amazon.com/Sales-Development-Playbook-Repeatable-Accelerate/dp/0692622039	Trish Bertuzzi	IN_LIBRARY	2018-03-21 17:20:06.094	2018-03-21 17:20:06.094	7	136
62	Thinking in Java	\N	Eckel B.	IN_LIBRARY	2014-08-30 10:27:12.557	2014-08-30 10:27:12.557	1	\N
72	JavaScript Rozmówki	\N	Wenz C.	IN_LIBRARY	2014-08-30 10:27:12.58	2014-08-30 10:27:12.58	1	\N
82	The little book on CoffeeScript	http://shop.oreilly.com/product/0636920024309.do	MacCaw A., Ashkenas J.	IN_LIBRARY	2014-09-02 12:27:31.189	2014-09-02 12:27:31.189	1	109
90	Mobile First	http://www.amazon.com/Mobile-First-Luke-Wroblewski/dp/1937557022/ref=sr_1_1?ie=UTF8&qid=1417100026&sr=8-1&keywords=mobile+first	Luke Wroblewski	LOST	2014-11-27 14:57:39.052	2014-11-27 14:57:39.052	1	112
99	Product Design for the Web: Principles of Designing and Releasing Web Products 	http://www.amazon.com/Product-Design-Web-Principles-Designing/dp/0321929039	 Randy J. Hunt	LOST	2014-11-28 14:41:37.193	2014-11-28 14:41:37.193	2	54
108	Drive: The Surprising Truth About What Motivates Us	http://www.amazon.com/Drive-Surprising-Truth-About-Motivates/dp/1594484805	Daniel H. Pink 	IN_LIBRARY	2015-09-24 09:46:34.335	2015-09-24 09:46:34.335	7	44
118	Speaking JavaScript: An In-Depth Guide for Programmers	http://shop.oreilly.com/product/0636920029564.do?cmp=af-prog-books-videos-product_cj_9781449364984_%25zp	Dr. Axel Rauschmayer	IN_LIBRARY	2015-09-30 12:35:07.327	2015-09-30 12:35:07.327	6	65
127	SOFTWARE 30 Days How Agile Manage	http://allegro.pl/ken-schwaber-in-software-30-days-how-agile-manage-i5986109041.html	Ken Schwaber	IN_LIBRARY	2016-02-21 08:30:08.509	2016-02-21 08:30:08.509	7	106
137	Leaders Eat Last: Why Some Teams Pull Together and Others Don’t	http://www.amazon.com/Leaders-Eat-Last-Together-Others/dp/1591845327/ref=sr_1_1?ie=UTF8&qid=1458131719&sr=8-1&keywords=leader	Simon Sinek	IN_LIBRARY	2016-03-16 12:37:13.771	2016-03-16 12:37:13.771	7	44
147	You don`t know JS - SCOPE & CLOSURES	http://www.allegro.pl	KYLE SIMPSON	LOST	2016-05-10 10:13:01.505	2016-05-10 10:13:01.505	1	135
157	Playing to win: How Strategy really works	https://www.amazon.co.uk/Playing-Win-Strategy-Really-Works/dp/142218739X	A.G. Lafley and Roger L. Martin	LOST	2016-06-20 09:32:42.777	2016-06-20 09:32:42.777	7	23
167	Growth Hacker Marketing 	https://www.amazon.com/Growth-Hacker-Marketing-Primer-Advertising-ebook/dp/B00INIXL3O/ref=sr_1_1?s=digital-text&ie=UTF8&qid=1467105152&sr=1-1&keywords=growth+hacker+marketing#navbar	Ryan Holiday	IN_LIBRARY	2016-06-28 09:14:57.931	2016-06-28 09:14:57.931	7	93
177	SurviveJS - Webpack and React: From apprentice to master	https://www.amazon.com/SurviveJS-Webpack-React-apprentice-master/dp/152391050X/ref=sr_1_5?s=books&ie=UTF8&qid=1474876914&sr=1-5&keywords=react	Juho Vepsalainen	IN_LIBRARY	2016-09-26 08:29:22.234	2016-09-26 08:29:22.234	6	135
187	The Art of Explanation: Making your Ideas, Products, and Services Easier to Understand	https://www.amazon.com/Art-Explanation-Products-Services-Understand/dp/1118374584/ref=pd_rhf_se_s_cp_11?_encoding=UTF8&psc=1&refRID=K6G612Z2RE3W2EAH14CJ	Lee LeFever	IN_LIBRARY	2016-12-14 13:07:59.36	2016-12-14 13:07:59.36	2	29
197	Zero to one (PL)	https://www.amazon.com/Zero-One-Notes-Startups-Future/dp/0804139296	Peter Thiel	IN_LIBRARY	2017-02-07 11:57:27.505	2017-02-07 11:57:27.505	7	135
207	Learning Web-based Virtual Reality: Build and Deploy Web-based Virtual Reality Technology	https://www.amazon.com/Learning-Web-based-Virtual-Reality-Technology/dp/1484227093/ref=sr_1_2?s=books&ie=UTF8&qid=1492759905&sr=1-2&keywords=vr+javascript	Srushtika Neelakantam, Tanay Pant	IN_LIBRARY	2017-04-21 07:37:05.366	2017-04-21 07:37:05.366	1	27
217	Extreme Ownership: How U.S. Navy SEALs Lead and Win	https://www.kobo.com/ww/en/ebook/extreme-ownership	Jocko Willink	IN_LIBRARY	2017-06-19 13:12:54.998	2017-06-19 13:12:54.998	7	164
227	The Great ScrumMaster #ScrumMasterWay	https://www.amazon.ca/Great-ScrumMaster-ScrumMasterWay-Zuzana-Sochova/dp/013465711X	Zuzana Sohova	IN_LIBRARY	2017-10-06 13:46:35.853	2017-10-06 13:46:35.853	7	118
237	Implementing Domain-Driven Design	https://www.amazon.com/gp/product/0321834577?ie=UTF8&tag=martinfowlerc-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=0321834577	Vaughn Vernon	IN_LIBRARY	2017-12-25 16:41:31.48	2017-12-25 16:41:31.48	6	112
257	Narodziny Marki	https://pomagam.pl/3azjjk0d	Jacek Kłosiński	IN_LIBRARY	2018-04-12 07:30:48.812	2018-04-12 07:30:48.812	2	168
267	Why Simple Wins: Escape the Complexity Trap and Get to Work That Matters	https://www.amazon.com/Why-Simple-Wins-Complexity-Matters/dp/1629561290/ref=pd_bxgy_14_2/131-1562350-4403417?_encoding=UTF8&pd_rd_i=1629561290&pd_rd_r=DWZZQFJKVY150JENGWHC&pd_rd_w=FKCGa&pd_rd_wg=ZwKyl&psc=1&refRID=DWZZQFJKVY150JENGWHC	Lisa Bodell	REQUESTED	2018-05-30 05:54:31.246	2018-05-30 05:54:31.246	7	142
73	HTTP Leksykon kieszonkowy	\N	Wong C.	IN_LIBRARY	2014-08-30 10:27:12.582	2014-08-30 10:27:12.582	1	\N
83	The 7 Habits of Highly Effective People: Powerful Lessons in Personal Change	http://www.amazon.com/Habits-Highly-Effective-People-Powerful/dp/1451639619/ref=sr_1_5?s=books&ie=UTF8&qid=1409667055&sr=1-5&keywords=management	Stephen R. Covey 	IN_LIBRARY	2014-09-02 14:15:46.411	2014-09-02 14:15:46.411	7	44
100	Designing Brand Identity: An Essential Guide for the Whole Branding Team, 4th Edition	http://www.amazon.com/Designing-Brand-Identity-Essential-Branding/dp/1118099206	Alina Wheeler 	IN_LIBRARY	2014-11-28 14:42:08.125	2014-11-28 14:42:08.125	2	54
109	Building Microservices	http://www.amazon.com/Building-Microservices-Sam-Newman/dp/1491950358/ref=sr_1_1?s=books&ie=UTF8&qid=1443097342&sr=1-1&keywords=Building+Microservices	Sam Newman	IN_LIBRARY	2015-09-24 12:24:16.024	2015-09-24 12:24:16.024	6	8
119	Enterprise Integration Patterns	http://www.amazon.com/o/asin/0321200683/ref=nosim/enterpriseint-20	Gregor Hohpe	IN_LIBRARY	2015-09-30 12:39:11.979	2015-09-30 12:39:11.979	6	18
128	Programming Collective Intelligence: Building Smart Web 2.0 Applications	http://www.amazon.com/Programming-Collective-Intelligence-Building-Applications/dp/0596529325	Toby Segaran	IN_LIBRARY	2016-02-29 12:40:12.876	2016-02-29 12:40:12.876	1	109
138	Site Reliability Engineering Production Systems	http://www.amazon.com/Site-Reliability-Engineering-Production-Systems/dp/149192912X	Jennifer Petoff, Niall Richard Murphy, Betsy Beyer, Chris Jones	IN_LIBRARY	2016-04-09 09:15:26.008	2016-04-09 09:15:26.008	6	8
148	You don`t know JS - ASYNC & PERFORMANCE	http://www.allegro.pl	KYLE SIMPSON	IN_LIBRARY	2016-05-10 10:14:13.056	2016-05-10 10:14:13.056	1	135
158	Logo: The Reference Guide to Symbols and Logotypes	https://www.amazon.com/Logo-Reference-Guide-Symbols-Logotypes/dp/1780671806/ref=zg_bs_3564965011_3	Michael Evamy	LOST	2016-06-20 09:51:44.987	2016-06-20 09:51:44.987	2	57
168	The Ultimate Beginner’s Guide to Search Engine Optimization	https://www.amazon.com/SEO-Like-Im-Beginners-Optimization-ebook/dp/B00M6RPH5S/ref=sr_1_1?s=digital-text&ie=UTF8&qid=1467105217&sr=1-1&keywords=The+Ultimate+Beginner%E2%80%99s+Guide+to+Search+Engine+Optimization#navbar	Matthew Capala	LOST	2016-06-28 09:15:46.36	2016-06-28 09:15:46.36	7	93
178	Kotlin for Android Developers: Learn Kotlin the easy way while developing an Android App	https://www.amazon.com/Kotlin-Android-Developers-Learn-developing/dp/1530075610/ref=sr_1_1?ie=UTF8&qid=1474878553&sr=8-1&keywords=kotlin	Antonio Leiva	IN_LIBRARY	2016-09-26 08:42:07.502	2016-09-26 08:42:07.502	3	135
188	Content Everywhere: Strategy and Structure for Future-Ready Content	https://www.amazon.com/Content-Everywhere-Strategy-Structure-Future-Ready/dp/193382087X/ref=sr_1_16?ie=UTF8&qid=1481721532&sr=8-16&keywords=rosenfeld+media	Sara Wachter-Boettcher	IN_LIBRARY	2016-12-15 13:09:03.853	2016-12-15 13:09:03.853	2	29
198	Zero to one (ENG)	https://www.amazon.com/Zero-One-Notes-Startups-Future/dp/0804139296	Peter Thiel	IN_LIBRARY	2017-02-07 11:57:59.318	2017-02-07 11:57:59.318	7	135
208	HOW TO DESIGN 3D GAMES WITH WEB TECHNOLOGY - BOOK 01: Three.js – HTML5 and WebGL	https://www.amazon.com/HOW-DESIGN-GAMES-WEB-TECHNOLOGY/dp/1520547455/ref=sr_1_3?s=books&ie=UTF8&qid=1492760392&sr=1-3&keywords=three.js	Jordi Josa	REQUESTED	2017-04-21 07:42:05.9	2017-04-21 07:42:05.9	1	27
218	Extreme Ownership: How U.S. Navy SEALs Lead and Win	https://www.kobo.com/ww/en/ebook/extreme-ownership	Jocko Willink	IN_LIBRARY	2017-06-19 13:13:09.458	2017-06-19 13:13:09.458	7	164
228	Working Effectively with Legacy Code	https://www.amazon.de/Working-Effectively-Legacy-Robert-Martin/dp/0131177052	Michael C. Feathers	IN_LIBRARY	2017-10-31 15:04:54.728	2017-10-31 15:04:54.728	6	6
238	Discipline Equals Freedom: Field Manual	https://www.amazon.com/Discipline-Equals-Freedom-Field-Manual/dp/1250156947	Jocko Willink	IN_LIBRARY	2018-01-08 11:40:23.682	2018-01-08 11:40:23.682	7	111
248	The Little Elixir & OTP Guidebook	https://www.amazon.com/Little-Elixir-OTP-Guidebook/dp/1633430111/ref=pd_sbs_14_1?_encoding=UTF8&pd_rd_i=1633430111&pd_rd_r=Y64CQ5JMCB72K99Y49ZX&pd_rd_w=TOGx9&pd_rd_wg=Zfuny&psc=1&refRID=Y64CQ5JMCB72K99Y49ZX	Benjamin Tan Wei Hao 	IN_LIBRARY	2018-03-01 07:44:48.211	2018-03-01 07:44:48.211	6	112
258	Irresistible APIs. Designing web APIs that developers will love	https://www.manning.com/books/irresistible-apis	Kirsten L. Hunter	REQUESTED	2018-04-15 14:26:33.915	2018-04-15 14:26:33.915	1	181
268	Agile Retrospectives	https://www.amazon.com/Agile-Retrospectives-Making-Pragmatic-Programmers-ebook/dp/B00B03SRJW	E. Derby, D. Larsen	REQUESTED	2018-05-30 08:57:30.29	2018-05-30 08:57:30.29	7	209
64	JavaScript Leksykon kieszonkowy	\N	Flanagan D.	IN_LIBRARY	2014-08-30 10:27:12.562	2014-08-30 10:27:12.562	1	\N
74	Maintainable JavaScript	\N	Zakas N.C.	IN_LIBRARY	2014-08-30 10:27:12.584	2014-08-30 10:27:12.584	1	\N
84	Beginning Haskell	http://www.apress.com/9781430262503	Alejandro Serrano Mena	DELETED	2014-09-03 08:18:20.259	2014-09-03 08:18:20.259	6	161
91	The Elements of Content Strategy	http://www.amazon.com/Elements-Content-Strategy-People-Websites/dp/B004ZRFJ4G/ref=sr_1_1?ie=UTF8&qid=1417100321&sr=8-1&keywords=The+Elements+of+Content+Strategy	Erin Kissane	DELETED	2014-11-27 14:59:16.377	2014-11-27 14:59:16.377	2	112
101	Developing a React.js Edge	http://shop.oreilly.com/product/9781939902122.do	Frankie Bagnardi, Jonathan Beebe, Richard Feldman, Tom Hallett, Simon Højberg, Karl Mikkelsen	IN_LIBRARY	2014-12-06 22:52:46.877	2014-12-06 22:52:46.877	1	101
110	API Architecture: The Big Picture for Building APIs	http://www.amazon.com/API-Architecture-Picture-Building-University/dp/150867664X/ref=la_B00NYY3ZS8_1_2?s=books&ie=UTF8&qid=1443097439&sr=1-2	Matthias Biehl	IN_LIBRARY	2015-09-24 12:24:44.085	2015-09-24 12:24:44.085	1	8
120	Non-violent communication	http://www.amazon.com/Nonviolent-Communication-Language-Marshall-Rosenberg/dp/1892005034/ref=sr_1_1?s=books&ie=UTF8&qid=1443617684&sr=1-1&keywords=non-violent+communication	Marshall B. Rosenberg	LOST	2015-09-30 12:55:32.89	2015-09-30 12:55:32.89	7	44
129	Articulating Design Decisions: Communicate with Stakeholders, Keep Your Sanity, and Deliver the Best User Experience	http://www.amazon.com/Articulating-Design-Decisions-Communicate-Stakeholders/dp/1491921560	Tom Greever	IN_LIBRARY	2016-03-16 10:13:10.587	2016-03-16 10:13:10.587	2	54
139	Deep Work: Rules for Focused Success in a Distracted World	http://www.amazon.com/Deep-Work-Focused-Success-Distracted/dp/0349413681/ref=tmm_pap_swatch_0?_encoding=UTF8&qid=&sr=	Cal Newport	IN_LIBRARY	2016-04-15 08:14:41.515	2016-04-15 08:14:41.515	7	109
149	You don`t know JS - ES6 & Beyond	http://www.amazon.com/You-Dont-Know-JS-Beyond/dp/1491904240/ref=sr_1_1?ie=UTF8&qid=1462875540&sr=8-1&keywords=you+dont+know+JS+ES6	KYLE SIMPSON	LOST	2016-05-10 10:19:57.767	2016-05-10 10:19:57.767	1	135
159	How to Use Graphic Design to Sell Things, Explain Things, Make Things Look Better, Make People Laugh, Make People Cry, and (Every Once in a While) Change the World	https://www.amazon.com/Graphic-Design-Things-Explain-Better/dp/0062413902/ref=pd_sim_14_4?ie=UTF8&dpID=51poDjoapYL&dpSrc=sims&preST=_AC_UL320_SR308%2C320_&refRID=NXD37MFWH16PDWQMWK2V	Michael Bierut	LOST	2016-06-20 09:52:49.991	2016-06-20 09:52:49.991	2	57
169	Domain-Driven Design: Tackling Complexity in the Heart of Software	https://www.amazon.com/Domain-Driven-Design-Tackling-Complexity-Software/dp/0321125215?ie=UTF8&qid=1467140320&ref_=la_B001KDCO2I_1_1&s=books&sr=1-1	Eric Evans	IN_LIBRARY	2016-06-28 19:01:22.469	2016-06-28 19:01:22.469	6	144
179	Two Scoops of Django: Best Practices for Django 1.8 	https://www.amazon.com/Two-Scoops-Django-Best-Practices/dp/0981467342	Daniel Roy Greenfeld, Audrey Roy Greenfel	IN_LIBRARY	2016-09-26 09:25:24.328	2016-09-26 09:25:24.328	6	149
189	Metaprogramming Elixir: Write Less Code, Get More Done (and Have Fun!)	https://www.amazon.com/Metaprogramming-Elixir-Write-Less-Code/dp/1680500414/ref=sr_1_1?ie=UTF8&qid=1482748072&sr=8-1&keywords=metaprogramming+elixir	Chris McCord 	IN_LIBRARY	2016-12-26 10:30:57.038	2016-12-26 10:30:57.038	6	112
199	Designing Data-Intensive Applications	https://www.amazon.com/Designing-Data-Intensive-Applications-Reliable-Maintainable/dp/1449373321/ref=sr_1_1?ie=UTF8&qid=1487352797&sr=8-1&keywords=Designing+Data-Intensive+Applications	Martin Kleppmann	IN_LIBRARY	2017-02-17 17:34:35.642	2017-02-17 17:34:35.642	6	144
209	Mastering Bitcoin: Unlocking Digital Cryptocurrencies	https://www.amazon.com/Mastering-Bitcoin-Unlocking-Digital-Cryptocurrencies/dp/1449374042	Andreas M. Antonopoulos	IN_LIBRARY	2017-04-21 10:07:55.694	2017-04-21 10:07:55.694	6	149
219	Extreme Ownership: How U.S. Navy SEALs Lead and Win	https://www.amazon.com/Extreme-Ownership-U-S-Navy-SEALs/dp/1250067057/ref=tmm_hrd_swatch_0?_encoding=UTF8&qid=&sr=	Jocko Willink	IN_LIBRARY	2017-06-19 13:13:20.495	2017-06-19 13:13:20.495	7	164
229	Clean Language	https://www.amazon.com/Clean-Language-Revealing-Metaphors-Opening/dp/1845901258/ref=sr_1_1?ie=UTF8&qid=1509976761&sr=8-1&keywords=clean+language	Judy Rees	IN_LIBRARY	2017-11-06 13:59:50.95	2017-11-06 13:59:50.95	7	22
65	Java. Concurrency in practice.	\N	Goetz B.	IN_LIBRARY	2014-08-30 10:27:12.564	2014-08-30 10:27:12.564	6	\N
75	Scaling up Excellence	http://www.amazon.com/Scaling-up-Excellence-Robert-Sutton-ebook/dp/B00EKOBXKI/ref=tmm_kin_swatch_0?_encoding=UTF8&sr=&qid=	Robert I. Sutton, Hayagreeva Rao	IN_LIBRARY	2014-09-01 18:08:08.78	2014-09-01 18:08:08.78	7	20
85	Art of Multiprocessor Programming	http://www.amazon.com/Art-Multiprocessor-Programming-Revised-Reprint/dp/0123973376/ref=sr_1_1?s=books&ie=UTF8&qid=1409925180&sr=1-1&keywords=art+of+multiprocessor+programming	Maurice Herlihy, Nir Shavit	IN_LIBRARY	2014-09-05 13:54:10.744	2014-09-05 13:54:10.744	6	5
92	The Lean Startup: How Today's Entrepreneurs Use Continuous Innovation to Create Radically Successful Businesses	http://www.amazon.com/dp/0307887898?tag=lessolearn01-20&camp=213381&creative=390973&linkCode=as4&creativeASIN=0307887898&adid=004DZWTQ0HQTRCNYZJPD	Eric Ries	IN_LIBRARY	2014-11-27 20:31:22.671	2014-11-27 20:31:22.671	7	54
102	The Complete Recruitment Survival Guide	http://www.amazon.com/The-Complete-Recruitment-Survival-Guide/dp/0955636302	Ayub Shaikh	IN_LIBRARY	2015-01-12 12:03:44.841	2015-01-12 12:03:44.841	7	44
111	Work Rules!	http://www.amazon.com/Work-Rules-Insights-Inside-Transform/dp/1455554790	Laszlo Bock	LOST	2015-09-24 12:38:30.545	2015-09-24 12:38:30.545	7	44
121	Functional Programming in Swift	http://www.amazon.co.uk/Functional-Programming-Swift-Chris-Eidhof/dp/3000480056/ref=sr_1_1?s=books&ie=UTF8&qid=1444584706&sr=1-1&keywords=swift+functional	 Florian Kugler	IN_LIBRARY	2015-10-11 17:33:48.993	2015-10-11 17:33:48.993	3	5
130	Sprint: How to Solve Big Problems and Test New Ideas in Just Five Days	http://www.amazon.com/Sprint-Solve-Problems-Test-Ideas/dp/150112174X/ref=asap_bc?ie=UTF8	Jake Knapp	IN_LIBRARY	2016-03-16 10:13:40.359	2016-03-16 10:13:40.359	2	54
140	Life's a Pitch: How to Sell Yourself and Your Brilliant Ideas	http://www.amazon.com/Lifes-Pitch-Yourself-Brilliant-Ideas/dp/0552156833/ref=tmm_pap_swatch_0?_encoding=UTF8&qid=1460707887&sr=1-1	Roger Mavity	IN_LIBRARY	2016-04-15 08:15:44.281	2016-04-15 08:15:44.281	7	109
150	Tajemnice JavaScriptu Podręcznik Ninja	http://helion.pl/ksiazki/tajemnice-javascriptu-podrecznik-ninja-john-resig-bear-bibeault,tajani.htm	John Resig, Bear Bibeault	IN_LIBRARY	2016-05-19 08:46:33.634	2016-05-19 08:46:33.634	6	135
160	Grid Systems in Graphic Design: A Visual Communication Manual for Graphic Designers, Typographers and Three Dimensional Designers (German and English Edition)	https://www.amazon.com/Grid-Systems-Graphic-Design-Communication/dp/3721201450/ref=pd_sim_14_9?ie=UTF8&dpID=51KBThjsvqL&dpSrc=sims&preST=_AC_UL160_SR112%2C160_&refRID=YMN41QQAH8YCBKPD6PKB	Josef Müller-Brockmann	IN_LIBRARY	2016-06-20 09:59:12.584	2016-06-20 09:59:12.584	2	57
259	Adopting Elixir: From Concept to Production 	https://www.amazon.com/Adopting-Elixir-Production-Ben-Marx/dp/1680502522/ref=sr_1_1?ie=UTF8&qid=1523865220&sr=8-1&keywords=adopting+elixir	Ben Marx, Jose Valim, Bruce Tate 	IN_LIBRARY	2018-04-16 07:54:31.017	2018-08-01 12:01:58.457697	6	112
269	Agile Estimating and Planning	https://www.amazon.com/gp/product/0131479415/ref=as_li_ss_tl?ie=UTF8&tag=thepragmana-20&linkCode=as2&camp=217145&creative=399369&creativeASIN=0131479415	Mike Cohn	IN_LIBRARY	2018-05-30 08:58:06.013	2018-08-01 12:03:06.638197	7	209
170	SCRUM czyli jak robić dwa razy więcej dwa razy szybciej	http://ksiegarnia.pwn.pl/Scrum-Czyli-jak-robic-dwa-razy-wiecej-dwa-razy-szybciej,114592110,p.html	Jeff Sutherland	IN_LIBRARY	2016-07-20 07:39:39.488	2016-07-20 07:39:39.488	7	135
180	Gamestorming: A Playbook for Innovators, Rulebreakers, and Changemakers	https://www.amazon.com/Gamestorming-Playbook-Innovators-Rulebreakers-Changemakers/dp/0596804172/ref=sr_1_1?ie=UTF8&qid=1474890904&sr=8-1&keywords=gamestorming	Dave Gray	IN_LIBRARY	2016-09-26 11:55:30.071	2016-09-26 11:55:30.071	2	29
190	Brutal London: Construct Your Own Concrete Capital	https://www.amazon.com/Brutal-London-Construct-Concrete-Capital/dp/3791383000/ref=sr_1_1?s=books&ie=UTF8&qid=1482932993&sr=1-1&keywords=brutal+london	Norman Foster, Zupagrafika	IN_LIBRARY	2016-12-28 13:53:49.79	2016-12-28 13:53:49.79	2	24
200	Kotlin in Action	https://www.amazon.com/Kotlin-Action-Dmitry-Jemerov/dp/1617293296	Dmitry Jemerov, Svetlana Isakova	IN_LIBRARY	2017-02-26 14:04:47.148	2017-02-26 14:04:47.148	3	140
210	Print Control no.5	http://www.printcontrol.pl/?p=5467	Magdalena Heliasz, praca zbiorowa	IN_LIBRARY	2017-04-28 13:34:11.028	2017-04-28 13:34:11.028	2	164
220	Extreme Ownership: How U.S. Navy SEALs Lead and Win	https://www.kobo.com/ww/en/ebook/extreme-ownership	Jocko Willink	IN_LIBRARY	2017-06-19 13:13:32.249	2017-06-19 13:13:32.249	7	164
230	Nonviolent Communication: A Language of Life, 3rd Edition: Life-Changing Tools for Healthy Relationships (Nonviolent Communication Guides)	https://www.amazon.de/Nonviolent-Communication-Language-Life-Changing-Relationships/dp/189200528X	Marshal B. Rosenberg	IN_LIBRARY	2017-11-06 14:15:31.951	2017-11-06 14:15:31.951	7	142
240	Bitcoin and Cryptocurrency Technologies: A Comprehensive Introduction	https://www.amazon.com/Bitcoin-Cryptocurrency-Technologies-Comprehensive-Introduction/dp/0691171696	Andrew Miller, Arvind Narayanan, Edward Felten, Joseph Bonneau, and Steven Goldfeder	IN_LIBRARY	2018-01-08 13:58:07.651	2018-01-08 13:58:07.651	6	149
66	Core Java 2 Techniki zaawansowane	\N	Hortsmann C.S., Cornell G.	IN_LIBRARY	2014-08-30 10:27:12.567	2014-08-30 10:27:12.567	6	\N
76	Manager as Coach: The New Way to Get Results	http://www.mheducation.co.uk/html/0077140184.html	Jenny Rogers, Karen Whittleworth, Andrew Gilbert	DELETED	2014-09-02 10:38:05.38	2014-09-02 10:38:05.38	7	109
86	Functional programming in Swift	http://www.objc.io/books/#early-access	Chris Eidhof	DELETED	2014-09-19 11:56:38.337	2014-09-19 11:56:38.337	3	5
115	Erlang and OTP in Action	http://www.amazon.com/Erlang-OTP-Action-Martin-Logan/dp/1933988789/	Martin Logan, Eric Merritt, Richard Carlsson	IN_LIBRARY	2015-09-25 09:55:40.481	2015-09-25 09:55:40.481	6	107
93	Tribal Leadership: Leveraging Natural Groups to Build a Thriving Organization	http://www.amazon.com/Tribal-Leadership-Leveraging-Thriving-Organization/dp/0061251321/ref=sr_1_sc_1?s=books&ie=UTF8&qid=1414866078&sr=1-1-spell&keywords=Tribal+lidership.	Dave Logan (Author), John King (Author), Halee Fischer-Wright (Author)	IN_LIBRARY	2014-11-27 20:31:59.699	2014-11-27 20:31:59.699	7	54
103	Algorytmy + struktury danych = programy	http://lubimyczytac.pl/ksiazka/122213/algorytmy-struktury-danych-programy	Niklaus Wirth	IN_LIBRARY	2015-01-21 15:20:22.919	2015-01-21 15:20:22.919	6	109
112	How Google Works	http://www.amazon.com/How-Google-Works-Eric-Schmidt/dp/1455582344	Eric Schmidt 	IN_LIBRARY	2015-09-24 12:40:37.941	2015-09-24 12:40:37.941	7	44
122	CSS Secrets	http://www.amazon.com/CSS-Secrets-Solutions-Everyday-Problems/dp/1449372635	Lea Verou	LOST	2015-10-23 09:12:40.701	2015-10-23 09:12:40.701	1	160
131	The Design Method: A Philosophy and Process for Functional Visual Communication	http://www.amazon.com/gp/product/0321928849/ref=as_li_tf_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0321928849&linkCode=as2&tag=sm01e-20	\N	IN_LIBRARY	2016-03-16 10:14:04.74	2016-03-16 10:14:04.74	2	54
141	Beyond Measure: The Big Impact of Small Changes	http://www.amazon.com/Beyond-Measure-Impact-Small-Changes/dp/1476784906/ref=sr_1_5?s=books&ie=UTF8&qid=1460708314&sr=1-5&keywords=TED+books	\tMargaret Heffernan	IN_LIBRARY	2016-04-15 08:22:11.531	2016-04-15 08:22:11.531	7	109
151	Measuring the User Experience	https://www.amazon.com/Measuring-User-Experience-Second-Technologies/dp/0124157815	William Albert	IN_LIBRARY	2016-06-10 12:25:53.878	2016-06-10 12:25:53.878	2	23
161	Android Programming: The Big Nerd Ranch Guide (Big Nerd Ranch Guides)	https://www.amazon.com/Android-Programming-Ranch-Guide-Guides-ebook/dp/B00C893P8U?ie=UTF8&tag=top-books-cs-20	BILL PHILLIPS and BRIAN HARDY	IN_LIBRARY	2016-06-20 10:17:24.318	2016-06-20 10:17:24.318	3	90
171	Fifty Quick Ideas To Improve Your User Stories	https://www.amazon.com/Fifty-Quick-Ideas-Improve-Stories-ebook/dp/B00OGT2U7M	Gojko Adzic	IN_LIBRARY	2016-08-05 11:43:47.043	2016-08-05 11:43:47.043	7	123
181	The Phoenix Project: A Novel about IT, DevOps, and Helping Your Business Win	https://www.amazon.com/Phoenix-Project-DevOps-Helping-Business/dp/0988262509	Gene Kim, Kevin Behr, George Spafford	IN_LIBRARY	2016-09-28 21:51:08.212	2016-09-28 21:51:08.212	6	8
191	Tools of Titans	https://www.amazon.com/Tools-Titans-Billionaires-World-Class-Performers/dp/1328683788/ref=pd_sim_14_2?_encoding=UTF8&psc=1&refRID=GFKDVQ8JDRKT5J7S1Y51	Timothy Ferriss	IN_LIBRARY	2016-12-29 15:51:06.263	2016-12-29 15:51:06.263	7	106
201	Zastosowanie XML do tworzenia usług internetowych na platformie microsoft .net	hhtp://www.google.com	Scott Short	IN_LIBRARY	2017-03-06 10:45:25.256	2017-03-06 10:45:25.256	1	135
211	Extreme Ownership: How U.S. Navy SEALs Lead and Win 	https://www.amazon.com/Extreme-Ownership-U-S-Navy-SEALs/dp/1250067057/ref=tmm_hrd_swatch_0?_encoding=UTF8&qid=&sr=	Jocko Willink 	IN_LIBRARY	2017-05-24 08:56:36.493	2017-05-24 08:56:36.493	7	164
221	Nieświadome wybory	http://www.mtbiznes.pl/b2132-nieswiadome-wybory.htm	Jonah Berger	IN_LIBRARY	2017-07-19 06:31:18.476	2017-07-19 06:31:18.476	7	135
241	Scaling Lean: Mastering the Key Metrics for Startup Growth	https://www.amazon.com/Scaling-Lean-Mastering-Metrics-Startup/dp/1101980524/ref=sr_1_1?ie=UTF8&qid=1515511219&sr=8-1&keywords=scaling+lean	Ash Maurya	IN_LIBRARY	2018-01-09 15:30:50.006	2018-01-09 15:30:50.006	7	169
251	Work Rules!	http://www.empik.com/work-rules-bock-laszlo,p1118551338,ksiazka-p	Laszlo Bock	IN_LIBRARY	2018-03-08 09:07:12.869	2018-03-08 09:07:12.869	7	142
153	Convivial Toolbox: Generative Research for the Front End of Design	https://www.amazon.com/Convivial-Toolbox-Generative-Research-Design/dp/9063692846/188-5455634-2124342?ie=UTF8&*Version*=1&*entries*=0	Liz Sanders, Pieter Jan Stappers	IN_LIBRARY	2016-06-15 21:08:52.492	2016-06-15 21:08:52.492	2	25
270	Succeeding with Agile: Software Development Using Scrum	https://www.amazon.com/gp/product/0321579364/ref=as_li_ss_tl?ie=UTF8&tag=thepragmana-20&linkCode=as2&camp=1789&creative=390957&creativeASIN=0321579364	Mike Cohn	DELETED	2018-05-30 08:58:54.874	2018-07-19 07:33:00.162156	7	209
250	Getting Things Done	https://aros.pl/ksiazka/getting-things-done-czyli-sztuka-bezstresowej-efektywnosci-wydanie-ii	David Allen	IN_LIBRARY	2018-03-08 07:37:38.348	2018-08-01 12:02:37.042066	7	92
271	Coaching Agile Teams	https://www.amazon.com/Coaching-Agile-Teams-ScrumMasters-Addison-Wesley/dp/0321637704	Lyssa Adkins	REQUESTED	2018-05-30 09:01:35.063	2018-05-30 09:01:35.063	7	209
67	Express.js Guide: The Comprehensive Book on Express.js	\N	Mardanov A.	IN_LIBRARY	2014-08-30 10:27:12.569	2014-08-30 10:27:12.569	1	\N
77	Overcoming The Five Dysfunctions of a Team: A Field Guide for Leaders, Managers, and Facilitators	http://www.tablegroup.com/books/dysfunctions#guide	Patrick Lencioni	IN_LIBRARY	2014-09-02 10:39:33.956	2014-09-02 10:39:33.956	7	109
87	Delivering Happiness: A Path to Profits, Passion and Purpose	http://www.amazon.co.uk/Delivering-Happiness-Profits-Passion-Purpose/dp/145550890X/ref=sr_1_1?s=books&ie=UTF8&qid=1412262739&sr=1-1&keywords=delivering+happiness	Tony Hsieh	IN_LIBRARY	2014-10-02 15:13:01.451	2014-10-02 15:13:01.451	7	110
94	Crossing the Chasm, 3rd Edition: Marketing and Selling Disruptive Products to Mainstream Customers	http://www.amazon.com/Crossing-Chasm-3rd-Disruptive-Mainstream/dp/0062292986/ref=sr_1_1?s=books&ie=UTF8&qid=1417120405&sr=1-1&keywords=crossing+chasm	 Geoffrey A. Moore	IN_LIBRARY	2014-11-27 20:34:10.284	2014-11-27 20:34:10.284	7	54
113	BrandingPays: The Five-Step System to Reinvent Your Personal Brand	http://www.amazon.com/gp/product/0988437503?ref_=cm_lmf_img_1	Karen Kang 	IN_LIBRARY	2015-09-24 12:47:50.138	2015-09-24 12:47:50.138	7	44
132	Change by Design: How Design Thinking Transforms Organizations and Inspires Innovation	http://www.amazon.com/gp/product/0061766089?keywords=Change%20by%20Design&qid=1457467235&ref_=sr_1_1&sr=8-1 	 Tim Brown	IN_LIBRARY	2016-03-16 10:15:08.717	2016-03-16 10:15:08.717	2	54
142	The Rule Breakers' Book of Business: Win at Work by Doing Things Differently	http://www.amazon.com/Rule-Breakers-Book-Business-Differently/dp/B010CKLN5I/ref=sr_1_3?s=books&ie=UTF8&qid=1460708837&sr=1-3&keywords=The+Rule+Breaker%27s+Book+of+Business%3A+Win+at+Work+by+Doing+Things+Differently	 Roger, Bayley, Stephen Mavity	IN_LIBRARY	2016-04-15 08:27:56.897	2016-04-15 08:27:56.897	7	109
152	business model generation	https://www.amazon.co.uk/Business-Model-Generation-Visionaries-Challengers/dp/0470876417	 Alexander Osterwalder	IN_LIBRARY	2016-06-10 12:31:03.817	2016-06-10 12:31:03.817	7	23
162	Hooked: How to Build Habit-Forming Products	https://www.amazon.com/gp/product/1591847788/ref=s9_zwish_hd_bw_bhW_g14_i1?pf_rd_m=ATVPDKIKX0DER&pf_rd_s=merchandised-search-6&pf_rd_r=DNXY0S3QBMG2VCJWRV82&pf_rd_t=101&pf_rd_p=4c0187d4-5814-45e0-9476-1af606f5711e&pf_rd_i=2698	Nir Eyal	IN_LIBRARY	2016-06-24 14:50:03.244	2016-06-24 14:50:03.244	7	110
172	Fifty Quick Ideas To Improve Your Retrospectives	https://www.amazon.com/Fifty-Quick-Ideas-Improve-Retrospectives-ebook/dp/B017A5HZWS/ref=pd_sim_351_4?ie=UTF8&dpID=514XQjmGvqL&dpSrc=sims&preST=_OU01__BG0%2C0%2C0%2C0_FMpng_AC_UL160_SR160%2C160_&psc=1&refRID=AF2VCME5H682N3Y8WA11	Tom Roden	IN_LIBRARY	2016-08-05 11:44:25.466	2016-08-05 11:44:25.466	7	123
182	Agile Metrics in Action: How to measure and improve team performance 	https://www.amazon.com/Agile-Metrics-Action-Performance-Christopher/dp/B015X4EFF8	Christopher W. H. Davis	IN_LIBRARY	2016-11-10 10:07:29.35	2016-11-10 10:07:29.35	7	106
192	Startup Manual 	https://startupmanual.ws/pl	Marek Piasek	IN_LIBRARY	2017-01-02 11:44:19.63	2017-01-02 11:44:19.63	7	135
202	Introdcuting Microsoft ASP.NET 2.0	http://www.google.com	Dino Esposito	IN_LIBRARY	2017-03-06 10:46:28.534	2017-03-06 10:46:28.534	6	135
212	Extreme Ownership: How U.S. Navy SEALs Lead and Win	https://www.amazon.com/Extreme-Ownership-U-S-Navy-SEALs/dp/1250067057/ref=tmm_hrd_swatch_0?_encoding=UTF8&qid=&sr=	Jocko Willink 	IN_LIBRARY	2017-05-24 08:58:02.003	2017-05-24 08:58:02.003	7	164
222	Everest lidera	https://www.amazon.de/Everest-Lidera-Anna-Sarnacka-Smith/dp/8380872339	Anna Sarnacka-Smith	REQUESTED	2017-07-19 07:11:34.67	2017-07-19 07:11:34.67	7	148
232	Building Evolutionary Architectures: Support Constant Change	https://www.amazon.com/Building-Evolutionary-Architectures-Support-Constant/dp/1491986360/ref=sr_1_3?s=books&ie=UTF8&qid=1509978176&sr=1-3&keywords=software+architecture	Neal Ford,‎ Rebecca Parsons,‎ Patrick Kua	IN_LIBRARY	2017-11-06 14:24:24.674	2017-11-06 14:24:24.674	6	112
252	Build APIs You Wont Hate	https://www.amazon.com/Build-APIs-You-Wont-Hate/dp/0692232699	Phil Sturgeon	IN_LIBRARY	2018-03-08 14:08:13.867	2018-03-08 14:08:13.867	6	181
68	Nginx HTTP Server	\N	Nedelcu C.	IN_LIBRARY	2014-08-30 10:27:12.571	2014-08-30 10:27:12.571	1	\N
78	Producing Open Source Software: How to Run a Successful Free Software Project	http://www.amazon.com/Producing-Open-Source-Software-Successful-ebook/dp/B0026OR37Q/ref=tmm_kin_swatch_0?_encoding=UTF8&sr=&qid=	Karl Fogel	IN_LIBRARY	2014-09-02 10:40:52.486	2014-09-02 10:40:52.486	6	109
88	The Enterprise and scrum	http://www.amazon.com/Enterprise-Scrum-Developer-Best-Practices/dp/0735623376	Ken Schwaber	IN_LIBRARY	2014-11-21 09:06:08.114	2014-11-21 09:06:08.114	7	109
95	Czysty kod	http://helion.pl/ksiazki/czysty-kod-podrecznik-dobrego-programisty-robert-c-martin,czykod.htm	Robert C. Martin	IN_LIBRARY	2014-11-27 22:45:54.28	2014-11-27 22:45:54.28	6	65
104	Timing for Animation	http://www.amazon.co.uk/Timing-Animation-Harold-Whittaker/dp/0240521609/ref=sr_1_1?ie=UTF8&qid=1427195083&sr=8-1&keywords=Timing+and+animation	Harold Whittaker	IN_LIBRARY	2015-03-24 11:08:12.665	2015-03-24 11:08:12.665	2	112
114	Programming Erlang: Software for a Concurrent World	http://www.amazon.com/Programming-Erlang-Concurrent-Pragmatic-Programmers/dp/193778553X	Joe Armstrong	IN_LIBRARY	2015-09-25 09:53:44.822	2015-09-25 09:53:44.822	6	107
123	JavaScript Web Applicatuions	http://www.amazon.com/JavaScript-Web-Applications-Alex-MacCaw/dp/144930351X/ref=sr_1_sc_1?ie=UTF8&qid=1447437103&sr=8-1-spell&keywords=JavaScript+Web+Applicatuions	Alex MacCaw	IN_LIBRARY	2015-11-13 17:51:50.895	2015-11-13 17:51:50.895	1	112
133	Lean UX: Applying Lean Principles to Improve User Experience	http://www.amazon.com/Lean-UX-Applying-Principles-Experience/dp/1449311652	Jeff Gothelf	LOST	2016-03-16 10:15:37.208	2016-03-16 10:15:37.208	2	54
143	Ogólnopolskie Wystawy Znaków Graficznych	http://www.karakter.pl/ksiazki/ogolnopolskie-wystawy-znakow-graficznych	Rene Wawrzkiewicz, Patryk Hardziej	IN_LIBRARY	2016-04-26 09:26:50.207	2016-04-26 09:26:50.207	2	57
272	The Goal: A Process of Ongoing Improvement	https://www.amazon.com/Goal-Process-Ongoing-Improvement/dp/0884271951	Eliyahu M. Goldratt	REQUESTED	2018-05-30 09:24:52.563	2018-07-30 12:35:01.671432	7	209
242	Functional Programming in Scala	https://www.amazon.com/Functional-Programming-Scala-Paul-Chiusano/dp/1617290653/ref=sr_1_2?ie=UTF8	Paul Chiusano, Rúnar Bjarnason	IN_LIBRARY	2018-01-16 21:59:40.567	2018-08-01 12:03:00.729926	6	144
262	The User's Journey: Storymapping Products That People Love	https://www.amazon.com/Users-Journey-Storymapping-Products-People/dp/1933820314/ref=pd_sim_14_22?_encoding=UTF8&pd_rd_i=1933820314&pd_rd_r=EEMJF5P9WV94RQ4DB7FP&pd_rd_w=YpwCw&pd_rd_wg=9N0hX&psc=1&refRID=EEMJF5P9WV94RQ4DB7FP	Donna Lichaw 	REQUESTED	2018-04-17 13:36:29.069	2018-08-28 11:35:05.42966	2	206
163	Jab, Jab, Jab, Right Hook: How to Tell Your Story in a Noisy Social World	https://www.amazon.com/gp/product/006227306X/ref=s9_zwish_hd_bw_bhW_g14_i7?pf_rd_m=ATVPDKIKX0DER&pf_rd_s=merchandised-search-6&pf_rd_r=DNXY0S3QBMG2VCJWRV82&pf_rd_t=101&pf_rd_p=4c0187d4-5814-45e0-9476-1af606f5711e&pf_rd_i=2698	Gary Vaynerchuk	IN_LIBRARY	2016-06-24 14:50:38.951	2016-06-24 14:50:38.951	7	110
173	What Customers Want: Using Outcome-Driven Innovation to Create Breakthrough Products and Services	https://www.amazon.com/gp/product/0071408673/ref=as_li_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=0071408673&linkCode=as2&tag=swingwiki-20&linkId=CCMSIUVDLKPK2NUF	Anthony Ulwick	IN_LIBRARY	2016-08-05 11:46:56.323	2016-08-05 11:46:56.323	7	123
183	How Brands Grow	https://www.amazon.co.uk/How-Brands-Grow-What-Marketers/dp/0195573560/ref=sr_1_1?ie=UTF8&qid=1479811310&sr=8-1&keywords=how+brands+grow	Byron Sharp	IN_LIBRARY	2016-11-22 10:42:23.035	2016-11-22 10:42:23.035	7	23
193	Codzienne rytuały, jak pracują wielkie umysły	http://lubimyczytac.pl/ksiazka/260755/codzienne-rytualy-jak-pracuja-wielkie-umysly	Mason Currey	IN_LIBRARY	2017-01-11 11:36:39.788	2017-01-11 11:36:39.788	7	164
213	Extreme Ownership: How U.S. Navy SEALs Lead and Win	https://www.kobo.com/ww/en/ebook/extreme-ownership	Jocko Willink	IN_LIBRARY	2017-06-19 13:11:57.874	2017-06-19 13:11:57.874	7	164
223	Kanban and Scrum - making the most of both (Enterprise Software Development)	https://www.amazon.com/Kanban-Scrum-Enterprise-Software-Development/dp/0557138329/ref=sr_1_1?ie=UTF8&qid=1500448187&sr=8-1&keywords=kniberg	Henrik Kniberg	IN_LIBRARY	2017-07-19 07:12:33.546	2017-07-19 07:12:33.546	7	22
233	Spin Selling	https://www.amazon.com/SPIN-selling-Neil-Rackham/dp/0566076896	Neil Rackham	IN_LIBRARY	2017-11-07 08:42:20.629	2017-11-07 08:42:20.629	7	164
243	Mastering Bitcoin: Programming the Open Blockchain	https://www.amazon.com/Mastering-Bitcoin-Programming-Open-Blockchain/dp/1491954388/ref=sr_1_3?ie=UTF8&qid=1518111116&sr=8-3&keywords=mastering+bitcoin	Andreas M. Antonopoulos	REQUESTED	2018-02-08 17:33:11.224	2018-02-08 17:33:11.224	6	112
253	Patterns of Enterprise Application Architecture	https://www.amazon.com/Patterns-Enterprise-Application-Architecture-Martin/dp/0321127420/ref=pd_bxgy_14_img_2/145-1158781-9392641?_encoding=UTF8&pd_rd_i=0321127420&pd_rd_r=BPRSZ09Q4ZE7HFPPVW0H&pd_rd_w=XRRtH&pd_rd_wg=ULmpa&psc=1&refRID=BPRSZ09Q4ZE7HFPPVW0H	Martin Fowler	IN_LIBRARY	2018-03-16 14:18:14.205	2018-03-16 14:18:14.205	6	112
263	Kryptowaluty	https://kryptowaluty.edu.pl/	Michał Grzybkowski, Szczepan Bentyn	REQUESTED	2018-04-30 10:16:43.218	2018-04-30 10:16:43.218	7	169
69	Perl 6 Podstawy	\N	Randal A., Sugalski D., Totsh L.	IN_LIBRARY	2014-08-30 10:27:12.573	2014-08-30 10:27:12.573	6	\N
79	Motion Design for iOS	http://designthencode.com/	Mike Rundle	DELETED	2014-09-02 10:52:14.532	2014-09-02 10:52:14.532	3	81
96	Hacker's Delight (2nd Edition)	http://www.amazon.com/Hackers-Delight-Edition-Henry-Warren/dp/0321842685/ref=pd_sim_b_5?ie=UTF8&refRID=0QWA9NG9ERECX0W7GTVY	Henry S. Warren	IN_LIBRARY	2014-11-28 09:18:58.209	2014-11-28 09:18:58.209	5	5
105	What Did You Say?: The Art of Giving and Receiving Feedback	http://www.amazon.com/What-Did-You-Say-Receiving/dp/0965043002	Charles N. Seashore 	IN_LIBRARY	2015-06-29 10:38:03.596	2015-06-29 10:38:03.596	7	42
124	Adaptive Web Design: Crafting Rich Experiences with Progressive Enhancement	http://www.amazon.com/Adaptive-Web-Design-Experiences-Progressive/dp/098358950X	Aaron Gustafson	LOST	2015-12-17 16:33:46.937	2015-12-17 16:33:46.937	1	160
134	Agile Experience Design: A Digital Designer's Guide to Agile, Lean, and Continuous (Voices That Matter)	http://www.amazon.com/gp/product/0321804813?keywords=Agile%20Experience%20Design&qid=1458122922&ref_=sr_1_1&sr=8-1	\N	IN_LIBRARY	2016-03-16 10:16:08.444	2016-03-16 10:16:08.444	7	54
144	You don`t know JS - TYPES & GRAMMAR	http://www.allegro.pl	KYLE SIMPSON	LOST	2016-05-10 10:11:03.571	2016-05-10 10:11:03.571	1	135
164	The Power of Habit: Why We Do What We Do in Life and Business	https://www.amazon.com/Power-Habit-What-Life-Business/dp/081298160X/ref=sr_1_1?s=books&ie=UTF8&qid=1466779428&sr=1-1&keywords=the+power+of+habit	Charles Duhigg	IN_LIBRARY	2016-06-24 14:51:18.521	2016-06-24 14:51:18.521	7	110
174	Pro React	https://www.amazon.com/Pro-React-Cassio-Sousa-Antonio/dp/1484212614/ref=sr_1_1?ie=UTF8&qid=1470508335&sr=8-1&keywords=pro+react	Cassio de Sousa Antonio 	LOST	2016-08-06 18:32:56.338	2016-08-06 18:32:56.338	1	112
184	Capital in the Twenty-First Century	https://www.amazon.com/Capital-Twenty-Century-Thomas-Piketty/dp/067443000X/ref=tmm_hrd_swatch_0?_encoding=UTF8&qid=1480184988&sr=8-1	Thomas Piketty	IN_LIBRARY	2016-11-26 18:34:27.725	2016-11-26 18:34:27.725	7	29
194	Clean Architecture	https://www.amazon.com/Clean-Architecture-Robert-C-Martin/dp/0134494164	Robert C. Martin (Uncle Bob)	IN_LIBRARY	2017-01-20 20:01:42.944	2017-01-20 20:01:42.944	6	144
204	Everybody Writes: Your Go-To Guide to Creating Ridiculously Good Content	https://www.amazon.com/Everybody-Writes-Go-Creating-Ridiculously/dp/1118905555/ref=sr_1_1?ie=UTF8&qid=1490888373&sr=8-1&keywords=everyone+writes	 Ann Handley 	IN_LIBRARY	2017-03-31 13:53:22.066	2017-03-31 13:53:22.066	7	135
214	Extreme Ownership: How U.S. Navy SEALs Lead and Win	https://www.kobo.com/ww/en/ebook/extreme-ownership	Jocko Willink	IN_LIBRARY	2017-06-19 13:12:20.938	2017-06-19 13:12:20.938	7	164
224	Lean From the Trenches	https://www.amazon.com/Lean-Trenches-Managing-Large-Scale-Projects/dp/1934356859/ref=mt_paperback?_encoding=UTF8&me=	Henrik Kniberg	IN_LIBRARY	2017-07-19 07:13:11.117	2017-07-19 07:13:11.117	7	22
234	UX Strategy How to Devise Innovative Digital Products that People Want	http://shop.oreilly.com/product/0636920032090.do	Jaime Levy	IN_LIBRARY	2017-11-17 09:54:24.435	2017-11-17 09:54:24.435	2	169
244	Mastering Ethereum: Building Smart Contracts and Dapps	https://www.amazon.com/Mastering-Ethereum-Building-Smart-Contracts/dp/1491971940/ref=sr_1_6?s=books&ie=UTF8&qid=1518111201&sr=1-6&keywords=ethereum&dpID=51eW3hlp3jL&preST=_SX218_BO1,204,203,200_QL40_&dpSrc=srch	Andreas M. Antonopoulos, Gavin Wood	REQUESTED	2018-02-08 17:36:51.039	2018-02-08 17:36:51.039	6	112
254	12 Rules for Life: An Antidote to Chaos	https://www.amazon.com/12-Rules-Life-Antidote-Chaos/dp/0345816021/	Jordan B. Peterson	IN_LIBRARY	2018-03-21 07:45:18.03	2018-03-21 07:45:18.03	7	188
264	Functional-Light JavaScript: Pragmatic, Balanced FP in JavaScript	https://www.amazon.com/Functional-Light-JavaScript-Pragmatic-Balanced-FP-ebook/dp/B0787DBFKH	Kyle Simpson	REQUESTED	2018-05-17 12:44:48.814	2018-05-17 12:44:48.814	6	188
154	Programming Phoenix (1.2)	https://www.amazon.com/Programming-Phoenix-Productive-Reliable-Fast-ebook/dp/B01FRIOYEC/ref=sr_1_2?ie=UTF8&qid=1466412551&sr=8-2&keywords=phoenix+book	Chris McCord, Bruce Tate, Jose Valim	IN_LIBRARY	2016-06-20 08:50:21.685	2018-08-01 12:16:02.198888	1	144
203	Purely Functional Data Structures	https://www.amazon.co.uk/dp/0521663504/?tag=devbookscom-21	Chris Okasaki	LOST	2017-03-09 23:04:17.525	2018-09-26 14:10:22.451216	6	144
70	Mastering Dojo: JavaScript and Ajax Tools for Great Web Experiences (Pragmatic Programmers)	\N	Riecke C., Gill R. , Russell A.	IN_LIBRARY	2014-08-30 10:27:12.575	2014-08-30 10:27:12.575	1	\N
80	The Design of Everyday Things	http://www.amazon.com/The-Design-Everyday-Things-Expanded/dp/0465050654/ref=dp_ob_title_bk	Donald A. Norman	IN_LIBRARY	2014-09-02 10:54:31.732	2014-09-02 10:54:31.732	2	54
89	Content Strategy for Mobile	http://www.amazon.com/Content-Strategy-Mobile-Karen-McGrane/dp/1937557081/ref=sr_1_1?ie=UTF8&qid=1417100156&sr=8-1&keywords=Content+Strategy+for+Mobile	Karen McGrane	IN_LIBRARY	2014-11-27 14:56:28.839	2014-11-27 14:56:28.839	2	112
97	Results Without Authority: Controlling a Project When the Team Doesn't Report to You	http://www.amazon.com/Results-Without-Authority-Controlling-Project/dp/0814417817/ref=sr_1_1?ie=UTF8&qid=1417169342&sr=8-1&keywords=Results+without+authority%2C	 Tom Kendrick 	LOST	2014-11-28 10:13:58.8	2014-11-28 10:13:58.8	7	31
106	The Design of Everyday Things	http://www.amazon.com/The-Design-Everyday-Things-Expanded/dp/0465050654/ref=pd_sim_sbs_14_1?ie=UTF8&refRID=031R94S8HP84P48GMBE5	Don Norman	IN_LIBRARY	2015-07-28 15:06:12.598	2015-07-28 15:06:12.598	2	109
116	Programming Elixir: Functional |> Concurrent |> Pragmatic |> Fun	http://www.amazon.com/Programming-Elixir-Functional-Concurrent-Pragmatic/dp/1937785580/	Dave Thomas	IN_LIBRARY	2015-09-25 09:56:35.462	2015-09-25 09:56:35.462	1	107
125	Why We Work	http://www.amazon.com/Why-We-Work-TED-Books/dp/1476784868	Barry Schwartz	LOST	2015-12-18 13:53:33.017	2015-12-18 13:53:33.017	7	109
135	Super-Modified: The Behance Book of Creative Work	http://www.amazon.com/Super-Modified-Behance-Book-Creative-Work/dp/3899555384/ref=sr_1_1?s=books&ie=UTF8&qid=1458124030&sr=1-1&keywords=Super-Modified	\N	IN_LIBRARY	2016-03-16 10:29:16.307	2016-03-16 10:29:16.307	2	54
145	You don`t know JS - UP & GOING	http://www.allegro.pl	KYLE SIMPSON	LOST	2016-05-10 10:11:53.241	2016-05-10 10:11:53.241	1	135
155	Effective DevOps	https://www.amazon.com/Effective-DevOps-Building-Collaboration-Affinity/dp/1491926309/ref=sr_1_1?s=books&ie=UTF8&qid=1466413621&sr=1-1&keywords=Effective+DevOps%3A+Building+a+Culture+of+Collaboration%2C+Affinity%2C+and+Tooling+a	Jennifer Davis	IN_LIBRARY	2016-06-20 09:07:43.417	2016-06-20 09:07:43.417	6	8
165	Play Bigger	https://www.amazon.com/Play-Bigger-Dreamers-Innovators-Dominate/dp/0062407619/ref=sr_1_1?ie=UTF8&qid=1466262614&sr=8-1&keywords=play+bigger	by Al Ramadan  (Author), Dave Peterson  (Author), Christopher Lochhead 	IN_LIBRARY	2016-06-26 21:43:42.665	2016-06-26 21:43:42.665	7	106
175	Herding Cats: A Primer for Programmers Who Lead Programmers	https://www.amazon.com/Herding-Cats-Primer-Programmers-Lead/dp/1590590171/ref=sr_1_1?ie=UTF8&qid=1471240412&sr=8-1&keywords=Herding+Cats	J. Hank Rainwater	LOST	2016-08-15 21:05:06.74	2016-08-15 21:05:06.74	7	112
185	The Zero Marginal Cost Society: The Internet of Things, the Collaborative Commons, and the Eclipse of Capitalism	https://www.amazon.com/Zero-Marginal-Cost-Society-Collaborative/dp/1137280115/ref=tmm_pap_swatch_0?_encoding=UTF8&qid=1480184963&sr=8-1	Jeremy Rifkin	IN_LIBRARY	2016-11-26 18:37:27.372	2016-11-26 18:37:27.372	7	29
195	Exponential Organizations	http://exponentialorgs.com/	Salim Ismail	IN_LIBRARY	2017-01-24 13:26:31.369	2017-01-24 13:26:31.369	7	164
205	Myślenie wizualne w biznesie	http://allegro.pl/myslenie-wizualne-w-biznesie-ty-tez-potrafisz-i6767653385.html?reco_id=43e97da1-1921-11e7-a210-6c3be5c00ee0&ars_rule_id=201	Karolina Jóźwik Szymon Zwoliński	IN_LIBRARY	2017-04-13 09:59:59.605	2017-04-13 09:59:59.605	7	164
215	Extreme Ownership: How U.S. Navy SEALs Lead and Win	https://www.amazon.com/Extreme-Ownership-U-S-Navy-SEALs/dp/1250067057/ref=tmm_hrd_swatch_0?_encoding=UTF8&qid=&sr=	Jocko Willink	LOST	2017-06-19 13:12:30.213	2017-06-19 13:12:30.213	7	164
225	Scrum and XP From The Trenches	https://www.amazon.com/Scrum-Trenches-2nd-Henrik-Kniberg/dp/1329224272/ref=sr_1_3?ie=UTF8&qid=1500448187&sr=8-3&keywords=kniberg	Henrik Kniberg	IN_LIBRARY	2017-07-19 07:13:47.813	2017-07-19 07:13:47.813	7	22
235	The Sales Enablement Playbook	https://www.amazon.com/Sales-Enablement-Playbook-Cory-Bray/dp/1546744762/	Cory Bray, Hilmon Sorey	IN_LIBRARY	2017-12-13 09:22:15.105	2017-12-13 09:22:15.105	7	55
255	Interactive Data Visualization for the Web, 2nd Edtion	http://alignedleft.com/work/d3-book-2e	Scott Murray	IN_LIBRARY	2018-03-21 07:52:37.486	2018-03-21 07:52:37.486	1	170
265	Refactoring: Improving the Design of Existing Code	https://www.amazon.com/Refactoring-Improving-Design-Existing-Code/dp/0201485672/ref=asap_bc?ie=UTF8	Martin Fowler, Kent Beck, John Brant, William Opdyke, Don Roberts	REQUESTED	2018-05-28 21:31:59.328	2018-05-28 21:31:59.328	6	112
266	Kill the Company: End the Status Quo, Start an Innovation Revolution	https://www.amazon.com/Kill-Company-Status-Innovation-Revolution/dp/1937134024/ref=sr_1_1?s=books&ie=UTF8&qid=1328286325&sr=1-1	Lisa Bodell	REQUESTED	2018-05-30 05:53:33.299	2018-06-11 13:19:23.773444	7	142
273	Thinking, Fast and Slow	https://www.amazon.com/Thinking-Fast-Slow-Daniel-Kahneman/dp/0374533555	Daniel Kahneman	REQUESTED	2018-05-31 20:58:26.01	2018-06-11 21:20:46.293483	2	205
275	Explain the Cloud Like I'm 10	https://www.amazon.com/Explain-Cloud-Like-Im-10/dp/0979707110/	Todd Hoff	REQUESTED	2018-06-14 11:12:39.113191	2018-06-14 11:12:39.113209	6	176
12	Remote	https://www.amazon.com/Remote-Office-Not-Required/dp/B00DJ5TS5Q/ref=sr_1_1?s=books&ie=UTF8&qid=1529336966&sr=1-1&keywords=remote	Fried J., Heinemeier Hansson D.	IN_LIBRARY	2014-08-30 10:27:12.447	2018-06-18 15:49:42.82704	7	\N
4	Programming in Objective-C	https://www.amazon.com/Programming-Objective-C-6th-Developers-Library/dp/0321967607/ref=sr_1_1?ie=UTF8&qid=1529337008&sr=8-1&keywords=Programming+in+Objective-C	Kochan S.G.	IN_LIBRARY	2014-08-30 10:27:12.426	2018-06-18 15:50:25.687154	3	\N
14	Manage Your Day-to-Day: Build Your Routine, Find Your Focus, and Sharpen Your Creative Mind	https://www.amazon.com/Manage-Your-Day-Day-Creative/dp/1477800670/ref=tmm_pap_swatch_0?_encoding=UTF8&qid=1529337075&sr=1-1	Glei J.K.	IN_LIBRARY	2014-08-30 10:27:12.451	2018-06-18 15:51:38.937551	7	\N
274	test	http://goole.com	test	DELETED	2018-06-14 11:08:39.408353	2018-06-22 14:53:08.549554	3	112
276	Functional Web Development with Elixir, OTP, and Phoenix: Rethink the Modern Web App	https://www.amazon.com/Functional-Web-Development-Elixir-Phoenix/dp/1680502433/ref=pd_sim_14_1?_encoding=UTF8&pd_rd_i=1680502433&pd_rd_r=NPVEZT53Z05RA2TF8C56&pd_rd_w=EvrIO&pd_rd_wg=k7r23&psc=1&refRID=NPVEZT53Z05RA2TF8C56	Lance Halvorsen	REQUESTED	2018-06-24 09:08:18.893648	2018-06-24 09:08:18.893694	1	112
277	Craft GraphQL APIs in Elixir with Absinthe: Flexible, Robust Services for Queries, Mutations, and Subscriptions	https://www.amazon.com/Craft-GraphQL-APIs-Elixir-Absinthe/dp/1680502557/ref=pd_sim_14_2?_encoding=UTF8&pd_rd_i=1680502557&pd_rd_r=NPVEZT53Z05RA2TF8C56&pd_rd_w=EvrIO&pd_rd_wg=k7r23&psc=1&refRID=NPVEZT53Z05RA2TF8C56	Bruce Williams,  Ben Wilson	REQUESTED	2018-06-24 09:09:02.524424	2018-07-19 07:47:04.133731	1	112
278	Księga Adsów 2.0	https://socialtigers.pl/ebook	Franciszek Georgiew	DELETED	2018-06-26 12:13:40.877358	2018-06-29 06:48:03.980816	7	217
279	Mastering PostgreSQL in Application Development	https://www.amazon.com/Mastering-PostgreSQL-Application-Development-Fontaine/dp/024494525X/ref=sr_1_1?ie=UTF8&qid=1531992097&sr=8-1&keywords=Mastering+PostgreSQL+in+Application+Development	Dimitri Fontaine	REQUESTED	2018-07-19 09:22:41.926741	2018-07-19 09:22:41.926757	4	112
280	Mastering PostgreSQL 10: Expert techniques on PostgreSQL 10 development and administration	https://www.amazon.com/Mastering-PostgreSQL-techniques-development-administration/dp/1788472292/ref=pd_bxgy_14_img_2?_encoding=UTF8&pd_rd_i=1788472292&pd_rd_r=68bd15cc-8b35-11e8-88c9-b521805f7331&pd_rd_w=Ok15N&pd_rd_wg=XAYuj&pf_rd_i=desktop-dp-sims&pf_rd_m=ATVPDKIKX0DER&pf_rd_p=1475879231140687736&pf_rd_r=9Z980T4VGKXZ6X4RJ7Z0&pf_rd_s=desktop-dp-sims&pf_rd_t=40701&psc=1&refRID=9Z980T4VGKXZ6X4RJ7Z0	Hans-Jurgen Schonig	REQUESTED	2018-07-19 09:25:01.10653	2018-07-19 09:25:01.106549	4	112
260	Solving Product Design Exercises: Questions & Answers	https://www.amazon.com/Solving-Product-Design-Exercises-Questions/dp/1977000428/ref=pd_sim_14_13?_encoding=UTF8&pd_rd_i=1977000428&pd_rd_r=Y6Z4VYZMRTG3429BZZYE&pd_rd_w=sf3QZ&pd_rd_wg=tufMW&psc=1&refRID=Y6Z4VYZMRTG3429BZZYE	Artiom Dashinsky	IN_LIBRARY	2018-04-17 13:30:20.078	2018-07-24 09:30:42.129732	2	206
245	Decoded: The Science Behind Why We Buy 	https://www.amazon.com/Decoded-Science-Behind-Why-Buy/dp/1118345606/ref=sr_1_1?s=books&ie=UTF8&qid=1474124535&sr=1-1&keywords=decoded%20phil%20barden&lipi=urn%3Ali%3Apage%3Ad_flagship3_pulse_read%3BwUNtzrsjSxu7OMwptWq3%2BQ%3D%3D	Phil Barden	IN_LIBRARY	2018-02-26 15:47:26.535	2018-07-24 09:33:17.647872	7	67
247	Designing for Scalability with Erlang/OTP: Implement Robust, Fault-Tolerant Systems 	https://www.amazon.com/Designing-Scalability-Erlang-OTP-Fault-Tolerant/dp/1449320732/ref=sr_1_1?ie=UTF8&qid=1519890073&sr=8-1&keywords=erlang+otp&dpID=51Jfu8fVJ0L&preST=_SX218_BO1,204,203,200_QL40_&dpSrc=srch	Francesco Cesarini,‎ Steve Vinoski	IN_LIBRARY	2018-03-01 07:42:28.403	2018-07-24 09:34:21.337405	6	112
249	Antifragile, Antykruchość. O rzeczach, którym służą wstrząsy.	https://czytam.pl/k,ks_299755,Antykruchosc-Taleb-Nassim-Nicholas-google.html?gclid=EAIaIQobChMI3deVueDK2QIVGWUZCh2Vzg-mEAQYASABEgLyOfD_BwE	Nassim Taleb	IN_LIBRARY	2018-03-01 08:59:47.848	2018-07-24 09:34:44.514713	7	142
239	Fluent Python	http://shop.oreilly.com/product/0636920032519.do	Luciano Ramalho	IN_LIBRARY	2018-01-08 12:08:23.761	2018-08-01 12:02:13.95046	6	176
261	Creative Confidence: Unleashing the Creative Potential Within Us All	https://www.amazon.com/Creative-Confidence-Unleashing-Potential-Within/dp/038534936X/ref=pd_sim_14_18?_encoding=UTF8&pd_rd_i=038534936X&pd_rd_r=Y6Z4VYZMRTG3429BZZYE&pd_rd_w=sf3QZ&pd_rd_wg=tufMW&psc=1&refRID=Y6Z4VYZMRTG3429BZZYE	Tom Kelley	IN_LIBRARY	2018-04-17 13:32:00.462	2018-08-01 12:02:25.594249	7	206
281	Nonviolent Communication: A Language of Life, 3rd Edition: Life-Changing Tools for Healthy Relationships 	https://www.amazon.de/Nonviolent-Communication-Language-Life-Changing-Relationships/dp/189200528X	Marshall B. Rosenberg	IN_LIBRARY	2018-08-01 12:05:05.411797	2018-08-01 12:05:05.411816	7	112
282	Nonviolent Communication: A Language of Life, 3rd Edition: Life-Changing Tools for Healthy Relationships	https://www.amazon.de/Nonviolent-Communication-Language-Life-Changing-Relationships/dp/189200528X	Marshall B. Rosenberg	IN_LIBRARY	2018-08-01 12:05:51.950147	2018-08-01 12:05:51.950169	7	112
283	Programming Phoenix (1.2)	https://www.amazon.com/Programming-Phoenix-Productive-Reliable-Fast-ebook/dp/B01FRIOYEC/ref=sr_1_2?ie=UTF8&qid=1466412551&sr=8-2&keywords=phoenix+book	Chris McCord	IN_LIBRARY	2018-08-01 12:15:45.565211	2018-08-01 12:16:09.369598	1	112
284	How the Internet Happened: From Netscape to the iPhone	https://www.amazon.com/How-Internet-Happened-Netscape-iPhone/dp/1631493078/ref=mt_hardcover	Brian McCullough	REQUESTED	2018-08-13 07:03:20.538563	2018-08-13 07:03:20.538585	7	162
231	Programming Phoenix 1.4: Productive |> Reliable |> Fast	https://www.amazon.com/Programming-Phoenix-1-3-Productive-Reliable/dp/1680502263/ref=sr_1_1?ie=UTF8&qid=1509977964&sr=8-1&keywords=Programming+Phoenix+1.3	Chris McCord,‎ Bruce Tate,‎ Jose Valim	REQUESTED	2017-11-06 14:20:11.16	2018-08-28 11:35:03.231457	1	112
285	Code: The Hidden Language of Computer Hardware and Software	https://www.amazon.com/Code-Language-Computer-Hardware-Software/dp/0735611319/ref=pd_rhf_dp_s_cp_0_3?_encoding=UTF8&pd_rd_i=0735611319&pd_rd_r=DR4Q3TY04SW6CGH2Q0CZ&pd_rd_w=i8bEw&pd_rd_wg=sD0kq&psc=1&refRID=DR4Q3TY04SW6CGH2Q0CZ	Charles Petzold	REQUESTED	2018-09-05 19:52:37.107405	2018-09-05 19:52:37.107438	6	188
286	Mastering Vim Quickly: From WTF to OMG in no time	https://www.amazon.com/Mastering-Vim-Quickly-WTF-time/dp/1983325740/ref=sr_1_cc_1?s=aps&ie=UTF8&qid=1536312992&sr=1-1-catcorr&keywords=mastering+vim	Jovica Ilic	REQUESTED	2018-09-07 09:39:36.653262	2018-09-07 09:39:36.653293	5	99
288	Lean Inception: How to Align People and Build the Right Product	https://www.amazon.com/Lean-Inception-Align-People-Product-ebook/dp/B079CMQQB5/ref=as_li_ss_tl?s=books&ie=UTF8&qid=1518618546&sr=1-1&keywords=lean+inception&linkCode=sl1&tag=caroliorg-20&linkId=b2fcb792f5eca1512500b689da18477b	 Paulo Caroli 	REQUESTED	2018-09-25 09:13:15.726488	2018-09-25 09:13:15.726532	2	206
289	Radical Candor	https://www.empik.com/radical-candor-kim-scott,p1174778278,ksiazka-p	Kim Scott	IN_LIBRARY	2018-10-02 08:38:37.101552	2018-10-02 08:38:37.101586	7	227
287	Structure and Interpretation of Computer Programs	https://www.amazon.com/Structure-Interpretation-Computer-Programs-Engineering/dp/0262510871	Harold Abelson	ORDERED	2018-09-17 10:14:00.370321	2018-12-07 18:45:32	6	188
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schema_migrations (version, inserted_at) FROM stdin;
20171007204324	2018-06-11 12:35:17.804595
20171022133327	2018-06-11 12:35:17.840755
20171022235756	2018-06-11 12:35:17.86731
20171029142903	2018-06-11 12:35:17.899904
20171104181512	2018-06-11 12:35:17.921687
20171113123403	2018-06-11 12:35:17.956032
20171129181403	2018-06-11 12:35:17.986228
20171201185409	2018-06-11 12:35:18.021313
20171201212430	2018-06-11 12:35:18.041555
20171226110736	2018-06-11 12:35:18.090201
20171230083311	2018-06-11 12:35:18.131472
20180331141710	2018-06-11 12:35:18.153006
20180516213301	2018-06-11 12:35:18.183948
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, email, inserted_at, updated_at, is_admin, avatar_url) FROM stdin;
44	Corinne Aceuedo	user-25@gmail.com	2014-09-02 14:06:43.235	2014-09-02 14:06:43.235	t	http://avatar.baccano.io/6
54	Delphia Bainter	user-26@gmail.com	2014-09-01 08:58:32.359	2014-09-01 08:58:32.359	f	http://avatar.baccano.io/7
84	Karleen Tsui	user-27@gmail.com	2017-10-04 11:48:50.576	2017-10-04 11:48:50.576	f	http://avatar.baccano.io/8
192	Fredrick Bainter	user-28@gmail.com	2018-02-19 11:46:46.34	2018-06-11 12:52:39.991908	f	http://avatar.baccano.io/9
102	Kimiko Vanhoose	user-31@gmail.com	2016-02-02 11:53:16.044	2018-08-24 12:23:40.45578	f	http://avatar.baccano.io/10
5	Wen Ritzman	user-3@gmail.com	2014-09-01 08:05:03.13	2014-09-01 08:05:03.13	f	http://avatar.baccano.io/23
6	Yan Flannigan	user-4@gmail.com	2016-04-20 11:59:04.893	2016-04-20 11:59:04.893	f	http://avatar.baccano.io/24
8	Helena Gibbs	user-5@gmail.com	2014-09-01 08:08:19.934	2014-09-01 08:08:19.934	f	http://avatar.baccano.io/25
18	Katherin Lafortune	user-6@gmail.com	2015-09-24 12:05:24.817	2015-09-24 12:05:24.817	f	http://avatar.baccano.io/26
19	Cinda Tallmadge	user-7@gmail.com	2017-04-10 08:57:05.266	2017-04-10 08:57:05.266	f	http://avatar.baccano.io/27
20	Vanna Rolon	user-8@gmail.com	2014-09-01 08:10:38.307	2014-09-01 08:10:38.307	f	http://avatar.baccano.io/28
22	Catherin Bramlett	user-9@gmail.com	2015-11-30 09:45:03.368	2015-11-30 09:45:03.368	f	http://avatar.baccano.io/29
23	Jonah Rehberg	user-10@gmail.com	2016-05-04 11:09:36.211	2016-05-04 11:09:36.211	f	http://avatar.baccano.io/30
24	Branda Seifried	user-11@gmail.com	2016-12-28 13:39:45.278	2016-12-28 13:39:45.278	f	http://avatar.baccano.io/31
25	Emmanuel Grabert	user-12@gmail.com	2016-04-20 09:20:43.428	2016-04-20 09:20:43.428	f	http://avatar.baccano.io/32
27	Jarod Guinyard	user-13@gmail.com	2017-02-20 09:31:54.707	2017-02-20 09:31:54.707	f	http://avatar.baccano.io/33
29	Katherina Boze	user-14@gmail.com	2016-03-23 10:56:03.039	2016-03-23 10:56:03.039	f	http://avatar.baccano.io/34
31	Celestina Tsang	user-15@gmail.com	2014-08-28 11:51:16.083	2014-08-28 11:51:16.083	f	http://avatar.baccano.io/35
34	Porsche Holland	user-16@gmail.com	2017-05-08 09:33:14.927	2017-05-08 09:33:14.927	f	http://avatar.baccano.io/36
35	Cruz Crumley	user-17@gmail.com	2017-09-04 09:42:15.115	2017-09-04 09:42:15.115	f	http://avatar.baccano.io/37
38	Melva Fannin	user-18@gmail.com	2014-09-01 09:03:41.606	2014-09-01 09:03:41.606	f	http://avatar.baccano.io/38
92	Edris Berber	user-29@gmail.com	2017-02-01 10:20:42.065	2018-06-18 09:41:06.130361	f	http://avatar.baccano.io/39
42	Derrick Flannigan	user-19@gmail.com	2014-09-01 08:20:44.413	2014-09-01 08:20:44.413	f	http://avatar.baccano.io/40
163	Rosamond Flack	user-30@gmail.com	2017-08-30 09:25:07.205	2018-06-18 15:22:40.955412	f	http://avatar.baccano.io/41
145	Alysa Kunst	user-42@gmail.com	2017-02-22 14:07:41.819	2017-02-22 14:07:41.819	f	http://avatar.baccano.io/42
165	Carlo Gaulke	user-43@gmail.com	2015-06-10 09:12:10.883	2015-06-10 09:12:10.883	f	http://avatar.baccano.io/43
72	Shemika Esper	user-20@gmail.com	2015-03-02 10:49:47.236	2015-03-02 10:49:47.236	f	http://avatar.baccano.io/1
162	Rosalind States	user-21@gmail.com	2015-09-24 12:05:27.086	2015-09-24 12:05:27.086	f	http://avatar.baccano.io/2
93	Tamisha Cargo	user-22@gmail.com	2015-06-10 10:59:54.575	2015-06-10 10:59:54.575	f	http://avatar.baccano.io/3
142	Karyn Titcomb	user-32@gmail.com	2017-09-05 07:19:57.169	2018-10-08 07:13:29.24867	f	http://avatar.baccano.io/11
94	Ivette Sienkiewicz	user-33@gmail.com	2016-08-01 10:08:22.818	2016-08-01 10:08:22.818	f	http://avatar.baccano.io/12
144	Tempie Shockey	user-34@gmail.com	2015-06-10 09:39:31.537	2015-06-10 09:39:31.537	f	http://avatar.baccano.io/13
154	Bianca Bushnell	user-35@gmail.com	2015-06-10 09:12:20.431	2015-06-10 09:12:20.431	f	http://avatar.baccano.io/14
164	Kecia Woodside	user-36@gmail.com	2017-01-02 10:08:30.869	2017-01-02 10:08:30.869	t	http://avatar.baccano.io/15
55	Tommye Leverett	user-37@gmail.com	2017-02-06 10:31:49.639	2017-02-06 10:31:49.639	f	http://avatar.baccano.io/16
65	Debroah Vess	user-38@gmail.com	2014-10-02 12:15:28.32	2014-10-02 12:15:28.32	f	http://avatar.baccano.io/17
85	Kimbery Gravitt	user-39@gmail.com	2017-05-15 10:48:53.232	2017-05-15 10:48:53.232	f	http://avatar.baccano.io/18
115	Wilda Carrico	user-40@gmail.com	2017-07-31 14:24:42.437	2017-07-31 14:24:42.437	f	http://avatar.baccano.io/19
135	Alan Kohut	user-41@gmail.com	2016-02-22 10:43:07.474	2016-02-22 10:43:07.474	t	http://avatar.baccano.io/20
123	Melony Aceuedo	user-23@gmail.com	2016-08-02 06:57:05.689	2016-08-02 06:57:05.689	f	http://avatar.baccano.io/4
143	Cheree Lavallie	user-24@gmail.com	2017-05-04 10:11:49.961	2017-05-04 10:11:49.961	f	http://avatar.baccano.io/5
66	Fernanda Hummer	user-44@gmail.com	2017-10-02 09:28:59.674	2017-10-02 09:28:59.674	f	http://avatar.baccano.io/21
3	Joy Marko	user-2@gmail.com	2017-10-03 12:00:15.615	2017-10-03 12:00:15.615	f	http://avatar.baccano.io/22
149	Jessi Belton	user-80@gmail.com	2016-02-29 10:40:13.137	2018-06-13 13:24:00.35243	f	http://avatar.baccano.io/58
169	Milo Cranford	user-81@gmail.com	2017-11-02 10:00:48.486	2018-06-18 08:53:25.559709	f	http://avatar.baccano.io/59
190	Lesli Honda	user-82@gmail.com	2018-02-06 10:25:33.473	2018-06-22 08:55:37.215852	f	http://avatar.baccano.io/60
180	Idalia Towell	user-83@gmail.com	2018-01-08 11:18:20.129	2018-07-29 15:57:00.256021	f	http://avatar.baccano.io/61
119	Emerald Lapp	user-84@gmail.com	2017-06-20 07:02:49.733	2018-10-04 15:06:20.510632	f	http://avatar.baccano.io/62
159	Wanetta Tsui	user-85@gmail.com	2015-06-10 09:20:21.937	2018-10-04 15:01:41.550705	f	http://avatar.baccano.io/63
81	Terina Otts	user-86@gmail.com	2014-09-02 10:49:48.24	2014-09-02 10:49:48.24	f	http://avatar.baccano.io/64
101	Domenic Manrique	user-87@gmail.com	2014-09-01 09:12:05.551	2014-09-01 09:12:05.551	f	http://avatar.baccano.io/65
106	Josefina Schreiber	user-45@gmail.com	2015-06-10 09:12:23.143	2015-06-10 09:12:23.143	f	http://avatar.baccano.io/66
116	Bell Chasteen	user-46@gmail.com	2017-06-29 06:28:35.632	2017-06-29 06:28:35.632	f	http://avatar.baccano.io/67
126	Chery Fraga	user-47@gmail.com	2017-06-19 09:32:17.822	2017-06-19 09:32:17.822	f	http://avatar.baccano.io/68
204	Dyan Crenshaw	user-51@gmail.com	2018-04-04 09:03:36.997	2018-10-23 11:47:27.16262	f	http://avatar.baccano.io/69
195	Shiloh Motz	user-52@gmail.com	2018-02-28 13:52:41.279	2018-09-26 13:18:38.643744	f	http://avatar.baccano.io/70
176	Kristin Strachan	user-53@gmail.com	2018-01-03 09:23:16.374	2018-01-03 09:23:16.374	f	http://avatar.baccano.io/71
128	Iraida Almonte	user-60@gmail.com	2015-06-16 08:16:40.214	2015-06-16 08:16:40.214	f	http://avatar.baccano.io/76
148	Kecia Harries	user-61@gmail.com	2017-01-02 12:05:03.755	2017-01-02 12:05:03.755	f	http://avatar.baccano.io/77
168	Andreas Tye	user-62@gmail.com	2017-11-02 09:09:57.157	2017-11-02 09:09:57.157	t	http://avatar.baccano.io/78
188	Virgie Boser	user-63@gmail.com	2018-02-01 11:31:36.336	2018-02-01 11:31:36.336	f	http://avatar.baccano.io/79
157	Hue Rothrock	user-64@gmail.com	2016-04-04 09:36:57.868	2018-06-11 12:51:14.798221	f	http://avatar.baccano.io/80
147	Corie Mutter	user-65@gmail.com	2016-08-08 11:37:07.162	2018-09-12 06:33:19.178411	t	http://avatar.baccano.io/81
166	Pattie Osbourne	user-66@gmail.com	2017-10-24 09:15:29.519	2018-08-07 12:10:17.49367	t	http://avatar.baccano.io/82
170	Tayna Fannin	user-78@gmail.com	2017-11-06 13:56:30.933	2017-11-06 13:56:30.933	f	http://avatar.baccano.io/83
136	Corinna Manrique	user-48@gmail.com	2017-09-01 07:24:08.48	2017-09-01 07:24:08.48	f	http://avatar.baccano.io/84
205	Rickie Mazzotta	user-49@gmail.com	2018-04-06 08:40:01.801	2018-06-11 12:57:35.022439	f	http://avatar.baccano.io/85
185	Delphia Hunger	user-50@gmail.com	2018-01-31 10:20:58.682	2018-11-07 09:45:59.148926	f	http://avatar.baccano.io/86
57	Manual Mudd	user-56@gmail.com	2015-10-19 08:54:12.046	2015-10-19 08:54:12.046	f	http://avatar.baccano.io/44
107	Foster Giddens	user-57@gmail.com	2014-09-11 08:31:51.429	2014-09-11 08:31:51.429	f	http://avatar.baccano.io/45
67	Iesha Konrad Vibbert Aceuedo	user-67@gmail.com	2016-11-09 10:51:36.145	2018-10-10 11:18:16.724885	f	http://avatar.baccano.io/46
208	Particia Guinyard	user-68@gmail.com	2018-04-18 14:58:53.05	2018-04-18 14:58:53.05	f	http://avatar.baccano.io/47
218	Reynaldo Music	user-69@gmail.com	2018-06-06 09:14:05.337	2018-06-06 09:14:05.337	f	http://avatar.baccano.io/48
99	Dayna Macky	user-70@gmail.com	2017-02-01 12:56:53.83	2017-02-01 12:56:53.83	f	http://avatar.baccano.io/49
109	Jessi Pillai	user-71@gmail.com	2014-09-01 07:52:55.222	2014-09-01 07:52:55.222	t	http://avatar.baccano.io/50
209	Letisha Decaro	user-72@gmail.com	2018-04-23 11:28:25.076	2018-04-23 11:28:25.076	f	http://avatar.baccano.io/51
80	Tressa Harries	user-73@gmail.com	2017-09-01 11:44:05.478	2017-09-01 11:44:05.478	f	http://avatar.baccano.io/52
90	Reynaldo Guynn	user-74@gmail.com	2016-05-16 09:12:41.989	2016-05-16 09:12:41.989	f	http://avatar.baccano.io/53
110	Myrta Meacham	user-75@gmail.com	2014-10-02 13:31:07.705	2014-10-02 13:31:07.705	f	http://avatar.baccano.io/54
140	Kizzy Sieck	user-76@gmail.com	2016-04-21 13:18:36.8	2016-04-21 13:18:36.8	f	http://avatar.baccano.io/55
186	Amberly Fraga	user-54@gmail.com	2018-02-01 08:41:25.344	2018-02-01 08:41:25.344	f	http://avatar.baccano.io/72
206	Tajuana Mclamb	user-55@gmail.com	2018-04-09 12:30:06.922	2018-04-09 12:30:06.922	f	http://avatar.baccano.io/73
58	Tayna Kunst	user-58@gmail.com	2017-04-03 10:59:17.195	2017-04-03 10:59:17.195	f	http://avatar.baccano.io/74
160	Leeanna Russom	user-77@gmail.com	2014-09-01 08:06:06.059	2014-09-01 08:06:06.059	f	http://avatar.baccano.io/56
61	Adah Leverett	user-79@gmail.com	2017-04-10 07:24:09.911	2017-04-10 07:24:09.911	f	http://avatar.baccano.io/57
118	Loan Feucht	user-59@gmail.com	2017-09-25 08:40:12.732	2017-09-25 08:40:12.732	f	http://avatar.baccano.io/75
201	Iraida Lines	user-92@gmail.com	2018-03-21 08:07:52.204	2018-03-21 08:07:52.204	f	http://avatar.baccano.io/93
196	Melonie Redden	user-93@gmail.com	2018-03-01 07:56:54.02	2018-06-11 12:42:43.566832	t	http://avatar.baccano.io/94
124	Amberly Shriner	user-94@gmail.com	2017-02-02 10:39:12.355	2018-06-11 12:57:16.000847	f	http://avatar.baccano.io/95
96	Louis Ingham	user-95@gmail.com	2017-01-10 10:06:40.793	2018-06-12 13:07:20.813322	f	http://avatar.baccano.io/96
224	Lawanda Tallmadge	user-96@gmail.com	2018-08-01 11:44:00.637208	2018-08-21 12:28:58.862033	f	http://avatar.baccano.io/97
181	Sharlene Thelen	user-97@gmail.com	2018-01-15 09:04:30.564	2018-08-22 08:13:34.167074	f	http://avatar.baccano.io/98
223	Sherrill Mcclard	user-98@gmail.com	2018-07-03 10:47:34.025143	2018-07-03 10:47:34.025157	f	http://avatar.baccano.io/99
182	Vinnie Chaudhry	user-99@gmail.com	2018-01-17 14:42:10.979	2018-07-17 09:28:05.807106	t	http://avatar.baccano.io/100
227	Helga Gatto	user-100@gmail.com	2018-08-28 11:29:03.161627	2018-09-14 13:26:39.687788	t	http://avatar.baccano.io/101
131	Shira Alex	user-101@gmail.com	2017-04-03 08:54:03.307	2018-07-25 10:47:26.374801	f	http://avatar.baccano.io/102
225	Cornelius Steidl	user-102@gmail.com	2018-08-07 14:15:37.866047	2018-08-07 14:15:37.86606	f	http://avatar.baccano.io/103
12	Elvina Hohman	user-103@gmail.com	2017-04-10 11:33:59.962	2018-10-22 10:24:57.682168	f	http://avatar.baccano.io/104
217	Wen Tsui	user-104@gmail.com	2018-05-30 08:57:47.659	2018-09-17 09:15:52.650781	f	http://avatar.baccano.io/105
226	Omar Fox	user-105@gmail.com	2018-08-07 16:01:23.173311	2018-08-27 15:46:59.088928	f	http://avatar.baccano.io/106
229	Concetta Radosevich	user-106@gmail.com	2018-09-18 07:54:09.297695	2018-09-18 07:54:09.297714	f	http://avatar.baccano.io/107
230	Merle Bremer	user-107@gmail.com	2018-10-10 11:42:08.350374	2018-10-10 11:42:08.35039	f	http://avatar.baccano.io/108
33	Jerrold Smead	user-108@gmail.com	2016-10-24 08:49:02.378	2018-10-11 10:13:13.226985	f	http://avatar.baccano.io/109
112	Molly Urena	user-109@gmail.com	2016-07-30 11:38:41.419	2018-06-11 12:57:53.242341	t	http://avatar.baccano.io/110
32	Ethyl Kunst	user-110@gmail.com	2014-10-27 09:28:38.096	2018-12-03 16:40:49	f	http://avatar.baccano.io/87
2	Patience Gabel	user-1@gmail.com	2014-09-01 08:14:11.668	2014-09-01 08:14:11.668	f	http://avatar.baccano.io/88
111	Rosella Southward	user-88@gmail.com	2017-07-03 07:27:23.223	2017-07-03 07:27:23.223	f	http://avatar.baccano.io/89
121	Sharlene Webber	user-89@gmail.com	2014-09-22 08:02:15.41	2014-09-22 08:02:15.41	f	http://avatar.baccano.io/90
141	Sharilyn Waldron	user-90@gmail.com	2017-04-20 09:58:00.757	2017-04-20 09:58:00.757	f	http://avatar.baccano.io/91
161	Calvin Ritzman	user-91@gmail.com	2014-09-03 08:17:21.474	2014-09-03 08:17:21.474	f	http://avatar.baccano.io/92
\.


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_id_seq', 8, true);


--
-- Name: product_ratings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_ratings_id_seq', 74, true);


--
-- Name: product_uses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_uses_id_seq', 185, true);


--
-- Name: product_votes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_votes_id_seq', 560, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_id_seq', 289, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 233, true);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: product_ratings product_ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_ratings
    ADD CONSTRAINT product_ratings_pkey PRIMARY KEY (id);


--
-- Name: product_uses product_uses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_uses
    ADD CONSTRAINT product_uses_pkey PRIMARY KEY (id);


--
-- Name: product_votes product_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_votes
    ADD CONSTRAINT product_votes_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: categories_name_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX categories_name_index ON public.categories USING btree (name);


--
-- Name: product_ratings_product_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX product_ratings_product_id_index ON public.product_ratings USING btree (product_id);


--
-- Name: product_ratings_product_id_user_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX product_ratings_product_id_user_id_index ON public.product_ratings USING btree (product_id, user_id);


--
-- Name: product_uses_product_id_ended_at_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX product_uses_product_id_ended_at_index ON public.product_uses USING btree (product_id, ended_at) WHERE (ended_at IS NOT NULL);


--
-- Name: product_uses_product_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX product_uses_product_id_index ON public.product_uses USING btree (product_id) WHERE (ended_at IS NULL);


--
-- Name: product_votes_product_id_user_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX product_votes_product_id_user_id_index ON public.product_votes USING btree (product_id, user_id);


--
-- Name: products_inserted_at_DESC_NULLS_LAST_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "products_inserted_at_DESC_NULLS_LAST_index" ON public.products USING btree (inserted_at DESC NULLS LAST);


--
-- Name: products_status_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX products_status_index ON public.products USING btree (status);


--
-- Name: users_email_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_email_index ON public.users USING btree (email);


--
-- Name: categories nofity_about_category_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER nofity_about_category_update AFTER INSERT OR DELETE OR UPDATE ON public.categories FOR EACH ROW EXECUTE PROCEDURE public.notify_about_update('category_updated', 'id');


--
-- Name: products nofity_about_product_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER nofity_about_product_update AFTER INSERT OR DELETE OR UPDATE ON public.products FOR EACH ROW EXECUTE PROCEDURE public.notify_about_update('product_updated', 'id');


--
-- Name: product_ratings nofity_about_product_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER nofity_about_product_update AFTER INSERT OR DELETE OR UPDATE ON public.product_ratings FOR EACH ROW EXECUTE PROCEDURE public.notify_about_update('product_updated', 'product_id');


--
-- Name: product_uses nofity_about_product_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER nofity_about_product_update AFTER INSERT OR DELETE OR UPDATE ON public.product_uses FOR EACH ROW EXECUTE PROCEDURE public.notify_about_update('product_updated', 'product_id');


--
-- Name: product_votes nofity_about_product_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER nofity_about_product_update AFTER INSERT OR DELETE OR UPDATE ON public.product_votes FOR EACH ROW EXECUTE PROCEDURE public.notify_about_update('product_updated', 'product_id');


--
-- Name: product_ratings product_ratings_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_ratings
    ADD CONSTRAINT product_ratings_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: product_ratings product_ratings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_ratings
    ADD CONSTRAINT product_ratings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: product_uses product_uses_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_uses
    ADD CONSTRAINT product_uses_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: product_uses product_uses_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_uses
    ADD CONSTRAINT product_uses_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: product_votes product_votes_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_votes
    ADD CONSTRAINT product_votes_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: product_votes product_votes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_votes
    ADD CONSTRAINT product_votes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: products products_requested_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_requested_by_user_id_fkey FOREIGN KEY (requested_by_user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

