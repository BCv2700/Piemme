--
-- PostgreSQL database dump
--

\restrict 5cVkgOxRjtecxkpA9i8SmGtJyhD8LEYVeCTwKnZuTDXpJ8sZfORz40mJ0VhuPxw

-- Dumped from database version 18.4 (Debian 18.4-1.pgdg13+1)
-- Dumped by pg_dump version 18.4 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: article_composants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.article_composants (
    id integer NOT NULL,
    article_id integer NOT NULL,
    description character varying(150) NOT NULL,
    prix numeric(10,2) DEFAULT 0 NOT NULL
);


ALTER TABLE public.article_composants OWNER TO postgres;

--
-- Name: article_composants_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.article_composants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.article_composants_id_seq OWNER TO postgres;

--
-- Name: article_composants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.article_composants_id_seq OWNED BY public.article_composants.id;


--
-- Name: articles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.articles (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    categorie character varying(50),
    type_article character varying(50),
    tva numeric(5,2) DEFAULT 21 NOT NULL,
    prix_achat numeric(10,2) DEFAULT 0,
    prix_vente numeric(10,2) DEFAULT 0 NOT NULL,
    prix_vente_away numeric(10,2),
    stock integer DEFAULT 0,
    stock_min integer DEFAULT 0,
    stock_max integer DEFAULT 0,
    ean character varying(20),
    fournisseur character varying(100),
    localisation character varying(100),
    actif boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    tva_away numeric(5,2),
    code_vente integer,
    stock_a_suivre boolean DEFAULT false,
    est_boisson boolean DEFAULT false,
    type character varying(20) DEFAULT 'vente'::character varying NOT NULL,
    imprimer_cuisine boolean DEFAULT false,
    ordre integer
);


ALTER TABLE public.articles OWNER TO postgres;

--
-- Name: articles_achat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.articles_achat (
    id integer NOT NULL,
    nom character varying(150) NOT NULL,
    qte integer DEFAULT 0,
    prix_achat numeric(10,2),
    magasin character varying(100),
    a_commander boolean DEFAULT false,
    date_derniere_commande date
);


ALTER TABLE public.articles_achat OWNER TO postgres;

--
-- Name: articles_achat_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.articles_achat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.articles_achat_id_seq OWNER TO postgres;

--
-- Name: articles_achat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.articles_achat_id_seq OWNED BY public.articles_achat.id;


--
-- Name: articles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.articles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.articles_id_seq OWNER TO postgres;

--
-- Name: articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.articles_id_seq OWNED BY public.articles.id;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clients (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    telephone_mobile character varying(30),
    email character varying(100),
    adresse character varying(150),
    cp character varying(10),
    localite character varying(100),
    date_anniversaire date,
    derniere_visite date,
    a_recontacter boolean DEFAULT false,
    remarques text,
    actif boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    telephone_fixe character varying(30)
);


ALTER TABLE public.clients OWNER TO postgres;

--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clients_id_seq OWNER TO postgres;

--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- Name: commandes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.commandes (
    id integer NOT NULL,
    table_id integer NOT NULL,
    article_id integer NOT NULL,
    quantite numeric(10,2) DEFAULT 1 NOT NULL,
    prix_unitaire numeric(10,2) NOT NULL,
    tva numeric(5,2) NOT NULL,
    serveur character varying(50),
    imprime boolean DEFAULT false NOT NULL,
    emporte boolean DEFAULT false NOT NULL,
    date_commande timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.commandes OWNER TO postgres;

--
-- Name: commandes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.commandes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.commandes_id_seq OWNER TO postgres;

--
-- Name: commandes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.commandes_id_seq OWNED BY public.commandes.id;


--
-- Name: encaissement_lignes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.encaissement_lignes (
    id integer NOT NULL,
    encaissement_id integer NOT NULL,
    article_id integer,
    article_nom character varying(100) NOT NULL,
    quantite numeric(10,2) DEFAULT 1 NOT NULL,
    prix_vente numeric(10,2) NOT NULL,
    tva numeric(5,2) NOT NULL,
    vente_analysee boolean DEFAULT false
);


ALTER TABLE public.encaissement_lignes OWNER TO postgres;

--
-- Name: encaissement_lignes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.encaissement_lignes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.encaissement_lignes_id_seq OWNER TO postgres;

--
-- Name: encaissement_lignes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.encaissement_lignes_id_seq OWNED BY public.encaissement_lignes.id;


--
-- Name: encaissements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.encaissements (
    id integer NOT NULL,
    table_nom character varying(10),
    client_id integer,
    montant_carte numeric(10,2) DEFAULT 0,
    montant_cash numeric(10,2) DEFAULT 0,
    montant_total numeric(10,2) DEFAULT 0 NOT NULL,
    nb_personnes integer DEFAULT 1,
    emporte boolean DEFAULT false NOT NULL,
    depenses boolean DEFAULT false NOT NULL,
    serveur character varying(50),
    date_encaissement timestamp without time zone DEFAULT now() NOT NULL,
    remarque text,
    cash_analyse numeric(10,2) DEFAULT 0,
    nom_reservation_archive character varying(100)
);


ALTER TABLE public.encaissements OWNER TO postgres;

--
-- Name: encaissements_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.encaissements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.encaissements_id_seq OWNER TO postgres;

--
-- Name: encaissements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.encaissements_id_seq OWNED BY public.encaissements.id;


--
-- Name: recap_mensuel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recap_mensuel (
    id integer NOT NULL,
    annee integer NOT NULL,
    mois integer NOT NULL,
    memo text DEFAULT ''::text,
    km_defaut numeric(10,2) DEFAULT 53.4,
    km_par_jour jsonb DEFAULT '{}'::jsonb,
    ferme_par_jour jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE public.recap_mensuel OWNER TO postgres;

--
-- Name: recap_mensuel_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recap_mensuel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recap_mensuel_id_seq OWNER TO postgres;

--
-- Name: recap_mensuel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recap_mensuel_id_seq OWNED BY public.recap_mensuel.id;


--
-- Name: reservations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reservations (
    id integer NOT NULL,
    table_id integer,
    client_id integer,
    nom_client character varying(100) NOT NULL,
    date_reservation date NOT NULL,
    heure time without time zone NOT NULL,
    nb_personnes integer DEFAULT 2 NOT NULL,
    remarque text,
    statut character varying(20) DEFAULT 'confirmee'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.reservations OWNER TO postgres;

--
-- Name: reservations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reservations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reservations_id_seq OWNER TO postgres;

--
-- Name: reservations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reservations_id_seq OWNED BY public.reservations.id;


--
-- Name: table_position_jour; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.table_position_jour (
    id integer NOT NULL,
    table_id integer NOT NULL,
    date date NOT NULL,
    pos_x integer,
    pos_y integer,
    statut character varying(20),
    heure_arrivee time without time zone
);


ALTER TABLE public.table_position_jour OWNER TO postgres;

--
-- Name: table_position_jour_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.table_position_jour_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.table_position_jour_id_seq OWNER TO postgres;

--
-- Name: table_position_jour_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.table_position_jour_id_seq OWNED BY public.table_position_jour.id;


--
-- Name: tables; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tables (
    id integer NOT NULL,
    nom character varying(10) NOT NULL,
    capacite integer DEFAULT 2 NOT NULL,
    pos_x integer DEFAULT 0 NOT NULL,
    pos_y integer DEFAULT 0 NOT NULL,
    forme character varying(10) DEFAULT 'rect'::character varying NOT NULL,
    statut character varying(20) DEFAULT 'libre'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    nom_reservation character varying(100),
    heure_arrivee timestamp without time zone,
    type character varying(20) DEFAULT 'salle'::character varying NOT NULL
);


ALTER TABLE public.tables OWNER TO postgres;

--
-- Name: tables_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tables_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tables_id_seq OWNER TO postgres;

--
-- Name: tables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tables_id_seq OWNED BY public.tables.id;


--
-- Name: utilisateurs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.utilisateurs (
    id integer NOT NULL,
    username character varying NOT NULL,
    mot_de_passe character varying NOT NULL,
    actif boolean DEFAULT true
);


ALTER TABLE public.utilisateurs OWNER TO postgres;

--
-- Name: utilisateurs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.utilisateurs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.utilisateurs_id_seq OWNER TO postgres;

--
-- Name: utilisateurs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.utilisateurs_id_seq OWNED BY public.utilisateurs.id;


--
-- Name: article_composants id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.article_composants ALTER COLUMN id SET DEFAULT nextval('public.article_composants_id_seq'::regclass);


--
-- Name: articles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.articles ALTER COLUMN id SET DEFAULT nextval('public.articles_id_seq'::regclass);


--
-- Name: articles_achat id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.articles_achat ALTER COLUMN id SET DEFAULT nextval('public.articles_achat_id_seq'::regclass);


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- Name: commandes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commandes ALTER COLUMN id SET DEFAULT nextval('public.commandes_id_seq'::regclass);


--
-- Name: encaissement_lignes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encaissement_lignes ALTER COLUMN id SET DEFAULT nextval('public.encaissement_lignes_id_seq'::regclass);


--
-- Name: encaissements id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encaissements ALTER COLUMN id SET DEFAULT nextval('public.encaissements_id_seq'::regclass);


--
-- Name: recap_mensuel id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recap_mensuel ALTER COLUMN id SET DEFAULT nextval('public.recap_mensuel_id_seq'::regclass);


--
-- Name: reservations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations ALTER COLUMN id SET DEFAULT nextval('public.reservations_id_seq'::regclass);


--
-- Name: table_position_jour id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.table_position_jour ALTER COLUMN id SET DEFAULT nextval('public.table_position_jour_id_seq'::regclass);


--
-- Name: tables id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tables ALTER COLUMN id SET DEFAULT nextval('public.tables_id_seq'::regclass);


--
-- Name: utilisateurs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateurs ALTER COLUMN id SET DEFAULT nextval('public.utilisateurs_id_seq'::regclass);


--
-- Data for Name: article_composants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.article_composants (id, article_id, description, prix) FROM stdin;
102	110	Sauce de base 2 louches	0.00
103	110	1 Courgette	0.00
104	110	6 scampis	0.00
105	79	Olives (40)	0.00
106	79	Sel/Ppivre	0.00
107	79	Oignons cube 1Kg	0.00
108	79	Miel 250gr	0.00
109	79	Coriandre congelée	0.00
110	79	Cubes bouillon (10)	0.00
111	79	Coriandre fraîche	0.00
112	79	Maizena brune	0.00
115	83	Tagliatelles (5 nids)	0.00
116	83	6 scampis	0.00
117	82	Sauce Polpettes (2 louches)	1.00
119	82	3 polpettes	3.00
120	80	200 Gr de Semoule	0.50
121	80	1/2 L de bouillon	1.00
122	84	Papardelles (2 nids )	0.00
123	84	Tagliatelles (5 nids)	0.00
124	84	1 louche sauce truffes	0.00
125	107	2 Louches de sauce Tchak	0.00
126	107	1 Merguez	1.00
127	107	1 Œuf	0.50
133	112	100 ml Crème 30%	0.50
134	112	Sucre de canne	0.00
135	112	Dose de whisky	0.50
136	112	Café	0.50
137	90	nan	18.00
140	73	Fromages	0.00
145	73	Salaisons	0.00
156	85	Glace 2 boules	0.00
157	85	Biscuit	0.00
160	140	1/2 Tomate Cœur de Bœuf	0.00
161	140	1/2 Tomate Jaune	0.00
162	140	1 Tomate noire (Kumato)	0.00
164	140	3 mini-boules de mozza	0.00
165	140	4 tranches de Prosciutto grillées	0.00
170	140	Salade	0.00
171	81	200Gr semoule	0.50
172	81	1 Merguez	0.70
173	81	1/2L bouillon	1.00
175	155	2 Louches sauce de base	0.50
176	155	Pâtes	0.50
177	155	5 scampis	2.50
178	144	Pâtes	0.00
179	144	Straciatella	2.05
180	144	6 Scampis	0.00
181	144	2 louches de Sauce de Base	0.00
182	74	5 verres avec 1 litre	2.00
183	154	Pâtes	1.00
184	154	2 louches de sauce	0.50
185	77	5 Scampis	2.00
186	77	2 Louches de sauce de base + Piquant	0.50
187	221	Burrata	0.00
188	221	Pignons	0.00
189	4	5 verres au litre	0.00
190	118	375gr lait entier	0.50
191	118	15 jaune d'oeufs	5.00
192	118	200gr sucre vanillé	2.00
193	118	Recette pour 13 crèmes	0.00
194	118	187,5gr sucre semoule	2.00
195	118	625gr crème 35%	1.50
174	81	1 Cuisse de poulet rôti	1.63
196	73	Tapas	0.00
197	73	Garniture	0.00
169	140	Garniture	0.00
118	82	Parmesan	0.50
131	115	Cornet	0.25
146	114	Fourchette	0.10
198	165	Tagliatelles	1.50
199	165	Burrata	1.80
200	165	Sauce de base	0.50
129	115	Fourchette	0.10
113	83	Sauce de base	0.50
153	116	Fourchette	0.10
128	115	Sauce Truffe	1.00
132	115	Pennes	1.50
148	114	Pennes	1.50
154	116	Pennes	1.50
130	115	Serviette	0.10
151	116	Serviette	0.10
147	114	Sauce Bolo	1.00
150	114	Cornet	0.25
152	116	Cornet	0.25
155	116	Sauce Lard	1.00
201	114	Serviette	0.10
202	78	Sauce de base	0.50
203	78	Champignons	1.50
\.


--
-- Data for Name: articles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.articles (id, nom, categorie, type_article, tva, prix_achat, prix_vente, prix_vente_away, stock, stock_min, stock_max, ean, fournisseur, localisation, actif, created_at, updated_at, tva_away, code_vente, stock_a_suivre, est_boisson, type, imprimer_cuisine, ordre) FROM stdin;
39	ESPRESSO	BOISSONS	BOISSONS CHAUDES	21.00	0.25	2.50	2.50	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7003	f	f	vente	f	\N
110	PÂTES COURGETTE	PLAT	4B. VG	12.00	4.50	14.00	14.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	9
88	FRANGELICA	POUSSE	6. POUSSE-CAFÉ	21.00	0.00	6.00	6.00	0	0	0	\N	\N	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	f	vente	f	\N
92	IRISH COFFEE	POUSSE	6. POUSSE-CAFÉ	21.00	1.50	8.00	8.00	39	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	f	vente	f	\N
95	CÔTES DE RHÔNES	BOISSONS	VIN ROUGE	21.00	7.00	24.00	24.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7004	f	f	vente	f	\N
515	Service ANTON	SERVICE	Service ANTON	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
532	Service Jeff	SERVICE	Service Jeff	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
100	BLANC VERRE	BOISSONS	VIN BLANC	21.00	0.90	5.00	5.00	76	10	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7004	f	f	vente	f	\N
101	ROUGE VERRE	BOISSONS	VIN ROUGE	21.00	1.25	5.00	4.00	12	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7004	f	f	vente	f	\N
108	FORFAIT	FORFAIT	8. FORFAITS	12.00	0.00	50.00	50.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	12.00	7002	f	f	vente	f	\N
79	TAJINE	PLAT	4. PLATS	12.00	2.00	17.00	17.00	-29	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	2
111	JUPILER	BOISSONS	2B. BIÈRE	21.00	0.80	2.50	2.50	-42	24	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	t	vente	f	1
83	PÂTES SCAMPIS	PLAT	4A. PÂTES	12.00	4.00	17.00	17.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	4
82	POLPETTE	PLAT	4. PLATS	12.00	1.00	16.00	16.00	-46	5	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	3
80	COUSCOUS VG	PLAT	4B. VG	12.00	1.50	12.00	12.00	55	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	1
84	PÂTES TRUFFE	PLAT	4B. VG	12.00	4.00	14.00	14.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	4
107	CHAKTCHOUKA	ENTREES	3. ENTRÉES	12.00	2.50	12.00	12.00	-19	4	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	3
105	POLPETTE	PLAT	7. ENFANTS	12.00	0.00	10.00	10.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	\N
115	CORNET TRUFFE	PLAT	1. MIDI	6.00	2.50	7.00	7.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	\N
64	GATEAUX MIEL	DESSERT	5. DESSERTS	12.00	2.00	5.00	5.00	0	4	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	f	10
78	CHAMPIGNONS KABYLES	ENTREES	3. ENTRÉES	12.00	2.00	10.00	10.00	-40	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	1
112	IRISH COFFEE	DESSERT	5. DESSERTS	21.00	1.50	8.00	8.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7002	f	f	vente	t	5
106	TAJINE	PLAT	7. ENFANTS	12.00	0.00	10.00	10.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	\N
9	VIOLETTE	BOISSONS	2. APERITIF	21.00	2.50	8.00	8.00	40	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	t	vente	f	2
75	Cuba-Li	BOISSONS	2. APERITIF	21.00	0.86	8.00	8.00	99	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	t	vente	f	4
87	AMARETTO	POUSSE	6. POUSSE-CAFÉ	21.00	0.00	6.00	6.00	86	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	t	vente	f	\N
10	SOFT (Verre)	BOISSONS	2C. SOFTS	21.00	0.50	2.20	2.20	-7	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7003	f	f	vente	f	6
67	EAU PÉTILLANTE 1 L	BOISSONS	2C. SOFTS	21.00	0.80	5.00	5.00	13	6	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7003	f	t	vente	f	8
41	CAFÉ	BOISSONS	BOISSONS CHAUDES	21.00	0.25	2.50	2.50	24	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7003	f	t	vente	f	\N
94	EAU PET VERRE	BOISSONS	2C. SOFTS	21.00	0.50	2.20	2.20	50	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7003	f	f	vente	f	9
109	FORFAIT BOISSONS	BOISSONS	2C. SOFTS	21.00	0.00	0.00	0.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7003	f	f	vente	f	99
76	BLONDINETTE	BOISSONS	2B. BIÈRE	21.00	1.60	4.00	4.00	48	24	48	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	t	vente	f	3
102	TRIPLE	BOISSONS	2B. BIÈRE	21.00	1.74	4.50	4.50	24	24	48	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	t	vente	f	4
90	GRAPPA	POUSSE	6. POUSSE-CAFÉ	21.00	0.50	6.00	6.00	87	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	t	vente	f	\N
70	LIMONCELLO	POUSSE	6. POUSSE-CAFÉ	21.00	1.00	6.00	6.00	-2	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	t	vente	f	\N
91	RHUM	POUSSE	6. POUSSE-CAFÉ	21.00	0.00	6.00	6.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	t	vente	f	\N
89	SAMBUCA	POUSSE	6. POUSSE-CAFÉ	21.00	0.50	6.00	6.00	-2	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	t	vente	f	\N
99	EAU PET 1/2 L	BOISSONS	2C. SOFTS	21.00	0.50	3.50	3.50	6	18	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7003	f	t	vente	f	7
35	NERO D'AVOLA	BOISSONS	VIN ROUGE	21.00	5.50	30.00	30.00	7	6	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7004	f	t	vente	f	\N
42	CAPUCCINO	BOISSONS	BOISSONS CHAUDES	21.00	0.25	2.80	2.80	99	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7003	f	f	vente	f	\N
36	PINOT GRIGIO	BOISSONS	VIN BLANC	21.00	5.99	20.00	20.00	15	6	12	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7004	f	t	vente	f	\N
34	PRIMITIVO NR 14	BOISSONS	VIN ROUGE	21.00	7.87	24.00	8.00	11	6	12	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7004	f	t	vente	f	\N
73	ASSIETTE APERITIVE (2 p.)	ENTREES	3. ENTRÉES	12.00	7.50	19.00	19.00	-22	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	1
65	TIRAMISU GLACÉ	DESSERT	5. DESSERTS	12.00	1.00	6.00	6.00	1	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	2
104	PÂTES	PLAT	7. ENFANTS	12.00	3.00	10.00	10.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	\N
114	CORNET BOLO	PLAT	1. MIDI	6.00	2.00	6.00	6.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	\N
116	CORNET LARD	PLAT	1. MIDI	6.00	2.00	6.00	6.00	0	0	0	LARD	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	\N
103	COUSCOUS	PLAT	7. ENFANTS	12.00	3.95	10.00	10.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	\N
85	GLACE	DESSERT	5. DESSERTS	12.00	2.00	5.00	5.00	-22	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	8
179	TATIN	DESSERT	5. DESSERTS	12.00	1.50	8.00	0.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	f	11
183	PÂTES COURGETTE + SCAMPIS	PLAT	4A. PÂTES	12.00	3.75	18.00	18.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	5
145	ROSÉ PATRON	BOISSONS	VIN ROSE	21.00	4.50	15.00	15.00	-3	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7004	f	f	vente	f	\N
146	ROSÉ VERRE	BOISSONS	VIN ROSE	21.00	0.90	5.00	5.00	-32	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7004	f	f	vente	f	\N
140	BURRATINA	PLAT	4. PLATS	12.00	6.00	14.00	14.00	0	0	0	\N	\N	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	98
148	BLANC 1/2	BOISSONS	VIN BLANC	21.00	3.00	13.00	13.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7004	f	f	vente	f	\N
165	PÂTES STRACIATELLA	PLAT	4B. VG	12.00	5.00	16.00	16.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	1
157	CHOUFFE COFFEE	POUSSE	6. POUSSE-CAFÉ	21.00	1.50	8.00	8.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	f	vente	f	\N
174	PÂTES PESTO	PLAT	4B. VG	12.00	4.00	14.00	14.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	6
175	PLAT SPÉCIAL	PLAT	9. SUGGESTIONS	12.00	2.50	18.00	18.00	87	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	\N
167	MENU DES FÊTES	FORFAIT	8. FORFAITS	6.00	0.00	40.00	0.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7002	f	f	vente	f	\N
169	PINOT BLANC	BOISSONS	VIN BLANC	21.00	4.50	24.00	24.00	0	0	0	\N	\N	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7004	f	f	vente	f	\N
172	BULLES 0%	ENTREES	2D. ZERO	21.00	1.25	6.00	6.00	12	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	f	vente	f	\N
177	CREME PISTACHE	POUSSE	6. POUSSE-CAFÉ	21.00	1.50	6.00	6.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	f	vente	f	\N
176	SABAYON	DESSERT	5. DESSERTS	12.00	2.00	8.00	8.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	6
195	HUILE ESPEJO	VENTE	99. VENTES	6.00	12.50	20.00	20.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7005	f	f	vente	f	\N
196	HUILE GUGLIELMI	VENTE	99. VENTES	6.00	6.00	10.00	10.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7005	f	f	vente	f	\N
81	COUSCOUS PM	PLAT	4. PLATS	12.00	3.95	17.00	17.00	39	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	1
155	SCAMPIS LUCIFER	PLAT	4. PLATS	12.00	3.50	15.00	15.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	5
200	L'OUSTEAU (AUBERGINES)	VENTE	99. VENTES	6.00	4.79	7.50	7.50	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7005	f	f	vente	f	\N
201	L'OUSTEAU (COURGETTES)	VENTE	99. VENTES	6.00	4.79	7.50	7.50	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7005	f	f	vente	f	\N
202	L'OUSTEAU (OIGNONS CONFITS)	VENTE	99. VENTES	6.00	4.79	7.50	7.50	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7005	f	f	vente	f	\N
203	L'OUSTEAU (TOMATES SECHEES)	VENTE	99. VENTES	6.00	4.79	7.50	7.50	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7005	f	f	vente	f	\N
204	L'OUSTEAU (POIVRONS)	VENTE	99. VENTES	6.00	4.79	7.50	7.50	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7005	f	f	vente	f	\N
205	L'OUSTEAU (OLIVES NOIRES)	VENTE	99. VENTES	6.00	4.79	7.50	7.50	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7005	f	f	vente	f	\N
144	PÂTES STRACIATELLA SCAMPIS	PLAT	4A. PÂTES	12.00	5.50	20.00	20.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	7
173	CREPE FLAMBEE GD MARNIER	DESSERT	5. DESSERTS	12.00	2.00	10.00	10.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	4
190	PÂTES ASPERGES	PLAT	4A. PÂTES	12.00	2.50	18.00	18.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	8
151	BURRATA	ENTREES	3. ENTRÉES	12.00	1.75	8.00	8.00	9	6	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	f	98
117	BLANCOCA	BOISSONS	2. APERITIF	21.00	1.00	4.00	4.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	t	vente	f	7
193	FANTA	BOISSONS	2C. SOFTS	21.00	0.90	2.20	2.20	3	15	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7003	f	t	vente	f	3
182	BLUSH	BOISSONS	VIN ROSE	21.00	4.95	20.00	20.00	16	6	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7004	f	t	vente	f	\N
171	CHARDONNAY FIO	BOISSONS	VIN BLANC	21.00	4.95	20.00	20.00	13	6	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7004	f	t	vente	f	\N
158	GINGEMBRE	BOISSONS	2. APERITIF	21.00	2.50	8.00	8.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	f	vente	f	3
206	SPRITZ 0%	BOISSONS	2D. ZERO	21.00	1.25	8.00	8.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	t	vente	f	\N
74	PECKET FRAISE	BOISSONS	2. APERITIF	21.00	2.00	8.00	8.00	-26	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	t	vente	f	1
153	ORVAL	BOISSONS	2B. BIÈRE	21.00	1.60	5.00	5.00	72	24	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	t	vente	f	6
207	GIN 0%	BOISSONS	2D. ZERO	21.00	1.25	8.00	8.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	t	vente	f	\N
192	COCA ZERO	BOISSONS	2C. SOFTS	21.00	0.50	2.20	2.20	-1	15	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7003	f	t	vente	f	2
194	ICE TEA	BOISSONS	2C. SOFTS	21.00	0.80	2.20	2.20	9	15	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7003	f	t	vente	f	4
154	PÂTES BOLO	PLAT	4A. PÂTES	12.00	2.50	14.00	14.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	2
77	SCAMPIS LUCIFER	ENTREES	3. ENTRÉES	12.00	3.50	12.00	12.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	5
135	DIVERS	\N	9. SUGGESTIONS	12.00	0.00	3.00	3.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	\N
150	SALADE FOLLE	ENTREES	3. ENTRÉES	12.00	0.00	5.00	0.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	99
168	CHOUCROUTE	\N	9. SUGGESTIONS	12.00	10.00	24.00	24.00	0	0	0	\N	\N	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	\N
566	BMW X3	Véhicule		0.00	0.00	0.00	\N	0	0	0				t	2026-06-24 15:53:41.928693	2026-06-24 15:53:41.928693	\N	9001	f	f	vente	f	\N
231	CRÊPE CREME LARD	\N	9A. CRÊPES	12.00	1.80	14.00	14.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	3
233	CRÊPE KABYLE	\N	9B. CRÊPES VG	12.00	3.00	14.00	14.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	3
220	BON KDO	\N	99. VENTES	0.00	7.50	50.00	0.00	0	0	0	\N	\N	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	0.00	7005	f	f	vente	f	\N
225	GRAPPA MIEL	\N	6. POUSSE-CAFÉ	21.00	0.50	6.00	6.00	20	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	f	vente	f	\N
226	CREME CITRON	\N	6. POUSSE-CAFÉ	21.00	1.50	6.00	6.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	f	vente	f	\N
238	ZÉRO	\N	99. VENTES	6.00	0.00	0.00	0.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7005	f	f	vente	f	\N
215	EAU DE BARNEY	BOISSONS	2C. SOFTS	21.00	0.50	0.00	0.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7003	f	f	vente	f	97
247	DECA	\N	BOISSONS CHAUDES	21.00	0.25	2.50	2.50	99	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7003	f	f	vente	f	\N
270	VAL DIEU	\N	2B. BIÈRE	21.00	1.60	4.00	4.00	8	12	24	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	t	vente	f	5
277	PÂTES	\N	4A. PÂTES	12.00	2.50	8.00	8.00	99	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	1
228	PÂTES CREME LARDONS	\N	4A. PÂTES	12.00	2.50	14.00	14.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	3
259	MANDURIA	\N	VIN ROUGE	21.00	12.00	30.00	30.00	12	6	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7004	f	f	vente	f	\N
236	PÂTES TRUFFE + BURRATA	\N	4B. VG	12.00	4.00	18.00	18.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	8
237	PÂTES BOMBE ATOMIQUE + BURRATA	\N	4B. VG	12.00	4.00	17.00	17.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	8
221	SAUMON BURRATA PESTO	\N	9. SUGGESTIONS	12.00	4.50	16.00	16.00	0	0	0	\N	\N	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	\N
257	POTEE AL D'JOTE	\N	9. SUGGESTIONS	12.00	0.00	18.00	18.00	0	2	0	\N	\N	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	\N
230	CRÈPE LARDONS	\N	9. SUGGESTIONS	12.00	4.50	14.00	14.00	0	0	0	\N	\N	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	\N
245	CRÊPE CHAKCHOUKA XXL	\N	9A. CRÊPES	12.00	5.25	17.00	17.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	2
229	CRÈPE CHAMPIGNONS	\N	9. SUGGESTIONS	12.00	4.50	14.00	14.00	0	0	0	\N	\N	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	\N
208	BEIGNETS DE COURGETTE	ENTREES	3. ENTRÉES	12.00	7.50	18.00	18.00	-34	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	6
272	VIN CHAUD	\N	BOISSONS CHAUDES	21.00	0.25	2.50	2.50	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7004	f	f	vente	f	\N
241	CREPE GORGONZOLA COURGETTES XXL	\N	9B. CRÊPES VG	12.00	4.00	19.00	19.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	2
260	CREPE SUCRE	\N	5. DESSERTS	12.00	1.00	5.00	5.00	-22	6	10	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	3
235	CRÊPE TRUFFES BURRATA	\N	9B. CRÊPES VG	12.00	4.25	20.00	20.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	7
242	CRÊPE TRUFFES BURRATA XXL	\N	9B. CRÊPES VG	12.00	4.25	23.00	23.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	8
243	CRÊPE BASE + BURRATA XXL	\N	9B. CRÊPES VG	12.00	4.75	17.00	17.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	10
224	ARANCELLO	\N	6. POUSSE-CAFÉ	21.00	1.00	6.00	6.00	48	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	t	vente	f	\N
213	CYNAR	POUSSE	6. POUSSE-CAFÉ	21.00	1.25	5.00	5.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	t	vente	f	\N
234	CRÊPE BASE + BURRATA	\N	9B. CRÊPES VG	12.00	3.75	14.00	14.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	f	9
218	BULLES CHOCOLAT	BOISSONS	2A. BULLES	21.00	8.90	16.00	16.00	18	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	t	vente	f	4
227	COCA	\N	2C. SOFTS	21.00	0.50	2.20	2.20	0	15	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7003	f	t	vente	f	1
44	THÉ MENTHE	BOISSONS	BOISSONS CHAUDES	21.00	0.25	2.50	2.50	5	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7003	f	t	vente	f	\N
214	AMARONE	BOISSONS	VIN ROUGE	21.00	26.01	50.00	50.00	4	3	6	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7004	f	t	vente	f	\N
232	CRÊPE CHAKCHOUKA	\N	9A. CRÊPES	12.00	3.50	14.00	14.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	1
240	CRÊPE GORGONZOLA COURGETTES	\N	9B. CRÊPES VG	12.00	3.00	16.00	16.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	1
246	CRÊPE CREME LARD XXL	\N	9A. CRÊPES	12.00	2.80	17.00	17.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	4
244	CRÊPE KABYLE XXL	\N	9B. CRÊPES VG	12.00	4.00	17.00	17.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	4
219	ARROSTICINNI (5)	\N	3. ENTRÉES	12.00	4.00	8.00	8.00	-10	10	10	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	7
248	SABAYON SPECIAL	\N	5. DESSERTS	12.00	0.00	10.00	10.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	7
310	CRÊPE TRUFFES XXL	\N	9B. CRÊPES VG	12.00	4.25	20.00	20.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	6
1	PROSECCO Bouteille	BOISSONS	2A. BULLES	21.00	6.50	25.00	25.00	10	6	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	t	vente	f	2
309	CRÊPE TRUFFES	\N	9B. CRÊPES VG	12.00	4.25	17.00	17.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	5
184	CARAFE EAU	BOISSONS	2C. SOFTS	21.00	0.50	0.00	0.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7003	f	f	vente	f	\N
285	RIESLING	\N	VIN BLANC	21.00	10.80	24.00	24.00	5	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7004	f	f	vente	f	\N
346	MERGUEZ	Magasin	MERGUEZ	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
340	HACHIS BOLO	Magasin	HACHIS BOLO	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
294	FRAISE 1L	\N	99. VENTES	21.00	12.50	12.00	12.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	f	vente	f	\N
295	FRAISE 1/2L	\N	99. VENTES	21.00	12.50	8.00	8.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	f	vente	f	\N
301	ALCOOL	\N	6. POUSSE-CAFÉ	21.00	0.00	6.00	6.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	f	vente	f	\N
567	Work Today	Charge Fixe	Work Today	0.00	0.00	0.00	0.00	0	0	0				t	2026-06-27 21:29:38.650828	2026-06-27 21:29:38.650828	0.00	9001	f	f	vente	f	\N
303	PÂTES COURGETTE + SCAMPIS + BURRATA	\N	4A. PÂTES	12.00	3.75	22.00	22.00	0	0	0	\N	\N	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	6
311	VIN DU MOIS	\N	VIN ROSE	21.00	4.50	15.00	15.00	-11	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7004	f	f	vente	f	\N
308	PÂTES RAGÙ	\N	4A. PÂTES	12.00	2.50	15.00	15.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	9
304	PÂTES SAUCE BASE	\N	4B. VG	12.00	2.50	12.00	12.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	-2
293	BEIGNETS FLEUR DE COURGETTES	\N	4B. VG	12.00	4.50	18.00	18.00	3	3	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	11
312	SMASH	\N	2B. BIÈRE	21.00	2.40	4.50	4.50	19	12	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	f	vente	f	2
286	DEFERLANTE	\N	2B. BIÈRE	21.00	1.60	4.00	4.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	f	vente	f	8
279	NOËL (BRUNE)	\N	2B. BIÈRE	21.00	1.60	4.00	4.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	f	vente	f	9
281	CANNELLONI VIANDE	\N	4. PLATS	12.00	4.50	17.00	17.00	-2	3	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	4
283	COUSCOUS AGNEAU	\N	4. PLATS	12.00	3.95	25.00	25.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	99
280	AGNEAU + GRATIN	\N	4. PLATS	12.00	8.00	25.00	25.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	97
287	BIERE AUTRE	\N	2B. BIÈRE	21.00	0.80	2.50	2.50	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	f	vente	f	10
297	SPARE RIBS	\N	9. SUGGESTIONS	12.00	4.50	18.00	18.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	\N
2	APEROL SPRITZ	BOISSONS	2. APERITIF	21.00	0.00	8.00	8.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	t	vente	f	6
284	LASAGNE DU BOUCHER	\N	9. SUGGESTIONS	12.00	6.50	15.00	15.00	0	0	0	\N	\N	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	\N
4	PROSECCO VERRE	BOISSONS	2A. BULLES	21.00	1.25	6.00	6.00	51	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	f	vente	f	1
296	RICARD	\N	2. APERITIF	21.00	2.00	5.00	5.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	t	vente	f	8
6	GIN TONIC	BOISSONS	2. APERITIF	21.00	2.00	10.00	10.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	t	vente	f	5
299	ROSÉ MAISON	\N	VIN ROSE	21.00	0.90	3.50	3.50	-28	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7004	f	t	vente	f	\N
300	ASSORTIMENT CROQUETTES	\N	3. ENTRÉES	12.00	5.00	20.00	20.00	-1	4	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	2
291	VIANDE + GRATIN	\N	9. SUGGESTIONS	12.00	10.00	24.00	24.00	-16	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	\N
321	ALVO	Magasin	ALVO	0.00	0.00	0.00	0.00	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	0.00	9001	f	f	depense	f	\N
322	AVA	Magasin	AVA	0.00	0.00	0.00	0.00	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	0.00	9001	f	f	depense	f	\N
325	BOULANGERIE	Magasin	BOULANGERIE	0.00	0.00	0.00	0.00	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	0.00	9001	f	f	depense	f	\N
326	BUTERA	Magasin	BUTERA	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
327	CARBURANT	Charge Fixe	CARBURANT	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
328	CASH-ITALIA	Magasin	CASH-ITALIA	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
329	CLABOTS	Magasin	CLABOTS	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
330	COLRUYT	Magasin	COLRUYT	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
331	COMPTABLE	Charge Fixe	COMPTABLE	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
333	DELHAIZE	Magasin	DELHAIZE	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
334	DESPRIETS	Magasin	DESPRIETS	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
341	IKEA	Magasin	IKEA	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
342	INTERMARCHE	Magasin	INTERMARCHE	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
345	MAISON ITALIENNE	Magasin	MAISON ITALIENNE	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
347	NETTOYAGE	Charge Fixe	NETTOYAGE	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
358	SPAR	Magasin	SPAR	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
364	VERACHTERT	Magasin	VERACHTERT	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
561	VENERIA CARS	Magasin	VENERIA CARS	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
363	VDS	Magasin	VDS	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
362	TURC	Magasin	TURC	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
361	TRAFIC	Magasin	TRAFIC	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
360	TEMPO-TEAM	Charge Fixe	TEMPO-TEAM	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
568	Yooza	Entretien	Yooza	0.00	0.00	0.00	\N	0	0	0				t	2026-06-27 22:27:25.392186	2026-06-27 22:27:25.392186	\N	9001	f	f	vente	f	\N
8	MARTINI Blanc/Rouge	BOISSONS	2. APERITIF	21.00	0.00	6.00	6.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	f	vente	f	9
348	NITOUCHE	Magasin	NITOUCHE	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
349	NOSTRA LIEGE	Magasin	NOSTRA LIEGE	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
351	OLEODELICES	Magasin	OLEODELICES	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
353	PAQUE	Magasin	PAQUE	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
356	SAHIN	Magasin	SAHIN	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	9001	f	f	depense	f	\N
376	Service CHA	SERVICE	Service CHA	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:31.596144	2026-06-22 12:35:31.596144	\N	9001	f	f	depense	f	\N
377	Service EVE	SERVICE	Service EVE	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:31.596144	2026-06-22 12:35:31.596144	\N	9001	f	f	depense	f	\N
378	Service INES	SERVICE	Service INES	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:31.596144	2026-06-22 12:35:31.596144	\N	9001	f	f	depense	f	\N
569	Afsca	Taxe	Afsca	0.00	0.00	0.00	\N	0	0	0				t	2026-06-27 22:29:24.046819	2026-06-27 22:29:24.046819	\N	9001	f	f	vente	f	\N
118	CREME BRULEE	DESSERT	5. DESSERTS	12.00	1.50	6.00	6.00	-19	6	12	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	1
369	LOYER	Charge Fixe	LOYER	0.00	0.00	0.00	0.00	0	0	0	\N	\N	\N	t	2026-06-22 12:35:31.596144	2026-06-22 12:35:31.596144	0.00	9001	f	f	depense	f	\N
368	ENERGIES	Charge Fixe	ENERGIES	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 12:35:31.596144	2026-06-22 12:35:31.596144	\N	9001	f	f	depense	f	\N
375	Service ANTON	SERVICE	Service ANTON	0.00	0.00	0.00	0.00	0	0	0	\N	\N	\N	t	2026-06-22 12:35:31.596144	2026-06-22 12:35:31.596144	0.00	9001	f	f	depense	f	\N
119	ROUGE 1/2	BOISSONS	VIN ROUGE	21.00	4.00	14.00	14.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7004	f	f	vente	f	\N
429	DAMBIERMONT	Véhicule	DAMBIERMONT	0.00	0.00	0.00	0.00	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	0.00	9001	f	f	depense	f	\N
570	Adibox	Charge Fixe	Adibox	0.00	0.00	0.00	\N	0	0	0				t	2026-06-27 22:39:14.928665	2026-06-27 22:39:14.928665	\N	9001	f	f	vente	f	\N
185	PÂTES PESTO + BURRATA	PLAT	4B. VG	12.00	4.00	18.00	18.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	7
188	BIERLAINOISE	BOISSONS	2B. BIÈRE	21.00	1.60	4.00	4.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	f	vente	f	7
435	DIVERS	\N	DIVERS	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
380	ACTION	Magasin	ACTION	0.00	0.00	0.00	0.00	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	0.00	9001	f	f	depense	f	\N
383	ALBINETE	Magasin	ALBINETE	0.00	0.00	0.00	0.00	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	0.00	9001	f	f	depense	f	\N
384	ALDI	Magasin	ALDI	0.00	0.00	0.00	0.00	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	0.00	9001	f	f	depense	f	\N
389	ASSURANCE	Assurances	ASSURANCE	0.00	0.00	0.00	0.00	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	0.00	9001	f	f	depense	f	\N
398	BIO	Magasin	BIO	0.00	0.00	0.00	0.00	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	0.00	9001	f	f	depense	f	\N
402	BRICO	Magasin	BRICO	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
404	BULEX	Charge Fixe	BULEX	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
440	EQUIPEMENT	Equipement	EQUIPEMENT	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
441	EVRARD	Magasin	EVRARD	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
382	AG ASSURANCE	Charge Fixe	AG ASSURANCE	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
250	CANNELLONI RICO/EPI	\N	4B. VG	12.00	4.50	17.00	17.00	1	3	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	10
503	SERVICE Caro	SERVICE	SERVICE Caro	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
502	SERVICE CELIA	SERVICE	SERVICE CELIA	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
113	4 FROMAGES	PLAT	1. MIDI	6.00	0.00	6.00	6.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	t	f	vente	t	\N
251	BLUSH 1/4	\N	VIN ROSE	21.00	4.50	8.00	8.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7004	f	f	vente	f	\N
252	ROUGE 1/4	\N	VIN ROUGE	21.00	6.50	8.00	8.00	-1	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7004	f	f	vente	f	\N
253	BLANC 1/4	\N	VIN BLANC	21.00	3.00	8.00	0.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7004	f	f	vente	f	\N
450	HOPSEIDON	Magasin	HOPSEIDON	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
452	JAMENDO	Charge Fixe	JAMENDO	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
456	LIDL	Magasin	LIDL	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
472	ORANGE	Charge Fixe	ORANGE	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
481	POULET	Magasin	POULET	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
483	PROXIMUS	Charge Fixe	PROXIMUS	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
500	SABAM	Charge Fixe	SABAM	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
316	SALADE PERLES MARINES	\N	9. SUGGESTIONS	12.00	4.50	18.00	18.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	\N
315	L'OR D'AURORE	\N	5. DESSERTS	21.00	1.00	8.00	8.00	10	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	f	9
317	CHAMPAGNE	\N	2A. BULLES	21.00	30.00	50.00	50.00	2	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7001	f	f	vente	f	3
313	SCHWEPPES	\N	2C. SOFTS	21.00	0.50	2.20	2.20	12	12	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7003	f	t	vente	f	5
314	PELLEGRINO	\N	2C. SOFTS	21.00	1.00	2.20	2.20	12	12	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	21.00	7003	f	t	vente	f	98
318	CUISSES DE GRENOUILLES AÏL	\N	9. SUGGESTIONS	12.00	4.50	13.00	13.00	0	0	0	\N	\N	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	6.00	7002	f	f	vente	t	\N
518	Service Caro	SERVICE	Service Caro	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
519	Service Carol	SERVICE	Service Carol	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
522	Service Célia	SERVICE	Service Célia	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
523	Service EDOUARD	SERVICE	Service EDOUARD	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
527	Service Elise	SERVICE	Service Elise	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
524	Service ERIC	SERVICE	Service ERIC	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
528	Service Fanny	SERVICE	Service Fanny	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
529	Service HANAË	SERVICE	Service HANAË	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
536	Service Léa	SERVICE	Service Léa	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
535	Service Louna	SERVICE	Service Louna	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
537	Service Marie	SERVICE	Service Marie	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
539	Service Maurine	SERVICE	Service Maurine	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
541	Service NILAYA	SERVICE	Service NILAYA	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
546	Service Véro	SERVICE	Service Véro	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
545	Service Victor	SERVICE	Service Victor	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
512	STNI	Magasin	STNI	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
557	UCM	Charge Fixe	UCM	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
554	TVA	Charge Fixe	TVA	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
556	Taxes Liège	Taxe	Taxes Liège	0.00	0.00	0.00	\N	0	0	0	\N	\N	\N	t	2026-06-22 23:08:37.104686	2026-06-22 23:08:37.104686	\N	9001	f	f	depense	f	\N
\.


--
-- Data for Name: articles_achat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.articles_achat (id, nom, qte, prix_achat, magasin, a_commander, date_derniere_commande) FROM stdin;
2	Aluminium	1	1.00	COLRUYT	f	\N
3	Amandes	0	\N	TURC	f	\N
4	Amarone	3	21.00	NOSTRA	f	\N
19	Bulles Chocolat	0	\N	O CHOCOLAT	f	\N
22	Canneloni VG	0	\N	WANZE	f	\N
24	Caprons	1	1.00	COLRUYT	f	\N
25	Carottes	0	1.50	COLRUYT	f	\N
26	CCMel	1	1.00	COLRUYT	f	\N
28	Champignons	2	2.00	COLRUYT	f	\N
30	Chateaubriand	2	7.00	INTER	f	\N
31	Choucroute	0	10.00	MIKE	f	\N
32	Citron	1	1.00	COLRUYT	f	\N
33	Citron confit	0	\N	TURC	f	\N
34	Coca (15)	0	12.00	COLRUYT	f	\N
36	Concentré de tomate	0	\N	COLRUYT	f	\N
37	Confiture	1	2.00	TURC	f	\N
38	Contrefilet	0	13.00	EVRARD	f	\N
39	Coriandre	2	1.00	COLRUYT	f	\N
44	Crème 40%	24	0.79	INTER	f	\N
45	Crème Light	1	1.00	COLRUYT	f	\N
47	Croquettes Chicons Lardons	0	\N	DENIS	f	\N
55	Cube bouillon	1	0.00	COLRUYT	f	\N
59	Desodorisant WC	0	1.00	ACTION	f	\N
62	Eau Plate 1L	0	0.00	VERACHTERT	f	\N
63	Eau Plate pour café	0	3.00	COLRUYT	f	\N
65	Fanta (15)	0	12.00	COLRUYT	f	\N
66	Farine	1	2.00	COLRUYT	f	\N
67	Feuille A4	1	5.00	TRAFIC	f	\N
68	Fraise	1	0.00	MAISON	f	\N
69	Fromages	0	8.00	WANZE	f	\N
70	Funghi	2	15.00	WANZE	f	\N
71	Gants latex	1	5.00	COLRUYT	f	\N
72	Gâteaux miel	1	\N	TURC	f	\N
73	Gel WC	1	1.00	ACTION	f	\N
76	Glace Chocolat	0	\N	COLRUYT	f	\N
77	Glace Vanille	0	\N	COLRUYT	f	\N
78	Gorgonzola	0	\N	VDS	f	\N
80	Grappa	0	\N	NOSTRA	f	\N
84	Gruyere	4	2.00	COLRUYT	f	\N
86	Harissa	0	\N	TURC	f	\N
88	Jupiler	3	15.00	COLRUYT	f	\N
90	Kiwi	1	1.00	COLRUYT	f	\N
94	Légumes Polpette	0	\N	COLRUYT	f	\N
97	Menthe	2	1.00	TURC	f	\N
99	Miel	1	6.00	COLRUYT	f	\N
101	Mozza billes	1	2.00	INTER	f	\N
102	Navets	1	1.00	COLRUYT	f	\N
103	Œufs	30	4.00	COLRUYT	f	\N
111	Pâtes Complètes	1	2.00	COLRUYT	f	\N
114	Pennes congelées (10Kg)	2	29.80	DESPRIETS	f	\N
116	Pesto	0	\N	COLRUYT	f	\N
123	Prosecco	12	6.50	NOSTRA	f	\N
124	Raisins	1	4.00	INTER	f	\N
125	Raisins secs	0	\N	TURC	f	\N
15	Blush	12	5.00	NOSTRA	f	\N
10	Ballons	1	1.00	TRAFIC	f	\N
16	Boîte ALU 1L + couvercle	1	1.00	AVA	f	\N
20	Burrata	12	1.79	ALDI	f	\N
46	Croquettes Chèvre Chorizo	0	\N	DENIS	f	\N
57	Cure-dent	1	1.00	COLRUYT	f	\N
51	Croquettes Parmesan	0	\N	DENIS	f	\N
54	Croquettes Volaille Truffe	0	\N	DENIS	f	\N
53	Croquettes Poulet	0	\N	DENIS	f	\N
52	Croquettes Porcelet grillé	0	\N	DENIS	f	\N
58	Curry	0	\N	TURC	f	\N
48	Croquettes Gorgonzola noix	0	\N	DENIS	f	\N
56	Cumin	0	\N	TURC	f	\N
60	Eau Pet 1/2	2	18.00	VERACHTERT	f	2026-05-11
49	Croquettes Herve	0	\N	DENIS	f	\N
50	Croquettes Jambon-Coquillettes	0	\N	DENIS	f	\N
9	Bain-Marie	1	1.00	COLRUYT	f	\N
85	Hachis Bolo	1	1.00	TURC	f	\N
89	jus de citron	1	1.00	COLRUYT	f	\N
87	Ice tea	15	0.80	COLRUYT	f	\N
29	Chardonnay FIO	0	6.50	NOSTRA	f	\N
79	Grand Marnier	0	\N	ALDI	f	\N
75	Glace Caramel	0	\N	COLRUYT	f	\N
74	Gin	2	1.00	MAISON	f	\N
81	gratin truffe	1	1.00	COLRUYT	f	\N
40	Cornet emporté	4	5.00	AVA	f	\N
106	Orval	0	\N	INTER	f	\N
98	Merguez	40	0.80	TURC	f	2026-07-02
91	Lait entier	2	1.00	COLRUYT	f	2026-07-03
121	Polpette	20	\N	WANZE	f	\N
41	Courgettes	4	1.00	COLRUYT	f	\N
42	Couvercle 250 Ml	1	1.00	AVA	f	\N
122	Poulet	50	\N	ANS	f	\N
11	Balsamique	1	1.00	COLRUYT	f	2026-01-22
12	Beignet Fleur de courgettes	1	30.00	WANZE	f	2026-06-11
35	Coca zéro (15)	0	12.00	COLRUYT	f	\N
117	Pino Grigio	0	\N	NOSTRA	f	\N
107	Pain Turc	10	0.80	TURC	f	\N
43	crème 20%	0	\N	COLRUYT	f	\N
96	Manduria	12	11.00	NOSTRA	f	\N
21	Café	0	\N	Espagne	f	\N
118	Poireaux	0	2.21	COLRUYT	f	\N
95	Liquide de rinçage	2	1.00	COLRUYT	f	\N
112	Pâtes sans gluten	1	1.00	COLRUYT	f	\N
119	Poivre	0	\N	TURC	f	\N
109	Papier WC	1	1.00	COLRUYT	f	\N
110	Parmesan	6	2.00	COLRUYT	f	\N
113	PDT grenailles	1	1.00	COLRUYT	f	\N
23	Canneloni viande	1	0.00	WANZE	f	\N
83	Grignotin	1	10.00	COLRUYT	f	\N
108	Pamplemousse	1	1.00	COLRUYT	f	\N
93	Légumes Bolo	2	\N	COLRUYT	f	\N
120	Poivrons	1	5.00	DESPRIETS	f	\N
104	Oignons Balsamique	1	1.00	WANZE	f	\N
27	Celeri	0	1.76	COLRUYT	f	\N
105	Oignons congelés (2,5Kg)	1	2.00	COLRUYT	f	\N
115	PERSIL	1	1.00	INTER	f	\N
82	Grenadine	0	\N	COLRUYT	f	\N
5	Aneth	1	1.00	COLRUYT	f	\N
13	Beurre	0	\N	INTER	f	\N
61	Eau Pet 1L	1	18.00	VERACHTERT	f	2026-05-28
64	Eponges	1	1.00	COLRUYT	f	\N
92	Lardons	4	\N	COLRUYT	f	\N
100	Moutarde	1	3.00	COLRUYT	f	\N
126	Raz EL Hanout	0	\N	TURC	f	\N
127	Rhum	0	\N	NOSTRA	f	\N
128	Rosé Maison	0	\N	DENIS	f	\N
130	Sacs sous vide	0	\N	AMAZON	f	\N
147	Sucrettes	0	\N	INTER	f	\N
150	Tiramisu	0	\N	RUDY	f	\N
152	Tomate berlingot	0	\N	COLRUYT	f	\N
1	Ail	1	6.00	CASH ITALIA	f	\N
6	Arrosticinni	0	12.00	INTER	f	\N
8	Bac Alu + Couvercle 2L	0	\N	AVA	f	\N
7	Bac à sceller (DUNIFORM)	0	\N	VDS	f	\N
14	Blondinette	0	40.00	St NI	f	\N
17	Boîte plastique 250Ml	1	1.00	AVA	f	\N
18	Bougies	1	5.00	COLRUYT	f	\N
129	Sacs 3L	0	\N	DELHAIZE	f	\N
131	Salade	3	2.00	INTER	f	\N
132	Salaisons	1	10.00	WANZE	f	\N
133	Sambuca	1	1.00	COLRUYT	f	\N
134	San Pellegrino	12	1.00	COLRUYT	f	\N
135	Saucisses Potée	20	2.00	COLRUYT	f	\N
136	Scampis	3	12.50	WANZE	f	\N
137	SCHWEPPES	18	1.00	COLRUYT	f	\N
138	Sel	10	\N	COLRUYT	f	\N
139	Semoule	2	\N	TURC	f	2026-07-02
140	Serviettes noires	10	3.00	DESPRIETS	f	\N
141	Smash	12	1.00	COLRUYT	f	\N
142	Spare Ribs	0	\N	INTER	f	\N
143	Spirelli congelés	0	\N	DESPRIETS	f	\N
144	Steack	1	1.00	EVRARD	f	\N
145	Sucre	4	\N	COLRUYT	f	\N
146	Sucre vanillé	0	\N	COLRUYT	f	\N
148	Tagliatelles congelées (5Kg)	1	21.04	DESPRIETS	f	2026-07-03
149	Thé mente	0	\N	TURC	f	\N
151	Tiramisu glacé	0	\N	CINDY	f	\N
153	Tomate concassée	0	\N	COLRUYT	f	\N
154	Tomates	2	2.00	COLRUYT	f	\N
155	Tomates cerise	1	3.05	COLRUYT	f	\N
156	Triple	1	40.00	St NI	f	\N
157	Truffe	2	15.00	WANZE	f	\N
158	Val Dieu	12	1.80	COLRUYT	f	\N
159	Viande	1	1.00	INTER	f	\N
161	Vinaigre	6	0.75	COLRUYT	f	\N
162	Vinaigrette	1	1.00	COLRUYT	f	2026-01-22
160	Vin Moelleux	1	1.00	COLRUYT	f	\N
163	Violette	4	5.00	DELHAIZE	f	2026-06-25
\.


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clients (id, nom, telephone_mobile, email, adresse, cp, localite, date_anniversaire, derniere_visite, a_recontacter, remarques, actif, created_at, updated_at, telephone_fixe) FROM stdin;
0	CLIENT	0	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-2129673309	FOERSTER	0033780031329	\N	\N	\N	\N	\N	2024-03-06	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1556661738	Mariepaule Maricq	019566990	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1057878124	GARAGE RENAULT	042521569	\N	\N	\N	\N	\N	2024-01-12	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
35667300	DEWINDT	043780701	\N	\N	\N	\N	\N	\N	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-816121950	BARATTO	0465106675	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1343913728	MARQUET	0465128762	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
630630580	0467837748	0467837748	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-469180033	BIFERI	0468363176	\N	\N	\N	\N	\N	2025-01-17	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-612734926	PITOU	0468372226	\N	\N	\N	\N	\N	2023-10-27	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1632933197	SABINE WERY	0470013425	\N	\N	\N	\N	\N	2023-06-10	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
907055032	LAURENCE	0470603741	\N	\N	\N	\N	\N	2024-01-27	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1018609304	0470651926	0470651926	\N	\N	\N	\N	\N	2023-05-17	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
420446599	MARC PRISON	0470794130	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1705886505	DELGADO	0470854697	\N	\N	\N	\N	\N	2025-01-15	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1461066836	Lam	0470985648	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-560080272	JEREMY	0471332701	\N	\N	\N	\N	\N	2024-05-24	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
351063202	LO PRESTI	0471415086	\N	\N	\N	\N	\N	\N	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1899778452	LEGROS	0471430271	\N	\N	\N	\N	\N	2024-01-05	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1801614408	JMD	0471552223	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
687226325	LOÏC COLINET	0471574508	\N	\N	\N	\N	\N	2023-06-16	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1145829210	0472255935	0472255935	\N	\N	\N	\N	\N	2022-03-04	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1139066072	David Lekeu	0472471499	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
731157830	0472599973	0472599973	\N	\N	\N	\N	\N	2023-11-10	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-2118670673	PIERRE CANVAT	0472810676	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1125036790	BOYENS	0473120569	\N	\N	\N	\N	\N	2023-05-13	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
6908928	Luc Renard	0473250650	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-61916888	HAUZER FRANCOISE	0473302915	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1378554073	STÉPHANIE & FRANÇOIS	0473504542	\N	\N	\N	\N	\N	2023-05-20	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1263462298	0473562539	0473562539	\N	\N	\N	\N	\N	2023-11-10	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
2015681173	Vam Michel	0473734171	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
522262762	PECAND	0473871088	\N	\N	\N	\N	\N	2024-01-19	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-514666842	GOFFIN	0474040733	\N	\N	\N	\N	\N	2024-06-14	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1316411078	0474047387	0474047387	\N	\N	\N	\N	\N	2023-10-25	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1198282750	LION	0474136916	\N	\N	\N	\N	\N	\N	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
2077824867	Mimie	0474367454	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1683800573	MASSIN	0474412452	\N	\N	\N	\N	\N	2025-02-28	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1694291892	0474797043	0474797043	\N	\N	\N	\N	\N	2022-03-25	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1454545753	XAVIER BURGEVIN	0474890771	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1017199408	0475359115	0475359115	\N	\N	\N	\N	\N	2023-10-31	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-102291402	MOOREN	0475383840	\N	\N	\N	\N	\N	\N	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-431586071	Philippe Saive	0475459878	\N	\N	\N	\N	\N	2022-02-04	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1679855426	0475530888	0475530888	\N	\N	\N	\N	\N	2023-05-13	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1639649453	DEHON	0475552480	\N	\N	\N	\N	\N	2024-03-22	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1590358994	MORATI FLORENCE	0475838824	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
190114966	ERIC&IRENE	0475879151	\N	\N	\N	\N	\N	2024-03-01	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1850234108	JCC	0476264966	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
428145220	PHILIPPE & SYLVIE	0476414626	\N	\N	\N	\N	\N	2023-05-12	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1536283876	0476479096	0476479096	\N	\N	\N	\N	\N	2023-11-03	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1044094636	CLOES	0476660879	\N	\N	\N	\N	\N	\N	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
225199455	BRIOL	0476720547	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-708274188	DEFAWEUX-LEBRUN	0476796814	\N	\N	\N	\N	\N	2023-05-13	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1095562128	Michel Delcominette	0477307096	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1671272237	COUNE FANETTE	0477343513	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1571398319	0477618735	0477618735	\N	\N	\N	\N	\N	2023-12-14	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1501231512	0477635381	0477635381	\N	\N	\N	\N	\N	2022-05-05	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
2084900867	MINET	0477878318	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-982451183	BURTON	0477922783	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1105205458	Stephane Pirotte	0478191210	\N	\N	\N	\N	\N	2023-05-05	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1868135159	Gaëlle Piel	0478443449	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1027030872	0478619832	0478619832	\N	\N	\N	\N	\N	2023-11-10	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1979750295	LEMAIRE	0478649121	\N	\N	\N	\N	\N	2023-08-25	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-2027096864	NADINE (CARO)	0478674474	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
2	Laetitia Huyghe	0478810261	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1531179267	JM & MANU	0479350700	\N	\N	\N	\N	\N	2023-06-03	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-34589632	0479499569	0479499569	\N	\N	\N	\N	\N	2022-04-08	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1310531410	0479731375	0479731375	\N	\N	\N	\N	\N	2023-11-14	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-569673578	Olivier Jonet	0479761441	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1319489455	Thierry Jacquemin	0479789208	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1671559650	ALVINE	0479808805	\N	\N	\N	\N	\N	\N	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1022922984	0479842430	0479842430	\N	\N	\N	\N	\N	2024-01-31	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
986627362	MANGON	0479920585	\N	\N	\N	\N	\N	2024-05-10	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
878500392	DELVAUX	0479972687	\N	\N	\N	\N	\N	\N	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-726324367	MONTANARI	0483998239	\N	\N	\N	\N	\N	2024-03-23	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1248698199	SAGOT	0484140880	\N	\N	\N	\N	\N	2024-01-13	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-848122636	0484189200	0484189200	\N	\N	\N	\N	\N	2023-05-26	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-384455030	0485108494	0485108494	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-867980635	GLUTEN-ARNOLD	0485126459	\N	\N	\N	\N	\N	\N	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1769468414	Laurent Massillon	0485500100	\N	\N	\N	\N	\N	2023-05-06	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1114678346	0485500502	0485500502	\N	\N	\N	\N	\N	2023-05-12	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
569943876	Fred Massillon	0485558064	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
155646985	MIGNOLET	0485857445	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
553905504	SCHMITZ	0485881134	\N	\N	\N	\N	\N	2023-05-26	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-479672637	MANU SAVINI	0486051549	\N	\N	\N	\N	\N	2023-10-04	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1551998939	DIDIER	0486070324	\N	\N	\N	\N	\N	2024-01-06	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1129356520	0486137423	0486137423	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-2090111404	LO PRESTI	0486714463	\N	\N	\N	\N	\N	\N	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1936149254	0486744239	0486744239	\N	\N	\N	\N	\N	2024-01-31	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1770452859	SCHEFFER	0488036625	\N	\N	\N	\N	\N	2023-08-31	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1634782901	0488678384	0488678384	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
627317039	Eric Melen	0489837523	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1	Justin Radu	0491070159	\N	\N	\N	\N	\N	\N	t	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1842973540	0491245697	0491245697	\N	\N	\N	\N	\N	2022-05-20	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1631695881	MORAY NATHALIE	0491364078	\N	\N	\N	\N	\N	2023-06-02	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
647511427	GUMEZ	04916290545	\N	\N	\N	\N	\N	2023-12-16	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
116918907	Delcomte	0491745133	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
623706089	0491898999	0491898999	\N	\N	\N	\N	\N	2025-02-28	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1647291379	Mike	0492064122	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
769723709	FRED BC VERLAINE	0492100542	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1375258664	DARDENNE	0492226649	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
631314543	0492315792	0492315792	\N	\N	\N	\N	\N	2024-06-22	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1588185380	CATA LÉO	0492424718	\N	\N	\N	\N	\N	2023-06-23	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1959562082	0492750947	0492750947	\N	\N	\N	\N	\N	2024-03-20	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1595640756	Adam	0492759110	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
713968666	RODRIGUEZ	0493168205	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1635161824	ROISEAUX	0493247299	\N	\N	\N	\N	\N	2025-06-27	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
982986128	0494054399	0494054399	\N	\N	\N	\N	\N	2024-01-18	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1758572172	0494088879	0494088879	\N	\N	\N	\N	\N	2023-11-11	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
101832114	0494176396	0494176396	\N	\N	\N	\N	\N	2023-11-03	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
811323752	FIMIANI	0494425022	\N	\N	\N	\N	\N	2024-08-02	t	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
743392239	NicNac	0494429058	\N	\N	\N	\N	\N	2023-05-05	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-272858789	Bossuroy	0494477891	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1588624978	0494498241	0494498241	\N	\N	\N	\N	\N	2023-06-02	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1423511228	GASON	0494628470	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-832235899	KOSTER	0494768346	\N	\N	\N	\N	\N	2023-09-02	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
72834090	0495115029	0495115029	\N	\N	\N	\N	\N	2022-05-09	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1090130270	WOS	0495251463	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1936806253	PASLEAU	0495297897	\N	\N	\N	\N	\N	2023-06-23	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
804024882	SOFTPLUS	0495313433	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-310771039	LAETI&DAVID	0495456867	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
469917620	0495512527	0495512527	\N	\N	\N	\N	\N	2024-03-05	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1931747542	DENIS GUILLAUME	0495534457	\N	\N	\N	\N	\N	2023-05-18	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1412247744	0495563834	0495563834	\N	\N	\N	\N	\N	2023-05-12	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1647538147	PIRARD (PHILIPPART)	0495661401	\N	\N	\N	\N	\N	2023-06-03	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1655278907	Loic	0495770815	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1609736283	BODEUX	0495775291	\N	\N	\N	\N	\N	2022-02-24	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
57950513	LÉNA	0495809146	\N	\N	\N	\N	\N	2023-05-05	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-9543601	0495924605	0495924605	\N	\N	\N	\N	\N	2024-03-26	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1920330112	0496060553	0496060553	\N	\N	\N	\N	\N	2023-11-15	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
693372496	BOUKILY	0496089867	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
457598225	Marco Claessen	0496108530	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1453381743	BONFOND	0496142530	\N	\N	\N	\N	\N	2023-09-22	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1454048100	Crucifix	0496148625	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1163187653	PIERRE DELHASSE	0496178922	\N	\N	\N	\N	\N	2023-06-10	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1177891950	0496209334	0496209334	\N	\N	\N	\N	\N	2022-04-08	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1900657782	PIROTTE	0496615376	\N	\N	\N	\N	\N	2024-01-12	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
232453727	SARAH & JULIEN	0496627409	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-837811382	cayet	0496695645	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1225565654	GREGORY CLABOTS	0496722427	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1102124144	0496812440	0496812440	\N	\N	\N	\N	\N	2022-05-27	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1588048427	Elise Chanly	0496814042	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
3	Filou	0496814048	\N	\N	\N	\N	\N	2023-05-05	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1681292035	ATTA NATHAN	0496831420	\N	\N	\N	\N	\N	2022-02-11	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-833506467	DELAUNOY	0497176568	\N	\N	\N	\N	\N	2023-11-08	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-186986451	SÉBASTIEN PIROTTE	0497210139	\N	\N	\N	\N	\N	2023-09-23	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1779896331	JM DE NIC	0497285244	\N	\N	\N	\N	\N	2023-05-05	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1513168700	MÉLANIE	0497288907	\N	\N	\N	\N	\N	2023-12-09	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1647550423	Joost	0497289516	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-60272358	Conch & Mous	0497383674	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1034625513	MORGANTE	0497457368	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1170351074	MANCINI MICHEL	0497457659	\N	\N	\N	\N	\N	2025-01-22	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1579283158	0497467246	0497467246	\N	\N	\N	\N	\N	2022-04-29	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1297670515	SANDRA DAHMOUN	0497606689	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1355563075	0497709219	0497709219	\N	\N	\N	\N	\N	2023-06-15	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
746750116	0497749715	0497749715	\N	\N	\N	\N	\N	2024-01-31	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-2020207416	LESCRENIER	0497774779	\N	\N	\N	\N	\N	\N	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-259160509	MATHILDE	0497853927	\N	\N	\N	\N	\N	2023-11-24	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1496710206	LABIOUSE	0497924447	\N	\N	\N	\N	\N	2023-05-05	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1458243463	PARMENTIER	0498054706	\N	\N	\N	\N	\N	2023-10-06	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1184036354	Cristelle et Thierry	0498060391	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-561784630	JOBÉ	0498153241	\N	\N	\N	\N	\N	2023-11-04	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
429590051	Godinas Bernadette	0498294415	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1551772392	EMMA	0498476897	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1997312316	ELOGIA	0498546285	\N	\N	\N	\N	\N	2023-11-25	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
579644482	0498567389	0498567389	\N	\N	\N	\N	\N	2022-04-12	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1547125190	TILMANN	0498599718	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1813802963	Phil Perwez	0498725906	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
456697569	MICHAËL DINEUR	0498816823	\N	\N	\N	\N	\N	2023-06-09	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1616720992	PIRSON	0499151102	\N	\N	\N	\N	\N	\N	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1581012734	Califice	0499153576	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-913310719	Véronique Lespagnard	0499273819	\N	\N	\N	\N	\N	2023-05-06	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1843296575	0499332197	0499332197	\N	\N	\N	\N	\N	2022-02-16	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1611704114	0499401320	0499401320	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
863154534	SAM ALEX	0499741421	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-2091502576	0499879834	0499879834	\N	\N	\N	\N	\N	2023-09-20	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1647606316	Adrien (Léa)	Adrien (Léa)	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-604209419	Angéllique Deponthière	Angéllique Deponthière	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
686373030	Annick	Annick	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1222882766	ARTHUR	ARTHUR	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1996340249	Aude Simon	Aude Simon	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1776719868	AURORE	AURORE	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-781131527	beguin	beguin	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1027211030	BENJAMIN	BENJAMIN	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1404998520	Bidaine	Bidaine	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-342938974	BIFERI	BIFERI	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1339696487	bion	bion	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-2114157071	BLAISE	BLAISE	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1376027346	Brasseur	Brasseur	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-467686845	CALBERG	CALBERG	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
402457021	Camille (Caro)	Camille (Caro)	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
363385425	CARO	CARO	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-261849331	CAROLINE	CAROLINE	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-2091564144	CARWASH	CARWASH	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
2113986679	CASH	CASH	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1686520547	CAUFFMAN	CAUFFMAN	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
967995154	Chantal	Chantal	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-133521499	CHARLOTTE & MALOU	CHARLOTTE & MALOU	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-2018722768	CHEVOLET	CHEVOLET	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1393851931	CHRISTOPHE	CHRISTOPHE	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1776812018	collet	collet	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1190480647	CONSTANT	CONSTANT	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1566221436	CREMASCO	CREMASCO	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-2101073188	DANIEL MAGISTRAT	DANIEL MAGISTRAT	\N	\N	\N	\N	\N	\N	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
2047405728	DEBATTY	DEBATTY	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1878081881	DELHAIZE	DELHAIZE	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
7614925	DESTEXHE	DESTEXHE	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
383682159	docteur	docteur	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1307486133	Dodet	Dodet	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1787824055	Dominique Gelin	Dominique Gelin	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
2098037424	DORSAN	DORSAN	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
548676026	DTB	DTB	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
971280237	Emporté	EMPORTE	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-2060384021	Erika	Erika	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-278690184	EVE	EVE	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
373719688	FANON	FANON	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-960371656	FIEVET	FIEVET	\N	\N	\N	\N	\N	\N	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
804734236	FLAS	FLAS	\N	\N	\N	\N	\N	2023-09-22	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-282106964	FRANCOISE	FRANCOISE	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
798729588	FRANÇOISE	FRANÇOISE	\N	\N	\N	\N	\N	\N	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
68822247	FRANQUET	FRANQUET	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
628858951	GERARD	GERARD	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1369254710	GOUDERS	GOUDERS	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1355405801	Guerrara	Guerrara	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-511474136	Guy Pinkers	Guy Pinkers	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1538497939	Guy Sauvage	Guy Sauvage	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-419139728	halleux	halleux	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-856482689	Hannon	Hannon	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
738464830	HANSEZ	HANSEZ	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-530889051	HOUARD	HOUARD	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1139160753	HUQUE	HUQUE	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1484643075	IFAPME	IFAPME	\N	\N	\N	\N	\N	\N	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-769963217	INTER	INTER	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1763527961	IRENE&ERIC	IRENE&ERIC	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1158611139	ISTACE	ISTACE	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1602796250	JEANCHRISTOPHE	JEANCHRISTOPHE	\N	\N	\N	\N	\N	2025-01-24	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1243637027	JEREMY	JEREMY	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1418201111	LA BARONNE LAURENT	LA BARONNE LAURENT	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1120105367	LAMARCHE	LAMARCHE	\N	\N	\N	\N	\N	2023-09-09	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-47553642	LECLUSE	LECLUSE	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
352944417	LEGROS	LEGROS	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1604822599	LEYENS	LEYENS	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1831621911	LOPEZ	LOPEZ	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
2082502846	MAERTENS	MAERTENS	\N	\N	\N	\N	\N	2023-09-20	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
672071925	MAISON	MAISON	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1950985781	MANDOUX	MANDOUX	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1932514883	MANON	MANON	\N	\N	\N	\N	\N	\N	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1500277506	MARIANNE	MARIANNE	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-12121761	MARIE	MARIE	\N	\N	\N	\N	\N	\N	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
4793386	Marie de Nic	Marie de Nic	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1751496538	MARIE (LOU)	MARIEDELOU	\N	\N	\N	\N	\N	2023-09-21	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1533129552	Martin  Dachet	Martin Dachet	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-234171665	Massin	Massin	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-2003413660	MASSOTTE	MASSOTTE	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1775645180	MAURIZIO	MAURIZIO	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1507213074	MERCINY	MERCINY	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1966843488	Michael	Michael	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1143299298	MICHEL	MICHEL	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-296848433	MILAZZO	MILAZZO	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1776813363	MOY	MOY	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1908980572	MUMU	MUMU	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1734019673	Nathan ATTA	Natha ATTA	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1459600805	Nathalie Tabruyn	Nathalie Tabruyn	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
347476400	NICO (CARO)	NICO	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1409108099	NOSTRA	NOSTRA	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-732188617	OLIVIER	OLIVIER	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-322567125	PAQUE	PAQUE	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
718833254	Patricia	Patricia	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1937982526	Philippe Saive	Philippe Saive	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1530628075	PIERRET	PIERRET	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-762245237	PIPPO	PIPPO	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1564323071	PITOU	PITOU	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-495515213	QUOILIN	QUOILIN	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1474477203	RENAULT	RENAULT	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-294468688	rossion	rossion	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
644045150	RUDY GUILLAUME	RUDY GUILLAUME	\N	\N	\N	\N	\N	\N	f	\N	t	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1911796559	SAGOT	SAGOT	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
402497292	SCHOOTERBEN	SCHOOTERBEN	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1980803577	Schreuder	Schreuder	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
515634717	Scuvie	Scuvie	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-1607156744	SOPHIE	SOPHIE	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-585818291	STEPHANE	STEPHANE	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1886599260	Sylvie & Philippe	Sylvie & Philippe	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-801412725	TAMARA	TAMARA	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1063798313	TANTE STEPH	TANTE STEPH	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-29404940	THIBAUT	THIBAUT	\N	\N	\N	\N	\N	2023-06-17	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-984714471	THONON	THONON	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-981640180	Thoreau	Thoreau	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1846656499	TURC	TURC	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
-2047331794	Veroni	Veroni	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
1124088534	Véronique & Geert	Véronique & Geert	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
290949060	XAVIER-CHAPON	XAVIER-CHAPON	\N	\N	\N	\N	\N	\N	f	\N	f	2026-06-20 01:04:31.636367	2026-06-20 01:04:31.636367	\N
2113986680	Veneria Cars	0476349012					\N	\N	f		t	2026-07-05 22:43:53.961305	2026-07-05 22:43:53.961305	019567268
\.


--
-- Data for Name: commandes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.commandes (id, table_id, article_id, quantite, prix_unitaire, tva, serveur, imprime, emporte, date_commande) FROM stdin;
\.


--
-- Data for Name: encaissement_lignes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.encaissement_lignes (id, encaissement_id, article_id, article_nom, quantite, prix_vente, tva, vente_analysee) FROM stdin;
1	1	\N	PÂTES BOLO	1.00	7.00	6.00	f
2	2	\N	POLPETTE	1.00	8.00	6.00	f
3	3	\N	COUSCOUS PM	1.00	15.00	12.00	f
4	4	\N	COUSCOUS PM	1.00	15.00	12.00	f
5	5	\N	COUSCOUS PM	1.00	13.50	6.00	t
6	6	\N	COUSCOUS PM	1.00	13.50	6.00	t
7	7	\N	PECKET FRAISE	1.00	6.00	21.00	f
8	7	\N	PECKET FRAISE	1.00	6.00	21.00	f
9	7	\N	PECKET FRAISE	1.00	6.00	21.00	f
10	8	\N	THÉ MENTHE	1.00	2.50	21.00	t
11	8	\N	GATEAUX MIEL	2.00	5.00	12.00	t
12	8	\N	VIN ROUGE VERRE	2.00	4.00	21.00	t
13	8	\N	MAISON	1.00	6.00	21.00	t
14	8	\N	SOFT (Verre)	1.00	2.00	21.00	t
15	8	\N	Cuba-Li	1.00	6.00	21.00	t
16	8	\N	COUSCOUS PM	3.00	15.00	12.00	t
17	8	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
18	8	\N	SOFT (Verre)	1.00	2.00	21.00	t
19	9	\N	GATEAUX MIEL	1.00	5.00	12.00	t
20	9	\N	CAFÉ	1.00	2.50	21.00	f
21	9	\N	VIN ROUGE VERRE	2.00	4.00	21.00	f
22	9	\N	MAISON	2.00	6.00	21.00	f
23	9	\N	COUSCOUS PM	2.00	15.00	12.00	t
24	9	\N	TCHAKTCHOUKA	2.00	8.00	12.00	t
25	9	\N	PRIMITIVO	1.00	24.00	21.00	f
26	10	\N	GATEAUX MIEL	1.00	5.00	12.00	t
27	10	\N	GATEAUX MIEL	1.00	5.00	12.00	t
28	10	\N	GATEAUX MIEL	1.00	5.00	12.00	t
29	10	\N	CASELLETTI	1.00	30.00	21.00	t
30	10	\N	CASELLETTI	1.00	30.00	21.00	t
31	10	\N	POLPETTE	2.00	14.00	12.00	t
32	10	\N	COUSCOUS PM	3.00	15.00	12.00	t
33	10	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
34	10	\N	TCHAKTCHOUKA	1.00	8.00	12.00	t
35	10	\N	PECKET FRAISE	1.00	6.00	21.00	t
36	10	\N	Cuba-Li	1.00	6.00	21.00	t
37	10	\N	Cuba-Li	1.00	6.00	21.00	t
38	10	\N	GIN TONIC	1.00	6.00	21.00	t
39	10	\N	GIN TONIC	1.00	6.00	21.00	t
40	11	\N	SOFT (Verre)	1.00	2.00	21.00	f
41	11	\N	THÉ MENTHE	1.00	2.50	21.00	t
42	11	\N	CAFÉ	1.00	2.50	21.00	t
43	11	\N	EAU 1/2 L	1.00	3.50	21.00	f
44	11	\N	COUSCOUS PM	1.00	15.00	12.00	t
45	11	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
46	11	\N	TCHAKTCHOUKA	1.00	8.00	12.00	t
47	11	\N	MAISON	1.00	6.00	21.00	f
48	11	\N	GIN TONIC	1.00	6.00	21.00	t
49	11	\N	SOFT (Verre)	1.00	2.00	21.00	f
50	11	\N	PRIMITIVO	1.00	24.00	21.00	f
51	11	\N	Cuba-Li	1.00	6.00	21.00	f
52	11	\N	GIN TONIC	1.00	6.00	21.00	f
53	11	\N	POLPETTE	1.00	14.00	12.00	t
54	12	\N	THÉ MENTHE	4.00	2.50	21.00	f
55	12	\N	VIN ROUGE VERRE	1.00	4.00	21.00	f
56	12	\N	EAU 1/2 L	1.00	3.50	21.00	f
57	12	\N	COUSCOUS PM	2.00	15.00	12.00	t
58	13	\N	GRAPPA	1.00	5.00	21.00	f
59	13	\N	LIMONCELLO	2.00	5.00	21.00	f
60	13	\N	VIN BLANC VERRE	1.00	4.00	21.00	f
61	13	\N	PRIMITIVO	1.00	24.00	21.00	f
62	14	\N	PÂTES BOLO	2.00	6.00	6.00	t
63	15	\N	PÂTES LARD	1.00	6.00	6.00	t
64	16	\N	COUSCOUS PM	1.00	13.50	6.00	t
65	17	\N	THÉ MENTHE	1.00	2.50	21.00	t
66	17	\N	GATEAUX MIEL	2.00	5.00	12.00	t
67	17	\N	TRIPLE SAINTE NITOUCHE	1.00	4.00	21.00	t
68	17	\N	BLONDINETTE	1.00	3.50	21.00	f
69	17	\N	VIN BLANC VERRE	2.00	4.00	21.00	f
70	17	\N	PRIMITIVO	2.00	24.00	21.00	f
71	17	\N	POLPETTE	3.00	14.00	12.00	t
72	18	\N	POLPETTE	4.00	12.60	12.00	t
73	19	\N	COUSCOUS PM	2.00	13.50	6.00	t
74	20	\N	PÂTES LARD	2.00	6.00	6.00	t
75	21	\N	CREME BRULEE	1.00	5.00	12.00	t
76	21	\N	THÉ MENTHE	2.00	2.50	21.00	t
77	21	\N	ASSIETTE APERITIVE (2 p.)	2.00	19.00	12.00	t
78	21	\N	CHARDONNAY (2020)	1.00	18.00	21.00	t
79	21	\N	SOFT (Verre)	1.00	2.00	21.00	t
80	22	\N	THÉ MENTHE	4.00	2.50	21.00	t
81	22	\N	CHARDONNAY (2020)	1.00	18.00	21.00	t
82	22	\N	COUSCOUS PM	3.00	15.00	12.00	t
83	22	\N	POLPETTE	1.00	14.00	12.00	t
84	22	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
85	22	\N	PECKET FRAISE	1.00	6.00	21.00	f
86	22	\N	MAISON	3.00	6.00	21.00	f
87	23	\N	PRIMITIVO	1.00	24.00	21.00	t
88	23	\N	COUSCOUS PM	2.00	15.00	12.00	t
89	23	\N	TCHAKTCHOUKA	2.00	8.00	12.00	t
90	24	\N	PÂTES BOLO	1.00	6.00	6.00	t
91	24	\N	PÂTES TRUF	1.00	7.00	6.00	t
92	24	\N	PÂTES LARD	1.00	6.00	6.00	t
93	25	\N	PÂTES LARD	1.00	6.00	6.00	t
94	25	\N	PÂTES BOLO	2.00	6.00	6.00	t
95	26	\N	PÂTES TRUF	1.00	7.00	6.00	t
96	27	\N	COUSCOUS PM	1.00	13.50	6.00	t
97	28	\N	SOFT (Verre)	1.00	2.00	21.00	f
98	28	\N	PÂTES BOLO	1.00	6.00	6.00	t
99	29	\N	COUSCOUS PM	1.00	13.50	12.00	t
100	30	\N	THÉ MENTHE	2.00	2.50	21.00	t
101	30	\N	CREME BRULEE	2.00	5.00	21.00	t
102	30	\N	VIN 1/2	1.00	10.00	21.00	t
103	30	\N	PECKET FRAISE	2.00	6.00	21.00	t
104	30	\N	COUSCOUS PM	2.00	15.00	12.00	t
105	31	\N	SOFT (Verre)	5.00	2.00	21.00	f
106	31	\N	EAUX 1 L	1.00	5.00	21.00	t
107	31	\N	THÉ MENTHE	5.00	2.50	21.00	f
108	31	\N	CREME BRULEE	1.00	5.00	12.00	t
109	31	\N	POLPETTE	2.00	14.00	12.00	t
110	31	\N	COUSCOUS PM	3.00	15.00	12.00	t
111	31	\N	TCHAKTCHOUKA	1.00	8.00	12.00	f
112	31	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
113	32	\N	VIN ROUGE VERRE	1.00	4.00	21.00	f
114	32	\N	VIN BLANC VERRE	1.00	4.00	21.00	t
115	32	\N	THÉ MENTHE	1.00	2.50	21.00	t
116	32	\N	CAFÉ	1.00	2.50	21.00	f
117	32	\N	POLPETTE	1.00	14.00	12.00	t
118	32	\N	COUSCOUS PM	1.00	15.00	12.00	t
119	32	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
120	33	\N	RHUM HAVANA	2.00	6.00	21.00	t
121	33	\N	CREME BRULEE	3.00	5.00	21.00	t
122	33	\N	COUSCOUS PM	3.00	15.00	12.00	t
123	33	\N	EAUX 1 L	1.00	5.00	21.00	t
124	33	\N	THÉ MENTHE	1.00	2.50	21.00	t
125	33	\N	CAFÉ	3.00	2.50	21.00	t
126	33	\N	GRAPPA	1.00	5.00	21.00	t
127	33	\N	VIN BLANC VERRE	2.00	4.00	21.00	t
128	33	\N	PRIMITIVO	1.00	24.00	21.00	t
129	33	\N	PROSECCO VERRE	1.00	5.00	21.00	t
130	33	\N	MAISON	2.00	6.00	21.00	t
153	36	\N	DIVERS	-1.00	-169.91	0.00	t
154	36	\N	DIVERS	-1.00	-176.31	0.00	t
155	36	\N	DIVERS	-1.00	-18.02	0.00	t
164	39	\N	DIVERS	-1.00	-50.00	0.00	f
165	39	\N	DIVERS	-1.00	-3.50	0.00	t
166	39	\N	DIVERS	-1.00	-41.58	0.00	t
172	42	\N	DIVERS	-1.00	-50.00	0.00	f
175	45	\N	JUPILER	1.00	2.00	21.00	f
176	45	\N	COUSCOUS PM	1.00	15.00	12.00	f
180	48	\N	DIVERS	-2.00	-50.00	0.00	f
183	51	\N	DIVERS	-1.00	-84.61	0.00	t
191	54	\N	DIVERS	-1.00	-26.32	0.00	t
192	54	\N	DIVERS	-1.00	-9.20	0.00	t
193	54	\N	DIVERS	-1.00	-3.00	0.00	t
194	54	\N	DIVERS	-1.00	-14.74	0.00	t
197	57	\N	GRAPPA	1.00	5.00	21.00	t
198	57	\N	ASSIETTE APERITIVE (2 p.)	1.00	10.00	12.00	t
199	57	\N	THÉ MENTHE	1.00	2.50	21.00	t
200	57	\N	COUSCOUS PM	2.00	15.00	12.00	t
201	57	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	t
202	57	\N	VIN BLANC VERRE	1.00	4.00	21.00	t
203	57	\N	VIN 1/2	1.00	10.00	21.00	t
204	57	\N	Cuba-Li	1.00	6.00	21.00	t
220	60	\N	COUSCOUS PM	1.00	13.50	6.00	t
221	60	\N	SCAMPIS LUCIFER	1.00	6.50	6.00	t
224	63	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
225	63	\N	ESPRESSO	1.00	2.50	21.00	t
226	63	\N	CASELLETTI	1.00	30.00	21.00	f
227	63	\N	CREME BRULEE	1.00	5.00	12.00	t
228	63	\N	COUSCOUS VG	2.00	10.00	12.00	t
238	66	\N	DIVERS	-1.00	-110.00	0.00	f
241	69	\N	DIVERS	-1.00	-32.40	0.00	t
246	72	\N	COUSCOUS VG	1.00	5.00	6.00	t
254	75	\N	DIVERS	-1.00	-23.22	0.00	t
262	78	\N	COUSCOUS PM	3.00	13.50	12.00	f
274	81	\N	SOFT (Verre)	1.00	2.00	21.00	t
275	81	\N	THÉ MENTHE	1.00	2.50	21.00	t
276	81	\N	CAFÉ	2.00	2.50	21.00	t
277	81	\N	CASELLETTI	1.00	30.00	21.00	f
278	81	\N	PECKET FRAISE	2.00	6.00	21.00	f
279	81	\N	MAISON	2.00	6.00	21.00	f
280	81	\N	CREME BRULEE	2.00	5.00	12.00	t
281	81	\N	COUSCOUS PM	4.00	15.00	12.00	t
282	81	\N	SCAMPIS LUCIFER	2.00	8.00	12.00	t
296	84	\N	DIVERS	-1.00	-80.81	0.00	t
302	87	\N	SOFT (Verre)	1.00	2.00	21.00	f
303	87	\N	PÂTES BOLO	1.00	6.00	6.00	f
308	90	\N	DIVERS	-1.00	-45.13	0.00	t
311	93	\N	DIVERS	-1.00	-12.00	0.00	f
322	96	\N	DIVERS	-1.00	-122.00	0.00	f
325	99	\N	SOFT (Verre)	1.00	2.00	21.00	f
326	99	\N	PROSECCO Bouteille	1.00	25.00	21.00	f
327	99	\N	GIN TONIC	2.00	6.00	21.00	f
328	99	\N	PECKET FRAISE	2.00	6.00	21.00	f
329	99	\N	COUSCOUS PM	3.00	15.00	12.00	t
330	99	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	t
331	99	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
348	102	\N	DIVERS	-1.00	-50.00	0.00	f
351	105	\N	GATEAUX MIEL	1.00	0.00	12.00	t
352	105	\N	CREME BRULEE	1.00	5.00	12.00	t
353	105	\N	BURRATINA	2.00	14.00	12.00	t
354	105	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	t
355	105	\N	SOFT (Verre)	2.00	2.00	21.00	t
356	105	\N	PROSECCO VERRE	1.00	0.00	21.00	t
361	108	\N	GATEAUX MIEL	1.00	5.00	12.00	t
362	108	\N	COUSCOUS PM	2.00	15.00	12.00	t
363	108	\N	SOFT (Verre)	2.00	2.00	21.00	t
366	111	\N	CREME BRULEE	2.00	5.00	12.00	t
367	111	\N	CAFÉ	2.00	2.50	21.00	t
372	114	\N	CAFÉ	1.00	2.50	21.00	f
373	114	\N	JUPILER	1.00	2.00	21.00	f
386	117	\N	CAFÉ	4.00	2.50	21.00	t
387	117	\N	PRIMITIVO	1.00	24.00	21.00	t
388	117	\N	TRIPLE SAINTE NITOUCHE	2.00	4.00	21.00	t
389	117	\N	MAISON	6.00	6.00	21.00	t
390	117	\N	PECKET FRAISE	5.00	6.00	21.00	t
391	117	\N	GATEAUX MIEL	1.00	5.00	12.00	t
392	117	\N	CREME BRULEE	4.00	5.00	12.00	t
393	117	\N	COUSCOUS PM	4.00	15.00	12.00	t
394	117	\N	CHAMPIGNONS KABYLES	4.00	6.00	12.00	t
395	117	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
398	120	\N	DIVERS	-1.00	-600.00	0.00	f
399	120	\N	DIVERS	-1.00	-400.00	0.00	f
402	123	\N	COUSCOUS PM	2.00	13.50	6.00	t
405	126	\N	COUSCOUS PM	3.00	13.50	6.00	t
1169	383	\N	THÉ MENTHE	1.00	2.50	21.00	t
1170	383	\N	IRISH COFFEE	1.00	8.00	21.00	t
1171	383	\N	GATEAUX MIEL	1.00	5.00	12.00	t
1172	383	\N	CREME BRULEE	3.00	5.00	12.00	t
1173	383	\N	BURRATINA	2.00	14.00	12.00	t
1174	383	\N	COUSCOUS PM	4.00	15.00	12.00	t
1175	383	\N	ASSIETTE APERITIVE (2 p.)	2.00	19.00	12.00	t
1176	383	\N	MACON AZE (2018)	1.00	25.00	21.00	t
1177	383	\N	SOFT (Verre)	2.00	2.00	21.00	t
1178	383	\N	MAISON	4.00	6.00	21.00	t
1179	383	\N	PROSECCO VERRE	2.00	5.00	21.00	t
1182	386	\N	NOURRITURE	-1.00	-8.48	0.00	t
1190	389	\N	NOURRITURE	-1.00	-132.00	0.00	t
1193	392	\N	PÂTES BOLO	1.00	6.00	6.00	t
1200	395	\N	ROUGE VERRE	1.00	5.00	21.00	t
1201	395	\N	ROSÉ VERRE	1.00	5.00	21.00	t
1202	395	\N	PÂTES LARD	1.00	6.00	6.00	t
1203	395	\N	PÂTES TRUFFE	1.00	7.00	6.00	t
1207	398	\N	PÂTES LARD	1.00	6.00	6.00	t
1211	401	\N	NOURRITURE	-1.00	-13.00	0.00	t
1217	404	\N	EAU 1/2 L	1.00	3.50	21.00	f
1218	404	\N	BLANC VERRE	2.00	5.00	21.00	f
1219	404	\N	MAISON	2.00	6.00	21.00	f
1220	404	\N	IRISH COFFEE	1.00	8.00	21.00	f
1221	404	\N	COUSCOUS PM	1.00	15.00	12.00	f
1230	407	\N	IRISH COFFEE	2.00	8.00	21.00	f
131	34	\N	IRISH COFFEE	1.00	8.00	21.00	f
132	34	\N	GATEAUX MIEL	1.00	5.00	12.00	t
133	34	\N	CREME BRULEE	7.00	5.00	12.00	t
134	34	\N	POLPETTE	3.00	14.00	12.00	t
135	34	\N	COUSCOUS PM	8.00	15.00	12.00	t
136	34	\N	POLPETTE	3.00	8.00	12.00	t
137	34	\N	COUSCOUS PM	5.00	8.00	12.00	t
138	34	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
139	34	\N	TCHAKTCHOUKA	4.00	8.00	12.00	t
140	34	\N	SOFT (Verre)	16.00	2.00	21.00	t
141	34	\N	VIN BLANC VERRE	2.00	4.00	21.00	t
142	34	\N	PRIMITIVO	3.00	24.00	21.00	f
143	34	\N	CHARDONNAY (2020)	1.00	18.00	21.00	f
144	34	\N	JUPILER	17.00	2.00	21.00	t
145	34	\N	TRIPLE SAINTE NITOUCHE	3.00	4.00	21.00	t
146	34	\N	PECKET FRAISE	9.00	6.00	21.00	f
147	34	\N	MAISON	5.00	6.00	21.00	f
148	34	\N	PROSECCO VERRE	11.00	5.00	21.00	f
156	37	\N	DIVERS	-1.00	-17.00	0.00	t
157	37	\N	DIVERS	-1.00	-51.93	0.00	t
158	37	\N	DIVERS	-1.00	-12.27	0.00	t
159	37	\N	DIVERS	-1.00	-12.28	0.00	t
160	37	\N	DIVERS	-1.00	-16.48	0.00	t
161	37	\N	DIVERS	-1.00	-10.83	0.00	t
167	40	\N	DIVERS	-1.00	-50.00	0.00	f
168	40	\N	DIVERS	-1.00	-10.00	0.00	t
169	40	\N	DIVERS	-1.00	-87.46	0.00	t
170	40	\N	DIVERS	-1.00	-6.28	0.00	t
173	43	\N	DIVERS	-1.00	-11.74	0.00	t
177	46	\N	DIVERS	-1.00	-400.00	0.00	t
178	46	\N	DIVERS	-1.00	-600.00	0.00	t
181	49	\N	PÂTES LARD	1.00	6.00	6.00	t
184	52	\N	COUSCOUS PM	2.00	13.50	6.00	t
195	55	\N	COUSCOUS PM	3.00	13.50	12.00	t
205	58	\N	SOFT (Verre)	4.00	2.00	21.00	t
206	58	\N	MAISON	3.00	6.00	21.00	t
207	58	\N	CREME BRULEE	2.00	5.00	12.00	t
208	58	\N	GATEAUX MIEL	2.00	5.00	12.00	t
209	58	\N	COUSCOUS PM	3.00	15.00	12.00	t
210	58	\N	COUSCOUS VG	1.00	10.00	12.00	t
211	58	\N	SCAMPIS LUCIFER	2.00	8.00	12.00	t
212	58	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
222	61	\N	PÂTES TRUF	1.00	6.00	6.00	t
229	64	\N	SOFT (Verre)	1.00	2.00	21.00	t
230	64	\N	JUPILER	4.00	2.00	21.00	t
231	64	\N	COUSCOUS VG	1.00	10.00	12.00	t
239	67	\N	COUSCOUS PM	2.00	13.50	6.00	t
242	70	\N	PÂTES LARD	1.00	6.00	6.00	t
247	73	\N	PÂTES BOLO	2.00	6.00	6.00	t
248	73	\N	PÂTES TRUFFE	1.00	7.00	6.00	t
255	76	\N	DIVERS	-1.00	-50.23	0.00	t
263	79	\N	PROSECCO Bouteille	1.00	25.00	21.00	t
264	79	\N	CAFÉ	1.00	2.50	21.00	t
265	79	\N	GATEAUX MIEL	1.00	5.00	12.00	t
266	79	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
267	79	\N	COUSCOUS VG	1.00	10.00	12.00	t
268	79	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
283	82	\N	CASELLETTI	2.00	30.00	21.00	f
284	82	\N	VIN ROUGE VERRE	1.00	4.00	21.00	t
285	82	\N	CHARDONNAY (2020)	1.00	18.00	21.00	f
286	82	\N	VIN BLANC VERRE	1.00	4.00	21.00	t
287	82	\N	SOFT (Verre)	1.00	2.00	21.00	t
288	82	\N	MAISON	3.00	6.00	21.00	f
289	82	\N	PECKET FRAISE	5.00	6.00	21.00	f
290	82	\N	PÂTES TRUFFE	4.00	17.00	12.00	t
291	82	\N	COUSCOUS PM	4.00	15.00	12.00	t
292	82	\N	PÂTES CREME LARDONS	1.00	14.00	6.00	t
293	82	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
294	82	\N	SCAMPIS LUCIFER	7.00	8.00	12.00	t
297	85	\N	SOFT (Verre)	1.00	2.00	21.00	f
298	85	\N	BLONDINETTE	1.00	3.50	21.00	f
299	85	\N	PÂTES LARD	1.00	6.00	6.00	t
304	88	\N	BLONDINETTE	3.00	3.50	21.00	f
305	88	\N	JUPILER	3.00	2.00	21.00	f
306	88	\N	PÂTES TRUFFE	2.00	7.00	6.00	t
309	91	\N	DIVERS	-1.00	-42.98	0.00	t
312	94	\N	PÂTES BOLO	1.00	6.00	6.00	t
313	94	\N	PÂTES TRUFFE	1.00	7.00	6.00	t
314	94	\N	PÂTES LARD	1.00	6.00	6.00	t
323	97	\N	DIVERS	-1.00	-21.05	0.00	t
332	100	\N	GATEAUX MIEL	1.00	5.00	12.00	t
333	100	\N	CREME BRULEE	3.00	5.00	21.00	t
334	100	\N	VIN ROUGE VERRE	1.00	4.00	21.00	t
335	100	\N	COUSCOUS PM	1.00	8.00	12.00	t
336	100	\N	PÂTES	1.00	8.00	12.00	t
337	100	\N	PÂTES SCAMPIS	2.00	15.00	12.00	t
338	100	\N	ASSIETTE APERITIVE (2 p.)	2.00	19.00	12.00	t
339	100	\N	MAISON	3.00	6.00	21.00	t
340	100	\N	SOFT (Verre)	3.00	2.00	21.00	t
349	103	\N	DIVERS	-1.00	-50.00	0.00	f
357	106	\N	PÂTES BOLO	2.00	6.00	6.00	t
364	109	\N	DIVERS	-1.00	-26.73	0.00	t
368	112	\N	SOFT (Verre)	4.00	2.00	21.00	f
369	112	\N	PÂTES BOLO	2.00	6.00	6.00	t
370	112	\N	PÂTES LARD	2.00	6.00	6.00	t
374	115	\N	SOFT (Verre)	2.00	2.00	21.00	t
375	115	\N	VIN BLANC VERRE	1.00	4.00	21.00	t
376	115	\N	PROSECCO VERRE	1.00	5.00	21.00	t
377	115	\N	MAISON	1.00	6.00	21.00	t
378	115	\N	CREME BRULEE	1.00	5.00	12.00	t
379	115	\N	PÂTES SCAMPIS	1.00	15.00	12.00	t
380	115	\N	COUSCOUS PM	1.00	15.00	12.00	t
381	115	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
396	118	\N	DIVERS	-1.00	-50.00	0.00	f
400	121	\N	COUSCOUS PM	1.00	13.50	12.00	t
403	124	\N	DIVERS	-1.00	-8.52	6.00	t
1180	384	\N	SERVICE	-1.00	-50.00	0.00	t
1183	387	\N	PÂTES LARD	1.00	6.00	6.00	t
1191	390	\N	NOURRITURE	-1.00	-5.47	0.00	t
1194	393	\N	PÂTES BOLO	1.00	6.00	6.00	t
1195	393	\N	PÂTES LARD	1.00	6.00	6.00	t
1204	396	\N	BURRATINA	1.00	14.00	12.00	t
1205	396	\N	MAISON	1.00	6.00	21.00	t
1208	399	\N	PÂTES LARD	1.00	6.00	6.00	t
1209	399	\N	PÂTES BOLO	2.00	6.00	6.00	t
1212	402	\N	NOURRITURE	-1.00	-9.51	0.00	t
1222	405	\N	COUSCOUS VG	1.00	10.00	12.00	f
1223	405	\N	COUSCOUS PM	1.00	15.00	12.00	f
1224	405	\N	ROUGE VERRE	1.00	5.00	21.00	f
1236	408	\N	PRIMITIVO NR 14	3.00	24.00	21.00	t
1237	408	\N	ROSÉ VERRE	1.00	5.00	21.00	t
149	35	\N	DIVERS	-1.00	-39.24	0.00	t
150	35	\N	DIVERS	-1.00	-62.50	0.00	t
151	35	\N	DIVERS	-1.00	-62.10	0.00	t
152	35	\N	DIVERS	-1.00	-180.00	0.00	f
162	38	\N	DIVERS	-1.00	-50.00	0.00	f
163	38	\N	DIVERS	-1.00	-99.00	0.00	t
171	41	\N	DIVERS	-1.00	-50.00	0.00	f
174	44	\N	DIVERS	-1.00	-19.12	0.00	t
179	47	\N	COUSCOUS PM	55.00	12.00	12.00	f
182	50	\N	PÂTES TRUF	1.00	7.00	6.00	t
185	53	\N	CREME BRULEE	2.00	5.00	12.00	f
186	53	\N	CAFÉ	2.00	2.50	21.00	f
187	53	\N	VIN ROUGE VERRE	1.00	4.00	21.00	f
188	53	\N	VIN BLANC VERRE	2.00	4.00	21.00	f
189	53	\N	PÂTES LARD	1.00	14.00	12.00	t
190	53	\N	PÂTES TRUFFE	1.00	17.00	6.00	t
196	56	\N	COUSCOUS PM	2.00	13.50	12.00	t
213	59	\N	CAFÉ	1.00	2.50	21.00	t
214	59	\N	PRIMITIVO	1.00	12.00	21.00	f
215	59	\N	MAISON	3.00	6.00	21.00	f
216	59	\N	PÂTES TRUFFE	1.00	0.00	12.00	f
217	59	\N	COUSCOUS PM	2.00	15.00	12.00	t
218	59	\N	SCAMPIS LUCIFER	1.00	12.00	12.00	t
219	59	\N	ASSIETTE APERITIVE (2 p.)	1.00	17.00	12.00	t
223	62	\N	DIVERS	-1.00	-59.95	0.00	t
232	65	\N	THÉ MENTHE	1.00	2.50	21.00	t
233	65	\N	PECKET FRAISE	1.00	6.00	21.00	t
234	65	\N	MAISON	1.00	6.00	21.00	t
235	65	\N	CREME BRULEE	1.00	5.00	12.00	t
236	65	\N	PÂTES TRUFFE	2.00	17.00	12.00	t
237	65	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
240	68	\N	PÂTES LARD	2.00	6.00	6.00	t
243	71	\N	CREME BRULEE	1.00	5.00	12.00	t
244	71	\N	CAFÉ	1.00	2.50	21.00	t
245	71	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
249	74	\N	CREME BRULEE	1.00	5.00	12.00	t
250	74	\N	VIN 1/2	1.00	10.00	21.00	f
251	74	\N	COUSCOUS PM	2.00	15.00	12.00	t
252	74	\N	MAISON	1.00	6.00	21.00	t
253	74	\N	PECKET FRAISE	1.00	6.00	21.00	f
256	77	\N	GATEAUX MIEL	1.00	5.00	12.00	t
257	77	\N	COUSCOUS PM	3.00	15.00	12.00	t
258	77	\N	THÉ MENTHE	1.00	2.50	21.00	t
259	77	\N	CASELLETTI	1.00	30.00	21.00	t
260	77	\N	BLONDINETTE	1.00	3.50	21.00	t
261	77	\N	MAISON	2.00	6.00	21.00	t
269	80	\N	EAUX 1 L	1.00	5.00	21.00	f
270	80	\N	GATEAUX MIEL	2.00	5.00	12.00	f
271	80	\N	PÂTES TRUFFE	1.00	17.00	12.00	f
272	80	\N	COUSCOUS PM	1.00	15.00	12.00	f
273	80	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	f
295	83	\N	COUSCOUS PM	2.00	13.50	6.00	t
300	86	\N	SOFT (Verre)	1.00	2.00	21.00	t
301	86	\N	PÂTES LARD	1.00	6.00	6.00	t
307	89	\N	PÂTES LARD	1.00	6.00	6.00	t
310	92	\N	DIVERS	-1.00	-10.72	0.00	t
315	95	\N	CAFÉ	3.00	2.50	21.00	t
316	95	\N	PINOT GRIGIO (2020)	1.00	16.00	21.00	t
317	95	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
318	95	\N	COUSCOUS PM	1.00	15.00	12.00	t
319	95	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
320	95	\N	SOFT (Verre)	1.00	2.00	21.00	t
321	95	\N	PECKET FRAISE	2.00	6.00	21.00	t
324	98	\N	COUSCOUS PM	2.00	13.50	12.00	t
341	101	\N	VIN ROUGE VERRE	1.00	4.00	21.00	t
342	101	\N	PECKET FRAISE	2.00	6.00	21.00	t
343	101	\N	CREME BRULEE	1.00	5.00	12.00	t
344	101	\N	GATEAUX MIEL	1.00	5.00	12.00	t
345	101	\N	COUSCOUS PM	1.00	15.00	12.00	t
346	101	\N	COUSCOUS VG	1.00	10.00	12.00	t
347	101	\N	CHAMPIGNONS KABYLES	2.00	6.00	12.00	t
350	104	\N	DIVERS	-1.00	-50.00	0.00	f
358	107	\N	SOFT (Verre)	2.00	2.00	21.00	t
359	107	\N	PÂTES BOLO	1.00	6.00	6.00	t
360	107	\N	PÂTES LARD	1.00	6.00	6.00	t
365	110	\N	PÂTES LARD	1.00	6.00	6.00	t
371	113	\N	DIVERS	-1.00	-70.00	0.00	f
382	116	\N	CHAMPIGNONS KABYLES	2.00	6.00	12.00	t
383	116	\N	COUSCOUS PM	1.00	15.00	12.00	t
384	116	\N	COUSCOUS VG	1.00	10.00	12.00	t
385	116	\N	MACON AZE (2018)	1.00	25.00	21.00	f
397	119	\N	DIVERS	-1.00	-20.00	0.00	f
401	122	\N	COUSCOUS PM	2.00	13.50	6.00	f
404	125	\N	DIVERS	-1.00	-8.00	0.00	t
406	127	\N	VIN BLANC VERRE	2.00	4.00	21.00	t
407	127	\N	MAISON	1.00	6.00	21.00	t
408	127	\N	CREME BRULEE	1.00	5.00	12.00	t
409	127	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
410	128	\N	THÉ MENTHE	2.00	2.50	21.00	f
411	128	\N	MAISON	2.00	6.00	21.00	f
412	128	\N	COUSCOUS PM	2.00	15.00	12.00	f
413	128	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
414	129	\N	VIN ROUGE VERRE	1.00	2.00	21.00	f
415	129	\N	PROSECCO VERRE	1.00	5.00	21.00	f
416	129	\N	MAISON	4.00	6.00	21.00	f
417	129	\N	CREME BRULEE	1.00	5.00	12.00	f
418	129	\N	GATEAUX MIEL	1.00	5.00	12.00	f
419	129	\N	PÂTES SCAMPIS	2.00	15.00	12.00	t
420	129	\N	BURRATINA	1.00	5.00	12.00	t
421	129	\N	COUSCOUS PM	1.00	15.00	12.00	t
422	129	\N	ASSIETTE APERITIVE (2 p.)	2.00	19.00	12.00	t
423	129	\N	CASELLETTI	2.00	30.00	21.00	t
424	129	\N	AMARETTO	1.00	5.00	21.00	f
425	129	\N	THÉ MENTHE	1.00	2.00	21.00	t
426	129	\N	SOFT (Verre)	2.00	2.00	21.00	f
427	130	\N	PÂTES SCAMPIS	1.00	13.50	6.00	t
428	131	\N	DIVERS	-1.00	-50.00	0.00	f
429	132	\N	DIVERS	-1.00	-4.89	0.00	t
430	133	\N	DIVERS	-1.00	-57.70	0.00	f
431	134	\N	DIVERS	-1.00	-27.43	0.00	t
432	135	\N	COUSCOUS PM	2.00	13.50	6.00	t
433	136	\N	VIN BLANC VERRE	2.00	4.00	21.00	t
434	136	\N	SOFT (Verre)	1.00	2.00	21.00	t
435	136	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
436	136	\N	COUSCOUS PM	1.00	15.00	12.00	t
437	136	\N	PROSECCO VERRE	3.00	5.00	21.00	t
438	136	\N	MAISON	3.00	6.00	21.00	t
439	137	\N	DIVERS	-1.00	-38.08	0.00	t
440	137	\N	DIVERS	-1.00	-17.15	0.00	t
441	137	\N	DIVERS	-1.00	-18.70	0.00	t
442	137	\N	DIVERS	-1.00	-3.98	0.00	t
443	138	\N	JUPILER	5.00	2.00	21.00	t
444	138	\N	SOFT (Verre)	2.00	2.00	21.00	t
445	138	\N	BLONDINETTE	2.00	3.50	21.00	t
456	141	\N	BURRATINA	1.00	14.00	12.00	t
457	141	\N	POLPETTE	1.00	14.00	12.00	t
458	141	\N	EAU 1/2 L	1.00	3.50	21.00	t
459	141	\N	JUPILER	1.00	2.00	21.00	t
463	144	\N	DIVERS	-1.00	-27.08	0.00	t
466	147	\N	PÂTES LARD	1.00	6.00	6.00	f
469	150	\N	DIVERS	-1.00	-20.26	0.00	t
485	153	\N	PECKET FRAISE	1.00	6.00	21.00	f
486	153	\N	MAISON	1.00	6.00	21.00	f
487	153	\N	COUSCOUS VG	1.00	9.00	6.00	t
488	153	\N	EAU 1/2 L	1.00	3.50	21.00	t
489	153	\N	PÂTES TRUFFE	2.00	17.00	12.00	t
490	153	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
493	156	\N	CAFÉ	3.00	2.50	21.00	f
494	156	\N	IRISH COFFEE	1.00	8.00	12.00	f
495	156	\N	CREME BRULEE	3.00	5.00	12.00	f
496	156	\N	BURRATINA	1.00	14.00	12.00	t
497	156	\N	PÂTES LARD	3.00	12.00	12.00	t
498	156	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
499	156	\N	PINOT GRIGIO (2020)	1.00	18.00	21.00	f
500	156	\N	PROSECCO Bouteille	1.00	25.00	21.00	f
507	159	\N	PINOT GRIGIO (2020)	1.00	18.00	21.00	f
508	159	\N	MAISON	1.00	6.00	21.00	f
509	159	\N	CREME BRULEE	1.00	5.00	12.00	f
510	159	\N	COUSCOUS PM	2.00	15.00	12.00	f
511	159	\N	BURRATINA	1.00	14.00	12.00	f
512	159	\N	TCHAKTCHOUKA	1.00	8.00	12.00	f
520	162	\N	CAFÉ	1.00	2.50	21.00	t
521	162	\N	CREME BRULEE	1.00	5.00	12.00	t
522	162	\N	COUSCOUS PM	1.00	15.00	12.00	t
523	162	\N	PINOT GRIGIO (2020)	1.00	12.00	21.00	t
524	162	\N	GIN TONIC	1.00	6.00	21.00	t
533	165	\N	PINOT GRIGIO (2020)	1.00	18.00	21.00	f
534	165	\N	MAISON	1.00	6.00	21.00	f
535	165	\N	CREME BRULEE	1.00	5.00	12.00	t
536	165	\N	COUSCOUS PM	2.00	15.00	12.00	t
537	165	\N	BURRATINA	1.00	14.00	12.00	t
538	165	\N	TCHAKTCHOUKA	1.00	8.00	12.00	t
543	168	\N	VIN ROUGE VERRE	2.00	4.00	21.00	t
544	168	\N	COUSCOUS PM	1.00	15.00	12.00	t
545	168	\N	BURRATINA	1.00	14.00	12.00	t
546	168	\N	VIN BLANC VERRE	3.00	4.00	21.00	t
547	168	\N	SOFT (Verre)	1.00	2.00	21.00	t
548	168	\N	JUPILER	3.00	2.00	21.00	t
558	171	\N	COUSCOUS PM	3.00	13.50	6.00	t
562	174	\N	EAU VERRE	1.00	2.00	21.00	t
563	174	\N	POLPETTE	1.00	14.00	12.00	t
568	177	\N	DIVERS	-1.00	-86.00	0.00	t
572	180	\N	DIVERS	-1.00	-38.31	0.00	t
575	183	\N	SOFT (Verre)	1.00	2.00	21.00	t
576	183	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
579	186	\N	VIN BLANC VERRE	1.00	4.00	21.00	t
580	186	\N	JUPILER	1.00	2.00	21.00	t
583	189	\N	VIN ROUGE VERRE	1.00	4.00	21.00	t
584	189	\N	SOFT (Verre)	2.00	2.00	21.00	t
585	189	\N	RHUM HAVANA	2.00	6.00	21.00	t
586	189	\N	PÂTES TRUFFE	2.00	17.00	12.00	t
587	189	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
598	192	\N	DIVERS	-1.00	-6.44	0.00	t
602	195	\N	DIVERS	-1.00	-50.00	0.00	f
605	198	\N	PÂTES LARD	2.00	6.00	6.00	t
612	201	\N	DIVERS	-1.00	-53.20	0.00	t
622	204	\N	DIVERS	-1.00	-29.61	0.00	t
625	207	\N	DIVERS	-1.00	-35.65	0.00	t
631	210	\N	PÂTES LARD	1.00	6.00	6.00	t
636	213	\N	DIVERS	-1.00	-4.60	0.00	t
639	216	\N	COUSCOUS PM	2.00	13.00	6.00	t
642	219	\N	DIVERS	-1.00	-36.05	0.00	t
660	222	\N	PRIMITIVO	1.00	24.00	21.00	f
661	222	\N	PECKET FRAISE	2.00	6.00	21.00	f
662	222	\N	PÂTES SCAMPIS	2.00	16.00	12.00	t
663	222	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
667	225	\N	DIVERS	-1.00	-60.00	0.00	t
670	228	\N	MAISON	3.00	6.00	21.00	t
671	228	\N	AMARETTO	1.00	5.00	21.00	t
672	228	\N	VIN 1/2	1.00	7.00	21.00	f
673	228	\N	VIN 1/2	3.00	14.00	21.00	f
674	228	\N	ESPRESSO	1.00	2.50	21.00	t
675	228	\N	THÉ MENTHE	3.00	2.50	21.00	t
676	228	\N	SPAG.COURG.SCAMP.	1.00	16.00	12.00	f
677	228	\N	COUSCOUS PM	3.00	15.00	12.00	t
678	228	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
688	231	\N	PÂTES LARD	1.00	6.00	6.00	t
691	234	\N	DIVERS	-1.00	-10.50	0.00	t
694	237	\N	DIVERS	-1.00	-50.00	0.00	t
697	240	\N	DIVERS	-1.00	-60.00	0.00	t
704	243	\N	CREME BRULEE	1.00	5.00	12.00	t
705	243	\N	COUSCOUS PM	1.00	15.00	12.00	t
706	243	\N	VIN BLANC VERRE	1.00	4.00	21.00	t
707	243	\N	MAISON	2.00	6.00	21.00	f
719	246	\N	VIN BLANC VERRE	1.00	4.00	21.00	t
733	249	\N	PINOT GRIGIO (2020)	1.00	9.00	21.00	t
734	249	\N	POLPETTE	1.00	14.00	12.00	t
735	249	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	t
736	249	\N	TCHAKTCHOUKA	1.00	8.00	12.00	t
737	249	\N	SOFT (Verre)	1.00	2.00	21.00	t
738	249	\N	PINOT GRIGIO (2020)	1.00	16.00	21.00	t
739	249	\N	PECKET FRAISE	1.00	6.00	21.00	t
740	249	\N	MAISON	1.00	6.00	21.00	t
741	249	\N	COUSCOUS PM	1.00	15.00	12.00	t
744	252	\N	DIVERS	-1.00	-19.29	0.00	t
1181	385	\N	SERVICE	-1.00	-80.00	0.00	t
1184	388	\N	SOFT (Verre)	1.00	2.00	21.00	t
1185	388	\N	VIN BLANC VERRE	2.00	5.00	21.00	t
1186	388	\N	VIN 1/2	1.00	13.00	21.00	t
1187	388	\N	PÂTES BOLO	2.00	12.00	12.00	t
1188	388	\N	PROSECCO VERRE	2.00	5.00	21.00	t
1189	388	\N	MAISON	2.00	6.00	21.00	t
1192	391	\N	NOURRITURE	-1.00	-37.96	0.00	t
1196	394	\N	CAFÉ	1.00	0.00	21.00	f
1197	394	\N	THÉ MENTHE	1.00	2.50	21.00	f
1198	394	\N	CHIARETTO	1.00	6.50	21.00	f
1199	394	\N	COUSCOUS PM	1.00	15.00	12.00	f
1206	397	\N	COUSCOUS PM	2.00	13.50	6.00	f
1210	400	\N	SOFT (Verre)	1.00	2.00	21.00	f
1213	403	\N	SOFT (Verre)	1.00	2.00	21.00	t
1214	403	\N	JUPILER	1.00	2.50	21.00	t
1215	403	\N	TCHAKTCHOUKA	1.00	8.00	12.00	t
1216	403	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
446	139	\N	COUSCOUS PM	8.00	15.00	12.00	f
447	139	\N	PÂTES SCAMPIS	1.00	15.00	12.00	f
448	139	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	f
449	139	\N	ASSIETTE APERITIVE (2 p.)	4.00	19.00	12.00	f
450	139	\N	THÉ MENTHE	9.00	2.50	21.00	f
451	139	\N	PRIMITIVO	2.00	24.00	21.00	f
452	139	\N	TRIPLE SAINTE NITOUCHE	1.00	4.00	21.00	f
453	139	\N	SOFT (Verre)	1.00	2.00	21.00	f
454	139	\N	JUPILER	5.00	2.00	21.00	f
460	142	\N	DIVERS	-1.00	-19.50	0.00	t
461	142	\N	DIVERS	-1.00	-29.31	0.00	t
464	145	\N	DIVERS	-1.00	-33.37	0.00	t
467	148	\N	DIVERS	-1.00	-99.05	0.00	t
470	151	\N	THÉ MENTHE	4.00	2.50	21.00	t
471	151	\N	BURRATINA	4.00	14.00	12.00	t
472	151	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
473	151	\N	SOFT (Verre)	1.00	2.00	21.00	t
474	151	\N	MAISON	4.00	6.00	21.00	t
491	154	\N	PÂTES TRUFFE	1.00	7.00	6.00	t
501	157	\N	DIVERS	-1.00	-10.39	0.00	t
513	160	\N	COUSCOUS PM	5.00	13.50	6.00	f
525	163	\N	CREME BRULEE	2.00	5.00	12.00	t
526	163	\N	MAISON	1.00	6.00	21.00	t
527	163	\N	COUSCOUS PM	1.00	15.00	12.00	t
528	163	\N	BURRATINA	1.00	14.00	12.00	t
529	163	\N	PRIMITIVO	1.00	24.00	21.00	t
530	163	\N	VIN BLANC VERRE	1.00	4.00	21.00	t
531	163	\N	PROSECCO VERRE	1.00	5.00	21.00	t
539	166	\N	COUSCOUS PM	5.00	13.50	6.00	f
549	169	\N	SOFT (Verre)	1.00	2.00	21.00	t
550	169	\N	JUPILER	4.00	2.00	21.00	t
551	169	\N	PECKET FRAISE	1.00	6.00	21.00	t
552	169	\N	PROSECCO VERRE	1.00	5.00	21.00	t
559	172	\N	PÂTES BOLO	1.00	6.00	6.00	t
564	175	\N	EAU VERRE	1.00	2.00	21.00	t
565	175	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
566	175	\N	COUSCOUS PM	2.00	15.00	12.00	t
569	178	\N	PÂTES 4 FR.	1.00	6.00	6.00	t
570	178	\N	COUSCOUS PM	1.00	13.50	6.00	t
573	181	\N	DIVERS	-1.00	-9.91	0.00	t
577	184	\N	DIVERS	-1.00	-6.15	0.00	t
581	187	\N	COUSCOUS PM	2.00	13.50	6.00	t
588	190	\N	IRISH COFFEE	4.00	8.00	21.00	t
589	190	\N	BURRATINA	1.00	14.00	12.00	t
590	190	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
591	190	\N	COUSCOUS PM	2.00	15.00	12.00	t
592	190	\N	TCHAKTCHOUKA	1.00	8.00	12.00	t
593	190	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
594	190	\N	BLONDINETTE	12.00	3.50	21.00	f
595	190	\N	TRIPLE SAINTE NITOUCHE	1.00	4.00	21.00	f
596	190	\N	VIN BLANC VERRE	3.00	4.00	21.00	t
599	193	\N	SOFT (Verre)	2.00	2.00	21.00	t
600	193	\N	PÂTES TRUFFE	2.00	7.00	6.00	t
603	196	\N	DIVERS	-1.00	-50.00	0.00	f
606	199	\N	PÂTES BOLO	1.00	6.00	6.00	t
613	202	\N	THÉ MENTHE	2.00	2.50	21.00	t
614	202	\N	CREME BRULEE	1.00	5.00	12.00	t
615	202	\N	BURRATINA	1.00	14.00	12.00	t
616	202	\N	POLPETTE	1.00	14.00	12.00	t
617	202	\N	BLONDINETTE	1.00	3.50	21.00	t
623	205	\N	PÂTES 4 FR.	1.00	6.00	6.00	t
626	208	\N	PRIMITIVO	2.00	24.00	21.00	f
627	208	\N	COUSCOUS PM	3.00	15.00	12.00	t
628	208	\N	POLPETTE	1.00	14.00	12.00	t
629	208	\N	JUPILER	16.00	2.00	21.00	f
632	211	\N	SOFT (Verre)	1.00	2.00	21.00	t
637	214	\N	DIVERS	-1.00	-44.05	0.00	t
640	217	\N	DIVERS	-1.00	-36.07	0.00	t
643	220	\N	SOFT (Verre)	1.00	2.00	21.00	t
644	220	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
645	220	\N	COUSCOUS PM	1.00	15.00	12.00	t
646	220	\N	POLPETTE	1.00	14.00	12.00	t
647	220	\N	POLPETTE	2.00	8.00	12.00	t
648	220	\N	BURRATINA	1.00	14.00	12.00	t
649	220	\N	PRIMITIVO	1.00	20.00	21.00	t
650	220	\N	JUPILER	1.00	2.00	21.00	t
651	220	\N	PROSECCO VERRE	2.00	5.00	21.00	t
652	220	\N	MAISON	1.00	6.00	21.00	t
664	223	\N	PÂTES TRUFFE	1.00	10.00	6.00	f
665	223	\N	COUSCOUS VG	1.00	10.00	12.00	f
668	226	\N	PÂTES BOLO	1.00	6.00	6.00	t
679	229	\N	VIN 1/2	1.00	14.00	21.00	t
680	229	\N	COUSCOUS VG	1.00	10.00	12.00	t
681	229	\N	COUSCOUS PM	1.00	15.00	12.00	t
682	229	\N	PECKET FRAISE	1.00	6.00	21.00	t
683	229	\N	MAISON	1.00	6.00	21.00	t
684	229	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	t
685	229	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	t
689	232	\N	COUSCOUS PM	1.00	13.50	6.00	t
692	235	\N	DIVERS	-1.00	-600.00	0.00	t
695	238	\N	DIVERS	-1.00	-60.00	0.00	t
698	241	\N	PÂTES LARD	2.00	6.00	6.00	t
708	244	\N	THÉ MENTHE	2.00	2.50	21.00	t
709	244	\N	CAFÉ	2.00	2.50	21.00	t
710	244	\N	PECKET FRAISE	2.00	6.00	21.00	t
711	244	\N	CREME BRULEE	2.00	5.00	12.00	t
712	244	\N	COUSCOUS PM	2.00	15.00	12.00	t
713	244	\N	TCHAKTCHOUKA	2.00	8.00	12.00	t
720	247	\N	SPAG.COURG.SCAMP.	1.00	16.00	12.00	t
721	247	\N	COUSCOUS PM	1.00	15.00	12.00	t
722	247	\N	PÂTES	1.00	8.00	12.00	t
723	247	\N	VIN BLANC VERRE	1.00	4.00	21.00	t
724	247	\N	TRIPLE SAINTE NITOUCHE	4.00	4.00	21.00	t
742	250	\N	DIVERS	-1.00	-2.00	0.00	t
1225	406	\N	PÂTES BOLO	1.00	10.80	6.00	t
1226	406	\N	PÂTES LARD	1.00	10.80	6.00	t
1227	406	\N	POLPETTE	1.00	12.60	6.00	t
1228	406	\N	PÂTES TRUFFE	1.00	15.30	6.00	t
1229	406	\N	COUSCOUS PM	2.00	13.50	6.00	t
1244	409	\N	VIN 1/2	1.00	14.00	21.00	f
1245	409	\N	COUSCOUS PM	2.00	15.00	12.00	f
1250	412	\N	COUSCOUS PM	2.00	13.50	6.00	f
1251	412	\N	PÂTES LARD	1.00	12.00	12.00	f
1267	415	\N	SERVICE	-1.00	-50.00	0.00	t
1274	418	\N	NOURRITURE	-1.00	-11.06	0.00	t
1288	421	\N	CAFÉ	1.00	2.50	21.00	f
1289	421	\N	AMARETTO	1.00	5.00	21.00	f
1290	421	\N	GRAPPA	1.00	5.00	21.00	f
1294	424	\N	COLRUYT	-1.00	60.76	0.00	t
1301	427	\N	SPAG.COURG.SCAMP.	1.00	16.00	12.00	t
1302	427	\N	TORTELLONE RICOTTA	1.00	15.00	12.00	t
455	140	\N	PÂTES BOLO	1.00	6.00	6.00	t
462	143	\N	PÂTES BOLO	1.00	6.00	6.00	t
465	146	\N	DIVERS	-1.00	-46.73	0.00	f
468	149	\N	DIVERS	-1.00	-13.60	0.00	t
475	152	\N	THÉ MENTHE	2.00	2.50	21.00	t
476	152	\N	CREME BRULEE	1.00	5.00	12.00	t
477	152	\N	PROSECCO Bouteille	1.00	25.00	21.00	t
478	152	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
479	152	\N	TCHAKTCHOUKA	1.00	8.00	12.00	t
480	152	\N	COUSCOUS PM	3.00	15.00	12.00	t
481	152	\N	BURRATINA	1.00	14.00	12.00	t
482	152	\N	PRIMITIVO	1.00	24.00	21.00	t
483	152	\N	NEGROAMARO (2019)	1.00	18.00	21.00	t
484	152	\N	VIN BLANC VERRE	1.00	4.00	21.00	t
492	155	\N	DIVERS	-1.00	-30.86	0.00	t
502	158	\N	JUPILER	2.00	2.00	21.00	t
503	158	\N	BLONDINETTE	1.00	3.50	21.00	t
504	158	\N	TRIPLE SAINTE NITOUCHE	1.00	4.00	21.00	t
505	158	\N	VIN BLANC VERRE	1.00	4.00	21.00	t
506	158	\N	VIN ROUGE VERRE	1.00	4.00	21.00	t
514	161	\N	VIN ROUGE VERRE	2.00	4.00	21.00	t
515	161	\N	COUSCOUS PM	1.00	15.00	12.00	t
516	161	\N	VIN BLANC VERRE	3.00	4.00	21.00	t
517	161	\N	SOFT (Verre)	1.00	2.00	21.00	t
518	161	\N	JUPILER	3.00	2.00	21.00	t
519	161	\N	BURRATINA	1.00	14.00	12.00	t
532	164	\N	DIVERS	-1.00	-35.29	0.00	t
540	167	\N	POLPETTE	2.00	12.60	6.00	f
541	167	\N	COUSCOUS VG	3.00	9.00	6.00	f
542	167	\N	COUSCOUS PM	3.00	13.50	6.00	f
553	170	\N	POLPETTE	1.00	14.00	12.00	t
554	170	\N	COUSCOUS PM	1.00	15.00	12.00	f
555	170	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
556	170	\N	PECKET FRAISE	1.00	6.00	21.00	t
557	170	\N	MAISON	1.00	6.00	21.00	f
560	173	\N	JUPILER	1.00	2.00	21.00	t
561	173	\N	PÂTES BOLO	1.00	6.00	6.00	t
567	176	\N	PÂTES BOLO	2.00	6.00	6.00	t
571	179	\N	DIVERS	-1.00	-23.91	0.00	t
574	182	\N	DIVERS	-1.00	-7.10	0.00	t
578	185	\N	DIVERS	-1.00	-21.83	0.00	t
582	188	\N	PÂTES LARD	1.00	6.00	6.00	t
597	191	\N	DIVERS	-1.00	-86.00	0.00	t
601	194	\N	DIVERS	-1.00	-60.00	0.00	f
604	197	\N	PÂTES TRUFFE	1.00	7.00	6.00	t
607	200	\N	SOFT (Verre)	1.00	2.00	21.00	t
608	200	\N	CREME BRULEE	1.00	5.00	12.00	t
609	200	\N	CAFÉ	2.00	2.50	21.00	t
610	200	\N	COUSCOUS PM	1.00	15.00	12.00	t
611	200	\N	BURRATINA	1.00	13.00	12.00	t
618	203	\N	CREME BRULEE	1.00	5.00	12.00	t
619	203	\N	COUSCOUS PM	1.00	15.00	12.00	t
620	203	\N	COUSCOUS VG	1.00	10.00	12.00	t
621	203	\N	PROSECCO VERRE	1.00	5.00	21.00	t
624	206	\N	PÂTES BOLO	3.00	6.00	6.00	t
630	209	\N	COUSCOUS PM	1.00	13.50	6.00	t
633	212	\N	VIN BLANC VERRE	1.00	4.00	21.00	t
634	212	\N	COUSCOUS PM	1.00	15.00	12.00	t
635	212	\N	MAISON	2.00	6.00	21.00	t
638	215	\N	DIVERS	-1.00	-13.89	0.00	t
641	218	\N	DIVERS	-1.00	-18.03	0.00	t
653	221	\N	PÂTES SCAMPIS	1.00	16.00	12.00	f
654	221	\N	VIN ROUGE VERRE	2.00	4.00	21.00	f
655	221	\N	VIN BLANC VERRE	2.00	4.00	21.00	f
656	221	\N	SOFT (Verre)	3.00	2.00	21.00	f
657	221	\N	CREME BRULEE	2.00	5.00	12.00	f
658	221	\N	COUSCOUS VG	1.00	10.00	12.00	f
659	221	\N	COUSCOUS PM	1.00	15.00	12.00	f
666	224	\N	DIVERS	-1.00	-50.00	0.00	t
669	227	\N	SOFT (Verre)	2.00	2.00	21.00	t
686	230	\N	PÂTES BOLO	2.00	6.00	6.00	t
687	230	\N	COUSCOUS VG	1.00	9.00	6.00	t
690	233	\N	DIVERS	-1.00	-6.29	0.00	t
693	236	\N	DIVERS	-1.00	-50.00	0.00	t
696	239	\N	DIVERS	-1.00	-50.00	0.00	t
699	242	\N	SOFT (Verre)	1.00	2.00	21.00	t
700	242	\N	CREME BRULEE	1.00	5.00	12.00	t
701	242	\N	COUSCOUS PM	1.00	15.00	12.00	t
702	242	\N	PÂTES SCAMPIS	1.00	15.00	12.00	f
703	242	\N	TCHAKTCHOUKA	1.00	8.00	12.00	t
714	245	\N	PRIMITIVO	1.00	24.00	21.00	t
715	245	\N	THÉ MENTHE	1.00	2.50	21.00	t
716	245	\N	CREME BRULEE	2.00	5.00	12.00	t
717	245	\N	COUSCOUS PM	1.00	15.00	12.00	t
718	245	\N	VIN BLANC VERRE	2.00	4.00	21.00	t
725	248	\N	VIN BLANC VERRE	2.00	4.00	21.00	t
726	248	\N	PECKET FRAISE	1.00	6.00	21.00	t
727	248	\N	Cuba-Li	1.00	6.00	21.00	t
728	248	\N	SCAMPIS LUCIFER	1.00	14.00	12.00	t
729	248	\N	COUSCOUS PM	1.00	15.00	12.00	t
730	248	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
731	248	\N	TCHAKTCHOUKA	1.00	8.00	12.00	t
732	248	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	t
743	251	\N	DIVERS	-1.00	-11.74	0.00	t
745	253	\N	GLACE	1.00	5.00	12.00	t
746	253	\N	PÂTES BOLO	1.00	12.00	12.00	t
747	253	\N	PÂTES	1.00	8.00	12.00	t
748	253	\N	SOFT (Verre)	1.00	2.00	21.00	t
749	254	\N	SOFT (Verre)	2.00	2.00	21.00	t
750	254	\N	PECKET FRAISE	1.00	6.00	21.00	f
751	254	\N	TRIPLE SAINTE NITOUCHE	3.00	4.00	21.00	t
752	254	\N	VIN ROUGE VERRE	3.00	4.00	21.00	t
753	254	\N	PÂTES LARD	2.00	12.00	12.00	t
754	254	\N	BURRATINA	1.00	14.00	12.00	t
755	254	\N	PÂTES SCAMPIS	1.00	15.00	12.00	f
756	254	\N	POLPETTE	2.00	14.00	12.00	f
757	254	\N	CHAMPIGNONS KABYLES	3.00	6.00	12.00	t
758	254	\N	SCAMPIS LUCIFER	3.00	8.00	12.00	f
759	255	\N	SOFT (Verre)	3.00	2.00	21.00	t
760	255	\N	PROSECCO VERRE	2.00	5.00	21.00	t
761	255	\N	PECKET FRAISE	1.00	6.00	21.00	t
762	255	\N	CREME BRULEE	1.00	5.00	12.00	t
763	255	\N	GATEAUX MIEL	1.00	5.00	12.00	t
764	255	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
765	255	\N	COUSCOUS PM	1.00	15.00	12.00	t
766	255	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
767	256	\N	IRISH COFFEE	1.00	8.00	21.00	t
768	256	\N	THÉ MENTHE	1.00	2.50	21.00	f
769	256	\N	VIN ROUGE VERRE	1.00	4.00	21.00	t
770	256	\N	VIN BLANC VERRE	1.00	4.00	21.00	t
771	256	\N	MAISON	2.00	6.00	21.00	t
772	256	\N	CREME BRULEE	1.00	5.00	12.00	t
773	256	\N	SPAG.COURG.SCAMP.	1.00	16.00	12.00	f
774	256	\N	BURRATINA	1.00	14.00	12.00	t
775	256	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
781	259	\N	SOFT (Verre)	1.00	2.00	21.00	t
782	259	\N	PÂTES TRUFFE	2.00	7.00	6.00	t
785	262	\N	PÂTES BOLO	1.00	6.00	6.00	t
786	262	\N	PÂTES LARD	1.00	6.00	6.00	t
790	265	\N	DIVERS	-1.00	-24.04	0.00	t
794	268	\N	COUSCOUS PM	3.00	13.50	6.00	t
798	271	\N	BURRATINA	1.00	14.00	12.00	t
801	274	\N	DIVERS	-1.00	-10.65	0.00	t
804	277	\N	DIVERS	-1.00	-30.00	0.00	t
807	280	\N	THÉ MENTHE	3.00	2.50	21.00	t
808	280	\N	GATEAUX MIEL	4.00	5.00	6.00	t
809	280	\N	COUSCOUS PM	2.00	13.50	6.00	t
810	280	\N	POLPETTE	1.00	12.60	6.00	t
811	280	\N	PÂTES TRUFFE	2.00	15.30	6.00	t
827	283	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
828	283	\N	COUSCOUS PM	2.00	15.00	12.00	f
829	283	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	t
830	283	\N	JUPILER	2.00	2.00	21.00	t
831	283	\N	MARTINI Blanc/Rouge	1.00	5.00	21.00	t
840	286	\N	CHARDONNAY (2020)	1.00	18.00	21.00	f
841	286	\N	THÉ MENTHE	1.00	2.50	21.00	t
842	286	\N	PECKET FRAISE	1.00	6.00	21.00	f
843	286	\N	MAISON	3.00	6.00	21.00	f
844	286	\N	CREME BRULEE	2.00	5.00	12.00	t
845	286	\N	IRISH COFFEE	1.00	8.00	21.00	f
846	286	\N	PÂTES SCAMPIS	1.00	15.00	12.00	t
847	286	\N	COUSCOUS VG	1.00	10.00	12.00	t
848	286	\N	COUSCOUS PM	1.00	15.00	12.00	t
849	286	\N	BURRATINA	1.00	14.00	12.00	t
850	286	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
879	289	\N	GATEAUX MIEL	1.00	3.00	6.00	t
880	289	\N	PÂTES LARD	1.00	6.00	6.00	t
881	289	\N	CAFÉ	1.00	2.50	21.00	t
884	292	\N	COUSCOUS PM	1.00	13.50	6.00	t
888	295	\N	DIVERS	-1.00	-108.00	0.00	f
894	298	\N	DIVERS	-1.00	-400.00	0.00	t
910	301	\N	DIVERS	-1.00	-19.85	0.00	t
918	304	\N	MAISON	1.00	6.00	21.00	f
919	304	\N	VIN BLANC VERRE	2.00	4.00	21.00	f
920	304	\N	COUSCOUS PM	1.00	15.00	12.00	t
928	307	\N	DIVERS	-1.00	-13.15	0.00	t
941	310	\N	PÂTES BOLO	1.00	6.00	6.00	t
951	313	\N	DIVERS	-1.00	-118.38	0.00	t
954	316	\N	VIN ROUGE VERRE	1.00	4.00	21.00	t
955	316	\N	Cuba-Li	1.00	6.00	21.00	t
956	316	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
969	319	\N	DIVERS	-1.00	-37.10	0.00	t
972	322	\N	DIVERS	-1.00	-55.00	0.00	t
986	325	\N	DIVERS	-1.00	-50.00	0.00	t
989	328	\N	DIVERS	-1.00	-60.00	0.00	t
992	331	\N	CAFÉ	1.00	2.50	21.00	t
993	331	\N	VIN ROUGE VERRE	1.00	5.00	21.00	t
994	331	\N	COUSCOUS PM	1.00	15.00	12.00	t
999	334	\N	NOURRITURE	-1.00	-10.96	0.00	t
1005	337	\N	POLPETTE	1.00	12.60	6.00	f
1006	337	\N	COUSCOUS PM	1.00	13.50	6.00	f
1007	337	\N	BURRATINA	1.00	14.00	12.00	f
1019	340	\N	CHARDONNAY (2020)	1.00	19.00	21.00	t
1020	340	\N	CHIARETTO	1.00	19.00	21.00	t
1021	340	\N	Cuba-Li	1.00	6.00	21.00	t
1022	340	\N	MAISON	1.00	6.00	21.00	t
1023	340	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
1024	340	\N	SCAMPIS LUCIFER	3.00	8.00	12.00	t
1045	343	\N	PRIMITIVO NR 14	2.00	24.00	21.00	t
1046	343	\N	Cuba-Li	3.00	6.00	21.00	t
1047	343	\N	MAISON	8.00	6.00	21.00	t
1048	343	\N	PÂTES TRUFFE	4.00	17.00	12.00	t
1049	343	\N	COUSCOUS PM	3.00	15.00	12.00	t
1050	343	\N	PÂTES SCAMPIS	1.00	15.00	12.00	t
1051	343	\N	POLPETTE	4.00	14.00	12.00	t
1052	343	\N	TCHAKTCHOUKA	1.00	8.00	12.00	t
1061	346	\N	NOURRITURE	-1.00	-13.25	0.00	t
1066	349	\N	NOURRITURE	-1.00	-44.26	0.00	t
1069	352	\N	THÉ MENTHE	1.00	2.50	21.00	t
1070	352	\N	SOFT (Verre)	3.00	2.00	21.00	t
1071	352	\N	PROSECCO VERRE	1.00	5.00	21.00	t
1072	352	\N	BLONDINETTE	2.00	3.50	21.00	t
1073	352	\N	PECKET FRAISE	1.00	6.00	21.00	t
1074	352	\N	GLACE	1.00	5.00	12.00	t
1075	352	\N	CREME BRULEE	2.00	5.00	12.00	t
1076	352	\N	COUSCOUS PM	2.00	15.00	12.00	t
1077	352	\N	POLPETTE	1.00	14.00	12.00	t
1078	352	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
1079	352	\N	TCHAKTCHOUKA	1.00	8.00	12.00	t
1080	352	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
1083	355	\N	DIVERS	-1.00	-88.26	0.00	t
1091	358	\N	CAFÉ	2.00	2.50	21.00	f
1092	358	\N	COUSCOUS PM	2.00	15.00	12.00	f
1093	358	\N	EAU 1/2 L	1.00	3.50	21.00	f
1094	358	\N	MAISON	2.00	6.00	21.00	f
1098	361	\N	PÂTES TRUFFE	1.00	7.00	6.00	t
1099	361	\N	JUPILER	9.00	2.50	21.00	t
1102	364	\N	NOURRITURE	-1.00	-96.25	0.00	t
1106	367	\N	PÂTES BOLO	1.00	6.00	6.00	f
1117	370	\N	LOYER	-1.00	-600.00	0.00	t
1124	373	\N	SOFT (Verre)	1.00	2.00	21.00	f
1125	373	\N	PÂTES LARD	1.00	12.00	12.00	f
1126	373	\N	COUSCOUS PM	1.00	15.00	12.00	f
1136	376	\N	SOFT (Verre)	1.00	2.00	21.00	f
1137	376	\N	VIN BLANC VERRE	1.00	5.00	21.00	f
1138	376	\N	JUPILER	7.00	2.50	21.00	f
1153	379	\N	PRIMITIVO NR 14	2.00	24.00	21.00	f
1154	379	\N	EAU 1/2 L	1.00	5.50	21.00	t
1155	379	\N	SOFT (Verre)	2.00	2.00	21.00	t
1156	379	\N	PROSECCO VERRE	2.00	5.00	21.00	t
1157	379	\N	Cuba-Li	2.00	6.00	21.00	t
1158	379	\N	MAISON	1.00	6.00	21.00	t
1159	379	\N	CREME BRULEE	1.00	5.00	12.00	t
1160	379	\N	IRISH COFFEE	2.00	8.00	21.00	f
1161	379	\N	BURRATINA	2.00	14.00	12.00	f
1162	379	\N	COUSCOUS PM	1.00	15.00	12.00	t
1163	379	\N	POLPETTE	1.00	14.00	12.00	t
1164	379	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
1167	382	\N	CHIARETTO	1.00	19.00	21.00	f
1168	382	\N	PÂTES TRUFFE	2.00	17.00	12.00	f
1231	407	\N	TCHAKTCHOUKA	1.00	14.00	12.00	f
1232	407	\N	PÂTES TRUFFE	1.00	17.00	12.00	f
776	257	\N	IRISH COFFEE	1.00	8.00	21.00	f
777	257	\N	PÂTES LARD	1.00	12.00	12.00	t
778	257	\N	VIN BLANC VERRE	3.00	4.00	21.00	f
779	257	\N	APEROL SPRITZ	3.00	6.00	21.00	f
783	260	\N	DIVERS	-1.00	-60.45	0.00	t
787	263	\N	JUPILER	3.00	2.00	21.00	t
791	266	\N	DIVERS	-1.00	-20.03	0.00	t
795	269	\N	COUSCOUS PM	1.00	15.00	12.00	t
799	272	\N	DIVERS	-1.00	-270.36	0.00	t
802	275	\N	DIVERS	-1.00	-70.00	0.00	t
805	278	\N	COUSCOUS VG	6.00	9.00	6.00	t
812	281	\N	VIN 1/2	1.00	14.00	21.00	t
813	281	\N	THÉ MENTHE	1.00	2.50	21.00	t
814	281	\N	EAUX 1 L	1.00	5.00	21.00	t
815	281	\N	PROSECCO Bouteille	1.00	25.00	21.00	t
816	281	\N	CREME BRULEE	2.00	5.00	12.00	t
817	281	\N	PÂTES LARD	2.00	14.00	12.00	t
832	284	\N	DIVERS	-1.00	-90.34	0.00	t
851	287	\N	TRIPLE SAINTE NITOUCHE	1.00	4.00	21.00	t
852	287	\N	BLONDINETTE	1.00	3.50	21.00	t
853	287	\N	VIN BLANC VERRE	2.00	4.00	21.00	t
854	287	\N	PECKET FRAISE	3.00	6.00	21.00	t
855	287	\N	COUSCOUS PM	4.00	15.00	12.00	t
856	287	\N	TCHAKTCHOUKA	2.00	8.00	12.00	t
857	287	\N	SCAMPIS LUCIFER	3.00	8.00	12.00	t
882	290	\N	DIVERS	-1.00	-10.72	0.00	t
885	293	\N	VIN ROUGE VERRE	3.00	4.00	21.00	t
886	293	\N	COUSCOUS PM	1.00	15.00	12.00	t
889	296	\N	CAFÉ	1.00	2.50	21.00	t
890	296	\N	CREME BRULEE	2.00	5.00	12.00	t
891	296	\N	JUPILER	2.00	2.00	21.00	t
892	296	\N	PÂTES SCAMPIS	2.00	15.00	12.00	t
895	299	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	t
896	299	\N	COUSCOUS PM	1.00	13.50	6.00	t
911	302	\N	VIN ROUGE VERRE	1.00	4.00	21.00	t
912	302	\N	VIN BLANC VERRE	2.00	4.00	21.00	f
913	302	\N	PECKET FRAISE	3.00	6.00	21.00	f
914	302	\N	CREME BRULEE	1.00	5.00	12.00	t
915	302	\N	COUSCOUS PM	2.00	15.00	12.00	t
921	305	\N	SOFT (Verre)	1.00	2.00	21.00	t
922	305	\N	THÉ MENTHE	1.00	2.50	21.00	t
923	305	\N	VIN BLANC VERRE	2.00	4.00	21.00	f
924	305	\N	PECKET FRAISE	2.00	6.00	21.00	f
925	305	\N	POLPETTE	1.00	12.60	12.00	f
926	305	\N	COUSCOUS PM	2.00	15.00	12.00	t
929	308	\N	DIVERS	-1.00	-50.77	0.00	t
942	311	\N	CREME BRULEE	1.00	5.00	12.00	t
943	311	\N	CAFÉ	3.00	2.50	21.00	t
944	311	\N	GLACE	3.00	5.00	12.00	t
945	311	\N	PÂTES	2.00	8.00	12.00	t
946	311	\N	COUSCOUS PM	1.00	8.00	12.00	t
947	311	\N	COUSCOUS PM	2.00	15.00	12.00	t
948	311	\N	MAISON	3.00	6.00	21.00	t
949	311	\N	SOFT (Verre)	2.00	2.00	21.00	t
952	314	\N	DIVERS	-1.00	-46.86	0.00	t
957	317	\N	CAFÉ	1.00	2.50	21.00	t
958	317	\N	GLACE	1.00	5.00	12.00	t
959	317	\N	GATEAUX MIEL	1.00	5.00	12.00	t
960	317	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
961	317	\N	COUSCOUS PM	1.00	15.00	12.00	f
962	317	\N	CHAMPIGNONS KABYLES	2.00	6.00	12.00	t
963	317	\N	VIN 1/2	1.00	14.00	21.00	f
964	317	\N	BLONDINETTE	1.00	3.50	21.00	f
965	317	\N	Cuba-Li	1.00	6.00	21.00	f
970	320	\N	DIVERS	-1.00	-4.28	0.00	t
973	323	\N	COUSCOUS VG	2.00	9.00	6.00	f
974	323	\N	COUSCOUS PM	8.00	13.50	6.00	f
987	326	\N	DIVERS	-1.00	-60.00	0.00	t
990	329	\N	DIVERS	-1.00	-50.00	0.00	t
995	332	\N	PÂTES BOLO	1.00	6.00	6.00	t
1000	335	\N	POLPETTE	1.00	14.00	12.00	f
1001	335	\N	COUSCOUS VG	1.00	10.00	12.00	f
1008	338	\N	SOFT (Verre)	1.00	2.00	21.00	t
1009	338	\N	MAISON	1.00	6.00	21.00	t
1010	338	\N	CREME BRULEE	2.00	5.00	12.00	t
1011	338	\N	PÂTES SCAMPIS	1.00	15.00	12.00	t
1012	338	\N	PÂTES BOLO	1.00	12.00	12.00	t
1025	341	\N	BLONDINETTE	2.00	3.50	21.00	t
1026	341	\N	TRIPLE SAINTE NITOUCHE	1.00	4.50	21.00	t
1027	341	\N	GATEAUX MIEL	1.00	3.00	12.00	t
1028	341	\N	COUSCOUS PM	1.00	15.00	12.00	t
1029	341	\N	POLPETTE	1.00	14.00	12.00	t
1030	341	\N	TCHAKTCHOUKA	1.00	8.00	12.00	t
1031	341	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	t
1053	344	\N	SOFT (Verre)	1.00	2.00	21.00	t
1054	344	\N	PROSECCO VERRE	1.00	5.00	21.00	t
1055	344	\N	VIN ROUGE VERRE	1.00	5.00	21.00	t
1056	344	\N	CAFÉ	1.00	2.50	21.00	t
1057	344	\N	ESPRESSO	1.00	2.50	21.00	t
1058	344	\N	GRAPPA	1.00	5.00	21.00	t
1059	344	\N	AMARETTO	3.00	5.00	21.00	t
1062	347	\N	COUSCOUS PM	1.00	18.00	6.00	f
1063	347	\N	COUSCOUS VG	1.00	9.00	6.00	f
1064	347	\N	PÂTES LARD	1.00	12.00	12.00	f
1067	350	\N	NOURRITURE	-1.00	-68.83	0.00	t
1081	353	\N	SERVICE	-1.00	-50.00	0.00	t
1084	356	\N	SOFT (Verre)	1.00	2.00	21.00	t
1085	356	\N	IRISH COFFEE	1.00	8.00	21.00	t
1086	356	\N	PÂTES LARD	1.00	12.00	12.00	t
1087	356	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
1088	356	\N	PROSECCO VERRE	2.00	5.00	21.00	t
1095	359	\N	PÂTES BOLO	1.00	6.00	6.00	f
1096	359	\N	PÂTES LARD	1.00	6.00	6.00	f
1100	362	\N	PÂTES LARD	1.00	6.00	6.00	f
1103	365	\N	NOURRITURE	-1.00	-24.36	0.00	t
1107	368	\N	PECKET FRAISE	1.00	6.00	21.00	t
1108	368	\N	MAISON	1.00	6.00	21.00	t
1109	368	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
1110	368	\N	BURRATINA	2.00	14.00	12.00	t
1111	368	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
1118	371	\N	COUSCOUS VG	1.00	9.00	6.00	f
1119	371	\N	COUSCOUS PM	5.00	13.50	6.00	f
1127	374	\N	ROSÉ VERRE	1.00	5.00	21.00	f
1128	374	\N	VIN BLANC VERRE	2.00	5.00	21.00	f
1129	374	\N	JUPILER	5.00	2.50	21.00	f
1139	377	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
1140	377	\N	SOFT (Verre)	1.00	2.00	21.00	f
1141	377	\N	Cuba-Li	1.00	6.00	21.00	f
1142	377	\N	PECKET FRAISE	1.00	6.00	21.00	f
1143	377	\N	MAISON	1.00	6.00	21.00	f
1144	377	\N	PÂTES LARD	1.00	12.00	12.00	f
1145	377	\N	PÂTES TRUFFE	3.00	17.00	12.00	f
780	258	\N	DIVERS	-1.00	-151.03	0.00	t
784	261	\N	DIVERS	-1.00	-400.00	0.00	t
788	264	\N	JUPILER	2.00	2.00	21.00	t
789	264	\N	PÂTES LARD	1.00	6.00	6.00	t
792	267	\N	PÂTES TRUFFE	1.00	7.00	6.00	t
793	267	\N	PÂTES LARD	2.00	6.00	6.00	t
796	270	\N	JUPILER	2.00	2.00	21.00	t
797	270	\N	PÂTES TRUFFE	1.00	14.00	12.00	t
800	273	\N	DIVERS	-1.00	-106.00	0.00	t
803	276	\N	DIVERS	-1.00	-26.00	0.00	t
806	279	\N	COUSCOUS PM	1.00	13.50	6.00	t
818	282	\N	COUSCOUS PM	1.00	15.00	12.00	t
819	282	\N	CASELLETTI	1.00	30.00	21.00	f
820	282	\N	CAFÉ	1.00	2.50	21.00	t
821	282	\N	THÉ MENTHE	1.00	2.50	21.00	t
822	282	\N	PECKET FRAISE	1.00	6.00	21.00	t
823	282	\N	GATEAUX MIEL	1.00	5.00	12.00	t
824	282	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	t
825	282	\N	PÂTES LARD	2.00	14.00	12.00	f
826	282	\N	TCHAKTCHOUKA	2.00	8.00	12.00	t
833	285	\N	IRISH COFFEE	1.00	8.00	21.00	t
834	285	\N	GLACE	1.00	5.00	12.00	t
835	285	\N	COUSCOUS PM	2.00	15.00	12.00	f
836	285	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	t
837	285	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	t
838	285	\N	SOFT (Verre)	3.00	2.00	21.00	t
839	285	\N	MAISON	1.00	6.00	21.00	f
858	288	\N	TCHAKTCHOUKA	1.00	14.00	12.00	t
859	288	\N	POLPETTE	1.00	14.00	12.00	t
860	288	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
861	288	\N	BURRATINA	1.00	14.00	12.00	t
862	288	\N	COUSCOUS PM	3.00	15.00	12.00	f
863	288	\N	COUSCOUS VG	3.00	10.00	12.00	f
864	288	\N	SCAMPIS LUCIFER	2.00	8.00	12.00	t
865	288	\N	ASSIETTE APERITIVE (2 p.)	2.00	19.00	12.00	t
866	288	\N	PRIMITIVO NR 14	2.00	24.00	21.00	f
867	288	\N	PINOT GRIGIO (2020)	2.00	16.00	21.00	f
868	288	\N	CAFÉ	2.00	2.50	21.00	t
869	288	\N	CAPUCCINO	2.00	2.80	21.00	t
870	288	\N	EAU 1/2 L	1.00	3.50	21.00	t
871	288	\N	SOFT (Verre)	3.00	2.00	21.00	t
872	288	\N	JUPILER	1.00	2.00	21.00	t
873	288	\N	TRIPLE SAINTE NITOUCHE	2.00	4.00	21.00	t
874	288	\N	Cuba-Li	2.00	6.00	21.00	f
875	288	\N	GIN TONIC	2.00	6.00	21.00	t
876	288	\N	APEROL SPRITZ	2.00	6.00	21.00	f
877	288	\N	MAISON	1.00	6.00	21.00	t
878	288	\N	PECKET FRAISE	7.00	6.00	21.00	f
883	291	\N	DIVERS	-1.00	-50.40	0.00	t
887	294	\N	LOYER	-1.00	-600.00	0.00	t
893	297	\N	DIVERS	-1.00	-28.14	0.00	t
897	300	\N	THÉ MENTHE	1.00	2.50	21.00	t
898	300	\N	MAISON	1.00	6.00	21.00	f
899	300	\N	PECKET FRAISE	6.00	6.00	21.00	f
900	300	\N	CREME BRULEE	1.00	5.00	12.00	t
901	300	\N	GATEAUX MIEL	2.00	5.00	12.00	t
902	300	\N	GLACE	1.00	5.00	12.00	f
903	300	\N	PÂTES SCAMPIS	1.00	15.00	12.00	t
904	300	\N	COUSCOUS PM	4.00	15.00	12.00	t
905	300	\N	CHAMPIGNONS KABYLES	2.00	6.00	12.00	f
906	300	\N	SCAMPIS LUCIFER	3.00	8.00	12.00	f
907	300	\N	BLONDINETTE	1.00	3.50	21.00	t
908	300	\N	VIN ROUGE VERRE	1.00	4.00	21.00	f
909	300	\N	VIN BLANC VERRE	1.00	4.00	21.00	t
916	303	\N	VIN BLANC VERRE	3.00	4.00	21.00	f
917	303	\N	POLPETTE	2.00	14.00	12.00	t
927	306	\N	COUSCOUS PM	1.00	13.50	6.00	t
930	309	\N	CAFÉ	1.00	2.50	21.00	t
931	309	\N	Cuba-Li	1.00	6.00	21.00	t
932	309	\N	SOFT (Verre)	2.00	2.00	21.00	t
933	309	\N	MAISON	1.00	6.00	21.00	t
934	309	\N	CREME BRULEE	2.00	5.00	12.00	t
935	309	\N	PÂTES BOLO	1.00	12.00	12.00	t
936	309	\N	PÂTES TRUFFE	1.00	17.00	12.00	f
937	309	\N	PÂTES SCAMPIS	1.00	15.00	12.00	f
938	309	\N	TCHAKTCHOUKA	1.00	8.00	12.00	t
939	309	\N	CHAMPIGNONS KABYLES	2.00	6.00	12.00	t
940	309	\N	CASELLETTI	1.00	30.00	21.00	f
950	312	\N	DIVERS	-1.00	-37.10	0.00	t
953	315	\N	DIVERS	-1.00	-11.44	0.00	t
966	318	\N	CASELLETTI	1.00	30.00	21.00	t
967	318	\N	THÉ MENTHE	2.00	2.50	21.00	t
968	318	\N	COUSCOUS PM	2.00	15.00	12.00	t
971	321	\N	DIVERS	-1.00	-8.76	0.00	t
975	324	\N	CAPUCCINO	1.00	2.80	21.00	t
976	324	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	f
977	324	\N	CHAMPIGNONS KABYLES	2.00	6.00	12.00	f
978	324	\N	SOFT (Verre)	1.00	2.00	21.00	t
979	324	\N	VIN ROUGE VERRE	1.00	4.00	21.00	t
980	324	\N	PÂTES BOLO	1.00	12.00	12.00	t
981	324	\N	PÂTES LARD	1.00	12.00	12.00	t
982	324	\N	COUSCOUS PM	1.00	15.00	12.00	f
983	324	\N	MAISON	2.00	6.00	21.00	t
984	324	\N	SOFT (Verre)	2.00	2.00	21.00	t
985	324	\N	PECKET FRAISE	1.00	6.00	21.00	t
988	327	\N	DIVERS	-1.00	-50.00	0.00	t
991	330	\N	DIVERS	-1.00	-22.06	0.00	t
996	333	\N	THÉ MENTHE	2.00	2.50	21.00	t
997	333	\N	COUSCOUS PM	2.00	15.00	12.00	t
998	333	\N	TRIPLE SAINTE NITOUCHE	2.00	4.50	21.00	t
1002	336	\N	VIN ROUGE VERRE	2.00	5.00	21.00	f
1003	336	\N	PÂTES SCAMPIS	1.00	15.00	12.00	f
1004	336	\N	MAISON	2.00	6.00	21.00	f
1013	339	\N	IRISH COFFEE	1.00	8.00	21.00	t
1014	339	\N	ROSÉ VERRE	2.00	5.00	21.00	t
1015	339	\N	PECKET FRAISE	1.00	6.00	21.00	t
1016	339	\N	MAISON	1.00	6.00	21.00	t
1017	339	\N	CREME BRULEE	1.00	5.00	12.00	t
1018	339	\N	COUSCOUS PM	2.00	15.00	12.00	t
1032	342	\N	THÉ MENTHE	3.00	2.50	21.00	t
1033	342	\N	SOFT (Verre)	3.00	2.00	21.00	t
1034	342	\N	MAISON	3.00	6.00	21.00	t
1035	342	\N	GIN TONIC	1.00	6.00	21.00	t
1036	342	\N	IRISH COFFEE	1.00	8.00	21.00	t
1037	342	\N	CREME BRULEE	3.00	5.00	12.00	t
1038	342	\N	POLPETTE	1.00	14.00	12.00	t
1039	342	\N	COUSCOUS VG	1.00	10.00	12.00	t
1040	342	\N	COUSCOUS PM	2.00	15.00	12.00	t
1041	342	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
1042	342	\N	TCHAKTCHOUKA	1.00	8.00	12.00	t
1043	342	\N	VIN ROUGE VERRE	2.00	5.00	21.00	t
1044	342	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
1060	345	\N	SERVICE	-1.00	-50.00	0.00	t
1065	348	\N	BOISSONS	-1.00	-115.00	0.00	t
1068	351	\N	PÂTES BOLO	1.00	6.00	6.00	t
1082	354	\N	EMBALLAGE	-1.00	-69.01	0.00	t
1089	357	\N	POLPETTE	3.00	14.00	6.00	f
1090	357	\N	PÂTES LARD	3.00	6.00	6.00	f
1097	360	\N	NOURRITURE	-1.00	-11.44	0.00	t
1101	363	\N	PÂTES TRUFFE	1.00	7.00	6.00	f
1104	366	\N	PÂTES LARD	1.00	6.00	6.00	t
1105	366	\N	PÂTES TRUFFE	2.00	7.00	6.00	t
1112	369	\N	COUSCOUS PM	1.00	13.50	6.00	f
1113	369	\N	VIN BLANC VERRE	2.00	5.00	21.00	f
1114	369	\N	PÂTES BOLO	1.00	12.00	12.00	f
1115	369	\N	EAU 1/2 L	1.00	3.50	21.00	f
1116	369	\N	MAISON	1.00	6.00	21.00	f
1120	372	\N	POLPETTE	1.00	8.00	6.00	t
1121	372	\N	POLPETTE	1.00	12.60	6.00	t
1122	372	\N	PÂTES LARD	1.00	10.80	6.00	t
1123	372	\N	COUSCOUS PM	1.00	13.50	6.00	t
1130	375	\N	COUSCOUS PM	1.00	15.00	12.00	t
1131	375	\N	POLPETTE	1.00	14.00	12.00	t
1132	375	\N	PÂTES LARD	1.00	12.00	6.00	t
1133	375	\N	VIN BLANC VERRE	1.00	5.00	21.00	t
1134	375	\N	JUPILER	2.00	2.50	21.00	t
1135	375	\N	SOFT (Verre)	3.00	2.00	21.00	t
1147	378	\N	PINOT GRIGIO (2020)	1.00	19.00	21.00	f
1148	378	\N	TRIPLE SAINTE NITOUCHE	1.00	4.50	21.00	f
1149	378	\N	PROSECCO VERRE	1.00	5.00	21.00	f
1150	378	\N	IRISH COFFEE	2.00	8.00	21.00	f
1151	378	\N	COUSCOUS PM	2.00	15.00	12.00	f
1152	378	\N	CHAMPIGNONS KABYLES	2.00	6.00	12.00	f
1166	381	\N	PÂTES BOLO	2.00	10.80	6.00	f
1233	407	\N	EAUX 1 L	1.00	5.00	21.00	f
1234	407	\N	PECKET FRAISE	1.00	6.00	21.00	f
1235	407	\N	MAISON	1.00	6.00	21.00	f
1246	410	\N	GRAPPA	2.00	5.00	21.00	t
1247	410	\N	JUPILER	2.00	2.50	21.00	t
1248	410	\N	CREME BRULEE	1.00	5.00	12.00	t
1252	413	\N	EAUX 1 L	2.00	5.00	21.00	t
1253	413	\N	CAPUCCINO	1.00	2.80	21.00	t
1254	413	\N	CAFÉ	1.00	2.50	21.00	t
1255	413	\N	SOFT (Verre)	3.00	2.00	21.00	t
1256	413	\N	ROSÉ VERRE	4.00	5.00	21.00	t
1257	413	\N	PROSECCO VERRE	1.00	5.00	21.00	t
1258	413	\N	PECKET FRAISE	1.00	6.00	21.00	t
1259	413	\N	GLACE	2.00	5.00	12.00	t
1260	413	\N	PÂTES LARD	2.00	12.00	12.00	t
1261	413	\N	PÂTES SCAMPIS	1.00	15.00	12.00	t
1262	413	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
1263	413	\N	SCAMPIS LUCIFER	2.00	8.00	12.00	t
1268	416	\N	SERVICE	-1.00	-50.00	0.00	t
1275	419	\N	IRISH COFFEE	1.00	8.00	21.00	t
1276	419	\N	CREME BRULEE	1.00	5.00	12.00	t
1277	419	\N	BURRATINA	1.00	14.00	12.00	t
1278	419	\N	TORTELLONE RICOTTA	1.00	15.00	12.00	t
1279	419	\N	PECKET FRAISE	1.00	6.00	21.00	t
1280	419	\N	MAISON	1.00	6.00	21.00	t
1291	422	\N	NOSTRA LIEGE	-1.00	72.00	0.00	t
1295	425	\N	NOURRITURE	-1.00	-65.45	0.00	t
1303	427	\N	ROUGE VERRE	1.00	5.00	21.00	t
1304	427	\N	MAISON	1.00	6.00	21.00	t
1305	428	\N	CAFÉ	1.00	2.50	21.00	f
1306	428	\N	ROUGE VERRE	1.00	5.00	21.00	f
1307	428	\N	POLPETTE	1.00	14.00	12.00	f
1308	428	\N	TORTELLONE RICOTTA	1.00	15.00	12.00	f
1309	428	\N	JUPILER	1.00	2.50	21.00	f
1310	428	\N	PROSECCO VERRE	1.00	5.00	21.00	f
1312	430	\N	NOURRITURE	-1.00	-26.85	0.00	t
1313	431	\N	PÂTES BOLO	1.00	6.00	6.00	t
1314	431	\N	PÂTES LARD	1.00	6.00	6.00	t
1321	433	\N	COUSCOUS PM	1.00	13.50	6.00	t
1322	433	\N	COUSCOUS VG	1.00	9.00	6.00	t
1323	434	\N	ROSÉ VERRE	2.00	5.00	21.00	f
1324	434	\N	CREME BRULEE	1.00	5.00	12.00	f
1325	434	\N	SPAG.COURG.SCAMP.	1.00	16.00	12.00	f
1326	434	\N	CHIARETTO	1.00	19.00	21.00	f
1327	434	\N	PROSECCO VERRE	2.00	5.00	21.00	f
1328	434	\N	COUSCOUS PM	1.00	15.00	12.00	f
1329	434	\N	TCHAKTCHOUKA	1.00	8.00	12.00	f
1330	434	\N	BURRATINA (1X50GR)	1.00	0.00	12.00	f
1343	436	\N	NOURRITURE	-1.00	-23.90	0.00	t
1344	437	\N	NOURRITURE	-1.00	-29.30	0.00	t
1346	439	\N	COUSCOUS PM	2.00	13.50	6.00	t
1347	440	\N	AMARETTO	2.00	5.00	21.00	f
1348	440	\N	BLANC VERRE	2.00	5.00	21.00	f
1349	440	\N	PÂTES LARD	1.00	12.00	12.00	f
1350	440	\N	PROSECCO VERRE	1.00	5.00	21.00	f
1351	440	\N	MAISON	2.00	6.00	21.00	f
1352	440	\N	EAU 1/2 L	1.00	3.50	21.00	f
1364	442	\N	SERVICE	-1.00	-100.00	0.00	t
1365	443	\N	THÉ MENTHE	1.00	2.50	21.00	t
1366	443	\N	GLACE	3.00	5.00	12.00	t
1367	443	\N	GATEAUX MIEL	2.00	5.00	12.00	t
1368	443	\N	CREME BRULEE	1.00	5.00	12.00	t
1369	443	\N	VIN 1/2	1.00	14.00	21.00	t
1370	443	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
1371	443	\N	PÂTES STRACIATELLA SCAMPIS	2.00	17.00	12.00	t
1372	443	\N	COUSCOUS PM	3.00	15.00	12.00	t
1373	443	\N	POLPETTE	1.00	14.00	12.00	t
1374	443	\N	POLPETTE	1.00	8.00	12.00	t
1375	443	\N	PÂTES SCAMPIS	1.00	11.00	12.00	t
1376	443	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
1377	443	\N	MAISON	1.00	6.00	21.00	t
1378	443	\N	BLONDINETTE	6.00	3.50	21.00	t
1379	443	\N	SOFT (Verre)	9.00	2.00	21.00	t
1381	445	\N	NOURRITURE	-1.00	-29.15	0.00	t
1382	446	\N	NOURRITURE	-1.00	-4.52	0.00	t
1385	448	\N	PÂTES LARD	2.00	6.00	6.00	t
1386	449	\N	NOURRITURE	-1.00	-30.88	0.00	t
1389	451	\N	POLPETTE	2.00	14.00	12.00	t
1390	452	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
1391	452	\N	COUSCOUS PM	2.00	15.00	12.00	t
1392	452	\N	PÂTES BOLO	1.00	6.00	6.00	f
1394	454	\N	PÂTES BOLO	1.00	12.00	6.00	t
1395	454	\N	PÂTES TRUFFE	1.00	15.30	6.00	t
1396	455	\N	NOURRITURE	-1.00	-75.97	0.00	t
1398	457	\N	POLPETTE	1.00	12.60	6.00	t
1399	457	\N	PÂTES LARD	1.00	12.00	6.00	t
1400	457	\N	PÂTES LARD	1.00	8.00	6.00	t
1401	458	\N	ORVAL	1.00	4.50	21.00	f
1146	377	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
1165	380	\N	NOURRITURE	-1.00	-20.57	0.00	t
1238	408	\N	BLANC VERRE	1.00	5.00	21.00	t
1239	408	\N	BLONDINETTE	2.00	3.50	21.00	t
1240	408	\N	JUPILER	2.00	2.50	21.00	t
1241	408	\N	PÂTES LARD	1.00	12.00	12.00	t
1242	408	\N	POLPETTE	2.00	14.00	12.00	t
1243	408	\N	COUSCOUS VG	1.00	10.00	12.00	t
1249	411	\N	NOURRITURE	-1.00	-34.20	0.00	t
1264	414	\N	PÂTES SCAMPIS	1.00	15.00	12.00	t
1265	414	\N	PÂTES LARD	1.00	12.00	12.00	t
1266	414	\N	SOFT (Verre)	1.00	2.00	21.00	t
1269	417	\N	CAPUCCINO	2.00	2.80	21.00	f
1270	417	\N	SALADE FOLLE	1.00	5.00	12.00	f
1271	417	\N	PÂTES LARD	1.00	12.00	12.00	f
1272	417	\N	PÂTES BOLO	1.00	12.00	12.00	f
1273	417	\N	VIN 1/2	1.00	14.00	21.00	f
1281	420	\N	CREME BRULEE	2.00	5.00	12.00	f
1282	420	\N	COUSCOUS PM	2.00	15.00	12.00	f
1283	420	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	f
1284	420	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	f
1285	420	\N	PRIMITIVO NR 14	2.00	24.00	21.00	f
1286	420	\N	ROUGE VERRE	1.00	5.00	21.00	f
1287	420	\N	PROSECCO VERRE	1.00	5.00	21.00	f
1292	423	\N	SOFT (Verre)	1.00	2.00	21.00	t
1293	423	\N	PÂTES BOLO	1.00	6.00	6.00	t
1296	426	\N	IRISH COFFEE	2.00	8.00	21.00	f
1297	426	\N	BLANC VERRE	2.00	5.00	21.00	f
1298	426	\N	POLPETTE	1.00	14.00	12.00	f
1299	426	\N	PÂTES BOLO	1.00	12.00	12.00	f
1300	426	\N	PROSECCO VERRE	2.00	5.00	21.00	f
1311	429	\N	NOURRITURE	-1.00	-10.80	0.00	t
1315	432	\N	BLANC VERRE	1.00	5.00	21.00	f
1316	432	\N	MAISON	2.00	6.00	21.00	t
1317	432	\N	CREME BRULEE	1.00	5.00	12.00	f
1318	432	\N	IRISH COFFEE	1.00	8.00	21.00	t
1319	432	\N	BURRATINA	2.00	14.00	12.00	f
1320	432	\N	TCHAKTCHOUKA	2.00	8.00	12.00	t
1331	435	\N	THÉ MENTHE	3.00	2.50	21.00	f
1332	435	\N	GLACE	1.00	0.00	12.00	f
1333	435	\N	CREME BRULEE	1.00	5.00	12.00	f
1334	435	\N	GATEAUX MIEL	1.00	5.00	12.00	f
1335	435	\N	PÂTES BOLO	1.00	12.00	12.00	f
1336	435	\N	BURRATINA	1.00	14.00	12.00	f
1337	435	\N	COUSCOUS PM	4.00	15.00	12.00	f
1338	435	\N	CHIARETTO	1.00	19.00	21.00	f
1339	435	\N	BLONDINETTE	1.00	3.50	21.00	f
1340	435	\N	SOFT (Verre)	4.00	2.00	21.00	f
1341	435	\N	APEROL SPRITZ	5.00	6.00	21.00	f
1342	435	\N	MAISON	1.00	6.00	21.00	f
1345	438	\N	PAQUE	-1.00	-99.44	0.00	t
1353	441	\N	ROSÉ VERRE	1.00	5.00	21.00	t
1354	441	\N	BLANC VERRE	1.00	5.00	21.00	t
1355	441	\N	BLONDINETTE	1.00	3.50	21.00	t
1356	441	\N	MAISON	1.00	6.00	21.00	t
1357	441	\N	IRISH COFFEE	1.00	8.00	21.00	t
1358	441	\N	BURRATINA	1.00	14.00	12.00	t
1359	441	\N	PÂTES STRACIATELLA SCAMPIS	2.00	17.00	12.00	f
1360	441	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	f
1361	441	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	t
1362	441	\N	TCHAKTCHOUKA	1.00	8.00	12.00	f
1363	441	\N	THÉ MENTHE	2.00	2.50	21.00	t
1380	444	\N	NOURRITURE	-1.00	-28.45	0.00	t
1383	447	\N	PÂTES BOLO	1.00	6.00	6.00	t
1384	447	\N	PÂTES TRUFFE	1.00	7.00	6.00	t
1387	450	\N	BLONDINETTE	2.00	3.50	21.00	f
1388	450	\N	PÂTES LARD	1.00	6.00	6.00	t
1393	453	\N	COUSCOUS PM	1.00	13.50	6.00	t
1397	456	\N	NOURRITURE	-1.00	-3.50	0.00	t
1402	458	\N	JUPILER	9.00	2.50	21.00	f
1403	458	\N	PECKET FRAISE	7.00	6.00	21.00	f
1404	458	\N	MENU À 35	20.00	35.00	12.00	f
1405	459	\N	SERVICE	-1.00	-50.00	0.00	t
1406	460	\N	Fred	-1.00	-400.00	0.00	t
1407	461	\N	COUSCOUS PM	1.00	15.00	12.00	f
1408	461	\N	SCAMPIS LUCIFER	1.00	12.00	12.00	f
1409	461	\N	BLONDINETTE	2.00	3.50	21.00	f
1410	461	\N	PROSECCO VERRE	1.00	5.00	21.00	f
1411	462	\N	BURRATINA (1X50GR)	1.00	8.00	12.00	f
1412	462	\N	POLPETTE	1.00	14.00	12.00	f
1413	462	\N	BLONDINETTE	2.00	3.50	21.00	f
1414	462	\N	BLANC VERRE	2.00	5.00	21.00	f
1415	463	\N	CREME BRULEE	1.00	5.00	12.00	t
1416	463	\N	PÂTES LARD	1.00	12.00	6.00	t
1417	463	\N	ROSÉ VERRE	3.00	5.00	21.00	t
1418	463	\N	MAISON	2.00	6.00	21.00	t
1419	464	\N	JUPILER	4.00	2.50	21.00	t
1420	464	\N	PÂTES LARD	2.00	6.00	6.00	t
1421	465	\N	PÂTES LARD	1.00	6.00	6.00	t
1422	466	\N	PÂTES BOLO	1.00	6.00	6.00	t
1423	467	\N	NOURRITURE	-1.00	-22.92	0.00	t
1424	468	\N	SOFT (Verre)	2.00	2.00	21.00	t
1425	469	\N	CAFÉ	1.00	2.50	21.00	t
1426	469	\N	SOFT (Verre)	1.00	2.00	21.00	t
1427	469	\N	POLPETTE	1.00	14.00	12.00	t
1428	470	\N	EAUX 1 L	1.00	5.00	21.00	f
1429	470	\N	PÂTES LARD	2.00	12.00	12.00	f
1430	470	\N	COUSCOUS VG	1.00	9.00	6.00	t
1431	470	\N	COUSCOUS PM	1.00	13.50	6.00	t
1432	470	\N	ESPRESSO	1.00	2.50	21.00	f
1433	470	\N	CREME BRULEE	2.00	5.00	12.00	f
1434	471	\N	NOURRITURE	-1.00	-36.48	0.00	t
1435	472	\N	SERVICE	-1.00	-20.00	0.00	t
1436	473	\N	SOFT (Verre)	1.00	2.00	21.00	f
1437	473	\N	JUPILER	1.00	2.50	21.00	f
1438	473	\N	CORNET LARD	1.00	6.00	6.00	t
1439	474	\N	CORNET BOLO	1.00	6.00	6.00	t
1440	475	\N	CORNET LARD	1.00	6.00	6.00	t
1441	476	\N	CORNET BOLO	2.00	6.00	6.00	t
1442	477	\N	POLPETTE	2.00	12.60	6.00	t
1443	478	\N	CORNET TRUFFE	1.00	7.00	6.00	t
1444	479	\N	PÂTES TRUFFE	1.00	17.00	12.00	f
1445	479	\N	PÂTES BOLO/LARD	3.00	12.00	12.00	f
1446	479	\N	IRISH COFFEE	1.00	8.00	21.00	f
1447	479	\N	THÉ MENTHE	1.00	2.50	21.00	f
1448	479	\N	CAFÉ	1.00	2.50	21.00	f
1449	479	\N	SOFT (Verre)	2.00	2.00	21.00	f
1450	479	\N	BLONDINETTE	2.00	3.50	21.00	f
1451	480	\N	PÂTES TRUFFE	1.00	15.30	6.00	f
1452	480	\N	COUSCOUS PM	1.00	13.50	6.00	f
1453	481	\N	EMBALLAGE	-1.00	-49.45	0.00	t
1456	484	\N	CORNET LARD	1.00	6.00	6.00	t
1457	484	\N	SOFT (Verre)	2.00	2.00	21.00	f
1461	487	\N	COUSCOUS VG	2.00	10.00	6.00	t
1468	490	\N	PÂTES TRUFFE	1.00	17.00	6.00	t
1481	493	\N	VIN 1/2	1.00	13.00	21.00	f
1488	496	\N	NOURRITURE	-1.00	-79.96	0.00	t
1508	499	\N	CAPUCCINO	2.00	2.80	21.00	t
1509	499	\N	COUSCOUS PM	1.00	15.00	12.00	t
1510	499	\N	POLPETTE	1.00	14.00	12.00	t
1511	499	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
1512	499	\N	VIN 1/2	1.00	20.00	21.00	t
1513	499	\N	Cuba-Li	2.00	6.00	21.00	t
1516	502	\N	NOURRITURE	-1.00	-66.00	0.00	t
1519	505	\N	NOURRITURE	-1.00	-51.85	0.00	t
1525	508	\N	BLONDINETTE	2.00	3.50	21.00	f
1530	511	\N	ESPRESSO	3.00	2.50	21.00	f
1531	511	\N	SOFT (Verre)	1.00	2.00	21.00	f
2971	1030	\N	VIOLETTE	1.00	6.00	21.00	f
2972	1030	\N	BLANC VERRE	3.00	5.00	21.00	f
2973	1030	\N	CORNET LARD	1.00	6.00	6.00	f
2987	1033	\N	SERVICE Caro	-1.00	-50.00	0.00	t
2990	1036	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
2991	1036	\N	PÂTES	1.00	10.00	12.00	f
2992	1036	\N	POLPETTE	1.00	10.00	12.00	f
2993	1036	\N	ROUGE VERRE	1.00	5.00	21.00	f
3004	1039	\N	CORNET LARD	2.00	6.00	6.00	t
3005	1039	\N	JUPILER	4.00	2.00	21.00	t
3008	1042	\N	Taxes Liège	-1.00	-220.00	0.00	t
3011	1045	\N	NOURRITURE	-1.00	-17.77	0.00	t
3017	1048	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
3018	1048	\N	SOFT (Verre)	1.00	2.00	21.00	t
3019	1048	\N	VIOLETTE	1.00	6.00	21.00	t
3020	1048	\N	PROSECCO VERRE	1.00	5.00	21.00	t
3021	1048	\N	THÉ MENTHE	2.00	2.50	21.00	t
3022	1048	\N	CREME BRULEE	2.00	5.00	12.00	t
3023	1048	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
3024	1048	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	t
3025	1048	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
3052	1051	\N	CAFÉ	3.00	2.50	21.00	t
3053	1051	\N	SOFT (Verre)	1.00	2.00	21.00	t
3054	1051	\N	PÂTES PESTO	1.00	14.00	12.00	t
3055	1051	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
3056	1051	\N	TAJINE	1.00	15.00	12.00	t
3057	1051	\N	BLANC VERRE	1.00	5.00	21.00	t
3058	1051	\N	PROSECCO VERRE	1.00	5.00	21.00	t
3059	1051	\N	Cuba-Li	1.00	6.00	21.00	t
3060	1051	\N	GIN TONIC	1.00	6.00	21.00	t
3063	1054	\N	NOURRITURE	-1.00	-32.58	0.00	t
3066	1057	\N	Service Véro	-1.00	-35.00	0.00	t
3069	1060	\N	SOFT (Verre)	1.00	0.00	21.00	t
3070	1060	\N	PÂTES TRUFFE	1.00	0.00	12.00	t
3071	1060	\N	TAJINE	1.00	0.00	12.00	t
3072	1060	\N	PECKET FRAISE	2.00	0.00	21.00	t
3075	1063	\N	BRICO	-1.00	-17.49	0.00	t
3088	1066	\N	COUSCOUS PM	1.00	15.00	6.00	t
3103	1069	\N	TATIN	1.00	8.00	12.00	f
3104	1069	\N	THÉ MENTHE	3.00	2.50	21.00	f
3105	1069	\N	SABAYON	1.00	8.00	12.00	f
3106	1069	\N	CREME BRULEE	2.00	5.00	12.00	f
3107	1069	\N	APPASSIMENTO	1.00	30.00	21.00	f
3108	1069	\N	BLONDINETTE	1.00	3.50	21.00	f
3109	1069	\N	PECKET FRAISE	1.00	6.00	21.00	f
3110	1069	\N	GINGEMBRE	2.00	6.00	21.00	f
3111	1069	\N	BURRATINA TRUFFES	1.00	17.00	12.00	f
3112	1069	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	f
3113	1069	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
3114	1069	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
3117	1072	\N	Service Véro	-1.00	-25.00	0.00	t
3135	1075	\N	IRISH COFFEE	1.00	0.00	21.00	f
3136	1075	\N	BLANC VERRE	2.00	5.00	21.00	f
3137	1075	\N	VIOLETTE	2.00	6.00	21.00	f
3138	1075	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
3154	1078	\N	COUSCOUS PM	1.00	15.00	12.00	t
3155	1078	\N	TAJINE	1.00	15.00	12.00	t
3156	1078	\N	ROUGE VERRE	2.00	6.00	21.00	t
3168	1081	\N	TATIN	2.00	8.00	12.00	f
3169	1081	\N	APPASSIMENTO	1.00	30.00	21.00	f
3170	1081	\N	AMARETTO	1.00	0.00	21.00	f
3171	1081	\N	LIMONCELLO	2.00	0.00	21.00	f
3172	1081	\N	POLPETTE	2.00	15.00	12.00	f
3175	1084	\N	NOURRITURE	-1.00	-36.00	0.00	t
3178	1087	\N	Resto Filou	-1.00	-54.00	0.00	t
3181	1090	\N	ENERGIES	-1.00	-73.50	0.00	t
3184	1093	\N	NOURRITURE	-1.00	-8.10	0.00	t
3191	1096	\N	BOISSONS	-1.00	-66.00	0.00	t
3194	1099	\N	BLANC VERRE	2.00	5.00	21.00	f
3195	1099	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
3196	1099	\N	JUPILER	1.00	2.50	21.00	f
3197	1099	\N	CHARDONNAY (2020)	2.00	19.00	21.00	f
3200	1102	\N	MATERIEL	-1.00	-27.77	0.00	t
3206	1105	\N	JUPILER	2.00	2.00	21.00	t
3217	1108	\N	SOFT (Verre)	3.00	2.00	21.00	f
3218	1108	\N	TAJINE	1.00	15.00	12.00	f
3219	1108	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
3220	1108	\N	PÂTES	2.00	10.00	12.00	f
3232	1111	\N	TAJINE	18.00	9.00	6.00	f
3235	1114	\N	PÂTES BOLO/LARD	2.00	12.00	12.00	t
3236	1114	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
3242	1117	\N	THÉ MENTHE	2.00	2.50	21.00	t
3243	1117	\N	ROUGE VERRE	1.00	5.00	21.00	t
3244	1117	\N	EAU 1/2 L	1.00	3.50	21.00	t
3245	1117	\N	PROSECCO VERRE	2.00	5.00	21.00	t
3246	1117	\N	COUSCOUS PM	2.00	15.00	12.00	t
3247	1117	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
3258	1120	\N	THÉ MENTHE	4.00	2.50	21.00	t
3259	1120	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	t
3260	1120	\N	CHARDONNAY (2020)	1.00	19.00	21.00	t
3261	1120	\N	PINOT GRIGIO (2020)	1.00	19.00	21.00	t
3262	1120	\N	PROSECCO VERRE	1.00	5.00	21.00	t
3263	1120	\N	IRISH COFFEE	1.00	8.00	21.00	t
3264	1120	\N	Cuba-Li	1.00	6.00	21.00	t
3265	1120	\N	VIOLETTE	3.00	6.00	21.00	t
3266	1120	\N	GINGEMBRE	1.00	6.00	21.00	t
3267	1120	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
3268	1120	\N	COUSCOUS VG	1.00	10.00	12.00	t
3269	1120	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	t
3270	1120	\N	BURRATINA TRUFFES	4.00	17.00	12.00	t
3271	1120	\N	CREME BRULEE	2.00	5.00	12.00	t
3277	1123	\N	GLACE	1.00	5.00	12.00	t
1454	482	\N	NOURRITURE	-1.00	-68.57	0.00	t
1458	485	\N	CORNET LARD	1.00	6.00	6.00	t
1462	488	\N	PINOT GRIGIO (2020)	1.00	19.00	21.00	f
1469	491	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
1470	491	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
1471	491	\N	PECKET FRAISE	2.00	6.00	21.00	t
1472	491	\N	PINOT GRIGIO (2020)	2.00	19.00	21.00	t
1473	491	\N	CORNET BOLO	1.00	6.00	6.00	t
1474	491	\N	CORNET LARD	1.00	6.00	6.00	t
1482	494	\N	BLONDINETTE	2.00	3.50	21.00	f
1483	494	\N	BLANC VERRE	1.00	5.00	21.00	f
1484	494	\N	ROSÉ VERRE	5.00	5.00	21.00	f
1485	494	\N	PROSECCO VERRE	3.00	5.00	21.00	f
1486	494	\N	POLPETTE	1.00	14.00	12.00	f
1489	497	\N	PINOT GRIGIO (2020)	1.00	19.00	21.00	t
1490	497	\N	Cuba-Li	1.00	6.00	21.00	t
1491	497	\N	MAISON	1.00	6.00	21.00	t
1492	497	\N	IRISH COFFEE	2.00	8.00	21.00	t
1493	497	\N	COUSCOUS PM	1.00	15.00	12.00	t
1494	497	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
1514	500	\N	SERVICE	-1.00	-50.00	0.00	t
1517	503	\N	SOFT (Verre)	3.00	2.00	21.00	f
1520	506	\N	SOFT (Verre)	1.00	2.00	21.00	t
1521	506	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
1522	506	\N	PÂTES SCAMPIS	1.00	15.00	12.00	t
1526	509	\N	CORNET BOLO	1.00	6.00	6.00	t
1527	509	\N	SOFT (Verre)	1.00	2.00	21.00	t
1532	512	\N	NOURRITURE	-1.00	-33.55	0.00	t
2974	1031	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
2975	1031	\N	CREME BRULEE	1.00	5.00	12.00	f
2976	1031	\N	PANNA COTTA	1.00	5.00	12.00	f
2977	1031	\N	COUSCOUS PM	1.00	15.00	12.00	f
2978	1031	\N	COUSCOUS VG	1.00	10.00	12.00	f
2979	1031	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	f
2988	1034	\N	SERVICE Caro	-1.00	-50.00	0.00	t
2994	1037	\N	PROSECCO VERRE	3.00	5.00	21.00	f
2995	1037	\N	PÂTES PESTO	1.00	14.00	12.00	f
2996	1037	\N	TAJINE	2.00	15.00	12.00	t
2997	1037	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	t
2998	1037	\N	TCHAKTCHOUKA	1.00	10.00	12.00	t
3006	1040	\N	Taxes Liège	-1.00	-37.49	0.00	t
3009	1043	\N	NOURRITURE	-1.00	-50.00	0.00	t
3012	1046	\N	COUSCOUS PM	1.00	15.00	6.00	t
3026	1049	\N	COUSCOUS PM	2.00	15.00	12.00	t
3027	1049	\N	CREME BRULEE	1.00	5.00	12.00	t
3028	1049	\N	IRISH COFFEE	1.00	8.00	21.00	t
3029	1049	\N	THÉ MENTHE	1.00	2.50	21.00	t
3030	1049	\N	BLANC VERRE	4.00	5.00	21.00	t
3031	1049	\N	PROSECCO VERRE	1.00	5.00	21.00	t
3032	1049	\N	Cuba-Li	1.00	6.00	21.00	t
3061	1052	\N	SERVICE Caro	-1.00	-50.00	0.00	t
3064	1055	\N	NOURRITURE	-1.00	-76.45	0.00	t
3067	1058	\N	Service Véro	-1.00	-35.00	0.00	t
3073	1061	\N	CORNET BOLO	1.00	6.00	6.00	t
3076	1064	\N	CORNET LARD	2.00	6.00	6.00	t
3089	1067	\N	SOFT (Verre)	1.00	2.00	21.00	f
3090	1067	\N	APPASSIMENTO	2.00	30.00	21.00	f
3091	1067	\N	TAJINE	1.00	15.00	12.00	f
3092	1067	\N	COUSCOUS PM	5.00	15.00	12.00	f
3093	1067	\N	EAUX 1 L	1.00	5.00	21.00	f
3094	1067	\N	THÉ MENTHE	1.00	2.50	21.00	f
3095	1067	\N	CAFÉ	2.00	2.50	21.00	f
3096	1067	\N	SOFT (Verre)	2.00	2.00	21.00	f
3097	1067	\N	GINGEMBRE	1.00	6.00	21.00	f
3098	1067	\N	BLONDINETTE	1.00	3.50	21.00	f
3099	1067	\N	CHARDONNAY FIO	2.00	20.00	21.00	f
3100	1067	\N	BULLES 0% VERRE	3.00	5.00	1.00	f
3115	1070	\N	SERVICE Célia	-1.00	-20.00	0.00	t
3118	1073	\N	CHARDONNAY (2020)	1.00	19.00	21.00	t
3119	1073	\N	BLONDINETTE	2.00	3.50	21.00	t
3120	1073	\N	SOFT (Verre)	2.00	2.00	21.00	t
3121	1073	\N	PROSECCO VERRE	3.00	5.00	21.00	t
3122	1073	\N	GINGEMBRE	1.00	6.00	21.00	t
3123	1073	\N	THÉ MENTHE	2.00	2.50	21.00	t
3124	1073	\N	IRISH COFFEE	2.00	8.00	21.00	t
3125	1073	\N	PANNA COTTA	1.00	5.00	12.00	t
3126	1073	\N	SABAYON	1.00	8.00	12.00	t
3127	1073	\N	TATIN	1.00	8.00	12.00	t
3128	1073	\N	COUSCOUS PM	2.00	15.00	12.00	t
3129	1073	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	t
3130	1073	\N	PÂTES PESTO	2.00	14.00	12.00	t
3131	1073	\N	BURRATINA TRUFFES	2.00	17.00	12.00	t
3132	1073	\N	BURRATINA	1.00	14.00	12.00	t
3133	1073	\N	ASSIETTE APERITIVE (2 p.)	2.00	19.00	12.00	t
3139	1076	\N	SABAYON	1.00	8.00	12.00	t
3140	1076	\N	IRISH COFFEE	2.00	8.00	21.00	t
3141	1076	\N	APPASSIMENTO	1.00	30.00	21.00	t
3142	1076	\N	BURRATINA TRUFFES	1.00	17.00	12.00	t
3143	1076	\N	COUSCOUS PM	1.00	15.00	12.00	t
3144	1076	\N	COUSCOUS PM	1.00	15.00	12.00	t
3157	1079	\N	IRISH COFFEE	3.00	8.00	21.00	t
3158	1079	\N	PÂTES PESTO	1.00	14.00	12.00	t
3159	1079	\N	POLPETTE	2.00	15.00	12.00	t
3160	1079	\N	CHIARETTO	1.00	19.00	21.00	t
3173	1082	\N	SERVICE Caro	-1.00	-50.00	0.00	t
3176	1085	\N	Louna	-1.00	-50.00	0.00	t
3179	1088	\N	Fred	-1.00	-400.00	0.00	t
3182	1091	\N	NOURRITURE	-1.00	-19.73	0.00	t
3185	1094	\N	CAFÉ	2.00	2.50	21.00	f
3186	1094	\N	CREME BRULEE	2.00	5.00	12.00	f
3187	1094	\N	TAJINE	2.00	15.00	12.00	f
3188	1094	\N	SCAMPIS LUCIFER	1.00	10.00	12.00	f
3189	1094	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
3192	1097	\N	COUSCOUS PM	2.00	15.00	6.00	f
3198	1100	\N	CARBURANT	-1.00	-446.06	0.00	t
3201	1103	\N	CORNET BOLO	1.00	6.00	6.00	f
3207	1106	\N	ROSÉ VERRE	2.00	0.00	21.00	f
3208	1106	\N	PÂTES STRACIATELLA	1.00	13.00	12.00	f
3209	1106	\N	PÂTES STRACIATELLA SCAMPIS	2.00	17.00	12.00	f
3210	1106	\N	PINOT GRIGIO BLUSH	1.00	19.00	21.00	f
3221	1109	\N	CREME BRULEE	2.00	5.00	12.00	f
3222	1109	\N	APPASSIMENTO	2.00	6.00	21.00	f
3223	1109	\N	JUPILER	1.00	2.50	21.00	f
3224	1109	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	f
3225	1109	\N	COUSCOUS PM	1.00	15.00	12.00	f
3226	1109	\N	PROSECCO VERRE	1.00	5.00	21.00	f
3227	1109	\N	VIOLETTE	1.00	6.00	21.00	f
3233	1112	\N	NOURRITURE	-1.00	-30.00	0.00	t
3237	1115	\N	BLANC VERRE	1.00	5.00	21.00	f
1455	483	\N	NOURRITURE	-1.00	-51.57	0.00	t
1459	486	\N	CORNET BOLO	1.00	6.00	6.00	t
1460	486	\N	CORNET LARD	1.00	6.00	6.00	t
1463	489	\N	CREME BRULEE	1.00	5.00	12.00	t
1464	489	\N	GATEAUX MIEL	1.00	5.00	12.00	t
1465	489	\N	VIN 1/2	1.00	13.00	21.00	t
1466	489	\N	POLPETTE	1.00	14.00	12.00	t
1467	489	\N	COUSCOUS PM	1.00	15.00	12.00	t
1475	492	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
1476	492	\N	POLPETTE	1.00	14.00	12.00	t
1477	492	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
1478	492	\N	PÂTES SCAMPIS	1.00	15.00	12.00	t
1479	492	\N	PINOT GRIGIO (2020)	2.00	19.00	21.00	t
1480	492	\N	CORNET LARD	1.00	6.00	6.00	t
1487	495	\N	COUSCOUS PM	3.00	15.00	6.00	f
1495	498	\N	BLANC VERRE	3.00	5.00	21.00	t
1496	498	\N	ROSÉ VERRE	1.00	5.00	21.00	t
1497	498	\N	SOFT (Verre)	1.00	2.00	21.00	t
1498	498	\N	PROSECCO VERRE	1.00	5.00	21.00	t
1499	498	\N	MAISON	1.00	6.00	21.00	t
1500	498	\N	THÉ MENTHE	1.00	2.50	21.00	t
1501	498	\N	IRISH COFFEE	1.00	8.00	21.00	t
1502	498	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
1503	498	\N	BURRATINA	1.00	14.00	12.00	t
1504	498	\N	COUSCOUS VG	1.00	10.00	12.00	t
1505	498	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	t
1506	498	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	t
1507	498	\N	BURRATINA (1X50GR)	1.00	8.00	12.00	t
1515	501	\N	SERVICE	-1.00	-70.00	0.00	t
1518	504	\N	NOURRITURE	-1.00	-15.56	0.00	t
1523	507	\N	BLONDINETTE	1.00	3.50	21.00	f
1524	507	\N	ROSÉ VERRE	3.00	5.00	21.00	f
1528	510	\N	CORNET TRUFFE	1.00	7.00	6.00	f
1529	510	\N	CORNET LARD	3.00	6.00	6.00	f
1533	513	\N	SOFT (Verre)	1.00	2.00	21.00	t
1534	513	\N	POLPETTE	1.00	14.00	12.00	t
1535	513	\N	COUSCOUS PM	1.00	15.00	12.00	t
1536	513	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
1537	513	\N	PECKET FRAISE	2.00	6.00	21.00	t
1538	514	\N	VIN 1/2	1.00	13.00	21.00	f
1539	514	\N	POLPETTE	1.00	14.00	12.00	t
1540	514	\N	BURRATINA	1.00	14.00	12.00	t
1541	514	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	t
1542	515	\N	IRISH COFFEE	1.00	8.00	21.00	f
1543	515	\N	PÂTES TRUFFE	1.00	17.00	12.00	f
1544	515	\N	BURRATINA	1.00	14.00	12.00	f
1545	515	\N	TCHAKTCHOUKA	1.00	8.00	12.00	f
1546	515	\N	VIOLETTE	1.00	6.00	21.00	f
1547	516	\N	CHIARETTO	1.00	13.00	21.00	f
1548	516	\N	SPAG.COURG.SCAMP.	2.00	16.00	12.00	f
1549	516	\N	SCAMPIS LUCIFER	1.00	15.00	12.00	t
1550	516	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
1551	516	\N	PÂTES BOLO/LARD	3.00	12.00	12.00	f
1552	516	\N	BURRATINA	1.00	14.00	12.00	t
1553	516	\N	ASSIETTE APERITIVE (2 p.)	2.00	19.00	12.00	f
1554	516	\N	EAUX 1 L	1.00	5.00	21.00	t
1555	516	\N	TRIPLE SAINTE NITOUCHE	4.00	4.50	21.00	t
1556	516	\N	PECKET FRAISE	2.00	6.00	21.00	t
1557	516	\N	VIOLETTE	3.00	6.00	21.00	f
1558	517	\N	THÉ MENTHE	2.00	2.50	21.00	f
1559	517	\N	CAFÉ	1.00	2.50	21.00	f
1560	517	\N	IRISH COFFEE	2.00	8.00	21.00	f
1561	517	\N	SOFT (Verre)	1.00	2.00	21.00	f
1562	517	\N	ORVAL	1.00	4.50	21.00	f
1563	517	\N	GRAPPA	1.00	5.00	21.00	f
1564	518	\N	SERVICE	-1.00	-50.00	0.00	f
1565	519	\N	NOURRITURE	-1.00	-27.58	0.00	t
1566	520	\N	NOURRITURE	-1.00	-36.39	0.00	t
1567	521	\N	NOURRITURE	-1.00	-68.35	0.00	t
1568	522	\N	CORNET BOLO	1.00	6.00	6.00	t
1569	523	\N	CAPUCCINO	1.00	2.80	21.00	f
1570	523	\N	PÂTES SCAMPIS	1.00	15.00	12.00	t
1571	523	\N	COUSCOUS PM	2.00	15.00	12.00	f
1572	523	\N	BLANC VERRE	3.00	5.00	21.00	f
1573	524	\N	NOURRITURE	-1.00	-28.65	0.00	t
1574	525	\N	CORNET TRUFFE	1.00	7.00	6.00	t
1575	526	\N	NOURRITURE	-1.00	-55.13	0.00	t
1576	527	\N	ROSÉ VERRE	3.00	5.00	21.00	f
1577	527	\N	POTEE AUX CHOUX	1.00	15.00	12.00	f
1578	527	\N	PROSECCO VERRE	2.00	5.00	21.00	f
1579	528	\N	PINOT GRIGIO (2020)	2.00	19.00	21.00	f
1580	528	\N	PRIMITIVO NR 14	3.00	24.00	21.00	f
1581	528	\N	VIOLETTE	1.00	6.00	21.00	f
1582	528	\N	BLANC VERRE	1.00	5.00	21.00	f
1583	528	\N	JUPILER	2.00	2.50	21.00	f
1584	528	\N	POLPETTE	1.00	14.00	12.00	f
1585	528	\N	COUSCOUS PM	5.00	15.00	12.00	f
1586	529	\N	CORNET BOLO	1.00	6.00	6.00	t
1587	530	\N	COUSCOUS PM	2.00	13.50	6.00	f
1588	531	\N	COUSCOUS PM	1.00	13.50	6.00	f
1589	532	\N	NOURRITURE	-1.00	-3.35	0.00	t
1590	533	\N	COUSCOUS PM	2.00	13.50	6.00	f
1591	534	\N	CORNET LARD	1.00	6.00	6.00	t
1592	535	\N	CAFÉ	2.00	2.50	21.00	f
1593	535	\N	EAUX 1 L	2.00	5.00	21.00	f
1594	535	\N	COUSCOUS PM	2.00	15.00	12.00	f
1595	536	\N	CHIARETTO	1.00	19.00	21.00	f
1596	536	\N	CORNET BOLO	1.00	6.00	6.00	f
1597	536	\N	CORNET LARD	3.00	6.00	6.00	t
1598	536	\N	PINOT GRIGIO (2020)	3.00	19.00	21.00	t
1599	536	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
1600	536	\N	JUPILER	4.00	2.50	21.00	t
1601	536	\N	CORNET BOLO	1.00	6.00	6.00	t
1602	536	\N	CORNET LARD	1.00	6.00	6.00	t
1603	537	\N	SOFT (Verre)	1.00	2.00	21.00	t
1604	537	\N	JUPILER	1.00	2.50	21.00	t
1605	538	\N	BLONDINETTE	2.00	3.50	21.00	f
1606	539	\N	PRIMITIVO NR 14	3.00	24.00	21.00	t
1607	539	\N	PINOT GRIGIO (2020)	1.00	19.00	21.00	t
1608	539	\N	JUPILER	1.00	2.50	21.00	t
1609	539	\N	TRIPLE SAINTE NITOUCHE	1.00	4.50	21.00	t
1610	539	\N	GINGEMBRE	2.00	6.00	21.00	t
1611	539	\N	Cuba-Li	1.00	6.00	21.00	t
1612	539	\N	PROSECCO VERRE	2.00	5.00	21.00	t
1613	539	\N	SOFT (Verre)	2.00	2.00	21.00	t
1614	539	\N	THÉ MENTHE	3.00	2.50	21.00	t
1615	539	\N	GLACE	1.00	5.00	12.00	t
1616	539	\N	GATEAUX MIEL	1.00	5.00	12.00	t
1617	539	\N	CREME BRULEE	5.00	5.00	12.00	t
1618	539	\N	COUSCOUS PM	1.00	15.00	12.00	t
1619	539	\N	BURRATINA	1.00	14.00	12.00	t
1620	539	\N	COUSCOUS PM	2.00	15.00	12.00	t
1621	539	\N	COUSCOUS VG	1.00	10.00	12.00	t
1622	539	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
1623	539	\N	POLPETTE	2.00	14.00	12.00	t
1624	539	\N	PÂTES BOLO/LARD	2.00	12.00	12.00	t
1625	539	\N	TCHAKTCHOUKA	1.00	8.00	12.00	t
1626	539	\N	ASSIETTE APERITIVE (2 p.)	2.00	19.00	12.00	t
1627	539	\N	BURRATINA (1X50GR)	1.00	8.00	12.00	t
1631	542	\N	COUSCOUS PM	2.00	13.50	6.00	t
1647	545	\N	BLANC VERRE	3.00	5.00	21.00	f
1648	545	\N	Cuba-Li	14.00	6.00	21.00	f
1651	548	\N	SERVICE	-1.00	-50.00	0.00	t
1654	551	\N	SERVICE	-1.00	-20.00	0.00	t
1657	554	\N	NOURRITURE	-1.00	-29.25	0.00	t
1660	557	\N	COUSCOUS PM	2.00	13.50	6.00	t
1664	560	\N	TVA	-1.00	-533.33	0.00	t
1667	563	\N	ENERGIES	-1.00	-200.73	0.00	t
1670	566	\N	ENERGIES REGUL	-1.00	-402.72	0.00	t
1673	569	\N	ASSURANCE	-1.00	-114.17	0.00	t
1676	572	\N	CARBURANT	-1.00	-124.31	0.00	t
1679	575	\N	UNIF	-1.00	-242.00	0.00	t
1682	578	\N	ORANGE	-1.00	-129.00	0.00	t
1685	581	\N	BLANC VERRE	3.00	5.00	21.00	t
1686	581	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
1687	581	\N	VIOLETTE	2.00	6.00	21.00	t
1692	584	\N	DIVERS	-1.00	-117.00	0.00	t
1695	587	\N	CARBURANT	-1.00	-108.52	0.00	t
1699	590	\N	BLONDINETTE	1.00	3.50	21.00	t
1700	590	\N	BLANC VERRE	1.00	5.00	21.00	t
1701	590	\N	POLPETTE	1.00	14.00	12.00	t
1702	590	\N	COUSCOUS PM	1.00	15.00	12.00	t
1703	590	\N	VIOLETTE	1.00	6.00	21.00	t
1704	590	\N	TRIPLE SAINTE NITOUCHE	1.00	4.50	21.00	t
1714	593	\N	CREME BRULEE	1.00	5.00	12.00	f
1715	593	\N	Cuba-Li	1.00	6.00	21.00	f
1716	593	\N	SOFT (Verre)	2.00	2.00	21.00	f
1717	593	\N	PÂTES TRUFFE	1.00	17.00	12.00	f
1718	593	\N	POLPETTE	1.00	14.00	12.00	f
1727	596	\N	CREME BRULEE	2.00	5.00	12.00	f
1728	596	\N	POLPETTE	1.00	14.00	12.00	f
1729	596	\N	POTEE AUX CHOUX	1.00	15.00	12.00	f
1730	596	\N	CASELLETTI	1.00	30.00	21.00	f
1739	599	\N	BLANC VERRE	1.00	5.00	21.00	t
1740	599	\N	POLPETTE	1.00	14.00	12.00	t
1741	599	\N	COUSCOUS PM	1.00	15.00	12.00	t
1742	599	\N	VIOLETTE	1.00	6.00	21.00	t
1743	599	\N	TRIPLE SAINTE NITOUCHE	1.00	4.50	21.00	t
1744	599	\N	BLONDINETTE	1.00	3.50	21.00	t
1748	602	\N	NOURRITURE	-1.00	-20.00	0.00	t
1751	605	\N	POTEE AUX CHOUX	2.00	15.00	6.00	t
1752	605	\N	ORVAL	2.00	5.00	21.00	t
1763	608	\N	LIMONCELLO	1.00	5.00	21.00	t
1766	611	\N	SERVICE	-1.00	-50.00	0.00	t
1769	614	\N	JUPILER	7.00	2.50	21.00	f
1770	614	\N	BLANC VERRE	3.00	5.00	21.00	f
1771	614	\N	TRIPLE SAINTE NITOUCHE	8.00	4.00	21.00	f
1778	617	\N	CORNET LARD	1.00	5.00	6.00	t
1779	617	\N	BLANC VERRE	2.00	5.00	21.00	t
1780	617	\N	BLONDINETTE	3.00	3.50	21.00	t
1788	620	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	f
1789	620	\N	CREME BRULEE	1.00	5.00	12.00	f
1790	620	\N	COUSCOUS PM	1.00	15.00	12.00	f
1791	620	\N	BLANC VERRE	1.00	5.00	21.00	f
1792	620	\N	PROSECCO VERRE	2.00	5.00	21.00	f
1803	623	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	t
1804	623	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	t
1805	623	\N	VIOLETTE	1.00	6.00	21.00	t
1806	623	\N	COUSCOUS PM	2.00	15.00	12.00	t
1807	623	\N	SOFT (Verre)	1.00	2.00	21.00	t
1810	626	\N	NOURRITURE	-1.00	-11.54	0.00	t
1819	629	\N	ORVAL	2.00	5.00	21.00	t
1820	629	\N	EAUX 1 L	1.00	5.00	21.00	t
1821	629	\N	COUSCOUS PM	1.00	15.00	12.00	t
1822	629	\N	POLPETTE	2.00	14.00	12.00	t
1825	632	\N	COUSCOUS PM	1.00	13.50	6.00	f
1828	635	\N	CARBURANT	-1.00	-117.93	0.00	t
1831	638	\N	CORNET BOLO	1.00	6.00	6.00	f
1832	638	\N	CORNET LARD	2.00	6.00	6.00	f
1833	638	\N	COUSCOUS PM	1.00	13.50	6.00	f
1837	641	\N	TROTINETTE	-1.00	-100.00	0.00	t
1840	644	\N	BLONDINETTE	2.00	3.50	21.00	f
2980	1032	\N	PINOT GRIGIO (2020)	1.00	19.00	21.00	f
2981	1032	\N	TAJINE	2.00	15.00	12.00	f
2982	1032	\N	GRAPPA	2.00	0.00	21.00	f
2983	1032	\N	IRISH COFFEE	1.00	8.00	21.00	f
2984	1032	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	f
2985	1032	\N	TCHAKTCHOUKA	2.00	10.00	12.00	f
2986	1032	\N	PROSECCO VERRE	2.00	5.00	21.00	f
2989	1035	\N	NOURRITURE	-1.00	-66.78	0.00	t
2999	1038	\N	CAFÉ	1.00	2.50	21.00	t
3000	1038	\N	PANNA COTTA	1.00	5.00	12.00	t
3001	1038	\N	CREME BRULEE	1.00	5.00	12.00	t
3002	1038	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
3003	1038	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
3007	1041	\N	Taxes Liège	-1.00	-58.00	0.00	t
3010	1044	\N	NOURRITURE	-1.00	-34.45	0.00	t
3013	1047	\N	PROSECCO VERRE	1.00	5.00	21.00	t
3014	1047	\N	Cuba-Li	1.00	6.00	21.00	t
3015	1047	\N	GIN TONIC	1.00	6.00	21.00	t
3016	1047	\N	CHOUFFE COFFEE	1.00	8.00	21.00	t
3033	1050	\N	PINOT GRIGIO (2020)	1.00	19.00	21.00	t
3034	1050	\N	EAUX 1 L	1.00	5.00	21.00	t
3035	1050	\N	PROSECCO VERRE	5.00	5.00	21.00	t
3036	1050	\N	GINGEMBRE	1.00	6.00	21.00	t
3037	1050	\N	VIOLETTE	4.00	6.00	21.00	t
3038	1050	\N	SOFT (Verre)	5.00	2.00	21.00	t
3039	1050	\N	SABAYON	2.00	8.00	12.00	t
3040	1050	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
3041	1050	\N	PÂTES TRUFFE	2.00	17.00	12.00	t
3042	1050	\N	COUSCOUS VG	1.00	10.00	12.00	t
3043	1050	\N	COUSCOUS PM	2.00	15.00	12.00	t
3044	1050	\N	ASSIETTE APERITIVE (2 p.)	3.00	19.00	12.00	t
3045	1050	\N	PÂTES BOLO/LARD	6.00	12.00	12.00	t
3046	1050	\N	THÉ MENTHE	2.00	2.50	21.00	t
3047	1050	\N	GLACE	7.00	5.00	12.00	t
3048	1050	\N	IRISH COFFEE	1.00	8.00	21.00	t
1628	540	\N	JUPILER	1.00	2.50	21.00	f
1632	543	\N	PÂTES SCAMPIS	1.00	15.00	12.00	t
1633	543	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
1634	543	\N	PÂTES TRUFFE	2.00	17.00	12.00	t
1635	543	\N	TCHAKTCHOUKA	1.00	14.00	12.00	t
1649	546	\N	NOURRITURE	-1.00	-36.26	0.00	t
1652	549	\N	SERVICE	-1.00	-50.00	0.00	t
1655	552	\N	NOURRITURE	-1.00	-121.70	0.00	t
1658	555	\N	NOURRITURE	-1.00	-31.40	0.00	t
1661	558	\N	CORNET LARD	1.00	6.00	6.00	t
1665	561	\N	Taxe Circulation	-1.00	-486.02	0.00	t
1668	564	\N	NOURRITURE	-1.00	-100.00	0.00	t
1671	567	\N	CARBURANT	-1.00	-115.83	0.00	t
1674	570	\N	CARBURANT	-1.00	-116.20	0.00	t
1677	573	\N	DIVERS	-1.00	-90.00	0.00	t
1680	576	\N	UNIF	-1.00	-500.00	0.00	t
1683	579	\N	CORNET LARD	1.00	6.00	6.00	t
1688	582	\N	CORNET BOLO	1.00	6.00	6.00	t
1689	582	\N	CORNET TRUFFE	1.00	7.00	6.00	t
1690	582	\N	CORNET LARD	1.00	6.00	6.00	t
1693	585	\N	DIVERS	-1.00	-48.50	0.00	t
1696	588	\N	Fred	-1.00	-400.00	0.00	t
1705	591	\N	COUSCOUS PM	2.00	15.00	12.00	t
1706	591	\N	ROUGE VERRE	1.00	5.00	21.00	t
1707	591	\N	BLANC VERRE	1.00	5.00	21.00	t
1708	591	\N	PECKET FRAISE	1.00	6.00	21.00	t
1709	591	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
1719	594	\N	BLANC VERRE	1.00	5.00	21.00	t
1720	594	\N	SOFT (Verre)	1.00	2.00	21.00	t
1721	594	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
1722	594	\N	POLPETTE	1.00	14.00	12.00	t
1723	594	\N	PÂTES TRUFFE	2.00	17.00	12.00	t
1724	594	\N	PECKET FRAISE	3.00	6.00	21.00	t
1731	597	\N	COUSCOUS PM	2.00	15.00	12.00	t
1732	597	\N	BLANC VERRE	2.00	5.00	21.00	t
1733	597	\N	PECKET FRAISE	1.00	6.00	21.00	t
1734	597	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
1745	600	\N	TRIPLE SAINTE NITOUCHE	1.00	4.50	21.00	t
1746	600	\N	GRAPPA	2.00	5.00	21.00	t
1749	603	\N	NOURRITURE	-1.00	-11.66	0.00	t
1753	606	\N	PRIMITIVO NR 14	1.00	20.00	21.00	f
1764	609	\N	COUSCOUS PM	1.00	13.50	6.00	t
1767	612	\N	DAMBIERMONT	-1.00	-337.06	0.00	t
1772	615	\N	BLONDINETTE	4.00	3.50	21.00	f
1773	615	\N	CORNET BOLO	2.00	5.00	6.00	f
1774	615	\N	CAFÉ	1.00	2.50	21.00	f
1775	615	\N	BLANC VERRE	2.00	5.00	21.00	f
1776	615	\N	SOFT (Verre)	2.00	2.00	21.00	f
1781	618	\N	ROUGE VERRE	4.00	5.00	21.00	t
1782	618	\N	BLANC VERRE	2.00	5.00	21.00	t
1783	618	\N	JUPILER	3.00	2.50	21.00	t
1784	618	\N	CORNET LARD	4.00	5.00	6.00	t
1785	618	\N	SOFT (Verre)	1.00	2.00	21.00	t
1786	618	\N	BLONDINETTE	1.00	3.50	21.00	t
1793	621	\N	COUSCOUS PM	1.00	15.00	12.00	t
1794	621	\N	COUSCOUS VG	1.00	10.00	12.00	t
1795	621	\N	SOFT (Verre)	2.00	2.00	21.00	t
1796	621	\N	PECKET FRAISE	1.00	6.00	21.00	t
1808	624	\N	NOURRITURE	-1.00	-32.38	0.00	t
1811	627	\N	NOURRITURE	-1.00	-6.16	0.00	t
1823	630	\N	SERVICE Célia	-1.00	-50.00	0.00	t
1826	633	\N	SOUS-VIDEUSE	-1.00	-74.00	0.00	t
1829	636	\N	LOYER	-1.00	-600.00	0.00	t
1834	639	\N	SOFT (Verre)	1.00	2.00	21.00	t
1835	639	\N	CORNET LARD	1.00	6.00	6.00	t
1838	642	\N	CORNET BOLO	1.00	6.00	6.00	f
3049	1050	\N	CREME BRULEE	1.00	5.00	12.00	t
3050	1050	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	t
3051	1050	\N	PÂTES SPÉCIALES	1.00	16.00	12.00	t
3062	1053	\N	BOISSONS	-1.00	-140.00	0.00	t
3065	1056	\N	SERVICE	-1.00	50.00	0.00	t
3068	1059	\N	SERVICE Célia	-1.00	-20.00	0.00	t
3074	1062	\N	CORNET LARD	1.00	6.00	6.00	t
3077	1065	\N	CAFÉ	2.00	0.00	21.00	f
3078	1065	\N	CAFÉ	1.00	2.50	21.00	t
3079	1065	\N	THÉ MENTHE	2.00	2.50	21.00	t
3080	1065	\N	PANNA COTTA	1.00	5.00	12.00	f
3081	1065	\N	CREME BRULEE	1.00	5.00	12.00	f
3082	1065	\N	BURRATINA TRUFFES	1.00	17.00	12.00	t
3083	1065	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
3084	1065	\N	COUSCOUS VG	1.00	10.00	12.00	f
3085	1065	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
3086	1065	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
3087	1065	\N	BLANC VERRE	1.00	5.00	21.00	f
3101	1068	\N	CORNET LARD	2.00	6.00	6.00	t
3102	1068	\N	CORNET BOLO	1.00	6.00	6.00	t
3116	1071	\N	SERVICE Caro	-1.00	-50.00	0.00	t
3134	1074	\N	COUSCOUS PM	1.00	15.00	6.00	f
3145	1077	\N	CAFÉ	2.00	2.50	21.00	f
3146	1077	\N	IRISH COFFEE	1.00	8.00	21.00	f
3147	1077	\N	TATIN	3.00	8.00	12.00	f
3148	1077	\N	SOFT (Verre)	2.00	2.00	21.00	f
3149	1077	\N	CHIARETTO 1/2	2.00	12.00	21.00	f
3150	1077	\N	PECKET FRAISE	1.00	6.00	21.00	f
3151	1077	\N	PÂTES PESTO	1.00	14.00	12.00	f
3152	1077	\N	POLPETTE	2.00	15.00	12.00	f
3153	1077	\N	SCAMPIS LUCIFER	2.00	10.00	12.00	f
3161	1080	\N	CREME BRULEE	2.00	5.00	12.00	f
3162	1080	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
3163	1080	\N	CAFÉ	1.00	2.50	21.00	f
3164	1080	\N	PROSECCO VERRE	2.00	5.00	21.00	f
3165	1080	\N	PÂTES PESTO	1.00	14.00	12.00	f
3166	1080	\N	BURRATINA TRUFFES	1.00	17.00	12.00	f
3167	1080	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
3174	1083	\N	Service Véro	-1.00	-30.00	0.00	t
3177	1086	\N	NOURRITURE	-1.00	-226.84	0.00	t
3180	1089	\N	ENERGIES	-1.00	-146.25	0.00	t
3183	1092	\N	NOURRITURE	-1.00	-21.00	0.00	t
3190	1095	\N	NOURRITURE	-1.00	-105.03	0.00	t
3193	1098	\N	NOURRITURE	-1.00	-41.53	0.00	t
3199	1101	\N	NOURRITURE	-1.00	-27.00	0.00	t
3202	1104	\N	BLANC VERRE	1.00	5.00	21.00	t
3203	1104	\N	JUPILER	1.00	2.50	21.00	t
3204	1104	\N	CAFÉ	1.00	2.50	21.00	t
3205	1104	\N	PINOT GRIGIO BLUSH	1.00	19.00	21.00	t
3211	1107	\N	GIN TONIC	1.00	0.00	21.00	t
3212	1107	\N	VIOLETTE	1.00	6.00	21.00	t
3213	1107	\N	GIN TONIC	4.00	6.00	21.00	t
3214	1107	\N	SOFT (Verre)	2.00	2.00	21.00	t
1629	541	\N	SOFT (Verre)	3.00	2.00	21.00	f
1630	541	\N	COUSCOUS PM	1.00	15.00	12.00	t
1636	544	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
1637	544	\N	EAUX 1 L	1.00	5.00	21.00	f
1638	544	\N	POLPETTE	1.00	14.00	12.00	f
1639	544	\N	SPAG.COURG.SCAMP.	1.00	16.00	12.00	f
1640	544	\N	PÂTES STRACIATELLA SCAMPIS	1.00	17.00	12.00	f
1641	544	\N	COUSCOUS PM	1.00	15.00	12.00	t
1642	544	\N	PÂTES SCAMPIS	1.00	15.00	12.00	f
1643	544	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
1644	544	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
1645	544	\N	ASSIETTE APERITIVE (2 p.)	2.00	19.00	12.00	t
1646	544	\N	BURRATINA (1X50GR)	1.00	8.00	12.00	t
1650	547	\N	SERVICE	-1.00	-50.00	0.00	t
1653	550	\N	SERVICE	-1.00	-20.00	0.00	t
1656	553	\N	NOURRITURE	-1.00	-71.05	0.00	t
1659	556	\N	CORNET LARD	1.00	6.00	6.00	t
1662	559	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
1663	559	\N	PROSECCO VERRE	2.00	5.00	21.00	t
1666	562	\N	CARBURANT	-1.00	-113.63	0.00	t
1669	565	\N	NOURRITURE	-1.00	-25.00	0.00	t
1672	568	\N	CARBURANT	-1.00	-117.23	0.00	t
1675	571	\N	DIVERS	-1.00	-25.00	0.00	t
1678	574	\N	CARBURANT	-1.00	-116.36	0.00	t
1681	577	\N	CARBURANT	-1.00	-110.66	0.00	t
1684	580	\N	NOURRITURE	-1.00	-4.90	0.00	t
1691	583	\N	CORNET BOLO	1.00	6.00	6.00	t
1694	586	\N	DIVERS	-1.00	-39.00	0.00	t
1697	589	\N	TRIPLE SAINTE NITOUCHE	1.00	4.50	21.00	t
1698	589	\N	GRAPPA	2.00	5.00	21.00	t
1710	592	\N	CREME BRULEE	1.00	5.00	12.00	t
1711	592	\N	ROUGE VERRE	1.00	5.00	21.00	t
1712	592	\N	BLANC VERRE	1.00	5.00	21.00	t
1713	592	\N	SPAG.COURG.SCAMP.	1.00	12.00	12.00	t
1725	595	\N	BLONDINETTE	3.00	3.50	21.00	t
1726	595	\N	JUPILER	5.00	2.50	21.00	t
1735	598	\N	ROUGE VERRE	1.00	5.00	21.00	t
1736	598	\N	CREME BRULEE	1.00	5.00	12.00	t
1737	598	\N	SPAG.COURG.SCAMP.	1.00	12.00	12.00	t
1738	598	\N	BLANC VERRE	1.00	5.00	21.00	t
1747	601	\N	SERVICE	-1.00	-50.00	0.00	t
1750	604	\N	COUSCOUS PM	2.00	13.50	6.00	f
1754	607	\N	GLACE	1.00	5.00	12.00	f
1755	607	\N	IRISH COFFEE	1.00	8.00	21.00	f
1756	607	\N	VIOLETTE	1.00	6.00	21.00	f
1757	607	\N	BLANC VERRE	1.00	5.00	21.00	f
1758	607	\N	TCHAKTCHOUKA	2.00	8.00	12.00	f
1759	607	\N	ROUGE VERRE	2.00	5.00	21.00	f
1760	607	\N	VIOLETTE	1.00	6.00	21.00	f
1761	607	\N	BURRATINA	1.00	14.00	12.00	f
1762	607	\N	POLPETTE	1.00	14.00	12.00	f
1765	610	\N	ORVAL-RHUM	-1.00	-325.00	0.00	t
1768	613	\N	CHAUSSURES JULIE	-1.00	-50.00	0.00	t
1777	616	\N	JUPILER	3.00	2.50	21.00	t
1787	619	\N	JUPILER	1.00	2.50	21.00	f
1797	622	\N	COUSCOUS PM	2.00	15.00	12.00	t
1798	622	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
1799	622	\N	SOFT (Verre)	3.00	2.00	21.00	t
1800	622	\N	GATEAUX MIEL	1.00	5.00	12.00	t
1801	622	\N	CREME BRULEE	1.00	5.00	12.00	t
1802	622	\N	IRISH COFFEE	1.00	8.00	21.00	t
1809	625	\N	NOURRITURE	-1.00	-29.04	0.00	t
1812	628	\N	THÉ MENTHE	1.00	2.50	21.00	t
1813	628	\N	PROSECCO VERRE	2.00	5.00	21.00	t
1814	628	\N	VIOLETTE	1.00	6.00	21.00	t
1815	628	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
1816	628	\N	COUSCOUS PM	1.00	15.00	12.00	t
1817	628	\N	POLPETTE	1.00	14.00	12.00	t
1818	628	\N	CREME BRULEE	2.00	5.00	12.00	t
1824	631	\N	NOURRITURE	-1.00	-12.10	0.00	t
1827	634	\N	CORNET LARD	1.00	6.00	6.00	f
1830	637	\N	CARBURANT	-1.00	-113.92	0.00	t
1836	640	\N	JUPILER	1.00	2.00	21.00	f
1839	643	\N	CORNET LARD	1.00	6.00	6.00	f
1841	645	\N	AFSCA	-1.00	-202.22	0.00	t
1842	646	\N	ENERGIES	-1.00	-237.46	0.00	t
1843	647	\N	SERVICE	-1.00	-50.00	0.00	t
1844	648	\N	ROUGE VERRE	2.00	5.00	21.00	f
1845	648	\N	EAU 1/2 L	1.00	3.50	21.00	f
1846	648	\N	PÂTES SCAMPIS	1.00	15.00	12.00	f
1847	648	\N	VIOLETTE	2.00	6.00	21.00	f
1848	649	\N	IRISH COFFEE	1.00	8.00	21.00	f
1849	649	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	f
1850	649	\N	POLPETTE	1.00	14.00	12.00	f
1851	649	\N	CAFÉ	1.00	2.50	21.00	f
1852	649	\N	VIN 1/2	1.00	10.00	21.00	f
1853	649	\N	SOFT (Verre)	1.00	2.00	21.00	f
1854	649	\N	EAU 1/2 L	1.00	3.50	21.00	f
1855	649	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	f
1856	649	\N	CREME BRULEE	1.00	5.00	12.00	f
1857	650	\N	POTEE AUX CHOUX	1.00	15.00	12.00	t
1858	650	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
1859	650	\N	JUPILER	3.00	2.00	21.00	t
1860	651	\N	BOMBE  CALABRÈSE	2.00	15.00	12.00	f
1861	651	\N	ESPRESSO	1.00	2.50	21.00	f
1862	651	\N	CAFÉ	1.00	2.50	21.00	f
1863	651	\N	CASELLETTI	1.00	30.00	21.00	f
1864	651	\N	PROSECCO VERRE	4.00	5.00	21.00	f
1865	652	\N	JUPILER	2.00	2.00	21.00	f
1866	653	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
1867	654	\N	BLANC VERRE	1.00	5.00	21.00	f
1868	654	\N	SOFT (Verre)	1.00	2.00	21.00	f
1869	654	\N	PÂTES SCAMPIS	1.00	15.00	12.00	f
1870	654	\N	POLPETTE	1.00	14.00	12.00	f
1871	655	\N	CASELLETTI	1.00	30.00	21.00	t
1872	655	\N	CREME BRULEE	1.00	5.00	12.00	t
1873	655	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
1874	655	\N	COUSCOUS PM	2.00	15.00	12.00	t
1875	656	\N	CREME BRULEE	1.00	5.00	12.00	t
1876	656	\N	COUSCOUS PM	1.00	15.00	12.00	t
1877	657	\N	CORNET BOLO	1.00	6.00	6.00	t
1878	657	\N	CREME BRULEE	1.00	5.00	12.00	t
1879	657	\N	PÂTES STRACIATELLA SCAMPIS	1.00	17.00	12.00	t
1880	657	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
1881	658	\N	THÉ MENTHE	1.00	2.50	21.00	t
1882	658	\N	BLONDINETTE	1.00	3.50	21.00	t
1883	658	\N	AMARETTO	1.00	5.00	21.00	t
1884	658	\N	GATEAUX MIEL	1.00	5.00	12.00	t
1885	658	\N	BURRATINA	2.00	14.00	12.00	t
1886	658	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
1887	658	\N	PECKET FRAISE	1.00	6.00	21.00	t
1888	658	\N	VIOLETTE	1.00	6.00	21.00	t
1889	658	\N	GINGEMBRE	1.00	6.00	21.00	t
1904	661	\N	CHIARETTO	1.00	19.00	21.00	f
1905	661	\N	ESPRESSO	1.00	2.50	21.00	f
1906	661	\N	GATEAUX MIEL	1.00	5.00	12.00	f
1907	661	\N	COUSCOUS PM	2.00	15.00	12.00	f
1910	664	\N	SERVICE Caro	-1.00	-60.00	0.00	t
1913	667	\N	NOURRITURE	-1.00	-21.15	0.00	t
1917	670	\N	CAFÉ	1.00	2.50	21.00	f
1918	670	\N	ROUGE VERRE	2.00	5.00	21.00	f
1919	670	\N	SAMBUCA	1.00	5.00	21.00	f
1920	670	\N	GATEAUX MIEL	1.00	5.00	12.00	t
1921	670	\N	PÂTES SCAMPIS	1.00	15.00	12.00	t
1922	670	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
1936	673	\N	CAFÉ	1.00	2.50	21.00	f
1937	673	\N	CAPUCCINO	3.00	2.80	21.00	f
1938	673	\N	RHUM HAVANA	1.00	6.00	21.00	f
1939	673	\N	PRIMITIVO NR 14	3.00	24.00	21.00	f
1940	673	\N	IRISH COFFEE	3.00	8.00	21.00	f
1941	673	\N	CREME BRULEE	1.00	5.00	12.00	f
1942	673	\N	POLPETTE	1.00	14.00	12.00	f
1943	673	\N	PÂTES TRUFFE	2.00	17.00	12.00	f
1944	673	\N	COUSCOUS PM	9.00	15.00	12.00	f
1945	673	\N	TCHAKTCHOUKA	1.00	8.00	12.00	f
1946	673	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
1947	673	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	f
1948	673	\N	CHAMPIGNONS KABYLES	2.00	6.00	12.00	f
1949	673	\N	BLANC VERRE	2.00	5.00	21.00	f
1950	673	\N	SOFT (Verre)	5.00	2.00	21.00	f
1951	673	\N	PROSECCO VERRE	1.00	5.00	21.00	f
1952	673	\N	VIOLETTE	4.00	6.00	21.00	f
1953	673	\N	GINGEMBRE	3.00	6.00	21.00	f
1954	673	\N	PECKET FRAISE	1.00	6.00	21.00	f
1955	673	\N	Cuba-Li	5.00	6.00	21.00	f
1956	673	\N	GIN TONIC	2.00	6.00	21.00	f
1959	676	\N	NOURRITURE	-1.00	-15.90	0.00	t
1962	679	\N	SODEXO	-1.00	-90.00	0.00	t
1968	682	\N	VINS	-1.00	-126.00	0.00	t
1972	685	\N	SPAG.COURG.SCAMP.	1.00	16.00	12.00	t
1973	685	\N	CREME BRULEE	1.00	0.00	12.00	t
1974	685	\N	ROUGE VERRE	3.00	5.00	21.00	t
1975	685	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
1984	688	\N	CAFÉ	1.00	2.50	21.00	t
1985	688	\N	COUSCOUS PM	1.00	15.00	12.00	t
1986	688	\N	EAU 1/2 L	1.00	3.50	21.00	t
1991	691	\N	NOURRITURE	-1.00	-2.40	0.00	t
1999	694	\N	NOURRITURE	-1.00	-30.05	0.00	t
2002	697	\N	COUSCOUS PM	3.00	13.50	6.00	f
2010	700	\N	IRISH COFFEE	1.00	8.00	21.00	t
2011	700	\N	GATEAUX MIEL	1.00	5.00	12.00	t
2012	700	\N	THÉ MENTHE	2.00	2.50	21.00	t
2013	700	\N	BLONDINETTE	1.00	3.50	21.00	t
2014	700	\N	JUPILER	1.00	2.50	21.00	t
2015	700	\N	ROSÉ VERRE	1.00	5.00	21.00	t
2016	700	\N	ROUGE VERRE	1.00	5.00	21.00	t
2017	700	\N	BURRATINA	1.00	14.00	12.00	t
2018	700	\N	COUSCOUS PM	2.00	15.00	12.00	t
2019	700	\N	PÂTES STRACIATELLA SCAMPIS	1.00	17.00	12.00	t
2020	700	\N	PROSECCO VERRE	1.00	5.00	21.00	t
2021	700	\N	PECKET FRAISE	1.00	6.00	21.00	t
2022	700	\N	VIOLETTE	1.00	6.00	21.00	t
2023	700	\N	Cuba-Li	1.00	6.00	21.00	t
2042	703	\N	NOURRITURE	-1.00	-9.90	0.00	t
2045	706	\N	CORNET BOLO	1.00	6.00	6.00	f
2056	709	\N	IRISH COFFEE	6.00	8.00	21.00	f
2057	709	\N	EAU 1/2 L	1.00	3.50	21.00	f
2058	709	\N	PRIMITIVO NR 14	2.00	24.00	21.00	f
2059	709	\N	SOFT (Verre)	2.00	2.00	21.00	f
2060	709	\N	COUSCOUS PM	4.00	15.00	12.00	f
2061	709	\N	PINOT GRIGIO (2020)	3.00	19.00	21.00	f
2064	712	\N	PROCES	-1.00	-63.02	0.00	t
2067	715	\N	NOURRITURE	-1.00	-19.30	0.00	t
2070	718	\N	CORNET LARD	3.00	6.00	6.00	t
2075	721	\N	CORNET LARD	2.00	6.00	6.00	t
2078	724	\N	COUSCOUS PM	3.00	13.50	6.00	t
2079	724	\N	COUSCOUS VG	2.00	10.00	6.00	t
2083	727	\N	IRISH COFFEE	5.00	8.00	21.00	t
2084	727	\N	CREME BRULEE	1.00	5.00	12.00	t
2085	727	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
2086	727	\N	SOFT (Verre)	2.00	2.00	21.00	t
2087	727	\N	APPASSIMENTO	1.00	30.00	21.00	t
2088	727	\N	COUSCOUS PM	1.00	15.00	12.00	t
2089	727	\N	PÂTES TRUFFE	2.00	17.00	12.00	t
2090	727	\N	POLPETTE	4.00	14.00	12.00	t
2093	730	\N	COUSCOUS VG	2.00	10.00	6.00	f
2096	733	\N	ROUGE VERRE	1.00	5.00	21.00	f
2097	733	\N	COUSCOUS PM	1.00	15.00	12.00	f
2098	733	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	f
2099	733	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
2100	733	\N	BLANC VERRE	3.00	5.00	21.00	f
2101	733	\N	ORVAL	2.00	5.00	21.00	f
2118	736	\N	PROSECCO VERRE	1.00	5.00	21.00	f
2119	736	\N	LIMONCELLO	2.00	5.00	21.00	f
2120	736	\N	GRAPPA	1.00	5.00	21.00	f
2123	739	\N	NOURRITURE	-1.00	-10.30	0.00	t
2141	742	\N	SERVICE Caro	-1.00	-50.00	0.00	t
2144	745	\N	UCM	-1.00	-140.35	0.00	t
2147	748	\N	CORNET BOLO	1.00	6.00	6.00	f
2156	751	\N	PROSECCO VERRE	2.00	5.00	21.00	t
2157	751	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
2160	754	\N	NOURRITURE	-1.00	-9.36	0.00	t
2163	757	\N	CORNET TRUFFE	1.00	7.00	6.00	t
2173	760	\N	BLANC VERRE	2.00	5.00	21.00	t
2181	763	\N	PINOT GRIGIO (2020)	1.00	19.00	21.00	f
2198	766	\N	ROUGE VERRE	1.00	5.00	21.00	f
2199	766	\N	COUSCOUS PM	4.00	15.00	12.00	f
2200	766	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	f
2201	766	\N	PÂTES TRUFFE	1.00	17.00	12.00	f
2202	766	\N	PÂTES SCAMPIS	2.00	15.00	12.00	f
2203	766	\N	ASSIETTE APERITIVE (2 p.)	2.00	19.00	12.00	f
2204	766	\N	IRISH COFFEE	4.00	8.00	21.00	f
2205	766	\N	APPASSIMENTO	1.00	30.00	21.00	f
2206	766	\N	BLANC VERRE	1.00	5.00	21.00	f
2207	766	\N	ORVAL	7.00	5.00	21.00	f
2208	766	\N	JUPILER	19.00	2.50	21.00	f
2209	766	\N	PECKET FRAISE	2.00	6.00	21.00	f
2210	766	\N	GINGEMBRE	3.00	6.00	21.00	f
1890	659	\N	CASELLETTI	1.00	30.00	21.00	t
1891	659	\N	THÉ MENTHE	2.00	2.50	21.00	t
1892	659	\N	COUSCOUS PM	2.00	15.00	12.00	t
1893	659	\N	TCHAKTCHOUKA	2.00	8.00	12.00	t
1894	659	\N	BLONDINETTE	1.00	3.50	21.00	t
1895	659	\N	Cuba-Li	1.00	6.00	21.00	t
1908	662	\N	CORNET LARD	1.00	6.00	6.00	t
1911	665	\N	NOURRITURE	-1.00	-31.00	0.00	t
1914	668	\N	NOURRITURE	-1.00	-16.90	0.00	t
1923	671	\N	ROSÉ VERRE	2.00	5.00	21.00	f
1924	671	\N	BLANC VERRE	3.00	5.00	21.00	f
1957	674	\N	NOURRITURE	-1.00	-27.60	0.00	t
1960	677	\N	CARBURANT	-1.00	-113.65	0.00	t
1963	680	\N	CORNET TRUFFE	1.00	7.00	6.00	t
1964	680	\N	CORNET LARD	1.00	6.00	6.00	t
1969	683	\N	CORNET LARD	1.00	6.00	6.00	f
1976	686	\N	COUSCOUS PM	2.00	15.00	12.00	t
1977	686	\N	Cuba-Li	2.00	6.00	21.00	t
1987	689	\N	POLPETTE	1.00	14.00	6.00	t
1988	689	\N	TCHAKTCHOUKA	1.00	14.00	6.00	t
1989	689	\N	PÂTES BOLO/LARD	1.00	12.00	6.00	t
1992	692	\N	GRAPPA	1.00	5.00	21.00	t
1993	692	\N	AMARETTO	1.00	5.00	21.00	t
1994	692	\N	PINOT GRIGIO (2020)	1.00	19.00	21.00	f
1995	692	\N	PÂTES STRACIATELLA	1.00	13.00	12.00	t
1996	692	\N	BURRATINA	1.00	14.00	12.00	t
1997	692	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
2000	695	\N	AUTO	-1.00	-75.00	0.00	t
2003	698	\N	CREME BRULEE	2.00	5.00	12.00	f
2004	698	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	f
2005	698	\N	POLPETTE	1.00	14.00	12.00	f
2006	698	\N	ROUGE VERRE	3.00	5.00	21.00	f
2024	701	\N	PÂTES SCAMPIS	1.00	15.00	12.00	f
2025	701	\N	POLPETTE	1.00	14.00	12.00	f
2026	701	\N	COUSCOUS PM	1.00	15.00	12.00	f
2027	701	\N	PRIMITIVO NR 14	2.00	24.00	21.00	f
2028	701	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
2029	701	\N	GATEAUX MIEL	1.00	5.00	12.00	f
2030	701	\N	CREME BRULEE	2.00	5.00	12.00	f
2043	704	\N	NOURRITURE	-1.00	-25.07	0.00	t
2046	707	\N	CREME BRULEE	1.00	5.00	12.00	f
2047	707	\N	ROUGE VERRE	1.00	5.00	21.00	f
2048	707	\N	COUSCOUS PM	1.00	15.00	12.00	f
2049	707	\N	EAU 1/2 L	1.00	3.50	21.00	f
2050	707	\N	PROSECCO VERRE	2.00	5.00	21.00	f
2062	710	\N	COUSCOUS PM	4.00	12.50	6.00	f
2065	713	\N	PROCES	-1.00	-87.02	0.00	t
2068	716	\N	NOURRITURE	-1.00	-36.83	0.00	t
2071	719	\N	SOFT (Verre)	1.00	2.00	21.00	t
2072	719	\N	CORNET LARD	1.00	6.00	6.00	t
2076	722	\N	ENERGIES	-1.00	-246.46	0.00	t
2080	725	\N	EMBALLAGE	-1.00	-48.93	0.00	t
2091	728	\N	BOISSONS	-1.00	-105.72	0.00	t
2094	731	\N	COUSCOUS VG	2.00	10.00	6.00	f
2102	734	\N	PINOT GRIGIO (2020)	1.00	19.00	21.00	f
2103	734	\N	SPAG.COURG.SCAMP.	2.00	16.00	12.00	f
2104	734	\N	PÂTES BOLO/LARD	5.00	12.00	12.00	f
2105	734	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
2106	734	\N	SOFT (Verre)	1.00	2.00	21.00	f
2107	734	\N	PROSECCO VERRE	1.00	5.00	21.00	f
2108	734	\N	PECKET FRAISE	2.00	6.00	21.00	f
2121	737	\N	Service Victor	-1.00	-50.00	0.00	t
2124	740	\N	APPASSIMENTO	1.00	20.00	21.00	t
2125	740	\N	BLANC VERRE	1.00	5.00	21.00	t
2126	740	\N	ROUGE VERRE	1.00	6.00	21.00	t
2127	740	\N	BURRATINA	1.00	14.00	12.00	t
2128	740	\N	COUSCOUS PM	1.00	13.50	12.00	t
2142	743	\N	CARBURANT	-1.00	-102.42	0.00	t
2145	746	\N	Fred	-1.00	-400.00	0.00	t
2148	749	\N	CORNET LARD	2.00	6.00	6.00	t
2149	749	\N	CORNET TRUFFE	2.00	7.00	6.00	t
2158	752	\N	NOURRITURE	-1.00	-27.02	0.00	t
2161	755	\N	NOURRITURE	-1.00	-3.00	0.00	t
2164	758	\N	ESPRESSO	1.00	2.50	21.00	t
2165	758	\N	THÉ MENTHE	2.00	2.50	21.00	t
2166	758	\N	CREME BRULEE	2.00	5.00	12.00	t
2167	758	\N	POLPETTE	1.00	14.00	12.00	t
2168	758	\N	COUSCOUS PM	3.00	15.00	12.00	f
2169	758	\N	EAU 1/2 L	1.00	3.50	21.00	t
2170	758	\N	GIN TONIC	3.00	6.00	21.00	f
2171	758	\N	BLANC VERRE	3.00	5.00	21.00	t
2174	761	\N	COUSCOUS PM	5.00	13.50	6.00	f
2182	764	\N	THÉ MENTHE	1.00	2.50	21.00	t
2183	764	\N	APPASSIMENTO	1.00	30.00	21.00	t
2184	764	\N	PROSECCO VERRE	1.00	5.00	21.00	t
2185	764	\N	CREME BRULEE	2.00	5.00	12.00	t
2186	764	\N	GATEAUX MIEL	1.00	5.00	12.00	t
2187	764	\N	SPAG.COURG.SCAMP.	1.00	16.00	12.00	t
2188	764	\N	POLPETTE	1.00	14.00	12.00	t
2189	764	\N	PÂTES SCAMPIS	1.00	15.00	12.00	t
2190	764	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
2191	764	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
2211	767	\N	ORVAL	4.00	5.00	21.00	f
2212	767	\N	JUPILER	2.00	2.50	21.00	f
2213	767	\N	ROUGE VERRE	1.00	6.00	21.00	f
2214	767	\N	BLANC VERRE	1.00	5.00	21.00	f
2226	770	\N	Service Julie	-1.00	-50.00	0.00	t
2229	773	\N	Service Elisa	-1.00	-50.00	0.00	t
3215	1107	\N	COUSCOUS PM	1.00	15.00	12.00	t
3216	1107	\N	BURRATINA TRUFFES	1.00	17.00	12.00	t
3228	1110	\N	BULLES 0% VERRE	1.00	5.00	21.00	t
3229	1110	\N	GIN TONIC	4.00	6.00	21.00	t
3230	1110	\N	JUPILER	2.00	2.50	21.00	t
3231	1110	\N	BLANC VERRE	1.00	5.00	21.00	t
3234	1113	\N	NOURRITURE	-1.00	-18.75	0.00	t
3240	1116	\N	POLPETTE	1.00	15.00	12.00	f
3241	1116	\N	COUSCOUS PM	1.00	15.00	12.00	f
3257	1119	\N	COUSCOUS VG	1.00	10.00	6.00	t
3275	1122	\N	PROSECCO VERRE	1.00	5.00	21.00	t
3276	1122	\N	VIOLETTE	1.00	6.00	21.00	t
3285	1125	\N	NOURRITURE	-1.00	-54.20	0.00	t
3288	1128	\N	Nettoyage	-1.00	-50.00	0.00	t
3291	1131	\N	BOISSONS	-1.00	-313.80	0.00	t
3294	1134	\N	Service Véro	-1.00	-40.00	0.00	t
3297	1137	\N	EAUX 1 L	1.00	5.00	21.00	f
3298	1137	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
3299	1137	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	f
3300	1137	\N	POLPETTE	1.00	15.00	12.00	f
3301	1137	\N	TAJINE	1.00	15.00	12.00	f
1896	660	\N	ESPRESSO	1.00	2.50	21.00	f
1897	660	\N	SOFT (Verre)	4.00	2.00	21.00	f
1898	660	\N	PÂTES SCAMPIS	1.00	15.00	12.00	f
1899	660	\N	COUSCOUS VG	1.00	10.00	12.00	f
1900	660	\N	TCHAKTCHOUKA	1.00	8.00	12.00	f
1901	660	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	f
1902	660	\N	PECKET FRAISE	1.00	6.00	21.00	f
1903	660	\N	VIOLETTE	1.00	6.00	21.00	f
1909	663	\N	SERVICE Caro	-1.00	-75.00	0.00	t
1912	666	\N	NOURRITURE	-1.00	-61.15	0.00	t
1915	669	\N	PÂTES TRUFFE	1.00	17.00	6.00	f
1916	669	\N	COUSCOUS PM	1.00	13.50	6.00	f
1925	672	\N	CREME BRULEE	2.00	5.00	12.00	t
1926	672	\N	SPAG.COURG.SCAMP.	1.00	16.00	12.00	t
1927	672	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	t
1928	672	\N	COUSCOUS PM	1.00	15.00	12.00	t
1929	672	\N	PÂTES BOLO/LARD	4.00	12.00	12.00	t
1930	672	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	t
1931	672	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
1932	672	\N	PINOT GRIGIO (2020)	1.00	19.00	21.00	f
1933	672	\N	BLANC VERRE	2.00	5.00	21.00	f
1934	672	\N	SOFT (Verre)	2.00	2.00	21.00	t
1935	672	\N	VIOLETTE	2.00	6.00	21.00	t
1958	675	\N	NOURRITURE	-1.00	-10.31	0.00	t
1961	678	\N	AMEUBLEMENT	-1.00	-70.75	0.00	t
1965	681	\N	COUSCOUS PM	1.00	13.50	6.00	t
1966	681	\N	SPAG.COURG.SCAMP.	2.00	16.00	12.00	f
1967	681	\N	SOFT (Verre)	1.00	2.00	21.00	t
1970	684	\N	CORNET BOLO	1.00	6.00	6.00	t
1971	684	\N	CORNET LARD	1.00	6.00	6.00	t
1978	687	\N	THÉ MENTHE	1.00	2.50	21.00	t
1979	687	\N	IRISH COFFEE	1.00	8.00	21.00	t
1980	687	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	t
1981	687	\N	BURRATINA	1.00	14.00	12.00	t
1982	687	\N	VIOLETTE	1.00	6.00	21.00	t
1983	687	\N	GINGEMBRE	1.00	6.00	21.00	t
1990	690	\N	NOURRITURE	-1.00	-99.06	0.00	t
1998	693	\N	SERVICE Caro	-1.00	-50.00	0.00	t
2001	696	\N	NOURRITURE	-1.00	-32.72	0.00	t
2007	699	\N	SPAG.COURG.SCAMP.	1.00	13.00	12.00	f
2008	699	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	f
2009	699	\N	BLONDINETTE	2.00	3.50	21.00	f
2031	702	\N	CAFÉ	1.00	2.50	21.00	t
2032	702	\N	PECKET FRAISE	1.00	6.00	21.00	f
2033	702	\N	GRAPPA	1.00	5.00	21.00	f
2034	702	\N	PROSECCO VERRE	1.00	5.00	21.00	t
2035	702	\N	PINOT GRIGIO (2020)	1.00	19.00	21.00	f
2036	702	\N	SPAG.COURG.SCAMP.	1.00	16.00	12.00	t
2037	702	\N	PÂTES BOLO/LARD	3.00	12.00	12.00	t
2038	702	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	t
2039	702	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	t
2040	702	\N	VIOLETTE	3.00	6.00	21.00	f
2041	702	\N	PÂTES BOLO/LARD	2.00	12.00	12.00	t
2044	705	\N	BOISSONS	-1.00	-22.15	0.00	t
2051	708	\N	ESPRESSO	1.00	2.50	21.00	t
2052	708	\N	CAPUCCINO	1.00	2.80	21.00	t
2053	708	\N	JUPILER	2.00	2.50	21.00	t
2054	708	\N	SPAG.COURG.SCAMP.	1.00	16.00	12.00	t
2055	708	\N	POLPETTE	1.00	14.00	12.00	t
2063	711	\N	FISC	-1.00	-350.00	0.00	t
2066	714	\N	SERVICE Caro	-1.00	-20.00	0.00	t
2069	717	\N	CORNET BOLO	1.00	6.00	6.00	f
2073	720	\N	CORNET TRUFFE	1.00	7.00	6.00	t
2074	720	\N	CORNET BOLO	1.00	6.00	6.00	t
2077	723	\N	NOURRITURE	-1.00	-47.33	0.00	t
2081	726	\N	SOFT (Verre)	2.00	2.00	21.00	t
2082	726	\N	PROSECCO VERRE	1.00	5.00	21.00	t
2092	729	\N	NOURRITURE	-1.00	-5.30	0.00	t
2095	732	\N	COUSCOUS PM	3.00	13.50	6.00	f
2109	735	\N	GATEAUX MIEL	1.00	5.00	12.00	f
2110	735	\N	SPAG.COURG.SCAMP.	1.00	16.00	12.00	f
2111	735	\N	THÉ MENTHE	1.00	2.50	21.00	f
2112	735	\N	COUSCOUS PM	1.00	15.00	12.00	f
2113	735	\N	TCHAKTCHOUKA	1.00	8.00	12.00	f
2114	735	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	f
2115	735	\N	BLANC VERRE	3.00	5.00	21.00	f
2116	735	\N	SOFT (Verre)	2.00	2.00	21.00	f
2117	735	\N	JUPILER	2.00	2.50	21.00	f
2122	738	\N	NOURRITURE	-1.00	-45.10	0.00	t
2129	741	\N	IRISH COFFEE	1.00	8.00	21.00	t
2130	741	\N	PÂTES SCAMPIS	1.00	15.00	12.00	t
2131	741	\N	PÂTES BOLO/LARD	3.00	12.00	12.00	t
2132	741	\N	SOFT (Verre)	2.00	2.00	21.00	f
2133	741	\N	PECKET FRAISE	1.00	6.00	21.00	f
2134	741	\N	CHIARETTO	2.00	19.00	21.00	f
2135	741	\N	CREME BRULEE	1.00	5.00	12.00	t
2136	741	\N	GRAPPA	1.00	5.00	21.00	t
2137	741	\N	CAFÉ	2.00	2.50	21.00	t
2138	741	\N	CAPUCCINO	1.00	2.80	21.00	t
2139	741	\N	SCAMPIS LUCIFER	2.00	8.00	12.00	f
2140	741	\N	CHAMPIGNONS KABYLES	2.00	6.00	12.00	t
2143	744	\N	AUTO	-1.00	-65.40	0.00	t
2146	747	\N	CORNET TRUFFE	1.00	7.00	6.00	f
2150	750	\N	IRISH COFFEE	2.00	8.00	21.00	f
2151	750	\N	CREME BRULEE	1.00	5.00	6.00	f
2152	750	\N	BLANC VERRE	1.00	5.00	21.00	f
2153	750	\N	ROUGE VERRE	1.00	5.00	21.00	f
2154	750	\N	PROSECCO VERRE	2.00	5.00	21.00	f
2155	750	\N	SPAG.COURG.SCAMP.	2.00	16.00	12.00	f
2159	753	\N	NOURRITURE	-1.00	-2.90	0.00	t
2162	756	\N	BOISSONS	-1.00	-78.00	0.00	t
2172	759	\N	NOURRITURE	-1.00	-40.93	0.00	t
2175	762	\N	PINOT GRIGIO (2020)	1.00	19.00	21.00	t
2176	762	\N	BLONDINETTE	6.00	3.50	21.00	t
2177	762	\N	BLANC VERRE	2.00	5.00	21.00	t
2178	762	\N	ROUGE VERRE	3.00	5.00	21.00	t
2179	762	\N	SPAG.COURG.SCAMP.	1.00	16.00	12.00	t
2180	762	\N	ASSIETTE APERITIVE (2 p.)	1.00	10.00	12.00	t
2192	765	\N	ESPRESSO	2.00	2.50	21.00	f
2193	765	\N	PÂTES SCAMPIS	1.00	15.00	12.00	f
2194	765	\N	POLPETTE	2.00	14.00	12.00	f
2195	765	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
2196	765	\N	PINOT GRIGIO (2020)	2.00	19.00	21.00	f
2197	765	\N	PROSECCO VERRE	3.00	5.00	21.00	f
2215	768	\N	LIMONCELLO	1.00	5.00	21.00	t
2216	768	\N	EAU 1/2 L	1.00	3.50	21.00	t
2217	768	\N	COUSCOUS PM	1.00	0.00	12.00	t
2218	768	\N	IRISH COFFEE	1.00	0.00	21.00	t
2219	768	\N	GATEAUX MIEL	1.00	5.00	12.00	t
2220	768	\N	CREME BRULEE	1.00	0.00	12.00	t
2221	768	\N	APPASSIMENTO	1.00	20.00	21.00	t
2222	768	\N	COUSCOUS PM	1.00	15.00	12.00	t
2223	768	\N	PROSECCO VERRE	2.00	0.00	21.00	t
2224	768	\N	PROSECCO VERRE	2.00	5.00	21.00	t
2227	771	\N	BLANC VERRE	3.00	5.00	21.00	f
3238	1115	\N	PROSECCO VERRE	1.00	5.00	21.00	f
3239	1115	\N	TAJINE	1.00	15.00	12.00	f
3248	1118	\N	CREME BRULEE	1.00	5.00	12.00	t
3249	1118	\N	TATIN	3.00	8.00	12.00	t
3250	1118	\N	SOFT (Verre)	2.00	2.00	21.00	t
3251	1118	\N	Cuba-Li	1.00	6.00	21.00	t
3252	1118	\N	VIOLETTE	2.00	6.00	21.00	t
3253	1118	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	t
3254	1118	\N	SPAG.COURGETTE	1.00	18.00	12.00	t
3255	1118	\N	PÂTES STRACIATELLA	1.00	15.00	12.00	t
3256	1118	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
3272	1121	\N	CREME BRULEE	1.00	5.00	12.00	f
3273	1121	\N	ROUGE VERRE	1.00	5.00	21.00	f
3274	1121	\N	RHUM	1.00	6.00	21.00	f
3284	1124	\N	NOURRITURE	-1.00	-32.45	0.00	t
3287	1127	\N	NOURRITURE	-1.00	-16.55	0.00	t
3290	1130	\N	BOISSONS	-1.00	-47.19	0.00	t
3293	1133	\N	COUSCOUS PM	2.00	15.00	6.00	f
3296	1136	\N	SERVICE Elise	-1.00	-30.00	0.00	t
3309	1139	\N	SOFT (Verre)	1.00	2.00	21.00	t
3310	1139	\N	GINGEMBRE	1.00	6.00	21.00	t
3311	1139	\N	PROSECCO VERRE	1.00	5.00	21.00	t
3312	1139	\N	APPASSIMENTO	1.00	30.00	21.00	t
3313	1139	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
3314	1139	\N	PÂTES	1.00	10.00	12.00	t
3315	1139	\N	GATEAUX MIEL	1.00	5.00	12.00	t
3316	1139	\N	THÉ MENTHE	1.00	2.50	21.00	t
3317	1139	\N	POLPETTE	2.00	15.00	12.00	t
3338	1142	\N	ROUGE VERRE	1.00	5.00	21.00	f
3339	1142	\N	RHUM	1.00	6.00	21.00	f
3340	1142	\N	SOFT (Verre)	1.00	2.00	21.00	f
3341	1142	\N	JUPILER	1.00	2.50	21.00	f
3342	1142	\N	BLONDINETTE	1.00	3.50	21.00	f
3345	1145	\N	SERVICE Caro	-1.00	-50.00	0.00	t
3353	1148	\N	COUSCOUS PM	4.00	10.00	6.00	t
3362	1151	\N	NOURRITURE	-1.00	-14.07	0.00	t
3367	1154	\N	CAFÉ	2.00	2.50	21.00	t
3368	1154	\N	THÉ MENTHE	2.00	2.50	21.00	t
3369	1154	\N	GATEAUX MIEL	2.00	5.00	12.00	t
3370	1154	\N	TAJINE	2.00	15.00	12.00	t
3371	1154	\N	ROSÉ VERRE	1.00	5.00	21.00	t
3372	1154	\N	SOFT (Verre)	2.00	2.00	21.00	t
3373	1154	\N	PECKET FRAISE	1.00	6.00	21.00	t
3376	1157	\N	EMBALLAGE	-1.00	-16.48	0.00	t
3399	1161	\N	ESPRESSO	1.00	2.50	21.00	f
3400	1161	\N	POLPETTE	2.00	15.00	12.00	f
3401	1161	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
3402	1161	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
3412	1164	\N	PROSECCO VERRE	2.00	5.00	21.00	f
3413	1164	\N	BURRATINA TRUFFES	1.00	17.00	12.00	f
3414	1164	\N	TAJINE	1.00	15.00	12.00	f
3415	1164	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
3416	1164	\N	VIN 1/2	1.00	20.00	21.00	f
3417	1164	\N	THÉ MENTHE	1.00	2.50	21.00	f
3418	1164	\N	SABAYON	1.00	8.00	12.00	f
3419	1164	\N	CREME BRULEE	1.00	5.00	12.00	f
3421	1166	\N	Service Véro	-1.00	-30.00	0.00	t
3422	1167	\N	NOURRITURE	-1.00	-28.09	0.00	t
3423	1168	\N	NOURRITURE	-1.00	-10.25	0.00	t
3424	1169	\N	NOURRITURE	-1.00	-35.56	0.00	t
3425	1170	\N	JUPILER	2.00	2.00	21.00	t
3426	1170	\N	COUSCOUS PM	4.00	15.00	6.00	t
3427	1171	\N	SOFT (Verre)	1.00	2.00	21.00	t
3428	1171	\N	TATIN	1.00	8.00	12.00	t
3429	1171	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
3430	1171	\N	BURRATINA PESTO	1.00	15.00	12.00	t
3431	1172	\N	THÉ MENTHE	3.00	2.50	21.00	f
3432	1172	\N	SABAYON	1.00	8.00	12.00	f
3433	1172	\N	TATIN	2.00	8.00	12.00	f
3434	1172	\N	GATEAUX MIEL	1.00	5.00	12.00	f
3435	1172	\N	SOFT (Verre)	4.00	2.00	21.00	f
3436	1172	\N	PROSECCO VERRE	1.00	5.00	21.00	f
3437	1172	\N	VIOLETTE	1.00	6.00	21.00	f
3438	1172	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	6.00	f
3439	1172	\N	POLPETTE	1.00	15.00	12.00	f
3440	1172	\N	COUSCOUS PM	1.00	15.00	12.00	f
3441	1172	\N	PÂTES SPÉCIALES	1.00	16.00	12.00	f
3442	1173	\N	ROUGE VERRE	4.00	5.00	21.00	f
3443	1173	\N	TAJINE	1.00	15.00	12.00	f
3444	1173	\N	COUSCOUS VG	1.00	10.00	12.00	f
3445	1173	\N	CREME BRULEE	1.00	5.00	12.00	f
3446	1173	\N	ESPRESSO	1.00	2.50	21.00	f
3447	1174	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
3448	1174	\N	SOFT (Verre)	2.00	2.00	21.00	f
3449	1174	\N	CHARDONNAY FIO	1.00	20.00	21.00	f
3450	1174	\N	LIMONCELLO	2.00	0.00	21.00	f
3451	1174	\N	ROUGE VERRE	2.00	5.00	21.00	f
3452	1174	\N	LIMONCELLO	3.00	5.00	21.00	f
3453	1174	\N	TATIN	1.00	8.00	12.00	f
3454	1174	\N	CREME BRULEE	1.00	5.00	12.00	f
3455	1174	\N	ORVAL	1.00	5.00	21.00	f
3456	1174	\N	IRISH COFFEE	2.00	8.00	21.00	f
3457	1174	\N	GATEAUX MIEL	1.00	5.00	12.00	f
3458	1174	\N	GLACE	1.00	5.00	12.00	f
3459	1174	\N	TAJINE	3.00	15.00	12.00	f
3460	1174	\N	COUSCOUS PM	2.00	15.00	12.00	f
3461	1174	\N	TAJINE	1.00	10.00	12.00	f
3462	1174	\N	COUSCOUS PM	1.00	10.00	12.00	f
3463	1174	\N	COUSCOUS VG	1.00	10.00	12.00	f
3464	1175	\N	SERVICE Caro	-1.00	-50.00	0.00	t
3465	1176	\N	DIVERS	-1.00	-15.00	0.00	t
3466	1177	\N	SERVICE CELIA	-1.00	-40.00	0.00	t
3467	1178	\N	PÂTES SPÉCIALES	1.00	16.00	12.00	f
3468	1178	\N	BURRATINA TRUFFES	1.00	17.00	12.00	f
3469	1178	\N	TAJINE	2.00	15.00	12.00	f
3470	1178	\N	ROUGE VERRE	1.00	5.00	21.00	f
3471	1178	\N	SOFT (Verre)	4.00	2.00	21.00	f
3472	1178	\N	Cuba-Li	1.00	0.00	21.00	f
3473	1178	\N	PROSECCO VERRE	1.00	0.00	21.00	f
3474	1178	\N	PECKET FRAISE	2.00	0.00	21.00	f
3475	1178	\N	CAFÉ	1.00	2.50	21.00	f
3476	1178	\N	CAPUCCINO	1.00	2.80	21.00	f
3477	1178	\N	CREME BRULEE	1.00	5.00	12.00	f
2225	769	\N	JUPILER	1.00	2.50	21.00	t
2228	772	\N	Service Caro	-1.00	-100.00	0.00	t
2230	774	\N	SERVICE	-1.00	20.00	0.00	t
2231	775	\N	Service Célia	-1.00	-20.00	0.00	t
2232	776	\N	NOURRITURE	-1.00	-94.50	0.00	t
2233	777	\N	NOURRITURE	-1.00	-38.70	0.00	t
2234	778	\N	NOURRITURE	-1.00	-19.74	0.00	t
2235	779	\N	CAFÉ	2.00	2.50	21.00	t
2236	779	\N	CREME BRULEE	1.00	5.00	12.00	t
2237	779	\N	IRISH COFFEE	1.00	8.00	21.00	f
2238	779	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
2239	779	\N	POLPETTE	3.00	14.00	12.00	f
2240	779	\N	CHAMPIGNONS KABYLES	2.00	6.00	12.00	t
2241	779	\N	SCAMPIS LUCIFER	2.00	8.00	12.00	t
2242	779	\N	CHIARETTO	2.00	19.00	21.00	f
2243	779	\N	EAUX 1 L	1.00	5.00	21.00	t
2244	779	\N	PECKET FRAISE	2.00	6.00	21.00	f
2245	780	\N	THÉ MENTHE	2.00	2.50	21.00	t
2246	780	\N	COUSCOUS PM	2.00	15.00	12.00	f
2247	780	\N	TCHAKTCHOUKA	1.00	8.00	12.00	t
2248	780	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	t
2249	780	\N	TCHAKTCHOUKA	1.00	10.00	12.00	t
2250	780	\N	ROUGE VERRE	2.00	6.00	21.00	t
2251	780	\N	APPASSIMENTO	1.00	30.00	21.00	f
2252	780	\N	BLANC VERRE	1.00	5.00	21.00	t
2253	781	\N	LIMONCELLO	1.00	5.00	21.00	f
2254	781	\N	AMARETTO	1.00	5.00	21.00	f
2255	781	\N	RHUM HAVANA	2.00	6.00	21.00	f
2256	782	\N	Service Elisa	-1.00	-50.00	0.00	t
2257	783	\N	SOFT (Verre)	1.00	2.00	21.00	t
2258	783	\N	CORNET LARD	1.00	6.00	6.00	t
2259	784	\N	NOURRITURE	-1.00	-49.70	0.00	t
2260	785	\N	SOFT (Verre)	1.00	2.00	21.00	t
2261	785	\N	ROSÉ VERRE	2.00	5.00	21.00	t
2262	785	\N	CHIARETTO 1/2	1.00	12.00	21.00	t
2263	785	\N	POLPETTE	2.00	14.00	12.00	t
2264	785	\N	EAU 1/2 L	1.00	3.50	21.00	t
2265	785	\N	PROSECCO VERRE	4.00	5.00	21.00	t
2266	786	\N	CREME BRULEE	1.00	5.00	12.00	f
2267	786	\N	IRISH COFFEE	1.00	8.00	21.00	f
2268	786	\N	ROUGE VERRE	2.00	5.00	21.00	f
2269	786	\N	PROSECCO VERRE	2.00	5.00	21.00	f
2270	786	\N	COUSCOUS PM	2.00	15.00	12.00	f
2271	787	\N	SERVICE Célia	-1.00	-25.00	0.00	t
2272	788	\N	CORNET TRUFFE	1.00	7.00	6.00	t
2273	788	\N	JUPILER	2.00	2.00	21.00	t
2274	789	\N	CORNET LARD	1.00	6.00	6.00	t
2275	789	\N	CORNET TRUFFE	1.00	7.00	6.00	t
2276	790	\N	IRISH COFFEE	2.00	8.00	21.00	t
2277	790	\N	PINOT GRIGIO (2020)	1.00	19.00	21.00	f
2278	790	\N	PROSECCO Bouteille	2.00	25.00	21.00	f
2279	790	\N	COUSCOUS PM	2.00	15.00	12.00	t
2280	790	\N	TCHAKTCHOUKA	1.00	8.00	12.00	t
2281	791	\N	AMARETTO	1.00	5.00	21.00	f
2282	791	\N	ROSÉ VERRE	4.00	5.00	21.00	f
2283	791	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	f
2284	791	\N	PROSECCO VERRE	3.00	5.00	21.00	f
2285	792	\N	JUPILER	2.00	2.00	21.00	t
2286	792	\N	CORNET LARD	1.00	6.00	6.00	t
2287	793	\N	NOURRITURE	-1.00	-115.88	0.00	t
2288	794	\N	NOURRITURE	-1.00	-11.00	0.00	t
2289	795	\N	NOURRITURE	-1.00	-79.97	0.00	t
2290	796	\N	CORNET BOLO	1.00	6.00	6.00	t
2291	797	\N	BLANC VERRE	3.00	5.00	21.00	f
2292	797	\N	SOFT (Verre)	1.00	2.00	21.00	f
2293	797	\N	COUSCOUS PM	2.00	15.00	12.00	f
2294	798	\N	VIN 1/2	1.00	13.00	21.00	f
2295	798	\N	VIN 1/2	1.00	20.00	21.00	f
2296	798	\N	CREME BRULEE	4.00	5.00	12.00	t
2297	798	\N	PÂTES TRUFFE	2.00	17.00	12.00	t
2298	798	\N	POLPETTE	2.00	14.00	12.00	f
2299	798	\N	SCAMPIS LUCIFER	2.00	8.00	12.00	f
2300	798	\N	CHAMPIGNONS KABYLES	2.00	6.00	12.00	t
2301	799	\N	ESPRESSO	1.00	2.50	21.00	f
2302	799	\N	GATEAUX MIEL	1.00	5.00	12.00	f
2303	799	\N	CREME BRULEE	2.00	5.00	12.00	f
2304	799	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	f
2305	799	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
2306	799	\N	COUSCOUS VG	1.00	10.00	12.00	f
2307	799	\N	COUSCOUS PM	3.00	15.00	12.00	f
2308	799	\N	TCHAKTCHOUKA	1.00	14.00	12.00	f
2309	799	\N	BURRATINA (1X50GR)	1.00	8.00	12.00	f
2310	799	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	f
2311	799	\N	CHAMPIGNONS KABYLES	3.00	6.00	12.00	f
2312	799	\N	THÉ MENTHE	1.00	2.50	21.00	f
2313	799	\N	SOFT (Verre)	2.00	2.00	21.00	f
2314	799	\N	APPASSIMENTO	1.00	30.00	21.00	f
2315	799	\N	PINOT GRIGIO (2020)	2.00	19.00	21.00	f
2316	799	\N	ORVAL	1.00	5.00	21.00	f
2317	799	\N	TRIPLE SAINTE NITOUCHE	2.00	4.50	21.00	f
2318	799	\N	PROSECCO VERRE	2.00	5.00	21.00	f
2319	799	\N	GIN TONIC	2.00	6.00	21.00	f
2320	799	\N	PECKET FRAISE	3.00	6.00	21.00	f
2321	799	\N	APEROL SPRITZ	1.00	6.00	21.00	f
2322	800	\N	COUSCOUS PM	1.00	15.00	12.00	t
2323	800	\N	VIOLETTE	2.00	6.00	21.00	f
2324	800	\N	GIN TONIC	1.00	6.00	21.00	f
2325	801	\N	SERVICE Caro	-1.00	-70.00	0.00	t
2326	802	\N	VIN 1/2	1.00	20.00	21.00	t
2327	802	\N	GRAPPA	1.00	5.00	21.00	t
2328	802	\N	CREME BRULEE	2.00	5.00	12.00	t
2329	802	\N	SPAG.COURG.SCAMP.	1.00	16.00	12.00	t
2330	802	\N	COUSCOUS PM	1.00	15.00	12.00	t
2331	802	\N	PECKET FRAISE	1.00	6.00	21.00	t
2332	802	\N	VIOLETTE	1.00	6.00	21.00	t
2333	803	\N	GLACE	2.00	5.00	12.00	t
2334	803	\N	GATEAUX MIEL	1.00	5.00	12.00	t
2335	803	\N	EAU 1/2 L	1.00	3.50	21.00	t
2336	803	\N	SOFT (Verre)	3.00	2.00	21.00	t
2337	803	\N	VIOLETTE	1.00	6.00	21.00	t
2338	803	\N	PROSECCO VERRE	1.00	5.00	21.00	t
2339	803	\N	SPAG.COURG.SCAMP.	1.00	16.00	12.00	t
2340	803	\N	COUSCOUS PM	1.00	15.00	12.00	t
2341	803	\N	COUSCOUS VG	2.00	10.00	12.00	t
2342	804	\N	BLANC VERRE	1.00	5.00	21.00	t
2343	804	\N	PÂTES SCAMPIS	1.00	15.00	12.00	t
2344	804	\N	COUSCOUS VG	2.00	10.00	12.00	t
2345	804	\N	PECKET FRAISE	1.00	6.00	21.00	t
2346	804	\N	VIOLETTE	1.00	6.00	21.00	t
2347	804	\N	GINGEMBRE	1.00	6.00	21.00	t
2355	807	\N	LOYER	-1.00	-600.00	0.00	t
2358	810	\N	APPASSIMENTO	1.00	30.00	21.00	f
2359	810	\N	PINOT GRIGIO (2020)	2.00	19.00	21.00	f
2360	810	\N	SPAG.COURG.SCAMP.	3.00	16.00	12.00	f
2361	810	\N	TCHAKTCHOUKA	1.00	8.00	12.00	f
2362	810	\N	GINGEMBRE	1.00	6.00	21.00	f
2363	810	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
2364	810	\N	PECKET FRAISE	2.00	6.00	21.00	f
2370	813	\N	COUSCOUS PM	2.00	15.00	6.00	f
2373	816	\N	NOURRITURE	-1.00	-19.05	0.00	t
2377	819	\N	EMBALLAGE	-1.00	-6.50	0.00	t
2380	822	\N	BLANC VERRE	1.00	5.00	21.00	t
2381	822	\N	PÂTES SCAMPIS	1.00	15.00	12.00	t
2382	822	\N	VIOLETTE	2.00	6.00	21.00	f
2387	825	\N	DIVERS	-1.00	-38.41	0.00	t
2391	828	\N	COUSCOUS PM	1.00	15.00	12.00	f
2392	828	\N	GRAPPA	1.00	5.00	21.00	f
2393	828	\N	SPAG.COURG.SCAMP.	1.00	12.00	12.00	f
2394	828	\N	COUSCOUS PM	1.00	15.00	12.00	f
2395	828	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	f
2396	828	\N	BURRATINA (1X50GR)	1.00	8.00	12.00	f
2397	828	\N	PROSECCO VERRE	1.00	5.00	21.00	f
2398	828	\N	VIOLETTE	1.00	6.00	21.00	f
2417	831	\N	SERVICE Caro	-1.00	-50.00	0.00	t
2420	834	\N	NOURRITURE	-1.00	-26.40	0.00	t
2426	837	\N	PROSECCO VERRE	1.00	5.00	21.00	t
2427	837	\N	RHUM HAVANA	1.00	6.00	21.00	t
2428	837	\N	JUPILER	2.00	2.00	21.00	t
2431	840	\N	COMPTABLE	-1.00	-393.25	0.00	t
2438	843	\N	JUPILER	4.00	2.50	21.00	t
2439	843	\N	CORNET LARD	2.00	6.00	6.00	t
2452	846	\N	CORNET BOLO	4.00	6.00	6.00	f
2453	846	\N	CORNET TRUFFE	1.00	7.00	6.00	f
2466	849	\N	BOISSONS	-1.00	-201.00	0.00	t
2469	852	\N	AMEUBLEMENT	-1.00	-10.78	0.00	t
2473	855	\N	EAU 1/2 L	1.00	3.50	21.00	t
2474	855	\N	BLANC VERRE	4.00	5.00	21.00	t
2475	855	\N	ORVAL	2.00	5.00	21.00	t
2476	855	\N	POLPETTE	2.00	14.00	12.00	t
2477	855	\N	COUSCOUS PM	1.00	15.00	12.00	t
2478	855	\N	PÂTES SCAMPIS	2.00	15.00	12.00	t
2484	858	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	f
2485	858	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	f
2486	858	\N	COUSCOUS VG	2.00	10.00	12.00	f
2487	858	\N	COUSCOUS PM	2.00	15.00	12.00	f
2495	861	\N	SOFT (Verre)	1.00	2.00	21.00	f
2496	861	\N	EAU VERRE	1.00	2.00	21.00	f
2500	864	\N	CORNET LARD	1.00	5.00	6.00	f
2504	867	\N	CORNET BOLO	1.00	5.00	6.00	f
2509	870	\N	CORNET BOLO	2.00	5.00	6.00	f
2510	870	\N	CORNET LARD	3.00	5.00	6.00	f
2513	873	\N	CORNET LARD	1.00	5.00	6.00	f
2517	876	\N	CORNET BOLO	2.00	5.00	6.00	t
2518	876	\N	CORNET LARD	2.00	5.00	6.00	t
2522	879	\N	NOURRITURE	-1.00	-2.59	0.00	t
2526	882	\N	CORNET BOLO	1.00	6.00	6.00	f
2527	882	\N	CORNET LARD	1.00	6.00	6.00	f
2528	882	\N	SPAG.COURG.SCAMP.	2.00	16.00	12.00	f
2529	882	\N	PÂTES BOLO/LARD	2.00	12.00	12.00	f
2530	882	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
2531	882	\N	PINOT GRIGIO (2020)	2.00	19.00	21.00	f
2534	885	\N	EAU 1/2 L	2.00	0.00	21.00	f
2535	885	\N	RHUM HAVANA	1.00	0.00	21.00	f
2536	885	\N	RHUM HAVANA	1.00	6.00	21.00	f
2537	885	\N	APPASSIMENTO	1.00	30.00	21.00	f
2538	885	\N	MENU DES FÊTES	2.00	40.00	6.00	f
2550	888	\N	Nouvel An	-1.00	-175.00	0.00	t
2553	891	\N	SERVICE Caro	-1.00	-50.00	0.00	t
2556	894	\N	Choucroute	-1.00	-240.00	0.00	t
2566	897	\N	CREME BRULEE	2.00	5.00	12.00	f
2567	897	\N	POLPETTE	2.00	14.00	12.00	t
2568	897	\N	CHOUCROUTE	6.00	24.00	12.00	f
2569	897	\N	CAFÉ	5.00	2.50	21.00	t
2570	897	\N	PINOT BLANC	2.00	24.00	21.00	t
2571	897	\N	EAU VERRE	1.00	2.00	21.00	t
2572	897	\N	SOFT (Verre)	4.00	2.00	21.00	f
2573	897	\N	PROSECCO VERRE	5.00	5.00	21.00	t
2574	897	\N	TRIPLE SAINTE NITOUCHE	1.00	4.50	21.00	t
2575	897	\N	GIN TONIC	2.00	6.00	21.00	t
2576	897	\N	Cuba-Li	5.00	6.00	21.00	t
3278	1123	\N	CREME BRULEE	1.00	5.00	12.00	t
3279	1123	\N	LIMONCELLO	1.00	5.00	21.00	t
3280	1123	\N	PINOT GRIGIO BLUSH	2.00	19.00	21.00	t
3281	1123	\N	RHUM	2.00	6.00	21.00	t
3282	1123	\N	PÂTES BOLO/LARD	3.00	12.00	12.00	t
3283	1123	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
3286	1126	\N	NOURRITURE	-1.00	-9.70	0.00	t
3289	1129	\N	NOURRITURE	-1.00	-19.00	0.00	t
3292	1132	\N	SERVICE Caro	-1.00	-50.00	0.00	t
3295	1135	\N	SERVICE Caro	-1.00	-50.00	0.00	t
3303	1138	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
3304	1138	\N	PÂTES PESTO	1.00	14.00	12.00	f
3305	1138	\N	PÂTES STRACIATELLA SCAMPIS	1.00	17.00	12.00	f
3306	1138	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	f
3307	1138	\N	TATIN	2.00	8.00	12.00	f
3308	1138	\N	ROUGE VERRE	2.00	5.00	21.00	f
3337	1141	\N	COUSCOUS PM	1.00	15.00	6.00	t
3344	1144	\N	LOYER	-1.00	-600.00	0.00	t
3347	1147	\N	ESPRESSO	4.00	2.50	21.00	f
3348	1147	\N	CARAFE EAU	1.00	0.00	21.00	f
3349	1147	\N	ROUGE VERRE	1.00	5.00	21.00	f
3350	1147	\N	COUSCOUS PM	1.00	15.00	12.00	f
3351	1147	\N	TAJINE	1.00	15.00	12.00	f
3352	1147	\N	EAU 1/2 L	1.00	3.50	21.00	f
3358	1150	\N	IRISH COFFEE	1.00	8.00	21.00	f
3359	1150	\N	COUSCOUS PM	1.00	15.00	12.00	f
3360	1150	\N	BLANC VERRE	1.00	5.00	21.00	f
3361	1150	\N	JUPILER	2.00	2.50	21.00	f
3364	1153	\N	SOFT (Verre)	2.00	2.00	21.00	t
3365	1153	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
3366	1153	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
3375	1156	\N	NOURRITURE	-1.00	-37.55	0.00	t
3383	1159	\N	SABAYON	1.00	8.00	12.00	t
3384	1159	\N	TATIN	1.00	8.00	12.00	t
3385	1159	\N	VIN 1/2	1.00	14.00	21.00	t
3386	1159	\N	COUSCOUS VG	2.00	10.00	12.00	t
3403	1162	\N	CAFÉ	2.00	2.50	21.00	t
3404	1162	\N	COUSCOUS VG	1.00	10.00	12.00	t
2348	805	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
2349	805	\N	PROSECCO VERRE	2.00	5.00	21.00	t
2350	805	\N	CREME BRULEE	2.00	5.00	12.00	t
2351	805	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	t
2352	805	\N	POLPETTE	1.00	14.00	12.00	t
2353	805	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
2356	808	\N	Nettoyage	-1.00	-70.00	0.00	t
2365	811	\N	THÉ MENTHE	2.00	0.00	21.00	t
2366	811	\N	EAU 1/2 L	1.00	3.50	21.00	t
2367	811	\N	POLPETTE	1.00	14.00	12.00	t
2368	811	\N	COUSCOUS VG	1.00	10.00	12.00	t
2371	814	\N	SERVICE Célia	-1.00	-30.00	0.00	t
2374	817	\N	CORNET BOLO	1.00	6.00	6.00	t
2375	817	\N	CORNET LARD	1.00	6.00	6.00	t
2378	820	\N	NOURRITURE	-1.00	-114.81	0.00	t
2383	823	\N	COUSCOUS PM	2.00	15.00	12.00	t
2384	823	\N	PROSECCO Bouteille	1.00	25.00	21.00	f
2385	823	\N	GIN TONIC	4.00	6.00	21.00	f
2388	826	\N	NOURRITURE	-1.00	-69.27	0.00	t
2399	829	\N	COUSCOUS VG	1.00	10.00	12.00	t
2400	829	\N	JUPILER	9.00	2.50	21.00	t
2401	829	\N	ROUGE VERRE	1.00	6.00	21.00	t
2402	829	\N	ROUGE VERRE	1.00	5.00	21.00	t
2403	829	\N	APPASSIMENTO	1.00	30.00	21.00	f
2404	829	\N	SOFT (Verre)	8.00	2.00	21.00	t
2405	829	\N	PROSECCO VERRE	1.00	5.00	21.00	t
2406	829	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	t
2407	829	\N	POLPETTE	2.00	14.00	12.00	t
2408	829	\N	COUSCOUS PM	3.00	15.00	12.00	t
2409	829	\N	BURRATINA	2.00	14.00	12.00	t
2410	829	\N	TCHAKTCHOUKA	1.00	8.00	12.00	t
2411	829	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
2412	829	\N	SCAMPIS LUCIFER	3.00	8.00	12.00	t
2418	832	\N	SERVICE Caro	-1.00	-20.00	0.00	t
2421	835	\N	ROUGE VERRE	1.00	6.00	21.00	t
2422	835	\N	PROSECCO VERRE	1.00	5.00	21.00	t
2423	835	\N	GRAPPA	1.00	5.00	21.00	t
2429	838	\N	FISC	-1.00	-350.00	0.00	t
2432	841	\N	COMPTABLE	-1.00	-151.25	0.00	t
2440	844	\N	THÉ MENTHE	2.00	2.50	21.00	t
2441	844	\N	CREME BRULEE	2.00	5.00	12.00	t
2442	844	\N	SPAG.COURG.SCAMP.	1.00	12.00	12.00	t
2443	844	\N	VIN 1/2	1.00	13.00	21.00	t
2444	844	\N	PROSECCO VERRE	2.00	5.00	21.00	t
2445	844	\N	VIOLETTE	1.00	6.00	21.00	t
2446	844	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
2447	844	\N	COUSCOUS VG	1.00	10.00	12.00	t
2448	844	\N	TCHAKTCHOUKA	1.00	8.00	12.00	t
2449	844	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	t
2454	847	\N	THÉ MENTHE	2.00	2.50	21.00	t
2455	847	\N	IRISH COFFEE	4.00	8.00	21.00	t
2456	847	\N	CAFÉ	2.00	2.50	21.00	t
2457	847	\N	PRIMITIVO NR 14	5.00	24.00	21.00	f
2458	847	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	t
2459	847	\N	ASSIETTE APERITIVE (2 p.)	2.00	15.00	12.00	t
2460	847	\N	COUSCOUS PM	9.00	15.00	12.00	f
2461	847	\N	PINOT GRIGIO (2020)	6.00	19.00	21.00	f
2462	847	\N	EAUX 1 L	3.00	5.00	21.00	t
2463	847	\N	BLANC VERRE	2.00	5.00	21.00	t
2464	847	\N	JUPILER	2.00	2.50	21.00	t
2467	850	\N	NOURRITURE	-1.00	-95.84	0.00	t
2470	853	\N	NOURRITURE	-1.00	-80.00	0.00	t
2479	856	\N	BOISSONS	-1.00	-84.00	0.00	t
2488	859	\N	PÂTES TRUFFE	4.00	17.00	12.00	t
2489	859	\N	PÂTES SCAMPIS	2.00	0.00	12.00	t
2490	859	\N	PECKET FRAISE	10.00	6.00	21.00	t
2491	859	\N	SOFT (Verre)	1.00	2.00	21.00	t
2497	862	\N	CORNET BOLO	3.00	5.00	6.00	f
2498	862	\N	CORNET LARD	1.00	5.00	6.00	f
2501	865	\N	CORNET LARD	1.00	5.00	6.00	f
2505	868	\N	CORNET BOLO	2.00	5.00	6.00	f
2506	868	\N	CORNET LARD	2.00	5.00	6.00	f
2511	871	\N	CORNET LARD	1.00	5.00	6.00	f
2514	874	\N	BLANC VERRE	3.00	5.00	21.00	f
2515	874	\N	JUPILER	2.00	2.50	21.00	f
2519	877	\N	ROUGE VERRE	1.00	5.00	21.00	f
2520	877	\N	CORNET BOLO	1.00	5.00	6.00	f
2523	880	\N	NOURRITURE	-1.00	-48.21	0.00	t
2532	883	\N	NOURRITURE	-1.00	-41.00	0.00	t
2539	886	\N	IRISH COFFEE	1.00	0.00	21.00	t
2540	886	\N	BLANC VERRE	2.00	5.00	21.00	t
2541	886	\N	PROSECCO VERRE	2.00	5.00	21.00	t
2542	886	\N	MENU DES FÊTES	3.00	40.00	6.00	t
2551	889	\N	Fred	-1.00	-400.00	0.00	t
2554	892	\N	Service Véro	-1.00	-50.00	0.00	t
2557	895	\N	CHOUCROUTE	3.00	24.00	12.00	t
2558	895	\N	PROSECCO VERRE	2.00	5.00	21.00	t
2559	895	\N	SOFT (Verre)	1.00	2.00	21.00	t
2577	898	\N	IRISH COFFEE	1.00	8.00	21.00	f
2578	898	\N	GATEAUX MIEL	1.00	5.00	12.00	f
2579	898	\N	CHOUCROUTE	3.00	24.00	12.00	f
2580	898	\N	POLPETTE	3.00	8.00	12.00	f
2581	898	\N	POLPETTE	1.00	14.00	12.00	f
2582	898	\N	PINOT BLANC	2.00	24.00	21.00	f
2583	898	\N	PROSECCO VERRE	1.00	5.00	21.00	f
2584	898	\N	Cuba-Li	2.00	6.00	21.00	f
2585	898	\N	SOFT (Verre)	2.00	2.00	21.00	f
3302	1137	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
3318	1140	\N	APPASSIMENTO	2.00	30.00	21.00	t
3319	1140	\N	Cuba-Li	3.00	6.00	21.00	t
3320	1140	\N	SOFT (Verre)	5.00	2.00	21.00	t
3321	1140	\N	GINGEMBRE	1.00	6.00	21.00	t
3322	1140	\N	VIOLETTE	2.00	6.00	21.00	t
3323	1140	\N	PECKET FRAISE	5.00	6.00	21.00	t
3324	1140	\N	CAFÉ	1.00	2.50	21.00	t
3325	1140	\N	THÉ MENTHE	1.00	2.50	21.00	t
3326	1140	\N	GATEAUX MIEL	1.00	5.00	12.00	t
3327	1140	\N	IRISH COFFEE	3.00	8.00	21.00	t
3328	1140	\N	TATIN	2.00	8.00	12.00	t
3329	1140	\N	PANNA COTTA	1.00	5.00	12.00	t
3330	1140	\N	BURRATINA TRUFFES	1.00	17.00	12.00	t
3331	1140	\N	COUSCOUS PM	1.00	15.00	12.00	t
3332	1140	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
3333	1140	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
3334	1140	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
3335	1140	\N	BOMBE  CALABRÈSE	2.00	15.00	12.00	t
3336	1140	\N	ASSIETTE APERITIVE (2 p.)	2.00	19.00	12.00	t
3343	1143	\N	ENERGIES	-1.00	-210.64	0.00	t
3346	1146	\N	SERVICE Elise	-1.00	-50.00	0.00	t
2354	806	\N	SERVICE Caro	-1.00	-50.00	0.00	t
2357	809	\N	CORNET BOLO	1.00	6.00	6.00	f
2369	812	\N	BLONDINETTE	2.00	5.00	21.00	f
2372	815	\N	NOURRITURE	-1.00	-61.60	0.00	t
2376	818	\N	NOURRITURE	-1.00	-6.99	0.00	t
2379	821	\N	CORNET BOLO	1.00	6.00	6.00	f
2386	824	\N	NOURRITURE	-1.00	-63.60	0.00	t
2389	827	\N	POLPETTE	2.00	14.00	6.00	t
2390	827	\N	PÂTES BOLO/LARD	1.00	12.00	6.00	t
2413	830	\N	ROUGE VERRE	2.00	6.00	21.00	f
2414	830	\N	BLONDINETTE	2.00	3.50	21.00	f
2415	830	\N	COUSCOUS PM	2.00	15.00	12.00	f
2416	830	\N	TCHAKTCHOUKA	1.00	8.00	12.00	f
2419	833	\N	NOURRITURE	-1.00	-4.50	0.00	t
2424	836	\N	PROSECCO VERRE	1.00	5.00	21.00	t
2425	836	\N	JUPILER	2.00	2.50	21.00	t
2430	839	\N	FISC	-1.00	-350.00	0.00	t
2433	842	\N	ROUGE VERRE	2.00	5.00	21.00	f
2434	842	\N	CAFÉ	2.00	2.50	21.00	f
2435	842	\N	BLANC VERRE	1.00	5.00	21.00	f
2436	842	\N	COUSCOUS PM	2.00	15.00	12.00	f
2437	842	\N	JUPILER	2.00	2.50	21.00	f
2450	845	\N	COUSCOUS PM	2.00	15.00	12.00	t
2451	845	\N	CAFÉ	2.00	2.50	21.00	t
2465	848	\N	SERVICE Célia	-1.00	-50.00	0.00	t
2468	851	\N	NOURRITURE	-1.00	-35.50	0.00	t
2471	854	\N	CORNET BOLO	1.00	6.00	6.00	f
2472	854	\N	CORNET LARD	1.00	6.00	6.00	f
2480	857	\N	ROUGE VERRE	2.00	5.00	21.00	f
2481	857	\N	PECKET FRAISE	1.00	6.00	21.00	f
2482	857	\N	COUSCOUS PM	1.00	15.00	12.00	f
2483	857	\N	VIOLETTE	1.00	6.00	21.00	f
2492	860	\N	CREME BRULEE	1.00	5.00	12.00	t
2493	860	\N	CORNET TRUFFE	1.00	7.00	6.00	t
2494	860	\N	SOFT (Verre)	1.00	2.00	21.00	t
2499	863	\N	SOFT (Verre)	1.00	2.00	21.00	f
2502	866	\N	CORNET BOLO	3.00	5.00	6.00	f
2503	866	\N	CORNET LARD	1.00	5.00	6.00	f
2507	869	\N	BLANC VERRE	2.00	4.00	21.00	f
2508	869	\N	JUPILER	1.00	2.50	21.00	f
2512	872	\N	CORNET BOLO	1.00	5.00	6.00	f
2516	875	\N	CORNET LARD	3.00	5.00	6.00	f
2521	878	\N	BOISSONS	-1.00	-94.47	0.00	t
2524	881	\N	POLPETTE	2.00	14.00	12.00	t
2525	881	\N	PROSECCO Bouteille	1.00	25.00	21.00	f
2533	884	\N	NOURRITURE	-1.00	-32.35	0.00	t
2543	887	\N	IRISH COFFEE	3.00	0.00	21.00	f
2544	887	\N	SOFT (Verre)	2.00	0.00	21.00	f
2545	887	\N	PINOT GRIGIO (2020)	2.00	19.00	21.00	f
2546	887	\N	VIOLETTE	1.00	6.00	21.00	f
2547	887	\N	Cuba-Li	2.00	6.00	21.00	f
2548	887	\N	PROSECCO VERRE	1.00	5.00	21.00	f
2549	887	\N	MENU DES FÊTES	4.00	40.00	6.00	f
2552	890	\N	SERVICE Caro	-1.00	-50.00	0.00	t
2555	893	\N	Service Jeff	-1.00	-50.00	0.00	t
2560	896	\N	CAPUCCINO	1.00	2.80	21.00	f
2561	896	\N	CAFÉ	2.00	2.50	21.00	f
2562	896	\N	CREME BRULEE	1.00	5.00	12.00	f
2563	896	\N	CHOUCROUTE	4.00	24.00	12.00	f
2564	896	\N	ROSÉ VERRE	2.00	5.00	21.00	f
2565	896	\N	SOFT (Verre)	6.00	2.00	21.00	f
2586	899	\N	CHOUCROUTE	3.00	24.00	6.00	f
2587	900	\N	SERVICE Caro	-1.00	-50.00	0.00	t
2588	901	\N	NOURRITURE	-1.00	-37.43	0.00	t
2589	902	\N	SOFT (Verre)	1.00	2.00	21.00	t
2590	902	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	t
2591	902	\N	POLPETTE	1.00	14.00	12.00	t
2592	902	\N	GINGEMBRE	1.00	6.00	21.00	t
2593	902	\N	VIOLETTE	1.00	6.00	21.00	t
2594	903	\N	ASSURANCE	-1.00	-166.36	0.00	t
2595	904	\N	NOURRITURE	-1.00	-113.54	0.00	t
2596	905	\N	COUSCOUS VG	1.00	10.00	6.00	t
2597	906	\N	JUPILER	2.00	2.50	21.00	t
2598	906	\N	BLANC VERRE	3.00	5.00	21.00	t
2599	907	\N	COUSCOUS PM	1.00	15.00	6.00	f
2600	908	\N	BLANC VERRE	3.00	5.00	21.00	f
2601	908	\N	JUPILER	1.00	2.00	21.00	f
2602	909	\N	JUPILER	1.00	2.50	21.00	f
2603	909	\N	BLANC VERRE	2.00	5.00	21.00	f
2604	909	\N	CAFÉ	1.00	2.50	21.00	f
2605	910	\N	IRISH COFFEE	1.00	0.00	21.00	f
2606	910	\N	THÉ MENTHE	1.00	0.00	21.00	f
2607	910	\N	BLANC VERRE	2.00	5.00	21.00	f
2608	910	\N	APPASSIMENTO	1.00	30.00	21.00	f
2609	910	\N	COUSCOUS PM	2.00	15.00	12.00	f
2610	910	\N	TCHAKTCHOUKA	2.00	8.00	12.00	f
2611	910	\N	VIOLETTE	2.00	6.00	21.00	f
2612	911	\N	JUPILER	2.00	2.50	21.00	f
2613	912	\N	NOURRITURE	-1.00	-29.50	0.00	t
2614	913	\N	NOURRITURE	-1.00	-14.99	0.00	t
2615	914	\N	SPAG.COURG.SCAMP.	1.00	16.00	12.00	t
2616	914	\N	POLPETTE	1.00	14.00	12.00	t
2617	914	\N	ROUGE VERRE	1.00	5.00	21.00	t
2618	914	\N	BLONDINETTE	1.00	3.50	21.00	t
2619	914	\N	PROSECCO VERRE	1.00	5.00	21.00	t
2620	915	\N	COUSCOUS PM	4.00	15.00	12.00	t
2621	915	\N	CREME BRULEE	3.00	5.00	12.00	f
2622	915	\N	IRISH COFFEE	1.00	8.00	21.00	t
2623	915	\N	VIN 1/2	1.00	20.00	21.00	f
2624	915	\N	VIN 1/2	1.00	16.00	21.00	f
2625	915	\N	PINOT GRIGIO (2020)	1.00	19.00	21.00	f
2626	915	\N	GINGEMBRE	1.00	6.00	21.00	t
2627	916	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
2628	916	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
2629	917	\N	COUSCOUS PM	1.00	15.00	12.00	t
2630	917	\N	POLPETTE	1.00	14.00	12.00	t
2631	917	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	t
2632	917	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	t
2633	917	\N	ROUGE VERRE	2.00	6.00	21.00	t
2634	917	\N	GINGEMBRE	1.00	6.00	21.00	t
2635	917	\N	VIOLETTE	1.00	6.00	21.00	t
2636	918	\N	LOYER	-1.00	-600.00	0.00	t
2637	919	\N	SERVICE Caro	-1.00	-50.00	0.00	t
2638	920	\N	SERVICE Caro	-1.00	-50.00	0.00	t
2639	921	\N	ENERGIES	-1.00	-253.46	0.00	t
2640	922	\N	CARBURANT	-1.00	-416.52	0.00	t
2641	923	\N	CORNET LARD	1.00	6.00	6.00	t
2642	924	\N	ESPRESSO	1.00	2.50	21.00	t
2643	924	\N	CREME BRULEE	1.00	5.00	12.00	t
2644	924	\N	COUSCOUS PM	2.00	15.00	12.00	t
2645	924	\N	APPASSIMENTO	1.00	30.00	21.00	t
2650	927	\N	NOURRITURE	-1.00	-140.00	0.00	t
2655	930	\N	COUSCOUS PM	1.00	15.00	12.00	t
2656	930	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
2657	930	\N	ROUGE VERRE	2.00	5.00	21.00	f
2658	930	\N	PROSECCO VERRE	2.00	5.00	21.00	f
2666	933	\N	NOURRITURE	-1.00	-13.42	0.00	t
2679	936	\N	LIMONCELLO	2.00	0.00	21.00	f
2680	936	\N	THÉ MENTHE	1.00	2.50	21.00	t
2681	936	\N	CAFÉ	1.00	2.50	21.00	t
2682	936	\N	VIN 1/2	1.00	20.00	21.00	f
2683	936	\N	CREME BRULEE	2.00	5.00	12.00	t
2684	936	\N	COUSCOUS PM	2.00	15.00	12.00	t
2685	936	\N	Cuba-Li	2.00	6.00	21.00	f
2697	939	\N	BLANC VERRE	2.00	5.00	21.00	t
2698	939	\N	GIN TONIC	1.00	6.00	21.00	t
2699	939	\N	PÂTES SCAMPIS	1.00	15.00	12.00	t
2700	939	\N	POLPETTE	1.00	14.00	12.00	t
2701	939	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
2720	942	\N	SERVICE Caro	-1.00	-50.00	0.00	t
2723	945	\N	NOURRITURE	-1.00	-21.81	0.00	t
2726	948	\N	NOURRITURE	-1.00	-8.51	0.00	t
2731	951	\N	POLPETTE	1.00	14.00	12.00	t
2732	951	\N	COUSCOUS PM	1.00	15.00	12.00	t
2745	954	\N	COUSCOUS PM	2.00	15.00	12.00	t
2746	954	\N	EAU 1/2 L	1.00	3.50	21.00	t
2747	954	\N	BLANC VERRE	5.00	5.00	21.00	f
2748	954	\N	PÂTES SCAMPIS	1.00	15.00	12.00	t
2749	954	\N	VIOLETTE	2.00	6.00	21.00	t
2771	957	\N	SERVICE Caro	-1.00	-50.00	0.00	t
2774	960	\N	NOURRITURE	-1.00	-18.27	0.00	t
2777	963	\N	THÉ MENTHE	2.00	2.50	21.00	t
2778	963	\N	PANNA COTTA	1.00	5.00	12.00	t
2779	963	\N	PINOT GRIGIO (2020)	1.00	19.00	21.00	t
2780	963	\N	SPAG.COURG.SCAMP.	1.00	16.00	12.00	t
2781	963	\N	POLPETTE	1.00	14.00	12.00	t
2782	963	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	t
2783	963	\N	TCHAKTCHOUKA	1.00	8.00	12.00	t
2786	966	\N	PROCES	-1.00	-111.02	0.00	t
2789	969	\N	SODEXO	-1.00	-100.00	0.00	t
2794	972	\N	SPAG.COURG.SCAMP.	1.00	16.00	12.00	t
2795	972	\N	ESPRESSO	1.00	2.50	21.00	t
2796	972	\N	CHARDONNAY FIO	1.00	20.00	21.00	t
2802	975	\N	NOURRITURE	-1.00	-7.00	0.00	t
2805	978	\N	COUSCOUS PM	1.00	15.00	12.00	t
2806	978	\N	CAFÉ	1.00	2.50	21.00	t
2807	978	\N	CREME BRULEE	1.00	5.00	12.00	t
2808	978	\N	PANNA COTTA	1.00	5.00	12.00	t
2809	978	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
2810	978	\N	SPAG.COURG.SCAMP.	1.00	16.00	12.00	t
2811	978	\N	BULLES 0% VERRE	2.00	5.00	21.00	t
2817	981	\N	Nettoyage	-1.00	-70.00	0.00	t
2820	984	\N	CORNET BOLO	1.00	6.00	6.00	t
2823	987	\N	ROUGE VERRE	1.00	5.00	21.00	t
2824	987	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
2836	990	\N	POLPETTE	1.00	14.00	12.00	t
2837	990	\N	BLANC VERRE	1.00	5.00	21.00	t
2838	990	\N	PROSECCO VERRE	1.00	5.00	21.00	t
2839	990	\N	VIOLETTE	1.00	6.00	21.00	t
2847	993	\N	SERVICE Caro	-1.00	-50.00	0.00	t
2868	996	\N	SOFT (Verre)	5.00	2.00	21.00	f
2869	996	\N	EAUX 1 L	2.00	5.00	21.00	f
2870	996	\N	PRIMITIVO NR 14	2.00	24.00	21.00	f
2871	996	\N	CHARDONNAY (2020)	1.00	19.00	21.00	f
2872	996	\N	COUSCOUS PM	1.00	15.00	12.00	f
2873	996	\N	COUSCOUS PM	8.00	15.00	12.00	f
2874	996	\N	PÂTES TRUFFE	1.00	17.00	12.00	f
2875	996	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	f
2876	996	\N	TCHAKTCHOUKA	1.00	10.00	12.00	f
2877	996	\N	PROSECCO VERRE	4.00	5.00	21.00	f
2878	996	\N	PINOT GRIGIO (2020)	5.00	19.00	21.00	f
2879	996	\N	BLANC VERRE	4.00	5.00	21.00	f
2880	996	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
2884	999	\N	PRIMITIVO NR 14	3.00	20.00	21.00	f
2888	1002	\N	CREME BRULEE	2.00	5.00	12.00	t
2889	1002	\N	CAFÉ	2.00	2.50	21.00	t
2890	1002	\N	SOFT (Verre)	5.00	2.00	21.00	t
2891	1002	\N	PÂTES TRUFFE	2.00	17.00	12.00	t
2892	1002	\N	BURRATINA	1.00	14.00	12.00	t
2893	1002	\N	POLPETTE	1.00	15.00	12.00	t
2912	1005	\N	SERVICE Célia	-1.00	-53.07	0.00	t
2915	1008	\N	NOURRITURE	-1.00	-24.51	0.00	t
2918	1011	\N	CAFÉ	1.00	2.50	21.00	t
2919	1011	\N	THÉ MENTHE	1.00	2.50	21.00	t
2920	1011	\N	COUSCOUS PM	2.00	15.00	12.00	t
2921	1011	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
2922	1011	\N	BLONDINETTE	2.00	3.50	21.00	t
2926	1014	\N	NOURRITURE	-1.00	-11.36	0.00	t
2931	1017	\N	COUSCOUS PM	1.00	15.00	12.00	t
2932	1017	\N	BLANC VERRE	2.00	5.00	21.00	f
2933	1017	\N	PROSECCO VERRE	2.00	5.00	21.00	f
2936	1020	\N	CAPUCCINO	1.00	3.00	21.00	t
2937	1020	\N	TAJINE	1.00	15.00	12.00	t
2938	1020	\N	COUSCOUS PM	1.00	15.00	12.00	f
2946	1023	\N	CHAUFFAGE	-1.00	-290.95	0.00	t
2949	1026	\N	ROUGE VERRE	1.00	5.00	21.00	f
2950	1026	\N	POLPETTE	1.00	15.00	12.00	f
2951	1026	\N	COUSCOUS PM	1.00	15.00	12.00	t
2952	1026	\N	VIOLETTE	1.00	6.00	21.00	t
2953	1026	\N	TRIPLE SAINTE NITOUCHE	2.00	4.50	21.00	f
2965	1029	\N	LIMONCELLO	1.00	0.00	21.00	t
2966	1029	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
2967	1029	\N	COUSCOUS PM	1.00	15.00	12.00	t
2968	1029	\N	COUSCOUS PM	1.00	15.00	12.00	t
2969	1029	\N	RHUM	2.00	6.00	21.00	t
2970	1029	\N	SAMBUCA	1.00	0.00	21.00	t
3354	1149	\N	CAFÉ	2.00	2.50	21.00	t
3355	1149	\N	Cuba-Li	1.00	6.00	21.00	t
3356	1149	\N	POLPETTE	1.00	15.00	12.00	t
3357	1149	\N	BURRATINA PESTO	1.00	15.00	12.00	t
3363	1152	\N	BOISSONS	-1.00	-186.00	0.00	t
3374	1155	\N	NOURRITURE	-1.00	-56.55	0.00	t
3377	1158	\N	BLONDINETTE	1.00	3.50	21.00	t
3378	1158	\N	ROUGE VERRE	1.00	5.00	21.00	t
3379	1158	\N	SOFT (Verre)	2.00	2.00	21.00	t
3380	1158	\N	TAJINE	1.00	15.00	12.00	t
3381	1158	\N	COUSCOUS PM	1.00	15.00	12.00	t
3382	1158	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
3405	1162	\N	COUSCOUS PM	1.00	15.00	12.00	t
2646	925	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
2647	925	\N	POLPETTE	1.00	14.00	12.00	t
2648	925	\N	BLANC VERRE	4.00	5.00	21.00	f
2651	928	\N	NOURRITURE	-1.00	-50.07	0.00	t
2659	931	\N	PINOT BLANC	1.00	24.00	21.00	f
2660	931	\N	COUSCOUS PM	3.00	15.00	6.00	f
2667	934	\N	CAFÉ	1.00	2.50	21.00	t
2668	934	\N	CREME BRULEE	1.00	5.00	12.00	t
2669	934	\N	EAU 1/2 L	1.00	0.00	21.00	t
2670	934	\N	BLANC VERRE	1.00	5.00	21.00	t
2671	934	\N	CHOUCROUTE	1.00	24.00	12.00	t
2672	934	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
2673	934	\N	APPASSIMENTO	2.00	30.00	21.00	t
2686	937	\N	COUSCOUS PM	1.00	15.00	6.00	f
2687	937	\N	PÂTES TRUFFE	1.00	17.00	6.00	f
2688	937	\N	PÂTES BOLO/LARD	1.00	12.00	6.00	f
2689	937	\N	BURRATINA	2.00	14.00	12.00	f
2690	937	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	6.00	f
2702	940	\N	VIOLETTE	1.00	6.00	21.00	t
2703	940	\N	AMARETTO	1.00	5.00	21.00	t
2704	940	\N	BLANC VERRE	1.00	5.00	21.00	t
2705	940	\N	LIMONCELLO	1.00	5.00	21.00	t
2706	940	\N	GRAPPA	2.00	5.00	21.00	t
2707	940	\N	SOFT (Verre)	1.00	2.00	21.00	t
2721	943	\N	SERVICE Caro	-1.00	-50.00	0.00	t
2724	946	\N	NOURRITURE	-1.00	-8.57	0.00	t
2727	949	\N	CORNET BOLO	1.00	6.00	6.00	t
2733	952	\N	VIN 1/2	1.00	7.00	21.00	f
2734	952	\N	TRIPLE SAINTE NITOUCHE	1.00	4.50	21.00	f
2735	952	\N	PROSECCO VERRE	1.00	5.00	21.00	f
2736	952	\N	Cuba-Li	1.00	6.00	21.00	f
2737	952	\N	COUSCOUS PM	1.00	15.00	12.00	f
2738	952	\N	COUSCOUS PM	2.00	15.00	12.00	f
2739	952	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
2750	955	\N	THÉ MENTHE	1.00	2.50	21.00	t
2751	955	\N	IRISH COFFEE	1.00	8.00	21.00	t
2752	955	\N	JUPILER	4.00	2.50	21.00	t
2753	955	\N	ROUGE VERRE	1.00	5.00	21.00	t
2754	955	\N	SOFT (Verre)	5.00	2.00	21.00	t
2755	955	\N	PROSECCO VERRE	1.00	5.00	21.00	t
2756	955	\N	VIOLETTE	1.00	6.00	21.00	t
2757	955	\N	GINGEMBRE	1.00	6.00	21.00	t
2758	955	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	t
2759	955	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	t
2760	955	\N	PÂTES TRUFFE	2.00	17.00	12.00	t
2761	955	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
2772	958	\N	NOURRITURE	-1.00	-18.93	0.00	t
2775	961	\N	COUSCOUS PM	5.00	15.00	6.00	t
2784	964	\N	SERVICE Caro	-1.00	-50.00	0.00	t
2787	967	\N	NOURRITURE	-1.00	-59.00	0.00	t
2790	970	\N	FISC	-1.00	-91.16	0.00	t
2797	973	\N	SPAG.COURG.SCAMP.	1.00	16.00	12.00	t
2803	976	\N	NOURRITURE	-1.00	-12.30	0.00	t
2812	979	\N	PÂTES BOLO/LARD	1.00	0.00	12.00	t
2813	979	\N	SPAG.COURG.SCAMP.	1.00	0.00	12.00	t
2814	979	\N	SOFT (Verre)	1.00	0.00	21.00	t
2815	979	\N	VIOLETTE	1.00	0.00	21.00	t
2818	982	\N	NOURRITURE	-1.00	-13.82	0.00	t
2821	985	\N	SABAM	-1.00	-36.04	0.00	t
2825	988	\N	GRAPPA	1.00	0.00	21.00	t
2826	988	\N	SAMBUCA	1.00	0.00	21.00	t
2827	988	\N	ROUGE VERRE	2.00	0.00	21.00	t
2828	988	\N	CREME BRULEE	1.00	5.00	12.00	t
2829	988	\N	PANNA COTTA	1.00	5.00	12.00	t
2830	988	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
2831	988	\N	POLPETTE	1.00	14.00	12.00	t
2832	988	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	t
2833	988	\N	CHIARETTO	1.00	19.00	21.00	t
2834	988	\N	CHIARETTO 1/2	1.00	14.00	21.00	t
2840	991	\N	THÉ MENTHE	2.00	2.50	21.00	t
2841	991	\N	BLANC VERRE	2.00	5.00	21.00	t
2842	991	\N	VIOLETTE	1.00	6.00	21.00	t
2843	991	\N	Cuba-Li	1.00	6.00	21.00	t
2844	991	\N	PÂTES BOLO/LARD	2.00	12.00	12.00	t
2845	991	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	t
2848	994	\N	AMARETTO	1.00	0.00	21.00	f
2849	994	\N	THÉ MENTHE	1.00	0.00	21.00	f
2850	994	\N	THÉ MENTHE	1.00	2.50	21.00	f
2851	994	\N	ROUGE VERRE	2.00	5.00	21.00	f
2852	994	\N	BLANC VERRE	1.00	5.00	21.00	f
2853	994	\N	TRIPLE SAINTE NITOUCHE	1.00	4.50	21.00	f
2854	994	\N	IRISH COFFEE	1.00	8.00	21.00	f
2855	994	\N	CREME BRULEE	1.00	5.00	12.00	f
2856	994	\N	PROSECCO VERRE	2.00	5.00	21.00	f
2857	994	\N	PÂTES TRUFFE	1.00	17.00	12.00	f
2858	994	\N	COUSCOUS PM	1.00	15.00	12.00	f
2881	997	\N	POLPETTE	1.00	15.00	12.00	f
2882	997	\N	COUSCOUS PM	2.00	15.00	12.00	f
2885	1000	\N	CORNET BOLO	2.00	6.00	6.00	f
2894	1003	\N	LIMONCELLO	1.00	0.00	21.00	t
2895	1003	\N	RHUM HAVANA	1.00	0.00	21.00	t
2896	1003	\N	AMARETTO	1.00	0.00	21.00	t
2897	1003	\N	PINOT GRIGIO (2020)	1.00	19.00	21.00	t
2898	1003	\N	CREME BRULEE	1.00	5.00	12.00	t
2899	1003	\N	IRISH COFFEE	1.00	8.00	21.00	t
2900	1003	\N	COUSCOUS PM	2.00	15.00	12.00	t
2901	1003	\N	POLPETTE	1.00	15.00	12.00	t
2913	1006	\N	SERVICE Célia	-1.00	-53.07	0.00	t
2916	1009	\N	NOURRITURE	-1.00	-14.25	0.00	t
2923	1012	\N	CORNET LARD	1.00	6.00	6.00	t
2927	1015	\N	CORNET TRUFFE	1.00	7.00	6.00	t
2934	1018	\N	COMPTABLE	-1.00	-363.00	0.00	t
2939	1021	\N	PANNA COTTA	1.00	5.00	12.00	t
2940	1021	\N	CREME BRULEE	1.00	5.00	12.00	f
2941	1021	\N	TAJINE	1.00	15.00	12.00	t
2942	1021	\N	COUSCOUS VG	1.00	10.00	12.00	f
2943	1021	\N	THÉ MENTHE	1.00	2.50	21.00	t
2944	1021	\N	GINGEMBRE	1.00	6.00	21.00	f
2947	1024	\N	NOURRITURE	-1.00	-65.40	0.00	t
2954	1027	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	t
2955	1027	\N	CREME BRULEE	3.00	5.00	12.00	t
2956	1027	\N	VIN 1/2	1.00	14.00	21.00	t
2957	1027	\N	VIN 1/2	1.00	20.00	21.00	f
2958	1027	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	t
2959	1027	\N	COUSCOUS PM	3.00	15.00	12.00	f
3387	1160	\N	THÉ MENTHE	1.00	2.50	21.00	f
3388	1160	\N	CAFÉ	1.00	2.50	21.00	f
3389	1160	\N	SABAYON	1.00	8.00	12.00	f
3390	1160	\N	CREME BRULEE	1.00	5.00	12.00	f
2649	926	\N	NOURRITURE	-1.00	-32.33	0.00	t
2652	929	\N	CORNET BOLO	1.00	6.00	6.00	t
2653	929	\N	CORNET TRUFFE	1.00	7.00	6.00	t
2654	929	\N	CORNET LARD	1.00	6.00	6.00	t
2661	932	\N	CORNET TRUFFE	1.00	7.00	6.00	t
2662	932	\N	CORNET LARD	2.00	6.00	6.00	t
2663	932	\N	SOFT (Verre)	1.00	2.00	21.00	t
2664	932	\N	BLONDINETTE	2.00	3.50	21.00	t
2665	932	\N	JUPILER	1.00	2.50	21.00	t
2674	935	\N	ROUGE VERRE	1.00	5.00	21.00	t
2675	935	\N	PROSECCO VERRE	1.00	5.00	21.00	t
2676	935	\N	GRAPPA	1.00	5.00	21.00	t
2677	935	\N	RHUM HAVANA	1.00	6.00	21.00	t
2678	935	\N	CAFÉ	2.00	2.50	21.00	t
2691	938	\N	VIOLETTE	1.00	6.00	21.00	t
2692	938	\N	SOFT (Verre)	2.00	2.00	21.00	t
2693	938	\N	PROSECCO VERRE	2.00	5.00	21.00	t
2694	938	\N	SPAG.COURG.SCAMP.	2.00	16.00	12.00	t
2695	938	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	t
2696	938	\N	TCHAKTCHOUKA	1.00	8.00	12.00	t
2708	941	\N	PINOT BLANC	2.00	24.00	21.00	t
2709	941	\N	VIN 1/2	1.00	14.00	21.00	t
2710	941	\N	VIOLETTE	2.00	6.00	21.00	t
2711	941	\N	PROSECCO VERRE	3.00	5.00	21.00	t
2712	941	\N	SPAG.COURG.SCAMP.	2.00	16.00	12.00	t
2713	941	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	t
2714	941	\N	SPAG.COURG.SCAMP.	2.00	16.00	12.00	t
2715	941	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
2716	941	\N	PÂTES BOLO/LARD	2.00	12.00	12.00	t
2717	941	\N	SCAMPIS LUCIFER	1.00	8.00	12.00	t
2718	941	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	t
2719	941	\N	TCHAKTCHOUKA	2.00	8.00	12.00	t
2722	944	\N	NOURRITURE	-1.00	-12.34	0.00	t
2725	947	\N	NOURRITURE	-1.00	-6.58	0.00	t
2728	950	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	t
2729	950	\N	PÂTES SCAMPIS	1.00	15.00	12.00	t
2730	950	\N	POLPETTE	1.00	14.00	12.00	t
2740	953	\N	BLANC VERRE	1.00	4.00	21.00	t
2741	953	\N	JUPILER	1.00	2.50	21.00	t
2742	953	\N	PROSECCO VERRE	1.00	5.00	21.00	t
2743	953	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
2744	953	\N	PÂTES BOLO/LARD	2.00	12.00	12.00	t
2762	956	\N	IRISH COFFEE	4.00	8.00	21.00	t
2763	956	\N	PRIMITIVO NR 14	2.00	24.00	21.00	t
2764	956	\N	BLANC VERRE	3.00	5.00	21.00	t
2765	956	\N	BLONDINETTE	2.00	3.50	21.00	t
2766	956	\N	Cuba-Li	1.00	6.00	21.00	t
2767	956	\N	GINGEMBRE	2.00	6.00	21.00	t
2768	956	\N	PÂTES TRUFFE	1.00	17.00	12.00	t
2769	956	\N	COUSCOUS PM	3.00	15.00	12.00	t
2770	956	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
2773	959	\N	NOURRITURE	-1.00	-78.90	0.00	t
2776	962	\N	COUSCOUS VG	2.00	10.00	6.00	t
2785	965	\N	THERMES	-1.00	-239.50	0.00	t
2788	968	\N	ORANGE	-1.00	-25.00	0.00	t
2791	971	\N	SPAG.COURG.SCAMP.	1.00	16.00	12.00	t
2792	971	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
2793	971	\N	JUPILER	2.00	2.50	21.00	t
2798	974	\N	PANNA COTTA	2.00	0.00	12.00	t
2799	974	\N	POLPETTE	2.00	0.00	12.00	t
2800	974	\N	SCAMPIS LUCIFER	1.00	0.00	12.00	t
2801	974	\N	CHAMPIGNONS KABYLES	1.00	0.00	12.00	t
2804	977	\N	NOURRITURE	-1.00	-24.32	0.00	t
2816	980	\N	NOURRITURE	-1.00	-64.92	0.00	t
2819	983	\N	NOURRITURE	-1.00	-20.00	0.00	t
2822	986	\N	CORNET TRUFFE	1.00	7.00	6.00	t
2835	989	\N	COUSCOUS PM	5.00	15.00	6.00	t
2846	992	\N	SERVICE Elise	-1.00	-30.00	0.00	t
2859	995	\N	CAFÉ	1.00	0.00	21.00	f
2860	995	\N	VIN 1/2	1.00	20.00	21.00	f
2861	995	\N	AMARETTO	1.00	0.00	21.00	f
2862	995	\N	PANNA COTTA	1.00	5.00	12.00	f
2863	995	\N	CREME BRULEE	1.00	5.00	12.00	f
2864	995	\N	PROSECCO VERRE	2.00	5.00	21.00	f
2865	995	\N	PÂTES SCAMPIS	1.00	15.00	12.00	f
2866	995	\N	COUSCOUS PM	2.00	15.00	12.00	f
2867	995	\N	CHAMPIGNONS KABYLES	1.00	6.00	12.00	f
2883	998	\N	COUSCOUS PM	2.00	15.00	12.00	f
2886	1001	\N	CORNET TRUFFE	1.00	7.00	6.00	f
2887	1001	\N	JUPILER	2.00	2.00	21.00	f
2902	1004	\N	ROUGE VERRE	1.00	0.00	21.00	f
2903	1004	\N	BULLES 0% VERRE	1.00	5.00	21.00	t
2904	1004	\N	CREME BRULEE	1.00	5.00	12.00	f
2905	1004	\N	ROUGE VERRE	1.00	5.00	21.00	f
2906	1004	\N	VIN 1/2	1.00	14.00	21.00	f
2907	1004	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	t
2908	1004	\N	COUSCOUS PM	1.00	15.00	12.00	t
2909	1004	\N	BLANC VERRE	1.00	5.00	21.00	f
2910	1004	\N	SOFT (Verre)	2.00	2.00	21.00	f
2911	1004	\N	VIOLETTE	1.00	6.00	21.00	f
2914	1007	\N	PROCES	-1.00	-159.00	0.00	t
2917	1010	\N	BOISSONS	-1.00	-137.40	0.00	t
2924	1013	\N	JUPILER	1.00	2.50	21.00	t
2925	1013	\N	BLONDINETTE	1.00	3.50	21.00	t
2928	1016	\N	COUSCOUS PM	2.00	15.00	6.00	t
2929	1016	\N	TAJINE	1.00	15.00	6.00	t
2930	1016	\N	CORNET TRUFFE	1.00	7.00	6.00	t
2935	1019	\N	ORANGE	-1.00	-14.00	0.00	t
2945	1022	\N	LOYER	-1.00	-600.00	0.00	t
2948	1025	\N	NOURRITURE	-1.00	-26.25	0.00	t
2960	1028	\N	PROSECCO VERRE	1.00	5.00	21.00	t
2961	1028	\N	ROUGE VERRE	2.00	5.00	21.00	f
2962	1028	\N	BLANC VERRE	3.00	5.00	21.00	f
2963	1028	\N	COUSCOUS PM	1.00	15.00	12.00	t
2964	1028	\N	TAJINE	1.00	15.00	12.00	t
3391	1160	\N	PÂTES TRUFFE	1.00	15.00	12.00	f
3392	1160	\N	COUSCOUS PM	1.00	15.00	12.00	f
3393	1160	\N	COUSCOUS PM	1.00	15.00	12.00	f
3394	1160	\N	THÉ MENTHE	1.00	0.00	21.00	f
3395	1160	\N	GRAPPA	1.00	0.00	21.00	f
3396	1160	\N	VIN 1/2	1.00	20.00	21.00	f
3397	1160	\N	EAU 1/2 L	1.00	3.50	21.00	f
3398	1160	\N	SOFT (Verre)	1.00	2.00	21.00	f
3406	1162	\N	CAFÉ	1.00	0.00	21.00	t
3407	1162	\N	LIMONCELLO	2.00	0.00	21.00	t
3408	1162	\N	BLANC VERRE	2.00	5.00	21.00	t
3409	1162	\N	SOFT (Verre)	2.00	2.00	21.00	t
3410	1162	\N	PÂTES TRUFFE	1.00	15.00	12.00	t
3411	1163	\N	CORNET TRUFFE	1.00	7.00	6.00	t
3420	1165	\N	SERVICE Caro	-1.00	-50.00	0.00	t
3478	1178	\N	PROSECCO VERRE	5.00	5.00	21.00	f
3479	1178	\N	GIN TONIC	2.00	6.00	21.00	f
3480	1178	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
3483	1181	\N	NOURRITURE	-1.00	-3.98	0.00	t
3487	1184	\N	ROSÉ VERRE	1.00	5.00	21.00	f
3488	1184	\N	PINOT GRIGIO BLUSH	2.00	19.00	21.00	f
3489	1184	\N	BURRATINA PESTO	1.00	15.00	12.00	f
3490	1184	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	f
3501	1187	\N	NOURRITURE	-1.00	-24.52	0.00	t
3504	1190	\N	Resto Louna	-1.00	-59.80	0.00	t
3507	1193	\N	SODEXO	-1.00	-60.00	0.00	t
3510	1196	\N	UCM	-1.00	-163.70	0.00	t
3513	1199	\N	NOURRITURE	-1.00	-64.79	0.00	t
3516	1202	\N	CAPUCCINO	1.00	2.80	21.00	t
3517	1202	\N	CAFÉ	1.00	2.50	21.00	t
3518	1202	\N	SOFT (Verre)	2.00	2.00	21.00	t
3519	1202	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	t
3520	1202	\N	COUSCOUS PM	1.00	15.00	12.00	t
3530	1205	\N	CREME BRULEE	1.00	5.00	12.00	t
3531	1205	\N	PANNA COTTA	1.00	5.00	12.00	t
3532	1205	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	t
3533	1205	\N	SOFT (Verre)	2.00	2.00	21.00	t
3534	1205	\N	PECKET FRAISE	1.00	6.00	21.00	t
3535	1205	\N	BURRATINA PESTO	1.00	15.00	12.00	t
3536	1205	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	t
3540	1208	\N	COUSCOUS VG	1.00	10.00	6.00	f
3541	1208	\N	COUSCOUS PM	2.00	15.00	6.00	f
3548	1211	\N	NOURRITURE	-1.00	-8.71	0.00	t
3555	1214	\N	SERVICE Elise	-1.00	-40.00	0.00	t
3558	1217	\N	SABAYON	1.00	8.00	12.00	f
3559	1217	\N	TATIN	1.00	8.00	12.00	f
3560	1217	\N	PECKET FRAISE	2.00	6.00	21.00	f
3561	1217	\N	BURRATINA TRUFFES	1.00	17.00	12.00	f
3562	1217	\N	COUSCOUS PM	1.00	15.00	12.00	f
3565	1220	\N	NOURRITURE	-1.00	-7.00	0.00	t
3576	1223	\N	ROUGE VERRE	1.00	5.00	21.00	f
3577	1223	\N	BLANC VERRE	1.00	5.00	21.00	f
3586	1226	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
3587	1226	\N	BURRATINA TRUFFES	1.00	17.00	12.00	t
3588	1226	\N	TAJINE	1.00	15.00	12.00	t
3589	1226	\N	COUSCOUS VG	1.00	10.00	12.00	t
3590	1226	\N	COUSCOUS PM	1.00	15.00	12.00	t
3591	1226	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
3592	1226	\N	ORVAL	1.00	5.00	21.00	t
3593	1226	\N	PROSECCO VERRE	2.00	5.00	21.00	t
3594	1226	\N	BULLES 0% VERRE	1.00	5.00	21.00	t
3607	1229	\N	Service Sara	-1.00	-30.00	0.00	t
3610	1232	\N	NOURRITURE	-1.00	-111.00	0.00	t
3613	1235	\N	PINOT GRIGIO BLUSH	1.00	19.00	21.00	t
3614	1235	\N	BURRATINA PESTO	1.00	15.00	12.00	t
3615	1235	\N	COUSCOUS PM	1.00	15.00	12.00	t
3616	1235	\N	Cuba-Li	1.00	6.00	21.00	t
3617	1235	\N	PANNA COTTA	1.00	5.00	12.00	t
3618	1235	\N	CREME BRULEE	1.00	5.00	12.00	t
3619	1235	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
3620	1235	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
3621	1235	\N	JUPILER	1.00	2.50	21.00	t
3632	1238	\N	JUPILER	4.00	2.50	21.00	f
3635	1241	\N	MENU À 35	1.00	64.00	12.00	f
3638	1244	\N	COUSCOUS PM	3.00	15.00	6.00	t
3644	1247	\N	BOISSONS	-1.00	-78.00	0.00	t
3658	1250	\N	SERVICE Célia	-1.00	-50.00	0.00	t
3661	1253	\N	Service Véro	-1.00	-30.00	0.00	t
3664	1256	\N	MATERIEL	-1.00	-3.49	0.00	t
3679	1259	\N	APPASSIMENTO	1.00	30.00	21.00	f
3680	1259	\N	VERLAINOISE	1.00	4.00	6.00	f
3681	1259	\N	SOFT (Verre)	1.00	2.00	21.00	f
3682	1259	\N	GINGEMBRE	1.00	0.00	21.00	f
3683	1259	\N	CREME BRULEE	1.00	5.00	12.00	f
3684	1259	\N	TATIN	1.00	8.00	12.00	f
3685	1259	\N	IRISH COFFEE	1.00	0.00	21.00	f
3686	1259	\N	IRISH COFFEE	1.00	8.00	21.00	f
3687	1259	\N	BOMBE  CALABRÈSE	1.00	0.00	12.00	f
3688	1259	\N	COUSCOUS VG	1.00	10.00	12.00	f
3689	1259	\N	COUSCOUS PM	1.00	15.00	12.00	f
3690	1259	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	f
3691	1259	\N	TCHAKTCHOUKA	1.00	10.00	12.00	f
3709	1262	\N	SERVICE Caro	-1.00	-50.00	0.00	t
3712	1265	\N	NOURRITURE	-1.00	-40.00	0.00	t
3716	1268	\N	Fred	-1.00	-400.00	0.00	t
3721	1271	\N	APPASSIMENTO	1.00	6.00	21.00	t
3722	1271	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
3731	1274	\N	CAFÉ	1.00	2.50	21.00	f
3732	1274	\N	PROSECCO VERRE	3.00	5.00	21.00	f
3735	1277	\N	SOFT (Verre)	2.00	2.00	21.00	f
3736	1277	\N	CORNET BOLO	1.00	6.00	6.00	f
3737	1277	\N	CORNET LARD	1.00	6.00	6.00	f
3741	1280	\N	ESPRESSO	1.00	2.50	21.00	f
3742	1280	\N	CREME BRULEE	1.00	5.00	12.00	f
3743	1280	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	f
3744	1280	\N	SPAG.COURGETTE	1.00	14.00	12.00	f
3745	1280	\N	CHARDONNAY FIO	1.00	5.00	21.00	f
3746	1280	\N	ROUGE VERRE	1.00	6.00	21.00	f
3747	1280	\N	VERLAINOISE	1.00	4.00	6.00	f
3750	1283	\N	NOURRITURE	-1.00	-3.50	0.00	t
3753	1286	\N	CREME BRULEE	1.00	5.00	6.00	f
3766	1289	\N	CAPUCCINO	2.00	2.80	21.00	f
3771	1292	\N	CORNET LARD	1.00	6.00	6.00	f
3778	1295	\N	NOURRITURE	-1.00	-51.64	0.00	t
3791	1298	\N	SERVICE Caro	-1.00	-30.00	0.00	t
3794	1301	\N	CAFÉ	1.00	2.50	21.00	t
3795	1301	\N	LIMONCELLO	1.00	5.00	21.00	t
3796	1301	\N	AMARETTO	1.00	5.00	21.00	t
3797	1301	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
3798	1301	\N	POLPETTE	1.00	15.00	12.00	t
3799	1301	\N	COUSCOUS PM	1.00	15.00	12.00	t
3800	1301	\N	PÂTES BOLO/LARD	2.00	12.00	12.00	t
3801	1301	\N	ROUGE VERRE	2.00	5.00	21.00	t
3802	1301	\N	BLANC VERRE	2.00	5.00	21.00	t
3812	1304	\N	NOURRITURE	-1.00	-32.60	0.00	t
3820	1307	\N	PINOT GRIGIO BLUSH	1.00	20.00	21.00	t
3824	1310	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	t
3825	1310	\N	PÂTES STRACIATELLA	1.00	13.00	12.00	t
3826	1310	\N	PÂTES STRACIATELLA SCAMPIS	1.00	17.00	12.00	t
3827	1310	\N	PÂTES STRACIATELLA SCAMPIS	1.00	17.00	12.00	t
3828	1310	\N	JUPILER	1.00	2.50	21.00	t
3829	1310	\N	ORVAL	1.00	5.00	21.00	t
3830	1310	\N	GINGEMBRE	1.00	6.00	21.00	t
3481	1179	\N	Service Véro	-1.00	-40.00	0.00	t
3484	1182	\N	NOURRITURE	-1.00	-78.00	0.00	t
3491	1185	\N	CAFÉ	2.00	2.50	21.00	t
3492	1185	\N	PRIMITIVO NR 14	2.00	24.00	21.00	t
3493	1185	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
3494	1185	\N	POLPETTE	3.00	15.00	12.00	t
3495	1185	\N	SCAMPIS LUCIFER	1.00	10.00	12.00	t
3496	1185	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	t
3497	1185	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
3498	1185	\N	PROSECCO VERRE	2.00	5.00	21.00	t
3499	1185	\N	BLANC VERRE	5.00	5.00	21.00	t
3502	1188	\N	NOURRITURE	-1.00	-148.17	0.00	t
3505	1191	\N	RESTO DAVID	-1.00	-107.70	0.00	t
3508	1194	\N	COMPTABLE	-1.00	-211.75	0.00	t
3511	1197	\N	BOISSONS	-1.00	-89.10	0.00	t
3514	1200	\N	NOURRITURE	-1.00	-26.88	0.00	t
3521	1203	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
3522	1203	\N	CHIARETTO 1/2	1.00	12.00	21.00	t
3523	1203	\N	TAJINE	3.00	15.00	12.00	t
3537	1206	\N	ROUGE VERRE	2.00	4.00	21.00	f
3538	1206	\N	CORNET LARD	1.00	6.00	6.00	f
3542	1209	\N	CREME BRULEE	1.00	5.00	6.00	f
3549	1212	\N	THÉ MENTHE	1.00	2.50	21.00	t
3550	1212	\N	SOFT (Verre)	1.00	2.00	21.00	t
3551	1212	\N	TAJINE	1.00	15.00	12.00	t
3552	1212	\N	POLPETTE	1.00	15.00	12.00	t
3553	1212	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
3556	1215	\N	Service Véro	-1.00	-40.00	0.00	t
3563	1218	\N	NOURRITURE	-1.00	-15.10	0.00	t
3566	1221	\N	COUSCOUS PM	1.00	15.00	12.00	f
3567	1221	\N	BLANC VERRE	1.00	5.00	21.00	f
3568	1221	\N	ROUGE VERRE	1.00	5.00	21.00	f
3569	1221	\N	TAJINE	1.00	15.00	12.00	f
3578	1224	\N	POLPETTE	1.00	15.00	12.00	t
3579	1224	\N	TAJINE	1.00	15.00	12.00	t
3595	1227	\N	SOFT (Verre)	1.00	2.00	21.00	t
3596	1227	\N	THÉ MENTHE	1.00	2.50	21.00	t
3597	1227	\N	GLACE	1.00	5.00	12.00	t
3598	1227	\N	SABAYON	2.00	8.00	12.00	t
3599	1227	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
3600	1227	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
3601	1227	\N	TAJINE	1.00	15.00	12.00	t
3602	1227	\N	BURRATINA TRUFFES	1.00	17.00	12.00	t
3603	1227	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
3604	1227	\N	APPASSIMENTO	1.00	30.00	21.00	t
3605	1227	\N	SOFT (Verre)	3.00	2.00	21.00	t
3608	1230	\N	SERVICE Elise	-1.00	-50.00	0.00	t
3611	1233	\N	NOURRITURE	-1.00	-40.74	0.00	t
3622	1236	\N	PÂTES SCAMPIS	2.00	17.00	12.00	f
3623	1236	\N	COUSCOUS PM	2.00	15.00	12.00	f
3624	1236	\N	BLANC VERRE	2.00	5.00	21.00	f
3625	1236	\N	APPASSIMENTO	2.00	30.00	21.00	f
3626	1236	\N	JUPILER	5.00	2.50	21.00	f
3627	1236	\N	SOFT (Verre)	7.00	2.00	21.00	f
3628	1236	\N	PINOT GRIGIO BLUSH	4.00	19.00	21.00	f
3629	1236	\N	PINOT GRIGIO (2020)	1.00	19.00	21.00	f
3630	1236	\N	CHARDONNAY (2020)	1.00	19.00	21.00	f
3633	1239	\N	NOURRITURE	-1.00	-32.93	0.00	t
3636	1242	\N	MENU À 35	1.00	65.00	12.00	t
3639	1245	\N	CREME BRULEE	2.00	5.00	12.00	f
3640	1245	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	f
3641	1245	\N	COUSCOUS PM	1.00	15.00	12.00	f
3642	1245	\N	PÂTES SCAMPIS	2.00	17.00	12.00	f
3645	1248	\N	PÂTES BOLO/LARD	2.00	12.00	12.00	t
3646	1248	\N	LIMONCELLO	1.00	5.00	21.00	t
3647	1248	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
3648	1248	\N	SOFT (Verre)	2.00	2.00	21.00	t
3649	1248	\N	ORVAL	1.00	5.00	21.00	t
3650	1248	\N	COUSCOUS PM	1.00	15.00	12.00	t
3659	1251	\N	Service Véro	-1.00	-40.00	0.00	t
3662	1254	\N	NOURRITURE	-1.00	-68.89	0.00	t
3665	1257	\N	GRAPPA	1.00	0.00	21.00	t
3666	1257	\N	CAFÉ	1.00	0.00	21.00	t
3667	1257	\N	CREME BRULEE	2.00	5.00	12.00	t
3668	1257	\N	VIN 1/2	2.00	14.00	21.00	t
3669	1257	\N	BLANC VERRE	2.00	5.00	21.00	t
3670	1257	\N	TAJINE	1.00	15.00	12.00	t
3671	1257	\N	COUSCOUS PM	1.00	15.00	12.00	t
3692	1260	\N	Cuba-Li	1.00	6.00	21.00	f
3693	1260	\N	PROSECCO VERRE	1.00	5.00	21.00	f
3694	1260	\N	THÉ MENTHE	2.00	2.50	21.00	f
3695	1260	\N	CREME BRULEE	2.00	5.00	12.00	f
3696	1260	\N	TAJINE	1.00	15.00	12.00	f
3697	1260	\N	COUSCOUS PM	1.00	15.00	12.00	f
3698	1260	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
3699	1260	\N	APPASSIMENTO	1.00	30.00	21.00	f
3710	1263	\N	SERVICE Caro	-1.00	-50.00	0.00	t
3713	1266	\N	COLLOQUE CARO	-1.00	-90.00	0.00	t
3717	1269	\N	LOYER	-1.00	-600.00	0.00	t
3723	1272	\N	BURRATINA PESTO	1.00	15.00	12.00	t
3724	1272	\N	PÂTES BOLO/LARD	3.00	12.00	12.00	t
3725	1272	\N	APPASSIMENTO	1.00	30.00	21.00	t
3726	1272	\N	APPASSIMENTO	2.00	6.00	21.00	t
3727	1272	\N	BLANC VERRE	2.00	5.00	21.00	t
3733	1275	\N	BOISSONS	-1.00	-78.00	0.00	t
3738	1278	\N	COUSCOUS PM	1.00	15.00	6.00	f
3748	1281	\N	NOURRITURE	-1.00	-6.66	0.00	t
3751	1284	\N	NOURRITURE	-1.00	-19.25	0.00	t
3754	1287	\N	AMARETTO	2.00	0.00	21.00	t
3755	1287	\N	CAFÉ	1.00	0.00	21.00	t
3756	1287	\N	CAFÉ	2.00	2.50	21.00	t
3757	1287	\N	CAPUCCINO	1.00	2.80	21.00	t
3758	1287	\N	SABAYON	3.00	8.00	12.00	t
3759	1287	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
3760	1287	\N	BLANC VERRE	2.00	5.00	21.00	t
3761	1287	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
3762	1287	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
3763	1287	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
3764	1287	\N	ROUGE VERRE	1.00	5.00	21.00	t
3767	1290	\N	CORNET LARD	1.00	6.00	6.00	f
3772	1293	\N	CAFÉ	1.00	2.50	21.00	t
3773	1293	\N	TAJINE	1.00	15.00	12.00	t
3774	1293	\N	ROUGE VERRE	1.00	5.00	21.00	t
3775	1293	\N	BLANC VERRE	3.00	5.00	21.00	t
3776	1293	\N	COUSCOUS PM	1.00	15.00	12.00	t
3779	1296	\N	NOURRITURE	-1.00	-4.90	0.00	t
3792	1299	\N	NOURRITURE	-1.00	-18.20	0.00	t
3803	1302	\N	THÉ MENTHE	2.00	2.50	21.00	f
3804	1302	\N	CAFÉ	1.00	2.50	21.00	f
3805	1302	\N	PÂTES TRUFFE	1.00	15.00	12.00	f
3482	1180	\N	NOURRITURE	-1.00	-14.68	0.00	t
3485	1183	\N	TAJINE	1.00	15.00	6.00	f
3486	1183	\N	COUSCOUS PM	1.00	15.00	6.00	f
3500	1186	\N	SERVICE Célia	-1.00	-25.00	0.00	t
3503	1189	\N	OCASC CARO	-1.00	-172.80	0.00	t
3506	1192	\N	ORANGE	-1.00	-28.00	0.00	t
3509	1195	\N	RESTO SARAH	-1.00	-120.00	0.00	t
3512	1198	\N	BOISSONS	-1.00	-35.94	0.00	t
3515	1201	\N	COUSCOUS PM	1.00	15.00	12.00	f
3524	1204	\N	PANNA COTTA	1.00	5.00	12.00	t
3525	1204	\N	TATIN	1.00	8.00	12.00	t
3526	1204	\N	Cuba-Li	1.00	6.00	21.00	t
3527	1204	\N	VIOLETTE	1.00	6.00	21.00	t
3528	1204	\N	COUSCOUS PM	1.00	15.00	12.00	t
3529	1204	\N	COUSCOUS PM	1.00	15.00	12.00	t
3539	1207	\N	BOISSONS	-1.00	-50.00	0.00	t
3543	1210	\N	CREME BRULEE	2.00	5.00	12.00	f
3544	1210	\N	BURRATINA TRUFFES	1.00	17.00	12.00	f
3545	1210	\N	POLPETTE	1.00	15.00	12.00	f
3546	1210	\N	VIN 1/2	1.00	14.00	21.00	f
3547	1210	\N	SOFT (Verre)	2.00	2.00	21.00	f
3554	1213	\N	SERVICE Célia	-1.00	-25.00	0.00	t
3557	1216	\N	ASSURANCE	-1.00	-166.36	0.00	t
3564	1219	\N	NOURRITURE	-1.00	-11.85	0.00	t
3570	1222	\N	SOFT (Verre)	1.00	2.00	21.00	f
3571	1222	\N	SOFT (Verre)	1.00	2.00	21.00	f
3572	1222	\N	POLPETTE	1.00	15.00	12.00	f
3573	1222	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	f
3574	1222	\N	TAJINE	1.00	15.00	12.00	f
3575	1222	\N	COUSCOUS PM	1.00	15.00	12.00	f
3580	1225	\N	TAJINE	1.00	15.00	12.00	t
3581	1225	\N	POLPETTE	1.00	15.00	12.00	t
3582	1225	\N	COUSCOUS PM	2.00	15.00	12.00	t
3583	1225	\N	APPASSIMENTO	1.00	30.00	21.00	t
3584	1225	\N	TATIN	1.00	8.00	12.00	t
3585	1225	\N	CREME BRULEE	2.00	5.00	12.00	t
3606	1228	\N	COUSCOUS PM	9.00	15.00	6.00	f
3609	1231	\N	SERVICE Célia	-1.00	-25.00	0.00	t
3612	1234	\N	NOURRITURE	-1.00	-34.03	0.00	t
3631	1237	\N	JUPILER	1.00	2.50	21.00	f
3634	1240	\N	NOURRITURE	-1.00	-31.49	0.00	t
3637	1243	\N	JUPILER	3.00	2.50	21.00	t
3643	1246	\N	NOURRITURE	-1.00	-9.44	0.00	t
3651	1249	\N	CREME BRULEE	3.00	5.00	12.00	t
3652	1249	\N	TATIN	1.00	8.00	12.00	t
3653	1249	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
3654	1249	\N	CHARDONNAY FIO	1.00	20.00	21.00	t
3655	1249	\N	SOFT (Verre)	3.00	2.00	21.00	t
3656	1249	\N	COUSCOUS PM	5.00	15.00	12.00	t
3657	1249	\N	TAJINE	2.00	15.00	12.00	t
3660	1252	\N	SERVICE Célia	-1.00	-40.00	0.00	t
3663	1255	\N	NOURRITURE	-1.00	-9.56	0.00	t
3672	1258	\N	PRIMITIVO NR 14	1.00	20.00	21.00	f
3673	1258	\N	GINGEMBRE	1.00	6.00	21.00	f
3674	1258	\N	VIOLETTE	1.00	6.00	21.00	f
3675	1258	\N	COUSCOUS PM	2.00	15.00	12.00	f
3676	1258	\N	TCHAKTCHOUKA	1.00	10.00	12.00	f
3677	1258	\N	GATEAUX MIEL	1.00	5.00	12.00	f
3678	1258	\N	SABAYON	1.00	8.00	12.00	f
3700	1261	\N	CHOUFFE COFFEE	1.00	8.00	21.00	t
3701	1261	\N	Cuba-Li	2.00	6.00	21.00	t
3702	1261	\N	SOFT (Verre)	1.00	2.00	21.00	t
3703	1261	\N	BURRATINA PESTO	1.00	15.00	12.00	t
3704	1261	\N	PANNA COTTA	1.00	5.00	12.00	t
3705	1261	\N	GATEAUX MIEL	2.00	5.00	12.00	t
3706	1261	\N	BLANC VERRE	2.00	5.00	21.00	t
3707	1261	\N	BURRATINA TRUFFES	1.00	17.00	12.00	t
3708	1261	\N	TAJINE	1.00	15.00	12.00	t
3711	1264	\N	Service Véro	-1.00	-40.00	0.00	t
3714	1267	\N	PECKET FRAISE	30.00	9.00	21.00	f
3715	1267	\N	COUSCOUS PM	190.00	9.00	6.00	f
3718	1270	\N	BURRATINA PESTO	2.00	15.00	12.00	t
3719	1270	\N	ROUGE VERRE	2.00	5.00	21.00	t
3720	1270	\N	BLANC VERRE	2.00	5.00	21.00	t
3728	1273	\N	PROSECCO VERRE	1.00	5.00	21.00	f
3729	1273	\N	LIMONCELLO	1.00	5.00	21.00	f
3730	1273	\N	PROSECCO VERRE	5.00	5.00	21.00	f
3734	1276	\N	NOURRITURE	-1.00	-20.90	0.00	t
3739	1279	\N	CORNET BOLO	1.00	6.00	6.00	f
3740	1279	\N	JUPILER	2.00	2.00	21.00	f
3749	1282	\N	NOURRITURE	-1.00	-29.90	0.00	t
3752	1285	\N	BOISSONS	-1.00	-170.00	0.00	t
3765	1288	\N	SERVICE Célia	-1.00	-20.00	0.00	t
3768	1291	\N	SOFT (Verre)	4.00	2.00	21.00	t
3769	1291	\N	PÂTES BOLO/LARD	2.00	12.00	6.00	t
3770	1291	\N	POLPETTE	1.00	15.00	6.00	t
3777	1294	\N	SERVICE Caro	-1.00	-50.00	0.00	t
3780	1297	\N	LIMONCELLO	2.00	0.00	21.00	t
3781	1297	\N	SABAYON	1.00	8.00	12.00	t
3782	1297	\N	THÉ MENTHE	3.00	2.50	21.00	t
3783	1297	\N	ORVAL	2.00	5.00	21.00	t
3784	1297	\N	COUSCOUS PM	1.00	15.00	12.00	t
3785	1297	\N	PÂTES STRACIATELLA	1.00	13.00	12.00	t
3786	1297	\N	TAJINE	1.00	15.00	12.00	t
3787	1297	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	t
3788	1297	\N	PROSECCO VERRE	1.00	5.00	21.00	t
3789	1297	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
3790	1297	\N	VIOLETTE	2.00	6.00	21.00	t
3793	1300	\N	CHAISES	-1.00	-50.00	0.00	t
3810	1303	\N	LIMONCELLO	1.00	5.00	21.00	f
3811	1303	\N	PROSECCO VERRE	2.00	5.00	21.00	f
3816	1306	\N	SOFT (Verre)	2.00	2.00	21.00	f
3817	1306	\N	CAFÉ	1.00	2.50	21.00	f
3818	1306	\N	JUPILER	2.00	2.50	21.00	f
3819	1306	\N	PINOT GRIGIO BLUSH	1.00	20.00	21.00	f
3823	1309	\N	NOURRITURE	-1.00	-28.15	0.00	t
3836	1312	\N	CORNET BOLO	1.00	6.00	6.00	t
3837	1312	\N	JUPILER	1.00	2.50	21.00	t
3838	1312	\N	ROSÉ VERRE	2.00	5.00	21.00	t
3853	1315	\N	Service Véro	-1.00	-40.00	0.00	t
3869	1318	\N	ROSÉ VERRE	2.00	5.00	21.00	t
3870	1318	\N	JUPILER	2.00	2.50	21.00	t
3871	1318	\N	BLONDINETTE	2.00	4.00	21.00	t
3872	1318	\N	BLANCOCA	3.00	4.00	21.00	t
3877	1321	\N	NOURRITURE	-1.00	-25.13	0.00	t
3880	1324	\N	NOURRITURE	-1.00	-7.78	0.00	t
3883	1327	\N	TATIN	1.00	8.00	12.00	t
3884	1327	\N	GATEAUX MIEL	1.00	5.00	12.00	t
3885	1327	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
3886	1327	\N	SPAG.COURGETTE + SCAMPIS	2.00	18.00	12.00	t
3887	1327	\N	EAU 1/2 L	1.00	3.50	21.00	t
3806	1302	\N	COUSCOUS PM	1.00	15.00	12.00	f
3807	1302	\N	TAJINE	1.00	15.00	12.00	f
3808	1302	\N	PINOT GRIGIO BLUSH	1.00	20.00	21.00	f
3809	1302	\N	SOFT (Verre)	1.00	2.00	21.00	f
3813	1305	\N	SOFT (Verre)	1.00	2.00	21.00	f
3814	1305	\N	PÂTES TRUFFE	1.00	15.00	12.00	f
3815	1305	\N	POLPETTE	1.00	15.00	12.00	f
3821	1308	\N	JUPILER	1.00	2.00	21.00	t
3822	1308	\N	ROSÉ VERRE	2.00	5.00	21.00	t
3833	1311	\N	BLANC VERRE	1.00	5.00	21.00	f
3834	1311	\N	CREME BRULEE	1.00	5.00	12.00	f
3835	1311	\N	BURRATINA TRUFFES	2.00	17.00	12.00	f
3845	1314	\N	BLANC VERRE	1.00	5.00	21.00	f
3846	1314	\N	SOFT (Verre)	2.00	2.00	21.00	f
3847	1314	\N	GIN TONIC	3.00	6.00	21.00	f
3848	1314	\N	BURRATINA TRUFFES	1.00	17.00	12.00	f
3849	1314	\N	COUSCOUS PM	1.00	15.00	12.00	f
3850	1314	\N	SCAMPIS LUCIFER	2.00	10.00	12.00	f
3851	1314	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
3852	1314	\N	ROUGE VERRE	2.00	6.00	21.00	f
3855	1317	\N	SOFT (Verre)	1.00	2.00	21.00	f
3856	1317	\N	GRAPPA	4.00	5.00	21.00	f
3857	1317	\N	CAFÉ	7.00	2.50	21.00	f
3858	1317	\N	PINOT GRIGIO BLUSH	2.00	20.00	21.00	f
3859	1317	\N	EAUX 1 L	3.00	5.00	21.00	f
3860	1317	\N	EAU 1/2 L	2.00	3.50	21.00	f
3861	1317	\N	PECKET FRAISE	1.00	6.00	21.00	f
3862	1317	\N	IRISH COFFEE	1.00	8.00	21.00	f
3863	1317	\N	CREME BRULEE	1.00	5.00	12.00	f
3864	1317	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
3865	1317	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	f
3866	1317	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	f
3867	1317	\N	POLPETTE	1.00	15.00	12.00	f
3868	1317	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
3876	1320	\N	NOURRITURE	-1.00	-37.03	0.00	t
3879	1323	\N	NOURRITURE	-1.00	-5.58	0.00	t
3882	1326	\N	BOISSONS	-1.00	-306.80	0.00	t
3894	1329	\N	CREME BRULEE	1.00	5.00	12.00	f
3895	1329	\N	TATIN	1.00	8.00	12.00	f
3896	1329	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
3897	1329	\N	SCAMPIS LUCIFER	1.00	10.00	12.00	f
3898	1329	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	f
3899	1329	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
3914	1332	\N	CREME BRULEE	1.00	5.00	12.00	f
3915	1332	\N	TATIN	1.00	8.00	12.00	f
3916	1332	\N	PÂTES STRACIATELLA SCAMPIS	2.00	19.00	12.00	f
3917	1332	\N	BLANC VERRE	2.00	5.00	21.00	f
3918	1332	\N	PROSECCO VERRE	1.00	5.00	21.00	f
3919	1332	\N	Cuba-Li	1.00	6.00	21.00	f
3931	1335	\N	NOURRITURE	-1.00	-19.15	0.00	t
3936	1338	\N	TATIN	1.00	8.00	12.00	t
3937	1338	\N	BLANC VERRE	1.00	5.00	21.00	t
3938	1338	\N	VIOLETTE	1.00	6.00	21.00	t
3939	1338	\N	PÂTES TRUFFE	1.00	15.00	12.00	t
3949	1341	\N	SERVICE Célia	-1.00	-25.00	0.00	t
3957	1344	\N	SERVICE Célia	-1.00	-25.00	0.00	t
3964	1347	\N	NOURRITURE	-1.00	-29.08	0.00	t
3972	1350	\N	MATERIEL	-1.00	-83.94	0.00	t
3975	1353	\N	NOURRITURE	-1.00	-55.65	0.00	t
3978	1356	\N	NOURRITURE	-1.00	-9.06	0.00	t
3981	1359	\N	CAFÉ	1.00	0.00	21.00	t
3982	1359	\N	AMARETTO	1.00	0.00	21.00	t
3983	1359	\N	SABAYON	1.00	8.00	12.00	t
3984	1359	\N	TATIN	1.00	8.00	12.00	t
3985	1359	\N	PRIMITIVO NR 14	2.00	5.00	21.00	t
3986	1359	\N	PÂTES BOLO/LARD	2.00	12.00	12.00	t
3987	1359	\N	CHARDONNAY FIO	4.00	5.00	21.00	t
3991	1362	\N	PÂTES ASPERGES	1.00	18.00	12.00	f
3992	1362	\N	COUSCOUS PM	1.00	15.00	12.00	f
3993	1362	\N	EAU 1/2 L	1.00	3.50	21.00	f
3994	1362	\N	JUPILER	3.00	2.50	21.00	f
3997	1365	\N	CONCERT	-1.00	-150.00	0.00	t
4003	1368	\N	THÉ MENTHE	2.00	2.50	21.00	f
4004	1368	\N	APPASSIMENTO	1.00	30.00	21.00	f
4005	1368	\N	SOFT (Verre)	2.00	2.00	21.00	f
4006	1368	\N	FORFAIT	2.00	45.00	12.00	f
4018	1371	\N	EAUX 1 L	1.00	5.00	21.00	f
4019	1371	\N	GRAPPA	1.00	5.00	21.00	f
4020	1371	\N	CAPUCCINO	1.00	2.80	21.00	f
4021	1371	\N	CAFÉ	3.00	2.50	21.00	f
4027	1374	\N	Service Véro	-1.00	-40.00	0.00	t
4032	1377	\N	PÂTES BOLO/LARD	3.00	12.00	12.00	f
4033	1377	\N	ASSIETTE APERITIVE (2 p.)	2.00	19.00	12.00	f
4034	1377	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	f
4043	1380	\N	NOURRITURE	-1.00	-20.28	0.00	t
4046	1383	\N	RECETTE	-1.00	-10.00	0.00	t
4049	1386	\N	FRAIS	-1.00	-20.00	0.00	t
4052	1389	\N	COUSCOUS PM	2.00	15.00	6.00	f
4055	1392	\N	CAFÉ	1.00	0.00	21.00	t
4056	1392	\N	CAFÉ	2.00	2.50	21.00	t
4057	1392	\N	TATIN	2.00	8.00	12.00	t
4058	1392	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
4059	1392	\N	BLANC VERRE	5.00	5.00	21.00	t
4060	1392	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
4061	1392	\N	BURRATINA TRUFFES	1.00	17.00	12.00	t
4064	1395	\N	TVA	-1.00	-726.99	0.00	t
4070	1398	\N	BLANC VERRE	1.00	5.00	21.00	f
4071	1398	\N	JUPILER	1.00	2.50	21.00	f
4072	1398	\N	BURRATINA TRUFFES	1.00	17.00	12.00	f
4073	1398	\N	POLPETTE	1.00	15.00	12.00	f
4086	1401	\N	THÉ MENTHE	2.00	2.50	21.00	t
4087	1401	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
4088	1401	\N	SOFT (Verre)	1.00	2.00	21.00	t
4089	1401	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
4090	1401	\N	BURRATINA TRUFFES	1.00	17.00	12.00	t
4091	1401	\N	TAJINE	1.00	15.00	12.00	t
4107	1404	\N	SOFT (Verre)	1.00	2.00	21.00	t
4108	1404	\N	BLANC VERRE	1.00	5.00	21.00	t
4109	1404	\N	JUPILER	1.00	2.50	21.00	t
4110	1404	\N	Cuba-Li	1.00	6.00	21.00	t
4111	1404	\N	SCAMPIS LUCIFER	2.00	10.00	12.00	t
4112	1404	\N	BURRATINA TRUFFES	2.00	17.00	12.00	t
4115	1407	\N	SONOS	-1.00	-180.00	0.00	t
4119	1410	\N	COUSCOUS VG	1.00	10.00	12.00	f
4120	1410	\N	COUSCOUS PM	2.00	15.00	12.00	f
4129	1413	\N	TATIN	2.00	8.00	12.00	t
4130	1413	\N	PÂTES TRUFFE	1.00	15.00	12.00	t
4131	1413	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	t
4150	1416	\N	ENERGIES	-1.00	219.75	0.00	t
4158	1419	\N	COMPTABLE	-1.00	-242.00	0.00	t
3831	1310	\N	PECKET FRAISE	1.00	6.00	21.00	t
3832	1310	\N	SOFT (Verre)	2.00	2.00	21.00	t
3839	1313	\N	THÉ MENTHE	1.00	2.50	21.00	t
3840	1313	\N	CREME BRULEE	2.00	5.00	12.00	t
3841	1313	\N	VIN 1/2	1.00	14.00	21.00	t
3842	1313	\N	PROSECCO VERRE	2.00	5.00	21.00	t
3843	1313	\N	COUSCOUS PM	1.00	15.00	12.00	t
3844	1313	\N	TAJINE	1.00	15.00	12.00	t
3854	1316	\N	SERVICE Caro	-1.00	-50.00	0.00	t
3873	1319	\N	ROSÉ VERRE	2.00	5.00	21.00	t
3874	1319	\N	BLONDINETTE	1.00	4.00	21.00	t
3875	1319	\N	GIN TONIC	4.00	6.00	21.00	t
3878	1322	\N	NOURRITURE	-1.00	-8.99	0.00	t
3881	1325	\N	BOISSONS	-1.00	-327.43	0.00	t
3889	1328	\N	SOFT (Verre)	2.00	2.00	21.00	f
3890	1328	\N	COUSCOUS PM	1.00	15.00	12.00	f
3891	1328	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
3892	1328	\N	PECKET FRAISE	1.00	6.00	21.00	f
3893	1328	\N	VIOLETTE	1.00	6.00	21.00	f
3908	1331	\N	CREME BRULEE	1.00	0.00	12.00	t
3909	1331	\N	GLACE	1.00	0.00	12.00	t
3910	1331	\N	CHAMPIGNONS KABYLES	2.00	8.00	12.00	t
3911	1331	\N	COUSCOUS PM	2.00	15.00	12.00	t
3912	1331	\N	SOFT (Verre)	2.00	2.00	21.00	t
3913	1331	\N	THÉ MENTHE	2.00	2.50	21.00	t
3926	1334	\N	CAFÉ	1.00	2.50	21.00	t
3927	1334	\N	GRAPPA	1.00	5.00	21.00	t
3928	1334	\N	GIN TONIC	3.00	6.00	21.00	t
3929	1334	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
3930	1334	\N	PINOT GRIGIO BLUSH	1.00	20.00	21.00	t
3933	1337	\N	CAFÉ	1.00	2.50	21.00	t
3934	1337	\N	BURRATINA TRUFFES	1.00	17.00	12.00	t
3935	1337	\N	BLANC VERRE	1.00	5.00	21.00	t
3943	1340	\N	BLANC VERRE	2.00	5.00	21.00	f
3944	1340	\N	ROUGE VERRE	1.00	5.00	21.00	f
3945	1340	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
3946	1340	\N	CAFÉ	3.00	2.50	21.00	f
3947	1340	\N	PÂTES BOLO/LARD	2.00	12.00	12.00	f
3948	1340	\N	POLPETTE	1.00	15.00	12.00	f
3956	1343	\N	NOURRITURE	-1.00	-30.66	0.00	t
3963	1346	\N	Service Véro	-1.00	-40.00	0.00	t
3966	1349	\N	PROSECCO Bouteille	1.00	25.00	21.00	f
3967	1349	\N	TATIN	3.00	8.00	12.00	t
3968	1349	\N	PÂTES ASPERGES	3.00	18.00	12.00	t
3969	1349	\N	CAFÉ	7.00	2.50	21.00	f
3970	1349	\N	SOFT (Verre)	1.00	2.00	21.00	f
3971	1349	\N	CHARDONNAY FIO	2.00	20.00	21.00	f
3974	1352	\N	NOURRITURE	-1.00	-22.15	0.00	t
3977	1355	\N	NOURRITURE	-1.00	-10.93	0.00	t
3980	1358	\N	NOURRITURE	-1.00	-213.06	0.00	t
3989	1361	\N	JUPILER	2.00	2.00	21.00	t
3990	1361	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
3996	1364	\N	NOURRITURE	-1.00	-4.93	0.00	t
4000	1367	\N	EAU 1/2 L	2.00	3.50	21.00	t
4001	1367	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	t
4002	1367	\N	FORFAIT	4.00	45.00	12.00	t
4013	1370	\N	ROUGE VERRE	3.00	5.00	21.00	f
4014	1370	\N	SOFT (Verre)	4.00	2.00	21.00	f
4015	1370	\N	PINOT GRIGIO BLUSH	2.00	20.00	21.00	f
4016	1370	\N	EAUX 1 L	1.00	5.00	21.00	f
4017	1370	\N	FORFAIT	4.00	45.00	12.00	f
4026	1373	\N	Service Caro	-1.00	-60.00	0.00	t
4031	1376	\N	NOURRITURE	-1.00	-76.44	0.00	t
4037	1379	\N	PÂTES SCAMPIS	2.00	17.00	12.00	f
4038	1379	\N	TCHAKTCHOUKA	1.00	10.00	12.00	f
4039	1379	\N	PINOT GRIGIO BLUSH	1.00	20.00	21.00	f
4040	1379	\N	PECKET FRAISE	2.00	6.00	21.00	f
4041	1379	\N	CREME BRULEE	2.00	5.00	12.00	f
4042	1379	\N	CAFÉ	1.00	2.50	21.00	f
4045	1382	\N	Nettoyage	-1.00	-10.00	0.00	t
4048	1385	\N	RECETTE	-1.00	-16.00	0.00	t
4051	1388	\N	FRED	-1.00	-400.00	0.00	t
4054	1391	\N	NOURRITURE	-1.00	-16.45	0.00	t
4063	1394	\N	NOURRITURE	-1.00	-46.02	0.00	t
4066	1397	\N	PECKET FRAISE	1.00	6.00	21.00	f
4067	1397	\N	GINGEMBRE	1.00	6.00	21.00	f
4068	1397	\N	PÂTES ASPERGES	1.00	18.00	12.00	f
4069	1397	\N	TAJINE	1.00	15.00	12.00	f
4079	1400	\N	CREME BRULEE	1.00	5.00	12.00	t
4080	1400	\N	THÉ MENTHE	1.00	2.50	21.00	t
4081	1400	\N	BLANC VERRE	1.00	5.00	21.00	t
4082	1400	\N	SOFT (Verre)	2.00	2.00	21.00	t
4083	1400	\N	PROSECCO VERRE	1.00	5.00	21.00	t
4084	1400	\N	PÂTES ASPERGES	2.00	18.00	12.00	t
4085	1400	\N	TCHAKTCHOUKA	1.00	10.00	12.00	t
4095	1403	\N	ROSÉ VERRE	1.00	5.00	21.00	f
4096	1403	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
4097	1403	\N	PROSECCO VERRE	2.00	5.00	21.00	f
4098	1403	\N	VIOLETTE	1.00	6.00	21.00	f
4099	1403	\N	Cuba-Li	2.00	6.00	21.00	f
4100	1403	\N	CAFÉ	1.00	2.50	21.00	f
4101	1403	\N	THÉ MENTHE	4.00	2.50	21.00	f
4102	1403	\N	CREME BRULEE	2.00	5.00	12.00	f
4103	1403	\N	SABAYON	3.00	8.00	12.00	f
4104	1403	\N	TAJINE	1.00	15.00	12.00	f
4105	1403	\N	BURRATINA PESTO	1.00	15.00	12.00	f
4106	1403	\N	COUSCOUS PM	3.00	15.00	12.00	f
4114	1406	\N	NOURRITURE	-1.00	-29.10	0.00	t
4118	1409	\N	BOISSONS	-1.00	-17.00	0.00	t
4127	1412	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
4128	1412	\N	COUSCOUS PM	2.00	15.00	12.00	f
4149	1415	\N	NOURRITURE	-1.00	-28.85	0.00	t
4157	1418	\N	COMPTABLE	-1.00	-151.25	0.00	t
4950	1681	\N	NOURRITURE	-1.00	-22.66	0.00	t
4956	1684	\N	ROBE JULIE	-1.00	-60.00	0.00	t
4959	1687	\N	TATIN	2.00	8.00	12.00	t
4960	1687	\N	BLANC VERRE	2.00	5.00	21.00	t
4961	1687	\N	ROSÉ VERRE	2.00	5.00	21.00	t
4962	1687	\N	PÂTES ASPERGES	2.00	18.00	12.00	t
4963	1687	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
4974	1690	\N	Service Célia	-1.00	-30.00	0.00	t
4982	1693	\N	GIN 0%	1.00	6.00	21.00	t
4983	1693	\N	BLONDINETTE	1.00	4.00	21.00	t
4984	1693	\N	AMARETTO	2.00	5.00	21.00	t
4992	1696	\N	EAU 1/2 L	1.00	3.50	21.00	t
4993	1696	\N	COCA / ZERO	1.00	2.00	21.00	t
4994	1696	\N	FANTA	2.00	2.00	21.00	t
4995	1696	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	t
4996	1696	\N	BURRATINA TRUFFES	2.00	17.00	12.00	t
4997	1696	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
5002	1699	\N	ANNIV CHARLOTTE	-1.00	-70.00	0.00	t
3888	1327	\N	PECKET FRAISE	2.00	6.00	21.00	t
3900	1330	\N	SABAYON	1.00	0.00	12.00	t
3901	1330	\N	TATIN	3.00	8.00	12.00	t
3902	1330	\N	PÂTES BOLO/LARD	2.00	12.00	12.00	t
3903	1330	\N	PÂTES SPÉCIALES	1.00	15.00	12.00	t
3904	1330	\N	SPAG.COURGETTE	1.00	14.00	12.00	t
3905	1330	\N	EAU VERRE	4.00	2.00	21.00	t
3906	1330	\N	PROSECCO VERRE	2.00	5.00	21.00	t
3907	1330	\N	VIOLETTE	1.00	6.00	21.00	t
3920	1333	\N	VIOLETTE	1.00	6.00	21.00	t
3921	1333	\N	SOFT (Verre)	1.00	2.00	21.00	t
3922	1333	\N	GIN TONIC	1.00	6.00	21.00	t
3923	1333	\N	COUSCOUS VG	1.00	10.00	12.00	t
3924	1333	\N	TAJINE	1.00	15.00	12.00	t
3925	1333	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	t
3932	1336	\N	CORNET LARD	1.00	6.00	6.00	t
3940	1339	\N	SOFT (Verre)	3.00	2.00	21.00	t
3941	1339	\N	BURRATINA PESTO	2.00	15.00	12.00	t
3942	1339	\N	BURRATINA TRUFFES	1.00	17.00	12.00	t
3950	1342	\N	BLANC VERRE	1.00	5.00	21.00	t
3951	1342	\N	SOFT (Verre)	1.00	2.00	21.00	t
3952	1342	\N	VIOLETTE	2.00	6.00	21.00	t
3953	1342	\N	COUSCOUS PM	2.00	15.00	12.00	t
3954	1342	\N	TAJINE	1.00	15.00	12.00	t
3955	1342	\N	TCHAKTCHOUKA	1.00	10.00	12.00	t
3958	1345	\N	COUSCOUS VG	2.00	10.00	6.00	f
3959	1345	\N	CREME BRULEE	14.00	5.00	6.00	f
3960	1345	\N	TAJINE	5.00	15.00	6.00	f
3961	1345	\N	COUSCOUS PM	6.00	15.00	6.00	f
3962	1345	\N	ASSIETTE APERITIVE (2 p.)	4.00	20.00	6.00	f
3965	1348	\N	CORNET LARD	1.00	6.00	6.00	t
3973	1351	\N	NOURRITURE	-1.00	-8.26	0.00	t
3976	1354	\N	NOURRITURE	-1.00	-27.97	0.00	t
3979	1357	\N	NOURRITURE	-1.00	-54.76	0.00	t
3988	1360	\N	CORNET TRUFFE	1.00	7.00	6.00	t
3995	1363	\N	NOURRITURE	-1.00	-16.18	0.00	t
3998	1366	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
3999	1366	\N	FORFAIT	2.00	45.00	12.00	t
4007	1369	\N	ROUGE VERRE	1.00	6.00	21.00	t
4008	1369	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
4009	1369	\N	SOFT (Verre)	1.00	2.00	21.00	t
4010	1369	\N	CHARDONNAY FIO	2.00	20.00	21.00	t
4011	1369	\N	VIN 1/2	1.00	13.00	21.00	t
4012	1369	\N	FORFAIT	5.00	45.00	12.00	t
4022	1372	\N	ESPRESSO	2.00	2.50	21.00	f
4023	1372	\N	VIN 1/2	1.00	20.00	21.00	f
4024	1372	\N	APPASSIMENTO	1.00	30.00	21.00	f
4025	1372	\N	FORFAIT	4.00	45.00	12.00	f
4028	1375	\N	GRAPPA	1.00	5.00	21.00	t
4029	1375	\N	CAFÉ	1.00	2.50	21.00	t
4030	1375	\N	BLONDINETTE	2.00	4.00	21.00	t
4035	1378	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	f
4036	1378	\N	ORVAL	1.00	5.00	21.00	f
4044	1381	\N	NOURRITURE	-1.00	-71.77	0.00	t
4047	1384	\N	RECETTE	-1.00	-20.00	0.00	t
4050	1387	\N	LOYER	-1.00	-600.00	0.00	t
4053	1390	\N	BLANC VERRE	3.00	5.00	21.00	f
4062	1393	\N	CARBURANT	-1.00	-438.48	0.00	t
4065	1396	\N	BOISSONS	-1.00	-72.99	0.00	t
4074	1399	\N	ESPRESSO	1.00	2.50	21.00	f
4075	1399	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	f
4076	1399	\N	COUSCOUS PM	1.00	15.00	12.00	f
4077	1399	\N	TCHAKTCHOUKA	1.00	10.00	12.00	f
4078	1399	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
4092	1402	\N	PINOT BLANC	1.00	24.00	21.00	f
4093	1402	\N	PECKET FRAISE	1.00	6.00	21.00	f
4094	1402	\N	COUSCOUS PM	1.00	15.00	12.00	f
4113	1405	\N	Service Caro	-1.00	-50.00	0.00	t
4116	1408	\N	BLANC VERRE	1.00	5.00	21.00	f
4117	1408	\N	PROSECCO VERRE	2.00	5.00	21.00	f
4121	1411	\N	GIN TONIC	1.00	6.00	21.00	t
4122	1411	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
4123	1411	\N	BLANC VERRE	3.00	5.00	21.00	t
4124	1411	\N	JUPILER	1.00	2.50	21.00	t
4125	1411	\N	CORNET LARD	1.00	6.00	6.00	t
4126	1411	\N	CORNET BOLO	1.00	6.00	6.00	t
4132	1414	\N	IRISH COFFEE	4.00	8.00	21.00	f
4133	1414	\N	TATIN	1.00	8.00	12.00	f
4134	1414	\N	SABAYON	2.00	8.00	12.00	f
4135	1414	\N	ESPRESSO	1.00	2.50	21.00	f
4136	1414	\N	THÉ MENTHE	1.00	2.50	21.00	f
4137	1414	\N	CREME BRULEE	2.00	5.00	12.00	f
4138	1414	\N	CREME PIST/CITR	1.00	5.00	21.00	f
4139	1414	\N	PROSECCO Bouteille	2.00	25.00	21.00	f
4140	1414	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	f
4141	1414	\N	APPASSIMENTO	1.00	30.00	21.00	f
4142	1414	\N	SOFT (Verre)	1.00	2.00	21.00	f
4143	1414	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	f
4144	1414	\N	COUSCOUS PM	4.00	15.00	12.00	f
4145	1414	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
4146	1414	\N	PROSECCO VERRE	5.00	5.00	21.00	f
4147	1414	\N	Cuba-Li	2.00	6.00	21.00	f
4148	1414	\N	APEROL SPRITZ	7.00	6.00	21.00	f
4151	1417	\N	LIMONCELLO	1.00	0.00	21.00	t
4152	1417	\N	CREME PIST/CITR	1.00	0.00	21.00	t
4153	1417	\N	CORNET TRUFFE	1.00	7.00	6.00	t
4154	1417	\N	PÂTES ASPERGES	2.00	18.00	12.00	t
4155	1417	\N	CAFÉ	1.00	2.50	21.00	t
4156	1417	\N	PINOT BLANC	4.00	5.00	21.00	t
4159	1420	\N	ORANGE	-1.00	-14.00	0.00	t
4160	1421	\N	FETE DES MERES	-1.00	-89.00	0.00	t
4161	1422	\N	NOURRITURE	-1.00	-209.13	0.00	t
4162	1423	\N	CORNET TRUFFE	1.00	7.00	6.00	f
4163	1423	\N	CORNET LARD	1.00	6.00	6.00	f
4164	1424	\N	NOURRITURE	-1.00	-33.34	0.00	t
4165	1425	\N	ARMOIRE CHAUFFANTE	-1.00	-75.00	0.00	t
4166	1426	\N	CREME BRULEE	2.00	5.00	12.00	f
4167	1426	\N	ROUGE VERRE	2.00	5.00	21.00	f
4168	1426	\N	PÂTES ASPERGES	2.00	18.00	12.00	f
4169	1427	\N	COUSCOUS PM	1.00	20.00	12.00	t
4170	1427	\N	JUPILER	3.00	2.50	21.00	t
4171	1427	\N	PÂTES PESTO	1.00	14.00	12.00	t
4172	1428	\N	AMARETTO	1.00	0.00	21.00	f
4173	1428	\N	CAFÉ	1.00	0.00	21.00	f
4174	1428	\N	LIMONCELLO	2.00	0.00	21.00	f
4175	1428	\N	CREME BRULEE	1.00	5.00	12.00	f
4176	1428	\N	CAFÉ	1.00	2.50	21.00	f
4177	1428	\N	PROSECCO VERRE	2.00	6.00	21.00	f
4178	1428	\N	JUPILER	2.00	2.50	21.00	f
4179	1428	\N	EAUX 1 L	1.00	5.00	21.00	f
4189	1430	\N	CAFÉ	1.00	2.50	21.00	f
4180	1428	\N	PÂTES ASPERGES	1.00	18.00	12.00	f
4181	1428	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
4182	1428	\N	POLPETTE	2.00	15.00	12.00	f
4196	1431	\N	Service Célia	-1.00	-30.00	0.00	t
4201	1434	\N	COCA / ZERO	1.00	2.00	21.00	f
4202	1434	\N	Cuba-Li	1.00	6.00	21.00	f
4203	1434	\N	PROSECCO VERRE	2.00	6.00	21.00	f
4204	1434	\N	POLPETTE	1.00	15.00	12.00	f
4205	1434	\N	TAJINE	1.00	15.00	12.00	f
4222	1437	\N	BULLES 0%	2.00	6.00	21.00	f
4223	1437	\N	AMARETTO	1.00	5.00	21.00	f
4224	1437	\N	Cuba-Li	1.00	6.00	21.00	f
4225	1437	\N	PECKET FRAISE	1.00	6.00	21.00	f
4230	1440	\N	EQUIPEMENT	-1.00	-48.96	0.00	t
4233	1443	\N	PECKET FRAISE	1.00	6.00	21.00	t
4234	1443	\N	COCA / ZERO	1.00	2.00	21.00	t
4235	1443	\N	BURRATINA TRUFFES	1.00	17.00	12.00	t
4236	1443	\N	TAJINE	1.00	15.00	12.00	t
4237	1443	\N	COUSCOUS PM	1.00	15.00	12.00	t
4249	1446	\N	COCA / ZERO	1.00	2.00	21.00	t
4250	1446	\N	VIOLETTE	1.00	6.00	21.00	t
4251	1446	\N	PROSECCO VERRE	2.00	6.00	21.00	t
4252	1446	\N	ICE TEA	2.00	2.00	21.00	t
4253	1446	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
4254	1446	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
4255	1446	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
4256	1446	\N	SABAYON	1.00	8.00	12.00	t
4257	1446	\N	TATIN	1.00	8.00	12.00	t
4258	1446	\N	TATIN	1.00	8.00	12.00	t
4259	1446	\N	EAUX 1 L	1.00	5.00	21.00	t
4260	1446	\N	POLPETTE	1.00	15.00	12.00	t
4274	1449	\N	COCA / ZERO	2.00	2.00	21.00	t
4275	1449	\N	GRAPPA	1.00	5.00	21.00	t
4276	1449	\N	PROSECCO VERRE	2.00	6.00	21.00	t
4279	1452	\N	SODEXO	-1.00	-30.00	0.00	t
4282	1455	\N	PECKET FRAISE	1.00	30.00	21.00	f
4288	1458	\N	CAFÉ	3.00	2.50	21.00	f
4292	1461	\N	SOFT (Verre)	4.00	2.00	21.00	f
4293	1461	\N	APPASSIMENTO	3.00	30.00	21.00	f
4294	1461	\N	PINOT GRIGIO BLUSH	4.00	20.00	21.00	f
4295	1461	\N	JUPILER	3.00	2.50	21.00	f
4296	1461	\N	EAUX 1 L	2.00	5.00	21.00	f
4297	1461	\N	PINOT GRIGIO (2020)	3.00	20.00	21.00	f
4305	1464	\N	APPASSIMENTO	3.00	30.00	21.00	f
4306	1464	\N	PINOT GRIGIO BLUSH	3.00	20.00	21.00	f
4307	1464	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	f
4316	1467	\N	NOURRITURE	-1.00	-76.00	0.00	t
4321	1470	\N	Service Célia	-1.00	-40.00	0.00	t
4326	1473	\N	CAFÉ	5.00	2.50	21.00	t
4334	1476	\N	CORNET BOLO	2.00	6.00	6.00	f
4337	1479	\N	Service Véro	-1.00	-20.00	0.00	t
4340	1482	\N	TATIN	1.00	8.00	12.00	f
4341	1482	\N	PÂTES ASPERGES	1.00	18.00	12.00	f
4342	1482	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	f
4343	1482	\N	SPRITZ 0%	1.00	6.00	21.00	f
4344	1482	\N	JUPILER	2.00	2.50	21.00	f
4351	1485	\N	BLANC VERRE	1.00	5.00	21.00	f
4352	1485	\N	ROSÉ VERRE	1.00	5.00	21.00	f
4355	1488	\N	NOURRITURE	-1.00	-64.54	0.00	t
4359	1491	\N	COUSCOUS PM	3.00	15.00	12.00	f
4360	1491	\N	PÂTES ASPERGES	1.00	18.00	12.00	f
4361	1491	\N	BLONDINETTE	4.00	4.00	21.00	f
4362	1491	\N	TARTELETTE CITRON	2.00	6.00	6.00	f
4363	1491	\N	CREME BRULEE	1.00	5.00	12.00	f
4364	1491	\N	SABAYON	1.00	8.00	12.00	f
4391	1494	\N	GLACE	1.00	5.00	12.00	f
4392	1494	\N	CREME BRULEE	1.00	5.00	12.00	f
4393	1494	\N	TARTELETTE CITRON	1.00	6.00	6.00	f
4394	1494	\N	SABAYON	1.00	8.00	12.00	f
4395	1494	\N	BURRATINA TRUFFES	2.00	17.00	12.00	f
4396	1494	\N	BURRATINA PESTO	1.00	15.00	12.00	f
4397	1494	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
4398	1494	\N	SCAMPIS LUCIFER	1.00	10.00	12.00	f
4399	1494	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
4400	1494	\N	SPRITZ 0%	1.00	6.00	21.00	f
4401	1494	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	f
4402	1494	\N	PROSECCO VERRE	3.00	6.00	21.00	f
4403	1494	\N	VIOLETTE	1.00	6.00	21.00	f
4404	1494	\N	BLONDINETTE	3.00	4.00	21.00	f
4418	1497	\N	NOURRITURE	-1.00	-48.34	0.00	t
4421	1500	\N	NOURRITURE	-1.00	-13.12	0.00	t
4424	1503	\N	NOURRITURE	-1.00	-31.59	0.00	t
4435	1506	\N	COUSCOUS VG	1.00	10.00	6.00	f
4446	1509	\N	ESPRESSO	1.00	2.50	21.00	t
4447	1509	\N	THÉ MENTHE	3.00	2.50	21.00	t
4448	1509	\N	TARTELETTE CITRON	1.00	6.00	6.00	t
4449	1509	\N	CREME BRULEE	2.00	5.00	12.00	t
4450	1509	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
4451	1509	\N	COUSCOUS PM	1.00	15.00	12.00	t
4452	1509	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	t
4453	1509	\N	BURRATINA TRUFFES	1.00	17.00	12.00	t
4454	1509	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
4455	1509	\N	PROSECCO VERRE	1.00	6.00	21.00	t
4456	1509	\N	GINGEMBRE	1.00	6.00	21.00	t
4457	1509	\N	VIOLETTE	2.00	6.00	21.00	t
4477	1512	\N	Service Caro	-1.00	-75.00	0.00	t
4485	1515	\N	ROSÉ VERRE	1.00	5.00	21.00	f
4486	1515	\N	ROUGE VERRE	2.00	5.00	21.00	f
4487	1515	\N	PECKET FRAISE	2.00	6.00	21.00	f
4488	1515	\N	PROSECCO VERRE	2.00	6.00	21.00	f
4491	1518	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
4497	1521	\N	JUPILER	2.00	2.50	21.00	f
4498	1521	\N	CORNET LARD	1.00	6.00	6.00	f
4504	1524	\N	BLANC VERRE	1.00	5.00	21.00	f
4505	1524	\N	PECKET FRAISE	1.00	6.00	21.00	f
4506	1524	\N	CYNAR	1.00	5.00	21.00	f
4509	1527	\N	PÂTES ASPERGES	1.00	18.00	12.00	f
4513	1530	\N	ESPRESSO	2.00	2.50	21.00	f
4514	1530	\N	TATIN	2.00	8.00	12.00	f
4515	1530	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
4516	1530	\N	PINOT GRIGIO (2020)	10.00	5.00	21.00	f
4517	1530	\N	BURRATINA TRUFFES	1.00	17.00	12.00	f
4518	1530	\N	PÂTES ASPERGES	1.00	18.00	12.00	f
4523	1533	\N	PINOT GRIGIO (2020)	3.00	5.00	21.00	t
4526	1536	\N	POLPETTE	1.00	15.00	12.00	f
4527	1536	\N	COUSCOUS PM	1.00	15.00	12.00	f
4551	1539	\N	Service Caro	-1.00	-50.00	0.00	t
4554	1542	\N	VIOLETTE	2.00	6.00	21.00	f
4555	1542	\N	PECKET FRAISE	1.00	6.00	21.00	f
4556	1542	\N	GIN TONIC	1.00	6.00	21.00	f
4183	1429	\N	LIMONCELLO	2.00	5.00	21.00	t
4184	1429	\N	AMARETTO	2.00	5.00	21.00	t
4185	1429	\N	CAFÉ	1.00	2.50	21.00	t
4186	1429	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
4187	1429	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
4188	1429	\N	BLANC VERRE	4.00	5.00	21.00	t
4197	1432	\N	JUPILER	4.00	2.00	21.00	t
4198	1432	\N	CORNET BOLO	2.00	6.00	6.00	t
4199	1432	\N	CORNET LARD	2.00	6.00	6.00	t
4206	1435	\N	BLANC VERRE	2.00	5.00	21.00	f
4207	1435	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
4208	1435	\N	JUPILER	1.00	2.50	21.00	f
4209	1435	\N	PECKET FRAISE	3.00	6.00	21.00	f
4210	1435	\N	COCA / ZERO	1.00	2.00	21.00	f
4211	1435	\N	THÉ MENTHE	4.00	2.50	21.00	f
4212	1435	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
4213	1435	\N	BURRATINA TRUFFES	1.00	17.00	12.00	f
4214	1435	\N	PÂTES STRACIATELLA SCAMPIS	1.00	17.00	12.00	f
4215	1435	\N	PÂTES ASPERGES	2.00	18.00	12.00	f
4226	1438	\N	PROSECCO VERRE	1.00	2.00	21.00	f
4227	1438	\N	GIN TONIC	1.00	6.00	21.00	f
4228	1438	\N	PECKET FRAISE	2.00	6.00	21.00	f
4231	1441	\N	NOURRITURE	-1.00	-10.00	0.00	t
4238	1444	\N	FORFAIT	2.00	50.00	12.00	f
4239	1444	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	f
4240	1444	\N	TAJINE	1.00	15.00	12.00	f
4241	1444	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	f
4242	1444	\N	BLONDINETTE	3.00	4.00	21.00	f
4243	1444	\N	PÂTES ASPERGES	1.00	18.00	12.00	f
4244	1444	\N	BEIGNETS DE COURGETTE	1.00	8.00	6.00	f
4245	1444	\N	TCHAKTCHOUKA	1.00	10.00	12.00	f
4246	1444	\N	PECKET FRAISE	2.00	6.00	21.00	f
4247	1444	\N	PROSECCO VERRE	2.00	6.00	21.00	f
4261	1447	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
4262	1447	\N	EAU 1/2 L	1.00	3.50	21.00	t
4263	1447	\N	BIERLAINOISE	1.00	4.00	6.00	t
4264	1447	\N	BLANC VERRE	6.00	5.00	21.00	t
4265	1447	\N	CAFÉ	3.00	2.50	21.00	t
4266	1447	\N	SABAYON	1.00	8.00	12.00	t
4267	1447	\N	TATIN	1.00	8.00	12.00	t
4268	1447	\N	COUSCOUS PM	1.00	15.00	12.00	t
4269	1447	\N	POLPETTE	1.00	15.00	12.00	t
4270	1447	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
4271	1447	\N	TAJINE	1.00	15.00	12.00	t
4272	1447	\N	CHAMPIGNONS KABYLES	3.00	8.00	12.00	t
4277	1450	\N	NOURRITURE	-1.00	-15.00	0.00	t
4280	1453	\N	NOURRITURE	-1.00	-79.30	0.00	t
4283	1456	\N	JUPILER	2.00	2.50	21.00	t
4284	1456	\N	PROSECCO VERRE	1.00	6.00	21.00	t
4285	1456	\N	PECKET FRAISE	4.00	6.00	21.00	t
4286	1456	\N	ASSIETTE APERITIVE (2 p.)	1.00	10.00	12.00	t
4289	1459	\N	JUPILER	4.00	2.00	21.00	f
4298	1462	\N	PÂTES ASPERGES	1.00	18.00	12.00	f
4299	1462	\N	COUSCOUS PM	7.00	15.00	12.00	f
4300	1462	\N	TAJINE	1.00	15.00	12.00	f
4301	1462	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	f
4302	1462	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
4308	1465	\N	PINOT GRIGIO BLUSH	1.00	20.00	21.00	f
4309	1465	\N	PROSECCO VERRE	1.00	6.00	21.00	f
4310	1465	\N	JUPILER	2.00	2.50	21.00	f
4311	1465	\N	PINOT GRIGIO (2020)	3.00	20.00	21.00	f
4317	1468	\N	Service Célia	-1.00	-50.00	0.00	t
4322	1471	\N	FORFAIT	7.00	30.00	12.00	f
4327	1474	\N	COCA / ZERO	1.00	2.00	21.00	t
4328	1474	\N	BLANC VERRE	1.00	5.00	21.00	t
4329	1474	\N	PRIMITIVO NR 14	3.00	24.00	21.00	t
4335	1477	\N	Service Véro	-1.00	-20.00	0.00	t
4338	1480	\N	Service Véro	-1.00	-10.00	0.00	t
4345	1483	\N	CORNET BOLO	1.00	6.00	6.00	f
4353	1486	\N	DEPENSES	-1.00	-3.05	0.00	t
4356	1489	\N	JUPILER	4.00	2.00	21.00	t
4357	1489	\N	PINOT GRIGIO BLUSH	1.00	20.00	21.00	t
4365	1492	\N	GINGEMBRE	1.00	6.00	21.00	f
4366	1492	\N	Cuba-Li	1.00	6.00	21.00	f
4367	1492	\N	PECKET FRAISE	1.00	6.00	21.00	f
4368	1492	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	f
4405	1495	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	f
4406	1495	\N	BURRATINA TRUFFES	1.00	17.00	12.00	f
4407	1495	\N	PÂTES ASPERGES	1.00	18.00	12.00	f
4408	1495	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
4409	1495	\N	GIN 0%	1.00	6.00	21.00	f
4410	1495	\N	PROSECCO VERRE	1.00	6.00	21.00	f
4411	1495	\N	IRISH COFFEE	2.00	8.00	21.00	f
4412	1495	\N	TATIN	1.00	8.00	12.00	f
4413	1495	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	f
4414	1495	\N	APPASSIMENTO	1.00	30.00	21.00	f
4415	1495	\N	JUPILER	1.00	2.50	21.00	f
4416	1495	\N	PECKET FRAISE	2.00	6.00	21.00	f
4419	1498	\N	NOURRITURE	-1.00	-51.20	0.00	t
4422	1501	\N	NOURRITURE	-1.00	-16.57	0.00	t
4425	1504	\N	CREME BRULEE	2.00	5.00	12.00	f
4426	1504	\N	FANTA	1.00	2.00	21.00	f
4427	1504	\N	COCA / ZERO	1.00	2.00	21.00	f
4428	1504	\N	PRIMITIVO NR 14	2.00	5.00	21.00	f
4429	1504	\N	BURRATINA TRUFFES	1.00	17.00	12.00	f
4430	1504	\N	PÂTES ASPERGES	1.00	18.00	12.00	f
4431	1504	\N	COUSCOUS PM	1.00	15.00	12.00	f
4436	1507	\N	GIN 0%	1.00	6.00	21.00	f
4437	1507	\N	CREME BRULEE	1.00	5.00	12.00	f
4438	1507	\N	ROSÉ VERRE	2.00	5.00	21.00	f
4439	1507	\N	TRIPLE SAINTE NITOUCHE	2.00	4.50	21.00	f
4458	1510	\N	EAU VERRE	1.00	2.00	21.00	t
4459	1510	\N	SOFT (Verre)	1.00	2.00	21.00	t
4460	1510	\N	LIMONCELLO	1.00	5.00	21.00	t
4461	1510	\N	ROSÉ VERRE	1.00	5.00	21.00	t
4462	1510	\N	JUPILER	3.00	2.00	21.00	t
4478	1513	\N	Service Caro	-1.00	-75.00	0.00	t
4489	1516	\N	PECKET FRAISE	2.00	5.00	21.00	f
4492	1519	\N	ROSÉ VERRE	1.00	0.00	21.00	t
4493	1519	\N	ROUGE VERRE	1.00	0.00	21.00	t
4494	1519	\N	PÂTES ASPERGES	1.00	0.00	12.00	t
4495	1519	\N	PECKET FRAISE	1.00	0.00	21.00	t
4499	1522	\N	CAFÉ	1.00	2.50	21.00	f
4507	1525	\N	Service Célia	-1.00	-40.00	0.00	t
4510	1528	\N	CORNET LARD	1.00	0.00	6.00	f
4519	1531	\N	TAJINE	1.00	0.00	12.00	t
4520	1531	\N	GIN 0%	1.00	0.00	21.00	t
4521	1531	\N	PINOT GRIGIO (2020)	1.00	0.00	21.00	t
4524	1534	\N	COUSCOUS PM	2.00	15.00	6.00	f
4190	1430	\N	THÉ MENTHE	1.00	2.50	21.00	f
4191	1430	\N	LIMONCELLO	1.00	5.00	21.00	f
4192	1430	\N	AMARETTO	1.00	5.00	21.00	f
4193	1430	\N	PÂTES ASPERGES	1.00	18.00	12.00	f
4194	1430	\N	COUSCOUS PM	1.00	15.00	12.00	f
4195	1430	\N	BLANC VERRE	3.00	5.00	21.00	f
4200	1433	\N	CORNET BOLO	2.00	6.00	6.00	f
4216	1436	\N	CAFÉ	1.00	2.50	21.00	f
4217	1436	\N	EAUX 1 L	1.00	5.00	21.00	f
4218	1436	\N	THÉ MENTHE	2.00	2.50	21.00	f
4219	1436	\N	VIOLETTE	1.00	6.00	21.00	f
4220	1436	\N	TATIN	3.00	8.00	12.00	f
4221	1436	\N	TAJINE	3.00	15.00	12.00	f
4229	1439	\N	Service Caro	-1.00	-70.00	0.00	t
4232	1442	\N	NOURRITURE	-1.00	-10.00	0.00	t
4248	1445	\N	COUSCOUS PM	3.00	15.00	12.00	f
4273	1448	\N	Service Caro	-1.00	-60.00	0.00	t
4278	1451	\N	COURS CUISINE	-1.00	-70.00	0.00	t
4281	1454	\N	Service Cha	-1.00	-20.00	0.00	t
4287	1457	\N	CAFÉ	1.00	2.50	21.00	f
4290	1460	\N	APEROL SPRITZ	1.00	6.00	21.00	t
4291	1460	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	t
4303	1463	\N	THÉ MENTHE	1.00	2.00	21.00	t
4304	1463	\N	PINOT GRIGIO (2020)	3.00	5.00	21.00	t
4312	1466	\N	RHUM	1.00	0.00	21.00	f
4313	1466	\N	CAFÉ	1.00	0.00	21.00	f
4314	1466	\N	PINOT GRIGIO BLUSH	1.00	0.00	21.00	f
4315	1466	\N	APPASSIMENTO	1.00	29.00	21.00	f
4318	1469	\N	CAPUCCINO	1.00	2.80	21.00	t
4319	1469	\N	BLANC VERRE	1.00	5.00	21.00	t
4320	1469	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	t
4323	1472	\N	CAFÉ	1.00	2.50	21.00	t
4324	1472	\N	CYNAR	6.00	5.00	21.00	t
4325	1472	\N	LIMONCELLO	2.00	5.00	21.00	t
4330	1475	\N	CAFÉ	1.00	2.50	21.00	t
4331	1475	\N	TATIN	1.00	8.00	12.00	t
4332	1475	\N	CHAMPIGNONS KABYLES	2.00	12.00	12.00	t
4333	1475	\N	COCA / ZERO	1.00	2.00	21.00	t
4336	1478	\N	Service Véro	-1.00	-10.00	0.00	t
4339	1481	\N	Service Véro	-1.00	-10.00	0.00	t
4346	1484	\N	ESPRESSO	2.00	2.50	21.00	t
4347	1484	\N	MARTINI Blanc/Rouge	1.00	5.00	21.00	t
4348	1484	\N	ORVAL	3.00	5.00	21.00	t
4349	1484	\N	POLPETTE	1.00	15.00	12.00	t
4350	1484	\N	BURRATINA TRUFFES	1.00	17.00	12.00	t
4354	1487	\N	DEPENSES	-1.00	-2.60	0.00	t
4358	1490	\N	PINOT GRIGIO BLUSH	1.00	20.00	21.00	t
4369	1493	\N	CREME BRULEE	5.00	5.00	12.00	f
4370	1493	\N	IRISH COFFEE	1.00	8.00	21.00	t
4371	1493	\N	SABAYON	1.00	8.00	12.00	f
4372	1493	\N	THÉ MENTHE	5.00	2.50	21.00	f
4373	1493	\N	BURRATINA PESTO	2.00	15.00	12.00	f
4374	1493	\N	PÂTES ASPERGES	1.00	18.00	12.00	f
4375	1493	\N	BURRATINA TRUFFES	2.00	17.00	12.00	f
4376	1493	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	f
4377	1493	\N	PÂTES TRUFFE	1.00	15.00	12.00	f
4378	1493	\N	POLPETTE	1.00	15.00	12.00	f
4379	1493	\N	TAJINE	1.00	15.00	12.00	f
4380	1493	\N	COUSCOUS PM	1.00	15.00	12.00	f
4381	1493	\N	ASSIETTE APERITIVE (2 p.)	2.00	19.00	12.00	t
4382	1493	\N	GIN 0%	4.00	6.00	21.00	t
4383	1493	\N	ICE TEA	1.00	2.00	21.00	t
4384	1493	\N	COCA / ZERO	1.00	2.00	21.00	f
4385	1493	\N	BLONDINETTE	1.00	4.00	21.00	t
4386	1493	\N	THÉ MENTHE	1.00	2.50	21.00	f
4387	1493	\N	JUPILER	1.00	2.50	21.00	f
4388	1493	\N	PECKET FRAISE	4.00	6.00	21.00	f
4389	1493	\N	VIOLETTE	4.00	6.00	21.00	f
4390	1493	\N	GINGEMBRE	2.00	6.00	21.00	f
4417	1496	\N	BOISSONS	-1.00	-382.00	0.00	t
4420	1499	\N	NOURRITURE	-1.00	-47.45	0.00	t
4423	1502	\N	NOURRITURE	-1.00	-5.70	0.00	t
4432	1505	\N	COCA / ZERO	1.00	2.00	21.00	t
4433	1505	\N	GIN TONIC	1.00	6.00	21.00	t
4434	1505	\N	COUSCOUS PM	2.00	15.00	12.00	t
4440	1508	\N	ROUGE VERRE	1.00	6.00	21.00	t
4441	1508	\N	EAU 1/2 L	1.00	3.50	21.00	t
4442	1508	\N	FANTA	1.00	2.00	21.00	t
4443	1508	\N	BURRATINA PESTO	1.00	15.00	12.00	t
4444	1508	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
4445	1508	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
4463	1511	\N	PINOT GRIGIO BLUSH	2.00	20.00	21.00	f
4464	1511	\N	THÉ MENTHE	2.00	2.50	21.00	f
4465	1511	\N	CAFÉ	1.00	2.50	21.00	f
4466	1511	\N	ESPRESSO	2.00	2.50	21.00	f
4467	1511	\N	GRAPPA	2.00	5.00	21.00	f
4468	1511	\N	ROSÉ VERRE	2.00	5.00	21.00	f
4469	1511	\N	LIMONCELLO	1.00	5.00	21.00	f
4470	1511	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
4471	1511	\N	BLANC VERRE	2.00	5.00	21.00	f
4472	1511	\N	PECKET FRAISE	3.00	6.00	21.00	f
4473	1511	\N	TRIPLE SAINTE NITOUCHE	2.00	4.50	21.00	f
4474	1511	\N	PÂTES ASPERGES	1.00	18.00	12.00	f
4475	1511	\N	TAJINE	1.00	15.00	12.00	f
4476	1511	\N	COUSCOUS PM	3.00	15.00	12.00	f
4479	1514	\N	CAFÉ	1.00	2.50	21.00	t
4480	1514	\N	GINGEMBRE	1.00	6.00	21.00	t
4481	1514	\N	Cuba-Li	1.00	6.00	21.00	t
4482	1514	\N	ICE TEA	1.00	2.00	21.00	t
4483	1514	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	t
4484	1514	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	t
4490	1517	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
4496	1520	\N	NOURRITURE	-1.00	-8.69	0.00	t
4500	1523	\N	CREME BRULEE	2.00	0.00	12.00	t
4501	1523	\N	CAFÉ	2.00	0.00	21.00	t
4502	1523	\N	PROSECCO VERRE	1.00	0.00	21.00	t
4503	1523	\N	PÂTES ASPERGES	2.00	0.00	12.00	t
4508	1526	\N	Service Célia	-1.00	-30.00	0.00	t
4511	1529	\N	CAFÉ	1.00	2.50	21.00	f
4512	1529	\N	PINOT GRIGIO (2020)	3.00	5.00	21.00	f
4522	1532	\N	Service Célia	-1.00	-25.00	0.00	t
4525	1535	\N	JUPILER	2.00	2.00	21.00	f
4534	1538	\N	CHARDONNAY FIO	1.00	20.00	21.00	f
4535	1538	\N	BLANC VERRE	1.00	5.00	21.00	f
4536	1538	\N	COCA / ZERO	3.00	2.00	21.00	f
4537	1538	\N	VIOLETTE	1.00	6.00	21.00	f
4538	1538	\N	Cuba-Li	1.00	6.00	21.00	f
4539	1538	\N	PÂTES ASPERGES	2.00	18.00	12.00	f
4540	1538	\N	PÂTES TRUFFE	1.00	15.00	12.00	f
4541	1538	\N	TAJINE	1.00	15.00	12.00	f
4528	1537	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	t
4529	1537	\N	BURRATINA PESTO	1.00	15.00	12.00	t
4530	1537	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
4531	1537	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
4532	1537	\N	THÉ MENTHE	2.00	2.50	21.00	t
4533	1537	\N	CREME BRULEE	2.00	5.00	12.00	t
4552	1540	\N	Service Véro	-1.00	-40.00	0.00	t
4558	1543	\N	COUSCOUS PM	2.00	15.00	6.00	t
4564	1546	\N	NOURRITURE	-1.00	-61.35	0.00	t
4567	1549	\N	ESPRESSO	1.00	2.50	21.00	f
4568	1549	\N	CAFÉ	1.00	2.50	21.00	f
4569	1549	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
4570	1549	\N	COUSCOUS PM	2.00	15.00	12.00	f
4577	1552	\N	PRIMITIVO NR 14	2.00	5.00	21.00	f
4578	1552	\N	BURRATINA PESTO	1.00	15.00	12.00	f
4584	1555	\N	ESPRESSO	1.00	2.50	21.00	t
4585	1555	\N	Cuba-Li	2.00	6.00	21.00	t
4586	1555	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
4601	1558	\N	NOURRITURE	-1.00	-63.46	0.00	t
4604	1561	\N	CORNET BOLO	1.00	6.00	6.00	t
4605	1561	\N	CORNET TRUFFE	1.00	7.00	6.00	t
4616	1564	\N	THÉ MENTHE	1.00	2.50	21.00	t
4617	1564	\N	CAFÉ	1.00	2.50	21.00	t
4618	1564	\N	CREME BRULEE	2.00	5.00	12.00	t
4619	1564	\N	ROUGE VERRE	1.00	5.00	21.00	t
4620	1564	\N	ROSÉ VERRE	1.00	5.00	21.00	t
4621	1564	\N	POLPETTE	1.00	15.00	12.00	t
4622	1564	\N	PÂTES ASPERGES	2.00	18.00	12.00	t
4623	1564	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
4624	1564	\N	COCA / ZERO	1.00	2.00	21.00	t
4625	1564	\N	ICE TEA	1.00	2.00	21.00	t
4626	1564	\N	PROSECCO VERRE	1.00	6.00	21.00	t
4627	1564	\N	ORVAL	1.00	5.00	21.00	t
4636	1567	\N	THÉ MENTHE	1.00	2.50	21.00	t
4637	1567	\N	CAPUCCINO	2.00	2.80	21.00	t
4638	1567	\N	CREME BRULEE	1.00	5.00	12.00	t
4639	1567	\N	SABAYON	1.00	8.00	12.00	t
4640	1567	\N	GATEAUX MIEL	2.00	5.00	12.00	t
4641	1567	\N	CREME PIST/CITR	2.00	5.00	21.00	t
4642	1567	\N	SOFT (Verre)	1.00	2.00	21.00	t
4643	1567	\N	ROUGE VERRE	3.00	5.00	21.00	t
4644	1567	\N	BLANC VERRE	2.00	5.00	21.00	t
4645	1567	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
4646	1567	\N	PÂTES ASPERGES	2.00	18.00	12.00	t
4647	1567	\N	PÂTES TRUFFE	3.00	15.00	12.00	t
4648	1567	\N	GINGEMBRE	9.00	6.00	21.00	t
4649	1567	\N	PECKET FRAISE	4.00	6.00	21.00	t
4659	1570	\N	PÂTES ASPERGES	2.00	18.00	12.00	f
4660	1570	\N	PÂTES TRUFFE	1.00	15.00	12.00	f
4661	1570	\N	SCAMPIS LUCIFER	3.00	10.00	12.00	f
4662	1570	\N	COCA / ZERO	1.00	2.00	21.00	f
4663	1570	\N	APPASSIMENTO	1.00	30.00	21.00	f
4664	1570	\N	GIN 0%	1.00	6.00	21.00	f
4665	1570	\N	Cuba-Li	2.00	6.00	21.00	f
4684	1573	\N	POLPETTE	2.00	15.00	12.00	t
4685	1573	\N	BLANC VERRE	2.00	5.00	21.00	t
4686	1573	\N	COCA / ZERO	1.00	2.00	21.00	t
4695	1576	\N	NOURRITURE	-1.00	-18.55	0.00	t
4698	1579	\N	CAFÉ	2.00	2.50	21.00	f
4699	1579	\N	EAU 1/2 L	1.00	3.50	21.00	f
4700	1579	\N	BLANC VERRE	1.00	5.00	21.00	f
4701	1579	\N	CHAMPIGNONS KABYLES	1.00	12.00	12.00	f
4702	1579	\N	COUSCOUS PM	1.00	15.00	12.00	f
4706	1582	\N	COCA / ZERO	1.00	2.00	21.00	f
4707	1582	\N	BURRATINA TRUFFES	1.00	17.00	12.00	f
4708	1582	\N	VIOLETTE	1.00	6.00	21.00	f
4709	1582	\N	PÂTES ASPERGES	1.00	18.00	12.00	f
4710	1582	\N	BEIGNETS DE COURGETTE	1.00	10.00	6.00	f
4713	1585	\N	PROCES	-1.00	-140.10	0.00	t
4716	1588	\N	NOURRITURE	-1.00	-29.96	0.00	t
4723	1591	\N	CYNAR	2.00	5.00	21.00	f
4724	1591	\N	PROSECCO VERRE	2.00	6.00	21.00	f
4725	1591	\N	CAFÉ	2.00	2.50	21.00	f
4726	1591	\N	LIMONCELLO	2.00	5.00	21.00	f
4727	1591	\N	PRIMITIVO NR 14	1.00	5.00	21.00	f
4728	1591	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
4729	1591	\N	BURRATINA PESTO	1.00	15.00	12.00	f
4730	1591	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	f
4731	1591	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	f
4732	1591	\N	COUSCOUS PM	1.00	15.00	12.00	f
4739	1594	\N	BLANC VERRE	3.00	5.00	21.00	f
4740	1594	\N	PROSECCO VERRE	2.00	6.00	21.00	f
4741	1594	\N	CYNAR	1.00	5.00	21.00	f
4752	1597	\N	Service Caro	-1.00	-50.00	0.00	t
4755	1600	\N	BLANC VERRE	1.00	5.00	21.00	f
4756	1600	\N	ROUGE VERRE	1.00	5.00	21.00	f
4757	1600	\N	POLPETTE	1.00	15.00	12.00	f
4758	1600	\N	COUSCOUS PM	1.00	15.00	12.00	f
4770	1603	\N	IRISH COFFEE	1.00	8.00	21.00	f
4771	1603	\N	AMARONE	2.00	50.00	21.00	f
4772	1603	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	f
4773	1603	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
4774	1603	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
4777	1606	\N	COUSCOUS PM	2.00	15.00	6.00	t
4780	1609	\N	Nettoyage	-1.00	-20.00	0.00	t
4781	1609	\N	Nettoyage	-1.00	-20.00	0.00	t
4785	1612	\N	FRAIS	-1.00	-10.00	0.00	t
4793	1615	\N	FRAIS	-1.00	-27.17	0.00	t
4796	1618	\N	LOYER	-1.00	-600.00	0.00	t
4799	1621	\N	ORANGE	-1.00	-28.00	0.00	t
4802	1624	\N	CORNET BOLO	1.00	6.00	6.00	f
4803	1624	\N	CORNET TRUFFE	1.00	7.00	6.00	f
4806	1627	\N	L'OUSTEAU (AUBERGINES)	1.00	7.50	6.00	t
4807	1627	\N	HUILE ESPEJO	1.00	20.00	6.00	t
4808	1627	\N	CORNET BOLO	1.00	6.00	6.00	t
4818	1630	\N	ESPRESSO	1.00	2.50	21.00	f
4819	1630	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
4820	1630	\N	TAJINE	1.00	15.00	12.00	f
4821	1630	\N	VIOLETTE	1.00	6.00	21.00	f
4822	1630	\N	PINOT GRIGIO BLUSH	1.00	5.00	21.00	f
4823	1630	\N	BEIGNETS DE COURGETTE	1.00	12.00	6.00	f
4826	1633	\N	CORNET LARD	1.00	6.00	6.00	f
4827	1633	\N	CORNET BOLO	1.00	6.00	6.00	f
4831	1636	\N	COCA / ZERO	1.00	2.00	21.00	f
4832	1636	\N	FANTA	1.00	2.00	21.00	f
4833	1636	\N	CHAMPIGNONS KABYLES	2.00	12.00	12.00	f
4843	1639	\N	CORNET LARD	1.00	6.00	6.00	f
4853	1642	\N	THÉ MENTHE	2.00	2.50	21.00	f
4854	1642	\N	ROUGE VERRE	1.00	5.00	21.00	f
4855	1642	\N	BLANC VERRE	1.00	5.00	21.00	f
4542	1538	\N	TCHAKTCHOUKA	1.00	10.00	12.00	f
4543	1538	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	f
4544	1538	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
4545	1538	\N	EAU DE BARNEY	1.00	0.00	6.00	f
4546	1538	\N	ROUGE VERRE	2.00	5.00	21.00	f
4547	1538	\N	CAFÉ	1.00	2.50	21.00	f
4548	1538	\N	THÉ MENTHE	5.00	2.50	21.00	f
4549	1538	\N	GATEAUX MIEL	1.00	5.00	12.00	f
4550	1538	\N	CREME BRULEE	1.00	5.00	12.00	f
4553	1541	\N	NOURRITURE	-1.00	-13.08	0.00	t
4559	1544	\N	CORNET BOLO	1.00	6.00	6.00	f
4565	1547	\N	NOURRITURE	-1.00	-75.78	0.00	t
4571	1550	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	f
4572	1550	\N	SOFT (Verre)	2.00	2.00	21.00	f
4573	1550	\N	JUPILER	2.00	2.50	21.00	f
4579	1553	\N	JUPILER	1.00	2.50	21.00	f
4580	1553	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	f
4587	1556	\N	POLPETTE	3.00	15.00	12.00	t
4588	1556	\N	PÂTES BOLO/LARD	2.00	12.00	12.00	t
4589	1556	\N	PÂTES TRUFFE	1.00	15.00	12.00	t
4590	1556	\N	BURRATINA TRUFFES	1.00	17.00	12.00	t
4591	1556	\N	BURRATINA PESTO	0.00	15.00	12.00	t
4592	1556	\N	PÂTES ASPERGES	3.00	18.00	12.00	t
4593	1556	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
4594	1556	\N	BOMBE  CALABRÈSE	2.00	15.00	12.00	t
4602	1559	\N	NOURRITURE	-1.00	-39.89	0.00	t
4606	1562	\N	AMARETTO	1.00	5.00	21.00	f
4607	1562	\N	TATIN	1.00	8.00	12.00	f
4608	1562	\N	PROSECCO VERRE	1.00	6.00	21.00	f
4609	1562	\N	TAJINE	1.00	15.00	12.00	f
4610	1562	\N	COUSCOUS PM	1.00	15.00	12.00	f
4628	1565	\N	Service Célia	-1.00	-40.00	0.00	t
4650	1568	\N	COCA / ZERO	1.00	2.00	21.00	t
4651	1568	\N	Cuba-Li	1.00	6.00	21.00	t
4652	1568	\N	GIN 0%	1.00	6.00	21.00	t
4653	1568	\N	TAJINE	1.00	15.00	12.00	t
4654	1568	\N	COUSCOUS PM	1.00	15.00	12.00	t
4666	1571	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
4667	1571	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
4668	1571	\N	ROSÉ VERRE	1.00	5.00	21.00	t
4669	1571	\N	ROUGE VERRE	1.00	5.00	21.00	t
4670	1571	\N	ICE TEA	1.00	2.00	21.00	t
4671	1571	\N	COCA / ZERO	1.00	2.00	21.00	t
4672	1571	\N	PROSECCO VERRE	1.00	6.00	21.00	t
4673	1571	\N	POLPETTE	1.00	15.00	12.00	t
4674	1571	\N	THÉ MENTHE	1.00	2.50	21.00	t
4675	1571	\N	CAFÉ	1.00	2.50	21.00	t
4676	1571	\N	CREME BRULEE	2.00	5.00	12.00	t
4677	1571	\N	ORVAL	1.00	5.00	21.00	t
4687	1574	\N	CHAMPIGNONS KABYLES	1.00	12.00	12.00	t
4688	1574	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
4689	1574	\N	PECKET FRAISE	2.00	6.00	21.00	t
4696	1577	\N	NOURRITURE	-1.00	-14.00	0.00	t
4703	1580	\N	CAFÉ	1.00	2.50	21.00	f
4704	1580	\N	CYNAR	1.00	5.00	21.00	f
4711	1583	\N	JUPILER	3.00	2.00	21.00	f
4714	1586	\N	ORANGE	-1.00	-14.00	0.00	t
4717	1589	\N	CORNET BOLO	1.00	6.00	6.00	t
4733	1592	\N	BLANC VERRE	1.00	5.00	21.00	f
4734	1592	\N	ROSÉ VERRE	1.00	5.00	21.00	f
4742	1595	\N	JUPILER	3.00	2.00	21.00	f
4753	1598	\N	CORNET BOLO	2.00	6.00	6.00	t
4759	1601	\N	BLONDINETTE	4.00	4.00	21.00	t
4760	1601	\N	Cuba-Li	1.00	6.00	21.00	t
4761	1601	\N	COUSCOUS PM	4.00	15.00	12.00	t
4762	1601	\N	SCAMPIS LUCIFER	2.00	10.00	12.00	t
4763	1601	\N	TCHAKTCHOUKA	1.00	10.00	12.00	t
4764	1601	\N	BEIGNETS DE COURGETTE	1.00	14.00	6.00	t
4765	1601	\N	CAFÉ	2.00	2.50	21.00	t
4766	1601	\N	THÉ MENTHE	1.00	2.50	21.00	t
4775	1604	\N	Service Caro	-1.00	-40.00	0.00	t
4778	1607	\N	NOURRITURE	-1.00	-13.44	0.00	t
4782	1610	\N	Service Véro	-1.00	-10.00	0.00	t
4786	1613	\N	LIMONCELLO	2.00	0.00	21.00	t
4787	1613	\N	EAU 1/2 L	1.00	3.50	21.00	t
4788	1613	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
4789	1613	\N	BURRATINA TRUFFES	1.00	17.00	12.00	t
4790	1613	\N	TAJINE	1.00	15.00	12.00	t
4791	1613	\N	BEIGNETS DE COURGETTE	1.00	14.00	6.00	t
4794	1616	\N	ENERGIES	-1.00	-97.27	0.00	t
4797	1619	\N	FRED	-1.00	-400.00	0.00	t
4800	1622	\N	ORANGE	-1.00	-14.00	0.00	t
4804	1625	\N	CORNET BOLO	1.00	6.00	6.00	t
4809	1628	\N	ICE TEA	1.00	2.00	21.00	t
4810	1628	\N	GIN TONIC	1.00	6.00	21.00	t
4811	1628	\N	BURRATINA TRUFFES	1.00	17.00	12.00	t
4812	1628	\N	COUSCOUS PM	1.00	15.00	12.00	t
4824	1631	\N	JUPILER	2.00	2.00	21.00	f
4828	1634	\N	CORNET TRUFFE	1.00	7.00	6.00	f
4834	1637	\N	PROSECCO VERRE	2.00	6.00	21.00	t
4835	1637	\N	PÂTES ASPERGES	2.00	18.00	12.00	t
4844	1640	\N	COUSCOUS PM	1.00	15.00	6.00	f
4861	1643	\N	COUSCOUS PM	1.00	15.00	6.00	f
4869	1646	\N	NOURRITURE	-1.00	-31.99	0.00	t
4872	1649	\N	CREME BRULEE	1.00	5.00	12.00	f
4873	1649	\N	GRAPPA	1.00	5.00	21.00	f
4874	1649	\N	LIMONCELLO	1.00	5.00	21.00	f
4875	1649	\N	GINGEMBRE	2.00	6.00	21.00	f
4876	1649	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
4877	1649	\N	PÂTES ASPERGES	1.00	18.00	12.00	f
4878	1649	\N	COUSCOUS PM	2.00	15.00	12.00	f
4879	1649	\N	SCAMPIS LUCIFER	2.00	10.00	12.00	f
4880	1649	\N	TCHAKTCHOUKA	1.00	10.00	12.00	f
4885	1652	\N	VESPA	-1.00	-420.00	0.00	t
4888	1655	\N	NOURRITURE	-1.00	-23.32	0.00	t
4898	1658	\N	SERVICE Elise	-1.00	-40.00	0.00	t
4901	1661	\N	BOISSONS	-1.00	-166.25	0.00	t
4907	1664	\N	SCAMPIS LUCIFER	1.00	10.00	12.00	f
4908	1664	\N	BURRATINA TRUFFES	1.00	17.00	12.00	f
4909	1664	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	f
4910	1664	\N	PÂTES TRUFFE	1.00	15.00	12.00	f
4911	1664	\N	PÂTES ASPERGES	1.00	18.00	12.00	f
4912	1664	\N	COUSCOUS PM	1.00	15.00	12.00	f
4913	1664	\N	PÂTES BOLO/LARD	2.00	12.00	12.00	f
4923	1667	\N	BASKET JULKIE	-1.00	-61.98	0.00	t
4926	1670	\N	ORANGE	-1.00	-28.00	0.00	t
4929	1673	\N	LABO OLIVIER	-1.00	-30.67	0.00	t
4932	1676	\N	L'OUSTEAU (AUBERGINES)	1.00	7.50	6.00	f
4933	1676	\N	HUILE ESPEJO	1.00	20.00	6.00	f
4941	1679	\N	LIMONCELLO	4.00	0.00	21.00	f
4557	1542	\N	L'OUSTEAU (TOMATES SECHEES)	1.00	6.00	6.00	f
4560	1545	\N	CREME BRULEE	1.00	5.00	12.00	f
4561	1545	\N	SABAYON	1.00	8.00	12.00	f
4562	1545	\N	PÂTES ASPERGES	1.00	18.00	12.00	f
4563	1545	\N	COUSCOUS PM	1.00	15.00	12.00	f
4566	1548	\N	NOURRITURE	-1.00	-80.00	0.00	t
4574	1551	\N	COCA / ZERO	1.00	2.00	21.00	t
4575	1551	\N	FANTA	1.00	2.00	21.00	t
4576	1551	\N	CHAMPIGNONS KABYLES	2.00	12.00	12.00	t
4581	1554	\N	POLPETTE	1.00	15.00	12.00	t
4582	1554	\N	PRIMITIVO NR 14	2.00	24.00	21.00	t
4583	1554	\N	CHARDONNAY FIO	1.00	20.00	21.00	t
4595	1557	\N	CYNAR	1.00	5.00	21.00	f
4596	1557	\N	PECKET FRAISE	2.00	6.00	21.00	f
4597	1557	\N	Cuba-Li	3.00	6.00	21.00	f
4598	1557	\N	PRIMITIVO NR 14	2.00	5.00	21.00	f
4599	1557	\N	JUPILER	2.00	2.50	21.00	f
4600	1557	\N	COCA / ZERO	2.00	2.00	21.00	f
4603	1560	\N	NOURRITURE	-1.00	-40.47	0.00	t
4611	1563	\N	TAJINE	1.00	15.00	12.00	t
4612	1563	\N	COUSCOUS PM	1.00	15.00	12.00	t
4613	1563	\N	COCA / ZERO	1.00	2.00	21.00	t
4614	1563	\N	Cuba-Li	1.00	6.00	21.00	t
4615	1563	\N	GIN 0%	1.00	6.00	21.00	t
4629	1566	\N	PRIMITIVO NR 14	1.00	30.00	21.00	t
4630	1566	\N	PÂTES ASPERGES	2.00	18.00	12.00	t
4631	1566	\N	BURRATINA TRUFFES	1.00	17.00	12.00	t
4632	1566	\N	Cuba-Li	2.00	6.00	21.00	t
4633	1566	\N	GIN 0%	1.00	6.00	21.00	t
4634	1566	\N	COCA / ZERO	1.00	2.00	21.00	t
4635	1566	\N	SCAMPIS LUCIFER	3.00	10.00	12.00	t
4655	1569	\N	AMARETTO	1.00	5.00	21.00	f
4656	1569	\N	TAJINE	1.00	15.00	12.00	f
4657	1569	\N	COUSCOUS PM	1.00	15.00	12.00	f
4658	1569	\N	PROSECCO VERRE	1.00	6.00	21.00	f
4678	1572	\N	PROSECCO VERRE	1.00	6.00	21.00	f
4679	1572	\N	PÂTES ASPERGES	1.00	18.00	12.00	f
4680	1572	\N	POLPETTE	2.00	15.00	12.00	f
4681	1572	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	f
4682	1572	\N	PRIMITIVO NR 14	2.00	24.00	21.00	f
4683	1572	\N	ORVAL	1.00	5.00	21.00	f
4690	1575	\N	BLONDINETTE	1.00	4.00	21.00	f
4691	1575	\N	COCA / ZERO	2.00	2.00	21.00	f
4692	1575	\N	CAFÉ	1.00	2.50	21.00	f
4693	1575	\N	EAU 1/2 L	1.00	3.50	21.00	f
4694	1575	\N	COUSCOUS PM	3.00	15.00	12.00	f
4697	1578	\N	NOURRITURE	-1.00	-30.25	0.00	t
4705	1581	\N	NOURRITURE	-1.00	-115.30	0.00	t
4712	1584	\N	ENERGIES	-1.00	-219.75	0.00	t
4715	1587	\N	FRAIS	-1.00	-100.00	0.00	t
4718	1590	\N	FANTA	1.00	2.00	21.00	t
4719	1590	\N	EAU 1/2 L	1.00	3.50	21.00	t
4720	1590	\N	COCA / ZERO	3.00	2.00	21.00	t
4721	1590	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
4722	1590	\N	TAJINE	4.00	15.00	12.00	t
4735	1593	\N	PROSECCO VERRE	2.00	6.00	21.00	t
4736	1593	\N	CYNAR	1.00	5.00	21.00	t
4737	1593	\N	PINOT GRIGIO (2020)	3.00	5.00	21.00	t
4738	1593	\N	BURRATINA PESTO	2.00	15.00	12.00	t
4743	1596	\N	PÂTES ASPERGES	1.00	18.00	12.00	f
4744	1596	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	f
4745	1596	\N	BEIGNETS DE COURGETTE	1.00	14.00	6.00	f
4746	1596	\N	IRISH COFFEE	3.00	8.00	21.00	f
4747	1596	\N	COCA / ZERO	3.00	2.00	21.00	f
4748	1596	\N	PINOT GRIGIO BLUSH	3.00	20.00	21.00	f
4749	1596	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	f
4750	1596	\N	COUSCOUS PM	2.00	15.00	12.00	f
4751	1596	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	f
4754	1599	\N	COUSCOUS PM	2.00	15.00	6.00	f
4767	1602	\N	SABAYON	1.00	8.00	12.00	f
4768	1602	\N	Cuba-Li	3.00	6.00	21.00	f
4769	1602	\N	LIMONCELLO	1.00	5.00	21.00	f
4776	1605	\N	BOISSONS	-1.00	-126.00	0.00	t
4779	1608	\N	Service Véro	-1.00	-20.00	0.00	t
4783	1611	\N	Nettoyage	-1.00	-20.00	0.00	t
4784	1611	\N	Nettoyage	-1.00	-20.00	0.00	t
4792	1614	\N	COMPTABLE	-1.00	-121.00	0.00	t
4795	1617	\N	Service Caro	-1.00	-30.00	0.00	t
4798	1620	\N	UCM	-1.00	-163.70	0.00	t
4801	1623	\N	ORANGE	-1.00	-28.00	0.00	t
4805	1626	\N	NOURRITURE	-1.00	-63.65	0.00	t
4813	1629	\N	CREME BRULEE	1.00	5.00	12.00	f
4814	1629	\N	BLANC VERRE	1.00	5.00	21.00	f
4815	1629	\N	ROUGE VERRE	2.00	5.00	21.00	f
4816	1629	\N	PINOT GRIGIO BLUSH	3.00	5.00	21.00	f
4817	1629	\N	PÂTES ASPERGES	2.00	18.00	12.00	f
4825	1632	\N	BOISSONS LUX	-1.00	-187.70	0.00	t
4829	1635	\N	CORNET BOLO	1.00	6.00	6.00	f
4830	1635	\N	CORNET LARD	1.00	6.00	6.00	f
4836	1638	\N	CAFÉ	2.00	2.50	21.00	t
4837	1638	\N	SABAYON	1.00	8.00	12.00	t
4838	1638	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
4839	1638	\N	BLANC VERRE	3.00	5.00	21.00	t
4840	1638	\N	BURRATINA PESTO	1.00	15.00	12.00	t
4841	1638	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
4842	1638	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
4845	1641	\N	CAFÉ	1.00	2.50	21.00	t
4846	1641	\N	ESPRESSO	2.00	2.50	21.00	t
4847	1641	\N	BLANC VERRE	1.00	5.00	21.00	t
4848	1641	\N	ROUGE VERRE	1.00	5.00	21.00	t
4849	1641	\N	EAUX 1 L	1.00	5.00	21.00	t
4850	1641	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
4851	1641	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	t
4852	1641	\N	TAJINE	1.00	15.00	12.00	t
4862	1644	\N	GRAPPA	1.00	5.00	21.00	f
4863	1644	\N	LIMONCELLO	1.00	5.00	21.00	f
4864	1644	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
4865	1644	\N	PROSECCO VERRE	4.00	6.00	21.00	f
4866	1644	\N	ESPRESSO	2.00	2.50	21.00	f
4870	1647	\N	NOURRITURE	-1.00	-3.84	0.00	t
4881	1650	\N	BEIGNETS DE COURGETTE	1.00	18.00	12.00	t
4882	1650	\N	TAJINE	1.00	15.00	12.00	t
4886	1653	\N	COUSCOUS PM	1.00	15.00	12.00	t
4889	1656	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
4890	1656	\N	PÂTES ASPERGES	2.00	18.00	12.00	t
4891	1656	\N	COUSCOUS PM	1.00	10.00	12.00	t
4899	1659	\N	EQUIPEMENT	-1.00	-36.54	0.00	t
4902	1662	\N	VACANCES	-1.00	-535.00	0.00	t
4914	1665	\N	ESPRESSO	1.00	2.50	21.00	f
4915	1665	\N	COCA / ZERO	1.00	2.00	21.00	f
4916	1665	\N	CHARDONNAY FIO	1.00	5.00	21.00	f
4856	1642	\N	PROSECCO VERRE	1.00	6.00	21.00	f
4857	1642	\N	VIOLETTE	1.00	6.00	21.00	f
4858	1642	\N	POLPETTE	1.00	15.00	12.00	f
4859	1642	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	f
4860	1642	\N	BEIGNETS DE COURGETTE	1.00	14.00	12.00	f
4867	1645	\N	TATIN	2.00	8.00	12.00	f
4868	1645	\N	COUSCOUS PM	2.00	15.00	12.00	f
4871	1648	\N	NOURRITURE	-1.00	-5.73	0.00	t
4883	1651	\N	BURRATINA TRUFFES	1.00	17.00	12.00	t
4884	1651	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
4887	1654	\N	Service Caro	-1.00	-100.00	0.00	t
4892	1657	\N	TATIN	1.00	8.00	12.00	t
4893	1657	\N	ROUGE VERRE	1.00	0.00	21.00	t
4894	1657	\N	ROSÉ VERRE	3.00	0.00	21.00	t
4895	1657	\N	COUSCOUS PM	1.00	15.00	12.00	t
4896	1657	\N	TAJINE	1.00	15.00	12.00	t
4897	1657	\N	TCHAKTCHOUKA	1.00	10.00	12.00	t
4900	1660	\N	NOURRITURE	-1.00	-8.20	0.00	t
4903	1663	\N	COCA / ZERO	2.00	2.00	21.00	f
4904	1663	\N	PRIMITIVO NR 14	4.00	5.00	21.00	f
4905	1663	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	f
4906	1663	\N	PROSECCO VERRE	2.00	6.00	21.00	f
4922	1666	\N	VERNIS JULIE	-1.00	-50.00	0.00	t
4925	1669	\N	FRAIS	-1.00	-14.47	0.00	t
4928	1672	\N	BRISCARD	-1.00	-18.00	0.00	t
4931	1675	\N	AUTOSECURITE LOUNA	-1.00	-16.00	0.00	t
4936	1678	\N	CREME BRULEE	2.00	5.00	12.00	f
4937	1678	\N	JUPILER	3.00	2.50	21.00	f
4938	1678	\N	GIN 0%	1.00	6.00	21.00	f
4939	1678	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	f
4940	1678	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	f
4951	1682	\N	COUSCOUS VG	1.00	10.00	12.00	f
4952	1682	\N	PÂTES ASPERGES	1.00	18.00	12.00	f
4953	1682	\N	GINGEMBRE	1.00	6.00	21.00	f
4954	1682	\N	VIOLETTE	1.00	6.00	21.00	f
4957	1685	\N	RESTO CARO	-1.00	-122.00	0.00	t
4964	1688	\N	PINOT GRIGIO BLUSH	2.00	20.00	21.00	t
4965	1688	\N	BLANC VERRE	1.00	5.00	21.00	t
4966	1688	\N	JUPILER	1.00	2.50	21.00	t
4967	1688	\N	BLONDINETTE	1.00	4.00	21.00	t
4968	1688	\N	COUSCOUS PM	2.00	15.00	12.00	t
4975	1691	\N	CREME BRULEE	2.00	5.00	6.00	t
4976	1691	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	6.00	t
4977	1691	\N	BURRATINA PESTO	1.00	15.00	6.00	t
4978	1691	\N	COCA / ZERO	2.00	2.00	21.00	t
4985	1694	\N	GINGEMBRE	1.00	8.00	21.00	f
4986	1694	\N	SPAG.COURGETTE + SCAMPIS	2.00	18.00	12.00	f
4998	1697	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	f
4999	1697	\N	GIN 0%	1.00	6.00	21.00	f
5003	1700	\N	NOURRITURE	-1.00	-25.04	0.00	t
5006	1703	\N	Nettoyage	-1.00	-20.00	0.00	t
5010	1706	\N	CORNET BOLO	1.00	6.00	6.00	f
5019	1709	\N	COCA / ZERO	1.00	0.00	21.00	t
5020	1709	\N	JUPILER	1.00	0.00	21.00	t
5021	1709	\N	FANTA	2.00	0.00	21.00	t
5022	1709	\N	ARROSTICINNI (5)	1.00	0.00	12.00	t
5023	1709	\N	BURRATINA PESTO	1.00	0.00	12.00	t
5028	1712	\N	NOURRITURE	-1.00	-35.46	0.00	t
5036	1715	\N	IRISH COFFEE	1.00	0.00	21.00	t
5037	1715	\N	CREME BRULEE	1.00	0.00	12.00	t
5038	1715	\N	PINOT GRIGIO BLUSH	1.00	14.00	21.00	t
5039	1715	\N	PECKET FRAISE	1.00	0.00	21.00	t
5040	1715	\N	BLONDINETTE	1.00	0.00	21.00	t
5041	1715	\N	BLONDINETTE	1.00	0.00	21.00	t
5042	1715	\N	PÂTES ASPERGES	1.00	0.00	12.00	t
5043	1715	\N	BURRATINA PESTO	1.00	0.00	12.00	t
5057	1718	\N	Service Caro	-1.00	-54.00	0.00	t
5075	1721	\N	Service Célia	-1.00	-40.00	0.00	t
5078	1724	\N	NOURRITURE	-1.00	-87.50	0.00	t
5081	1727	\N	NOURRITURE	-1.00	-82.72	0.00	t
5084	1730	\N	AG ASSURANCE	-1.00	-166.36	0.00	t
5087	1733	\N	CARBURANT	-1.00	-366.67	0.00	t
5090	1736	\N	CORNET BOLO	1.00	6.00	6.00	t
5091	1736	\N	CORNET LARD	1.00	6.00	6.00	t
5095	1739	\N	EAUX 1 L	1.00	5.00	21.00	t
5096	1739	\N	COUSCOUS PM	1.00	15.00	12.00	t
5097	1739	\N	TCHAKTCHOUKA	1.00	15.00	12.00	t
5113	1742	\N	BLONDINETTE	1.00	4.00	21.00	t
5114	1742	\N	PROSECCO VERRE	1.00	6.00	21.00	t
5126	1745	\N	Service Victor	-1.00	-50.00	0.00	t
5129	1748	\N	GUINGUETTE	-1.00	-70.00	0.00	t
5134	1751	\N	Service Véro	-1.00	-50.00	0.00	t
5137	1754	\N	NOURRITURE	-1.00	-10.50	0.00	t
5140	1757	\N	BOISSONS	-1.00	-137.40	0.00	t
5143	1760	\N	CAFÉ	2.00	2.50	21.00	t
5144	1760	\N	EAU 1/2 L	1.00	3.50	21.00	t
5145	1760	\N	CREPE KABYLE	1.00	10.00	12.00	t
5146	1760	\N	PÂTES LARD	1.00	13.00	12.00	t
5153	1763	\N	ZÉRO	1.00	0.00	6.00	t
5158	1766	\N	CAFÉ	3.00	2.50	21.00	f
5159	1766	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	f
5160	1766	\N	SPAG.COURGETTE + SCAMPIS	2.00	18.00	12.00	f
5161	1766	\N	POLPETTE	1.00	16.00	12.00	f
5162	1766	\N	SCAMPIS LUCIFER	1.00	10.00	12.00	f
5163	1766	\N	CHAMPIGNONS KABYLES	2.00	8.00	12.00	f
5169	1769	\N	NOURRITURE	-1.00	-32.72	0.00	t
5178	1772	\N	CORNET LARD	2.00	6.00	6.00	f
5187	1775	\N	CREPE KABYLE	1.00	0.00	12.00	t
5188	1775	\N	PÂTES BOMBE ATOMIQUE+ BURRATA	1.00	17.00	12.00	t
5189	1775	\N	PÂTES TRUFFE + BURRATA	3.00	17.00	12.00	t
5190	1775	\N	COUSCOUS PM	5.00	17.00	12.00	t
5191	1775	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
5192	1775	\N	ICE TEA	1.00	2.20	21.00	f
5193	1775	\N	COCA	3.00	2.20	21.00	f
5194	1775	\N	COCA ZERO	2.00	2.20	21.00	f
5195	1775	\N	PINOT GRIGIO (2020)	2.00	20.00	21.00	f
5196	1775	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
5197	1775	\N	IRISH COFFEE	1.00	8.00	21.00	f
5198	1775	\N	CAFÉ	2.00	2.50	21.00	f
5199	1775	\N	CREME BRULEE	2.00	5.00	12.00	t
5204	1778	\N	ORANGE	-1.00	-14.07	0.00	t
5210	1781	\N	NOURRITURE	-1.00	-23.73	0.00	t
5213	1784	\N	TATIN	1.00	8.00	12.00	f
5214	1784	\N	BLANC VERRE	2.00	5.00	21.00	f
5215	1784	\N	PECKET FRAISE	1.00	8.00	21.00	f
5216	1784	\N	CREPE CREME LARD	1.00	10.00	12.00	f
5218	1785	\N	FANTA	1.00	2.20	21.00	f
5219	1785	\N	COCA	1.00	2.20	21.00	f
5220	1785	\N	PÂTES BOLO	2.00	13.00	12.00	f
4917	1665	\N	CYNAR	1.00	5.00	21.00	f
4918	1665	\N	GINGEMBRE	1.00	6.00	21.00	f
4919	1665	\N	PROSECCO VERRE	2.00	6.00	21.00	f
4920	1665	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	f
4921	1665	\N	PÂTES ASPERGES	3.00	18.00	12.00	f
4924	1668	\N	NOURRITURE	-1.00	-30.79	0.00	t
4927	1671	\N	SODEXO	-1.00	-30.00	0.00	t
4930	1674	\N	BOISSONS	-1.00	-214.41	0.00	t
4934	1677	\N	CORNET TRUFFE	1.00	7.00	6.00	f
4935	1677	\N	CORNET BOLO	1.00	6.00	6.00	f
4949	1680	\N	Service Caro	-1.00	-58.00	0.00	t
4955	1683	\N	Service Célia	-1.00	-25.00	0.00	t
4958	1686	\N	NOURRITURE	-1.00	-13.41	0.00	t
4969	1689	\N	BLANC VERRE	1.00	5.00	21.00	t
4970	1689	\N	BLONDINETTE	1.00	4.00	21.00	t
4971	1689	\N	PINOT GRIGIO BLUSH	1.00	20.00	21.00	t
4972	1689	\N	JUPILER	1.00	2.50	21.00	t
4973	1689	\N	COUSCOUS PM	1.00	15.00	12.00	t
4979	1692	\N	BLONDINETTE	1.00	4.00	21.00	t
4980	1692	\N	AMARETTO	1.00	5.00	21.00	t
4981	1692	\N	GIN 0%	1.00	6.00	21.00	t
4987	1695	\N	CAFÉ	1.00	2.50	21.00	f
4988	1695	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
4989	1695	\N	PINOT GRIGIO (2020)	1.00	5.00	21.00	f
4990	1695	\N	POLPETTE	1.00	15.00	12.00	f
4991	1695	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	f
5000	1698	\N	ROSÉ VERRE	2.00	0.00	21.00	t
5001	1698	\N	CHAMPIGNONS KABYLES	1.00	0.00	12.00	t
5004	1701	\N	CHÂTEAU GONFLABLE	-1.00	-160.00	0.00	t
5007	1704	\N	Nettoyage	-1.00	-20.00	0.00	t
5008	1704	\N	Nettoyage	-1.00	-20.00	0.00	t
5011	1707	\N	CORNET LARD	2.00	6.00	6.00	f
5024	1710	\N	COCA / ZERO	1.00	2.00	21.00	t
5025	1710	\N	PROSECCO VERRE	1.00	6.00	21.00	t
5026	1710	\N	JUPILER	2.00	2.00	21.00	t
5029	1713	\N	CORNET BOLO	1.00	6.00	6.00	t
5044	1716	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	t
5045	1716	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
5046	1716	\N	BLONDINETTE	1.00	4.00	21.00	t
5047	1716	\N	COCA / ZERO	10.00	2.00	21.00	t
5048	1716	\N	APEROL SPRITZ	4.00	6.00	21.00	t
5049	1716	\N	PECKET FRAISE	1.00	6.00	21.00	t
5050	1716	\N	CREME BRULEE	4.00	5.00	12.00	t
5051	1716	\N	SABAYON	2.00	8.00	12.00	t
5052	1716	\N	BURRATINA TRUFFES	1.00	17.00	12.00	t
5053	1716	\N	TAJINE	3.00	15.00	12.00	t
5054	1716	\N	COUSCOUS PM	4.00	15.00	12.00	t
5058	1719	\N	CREME BRULEE	1.00	5.00	12.00	t
5059	1719	\N	CAFÉ	1.00	2.50	21.00	t
5060	1719	\N	ROUGE VERRE	1.00	5.00	21.00	t
5061	1719	\N	COCA / ZERO	4.00	2.00	21.00	t
5062	1719	\N	VIOLETTE	1.00	6.00	21.00	t
5063	1719	\N	PECKET FRAISE	1.00	6.00	21.00	t
5064	1719	\N	BURRATINA TRUFFES	1.00	17.00	12.00	t
5065	1719	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
5066	1719	\N	PÂTES STRACIATELLA SCAMPIS	1.00	17.00	12.00	t
5067	1719	\N	POLPETTE	1.00	15.00	12.00	t
5076	1722	\N	Service Cha	-1.00	-10.00	0.00	t
5079	1725	\N	NOURRITURE	-1.00	-62.91	0.00	t
5082	1728	\N	NOURRITURE	-1.00	-15.40	0.00	t
5085	1731	\N	NOURRITURE	-1.00	-68.75	0.00	t
5088	1734	\N	NOURRITURE	-1.00	-24.52	0.00	t
5092	1737	\N	COCA / ZERO	2.00	2.00	21.00	t
5093	1737	\N	SAUMON BURRATA	1.00	16.00	12.00	t
5098	1740	\N	COCA / ZERO	2.00	2.00	21.00	t
5099	1740	\N	IRISH COFFEE	1.00	8.00	21.00	t
5100	1740	\N	THÉ MENTHE	4.00	2.50	21.00	t
5101	1740	\N	GLACE	4.00	5.00	12.00	t
5102	1740	\N	SABAYON	2.00	8.00	12.00	t
5103	1740	\N	APPASSIMENTO	1.00	30.00	21.00	t
5104	1740	\N	ICE TEA	1.00	2.00	21.00	t
5105	1740	\N	FANTA	2.00	2.00	21.00	t
5106	1740	\N	GINGEMBRE	1.00	6.00	21.00	t
5107	1740	\N	PECKET FRAISE	4.00	6.00	21.00	t
5108	1740	\N	PLAT SPÉCIAL	1.00	18.00	12.00	t
5109	1740	\N	PÂTES STRACIATELLA SCAMPIS	2.00	17.00	12.00	t
5110	1740	\N	BURRATINA TRUFFES	1.00	17.00	12.00	t
5111	1740	\N	PÂTES BOLO/LARD	3.00	12.00	12.00	t
5115	1743	\N	PECKET FRAISE	1.00	0.00	21.00	t
5116	1743	\N	GRAPPA	1.00	0.00	21.00	t
5117	1743	\N	GLACE	1.00	5.00	12.00	t
5118	1743	\N	APPASSIMENTO	2.00	5.00	21.00	t
5119	1743	\N	EAU 1/2 L	1.00	3.50	21.00	t
5120	1743	\N	BLONDINETTE	2.00	4.00	21.00	t
5121	1743	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
5122	1743	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
5123	1743	\N	BURRATINA TRUFFES	1.00	17.00	12.00	t
5124	1743	\N	SAUMON BURRATA	1.00	16.00	12.00	t
5127	1746	\N	JULIE COIFFEUSE	-1.00	-65.00	0.00	t
5130	1749	\N	PINOT GRIGIO (2020)	1.00	5.00	21.00	t
5131	1749	\N	PECKET FRAISE	2.00	6.00	21.00	t
5132	1749	\N	PÂTES STRACIATELLA SCAMPIS	1.00	17.00	12.00	t
5135	1752	\N	Service Véro	-1.00	-40.00	0.00	t
5138	1755	\N	PNEUS (4)	-1.00	-100.00	0.00	t
5141	1758	\N	LOYER	-1.00	-600.00	0.00	t
5147	1761	\N	LIMONCELLO	2.00	0.00	21.00	t
5148	1761	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	t
5149	1761	\N	PINOT GRIGIO (2020)	5.00	5.00	21.00	t
5150	1761	\N	PROSECCO VERRE	2.00	6.00	21.00	t
5151	1761	\N	PÂTES TRUFFE + BURRATA	2.00	17.00	12.00	t
5154	1764	\N	ZÉRO	1.00	0.00	6.00	t
5164	1767	\N	COCA ZERO	2.00	2.20	21.00	t
5165	1767	\N	Cuba-Li	1.00	6.00	21.00	t
5166	1767	\N	COUSCOUS VG	1.00	10.00	12.00	t
5167	1767	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	t
5170	1770	\N	CREME BRULEE	2.00	5.00	12.00	t
5171	1770	\N	PRIMITIVO NR 14	2.00	5.00	21.00	t
5172	1770	\N	Cuba-Li	1.00	6.00	21.00	t
5173	1770	\N	PROSECCO VERRE	1.00	6.00	21.00	t
5174	1770	\N	TAJINE	1.00	17.00	12.00	t
5175	1770	\N	COUSCOUS PM	1.00	17.00	12.00	t
5179	1773	\N	Service Caro	-1.00	-40.00	0.00	t
5200	1776	\N	PÂTES SCAMPIS	1.00	17.00	6.00	f
5205	1779	\N	CREME BRULEE	1.00	5.00	12.00	t
5206	1779	\N	PÂTES LARD	1.00	6.00	6.00	t
5207	1779	\N	COUSCOUS PM	1.00	17.00	12.00	t
5208	1779	\N	ICE TEA	1.00	2.00	21.00	t
5211	1782	\N	NOURRITURE	-1.00	-107.37	0.00	t
5217	1785	\N	JUPILER	1.00	2.50	21.00	f
4942	1679	\N	CREME BRULEE	2.00	5.00	12.00	f
4943	1679	\N	BOMBE  CALABRÈSE	1.00	15.00	12.00	f
4944	1679	\N	BURRATINA PESTO	1.00	15.00	12.00	f
4945	1679	\N	COUSCOUS PM	2.00	15.00	12.00	f
4946	1679	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	f
4947	1679	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
4948	1679	\N	APPASSIMENTO	2.00	30.00	21.00	f
5005	1702	\N	SODEXO	-1.00	-30.00	0.00	t
5009	1705	\N	Service Véro	-1.00	-10.00	0.00	t
5012	1708	\N	PINOT GRIGIO BLUSH	1.00	0.00	21.00	t
5013	1708	\N	LIMONCELLO	1.00	0.00	21.00	t
5014	1708	\N	COCA / ZERO	1.00	2.00	21.00	t
5015	1708	\N	PINOT GRIGIO BLUSH	2.00	5.00	21.00	t
5016	1708	\N	VIOLETTE	2.00	8.00	21.00	t
5017	1708	\N	PROSECCO VERRE	2.00	6.00	21.00	t
5018	1708	\N	PÂTES BOLO/LARD	2.00	12.00	12.00	t
5027	1711	\N	NOURRITURE	-1.00	-107.61	0.00	t
5030	1714	\N	ROSÉ VERRE	1.00	5.00	21.00	t
5031	1714	\N	COCA / ZERO	1.00	2.00	21.00	t
5032	1714	\N	FANTA	1.00	2.00	21.00	t
5033	1714	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
5034	1714	\N	BURRATINA PESTO	1.00	15.00	12.00	t
5035	1714	\N	PÂTES BOLO/LARD	1.00	12.00	12.00	t
5055	1717	\N	JUPILER	4.00	2.50	21.00	t
5056	1717	\N	GIN 0%	1.00	6.00	21.00	t
5068	1720	\N	CAFÉ	2.00	2.50	21.00	t
5069	1720	\N	EAU 1/2 L	1.00	3.50	21.00	t
5070	1720	\N	PINOT GRIGIO BLUSH	1.00	20.00	21.00	t
5071	1720	\N	PECKET FRAISE	1.00	6.00	21.00	t
5072	1720	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
5073	1720	\N	PÂTES BOLO/LARD	2.00	12.00	12.00	t
5074	1720	\N	CAFÉ	1.00	2.50	21.00	t
5077	1723	\N	ANNIV CHARLOTTE	-1.00	-130.00	0.00	t
5080	1726	\N	NOURRITURE	-1.00	-8.00	0.00	t
5083	1729	\N	ROBOT TONDEUSE	-1.00	-400.00	0.00	t
5086	1732	\N	ORANGE	-1.00	-14.07	0.00	t
5089	1735	\N	NOURRITURE	-1.00	-26.75	0.00	t
5094	1738	\N	PECKET FRAISE	4.00	5.00	21.00	t
5112	1741	\N	NOURRITURE	-1.00	-6.52	0.00	t
5125	1744	\N	Service Victor	-1.00	-30.00	0.00	t
5128	1747	\N	CHA MAASTRICHT	-1.00	-40.00	0.00	t
5133	1750	\N	NOURRITURE	-1.00	-6.76	0.00	t
5136	1753	\N	Service Véro	-1.00	-10.00	0.00	t
5139	1756	\N	PINOT GRIGIO BLUSH	2.00	5.00	21.00	t
5142	1759	\N	PROCES	-1.00	-58.00	0.00	t
5152	1762	\N	Zéro	1.00	0.00	0.00	t
5155	1765	\N	EAU 1/2 L	1.00	3.50	21.00	t
5156	1765	\N	COUSCOUS PM	1.00	17.00	12.00	t
5157	1765	\N	COUSCOUS PM	1.00	17.00	12.00	t
5168	1768	\N	Service Caro	-1.00	-30.00	0.00	t
5176	1771	\N	CORNET TRUFFE	1.00	7.00	6.00	f
5177	1771	\N	CORNET BOLO	1.00	6.00	6.00	f
5180	1774	\N	L'OUSTEAU (OIGNONS CONFITS)	1.00	7.50	6.00	t
5181	1774	\N	GIN 0%	1.00	8.00	21.00	t
5182	1774	\N	APEROL SPRITZ	1.00	8.00	21.00	t
5183	1774	\N	PROSECCO VERRE	3.00	6.00	21.00	t
5184	1774	\N	VIOLETTE	3.00	8.00	21.00	t
5185	1774	\N	GINGEMBRE	4.00	8.00	21.00	t
5186	1774	\N	ASSIETTE APERITIVE (2 p.)	2.00	19.00	12.00	t
5201	1777	\N	EAU 1/2 L	1.00	2.20	21.00	t
5202	1777	\N	FANTA	1.00	2.20	21.00	t
5203	1777	\N	COCA	2.00	2.20	21.00	t
5209	1780	\N	SOFT (Verre)	2.00	2.20	21.00	f
5212	1783	\N	CORNET BOLO	4.00	6.00	6.00	f
5221	1785	\N	COUSCOUS PM	1.00	17.00	12.00	f
5222	1786	\N	TAJINE	1.00	17.00	6.00	f
5223	1786	\N	COUSCOUS PM	2.00	17.00	6.00	f
5224	1787	\N	NOURRITURE	-1.00	-18.30	0.00	t
5225	1788	\N	EAU 1/2 L	1.00	3.50	21.00	t
5226	1788	\N	FANTA	1.00	2.20	21.00	t
5227	1788	\N	PROSECCO VERRE	3.00	6.00	21.00	t
5228	1788	\N	CREPE KABYLE	1.00	10.00	12.00	t
5229	1788	\N	PÂTES TRUFFE	1.00	15.00	12.00	t
5230	1789	\N	SODEXO	-1.00	-30.00	0.00	t
5231	1790	\N	ENERGIES	-1.00	-219.75	0.00	t
5232	1791	\N	COMPTABLE	-1.00	-211.75	0.00	t
5233	1792	\N	ORANGE	-1.00	-28.00	0.00	t
5234	1793	\N	THÉ MENTHE	1.00	0.00	21.00	t
5235	1793	\N	SAUMON BURRATA PESTO	1.00	0.00	12.00	t
5236	1793	\N	TAJINE	1.00	0.00	12.00	t
5237	1793	\N	BLANC VERRE	2.00	0.00	21.00	t
5238	1794	\N	NOURRITURE	-1.00	-3.70	0.00	t
5239	1795	\N	NOURRITURE	-1.00	-58.39	0.00	t
5240	1796	\N	CREPE COURG.	2.00	14.00	12.00	f
5241	1796	\N	SOFT (Verre)	1.00	0.00	21.00	f
5242	1796	\N	COCA	2.00	2.20	21.00	f
5243	1796	\N	ICE TEA	3.00	2.20	21.00	f
5244	1796	\N	COUSCOUS PM	2.00	17.00	12.00	f
5245	1796	\N	CREPE BURRATA	1.00	12.00	12.00	f
5246	1796	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	f
5247	1796	\N	PINOT GRIGIO BLUSH	1.00	0.00	21.00	f
5248	1796	\N	PINOT GRIGIO BLUSH	3.00	20.00	21.00	f
5249	1797	\N	JUPILER	3.00	2.00	21.00	f
5250	1798	\N	NOURRITURE	-1.00	-37.05	0.00	t
5251	1799	\N	JUPILER	3.00	2.50	21.00	f
5252	1800	\N	PROSECCO VERRE	1.00	6.00	21.00	f
5253	1800	\N	PECKET FRAISE	1.00	8.00	21.00	f
5254	1800	\N	EAU PETILLANTE	1.00	2.20	21.00	f
5255	1800	\N	CREPE GORGONZOLA + COURG.	1.00	14.00	12.00	t
5256	1800	\N	COUSCOUS PM	1.00	17.00	12.00	t
5257	1800	\N	TCHAKTCHOUKA	1.00	10.00	12.00	t
5258	1800	\N	CREME BRULEE	1.00	5.00	12.00	t
5259	1800	\N	THÉ MENTHE	2.00	2.50	21.00	f
5260	1800	\N	ROUGE VERRE	1.00	5.00	21.00	f
5261	1800	\N	BLANC VERRE	1.00	5.00	21.00	t
5262	1800	\N	PROSECCO VERRE	2.00	6.00	21.00	f
5263	1801	\N	NOURRITURE	-1.00	-15.35	0.00	t
5264	1802	\N	ICE TEA	2.00	2.20	21.00	f
5265	1802	\N	COUSCOUS PM	2.00	17.00	6.00	f
5266	1803	\N	COCA ZERO	1.00	2.20	21.00	t
5267	1803	\N	COCA	1.00	2.20	21.00	t
5268	1803	\N	GLACE	1.00	5.00	12.00	t
5269	1803	\N	PÂTES BOLO	1.00	13.00	12.00	t
5270	1803	\N	BLANC VERRE	1.00	5.00	21.00	t
5271	1803	\N	PROSECCO VERRE	3.00	6.00	21.00	t
5272	1803	\N	SCAMPIS LUCIFER	2.00	10.00	12.00	t
5273	1804	\N	PÂTES TRUFFE + BURRATA	2.00	17.00	12.00	t
5274	1804	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
5275	1804	\N	SCAMPIS LUCIFER	1.00	10.00	12.00	t
5276	1804	\N	CHAMPIGNONS KABYLES	2.00	8.00	12.00	t
5279	1807	\N	NOURRITURE	-1.00	-17.52	0.00	t
5287	1810	\N	PÂTES BOLO	1.00	13.00	12.00	t
5288	1810	\N	PÂTES TRUFFE	1.00	15.00	12.00	t
5289	1810	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
5290	1810	\N	DECA	2.00	2.50	21.00	t
5291	1810	\N	CAFÉ	2.00	2.50	21.00	t
5292	1810	\N	CYNAR	2.00	5.00	21.00	t
5293	1810	\N	PROSECCO VERRE	1.00	6.00	21.00	t
5309	1813	\N	CORNET BOLO	1.00	6.00	6.00	t
5325	1816	\N	SERVICE Elise	-1.00	-70.00	0.00	t
5328	1819	\N	NOURRITURE	-1.00	-6.49	0.00	t
5331	1822	\N	CARBURANT	-1.00	-314.62	0.00	t
5334	1825	\N	BOISSONS	-1.00	-108.00	0.00	t
5342	1828	\N	CREME BRULEE	2.00	5.00	6.00	f
5345	1831	\N	PÂTES BOLO	1.00	13.00	12.00	t
5346	1831	\N	PÂTES LARD	1.00	13.00	12.00	t
5347	1831	\N	PROSECCO VERRE	1.00	6.00	21.00	t
5351	1834	\N	COUSCOUS PM	3.00	17.00	6.00	f
5354	1837	\N	NOURRITURE	-1.00	-8.40	0.00	t
5358	1840	\N	JUPILER	2.00	2.50	21.00	t
5359	1840	\N	PÂTES BOLO	1.00	13.00	12.00	t
5360	1840	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
5382	1843	\N	VIN 1/2	1.00	20.00	21.00	f
5383	1843	\N	CREME BRULEE	2.00	5.00	12.00	f
5384	1843	\N	TAJINE	2.00	17.00	12.00	f
5402	1846	\N	Service Elise	-1.00	-30.00	0.00	t
5405	1849	\N	CREME BRULEE	2.00	5.00	12.00	f
5406	1849	\N	COCA	1.00	2.20	21.00	f
5407	1849	\N	FANTA	1.00	2.20	21.00	f
5408	1849	\N	THÉ MENTHE	1.00	2.50	21.00	f
5409	1849	\N	PROSECCO VERRE	1.00	6.00	21.00	f
5410	1849	\N	PECKET FRAISE	1.00	8.00	21.00	f
5411	1849	\N	COUSCOUS PM	2.00	17.00	12.00	f
5412	1849	\N	TCHAKTCHOUKA	1.00	10.00	12.00	f
5419	1852	\N	THÉ MENTHE	2.00	2.50	21.00	f
5420	1852	\N	PINOT GRIGIO BLUSH	1.00	20.00	21.00	f
5421	1852	\N	PINOT GRIGIO BLUSH	1.00	5.00	21.00	f
5422	1852	\N	Cuba-Li	1.00	6.00	21.00	f
5423	1852	\N	CREPE GORGONZOLA + COURG. XXL	1.00	18.00	6.00	f
5424	1852	\N	PÂTES LARD	1.00	13.00	12.00	f
5437	1855	\N	ENERGIES CHAPON	-1.00	-243.38	0.00	t
5443	1858	\N	BLONDINETTE	3.00	4.00	21.00	t
5444	1858	\N	JUPILER	2.00	2.50	21.00	t
5445	1858	\N	BLONDINETTE	1.00	4.00	21.00	t
5446	1858	\N	PECKET FRAISE	2.00	8.00	21.00	t
5449	1861	\N	Service Véro	-1.00	-10.00	0.00	t
5453	1864	\N	Service Véro	-1.00	-10.00	0.00	t
5456	1867	\N	NOURRITURE	-1.00	-65.00	0.00	t
5463	1870	\N	PÂTES LARD	2.00	13.00	12.00	t
5464	1870	\N	PÂTES BOLO	1.00	13.00	12.00	t
5465	1870	\N	FANTA	2.00	2.20	21.00	t
5466	1870	\N	PROSECCO VERRE	2.00	6.00	21.00	t
5470	1873	\N	VACANCES LOUNA	-1.00	-50.00	0.00	t
5473	1876	\N	AUTOSECURITE	-1.00	-70.70	0.00	t
5477	1879	\N	SPAG.COURGETTE + SCAMPIS+BURRATA	1.00	22.00	12.00	t
5478	1879	\N	ICE TEA	1.00	2.20	21.00	t
5479	1879	\N	COCA	1.00	2.20	21.00	t
5480	1879	\N	PÂTES BOLO	1.00	13.00	12.00	t
5484	1882	\N	CORNET BOLO	2.00	6.00	6.00	t
5491	1885	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	f
5492	1885	\N	THÉ MENTHE	3.00	2.50	21.00	f
5493	1885	\N	EAUX 1 L	1.00	5.00	21.00	f
5494	1885	\N	SPAG.COURGETTE + SCAMPIS+BURRATA	1.00	22.00	12.00	f
5495	1885	\N	BURRATINA	1.00	14.00	12.00	f
5496	1885	\N	PÂTES BOMBE ATOMIQUE+ BURRATA	1.00	17.00	12.00	f
5497	1885	\N	COUSCOUS PM	2.00	17.00	12.00	f
5498	1885	\N	PECKET FRAISE	1.00	8.00	21.00	f
5499	1885	\N	PINOT GRIGIO BLUSH	2.00	20.00	21.00	f
5500	1885	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	f
5504	1888	\N	CHIARETTO	2.00	20.00	21.00	f
5517	1891	\N	TAJINE	1.00	17.00	12.00	t
5518	1891	\N	BURRATA PESTO	1.00	15.00	12.00	t
5519	1891	\N	TCHAKTCHOUKA	1.00	14.00	12.00	t
5520	1891	\N	GIN 0%	1.00	8.00	21.00	t
5521	1891	\N	PROSECCO VERRE	1.00	6.00	21.00	t
5522	1891	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	t
5523	1891	\N	BLANC VERRE	2.00	5.00	21.00	t
5524	1891	\N	JUPILER	1.00	2.50	21.00	t
5525	1891	\N	ICE TEA	1.00	2.20	21.00	t
5538	1894	\N	JUPILER	2.00	2.00	21.00	f
5557	1897	\N	Service Célia	-1.00	-30.00	0.00	t
5560	1900	\N	NOURRITURE	-1.00	-21.59	0.00	t
5566	1903	\N	CREPE FLAMBEE GD MARNIER	2.00	8.00	12.00	t
5567	1903	\N	PINOT BLANC	1.00	24.00	21.00	t
5568	1903	\N	PÂTES TRUFFE	1.00	15.00	12.00	t
5569	1903	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
5570	1903	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	t
5573	1906	\N	NOURRITURE	-1.00	-12.05	0.00	t
5577	1909	\N	POLPETTE	3.00	16.00	12.00	t
5578	1909	\N	FANTA	1.00	2.20	21.00	t
5579	1909	\N	COCA ZERO	2.00	2.20	21.00	t
5586	1912	\N	COUSCOUS PM	3.00	17.00	6.00	t
5589	1915	\N	PROCES	-1.00	-63.10	0.00	t
5592	1918	\N	NOURRITURE	-1.00	-23.20	0.00	t
5596	1921	\N	COCA ZERO	1.00	2.00	21.00	f
5604	1924	\N	DECA	1.00	2.50	21.00	f
5605	1924	\N	CREPE FLAMBEE GD MARNIER	1.00	5.00	12.00	f
5606	1924	\N	SABAYON SPECIAL	2.00	10.00	12.00	f
5607	1924	\N	TAJINE	1.00	17.00	12.00	f
5608	1924	\N	PÂTES BOLO	2.00	13.00	12.00	f
5609	1924	\N	ROSÉ VERRE	1.00	5.00	21.00	f
5610	1924	\N	ROUGE VERRE	2.00	5.00	21.00	f
5611	1924	\N	PROSECCO Bouteille	1.00	25.00	21.00	f
5614	1927	\N	ROSÉ VERRE	3.00	5.00	21.00	f
5621	1930	\N	THÉ MENTHE	1.00	2.50	21.00	t
5622	1930	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	t
5623	1930	\N	CREME BRULEE	1.00	5.00	12.00	t
5624	1930	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	t
5625	1930	\N	GINGEMBRE	1.00	8.00	21.00	t
5626	1930	\N	Cuba-Li	1.00	8.00	21.00	t
5627	1930	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
5628	1930	\N	PÂTES BOMBE ATOMIQUE+ BURRATA	1.00	17.00	12.00	t
5638	1933	\N	MERGUEZ	-1.00	-27.65	0.00	t
5651	1936	\N	VIN 1/2	1.00	0.00	21.00	f
5652	1936	\N	TAJINE	1.00	17.00	12.00	f
5653	1936	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
5668	1939	\N	FANTA	1.00	2.20	21.00	t
5669	1939	\N	THÉ MENTHE	1.00	2.50	21.00	t
5277	1805	\N	Service Caro	-1.00	-40.00	0.00	t
5280	1808	\N	CAFÉ	2.00	2.50	21.00	f
5281	1808	\N	COUSCOUS PM	4.00	17.00	12.00	f
5282	1808	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	f
5294	1811	\N	ICE TEA	1.00	2.20	21.00	t
5295	1811	\N	COCA	1.00	2.20	21.00	t
5296	1811	\N	COUSCOUS PM	2.00	17.00	12.00	t
5297	1811	\N	GIN TONIC	1.00	6.00	21.00	t
5298	1811	\N	PECKET FRAISE	1.00	8.00	21.00	t
5310	1814	\N	EAU DE BARNEY	1.00	0.00	6.00	f
5311	1814	\N	CREPE GORGONZOLA + COURG.	1.00	14.00	12.00	f
5312	1814	\N	PÂTES PESTO	2.00	14.00	12.00	f
5313	1814	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	f
5314	1814	\N	THÉ MENTHE	2.00	2.50	21.00	f
5315	1814	\N	SABAYON SPECIAL	1.00	10.00	12.00	f
5316	1814	\N	IRISH COFFEE	1.00	8.00	21.00	f
5317	1814	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	f
5318	1814	\N	PINOT GRIGIO BLUSH	1.00	20.00	21.00	f
5319	1814	\N	AMARONE	1.00	50.00	21.00	f
5320	1814	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
5326	1817	\N	LOYER	-1.00	-600.00	0.00	t
5329	1820	\N	NOURRITURE	-1.00	-9.52	0.00	t
5332	1823	\N	NOURRITURE	-1.00	-13.00	0.00	t
5335	1826	\N	CHARDONNAY FIO	1.00	20.00	21.00	t
5336	1826	\N	COUSCOUS PM	3.00	17.00	12.00	t
5343	1829	\N	TVA	-1.00	-572.47	0.00	t
5348	1832	\N	TRIPLE SAINTE NITOUCHE	1.00	4.50	21.00	f
5352	1835	\N	CORNET TRUFFE	1.00	0.00	6.00	t
5355	1838	\N	NOURRITURE	-1.00	-73.62	0.00	t
5361	1841	\N	THÉ MENTHE	2.00	0.00	21.00	f
5362	1841	\N	COCA	2.00	2.20	21.00	f
5363	1841	\N	JUPILER	1.00	2.50	21.00	f
5364	1841	\N	ORVAL	1.00	5.00	21.00	f
5365	1841	\N	PECKET FRAISE	1.00	8.00	21.00	f
5366	1841	\N	VIOLETTE	1.00	8.00	21.00	f
5367	1841	\N	CREPE GORGONZOLA + COURG. XXL	1.00	18.00	6.00	f
5368	1841	\N	PÂTES SCAMPIS	1.00	21.00	12.00	f
5369	1841	\N	TAJINE	1.00	17.00	12.00	f
5370	1841	\N	COUSCOUS VG	1.00	10.00	12.00	f
5385	1844	\N	JUPILER	1.00	2.50	21.00	f
5386	1844	\N	APEROL SPRITZ	1.00	8.00	21.00	f
5387	1844	\N	TRIPLE SAINTE NITOUCHE	2.00	4.50	21.00	f
5388	1844	\N	SOFT (Verre)	1.00	2.20	21.00	f
5389	1844	\N	ICE TEA	1.00	2.20	21.00	f
5390	1844	\N	COCA ZERO	2.00	2.20	21.00	f
5391	1844	\N	GIN 0%	2.00	8.00	21.00	f
5392	1844	\N	GLACE	1.00	5.00	12.00	f
5393	1844	\N	CAFÉ	1.00	2.50	21.00	f
5394	1844	\N	CAPUCCINO	2.00	2.80	21.00	f
5395	1844	\N	CREME BRULEE	3.00	5.00	12.00	f
5396	1844	\N	TATIN	1.00	8.00	12.00	f
5397	1844	\N	CREPE CHAKCHOUKA XXL	2.00	18.00	6.00	f
5398	1844	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	f
5399	1844	\N	PÂTES TRUFFE	1.00	15.00	12.00	f
5400	1844	\N	COUSCOUS PM	3.00	17.00	12.00	f
5403	1847	\N	NOURRITURE	-1.00	-29.50	0.00	t
5413	1850	\N	CREME BRULEE	2.00	5.00	12.00	t
5414	1850	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
5415	1850	\N	PECKET FRAISE	2.00	8.00	21.00	f
5416	1850	\N	PÂTES BOLO	1.00	13.00	12.00	t
5417	1850	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	t
5425	1853	\N	BURRATA PESTO	1.00	15.00	12.00	f
5426	1853	\N	COUSCOUS PM	1.00	17.00	12.00	f
5427	1853	\N	TATIN	1.00	8.00	12.00	f
5428	1853	\N	PINOT GRIGIO BLUSH	1.00	5.00	21.00	f
5429	1853	\N	EAU 1/2 L	1.00	3.50	21.00	f
5438	1856	\N	Service Victor	-1.00	-50.00	0.00	t
5447	1859	\N	BOISSONS LUX	-1.00	-44.90	0.00	t
5450	1862	\N	Service Véro	-1.00	-10.00	0.00	t
5454	1865	\N	NOURRITURE	-1.00	-11.69	0.00	t
5457	1868	\N	CORNET BOLO	2.00	6.00	6.00	t
5458	1868	\N	CORNET LARD	1.00	6.00	6.00	t
5467	1871	\N	JUPILER	2.00	2.00	21.00	f
5468	1871	\N	CORNET LARD	1.00	6.00	6.00	f
5471	1874	\N	AUTO CARO	-1.00	-117.50	0.00	t
5474	1877	\N	POULET	-1.00	-87.50	0.00	t
5481	1880	\N	TAJINE	2.00	17.00	12.00	f
5482	1880	\N	CHARDONNAY FIO	1.00	5.00	21.00	f
5485	1883	\N	ESPRESSO	2.00	2.50	21.00	t
5486	1883	\N	VIN 1/2	1.00	14.00	21.00	t
5487	1883	\N	PROSECCO VERRE	1.00	6.00	21.00	t
5488	1883	\N	Cuba-Li	1.00	6.00	21.00	t
5489	1883	\N	COUSCOUS PM	2.00	17.00	12.00	t
5501	1886	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	f
5502	1886	\N	PINOT GRIGIO BLUSH	1.00	20.00	21.00	f
5505	1889	\N	CORNET BOLO	2.00	6.00	6.00	f
5526	1892	\N	POLPETTE	1.00	16.00	12.00	f
5527	1892	\N	COUSCOUS PM	1.00	17.00	12.00	f
5528	1892	\N	TCHAKTCHOUKA	1.00	10.00	12.00	f
5529	1892	\N	COCA	1.00	0.00	21.00	f
5530	1892	\N	IRISH COFFEE	1.00	0.00	21.00	f
5531	1892	\N	CREME BRULEE	1.00	5.00	12.00	f
5532	1892	\N	TATIN	1.00	8.00	12.00	f
5533	1892	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
5539	1895	\N	TAJINE	3.00	17.00	12.00	t
5540	1895	\N	PÂTES TRUFFE	1.00	15.00	12.00	t
5541	1895	\N	PÂTES TRUFFE + BURRATA	4.00	17.00	12.00	t
5542	1895	\N	EAUX 1 L	1.00	5.00	21.00	t
5543	1895	\N	THÉ MENTHE	1.00	2.50	21.00	t
5544	1895	\N	GRAPPA MIEL	1.00	5.00	21.00	f
5545	1895	\N	CAFÉ	2.00	2.50	21.00	t
5546	1895	\N	DECA	1.00	2.50	21.00	t
5547	1895	\N	CREME BRULEE	1.00	5.00	12.00	t
5548	1895	\N	TATIN	1.00	8.00	12.00	t
5549	1895	\N	SABAYON SPECIAL	1.00	10.00	12.00	t
5550	1895	\N	COCA	2.00	2.20	21.00	t
5551	1895	\N	ASSIETTE APERITIVE (2 p.)	3.00	19.00	12.00	t
5552	1895	\N	PROSECCO Bouteille	1.00	25.00	21.00	f
5553	1895	\N	PROSECCO VERRE	1.00	6.00	21.00	t
5554	1895	\N	APEROL SPRITZ	4.00	8.00	21.00	f
5555	1895	\N	PECKET FRAISE	6.00	8.00	21.00	f
5558	1898	\N	Service Caro	-1.00	-50.00	0.00	t
5561	1901	\N	NOURRITURE	-1.00	-25.00	0.00	t
5571	1904	\N	CORNET BOLO	1.00	6.00	6.00	f
5574	1907	\N	NOURRITURE	-1.00	-7.42	0.00	t
5580	1910	\N	BLANC VERRE	2.00	5.00	21.00	t
5581	1910	\N	PROSECCO VERRE	2.00	6.00	21.00	t
5582	1910	\N	Cuba-Li	2.00	6.00	21.00	t
5587	1913	\N	ORANGE	-1.00	-14.00	0.00	t
5590	1916	\N	CORNET BOLO	1.00	6.00	6.00	t
5278	1806	\N	Service Caro	-1.00	-40.00	0.00	t
5283	1809	\N	FANTA	1.00	2.20	21.00	t
5284	1809	\N	TAJINE	2.00	17.00	12.00	t
5285	1809	\N	COCA ZERO	1.00	2.20	21.00	t
5286	1809	\N	PECKET FRAISE	1.00	8.00	21.00	t
5299	1812	\N	CREME BRULEE	1.00	5.00	12.00	t
5300	1812	\N	GLACE	2.00	5.00	12.00	t
5301	1812	\N	SABAYON SPECIAL	1.00	10.00	12.00	t
5302	1812	\N	Cuba-Li	1.00	6.00	21.00	t
5303	1812	\N	FANTA	1.00	2.20	21.00	t
5304	1812	\N	COCA ZERO	3.00	2.20	21.00	t
5305	1812	\N	PECKET FRAISE	3.00	8.00	21.00	t
5306	1812	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
5307	1812	\N	CREPE CREME LARD	2.00	12.00	12.00	t
5308	1812	\N	COUSCOUS VG	1.00	10.00	12.00	t
5321	1815	\N	Cuba-Li	1.00	6.00	21.00	f
5322	1815	\N	GIN TONIC	1.00	6.00	21.00	f
5323	1815	\N	COCA	1.00	2.20	21.00	f
5324	1815	\N	JUPILER	1.00	2.50	21.00	f
5327	1818	\N	CARBURANT	-1.00	-219.08	0.00	t
5330	1821	\N	CARBURANT	-1.00	-317.97	0.00	t
5333	1824	\N	NOURRITURE	-1.00	-12.11	0.00	t
5337	1827	\N	CREME BRULEE	1.00	5.00	12.00	f
5338	1827	\N	COCA	1.00	2.20	21.00	f
5339	1827	\N	FANTA	1.00	2.20	21.00	f
5340	1827	\N	PÂTES LARD	1.00	13.00	12.00	f
5341	1827	\N	CREPE CHAKCHOUKA	1.00	14.00	12.00	f
5344	1830	\N	CAFÉ	1.00	2.50	21.00	f
5349	1833	\N	CAFÉ	3.00	0.00	21.00	t
5350	1833	\N	EAU PETILLANTE	1.00	0.00	21.00	t
5353	1836	\N	NOURRITURE	-1.00	-15.21	0.00	t
5356	1839	\N	PÂTES LARD	1.00	13.00	12.00	f
5357	1839	\N	COUSCOUS PM	1.00	17.00	12.00	f
5371	1842	\N	TATIN	3.00	8.00	12.00	t
5372	1842	\N	SABAYON SPECIAL	1.00	10.00	12.00	t
5373	1842	\N	VIOLETTE	1.00	8.00	21.00	t
5374	1842	\N	PLAT SPÉCIAL	1.00	21.00	12.00	t
5375	1842	\N	CREPE GORGONZOLA + COURG. XXL	1.00	18.00	6.00	t
5376	1842	\N	CREPE KABYLE	1.00	12.00	12.00	t
5377	1842	\N	CREPE CREME LARD	1.00	12.00	12.00	t
5378	1842	\N	ICE TEA	1.00	2.20	21.00	t
5379	1842	\N	FANTA	1.00	2.20	21.00	t
5380	1842	\N	PROSECCO VERRE	1.00	6.00	21.00	t
5381	1842	\N	PECKET FRAISE	2.00	8.00	21.00	t
5401	1845	\N	Service Caro	-1.00	-40.00	0.00	t
5404	1848	\N	NOURRITURE	-1.00	-120.72	0.00	t
5418	1851	\N	CREME BRULEE	2.00	5.00	6.00	f
5430	1854	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
5431	1854	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
5432	1854	\N	ORVAL	1.00	5.00	21.00	t
5433	1854	\N	TRIPLE SAINTE NITOUCHE	2.00	4.50	21.00	t
5434	1854	\N	IRISH COFFEE	1.00	8.00	21.00	t
5435	1854	\N	LIMONCELLO	1.00	5.00	21.00	t
5436	1854	\N	PÂTES BOMBE ATOMIQUE+ BURRATA	1.00	17.00	12.00	t
5439	1857	\N	PECKET FRAISE	2.00	8.00	21.00	t
5440	1857	\N	BLONDINETTE	1.00	4.00	21.00	t
5441	1857	\N	TRIPLE SAINTE NITOUCHE	1.00	4.50	21.00	t
5442	1857	\N	PINOT GRIGIO BLUSH	4.00	5.00	21.00	t
5448	1860	\N	Service Véro	-1.00	-10.00	0.00	t
5451	1863	\N	Nettoyage	-1.00	-20.00	0.00	t
5452	1863	\N	Nettoyage	-1.00	-20.00	0.00	t
5455	1866	\N	NOURRITURE	-1.00	-16.79	0.00	t
5459	1869	\N	JUPILER	1.00	0.00	21.00	t
5460	1869	\N	COUSCOUS PM	1.00	0.00	12.00	t
5461	1869	\N	COCA ZERO	1.00	0.00	21.00	t
5462	1869	\N	PECKET FRAISE	1.00	0.00	21.00	t
5469	1872	\N	JM	-1.00	-200.00	0.00	t
5472	1875	\N	ASSURANCE CARO	-1.00	-80.00	0.00	t
5475	1878	\N	CORNET TRUFFE	2.00	7.00	6.00	f
5476	1878	\N	CORNET LARD	2.00	6.00	6.00	f
5483	1881	\N	NOURRITURE	-1.00	-74.04	0.00	t
5490	1884	\N	PINOT GRIGIO BLUSH	1.00	20.00	21.00	f
5503	1887	\N	NOURRITURE	-1.00	-7.26	0.00	t
5506	1890	\N	CREME BRULEE	1.00	5.00	12.00	f
5507	1890	\N	GLACE	1.00	5.00	12.00	f
5508	1890	\N	SABAYON	1.00	8.00	12.00	f
5509	1890	\N	APPASSIMENTO	1.00	30.00	21.00	f
5510	1890	\N	FANTA	2.00	2.20	21.00	f
5511	1890	\N	ICE TEA	1.00	2.20	21.00	f
5512	1890	\N	APEROL SPRITZ	1.00	8.00	21.00	f
5513	1890	\N	GINGEMBRE	1.00	8.00	21.00	f
5514	1890	\N	PÂTES TRUFFE + BURRATA	3.00	17.00	12.00	f
5515	1890	\N	COUSCOUS PM	2.00	17.00	12.00	f
5516	1890	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
5534	1893	\N	BURRATA PESTO	1.00	15.00	12.00	f
5535	1893	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
5536	1893	\N	CREME BRULEE	1.00	5.00	12.00	f
5537	1893	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	f
5556	1896	\N	Service Véro	-1.00	-30.00	0.00	t
5559	1899	\N	NOURRITURE	-1.00	-20.30	0.00	t
5562	1902	\N	BLANC VERRE	4.00	5.00	21.00	t
5563	1902	\N	CREPE GORGONZOLA + COURG.	1.00	14.00	12.00	t
5564	1902	\N	COUSCOUS VG	1.00	10.00	12.00	t
5565	1902	\N	TCHAKTCHOUKA	1.00	10.00	12.00	t
5572	1905	\N	CORNET BOLO	2.00	6.00	6.00	f
5575	1908	\N	PÂTES BOLO	1.00	13.00	12.00	t
5576	1908	\N	PROSECCO VERRE	2.00	6.00	21.00	t
5583	1911	\N	BLANC VERRE	1.00	5.00	21.00	f
5584	1911	\N	Cuba-Li	1.00	6.00	21.00	f
5585	1911	\N	PROSECCO VERRE	1.00	6.00	21.00	f
5588	1914	\N	SODEXO	-1.00	-30.00	0.00	t
5591	1917	\N	CREPE GORGONZOLA + COURG.	2.00	14.00	12.00	t
5595	1920	\N	CORNET BOLO	1.00	6.00	6.00	t
5600	1923	\N	ROUGE VERRE	1.00	5.00	21.00	t
5601	1923	\N	CAFÉ	1.00	2.50	21.00	t
5602	1923	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	t
5603	1923	\N	PÂTES PESTO	1.00	18.00	12.00	t
5613	1926	\N	NOURRITURE	-1.00	-5.58	0.00	t
5618	1929	\N	CREPE FLAMBEE GD MARNIER	2.00	8.00	12.00	f
5619	1929	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	f
5620	1929	\N	COUSCOUS PM	4.00	17.00	12.00	f
5637	1932	\N	EQUIPEMENT	-1.00	-75.86	0.00	t
5645	1935	\N	COCA	1.00	2.20	21.00	f
5646	1935	\N	CREPE SAUCE DE BASE + BURRATA	2.00	12.00	12.00	f
5647	1935	\N	CREPE GORGONZOLA + COURG.	1.00	14.00	12.00	f
5648	1935	\N	CAPUCCINO	1.00	2.80	21.00	f
5649	1935	\N	GATEAUX MIEL	1.00	5.00	12.00	f
5650	1935	\N	CREME BRULEE	1.00	5.00	12.00	f
5665	1938	\N	IRISH COFFEE	1.00	8.00	21.00	f
5593	1919	\N	CORNET LARD	1.00	6.00	6.00	t
5594	1919	\N	CORNET BOLO	2.00	6.00	6.00	t
5597	1922	\N	ICE TEA	1.00	2.20	21.00	t
5598	1922	\N	FANTA	1.00	2.20	21.00	t
5599	1922	\N	CHAMPIGNONS KABYLES	2.00	12.00	12.00	t
5612	1925	\N	NOURRITURE	-1.00	-52.63	0.00	t
5615	1928	\N	CORNET BOLO	2.00	6.00	6.00	f
5616	1928	\N	CORNET TRUFFE	3.00	7.00	6.00	f
5617	1928	\N	CORNET LARD	1.00	6.00	6.00	f
5629	1931	\N	SAMBUCA	1.00	5.00	21.00	t
5630	1931	\N	CREPE FLAMBEE GD MARNIER	2.00	8.00	12.00	t
5631	1931	\N	GLACE	1.00	5.00	12.00	t
5632	1931	\N	APPASSIMENTO	1.00	30.00	21.00	t
5633	1931	\N	PROSECCO Bouteille	1.00	25.00	21.00	t
5634	1931	\N	COUSCOUS PM	3.00	17.00	12.00	t
5635	1931	\N	TAJINE	1.00	17.00	12.00	t
5636	1931	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
5639	1934	\N	CAFÉ	1.00	2.50	21.00	f
5640	1934	\N	EAUX 1 L	1.00	5.00	21.00	f
5641	1934	\N	SOFT (Verre)	2.00	2.20	21.00	f
5642	1934	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	f
5643	1934	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
5644	1934	\N	PÂTES BOMBE ATOMIQUE+ BURRATA	1.00	17.00	12.00	f
5654	1937	\N	GLACE	1.00	2.50	12.00	f
5655	1937	\N	ESPRESSO	1.00	2.50	21.00	f
5656	1937	\N	GLACE	1.00	5.00	12.00	f
5657	1937	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
5658	1937	\N	ROSÉ VERRE	2.00	5.00	21.00	f
5659	1937	\N	PINOT GRIGIO BLUSH	1.00	20.00	21.00	f
5660	1937	\N	PROSECCO VERRE	1.00	6.00	21.00	f
5661	1937	\N	Cuba-Li	3.00	6.00	21.00	f
5662	1937	\N	CHAMPIGNONS KABYLES	2.00	8.00	12.00	f
5663	1937	\N	SCAMPIS LUCIFER	2.00	10.00	12.00	f
5664	1937	\N	POLPETTE	4.00	16.00	12.00	f
5680	1940	\N	EAU 1/2 L	1.00	3.50	21.00	f
5681	1940	\N	PINOT GRIGIO BLUSH	1.00	20.00	21.00	f
5682	1940	\N	PECKET FRAISE	1.00	8.00	21.00	f
7232	2468	\N	MAISON ITAL	-1.00	-53.00	0.00	t
7242	2471	\N	CANNELLONI RICO/EPI	1.00	18.00	6.00	f
7249	2474	\N	BLANC VERRE	2.00	5.00	21.00	t
7250	2474	\N	VAL DIEU	3.00	4.00	21.00	t
7255	2477	\N	BLUSH	1.00	5.00	21.00	f
7264	2480	\N	RESTO ALEX	-1.00	-190.00	0.00	t
7269	2483	\N	NOURRITURE	-1.00	-8.00	0.00	t
7273	2486	\N	PÂTES TRUFFE	1.00	15.00	12.00	f
7274	2486	\N	COUSCOUS PM	2.00	17.00	12.00	f
7287	2489	\N	COUSCOUS PM	2.00	17.00	12.00	t
7288	2489	\N	TAJINE	1.00	17.00	12.00	t
7289	2489	\N	BLANC VERRE	1.00	5.00	21.00	t
7290	2489	\N	ROUGE VERRE	3.00	5.00	21.00	t
7291	2489	\N	SOFT (Verre)	1.00	2.20	21.00	t
7292	2489	\N	THÉ MENTHE	1.00	2.50	21.00	t
7293	2489	\N	CAFÉ	1.00	2.50	21.00	t
7299	2492	\N	EAU PET VERRE	1.00	2.20	21.00	t
7300	2492	\N	JUPILER	2.00	2.50	21.00	t
7301	2492	\N	COUSCOUS PM	2.00	17.00	12.00	t
7302	2492	\N	CHAMPIGNONS KABYLES	2.00	10.00	12.00	t
7303	2492	\N	BLONDINETTE	2.00	4.00	21.00	t
7304	2492	\N	PROSECCO VERRE	2.00	6.00	21.00	t
7311	2495	\N	Service Léa	-1.00	-40.00	0.00	t
7314	2498	\N	CARBURANT	-1.00	-107.32	0.00	t
7320	2501	\N	NERO D'AVOLA	1.00	30.00	21.00	f
7321	2501	\N	COCA	1.00	2.20	21.00	f
7322	2501	\N	ROSÉ VERRE	1.00	5.00	21.00	f
7323	2501	\N	BLANC VERRE	1.00	5.00	21.00	f
7324	2501	\N	COUSCOUS PM	2.00	17.00	12.00	f
7327	2504	\N	HACHIS BOLO	-1.00	-11.46	0.00	t
7331	2507	\N	COUSCOUS PM	2.00	17.00	12.00	f
7332	2507	\N	COCA	1.00	2.20	21.00	f
7333	2507	\N	PROSECCO VERRE	2.00	6.00	21.00	f
7340	2510	\N	BLANC VERRE	1.00	5.00	21.00	f
7341	2510	\N	JUPILER	3.00	2.00	21.00	f
7342	2510	\N	ICE TEA	1.00	2.20	21.00	f
7352	2513	\N	IRISH COFFEE	2.00	8.00	21.00	t
7353	2513	\N	COUSCOUS PM	3.00	17.00	12.00	t
7354	2513	\N	PECKET FRAISE	2.00	8.00	21.00	t
7355	2513	\N	BLONDINETTE	3.00	4.00	21.00	t
7356	2513	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
7357	2513	\N	TRIPLE	1.00	4.50	21.00	t
7367	2516	\N	ENERGIES	-1.00	-100.00	0.00	t
7371	2519	\N	PECKET FRAISE	1.00	8.00	21.00	f
7372	2519	\N	COCA	2.00	2.20	21.00	f
7373	2519	\N	VAL DIEU	1.00	4.00	21.00	f
7374	2519	\N	PROSECCO VERRE	2.00	6.00	21.00	f
7377	2522	\N	RHUM	1.00	6.00	21.00	f
7378	2522	\N	PROSECCO VERRE	2.00	6.00	21.00	f
7382	2525	\N	VAL DIEU	1.00	4.00	21.00	f
7383	2525	\N	RHUM	1.00	6.00	21.00	f
7387	2528	\N	COCA ZERO	4.00	2.20	21.00	f
7392	2531	\N	CAFÉ	1.00	2.50	21.00	f
7395	2534	\N	PECKET FRAISE	1.00	8.00	21.00	f
7400	2537	\N	Cuba-Li	1.00	8.00	21.00	f
7401	2537	\N	COCA ZERO	1.00	2.20	21.00	f
7402	2537	\N	ICE TEA	1.00	2.20	21.00	f
7403	2537	\N	BLONDINETTE	4.00	4.00	21.00	f
7404	2537	\N	VAL DIEU	3.00	4.00	21.00	f
7409	2540	\N	PINOT GRIGIO	1.00	20.00	21.00	f
7410	2540	\N	VAL DIEU	4.00	4.00	21.00	f
7411	2540	\N	BLONDINETTE	1.00	4.00	21.00	f
7412	2540	\N	COCA	1.00	2.20	21.00	f
7413	2540	\N	EAU PET VERRE	1.00	2.20	21.00	f
7414	2540	\N	ROUGE VERRE	1.00	5.00	21.00	f
7415	2540	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
7420	2543	\N	PROSECCO Bouteille	3.00	25.00	21.00	f
7429	2546	\N	CAFÉ	1.00	2.50	21.00	f
7430	2546	\N	COCA	2.00	2.20	21.00	f
7431	2546	\N	COCA ZERO	1.00	2.20	21.00	f
7432	2546	\N	PECKET FRAISE	3.00	8.00	21.00	f
7433	2546	\N	RHUM	1.00	6.00	21.00	f
7437	2549	\N	PECKET FRAISE	12.00	10.00	21.00	f
7438	2549	\N	4 FROMAGES	20.00	1.75	6.00	f
7439	2549	\N	CORNET BOLO	30.00	1.75	6.00	f
7440	2549	\N	ASSIETTE APERITIVE (2 p.)	20.00	8.00	6.00	f
7446	2552	\N	CORNET BOLO	1.00	6.00	6.00	f
7455	2555	\N	BLANC VERRE	1.00	5.00	21.00	f
7456	2555	\N	JUPILER	2.00	2.00	21.00	f
7459	2558	\N	ALDI	-1.00	-45.57	0.00	t
7462	2561	\N	CAFÉ	1.00	2.50	21.00	f
7463	2561	\N	PLAT SPÉCIAL	1.00	24.00	12.00	f
7464	2561	\N	PÂTES LARD	1.00	13.00	12.00	f
7465	2561	\N	CHARDONNAY FIO	1.00	20.00	21.00	f
5666	1938	\N	SABAYON SPECIAL	2.00	10.00	12.00	f
5667	1938	\N	GLACE	2.00	5.00	12.00	f
5683	1941	\N	COUSCOUS PM	1.00	17.00	12.00	f
5684	1941	\N	COUSCOUS PM	1.00	17.00	12.00	f
5685	1941	\N	ROUGE VERRE	1.00	5.00	21.00	f
5686	1941	\N	ROSÉ VERRE	1.00	5.00	21.00	f
5687	1941	\N	Cuba-Li	2.00	6.00	21.00	f
5688	1941	\N	VIOLETTE	1.00	8.00	21.00	f
5689	1941	\N	DECA	1.00	2.50	21.00	f
5690	1941	\N	THÉ MENTHE	1.00	2.50	21.00	f
5691	1941	\N	CREME BRULEE	2.00	5.00	12.00	f
7233	2469	\N	PÂTES TRUFFE	1.00	13.00	6.00	t
7243	2472	\N	BLONDINETTE	2.00	4.00	21.00	t
7251	2475	\N	LASAGNE DU BOUCHER	2.00	15.00	12.00	t
7252	2475	\N	RIESLING	2.00	24.00	21.00	t
7256	2478	\N	COUSCOUS PM	2.00	17.00	6.00	f
7265	2481	\N	COCA ZERO	2.00	2.20	21.00	t
7266	2481	\N	CHAMPIGNONS KABYLES	1.00	14.00	12.00	t
7267	2481	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
7270	2484	\N	NOURRITURE	-1.00	-31.38	0.00	t
7275	2487	\N	THÉ MENTHE	1.00	2.50	21.00	f
7276	2487	\N	CAFÉ	1.00	2.50	21.00	f
7277	2487	\N	ESPRESSO	1.00	2.50	21.00	f
7278	2487	\N	CREME BRULEE	3.00	5.00	12.00	f
7279	2487	\N	NERO D'AVOLA	1.00	30.00	21.00	f
7280	2487	\N	CHAKTCHOUKA	1.00	12.00	12.00	f
7281	2487	\N	VIOLETTE	3.00	8.00	21.00	f
7282	2487	\N	COUSCOUS PM	3.00	17.00	12.00	f
7294	2490	\N	JUPILER	1.00	2.00	21.00	f
7295	2490	\N	HOEGAARDEN ROSEE	1.00	2.00	21.00	f
7305	2493	\N	Cuba-Li	1.00	0.00	21.00	f
7306	2493	\N	THÉ MENTHE	1.00	0.00	21.00	f
7307	2493	\N	CREPE KABYLE	1.00	12.00	12.00	f
7308	2493	\N	CANNELLONI VIANDE	1.00	18.00	12.00	f
7309	2493	\N	PINOT GRIGIO	1.00	20.00	21.00	f
7312	2496	\N	CASH ITALIA	-1.00	-7.49	0.00	t
7315	2499	\N	POULET	-1.00	-87.50	0.00	t
7325	2502	\N	INTERMARCHE	-1.00	-28.41	0.00	t
7328	2505	\N	COLRUYT	-1.00	-89.21	0.00	t
7334	2508	\N	BLONDINETTE	1.00	4.00	21.00	f
7335	2508	\N	PÂTES LARD	1.00	13.00	12.00	f
7336	2508	\N	BOMBE ATOMIQUE+ BURRATA	1.00	17.00	12.00	f
7337	2508	\N	FANTA	1.00	2.20	21.00	f
7338	2508	\N	PECKET FRAISE	1.00	8.00	21.00	f
7343	2511	\N	EAU PET VERRE	2.00	0.00	21.00	t
7344	2511	\N	FANTA	2.00	2.20	21.00	t
7345	2511	\N	CANNELLONI RICO/EPI	1.00	18.00	12.00	t
7346	2511	\N	TAJINE	1.00	17.00	12.00	t
7358	2514	\N	COUSCOUS PM	1.00	17.00	12.00	t
7359	2514	\N	BOMBE ATOMIQUE+ BURRATA	1.00	17.00	12.00	t
7360	2514	\N	IRISH COFFEE	1.00	8.00	21.00	t
7361	2514	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
7362	2514	\N	BLANC VERRE	2.00	5.00	21.00	t
7363	2514	\N	PECKET FRAISE	1.00	8.00	21.00	t
7364	2514	\N	TRIPLE	2.00	4.50	21.00	t
7365	2514	\N	BLANC 1/4	1.00	8.00	21.00	t
7368	2517	\N	FORFAIT	25.00	7.00	12.00	t
7369	2517	\N	ASSIETTE APERITIVE (2 p.)	5.00	20.00	12.00	t
7375	2520	\N	RHUM	1.00	6.00	21.00	f
7379	2523	\N	RHUM	1.00	6.00	21.00	f
7380	2523	\N	VAL DIEU	1.00	4.00	21.00	f
7384	2526	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
7388	2529	\N	COCA	1.00	2.20	21.00	f
7393	2532	\N	VAL DIEU	1.00	4.00	21.00	f
7396	2535	\N	PECKET FRAISE	1.00	8.00	21.00	f
7397	2535	\N	ROUGE VERRE	1.00	5.00	21.00	f
7405	2538	\N	BLONDINETTE	1.00	4.00	21.00	f
7416	2541	\N	ROUGE VERRE	1.00	5.00	21.00	f
7417	2541	\N	PECKET FRAISE	1.00	8.00	21.00	f
7421	2544	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
7422	2544	\N	ROUGE VERRE	1.00	5.00	21.00	f
7423	2544	\N	EAU PET VERRE	1.00	2.20	21.00	f
7424	2544	\N	COCA ZERO	1.00	2.20	21.00	f
7425	2544	\N	BLONDINETTE	1.00	4.00	21.00	f
7426	2544	\N	PINOT GRIGIO	1.00	20.00	21.00	f
7427	2544	\N	VAL DIEU	4.00	4.00	21.00	f
7434	2547	\N	PECKET FRAISE	1.00	8.00	21.00	f
7435	2547	\N	BLONDINETTE	1.00	4.00	21.00	f
7441	2550	\N	LOYER	-1.00	-600.00	0.00	t
7447	2553	\N	ROUGE 1/4	1.00	8.00	21.00	f
7448	2553	\N	BLANC VERRE	1.00	5.00	21.00	f
7449	2553	\N	COUSCOUS PM	1.00	17.00	12.00	f
7457	2556	\N	INTERMARCHE	-1.00	-30.08	0.00	t
7460	2559	\N	BOISSONS	-1.00	-170.00	0.00	t
7466	2562	\N	NOURRITURE	-1.00	-9.46	0.00	t
7469	2565	\N	GRAPPA	1.00	0.00	21.00	t
7470	2565	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
7471	2565	\N	CONTRE FILET+GRATIN	1.00	24.00	12.00	t
7472	2565	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
7473	2565	\N	CANNELLONI VIANDE	1.00	18.00	12.00	t
7474	2565	\N	VIOLETTE	1.00	8.00	21.00	t
7475	2565	\N	GINGEMBRE	1.00	10.00	21.00	t
7478	2568	\N	EVRARD	-1.00	-49.61	0.00	t
7490	2571	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
7491	2571	\N	LASAGNE DU BOUCHER	1.00	15.00	12.00	f
7492	2571	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
7493	2571	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
7507	2574	\N	TRUFFE + BURRATA	1.00	17.00	12.00	t
7508	2574	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
7509	2574	\N	CHAKTCHOUKA	1.00	15.00	12.00	t
7533	2577	\N	Service Léa	-1.00	-40.00	0.00	t
7536	2580	\N	NOURRITURE	-1.00	-14.94	0.00	t
7539	2583	\N	CORNET BOLO	1.00	6.00	6.00	t
7540	2583	\N	BLANC VERRE	2.00	5.00	21.00	t
7541	2583	\N	ROSÉ VERRE	1.00	5.00	21.00	t
7546	2586	\N	DEFERLANTE	1.00	4.00	21.00	f
7547	2586	\N	BLANC VERRE	2.00	5.00	21.00	f
7550	2589	\N	NOURRITURE	-1.00	-22.56	0.00	t
7555	2592	\N	Service Marie	-1.00	-36.00	0.00	t
7569	2595	\N	COCA	3.00	2.20	21.00	f
7570	2595	\N	4 FROMAGES	1.00	12.00	6.00	f
7582	2598	\N	TRUFFE + BURRATA	1.00	17.00	12.00	t
7583	2598	\N	PESTO + BURRATA	1.00	15.00	12.00	t
7584	2598	\N	PINOT GRIGIO	1.00	20.00	21.00	t
7589	2601	\N	CARBURANT	-1.00	-106.93	0.00	t
7592	2604	\N	NOURRITURE	-1.00	-5.00	0.00	t
7595	2607	\N	ORANGE	-1.00	-28.00	0.00	t
7608	2610	\N	BOISSONS	-1.00	-206.00	0.00	t
7611	2613	\N	NOURRITURE	-1.00	-56.86	0.00	t
7615	2616	\N	CAFÉ	1.00	2.50	21.00	f
5670	1939	\N	ROSÉ VERRE	2.00	5.00	21.00	t
5671	1939	\N	VIN 1/2	1.00	20.00	21.00	t
5672	1939	\N	AMARONE	1.00	50.00	21.00	t
5673	1939	\N	Cuba-Li	2.00	6.00	21.00	t
5674	1939	\N	JUPILER	1.00	2.50	21.00	t
5675	1939	\N	PECKET FRAISE	6.00	8.00	21.00	t
5676	1939	\N	CREPE CHAKCHOUKA XXL	1.00	18.00	6.00	t
5677	1939	\N	CREPE GORGONZOLA + COURG.	1.00	14.00	12.00	t
5678	1939	\N	CREPE CREME LARD XXL	1.00	16.00	6.00	t
5679	1939	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
5692	1942	\N	ROUGE VERRE	1.00	5.00	21.00	t
5693	1942	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	t
5694	1942	\N	COUSCOUS PM	1.00	17.00	12.00	t
5695	1942	\N	ORVAL	1.00	5.00	21.00	t
5696	1943	\N	COUSCOUS PM	1.00	17.00	12.00	f
5697	1943	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	f
5698	1943	\N	TRIPLE SAINTE NITOUCHE	1.00	4.50	21.00	f
5699	1943	\N	ROUGE VERRE	1.00	5.00	21.00	f
5700	1944	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	t
5701	1944	\N	PÂTES BOLO	1.00	13.00	12.00	t
5702	1944	\N	TRIPLE SAINTE NITOUCHE	1.00	4.50	21.00	t
5703	1945	\N	THÉ MENTHE	2.00	2.50	21.00	f
5704	1945	\N	CREPE SAUCE DE BASE + BURRATA	1.00	12.00	12.00	f
5705	1945	\N	COUSCOUS PM	1.00	17.00	12.00	f
5706	1945	\N	PROSECCO VERRE	1.00	6.00	21.00	f
5707	1945	\N	PECKET FRAISE	1.00	8.00	21.00	f
5708	1946	\N	BLANC VERRE	1.00	5.00	21.00	f
5709	1946	\N	ROUGE VERRE	1.00	5.00	21.00	f
5710	1946	\N	CREPE CREME LARD	1.00	12.00	12.00	f
5711	1947	\N	CORNET TRUFFE	3.00	7.00	6.00	f
5712	1948	\N	AMARETTO	2.00	5.00	21.00	t
5713	1948	\N	CAFÉ	1.00	2.50	21.00	t
5714	1948	\N	DECA	1.00	2.50	21.00	t
5715	1948	\N	SABAYON	2.00	8.00	12.00	t
5716	1948	\N	PÂTES LARD	1.00	13.00	12.00	t
5717	1948	\N	PÂTES BOLO	1.00	13.00	12.00	t
5718	1948	\N	CREPE CREME LARD	1.00	12.00	12.00	t
5719	1948	\N	APPASSIMENTO	1.00	30.00	21.00	t
5720	1948	\N	BLANC VERRE	4.00	5.00	21.00	t
5721	1949	\N	JUPILER	4.00	2.00	21.00	f
5722	1950	\N	ENERGIES	-1.00	-219.75	0.00	t
5723	1951	\N	DECA	1.00	2.50	21.00	t
5724	1951	\N	CAFÉ	1.00	2.50	21.00	t
5725	1951	\N	ROUGE VERRE	3.00	5.00	21.00	t
5726	1951	\N	BLANC VERRE	1.00	5.00	21.00	t
5727	1951	\N	PÂTES BOLO	2.00	13.00	12.00	t
5728	1952	\N	TRIPLE SAINTE NITOUCHE	2.00	4.50	21.00	t
5729	1953	\N	COCA ZERO	3.00	2.20	21.00	t
5730	1953	\N	CAFÉ	1.00	2.50	21.00	t
5731	1953	\N	ESPRESSO	1.00	2.50	21.00	t
5732	1953	\N	VIN 1/2	1.00	20.00	21.00	t
5733	1953	\N	COUSCOUS PM	2.00	17.00	12.00	t
5734	1954	\N	ROUGE VERRE	2.00	5.00	21.00	t
5735	1954	\N	PROSECCO VERRE	1.00	6.00	21.00	t
5736	1954	\N	COUSCOUS PM	1.00	17.00	12.00	t
5737	1955	\N	NOURRITURE	-1.00	-115.64	0.00	t
5738	1956	\N	NOURRITURE	-1.00	-22.26	0.00	t
5739	1957	\N	PHARE BMW	-1.00	-140.00	0.00	t
5740	1958	\N	Service Véro	-1.00	-60.00	0.00	t
5741	1959	\N	Service Caro	-1.00	-30.00	0.00	t
5742	1960	\N	ESPRESSO	1.00	2.50	21.00	t
5743	1960	\N	EAUX 1 L	1.00	5.00	21.00	t
5744	1960	\N	COUSCOUS VG	1.00	10.00	12.00	t
5745	1960	\N	PÂTES BOMBE ATOMIQUE+ BURRATA	1.00	17.00	12.00	t
5746	1961	\N	CYNAR	1.00	5.00	21.00	f
5747	1961	\N	PROSECCO VERRE	2.00	6.00	21.00	f
5748	1961	\N	JUPILER	3.00	2.50	21.00	f
5749	1961	\N	TRIPLE SAINTE NITOUCHE	1.00	4.50	21.00	f
5750	1962	\N	SOFT (Verre)	1.00	2.20	21.00	t
5751	1962	\N	JUPILER	1.00	2.50	21.00	t
5752	1962	\N	DECA	2.00	2.50	21.00	t
5753	1962	\N	CYNAR	1.00	5.00	21.00	t
5754	1962	\N	LIMONCELLO	1.00	5.00	21.00	t
5755	1963	\N	GIN 0%	1.00	8.00	21.00	t
5756	1963	\N	CAFÉ	1.00	2.50	21.00	t
5757	1963	\N	JUPILER	2.00	2.50	21.00	t
5758	1964	\N	CORNET BOLO	2.00	6.00	6.00	t
5759	1964	\N	CORNET LARD	1.00	6.00	6.00	t
5760	1965	\N	THÉ MENTHE	2.00	2.50	21.00	t
5761	1965	\N	CREME BRULEE	1.00	5.00	12.00	t
5762	1965	\N	TAJINE	2.00	17.00	12.00	t
5763	1965	\N	COCA	1.00	2.20	21.00	t
5764	1966	\N	TRAFIC	-1.00	-57.20	0.00	t
5765	1967	\N	NOURRITURE	-1.00	-10.07	0.00	t
5766	1968	\N	CREME BRULEE	1.00	5.00	12.00	t
5767	1968	\N	ROUGE VERRE	3.00	5.00	21.00	t
5768	1968	\N	SPAG.COURGETTE + SCAMPIS+BURRATA	1.00	22.00	12.00	t
5769	1969	\N	GATEAUX MIEL	2.00	5.00	12.00	t
5770	1969	\N	APPASSIMENTO	1.00	30.00	21.00	t
5771	1969	\N	COUSCOUS PM	2.00	17.00	12.00	t
5772	1970	\N	FANTA	2.00	2.20	21.00	t
5773	1970	\N	COUSCOUS PM	1.00	17.00	12.00	t
5774	1970	\N	TAJINE	1.00	17.00	12.00	t
5775	1971	\N	Service Caro	-1.00	-50.00	0.00	t
5776	1972	\N	BOISSONS	-1.00	-233.40	0.00	t
5777	1973	\N	BOISSONS	-1.00	-165.29	0.00	t
5778	1974	\N	COUSCOUS PM	1.00	17.00	6.00	f
5779	1975	\N	NOURRITURE	-1.00	-25.25	0.00	t
5780	1976	\N	GATEAUX MIEL	2.00	5.00	12.00	t
5781	1976	\N	CREME BRULEE	1.00	5.00	12.00	t
5782	1976	\N	SABAYON SPECIAL	1.00	10.00	12.00	t
5783	1976	\N	COCA ZERO	1.00	2.20	21.00	t
5784	1976	\N	EAU 1/2 L	1.00	3.50	21.00	t
5785	1976	\N	PROSECCO VERRE	1.00	6.00	21.00	t
5786	1976	\N	VIOLETTE	1.00	8.00	21.00	t
5787	1976	\N	FANTA	1.00	2.20	21.00	t
5788	1976	\N	ICE TEA	1.00	2.20	21.00	t
5789	1976	\N	PROSECCO VERRE	1.00	6.00	21.00	t
5790	1976	\N	PLAT SPÉCIAL	1.00	18.00	12.00	t
5791	1976	\N	CREPE KABYLE	2.00	12.00	12.00	t
5792	1976	\N	CREPE CREME LARD	1.00	12.00	12.00	t
5793	1977	\N	ROUGE VERRE	2.00	5.00	21.00	t
5794	1977	\N	COUSCOUS PM	2.00	17.00	12.00	t
5795	1977	\N	VIOLETTE	1.00	8.00	21.00	t
5796	1977	\N	GINGEMBRE	1.00	8.00	21.00	t
5797	1978	\N	COCA ZERO	1.00	2.20	21.00	f
5798	1978	\N	FANTA	2.00	2.20	21.00	f
5799	1978	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
5800	1978	\N	TAJINE	1.00	17.00	12.00	f
5801	1978	\N	COUSCOUS PM	2.00	17.00	12.00	f
5802	1978	\N	PROSECCO VERRE	1.00	6.00	21.00	f
5803	1978	\N	FANTA	2.00	2.20	21.00	f
5804	1978	\N	GLACE	1.00	5.00	12.00	f
5816	1981	\N	SABAYON SPECIAL	1.00	10.00	12.00	t
5817	1981	\N	TRIPLE SAINTE NITOUCHE	2.00	4.50	21.00	t
5818	1981	\N	TRIPLE SAINTE NITOUCHE	1.00	4.50	21.00	t
5819	1981	\N	CREPE FLAMBEE GD MARNIER	1.00	6.00	12.00	t
5820	1981	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	t
5821	1981	\N	ROUGE VERRE	1.00	5.00	21.00	t
5822	1981	\N	ROUGE VERRE	1.00	5.00	21.00	t
5823	1981	\N	TRIPLE SAINTE NITOUCHE	1.00	4.50	21.00	t
5824	1981	\N	ORVAL	1.00	5.00	21.00	t
5825	1981	\N	PECKET FRAISE	2.00	8.00	21.00	t
5826	1981	\N	PÂTES PESTO	1.00	14.00	12.00	t
5827	1981	\N	PÂTES STRACIATELLA SCAMPIS	2.00	17.00	12.00	t
5828	1981	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	t
5829	1981	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
5830	1981	\N	TCHAKTCHOUKA	1.00	10.00	12.00	t
5831	1981	\N	CANNELLONI RICO/EPI	1.00	18.00	12.00	t
5842	1984	\N	Service Véro	-1.00	-40.00	0.00	t
5848	1987	\N	NOURRITURE	-1.00	-6.45	0.00	t
5851	1990	\N	POLPETTE	1.00	16.00	12.00	t
5852	1990	\N	TAJINE	1.00	17.00	12.00	t
5853	1990	\N	PINOT GRIGIO BLUSH	1.00	8.00	21.00	t
5854	1990	\N	PECKET FRAISE	1.00	8.00	21.00	t
5858	1993	\N	CORNET BOLO	1.00	6.00	6.00	f
5865	1996	\N	CREME BRULEE	2.00	5.00	6.00	f
5868	1999	\N	CARBURANT	-1.00	-85.64	0.00	t
5871	2002	\N	AG ASSURANCE	-1.00	-166.36	0.00	t
5879	2005	\N	CANNELLONI RICO/EPI	1.00	18.00	12.00	t
5880	2005	\N	PÂTES BOMBE ATOMIQUE+ BURRATA	1.00	17.00	12.00	t
5881	2005	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	t
5882	2005	\N	GINGEMBRE	1.00	8.00	21.00	t
5883	2005	\N	VIOLETTE	1.00	8.00	21.00	t
5886	2008	\N	PLAT SPÉCIAL	1.00	14.00	12.00	f
5887	2008	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	f
5888	2008	\N	COCA	2.00	2.20	21.00	f
5889	2008	\N	PINOT GRIGIO BLUSH	1.00	19.60	21.00	f
5893	2011	\N	Service Véro	-1.00	-50.00	0.00	t
5896	2014	\N	NOURRITURE	-1.00	-28.40	0.00	t
5901	2017	\N	Service Véro	-1.00	-50.00	0.00	t
5905	2020	\N	COUSCOUS VG	1.00	10.00	12.00	f
5906	2020	\N	COUSCOUS PM	1.00	17.00	12.00	f
5907	2020	\N	BIERLAINOISE	2.00	4.00	6.00	f
5925	2023	\N	NOURRITURE	-1.00	-26.84	0.00	t
5935	2026	\N	NOURRITURE	-1.00	-27.25	0.00	t
5938	2029	\N	Service Célia	-1.00	-30.00	0.00	t
5941	2032	\N	CORNET BOLO	1.00	6.00	6.00	t
5948	2035	\N	CORNET LARD	1.00	6.00	6.00	f
5951	2038	\N	NOURRITURE	-1.00	-28.95	0.00	t
5954	2041	\N	PINOT BLANC	2.00	20.00	21.00	t
5960	2044	\N	ESPRESSO	2.00	2.50	21.00	t
5961	2044	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	t
5962	2044	\N	JUPILER	1.00	2.50	21.00	t
5963	2044	\N	PÂTES LARD	3.00	13.00	12.00	t
5964	2044	\N	BLANC VERRE	2.00	4.00	21.00	t
5972	2047	\N	ROSÉ VERRE	1.00	5.00	21.00	f
5973	2047	\N	ICE TEA	1.00	2.20	21.00	f
5974	2047	\N	TAJINE	1.00	17.00	12.00	f
5975	2047	\N	COUSCOUS PM	1.00	17.00	12.00	f
5998	2050	\N	SABAYON SPECIAL	1.00	10.00	12.00	t
5999	2050	\N	CREME BRULEE	1.00	5.00	12.00	t
6000	2050	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
6001	2050	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
6002	2050	\N	BLANC VERRE	2.00	5.00	21.00	t
6003	2050	\N	GIN 0%	1.00	8.00	21.00	t
6017	2053	\N	Service Elise	-1.00	-85.00	0.00	t
6020	2056	\N	CARBURANT	-1.00	-98.98	0.00	t
6023	2059	\N	ORANGE	-1.00	-28.00	0.00	t
6026	2062	\N	CARBURANT	-1.00	-89.47	0.00	t
6029	2065	\N	BOISSONS	-1.00	-72.00	0.00	t
6032	2068	\N	TRAFIC	-1.00	-9.98	0.00	t
6035	2071	\N	CREPE GORGONZOLA + COURG.	1.00	14.00	12.00	f
6036	2071	\N	CANNELLONI RICO/EPI	1.00	18.00	12.00	f
6037	2071	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	f
6038	2071	\N	PINOT GRIGIO BLUSH	1.00	20.00	21.00	f
6041	2074	\N	CAFÉ	1.00	2.50	21.00	t
6042	2074	\N	BLANC VERRE	2.00	5.00	21.00	t
6043	2074	\N	CYNAR	4.00	5.00	21.00	t
6044	2074	\N	TRIPLE SAINTE NITOUCHE	2.00	4.50	21.00	t
6045	2074	\N	JUPILER	2.00	2.50	21.00	t
6046	2074	\N	GIN 0%	1.00	8.00	21.00	t
6055	2077	\N	COUSCOUS PM	2.00	17.00	12.00	f
6060	2080	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
6061	2080	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	t
6062	2080	\N	TCHAKTCHOUKA	1.00	10.00	12.00	t
6063	2080	\N	CREPE GORGONZOLA + COURG.	1.00	14.00	12.00	t
6064	2080	\N	BURRATA PESTO	1.00	15.00	12.00	t
6077	2083	\N	NOURRITURE	-1.00	-9.87	0.00	t
6080	2086	\N	Service Caro	-1.00	-50.00	0.00	t
6091	2089	\N	Service Caro	-1.00	-50.00	0.00	t
6115	2092	\N	CAFÉ	1.00	2.50	21.00	t
6116	2092	\N	COCA	1.00	2.20	21.00	t
6119	2095	\N	JUPILER	2.00	2.00	21.00	t
6122	2098	\N	SABAYON SPECIAL	2.00	10.00	12.00	f
6123	2098	\N	TAJINE	2.00	17.00	12.00	f
6124	2098	\N	SCAMPIS LUCIFER	2.00	10.00	12.00	f
6125	2098	\N	GINGEMBRE	1.00	8.00	21.00	f
6128	2101	\N	FANTA	2.00	2.00	21.00	f
6129	2101	\N	BLONDINETTE	2.00	4.00	21.00	f
6135	2104	\N	BLONDINETTE	1.00	4.00	21.00	t
6136	2104	\N	TRIPLE SAINTE NITOUCHE	1.00	4.50	21.00	t
6137	2104	\N	TRIPLE SAINTE NITOUCHE	5.00	4.50	21.00	t
6138	2104	\N	BLONDINETTE	2.00	4.00	21.00	t
6139	2104	\N	TRIPLE SAINTE NITOUCHE	5.00	4.50	21.00	t
6140	2104	\N	BLONDINETTE	2.00	4.00	21.00	t
6141	2104	\N	TRIPLE SAINTE NITOUCHE	3.00	4.50	21.00	t
6142	2104	\N	BLONDINETTE	2.00	4.00	21.00	t
6143	2104	\N	BLANC VERRE	1.00	5.00	21.00	t
6144	2104	\N	VIOLETTE	2.00	8.00	21.00	t
6145	2104	\N	BLONDINETTE	5.00	4.00	21.00	t
6146	2104	\N	TRIPLE SAINTE NITOUCHE	12.00	4.50	21.00	t
6155	2107	\N	NOURRITURE	-1.00	-4.28	0.00	t
6159	2110	\N	COUSCOUS PM	2.00	17.00	12.00	f
6170	2113	\N	Service Caro	-1.00	-50.00	0.00	t
6173	2116	\N	VIN 1/2	1.00	20.00	21.00	f
5805	1979	\N	VIOLETTE	1.00	8.00	21.00	t
5806	1979	\N	COCA ZERO	1.00	2.20	21.00	t
5807	1979	\N	TAJINE	1.00	17.00	12.00	t
5808	1979	\N	CANNELLONI RICO/EPI	1.00	18.00	12.00	t
5809	1979	\N	ESPRESSO	2.00	2.50	21.00	t
5832	1982	\N	ROUGE VERRE	2.00	5.00	21.00	t
5833	1982	\N	BLANC VERRE	1.00	5.00	21.00	t
5834	1982	\N	BLANC VERRE	2.00	5.00	21.00	t
5835	1982	\N	TAJINE	1.00	17.00	12.00	t
5836	1982	\N	CANNELLONI RICO/EPI	1.00	18.00	12.00	t
5837	1982	\N	PÂTES TRUFFE	1.00	15.00	12.00	t
5838	1982	\N	EAUX 1 L	1.00	5.00	21.00	t
5839	1982	\N	BLANC VERRE	2.00	5.00	21.00	t
5840	1982	\N	ESPRESSO	1.00	2.50	21.00	t
5843	1985	\N	ENERGIES	-1.00	-243.38	0.00	t
5849	1988	\N	NOURRITURE	-1.00	-13.60	0.00	t
5855	1991	\N	CORNET BOLO	2.00	6.00	6.00	f
5859	1994	\N	EAU 1/2 L	1.00	3.50	21.00	f
5860	1994	\N	CREPE GORGONZOLA + COURG.	1.00	14.00	12.00	f
5861	1994	\N	COUSCOUS VG	1.00	10.00	12.00	f
5862	1994	\N	BIERLAINOISE	1.00	4.00	6.00	f
5863	1994	\N	GINGEMBRE	1.00	8.00	21.00	f
5866	1997	\N	AFSCA	-1.00	-207.05	0.00	t
5869	2000	\N	AUTOSECURITE	-1.00	-15.60	0.00	t
5872	2003	\N	GLACE	2.00	5.00	12.00	t
5873	2003	\N	ESPRESSO	2.00	2.50	21.00	t
5874	2003	\N	ICE TEA	1.00	2.20	21.00	t
5875	2003	\N	COCA ZERO	2.00	2.20	21.00	t
5876	2003	\N	PLAT SPÉCIAL	1.00	18.00	12.00	t
5877	2003	\N	CREPE KABYLE	2.00	12.00	12.00	t
5884	2006	\N	Service Caro	-1.00	-30.00	0.00	t
5890	2009	\N	JUPILER	2.00	2.00	21.00	f
5891	2009	\N	CORNET BOLO	1.00	6.00	6.00	f
5894	2012	\N	ALBINETE	-1.00	-42.00	0.00	t
5897	2015	\N	GINGEMBRE	1.00	8.00	21.00	f
5898	2015	\N	Cuba-Li	3.00	8.00	21.00	f
5899	2015	\N	Cuba-Li	6.00	8.00	21.00	f
5902	2018	\N	RESTO BASKET	-1.00	-60.00	0.00	t
5908	2021	\N	CAFÉ	1.00	2.50	21.00	t
5909	2021	\N	CAPUCCINO	1.00	2.80	21.00	t
5910	2021	\N	CREPE CREME LARD	1.00	12.00	12.00	t
5911	2021	\N	CREPE KABYLE	1.00	12.00	12.00	t
5912	2021	\N	ICE TEA	2.00	2.20	21.00	t
5926	2024	\N	GIN 0%	3.00	8.00	21.00	f
5927	2024	\N	TAJINE	1.00	17.00	12.00	f
5928	2024	\N	COUSCOUS PM	2.00	17.00	12.00	f
5929	2024	\N	SCAMPIS LUCIFER	1.00	10.00	12.00	f
5930	2024	\N	CHAMPIGNONS KABYLES	2.00	8.00	12.00	f
5931	2024	\N	PECKET FRAISE	1.00	8.00	21.00	f
5932	2024	\N	ROSÉ VERRE	1.00	5.00	21.00	f
5933	2024	\N	COCA ZERO	1.00	2.20	21.00	f
5936	2027	\N	NOURRITURE	-1.00	-124.81	0.00	t
5939	2030	\N	CORNET LARD	2.00	6.00	6.00	t
5942	2033	\N	CREPE GORGONZOLA + COURG.	1.00	14.00	12.00	t
5943	2033	\N	ICE TEA	1.00	2.20	21.00	t
5949	2036	\N	POULET	-1.00	-87.50	0.00	t
5952	2039	\N	COUSCOUS PM	1.00	17.00	6.00	f
5955	2042	\N	COCA	2.00	2.20	21.00	f
5956	2042	\N	PROSECCO VERRE	2.00	6.00	21.00	f
5957	2042	\N	PÂTES TRUFFE	1.00	15.00	12.00	f
5958	2042	\N	PÂTES PESTO	1.00	14.00	12.00	f
5965	2045	\N	JUPILER	2.00	2.50	21.00	t
5966	2045	\N	TRIPLE SAINTE NITOUCHE	2.00	4.50	21.00	t
5967	2045	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
5968	2045	\N	PÂTES BOLO	1.00	13.00	12.00	t
5976	2048	\N	COCA ZERO	2.00	2.20	21.00	t
5977	2048	\N	PÂTES TRUFFE + BURRATA	2.00	17.00	12.00	t
5978	2048	\N	CHAMPIGNONS KABYLES	2.00	8.00	12.00	t
5979	2048	\N	VIOLETTE	1.00	8.00	21.00	t
5980	2048	\N	PROSECCO VERRE	1.00	6.00	21.00	t
5981	2048	\N	SABAYON	1.00	8.00	12.00	t
5982	2048	\N	THÉ MENTHE	2.00	2.50	21.00	t
5983	2048	\N	GLACE	1.00	5.00	12.00	t
6004	2051	\N	THÉ MENTHE	2.00	2.50	21.00	t
6005	2051	\N	CREME BRULEE	1.00	5.00	12.00	t
6006	2051	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
6007	2051	\N	TRIPLE SAINTE NITOUCHE	1.00	4.50	21.00	t
6008	2051	\N	GIN TONIC	1.00	6.00	21.00	t
6009	2051	\N	COUSCOUS PM	1.00	17.00	12.00	t
6010	2051	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
6018	2054	\N	ENERGIES	-1.00	-219.75	0.00	t
6021	2057	\N	COMPTABLE	-1.00	-211.75	0.00	t
6024	2060	\N	PAUL K	-1.00	-203.47	0.00	t
6027	2063	\N	AMAZON	-1.00	-27.93	0.00	t
6030	2066	\N	NOURRITURE	-1.00	-121.96	0.00	t
6033	2069	\N	NOURRITURE	-1.00	-23.58	0.00	t
6039	2072	\N	CORNET TRUFFE	1.00	7.00	6.00	t
6047	2075	\N	DECA	1.00	2.50	21.00	f
6048	2075	\N	CAFÉ	2.00	2.50	21.00	f
6049	2075	\N	CYNAR	1.00	5.00	21.00	f
6056	2078	\N	ROSÉ VERRE	1.00	5.00	21.00	f
6057	2078	\N	GIN TONIC	1.00	6.00	21.00	f
6058	2078	\N	PROSECCO VERRE	1.00	6.00	21.00	f
6065	2081	\N	EAU PETILLANTE	1.00	2.20	21.00	f
6066	2081	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	f
6067	2081	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
6068	2081	\N	COCA	1.00	2.20	21.00	f
6069	2081	\N	BULLES 0%	2.00	6.00	21.00	f
6078	2084	\N	CARBURANT	-1.00	-104.94	0.00	t
6081	2087	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
6082	2087	\N	PROSECCO VERRE	1.00	6.00	21.00	t
6083	2087	\N	POTEE AL D'JOTE	1.00	18.00	12.00	t
6084	2087	\N	COUSCOUS PM	1.00	17.00	12.00	t
6085	2087	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
6092	2090	\N	TRIPLE SAINTE NITOUCHE	2.00	4.50	21.00	t
6093	2090	\N	CANNELLONI RICO/EPI	1.00	18.00	12.00	t
6094	2090	\N	BURRATA PESTO	1.00	15.00	12.00	t
6095	2090	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
6096	2090	\N	PÂTES BOLO	1.00	13.00	12.00	t
6097	2090	\N	TAJINE	2.00	17.00	12.00	t
6098	2090	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
6099	2090	\N	PÂTES LARD	1.00	13.00	12.00	t
6100	2090	\N	COUSCOUS PM	1.00	17.00	12.00	t
6101	2090	\N	TAJINE	1.00	17.00	12.00	t
6102	2090	\N	SPAG.COURGETTE	1.00	14.00	12.00	t
6103	2090	\N	POTEE AL D'JOTE	1.00	18.00	12.00	t
6104	2090	\N	PÂTES LARD	3.00	13.00	12.00	t
6105	2090	\N	PÂTES BOLO	1.00	13.00	12.00	t
6106	2090	\N	DECA	1.00	2.50	21.00	t
5810	1980	\N	THÉ MENTHE	1.00	2.50	21.00	t
5811	1980	\N	VIOLETTE	1.00	8.00	21.00	t
5812	1980	\N	COCA ZERO	1.00	2.20	21.00	t
5813	1980	\N	TAJINE	1.00	17.00	12.00	t
5814	1980	\N	CANNELLONI RICO/EPI	1.00	18.00	12.00	t
5815	1980	\N	ESPRESSO	2.00	2.50	21.00	t
5841	1983	\N	Service Victor	-1.00	-50.00	0.00	t
5844	1986	\N	CREME BRULEE	2.00	5.00	6.00	t
5845	1986	\N	POLPETTE	1.00	16.00	6.00	t
5846	1986	\N	COUSCOUS PM	1.00	17.00	6.00	t
5847	1986	\N	TCHAKTCHOUKA	2.00	10.00	6.00	t
5850	1989	\N	NOURRITURE	-1.00	-36.68	0.00	t
5856	1992	\N	PÂTES BOLO	1.00	13.00	12.00	t
5857	1992	\N	PROSECCO VERRE	2.00	6.00	21.00	t
5864	1995	\N	LOYER	-1.00	-600.00	0.00	t
5867	1998	\N	CARBURANT	-1.00	-92.49	0.00	t
5870	2001	\N	CARBURANT	-1.00	-88.40	0.00	t
5878	2004	\N	BOISSONS	-1.00	-118.33	0.00	t
5885	2007	\N	COOKEO Véro	-1.00	-100.00	0.00	t
5892	2010	\N	Service Caro	-1.00	-50.00	0.00	t
5895	2013	\N	CORA	-1.00	-61.16	0.00	t
5900	2016	\N	Service Elise	-1.00	-50.00	0.00	t
5903	2019	\N	CORNET BOLO	1.00	6.00	6.00	f
5904	2019	\N	CORNET LARD	1.00	6.00	6.00	f
5913	2022	\N	JUPILER	1.00	2.50	21.00	t
5914	2022	\N	TRIPLE SAINTE NITOUCHE	3.00	4.50	21.00	t
5915	2022	\N	COCA	1.00	2.20	21.00	t
5916	2022	\N	ICE TEA	1.00	2.20	21.00	t
5917	2022	\N	BLANC VERRE	2.00	5.00	21.00	t
5918	2022	\N	PROSECCO VERRE	1.00	6.00	21.00	t
5919	2022	\N	ROUGE VERRE	1.00	5.00	21.00	t
5920	2022	\N	JUPILER	2.00	2.50	21.00	t
5921	2022	\N	SPAG.COURGETTE + SCAMPIS+BURRATA	1.00	22.00	12.00	t
5922	2022	\N	PÂTES BOMBE ATOMIQUE+ BURRATA	2.00	17.00	12.00	t
5923	2022	\N	COUSCOUS PM	3.00	17.00	12.00	t
5924	2022	\N	PÂTES LARD	2.00	13.00	12.00	t
5934	2025	\N	JUPILER	2.00	2.00	21.00	f
5937	2028	\N	MERGUEZ	-1.00	-28.45	0.00	t
5940	2031	\N	CORNET LARD	1.00	6.00	6.00	t
5944	2034	\N	JUPILER	1.00	2.50	21.00	f
5945	2034	\N	ICE TEA	2.00	2.20	21.00	f
5946	2034	\N	PÂTES LARD	1.00	13.00	12.00	f
5947	2034	\N	CREPE SAUCE DE BASE + BURRATA	1.00	12.00	12.00	f
5950	2037	\N	NOURRITURE	-1.00	-21.65	0.00	t
5953	2040	\N	TRAFIC	-1.00	-32.78	0.00	t
5959	2043	\N	Service Caro	-1.00	-40.00	0.00	t
5969	2046	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
5970	2046	\N	TRIPLE SAINTE NITOUCHE	1.00	4.50	21.00	t
5971	2046	\N	PROSECCO VERRE	1.00	6.00	21.00	t
5984	2049	\N	AMARETTO	1.00	5.00	21.00	t
5985	2049	\N	GRAPPA	1.00	5.00	21.00	t
5986	2049	\N	APPASSIMENTO	2.00	30.00	21.00	t
5987	2049	\N	POTEE AL D'JOTE	5.00	18.00	12.00	t
5988	2049	\N	TAJINE	1.00	17.00	12.00	t
5989	2049	\N	GIN 0%	1.00	8.00	21.00	t
5990	2049	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	t
5991	2049	\N	BULLES 0%	1.00	6.00	21.00	t
5992	2049	\N	EAU 1/2 L	1.00	3.50	21.00	t
5993	2049	\N	SABAYON SPECIAL	2.00	10.00	12.00	t
5994	2049	\N	Cuba-Li	1.00	8.00	21.00	t
5995	2049	\N	ESPRESSO	1.00	2.50	21.00	t
5996	2049	\N	CAFÉ	2.00	2.50	21.00	t
5997	2049	\N	DECA	1.00	2.50	21.00	t
6011	2052	\N	COUSCOUS PM	1.00	17.00	12.00	t
6012	2052	\N	PÂTES TRUFFE + BURRATA	2.00	17.00	12.00	t
6013	2052	\N	SCAMPIS LUCIFER	3.00	10.00	12.00	t
6014	2052	\N	BULLES 0%	1.00	6.00	21.00	t
6015	2052	\N	GIN 0%	2.00	8.00	21.00	t
6016	2052	\N	Cuba-Li	4.00	8.00	21.00	t
6019	2055	\N	SODEXO	-1.00	-30.00	0.00	t
6022	2058	\N	SODEXO	-1.00	-30.00	0.00	t
6025	2061	\N	CADEAU PAULINE	-1.00	-39.95	0.00	t
6028	2064	\N	NOURRITURE	-1.00	-75.25	0.00	t
6031	2067	\N	ROBINET	-1.00	-20.00	0.00	t
6034	2070	\N	CREME BRULEE	4.00	5.00	6.00	f
6040	2073	\N	CREME BRULEE	1.00	5.00	6.00	t
6050	2076	\N	POLPETTE	1.00	16.00	12.00	f
6051	2076	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	f
6052	2076	\N	ROSÉ VERRE	1.00	5.00	21.00	f
6053	2076	\N	PECKET FRAISE	2.00	8.00	21.00	f
6054	2076	\N	PINOT GRIGIO BLUSH	3.00	20.00	21.00	f
6059	2079	\N	NOURRITURE	-1.00	-23.22	0.00	t
6070	2082	\N	ESPRESSO	1.00	2.50	21.00	f
6071	2082	\N	DECA	1.00	2.50	21.00	f
6072	2082	\N	JUPILER	1.00	2.50	21.00	f
6073	2082	\N	BLANC VERRE	2.00	5.00	21.00	f
6074	2082	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	t
6075	2082	\N	COUSCOUS PM	1.00	17.00	12.00	t
6076	2082	\N	SCAMPIS LUCIFER	1.00	0.00	12.00	f
6079	2085	\N	ENERGIES	-1.00	-243.38	0.00	t
6086	2088	\N	GINGEMBRE	1.00	8.00	21.00	t
6087	2088	\N	PECKET FRAISE	1.00	8.00	21.00	t
6088	2088	\N	POTEE AL D'JOTE	1.00	18.00	12.00	t
6089	2088	\N	CREPE GORGONZOLA + COURG.	1.00	14.00	12.00	t
6090	2088	\N	TCHAKTCHOUKA	1.00	10.00	12.00	t
6110	2091	\N	COUSCOUS PM	2.00	17.00	12.00	t
6111	2091	\N	PECKET FRAISE	1.00	8.00	21.00	t
6112	2091	\N	MANDURIA	2.00	30.00	21.00	t
6113	2091	\N	CYNAR	1.00	5.00	21.00	t
6114	2091	\N	COCA	1.00	2.20	21.00	t
6118	2094	\N	LOYER	-1.00	-600.00	0.00	t
6121	2097	\N	NOURRITURE	-1.00	-24.31	0.00	t
6127	2100	\N	NOURRITURE	-1.00	-102.31	0.00	t
6132	2103	\N	SOFT (Verre)	1.00	2.20	21.00	t
6133	2103	\N	BLANC VERRE	2.00	5.00	21.00	t
6134	2103	\N	CYNAR	2.00	5.00	21.00	t
6154	2106	\N	NOURRITURE	-1.00	-27.00	0.00	t
6157	2109	\N	HUILE GUGLIELMI	1.00	10.00	6.00	f
6158	2109	\N	HUILE ESPEJO	1.00	20.00	6.00	f
6163	2112	\N	CAFÉ	1.00	2.50	21.00	t
6164	2112	\N	THÉ MENTHE	1.00	2.50	21.00	t
6165	2112	\N	COCA	1.00	2.20	21.00	t
6166	2112	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	t
6167	2112	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
6168	2112	\N	COUSCOUS PM	2.00	17.00	12.00	t
6169	2112	\N	TAJINE	1.00	17.00	12.00	t
6172	2115	\N	EQUIPEMENT	-1.00	-46.22	0.00	t
6181	2118	\N	JUPILER	2.00	2.00	21.00	f
6182	2118	\N	BURRATA PESTO	1.00	15.00	12.00	t
6193	2121	\N	POTEE AL D'JOTE	3.00	18.00	6.00	f
6107	2090	\N	CAFÉ	4.00	2.50	21.00	t
6108	2090	\N	PRIMITIVO NR 14	3.00	24.00	21.00	t
6109	2090	\N	COCA ZERO	3.00	2.20	21.00	t
6117	2093	\N	BOISSONS	-1.00	-132.00	0.00	t
6120	2096	\N	NOURRITURE	-1.00	-8.00	0.00	t
6126	2099	\N	NOURRITURE	-1.00	-39.71	0.00	t
6130	2102	\N	CORNET BOLO	1.00	6.00	6.00	f
6131	2102	\N	CORNET TRUFFE	1.00	7.00	6.00	f
6147	2105	\N	ROSÉ VERRE	1.00	5.00	21.00	f
6148	2105	\N	COUSCOUS PM	1.00	17.00	12.00	f
6149	2105	\N	CREPE GORGONZOLA + COURG.	2.00	14.00	12.00	f
6150	2105	\N	PROSECCO VERRE	1.00	6.00	21.00	f
6151	2105	\N	FANTA	1.00	2.20	21.00	f
6152	2105	\N	COCA	1.00	2.20	21.00	f
6153	2105	\N	PINOT GRIGIO BLUSH	2.00	20.00	21.00	f
6156	2108	\N	CORNET LARD	1.00	6.00	6.00	f
6160	2111	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
6161	2111	\N	PÂTES STRACIATELLA SCAMPIS	1.00	19.00	12.00	f
6162	2111	\N	CANNELLONI RICO/EPI	1.00	18.00	12.00	f
6171	2114	\N	NOURRITURE	-1.00	-28.52	0.00	t
6175	2117	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	t
6176	2117	\N	CREME BRULEE	1.00	5.00	12.00	t
6177	2117	\N	ICE TEA	1.00	2.20	21.00	f
6178	2117	\N	FANTA	1.00	2.20	21.00	f
6179	2117	\N	PÂTES TRUFFE	1.00	15.00	12.00	t
6180	2117	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
6192	2120	\N	COUSCOUS PM	2.00	17.00	12.00	f
6199	2123	\N	PINOT GRIGIO (2020)	2.00	20.00	21.00	f
6200	2123	\N	PÂTES STRACIATELLA SCAMPIS	1.00	19.00	12.00	f
6201	2123	\N	PÂTES BOMBE ATOMIQUE+ BURRATA	1.00	17.00	12.00	f
6202	2123	\N	TCHAKTCHOUKA	1.00	10.00	12.00	f
6203	2123	\N	GIN TONIC	1.00	6.00	21.00	f
6204	2123	\N	BLANC VERRE	1.00	5.00	21.00	f
6205	2123	\N	Cuba-Li	2.00	8.00	21.00	f
6206	2123	\N	GRAPPA	2.00	5.00	21.00	f
6211	2126	\N	ORANGE	-1.00	-14.00	0.00	t
6214	2129	\N	Caro	-1.00	-80.00	0.00	t
6217	2132	\N	RESTO JULIE	-1.00	-68.00	0.00	t
6223	2135	\N	GIN TONIC	2.00	6.00	21.00	f
6227	2138	\N	POULET	-1.00	-12.00	0.00	t
6255	2141	\N	BOISSONS	-1.00	-156.09	0.00	t
6258	2144	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
6259	2144	\N	IRISH COFFEE	4.00	8.00	21.00	f
6263	2147	\N	COURSES CHAPON	-1.00	-66.87	0.00	t
6266	2150	\N	JUPILER	1.00	2.50	21.00	t
6267	2150	\N	PROSECCO VERRE	1.00	6.00	21.00	t
6268	2150	\N	PÂTES STRACIATELLA SCAMPIS	1.00	19.00	12.00	t
6271	2153	\N	TVA	-1.00	-500.62	0.00	t
6274	2156	\N	COURSES CHAPON	-1.00	-26.55	0.00	t
6277	2159	\N	NOURRITURE	-1.00	-47.00	0.00	t
6287	2162	\N	PECKET FRAISE	2.00	8.00	21.00	f
6288	2162	\N	CANNELLONI RICO/EPI	1.00	18.00	12.00	f
6289	2162	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	f
6290	2162	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	f
6293	2165	\N	CANNELLONI RICO/EPI	1.00	18.00	12.00	t
6294	2165	\N	BLONDINETTE	2.00	4.00	21.00	f
6298	2168	\N	JUPILER	2.00	2.50	21.00	f
6302	2171	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	f
6306	2174	\N	CORNET BOLO	2.00	6.00	6.00	t
6307	2174	\N	CORNET LARD	2.00	6.00	6.00	t
6308	2174	\N	JUPILER	4.00	2.50	21.00	f
6314	2177	\N	BLANC VERRE	6.00	5.00	21.00	f
6319	2180	\N	CORNET LARD	1.00	6.00	6.00	t
6320	2180	\N	ROUGE VERRE	3.00	5.00	21.00	f
6328	2183	\N	ROUGE VERRE	3.00	5.00	21.00	t
6329	2183	\N	BLANC VERRE	3.00	5.00	21.00	t
6330	2183	\N	CORNET LARD	1.00	6.00	6.00	t
6336	2186	\N	ROUGE VERRE	1.00	5.00	21.00	f
6337	2186	\N	ROSÉ VERRE	15.00	5.00	21.00	f
6338	2186	\N	CAPUCCINO	1.00	2.80	21.00	f
6339	2186	\N	CORNET BOLO	1.00	6.00	6.00	t
6342	2189	\N	Service Caro	-1.00	-80.00	0.00	t
6353	2192	\N	CREME BRULEE	1.00	5.00	12.00	t
6354	2192	\N	BLANC VERRE	4.00	5.00	21.00	t
6355	2192	\N	CANNELLONI RICO/EPI	1.00	18.00	12.00	t
6356	2192	\N	POLPETTE	1.00	16.00	12.00	t
6359	2195	\N	GLACE	2.00	5.00	12.00	t
6360	2195	\N	ORVAL	1.00	5.00	21.00	f
6361	2195	\N	COCA	2.00	2.20	21.00	f
6362	2195	\N	VIOLETTE	1.00	8.00	21.00	f
6363	2195	\N	PECKET FRAISE	1.00	8.00	21.00	f
6364	2195	\N	PÂTES STRACIATELLA SCAMPIS	1.00	19.00	12.00	t
6365	2195	\N	PÂTES BOLO	1.00	13.00	12.00	t
6366	2195	\N	COUSCOUS VG	2.00	10.00	12.00	t
6389	2198	\N	VAL DIEU	1.00	4.00	21.00	f
6390	2198	\N	POLPETTE	2.00	16.00	12.00	t
6391	2198	\N	BLONDINETTE	1.00	4.00	21.00	f
6392	2198	\N	CAPUCCINO	2.00	2.80	21.00	f
6393	2198	\N	COCA	1.00	2.20	21.00	f
6396	2201	\N	SUSHI MAASTRICHT	-1.00	-79.60	0.00	t
7234	2470	\N	CREME BRULEE	1.00	5.00	12.00	f
7235	2470	\N	CAFÉ	1.00	2.50	21.00	f
7236	2470	\N	ESPRESSO	2.00	2.50	21.00	f
7237	2470	\N	COUSCOUS VG	1.00	12.00	12.00	f
7238	2470	\N	COUSCOUS PM	1.00	17.00	12.00	f
7239	2470	\N	CORNET BOLO	1.00	13.00	6.00	f
7240	2470	\N	COCA ZERO	1.00	2.20	21.00	f
7241	2470	\N	JUPILER	1.00	2.50	21.00	f
7244	2473	\N	CAFÉ	1.00	2.50	21.00	f
7245	2473	\N	BLANC VERRE	3.00	5.00	21.00	f
7246	2473	\N	ROUGE VERRE	2.00	5.00	21.00	f
7247	2473	\N	COCA	2.00	2.20	21.00	f
7248	2473	\N	PÂTES TRUFFE	2.00	15.00	12.00	f
7253	2476	\N	BLANC VERRE	1.00	5.00	21.00	t
7254	2476	\N	VAL DIEU	4.00	4.00	21.00	t
7257	2479	\N	MANDURIA	1.00	30.00	21.00	t
7258	2479	\N	SABAYON	3.00	8.00	12.00	t
7259	2479	\N	CANNELLONI VIANDE	1.00	18.00	12.00	t
7260	2479	\N	PÂTES LARD	2.00	13.00	12.00	t
7261	2479	\N	BLANC VERRE	1.00	5.00	21.00	t
7262	2479	\N	ORVAL	1.00	5.00	21.00	t
7263	2479	\N	GINGEMBRE	1.00	10.00	21.00	t
7268	2482	\N	CREME BRULEE	2.00	0.00	6.00	t
7271	2485	\N	4 FROMAGES	1.00	6.00	6.00	t
7272	2485	\N	CORNET BOLO	4.00	6.00	6.00	t
7283	2488	\N	GIN 0%	2.00	8.00	21.00	t
7284	2488	\N	COUSCOUS PM	2.00	17.00	12.00	t
7285	2488	\N	COCA	2.00	2.20	21.00	t
7286	2488	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
6174	2116	\N	POTEE AL D'JOTE	2.00	18.00	12.00	t
6183	2119	\N	CAFÉ	3.00	2.50	21.00	f
6184	2119	\N	MANDURIA	2.00	30.00	21.00	f
6185	2119	\N	GIN TONIC	2.00	6.00	21.00	f
6186	2119	\N	PROSECCO VERRE	6.00	6.00	21.00	f
6187	2119	\N	CREPE GORGONZOLA + COURG.	1.00	14.00	12.00	t
6188	2119	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	f
6189	2119	\N	COUSCOUS PM	1.00	17.00	12.00	f
6190	2119	\N	POLPETTE	1.00	16.00	12.00	t
6191	2119	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
6194	2122	\N	FANTA	2.00	0.00	21.00	t
6195	2122	\N	BLANC VERRE	2.00	0.00	21.00	t
6196	2122	\N	BURRATA PESTO	1.00	0.00	12.00	t
6197	2122	\N	COUSCOUS PM	1.00	0.00	12.00	t
6198	2122	\N	TAJINE	1.00	0.00	12.00	t
6210	2125	\N	CORNET LARD	1.00	6.00	6.00	t
6213	2128	\N	ORANGE	-1.00	-28.00	0.00	t
6216	2131	\N	CARBURANT	-1.00	-98.56	0.00	t
6222	2134	\N	COUSCOUS PM	2.00	17.00	6.00	f
6226	2137	\N	NOURRITURE	-1.00	-22.00	0.00	t
6229	2140	\N	FANTA	1.00	2.20	21.00	f
6230	2140	\N	PROSECCO VERRE	1.00	0.00	21.00	f
6231	2140	\N	PÂTES STRACIATELLA SCAMPIS	1.00	0.00	12.00	f
6232	2140	\N	COCA ZERO	3.00	2.20	21.00	f
6233	2140	\N	MANDURIA	3.00	30.00	21.00	f
6234	2140	\N	PÂTES STRACIATELLA SCAMPIS	2.00	19.00	12.00	f
6235	2140	\N	CANNELLONI RICO/EPI	4.00	18.00	12.00	t
6236	2140	\N	PÂTES LARD	2.00	13.00	12.00	f
6237	2140	\N	POLPETTE	1.00	16.00	12.00	f
6238	2140	\N	COUSCOUS PM	2.00	17.00	12.00	f
6239	2140	\N	ASSIETTE APERITIVE (2 p.)	3.00	19.00	12.00	t
6240	2140	\N	CREPE	1.00	0.00	12.00	f
6241	2140	\N	CREPE	2.00	5.00	12.00	f
6242	2140	\N	ESPRESSO	1.00	2.50	21.00	f
6243	2140	\N	CAFÉ	1.00	2.50	21.00	f
6244	2140	\N	CREME BRULEE	3.00	5.00	12.00	f
6245	2140	\N	SABAYON SPECIAL	1.00	10.00	12.00	f
6246	2140	\N	IRISH COFFEE	5.00	8.00	21.00	f
6247	2140	\N	BLANC VERRE	2.00	5.00	21.00	f
6248	2140	\N	COCA	2.00	2.20	21.00	f
6249	2140	\N	JUPILER	1.00	2.50	21.00	f
6250	2140	\N	TRIPLE SAINTE NITOUCHE	2.00	4.50	21.00	f
6251	2140	\N	PROSECCO VERRE	1.00	6.00	21.00	f
6252	2140	\N	Cuba-Li	2.00	8.00	21.00	f
6253	2140	\N	GIN TONIC	1.00	6.00	21.00	f
6254	2140	\N	PECKET FRAISE	3.00	8.00	21.00	f
6257	2143	\N	Service Caro	-1.00	-30.00	0.00	t
6261	2146	\N	BLANC VERRE	3.00	5.00	21.00	t
6262	2146	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
6265	2149	\N	Service Caro	-1.00	-20.00	0.00	t
6270	2152	\N	CARBURANT	-1.00	-97.35	0.00	t
6273	2155	\N	COURSES CHAPON	-1.00	-51.89	0.00	t
6276	2158	\N	HACHIS BOLO	-1.00	-24.30	0.00	t
6279	2161	\N	THÉ MENTHE	2.00	2.50	21.00	f
6280	2161	\N	COCA	1.00	2.20	21.00	f
6281	2161	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	f
6282	2161	\N	PÂTES BOLO	1.00	13.00	12.00	f
6283	2161	\N	CREPE SAUCE TRUFFES BURRATA	1.00	14.00	12.00	f
6284	2161	\N	CREPE CREME LARD	1.00	12.00	12.00	f
6285	2161	\N	PECKET FRAISE	2.00	8.00	21.00	f
6286	2161	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
6292	2164	\N	ROSÉ VERRE	2.00	5.00	21.00	t
6296	2167	\N	VIN CHAUD	1.00	2.50	21.00	f
6297	2167	\N	BLANC VERRE	1.00	5.00	21.00	f
6300	2170	\N	JUPILER	2.00	2.50	21.00	f
6301	2170	\N	ROUGE VERRE	1.00	5.00	21.00	f
6304	2173	\N	CORNET BOLO	1.00	6.00	6.00	t
6305	2173	\N	CORNET LARD	1.00	6.00	6.00	t
6311	2176	\N	BLANC VERRE	2.00	5.00	21.00	f
6312	2176	\N	CORNET LARD	2.00	6.00	6.00	t
6313	2176	\N	CORNET BOLO	2.00	6.00	6.00	t
6318	2179	\N	CORNET LARD	2.00	6.00	6.00	t
6325	2182	\N	PECKET FRAISE	2.00	8.00	21.00	f
6326	2182	\N	CORNET LARD	2.00	6.00	6.00	t
6327	2182	\N	CORNET BOLO	2.00	6.00	6.00	t
6334	2185	\N	CAFÉ	1.00	2.50	21.00	f
6335	2185	\N	GRAPPA	1.00	5.00	21.00	f
6341	2188	\N	COUSCOUS PM	2.00	17.00	6.00	f
6346	2191	\N	DECA	1.00	2.50	21.00	f
6347	2191	\N	ROUGE VERRE	1.00	5.00	21.00	f
6348	2191	\N	CAFÉ	1.00	2.50	21.00	f
6349	2191	\N	GLACE	2.00	5.00	12.00	f
6350	2191	\N	EAU PET 1/2 L	1.00	3.50	21.00	f
6351	2191	\N	COUSCOUS PM	1.00	17.00	12.00	f
6352	2191	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
6358	2194	\N	NOURRITURE	-1.00	-67.00	0.00	t
6377	2197	\N	CREME BRULEE	1.00	5.00	12.00	t
6378	2197	\N	ORVAL	1.00	5.00	21.00	t
6379	2197	\N	BLONDINETTE	2.00	4.00	21.00	t
6380	2197	\N	COUSCOUS PM	1.00	17.00	12.00	t
6381	2197	\N	Cuba-Li	1.00	8.00	21.00	t
6382	2197	\N	PECKET FRAISE	2.00	8.00	21.00	t
6383	2197	\N	CREPE GORGONZOLA + COURG.	1.00	14.00	12.00	t
6384	2197	\N	CAFÉ	1.00	2.50	21.00	t
6385	2197	\N	THÉ MENTHE	3.00	2.50	21.00	t
6386	2197	\N	TRIPLE SAINTE NITOUCHE	1.00	4.50	21.00	t
6387	2197	\N	PROSECCO VERRE	1.00	6.00	21.00	t
6388	2197	\N	PÂTES STRACIATELLA SCAMPIS	2.00	19.00	12.00	t
6395	2200	\N	NOURRITURE	-1.00	-3.78	0.00	t
6398	2203	\N	Service Elise	-1.00	-40.00	0.00	t
7296	2491	\N	COCA ZERO	1.00	2.20	21.00	t
7297	2491	\N	PROSECCO VERRE	1.00	6.00	21.00	t
7298	2491	\N	PÂTES BOLO	1.00	13.00	12.00	t
7310	2494	\N	Service Léa	-1.00	-30.00	0.00	t
7313	2497	\N	CARBURANT	-1.00	-105.92	0.00	t
7316	2500	\N	COCA ZERO	1.00	2.20	21.00	t
7317	2500	\N	CHAKTCHOUKA	1.00	12.00	12.00	t
7318	2500	\N	CANNELLONI VIANDE	1.00	18.00	12.00	t
7319	2500	\N	PECKET FRAISE	1.00	8.00	21.00	t
7326	2503	\N	MERGUEZ	-1.00	-34.65	0.00	t
7329	2506	\N	HOEGAARDEN ROSEE	1.00	0.00	21.00	f
7330	2506	\N	JUPILER	2.00	2.00	21.00	f
7339	2509	\N	INTERMARCHE	-1.00	-24.71	0.00	t
7347	2512	\N	GATEAUX MIEL	1.00	5.00	12.00	f
7348	2512	\N	CREPE CHAKCHOUKA	1.00	14.00	12.00	f
7349	2512	\N	BOMBE ATOMIQUE+ BURRATA	1.00	17.00	12.00	f
7350	2512	\N	TRIPLE	1.00	4.50	21.00	f
7351	2512	\N	JUPILER	1.00	2.50	21.00	f
6207	2124	\N	BLANC VERRE	1.00	5.00	21.00	f
6208	2124	\N	GRAPPA	1.00	5.00	21.00	f
6209	2124	\N	Cuba-Li	2.00	8.00	21.00	f
6212	2127	\N	Taxe Circulation	-1.00	-127.81	0.00	t
6215	2130	\N	NOURRITURE	-1.00	-70.45	0.00	t
6218	2133	\N	CREME BRULEE	2.00	5.00	12.00	t
6219	2133	\N	MANDURIA	4.00	30.00	21.00	t
6220	2133	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	t
6221	2133	\N	COUSCOUS PM	6.00	17.00	12.00	t
6224	2136	\N	ROSÉ VERRE	3.00	5.00	21.00	f
6225	2136	\N	PÂTES LARD	1.00	13.00	6.00	f
6228	2139	\N	NOURRITURE	-1.00	-57.13	0.00	t
6256	2142	\N	Service Caro	-1.00	-50.00	0.00	t
6260	2145	\N	CREME BRULEE	2.00	5.00	12.00	t
6264	2148	\N	POULET	-1.00	-140.00	0.00	t
6269	2151	\N	SODEXO	-1.00	-30.00	0.00	t
6272	2154	\N	PELLETS	-1.00	-55.00	0.00	t
6275	2157	\N	ENERGIES CHAPON	-1.00	-243.38	0.00	t
6278	2160	\N	BLONDINETTE	2.00	4.00	21.00	t
6291	2163	\N	Resto Louna	-1.00	-120.00	0.00	t
6295	2166	\N	NOURRITURE	-1.00	-17.98	0.00	t
6299	2169	\N	PINOT GRIGIO BLUSH	3.00	5.00	21.00	f
6303	2172	\N	CORNET LARD	2.00	6.00	6.00	t
6309	2175	\N	BLANC VERRE	3.00	5.00	21.00	f
6310	2175	\N	JUPILER	2.00	2.50	21.00	f
6315	2178	\N	ROSÉ VERRE	2.00	5.00	21.00	f
6316	2178	\N	PECKET FRAISE	2.00	8.00	21.00	f
6317	2178	\N	CORNET LARD	5.00	6.00	6.00	t
6321	2181	\N	GIN 0%	2.00	8.00	21.00	f
6322	2181	\N	GRAPPA	1.00	5.00	21.00	f
6323	2181	\N	CAPUCCINO	1.00	2.80	21.00	f
6324	2181	\N	ROSÉ VERRE	2.00	5.00	21.00	f
6331	2184	\N	CORNET LARD	3.00	6.00	6.00	t
6332	2184	\N	BLANC VERRE	2.00	5.00	21.00	t
6333	2184	\N	ROUGE VERRE	1.00	5.00	21.00	t
6340	2187	\N	BOISSONS	-1.00	-120.00	0.00	t
6343	2190	\N	ROSÉ VERRE	1.00	5.00	21.00	f
6344	2190	\N	CREPE GORGONZOLA + COURG. XXL	1.00	18.00	12.00	f
6345	2190	\N	POLPETTE	1.00	16.00	12.00	f
6357	2193	\N	Service Caro	-1.00	-30.00	0.00	t
6367	2196	\N	AMARONE	1.00	50.00	21.00	t
6368	2196	\N	IRISH COFFEE	1.00	8.00	21.00	t
6369	2196	\N	COCA ZERO	1.00	2.20	21.00	t
6370	2196	\N	CREME BRULEE	1.00	5.00	12.00	t
6371	2196	\N	JUPILER	1.00	2.50	21.00	t
6372	2196	\N	BLANC VERRE	1.00	5.00	21.00	t
6373	2196	\N	PROSECCO VERRE	1.00	6.00	21.00	t
6374	2196	\N	COUSCOUS PM	1.00	17.00	12.00	t
6375	2196	\N	CANNELLONI RICO/EPI	1.00	18.00	12.00	t
6376	2196	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
6394	2199	\N	NOURRITURE	-1.00	-14.51	0.00	t
6397	2202	\N	NOURRITURE	-1.00	-2.98	0.00	t
6399	2204	\N	Service Fanny	-1.00	-40.00	0.00	t
6400	2205	\N	COUSCOUS PM	10.00	17.00	6.00	f
6401	2206	\N	NOURRITURE	-1.00	-264.85	0.00	t
6402	2207	\N	EQUIPEMENT	-1.00	-81.35	0.00	t
6403	2208	\N	NOURRITURE	-1.00	-118.00	0.00	t
6404	2209	\N	NOURRITURE	-1.00	-91.68	0.00	t
6405	2210	\N	NOURRITURE	-1.00	-8.90	0.00	t
6406	2211	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
6407	2211	\N	TAJINE	2.00	17.00	12.00	t
6408	2211	\N	PÂTES TRUFFE	1.00	15.00	12.00	t
6409	2211	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
6410	2211	\N	COUSCOUS PM	3.00	17.00	12.00	t
6411	2211	\N	COCA ZERO	1.00	2.20	21.00	t
6412	2211	\N	ROUGE VERRE	2.00	5.00	21.00	t
6413	2211	\N	HOEGAARDEN ROSEE	2.00	2.50	21.00	t
6414	2211	\N	BLONDINETTE	3.00	4.00	21.00	t
6415	2211	\N	BLANC VERRE	3.00	5.00	21.00	t
6416	2212	\N	PLAT SPÉCIAL	1.00	13.00	12.00	f
6417	2212	\N	COUSCOUS PM	1.00	15.00	12.00	f
6418	2212	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
6419	2212	\N	POLPETTE	2.00	16.00	12.00	f
6420	2212	\N	PÂTES LARD	2.00	13.00	12.00	f
6421	2212	\N	PÂTES BOLO	5.00	13.00	12.00	f
6422	2212	\N	COCA	1.00	2.20	21.00	f
6423	2212	\N	COCA ZERO	2.00	2.20	21.00	f
6424	2212	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
6425	2212	\N	APPASSIMENTO	1.00	30.00	21.00	f
6426	2213	\N	Service Caro	-1.00	-30.00	0.00	t
6427	2214	\N	OFFICE 365	-1.00	-69.00	0.00	t
6428	2215	\N	NOURRITURE	-1.00	-17.41	0.00	t
6429	2216	\N	NOURRITURE	-1.00	-93.14	0.00	t
6430	2217	\N	NOURRITURE	-1.00	-17.16	0.00	t
6431	2218	\N	COUSCOUS PM	3.00	17.00	6.00	t
6432	2219	\N	BOISSONS	-1.00	-356.00	0.00	t
6433	2220	\N	CAFÉ	2.00	2.50	21.00	f
6434	2220	\N	EAU PET 1/2 L	1.00	3.50	21.00	f
6435	2220	\N	CREPE CHAKCHOUKA	2.00	14.00	12.00	f
6436	2221	\N	THÉ MENTHE	2.00	2.50	21.00	f
6437	2221	\N	BLANC VERRE	1.00	5.00	21.00	f
6438	2221	\N	PROSECCO VERRE	1.00	6.00	21.00	f
6439	2221	\N	JUPILER	2.00	2.50	21.00	f
6440	2221	\N	TAJINE	1.00	17.00	12.00	f
6441	2221	\N	COUSCOUS PM	1.00	17.00	12.00	f
6442	2222	\N	BLONDINETTE	2.00	4.00	21.00	f
6443	2223	\N	PECKET FRAISE	1.00	0.00	21.00	f
6444	2223	\N	TAJINE	1.00	0.00	12.00	f
6445	2223	\N	TAJINE	1.00	17.00	12.00	f
6446	2223	\N	THÉ MENTHE	1.00	2.50	21.00	f
6447	2224	\N	BLONDINETTE	1.00	4.00	21.00	f
6448	2224	\N	PINOT GRIGIO (2020)	2.00	20.00	21.00	f
6449	2224	\N	CANNELLONI RICO/EPI	2.00	18.00	12.00	f
6450	2224	\N	SPAG.COURGETTE + SCAMPIS+BURRATA	1.00	22.00	12.00	f
6451	2224	\N	VENTAJOL (CÔTES DE RHÔNES)	2.00	24.00	21.00	f
6452	2224	\N	ROUGE VERRE	2.00	6.00	21.00	f
6453	2224	\N	GIN 0%	1.00	8.00	21.00	f
6454	2224	\N	PECKET FRAISE	1.00	8.00	21.00	f
6455	2225	\N	PÂTES LARD	1.00	13.00	6.00	t
6456	2225	\N	COUSCOUS PM	2.00	17.00	6.00	t
6457	2226	\N	ROSÉ VERRE	1.00	5.00	21.00	f
6458	2226	\N	FORFAIT	2.00	45.00	12.00	f
6459	2226	\N	ROUGE VERRE	2.00	5.00	21.00	f
6460	2227	\N	ROUGE VERRE	1.00	5.00	21.00	f
6461	2227	\N	MANDURIA	1.00	30.00	21.00	f
6462	2227	\N	FORFAIT	4.00	45.00	12.00	f
6463	2228	\N	NERO D'AVOLA	2.00	30.00	21.00	t
6464	2228	\N	FORFAIT	4.00	45.00	12.00	t
6465	2229	\N	JUPILER	1.00	2.50	21.00	f
6466	2229	\N	ROSÉ VERRE	1.00	5.00	21.00	f
6467	2229	\N	VENTAJOL (CÔTES DE RHÔNES)	2.00	24.00	21.00	f
6471	2232	\N	DESSERT	-1.00	-40.00	0.00	t
6474	2235	\N	ROSÉ VERRE	1.00	0.00	21.00	t
6475	2235	\N	ROUGE VERRE	2.00	0.00	21.00	t
6480	2238	\N	ROUGE VERRE	1.00	0.00	21.00	t
6481	2238	\N	MANDURIA	1.00	0.00	21.00	t
6485	2241	\N	RESTO BASKET	-1.00	-50.50	0.00	t
6488	2244	\N	CARBURANT	-1.00	-101.61	0.00	t
6491	2247	\N	ZARA Maastricht	-1.00	-45.90	0.00	t
6494	2250	\N	ENERGIES CHAPON	-1.00	-243.38	0.00	t
6499	2253	\N	JUPILER	3.00	2.00	21.00	f
6505	2256	\N	MOUSSE CHOCOLAT	2.00	5.00	6.00	t
6523	2259	\N	BURRATA	1.00	8.00	12.00	t
6544	2262	\N	CORNET BOLO	4.00	6.00	6.00	t
6550	2265	\N	BURRATA PESTO	1.00	15.00	12.00	t
6551	2265	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
6552	2265	\N	PÂTES LARD	1.00	13.00	12.00	t
6553	2265	\N	COUSCOUS PM	6.00	17.00	12.00	t
6554	2265	\N	MANDURIA	2.00	30.00	21.00	t
6555	2265	\N	HOEGAARDEN ROSEE	2.00	2.50	21.00	t
6556	2265	\N	BLONDINETTE	4.00	4.00	21.00	t
6565	2268	\N	NOURRITURE	-1.00	-80.91	0.00	t
6568	2271	\N	Service Caro	-1.00	-50.00	0.00	t
6571	2274	\N	LOYER	-1.00	-600.00	0.00	t
6581	2277	\N	NOURRITURE	-1.00	-60.00	0.00	t
6584	2280	\N	COCA ZERO	1.00	2.20	21.00	f
6585	2280	\N	COCA	1.00	2.20	21.00	f
6586	2280	\N	PECKET FRAISE	2.00	8.00	21.00	f
6587	2280	\N	CHAMPIGNONS KABYLES	2.00	8.00	12.00	f
6591	2283	\N	BLONDINETTE	1.00	4.00	21.00	t
6592	2283	\N	ROUGE VERRE	3.00	5.00	21.00	t
6593	2283	\N	BLANC VERRE	5.00	5.00	21.00	t
6594	2283	\N	CREPE GORGONZOLA + COURG.	1.00	14.00	12.00	t
6595	2283	\N	SPAG.COURGETTE + SCAMPIS	5.00	18.00	12.00	t
6614	2286	\N	Service Caro	-1.00	-90.00	0.00	t
6621	2289	\N	BLUSH 1/4	1.00	8.00	21.00	f
6622	2289	\N	COCA	3.00	2.20	21.00	f
6623	2289	\N	PROSECCO VERRE	2.00	6.00	21.00	f
6624	2289	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	f
6625	2289	\N	PÂTES LARD	1.00	13.00	12.00	f
6626	2289	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
6629	2292	\N	BLUSH	2.00	20.00	21.00	f
6632	2295	\N	CREME BRULEE	1.00	5.00	12.00	f
6633	2295	\N	THÉ MENTHE	2.00	2.50	21.00	f
6634	2295	\N	COUSCOUS VG	1.00	10.00	12.00	f
6635	2295	\N	COUSCOUS PM	1.00	17.00	12.00	f
6636	2295	\N	VIOLETTE	1.00	8.00	21.00	f
6637	2295	\N	PROSECCO VERRE	1.00	6.00	21.00	f
6649	2298	\N	CAFÉ	1.00	2.50	21.00	t
6650	2298	\N	THÉ MENTHE	2.00	2.50	21.00	t
6651	2298	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	t
6652	2298	\N	CREME BRULEE	1.00	5.00	12.00	t
6653	2298	\N	BURRATA PESTO	1.00	15.00	12.00	t
6654	2298	\N	POLPETTE	1.00	16.00	12.00	t
6655	2298	\N	COUSCOUS PM	1.00	17.00	12.00	t
6656	2298	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	t
6664	2301	\N	BLANC VERRE	1.00	5.00	21.00	f
6665	2301	\N	COUSCOUS PM	1.00	17.00	12.00	f
6666	2301	\N	VAL DIEU	2.00	4.00	21.00	f
6674	2304	\N	SODEXO	-1.00	-30.00	0.00	t
6678	2307	\N	THÉ MENTHE	2.00	2.50	21.00	f
6679	2307	\N	CREME BRULEE	1.00	5.00	12.00	f
6680	2307	\N	COCA	1.00	2.20	21.00	f
6681	2307	\N	BURRATA PESTO	1.00	15.00	12.00	f
6682	2307	\N	PÂTES BOMBE ATOMIQUE+ BURRATA	1.00	17.00	12.00	f
6683	2307	\N	TAJINE	1.00	17.00	12.00	f
6684	2307	\N	Cuba-Li	1.00	8.00	21.00	f
6685	2307	\N	ROUGE VERRE	2.00	5.00	21.00	f
6703	2310	\N	SPAG.COURGETTE + SCAMPIS	1.00	0.00	12.00	t
6704	2310	\N	PÂTES SCAMPIS	1.00	0.00	12.00	t
6705	2310	\N	Cuba-Li	1.00	0.00	21.00	t
6706	2310	\N	VIOLETTE	1.00	0.00	21.00	t
6710	2313	\N	IRISH COFFEE	1.00	8.00	21.00	t
6711	2313	\N	THÉ MENTHE	3.00	2.50	21.00	t
6712	2313	\N	GLACE	1.00	5.00	12.00	t
6713	2313	\N	ICE TEA	1.00	2.20	21.00	t
6714	2313	\N	ROUGE VERRE	1.00	5.00	21.00	t
6715	2313	\N	BLONDINETTE	1.00	4.00	21.00	t
6716	2313	\N	CREPE SAUCE DE BASE + BURRATA	2.00	12.00	12.00	t
6717	2313	\N	CANNELLONI RICO/EPI	1.00	18.00	12.00	t
6718	2313	\N	COUSCOUS PM	1.00	17.00	12.00	t
6719	2313	\N	PROSECCO VERRE	1.00	6.00	21.00	t
6720	2313	\N	ORVAL	2.00	5.00	21.00	t
6721	2313	\N	PECKET FRAISE	2.00	8.00	21.00	t
6731	2316	\N	NOURRITURE	-1.00	-6.85	0.00	t
6734	2319	\N	NOURRITURE	-1.00	-26.98	0.00	t
6737	2322	\N	ORANGE	-1.00	-14.00	0.00	t
6743	2325	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
6744	2325	\N	BLUSH	2.00	20.00	21.00	f
6745	2325	\N	ROSÉ VERRE	2.00	5.00	21.00	f
6746	2325	\N	ARROSTICINNI (5)	2.00	8.00	12.00	f
6753	2328	\N	STNI	-1.00	-39.31	0.00	t
6756	2331	\N	CAFÉ	2.00	2.50	21.00	t
6761	2334	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
6762	2334	\N	COUSCOUS PM	1.00	17.00	12.00	f
6763	2334	\N	TAJINE	1.00	17.00	12.00	f
6764	2334	\N	PECKET FRAISE	2.00	8.00	21.00	f
6765	2334	\N	BURRATA PESTO	1.00	15.00	12.00	f
6766	2334	\N	CREME BRULEE	1.00	5.00	12.00	f
6767	2334	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	f
6782	2337	\N	PECKET FRAISE	2.00	8.00	21.00	t
6783	2337	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
6784	2337	\N	TAJINE	1.00	17.00	12.00	t
6785	2337	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
6786	2337	\N	CREME BRULEE	1.00	5.00	12.00	t
6787	2337	\N	SABAYON	1.00	8.00	12.00	t
6810	2340	\N	Service Victor	-1.00	-70.00	0.00	t
6813	2343	\N	ROUGE VERRE	1.00	5.00	21.00	f
6814	2343	\N	BLANC VERRE	1.00	5.00	21.00	f
6815	2343	\N	PECKET FRAISE	1.00	0.00	21.00	f
6816	2343	\N	COUSCOUS PM	1.00	17.00	12.00	f
6817	2343	\N	COUSCOUS AGNEAU	1.00	0.00	12.00	f
6834	2346	\N	Service Caro	-1.00	-50.00	0.00	t
6837	2349	\N	ST NICOLAS CARO	-1.00	-50.00	0.00	t
6840	2352	\N	CARBURANT	-1.00	-100.00	0.00	t
6843	2355	\N	NOURRITURE	-1.00	-72.36	0.00	t
6847	2358	\N	MANDURIA	1.00	0.00	21.00	t
6851	2361	\N	CAFÉ	5.00	0.00	21.00	t
6852	2361	\N	THÉ MENTHE	1.00	0.00	21.00	t
6853	2361	\N	CREME BRULEE	6.00	0.00	12.00	t
6468	2230	\N	BLUSH	2.00	20.00	21.00	f
6469	2230	\N	FORFAIT	4.00	45.00	12.00	f
6472	2233	\N	CONCERT	-1.00	-150.00	0.00	t
6476	2236	\N	EAU PET 1/2 L	1.00	0.00	21.00	t
6477	2236	\N	ASSIETTE APERITIVE (2 p.)	1.00	0.00	12.00	t
6478	2236	\N	VENTAJOL (CÔTES DE RHÔNES)	1.00	0.00	21.00	t
6482	2239	\N	NERO D'AVOLA	2.00	0.00	21.00	t
6486	2242	\N	PAUL K	-1.00	-80.00	0.00	t
6489	2245	\N	DAMBIERMONT	-1.00	-158.26	0.00	t
6492	2248	\N	ENERGIES	-1.00	-441.59	0.00	t
6495	2251	\N	CAFÉ	1.00	2.50	21.00	f
6496	2251	\N	COUSCOUS PM	1.00	17.00	12.00	f
6497	2251	\N	ROUGE 1/4	1.00	8.00	21.00	f
6500	2254	\N	COUSCOUS PM	1.00	17.00	12.00	f
6501	2254	\N	BLUSH	1.00	20.00	21.00	f
6506	2257	\N	CHAMPIGNONS KABYLES	1.00	8.00	6.00	t
6507	2257	\N	CAFÉ	1.00	2.50	21.00	f
6524	2260	\N	ICE TEA	1.00	2.20	21.00	f
6525	2260	\N	FANTA	1.00	2.20	21.00	f
6526	2260	\N	PROSECCO VERRE	2.00	6.00	21.00	f
6527	2260	\N	VIOLETTE	2.00	8.00	21.00	f
6528	2260	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	f
6529	2260	\N	CREPE GORGONZOLA + COURG.	2.00	14.00	12.00	f
6530	2260	\N	CREPE CREME LARD	1.00	12.00	12.00	f
6531	2260	\N	SABAYON SPECIAL	1.00	10.00	12.00	f
6532	2260	\N	MOUSSE CHOCOLAT	3.00	5.00	12.00	f
6533	2260	\N	EAU PETILLANTE	2.00	2.20	21.00	f
6545	2263	\N	PÂTES SCAMPIS	2.00	17.00	12.00	f
6546	2263	\N	SCAMPIS LUCIFER	1.00	10.00	12.00	f
6547	2263	\N	TCHAKTCHOUKA	1.00	10.00	12.00	f
6548	2263	\N	GINGEMBRE	1.00	8.00	21.00	f
6557	2266	\N	SPAG.COURGETTE + SCAMPIS+BURRATA	1.00	22.00	12.00	f
6558	2266	\N	ESPRESSO	1.00	2.50	21.00	f
6559	2266	\N	BLANC VERRE	3.00	5.00	21.00	f
6566	2269	\N	NOURRITURE	-1.00	-8.20	0.00	t
6569	2272	\N	JUPILER	2.00	2.00	21.00	f
6572	2275	\N	NOURRITURE	-1.00	-3.00	0.00	t
6582	2278	\N	ESPRESSO	1.00	2.50	21.00	f
6588	2281	\N	COUSCOUS PM	1.00	17.00	6.00	t
6596	2284	\N	CREME BRULEE	1.00	5.00	12.00	f
6597	2284	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
6598	2284	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	f
6599	2284	\N	COUSCOUS PM	3.00	17.00	12.00	f
6600	2284	\N	BLONDINETTE	2.00	4.00	21.00	f
6601	2284	\N	COCA ZERO	1.00	2.20	21.00	f
6602	2284	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	f
6603	2284	\N	PROSECCO VERRE	1.00	6.00	21.00	f
6615	2287	\N	Service Maureen	-1.00	-35.00	0.00	t
6627	2290	\N	COUSCOUS PM	2.00	15.00	6.00	t
6630	2293	\N	RESTO CARO	-1.00	-60.00	0.00	t
6638	2296	\N	CREPE CHAKCHOUKA	1.00	14.00	12.00	t
6639	2296	\N	COUSCOUS VG	1.00	10.00	12.00	t
6640	2296	\N	BLUSH	1.00	20.00	21.00	t
6657	2299	\N	CORNET BOLO	1.00	6.00	6.00	t
6667	2302	\N	SABAYON	1.00	8.00	12.00	t
6668	2302	\N	COCA ZERO	2.00	2.20	21.00	t
6669	2302	\N	CANNELLONI RICO/EPI	1.00	18.00	12.00	t
6670	2302	\N	PLAT SPÉCIAL	1.00	18.00	12.00	t
6671	2302	\N	PECKET FRAISE	1.00	8.00	21.00	t
6672	2302	\N	VIOLETTE	1.00	8.00	21.00	t
6675	2305	\N	BOISSONS	-1.00	-32.00	0.00	t
6686	2308	\N	ROUGE VERRE	4.00	5.00	21.00	f
6687	2308	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
6688	2308	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	f
6689	2308	\N	CREME BRULEE	2.00	5.00	12.00	f
6707	2311	\N	Service Maureen	-1.00	-60.00	0.00	t
6722	2314	\N	THÉ MENTHE	2.00	2.50	21.00	f
6723	2314	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	f
6724	2314	\N	CANNELLONI RICO/EPI	1.00	18.00	12.00	f
6725	2314	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	f
6732	2317	\N	NOURRITURE	-1.00	-26.95	0.00	t
6735	2320	\N	LOYER	-1.00	-600.00	0.00	t
6738	2323	\N	POLPETTE	1.00	16.00	12.00	t
6739	2323	\N	TRIPLE SAINTE NITOUCHE	2.00	4.50	21.00	t
6747	2326	\N	CAFÉ	2.00	2.50	21.00	f
6748	2326	\N	BLUSH	1.00	20.00	21.00	f
6749	2326	\N	MANDURIA	2.00	25.00	21.00	f
6750	2326	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
6751	2326	\N	POLPETTE	1.00	16.00	12.00	f
6754	2329	\N	STNI	-1.00	-122.73	0.00	t
6757	2332	\N	HOEGAARDEN ROSEE	1.00	2.50	21.00	t
6758	2332	\N	BLONDINETTE	6.00	4.00	21.00	t
6768	2335	\N	Cuba-Li	1.00	8.00	21.00	f
6769	2335	\N	PÂTES LARD	1.00	13.00	12.00	f
6770	2335	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	f
6771	2335	\N	TRIPLE	1.00	4.50	21.00	f
6788	2338	\N	PECKET FRAISE	2.00	8.00	21.00	t
6789	2338	\N	BURRATA PESTO	1.00	15.00	12.00	t
6790	2338	\N	CREME BRULEE	1.00	5.00	12.00	t
6791	2338	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
6811	2341	\N	TRAVAUX HUY	-1.00	-150.00	0.00	t
6818	2344	\N	BLANC VERRE	2.00	5.00	21.00	f
6819	2344	\N	COUSCOUS PM	2.00	17.00	12.00	f
6835	2347	\N	UCM	-1.00	-168.61	0.00	t
6838	2350	\N	ST NICOLAS LOUNA	-1.00	-50.00	0.00	t
6841	2353	\N	ENERGIES	-1.00	-278.42	0.00	t
6844	2356	\N	CREME BRULEE	2.00	5.00	6.00	t
6848	2359	\N	ROSÉ VERRE	2.00	5.00	21.00	t
6849	2359	\N	VAL DIEU	2.00	4.00	21.00	t
6863	2362	\N	NOURRITURE	-1.00	-8.99	0.00	t
6876	2365	\N	Service Elise	-1.00	-40.00	0.00	t
6879	2368	\N	NERO D'AVOLA	2.00	30.00	21.00	t
6880	2368	\N	NOËL (BRUNE)	1.00	4.00	21.00	t
6881	2368	\N	VAL DIEU	1.00	4.00	21.00	t
6882	2368	\N	ORVAL	1.00	5.00	21.00	t
6883	2368	\N	TRIPLE	1.00	4.50	21.00	t
6884	2368	\N	BLONDINETTE	1.00	4.00	21.00	t
6885	2368	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
6886	2368	\N	POLPETTE	1.00	16.00	12.00	t
6887	2368	\N	COUSCOUS PM	3.00	17.00	12.00	t
6895	2371	\N	CANNELLONI VIANDE	1.00	18.00	12.00	t
6896	2371	\N	BLANC VERRE	2.00	5.00	21.00	f
6897	2371	\N	ROUGE VERRE	2.00	5.00	21.00	f
6900	2374	\N	ACTION	-1.00	-13.10	0.00	t
6906	2377	\N	Service Maureen	-1.00	-40.00	0.00	t
6909	2380	\N	BOISSONS	-1.00	-98.00	0.00	t
6935	2383	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	f
6936	2383	\N	COUSCOUS PM	1.00	17.00	12.00	f
6937	2383	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	f
6470	2231	\N	Service Fanny	-1.00	-40.00	0.00	t
6473	2234	\N	Service Caro	-1.00	-80.00	0.00	t
6479	2237	\N	BLUSH	2.00	0.00	21.00	t
6483	2240	\N	POLPETTE	1.00	16.00	6.00	t
6484	2240	\N	FORFAIT	4.00	25.00	12.00	f
6487	2243	\N	PAUL K	-1.00	-46.90	0.00	t
6490	2246	\N	ENERGIES	-1.00	-232.14	0.00	t
6493	2249	\N	ENERGIES	-1.00	-278.42	0.00	t
6498	2252	\N	COUSCOUS PM	2.00	17.00	6.00	t
6502	2255	\N	ESPRESSO	1.00	2.50	21.00	f
6503	2255	\N	MOUSSE CHOCOLAT	1.00	5.00	12.00	f
6504	2255	\N	PÂTES TRUFFE + BURRATA	2.00	17.00	12.00	f
6508	2258	\N	BLANC VERRE	1.00	5.00	21.00	t
6509	2258	\N	NERO D'AVOLA	1.00	30.00	21.00	t
6510	2258	\N	THÉ MENTHE	5.00	2.50	21.00	t
6511	2258	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	t
6512	2258	\N	PROSECCO VERRE	1.00	6.00	21.00	t
6513	2258	\N	GIN 0%	1.00	8.00	21.00	t
6514	2258	\N	VIOLETTE	1.00	8.00	21.00	t
6515	2258	\N	JUPILER	2.00	2.50	21.00	t
6516	2258	\N	PÂTES STRACIATELLA SCAMPIS	1.00	19.00	12.00	t
6517	2258	\N	CANNELLONI RICO/EPI	1.00	18.00	12.00	t
6518	2258	\N	TAJINE	1.00	17.00	12.00	t
6519	2258	\N	COUSCOUS PM	1.00	17.00	12.00	t
6520	2258	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	t
6521	2258	\N	TCHAKTCHOUKA	1.00	10.00	12.00	t
6522	2258	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
6534	2261	\N	CAFÉ	1.00	2.50	21.00	t
6535	2261	\N	MOUSSE CHOCOLAT	1.00	5.00	12.00	t
6536	2261	\N	SABAYON	1.00	8.00	12.00	t
6537	2261	\N	Cuba-Li	1.00	8.00	21.00	t
6538	2261	\N	PECKET FRAISE	1.00	8.00	21.00	t
6539	2261	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
6540	2261	\N	POLPETTE	1.00	16.00	12.00	t
6541	2261	\N	TAJINE	1.00	17.00	12.00	t
6542	2261	\N	COUSCOUS PM	1.00	17.00	12.00	t
6543	2261	\N	TCHAKTCHOUKA	1.00	10.00	12.00	t
6549	2264	\N	COUSCOUS PM	1.00	17.00	12.00	f
6560	2267	\N	POLPETTE	1.00	16.00	12.00	t
6561	2267	\N	SPAG.COURGETTE + SCAMPIS+BURRATA	1.00	22.00	12.00	t
6562	2267	\N	COCA	1.00	2.20	21.00	t
6563	2267	\N	PECKET FRAISE	2.00	8.00	21.00	t
6564	2267	\N	PROSECCO VERRE	2.00	6.00	21.00	t
6567	2270	\N	CARBURANT	-1.00	-102.01	0.00	t
6570	2273	\N	NOURRITURE	-1.00	-95.33	0.00	t
6573	2276	\N	DECA	1.00	2.50	21.00	t
6574	2276	\N	AMARETTO	1.00	5.00	21.00	t
6575	2276	\N	CREPE	2.00	6.00	12.00	t
6576	2276	\N	SABAYON	2.00	8.00	12.00	t
6577	2276	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
6578	2276	\N	BLANC VERRE	2.00	5.00	21.00	t
6579	2276	\N	PÂTES LARD	1.00	13.00	12.00	t
6580	2276	\N	PÂTES BOLO	1.00	13.00	12.00	t
6583	2279	\N	CORNET BOLO	1.00	6.00	6.00	t
6589	2282	\N	ROUGE VERRE	2.00	5.00	21.00	f
6590	2282	\N	BLONDINETTE	2.00	4.00	21.00	f
6604	2285	\N	AMARETTO	2.00	5.00	21.00	t
6605	2285	\N	COCA ZERO	2.00	2.20	21.00	t
6606	2285	\N	CAFÉ	5.00	2.50	21.00	t
6607	2285	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
6608	2285	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	t
6609	2285	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	t
6610	2285	\N	COUSCOUS VG	2.00	10.00	12.00	t
6611	2285	\N	COUSCOUS PM	2.00	17.00	12.00	t
6612	2285	\N	SCAMPIS LUCIFER	1.00	10.00	12.00	t
6613	2285	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	t
6616	2288	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	f
6617	2288	\N	COCA ZERO	4.00	2.20	21.00	f
6618	2288	\N	PÂTES	1.00	8.00	12.00	f
6619	2288	\N	TAJINE	2.00	17.00	12.00	f
6620	2288	\N	COUSCOUS PM	3.00	17.00	12.00	f
6628	2291	\N	Service Elise	-1.00	-30.00	0.00	t
6631	2294	\N	NOURRITURE	-1.00	-23.41	0.00	t
6641	2297	\N	CREME BRULEE	2.00	5.00	12.00	t
6642	2297	\N	CAFÉ	1.00	2.50	21.00	t
6643	2297	\N	COUSCOUS VG	1.00	10.00	12.00	t
6644	2297	\N	COUSCOUS PM	1.00	17.00	12.00	t
6645	2297	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
6646	2297	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	t
6647	2297	\N	COCA ZERO	1.00	2.20	21.00	t
6648	2297	\N	FANTA	2.00	2.20	21.00	t
6658	2300	\N	ESPRESSO	1.00	2.50	21.00	f
6659	2300	\N	CAFÉ	1.00	2.50	21.00	f
6660	2300	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	f
6661	2300	\N	TAJINE	1.00	17.00	12.00	f
6662	2300	\N	COCA ZERO	1.00	2.20	21.00	f
6663	2300	\N	ORVAL	1.00	5.00	21.00	f
6673	2303	\N	MERGUEZ	-1.00	-31.55	0.00	t
6676	2306	\N	POLPETTE	1.00	16.00	6.00	t
6677	2306	\N	COUSCOUS PM	1.00	17.00	6.00	t
6690	2309	\N	NERO D'AVOLA	1.00	30.00	21.00	t
6691	2309	\N	SABAYON SPECIAL	2.00	10.00	12.00	t
6692	2309	\N	ORVAL	1.00	5.00	21.00	t
6693	2309	\N	PROSECCO VERRE	1.00	6.00	21.00	t
6694	2309	\N	COCA	1.00	2.20	21.00	t
6695	2309	\N	ICE TEA	1.00	2.20	21.00	t
6696	2309	\N	SABAYON	1.00	8.00	12.00	t
6697	2309	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	t
6698	2309	\N	CHAKTCHOUKA	1.00	10.00	12.00	t
6699	2309	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
6700	2309	\N	PÂTES PESTO	1.00	14.00	12.00	t
6701	2309	\N	SPAG.COURGETTE	1.00	14.00	12.00	t
6702	2309	\N	COUSCOUS PM	1.00	17.00	12.00	t
6708	2312	\N	TAJINE	2.00	17.00	6.00	t
6709	2312	\N	COUSCOUS PM	4.00	17.00	6.00	f
6726	2315	\N	CREME BRULEE	2.00	0.00	12.00	t
6727	2315	\N	FANTA	2.00	0.00	21.00	t
6728	2315	\N	PECKET FRAISE	1.00	0.00	21.00	t
6729	2315	\N	TAJINE	2.00	0.00	12.00	t
6730	2315	\N	BURRATA PESTO	1.00	0.00	12.00	t
6733	2318	\N	CARBURANT	-1.00	-95.86	0.00	t
6736	2321	\N	SABAM	-1.00	-89.00	0.00	t
6740	2324	\N	ROSÉ VERRE	3.00	5.00	21.00	t
6741	2324	\N	BLONDINETTE	2.00	4.00	21.00	t
6742	2324	\N	TRIPLE SAINTE NITOUCHE	1.00	4.50	21.00	t
6752	2327	\N	ORANGE	-1.00	-28.00	0.00	t
6755	2330	\N	NOURRITURE	-1.00	-27.17	0.00	t
6759	2333	\N	JUPILER	2.00	2.00	21.00	t
6760	2333	\N	CORNET BOLO	1.00	6.00	6.00	t
6772	2336	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
6773	2336	\N	BURRATA PESTO	3.00	15.00	12.00	f
6774	2336	\N	SCAMPIS LUCIFER	1.00	10.00	12.00	f
6775	2336	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	f
6776	2336	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	f
6777	2336	\N	ARANCELLO	1.00	10.00	21.00	f
6778	2336	\N	GATEAUX MIEL	1.00	5.00	12.00	f
6779	2336	\N	SABAYON	1.00	8.00	12.00	f
6780	2336	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
6781	2336	\N	PROSECCO VERRE	4.00	6.00	21.00	f
6792	2339	\N	ST JACQUES	1.00	0.00	12.00	f
6793	2339	\N	CANNELLONI VIANDE	2.00	18.00	12.00	t
6794	2339	\N	AGNEAU + GRATIN	3.00	25.00	12.00	f
6795	2339	\N	CREME BRULEE	5.00	5.00	12.00	t
6796	2339	\N	BLUSH	1.00	20.00	21.00	f
6797	2339	\N	CAFÉ	1.00	2.50	21.00	f
6798	2339	\N	EAU PÉTILLANTE 1 L	3.00	5.00	21.00	f
6799	2339	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
6800	2339	\N	FANTA	1.00	2.20	21.00	f
6801	2339	\N	CANNELLONI VIANDE	1.00	0.00	12.00	f
6802	2339	\N	COCA	1.00	2.20	21.00	f
6803	2339	\N	PROSECCO VERRE	1.00	6.00	21.00	f
6804	2339	\N	DECA	1.00	2.50	21.00	f
6805	2339	\N	CAFÉ	3.00	2.50	21.00	f
6806	2339	\N	VAL DIEU	1.00	4.00	21.00	f
6807	2339	\N	ST JACQUES	5.00	10.00	12.00	t
6808	2339	\N	PECKET FRAISE	2.00	8.00	21.00	f
6809	2339	\N	BLUSH	1.00	20.00	21.00	f
6812	2342	\N	NOURRITURE	-1.00	-20.00	0.00	t
6820	2345	\N	THÉ MENTHE	4.00	2.50	21.00	t
6821	2345	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	t
6822	2345	\N	GLACE	2.00	5.00	12.00	t
6823	2345	\N	GATEAUX MIEL	2.00	5.00	12.00	t
6824	2345	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
6825	2345	\N	CREPE	1.00	5.00	12.00	t
6826	2345	\N	ICE TEA	4.00	2.20	21.00	t
6827	2345	\N	PINOT GRIGIO (2020)	2.00	20.00	21.00	t
6828	2345	\N	PÂTES BOLO	1.00	13.00	12.00	t
6829	2345	\N	COUSCOUS AGNEAU	6.00	21.00	12.00	t
6830	2345	\N	COUSCOUS VG	1.00	11.00	12.00	t
6831	2345	\N	COUSCOUS PM	1.00	17.00	12.00	t
6832	2345	\N	CHAMPIGNONS KABYLES	2.00	8.00	12.00	t
6833	2345	\N	ASSIETTE APERITIVE (2 p.)	2.00	19.00	12.00	t
6836	2348	\N	BOISSONS	-1.00	-73.40	0.00	t
6839	2351	\N	ST NICOLAS CHA	-1.00	-50.00	0.00	t
6842	2354	\N	NOËL CHA VINTED	-1.00	-51.10	0.00	t
6845	2357	\N	ROSÉ VERRE	4.00	5.00	21.00	t
6846	2357	\N	JUPILER	1.00	2.50	21.00	t
6850	2360	\N	Service Caro	-1.00	-18.00	0.00	t
6864	2363	\N	NOURRITURE	-1.00	-9.00	0.00	t
6877	2366	\N	NOURRITURE	-1.00	-132.21	0.00	t
6888	2369	\N	VAL DIEU	2.00	4.00	21.00	t
6889	2369	\N	COCA	2.00	2.20	21.00	t
6890	2369	\N	COUSCOUS PM	1.00	17.00	6.00	t
6891	2369	\N	COUSCOUS PM	1.00	7.00	6.00	t
6898	2372	\N	NOURRITURE	-1.00	-10.92	0.00	t
6901	2375	\N	PROSECCO VERRE	1.00	6.00	21.00	t
6902	2375	\N	VAL DIEU	1.00	4.00	21.00	t
6903	2375	\N	VAL DIEU	1.00	4.00	21.00	t
6904	2375	\N	VAL DIEU	1.00	4.00	21.00	t
6907	2378	\N	AG ASSURANCE	-1.00	-168.61	0.00	t
6910	2381	\N	CAFÉ	1.00	2.50	21.00	f
6911	2381	\N	GLACE	1.00	5.00	12.00	f
6912	2381	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	f
6913	2381	\N	SABAYON	1.00	8.00	12.00	f
6914	2381	\N	CREME BRULEE	1.00	5.00	12.00	f
6915	2381	\N	GATEAUX MIEL	1.00	5.00	12.00	f
6916	2381	\N	SABAYON SPECIAL	1.00	10.00	12.00	f
6917	2381	\N	COCA	1.00	2.20	21.00	f
6918	2381	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	f
6919	2381	\N	SOFT (Verre)	1.00	2.20	21.00	f
6920	2381	\N	ROUGE VERRE	2.00	5.00	21.00	f
6921	2381	\N	BLONDINETTE	1.00	4.00	21.00	f
6922	2381	\N	VAL DIEU	1.00	4.00	21.00	f
6923	2381	\N	APEROL SPRITZ	1.00	8.00	21.00	f
6924	2381	\N	VIOLETTE	1.00	8.00	21.00	f
6925	2381	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	f
6926	2381	\N	PÂTES TRUFFE	1.00	15.00	12.00	f
6927	2381	\N	SPAG.COURGETTE	1.00	14.00	12.00	f
6928	2381	\N	POLPETTE	1.00	16.00	12.00	f
6929	2381	\N	COUSCOUS PM	1.00	17.00	12.00	f
6930	2381	\N	COUSCOUS VG	2.00	11.00	12.00	f
6941	2384	\N	DECA	1.00	2.50	21.00	f
6942	2384	\N	TAJINE	2.00	17.00	12.00	f
6943	2384	\N	CHAMPIGNONS KABYLES	2.00	8.00	12.00	f
6944	2384	\N	PROSECCO VERRE	1.00	6.00	21.00	f
6945	2384	\N	GINGEMBRE	1.00	8.00	21.00	f
6946	2384	\N	NERO D'AVOLA	1.00	30.00	21.00	f
6954	2387	\N	CHOUCROUTE	11.00	24.00	12.00	t
6955	2387	\N	RIESLING	3.00	24.00	21.00	f
6956	2387	\N	COCA ZERO	2.00	2.20	21.00	t
6957	2387	\N	IRISH COFFEE	3.00	8.00	21.00	f
6958	2387	\N	CAFÉ	8.00	2.50	21.00	f
6959	2387	\N	PÂTES TRUFFE + BURRATA	2.00	17.00	12.00	f
6960	2387	\N	EAU PET VERRE	1.00	2.20	21.00	t
6961	2387	\N	FANTA	1.00	2.20	21.00	t
6962	2387	\N	PROSECCO VERRE	3.00	6.00	21.00	f
6963	2387	\N	GIN TONIC	5.00	10.00	21.00	f
6964	2387	\N	Cuba-Li	1.00	8.00	21.00	f
6965	2387	\N	BLANC VERRE	3.00	5.00	21.00	f
6966	2387	\N	PECKET FRAISE	5.00	8.00	21.00	t
6969	2390	\N	ICE TEA	2.00	2.20	21.00	t
6970	2390	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
6971	2390	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
6977	2393	\N	DECA	1.00	2.50	21.00	f
6978	2393	\N	ESPRESSO	1.00	2.50	21.00	f
6979	2393	\N	CREME BRULEE	3.00	5.00	12.00	f
6980	2393	\N	COUSCOUS VG	2.00	12.00	12.00	f
6981	2393	\N	COUSCOUS PM	4.00	17.00	12.00	f
6982	2393	\N	PRIMITIVO NR 14	2.00	24.00	21.00	f
6983	2393	\N	BLANC VERRE	1.00	5.00	21.00	f
6987	2396	\N	TAJINE	1.00	17.00	6.00	f
6988	2396	\N	TAJINE	1.00	17.00	6.00	f
7014	2399	\N	Service NILAYA	-1.00	-40.00	0.00	t
7018	2402	\N	ORANGE	-1.00	-28.00	0.00	t
7021	2405	\N	ENERGIES	-1.00	-251.65	0.00	t
7024	2408	\N	CARBURANT	-1.00	-104.73	0.00	t
7027	2411	\N	CREME BRULEE	1.00	5.00	12.00	f
7028	2411	\N	SABAYON	2.00	8.00	12.00	f
7029	2411	\N	RIESLING	2.00	24.00	21.00	f
7030	2411	\N	COUSCOUS VG	2.00	12.00	12.00	f
7031	2411	\N	CHOUCROUTE	1.00	24.00	12.00	f
6854	2361	\N	EAU PET 1/2 L	1.00	0.00	21.00	t
6855	2361	\N	BLANC VERRE	5.00	0.00	21.00	t
6856	2361	\N	BLANC VERRE	2.00	0.00	21.00	t
6857	2361	\N	PROSECCO VERRE	1.00	0.00	21.00	t
6858	2361	\N	VIOLETTE	4.00	0.00	21.00	t
6859	2361	\N	ASSIETTE APERITIVE (2 p.)	2.00	0.00	12.00	t
6860	2361	\N	TAJINE	5.00	0.00	12.00	t
6861	2361	\N	COUSCOUS VG	2.00	0.00	12.00	t
6862	2361	\N	PLAT SPÉCIAL	2.00	35.00	12.00	t
6865	2364	\N	BLANC VERRE	1.00	5.00	21.00	t
6866	2364	\N	FANTA	1.00	2.20	21.00	t
6867	2364	\N	RIVANER	1.00	24.00	21.00	t
6868	2364	\N	COCA	1.00	2.20	21.00	t
6869	2364	\N	PECKET FRAISE	2.00	8.00	21.00	t
6870	2364	\N	CANNELLONI RICO/EPI	1.00	18.00	12.00	t
6871	2364	\N	CANNELLONI VIANDE	1.00	18.00	12.00	t
6872	2364	\N	PÂTES BOLO	1.00	13.00	12.00	t
6873	2364	\N	COUSCOUS PM	1.00	17.00	12.00	t
6874	2364	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
6875	2364	\N	SCAMPIS LUCIFER	1.00	10.00	12.00	t
6878	2367	\N	CARBURANT	-1.00	-97.44	0.00	t
6892	2370	\N	Cuba-Li	2.00	8.00	21.00	t
6893	2370	\N	COUSCOUS PM	1.00	17.00	12.00	t
6894	2370	\N	COUSCOUS VG	1.00	11.00	12.00	t
6899	2373	\N	EQUIPEMENT	-1.00	-48.41	0.00	t
6905	2376	\N	Service Jeff	-1.00	-60.00	0.00	t
6908	2379	\N	NOURRITURE	-1.00	-36.59	0.00	t
6931	2382	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
6932	2382	\N	TAJINE	1.00	17.00	12.00	t
6933	2382	\N	CAPUCCINO	2.00	2.80	21.00	t
6934	2382	\N	CHAMPIGNONS KABYLES	1.00	8.00	12.00	t
6947	2385	\N	RIESLING	1.00	24.00	21.00	t
6948	2385	\N	CHOUCROUTE	2.00	24.00	12.00	t
6967	2388	\N	Service Elise	-1.00	-50.00	0.00	t
6972	2391	\N	COCA ZERO	1.00	2.20	21.00	f
6973	2391	\N	COCA ZERO	1.00	2.20	21.00	f
6974	2391	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
6975	2391	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	f
6984	2394	\N	BLANC VERRE	1.00	4.00	21.00	f
6985	2394	\N	BLANC VERRE	1.00	4.00	21.00	f
6989	2397	\N	CAFÉ	1.00	2.50	21.00	f
6990	2397	\N	COUSCOUS PM	1.00	17.00	12.00	f
6991	2397	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	f
6992	2397	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	f
7015	2400	\N	MANDURIA	1.00	30.00	21.00	t
7016	2400	\N	COUSCOUS PM	2.00	17.00	12.00	t
7019	2403	\N	HOPSEIDON	-1.00	-44.58	0.00	t
7022	2406	\N	ORANGE	-1.00	-14.00	0.00	t
7025	2409	\N	EQUIPEMENT	-1.00	-64.55	0.00	t
7032	2412	\N	SABAYON SPECIAL	2.00	10.00	12.00	f
7033	2412	\N	ROUGE VERRE	1.00	5.00	21.00	f
7034	2412	\N	BLANC VERRE	1.00	5.00	21.00	f
7035	2412	\N	PECKET FRAISE	2.00	8.00	21.00	f
7036	2412	\N	TAJINE	2.00	17.00	12.00	f
7039	2415	\N	NOURRITURE	-1.00	-51.59	0.00	t
7047	2418	\N	BOISSONS	-1.00	-78.00	0.00	t
7065	2421	\N	TRIPLE	2.00	4.50	21.00	t
7066	2421	\N	VIOLETTE	1.00	8.00	21.00	t
7067	2421	\N	ORVAL	1.00	5.00	21.00	t
7068	2421	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
7069	2421	\N	TAJINE	1.00	17.00	12.00	t
7070	2421	\N	CREPE CHAKCHOUKA	1.00	14.00	12.00	t
7089	2424	\N	THÉ MENTHE	1.00	2.50	21.00	f
7090	2424	\N	NERO D'AVOLA	1.00	30.00	21.00	f
7091	2424	\N	FANTA	2.00	2.20	21.00	f
7092	2424	\N	VIOLETTE	1.00	8.00	21.00	f
7093	2424	\N	GINGEMBRE	1.00	10.00	21.00	f
7094	2424	\N	CREME BRULEE	1.00	5.00	12.00	f
7095	2424	\N	SABAYON	1.00	8.00	12.00	f
7096	2424	\N	PÂTES BOLO	1.00	13.00	12.00	f
7097	2424	\N	COUSCOUS PM	2.00	17.00	12.00	f
7110	2427	\N	COUSCOUS PM	5.00	17.00	12.00	t
7111	2427	\N	SCAMPIS LUCIFER	3.00	12.00	12.00	t
7112	2427	\N	SOFT (Verre)	1.00	2.20	21.00	t
7113	2427	\N	PECKET FRAISE	1.00	8.00	21.00	t
7114	2427	\N	MARTINI Blanc/Rouge	1.00	6.00	21.00	t
7115	2427	\N	GINGEMBRE	2.00	10.00	21.00	t
7116	2427	\N	THÉ MENTHE	2.00	2.50	21.00	t
7117	2427	\N	GATEAUX MIEL	3.00	5.00	12.00	t
7118	2427	\N	CREPE	1.00	5.00	12.00	t
7119	2427	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
7122	2430	\N	NOURRITURE	-1.00	-33.65	0.00	t
7125	2433	\N	Service Caro	-1.00	-100.00	0.00	t
7133	2436	\N	NOURRITURE	-1.00	-8.46	0.00	t
7147	2439	\N	CAFÉ	1.00	2.50	21.00	f
7148	2439	\N	COUSCOUS VG	1.00	12.00	12.00	f
7149	2439	\N	CHAKTCHOUKA	1.00	12.00	12.00	f
7150	2439	\N	COCA ZERO	1.00	2.20	21.00	f
7151	2439	\N	COCA	2.00	2.20	21.00	f
7154	2442	\N	HOEGAARDEN ROSEE	1.00	2.00	21.00	f
7155	2442	\N	JUPILER	1.00	2.00	21.00	f
7156	2442	\N	JUPILER	1.00	2.00	21.00	f
7160	2445	\N	PÂTES BOMBE ATOMIQUE+ BURRATA	1.00	17.00	12.00	f
7161	2445	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	f
7162	2445	\N	SCAMPIS LUCIFER	1.00	12.00	12.00	f
7163	2445	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	f
7164	2445	\N	ORVAL	1.00	5.00	21.00	f
7165	2445	\N	COCA	1.00	2.20	21.00	f
7178	2448	\N	CREME BRULEE	2.00	5.00	12.00	t
7179	2448	\N	CREPE CHAKCHOUKA	1.00	14.00	12.00	t
7180	2448	\N	COUSCOUS PM	2.00	17.00	12.00	t
7181	2448	\N	SCAMPIS LUCIFER	1.00	12.00	12.00	t
7182	2448	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	t
7183	2448	\N	VIOLETTE	1.00	8.00	21.00	t
7184	2448	\N	PECKET FRAISE	1.00	8.00	21.00	t
7187	2451	\N	NOURRITURE	-1.00	-10.75	0.00	t
7190	2454	\N	COMPTABLE	-1.00	-326.70	0.00	t
7193	2457	\N	ESPRESSO	1.00	2.50	21.00	t
7194	2457	\N	THÉ MENTHE	2.00	2.50	21.00	t
7195	2457	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	t
7196	2457	\N	CREPE SUCRE	2.00	5.00	12.00	t
7197	2457	\N	CHARDONNAY FIO	1.00	20.00	21.00	t
7198	2457	\N	PROSECCO VERRE	3.00	6.00	21.00	t
7199	2457	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	t
7200	2457	\N	PÂTES BOMBE ATOMIQUE+ BURRATA	1.00	17.00	12.00	t
7201	2457	\N	TAJINE	1.00	17.00	12.00	t
7204	2460	\N	DECA	1.00	2.50	21.00	t
7205	2460	\N	CREME BRULEE	1.00	5.00	12.00	t
7206	2460	\N	FANTA	1.00	2.20	21.00	t
6938	2383	\N	JUPILER	1.00	2.50	21.00	f
6939	2383	\N	BLANC VERRE	1.00	5.00	21.00	f
6940	2383	\N	AMARONE	1.00	50.00	21.00	f
6949	2386	\N	PÂTES BOLO	2.00	13.00	12.00	t
6950	2386	\N	CHOUCROUTE	2.00	24.00	12.00	t
6951	2386	\N	FANTA	1.00	2.20	21.00	t
6952	2386	\N	PROSECCO VERRE	1.00	6.00	21.00	t
6953	2386	\N	GIN TONIC	1.00	10.00	21.00	t
6968	2389	\N	NOURRITURE	-1.00	-96.07	0.00	t
6976	2392	\N	Service JEFF	-1.00	-40.00	0.00	t
6986	2395	\N	NOURRITURE	-1.00	-177.55	0.00	t
6993	2398	\N	SABAYON	1.00	8.00	12.00	f
6994	2398	\N	SPAG.COURGETTE + SCAMPIS	1.00	18.00	12.00	f
6995	2398	\N	COUSCOUS PM	2.00	17.00	12.00	f
6996	2398	\N	PÂTES LARD	1.00	13.00	12.00	f
6997	2398	\N	SPAG.COURGETTE	1.00	14.00	12.00	f
6998	2398	\N	CREPE CHAKCHOUKA	1.00	14.00	12.00	f
6999	2398	\N	CREPE CHAKCHOUKA XXL	1.00	18.00	12.00	f
7000	2398	\N	TAJINE	2.00	17.00	12.00	f
7001	2398	\N	COCA	2.00	2.20	21.00	f
7002	2398	\N	ORVAL	6.00	5.00	21.00	f
7003	2398	\N	PROSECCO VERRE	9.00	6.00	21.00	f
7004	2398	\N	BLONDINETTE	1.00	4.00	21.00	f
7005	2398	\N	TRIPLE	1.00	4.50	21.00	f
7006	2398	\N	CAFÉ	1.00	2.50	21.00	f
7007	2398	\N	THÉ MENTHE	3.00	2.50	21.00	f
7008	2398	\N	CREME BRULEE	2.00	5.00	12.00	f
7009	2398	\N	GLACE	1.00	5.00	12.00	f
7010	2398	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	f
7011	2398	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
7012	2398	\N	VIN 1/2	1.00	13.00	21.00	f
7013	2398	\N	VIOLETTE	1.00	8.00	21.00	f
7017	2401	\N	LOYER	-1.00	-600.00	0.00	t
7020	2404	\N	SODEXO	-1.00	-30.60	0.00	t
7023	2407	\N	SODEXO	-1.00	-30.60	0.00	t
7026	2410	\N	EQUIPEMENT	-1.00	-103.50	0.00	t
7037	2413	\N	MERGUEZ	-1.00	-32.55	0.00	t
7040	2416	\N	PÂTES	1.00	6.00	6.00	f
7041	2416	\N	CORNET BOLO	1.00	6.00	6.00	f
7042	2416	\N	CORNET LARD	1.00	6.00	6.00	f
7048	2419	\N	ESPRESSO	1.00	2.50	21.00	f
7049	2419	\N	CREME BRULEE	1.00	5.00	12.00	f
7050	2419	\N	ROUGE VERRE	2.00	5.00	21.00	f
7051	2419	\N	BURRATA PESTO	1.00	15.00	12.00	f
7052	2419	\N	COUSCOUS VG	1.00	12.00	12.00	f
7071	2422	\N	ICE TEA	2.00	2.20	21.00	f
7072	2422	\N	GATEAUX MIEL	2.00	5.00	12.00	f
7073	2422	\N	CREME BRULEE	1.00	5.00	12.00	f
7074	2422	\N	SABAYON SPECIAL	1.00	10.00	12.00	f
7075	2422	\N	THÉ MENTHE	1.00	2.50	21.00	f
7076	2422	\N	EAU PET 1/2 L	1.00	3.50	21.00	f
7077	2422	\N	PROSECCO VERRE	2.00	6.00	21.00	f
7078	2422	\N	GINGEMBRE	1.00	10.00	21.00	f
7079	2422	\N	COCA ZERO	3.00	2.20	21.00	f
7080	2422	\N	PLAT SPÉCIAL	1.00	15.00	12.00	f
7081	2422	\N	CREPE CREME LARD	1.00	12.00	12.00	f
7082	2422	\N	CREPE GORGONZOLA + COURG.	2.00	14.00	12.00	f
7098	2425	\N	PINOT GRIGIO (2020)	1.00	20.00	21.00	f
7099	2425	\N	ESPRESSO	1.00	2.50	21.00	f
7100	2425	\N	POLPETTE	1.00	16.00	12.00	f
7101	2425	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	f
7102	2425	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	f
7120	2428	\N	MANDURIA	1.00	30.00	21.00	t
7123	2431	\N	COMPTABLE	-1.00	-484.00	0.00	t
7126	2434	\N	NOURRITURE	-1.00	-113.44	0.00	t
7134	2437	\N	THÉ MENTHE	1.00	2.50	21.00	f
7135	2437	\N	RHUM	2.00	6.00	21.00	f
7136	2437	\N	CHOUCROUTE	1.00	24.00	12.00	f
7137	2437	\N	CANNELLONI VIANDE	1.00	18.00	12.00	f
7138	2437	\N	POLPETTE	1.00	16.00	12.00	f
7139	2437	\N	COCA	2.00	2.20	21.00	f
7140	2437	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
7141	2437	\N	RIESLING	2.00	24.00	21.00	f
7152	2440	\N	COUSCOUS PM	1.00	17.00	6.00	f
7157	2443	\N	CORNET BOLO	1.00	6.00	6.00	t
7158	2443	\N	CORNET BOLO	1.00	6.00	6.00	t
7166	2446	\N	AMARETTO	1.00	5.00	21.00	t
7167	2446	\N	CAPUCCINO	1.00	2.80	21.00	t
7168	2446	\N	CREME BRULEE	4.00	5.00	12.00	t
7169	2446	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
7170	2446	\N	SCAMPIS LUCIFER	3.00	12.00	12.00	t
7171	2446	\N	JUPILER	3.00	2.50	21.00	t
7172	2446	\N	Cuba-Li	1.00	8.00	21.00	t
7173	2446	\N	EAU PET 1/2 L	2.00	3.50	21.00	t
7174	2446	\N	POLPETTE	2.00	16.00	12.00	t
7175	2446	\N	PÂTES LARD	1.00	13.00	12.00	t
7176	2446	\N	COUSCOUS PM	1.00	17.00	12.00	t
7185	2449	\N	Service Léa	-1.00	-40.00	0.00	t
7188	2452	\N	SODEXO	-1.00	-30.63	0.00	t
7191	2455	\N	TVA	-1.00	-7.71	0.00	t
7202	2458	\N	NOURRITURE	-1.00	-46.31	0.00	t
7209	2461	\N	EQUIPEMENT	-1.00	-23.09	0.00	t
7222	2464	\N	NERO D'AVOLA	1.00	30.00	21.00	f
7223	2464	\N	CANNELLONI RICO/EPI	2.00	18.00	12.00	f
7224	2464	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	f
7225	2464	\N	SCAMPIS LUCIFER	1.00	12.00	12.00	f
7226	2464	\N	PECKET FRAISE	2.00	8.00	21.00	f
7231	2467	\N	SODEXO	-1.00	-30.60	0.00	t
7366	2515	\N	Service Victor	-1.00	-50.00	0.00	t
7370	2518	\N	VAL DIEU	1.00	4.00	21.00	f
7376	2521	\N	COCA ZERO	4.00	2.20	21.00	f
7381	2524	\N	ROUGE VERRE	1.00	5.00	21.00	f
7385	2527	\N	BLONDINETTE	4.00	4.00	21.00	f
7386	2527	\N	VAL DIEU	3.00	4.00	21.00	f
7389	2530	\N	RHUM	1.00	6.00	21.00	f
7390	2530	\N	VAL DIEU	1.00	4.00	21.00	f
7391	2530	\N	PROSECCO VERRE	1.00	6.00	21.00	f
7394	2533	\N	BLONDINETTE	1.00	4.00	21.00	f
7398	2536	\N	EAU PET VERRE	1.00	2.20	21.00	t
7399	2536	\N	COCA	1.00	2.20	21.00	t
7406	2539	\N	CAFÉ	1.00	2.50	21.00	f
7407	2539	\N	PECKET FRAISE	1.00	8.00	21.00	f
7408	2539	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
7418	2542	\N	TRIPLE	1.00	4.50	21.00	f
7419	2542	\N	JUPILER	1.00	2.50	21.00	f
7428	2545	\N	PROSECCO Bouteille	3.00	25.00	21.00	f
7436	2548	\N	Service Jeff	-1.00	-60.00	0.00	t
7442	2551	\N	CREME BRULEE	1.00	5.00	6.00	t
7443	2551	\N	GATEAUX MIEL	1.00	0.00	6.00	t
7444	2551	\N	CORNET LARD	1.00	6.00	6.00	t
7038	2414	\N	NOURRITURE	-1.00	-18.19	0.00	t
7043	2417	\N	BLANC VERRE	1.00	5.00	21.00	f
7044	2417	\N	BLONDINETTE	1.00	0.00	21.00	f
7045	2417	\N	BLONDINETTE	1.00	4.00	21.00	f
7046	2417	\N	BLONDINETTE	1.00	4.00	21.00	f
7053	2420	\N	BLANC VERRE	1.00	5.00	21.00	f
7054	2420	\N	THÉ MENTHE	4.00	2.50	21.00	f
7055	2420	\N	SABAYON	1.00	8.00	12.00	f
7056	2420	\N	PINOT GRIGIO (2020)	2.00	20.00	21.00	f
7057	2420	\N	Cuba-Li	4.00	8.00	21.00	f
7058	2420	\N	VIOLETTE	1.00	8.00	21.00	f
7059	2420	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	f
7060	2420	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
7061	2420	\N	SPAG.COURGETTE	1.00	14.00	12.00	f
7062	2420	\N	BURRATA PESTO	1.00	15.00	12.00	f
7063	2420	\N	PÂTES	1.00	15.00	12.00	f
7064	2420	\N	COUSCOUS PM	1.00	17.00	12.00	f
7083	2423	\N	ICE TEA	1.00	2.20	21.00	f
7084	2423	\N	COCA	2.00	2.20	21.00	f
7085	2423	\N	COUSCOUS PM	1.00	17.00	12.00	f
7086	2423	\N	COUSCOUS VG	1.00	12.00	12.00	f
7087	2423	\N	SCAMPIS LUCIFER	1.00	12.00	12.00	f
7088	2423	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	f
7103	2426	\N	PÂTES SCAMPIS	2.00	17.00	12.00	f
7104	2426	\N	POLPETTE	1.00	16.00	12.00	f
7105	2426	\N	COUSCOUS PM	1.00	17.00	12.00	f
7106	2426	\N	EAU PET 1/2 L	1.00	3.50	21.00	f
7107	2426	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
7108	2426	\N	THÉ MENTHE	1.00	2.50	21.00	f
7109	2426	\N	CREME BRULEE	4.00	5.00	12.00	f
7121	2429	\N	NOURRITURE	-1.00	-8.00	0.00	t
7124	2432	\N	CADEAU CARO	-1.00	-230.00	0.00	t
7127	2435	\N	ROUGE VERRE	1.00	5.00	21.00	t
7128	2435	\N	ESPRESSO	1.00	2.50	21.00	t
7129	2435	\N	BLANC VERRE	1.00	5.00	21.00	t
7130	2435	\N	BURRATA PESTO	1.00	15.00	12.00	t
7131	2435	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
7132	2435	\N	CHAKTCHOUKA	1.00	12.00	12.00	t
7142	2438	\N	ROUGE VERRE	2.00	5.00	21.00	t
7143	2438	\N	CAFÉ	2.00	2.50	21.00	t
7144	2438	\N	CANNELLONI VIANDE	2.00	18.00	12.00	t
7145	2438	\N	PROSECCO VERRE	2.00	6.00	21.00	t
7146	2438	\N	CHARDONNAY FIO	1.00	20.00	21.00	t
7153	2441	\N	BOISSONS	-1.00	-151.37	0.00	t
7159	2444	\N	CORNET BOLO	1.00	6.00	6.00	f
7177	2447	\N	Service Léa	-1.00	-40.00	0.00	t
7186	2450	\N	NOURRITURE	-1.00	-78.27	0.00	t
7189	2453	\N	FRAIS	-1.00	-127.81	0.00	t
7192	2456	\N	BULEX	-1.00	-296.77	0.00	t
7203	2459	\N	NOURRITURE	-1.00	-26.00	0.00	t
7210	2462	\N	GLACE	1.00	5.00	12.00	t
7211	2462	\N	PESTO + BURRATA	1.00	15.00	12.00	t
7212	2462	\N	CHAKTCHOUKA	1.00	15.00	12.00	t
7213	2462	\N	FANTA	1.00	2.20	21.00	t
7214	2462	\N	COCA	1.00	2.20	21.00	t
7227	2465	\N	CREME BRULEE	1.00	5.00	12.00	f
7228	2465	\N	ROUGE VERRE	3.00	5.00	21.00	f
7229	2465	\N	CANNELLONI RICO/EPI	1.00	18.00	12.00	f
7445	2551	\N	COUSCOUS PM	1.00	17.00	6.00	t
7450	2554	\N	CAFÉ	1.00	2.50	21.00	f
7451	2554	\N	CREME BRULEE	1.00	5.00	12.00	f
7452	2554	\N	COUSCOUS PM	1.00	17.00	12.00	f
7453	2554	\N	ROUGE 1/4	1.00	8.00	21.00	f
7454	2554	\N	ROUGE VERRE	3.00	5.00	21.00	f
7458	2557	\N	EVRARD	-1.00	-39.00	0.00	t
7461	2560	\N	BOISSONS	-1.00	-171.00	0.00	t
7467	2563	\N	CORNET BOLO	1.00	6.00	6.00	t
7476	2566	\N	Service Jeff	-1.00	-40.00	0.00	t
7479	2569	\N	BOISSONS	-1.00	-72.08	0.00	t
7494	2572	\N	BLUSH	2.00	20.00	21.00	f
7510	2575	\N	Service Jeff	-1.00	-60.00	0.00	t
7534	2578	\N	Service Charlotte	-1.00	-25.00	0.00	t
7537	2581	\N	EVRARD	-1.00	-26.10	0.00	t
7542	2584	\N	COCA	2.00	2.20	21.00	f
7543	2584	\N	CORNET TRUFFE	1.00	7.00	6.00	f
7548	2587	\N	PNEUS (4)	-1.00	-328.70	0.00	t
7551	2590	\N	COCA	1.00	2.20	21.00	t
7552	2590	\N	ICE TEA	2.00	2.20	21.00	t
7553	2590	\N	COUSCOUS PM	1.00	17.00	6.00	t
7556	2593	\N	CAFÉ	1.00	2.00	21.00	t
7557	2593	\N	CANNELLONI VIANDE	1.00	18.00	12.00	t
7571	2596	\N	CREME BRULEE	1.00	5.00	12.00	t
7572	2596	\N	CHAKTCHOUKA	1.00	12.00	12.00	t
7573	2596	\N	CREPE KABYLE	1.00	12.00	12.00	t
7574	2596	\N	COUSCOUS VG	1.00	12.00	12.00	t
7575	2596	\N	BLANC VERRE	1.00	5.00	21.00	t
7576	2596	\N	FANTA	1.00	2.20	21.00	t
7585	2599	\N	HOEGAARDEN ROSEE	1.00	2.50	21.00	t
7586	2599	\N	CONTRE FILET+GRATIN	1.00	24.00	12.00	t
7587	2599	\N	BLUSH	1.00	20.00	21.00	t
7590	2602	\N	COUSCOUS PM	2.00	17.00	6.00	t
7593	2605	\N	ENERGIES	-1.00	-311.55	0.00	t
7596	2608	\N	JUPILER	1.00	2.50	21.00	t
7597	2608	\N	CORNET BOLO	1.00	6.00	6.00	t
7609	2611	\N	BOISSONS	-1.00	-83.13	0.00	t
7612	2614	\N	NOURRITURE	-1.00	-46.08	0.00	t
7616	2616	\N	JUPILER	1.00	2.50	21.00	f
7617	2616	\N	CREME BRULEE	2.00	5.00	12.00	f
7618	2616	\N	CANNELLONI RICO/EPI	1.00	18.00	12.00	f
7619	2616	\N	COUSCOUS PM	3.00	17.00	12.00	f
7620	2616	\N	ROUGE 1/4	1.00	8.00	21.00	f
7621	2616	\N	COCA ZERO	1.00	2.20	21.00	f
7622	2616	\N	COCA	2.00	2.20	21.00	f
7623	2616	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
7624	2617	\N	NOURRITURE	-1.00	-41.96	0.00	t
7630	2619	\N	GIN 0%	1.00	8.00	21.00	t
7631	2619	\N	BOMBE ATOMIQUE+ BURRATA	1.00	17.00	12.00	t
7632	2619	\N	COUSCOUS PM	1.00	17.00	12.00	t
7633	2619	\N	ICE TEA	1.00	2.20	21.00	t
7634	2620	\N	IRISH COFFEE	1.00	8.00	21.00	t
7635	2620	\N	THÉ MENTHE	1.00	2.50	21.00	t
7636	2620	\N	TAJINE	1.00	17.00	12.00	t
7637	2620	\N	COUSCOUS PM	1.00	17.00	12.00	t
7638	2620	\N	Cuba-Li	1.00	8.00	21.00	t
7639	2620	\N	PINOT GRIGIO	1.00	20.00	21.00	t
7651	2622	\N	EAU PET VERRE	1.00	2.20	21.00	t
7652	2622	\N	PROSECCO VERRE	1.00	6.00	21.00	t
7653	2622	\N	COUSCOUS PM	4.00	17.00	12.00	t
7654	2622	\N	NOËL (BRUNE)	2.00	4.00	21.00	t
7655	2622	\N	IRISH COFFEE	1.00	8.00	21.00	t
7656	2622	\N	CREME BRULEE	3.00	5.00	12.00	t
7207	2460	\N	COCA ZERO	1.00	2.20	21.00	t
7208	2460	\N	CANNELLONI RICO/EPI	2.00	18.00	12.00	t
7215	2463	\N	COUSCOUS PM	1.00	17.00	12.00	f
7216	2463	\N	TAJINE	2.00	17.00	12.00	f
7217	2463	\N	BLANC VERRE	2.00	5.00	21.00	f
7218	2463	\N	ICE TEA	1.00	2.20	21.00	f
7219	2463	\N	FANTA	1.00	2.20	21.00	f
7220	2463	\N	THÉ MENTHE	1.00	2.50	21.00	f
7221	2463	\N	ESPRESSO	3.00	2.50	21.00	f
7230	2466	\N	Service Léa	-1.00	-40.00	0.00	t
7468	2564	\N	CORNET BOLO	1.00	6.00	6.00	f
7477	2567	\N	NOURRITURE	-1.00	-47.13	0.00	t
7480	2570	\N	COCA	2.00	2.20	21.00	f
7481	2570	\N	EAU PET 1/2 L	1.00	3.50	21.00	f
7482	2570	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
7483	2570	\N	LASAGNE DU BOUCHER	2.00	15.00	12.00	f
7484	2570	\N	COUSCOUS PM	2.00	17.00	12.00	f
7485	2570	\N	JUPILER	3.00	2.50	21.00	f
7486	2570	\N	ICE TEA	1.00	2.20	21.00	f
7487	2570	\N	FANTA	2.00	2.20	21.00	f
7488	2570	\N	COCA ZERO	2.00	2.20	21.00	f
7489	2570	\N	COCA	1.00	2.20	21.00	f
7495	2573	\N	CANNELLONI VIANDE	1.00	18.00	12.00	t
7496	2573	\N	TAJINE	1.00	17.00	12.00	t
7497	2573	\N	COUSCOUS PM	2.00	17.00	12.00	t
7498	2573	\N	CONTRE FILET+GRATIN	1.00	24.00	12.00	t
7499	2573	\N	PESTO + BURRATA	1.00	15.00	12.00	t
7500	2573	\N	ICE TEA	1.00	2.20	21.00	t
7501	2573	\N	FANTA	2.00	2.20	21.00	t
7502	2573	\N	COCA ZERO	2.00	2.20	21.00	t
7503	2573	\N	COCA	1.00	2.20	21.00	t
7504	2573	\N	GATEAUX MIEL	1.00	5.00	12.00	t
7505	2573	\N	CREME BRULEE	1.00	5.00	12.00	t
7506	2573	\N	THÉ MENTHE	5.00	2.50	21.00	t
7511	2576	\N	COCA ZERO	1.00	2.20	21.00	t
7512	2576	\N	ESPRESSO	1.00	2.50	21.00	t
7513	2576	\N	COCA	3.00	2.20	21.00	t
7514	2576	\N	CAPUCCINO	1.00	2.80	21.00	t
7515	2576	\N	CAFÉ	1.00	2.50	21.00	t
7516	2576	\N	THÉ MENTHE	1.00	2.50	21.00	t
7517	2576	\N	CREME BRULEE	2.00	5.00	12.00	t
7518	2576	\N	SABAYON SPECIAL	2.00	10.00	12.00	t
7519	2576	\N	GLACE	5.00	5.00	12.00	t
7520	2576	\N	COUSCOUS PM	1.00	17.00	12.00	t
7521	2576	\N	CREPE TRUFFES BURRATA	1.00	14.00	12.00	t
7522	2576	\N	TAJINE	2.00	17.00	12.00	t
7523	2576	\N	CONTRE FILET+GRATIN	1.00	24.00	12.00	t
7524	2576	\N	CREPE KABYLE	2.00	12.00	12.00	t
7525	2576	\N	PÂTES LARD	2.00	13.00	12.00	t
7526	2576	\N	PÂTES BOLO	3.00	13.00	12.00	t
7527	2576	\N	GINGEMBRE	1.00	10.00	21.00	t
7528	2576	\N	VIOLETTE	5.00	8.00	21.00	t
7529	2576	\N	ICE TEA	1.00	2.20	21.00	t
7530	2576	\N	FANTA	1.00	2.20	21.00	t
7531	2576	\N	PROSECCO VERRE	5.00	6.00	21.00	t
7532	2576	\N	CREPE CREME LARD	1.00	12.00	12.00	t
7535	2579	\N	NOURRITURE	-1.00	-36.79	0.00	t
7538	2582	\N	TAJINE	1.00	17.00	12.00	f
7544	2585	\N	BLUSH	1.00	20.00	21.00	f
7545	2585	\N	CORNET LARD	1.00	6.00	6.00	f
7549	2588	\N	NOURRITURE	-1.00	-85.00	0.00	t
7554	2591	\N	TAJINE	1.00	17.00	6.00	t
7558	2594	\N	COCA	1.00	2.20	21.00	f
7559	2594	\N	ESPRESSO	2.00	2.50	21.00	f
7560	2594	\N	PRIMITIVO NR 14	5.00	20.00	21.00	f
7561	2594	\N	PINOT GRIGIO	3.00	20.00	21.00	f
7562	2594	\N	BLANC VERRE	4.00	5.00	21.00	f
7563	2594	\N	ICE TEA	1.00	2.20	21.00	f
7564	2594	\N	FANTA	1.00	2.20	21.00	f
7565	2594	\N	COCA ZERO	2.00	2.20	21.00	f
7566	2594	\N	JUPILER	1.00	2.50	21.00	f
7567	2594	\N	CANNELLONI VIANDE	1.00	18.00	12.00	f
7568	2594	\N	COUSCOUS PM	3.00	17.00	12.00	f
7577	2597	\N	PINOT GRIGIO	1.00	20.00	21.00	t
7578	2597	\N	COUSCOUS PM	1.00	17.00	12.00	t
7579	2597	\N	TAJINE	1.00	17.00	12.00	t
7580	2597	\N	PECKET FRAISE	1.00	8.00	21.00	t
7581	2597	\N	PROSECCO VERRE	1.00	6.00	21.00	t
7588	2600	\N	Service Léa	-1.00	-40.00	0.00	t
7591	2603	\N	Service Marie	-1.00	-24.00	0.00	t
7594	2606	\N	ORANGE	-1.00	-14.40	0.00	t
7598	2609	\N	CAFÉ	5.00	2.50	21.00	t
7599	2609	\N	BOMBE ATOMIQUE+ BURRATA	2.00	17.00	12.00	t
7600	2609	\N	COUSCOUS PM	4.00	17.00	12.00	t
7601	2609	\N	SCAMPIS LUCIFER	1.00	12.00	12.00	t
7602	2609	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	t
7603	2609	\N	PRIMITIVO NR 14	2.00	24.00	21.00	t
7604	2609	\N	CHARDONNAY FIO	1.00	20.00	21.00	t
7605	2609	\N	PECKET FRAISE	1.00	8.00	21.00	t
7606	2609	\N	PROSECCO VERRE	1.00	6.00	21.00	t
7607	2609	\N	DEFERLANTE	1.00	4.00	21.00	t
7610	2612	\N	NOURRITURE	-1.00	-77.32	0.00	t
7613	2615	\N	CANNELLONI RICO/EPI	2.00	18.00	12.00	f
7614	2615	\N	ICE TEA	2.00	2.20	21.00	f
7625	2618	\N	BLUSH	1.00	20.00	21.00	f
7626	2618	\N	TAJINE	1.00	17.00	12.00	f
7627	2618	\N	COUSCOUS PM	1.00	17.00	12.00	f
7628	2618	\N	GINGEMBRE	1.00	10.00	21.00	f
7629	2618	\N	VIOLETTE	1.00	8.00	21.00	f
7640	2621	\N	SABAYON	1.00	8.00	12.00	f
7641	2621	\N	DECA	1.00	2.50	21.00	f
7642	2621	\N	CREME BRULEE	1.00	5.00	12.00	f
7643	2621	\N	LIMONCELLO	1.00	5.00	21.00	f
7644	2621	\N	CHARDONNAY FIO	1.00	20.00	21.00	f
7645	2621	\N	TRUFFE + BURRATA	1.00	17.00	12.00	f
7646	2621	\N	COUSCOUS PM	2.00	17.00	12.00	f
7647	2621	\N	COCA	1.00	2.20	21.00	f
7648	2621	\N	VIOLETTE	2.00	8.00	21.00	f
7649	2621	\N	CHAMPIGNONS KABYLES	2.00	10.00	12.00	f
7650	2621	\N	SCAMPIS LUCIFER	1.00	12.00	12.00	f
7657	2622	\N	BIERE AUTRE	1.00	4.00	21.00	t
7658	2622	\N	TRIPLE	1.00	4.50	21.00	t
7659	2623	\N	EAU PÉTILLANTE 1 L	3.00	5.00	21.00	t
7660	2623	\N	ICE TEA	1.00	2.20	21.00	f
7661	2623	\N	COCA ZERO	5.00	2.20	21.00	f
7662	2623	\N	Cuba-Li	1.00	8.00	21.00	t
7663	2623	\N	PECKET FRAISE	2.00	8.00	21.00	f
7664	2623	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
7665	2623	\N	COUSCOUS PM	5.00	17.00	12.00	t
7666	2623	\N	TAJINE	2.00	17.00	12.00	f
7667	2623	\N	CHAKTCHOUKA	2.00	12.00	12.00	t
7668	2623	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	t
7669	2623	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
7670	2623	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	f
7671	2623	\N	ESPRESSO	3.00	2.50	21.00	f
7672	2623	\N	THÉ MENTHE	4.00	2.50	21.00	f
7673	2623	\N	CHARDONNAY FIO	3.00	20.00	21.00	f
7685	2626	\N	CAPUCCINO	1.00	2.80	21.00	f
7686	2626	\N	THÉ MENTHE	1.00	2.50	21.00	f
7687	2626	\N	CREME BRULEE	1.00	5.00	12.00	f
7688	2626	\N	SABAYON	1.00	8.00	12.00	f
7689	2626	\N	NERO D'AVOLA	1.00	30.00	21.00	f
7690	2626	\N	CANNELLONI VIANDE	1.00	18.00	12.00	f
7691	2626	\N	PÂTES	1.00	12.00	12.00	f
7692	2626	\N	PESTO + BURRATA	1.00	15.00	12.00	f
7693	2626	\N	COUSCOUS PM	1.00	17.00	12.00	f
7694	2626	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
7695	2626	\N	Cuba-Li	4.00	8.00	21.00	f
7713	2629	\N	PRIMITIVO NR 14	1.00	12.00	21.00	t
7714	2629	\N	COUSCOUS PM	2.00	17.00	12.00	t
7715	2629	\N	BLANC VERRE	2.00	5.00	21.00	t
7716	2629	\N	ESPRESSO	1.00	2.50	21.00	t
7726	2632	\N	CARBURANT	-1.00	-101.94	0.00	t
7729	2635	\N	Service Maurine	-1.00	-60.00	0.00	t
7732	2638	\N	SODEXO	-1.00	-30.60	0.00	t
7735	2641	\N	TAJINE	2.00	17.00	12.00	t
7736	2641	\N	ROUGE VERRE	2.00	5.00	21.00	t
7755	2644	\N	DECA	1.00	2.50	21.00	t
7756	2644	\N	CAFÉ	1.00	2.50	21.00	t
7757	2644	\N	ROUGE VERRE	1.00	5.00	21.00	t
7758	2644	\N	BLANC VERRE	3.00	5.00	21.00	t
7759	2644	\N	PÂTES TRUFFE	1.00	15.00	12.00	t
7760	2644	\N	TAJINE	1.00	17.00	12.00	t
7767	2647	\N	Taxes Liège	-1.00	-220.00	0.00	t
7770	2650	\N	Taxes Liège	-1.00	-46.35	0.00	t
7773	2653	\N	Taxes Liège	-1.00	-69.25	0.00	t
7776	2656	\N	GLACE	1.00	5.00	12.00	t
7777	2656	\N	TRUFFE + BURRATA	1.00	17.00	12.00	t
7778	2656	\N	COUSCOUS VG	1.00	12.00	12.00	t
7779	2656	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
7789	2659	\N	PECKET FRAISE	1.00	8.00	21.00	f
7790	2659	\N	CHOUFFE COFFEE	2.00	5.00	21.00	f
7791	2659	\N	VENTAJOL (CÔTES DE RHÔNES)	2.00	24.00	21.00	f
7792	2659	\N	COURGETTE + SCAMPIS+BURRATA	1.00	18.00	12.00	f
7793	2659	\N	CANNELLONI VIANDE	1.00	18.00	12.00	f
7794	2659	\N	COUSCOUS PM	1.00	17.00	12.00	f
7795	2659	\N	PINOT GRIGIO	1.00	20.00	21.00	f
7818	2662	\N	NOURRITURE	-1.00	-5.00	0.00	t
7831	2665	\N	Service Léa	-1.00	-40.00	0.00	t
7834	2668	\N	EVRARD	-1.00	-45.76	0.00	t
7838	2671	\N	ROSÉ VERRE	2.00	5.00	21.00	t
7839	2671	\N	PINOT GRIGIO	1.00	5.00	21.00	t
7851	2674	\N	CAFÉ	1.00	2.50	21.00	f
7852	2674	\N	VENTAJOL (CÔTES DE RHÔNES)	1.00	24.00	21.00	f
7853	2674	\N	DECA	1.00	2.50	21.00	f
7856	2677	\N	MANDURIA	1.00	30.00	21.00	f
7857	2677	\N	VENTAJOL (CÔTES DE RHÔNES)	1.00	24.00	21.00	f
7858	2677	\N	BLANC VERRE	1.00	5.00	21.00	f
7859	2677	\N	PINOT GRIGIO	7.00	20.00	21.00	f
7860	2677	\N	JUPILER	5.00	2.50	21.00	f
7861	2677	\N	PECKET FRAISE	5.00	8.00	21.00	f
7862	2677	\N	ASSIETTE APERITIVE (2 p.)	3.00	19.00	12.00	f
7863	2677	\N	CHAMPIGNONS KABYLES	3.00	10.00	12.00	f
7867	2680	\N	BLANC VERRE	1.00	5.00	21.00	t
7868	2680	\N	ROUGE VERRE	2.00	5.00	21.00	t
7869	2680	\N	CHAKTCHOUKA	1.00	12.00	12.00	t
7870	2680	\N	COURGETTE + SCAMPIS	1.00	18.00	12.00	t
7871	2680	\N	COUSCOUS PM	1.00	17.00	12.00	t
7872	2680	\N	Cuba-Li	1.00	8.00	21.00	t
7873	2680	\N	GINGEMBRE	1.00	10.00	21.00	t
7888	2683	\N	COCA ZERO	1.00	2.20	21.00	t
7889	2683	\N	TAJINE	1.00	17.00	12.00	t
7890	2683	\N	COUSCOUS PM	1.00	17.00	12.00	t
7902	2686	\N	DECA	1.00	2.50	21.00	t
7903	2686	\N	PECKET FRAISE	1.00	8.00	21.00	t
7904	2686	\N	NERO D'AVOLA	1.00	30.00	21.00	t
7905	2686	\N	COUSCOUS PM	2.00	17.00	12.00	t
7906	2686	\N	SCAMPIS LUCIFER	1.00	12.00	12.00	t
7907	2686	\N	GINGEMBRE	1.00	10.00	21.00	t
7908	2686	\N	PROSECCO VERRE	1.00	6.00	21.00	t
7909	2686	\N	SABAYON SPECIAL	1.00	10.00	12.00	t
7912	2689	\N	NOURRITURE	-1.00	-37.38	0.00	t
7921	2692	\N	POLPETTE	1.00	16.00	12.00	f
7922	2692	\N	PÂTES BOLO	1.00	13.00	12.00	f
7923	2692	\N	BLANC VERRE	2.00	5.00	21.00	f
7924	2692	\N	ROUGE VERRE	2.00	5.00	21.00	f
7925	2692	\N	ROSÉ VERRE	1.00	5.00	21.00	f
7926	2692	\N	COCA	2.00	2.20	21.00	f
7931	2695	\N	NOURRITURE	-1.00	-78.74	0.00	t
7934	2698	\N	LASAGNE DU BOUCHER	1.00	15.00	12.00	f
7935	2698	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	f
7936	2698	\N	ROUGE VERRE	1.00	5.00	21.00	f
7937	2698	\N	ROUGE 1/2	1.00	14.00	21.00	f
7944	2701	\N	DAMBIERMONT	-1.00	-723.44	0.00	t
7947	2704	\N	ORANGE	-1.00	-28.00	0.00	t
7950	2707	\N	CARBURANT	-1.00	-50.04	0.00	t
7953	2710	\N	Service Marie	-1.00	-108.44	0.00	t
7957	2713	\N	ICE TEA	1.00	2.20	21.00	t
7958	2713	\N	COCA ZERO	2.00	2.20	21.00	t
7959	2713	\N	PESTO + BURRATA	1.00	15.00	12.00	t
7960	2713	\N	TRUFFE + BURRATA	1.00	17.00	12.00	t
7961	2713	\N	PÂTES BOLO	1.00	13.00	12.00	t
7970	2716	\N	COUSCOUS PM	4.00	17.00	6.00	t
7973	2719	\N	IRISH COFFEE	1.00	8.00	21.00	t
7974	2719	\N	CREME BRULEE	1.00	5.00	12.00	t
7975	2719	\N	NERO D'AVOLA	1.00	30.00	21.00	t
7976	2719	\N	COUSCOUS PM	1.00	17.00	12.00	t
7977	2719	\N	POLPETTE	1.00	16.00	12.00	t
7991	2722	\N	Service Victor	-1.00	-40.00	0.00	t
7994	2725	\N	FRAISE 1L	40.00	11.00	21.00	f
8002	2728	\N	BLUSH	1.00	20.00	21.00	t
8003	2728	\N	PÂTES BOLO	2.00	13.00	12.00	t
8004	2728	\N	TAJINE	2.00	17.00	12.00	t
8005	2728	\N	COUSCOUS PM	1.00	17.00	12.00	t
8006	2728	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
8007	2728	\N	PROSECCO VERRE	3.00	6.00	21.00	t
8008	2728	\N	ICE TEA	2.00	2.20	21.00	t
8009	2728	\N	IRISH COFFEE	1.00	8.00	21.00	t
8010	2728	\N	GLACE	1.00	0.00	12.00	t
8011	2728	\N	CREME BRULEE	1.00	5.00	12.00	t
7674	2624	\N	CREME BRULEE	1.00	5.00	12.00	f
7675	2624	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	f
7676	2624	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
7677	2624	\N	COUSCOUS PM	1.00	17.00	12.00	f
7678	2624	\N	TAJINE	2.00	17.00	12.00	f
7679	2624	\N	VIOLETTE	3.00	8.00	21.00	f
7696	2627	\N	JUPILER	1.00	2.50	21.00	t
7697	2627	\N	COCA ZERO	1.00	2.20	21.00	t
7698	2627	\N	CREPE GORGONZOLA + COURG.	1.00	14.00	12.00	t
7699	2627	\N	CONTRE FILET+GRATIN	1.00	24.00	12.00	t
7700	2627	\N	CANNELLONI VIANDE	1.00	18.00	12.00	t
7701	2627	\N	COUSCOUS PM	1.00	17.00	12.00	t
7702	2627	\N	PECKET FRAISE	2.00	8.00	21.00	t
7703	2627	\N	ORVAL	4.00	5.00	21.00	t
7704	2627	\N	GLACE	2.00	5.00	12.00	t
7705	2627	\N	GATEAUX MIEL	1.00	5.00	12.00	t
7706	2627	\N	THÉ MENTHE	1.00	2.50	21.00	t
7717	2630	\N	Service Elise	-1.00	-30.00	0.00	t
7727	2633	\N	CARBURANT	-1.00	-106.06	0.00	t
7730	2636	\N	ORANGE	-1.00	-14.40	0.00	t
7733	2639	\N	Café Angèle	-1.00	-40.00	0.00	t
7737	2642	\N	FANTA	1.00	2.20	21.00	t
7738	2642	\N	ICE TEA	1.00	2.20	21.00	t
7739	2642	\N	ORVAL	1.00	5.00	21.00	t
7740	2642	\N	BLONDINETTE	1.00	4.00	21.00	t
7741	2642	\N	PROSECCO VERRE	5.00	6.00	21.00	t
7742	2642	\N	BLANC VERRE	1.00	5.00	21.00	t
7761	2645	\N	COCA	1.00	2.20	21.00	t
7762	2645	\N	FANTA	1.00	2.20	21.00	t
7763	2645	\N	COCA ZERO	1.00	2.20	21.00	t
7764	2645	\N	ICE TEA	1.00	2.20	21.00	t
7765	2645	\N	4 FROMAGES	2.00	6.00	6.00	t
7768	2648	\N	Taxes Liège	-1.00	-40.08	0.00	t
7771	2651	\N	Taxes Liège	-1.00	-46.74	0.00	t
7774	2654	\N	Taxes Liège	-1.00	-69.83	0.00	t
7780	2657	\N	JUPILER	1.00	2.00	21.00	t
7796	2660	\N	GLACE	1.00	5.00	12.00	t
7797	2660	\N	CREME BRULEE	1.00	5.00	12.00	t
7798	2660	\N	TRIPLE	1.00	4.50	21.00	t
7799	2660	\N	APEROL SPRITZ	1.00	8.00	21.00	t
7800	2660	\N	ICE TEA	2.00	2.20	21.00	t
7801	2660	\N	FANTA	1.00	2.20	21.00	t
7802	2660	\N	PÂTES LARD	1.00	13.00	12.00	t
7803	2660	\N	CHAKTCHOUKA	2.00	12.00	12.00	t
7804	2660	\N	POLPETTE	2.00	16.00	12.00	t
7805	2660	\N	ROUGE VERRE	2.00	5.00	21.00	t
7819	2663	\N	NOURRITURE	-1.00	-21.62	0.00	t
7832	2666	\N	Service Maurine	-1.00	-60.00	0.00	t
7835	2669	\N	JUPILER	1.00	2.50	21.00	t
7836	2669	\N	COUSCOUS PM	1.00	17.00	12.00	t
7840	2672	\N	AMARONE	1.00	50.00	21.00	f
7854	2675	\N	COUSCOUS PM	4.00	17.00	6.00	f
7864	2678	\N	BLUSH	1.00	20.00	21.00	f
7874	2681	\N	CHARDONNAY FIO	1.00	20.00	21.00	t
7875	2681	\N	COUSCOUS VG	2.00	12.00	12.00	t
7876	2681	\N	PÂTES SCAMPIS	2.00	17.00	12.00	t
7877	2681	\N	SCAMPIS LUCIFER	1.00	12.00	12.00	t
7878	2681	\N	CHAKTCHOUKA	3.00	12.00	12.00	t
7879	2681	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	t
7880	2681	\N	ICE TEA	2.00	2.20	21.00	t
7881	2681	\N	PROSECCO VERRE	2.00	6.00	21.00	t
7882	2681	\N	GINGEMBRE	1.00	10.00	21.00	t
7883	2681	\N	VIOLETTE	1.00	8.00	21.00	t
7884	2681	\N	TRUFFE + BURRATA	1.00	17.00	12.00	t
7891	2684	\N	SABAYON	1.00	8.00	12.00	t
7892	2684	\N	CREME BRULEE	1.00	5.00	12.00	t
7893	2684	\N	PECKET FRAISE	2.00	8.00	21.00	t
7894	2684	\N	BOMBE ATOMIQUE+ BURRATA	1.00	17.00	12.00	t
7895	2684	\N	TRUFFE + BURRATA	1.00	17.00	12.00	t
7910	2687	\N	NOURRITURE	-1.00	-31.03	0.00	t
7913	2690	\N	POULET	-1.00	-87.50	0.00	t
7927	2693	\N	COCA	1.00	2.20	21.00	f
7928	2693	\N	PÂTES LARD	1.00	13.00	12.00	f
7929	2693	\N	CHARDONNAY FIO	1.00	20.00	21.00	f
7932	2696	\N	NOURRITURE	-1.00	-80.94	0.00	t
7938	2699	\N	BOISSONS	-1.00	-269.00	0.00	t
7945	2702	\N	BOISSONS	-1.00	-199.83	0.00	t
7948	2705	\N	ENERGIES	-1.00	-311.55	0.00	t
7951	2708	\N	Service Marie	-1.00	-56.81	0.00	t
7954	2711	\N	MERGUEZ	-1.00	-32.35	0.00	t
7962	2714	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	f
7963	2714	\N	COCA	1.00	2.20	21.00	f
7964	2714	\N	BLUSH	6.00	20.00	21.00	f
7965	2714	\N	CANNELLONI RICO/EPI	1.00	18.00	12.00	f
7966	2714	\N	CANNELLONI VIANDE	1.00	18.00	12.00	f
7967	2714	\N	COUSCOUS PM	1.00	17.00	12.00	f
7968	2714	\N	TAJINE	1.00	17.00	12.00	f
7971	2717	\N	BLONDINETTE	4.00	4.00	21.00	t
7978	2720	\N	ROUGE 1/4	2.00	8.00	21.00	t
7979	2720	\N	COCA ZERO	2.00	2.20	21.00	t
7980	2720	\N	PECKET FRAISE	2.00	8.00	21.00	t
7981	2720	\N	PROSECCO VERRE	2.00	6.00	21.00	t
7982	2720	\N	LASAGNE DU BOUCHER	2.00	15.00	12.00	t
7992	2723	\N	NOURRITURE	-1.00	-40.73	0.00	t
7995	2726	\N	FRAISE 1L	35.00	10.00	21.00	f
8012	2729	\N	Service Victor	-1.00	-30.00	0.00	t
8015	2732	\N	CAFÉ	2.00	2.50	21.00	t
8016	2732	\N	CREPE TRUFFES BURRATA	1.00	14.00	12.00	t
8017	2732	\N	PESTO + BURRATA	1.00	15.00	12.00	t
8020	2735	\N	AG ASSURANCE	-1.00	-168.61	0.00	t
8023	2738	\N	CORNET TRUFFE	1.00	7.00	6.00	f
8026	2741	\N	COCA	2.00	2.20	21.00	t
8027	2741	\N	PÂTES BOLO	2.00	13.00	6.00	t
8039	2744	\N	COCA ZERO	2.00	2.20	21.00	t
8040	2744	\N	ICE TEA	1.00	2.20	21.00	t
8041	2744	\N	FANTA	2.00	2.20	21.00	t
8042	2744	\N	PECKET FRAISE	2.00	8.00	21.00	t
8043	2744	\N	TAJINE	2.00	17.00	12.00	t
8044	2744	\N	COUSCOUS VG	1.00	12.00	12.00	t
8045	2744	\N	POLPETTE	1.00	10.00	12.00	t
8046	2744	\N	COUSCOUS	1.00	10.00	12.00	t
8067	2747	\N	Service Carol	-1.00	-50.00	0.00	t
8070	2750	\N	POULET	-1.00	-87.50	0.00	t
8076	2753	\N	BLANC VERRE	3.00	5.00	21.00	t
8077	2753	\N	PÂTES BOLO	1.00	13.00	6.00	t
8093	2756	\N	EAU PET VERRE	1.00	2.20	21.00	t
8094	2756	\N	ICE TEA	1.00	2.20	21.00	t
8095	2756	\N	BLONDINETTE	1.00	4.00	21.00	t
8096	2756	\N	DEFERLANTE	1.00	4.00	21.00	t
8097	2756	\N	JUPILER	4.00	2.50	21.00	t
8104	2759	\N	JUPILER	2.00	2.50	21.00	t
7680	2625	\N	AMARETTO	2.00	5.00	21.00	t
7681	2625	\N	CREME BRULEE	1.00	5.00	12.00	t
7682	2625	\N	PÂTES TRUFFE	1.00	15.00	12.00	t
7683	2625	\N	CONTRE FILET+GRATIN	1.00	24.00	12.00	t
7684	2625	\N	PECKET FRAISE	4.00	8.00	21.00	t
7707	2628	\N	ROUGE VERRE	1.00	5.00	21.00	f
7708	2628	\N	CONTRE FILET+GRATIN	1.00	24.00	12.00	f
7709	2628	\N	COURGETTE + SCAMPIS	1.00	18.00	12.00	f
7710	2628	\N	CAFÉ	1.00	2.50	21.00	f
7711	2628	\N	PRIMITIVO NR 14	1.00	12.00	21.00	f
7712	2628	\N	PROSECCO VERRE	1.00	6.00	21.00	f
7718	2631	\N	PLAT SPÉCIAL	1.00	18.00	12.00	t
7719	2631	\N	CREPE CREME LARD	1.00	12.00	12.00	t
7720	2631	\N	CREPE GORGONZOLA + COURG.	2.00	14.00	12.00	t
7721	2631	\N	ICE TEA	1.00	2.20	21.00	t
7722	2631	\N	FANTA	1.00	2.20	21.00	t
7723	2631	\N	COCA ZERO	2.00	2.20	21.00	t
7724	2631	\N	SABAYON	1.00	8.00	12.00	t
7725	2631	\N	GLACE	3.00	5.00	12.00	t
7728	2634	\N	CARBURANT	-1.00	-109.01	0.00	t
7731	2637	\N	ORANGE	-1.00	-28.00	0.00	t
7734	2640	\N	CORNET BOLO	1.00	6.00	6.00	t
7743	2643	\N	COCA ZERO	1.00	2.20	21.00	t
7744	2643	\N	CAPUCCINO	3.00	2.80	21.00	t
7745	2643	\N	CAFÉ	3.00	2.50	21.00	t
7746	2643	\N	IRISH COFFEE	1.00	8.00	21.00	t
7747	2643	\N	SABAYON	4.00	8.00	12.00	t
7748	2643	\N	ROUGE VERRE	1.00	5.00	21.00	t
7749	2643	\N	BLANC VERRE	1.00	5.00	21.00	t
7750	2643	\N	BLONDINETTE	1.00	4.00	21.00	t
7751	2643	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	t
7752	2643	\N	CANNELLONI RICO/EPI	2.00	18.00	12.00	t
7753	2643	\N	CANNELLONI VIANDE	2.00	18.00	12.00	t
7754	2643	\N	COUSCOUS PM	6.00	17.00	12.00	t
7766	2646	\N	HUILE GUGLIELMI	1.00	10.00	6.00	t
7769	2649	\N	Taxes Liège	-1.00	-59.20	0.00	t
7772	2652	\N	Taxes Liège	-1.00	-50.99	0.00	t
7775	2655	\N	Taxes Liège	-1.00	-76.18	0.00	t
7781	2658	\N	IRISH COFFEE	1.00	8.00	21.00	t
7782	2658	\N	AMARETTO	1.00	5.00	21.00	t
7783	2658	\N	SABAYON	1.00	8.00	12.00	t
7784	2658	\N	GLACE	1.00	5.00	12.00	t
7785	2658	\N	VENTAJOL (CÔTES DE RHÔNES)	1.00	24.00	21.00	t
7786	2658	\N	TAJINE	1.00	17.00	12.00	t
7787	2658	\N	COUSCOUS PM	1.00	17.00	12.00	t
7788	2658	\N	PROSECCO VERRE	4.00	6.00	21.00	t
7806	2661	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
7807	2661	\N	TRUFFE + BURRATA	1.00	17.00	12.00	t
7808	2661	\N	HOEGAARDEN ROSEE	2.00	2.50	21.00	t
7809	2661	\N	JUPILER	2.00	2.50	21.00	t
7810	2661	\N	ROSÉ VERRE	3.00	5.00	21.00	t
7811	2661	\N	ICE TEA	2.00	2.20	21.00	t
7812	2661	\N	GINGEMBRE	1.00	10.00	21.00	t
7813	2661	\N	GRAPPA	1.00	5.00	21.00	t
7814	2661	\N	THÉ MENTHE	1.00	2.50	21.00	t
7815	2661	\N	SABAYON	1.00	8.00	12.00	t
7816	2661	\N	ORVAL	1.00	5.00	21.00	t
7817	2661	\N	CANNELLONI VIANDE	2.00	18.00	12.00	t
7820	2664	\N	ESPRESSO	1.00	2.50	21.00	f
7821	2664	\N	IRISH COFFEE	1.00	8.00	21.00	f
7822	2664	\N	CREME BRULEE	1.00	5.00	12.00	f
7823	2664	\N	SABAYON	4.00	8.00	12.00	f
7824	2664	\N	BOMBE ATOMIQUE+ BURRATA	2.00	17.00	12.00	f
7825	2664	\N	COUSCOUS PM	4.00	17.00	12.00	f
7826	2664	\N	PRIMITIVO NR 14	2.00	24.00	21.00	f
7827	2664	\N	PECKET FRAISE	4.00	8.00	21.00	f
7828	2664	\N	CHARDONNAY FIO	2.00	20.00	21.00	f
7829	2664	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	f
7830	2664	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
7833	2667	\N	NOURRITURE	-1.00	-196.00	0.00	t
7837	2670	\N	BLUSH	2.00	5.00	21.00	t
7841	2673	\N	EAU PET 1/2 L	1.00	3.50	21.00	f
7842	2673	\N	EAU PÉTILLANTE 1 L	2.00	5.00	21.00	f
7843	2673	\N	COCA ZERO	1.00	2.20	21.00	f
7844	2673	\N	COCA	1.00	2.20	21.00	f
7845	2673	\N	PRIMITIVO NR 14	3.00	24.00	21.00	f
7846	2673	\N	VENTAJOL (CÔTES DE RHÔNES)	3.00	24.00	21.00	f
7847	2673	\N	COURGETTE + SCAMPIS	1.00	18.00	12.00	f
7848	2673	\N	COURGETTE + SCAMPIS+BURRATA	4.00	22.00	12.00	f
7849	2673	\N	COUSCOUS PM	7.00	17.00	12.00	f
7850	2673	\N	TAJINE	1.00	17.00	12.00	f
7855	2676	\N	BLUSH	1.00	20.00	21.00	t
7865	2679	\N	COUSCOUS PM	2.00	17.00	12.00	t
7866	2679	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
7885	2682	\N	HOEGAARDEN ROSEE	1.00	2.00	21.00	f
7886	2682	\N	JUPILER	2.00	2.00	21.00	f
7887	2682	\N	CORNET BOLO	1.00	6.00	6.00	f
7896	2685	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	f
7897	2685	\N	JUPILER	1.00	2.50	21.00	f
7898	2685	\N	SCAMPIS LUCIFER	1.00	12.00	12.00	f
7899	2685	\N	PINOT GRIGIO	1.00	20.00	21.00	f
7900	2685	\N	TRUFFE + BURRATA	1.00	17.00	12.00	f
7901	2685	\N	COUSCOUS PM	1.00	17.00	12.00	f
7911	2688	\N	NOURRITURE	-1.00	-49.45	0.00	t
7914	2691	\N	CONTRE FILET+GRATIN	2.00	24.00	12.00	t
7915	2691	\N	CREME BRULEE	1.00	5.00	12.00	t
7916	2691	\N	GLACE	1.00	5.00	12.00	t
7917	2691	\N	IRISH COFFEE	1.00	8.00	21.00	t
7918	2691	\N	COCA ZERO	2.00	2.20	21.00	t
7919	2691	\N	ROUGE 1/4	2.00	8.00	21.00	t
7920	2691	\N	PROSECCO VERRE	4.00	6.00	21.00	t
7930	2694	\N	LOYER	-1.00	-600.00	0.00	t
7933	2697	\N	CORNET BOLO	1.00	6.00	6.00	f
7939	2700	\N	CAFÉ	1.00	2.50	21.00	f
7940	2700	\N	BLANC VERRE	2.00	5.00	21.00	f
7941	2700	\N	PECKET FRAISE	1.00	8.00	21.00	f
7942	2700	\N	PÂTES PESTO	1.00	14.00	12.00	f
7943	2700	\N	CREPE BASE + BURRATA	1.00	12.00	12.00	f
7946	2703	\N	SODEXO	-1.00	-30.60	0.00	t
7949	2706	\N	Poches Fraise	-1.00	-126.65	0.00	t
7952	2709	\N	Service Marie	-1.00	-107.39	0.00	t
7955	2712	\N	CORNET BOLO	2.00	6.00	6.00	t
7956	2712	\N	JUPILER	8.00	2.00	21.00	t
7969	2715	\N	PECKET FRAISE	2.00	8.00	21.00	f
7972	2718	\N	PECKET FRAISE	2.00	8.00	21.00	f
7983	2721	\N	EAU PET VERRE	1.00	2.20	21.00	f
7984	2721	\N	COCA	1.00	2.20	21.00	f
7985	2721	\N	COCA ZERO	1.00	2.20	21.00	f
7986	2721	\N	ROSÉ VERRE	4.00	5.00	21.00	f
7987	2721	\N	CAPUCCINO	1.00	2.80	21.00	f
7988	2721	\N	CAFÉ	2.00	2.50	21.00	f
7989	2721	\N	CONTRE FILET+GRATIN	2.00	24.00	12.00	f
7990	2721	\N	POLPETTE	1.00	16.00	12.00	f
7993	2724	\N	EVRARD	-1.00	-48.00	0.00	t
7996	2727	\N	CORNET LARD	1.00	6.00	6.00	t
7997	2727	\N	PÂTES LARD	1.00	13.00	12.00	t
7998	2727	\N	PÂTES TRUFFE	1.00	15.00	12.00	t
7999	2727	\N	PECKET FRAISE	2.00	8.00	21.00	t
8000	2727	\N	PROSECCO VERRE	3.00	6.00	21.00	t
8001	2727	\N	BLANC VERRE	1.00	5.00	21.00	t
8013	2730	\N	CARBURANT	-1.00	-99.69	0.00	t
8018	2733	\N	NOURRITURE	-1.00	-7.36	0.00	t
8021	2736	\N	NOURRITURE	-1.00	-90.30	0.00	t
8024	2739	\N	PROSECCO VERRE	3.00	6.00	21.00	f
8028	2742	\N	THÉ MENTHE	1.00	2.50	21.00	t
8029	2742	\N	JUPILER	1.00	2.50	21.00	t
8030	2742	\N	BLUSH	1.00	5.00	21.00	t
8031	2742	\N	TAJINE	1.00	17.00	12.00	t
8032	2742	\N	COUSCOUS PM	1.00	17.00	12.00	t
8033	2742	\N	BEIGNETS FLEUR DE COURGETTES	1.00	18.00	12.00	t
8047	2745	\N	COCA ZERO	1.00	2.20	21.00	t
8048	2745	\N	ROUGE VERRE	2.00	5.00	21.00	t
8049	2745	\N	CONTRE FILET+GRATIN	1.00	24.00	12.00	t
8050	2745	\N	COUSCOUS PM	1.00	17.00	12.00	t
8051	2745	\N	EAU PET 1/2 L	1.00	3.50	21.00	t
8052	2745	\N	PECKET FRAISE	2.00	8.00	21.00	t
8053	2745	\N	PROSECCO VERRE	3.00	6.00	21.00	t
8068	2748	\N	FRAISE 1L	1.00	11.00	21.00	f
8071	2751	\N	NOURRITURE	-1.00	-10.33	0.00	t
8078	2754	\N	CAFÉ	1.00	2.50	21.00	f
8079	2754	\N	NERO D'AVOLA	1.00	30.00	21.00	f
8080	2754	\N	COUSCOUS PM	3.00	17.00	12.00	f
8098	2757	\N	BLONDINETTE	1.00	4.00	21.00	t
8099	2757	\N	JUPILER	1.00	2.50	21.00	t
8100	2757	\N	Cuba-Li	3.00	8.00	21.00	t
8106	2760	\N	SOFT (Verre)	1.00	2.20	21.00	f
8107	2760	\N	RICARD	3.00	5.00	21.00	f
8117	2763	\N	Service ERIC	-1.00	-50.00	0.00	t
8124	2766	\N	POLPETTE	2.00	16.00	12.00	t
8125	2766	\N	COCA ZERO	1.00	0.00	21.00	t
8126	2766	\N	CAFÉ	1.00	0.00	21.00	t
8127	2766	\N	CONTRE FILET+GRATIN	1.00	24.00	12.00	t
8128	2766	\N	ROUGE VERRE	1.00	5.00	21.00	t
8129	2766	\N	ICE TEA	1.00	2.20	21.00	t
8130	2766	\N	COCA	1.00	2.20	21.00	t
8131	2766	\N	LASAGNE DU BOUCHER	1.00	15.00	12.00	t
8134	2769	\N	NOURRITURE	-1.00	-101.36	0.00	t
8137	2772	\N	SABAYON SPECIAL	1.00	10.00	12.00	t
8138	2772	\N	COCA ZERO	4.00	2.20	21.00	t
8139	2772	\N	SPARE RIBS	1.00	18.00	21.00	t
8140	2772	\N	BEIGNETS FLEUR DE COURGETTES	1.00	18.00	12.00	t
10172	3421	\N	GIN 0%	1.00	8.00	21.00	f
10176	3424	\N	CAFÉ	2.00	2.50	21.00	f
10179	3427	\N	EAU PET 1/2 L	1.00	3.50	21.00	f
10180	3427	\N	VAL DIEU	2.00	4.00	21.00	f
10181	3427	\N	BLUSH	5.00	20.00	21.00	f
10185	3430	\N	PRIMITIVO NR 14	1.00	20.00	21.00	f
10186	3430	\N	CORNET BOLO	5.00	5.00	6.00	f
10190	3433	\N	FORFAIT	52.00	5.00	6.00	t
10193	3436	\N	Service Elise	-1.00	-150.00	0.00	t
10196	3439	\N	TEMPO-TEAM	-1.00	-97.16	0.00	t
10199	3442	\N	ENERGIES	-1.00	-303.21	0.00	t
10209	3445	\N	MANDURIA	1.00	5.00	21.00	t
10210	3445	\N	VAL DIEU	3.00	4.00	21.00	t
10214	3448	\N	PÂTES COURGETTE	1.00	14.00	12.00	t
10215	3448	\N	CRÊPE GORGONZOLA COURGETTES	1.00	14.00	12.00	t
10216	3448	\N	PÂTES CREME LARDONS	1.00	14.00	12.00	t
10217	3448	\N	PÂTES BOMBE ATOMIQUE + BURRATA	1.00	17.00	12.00	t
10218	3448	\N	TAJINE	1.00	17.00	12.00	t
10219	3448	\N	PRIMITIVO NR 14	1.00	5.00	21.00	t
10220	3448	\N	PECKET FRAISE	1.00	8.00	21.00	t
10221	3448	\N	VIOLETTE	1.00	8.00	21.00	t
10222	3448	\N	PINOT GRIGIO	1.00	20.00	21.00	t
10225	3451	\N	NOURRITURE	-1.00	-116.01	0.00	t
10236	3454	\N	CHARDONNAY FIO	1.00	20.00	21.00	f
10237	3454	\N	PÂTES CREME LARDONS	2.00	14.00	12.00	f
10238	3454	\N	PÂTES BOMBE ATOMIQUE + BURRATA	1.00	17.00	12.00	f
10239	3454	\N	PÂTES COURGETTE + SCAMPIS	2.00	18.00	12.00	f
10240	3454	\N	TAJINE	1.00	17.00	12.00	f
10241	3454	\N	ASSORTIMENT CROQUETTES	1.00	20.00	6.00	f
10242	3454	\N	PECKET FRAISE	2.00	8.00	21.00	f
10243	3454	\N	COUSCOUS PM	2.00	17.00	12.00	f
10248	3457	\N	PÂTES SCAMPIS	2.00	17.00	12.00	t
10249	3457	\N	COCA	1.00	2.20	21.00	t
10267	3460	\N	GLACE	1.00	5.00	12.00	t
10268	3460	\N	CREME BRULEE	1.00	5.00	12.00	t
10269	3460	\N	PÂTES	1.00	8.00	12.00	t
10270	3460	\N	COUSCOUS VG	1.00	12.00	12.00	t
10271	3460	\N	MANDURIA	1.00	30.00	21.00	t
10277	3463	\N	SABAYON SPECIAL	2.00	10.00	12.00	t
10278	3463	\N	CHARDONNAY FIO	2.00	20.00	21.00	t
10279	3463	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	t
10280	3463	\N	TAJINE	1.00	17.00	12.00	t
10281	3463	\N	COUSCOUS PM	2.00	17.00	12.00	t
10301	3466	\N	Service ANTON	-1.00	-70.00	0.00	t
10304	3469	\N	Service CHA	-1.00	-20.00	0.00	t
10308	3472	\N	Service Elise	-1.00	-45.00	0.00	t
10311	3475	\N	NOURRITURE	-1.00	-71.06	0.00	t
10322	3478	\N	MERGUEZ	-1.00	-33.30	0.00	t
10325	3481	\N	COUSCOUS PM	2.00	17.00	12.00	t
10326	3481	\N	JUPILER	1.00	2.50	21.00	t
10327	3481	\N	COCA	1.00	2.20	21.00	t
10334	3484	\N	Service Maurine	-1.00	-50.00	0.00	t
10337	3487	\N	CARBURANT	-1.00	-100.92	0.00	t
10340	3490	\N	ORANGE	-1.00	-28.00	0.00	t
10343	3493	\N	CARBURANT	-1.00	-376.50	0.00	t
10352	3496	\N	CREME BRULEE	1.00	6.00	12.00	t
10353	3496	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
10354	3496	\N	TRIPLE	1.00	4.50	21.00	t
10355	3496	\N	PROSECCO VERRE	3.00	6.00	21.00	t
10356	3496	\N	COUSCOUS PM	2.00	17.00	12.00	t
10357	3496	\N	COUSCOUS VG	1.00	12.00	12.00	t
10358	3496	\N	PÂTES TRUFFE + BURRATA	1.00	18.00	12.00	t
10359	3496	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	t
10360	3496	\N	CHAKTCHOUKA	1.00	12.00	12.00	t
10361	3496	\N	SCAMPIS LUCIFER	2.00	12.00	12.00	t
10374	3499	\N	SABAYON	1.00	8.00	12.00	t
10375	3499	\N	CREME BRULEE	1.00	6.00	12.00	t
10376	3499	\N	VIANDE + GRATIN	1.00	24.00	12.00	t
8014	2731	\N	CARBURANT	-1.00	-94.34	0.00	t
8019	2734	\N	ORANGE	-1.00	-14.40	0.00	t
8022	2737	\N	NOURRITURE	-1.00	-37.82	0.00	t
8025	2740	\N	NOURRITURE	-1.00	-64.00	0.00	t
8034	2743	\N	COCA ZERO	1.00	2.20	21.00	t
8035	2743	\N	VAL DIEU	2.00	4.00	21.00	t
8036	2743	\N	BLONDINETTE	5.00	4.00	21.00	t
8037	2743	\N	PECKET FRAISE	2.00	8.00	21.00	t
8038	2743	\N	RICARD	1.00	6.00	21.00	t
8054	2746	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	f
8055	2746	\N	MANDURIA	2.00	30.00	21.00	f
8056	2746	\N	SABAYON	1.00	8.00	12.00	f
8057	2746	\N	CHARDONNAY FIO	1.00	20.00	21.00	f
8058	2746	\N	THÉ MENTHE	3.00	2.50	21.00	f
8059	2746	\N	GATEAUX MIEL	2.00	5.00	12.00	f
8060	2746	\N	CREME BRULEE	2.00	5.00	12.00	f
8061	2746	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
8062	2746	\N	CHAMPIGNONS KABYLES	2.00	10.00	12.00	f
8063	2746	\N	PÂTES LARD	1.00	13.00	12.00	f
8064	2746	\N	TRUFFE + BURRATA	1.00	17.00	12.00	f
8065	2746	\N	COURGETTE + SCAMPIS	2.00	18.00	12.00	f
8066	2746	\N	TAJINE	4.00	17.00	12.00	f
8069	2749	\N	BOISSONS	-1.00	-144.00	0.00	t
8072	2752	\N	CREME BRULEE	1.00	5.00	12.00	f
8073	2752	\N	PÂTES BOLO	1.00	13.00	12.00	f
8074	2752	\N	ROUGE VERRE	1.00	5.00	21.00	f
8075	2752	\N	PECKET FRAISE	1.00	8.00	21.00	f
8081	2755	\N	CREME BRULEE	2.00	5.00	12.00	t
8082	2755	\N	IRISH COFFEE	6.00	8.00	21.00	t
8083	2755	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
8084	2755	\N	NERO D'AVOLA	1.00	30.00	21.00	t
8085	2755	\N	BLANC VERRE	1.00	5.00	21.00	t
8086	2755	\N	ORVAL	5.00	5.00	21.00	t
8087	2755	\N	CANNELLONI RICO/EPI	1.00	18.00	12.00	t
8088	2755	\N	BOMBE ATOMIQUE+ BURRATA	1.00	17.00	12.00	t
8089	2755	\N	TAJINE	1.00	17.00	12.00	t
8090	2755	\N	COUSCOUS PM	4.00	17.00	12.00	t
8091	2755	\N	DEFERLANTE	1.00	4.00	21.00	t
8092	2755	\N	VAL DIEU	9.00	4.00	21.00	t
8101	2758	\N	BLANCOCA	1.00	5.00	21.00	t
8102	2758	\N	RICARD	2.00	6.00	21.00	t
8103	2758	\N	SOFT (Verre)	1.00	2.20	21.00	t
8108	2761	\N	CÔTES DE RHÔNES	3.00	24.00	21.00	f
8109	2761	\N	PECKET FRAISE	1.00	8.00	21.00	f
8110	2761	\N	BLUSH	4.00	20.00	21.00	f
8111	2761	\N	ORVAL	1.00	5.00	21.00	f
8112	2761	\N	BOMBE ATOMIQUE+ BURRATA	1.00	17.00	12.00	f
8113	2761	\N	CANNELLONI RICO/EPI	1.00	18.00	12.00	f
8114	2761	\N	COURGETTE + SCAMPIS	1.00	18.00	12.00	f
8115	2761	\N	COUSCOUS PM	2.00	17.00	12.00	f
8118	2764	\N	PROSECCO VERRE	1.00	6.00	21.00	t
8119	2764	\N	PECKET FRAISE	2.00	8.00	21.00	t
8132	2767	\N	Service Léa	-1.00	-40.00	0.00	t
8135	2770	\N	NOURRITURE	-1.00	-34.83	0.00	t
10173	3422	\N	EAU PET VERRE	2.00	2.20	21.00	f
10177	3425	\N	COCA ZERO	1.00	2.20	21.00	f
10182	3428	\N	COUSCOUS PM	2.00	17.00	12.00	t
10187	3431	\N	Cuba-Li	3.00	8.00	21.00	t
10188	3431	\N	BIERE AUTRE	1.00	2.50	21.00	t
10191	3434	\N	COCHON	-1.00	-145.63	0.00	t
10194	3437	\N	Service ANTON	-1.00	-150.00	0.00	t
10197	3440	\N	TEMPO-TEAM	-1.00	-109.66	0.00	t
10200	3443	\N	POULET	-1.00	-87.50	0.00	t
10211	3446	\N	CHAMPIGNONS KABYLES	1.00	10.00	6.00	t
10212	3446	\N	COUSCOUS PM	3.00	17.00	6.00	t
10223	3449	\N	NOURRITURE	-1.00	-17.67	0.00	t
10226	3452	\N	CHARDONNAY FIO	1.00	20.00	21.00	t
10227	3452	\N	PÂTES	1.00	10.00	12.00	t
10228	3452	\N	COUSCOUS	1.00	10.00	12.00	t
10229	3452	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
10230	3452	\N	COUSCOUS PM	1.00	17.00	12.00	t
10231	3452	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
10232	3452	\N	ICE TEA	1.00	2.20	21.00	t
10233	3452	\N	COCA ZERO	1.00	2.20	21.00	t
10234	3452	\N	PROSECCO VERRE	2.00	6.00	21.00	t
10244	3455	\N	VAL DIEU	1.00	4.00	21.00	t
10250	3458	\N	CREME BRULEE	2.00	5.00	12.00	t
10251	3458	\N	BLANC VERRE	1.00	5.00	21.00	t
10252	3458	\N	COCA ZERO	1.00	2.20	21.00	t
10253	3458	\N	CRÊPE CHAKCHOUKA XXL	1.00	18.00	12.00	t
10254	3458	\N	PÂTES STRACIATELLA SCAMPIS	1.00	19.00	12.00	t
10255	3458	\N	VIOLETTE	1.00	8.00	21.00	t
10256	3458	\N	PECKET FRAISE	1.00	8.00	21.00	t
10272	3461	\N	ROUGE VERRE	2.00	5.00	21.00	t
10273	3461	\N	PÂTES RAGÙ	2.00	15.00	12.00	t
10282	3464	\N	CREME BRULEE	2.00	5.00	12.00	f
10283	3464	\N	TIRAMISU GLACÉ	3.00	6.00	12.00	f
10284	3464	\N	CAFÉ	2.00	2.50	21.00	f
10285	3464	\N	ESPRESSO	4.00	2.50	21.00	f
10286	3464	\N	COCA	1.00	2.20	21.00	f
10287	3464	\N	COCA ZERO	1.00	2.20	21.00	f
10288	3464	\N	COUSCOUS PM	1.00	17.00	12.00	f
10289	3464	\N	CRÊPE GORGONZOLA COURGETTES	1.00	14.00	12.00	f
10290	3464	\N	COUSCOUS VG	3.00	12.00	12.00	f
10291	3464	\N	CANNELLONI VIANDE	3.00	18.00	12.00	f
10292	3464	\N	TAJINE	2.00	17.00	12.00	f
10293	3464	\N	CHAKTCHOUKA	1.00	12.00	12.00	f
10294	3464	\N	CHAMPIGNONS KABYLES	2.00	10.00	12.00	f
10295	3464	\N	ASSORTIMENT CROQUETTES	2.00	20.00	6.00	f
10296	3464	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	f
10297	3464	\N	BIERE AUTRE	4.00	2.50	21.00	f
10298	3464	\N	VAL DIEU	6.00	4.00	21.00	f
10299	3464	\N	ICE TEA	4.00	2.20	21.00	f
10302	3467	\N	Service HANAË	-1.00	-70.00	0.00	t
10305	3470	\N	CANNELLONI VIANDE	1.00	18.00	12.00	f
10306	3470	\N	COUSCOUS PM	2.00	17.00	12.00	f
10309	3473	\N	Nettoyage	-1.00	-14.98	0.00	t
10312	3476	\N	ROUGE VERRE	2.00	5.00	21.00	t
10313	3476	\N	TRIPLE	1.00	4.50	21.00	t
10314	3476	\N	ORVAL	1.00	5.00	21.00	t
10315	3476	\N	CRÊPE KABYLE	1.00	14.00	12.00	t
10316	3476	\N	COUSCOUS PM	1.00	17.00	12.00	t
10317	3476	\N	TAJINE	1.00	17.00	12.00	t
10323	3479	\N	NOURRITURE	-1.00	-9.60	0.00	t
10328	3482	\N	ICE TEA	1.00	2.20	21.00	t
10329	3482	\N	COCA	1.00	2.20	21.00	t
10330	3482	\N	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	t
10331	3482	\N	COUSCOUS PM	1.00	17.00	12.00	t
10335	3485	\N	NOURRITURE	-1.00	-21.25	0.00	t
8105	2759	\N	Cuba-Li	3.00	8.00	21.00	t
8116	2762	\N	ROSÉ VERRE	2.00	5.00	21.00	t
8120	2765	\N	TAJINE	2.00	17.00	12.00	t
8121	2765	\N	CHAKTCHOUKA	1.00	12.00	12.00	t
8122	2765	\N	BLANC VERRE	1.00	5.00	21.00	t
8123	2765	\N	ROUGE VERRE	3.00	5.00	21.00	t
8133	2768	\N	CONTRE FILET+GRATIN	2.00	24.00	12.00	t
8136	2771	\N	NOURRITURE	-1.00	-5.00	0.00	t
8141	2773	\N	NOURRITURE	-1.00	-27.63	0.00	t
8142	2774	\N	CORNET BOLO	2.00	6.00	6.00	t
8143	2775	\N	ROSÉ VERRE	4.00	5.00	21.00	f
8144	2776	\N	ROSÉ VERRE	3.00	5.00	21.00	t
8145	2776	\N	JUPILER	2.00	2.50	21.00	t
8146	2777	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	t
8147	2777	\N	SABAYON	1.00	8.00	12.00	t
8148	2777	\N	BOMBE ATOMIQUE+ BURRATA	1.00	17.00	12.00	t
8149	2777	\N	LASAGNE DU BOUCHER	1.00	15.00	12.00	t
8150	2777	\N	ROUGE VERRE	2.00	5.00	21.00	t
8151	2777	\N	PECKET FRAISE	2.00	8.00	21.00	t
8152	2778	\N	BLONDINETTE	2.00	4.00	21.00	t
8153	2778	\N	ROSÉ VERRE	2.00	5.00	21.00	t
8154	2779	\N	Service Carol	-1.00	-55.00	0.00	t
8155	2780	\N	BLONDINETTE	1.00	4.00	21.00	t
8156	2780	\N	ROSÉ VERRE	5.00	5.00	21.00	t
8157	2781	\N	FORFAIT	3.00	50.00	12.00	t
8158	2781	\N	MANDURIA	1.00	30.00	21.00	t
8159	2781	\N	CAFÉ	1.00	2.50	21.00	t
8160	2781	\N	COCA	2.00	2.20	21.00	t
8161	2781	\N	ROSÉ VERRE	2.00	5.00	21.00	t
8162	2781	\N	VAL DIEU	1.00	4.00	21.00	t
8163	2781	\N	ROUGE VERRE	2.00	5.00	21.00	t
8164	2782	\N	FRAIS	-1.00	-375.00	0.00	t
8165	2783	\N	FRAIS	-1.00	-150.00	0.00	t
8166	2784	\N	CAFÉ	1.00	2.50	21.00	t
8167	2784	\N	FORFAIT	4.00	50.00	12.00	t
8168	2784	\N	EAU PET 1/2 L	1.00	3.50	21.00	t
8169	2784	\N	COCA	1.00	2.20	21.00	t
8170	2784	\N	BLANC 1/2	2.00	13.00	21.00	t
8171	2784	\N	NERO D'AVOLA	1.00	30.00	21.00	t
8172	2784	\N	THÉ MENTHE	2.00	2.50	21.00	t
8173	2784	\N	Cuba-Li	1.00	8.00	21.00	t
8174	2784	\N	PECKET FRAISE	2.00	8.00	21.00	t
8175	2784	\N	VIOLETTE	1.00	8.00	21.00	t
8176	2785	\N	IRISH COFFEE	1.00	8.00	21.00	t
8177	2785	\N	FANTA	2.00	2.20	21.00	t
8178	2785	\N	COCA	3.00	2.20	21.00	t
8179	2785	\N	ROSÉ VERRE	8.00	5.00	21.00	t
8180	2785	\N	FORFAIT	1.00	50.00	12.00	t
8181	2786	\N	VIOLETTE	1.00	8.00	21.00	f
8182	2786	\N	PROSECCO VERRE	1.00	6.00	21.00	f
8183	2786	\N	COCA ZERO	2.00	2.20	21.00	f
8184	2786	\N	JUPILER	1.00	2.50	21.00	f
8185	2786	\N	ARANCELLO	1.00	10.00	21.00	f
8186	2786	\N	AMARETTO	1.00	5.00	21.00	f
8187	2786	\N	BLANC VERRE	1.00	5.00	21.00	f
8188	2786	\N	Cuba-Li	3.00	8.00	21.00	f
8189	2787	\N	CAFÉ	5.00	2.50	21.00	f
8190	2787	\N	PINOT GRIGIO	2.00	20.00	21.00	f
8191	2787	\N	FORFAIT	4.00	50.00	12.00	f
8192	2787	\N	ICE TEA	1.00	2.20	21.00	f
8193	2787	\N	Cuba-Li	2.00	8.00	21.00	f
8194	2787	\N	AMARETTO	1.00	5.00	21.00	f
8195	2787	\N	ARANCELLO	1.00	10.00	21.00	f
8196	2787	\N	JUPILER	1.00	2.50	21.00	f
8197	2787	\N	GINGEMBRE	1.00	10.00	21.00	f
8198	2787	\N	PROSECCO VERRE	3.00	6.00	21.00	f
8199	2787	\N	VIOLETTE	4.00	8.00	21.00	f
8200	2787	\N	COCA ZERO	1.00	2.20	21.00	f
8201	2788	\N	PROSECCO Bouteille	1.00	20.00	21.00	t
8202	2789	\N	COCA	2.00	2.20	21.00	t
8203	2789	\N	PÂTES TRUFFE	1.00	15.00	12.00	t
8204	2789	\N	TRUFFE + BURRATA	1.00	17.00	12.00	t
8205	2790	\N	COMPTABLE	-1.00	-454.99	0.00	t
8206	2791	\N	COMPTABLE	-1.00	-381.15	0.00	t
8207	2792	\N	NOURRITURE	-1.00	-42.57	0.00	t
8208	2793	\N	ORVAL	2.00	5.00	21.00	t
8209	2793	\N	COUSCOUS PM	1.00	17.00	12.00	t
8210	2793	\N	SPAG.COURGETTE	1.00	14.00	12.00	t
8211	2793	\N	PÂTES LARD	1.00	13.00	12.00	t
8212	2794	\N	BLANC VERRE	2.00	5.00	21.00	t
8213	2794	\N	FANTA	1.00	2.20	21.00	t
8214	2794	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
8215	2794	\N	PÂTES PESTO	1.00	14.00	12.00	t
8216	2795	\N	LIMONCELLO	1.00	5.00	21.00	f
8217	2795	\N	IRISH COFFEE	1.00	8.00	21.00	f
8218	2795	\N	CREME BRULEE	2.00	5.00	12.00	f
8219	2795	\N	PINOT GRIGIO	1.00	20.00	21.00	f
8220	2795	\N	PROSECCO VERRE	2.00	6.00	21.00	f
8221	2795	\N	PECKET FRAISE	2.00	8.00	21.00	f
8222	2795	\N	SPARE RIBS	2.00	18.00	21.00	f
8223	2796	\N	COCA	2.00	2.20	21.00	t
8224	2796	\N	PESTO + BURRATA	1.00	15.00	12.00	t
8225	2797	\N	BULLES 0%	1.00	6.00	21.00	t
8226	2797	\N	ROSÉ VERRE	3.00	5.00	21.00	t
8227	2798	\N	CREME BRULEE	2.00	5.00	6.00	t
8228	2799	\N	COUSCOUS PM	3.00	17.00	12.00	f
8229	2799	\N	COCA	2.00	2.20	21.00	f
8230	2800	\N	GLACE	2.00	5.00	12.00	t
8231	2800	\N	CAFÉ	1.00	2.50	21.00	t
8232	2800	\N	DECA	1.00	2.50	21.00	t
8233	2800	\N	COURGETTE + SCAMPIS+BURRATA	1.00	22.00	12.00	t
8234	2800	\N	COUSCOUS PM	1.00	17.00	12.00	t
8235	2800	\N	BLANC VERRE	1.00	5.00	21.00	t
8236	2800	\N	ROUGE VERRE	1.00	5.00	21.00	t
8237	2801	\N	SPARE RIBS	1.00	18.00	12.00	t
8238	2801	\N	LASAGNE DU BOUCHER	1.00	15.00	12.00	t
8239	2801	\N	TAJINE	1.00	17.00	12.00	t
8240	2801	\N	ROUGE VERRE	1.00	5.00	21.00	t
8241	2801	\N	PROSECCO VERRE	1.00	6.00	21.00	t
8242	2802	\N	COUSCOUS PM	2.00	17.00	12.00	t
8243	2802	\N	CAFÉ	1.00	2.50	21.00	t
8244	2802	\N	SABAYON	1.00	8.00	12.00	t
8245	2802	\N	ROUGE VERRE	1.00	5.00	21.00	t
8246	2802	\N	COCA	1.00	2.20	21.00	t
8247	2803	\N	PÂTES BOLO	2.00	13.00	6.00	t
8248	2804	\N	BLANC VERRE	1.00	5.00	21.00	f
8249	2804	\N	COCA ZERO	1.00	2.20	21.00	f
8250	2804	\N	COUSCOUS PM	2.00	17.00	12.00	f
8251	2804	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
8252	2804	\N	PECKET FRAISE	1.00	8.00	21.00	f
8253	2804	\N	PROSECCO VERRE	1.00	6.00	21.00	f
8254	2804	\N	BULLES 0%	1.00	6.00	21.00	f
8255	2804	\N	CREME BRULEE	2.00	5.00	12.00	f
8266	2807	\N	Service Léa	-1.00	-50.00	0.00	t
8269	2810	\N	CAFÉ	1.00	2.50	21.00	t
8270	2810	\N	Cuba-Li	1.00	8.00	21.00	t
8271	2810	\N	PROSECCO VERRE	1.00	6.00	21.00	t
8272	2810	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
8273	2810	\N	PÂTES TRUFFE	1.00	15.00	12.00	t
8276	2813	\N	BLUSH	3.00	20.00	21.00	t
8277	2813	\N	COUSCOUS PM	1.00	17.00	12.00	t
8293	2816	\N	PÂTES	1.00	13.00	12.00	f
8294	2816	\N	COCA	1.00	2.20	21.00	f
8298	2819	\N	ROSÉ VERRE	4.00	5.00	21.00	f
8302	2822	\N	NOURRITURE	-1.00	-14.32	0.00	t
8308	2825	\N	GATEAUX MIEL	1.00	5.00	12.00	t
8309	2825	\N	CREME BRULEE	1.00	5.00	12.00	t
8310	2825	\N	BLUSH	1.00	20.00	21.00	t
8311	2825	\N	TAJINE	2.00	17.00	12.00	t
8312	2825	\N	PROSECCO VERRE	2.00	6.00	21.00	t
8324	2828	\N	Service Carol	-1.00	-13.00	0.00	t
8327	2831	\N	CREME BRULEE	2.00	5.00	6.00	t
8335	2834	\N	CREPE TRUFFES BURRATA	1.00	14.00	12.00	t
8336	2834	\N	SABAYON SPECIAL	1.00	10.00	12.00	t
8337	2834	\N	COCA ZERO	1.00	2.20	21.00	t
8338	2834	\N	ICE TEA	1.00	2.20	21.00	t
8339	2834	\N	STRACIATELLA	1.00	15.00	12.00	t
8340	2834	\N	COUSCOUS PM	1.00	17.00	12.00	t
8341	2834	\N	BEIGNETS DE COURGETTE	1.00	14.00	12.00	t
8342	2834	\N	PROSECCO VERRE	1.00	6.00	21.00	t
8343	2834	\N	VIOLETTE	2.00	8.00	21.00	t
8347	2837	\N	CORNET BOLO	1.00	6.00	6.00	f
8348	2837	\N	CREME BRULEE	1.00	5.00	12.00	f
8349	2837	\N	ROUGE 1/4	1.00	8.00	21.00	f
8350	2837	\N	PROSECCO VERRE	1.00	6.00	21.00	f
8351	2837	\N	SPARE RIBS	1.00	18.00	21.00	f
8356	2840	\N	ORANGE	-1.00	-14.40	0.00	t
8361	2843	\N	EVRARD	-1.00	-38.99	0.00	t
8364	2846	\N	SONOS	-1.00	-110.00	0.00	t
8377	2849	\N	FRAISE 1L	1.00	11.00	21.00	t
8378	2849	\N	CREME BRULEE	2.00	5.00	6.00	t
8379	2849	\N	COUSCOUS PM	2.00	17.00	6.00	t
8383	2852	\N	CREPE TRUFFES BURRATA	1.00	14.00	12.00	t
8384	2852	\N	PÂTES	1.00	13.00	12.00	t
8385	2852	\N	TAJINE	1.00	17.00	12.00	t
8386	2852	\N	BEIGNETS FLEUR DE COURGETTES	1.00	18.00	12.00	t
8387	2852	\N	PECKET FRAISE	2.00	8.00	21.00	t
8388	2852	\N	COCA	3.00	2.20	21.00	t
8406	2855	\N	Service Maurine	-1.00	-50.00	0.00	t
8411	2858	\N	PECKET FRAISE	1.00	8.00	21.00	t
8412	2858	\N	SAMBUCA	1.00	5.00	21.00	t
8413	2858	\N	ROSÉ VERRE	2.00	5.00	21.00	t
8414	2858	\N	COUSCOUS PM	5.00	17.00	6.00	t
8424	2861	\N	PROSECCO VERRE	1.00	6.00	21.00	t
8425	2861	\N	ROSÉ VERRE	2.00	5.00	21.00	t
8435	2864	\N	PROSECCO VERRE	1.00	6.00	21.00	t
8436	2864	\N	ROSÉ VERRE	3.00	5.00	21.00	t
8442	2867	\N	FRAISE 1L	6.00	10.00	21.00	f
8448	2870	\N	Service Jeff	-1.00	-40.00	0.00	t
8453	2873	\N	CORNET TRUFFE	1.00	7.00	6.00	t
8458	2876	\N	PESTO + BURRATA	1.00	15.00	12.00	t
8459	2876	\N	TRUFFE + BURRATA	1.00	17.00	12.00	t
8465	2879	\N	BLANC VERRE	1.00	5.00	21.00	f
8466	2879	\N	PROSECCO VERRE	2.00	6.00	21.00	f
8475	2882	\N	BLANC 1/2	1.00	13.00	21.00	t
8476	2882	\N	CREME BRULEE	1.00	5.00	12.00	t
8477	2882	\N	STRACIATELLA SCAMPIS	1.00	16.00	12.00	t
8478	2882	\N	PECKET FRAISE	2.00	8.00	21.00	t
8485	2885	\N	Service Elise	-1.00	-50.00	0.00	t
8488	2888	\N	COUSCOUS PM	1.00	17.00	12.00	f
8489	2888	\N	DEFERLANTE	1.00	4.00	21.00	f
8498	2891	\N	COUSCOUS PM	2.00	17.00	6.00	t
8505	2894	\N	NOURRITURE	-1.00	-25.18	0.00	t
8510	2897	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
8511	2897	\N	BLANC VERRE	2.00	5.00	21.00	t
8512	2897	\N	BOMBE ATOMIQUE+ BURRATA	1.00	17.00	12.00	t
8513	2897	\N	COUSCOUS VG	1.00	12.00	12.00	t
8514	2897	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
8515	2897	\N	CHAKTCHOUKA	1.00	12.00	12.00	t
8516	2897	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	t
8517	2897	\N	FANTA	1.00	2.20	21.00	t
8518	2897	\N	PROSECCO VERRE	1.00	6.00	21.00	t
8519	2897	\N	GINGEMBRE	1.00	10.00	21.00	t
8530	2900	\N	COCA ZERO	1.00	2.20	21.00	f
8531	2900	\N	ROSÉ VERRE	3.00	5.00	21.00	f
8544	2903	\N	COCA ZERO	4.00	2.20	21.00	t
8545	2903	\N	CREPE CREME LARD	1.00	12.00	12.00	t
8546	2903	\N	CREPE KABYLE	1.00	12.00	12.00	t
8547	2903	\N	PLAT SPÉCIAL	1.00	18.00	12.00	t
8548	2903	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
8549	2903	\N	ICE TEA	2.00	2.20	21.00	t
8550	2903	\N	FANTA	2.00	2.20	21.00	t
8551	2903	\N	TIRAMISU GLACÉ	2.00	6.00	12.00	t
8552	2903	\N	GLACE	1.00	5.00	12.00	t
8553	2903	\N	SABAYON SPECIAL	1.00	10.00	12.00	t
8556	2906	\N	GRAPPA	1.00	5.00	21.00	f
8557	2906	\N	CAFÉ	1.00	2.50	21.00	f
8558	2906	\N	RHUM	2.00	6.00	21.00	f
8559	2906	\N	Cuba-Li	5.00	0.00	21.00	f
8560	2906	\N	EAU PÉTILLANTE 1 L	6.00	5.00	21.00	f
8561	2906	\N	COCA	1.00	2.20	21.00	f
8562	2906	\N	BLUSH	4.00	20.00	21.00	f
8563	2906	\N	COCA ZERO	1.00	2.20	21.00	f
8566	2909	\N	NOURRITURE	-1.00	-40.47	0.00	t
8569	2912	\N	EMBALLAGE	-1.00	-79.10	0.00	t
8572	2915	\N	CORNET BOLO	2.00	6.00	6.00	f
8578	2918	\N	MANDURIA	1.00	30.00	21.00	t
8579	2918	\N	NERO D'AVOLA	1.00	30.00	21.00	t
8580	2918	\N	CHARDONNAY FIO	1.00	20.00	21.00	t
8581	2918	\N	PINOT GRIGIO	1.00	20.00	21.00	t
8582	2918	\N	PÂTES BOLO	1.00	13.00	12.00	t
8583	2918	\N	COUSCOUS PM	6.00	17.00	12.00	t
8586	2921	\N	COUSCOUS PM	3.00	17.00	12.00	f
8606	2924	\N	BLANC VERRE	2.00	5.00	21.00	t
8607	2924	\N	FANTA	1.00	2.20	21.00	t
8608	2924	\N	PÂTES LARD	1.00	13.00	12.00	t
8609	2924	\N	STRACIATELLA SCAMPIS	1.00	19.00	12.00	t
8610	2924	\N	SABAYON	1.00	8.00	12.00	t
8611	2924	\N	CREME BRULEE	1.00	5.00	12.00	t
8631	2927	\N	SPARE RIBS	1.00	18.00	21.00	t
8632	2927	\N	COCA	1.00	2.20	21.00	t
8633	2927	\N	RHUM	2.00	8.00	21.00	t
8634	2927	\N	Cuba-Li	4.00	8.00	21.00	t
8637	2930	\N	DECA	1.00	2.50	21.00	t
8256	2805	\N	EAU PET 1/2 L	2.00	3.50	21.00	f
8257	2805	\N	GRAPPA	1.00	5.00	21.00	f
8258	2805	\N	CAFÉ	1.00	2.50	21.00	f
8259	2805	\N	ROUGE VERRE	1.00	5.00	21.00	f
8260	2805	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
8267	2808	\N	NOURRITURE	-1.00	-18.84	0.00	t
8274	2811	\N	NOURRITURE	-1.00	-32.98	0.00	t
8278	2814	\N	BLUSH	1.00	20.00	21.00	f
8279	2814	\N	COUSCOUS PM	1.00	17.00	12.00	f
8280	2814	\N	COCA	1.00	2.20	21.00	f
8281	2814	\N	ICE TEA	3.00	2.20	21.00	f
8282	2814	\N	PINOT GRIGIO	1.00	20.00	21.00	f
8283	2814	\N	PECKET FRAISE	1.00	8.00	21.00	f
8284	2814	\N	COURGETTE + SCAMPIS	2.00	18.00	12.00	f
8285	2814	\N	SPARE RIBS	1.00	18.00	21.00	f
8286	2814	\N	GLACE	1.00	5.00	12.00	f
8287	2814	\N	FANTA	1.00	2.20	21.00	f
8288	2814	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
8295	2817	\N	BOMBE ATOMIQUE+ BURRATA	1.00	0.00	6.00	t
8296	2817	\N	COUSCOUS PM	3.00	0.00	6.00	t
8299	2820	\N	ROUGE VERRE	1.00	5.00	21.00	f
8300	2820	\N	PÂTES BOLO	1.00	13.00	12.00	f
8303	2823	\N	Cuba-Li	2.00	8.00	21.00	f
8304	2823	\N	ICE TEA	1.00	2.20	21.00	f
8305	2823	\N	FANTA	1.00	2.20	21.00	f
8306	2823	\N	JUPILER	1.00	2.50	21.00	f
8313	2826	\N	THÉ MENTHE	1.00	2.50	21.00	t
8314	2826	\N	PROSECCO VERRE	2.00	6.00	21.00	t
8315	2826	\N	COCA	1.00	2.20	21.00	t
8316	2826	\N	COUSCOUS VG	1.00	12.00	12.00	t
8317	2826	\N	COUSCOUS PM	1.00	17.00	12.00	t
8325	2829	\N	Service Charlotte	-1.00	-10.00	0.00	t
8328	2832	\N	JUPILER	2.00	2.50	21.00	t
8329	2832	\N	Cuba-Li	1.00	8.00	21.00	t
8330	2832	\N	GINGEMBRE	1.00	10.00	21.00	t
8331	2832	\N	VIOLETTE	1.00	8.00	21.00	t
8332	2832	\N	COUSCOUS VG	1.00	12.00	12.00	t
8333	2832	\N	PÂTES TRUFFE	2.00	15.00	12.00	t
8344	2835	\N	LOYER	-1.00	-600.00	0.00	t
8352	2838	\N	ESPRESSO	1.00	2.50	21.00	f
8353	2838	\N	TAJINE	1.00	17.00	12.00	f
8354	2838	\N	ICE TEA	1.00	2.20	21.00	f
8357	2841	\N	COCA	1.00	0.00	21.00	t
8358	2841	\N	ICE TEA	1.00	0.00	21.00	t
8359	2841	\N	CREPE TRUFFES BURRATA	1.00	0.00	12.00	t
8362	2844	\N	COUSCOUS PM	2.00	17.00	6.00	f
8365	2847	\N	FRAISJEUX	-1.00	-60.00	0.00	t
8380	2850	\N	CORNET BOLO	2.00	6.00	6.00	f
8389	2853	\N	THÉ MENTHE	1.00	2.50	21.00	t
8390	2853	\N	GATEAUX MIEL	1.00	5.00	12.00	t
8391	2853	\N	CREME BRULEE	1.00	5.00	12.00	t
8392	2853	\N	BLANC VERRE	2.00	5.00	21.00	t
8393	2853	\N	Cuba-Li	2.00	8.00	21.00	t
8394	2853	\N	BEIGNETS FLEUR DE COURGETTES	2.00	18.00	12.00	t
8395	2853	\N	SABAYON SPECIAL	1.00	0.00	12.00	t
8407	2856	\N	SPARE RIBS	1.00	18.00	21.00	f
8408	2856	\N	ROSÉ VERRE	3.00	5.00	21.00	f
8409	2856	\N	Cuba-Li	2.00	8.00	21.00	f
8415	2859	\N	ARROSTICINNI (5)	1.00	8.00	12.00	f
8416	2859	\N	BLUSH	1.00	20.00	21.00	f
8417	2859	\N	ROSÉ VERRE	2.00	5.00	21.00	f
8426	2862	\N	ROSÉ VERRE	1.00	5.00	21.00	t
8427	2862	\N	COCA ZERO	1.00	2.20	21.00	t
8428	2862	\N	COUSCOUS PM	1.00	17.00	12.00	t
8429	2862	\N	BLUSH	1.00	20.00	21.00	t
8430	2862	\N	PROSECCO VERRE	4.00	6.00	21.00	t
8431	2862	\N	SPARE RIBS	2.00	18.00	21.00	t
8437	2865	\N	THÉ MENTHE	1.00	2.50	21.00	t
8438	2865	\N	PROSECCO VERRE	2.00	6.00	21.00	t
8439	2865	\N	BLUSH	2.00	20.00	21.00	t
8443	2868	\N	CORNET BOLO	1.00	6.00	6.00	t
8449	2871	\N	PROSECCO VERRE	1.00	5.00	21.00	f
8450	2871	\N	BLANC VERRE	1.00	5.00	21.00	f
8451	2871	\N	JUPILER	1.00	2.00	21.00	f
8454	2874	\N	NOËL (BRUNE)	1.00	4.00	21.00	f
8455	2874	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
8460	2877	\N	PINOT GRIGIO	1.00	20.00	21.00	t
8461	2877	\N	SPARE RIBS	1.00	18.00	21.00	t
8467	2880	\N	CREME BRULEE	2.00	5.00	12.00	f
8468	2880	\N	CÔTES DE RHÔNES	2.00	24.00	21.00	f
8469	2880	\N	BLUSH	4.00	20.00	21.00	f
8470	2880	\N	ICE TEA	1.00	2.20	21.00	f
8471	2880	\N	COCA	1.00	2.20	21.00	f
8472	2880	\N	COUSCOUS PM	3.00	17.00	12.00	f
8479	2883	\N	JUPILER	2.00	2.50	21.00	t
8480	2883	\N	BLONDINETTE	1.00	4.00	21.00	t
8481	2883	\N	TRUFFE + BURRATA	1.00	17.00	12.00	t
8482	2883	\N	SPARE RIBS	1.00	18.00	21.00	t
8483	2883	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	t
8486	2886	\N	NOURRITURE	-1.00	-10.00	0.00	t
8490	2889	\N	HOEGAARDEN ROSEE	1.00	2.00	21.00	t
8491	2889	\N	JUPILER	3.00	2.00	21.00	t
8492	2889	\N	CORNET LARD	1.00	6.00	6.00	t
8499	2892	\N	ESPRESSO	1.00	2.50	21.00	f
8500	2892	\N	CREPE CHAKCHOUKA XXL	1.00	18.00	12.00	f
8501	2892	\N	TRUFFE + BURRATA	1.00	17.00	12.00	f
8502	2892	\N	PESTO + BURRATA	1.00	15.00	12.00	f
8503	2892	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
8506	2895	\N	NOURRITURE	-1.00	-30.72	0.00	t
8520	2898	\N	GLACE	1.00	5.00	12.00	f
8521	2898	\N	CREPE SUCRE	1.00	5.00	12.00	f
8522	2898	\N	STRACIATELLA SCAMPIS	1.00	19.00	12.00	f
8523	2898	\N	CREPE TRUFFES BURRATA	1.00	14.00	12.00	f
8524	2898	\N	COCA	2.00	2.20	21.00	f
8532	2901	\N	SABAYON SPECIAL	1.00	10.00	12.00	t
8533	2901	\N	COURGETTE + SCAMPIS	1.00	18.00	12.00	t
8534	2901	\N	COUSCOUS PM	2.00	17.00	12.00	t
8535	2901	\N	BLUSH	2.00	20.00	21.00	t
8536	2901	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
8554	2904	\N	Service SAM	-1.00	-50.00	0.00	t
8564	2907	\N	NOURRITURE	-1.00	-114.20	0.00	t
8567	2910	\N	NOURRITURE	-1.00	-40.35	0.00	t
8570	2913	\N	COUSCOUS PM	6.00	17.00	6.00	f
8573	2916	\N	BLUSH	1.00	20.00	21.00	f
8584	2919	\N	JUPILER	3.00	2.00	21.00	f
8587	2922	\N	GLACE	2.00	5.00	12.00	t
8588	2922	\N	TIRAMISU GLACÉ	2.00	6.00	12.00	t
8589	2922	\N	BLANC VERRE	2.00	5.00	21.00	t
8590	2922	\N	VAL DIEU	1.00	4.00	21.00	t
8591	2922	\N	COCA	3.00	2.20	21.00	t
8592	2922	\N	BLONDINETTE	3.00	4.00	21.00	t
8261	2806	\N	CAFÉ	1.00	2.50	21.00	t
8262	2806	\N	BULLES 0%	1.00	6.00	21.00	t
8263	2806	\N	ROSÉ VERRE	4.00	5.00	21.00	t
8264	2806	\N	SPARE RIBS	1.00	18.00	12.00	t
8265	2806	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	t
8268	2809	\N	NOURRITURE	-1.00	-38.99	0.00	t
8275	2812	\N	Service Elise	-1.00	-40.00	0.00	t
8289	2815	\N	CREME BRULEE	1.00	5.00	12.00	f
8290	2815	\N	PECKET FRAISE	1.00	8.00	21.00	f
8291	2815	\N	PÂTES BOLO	1.00	13.00	12.00	f
8292	2815	\N	ROUGE 1/4	1.00	8.00	21.00	f
8297	2818	\N	BOISSONS	-1.00	-40.00	0.00	t
8301	2821	\N	JUPILER	2.00	2.00	21.00	f
8307	2824	\N	NOURRITURE	-1.00	-48.28	0.00	t
8318	2827	\N	GLACE	1.00	5.00	12.00	t
8319	2827	\N	GATEAUX MIEL	1.00	5.00	12.00	t
8320	2827	\N	CREME BRULEE	1.00	5.00	12.00	t
8321	2827	\N	JUPILER	1.00	2.50	21.00	t
8322	2827	\N	BEIGNETS FLEUR DE COURGETTES	1.00	18.00	12.00	t
8323	2827	\N	SPARE RIBS	2.00	18.00	21.00	t
8326	2830	\N	T-SHIRT	-1.00	-246.84	0.00	t
8334	2833	\N	Service Elise	-1.00	-40.00	0.00	t
8345	2836	\N	CORNET TRUFFE	1.00	7.00	6.00	t
8346	2836	\N	CORNET BOLO	1.00	6.00	6.00	t
8355	2839	\N	ORANGE	-1.00	-28.00	0.00	t
8360	2842	\N	NOURRITURE	-1.00	-46.15	0.00	t
8363	2845	\N	Service Elise	-1.00	-40.00	0.00	t
8366	2848	\N	PRIMITIVO NR 14	2.00	24.00	21.00	t
8367	2848	\N	COCA	3.00	2.20	21.00	t
8368	2848	\N	BLONDINETTE	4.00	4.00	21.00	t
8369	2848	\N	TRIPLE	1.00	4.50	21.00	t
8370	2848	\N	COUSCOUS PM	5.00	17.00	12.00	t
8371	2848	\N	STRACIATELLA SCAMPIS	3.00	19.00	12.00	t
8372	2848	\N	SPARE RIBS	1.00	18.00	21.00	t
8373	2848	\N	DEFERLANTE	9.00	4.00	21.00	t
8374	2848	\N	VAL DIEU	5.00	4.00	21.00	t
8375	2848	\N	JUPILER	7.00	2.50	21.00	t
8376	2848	\N	ORVAL	3.00	5.00	21.00	t
8381	2851	\N	BOMBE ATOMIQUE+ BURRATA	1.00	21.00	6.00	f
8382	2851	\N	COUSCOUS PM	1.00	17.00	6.00	f
8396	2854	\N	NERO D'AVOLA	2.00	30.00	21.00	f
8397	2854	\N	PÂTES LARD	1.00	13.00	12.00	f
8398	2854	\N	SPARE RIBS	1.00	18.00	21.00	f
8399	2854	\N	CANNELLONI VIANDE	2.00	18.00	12.00	f
8400	2854	\N	ESPRESSO	1.00	2.50	21.00	f
8401	2854	\N	THÉ MENTHE	3.00	2.50	21.00	f
8402	2854	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
8403	2854	\N	JUPILER	2.00	2.50	21.00	f
8404	2854	\N	PECKET FRAISE	2.00	8.00	21.00	f
8405	2854	\N	Cuba-Li	4.00	8.00	21.00	f
8410	2857	\N	FRAISE 1L	30.00	10.00	21.00	f
8418	2860	\N	THÉ MENTHE	1.00	2.50	21.00	f
8419	2860	\N	CAFÉ	2.00	2.50	21.00	f
8420	2860	\N	COURGETTE + SCAMPIS	2.00	18.00	12.00	f
8421	2860	\N	SPARE RIBS	1.00	18.00	21.00	f
8422	2860	\N	PECKET FRAISE	1.00	8.00	21.00	f
8423	2860	\N	BLUSH	3.00	20.00	21.00	f
8432	2863	\N	PROSECCO VERRE	1.00	6.00	21.00	f
8433	2863	\N	THÉ MENTHE	1.00	2.50	21.00	f
8434	2863	\N	ROSÉ VERRE	4.00	5.00	21.00	f
8440	2866	\N	COUSCOUS	35.00	7.00	6.00	f
8441	2866	\N	COUSCOUS PM	74.00	9.00	6.00	f
8444	2869	\N	CREME BRULEE	1.00	5.00	12.00	t
8445	2869	\N	TAJINE	1.00	17.00	12.00	t
8446	2869	\N	BEIGNETS FLEUR DE COURGETTES	1.00	18.00	12.00	t
8447	2869	\N	NERO D'AVOLA	1.00	30.00	21.00	t
8452	2872	\N	CORNET TRUFFE	1.00	7.00	6.00	f
8456	2875	\N	JUPILER	10.00	2.00	21.00	f
8457	2875	\N	BLANC VERRE	1.00	5.00	21.00	f
8462	2878	\N	PESTO + BURRATA	1.00	15.00	12.00	t
8463	2878	\N	POLPETTE	1.00	16.00	12.00	t
8464	2878	\N	JUPILER	8.00	2.50	21.00	t
8473	2881	\N	SPAG.COURGETTE	1.00	0.00	12.00	t
8474	2881	\N	NERO D'AVOLA	1.00	30.00	21.00	t
8484	2884	\N	Service Caro	-1.00	-100.00	0.00	t
8487	2887	\N	NOURRITURE	-1.00	-2.10	0.00	t
8493	2890	\N	FANTA	1.00	2.20	21.00	t
8494	2890	\N	CREPE SUCRE	1.00	5.00	12.00	t
8495	2890	\N	STRACIATELLA	1.00	15.00	12.00	t
8496	2890	\N	PÂTES LARD	1.00	13.00	12.00	t
8497	2890	\N	COCA	3.00	2.20	21.00	t
8504	2893	\N	BLUSH	3.00	5.00	21.00	f
8507	2896	\N	CAFÉ	1.00	2.50	21.00	f
8508	2896	\N	EAU PET 1/2 L	1.00	3.50	21.00	f
8509	2896	\N	GRAPPA	1.00	5.00	21.00	f
8525	2899	\N	PROSECCO Bouteille	1.00	25.00	21.00	f
8526	2899	\N	IRISH COFFEE	1.00	8.00	21.00	f
8527	2899	\N	COCA	1.00	2.20	21.00	f
8528	2899	\N	JUPILER	1.00	2.50	21.00	f
8529	2899	\N	BLUSH	2.00	20.00	21.00	f
8537	2902	\N	EAU PÉTILLANTE 1 L	2.00	5.00	21.00	t
8538	2902	\N	CREPE KABYLE	1.00	12.00	12.00	t
8539	2902	\N	TAJINE	1.00	17.00	12.00	t
8540	2902	\N	CREPE TRUFFES BURRATA	1.00	12.00	12.00	t
8541	2902	\N	CAFÉ	1.00	2.50	21.00	t
8542	2902	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
8543	2902	\N	THÉ MENTHE	1.00	2.50	21.00	t
8555	2905	\N	BLUSH	1.00	20.00	21.00	f
8565	2908	\N	NOURRITURE	-1.00	-111.28	0.00	t
8568	2911	\N	DAMBIERMONT	-1.00	-390.37	0.00	t
8571	2914	\N	NOURRITURE	-1.00	-26.65	0.00	t
8574	2917	\N	ESPRESSO	1.00	2.50	21.00	f
8575	2917	\N	DECA	1.00	2.50	21.00	f
8576	2917	\N	THÉ MENTHE	2.00	2.50	21.00	f
8577	2917	\N	CREPE CHAKCHOUKA	2.00	14.00	12.00	f
8585	2920	\N	NOURRITURE	-1.00	-69.24	0.00	t
8601	2923	\N	CREME BRULEE	1.00	5.00	12.00	t
8602	2923	\N	GINGEMBRE	1.00	10.00	21.00	t
8603	2923	\N	PECKET FRAISE	1.00	8.00	21.00	t
8604	2923	\N	COUSCOUS PM	1.00	17.00	12.00	t
8605	2923	\N	COURGETTE + SCAMPIS	1.00	18.00	12.00	t
8630	2926	\N	NOURRITURE	-1.00	-12.00	0.00	t
8636	2929	\N	COURGETTE + SCAMPIS	3.00	18.00	12.00	f
8647	2932	\N	RHUM	1.00	6.00	21.00	f
8648	2932	\N	AMARETTO	1.00	5.00	21.00	f
8653	2935	\N	PINOT GRIGIO	1.00	5.00	21.00	t
8654	2935	\N	COCA ZERO	1.00	2.20	21.00	t
8655	2935	\N	PECKET FRAISE	1.00	8.00	21.00	t
8656	2935	\N	BEIGNETS FLEUR DE COURGETTES	1.00	18.00	12.00	t
8657	2935	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
8593	2922	\N	VIOLETTE	2.00	8.00	21.00	t
8594	2922	\N	PECKET FRAISE	1.00	8.00	21.00	t
8595	2922	\N	MIX CROQUETTES ARTISANALES	1.00	20.00	6.00	t
8596	2922	\N	PÂTES LARD	1.00	13.00	12.00	t
8597	2922	\N	PESTO + BURRATA	1.00	15.00	12.00	t
8598	2922	\N	TRUFFE + BURRATA	2.00	17.00	12.00	t
8599	2922	\N	POLPETTE	1.00	16.00	12.00	t
8600	2922	\N	COUSCOUS PM	1.00	17.00	12.00	t
8612	2925	\N	ROUGE 1/4	1.00	8.00	21.00	t
8613	2925	\N	FANTA	1.00	2.20	21.00	t
8614	2925	\N	COCA	4.00	2.20	21.00	t
8615	2925	\N	Cuba-Li	2.00	8.00	21.00	t
8616	2925	\N	PECKET FRAISE	2.00	8.00	21.00	t
8617	2925	\N	PINOT GRIGIO	2.00	20.00	21.00	t
8618	2925	\N	MIX CROQUETTES ARTISANALES	1.00	20.00	6.00	t
8619	2925	\N	RHUM	4.00	6.00	21.00	t
8620	2925	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
8621	2925	\N	CREME BRULEE	1.00	5.00	12.00	t
8622	2925	\N	CREPE SUCRE	1.00	5.00	12.00	t
8623	2925	\N	CREPE FLAMBEE GD MARNIER	3.00	8.00	12.00	t
8624	2925	\N	BLANC 1/2	1.00	13.00	21.00	t
8625	2925	\N	STRACIATELLA SCAMPIS	1.00	19.00	12.00	t
8626	2925	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
8627	2925	\N	PÂTES LARD	1.00	13.00	12.00	t
8628	2925	\N	PESTO + BURRATA	1.00	15.00	12.00	t
8629	2925	\N	COUSCOUS PM	1.00	17.00	12.00	t
8635	2928	\N	Service Caro	-1.00	-100.00	0.00	t
8641	2931	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	f
8642	2931	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	f
8643	2931	\N	PINOT GRIGIO	1.00	20.00	21.00	f
8644	2931	\N	EAU PET 1/2 L	1.00	3.50	21.00	f
8645	2931	\N	PECKET FRAISE	4.00	8.00	21.00	f
8646	2931	\N	PÂTES ASPERGES	2.00	18.00	12.00	f
8652	2934	\N	Service Elise	-1.00	-40.00	0.00	t
8660	2937	\N	JUPILER	2.00	2.50	21.00	f
8661	2937	\N	PROSECCO VERRE	2.00	6.00	21.00	f
8664	2940	\N	DECA	2.00	2.50	21.00	t
8665	2940	\N	THÉ MENTHE	1.00	2.50	21.00	t
8666	2940	\N	CREME BRULEE	1.00	5.00	12.00	t
8667	2940	\N	TIRAMISU GLACÉ	2.00	6.00	12.00	t
8668	2940	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	t
8669	2940	\N	BLANC VERRE	3.00	5.00	21.00	t
8670	2940	\N	Cuba-Li	1.00	8.00	21.00	t
8671	2940	\N	COUSCOUS PM	2.00	17.00	12.00	t
8672	2940	\N	COUSCOUS VG	1.00	12.00	12.00	t
8683	2943	\N	ARROSTICINNI (5)	1.00	8.00	12.00	t
8684	2943	\N	ROSÉ MAISON	4.00	3.50	21.00	t
8695	2946	\N	ARROSTICINNI (5)	3.00	8.00	12.00	f
8696	2946	\N	ROSÉ MAISON	17.00	3.50	21.00	f
8697	2946	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
8698	2946	\N	EAU PÉTILLANTE 1 L	3.00	5.00	21.00	f
8704	2949	\N	NOURRITURE	-1.00	-47.00	0.00	t
8708	2952	\N	CREPE KABYLE	1.00	14.00	6.00	t
8714	2955	\N	EAU PÉTILLANTE 1 L	2.00	5.00	21.00	f
8715	2955	\N	PECKET FRAISE	1.00	8.00	21.00	f
8716	2955	\N	COUSCOUS PM	4.00	17.00	12.00	f
8717	2955	\N	ROSÉ MAISON	8.00	15.00	21.00	f
8720	2958	\N	HACHIS BOLO	-1.00	-11.30	0.00	t
8733	2961	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	t
8734	2961	\N	GLACE	1.00	5.00	12.00	t
8735	2961	\N	PINOT GRIGIO	1.00	20.00	21.00	t
8736	2961	\N	CREPE GORGONZOLA + COURG.	1.00	14.00	12.00	t
8737	2961	\N	CREPE CREME LARD	1.00	12.00	12.00	t
8738	2961	\N	MIX CROQUETTES ARTISANALES	1.00	20.00	6.00	t
8739	2961	\N	PECKET FRAISE	2.00	8.00	21.00	t
8740	2961	\N	PROSECCO VERRE	2.00	6.00	21.00	t
8743	2964	\N	ROUGE VERRE	4.00	5.00	21.00	t
8744	2964	\N	COCA ZERO	4.00	2.20	21.00	t
8745	2964	\N	PROSECCO VERRE	1.00	6.00	21.00	t
8746	2964	\N	PECKET FRAISE	4.00	8.00	21.00	t
8747	2964	\N	COURGETTE + SCAMPIS	2.00	18.00	12.00	t
8748	2964	\N	PÂTES ASPERGES	2.00	18.00	12.00	t
8749	2964	\N	TAJINE	2.00	17.00	12.00	t
8757	2967	\N	JUPILER	2.00	2.50	21.00	t
8760	2970	\N	NOURRITURE	-1.00	-31.29	0.00	t
8770	2973	\N	BEIGNETS DE COURGETTE	1.00	0.00	12.00	t
8771	2973	\N	PESTO + BURRATA	1.00	0.00	12.00	t
8783	2976	\N	STRACIATELLA SCAMPIS	1.00	19.00	6.00	t
8784	2976	\N	COCA	2.00	2.20	21.00	t
8793	2979	\N	CAFÉ	2.00	2.50	21.00	f
8794	2979	\N	SABAYON	2.00	8.00	12.00	f
8795	2979	\N	BLANC VERRE	1.00	5.00	21.00	f
8796	2979	\N	COCA	1.00	2.20	21.00	f
8797	2979	\N	IRISH COFFEE	1.00	8.00	21.00	f
8798	2979	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	f
8799	2979	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	f
8800	2979	\N	CHAMPIGNONS KABYLES	1.00	14.00	12.00	f
8801	2979	\N	CREPE CREME LARD	1.00	12.00	12.00	f
8802	2979	\N	CREPE CREME LARD XXL	1.00	16.00	12.00	f
8803	2979	\N	ROSÉ VERRE	4.00	5.00	21.00	f
8804	2979	\N	PECKET FRAISE	2.00	8.00	21.00	f
8810	2982	\N	CAFÉ	2.00	2.50	21.00	t
8811	2982	\N	ROUGE VERRE	1.00	5.00	21.00	t
8812	2982	\N	FANTA	2.00	2.20	21.00	t
8813	2982	\N	ICE TEA	1.00	2.20	21.00	t
8814	2982	\N	COUSCOUS PM	2.00	17.00	12.00	t
8815	2982	\N	PÂTES LARD	1.00	13.00	12.00	t
8823	2985	\N	GLACE	2.00	5.00	12.00	t
8824	2985	\N	COCA	2.00	2.20	21.00	t
8825	2985	\N	PÂTES LARD	2.00	13.00	12.00	t
8831	2988	\N	DESPRIETS	-1.00	-77.87	0.00	t
8837	2991	\N	CORNET BOLO	1.00	6.00	6.00	f
8840	2994	\N	COCA	1.00	2.20	21.00	f
8841	2994	\N	BLUSH	6.00	20.00	21.00	f
8842	2994	\N	PINOT GRIGIO	1.00	20.00	21.00	f
8843	2994	\N	PECKET FRAISE	1.00	8.00	21.00	f
8844	2994	\N	COURGETTE + SCAMPIS	1.00	18.00	12.00	f
8845	2994	\N	STRACIATELLA SCAMPIS	2.00	19.00	12.00	f
8846	2994	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
8847	2994	\N	TAJINE	1.00	17.00	12.00	f
8850	2997	\N	JUPILER	2.00	2.50	21.00	f
8851	2997	\N	COCA ZERO	2.00	2.20	21.00	f
8852	2997	\N	POLPETTE	1.00	16.00	12.00	f
8853	2997	\N	COUSCOUS PM	1.00	17.00	12.00	f
8876	3000	\N	PINOT GRIGIO	2.00	20.00	21.00	f
8877	3000	\N	PROSECCO VERRE	1.00	6.00	21.00	f
8878	3000	\N	Cuba-Li	2.00	8.00	21.00	f
8879	3000	\N	TIRAMISU GLACÉ	2.00	6.00	12.00	f
8638	2930	\N	COCA	1.00	2.20	21.00	t
8639	2930	\N	POLPETTE	1.00	16.00	12.00	t
8640	2930	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
8649	2933	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
8650	2933	\N	ARROSTICINNI (5)	1.00	8.00	12.00	t
8651	2933	\N	PROSECCO VERRE	2.00	6.00	21.00	t
8658	2936	\N	PROSECCO VERRE	2.00	6.00	21.00	t
8659	2936	\N	JUPILER	4.00	2.50	21.00	t
8663	2939	\N	BOISSONS	-1.00	-78.00	0.00	t
8679	2942	\N	BLONDINETTE	1.00	4.00	21.00	t
8680	2942	\N	COCA	1.00	2.20	21.00	t
8681	2942	\N	ROSÉ VERRE	4.00	5.00	21.00	t
8682	2942	\N	JUPILER	3.00	2.00	21.00	t
8689	2945	\N	GIN TONIC	1.00	10.00	21.00	t
8690	2945	\N	PROSECCO VERRE	1.00	6.00	21.00	t
8691	2945	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
8692	2945	\N	TIRAMISU GLACÉ	2.00	6.00	12.00	t
8693	2945	\N	COURGETTE + SCAMPIS	1.00	18.00	12.00	t
8694	2945	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	t
8703	2948	\N	NOURRITURE	-1.00	-187.46	0.00	t
8706	2951	\N	PÂTES PESTO	3.00	14.00	12.00	t
8707	2951	\N	JUPILER	7.00	2.50	21.00	t
8713	2954	\N	NOURRITURE	-1.00	-34.80	0.00	t
8719	2957	\N	MERGUEZ	-1.00	-36.75	0.00	t
8732	2960	\N	Service Léa	-1.00	-50.00	0.00	t
8742	2963	\N	CORNET LARD	1.00	6.00	6.00	t
8755	2966	\N	PROSECCO VERRE	1.00	6.00	21.00	f
8756	2966	\N	VAL DIEU	4.00	4.00	21.00	f
8759	2969	\N	NOURRITURE	-1.00	-31.29	0.00	t
8767	2972	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	f
8768	2972	\N	VAL DIEU	1.00	4.00	21.00	f
8769	2972	\N	ROSÉ MAISON	2.00	4.00	21.00	f
8773	2975	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	f
8774	2975	\N	STRACIATELLA SCAMPIS	1.00	19.00	12.00	f
8775	2975	\N	COURGETTE + SCAMPIS	1.00	18.00	12.00	f
8776	2975	\N	TAJINE	1.00	17.00	12.00	f
8777	2975	\N	COUSCOUS PM	1.00	17.00	12.00	f
8778	2975	\N	BLUSH	5.00	20.00	21.00	f
8779	2975	\N	PECKET FRAISE	1.00	8.00	21.00	f
8780	2975	\N	BLANC VERRE	1.00	5.00	21.00	f
8781	2975	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
8782	2975	\N	CHAMPIGNONS KABYLES	2.00	10.00	12.00	f
8789	2978	\N	ROSÉ VERRE	1.00	5.00	21.00	t
8790	2978	\N	PÂTES LARD	1.00	13.00	12.00	t
8791	2978	\N	EAU PET 1/2 L	1.00	3.50	21.00	t
8792	2978	\N	PROSECCO VERRE	1.00	6.00	21.00	t
8806	2981	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	t
8807	2981	\N	COUSCOUS PM	1.00	0.00	12.00	t
8808	2981	\N	BLANC 1/4	1.00	8.00	21.00	t
8809	2981	\N	BLANC VERRE	1.00	5.00	21.00	t
8819	2984	\N	CANNELLONI VIANDE	1.00	18.00	12.00	t
8820	2984	\N	JUPILER	2.00	2.50	21.00	t
8821	2984	\N	EAU PET VERRE	1.00	2.20	21.00	t
8822	2984	\N	TRUFFE + BURRATA	1.00	17.00	12.00	t
8828	2987	\N	RHUM	2.00	6.00	21.00	f
8829	2987	\N	ROSÉ MAISON	4.00	4.00	21.00	f
8830	2987	\N	ARROSTICINNI (5)	1.00	8.00	12.00	f
8833	2990	\N	CAFÉ	1.00	2.50	21.00	f
8834	2990	\N	PÂTES BOLO	1.00	13.00	12.00	f
8835	2990	\N	ROUGE 1/4	1.00	8.00	21.00	f
8836	2990	\N	PECKET FRAISE	1.00	8.00	21.00	f
8839	2993	\N	EAU PET 1/2 L	1.00	3.50	21.00	t
8849	2996	\N	TIRAMISU GLACÉ	4.00	6.00	6.00	t
8862	2999	\N	PECKET FRAISE	1.00	8.00	21.00	t
8863	2999	\N	COCA	2.00	2.20	21.00	t
8864	2999	\N	TRUFFE + BURRATA	1.00	17.00	12.00	t
8865	2999	\N	COUSCOUS PM	3.00	17.00	12.00	t
8866	2999	\N	BLUSH	1.00	20.00	21.00	t
8867	2999	\N	EAU PET 1/2 L	1.00	3.50	21.00	t
8868	2999	\N	ICE TEA	2.00	2.20	21.00	t
8869	2999	\N	CAFÉ	2.00	2.50	21.00	t
8870	2999	\N	TIRAMISU GLACÉ	2.00	6.00	12.00	t
8871	2999	\N	CREME BRULEE	1.00	5.00	12.00	t
8872	2999	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
8873	2999	\N	TAJINE	1.00	17.00	12.00	t
8874	2999	\N	PÂTES LARD	1.00	13.00	12.00	t
8875	2999	\N	PESTO + BURRATA	1.00	18.00	12.00	t
8885	3002	\N	Service Caro	-1.00	-60.00	0.00	t
8907	3005	\N	Service Léa	-1.00	-60.00	0.00	t
8915	3008	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
8916	3008	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	t
8917	3008	\N	COUSCOUS PM	2.00	17.00	12.00	t
8918	3008	\N	PECKET FRAISE	1.00	8.00	21.00	t
8919	3008	\N	VAL DIEU	2.00	4.00	21.00	t
8920	3008	\N	ALCOOL	1.00	6.00	21.00	t
8921	3008	\N	AMARETTO	1.00	6.00	21.00	t
8922	3008	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	t
8923	3008	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
8927	3011	\N	NOURRITURE	-1.00	-103.20	0.00	t
8932	3014	\N	CAFÉ	1.00	2.50	21.00	t
8933	3014	\N	TIRAMISU GLACÉ	2.00	6.00	12.00	t
8934	3014	\N	ROSÉ MAISON	3.00	3.50	21.00	t
8935	3014	\N	POLPETTE	2.00	16.00	12.00	t
8936	3014	\N	COUSCOUS VG	1.00	12.00	12.00	t
8937	3014	\N	VAL DIEU	3.00	4.00	21.00	t
8940	3017	\N	EAU PET VERRE	1.00	2.20	21.00	t
8941	3017	\N	ROSÉ MAISON	3.00	3.50	21.00	t
8945	3020	\N	TAJINE	1.00	17.00	12.00	t
8946	3020	\N	COUSCOUS PM	1.00	17.00	12.00	t
8950	3023	\N	BIO	-1.00	-60.00	0.00	t
8958	3026	\N	ROSÉ VERRE	2.00	5.00	21.00	t
8959	3026	\N	SPARE RIBS	1.00	18.00	12.00	t
8985	3029	\N	Service Léa	-1.00	-45.00	0.00	t
8988	3032	\N	NOURRITURE	-1.00	-39.17	0.00	t
8991	3035	\N	MERGUEZ	-1.00	-40.00	0.00	t
8994	3038	\N	POLPETTE	1.00	10.00	6.00	t
8995	3038	\N	TAJINE	1.00	17.00	6.00	t
8996	3038	\N	COUSCOUS PM	1.00	17.00	6.00	t
8997	3038	\N	VAL DIEU	2.00	4.00	21.00	t
8998	3038	\N	PROSECCO VERRE	2.00	6.00	21.00	t
9005	3041	\N	BLUSH 1/4	1.00	8.00	21.00	t
9006	3041	\N	BOMBE ATOMIQUE+ BURRATA	1.00	17.00	12.00	t
9007	3041	\N	MIX CROQUETTES ARTISANALES	1.00	20.00	6.00	t
9008	3041	\N	PROSECCO VERRE	1.00	6.00	21.00	t
9009	3041	\N	PECKET FRAISE	1.00	8.00	21.00	t
9012	3044	\N	EQUIPEMENT	-1.00	-42.96	0.00	t
9015	3047	\N	LOYER	-1.00	-600.00	0.00	t
9020	3050	\N	TIRAMISU GLACÉ	1.00	6.00	6.00	t
9027	3053	\N	CORNET BOLO	1.00	6.00	6.00	f
8662	2938	\N	COUSCOUS PM	1.00	17.00	6.00	t
8673	2941	\N	COCA ZERO	2.00	1.50	21.00	t
8674	2941	\N	BLANC VERRE	1.00	5.00	21.00	t
8675	2941	\N	PÂTES BOLO	1.00	13.00	12.00	t
8676	2941	\N	COUSCOUS PM	1.00	17.00	12.00	t
8677	2941	\N	COUSCOUS VG	1.00	12.00	12.00	t
8678	2941	\N	TIRAMISU GLACÉ	1.00	0.00	12.00	t
8685	2944	\N	EAU PET 1/2 L	1.00	3.50	21.00	t
8686	2944	\N	BLUSH 1/4	2.00	8.00	21.00	t
8687	2944	\N	PÂTES BOLO	1.00	13.00	12.00	t
8688	2944	\N	PECKET FRAISE	1.00	8.00	21.00	t
8699	2947	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
8700	2947	\N	EAU PET 1/2 L	1.00	3.50	21.00	t
8701	2947	\N	PÂTES ASPERGES	2.00	18.00	12.00	t
8702	2947	\N	PROSECCO VERRE	2.00	6.00	21.00	t
8705	2950	\N	LOYER	-1.00	-600.00	0.00	t
8709	2953	\N	COCA ZERO	1.00	2.20	21.00	t
8710	2953	\N	COCA	1.00	2.20	21.00	t
8711	2953	\N	4 FROMAGES	1.00	6.00	6.00	t
8712	2953	\N	CORNET BOLO	1.00	6.00	6.00	t
8718	2956	\N	JUPILER	3.00	2.00	21.00	f
8721	2959	\N	TIRAMISU GLACÉ	1.00	0.00	1.00	t
8722	2959	\N	COCA ZERO	1.00	2.20	21.00	t
8723	2959	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
8724	2959	\N	CREME BRULEE	3.00	5.00	12.00	t
8725	2959	\N	TRUFFE + BURRATA	1.00	17.00	12.00	t
8726	2959	\N	Cuba-Li	1.00	0.00	21.00	t
8727	2959	\N	POLPETTE	1.00	16.00	12.00	t
8728	2959	\N	TAJINE	1.00	17.00	12.00	t
8729	2959	\N	SPARE RIBS	1.00	0.00	21.00	t
8730	2959	\N	BOMBE ATOMIQUE+ BURRATA	1.00	17.00	12.00	t
8731	2959	\N	PECKET FRAISE	5.00	8.00	21.00	t
8741	2962	\N	Service Carol	-1.00	-60.00	0.00	t
8750	2965	\N	CAFÉ	2.00	2.50	21.00	t
8751	2965	\N	ROUGE 1/2	1.00	14.00	21.00	t
8752	2965	\N	TRUFFE + BURRATA	2.00	17.00	12.00	t
8753	2965	\N	ORVAL	1.00	5.00	21.00	t
8754	2965	\N	VAL DIEU	1.00	4.00	21.00	t
8758	2968	\N	NOURRITURE	-1.00	-18.42	0.00	t
8761	2971	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	f
8762	2971	\N	GLACE	1.00	5.00	12.00	f
8763	2971	\N	BLUSH	1.00	20.00	21.00	f
8764	2971	\N	MIX CROQUETTES ARTISANALES	2.00	20.00	6.00	f
8765	2971	\N	EAU PET 1/2 L	1.00	3.50	21.00	f
8766	2971	\N	PROSECCO VERRE	4.00	6.00	21.00	f
8772	2974	\N	Service Léa	-1.00	-50.00	0.00	t
8785	2977	\N	ESPRESSO	1.00	2.50	21.00	t
8786	2977	\N	PESTO + BURRATA	1.00	18.00	6.00	t
8787	2977	\N	PÂTES TRUFFE	1.00	15.00	6.00	t
8788	2977	\N	JUPILER	2.00	2.50	21.00	t
8805	2980	\N	RHUM	4.00	6.00	21.00	f
8816	2983	\N	FANTA	1.00	2.20	21.00	f
8817	2983	\N	ROSÉ MAISON	3.00	4.00	21.00	f
8818	2983	\N	PECKET FRAISE	2.00	8.00	21.00	f
8826	2986	\N	ROUGE VERRE	2.00	5.00	21.00	t
8827	2986	\N	TRUFFE + BURRATA	2.00	17.00	6.00	t
8832	2989	\N	NOURRITURE	-1.00	-50.03	0.00	t
8838	2992	\N	LOYER	-1.00	-300.00	0.00	t
8848	2995	\N	COUSCOUS PM	2.00	17.00	6.00	f
8854	2998	\N	CREME BRULEE	1.00	5.00	12.00	t
8855	2998	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
8856	2998	\N	BLANC VERRE	4.00	5.00	21.00	t
8857	2998	\N	ASSIETTE APERITIVE (2 p.)	1.00	10.00	12.00	t
8858	2998	\N	PROSECCO VERRE	3.00	6.00	21.00	t
8859	2998	\N	COURGETTE + SCAMPIS+BURRATA	1.00	22.00	12.00	t
8860	2998	\N	TRUFFE + BURRATA	1.00	17.00	12.00	t
8861	2998	\N	COUSCOUS VG	1.00	12.00	12.00	t
8884	3001	\N	Service Léa	-1.00	-90.00	0.00	t
8898	3004	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	t
8899	3004	\N	CREME BRULEE	1.00	5.00	12.00	t
8900	3004	\N	CAFÉ	1.00	2.50	21.00	t
8901	3004	\N	PINOT GRIGIO	1.00	20.00	21.00	t
8902	3004	\N	PECKET FRAISE	1.00	8.00	21.00	t
8903	3004	\N	VIOLETTE	1.00	8.00	21.00	t
8904	3004	\N	COUSCOUS PM	1.00	17.00	12.00	t
8905	3004	\N	AMARETTO	1.00	0.00	21.00	t
8906	3004	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
8913	3007	\N	Cuba-Li	2.00	8.00	21.00	f
8914	3007	\N	ROSÉ MAISON	4.00	4.00	21.00	f
8926	3010	\N	LOYER	-1.00	-300.00	0.00	t
8929	3013	\N	CREME BRULEE	1.00	5.00	12.00	t
8930	3013	\N	PÂTES LARD	1.00	13.00	12.00	t
8931	3013	\N	ROSÉ MAISON	4.00	3.50	21.00	t
8939	3016	\N	BOISSONS	-1.00	-130.32	0.00	t
8944	3019	\N	ROSÉ PATRON	5.00	3.00	21.00	f
8949	3022	\N	ARROSTICINNI (5)	1.00	8.00	12.00	t
8952	3025	\N	AMARETTO	2.00	0.00	21.00	f
8953	3025	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
8954	3025	\N	CREME BRULEE	2.00	5.00	12.00	f
8955	3025	\N	ROSÉ VERRE	2.00	5.00	21.00	f
8956	3025	\N	PECKET FRAISE	2.00	8.00	21.00	f
8957	3025	\N	SPARE RIBS	2.00	18.00	21.00	f
8975	3028	\N	EAU DE BARNEY	1.00	0.00	6.00	f
8976	3028	\N	COCA ZERO	1.00	2.20	21.00	f
8977	3028	\N	THÉ MENTHE	2.00	2.50	21.00	f
8978	3028	\N	CAFÉ	1.00	2.50	21.00	f
8979	3028	\N	CAPUCCINO	1.00	2.80	21.00	f
8980	3028	\N	JUPILER	2.00	2.50	21.00	f
8981	3028	\N	AMARONE	1.00	50.00	21.00	f
8982	3028	\N	PINOT GRIGIO	1.00	20.00	21.00	f
8983	3028	\N	COURGETTE + SCAMPIS	2.00	18.00	12.00	f
8984	3028	\N	CANNELLONI VIANDE	2.00	18.00	12.00	f
8987	3031	\N	NOURRITURE	-1.00	-25.17	0.00	t
8990	3034	\N	MERGUEZ	-1.00	-40.00	0.00	t
8993	3037	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	t
9001	3040	\N	ALCOOL	1.00	6.00	21.00	f
9002	3040	\N	Cuba-Li	2.00	8.00	21.00	f
9003	3040	\N	AMARONE	1.00	50.00	21.00	f
9004	3040	\N	COUSCOUS PM	1.00	17.00	12.00	f
9011	3043	\N	ROSÉ VERRE	3.00	5.00	21.00	t
9014	3046	\N	NOURRITURE	-1.00	-37.30	0.00	t
9017	3049	\N	CREPE KABYLE	1.00	12.00	12.00	t
9018	3049	\N	COUSCOUS PM	1.00	17.00	12.00	t
9019	3049	\N	FANTA	2.00	2.20	21.00	t
9024	3052	\N	CORNET LARD	1.00	6.00	6.00	f
9025	3052	\N	CORNET TRUFFE	1.00	7.00	6.00	f
9026	3052	\N	CORNET BOLO	3.00	6.00	6.00	f
9034	3055	\N	BLANC VERRE	1.00	5.00	21.00	t
9035	3055	\N	JUPILER	1.00	2.50	21.00	t
9036	3055	\N	COUSCOUS PM	2.00	17.00	12.00	t
8880	3000	\N	PECKET FRAISE	2.00	8.00	21.00	f
8881	3000	\N	PÂTES LARD	2.00	13.00	12.00	f
8882	3000	\N	PESTO + BURRATA	1.00	18.00	12.00	f
8883	3000	\N	COURGETTE + SCAMPIS	2.00	18.00	12.00	f
8886	3003	\N	Cuba-Li	2.00	8.00	21.00	f
8887	3003	\N	PECKET FRAISE	2.00	8.00	21.00	f
8888	3003	\N	GLACE	2.00	5.00	12.00	f
8889	3003	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	f
8890	3003	\N	CREME BRULEE	1.00	5.00	12.00	f
8891	3003	\N	COCA ZERO	2.00	2.20	21.00	f
8892	3003	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
8893	3003	\N	COURGETTE + SCAMPIS	1.00	18.00	12.00	f
8894	3003	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
8895	3003	\N	COUSCOUS VG	1.00	12.00	12.00	f
8896	3003	\N	PÂTES BOLO	1.00	13.00	12.00	f
8897	3003	\N	FANTA	1.00	2.20	21.00	f
8908	3006	\N	CREPE SUCRE	1.00	6.00	12.00	t
8909	3006	\N	CREPE CREME LARD	1.00	12.00	12.00	t
8910	3006	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	t
8911	3006	\N	COCA	1.00	2.20	21.00	t
8912	3006	\N	ROSÉ VERRE	4.00	5.00	21.00	t
8924	3009	\N	ALCOOL	1.00	6.00	21.00	f
8925	3009	\N	AMARETTO	1.00	6.00	21.00	f
8928	3012	\N	LIDL	-1.00	-44.05	0.00	t
8938	3015	\N	BOISSONS	-1.00	-68.70	0.00	t
8942	3018	\N	EAU PET 1/2 L	1.00	3.50	21.00	f
8943	3018	\N	BLUSH	3.00	5.00	21.00	f
8947	3021	\N	TRUFFE + BURRATA	2.00	17.00	6.00	t
8948	3021	\N	SOFT (Verre)	3.00	2.20	21.00	t
8951	3024	\N	CREME BRULEE	2.00	5.00	6.00	t
8960	3027	\N	FANTA	2.00	2.20	21.00	t
8961	3027	\N	COCA ZERO	2.00	2.20	21.00	t
8962	3027	\N	ORVAL	2.00	5.00	21.00	t
8963	3027	\N	TRIPLE	1.00	4.50	21.00	t
8964	3027	\N	BLONDINETTE	1.00	4.00	21.00	t
8965	3027	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
8966	3027	\N	SABAYON	1.00	8.00	12.00	t
8967	3027	\N	SABAYON SPECIAL	1.00	10.00	12.00	t
8968	3027	\N	THÉ MENTHE	2.00	2.50	21.00	t
8969	3027	\N	GATEAUX MIEL	3.00	5.00	12.00	t
8970	3027	\N	BOMBE ATOMIQUE+ BURRATA	1.00	17.00	12.00	t
8971	3027	\N	PESTO + BURRATA	1.00	18.00	12.00	t
8972	3027	\N	TAJINE	2.00	17.00	12.00	t
8973	3027	\N	COUSCOUS PM	3.00	17.00	12.00	t
8974	3027	\N	MIX CROQUETTES ARTISANALES	1.00	20.00	6.00	t
8986	3030	\N	Service Caro	-1.00	-60.00	0.00	t
8989	3033	\N	NOURRITURE	-1.00	-11.00	0.00	t
8992	3036	\N	COUSCOUS PM	2.00	17.00	12.00	t
8999	3039	\N	EAU PET 1/2 L	1.00	3.50	21.00	t
9000	3039	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	t
9010	3042	\N	CAFÉ	3.00	2.50	21.00	f
9013	3045	\N	NOURRITURE	-1.00	-20.99	0.00	t
9016	3048	\N	CORNET LARD	1.00	6.00	6.00	t
9021	3051	\N	JUPILER	1.00	2.50	21.00	t
9022	3051	\N	EAU PET 1/2 L	1.00	3.50	21.00	t
9023	3051	\N	DEFERLANTE	2.00	4.00	21.00	t
9030	3054	\N	IRISH COFFEE	2.00	8.00	21.00	t
9031	3054	\N	COCA	2.00	2.20	21.00	t
9032	3054	\N	SPARE RIBS	1.00	18.00	21.00	t
9033	3054	\N	COUSCOUS PM	1.00	17.00	12.00	t
9038	3057	\N	PROCES	-1.00	-63.42	0.00	t
9043	3060	\N	COCA	2.00	0.00	21.00	f
9044	3060	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	f
9045	3060	\N	PÂTES SCAMPIS	1.00	14.00	12.00	f
9053	3063	\N	CORNET LARD	1.00	6.00	6.00	t
9068	3066	\N	CORNET BOLO	2.00	6.00	6.00	f
9071	3069	\N	CAFÉ	1.00	2.50	21.00	t
9072	3069	\N	ROUGE VERRE	1.00	5.00	21.00	t
9073	3069	\N	PROSECCO VERRE	2.00	6.00	21.00	t
9074	3069	\N	COUSCOUS PM	1.00	17.00	12.00	t
9075	3069	\N	COUSCOUS VG	1.00	12.00	12.00	t
9088	3072	\N	JUPILER	1.00	2.50	21.00	t
9089	3072	\N	CHARDONNAY FIO	1.00	20.00	21.00	t
9090	3072	\N	EAU PET 1/2 L	1.00	3.50	21.00	t
9091	3072	\N	DEFERLANTE	1.00	4.00	21.00	t
9100	3075	\N	ALCOOL	2.00	6.00	21.00	f
9101	3075	\N	RHUM	2.00	6.00	21.00	f
9108	3078	\N	CORNET BOLO	1.00	6.00	6.00	f
9120	3081	\N	BOISSONS	-1.00	-224.00	0.00	t
9123	3084	\N	ROSÉ MAISON	1.00	3.50	21.00	f
9124	3084	\N	JUPILER	2.00	2.50	21.00	f
9131	3087	\N	NOURRITURE	-1.00	-52.67	0.00	t
9146	3090	\N	BLUSH	1.00	20.00	21.00	t
9149	3093	\N	SABAYON	1.00	8.00	12.00	t
9150	3093	\N	ARROSTICINNI (5)	2.00	8.00	12.00	t
9151	3093	\N	DECA	1.00	2.50	21.00	t
9152	3093	\N	HOEGAARDEN ROSEE	1.00	2.50	21.00	t
9153	3093	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	t
9154	3093	\N	VAL DIEU	1.00	4.00	21.00	t
9155	3093	\N	ROSÉ MAISON	5.00	3.50	21.00	t
9156	3093	\N	CAFÉ	2.00	2.50	21.00	t
9157	3093	\N	COCA	2.00	2.20	21.00	t
9158	3093	\N	CREPE SUCRE	1.00	5.00	12.00	t
9162	3096	\N	PECKET FRAISE	2.00	8.00	21.00	f
9163	3096	\N	CORNET TRUFFE	1.00	7.00	6.00	f
9164	3096	\N	CORNET LARD	1.00	6.00	6.00	f
9165	3096	\N	BLANC VERRE	6.00	5.00	21.00	f
9166	3096	\N	JUPILER	3.00	2.50	21.00	f
9178	3099	\N	DEFERLANTE	1.00	4.00	21.00	f
9179	3099	\N	CORNET LARD	2.00	6.00	6.00	f
9180	3099	\N	EAU PET 1/2 L	1.00	3.50	21.00	f
9181	3099	\N	JUPILER	19.00	2.50	21.00	f
9182	3099	\N	CAFÉ	1.00	2.50	21.00	f
9188	3102	\N	DEFERLANTE	2.00	4.00	21.00	t
9189	3102	\N	JUPILER	6.00	2.50	21.00	t
9197	3105	\N	DEFERLANTE	1.00	4.00	21.00	t
9209	3108	\N	BLANC VERRE	1.00	5.00	21.00	t
9210	3108	\N	DEFERLANTE	3.00	4.00	21.00	t
9211	3108	\N	VAL DIEU	1.00	4.00	21.00	t
9212	3108	\N	JUPILER	22.00	2.50	21.00	t
9213	3108	\N	ESPRESSO	1.00	2.50	21.00	t
9217	3111	\N	BLANC VERRE	1.00	5.00	21.00	t
9218	3111	\N	VAL DIEU	1.00	4.00	21.00	t
9219	3111	\N	JUPILER	17.00	2.50	21.00	t
9228	3114	\N	CHARDONNAY FIO	2.00	4.00	21.00	t
9234	3117	\N	PECKET FRAISE	1.00	8.00	21.00	f
9235	3117	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	f
9236	3117	\N	PÂTES STRACIATELLA SCAMPIS	1.00	15.00	12.00	f
9237	3117	\N	DEFERLANTE	1.00	4.00	21.00	f
9238	3117	\N	BLUSH	3.00	20.00	21.00	f
9239	3117	\N	COUSCOUS PM	1.00	17.00	12.00	f
9028	3053	\N	VAL DIEU	1.00	4.00	21.00	f
9029	3053	\N	PÂTES BOLO	1.00	13.00	12.00	f
9037	3056	\N	ENERGIES	-1.00	-311.55	0.00	t
9040	3059	\N	TAJINE	2.00	17.00	12.00	f
9041	3059	\N	PROSECCO VERRE	1.00	6.00	21.00	f
9042	3059	\N	COCA ZERO	1.00	2.20	21.00	f
9047	3062	\N	ICE TEA	1.00	2.20	21.00	t
9048	3062	\N	PÂTES LARD	1.00	13.00	12.00	t
9049	3062	\N	PESTO + BURRATA	1.00	18.00	12.00	t
9050	3062	\N	PÂTES BOLO	1.00	13.00	12.00	t
9051	3062	\N	COCA	2.00	2.20	21.00	t
9052	3062	\N	JUPILER	2.00	2.50	21.00	t
9061	3065	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	t
9062	3065	\N	ESPRESSO	1.00	2.50	21.00	t
9063	3065	\N	CAFÉ	1.00	2.50	21.00	t
9064	3065	\N	PROSECCO VERRE	2.00	6.00	21.00	t
9065	3065	\N	BLONDINETTE	1.00	4.00	21.00	t
9066	3065	\N	COUSCOUS PM	1.00	17.00	12.00	t
9067	3065	\N	PLAT SPÉCIAL	1.00	18.00	12.00	t
9070	3068	\N	PÂTES TRUFFE	1.00	15.00	12.00	t
9081	3071	\N	IRISH COFFEE	1.00	8.00	21.00	t
9082	3071	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
9083	3071	\N	ROUGE VERRE	1.00	5.00	21.00	t
9084	3071	\N	COCA ZERO	2.00	2.20	21.00	t
9085	3071	\N	CREPE KABYLE	1.00	12.00	12.00	t
9086	3071	\N	TRUFFE + BURRATA	1.00	17.00	12.00	t
9087	3071	\N	PECKET FRAISE	2.00	8.00	21.00	t
9099	3074	\N	Service Léa	-1.00	-50.00	0.00	t
9107	3077	\N	CORNET BOLO	1.00	6.00	6.00	f
9115	3080	\N	CANNELLONI VIANDE	1.00	17.00	12.00	f
9116	3080	\N	STRACIATELLA	1.00	16.00	12.00	f
9117	3080	\N	STRACIATELLA SCAMPIS	1.00	20.00	12.00	f
9118	3080	\N	BLUSH	3.00	20.00	21.00	f
9119	3080	\N	COCA	2.00	2.20	21.00	f
9122	3083	\N	ROSÉ MAISON	4.00	3.50	21.00	f
9126	3086	\N	ROUGE VERRE	2.00	6.00	21.00	t
9127	3086	\N	BLANC VERRE	2.00	5.00	21.00	t
9128	3086	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
9129	3086	\N	TAJINE	1.00	17.00	12.00	t
9130	3086	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	t
9143	3089	\N	COCA	1.00	2.20	21.00	f
9144	3089	\N	ROSÉ MAISON	1.00	3.50	21.00	f
9145	3089	\N	PECKET FRAISE	2.00	8.00	21.00	f
9148	3092	\N	CHARDONNAY FIO	1.00	20.00	21.00	f
9160	3095	\N	EAU PET 1/2 L	1.00	3.50	21.00	f
9161	3095	\N	CORNET BOLO	1.00	6.00	6.00	f
9172	3098	\N	CORNET LARD	2.00	6.00	6.00	t
9173	3098	\N	FORFAIT	1.00	3.00	12.00	t
9174	3098	\N	ESPRESSO	1.00	2.50	21.00	t
9175	3098	\N	COCA ZERO	3.00	2.20	21.00	t
9176	3098	\N	EAU PET 1/2 L	1.00	3.50	21.00	t
9177	3098	\N	BLANC VERRE	6.00	5.00	21.00	t
9184	3101	\N	ASSIETTE APERITIVE (2 p.)	1.00	10.00	12.00	t
9185	3101	\N	BLANC VERRE	5.00	5.00	21.00	t
9186	3101	\N	JUPILER	2.00	2.50	21.00	t
9187	3101	\N	CHARDONNAY FIO	2.00	4.00	21.00	t
9196	3104	\N	POTEE AL D'JOTE	1.00	18.00	6.00	t
9201	3107	\N	GIN 0%	1.00	8.00	21.00	f
9202	3107	\N	DEFERLANTE	1.00	4.00	21.00	f
9203	3107	\N	ARROSTICINNI (5)	1.00	8.00	12.00	f
9204	3107	\N	EAU PET 1/2 L	2.00	3.50	21.00	f
9205	3107	\N	BLANC VERRE	11.00	5.00	21.00	f
9206	3107	\N	JUPILER	8.00	2.50	21.00	f
9207	3107	\N	VAL DIEU	9.00	4.00	21.00	f
9208	3107	\N	CORNET BOLO	1.00	6.00	6.00	f
9215	3110	\N	BLANC VERRE	2.00	5.00	21.00	f
9216	3110	\N	BLONDINETTE	3.00	4.00	21.00	f
9224	3113	\N	PINOT GRIGIO	1.00	20.00	21.00	t
9225	3113	\N	CHARDONNAY FIO	2.00	4.00	21.00	t
9226	3113	\N	BLANC VERRE	2.00	5.00	21.00	t
9227	3113	\N	COCA ZERO	1.00	2.20	21.00	t
9230	3116	\N	PROSECCO VERRE	1.00	6.00	21.00	t
9231	3116	\N	COCA	1.00	2.20	21.00	t
9232	3116	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	t
9233	3116	\N	CRÊPE GORGONZOLA COURGETTES	1.00	14.00	12.00	t
9245	3119	\N	DEFERLANTE	1.00	4.00	21.00	t
9246	3119	\N	BLONDINETTE	1.00	4.00	21.00	t
9249	3122	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	t
9250	3122	\N	FANTA	1.00	2.20	21.00	t
9251	3122	\N	ICE TEA	1.00	2.20	21.00	t
9252	3122	\N	GINGEMBRE	1.00	10.00	21.00	t
9253	3122	\N	BULLES CHOCOLAT	1.00	8.00	21.00	t
9254	3122	\N	PLAT SPÉCIAL	1.00	18.00	12.00	t
9255	3122	\N	CRÊPE KABYLE	2.00	12.00	12.00	t
9256	3122	\N	CRÊPE CREME LARD	1.00	12.00	12.00	t
9259	3125	\N	MANDURIA	1.00	30.00	21.00	f
9260	3125	\N	DECA	1.00	2.50	21.00	f
9261	3125	\N	CREME BRULEE	1.00	5.00	12.00	f
9262	3125	\N	SABAYON	1.00	8.00	12.00	f
9263	3125	\N	TAJINE	1.00	17.00	12.00	f
9264	3125	\N	CRÊPE GORGONZOLA COURGETTES	1.00	14.00	12.00	f
9265	3125	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
9280	3128	\N	NOURRITURE	-1.00	-26.37	0.00	t
9283	3131	\N	NOURRITURE	-1.00	-77.91	0.00	t
9290	3134	\N	SABAYON SPECIAL	1.00	10.00	12.00	t
9291	3134	\N	DEFERLANTE	1.00	4.00	21.00	t
9292	3134	\N	ROUGE VERRE	1.00	5.00	21.00	t
9293	3134	\N	VIOLETTE	1.00	8.00	21.00	t
9294	3134	\N	COUSCOUS PM	1.00	17.00	12.00	t
9295	3134	\N	CRÊPE GORGONZOLA COURGETTES	1.00	14.00	12.00	t
9299	3137	\N	JUPILER	3.00	2.50	21.00	f
9302	3140	\N	NOURRITURE	-1.00	-41.02	0.00	t
9305	3143	\N	COCA	1.00	0.00	21.00	t
9306	3143	\N	PÂTES TRUFFE + BURRATA	1.00	0.00	12.00	t
9312	3146	\N	RIESLING	1.00	18.00	21.00	t
9313	3146	\N	COUSCOUS PM	2.00	17.00	6.00	t
9321	3149	\N	PLAT SPÉCIAL	1.00	18.00	12.00	f
9322	3149	\N	COUSCOUS PM	1.00	17.00	12.00	f
9323	3149	\N	ASSORTIMENT CROQUETTES	1.00	20.00	6.00	f
9324	3149	\N	VAL DIEU	1.00	4.00	21.00	f
9325	3149	\N	GINGEMBRE	2.00	10.00	21.00	f
9326	3149	\N	GRAPPA	1.00	6.00	21.00	f
9327	3149	\N	MANDURIA	1.00	30.00	21.00	f
9338	3152	\N	COCA	1.00	2.20	21.00	t
9339	3152	\N	FANTA	1.00	2.20	21.00	t
9340	3152	\N	ICE TEA	1.00	2.20	21.00	t
9341	3152	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
9342	3152	\N	PÂTES STRACIATELLA	1.00	16.00	12.00	t
9343	3152	\N	GLACE	1.00	5.00	12.00	t
9039	3058	\N	TEMPO-TEAM	-1.00	-219.32	0.00	t
9046	3061	\N	NOURRITURE	-1.00	-37.57	0.00	t
9054	3064	\N	TIRAMISU GLACÉ	2.00	6.00	12.00	t
9055	3064	\N	CREME BRULEE	1.00	5.00	12.00	t
9056	3064	\N	CREPE BASE + BURRATA	1.00	12.00	12.00	t
9057	3064	\N	CREPE KABYLE	1.00	12.00	12.00	t
9058	3064	\N	COCA	2.00	2.20	21.00	t
9059	3064	\N	PROSECCO VERRE	1.00	6.00	21.00	t
9060	3064	\N	PESTO + BURRATA	1.00	18.00	12.00	t
9069	3067	\N	Service Caro	-1.00	-30.00	0.00	t
9076	3070	\N	ROUGE VERRE	2.00	5.00	21.00	t
9077	3070	\N	EAU PET 1/2 L	1.00	3.50	21.00	t
9078	3070	\N	JUPILER	1.00	2.50	21.00	t
9079	3070	\N	PÂTES BOLO	1.00	13.00	12.00	t
9080	3070	\N	POLPETTE	1.00	16.00	12.00	t
9092	3073	\N	THÉ MENTHE	1.00	2.50	21.00	t
9093	3073	\N	SABAYON	1.00	8.00	12.00	t
9094	3073	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
9095	3073	\N	TAJINE	1.00	17.00	12.00	t
9096	3073	\N	SPARE RIBS	1.00	18.00	21.00	t
9097	3073	\N	Cuba-Li	1.00	8.00	21.00	t
9098	3073	\N	VIOLETTE	1.00	8.00	21.00	t
9102	3076	\N	BEIGNETS FLEUR DE COURGETTES	1.00	18.00	12.00	f
9103	3076	\N	ARROSTICINNI (5)	1.00	8.00	12.00	f
9104	3076	\N	CHARDONNAY FIO	2.00	20.00	21.00	f
9105	3076	\N	ALCOOL	1.00	6.00	21.00	f
9106	3076	\N	RHUM	2.00	6.00	21.00	f
9109	3079	\N	SABAYON	1.00	8.00	12.00	t
9110	3079	\N	COCA ZERO	1.00	2.20	21.00	t
9111	3079	\N	POLPETTE	1.00	16.00	12.00	t
9112	3079	\N	COUSCOUS PM	1.00	17.00	12.00	t
9113	3079	\N	BLANC VERRE	1.00	5.00	21.00	t
9114	3079	\N	ROSÉ VERRE	3.00	5.00	21.00	t
9121	3082	\N	CORNET TRUFFE	1.00	7.00	6.00	f
9125	3085	\N	NOURRITURE	-1.00	-18.26	0.00	t
9132	3088	\N	CAPUCCINO	1.00	2.80	21.00	t
9133	3088	\N	CREME BRULEE	1.00	5.00	12.00	t
9134	3088	\N	TIRAMISU GLACÉ	2.00	6.00	12.00	t
9135	3088	\N	Cuba-Li	1.00	8.00	21.00	t
9136	3088	\N	AMARETTO	1.00	6.00	21.00	t
9137	3088	\N	PECKET FRAISE	1.00	8.00	21.00	t
9138	3088	\N	COCA ZERO	1.00	2.20	21.00	t
9139	3088	\N	CRÊPE KABYLE	1.00	14.00	12.00	t
9140	3088	\N	PÂTES BOMBE ATOMIQUE + BURRATA	1.00	16.00	12.00	t
9141	3088	\N	BEIGNETS FLEUR DE COURGETTES	1.00	18.00	12.00	t
9142	3088	\N	TAJINE	1.00	17.00	12.00	t
9147	3091	\N	JUPILER	3.00	2.50	21.00	t
9159	3094	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
9167	3097	\N	JUPILER	2.00	2.50	21.00	t
9168	3097	\N	DECA	2.00	2.50	21.00	t
9169	3097	\N	CORNET TRUFFE	2.00	7.00	6.00	t
9170	3097	\N	CAFÉ	2.00	2.50	21.00	t
9171	3097	\N	TRIPLE	5.00	4.50	21.00	t
9183	3100	\N	CORNET BOLO	1.00	6.00	6.00	t
9190	3103	\N	CHARDONNAY FIO	2.00	4.00	21.00	f
9191	3103	\N	BLANC VERRE	1.00	5.00	21.00	f
9192	3103	\N	PINOT GRIGIO	1.00	20.00	21.00	f
9193	3103	\N	JUPILER	3.00	2.50	21.00	f
9194	3103	\N	EAU PET 1/2 L	1.00	3.50	21.00	f
9195	3103	\N	BLUSH	1.00	5.00	21.00	f
9198	3106	\N	DEFERLANTE	1.00	4.00	21.00	t
9199	3106	\N	CHARDONNAY FIO	1.00	4.00	21.00	t
9200	3106	\N	ROSÉ MAISON	1.00	3.50	21.00	t
9214	3109	\N	PECKET FRAISE	4.00	8.00	21.00	t
9220	3112	\N	DEFERLANTE	2.00	4.00	21.00	f
9221	3112	\N	CHARDONNAY FIO	2.00	4.00	21.00	f
9222	3112	\N	EAU PET 1/2 L	1.00	3.50	21.00	f
9223	3112	\N	PINOT GRIGIO	2.00	20.00	21.00	f
9229	3115	\N	Service Louna	-1.00	-100.00	0.00	t
9240	3118	\N	HOEGAARDEN ROSEE	1.00	2.50	21.00	f
9241	3118	\N	FANTA	1.00	2.20	21.00	f
9242	3118	\N	ROSÉ MAISON	12.00	3.50	21.00	f
9243	3118	\N	EAU PÉTILLANTE 1 L	3.00	5.00	21.00	f
9244	3118	\N	JUPILER	1.00	2.50	21.00	f
9248	3121	\N	ROSÉ MAISON	5.00	3.50	21.00	f
9258	3124	\N	ROSÉ MAISON	5.00	3.50	21.00	f
9267	3127	\N	TIRAMISU GLACÉ	2.00	6.00	12.00	t
9268	3127	\N	FANTA	1.00	2.20	21.00	t
9269	3127	\N	COCA	4.00	2.20	21.00	t
9270	3127	\N	PROSECCO VERRE	2.00	6.00	21.00	t
9271	3127	\N	TAJINE	1.00	17.00	12.00	t
9272	3127	\N	PÂTES PESTO + BURRATA	1.00	18.00	12.00	t
9273	3127	\N	PÂTES COURGETTE	1.00	14.00	12.00	t
9274	3127	\N	PÂTES BOMBE ATOMIQUE + BURRATA	1.00	17.00	12.00	t
9275	3127	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
9276	3127	\N	PÂTES STRACIATELLA SCAMPIS	2.00	19.00	12.00	t
9277	3127	\N	COUSCOUS PM	1.00	17.00	12.00	t
9278	3127	\N	EAU PÉTILLANTE 1 L	2.00	5.00	21.00	t
9279	3127	\N	ESPRESSO	1.00	2.50	21.00	t
9282	3130	\N	NOURRITURE	-1.00	-13.83	0.00	t
9285	3133	\N	ICE TEA	1.00	2.20	21.00	f
9286	3133	\N	GIN 0%	1.00	8.00	21.00	f
9287	3133	\N	PROSECCO VERRE	1.00	6.00	21.00	f
9288	3133	\N	TAJINE	1.00	17.00	12.00	f
9289	3133	\N	COUSCOUS PM	1.00	17.00	12.00	f
9297	3136	\N	JUPILER	1.00	2.50	21.00	f
9298	3136	\N	ROSÉ MAISON	4.00	3.50	21.00	f
9301	3139	\N	NOURRITURE	-1.00	-39.40	0.00	t
9304	3142	\N	CORNET BOLO	1.00	6.00	6.00	t
9311	3145	\N	ROSÉ MAISON	2.00	3.50	21.00	t
9315	3148	\N	PÂTES TRUFFE + BURRATA	2.00	17.00	12.00	t
9316	3148	\N	PÂTES STRACIATELLA SCAMPIS	1.00	19.00	12.00	t
9317	3148	\N	ASSORTIMENT CROQUETTES	3.00	20.00	6.00	t
9318	3148	\N	GIN 0%	1.00	8.00	21.00	t
9319	3148	\N	TRIPLE	1.00	4.50	21.00	t
9320	3148	\N	VAL DIEU	1.00	4.00	21.00	t
9335	3151	\N	HOEGAARDEN ROSEE	1.00	2.50	21.00	f
9336	3151	\N	JUPILER	3.00	2.50	21.00	f
9337	3151	\N	CORNET BOLO	2.00	6.00	6.00	f
9352	3154	\N	ASSORTIMENT CROQUETTES	1.00	20.00	6.00	t
9353	3154	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	t
9354	3154	\N	PÂTES PESTO	1.00	14.00	12.00	t
9355	3154	\N	PROSECCO VERRE	2.00	6.00	21.00	t
9358	3157	\N	CAFÉ	1.00	2.50	21.00	f
9359	3157	\N	Cuba-Li	3.00	8.00	21.00	f
9360	3157	\N	EAU PET VERRE	1.00	2.20	21.00	f
9361	3157	\N	ROSÉ MAISON	4.00	3.50	21.00	f
9362	3157	\N	COCA ZERO	1.00	2.20	21.00	f
9363	3157	\N	COCA	3.00	2.20	21.00	f
9247	3120	\N	BOISSONS	-1.00	-240.00	0.00	t
9257	3123	\N	ROSÉ MAISON	3.00	3.50	21.00	f
9266	3126	\N	COUSCOUS PM	12.00	17.00	12.00	f
9281	3129	\N	MERGUEZ	-1.00	-32.95	0.00	t
9284	3132	\N	BOISSONS	-1.00	-60.00	0.00	t
9296	3135	\N	Service Caro	-1.00	-60.00	0.00	t
9300	3138	\N	POULET	-1.00	-87.50	0.00	t
9303	3141	\N	CREME BRULEE	2.00	5.00	6.00	f
9307	3144	\N	TIRAMISU GLACÉ	2.00	6.00	12.00	t
9308	3144	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
9309	3144	\N	PÂTES BOLO	1.00	14.00	12.00	t
9310	3144	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
9314	3147	\N	JUPILER	1.00	2.50	21.00	f
9328	3150	\N	MANDURIA	1.00	30.00	21.00	t
9329	3150	\N	PÂTES	2.00	10.00	12.00	t
9330	3150	\N	COUSCOUS PM	2.00	17.00	12.00	t
9331	3150	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
9332	3150	\N	GINGEMBRE	1.00	10.00	21.00	t
9333	3150	\N	VIOLETTE	1.00	8.00	21.00	t
9334	3150	\N	FANTA	1.00	2.20	21.00	t
9344	3153	\N	COUSCOUS PM	1.00	17.00	12.00	t
9345	3153	\N	TAJINE	1.00	17.00	12.00	t
9346	3153	\N	BLONDINETTE	1.00	4.00	21.00	t
9347	3153	\N	VIOLETTE	1.00	8.00	21.00	t
9348	3153	\N	CREME CITRON	1.00	6.00	21.00	t
9349	3153	\N	LIMONCELLO	1.00	6.00	21.00	t
9350	3153	\N	CREME BRULEE	1.00	5.00	12.00	t
9351	3153	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
9357	3156	\N	CORNET LARD	2.00	6.00	6.00	t
9369	3159	\N	CORNET LARD	1.00	6.00	6.00	f
9372	3162	\N	NOURRITURE	-1.00	-53.84	0.00	t
10174	3423	\N	Cuba-Li	1.00	8.00	21.00	f
10175	3423	\N	JUPILER	3.00	2.50	21.00	f
10178	3426	\N	BIERE AUTRE	2.00	2.50	21.00	f
10183	3429	\N	COCA	1.00	2.20	21.00	f
10184	3429	\N	Cuba-Li	2.00	8.00	21.00	f
10189	3432	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	f
10192	3435	\N	BOIS COCHON	-1.00	-160.00	0.00	t
10195	3438	\N	FRAIS	-1.00	-20.00	0.00	t
10198	3441	\N	TEMPO-TEAM	-1.00	-172.16	0.00	t
10201	3444	\N	BIERLAINOISE	1.00	4.00	6.00	t
10202	3444	\N	VAL DIEU	3.00	4.00	21.00	t
10203	3444	\N	PECKET FRAISE	1.00	8.00	21.00	t
10204	3444	\N	FANTA	2.00	2.20	21.00	t
10205	3444	\N	MANDURIA	5.00	5.00	21.00	t
10206	3444	\N	PÂTES STRACIATELLA	1.00	16.00	12.00	t
10207	3444	\N	PÂTES CREME LARDONS	1.00	14.00	12.00	t
10208	3444	\N	PÂTES RAGÙ	1.00	15.00	12.00	t
10213	3447	\N	NOURRITURE	-1.00	-68.38	0.00	t
10224	3450	\N	NOURRITURE	-1.00	-38.89	0.00	t
10235	3453	\N	CREME BRULEE	3.00	5.00	12.00	f
10245	3456	\N	CANNELLONI RICO/EPI	1.00	12.00	12.00	t
10246	3456	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	t
10247	3456	\N	Cuba-Li	2.00	8.00	21.00	t
10257	3459	\N	TAJINE	1.00	17.00	12.00	t
10258	3459	\N	CRÊPE GORGONZOLA COURGETTES	1.00	14.00	12.00	t
10259	3459	\N	PÂTES COURGETTE	1.00	14.00	12.00	t
10260	3459	\N	SCAMPIS LUCIFER	1.00	12.00	12.00	t
10261	3459	\N	ASSORTIMENT CROQUETTES	1.00	20.00	6.00	t
10262	3459	\N	VAL DIEU	1.00	4.00	21.00	t
10263	3459	\N	FANTA	1.00	2.20	21.00	t
10264	3459	\N	PROSECCO VERRE	1.00	6.00	21.00	t
10265	3459	\N	NERO D'AVOLA	1.00	30.00	21.00	t
10266	3459	\N	CREME BRULEE	1.00	5.00	12.00	t
10274	3462	\N	COCA ZERO	1.00	2.20	21.00	t
10275	3462	\N	CAFÉ	2.00	2.50	21.00	t
10276	3462	\N	CREME BRULEE	2.00	5.00	12.00	t
10300	3465	\N	Service HANAË	-1.00	-70.00	0.00	t
10303	3468	\N	Service CHA	-1.00	-30.00	0.00	t
10307	3471	\N	Service Elise	-1.00	-75.00	0.00	t
10310	3474	\N	NOURRITURE	-1.00	-30.68	0.00	t
10318	3477	\N	CREME BRULEE	2.00	6.00	12.00	t
10319	3477	\N	POLPETTE	1.00	16.00	12.00	t
10320	3477	\N	PÂTES CREME LARDONS	1.00	14.00	12.00	t
10321	3477	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
10324	3480	\N	BOISSONS	-1.00	-92.82	0.00	t
10332	3483	\N	ROUGE VERRE	2.00	5.00	21.00	t
10333	3483	\N	POLPETTE	1.00	16.00	12.00	t
10336	3486	\N	PROXIMUS	-1.00	-138.97	0.00	t
10339	3489	\N	COMPTABLE	-1.00	-217.80	0.00	t
10342	3492	\N	AUTO	-1.00	-532.63	0.00	t
10348	3495	\N	VIN DU MOIS	1.00	15.00	21.00	f
10349	3495	\N	CANNELLONI VIANDE	1.00	17.00	12.00	f
10350	3495	\N	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	f
10351	3495	\N	ASSORTIMENT CROQUETTES	1.00	20.00	12.00	f
10373	3498	\N	CORNET LARD	1.00	6.00	6.00	f
10381	3501	\N	NOURRITURE	-1.00	-10.00	0.00	t
10386	3504	\N	ESPRESSO	1.00	2.50	21.00	f
10387	3504	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	f
10388	3504	\N	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	f
10389	3504	\N	COCA	1.00	2.20	21.00	f
10390	3504	\N	PECKET FRAISE	1.00	8.00	21.00	f
10415	3507	\N	COCA	1.00	2.20	21.00	t
10416	3507	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	t
10417	3507	\N	PECKET FRAISE	1.00	8.00	21.00	t
10418	3507	\N	VIN DU MOIS	1.00	15.00	21.00	t
10419	3507	\N	PROSECCO VERRE	1.00	6.00	21.00	t
10420	3507	\N	VIANDE + GRATIN	2.00	24.00	12.00	t
10421	3507	\N	CANNELLONI VIANDE	2.00	17.00	12.00	t
10422	3507	\N	POLPETTE	1.00	16.00	12.00	t
10423	3507	\N	CREPE SUCRE	1.00	5.00	12.00	t
10424	3507	\N	CREME BRULEE	1.00	6.00	12.00	t
10425	3507	\N	ROUGE VERRE	4.00	5.00	21.00	t
10438	3510	\N	ROSÉ VERRE	1.00	5.00	21.00	f
10439	3510	\N	BLONDINETTE	1.00	4.00	21.00	f
10440	3510	\N	PECKET FRAISE	2.00	8.00	21.00	f
10443	3513	\N	ROSÉ VERRE	1.00	5.00	21.00	t
10444	3513	\N	BLONDINETTE	1.00	4.00	21.00	t
10445	3513	\N	VAL DIEU	2.00	4.00	21.00	t
10449	3516	\N	JUPILER	1.00	2.50	21.00	f
10466	3519	\N	THÉ MENTHE	2.00	2.50	21.00	t
10467	3519	\N	BIERE AUTRE	1.00	2.50	21.00	t
10468	3519	\N	ORVAL	1.00	5.00	21.00	t
10469	3519	\N	COUSCOUS PM	1.00	17.00	12.00	t
10470	3519	\N	PÂTES COURGETTE	1.00	14.00	12.00	t
10471	3519	\N	ASSORTIMENT CROQUETTES	1.00	20.00	12.00	t
10472	3519	\N	ICE TEA	2.00	2.20	21.00	t
10473	3519	\N	PROSECCO VERRE	1.00	6.00	21.00	t
10480	3522	\N	NOURRITURE	-1.00	-8.00	0.00	t
9356	3155	\N	Service Léa	-1.00	-75.00	0.00	t
9368	3158	\N	NOURRITURE	-1.00	-13.74	0.00	t
9371	3161	\N	BOISSONS	-1.00	-93.00	0.00	t
10338	3488	\N	LOYER	-1.00	-600.00	0.00	t
10341	3491	\N	CARBURANT	-1.00	-102.16	0.00	t
10344	3494	\N	CREME BRULEE	1.00	6.00	12.00	f
10345	3494	\N	CAFÉ	1.00	2.50	21.00	f
10346	3494	\N	ROSÉ VERRE	2.00	5.00	21.00	f
10347	3494	\N	COUSCOUS PM	1.00	17.00	12.00	f
10362	3497	\N	TIRAMISU GLACÉ	3.00	6.00	12.00	t
10363	3497	\N	SABAYON SPECIAL	1.00	10.00	12.00	t
10364	3497	\N	PLAT SPÉCIAL	1.00	24.00	12.00	t
10365	3497	\N	FANTA	1.00	2.20	21.00	t
10366	3497	\N	ICE TEA	1.00	2.20	21.00	t
10367	3497	\N	BULLES CHOCOLAT	1.00	16.00	21.00	t
10368	3497	\N	VIOLETTE	1.00	8.00	21.00	t
10369	3497	\N	CRÊPE KABYLE	2.00	14.00	12.00	t
10370	3497	\N	CANNELLONI VIANDE	1.00	17.00	12.00	t
10371	3497	\N	EAU PET 1/2 L	1.00	3.50	21.00	t
10372	3497	\N	COCA ZERO	2.00	2.20	21.00	t
10380	3500	\N	NOURRITURE	-1.00	-73.31	0.00	t
10383	3503	\N	ROUGE VERRE	1.00	5.00	21.00	f
10384	3503	\N	COUSCOUS VG	2.00	12.00	12.00	f
10385	3503	\N	CHAMPIGNONS KABYLES	2.00	10.00	12.00	f
10408	3506	\N	MANDURIA	1.00	30.00	21.00	t
10409	3506	\N	CHAKTCHOUKA	1.00	12.00	12.00	t
10410	3506	\N	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	t
10411	3506	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	t
10412	3506	\N	PECKET FRAISE	1.00	8.00	21.00	t
10413	3506	\N	TRIPLE	1.00	4.50	21.00	t
10414	3506	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
10428	3509	\N	AMARONE	1.00	50.00	21.00	f
10429	3509	\N	CANNELLONI VIANDE	2.00	17.00	12.00	f
10430	3509	\N	ASSIETTE APERITIVE (2 p.)	1.00	10.00	12.00	f
10431	3509	\N	CAFÉ	2.00	2.50	21.00	f
10432	3509	\N	COCA ZERO	1.00	2.20	21.00	f
10433	3509	\N	THÉ MENTHE	1.00	2.50	21.00	f
10434	3509	\N	Cuba-Li	1.00	8.00	21.00	f
10435	3509	\N	IRISH COFFEE	1.00	8.00	21.00	f
10436	3509	\N	HOEGAARDEN ROSEE	1.00	2.50	21.00	f
10437	3509	\N	JUPILER	1.00	2.50	21.00	f
10442	3512	\N	Service Elise	-1.00	-55.00	0.00	t
10447	3515	\N	ROSÉ MAISON	1.00	3.50	21.00	f
10448	3515	\N	VAL DIEU	1.00	4.00	21.00	f
10455	3518	\N	VIN DU MOIS	1.00	15.00	21.00	t
10456	3518	\N	PÂTES COURGETTE + SCAMPIS+BURRATA	1.00	22.00	12.00	t
10457	3518	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
10458	3518	\N	SABAYON	1.00	8.00	12.00	t
10459	3518	\N	SABAYON SPECIAL	1.00	10.00	12.00	t
10460	3518	\N	PÂTES TRUFFE + BURRATA	2.00	18.00	12.00	t
10461	3518	\N	CANNELLONI VIANDE	1.00	17.00	12.00	t
10462	3518	\N	ASSIETTE APERITIVE (2 p.)	2.00	19.00	12.00	t
10463	3518	\N	VIOLETTE	2.00	8.00	21.00	t
10464	3518	\N	ICE TEA	1.00	2.20	21.00	t
10465	3518	\N	PROSECCO VERRE	1.00	6.00	21.00	t
10479	3521	\N	Service ANTON	-1.00	-60.00	0.00	t
10482	3524	\N	NOURRITURE	-1.00	-57.85	0.00	t
10485	3527	\N	FANTA	1.00	2.20	21.00	f
10486	3527	\N	CORNET TRUFFE	1.00	7.00	6.00	f
10490	3530	\N	THERMES	-1.00	-76.50	0.00	t
10493	3533	\N	CARBURANT	-1.00	-104.66	0.00	t
10503	3535	\N	PÂTES PESTO + BURRATA	1.00	18.00	12.00	t
10504	3535	\N	VIANDE + GRATIN	1.00	24.00	12.00	t
10505	3536	\N	CHARDONNAY FIO	1.00	10.00	21.00	t
10506	3536	\N	JUPILER	4.00	2.50	21.00	t
10512	3538	\N	GLACE	1.00	5.00	12.00	t
10513	3538	\N	SABAYON SPECIAL	1.00	10.00	12.00	t
10514	3538	\N	ICE TEA	1.00	2.20	21.00	t
10515	3538	\N	PECKET FRAISE	1.00	8.00	21.00	t
10516	3538	\N	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	t
10517	3538	\N	TAJINE	1.00	17.00	12.00	t
10518	3539	\N	JUPILER	1.00	2.50	21.00	f
10519	3539	\N	ROSÉ MAISON	1.00	3.50	21.00	f
10520	3539	\N	ARROSTICINNI (5)	1.00	8.00	12.00	f
10523	3541	\N	CAFE	-1.00	-40.00	0.00	t
10524	3542	\N	LOYER	-1.00	-600.00	0.00	t
10528	3544	\N	NOURRITURE	-1.00	-10.37	0.00	t
10529	3545	\N	BLANC VERRE	2.00	5.00	21.00	f
10530	3545	\N	PÂTES BOLO	1.00	14.00	12.00	f
10537	3547	\N	GIN TONIC	1.00	10.00	21.00	f
10538	3547	\N	PROSECCO VERRE	1.00	6.00	21.00	f
10539	3547	\N	COCA ZERO	1.00	2.20	21.00	f
10540	3548	\N	AMARETTO	1.00	6.00	21.00	f
10541	3548	\N	SAMBUCA	1.00	6.00	21.00	f
10542	3548	\N	BLANCOCA	3.00	4.00	21.00	f
10543	3548	\N	THÉ MENTHE	1.00	2.50	21.00	f
10544	3548	\N	COCA ZERO	1.00	2.20	21.00	f
10545	3548	\N	PÂTES COURGETTE + SCAMPIS	2.00	18.00	12.00	f
10546	3548	\N	PÂTES PESTO + BURRATA	1.00	18.00	12.00	f
10547	3548	\N	CANNELLONI VIANDE	1.00	17.00	12.00	f
10548	3548	\N	PINOT GRIGIO	1.00	20.00	21.00	f
10549	3548	\N	GINGEMBRE	1.00	10.00	21.00	f
10550	3548	\N	VIOLETTE	1.00	8.00	21.00	f
10553	3551	\N	NOURRITURE	-1.00	-34.88	0.00	t
10563	3554	\N	Service ANTON	-1.00	-75.00	0.00	t
10566	3557	\N	ROUGE VERRE	1.00	5.00	21.00	f
10567	3557	\N	COCA ZERO	1.00	2.20	21.00	f
10568	3557	\N	PÂTES TRUFFE + BURRATA	2.00	18.00	12.00	f
10579	3560	\N	SMASH	2.00	4.50	21.00	t
10580	3560	\N	BLANC VERRE	3.00	5.00	21.00	t
10591	3563	\N	MANDURIA	1.00	30.00	21.00	f
10592	3563	\N	PÂTES TRUFFE	1.00	14.00	12.00	f
10593	3563	\N	COUSCOUS PM	1.00	17.00	12.00	f
10594	3563	\N	ASSORTIMENT CROQUETTES	1.00	20.00	12.00	f
10595	3563	\N	PECKET FRAISE	1.00	8.00	21.00	f
10596	3563	\N	Cuba-Li	1.00	8.00	21.00	f
10599	3566	\N	NOURRITURE	-1.00	-34.45	0.00	t
10602	3569	\N	NOURRITURE	-1.00	-56.00	0.00	t
10605	3572	\N	VIN DU MOIS	1.00	15.00	21.00	f
10606	3572	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	f
10607	3572	\N	VIANDE + GRATIN	1.00	24.00	12.00	f
10608	3572	\N	GINGEMBRE	1.00	10.00	21.00	f
10609	3572	\N	Cuba-Li	1.00	8.00	21.00	f
10626	3575	\N	Cuba-Li	1.00	8.00	21.00	t
10627	3575	\N	GINGEMBRE	1.00	10.00	21.00	t
10628	3575	\N	POLPETTE	1.00	16.00	12.00	t
10629	3575	\N	TAJINE	1.00	17.00	12.00	t
10639	3578	\N	CROQUETTES	-1.00	-91.80	0.00	t
10643	3581	\N	NOURRITURE	-1.00	-23.94	0.00	t
9364	3157	\N	ALCOOL	1.00	6.00	21.00	f
9365	3157	\N	POLPETTE	1.00	16.00	12.00	f
9366	3157	\N	ASSORTIMENT CROQUETTES	1.00	20.00	6.00	f
9367	3157	\N	CANNELLONI VIANDE	1.00	18.00	12.00	f
9370	3160	\N	PÂTES CREME LARDONS	1.00	14.00	6.00	t
9373	3163	\N	ESPRESSO	2.00	2.50	21.00	f
9374	3163	\N	COUSCOUS PM	2.00	17.00	12.00	f
9375	3163	\N	MANDURIA	1.00	30.00	21.00	f
9376	3163	\N	BLANC VERRE	2.00	5.00	21.00	f
9377	3164	\N	PÂTES CREME LARDONS	1.00	0.00	12.00	f
9378	3165	\N	CREME BRULEE	2.00	5.00	6.00	t
9379	3166	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	f
9380	3166	\N	TAJINE	1.00	17.00	12.00	f
9381	3166	\N	COUSCOUS PM	2.00	17.00	12.00	f
9382	3166	\N	PRIMITIVO NR 14	5.00	5.00	21.00	f
9383	3167	\N	BLONDINETTE	1.00	4.00	21.00	t
9384	3167	\N	COCA	1.00	2.20	21.00	t
9385	3167	\N	CRÊPE CHAKCHOUKA	1.00	14.00	12.00	t
9386	3167	\N	PÂTES BOMBE ATOMIQUE + BURRATA	1.00	17.00	12.00	t
9387	3167	\N	PÂTES STRACIATELLA SCAMPIS	1.00	19.00	12.00	t
9388	3167	\N	PECKET FRAISE	1.00	8.00	21.00	t
9389	3167	\N	ROUGE VERRE	2.00	5.00	21.00	t
9390	3167	\N	PROSECCO VERRE	1.00	6.00	21.00	t
9391	3168	\N	NERO D'AVOLA	1.00	30.00	21.00	f
9392	3168	\N	TAJINE	2.00	17.00	12.00	f
9393	3169	\N	LOYER	-1.00	-600.00	0.00	t
9394	3170	\N	Service Carol	-1.00	-147.00	0.00	t
9395	3171	\N	Service Carol	-1.00	-134.67	0.00	t
9396	3172	\N	Service Léa	-1.00	-136.80	0.00	t
9397	3173	\N	Service HANAË	-1.00	-118.58	0.00	t
9398	3174	\N	COCA ZERO	1.00	2.20	21.00	t
9399	3174	\N	CAFÉ	1.00	2.50	21.00	t
9400	3174	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
9401	3174	\N	CREME BRULEE	1.00	5.00	12.00	t
9402	3174	\N	BLUSH	1.00	20.00	21.00	t
9403	3174	\N	EAU PET 1/2 L	1.00	3.50	21.00	t
9404	3174	\N	PÂTES BOLO	1.00	14.00	12.00	t
9405	3174	\N	CONTRE FILET+GRATIN	1.00	24.00	12.00	t
9406	3174	\N	PROSECCO VERRE	2.00	6.00	21.00	t
9407	3174	\N	VAL DIEU	2.00	4.00	21.00	t
9408	3175	\N	EAU PET 1/2 L	1.00	3.50	21.00	t
9409	3175	\N	ROUGE VERRE	2.00	5.00	21.00	t
9410	3175	\N	BLANC VERRE	3.00	5.00	21.00	t
9411	3175	\N	PROSECCO VERRE	1.00	6.00	21.00	t
9412	3175	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
9413	3175	\N	CRÊPE GORGONZOLA COURGETTES	1.00	14.00	12.00	t
9414	3175	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
9415	3176	\N	COCA	1.00	0.00	21.00	t
9416	3176	\N	PÂTES CREME LARDONS	1.00	0.00	12.00	t
9417	3177	\N	ICE TEA	1.00	0.00	21.00	f
9418	3177	\N	BLANC VERRE	4.00	0.00	21.00	f
9419	3177	\N	VAL DIEU	2.00	0.00	21.00	f
9420	3177	\N	PÂTES STRACIATELLA SCAMPIS	1.00	0.00	12.00	f
9421	3177	\N	PÂTES COURGETTE + SCAMPIS	1.00	10.00	12.00	f
9422	3178	\N	NOURRITURE	-1.00	-39.14	0.00	t
9423	3179	\N	NOURRITURE	-1.00	-22.95	0.00	t
9424	3180	\N	COUSCOUS PM	2.00	17.00	12.00	f
9425	3180	\N	PÂTES TRUFFE	1.00	14.00	12.00	f
9426	3180	\N	ICE TEA	1.00	2.20	21.00	f
9427	3180	\N	PROSECCO VERRE	1.00	6.00	21.00	f
9428	3180	\N	ROUGE VERRE	4.00	5.00	21.00	f
9429	3181	\N	THÉ MENTHE	1.00	2.50	21.00	t
9430	3181	\N	ESPRESSO	1.00	2.50	21.00	t
9431	3181	\N	CREME BRULEE	1.00	5.00	12.00	t
9432	3181	\N	COUSCOUS VG	1.00	12.00	12.00	t
9433	3181	\N	COUSCOUS PM	1.00	17.00	12.00	t
9434	3181	\N	VIOLETTE	1.00	8.00	21.00	t
9435	3181	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
9436	3181	\N	Cuba-Li	1.00	8.00	21.00	t
9437	3182	\N	THÉ MENTHE	2.00	2.50	21.00	t
9438	3182	\N	CRÊPE GORGONZOLA COURGETTES	1.00	14.00	12.00	t
9439	3182	\N	PÂTES COURGETTE + SCAMPIS+BURRATA	1.00	22.00	12.00	t
9440	3182	\N	PECKET FRAISE	2.00	8.00	21.00	t
9441	3183	\N	DEFERLANTE	1.00	4.00	21.00	t
9442	3183	\N	BLONDINETTE	2.00	4.00	21.00	t
9443	3184	\N	COCA	1.00	2.20	21.00	t
9444	3184	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
9445	3184	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
9446	3184	\N	PÂTES CREME LARDONS	1.00	14.00	12.00	t
9447	3184	\N	CRÊPE GORGONZOLA COURGETTES	1.00	14.00	12.00	t
9448	3184	\N	ROUGE VERRE	4.00	5.00	21.00	t
9449	3184	\N	PÂTES SAUCE BASE	1.00	12.00	12.00	t
9450	3184	\N	PÂTES BOMBE ATOMIQUE + BURRATA	1.00	17.00	12.00	t
9451	3184	\N	PÂTES	1.00	8.00	12.00	t
9452	3184	\N	PECKET FRAISE	4.00	8.00	21.00	t
9453	3185	\N	THÉ MENTHE	4.00	2.50	21.00	f
9454	3185	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	f
9455	3185	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	f
9456	3185	\N	PINOT GRIGIO	1.00	20.00	21.00	f
9457	3185	\N	NERO D'AVOLA	1.00	30.00	21.00	f
9458	3185	\N	CAFÉ	1.00	2.50	21.00	f
9459	3185	\N	GRAPPA	1.00	6.00	21.00	f
9460	3185	\N	COUSCOUS PM	1.00	17.00	12.00	f
9461	3185	\N	TAJINE	2.00	17.00	12.00	f
9462	3185	\N	PÂTES COURGETTE + SCAMPIS	2.00	18.00	12.00	f
9463	3185	\N	ROSÉ VERRE	2.00	5.00	21.00	f
9464	3185	\N	BLONDINETTE	2.00	4.00	21.00	f
9465	3185	\N	Cuba-Li	1.00	8.00	21.00	f
9466	3185	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
9467	3186	\N	JUPILER	1.00	2.50	21.00	t
9468	3186	\N	COCA ZERO	3.00	2.20	21.00	t
9469	3186	\N	CRÊPE CHAKCHOUKA	1.00	14.00	12.00	t
9470	3186	\N	CANNELLONI VIANDE	2.00	18.00	12.00	t
9471	3186	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	t
9472	3186	\N	COUSCOUS PM	4.00	17.00	12.00	t
9473	3186	\N	VAL DIEU	2.00	4.00	21.00	t
9474	3186	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
9475	3186	\N	SCAMPIS LUCIFER	2.00	12.00	12.00	t
9476	3186	\N	CHAMPIGNONS KABYLES	3.00	10.00	12.00	t
9477	3186	\N	ORVAL	1.00	5.00	21.00	t
9478	3186	\N	CHARDONNAY FIO	1.00	20.00	21.00	t
9479	3186	\N	BLONDINETTE	1.00	4.00	21.00	t
9480	3186	\N	COCA	2.00	2.20	21.00	t
9481	3186	\N	GIN 0%	1.00	8.00	21.00	t
9482	3186	\N	Cuba-Li	2.00	8.00	21.00	t
9483	3186	\N	PROSECCO VERRE	1.00	6.00	21.00	t
9484	3186	\N	NERO D'AVOLA	1.00	30.00	21.00	t
9485	3187	\N	Service Léa	-1.00	-45.00	0.00	t
9488	3190	\N	NOURRITURE	-1.00	-27.63	0.00	t
9503	3193	\N	NOURRITURE	-1.00	-11.76	0.00	t
9506	3196	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	f
9507	3196	\N	PÂTES CREME LARDONS	1.00	14.00	12.00	f
9508	3196	\N	CANNELLONI RICO/EPI	1.00	17.00	12.00	f
9509	3196	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
9510	3196	\N	PINOT GRIGIO	2.00	5.00	21.00	f
9511	3196	\N	COCA	3.00	2.20	21.00	f
9519	3199	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
9520	3199	\N	PÂTES TRUFFE	1.00	14.00	12.00	t
9521	3199	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
9522	3199	\N	COCA ZERO	1.00	2.20	21.00	t
9523	3199	\N	PROSECCO VERRE	1.00	6.00	21.00	t
9529	3202	\N	Cuba-Li	1.00	0.00	21.00	t
9530	3202	\N	ROSÉ MAISON	2.00	0.00	21.00	t
9535	3205	\N	CAFÉ	2.00	2.50	21.00	f
9536	3205	\N	ROUGE 1/2	1.00	14.00	21.00	f
9537	3205	\N	GINGEMBRE	1.00	10.00	21.00	f
9538	3205	\N	Cuba-Li	1.00	8.00	21.00	f
9539	3205	\N	COUSCOUS PM	2.00	17.00	12.00	f
9554	3208	\N	BLONDINETTE	4.00	4.00	21.00	f
9567	3211	\N	ALCOOL	1.00	6.00	21.00	f
9568	3211	\N	LIMONCELLO	2.00	6.00	21.00	f
9571	3214	\N	PROSECCO VERRE	1.00	6.00	21.00	t
9574	3217	\N	JUPILER	1.00	2.50	21.00	f
9577	3220	\N	PROSECCO VERRE	1.00	6.00	21.00	t
9578	3220	\N	CORNET BOLO	4.00	6.00	6.00	t
9582	3223	\N	JUPILER	1.00	2.50	21.00	f
9583	3223	\N	BLANC VERRE	1.00	5.00	21.00	f
9584	3223	\N	BLONDINETTE	2.00	4.00	21.00	f
9589	3226	\N	BLONDINETTE	1.00	4.00	21.00	f
9590	3226	\N	CORNET TRUFFE	1.00	7.00	6.00	f
9591	3226	\N	CORNET LARD	1.00	6.00	6.00	f
9594	3229	\N	CORNET BOLO	1.00	6.00	6.00	f
9595	3229	\N	CORNET LARD	1.00	6.00	6.00	f
9603	3232	\N	BLANC VERRE	1.00	5.00	21.00	f
9604	3232	\N	CORNET LARD	1.00	6.00	6.00	f
9607	3235	\N	CORNET BOLO	1.00	6.00	6.00	f
9608	3235	\N	CORNET LARD	1.00	6.00	6.00	f
9614	3238	\N	CORNET BOLO	2.00	6.00	6.00	t
9619	3241	\N	CORNET TRUFFE	1.00	7.00	6.00	f
9620	3241	\N	CORNET BOLO	1.00	6.00	6.00	f
9621	3241	\N	CORNET LARD	2.00	6.00	6.00	f
9628	3244	\N	ICE TEA	1.00	2.20	21.00	f
9629	3244	\N	COCA ZERO	1.00	2.20	21.00	f
9630	3244	\N	PROSECCO VERRE	1.00	6.00	21.00	f
9631	3244	\N	VAL DIEU	1.00	4.00	21.00	f
9639	3247	\N	PÂTES COURGETTE + SCAMPIS+BURRATA	1.00	22.00	12.00	f
9640	3247	\N	COUSCOUS PM	2.00	17.00	12.00	f
9641	3247	\N	GIN TONIC	1.00	10.00	21.00	f
9642	3247	\N	PECKET FRAISE	1.00	8.00	21.00	f
9643	3247	\N	BLANC VERRE	2.00	5.00	21.00	f
9644	3247	\N	SABAYON SPECIAL	1.00	10.00	12.00	f
9645	3247	\N	ROUGE VERRE	1.00	5.00	21.00	f
9652	3250	\N	CANNELLONI RICO/EPI	1.00	17.00	12.00	t
9653	3250	\N	ROUGE 1/4	3.00	8.00	21.00	t
9654	3250	\N	CANNELLONI VIANDE	1.00	18.00	12.00	t
9655	3250	\N	PROSECCO VERRE	1.00	6.00	21.00	t
9656	3250	\N	CORNET LARD	1.00	6.00	6.00	t
9657	3250	\N	POTEE AL D'JOTE	1.00	18.00	12.00	t
9674	3253	\N	JUPILER	2.00	2.50	21.00	t
9675	3253	\N	LIMONCELLO	2.00	6.00	21.00	t
9676	3253	\N	CREME BRULEE	2.00	5.00	12.00	t
9677	3253	\N	IRISH COFFEE	2.00	8.00	21.00	t
9678	3253	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
9679	3253	\N	COUSCOUS PM	4.00	17.00	12.00	t
9680	3253	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
9681	3253	\N	MANDURIA	1.00	30.00	21.00	t
9682	3253	\N	DEFERLANTE	2.00	4.00	21.00	t
9683	3253	\N	ORVAL	2.00	5.00	21.00	t
9684	3253	\N	BLONDINETTE	2.00	4.00	21.00	t
9685	3253	\N	TRIPLE	1.00	4.50	21.00	t
9694	3256	\N	Cuba-Li	3.00	8.00	21.00	t
9702	3259	\N	Cuba-Li	2.00	8.00	21.00	f
9703	3259	\N	DEFERLANTE	1.00	4.00	21.00	f
9714	3262	\N	SABAYON	1.00	8.00	12.00	t
9715	3262	\N	COUSCOUS PM	1.00	17.00	12.00	t
9716	3262	\N	PÂTES TRUFFE	1.00	14.00	12.00	t
9717	3262	\N	ASSORTIMENT CROQUETTES	1.00	20.00	6.00	t
9718	3262	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
9719	3262	\N	CREME BRULEE	1.00	5.00	12.00	t
9726	3265	\N	BOISSONS	-1.00	-213.00	0.00	t
9731	3268	\N	BLANC VERRE	4.00	5.00	21.00	t
9732	3268	\N	COUSCOUS VG	1.00	12.00	12.00	t
9733	3268	\N	PÂTES CREME LARDONS	1.00	14.00	12.00	t
9734	3268	\N	ASSIETTE APERITIVE (2 p.)	1.00	10.00	12.00	t
9744	3271	\N	BLANC VERRE	1.00	5.00	21.00	t
9748	3274	\N	ICE TEA	1.00	2.20	21.00	f
9749	3274	\N	COCA ZERO	2.00	2.20	21.00	f
9750	3274	\N	JUPILER	5.00	2.50	21.00	f
9751	3274	\N	BLANC VERRE	3.00	5.00	21.00	f
9755	3277	\N	CORNET TRUFFE	1.00	7.00	6.00	f
9756	3277	\N	CORNET LARD	1.00	6.00	6.00	f
9773	3280	\N	CORNET TRUFFE	1.00	7.00	6.00	t
9774	3280	\N	CORNET LARD	1.00	6.00	6.00	t
9775	3280	\N	BLANC VERRE	1.00	5.00	21.00	t
9776	3280	\N	TRIPLE	5.00	4.50	21.00	t
9777	3280	\N	JUPILER	8.00	2.50	21.00	t
9791	3283	\N	Service LOUNA	-1.00	-100.00	0.00	t
9815	3286	\N	NOURRITURE	-1.00	-49.47	0.00	t
9825	3289	\N	NOURRITURE	-1.00	-8.00	0.00	t
9828	3292	\N	ROSÉ MAISON	3.00	3.50	21.00	f
9832	3295	\N	VAL DIEU	2.00	4.00	21.00	f
9842	3298	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
9843	3298	\N	BLUSH	2.00	20.00	21.00	t
9844	3298	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	t
9845	3298	\N	TAJINE	3.00	17.00	12.00	t
9856	3301	\N	NOURRITURE	-1.00	-47.22	0.00	t
9859	3304	\N	NOURRITURE	-1.00	-28.85	0.00	t
9862	3307	\N	VAL DIEU	1.00	4.00	21.00	t
9863	3307	\N	JUPILER	4.00	2.50	21.00	t
9867	3310	\N	Service Elise	-1.00	-45.00	0.00	t
9884	3313	\N	COUSCOUS PM	2.00	17.00	12.00	t
9885	3313	\N	VAL DIEU	2.00	4.00	21.00	t
9888	3316	\N	NOURRITURE	-1.00	-31.92	0.00	t
9891	3319	\N	PÂTES	1.00	10.00	12.00	t
9892	3319	\N	COUSCOUS	1.00	10.00	12.00	t
10136	3410	\N	PÂTES BOLO	1.00	14.00	12.00	f
9486	3188	\N	Service Léa	-1.00	-75.00	0.00	t
9489	3191	\N	CAFÉ	1.00	2.50	21.00	t
9490	3191	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	t
9491	3191	\N	THÉ MENTHE	1.00	2.50	21.00	t
9492	3191	\N	ICE TEA	1.00	2.20	21.00	t
9493	3191	\N	Cuba-Li	4.00	8.00	21.00	t
9494	3191	\N	PROSECCO VERRE	1.00	6.00	21.00	t
9495	3191	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
9496	3191	\N	SPARE RIBS	2.00	18.00	21.00	t
9497	3191	\N	PÂTES TRUFFE + BURRATA	2.00	17.00	12.00	t
9504	3194	\N	CREME BRULEE	2.00	5.00	6.00	f
9512	3197	\N	ROSÉ MAISON	4.00	3.50	21.00	t
9524	3200	\N	Service Léa	-1.00	-50.00	0.00	t
9531	3203	\N	CORNET BOLO	1.00	6.00	6.00	f
9540	3206	\N	ESPRESSO	1.00	2.50	21.00	f
9541	3206	\N	ROUGE 1/2	1.00	14.00	21.00	f
9542	3206	\N	PÂTES PESTO + BURRATA	1.00	18.00	12.00	f
9543	3206	\N	COUSCOUS PM	1.00	17.00	12.00	f
9544	3206	\N	Cuba-Li	1.00	8.00	21.00	f
9545	3206	\N	COCA	1.00	2.20	21.00	f
9546	3206	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	f
9555	3209	\N	NERO D'AVOLA	1.00	24.00	21.00	t
9556	3209	\N	COCA	2.00	2.20	21.00	t
9557	3209	\N	ROSÉ MAISON	1.00	3.50	21.00	t
9558	3209	\N	BLANC VERRE	2.00	5.00	21.00	t
9559	3209	\N	BLONDINETTE	4.00	4.00	21.00	t
9560	3209	\N	PÂTES BOLO	1.00	14.00	12.00	t
9561	3209	\N	PÂTES CREME LARDONS	1.00	14.00	12.00	t
9562	3209	\N	COUSCOUS PM	2.00	17.00	12.00	t
9569	3212	\N	NOURRITURE	-1.00	-81.63	0.00	t
9572	3215	\N	BLONDINETTE	1.00	4.00	21.00	f
9575	3218	\N	NOURRITURE	-1.00	-60.15	0.00	t
9579	3221	\N	ROUGE VERRE	2.00	5.00	21.00	t
9585	3224	\N	BLANC VERRE	1.00	5.00	21.00	f
9586	3224	\N	CORNET TRUFFE	1.00	7.00	6.00	f
9587	3224	\N	CORNET TRUFFE	1.00	7.00	6.00	f
9592	3227	\N	BLANC VERRE	3.00	5.00	21.00	t
9596	3230	\N	JUPILER	6.00	2.50	21.00	t
9597	3230	\N	CORNET BOLO	1.00	6.00	6.00	t
9598	3230	\N	CORNET LARD	1.00	6.00	6.00	t
9599	3230	\N	CORNET TRUFFE	1.00	7.00	6.00	t
9600	3230	\N	CORNET LARD	1.00	6.00	6.00	t
9601	3230	\N	CORNET BOLO	2.00	6.00	6.00	t
9605	3233	\N	BLONDINETTE	1.00	4.00	21.00	f
9609	3236	\N	JUPILER	1.00	2.50	21.00	t
9610	3236	\N	CORNET BOLO	1.00	6.00	6.00	t
9611	3236	\N	CORNET LARD	3.00	6.00	6.00	t
9615	3239	\N	Service Elise	-1.00	-135.00	0.00	t
9622	3242	\N	FANTA	1.00	2.20	21.00	t
9623	3242	\N	COCA ZERO	1.00	2.20	21.00	t
9624	3242	\N	JUPILER	2.00	2.50	21.00	t
9625	3242	\N	PROSECCO VERRE	3.00	6.00	21.00	t
9632	3245	\N	COCA	1.00	2.20	21.00	f
9633	3245	\N	CORNET BOLO	1.00	6.00	6.00	f
9646	3248	\N	PROSECCO VERRE	1.00	6.00	21.00	f
9647	3248	\N	BLANC VERRE	2.00	5.00	21.00	f
9658	3251	\N	TIRAMISU GLACÉ	2.00	6.00	12.00	t
9659	3251	\N	CREME BRULEE	2.00	5.00	12.00	t
9660	3251	\N	SABAYON SPECIAL	1.00	10.00	12.00	t
9661	3251	\N	ROUGE VERRE	1.00	5.00	21.00	t
9662	3251	\N	VAL DIEU	1.00	4.00	21.00	t
9663	3251	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
9664	3251	\N	TAJINE	3.00	17.00	12.00	t
9665	3251	\N	COUSCOUS VG	1.00	12.00	12.00	t
9666	3251	\N	POLPETTE	1.00	16.00	12.00	t
9667	3251	\N	ICE TEA	1.00	2.20	21.00	t
9668	3251	\N	DEFERLANTE	2.00	4.00	21.00	t
9686	3254	\N	PÂTES TRUFFE	1.00	14.00	12.00	t
9687	3254	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
9688	3254	\N	COCA	1.00	2.20	21.00	t
9695	3257	\N	CHARDONNAY FIO	1.00	20.00	21.00	f
9696	3257	\N	MANDURIA	1.00	30.00	21.00	f
9697	3257	\N	TAJINE	2.00	17.00	12.00	f
9698	3257	\N	CHAMPIGNONS KABYLES	2.00	10.00	12.00	f
9704	3260	\N	BLANC 1/2	1.00	13.00	21.00	t
9705	3260	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
9706	3260	\N	POLPETTE	1.00	16.00	12.00	t
9720	3263	\N	EAU PET 1/2 L	1.00	3.50	21.00	f
9721	3263	\N	SABAYON	1.00	8.00	12.00	f
9722	3263	\N	PRIMITIVO NR 14	1.00	24.00	21.00	f
9723	3263	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	f
9724	3263	\N	COUSCOUS PM	1.00	17.00	12.00	f
9727	3266	\N	BLANC VERRE	1.00	5.00	21.00	f
9728	3266	\N	PROSECCO Bouteille	1.00	25.00	21.00	f
9735	3269	\N	SAMBUCA	1.00	6.00	21.00	f
9736	3269	\N	LIMONCELLO	1.00	6.00	21.00	f
9737	3269	\N	GRAPPA	1.00	6.00	21.00	f
9738	3269	\N	BLUSH	1.00	20.00	21.00	f
9739	3269	\N	PINOT GRIGIO	3.00	20.00	21.00	f
9740	3269	\N	PÂTES STRACIATELLA	1.00	16.00	12.00	f
9741	3269	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	f
9745	3272	\N	BLANC VERRE	1.00	5.00	21.00	t
9746	3272	\N	BLONDINETTE	1.00	4.00	21.00	t
9752	3275	\N	BLANC VERRE	4.00	5.00	21.00	f
9757	3278	\N	DIVERS	2.00	3.00	6.00	f
9758	3278	\N	BLANC VERRE	3.00	5.00	21.00	f
9759	3278	\N	Cuba-Li	1.00	8.00	21.00	f
9760	3278	\N	ICE TEA	3.00	2.20	21.00	f
9761	3278	\N	JUPILER	7.00	2.50	21.00	f
9778	3281	\N	CORNET TRUFFE	1.00	7.00	6.00	f
9779	3281	\N	CORNET LARD	1.00	6.00	6.00	f
9780	3281	\N	DECA	1.00	2.50	21.00	f
9781	3281	\N	BLANC VERRE	4.00	5.00	21.00	f
9782	3281	\N	JUPILER	7.00	2.50	21.00	f
9792	3284	\N	CAFÉ	1.00	2.50	21.00	f
9793	3284	\N	PRIMITIVO NR 14	2.00	24.00	21.00	f
9794	3284	\N	Cuba-Li	3.00	8.00	21.00	f
9795	3284	\N	ICE TEA	5.00	2.20	21.00	f
9796	3284	\N	PROSECCO VERRE	1.00	6.00	21.00	f
9797	3284	\N	CHARDONNAY FIO	2.00	20.00	21.00	f
9798	3284	\N	VAL DIEU	1.00	4.00	21.00	f
9799	3284	\N	PECKET FRAISE	7.00	8.00	21.00	f
9800	3284	\N	CREME BRULEE	2.00	5.00	12.00	f
9801	3284	\N	TIRAMISU GLACÉ	3.00	6.00	12.00	f
9802	3284	\N	IRISH COFFEE	2.00	8.00	21.00	f
9803	3284	\N	CREPE SUCRE	2.00	5.00	12.00	f
9804	3284	\N	CANNELLONI VIANDE	3.00	18.00	12.00	f
9805	3284	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
9806	3284	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	f
9841	3297	\N	PLAT SPÉCIAL	1.00	18.00	12.00	t
9487	3189	\N	Service Carol	-1.00	-109.00	0.00	t
9498	3192	\N	CREME BRULEE	1.00	5.00	12.00	t
9499	3192	\N	NERO D'AVOLA	2.00	5.00	21.00	t
9500	3192	\N	TAJINE	1.00	17.00	12.00	t
9501	3192	\N	BEIGNETS FLEUR DE COURGETTES	1.00	18.00	12.00	t
9502	3192	\N	PROSECCO VERRE	2.00	6.00	21.00	t
9505	3195	\N	NOURRITURE	-1.00	-27.17	0.00	t
9513	3198	\N	VIOLETTE	1.00	8.00	21.00	t
9514	3198	\N	CANNELLONI VIANDE	1.00	18.00	12.00	t
9515	3198	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
9516	3198	\N	GINGEMBRE	2.00	10.00	21.00	t
9517	3198	\N	COCA ZERO	1.00	2.20	21.00	t
9518	3198	\N	PÂTES PESTO	1.00	14.00	12.00	t
9525	3201	\N	COCA	1.00	2.20	21.00	t
9526	3201	\N	POLPETTE	3.00	16.00	12.00	t
9527	3201	\N	ARROSTICINNI (5)	1.00	8.00	12.00	t
9528	3201	\N	ROSÉ PATRON	11.00	3.50	21.00	t
9532	3204	\N	BLANC VERRE	1.00	5.00	21.00	f
9533	3204	\N	CORNET BOLO	1.00	6.00	6.00	f
9534	3204	\N	CORNET LARD	2.00	6.00	6.00	f
9547	3207	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
9548	3207	\N	PROSECCO VERRE	1.00	6.00	21.00	t
9549	3207	\N	GRAPPA	1.00	6.00	21.00	t
9550	3207	\N	LIMONCELLO	1.00	6.00	21.00	t
9551	3207	\N	CAFÉ	1.00	2.50	21.00	t
9552	3207	\N	PÂTES TRUFFE	1.00	14.00	12.00	t
9553	3207	\N	PÂTES BOLO	1.00	14.00	12.00	t
9563	3210	\N	IRISH COFFEE	2.00	8.00	21.00	f
9564	3210	\N	MANDURIA	1.00	25.00	21.00	f
9565	3210	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	f
9566	3210	\N	TAJINE	1.00	17.00	12.00	f
9570	3213	\N	JUPILER	4.00	2.50	21.00	f
9573	3216	\N	JUPILER	4.00	2.50	21.00	f
9576	3219	\N	CORNET TRUFFE	1.00	7.00	6.00	t
9580	3222	\N	CORNET BOLO	2.00	6.00	6.00	t
9581	3222	\N	CORNET LARD	1.00	6.00	6.00	t
9588	3225	\N	JUPILER	2.00	2.50	21.00	t
9593	3228	\N	BLANC VERRE	1.00	5.00	21.00	f
9602	3231	\N	BLONDINETTE	4.00	4.00	21.00	f
9606	3234	\N	PINOT GRIGIO	1.00	20.00	21.00	f
9612	3237	\N	PROSECCO VERRE	1.00	6.00	21.00	t
9613	3237	\N	BLANC VERRE	3.00	5.00	21.00	t
9616	3240	\N	BLANC VERRE	1.00	5.00	21.00	t
9617	3240	\N	CORNET BOLO	1.00	6.00	6.00	t
9618	3240	\N	CORNET LARD	2.00	6.00	6.00	t
9626	3243	\N	ROUGE VERRE	2.00	5.00	21.00	f
9627	3243	\N	CORNET BOLO	2.00	6.00	6.00	f
9634	3246	\N	CRÊPE CREME LARD	1.00	12.00	12.00	f
9635	3246	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	f
9636	3246	\N	BLANC VERRE	1.00	5.00	21.00	f
9637	3246	\N	ICE TEA	1.00	2.20	21.00	f
9638	3246	\N	DEFERLANTE	1.00	4.00	21.00	f
9648	3249	\N	CREME BRULEE	1.00	5.00	12.00	t
9649	3249	\N	THÉ MENTHE	2.00	2.50	21.00	t
9650	3249	\N	PÂTES COURGETTE + SCAMPIS	2.00	18.00	12.00	t
9651	3249	\N	PINOT GRIGIO	1.00	20.00	21.00	t
9669	3252	\N	THÉ MENTHE	2.00	2.50	21.00	t
9670	3252	\N	NERO D'AVOLA	1.00	30.00	21.00	t
9671	3252	\N	PROSECCO VERRE	1.00	6.00	21.00	t
9672	3252	\N	COUSCOUS PM	2.00	17.00	12.00	t
9673	3252	\N	BEIGNETS DE COURGETTE	1.00	14.00	12.00	t
9689	3255	\N	COCA	1.00	2.20	21.00	f
9690	3255	\N	VAL DIEU	1.00	4.00	21.00	f
9691	3255	\N	ROUGE VERRE	2.00	5.00	21.00	f
9692	3255	\N	PÂTES STRACIATELLA SCAMPIS	1.00	19.00	12.00	f
9693	3255	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	f
9699	3258	\N	BLONDINETTE	1.00	4.00	21.00	t
9700	3258	\N	ICE TEA	1.00	2.20	21.00	t
9701	3258	\N	Cuba-Li	5.00	8.00	21.00	t
9707	3261	\N	AMARETTO	2.00	6.00	21.00	f
9708	3261	\N	COUSCOUS PM	1.00	17.00	12.00	f
9709	3261	\N	PROSECCO VERRE	1.00	6.00	21.00	f
9710	3261	\N	BLONDINETTE	1.00	4.00	21.00	f
9711	3261	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	f
9712	3261	\N	CREME BRULEE	1.00	5.00	12.00	f
9713	3261	\N	CANNELLONI VIANDE	1.00	18.00	12.00	f
9725	3264	\N	Service ANTON	-1.00	-70.00	0.00	t
9729	3267	\N	BLANC VERRE	2.00	5.00	21.00	t
9730	3267	\N	PECKET FRAISE	1.00	8.00	21.00	t
9742	3270	\N	BLONDINETTE	1.00	4.00	21.00	t
9743	3270	\N	BLANC VERRE	1.00	5.00	21.00	t
9747	3273	\N	JUPILER	2.00	2.50	21.00	t
9753	3276	\N	COCA	1.00	2.20	21.00	t
9754	3276	\N	VAL DIEU	1.00	4.00	21.00	t
9762	3279	\N	DIVERS	2.00	3.00	6.00	f
9763	3279	\N	CORNET TRUFFE	1.00	7.00	6.00	f
9764	3279	\N	CANNELLONI VIANDE	1.00	18.00	12.00	f
9765	3279	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
9766	3279	\N	ICE TEA	1.00	2.20	21.00	f
9767	3279	\N	DECA	1.00	2.50	21.00	f
9768	3279	\N	Cuba-Li	1.00	8.00	21.00	f
9769	3279	\N	JUPILER	5.00	2.50	21.00	f
9770	3279	\N	CAFÉ	2.00	2.50	21.00	f
9771	3279	\N	SOFT (Verre)	3.00	2.20	21.00	f
9772	3279	\N	BLANC VERRE	3.00	5.00	21.00	f
9783	3282	\N	CORNET BOLO	1.00	6.00	6.00	f
9784	3282	\N	CORNET LARD	3.00	6.00	6.00	f
9785	3282	\N	VAL DIEU	1.00	4.00	21.00	f
9786	3282	\N	BLANC VERRE	1.00	5.00	21.00	f
9787	3282	\N	SOFT (Verre)	1.00	2.20	21.00	f
9788	3282	\N	JUPILER	33.00	2.50	21.00	f
9789	3282	\N	ICE TEA	1.00	2.20	21.00	f
9790	3282	\N	CAFÉ	1.00	2.50	21.00	f
9812	3285	\N	PÂTES STRACIATELLA	1.00	16.00	12.00	f
9813	3285	\N	PÂTES CREME LARDONS	1.00	14.00	12.00	f
9814	3285	\N	TAJINE	1.00	17.00	12.00	f
9821	3288	\N	CHARDONNAY FIO	2.00	5.00	21.00	t
9822	3288	\N	PROSECCO VERRE	2.00	6.00	21.00	t
9823	3288	\N	TAJINE	2.00	17.00	12.00	t
9824	3288	\N	TIRAMISU GLACÉ	2.00	6.00	12.00	t
9827	3291	\N	CORNET BOLO	1.00	6.00	6.00	t
9831	3294	\N	Service Ménage	-1.00	-30.00	0.00	t
9834	3297	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	t
9835	3297	\N	PROSECCO VERRE	1.00	6.00	21.00	t
9836	3297	\N	ICE TEA	1.00	2.20	21.00	t
9837	3297	\N	FANTA	1.00	2.20	21.00	t
9838	3297	\N	COCA	2.00	2.20	21.00	t
9839	3297	\N	CRÊPE KABYLE	2.00	12.00	12.00	t
9840	3297	\N	CRÊPE CREME LARD	1.00	12.00	12.00	t
9807	3284	\N	PÂTES STRACIATELLA SCAMPIS	1.00	19.00	12.00	f
9808	3284	\N	PÂTES PESTO + BURRATA	2.00	18.00	12.00	f
9809	3284	\N	COUSCOUS PM	2.00	17.00	12.00	f
9810	3284	\N	POLPETTE	1.00	16.00	12.00	f
9811	3284	\N	ASSORTIMENT CROQUETTES	2.00	20.00	6.00	f
9816	3287	\N	THÉ MENTHE	3.00	2.50	21.00	f
9817	3287	\N	CANNELLONI VIANDE	1.00	18.00	12.00	f
9818	3287	\N	CRÊPE GORGONZOLA COURGETTES	1.00	14.00	12.00	f
9819	3287	\N	CHARDONNAY FIO	1.00	20.00	21.00	f
9820	3287	\N	PÂTES CREME LARDONS	1.00	14.00	12.00	f
9826	3290	\N	NOURRITURE	-1.00	-38.83	0.00	t
9829	3293	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
9830	3293	\N	PÂTES STRACIATELLA SCAMPIS	1.00	19.00	12.00	t
9833	3296	\N	BLONDINETTE	2.00	4.00	21.00	t
9846	3299	\N	PROSECCO Bouteille	1.00	25.00	21.00	f
9847	3299	\N	CHARDONNAY FIO	1.00	20.00	21.00	f
9848	3299	\N	VIOLETTE	1.00	8.00	21.00	f
9849	3299	\N	Cuba-Li	1.00	8.00	21.00	f
9850	3299	\N	VAL DIEU	1.00	4.00	21.00	f
9851	3299	\N	JUPILER	1.00	2.50	21.00	f
9852	3299	\N	PROSECCO VERRE	2.00	6.00	21.00	f
9853	3299	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	f
9854	3299	\N	TAJINE	1.00	17.00	12.00	f
9857	3302	\N	NOURRITURE	-1.00	-21.77	0.00	t
9860	3305	\N	POULET	-1.00	-87.50	0.00	t
9864	3308	\N	TIRAMISU GLACÉ	2.00	6.00	6.00	t
9865	3308	\N	TAJINE	2.00	17.00	6.00	t
9868	3311	\N	BLUSH	5.00	20.00	21.00	f
9869	3311	\N	TIRAMISU GLACÉ	2.00	6.00	12.00	f
9870	3311	\N	CAFÉ	1.00	2.50	21.00	f
9871	3311	\N	COCA	2.00	2.20	21.00	f
9872	3311	\N	COCA ZERO	1.00	2.20	21.00	f
9873	3311	\N	PECKET FRAISE	1.00	8.00	21.00	f
9874	3311	\N	PÂTES STRACIATELLA	3.00	16.00	12.00	f
9875	3311	\N	PÂTES COURGETTE	1.00	18.00	12.00	f
9876	3311	\N	PÂTES STRACIATELLA SCAMPIS	1.00	19.00	12.00	f
9886	3314	\N	Service Caro	-1.00	-50.00	0.00	t
9889	3317	\N	BLANC VERRE	4.00	5.00	21.00	f
9901	3320	\N	CREME BRULEE	2.00	5.00	12.00	f
9902	3320	\N	MANDURIA	1.00	30.00	21.00	f
9903	3320	\N	PÂTES BOMBE ATOMIQUE + BURRATA	1.00	17.00	12.00	f
9904	3320	\N	PÂTES PESTO + BURRATA	1.00	18.00	12.00	f
9905	3320	\N	AMARETTO	1.00	6.00	21.00	f
9906	3320	\N	IRISH COFFEE	1.00	8.00	21.00	f
9907	3320	\N	VAL DIEU	1.00	4.00	21.00	f
9908	3320	\N	JUPILER	2.00	2.50	21.00	f
9921	3323	\N	BLUSH	1.00	20.00	21.00	f
9922	3323	\N	COUSCOUS PM	2.00	17.00	12.00	f
9927	3326	\N	COUSCOUS PM	1.00	17.00	12.00	t
9928	3326	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	t
9929	3326	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
9930	3326	\N	BLANC 1/4	1.00	8.00	21.00	t
9931	3326	\N	COCA	1.00	2.20	21.00	t
9932	3326	\N	SCAMPIS LUCIFER	2.00	12.00	12.00	t
9933	3326	\N	ASSORTIMENT CROQUETTES	1.00	20.00	6.00	t
9934	3326	\N	VIOLETTE	1.00	8.00	21.00	t
9935	3326	\N	PECKET FRAISE	1.00	8.00	21.00	t
9938	3329	\N	VAL DIEU	2.00	4.00	21.00	t
9942	3332	\N	CAFÉ	1.00	2.50	21.00	t
9943	3332	\N	BLANC 1/2	1.00	13.00	21.00	t
9944	3332	\N	COUSCOUS PM	1.00	17.00	12.00	t
9947	3335	\N	PROCES	-1.00	-63.42	0.00	t
9950	3338	\N	CARBURANT	-1.00	-104.05	0.00	t
9953	3341	\N	CARBURANT	-1.00	-376.50	0.00	t
9956	3344	\N	DESPRIET	-1.00	-208.63	0.00	t
9959	3347	\N	DENIS	-1.00	-183.00	0.00	t
9962	3350	\N	PROXIMUS	-1.00	-98.49	0.00	t
9965	3353	\N	COMPTABLE	-1.00	-272.25	0.00	t
9968	3356	\N	EAU PET 1/2 L	2.00	3.50	21.00	t
9969	3356	\N	PROSECCO VERRE	1.00	6.00	21.00	t
9970	3356	\N	JUPILER	1.00	2.50	21.00	t
9981	3359	\N	COUSCOUS PM	1.00	17.00	6.00	f
9982	3359	\N	CANNELLONI VIANDE	1.00	18.00	6.00	f
9983	3359	\N	PÂTES TRUFFE + BURRATA	1.00	18.00	6.00	f
9988	3362	\N	TIRAMISU GLACÉ	2.00	6.00	12.00	t
9989	3362	\N	JUPILER	1.00	2.50	21.00	t
10005	3365	\N	VAL DIEU	3.00	4.00	21.00	t
10012	3368	\N	TIRAMISU GLACÉ	2.00	6.00	12.00	f
10013	3368	\N	CORNET TRUFFE	2.00	7.00	6.00	f
10020	3371	\N	LOYER	-1.00	-600.00	0.00	t
10023	3374	\N	NOURRITURE	-1.00	-63.69	0.00	t
10032	3377	\N	Service ANTON	-1.00	-60.00	0.00	t
10035	3380	\N	JAMENDO	-1.00	-79.08	0.00	t
10038	3383	\N	CARBURANT	-1.00	-83.16	0.00	t
10041	3386	\N	ENERGIES	-1.00	-325.95	0.00	t
10048	3389	\N	MANDURIA	1.00	30.00	21.00	t
10049	3389	\N	SCAMPIS LUCIFER	1.00	12.00	12.00	t
10050	3389	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	t
10051	3389	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
10052	3389	\N	PÂTES STRACIATELLA	1.00	16.00	12.00	t
10058	3392	\N	JUPILER	19.00	2.50	21.00	t
10062	3395	\N	CANNELLONI VIANDE	2.00	18.00	12.00	t
10063	3395	\N	DEFERLANTE	2.00	4.00	21.00	t
10064	3395	\N	ORVAL	3.00	5.00	21.00	t
10065	3395	\N	PECKET FRAISE	1.00	8.00	21.00	t
10066	3395	\N	BLANC VERRE	1.00	5.00	21.00	t
10067	3395	\N	CAFÉ	1.00	2.50	21.00	t
10068	3395	\N	VAL DIEU	1.00	4.00	21.00	t
10069	3395	\N	TRIPLE	1.00	4.50	21.00	t
10070	3395	\N	JUPILER	5.00	2.50	21.00	t
10076	3398	\N	VAL DIEU	2.00	4.00	21.00	f
10089	3401	\N	CORNET LARD	1.00	6.00	6.00	t
10090	3401	\N	CORNET TRUFFE	1.00	7.00	6.00	t
10091	3401	\N	ICE TEA	2.00	2.20	21.00	t
10092	3401	\N	ROUGE VERRE	1.00	5.00	21.00	t
10093	3401	\N	DEFERLANTE	2.00	4.00	21.00	t
10094	3401	\N	JUPILER	2.00	2.50	21.00	t
10095	3401	\N	SOFT (Verre)	1.00	2.20	21.00	t
10104	3404	\N	CORNET LARD	1.00	6.00	6.00	t
10105	3404	\N	CORNET TRUFFE	1.00	7.00	6.00	t
10106	3404	\N	COCA ZERO	1.00	2.20	21.00	t
10107	3404	\N	JUPILER	6.00	2.50	21.00	t
10108	3404	\N	ORVAL	6.00	5.00	21.00	t
10109	3404	\N	ROSÉ VERRE	3.00	5.00	21.00	t
10110	3404	\N	BLANC VERRE	2.00	5.00	21.00	t
10111	3404	\N	BIERE AUTRE	5.00	4.00	21.00	t
10127	3407	\N	CORNET LARD	1.00	6.00	6.00	t
10128	3407	\N	CORNET BOLO	1.00	6.00	6.00	t
9855	3300	\N	NOURRITURE	-1.00	-11.34	0.00	t
9858	3303	\N	NOURRITURE	-1.00	-16.69	0.00	t
9861	3306	\N	CORNET BOLO	2.00	6.00	6.00	t
9866	3309	\N	MERGUEZ	-1.00	-38.45	0.00	t
9877	3312	\N	THÉ MENTHE	2.00	2.50	21.00	f
9878	3312	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	f
9879	3312	\N	CREME BRULEE	1.00	5.00	12.00	f
9880	3312	\N	ROSÉ VERRE	2.00	5.00	21.00	f
9881	3312	\N	TAJINE	1.00	17.00	12.00	f
9882	3312	\N	COUSCOUS PM	1.00	17.00	12.00	f
9883	3312	\N	ASSORTIMENT CROQUETTES	1.00	20.00	6.00	f
9887	3315	\N	NOURRITURE	-1.00	-48.03	0.00	t
9890	3318	\N	BOISSONS	-1.00	-89.10	0.00	t
9909	3321	\N	TAJINE	1.00	17.00	12.00	t
9910	3321	\N	POLPETTE	1.00	16.00	12.00	t
9911	3321	\N	COUSCOUS PM	1.00	17.00	12.00	t
9912	3321	\N	ROUGE 1/4	1.00	8.00	21.00	t
9913	3321	\N	BLANC 1/4	1.00	8.00	21.00	t
9923	3324	\N	Service Charlotte	-1.00	-50.00	0.00	t
9936	3327	\N	NOURRITURE	-1.00	-23.13	0.00	t
9939	3330	\N	VAL DIEU	2.00	4.00	21.00	t
9945	3333	\N	LOYER	-1.00	-600.00	0.00	t
9948	3336	\N	DESPRIET	-1.00	-112.72	0.00	t
9951	3339	\N	ENERGIES	-1.00	-388.66	0.00	t
9954	3342	\N	RESTO	-1.00	-49.50	0.00	t
9957	3345	\N	ENERGIES	-1.00	-296.28	0.00	t
9960	3348	\N	VENERIA CARS	-1.00	-576.50	0.00	t
9963	3351	\N	BASKET CHA	-1.00	-100.00	0.00	t
9966	3354	\N	COMPTABLE	-1.00	-768.35	0.00	t
9971	3357	\N	CREPE FLAMBEE GD MARNIER	1.00	8.00	12.00	f
9972	3357	\N	ROSÉ PATRON	1.00	15.00	21.00	f
9973	3357	\N	SPARE RIBS	2.00	18.00	21.00	f
9974	3357	\N	PECKET FRAISE	2.00	8.00	21.00	f
9984	3360	\N	PÂTES SAUCE BASE	1.00	12.00	12.00	t
9990	3363	\N	CYNAR	1.00	0.00	21.00	t
9991	3363	\N	CYNAR	1.00	5.00	21.00	t
9992	3363	\N	VAL DIEU	1.00	4.00	21.00	t
9993	3363	\N	RHUM	1.00	6.00	21.00	t
9994	3363	\N	CAFÉ	1.00	2.50	21.00	t
9995	3363	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
9996	3363	\N	CREME BRULEE	1.00	5.00	12.00	t
9997	3363	\N	MANDURIA	1.00	30.00	21.00	t
9998	3363	\N	SCAMPIS LUCIFER	1.00	12.00	12.00	t
9999	3363	\N	COUSCOUS PM	1.00	17.00	12.00	t
10000	3363	\N	TAJINE	1.00	17.00	12.00	t
10006	3366	\N	TRIPLE	2.00	4.50	21.00	t
10014	3369	\N	MANDURIA	2.00	30.00	21.00	t
10015	3369	\N	BIERLAINOISE	6.00	4.00	6.00	t
10016	3369	\N	PÂTES TRUFFE + BURRATA	2.00	17.00	12.00	t
10017	3369	\N	CANNELLONI VIANDE	1.00	18.00	12.00	t
10018	3369	\N	COUSCOUS PM	4.00	17.00	12.00	t
10021	3372	\N	NOURRITURE	-1.00	-55.82	0.00	t
10024	3375	\N	PÂTES TRUFFE + BURRATA	1.00	18.00	12.00	t
10025	3375	\N	PÂTES BOMBE ATOMIQUE + BURRATA	1.00	17.00	12.00	t
10026	3375	\N	POLPETTE	1.00	16.00	12.00	t
10033	3378	\N	CARBURANT	-1.00	-99.37	0.00	t
10036	3381	\N	MASSAGE	-1.00	-25.00	0.00	t
10039	3384	\N	SUSHI	-1.00	-100.00	0.00	t
10042	3387	\N	CARBURANT	-1.00	-105.62	0.00	t
10053	3390	\N	TRIPLE	1.00	4.50	21.00	f
10059	3393	\N	Service Elise	-1.00	-40.00	0.00	t
10071	3396	\N	DEFERLANTE	1.00	4.00	21.00	f
10072	3396	\N	JUPILER	22.00	2.50	21.00	f
10077	3399	\N	CORNET LARD	2.00	6.00	6.00	t
10078	3399	\N	DEFERLANTE	2.00	4.00	21.00	t
10079	3399	\N	VAL DIEU	3.00	4.00	21.00	t
10080	3399	\N	TRIPLE	1.00	4.50	21.00	t
10081	3399	\N	SOFT (Verre)	2.00	2.20	21.00	t
10082	3399	\N	BIERE AUTRE	1.00	4.00	21.00	t
10083	3399	\N	JUPILER	9.00	2.50	21.00	t
10096	3402	\N	CORNET LARD	1.00	6.00	6.00	f
10097	3402	\N	BLANC VERRE	1.00	5.00	21.00	f
10098	3402	\N	COCA ZERO	1.00	2.20	21.00	f
10099	3402	\N	CAFÉ	1.00	2.50	21.00	f
10100	3402	\N	JUPILER	26.00	2.50	21.00	f
10112	3405	\N	VAL DIEU	1.00	4.00	21.00	f
10113	3405	\N	ORVAL	1.00	5.00	21.00	f
10114	3405	\N	Cuba-Li	3.00	8.00	21.00	f
10129	3408	\N	PINOT GRIGIO	1.00	20.00	21.00	f
10130	3408	\N	PECKET FRAISE	3.00	1.00	21.00	f
10131	3408	\N	EAU PET VERRE	1.00	2.20	21.00	f
10132	3408	\N	VAL DIEU	3.00	4.00	21.00	f
10133	3408	\N	BIERE AUTRE	2.00	2.50	21.00	f
10134	3408	\N	NOËL (BRUNE)	2.00	4.00	21.00	f
10139	3411	\N	GRAPPA MIEL	7.00	6.00	21.00	f
10149	3414	\N	Cuba-Li	2.00	8.00	21.00	f
10150	3414	\N	VAL DIEU	1.00	4.00	21.00	f
10151	3414	\N	BIERE AUTRE	1.00	2.50	21.00	f
10152	3414	\N	JUPILER	1.00	2.50	21.00	f
10164	3417	\N	JUPILER	2.00	2.50	21.00	f
10171	3420	\N	JUPILER	10.00	2.50	21.00	f
10377	3499	\N	SPARE RIBS	1.00	18.00	12.00	t
10378	3499	\N	FANTA	2.00	2.20	21.00	t
10379	3499	\N	PECKET FRAISE	1.00	8.00	21.00	t
10382	3502	\N	NOURRITURE	-1.00	-39.62	0.00	t
10391	3505	\N	SOFT (Verre)	1.00	2.20	21.00	t
10392	3505	\N	PROSECCO VERRE	1.00	6.00	21.00	t
10393	3505	\N	PECKET FRAISE	4.00	8.00	21.00	t
10394	3505	\N	ICE TEA	1.00	2.20	21.00	t
10395	3505	\N	COCA ZERO	13.00	2.20	21.00	t
10396	3505	\N	COCA	1.00	2.20	21.00	t
10397	3505	\N	PÂTES STRACIATELLA SCAMPIS	2.00	20.00	12.00	t
10398	3505	\N	CANNELLONI VIANDE	1.00	17.00	12.00	t
10399	3505	\N	TAJINE	4.00	17.00	12.00	t
10400	3505	\N	COUSCOUS PM	1.00	17.00	12.00	t
10401	3505	\N	ASSIETTE APERITIVE (2 p.)	2.00	19.00	12.00	t
10402	3505	\N	ASSORTIMENT CROQUETTES	1.00	20.00	12.00	t
10403	3505	\N	SABAYON	1.00	8.00	12.00	t
10404	3505	\N	CREME BRULEE	4.00	6.00	12.00	t
10405	3505	\N	TIRAMISU GLACÉ	3.00	6.00	12.00	t
10406	3505	\N	ROUGE VERRE	1.00	5.00	21.00	t
10407	3505	\N	EAU PET VERRE	1.00	2.20	21.00	t
10426	3508	\N	VAL DIEU	1.00	4.00	21.00	t
10427	3508	\N	PECKET FRAISE	3.00	8.00	21.00	t
10441	3511	\N	Service Maurine	-1.00	-70.00	0.00	t
10446	3514	\N	Service Elise	-1.00	-40.00	0.00	t
10450	3517	\N	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	t
10451	3517	\N	VIANDE + GRATIN	1.00	24.00	12.00	t
10452	3517	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	t
10453	3517	\N	ICE TEA	1.00	2.20	21.00	t
9893	3319	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
9894	3319	\N	PROSECCO VERRE	1.00	6.00	21.00	t
9895	3319	\N	GINGEMBRE	1.00	10.00	21.00	t
9896	3319	\N	FANTA	1.00	2.20	21.00	t
9897	3319	\N	COCA ZERO	1.00	2.20	21.00	t
9898	3319	\N	BLANC 1/2	2.00	13.00	21.00	t
9899	3319	\N	TAJINE	1.00	17.00	12.00	t
9900	3319	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
9914	3322	\N	PÂTES BOLO	1.00	14.00	12.00	t
9915	3322	\N	PÂTES COURGETTE + SCAMPIS	2.00	18.00	12.00	t
9916	3322	\N	CANNELLONI VIANDE	2.00	18.00	12.00	t
9917	3322	\N	COUSCOUS PM	2.00	17.00	12.00	t
9918	3322	\N	ASSORTIMENT CROQUETTES	2.00	20.00	6.00	t
9919	3322	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
9920	3322	\N	CHARDONNAY FIO	2.00	20.00	21.00	t
9924	3325	\N	PÂTES TRUFFE	1.00	14.00	6.00	t
9925	3325	\N	COUSCOUS PM	1.00	17.00	6.00	t
9926	3325	\N	ASSORTIMENT CROQUETTES	1.00	20.00	6.00	t
9937	3328	\N	CORNET TRUFFE	1.00	7.00	6.00	t
9940	3331	\N	RHUM	1.00	6.00	21.00	t
9941	3331	\N	COUSCOUS PM	1.00	17.00	6.00	t
9946	3334	\N	AUTO	-1.00	-655.11	0.00	t
9949	3337	\N	PROXIMUS	-1.00	-99.00	0.00	t
9952	3340	\N	ORANGE	-1.00	-28.00	0.00	t
9955	3343	\N	ORANGE	-1.00	-40.00	0.00	t
9958	3346	\N	PEB HUY	-1.00	-296.45	0.00	t
9961	3349	\N	CARBURANT	-1.00	-101.49	0.00	t
9964	3352	\N	ORANGE	-1.00	-28.00	0.00	t
9967	3355	\N	JUPILER	1.00	2.50	21.00	t
9975	3358	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	f
9976	3358	\N	CREME BRULEE	1.00	5.00	12.00	f
9977	3358	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	f
9978	3358	\N	PÂTES PESTO + BURRATA	1.00	18.00	12.00	f
9979	3358	\N	VIOLETTE	1.00	10.00	21.00	f
9980	3358	\N	PECKET FRAISE	1.00	8.00	21.00	f
9985	3361	\N	MANDURIA	1.00	30.00	21.00	t
9986	3361	\N	TAJINE	1.00	17.00	12.00	t
9987	3361	\N	COUSCOUS PM	1.00	17.00	12.00	t
10001	3364	\N	DECA	1.00	2.50	21.00	t
10002	3364	\N	CHARDONNAY FIO	1.00	20.00	21.00	t
10003	3364	\N	POLPETTE	2.00	16.00	12.00	t
10004	3364	\N	CHAKTCHOUKA	1.00	12.00	12.00	t
10007	3367	\N	PÂTES STRACIATELLA	1.00	16.00	12.00	t
10008	3367	\N	COUSCOUS PM	1.00	17.00	12.00	t
10009	3367	\N	PINOT GRIGIO	2.00	20.00	21.00	t
10010	3367	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
10011	3367	\N	Cuba-Li	2.00	8.00	21.00	t
10019	3370	\N	JUPILER	6.00	2.50	21.00	t
10022	3373	\N	JUPILER	2.00	2.50	21.00	t
10027	3376	\N	CAFÉ	1.00	2.50	21.00	f
10028	3376	\N	ROSÉ PATRON	1.00	0.00	21.00	f
10029	3376	\N	PINOT GRIGIO	1.00	20.00	21.00	f
10030	3376	\N	BEIGNETS DE COURGETTE	1.00	14.00	12.00	f
10031	3376	\N	COUSCOUS PM	1.00	17.00	12.00	f
10034	3379	\N	MASSAGE	-1.00	-25.00	0.00	t
10037	3382	\N	Taxe Circulation	-1.00	-105.68	0.00	t
10040	3385	\N	CARBURANT	-1.00	-376.50	0.00	t
10043	3388	\N	THÉ MENTHE	1.00	2.50	21.00	f
10044	3388	\N	CAFÉ	1.00	2.50	21.00	f
10045	3388	\N	COCA	1.00	2.20	21.00	f
10046	3388	\N	GINGEMBRE	3.00	10.00	21.00	f
10047	3388	\N	CANNELLONI VIANDE	2.00	18.00	12.00	f
10054	3391	\N	CAPUCCINO	1.00	2.80	21.00	f
10055	3391	\N	BIERE AUTRE	1.00	2.50	21.00	f
10056	3391	\N	SABAYON	1.00	8.00	12.00	f
10057	3391	\N	ROSÉ PATRON	1.00	15.00	21.00	f
10060	3394	\N	CORNET LARD	1.00	6.00	6.00	f
10061	3394	\N	JUPILER	16.00	2.50	21.00	f
10073	3397	\N	CAFÉ	1.00	2.50	21.00	f
10074	3397	\N	BLANC VERRE	5.00	5.00	21.00	f
10075	3397	\N	PECKET FRAISE	2.00	8.00	21.00	f
10084	3400	\N	SOFT (Verre)	1.00	2.20	21.00	f
10085	3400	\N	ICE TEA	2.00	2.20	21.00	f
10086	3400	\N	ROSÉ VERRE	1.00	5.00	21.00	f
10087	3400	\N	BLANC VERRE	3.00	5.00	21.00	f
10088	3400	\N	JUPILER	5.00	2.50	21.00	f
10101	3403	\N	ORVAL	1.00	5.00	21.00	f
10102	3403	\N	JUPILER	1.00	2.50	21.00	f
10103	3403	\N	Cuba-Li	2.00	8.00	21.00	f
10115	3406	\N	BLANC 1/2	1.00	13.00	21.00	f
10116	3406	\N	CANNELLONI VIANDE	1.00	18.00	12.00	f
10117	3406	\N	PÂTES TRUFFE	1.00	14.00	12.00	f
10118	3406	\N	PÂTES TRUFFE + BURRATA	2.00	17.00	12.00	f
10119	3406	\N	PÂTES PESTO + BURRATA	1.00	18.00	12.00	f
10120	3406	\N	PÂTES CREME LARDONS	1.00	14.00	12.00	f
10121	3406	\N	COCA	5.00	2.20	21.00	f
10122	3406	\N	VAL DIEU	1.00	4.00	21.00	f
10123	3406	\N	VIOLETTE	2.00	8.00	21.00	f
10124	3406	\N	THÉ MENTHE	1.00	2.50	21.00	f
10125	3406	\N	CREME BRULEE	1.00	5.00	12.00	f
10126	3406	\N	GLACE	1.00	5.00	12.00	f
10135	3409	\N	Cuba-Li	7.00	8.00	21.00	f
10140	3412	\N	PECKET FRAISE	5.00	8.00	21.00	t
10141	3412	\N	BLANC VERRE	1.00	5.00	21.00	t
10142	3412	\N	BIERE AUTRE	2.00	2.50	21.00	t
10143	3412	\N	NOËL (BRUNE)	5.00	4.00	21.00	t
10144	3412	\N	CANNELLONI VIANDE	1.00	18.00	12.00	t
10145	3412	\N	PÂTES TRUFFE + BURRATA	1.00	17.00	12.00	t
10146	3412	\N	COUSCOUS PM	5.00	17.00	12.00	t
10153	3415	\N	Cuba-Li	2.00	8.00	21.00	f
10165	3418	\N	VAL DIEU	2.00	4.00	21.00	f
10166	3418	\N	JUPILER	1.00	2.50	21.00	f
10454	3517	\N	COCA ZERO	2.00	2.20	21.00	t
10474	3520	\N	SABAYON	2.00	8.00	12.00	t
10475	3520	\N	ROUGE VERRE	2.00	5.00	21.00	t
10476	3520	\N	TAJINE	1.00	17.00	12.00	t
10477	3520	\N	COUSCOUS PM	1.00	17.00	12.00	t
10478	3520	\N	PECKET FRAISE	2.00	8.00	21.00	t
10481	3523	\N	NOURRITURE	-1.00	-46.00	0.00	t
10484	3526	\N	NOURRITURE	-1.00	-94.56	0.00	t
10489	3529	\N	FRAIS	-1.00	-109.25	0.00	t
10492	3532	\N	TERRASSE	-1.00	-124.23	0.00	t
10495	3535	\N	THÉ MENTHE	1.00	2.50	21.00	t
10496	3535	\N	DECA	1.00	2.50	21.00	t
10497	3535	\N	BIERE AUTRE	1.00	3.50	21.00	t
10498	3535	\N	ROUGE VERRE	1.00	5.00	21.00	t
10499	3535	\N	VIOLETTE	1.00	8.00	21.00	t
10500	3535	\N	COCA	2.00	2.20	21.00	t
10501	3535	\N	PROSECCO VERRE	1.00	6.00	21.00	t
10502	3535	\N	CRÊPE GORGONZOLA COURGETTES	1.00	16.00	12.00	t
10137	3410	\N	IRISH COFFEE	2.00	8.00	21.00	f
10138	3410	\N	Cuba-Li	5.00	8.00	21.00	f
10147	3413	\N	Cuba-Li	2.00	8.00	21.00	f
10148	3413	\N	BIERE AUTRE	1.00	2.50	21.00	f
10154	3416	\N	BLUSH	1.00	20.00	21.00	f
10155	3416	\N	PECKET FRAISE	1.00	8.00	21.00	f
10156	3416	\N	PINOT GRIGIO	8.00	20.00	21.00	f
10157	3416	\N	COUSCOUS PM	2.00	17.00	12.00	f
10158	3416	\N	CRÊPE GORGONZOLA COURGETTES	1.00	14.00	12.00	f
10159	3416	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	f
10160	3416	\N	TAJINE	1.00	17.00	12.00	f
10161	3416	\N	PÂTES STRACIATELLA	1.00	16.00	12.00	f
10162	3416	\N	ASSORTIMENT CROQUETTES	2.00	20.00	12.00	f
10163	3416	\N	CHAMPIGNONS KABYLES	2.00	10.00	12.00	f
10167	3419	\N	JUPILER	2.00	2.50	21.00	t
10168	3419	\N	Cuba-Li	2.00	8.00	21.00	t
10169	3419	\N	BIERLAINOISE	1.00	4.00	21.00	t
10170	3419	\N	VAL DIEU	2.00	4.00	21.00	t
10483	3525	\N	NOURRITURE	-1.00	-153.42	0.00	t
10487	3528	\N	PÂTES TRUFFE + BURRATA	1.00	18.00	6.00	t
10488	3528	\N	COUSCOUS PM	1.00	17.00	6.00	t
10491	3531	\N	ENERGIES	-1.00	-301.69	0.00	t
10494	3534	\N	POULET	-1.00	-87.50	0.00	t
10507	3537	\N	PÂTES TRUFFE	1.00	14.00	12.00	t
10508	3537	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
10509	3537	\N	SCAMPIS LUCIFER	1.00	12.00	12.00	t
10510	3537	\N	SOFT (Verre)	1.00	2.20	21.00	t
10511	3537	\N	COCA	1.00	2.20	21.00	t
10521	3540	\N	JUPILER	2.00	2.50	21.00	t
10522	3540	\N	ROSÉ MAISON	2.00	3.50	21.00	t
10525	3543	\N	ESPRESSO	2.00	2.50	21.00	f
10526	3543	\N	COUSCOUS PM	2.00	17.00	12.00	f
10527	3543	\N	PINOT GRIGIO	1.00	20.00	21.00	f
10531	3546	\N	CAFÉ	1.00	2.50	21.00	f
10532	3546	\N	EAU PET 1/2 L	1.00	3.50	21.00	f
10533	3546	\N	COCA	2.00	2.20	21.00	f
10534	3546	\N	ROSÉ MAISON	6.00	3.50	21.00	f
10535	3546	\N	PÂTES RAGÙ	1.00	15.00	12.00	f
10536	3546	\N	CANNELLONI VIANDE	2.00	17.00	12.00	f
10551	3549	\N	BLANC VERRE	2.00	5.00	21.00	t
10552	3550	\N	NOURRITURE	-1.00	-8.16	0.00	t
10554	3552	\N	ROUGE VERRE	1.00	5.00	21.00	f
10555	3552	\N	COCA	2.00	2.20	21.00	f
10556	3552	\N	CRÊPE GORGONZOLA COURGETTES	1.00	16.00	12.00	f
10557	3552	\N	PÂTES PESTO + BURRATA	1.00	18.00	12.00	f
10558	3553	\N	ROUGE VERRE	2.00	5.00	21.00	f
10559	3553	\N	TAJINE	2.00	17.00	12.00	f
10560	3553	\N	ASSORTIMENT CROQUETTES	1.00	20.00	12.00	f
10561	3553	\N	PROSECCO VERRE	1.00	6.00	21.00	f
10562	3553	\N	GINGEMBRE	1.00	10.00	21.00	f
10564	3555	\N	Service ANTON	-1.00	-60.00	0.00	t
10565	3556	\N	NOURRITURE	-1.00	-19.38	0.00	t
10569	3558	\N	COCA	1.00	2.20	21.00	f
10570	3558	\N	ICE TEA	1.00	2.20	21.00	f
10571	3558	\N	VIN DU MOIS	4.00	15.00	21.00	f
10572	3558	\N	EAU PET 1/2 L	4.00	3.50	21.00	f
10573	3558	\N	BLUSH	2.00	20.00	21.00	f
10574	3558	\N	COUSCOUS PM	3.00	17.00	12.00	f
10575	3558	\N	VIANDE + GRATIN	1.00	24.00	12.00	f
10576	3558	\N	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	f
10577	3559	\N	SMASH	2.00	4.50	21.00	t
10578	3559	\N	BLANC VERRE	2.00	5.00	21.00	t
10581	3561	\N	ROUGE VERRE	2.00	5.00	21.00	f
10582	3561	\N	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	f
10583	3561	\N	VIANDE + GRATIN	1.00	24.00	12.00	f
10584	3561	\N	PECKET FRAISE	1.00	8.00	21.00	f
10585	3561	\N	COCA	2.00	2.20	21.00	f
10586	3562	\N	ASSORTIMENT CROQUETTES	1.00	20.00	12.00	t
10587	3562	\N	NERO D'AVOLA	1.00	30.00	21.00	t
10588	3562	\N	SABAYON	1.00	8.00	12.00	t
10589	3562	\N	TAJINE	1.00	17.00	12.00	t
10590	3562	\N	COUSCOUS PM	1.00	17.00	12.00	t
10597	3564	\N	Service Elise	-1.00	-60.00	0.00	t
10598	3565	\N	Service ANTON	-1.00	-60.00	0.00	t
10600	3567	\N	NOURRITURE	-1.00	-105.96	0.00	t
10601	3568	\N	MERGUEZ	-1.00	-36.05	0.00	t
10603	3570	\N	NOURRITURE	-1.00	-7.20	0.00	t
10604	3571	\N	SMASH	2.00	4.50	21.00	t
10610	3573	\N	GLACE	1.00	5.00	12.00	f
10611	3573	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	f
10612	3573	\N	CREME BRULEE	3.00	6.00	12.00	f
10613	3573	\N	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	f
10614	3573	\N	PÂTES CREME LARDONS	1.00	14.00	12.00	f
10615	3573	\N	COUSCOUS VG	1.00	12.00	12.00	f
10616	3573	\N	COUSCOUS PM	1.00	17.00	12.00	f
10617	3573	\N	ASSORTIMENT CROQUETTES	1.00	20.00	12.00	f
10618	3573	\N	SOFT (Verre)	1.00	2.20	21.00	f
10619	3573	\N	COCA ZERO	2.00	2.20	21.00	f
10620	3573	\N	COCA	1.00	2.20	21.00	f
10621	3573	\N	VIOLETTE	1.00	8.00	21.00	f
10622	3573	\N	PROSECCO VERRE	1.00	6.00	21.00	f
10623	3573	\N	BLANC VERRE	2.00	5.00	21.00	f
10624	3573	\N	CHAKTCHOUKA	1.00	12.00	12.00	f
10625	3574	\N	COCA	1.00	0.00	21.00	t
10630	3576	\N	COUSCOUS	2.00	10.00	6.00	f
10631	3576	\N	COUSCOUS PM	4.00	17.00	6.00	f
10632	3577	\N	SABAYON	1.00	8.00	12.00	t
10633	3577	\N	THÉ MENTHE	1.00	2.50	21.00	t
10634	3577	\N	PLAT SPÉCIAL	1.00	18.00	12.00	t
10635	3577	\N	PÂTES BOMBE ATOMIQUE + BURRATA	1.00	17.00	12.00	t
10636	3577	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	t
10637	3577	\N	CHAKTCHOUKA	1.00	12.00	12.00	t
10638	3577	\N	MANDURIA	1.00	30.00	21.00	t
10640	3579	\N	NOURRITURE	-1.00	-103.15	0.00	t
10641	3580	\N	TIRAMISU GLACÉ	2.00	6.00	6.00	f
10642	3580	\N	COUSCOUS PM	2.00	17.00	6.00	f
10644	3582	\N	TRIPLE	2.00	4.50	21.00	t
10645	3582	\N	COCA	3.00	2.20	21.00	t
10646	3582	\N	PÂTES CREME LARDONS	1.00	14.00	12.00	t
10647	3582	\N	CANNELLONI VIANDE	2.00	17.00	12.00	t
10648	3582	\N	CRÊPE CREME LARD	1.00	14.00	12.00	t
10649	3582	\N	CREPE GORGONZOLA COURGETTES XXL	3.00	19.00	12.00	t
10650	3582	\N	COUSCOUS PM	2.00	17.00	12.00	t
10651	3582	\N	ASSORTIMENT CROQUETTES	1.00	20.00	12.00	t
10652	3582	\N	ICE TEA	2.00	2.20	21.00	t
10653	3582	\N	COCA ZERO	3.00	2.20	21.00	t
10654	3582	\N	SMASH	5.00	4.50	21.00	t
10655	3582	\N	ORVAL	4.00	5.00	21.00	t
10656	3583	\N	JUPILER	1.00	2.50	21.00	f
10657	3583	\N	COCA ZERO	1.00	2.20	21.00	f
10658	3583	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
10682	3586	\N	NOURRITURE	-1.00	-11.20	0.00	t
10687	3589	\N	NOURRITURE	-1.00	-7.96	0.00	t
10697	3592	\N	CREME BRULEE	2.00	6.00	12.00	f
10698	3592	\N	BLANC VERRE	2.00	5.00	21.00	f
10699	3592	\N	PÂTES BOMBE ATOMIQUE + BURRATA	1.00	17.00	12.00	f
10700	3592	\N	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	f
10701	3592	\N	Cuba-Li	1.00	8.00	21.00	f
10702	3592	\N	PROSECCO VERRE	1.00	6.00	21.00	f
10737	3595	\N	Service ANTON	-1.00	-105.00	0.00	t
10740	3598	\N	Service CHA	-1.00	-50.00	0.00	t
10743	3601	\N	PROXIMUS	-1.00	-127.79	0.00	t
10746	3604	\N	CARBURANT	-1.00	-376.50	0.00	t
10749	3607	\N	LOYER	-1.00	-600.00	0.00	t
10752	3610	\N	CARBURANT	-1.00	-363.00	0.00	t
10758	3613	\N	COCA ZERO	1.00	2.20	21.00	t
10759	3613	\N	BLUSH	1.00	0.00	21.00	t
10760	3613	\N	SMASH	1.00	4.50	21.00	t
10786	3616	\N	COUSCOUS PM	1.00	17.00	12.00	t
10791	3619	\N	PECKET FRAISE	1.00	8.00	21.00	f
10814	3622	\N	BLANC VERRE	2.00	5.00	21.00	f
10815	3622	\N	ROUGE VERRE	1.00	5.00	21.00	f
10816	3622	\N	SCAMPIS LUCIFER	1.00	12.00	12.00	f
10817	3622	\N	COUSCOUS VG	1.00	12.00	12.00	f
10818	3622	\N	COUSCOUS PM	1.00	17.00	12.00	f
10819	3622	\N	PROSECCO VERRE	1.00	6.00	21.00	f
10820	3622	\N	GINGEMBRE	1.00	10.00	21.00	f
10823	3625	\N	Service CHACHA	-1.00	-30.00	0.00	t
10831	3628	\N	NOURRITURE	-1.00	-125.00	0.00	t
10847	3631	\N	SMASH	2.00	4.50	21.00	f
10860	3634	\N	SALADE PERLES MARINES	1.00	18.00	12.00	f
10861	3634	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
10862	3634	\N	Cuba-Li	1.00	8.00	21.00	f
10863	3634	\N	PECKET FRAISE	1.00	8.00	21.00	f
10867	3637	\N	BLONDINETTE	2.00	4.00	21.00	f
10874	3640	\N	JUPILER	2.00	2.50	21.00	t
10881	3643	\N	L'OR D'AURORE	1.00	8.00	21.00	f
10882	3643	\N	MANDURIA	1.00	30.00	21.00	f
10883	3643	\N	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	f
10884	3643	\N	CRÊPE CHAKCHOUKA XXL	1.00	12.00	12.00	f
10887	3646	\N	NOURRITURE	-1.00	-156.90	0.00	t
10906	3649	\N	TIRAMISU GLACÉ	1.00	6.00	6.00	t
10907	3649	\N	CREME BRULEE	1.00	6.00	6.00	t
10908	3649	\N	PÂTES TRUFFE + BURRATA	1.00	18.00	6.00	t
10917	3652	\N	CAFÉ	1.00	2.50	21.00	f
10918	3652	\N	IRISH COFFEE	2.00	8.00	21.00	f
10919	3652	\N	GLACE	3.00	5.00	12.00	f
10920	3652	\N	PROSECCO VERRE	1.00	6.00	21.00	f
10921	3652	\N	GIN 0%	1.00	8.00	21.00	f
10922	3652	\N	COCA ZERO	3.00	2.20	21.00	f
10923	3652	\N	FANTA	2.00	2.20	21.00	f
10924	3652	\N	ORVAL	1.00	5.00	21.00	f
10925	3652	\N	VIOLETTE	2.00	8.00	21.00	f
10926	3652	\N	COUSCOUS PM	2.00	17.00	12.00	f
10927	3652	\N	PÂTES PESTO + BURRATA	1.00	18.00	12.00	f
10928	3652	\N	TAJINE	2.00	17.00	12.00	f
10929	3652	\N	PÂTES TRUFFE	2.00	14.00	12.00	f
10930	3652	\N	ASSORTIMENT CROQUETTES	3.00	20.00	12.00	f
10931	3652	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
10943	3655	\N	Service CHA	-1.00	-40.00	0.00	t
10948	3658	\N	SMASH	1.00	4.50	21.00	f
10949	3658	\N	PROSECCO Bouteille	1.00	25.00	21.00	f
10954	3661	\N	CORNET BOLO	1.00	4.00	6.00	f
10955	3661	\N	JUPILER	2.00	2.50	21.00	f
10956	3661	\N	TRIPLE	1.00	4.50	21.00	f
10957	3661	\N	VAL DIEU	2.00	4.00	21.00	f
10970	3664	\N	CORNET LARD	1.00	6.00	6.00	t
10974	3667	\N	ICE TEA	1.00	2.20	21.00	f
10975	3667	\N	COCA ZERO	1.00	2.20	21.00	f
10976	3667	\N	Cuba-Li	2.00	8.00	21.00	f
10977	3667	\N	EAU PET 1/2 L	1.00	3.50	21.00	f
10978	3667	\N	JUPILER	5.00	2.50	21.00	f
10979	3667	\N	CAFÉ	1.00	2.50	21.00	f
10980	3667	\N	CORNET LARD	1.00	6.00	6.00	f
10981	3667	\N	CORNET BOLO	1.00	6.00	6.00	f
10984	3670	\N	NOURRITURE	-1.00	-44.49	0.00	t
10989	3673	\N	ROSÉ VERRE	2.00	5.00	21.00	f
11001	3676	\N	GRAPPA	2.00	6.00	21.00	t
11002	3676	\N	GLACE	1.00	5.00	6.00	t
11003	3676	\N	CREPE FLAMBEE GD MARNIER	1.00	10.00	6.00	t
11004	3676	\N	ROUGE VERRE	2.00	5.00	21.00	t
11005	3676	\N	BLANC VERRE	1.00	5.00	21.00	t
11006	3676	\N	SALADE PERLES MARINES	1.00	18.00	6.00	t
11007	3676	\N	PÂTES PESTO + BURRATA	1.00	18.00	6.00	t
11008	3676	\N	CRÊPE CREME LARD	1.00	14.00	6.00	t
11009	3676	\N	SOFT (Verre)	1.00	2.20	21.00	t
11010	3676	\N	TRIPLE	1.00	4.50	21.00	t
11011	3676	\N	PROSECCO VERRE	1.00	6.00	21.00	t
11025	3679	\N	CORNET TRUFFE	7.00	5.00	6.00	t
11026	3679	\N	CORNET LARD	8.00	5.00	6.00	t
11027	3679	\N	CORNET BOLO	7.00	5.00	6.00	t
11039	3682	\N	EAU PET 1/2 L	1.00	3.50	21.00	f
11040	3682	\N	COUSCOUS PM	2.00	17.00	12.00	f
11041	3682	\N	ROUGE VERRE	3.00	5.00	21.00	f
11052	3685	\N	NOURRITURE	-1.00	-10.64	0.00	t
11055	3688	\N	NOURRITURE	-1.00	-14.56	0.00	t
11058	3691	\N	NERO D'AVOLA	1.00	6.00	21.00	t
11059	3691	\N	COUSCOUS PM	2.00	17.00	12.00	t
11060	3691	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
11061	3691	\N	PROSECCO VERRE	2.00	6.00	21.00	t
11072	3694	\N	THÉ MENTHE	2.00	2.50	21.00	t
11073	3694	\N	NERO D'AVOLA	1.00	6.00	21.00	t
11074	3694	\N	CANNELLONI VIANDE	1.00	17.00	12.00	t
11075	3694	\N	CRÊPE CREME LARD	1.00	14.00	12.00	t
11076	3694	\N	PINOT GRIGIO	1.00	20.00	21.00	t
11077	3694	\N	CYNAR	1.00	5.00	21.00	t
11078	3694	\N	COCA ZERO	1.00	2.20	21.00	t
11081	3697	\N	COUSCOUS PM	1.00	17.00	6.00	t
11093	3700	\N	SALADE PERLES MARINES	1.00	18.00	12.00	t
11094	3700	\N	COUSCOUS PM	1.00	17.00	12.00	t
11095	3700	\N	CANNELLONI VIANDE	1.00	17.00	12.00	t
11096	3700	\N	BEIGNETS DE COURGETTE	1.00	18.00	12.00	t
11097	3700	\N	EAU PET 1/2 L	1.00	3.50	21.00	t
11098	3700	\N	ICE TEA	1.00	2.20	21.00	t
11099	3700	\N	BLANC VERRE	2.00	5.00	21.00	t
11100	3700	\N	ROUGE VERRE	1.00	5.00	21.00	t
11101	3700	\N	VIOLETTE	1.00	8.00	21.00	t
11102	3700	\N	CAFÉ	1.00	2.50	21.00	t
10659	3584	\N	PÂTES CREME LARDONS	2.00	14.00	12.00	t
10660	3584	\N	PÂTES BOLO	2.00	14.00	12.00	t
10661	3584	\N	COUSCOUS PM	2.00	17.00	12.00	t
10683	3587	\N	CHARDONNAY FIO	1.00	20.00	21.00	t
10684	3587	\N	PÂTES TRUFFE + BURRATA	1.00	18.00	12.00	t
10685	3587	\N	POLPETTE	1.00	16.00	12.00	t
10688	3590	\N	NOURRITURE	-1.00	-44.20	0.00	t
10703	3593	\N	ROUGE VERRE	1.00	5.00	21.00	f
10704	3593	\N	COUSCOUS PM	1.00	17.00	12.00	f
10705	3593	\N	COUSCOUS VG	1.00	12.00	12.00	f
10706	3593	\N	AMARONE	1.00	50.00	21.00	f
10707	3593	\N	CREPE FLAMBEE GD MARNIER	1.00	10.00	12.00	f
10708	3593	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	f
10738	3596	\N	Service ANTON	-1.00	-90.00	0.00	t
10741	3599	\N	AG ASSURANCE	-1.00	-175.47	0.00	t
10744	3602	\N	CARBURANT	-1.00	-106.83	0.00	t
10747	3605	\N	MERGUEZ	-1.00	-35.35	0.00	t
10750	3608	\N	ENERGIES	-1.00	-301.69	0.00	t
10753	3611	\N	PECKET FRAISE	3.00	8.00	21.00	f
10754	3611	\N	NOËL (BRUNE)	2.00	4.00	21.00	f
10755	3611	\N	BLONDINETTE	4.00	4.00	21.00	f
10756	3611	\N	SMASH	4.00	4.50	21.00	f
10761	3614	\N	CREME BRULEE	3.00	6.00	12.00	f
10762	3614	\N	TIRAMISU GLACÉ	5.00	6.00	12.00	f
10763	3614	\N	SABAYON SPECIAL	1.00	10.00	12.00	f
10764	3614	\N	DECA	1.00	2.50	21.00	f
10765	3614	\N	CHARDONNAY FIO	1.00	20.00	21.00	f
10766	3614	\N	BLUSH	1.00	20.00	21.00	f
10767	3614	\N	VIANDE + GRATIN	2.00	24.00	12.00	f
10768	3614	\N	PÂTES PESTO + BURRATA	1.00	18.00	12.00	f
10769	3614	\N	COUSCOUS VG	1.00	12.00	12.00	f
10770	3614	\N	CANNELLONI VIANDE	1.00	17.00	12.00	f
10771	3614	\N	PÂTES TRUFFE + BURRATA	1.00	18.00	12.00	f
10772	3614	\N	COUSCOUS PM	4.00	17.00	12.00	f
10773	3614	\N	TAJINE	2.00	17.00	12.00	f
10774	3614	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	f
10775	3614	\N	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	f
10776	3614	\N	FANTA	3.00	2.20	21.00	f
10777	3614	\N	COCA	4.00	2.20	21.00	f
10778	3614	\N	COCA ZERO	6.00	2.20	21.00	f
10779	3614	\N	ORVAL	1.00	5.00	21.00	f
10780	3614	\N	VAL DIEU	1.00	4.00	21.00	f
10781	3614	\N	SMASH	4.00	4.50	21.00	f
10787	3617	\N	Cuba-Li	1.00	8.00	21.00	f
10788	3617	\N	JUPILER	2.00	2.50	21.00	f
10792	3620	\N	JUPILER	1.00	2.50	21.00	f
10793	3620	\N	Cuba-Li	2.00	8.00	21.00	f
10794	3620	\N	BLUSH	2.00	20.00	21.00	f
10821	3623	\N	Service ANTON	-1.00	-60.00	0.00	t
10848	3632	\N	PÂTES TRUFFE	1.00	14.00	12.00	f
10849	3632	\N	PÂTES SCAMPIS	2.00	17.00	12.00	f
10850	3632	\N	COUSCOUS PM	1.00	17.00	12.00	f
10851	3632	\N	PÂTES CREME LARDONS	1.00	14.00	12.00	f
10852	3632	\N	PÂTES BOLO	1.00	14.00	12.00	f
10853	3632	\N	ROSÉ VERRE	2.00	5.00	21.00	f
10854	3632	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	f
10864	3635	\N	FANTA	2.00	2.20	21.00	t
10865	3635	\N	PÂTES SAUCE BASE	2.00	10.00	6.00	t
10868	3638	\N	BLANC VERRE	1.00	5.00	21.00	t
10869	3638	\N	GINGEMBRE	1.00	8.00	21.00	t
10870	3638	\N	PÂTES BOMBE ATOMIQUE + BURRATA	1.00	17.00	12.00	t
10871	3638	\N	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	t
10872	3638	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	t
10875	3641	\N	CORNET BOLO	1.00	6.00	6.00	t
10885	3644	\N	NOURRITURE	-1.00	-22.10	0.00	t
10888	3647	\N	Service Caro	-1.00	-105.00	0.00	t
10909	3650	\N	CANNELLONI RICO/EPI	1.00	17.00	6.00	t
10910	3650	\N	PÂTES SCAMPIS	1.00	17.00	6.00	t
10932	3653	\N	COCA ZERO	2.00	0.00	21.00	t
10933	3653	\N	PÂTES COURGETTE + SCAMPIS	1.00	0.00	12.00	t
10934	3653	\N	TAJINE	2.00	0.00	12.00	t
10935	3653	\N	ASSIETTE APERITIVE (2 p.)	1.00	0.00	12.00	t
10936	3653	\N	CHAKTCHOUKA	1.00	0.00	12.00	t
10937	3653	\N	ALCOOL	1.00	0.00	21.00	t
10938	3653	\N	VIOLETTE	1.00	0.00	21.00	t
10939	3653	\N	PROSECCO VERRE	2.00	0.00	21.00	t
10940	3653	\N	Cuba-Li	3.00	0.00	21.00	t
10941	3653	\N	MANDURIA	1.00	0.00	21.00	t
10944	3656	\N	SMASH	1.00	4.50	21.00	f
10945	3656	\N	PROSECCO Bouteille	1.00	25.00	21.00	f
10950	3659	\N	ICE TEA	1.00	2.20	21.00	t
10951	3659	\N	COCA ZERO	1.00	2.20	21.00	t
10952	3659	\N	JUPILER	1.00	2.50	21.00	t
10958	3662	\N	CORNET TRUFFE	1.00	7.00	6.00	t
10959	3662	\N	VAL DIEU	1.00	4.00	21.00	t
10960	3662	\N	CORNET LARD	1.00	6.00	6.00	t
10961	3662	\N	BLONDINETTE	1.00	4.00	21.00	t
10962	3662	\N	ICE TEA	1.00	2.20	21.00	t
10963	3662	\N	EAU PET 1/2 L	1.00	3.50	21.00	t
10964	3662	\N	JUPILER	17.00	2.50	21.00	t
10965	3662	\N	COCA	1.00	2.20	21.00	t
10966	3662	\N	CAFÉ	2.00	2.50	21.00	t
10971	3665	\N	JUPILER	1.00	2.50	21.00	t
10972	3665	\N	EAU PET 1/2 L	1.00	3.50	21.00	t
10982	3668	\N	BOISSONS	-1.00	-176.00	0.00	t
10985	3671	\N	NOURRITURE	-1.00	-16.22	0.00	t
10990	3674	\N	CANNELLONI RICO/EPI	1.00	17.00	12.00	t
10991	3674	\N	PÂTES PESTO + BURRATA	1.00	18.00	12.00	t
11012	3677	\N	PECKET FRAISE	2.00	8.00	21.00	t
10825	3626	\N	CAFÉ	1.00	2.50	21.00	f
10826	3626	\N	TIRAMISU GLACÉ	2.00	6.00	12.00	f
10827	3626	\N	COUSCOUS PM	2.00	17.00	12.00	f
10829	3626	\N	COCA ZERO	2.00	2.20	21.00	f
10842	3629	\N	VIOLETTE	1.00	8.00	21.00	f
10844	3629	\N	CHARDONNAY FIO	3.00	20.00	21.00	f
10832	3629	\N	BLANC VERRE	1.00	5.00	21.00	f
10834	3629	\N	POLPETTE	1.00	16.00	12.00	f
10662	3585	\N	ESPRESSO	1.00	2.50	21.00	t
10663	3585	\N	SABAYON SPECIAL	1.00	10.00	12.00	t
10664	3585	\N	GLACE	5.00	5.00	12.00	t
10665	3585	\N	CREME BRULEE	4.00	6.00	12.00	t
10666	3585	\N	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	t
10667	3585	\N	PÂTES TRUFFE	3.00	14.00	12.00	t
10668	3585	\N	PÂTES PESTO + BURRATA	1.00	18.00	12.00	t
10669	3585	\N	PÂTES PESTO	1.00	14.00	12.00	t
10670	3585	\N	PÂTES SAUCE BASE	2.00	12.00	12.00	t
10671	3585	\N	PÂTES CREME LARDONS	6.00	14.00	12.00	t
10672	3585	\N	PÂTES BOLO	4.00	14.00	12.00	t
10673	3585	\N	FANTA	1.00	2.20	21.00	t
10674	3585	\N	SMASH	3.00	4.50	21.00	t
10675	3585	\N	COCA	6.00	2.20	21.00	t
10676	3585	\N	VIANDE + GRATIN	1.00	24.00	12.00	t
10677	3585	\N	TAJINE	1.00	17.00	12.00	t
10678	3585	\N	CANNELLONI VIANDE	1.00	17.00	12.00	t
10679	3585	\N	CHAKTCHOUKA	1.00	12.00	12.00	t
10680	3585	\N	COUSCOUS PM	1.00	17.00	12.00	t
10681	3585	\N	TIRAMISU GLACÉ	3.00	6.00	12.00	t
10686	3588	\N	SMASH	3.00	4.50	21.00	t
10689	3591	\N	VIN DU MOIS	1.00	15.00	21.00	f
10690	3591	\N	VIANDE + GRATIN	2.00	24.00	12.00	f
10691	3591	\N	PÂTES TRUFFE + BURRATA	1.00	18.00	12.00	f
10692	3591	\N	ASSORTIMENT CROQUETTES	1.00	20.00	12.00	f
10693	3591	\N	PROSECCO VERRE	3.00	6.00	21.00	f
10694	3591	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	f
10695	3591	\N	CAFÉ	2.00	2.50	21.00	f
10696	3591	\N	CREME BRULEE	1.00	6.00	12.00	f
10709	3594	\N	SOFT (Verre)	1.00	2.20	21.00	t
10710	3594	\N	CRÊPE CREME LARD	1.00	14.00	12.00	t
10711	3594	\N	BULLES CHOCOLAT	1.00	0.00	21.00	t
10712	3594	\N	CRÊPE KABYLE	1.00	14.00	12.00	t
10713	3594	\N	PÂTES CREME LARDONS	1.00	14.00	12.00	t
10714	3594	\N	PÂTES BOLO	4.00	14.00	12.00	t
10715	3594	\N	POLPETTE	2.00	16.00	12.00	t
10716	3594	\N	PLAT SPÉCIAL	2.00	18.00	12.00	t
10717	3594	\N	TAJINE	1.00	17.00	12.00	t
10718	3594	\N	PÂTES COURGETTE + SCAMPIS	2.00	18.00	12.00	t
10719	3594	\N	COUSCOUS PM	1.00	17.00	12.00	t
10720	3594	\N	GIN TONIC	1.00	10.00	21.00	t
10721	3594	\N	PROSECCO VERRE	2.00	6.00	21.00	t
10722	3594	\N	EAU PET 1/2 L	2.00	3.50	21.00	t
10723	3594	\N	THÉ MENTHE	1.00	2.50	21.00	t
10724	3594	\N	CREME BRULEE	1.00	6.00	12.00	t
10725	3594	\N	SABAYON SPECIAL	1.00	10.00	12.00	t
10726	3594	\N	ASSIETTE APERITIVE (2 p.)	2.00	19.00	12.00	t
10727	3594	\N	COCA	2.00	2.20	21.00	t
10728	3594	\N	FANTA	4.00	2.20	21.00	t
10729	3594	\N	ICE TEA	1.00	2.20	21.00	t
10730	3594	\N	ROUGE VERRE	1.00	5.00	21.00	t
10731	3594	\N	VIOLETTE	2.00	8.00	21.00	t
10732	3594	\N	GINGEMBRE	1.00	10.00	21.00	t
10733	3594	\N	L'OR D'AURORE	2.00	8.00	21.00	t
10734	3594	\N	TIRAMISU GLACÉ	3.00	6.00	12.00	t
10735	3594	\N	GLACE	7.00	5.00	12.00	t
10736	3594	\N	GIN 0%	3.00	8.00	21.00	t
10739	3597	\N	Service EDOUARD	-1.00	-90.00	0.00	t
10742	3600	\N	RESTO AVEC MIKE	-1.00	-105.00	0.00	t
10745	3603	\N	ORANGE	-1.00	-28.00	0.00	t
10748	3606	\N	NOURRITURE	-1.00	-88.74	0.00	t
10751	3609	\N	COMPTABLE	-1.00	-363.00	0.00	t
10757	3612	\N	SMASH	2.00	4.50	21.00	f
10789	3618	\N	CORNET BOLO	1.00	6.00	6.00	f
10790	3618	\N	FANTA	1.00	2.20	21.00	f
10795	3621	\N	BLONDINETTE	1.00	4.00	21.00	t
10796	3621	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
10797	3621	\N	CREME BRULEE	1.00	6.00	12.00	t
10798	3621	\N	L'OR D'AURORE	2.00	8.00	21.00	t
10799	3621	\N	GLACE	2.00	5.00	12.00	t
10800	3621	\N	ROUGE VERRE	1.00	5.00	21.00	t
10801	3621	\N	FANTA	1.00	2.20	21.00	t
10802	3621	\N	PÂTES PESTO	1.00	14.00	12.00	t
10803	3621	\N	PÂTES BOLO	1.00	14.00	12.00	t
10804	3621	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
10805	3621	\N	CANNELLONI RICO/EPI	1.00	17.00	12.00	t
10806	3621	\N	CRÊPE GORGONZOLA COURGETTES	1.00	16.00	12.00	t
10807	3621	\N	PÂTES BOMBE ATOMIQUE + BURRATA	1.00	17.00	12.00	t
10808	3621	\N	PÂTES	1.00	8.00	12.00	t
10809	3621	\N	SOFT (Verre)	1.00	2.20	21.00	t
10810	3621	\N	ICE TEA	1.00	2.20	21.00	t
10811	3621	\N	RICARD	1.00	5.00	21.00	t
10812	3621	\N	PECKET FRAISE	1.00	8.00	21.00	t
10813	3621	\N	BLANC VERRE	2.00	5.00	21.00	t
10822	3624	\N	Service Elise	-1.00	-105.00	0.00	t
10830	3627	\N	NOURRITURE	-1.00	-10.27	0.00	t
10846	3630	\N	NOURRITURE	-1.00	-75.17	0.00	t
10866	3636	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	t
10873	3639	\N	SALADE PERLES MARINES	1.00	18.00	12.00	t
10876	3642	\N	CAFÉ	1.00	2.50	21.00	f
10877	3642	\N	COUSCOUS PM	1.00	17.00	12.00	f
10878	3642	\N	PÂTES COURGETTE	1.00	14.00	12.00	f
10879	3642	\N	JUPILER	2.00	2.50	21.00	f
10880	3642	\N	PROSECCO VERRE	2.00	6.00	21.00	f
10886	3645	\N	NOURRITURE	-1.00	-14.60	0.00	t
10889	3648	\N	ICE TEA	1.00	2.20	21.00	f
10890	3648	\N	COCA	2.00	2.20	21.00	f
10891	3648	\N	L'OR D'AURORE	1.00	8.00	21.00	f
10892	3648	\N	SABAYON SPECIAL	1.00	10.00	12.00	f
10893	3648	\N	CAPUCCINO	2.00	2.80	21.00	f
10894	3648	\N	THÉ MENTHE	2.00	2.50	21.00	f
10895	3648	\N	CRÊPE CHAKCHOUKA	1.00	14.00	12.00	f
10896	3648	\N	NERO D'AVOLA	2.00	6.00	21.00	f
10897	3648	\N	PRIMITIVO NR 14	1.00	5.00	21.00	f
10898	3648	\N	PÂTES BOMBE ATOMIQUE + BURRATA	1.00	17.00	12.00	f
10899	3648	\N	COCA ZERO	2.00	2.20	21.00	f
10900	3648	\N	PÂTES PESTO + BURRATA	1.00	18.00	12.00	f
10901	3648	\N	PÂTES TRUFFE	1.00	14.00	12.00	f
10902	3648	\N	PROSECCO VERRE	1.00	6.00	21.00	f
10903	3648	\N	GINGEMBRE	1.00	8.00	21.00	f
10783	3615	\N	NERO D'AVOLA	1.00	30.00	21.00	f
10784	3615	\N	BLUSH	2.00	20.00	21.00	f
10785	3615	\N	CHARDONNAY FIO	3.00	20.00	21.00	f
10858	3633	\N	TAJINE	1.00	17.00	12.00	t
10855	3633	\N	ESPRESSO	1.00	2.50	21.00	t
10904	3648	\N	VIOLETTE	1.00	8.00	21.00	f
10905	3648	\N	ASSIETTE APERITIVE (2 p.)	2.00	19.00	12.00	f
10911	3651	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
10912	3651	\N	CRÊPE CHAKCHOUKA	1.00	14.00	12.00	t
10913	3651	\N	TAJINE	1.00	17.00	12.00	t
10914	3651	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
10915	3651	\N	PINOT GRIGIO	1.00	20.00	21.00	t
10916	3651	\N	THÉ MENTHE	1.00	2.50	21.00	t
10942	3654	\N	Service EDOUARD	-1.00	-90.00	0.00	t
10946	3657	\N	ORVAL	1.00	5.00	21.00	f
10947	3657	\N	PROSECCO Bouteille	1.00	25.00	21.00	f
10953	3660	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	t
10967	3663	\N	BLONDINETTE	3.00	4.00	21.00	f
10968	3663	\N	JUPILER	5.00	2.50	21.00	f
10969	3663	\N	EAU PET 1/2 L	1.00	3.50	21.00	f
10973	3666	\N	SMASH	2.00	4.50	21.00	t
10983	3669	\N	NOURRITURE	-1.00	-54.68	0.00	t
10986	3672	\N	VIN DU MOIS	1.00	15.00	21.00	f
10987	3672	\N	JUPILER	2.00	2.50	21.00	f
10988	3672	\N	COUSCOUS PM	1.00	17.00	12.00	f
10992	3675	\N	PROSECCO Bouteille	2.00	25.00	21.00	f
10993	3675	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	f
10994	3675	\N	EAU PET 1/2 L	2.00	3.50	21.00	f
10995	3675	\N	ORVAL	1.00	5.00	21.00	f
10996	3675	\N	NERO D'AVOLA	1.00	30.00	21.00	f
10997	3675	\N	VIN DU MOIS	2.00	15.00	21.00	f
10998	3675	\N	BLUSH	2.00	20.00	21.00	f
10999	3675	\N	SALADE PERLES MARINES	1.00	18.00	12.00	f
11000	3675	\N	PÂTES STRACIATELLA SCAMPIS	2.00	20.00	12.00	f
11024	3678	\N	Service ANTON	-1.00	-90.00	0.00	t
11030	3681	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	f
11031	3681	\N	CREME BRULEE	1.00	6.00	12.00	f
11032	3681	\N	GIN 0%	1.00	8.00	21.00	f
11033	3681	\N	BLANC VERRE	1.00	5.00	21.00	f
11034	3681	\N	ROSÉ MAISON	1.00	3.50	21.00	f
11035	3681	\N	VAL DIEU	1.00	4.00	21.00	f
11036	3681	\N	TAJINE	1.00	17.00	12.00	f
11037	3681	\N	PÂTES TRUFFE	1.00	14.00	12.00	f
11038	3681	\N	CRÊPE TRUFFES	2.00	21.00	12.00	f
11043	3684	\N	CHARDONNAY FIO	1.00	20.00	21.00	t
11044	3684	\N	FANTA	1.00	2.20	21.00	t
11045	3684	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	t
11046	3684	\N	POLPETTE	1.00	16.00	6.00	t
11047	3684	\N	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	6.00	t
11048	3684	\N	PÂTES TRUFFE + BURRATA	1.00	18.00	6.00	t
11049	3684	\N	PÂTES PESTO + BURRATA	1.00	18.00	6.00	t
11050	3684	\N	PÂTES CREME LARDONS	1.00	14.00	6.00	t
11051	3684	\N	PÂTES BOLO	1.00	14.00	6.00	t
11054	3687	\N	NOURRITURE	-1.00	-49.57	0.00	t
11057	3690	\N	PROSECCO VERRE	3.00	6.00	21.00	f
11067	3693	\N	BLUSH	1.00	20.00	21.00	t
11068	3693	\N	CREME BRULEE	2.00	6.00	12.00	t
11069	3693	\N	GINGEMBRE	2.00	8.00	21.00	t
11070	3693	\N	TAJINE	2.00	17.00	12.00	t
11071	3693	\N	ESPRESSO	1.00	2.50	21.00	t
11080	3696	\N	CORNET BOLO	2.00	6.00	6.00	t
11085	3699	\N	CAFÉ	1.00	2.50	21.00	t
11086	3699	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
11087	3699	\N	EAU PET 1/2 L	1.00	3.50	21.00	t
11088	3699	\N	FANTA	1.00	2.20	21.00	t
11089	3699	\N	COUSCOUS VG	1.00	12.00	12.00	t
11090	3699	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
11091	3699	\N	CRÊPE CHAKCHOUKA XXL	1.00	17.00	12.00	t
11092	3699	\N	ROUGE VERRE	1.00	5.00	21.00	t
11112	3702	\N	COUSCOUS VG	1.00	12.00	12.00	t
11113	3702	\N	COUSCOUS PM	1.00	17.00	12.00	t
11114	3702	\N	MANDURIA	1.00	30.00	21.00	t
11115	3702	\N	BEIGNETS DE COURGETTE	1.00	18.00	12.00	t
11116	3702	\N	ORVAL	1.00	5.00	21.00	t
11117	3702	\N	THÉ MENTHE	1.00	2.50	21.00	t
11131	3705	\N	NOURRITURE	-1.00	-85.44	0.00	t
11134	3708	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
11135	3708	\N	COUSCOUS PM	1.00	17.00	12.00	t
11136	3708	\N	SCAMPIS LUCIFER	1.00	15.00	12.00	t
11137	3708	\N	MANDURIA	1.00	6.00	21.00	t
11138	3708	\N	BEIGNETS DE COURGETTE	1.00	18.00	12.00	t
11139	3708	\N	NERO D'AVOLA	2.00	5.00	21.00	t
11150	3711	\N	CAFÉ	2.00	2.50	21.00	f
11151	3711	\N	CANNELLONI VIANDE	1.00	17.00	12.00	f
11152	3711	\N	ASSORTIMENT CROQUETTES	1.00	20.00	12.00	f
11153	3711	\N	BEIGNETS DE COURGETTE	1.00	18.00	12.00	f
11154	3711	\N	AMARONE	1.00	50.00	21.00	f
11155	3711	\N	PROSECCO VERRE	1.00	6.00	21.00	f
11156	3711	\N	VIOLETTE	1.00	8.00	21.00	f
11157	3711	\N	COUSCOUS PM	1.00	17.00	12.00	f
11164	3714	\N	RESTO AVEC LOUNA	-1.00	-93.00	0.00	t
11171	3717	\N	PÂTES TRUFFE	2.00	0.00	12.00	f
11172	3717	\N	SALADE PERLES MARINES	1.00	18.00	12.00	f
11173	3717	\N	COCA ZERO	2.00	2.20	21.00	f
11193	3720	\N	L'OR D'AURORE	1.00	8.00	21.00	f
11194	3720	\N	CREME BRULEE	1.00	6.00	12.00	f
11195	3720	\N	MANDURIA	2.00	30.00	21.00	f
11196	3720	\N	COCA ZERO	2.00	2.20	21.00	f
11197	3720	\N	BEIGNETS DE COURGETTE	1.00	18.00	12.00	f
11198	3720	\N	PÂTES ASPERGES	1.00	18.00	12.00	f
11199	3720	\N	PÂTES SCAMPIS	1.00	17.00	12.00	f
11200	3720	\N	POLPETTE	1.00	16.00	12.00	f
11201	3720	\N	TAJINE	1.00	17.00	12.00	f
11202	3720	\N	COUSCOUS PM	1.00	17.00	12.00	f
11203	3720	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
11204	3720	\N	APEROL SPRITZ	1.00	8.00	21.00	f
11205	3720	\N	Cuba-Li	4.00	8.00	21.00	f
11206	3720	\N	PROSECCO VERRE	2.00	6.00	21.00	f
11207	3720	\N	GIN TONIC	1.00	10.00	21.00	f
11210	3723	\N	LOYER	-1.00	-600.00	0.00	t
11213	3726	\N	CARBURANT	-1.00	-148.00	0.00	t
11216	3729	\N	BLUSH	1.00	5.00	21.00	t
11217	3729	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	t
11233	3732	\N	ROSÉ VERRE	2.00	5.00	21.00	f
11236	3735	\N	NOURRITURE	-1.00	-62.89	0.00	t
11243	3738	\N	POLPETTE	1.00	16.00	6.00	t
11251	3741	\N	CANNELLONI VIANDE	1.00	17.00	12.00	t
11252	3741	\N	PÂTES TRUFFE + BURRATA	1.00	18.00	12.00	t
11253	3741	\N	PECKET FRAISE	1.00	8.00	21.00	t
11254	3741	\N	VAL DIEU	1.00	4.00	21.00	t
11255	3741	\N	ASSORTIMENT CROQUETTES	1.00	20.00	12.00	t
11280	3744	\N	Service EVE	-1.00	-60.00	0.00	t
11285	3747	\N	L'OR D'AURORE	1.00	8.00	21.00	t
11013	3677	\N	CREME CITRON	1.00	6.00	21.00	t
11014	3677	\N	ROSÉ MAISON	2.00	3.50	21.00	t
11015	3677	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
11016	3677	\N	VIN DU MOIS	1.00	15.00	21.00	t
11017	3677	\N	PÂTES BOMBE ATOMIQUE + BURRATA	1.00	17.00	12.00	t
11018	3677	\N	CHAMPIGNONS KABYLES	1.00	13.00	12.00	t
11019	3677	\N	PÂTES STRACIATELLA SCAMPIS	2.00	20.00	12.00	t
11020	3677	\N	POLPETTE	1.00	16.00	12.00	t
11021	3677	\N	VIOLETTE	1.00	8.00	21.00	t
11022	3677	\N	GINGEMBRE	1.00	8.00	21.00	t
11023	3677	\N	PROSECCO VERRE	4.00	6.00	21.00	t
11028	3680	\N	COUSCOUS VG	1.00	12.00	12.00	t
11029	3680	\N	COUSCOUS PM	1.00	17.00	12.00	t
11042	3683	\N	Service ANTON	-1.00	-45.00	0.00	t
11053	3686	\N	NOURRITURE	-1.00	-9.60	0.00	t
11056	3689	\N	EQUIPEMENT	-1.00	-7.95	0.00	t
11062	3692	\N	PÂTES TRUFFE + BURRATA	1.00	18.00	6.00	t
11063	3692	\N	COUSCOUS PM	1.00	17.00	6.00	t
11064	3692	\N	GINGEMBRE	1.00	8.00	21.00	t
11065	3692	\N	CHAMPIGNONS KABYLES	1.00	10.00	6.00	t
11066	3692	\N	CHAKTCHOUKA	1.00	12.00	6.00	t
11079	3695	\N	Service Maurine	-1.00	-50.00	0.00	t
11082	3698	\N	MANDURIA	1.00	30.00	21.00	t
11083	3698	\N	TAJINE	2.00	17.00	12.00	t
11084	3698	\N	CHAKTCHOUKA	2.00	12.00	12.00	t
11105	3701	\N	BLANC VERRE	2.00	5.00	21.00	t
11106	3701	\N	Cuba-Li	1.00	8.00	21.00	t
11107	3701	\N	GIN TONIC	1.00	10.00	21.00	t
11108	3701	\N	CREME BRULEE	1.00	6.00	12.00	t
11109	3701	\N	SALADE PERLES MARINES	1.00	18.00	12.00	t
11110	3701	\N	COUSCOUS PM	1.00	17.00	12.00	t
11111	3701	\N	BEIGNETS DE COURGETTE	1.00	18.00	12.00	t
11130	3704	\N	NOURRITURE	-1.00	-151.56	0.00	t
11133	3707	\N	NOURRITURE	-1.00	-33.20	0.00	t
11145	3710	\N	COCA ZERO	2.00	2.20	21.00	t
11146	3710	\N	COCA	1.00	2.20	21.00	t
11147	3710	\N	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	t
11148	3710	\N	POLPETTE	2.00	16.00	12.00	t
11149	3710	\N	ESPRESSO	1.00	2.50	21.00	t
11163	3713	\N	FANTA	1.00	2.20	21.00	t
11166	3716	\N	VIN DU MOIS	1.00	15.00	21.00	f
11167	3716	\N	BLUSH	4.00	20.00	21.00	f
11168	3716	\N	SALADE PERLES MARINES	1.00	18.00	12.00	f
11169	3716	\N	PÂTES ASPERGES	1.00	18.00	12.00	f
11170	3716	\N	TAJINE	1.00	17.00	12.00	f
11177	3719	\N	ALCOOL	1.00	6.00	21.00	t
11178	3719	\N	LIMONCELLO	2.00	6.00	21.00	t
11179	3719	\N	AMARETTO	1.00	6.00	21.00	t
11180	3719	\N	COCA ZERO	3.00	2.20	21.00	t
11181	3719	\N	PINOT GRIGIO	1.00	20.00	21.00	t
11182	3719	\N	PÂTES TRUFFE + BURRATA	1.00	18.00	12.00	t
11183	3719	\N	PÂTES BOMBE ATOMIQUE + BURRATA	3.00	17.00	12.00	t
11184	3719	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
11185	3719	\N	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	t
11186	3719	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	t
11187	3719	\N	COUSCOUS PM	2.00	17.00	12.00	t
11188	3719	\N	ASSIETTE APERITIVE (2 p.)	2.00	19.00	12.00	t
11189	3719	\N	COCA	4.00	2.20	21.00	t
11190	3719	\N	GINGEMBRE	1.00	8.00	21.00	t
11191	3719	\N	PECKET FRAISE	4.00	8.00	21.00	t
11192	3719	\N	PROSECCO VERRE	3.00	6.00	21.00	t
11209	3722	\N	Service HANAË	-1.00	-90.00	0.00	t
11212	3725	\N	CARBURANT	-1.00	-147.50	0.00	t
11215	3728	\N	BOISSONS	-1.00	-114.71	0.00	t
11225	3731	\N	CAPUCCINO	1.00	2.80	21.00	t
11226	3731	\N	L'OR D'AURORE	1.00	8.00	21.00	t
11227	3731	\N	PÂTES TRUFFE + BURRATA	1.00	18.00	12.00	t
11228	3731	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	t
11229	3731	\N	PÂTES PESTO + BURRATA	1.00	18.00	12.00	t
11230	3731	\N	SCAMPIS LUCIFER	1.00	12.00	12.00	t
11231	3731	\N	BLONDINETTE	1.00	4.00	21.00	t
11232	3731	\N	COCA ZERO	1.00	2.20	21.00	t
11235	3734	\N	CARBURANT	-1.00	-149.27	0.00	t
11238	3737	\N	ROUGE VERRE	2.00	6.00	21.00	t
11239	3737	\N	VIANDE + GRATIN	2.00	24.00	12.00	t
11240	3737	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
11241	3737	\N	MANDURIA	1.00	30.00	21.00	t
11242	3737	\N	JUPILER	1.00	2.50	21.00	t
11245	3740	\N	CAFÉ	1.00	2.50	21.00	f
11246	3740	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	f
11247	3740	\N	SALADE PERLES MARINES	1.00	18.00	12.00	f
11248	3740	\N	TAJINE	1.00	17.00	12.00	f
11249	3740	\N	EAU PET 1/2 L	1.00	3.50	21.00	f
11250	3740	\N	NERO D'AVOLA	1.00	5.00	21.00	f
11271	3743	\N	CAFÉ	1.00	2.50	21.00	f
11272	3743	\N	DECA	2.00	2.50	21.00	f
11273	3743	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	f
11274	3743	\N	L'OR D'AURORE	2.00	8.00	21.00	f
11275	3743	\N	Cuba-Li	1.00	8.00	21.00	f
11276	3743	\N	COUSCOUS PM	1.00	17.00	12.00	f
11277	3743	\N	TAJINE	2.00	17.00	12.00	f
11278	3743	\N	JUPILER	1.00	2.50	21.00	f
11279	3743	\N	PROSECCO VERRE	1.00	6.00	21.00	f
11282	3746	\N	TAJINE	1.00	17.00	12.00	t
11283	3746	\N	COUSCOUS PM	1.00	17.00	12.00	t
11284	3746	\N	EAU PET 1/2 L	1.00	3.50	21.00	t
11301	3749	\N	Service CHA	-1.00	-50.00	0.00	t
11304	3752	\N	ORANGE	-1.00	-40.24	0.00	t
11307	3755	\N	POULET	-1.00	-87.50	0.00	t
11310	3758	\N	AG ASSURANCE	-1.00	-175.47	0.00	t
11327	3761	\N	THÉ MENTHE	1.00	2.50	21.00	t
11328	3761	\N	COCA ZERO	1.00	2.20	21.00	t
11329	3761	\N	ROUGE VERRE	3.00	5.00	21.00	t
11330	3761	\N	COUSCOUS PM	2.00	17.00	12.00	t
11331	3761	\N	SCAMPIS LUCIFER	1.00	12.00	12.00	t
11332	3761	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	t
11333	3761	\N	BLONDINETTE	1.00	4.00	21.00	t
11334	3761	\N	PECKET FRAISE	1.00	8.00	21.00	t
11337	3764	\N	JUPILER	1.00	2.50	21.00	f
11338	3764	\N	ROSÉ VERRE	1.00	3.50	21.00	f
11351	3767	\N	NOURRITURE	-1.00	-4.08	0.00	t
11356	3770	\N	SALADE PERLES MARINES	2.00	18.00	12.00	f
11366	3773	\N	FANTA	2.00	2.20	21.00	t
11367	3773	\N	ROUGE VERRE	2.00	5.00	21.00	t
11368	3773	\N	PÂTES PESTO + BURRATA	1.00	18.00	12.00	t
11369	3773	\N	CRÊPE KABYLE	1.00	14.00	12.00	t
11370	3773	\N	POLPETTE	1.00	16.00	12.00	t
11371	3773	\N	BEIGNETS DE COURGETTE	1.00	18.00	12.00	t
11103	3700	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
11104	3700	\N	L'OR D'AURORE	1.00	8.00	21.00	t
11118	3703	\N	PÂTES TRUFFE + BURRATA	1.00	18.00	12.00	t
11119	3703	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	t
11120	3703	\N	CANNELLONI RICO/EPI	1.00	17.00	12.00	t
11121	3703	\N	VIANDE + GRATIN	2.00	24.00	12.00	t
11122	3703	\N	GLACE	2.00	5.00	12.00	t
11123	3703	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
11124	3703	\N	CREME BRULEE	1.00	6.00	12.00	t
11125	3703	\N	COUSCOUS PM	1.00	17.00	12.00	t
11126	3703	\N	MANDURIA	2.00	30.00	21.00	t
11127	3703	\N	CHARDONNAY FIO	2.00	20.00	21.00	t
11128	3703	\N	JUPILER	4.00	2.50	21.00	t
11129	3703	\N	PÂTES TRUFFE	1.00	14.00	12.00	t
11132	3706	\N	EQUIPEMENT	-1.00	-104.10	0.00	t
11140	3709	\N	L'OR D'AURORE	2.00	8.00	21.00	t
11141	3709	\N	COUSCOUS PM	1.00	17.00	12.00	t
11142	3709	\N	CANNELLONI VIANDE	1.00	17.00	12.00	t
11143	3709	\N	PROSECCO VERRE	2.00	6.00	21.00	t
11144	3709	\N	PRIMITIVO NR 14	1.00	24.00	21.00	t
11158	3712	\N	L'OR D'AURORE	1.00	8.00	21.00	f
11159	3712	\N	VIANDE + GRATIN	1.00	24.00	12.00	f
11160	3712	\N	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	f
11161	3712	\N	Cuba-Li	1.00	8.00	21.00	f
11162	3712	\N	VIOLETTE	1.00	8.00	21.00	f
11165	3715	\N	EQUIPEMENT	-1.00	-119.94	0.00	t
11174	3718	\N	PÂTES PESTO + BURRATA	1.00	18.00	12.00	t
11175	3718	\N	COUSCOUS PM	1.00	17.00	12.00	t
11176	3718	\N	SALADE PERLES MARINES	1.00	18.00	12.00	t
11208	3721	\N	Service ANTON	-1.00	-90.00	0.00	t
11211	3724	\N	POULET	-1.00	-87.50	0.00	t
11214	3727	\N	ORANGE	-1.00	-54.95	0.00	t
11218	3730	\N	L'OR D'AURORE	1.00	8.00	21.00	t
11219	3730	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
11220	3730	\N	COCA	1.00	2.20	21.00	t
11221	3730	\N	COCA ZERO	1.00	2.20	21.00	t
11222	3730	\N	CANNELLONI VIANDE	1.00	17.00	12.00	t
11223	3730	\N	COUSCOUS PM	1.00	17.00	12.00	t
11224	3730	\N	PROSECCO VERRE	2.00	6.00	21.00	t
11234	3733	\N	Service EDOUARD	-1.00	-50.00	0.00	t
11237	3736	\N	NOURRITURE	-1.00	-20.45	0.00	t
11244	3739	\N	DESPRIETS	-1.00	-118.76	0.00	t
11256	3742	\N	LIMONCELLO	2.00	6.00	21.00	t
11257	3742	\N	GRAPPA	1.00	6.00	21.00	t
11258	3742	\N	ESPRESSO	1.00	2.50	21.00	t
11259	3742	\N	CAFÉ	1.00	2.50	21.00	t
11260	3742	\N	L'OR D'AURORE	2.00	8.00	21.00	t
11261	3742	\N	SABAYON	1.00	8.00	12.00	t
11262	3742	\N	SABAYON SPECIAL	1.00	10.00	12.00	t
11263	3742	\N	PINOT GRIGIO	1.00	20.00	21.00	t
11264	3742	\N	BEIGNETS DE COURGETTE	1.00	18.00	12.00	t
11265	3742	\N	TAJINE	2.00	17.00	12.00	t
11266	3742	\N	EAU PÉTILLANTE 1 L	2.00	5.00	21.00	t
11267	3742	\N	Cuba-Li	2.00	8.00	21.00	t
11268	3742	\N	CHAKTCHOUKA	1.00	12.00	12.00	t
11269	3742	\N	CANNELLONI RICO/EPI	1.00	17.00	12.00	t
11270	3742	\N	SALADE PERLES MARINES	1.00	18.00	12.00	t
11281	3745	\N	Service ANTON	-1.00	-75.00	0.00	t
11293	3748	\N	COUSCOUS PM	2.00	17.00	12.00	t
11294	3748	\N	PÂTES PESTO + BURRATA	1.00	18.00	12.00	t
11295	3748	\N	LIMONCELLO	1.00	6.00	21.00	t
11296	3748	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
11297	3748	\N	CREME BRULEE	1.00	6.00	12.00	t
11298	3748	\N	COCA	1.00	2.20	21.00	t
11299	3748	\N	PROSECCO VERRE	1.00	6.00	21.00	t
11300	3748	\N	ROSÉ VERRE	2.00	5.00	21.00	t
11303	3751	\N	ENERGIES	-1.00	-301.69	0.00	t
11306	3754	\N	SUSHI	-1.00	-81.90	0.00	t
11309	3757	\N	Service Tempo-Team	-1.00	-110.12	0.00	t
11317	3760	\N	BLANC VERRE	3.00	5.00	21.00	f
11318	3760	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
11319	3760	\N	TAJINE	1.00	17.00	12.00	f
11320	3760	\N	VIANDE + GRATIN	1.00	24.00	12.00	f
11321	3760	\N	PÂTES COURGETTE	1.00	14.00	12.00	f
11322	3760	\N	ICE TEA	3.00	2.20	21.00	f
11323	3760	\N	PROSECCO VERRE	1.00	6.00	21.00	f
11324	3760	\N	TRIPLE	3.00	4.50	21.00	f
11325	3760	\N	L'OR D'AURORE	1.00	8.00	21.00	f
11326	3760	\N	ROUGE VERRE	2.00	5.00	21.00	f
11336	3763	\N	VIN DU MOIS	1.00	15.00	21.00	f
11348	3766	\N	Cuba-Li	4.00	8.00	21.00	t
11349	3766	\N	SMASH	1.00	4.50	21.00	t
11350	3766	\N	COCA ZERO	1.00	2.20	21.00	t
11353	3769	\N	CANNELLONI VIANDE	1.00	17.00	12.00	f
11354	3769	\N	COUSCOUS PM	1.00	17.00	12.00	f
11355	3769	\N	SMASH	2.00	4.50	21.00	f
11363	3772	\N	PÂTES CREME LARDONS	1.00	14.00	12.00	t
11364	3772	\N	PÂTES BOLO	1.00	14.00	12.00	t
11365	3772	\N	JUPILER	4.00	2.50	21.00	t
11377	3775	\N	PÂTES CREME LARDONS	1.00	14.00	12.00	t
11378	3775	\N	BEIGNETS DE COURGETTE	1.00	18.00	12.00	t
11379	3775	\N	PROSECCO Bouteille	1.00	25.00	21.00	t
11380	3775	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
11381	3775	\N	VIOLETTE	1.00	8.00	21.00	t
11382	3775	\N	PECKET FRAISE	1.00	8.00	21.00	t
11399	3778	\N	Service EDOUARD	-1.00	-75.00	0.00	t
11420	3781	\N	Service Elise	-1.00	-60.00	0.00	t
11423	3784	\N	NOURRITURE	-1.00	-13.50	0.00	t
11431	3787	\N	Cuba-Li	1.00	8.00	21.00	f
11432	3787	\N	COCA ZERO	1.00	2.20	21.00	f
11433	3787	\N	FORFAIT	2.00	50.00	12.00	f
11434	3787	\N	COCA	1.00	2.20	21.00	f
11446	3790	\N	LIMONCELLO	2.00	6.00	21.00	t
11447	3790	\N	COCA ZERO	2.00	2.20	21.00	t
11448	3790	\N	Cuba-Li	3.00	8.00	21.00	t
11449	3790	\N	PROSECCO VERRE	2.00	6.00	21.00	t
11450	3790	\N	ROSÉ VERRE	3.00	5.00	21.00	t
11451	3790	\N	PECKET FRAISE	1.00	8.00	21.00	t
11455	3793	\N	ROUGE VERRE	2.00	5.00	21.00	f
11456	3793	\N	PINOT GRIGIO	1.00	20.00	21.00	f
11457	3793	\N	BLUSH	2.00	20.00	21.00	f
11458	3793	\N	PECKET FRAISE	3.00	8.00	21.00	f
11459	3793	\N	ROSÉ VERRE	2.00	5.00	21.00	f
11460	3793	\N	FORFAIT	5.00	50.00	12.00	f
11461	3793	\N	NERO D'AVOLA	4.00	30.00	21.00	f
11464	3796	\N	Service Elise	-1.00	-15.00	0.00	t
11472	3799	\N	GLACE	1.00	5.00	12.00	f
11473	3799	\N	TIRAMISU GLACÉ	2.00	6.00	12.00	f
11474	3799	\N	L'OR D'AURORE	2.00	8.00	21.00	f
11286	3747	\N	CAFÉ	1.00	2.50	21.00	t
11287	3747	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
11288	3747	\N	COUSCOUS VG	1.00	12.00	12.00	t
11289	3747	\N	PÂTES BOMBE ATOMIQUE + BURRATA	1.00	17.00	12.00	t
11290	3747	\N	COUSCOUS PM	1.00	17.00	12.00	t
11291	3747	\N	SCAMPIS LUCIFER	1.00	12.00	12.00	t
11292	3747	\N	AMARONE	1.00	50.00	21.00	t
11302	3750	\N	CARBURANT	-1.00	-124.00	0.00	t
11305	3753	\N	POUBELLES VERLAINE	-1.00	-127.50	0.00	t
11308	3756	\N	FRAIS	-1.00	-146.76	0.00	t
11311	3759	\N	PÂTES TRUFFE + BURRATA	1.00	18.00	12.00	t
11312	3759	\N	JUPILER	1.00	2.50	21.00	t
11313	3759	\N	COCA ZERO	1.00	2.20	21.00	t
11314	3759	\N	ROUGE VERRE	3.00	5.00	21.00	t
11315	3759	\N	ASSORTIMENT CROQUETTES	1.00	20.00	12.00	t
11316	3759	\N	POLPETTE	1.00	16.00	12.00	t
11335	3762	\N	Service Maurine	-1.00	-50.00	0.00	t
11339	3765	\N	COCA ZERO	1.00	2.20	21.00	t
11340	3765	\N	Cuba-Li	11.00	8.00	21.00	t
11341	3765	\N	Cuba-Li	5.00	8.00	21.00	t
11342	3765	\N	MANDURIA	2.00	30.00	21.00	t
11343	3765	\N	COUSCOUS PM	3.00	17.00	12.00	t
11344	3765	\N	SPARE RIBS	2.00	18.00	12.00	t
11345	3765	\N	VIN DU MOIS	1.00	15.00	21.00	t
11346	3765	\N	JUPILER	3.00	2.50	21.00	t
11347	3765	\N	SMASH	6.00	4.50	21.00	t
11352	3768	\N	NOURRITURE	-1.00	-47.21	0.00	t
11357	3771	\N	CAFÉ	1.00	2.50	21.00	t
11358	3771	\N	SALADE PERLES MARINES	1.00	18.00	12.00	t
11359	3771	\N	VIANDE + GRATIN	1.00	24.00	12.00	t
11360	3771	\N	NERO D'AVOLA	1.00	30.00	21.00	t
11361	3771	\N	VIOLETTE	2.00	8.00	21.00	t
11362	3771	\N	BEIGNETS DE COURGETTE	1.00	18.00	12.00	t
11372	3774	\N	CANNELLONI VIANDE	1.00	17.00	12.00	t
11373	3774	\N	VIANDE + GRATIN	1.00	24.00	12.00	t
11374	3774	\N	NERO D'AVOLA	1.00	30.00	21.00	t
11375	3774	\N	BEIGNETS DE COURGETTE	1.00	18.00	12.00	t
11376	3774	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	t
11392	3777	\N	EAU DE BARNEY	1.00	0.00	21.00	f
11393	3777	\N	COCA	1.00	2.20	21.00	f
11394	3777	\N	Cuba-Li	2.00	8.00	21.00	f
11395	3777	\N	LIMONCELLO	2.00	6.00	21.00	f
11396	3777	\N	BEIGNETS DE COURGETTE	1.00	18.00	12.00	f
11397	3777	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	f
11398	3777	\N	PINOT GRIGIO	1.00	20.00	21.00	f
11401	3780	\N	Cuba-Li	2.00	8.00	21.00	f
11402	3780	\N	SAMBUCA	2.00	6.00	21.00	f
11403	3780	\N	L'OR D'AURORE	3.00	8.00	21.00	f
11404	3780	\N	TIRAMISU GLACÉ	6.00	6.00	12.00	f
11405	3780	\N	CREME BRULEE	1.00	6.00	12.00	f
11406	3780	\N	GLACE	4.00	5.00	12.00	f
11407	3780	\N	COCA ZERO	3.00	2.20	21.00	f
11408	3780	\N	GIN 0%	1.00	8.00	21.00	f
11409	3780	\N	ICE TEA	5.00	0.00	21.00	f
11410	3780	\N	SOFT (Verre)	2.00	0.00	21.00	f
11411	3780	\N	CHAMPAGNE	1.00	50.00	21.00	f
11412	3780	\N	PROSECCO Bouteille	1.00	25.00	21.00	f
11413	3780	\N	PÂTES	4.00	0.00	12.00	f
11414	3780	\N	CANNELLONI VIANDE	1.00	17.00	12.00	f
11415	3780	\N	POLPETTE	3.00	16.00	12.00	f
11416	3780	\N	TAJINE	3.00	17.00	12.00	f
11417	3780	\N	COUSCOUS PM	3.00	17.00	12.00	f
11418	3780	\N	MANDURIA	2.00	30.00	21.00	f
11419	3780	\N	CHARDONNAY FIO	2.00	20.00	21.00	f
11422	3783	\N	MERGUEZ	-1.00	-25.00	0.00	t
11427	3786	\N	JUPILER	1.00	2.50	21.00	f
11428	3786	\N	PECKET FRAISE	1.00	8.00	21.00	f
11429	3786	\N	FORFAIT	2.00	50.00	12.00	f
11430	3786	\N	AMARONE	1.00	50.00	21.00	f
11441	3789	\N	VIOLETTE	2.00	8.00	21.00	f
11442	3789	\N	BLUSH	1.00	20.00	21.00	f
11443	3789	\N	PECKET FRAISE	1.00	8.00	21.00	f
11444	3789	\N	FORFAIT	4.00	50.00	12.00	f
11445	3789	\N	COCA ZERO	4.00	2.20	21.00	f
11454	3792	\N	NERO D'AVOLA	1.00	30.00	21.00	f
11463	3795	\N	Service Elise	-1.00	-75.00	0.00	t
11466	3798	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	f
11467	3798	\N	VIN DU MOIS	1.00	15.00	21.00	f
11468	3798	\N	JUPILER	1.00	2.50	21.00	f
11469	3798	\N	PÂTES PESTO + BURRATA	1.00	18.00	12.00	f
11470	3798	\N	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	f
11471	3798	\N	ASSORTIMENT CROQUETTES	1.00	20.00	12.00	f
11490	3801	\N	CARBURANT	-1.00	-122.87	0.00	t
11493	3804	\N	ORANGE	-1.00	-28.00	0.00	t
11496	3807	\N	CARBURANT	-1.00	-376.50	0.00	t
11511	3810	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
11512	3810	\N	ROUGE VERRE	2.00	5.00	21.00	t
11513	3810	\N	COUSCOUS PM	1.00	17.00	12.00	t
11514	3810	\N	CANNELLONI VIANDE	1.00	17.00	12.00	t
11515	3810	\N	Cuba-Li	1.00	8.00	21.00	t
11516	3810	\N	PROSECCO VERRE	1.00	6.00	21.00	t
11523	3813	\N	Service CHA	-1.00	-30.00	0.00	t
11530	3819	\N	BLANC VERRE	1.00	5.00	21.00	t
11531	3819	\N	PÂTES COURGETTE + SCAMPIS+BURRATA	1.00	22.00	12.00	t
11532	3819	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	t
11533	3819	\N	AMARONE	1.00	50.00	21.00	t
11534	3819	\N	VIANDE + GRATIN	1.00	24.00	12.00	t
11535	3819	\N	PÂTES BOMBE ATOMIQUE + BURRATA	1.00	17.00	12.00	t
11536	3819	\N	CREPE GORGONZOLA COURGETTES XXL	1.00	19.00	12.00	t
11537	3819	\N	CHAKTCHOUKA	3.00	12.00	12.00	t
11538	3819	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	t
11552	3822	\N	NERO D'AVOLA	1.00	30.00	21.00	t
11553	3822	\N	SABAYON	1.00	8.00	12.00	t
11554	3822	\N	VIANDE + GRATIN	1.00	24.00	12.00	t
11555	3822	\N	PÂTES BOMBE ATOMIQUE + BURRATA	2.00	17.00	12.00	t
11556	3822	\N	Cuba-Li	1.00	8.00	21.00	t
11557	3822	\N	BEIGNETS DE COURGETTE	1.00	18.00	12.00	t
11558	3822	\N	SCAMPIS LUCIFER	1.00	12.00	12.00	t
11559	3822	\N	RICARD	1.00	5.00	21.00	t
11581	3840	\N	JUPILER	1.00	2.50	21.00	t
11591	3843	\N	VAL DIEU	1.00	4.00	21.00	t
11592	3843	\N	PECKET FRAISE	1.00	8.00	21.00	t
11593	3843	\N	SMASH	1.00	4.50	21.00	t
11594	3843	\N	SOFT (Verre)	3.00	2.20	21.00	t
11575	3834	\N	COMPTABLE	-1.00	190.58	0.00	t
11526	3816	\N	NOURRITURE	-1.00	57.09	0.00	t
11578	3837	\N	ORANGE	-1.00	40.03	0.00	t
11572	3831	\N	TVA	-1.00	329.53	0.00	t
11383	3776	\N	BLANC VERRE	1.00	5.00	21.00	f
11384	3776	\N	PINOT GRIGIO	1.00	20.00	21.00	f
11385	3776	\N	COUSCOUS PM	2.00	17.00	12.00	f
11386	3776	\N	PECKET FRAISE	1.00	8.00	21.00	f
11387	3776	\N	Cuba-Li	3.00	8.00	21.00	f
11388	3776	\N	LIMONCELLO	2.00	6.00	21.00	f
11389	3776	\N	PÂTES TRUFFE	1.00	14.00	12.00	f
11390	3776	\N	VIOLETTE	2.00	8.00	21.00	f
11391	3776	\N	FANTA	2.00	2.20	21.00	f
11400	3779	\N	Service ANTON	-1.00	-105.00	0.00	t
11421	3782	\N	Service ANTON	-1.00	-60.00	0.00	t
11424	3785	\N	CAPUCCINO	1.00	2.80	21.00	t
11425	3785	\N	CAFÉ	1.00	2.50	21.00	t
11426	3785	\N	ESPRESSO	1.00	2.50	21.00	t
11435	3788	\N	FORFAIT	4.00	50.00	12.00	t
11436	3788	\N	THÉ MENTHE	3.00	2.50	21.00	t
11437	3788	\N	CAFÉ	1.00	2.50	21.00	t
11438	3788	\N	MANDURIA	1.00	30.00	21.00	t
11439	3788	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	t
11440	3788	\N	PINOT GRIGIO	1.00	20.00	21.00	t
11452	3791	\N	COCA ZERO	2.00	2.20	21.00	t
11453	3791	\N	JUPILER	1.00	2.50	21.00	t
11462	3794	\N	Service CHA	-1.00	-50.00	0.00	t
11465	3797	\N	NOURRITURE	-1.00	-45.00	0.00	t
11489	3800	\N	PROXIMUS	-1.00	-129.00	0.00	t
11492	3803	\N	MAKE A WISH	-1.00	-36.35	0.00	t
11495	3806	\N	CARBURANT	-1.00	-78.73	0.00	t
11501	3809	\N	GLACE	1.00	5.00	12.00	t
11502	3809	\N	VAL DIEU	4.00	4.00	21.00	t
11503	3809	\N	COCA	3.00	2.20	21.00	t
11504	3809	\N	PECKET FRAISE	4.00	8.00	21.00	t
11505	3809	\N	POLPETTE	1.00	16.00	12.00	t
11506	3809	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
11507	3809	\N	PÂTES CREME LARDONS	1.00	14.00	12.00	t
11508	3809	\N	PÂTES TRUFFE + BURRATA	2.00	18.00	12.00	t
11509	3809	\N	SPARE RIBS	1.00	18.00	12.00	t
11510	3809	\N	ASSORTIMENT CROQUETTES	2.00	20.00	12.00	t
11522	3812	\N	Service Elise	-1.00	-60.00	0.00	t
11525	3815	\N	CUISINE MARIE	-1.00	-500.00	0.00	t
11529	3818	\N	VAL DIEU	1.00	4.00	21.00	t
11543	3821	\N	IRISH COFFEE	2.00	8.00	21.00	t
11544	3821	\N	PROSECCO VERRE	3.00	6.00	21.00	t
11545	3821	\N	COUSCOUS PM	5.00	17.00	12.00	t
11546	3821	\N	COUSCOUS VG	1.00	12.00	12.00	t
11547	3821	\N	COCA	1.00	2.20	21.00	t
11548	3821	\N	GLACE	1.00	5.00	12.00	t
11549	3821	\N	TIRAMISU GLACÉ	1.00	6.00	12.00	t
11550	3821	\N	VIOLETTE	2.00	8.00	21.00	t
11551	3821	\N	CREME BRULEE	1.00	6.00	12.00	t
11609	3848	\N	ROSÉ VERRE	1.00	5.00	21.00	t
11610	3848	\N	CORNET BOLO	1.00	6.00	6.00	t
11618	3854	\N	PÂTES TRUFFE	1.00	14.00	12.00	t
11619	3854	\N	PÂTES TRUFFE + BURRATA	2.00	18.00	12.00	t
11620	3854	\N	FANTA	1.00	2.20	21.00	t
11621	3854	\N	PECKET FRAISE	1.00	8.00	21.00	t
11622	3854	\N	VIOLETTE	1.00	8.00	21.00	t
11623	3854	\N	SCAMPIS LUCIFER	1.00	12.00	12.00	t
11624	3854	\N	ASSORTIMENT CROQUETTES	1.00	20.00	12.00	t
11654	3863	\N	JUPILER	3.00	2.50	21.00	t
11712	3881	\N	Cuba-Li	2.00	8.00	21.00	t
11713	3881	\N	COCA ZERO	1.00	2.20	21.00	t
11714	3881	\N	ICE TEA	1.00	2.20	21.00	t
11715	3881	\N	JUPILER	10.00	2.50	21.00	t
11728	3887	\N	ROSÉ MAISON	6.00	5.00	21.00	t
11729	3887	\N	JUPILER	7.00	2.50	21.00	t
11736	3890	\N	ROSÉ VERRE	1.00	5.00	21.00	t
11737	3890	\N	FANTA	1.00	2.20	21.00	t
11738	3890	\N	JUPILER	6.00	2.50	21.00	t
11561	3824	\N	ROSÉ MAISON	2.00	3.50	21.00	t
11644	3857	\N	BLUSH	1.00	20.00	21.00	t
11645	3857	\N	JUPILER	1.00	2.50	21.00	t
11681	3875	\N	CREME BRULEE	2.00	6.00	6.00	t
11615	3851	\N	CROQUETTES	-1.00	91.80	0.00	t
11671	3866	\N	SALADE PERLES MARINES	1.00	18.00	6.00	t
11672	3866	\N	PÂTES CREME LARDONS	1.00	14.00	6.00	t
11678	3872	\N	FRAIS	-1.00	114.95	0.00	f
11704	3878	\N	SPRITZ 0%	1.00	8.00	21.00	t
11700	3878	\N	PÂTES COURGETTE	1.00	16.00	12.00	t
11702	3878	\N	POLPETTE	1.00	16.00	12.00	t
11701	3878	\N	PÂTES TRUFFE	1.00	14.00	12.00	t
11703	3878	\N	PROSECCO VERRE	1.00	6.00	21.00	t
11705	3878	\N	VIOLETTE	1.00	8.00	21.00	t
11648	3860	\N	NOURRITURE	-1.00	28.49	0.00	t
11727	3887	\N	COCA	1.00	2.20	21.00	t
11564	3827	\N	NOURRITURE	-1.00	6.40	0.00	t
11606	3845	\N	Service CHA	-1.00	20.00	0.00	t
11590	3842	\N	FANTA	1.00	2.20	21.00	t
11586	3842	\N	ESPRESSO	2.00	2.50	21.00	t
11588	3842	\N	PÂTES TRUFFE + BURRATA	1.00	18.00	12.00	t
11589	3842	\N	BLANC VERRE	2.00	5.00	21.00	t
11587	3842	\N	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	t
11675	3869	\N	NOURRITURE	-1.00	7.50	0.00	f
11747	3893	\N	NOURRITURE	-1.00	28.65	0.00	t
11574	3833	\N	ORANGE	-1.00	28.00	0.00	t
11643	3857	\N	CUISSES DE GRENOUILLES AÏL	2.00	12.00	12.00	t
11577	3836	\N	CARBURANT	-1.00	135.70	0.00	t
11571	3830	\N	LOYER	-1.00	600.00	0.00	t
11699	3878	\N	CREME BRULEE	3.00	6.00	12.00	t
11475	3799	\N	FORFAIT	1.00	10.00	12.00	f
11476	3799	\N	BLUSH	2.00	20.00	21.00	f
11477	3799	\N	SPRITZ 0%	1.00	8.00	21.00	f
11478	3799	\N	PROSECCO VERRE	1.00	6.00	21.00	f
11479	3799	\N	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	f
11480	3799	\N	PÂTES BOMBE ATOMIQUE + BURRATA	1.00	17.00	12.00	f
11481	3799	\N	COUSCOUS PM	2.00	17.00	12.00	f
11482	3799	\N	PÂTES CREME LARDONS	1.00	14.00	12.00	f
11483	3799	\N	CHAKTCHOUKA	2.00	12.00	12.00	f
11484	3799	\N	SCAMPIS LUCIFER	2.00	12.00	12.00	f
11485	3799	\N	JUPILER	2.00	2.50	21.00	f
11486	3799	\N	COCA	1.00	2.20	21.00	f
11487	3799	\N	VIOLETTE	1.00	8.00	21.00	f
11488	3799	\N	PECKET FRAISE	1.00	8.00	21.00	f
11491	3802	\N	BAC SANTOS	-1.00	-125.62	0.00	t
11494	3805	\N	ENERGIES	-1.00	-55.81	0.00	t
11497	3808	\N	PÂTES	10.00	5.00	6.00	t
11498	3808	\N	4 FROMAGES	16.00	5.00	6.00	t
11499	3808	\N	CORNET LARD	16.00	5.00	6.00	t
11500	3808	\N	CORNET BOLO	15.00	5.00	6.00	t
11517	3811	\N	GLACE	1.00	5.00	12.00	t
11518	3811	\N	COUSCOUS PM	1.00	17.00	12.00	t
11519	3811	\N	CRÊPE CREME LARD	1.00	14.00	12.00	t
11520	3811	\N	ROSÉ VERRE	3.00	5.00	21.00	t
11521	3811	\N	ICE TEA	1.00	2.20	21.00	t
11524	3814	\N	Service Elise	-1.00	-60.00	0.00	t
11527	3817	\N	BIERLAINOISE	1.00	0.00	21.00	t
11528	3817	\N	JUPILER	2.00	2.50	21.00	t
11539	3820	\N	PÂTES CREME LARDONS	1.00	14.00	12.00	t
11540	3820	\N	COUSCOUS VG	1.00	12.00	12.00	t
11541	3820	\N	PROSECCO VERRE	2.00	6.00	21.00	t
11542	3820	\N	CREME BRULEE	1.00	6.00	12.00	t
11566	3829	\N	TIRAMISU GLACÉ	2.00	6.00	12.00	t
11567	3829	\N	PÂTES BOMBE ATOMIQUE + BURRATA	1.00	17.00	12.00	t
11568	3829	\N	BEIGNETS DE COURGETTE	1.00	18.00	12.00	t
11569	3829	\N	VIOLETTE	1.00	8.00	21.00	t
11570	3829	\N	Cuba-Li	1.00	8.00	21.00	t
11647	3859	\N	COUSCOUS PM	2.00	17.00	12.00	t
11680	3874	\N	CORNET TRUFFE	1.00	7.00	6.00	t
11683	3877	\N	PÂTES STRACIATELLA SCAMPIS	3.00	20.00	12.00	t
11684	3877	\N	COUSCOUS PM	2.00	17.00	12.00	t
11685	3877	\N	TAJINE	2.00	17.00	12.00	t
11686	3877	\N	POLPETTE	1.00	16.00	12.00	t
11687	3877	\N	SCAMPIS LUCIFER	1.00	12.00	12.00	t
11688	3877	\N	Cuba-Li	2.00	8.00	21.00	t
11689	3877	\N	FANTA	1.00	2.20	21.00	t
11690	3877	\N	COCA ZERO	2.00	2.20	21.00	t
11691	3877	\N	COCA	4.00	2.20	21.00	t
11692	3877	\N	JUPILER	14.00	2.50	21.00	t
11693	3877	\N	VIOLETTE	1.00	8.00	21.00	t
11694	3877	\N	CHAMPIGNONS KABYLES	1.00	10.00	12.00	t
11695	3877	\N	CHAKTCHOUKA	1.00	12.00	12.00	t
11696	3877	\N	CUISSES DE GRENOUILLES AÏL	2.00	12.00	12.00	t
11697	3877	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
11698	3877	\N	ASSORTIMENT CROQUETTES	3.00	20.00	12.00	t
11719	3883	\N	VAL DIEU	1.00	4.00	21.00	t
11720	3883	\N	JUPILER	1.00	2.50	21.00	t
11732	3889	\N	Cuba-Li	2.00	8.00	21.00	t
11733	3889	\N	COCA ZERO	1.00	2.20	21.00	t
11734	3889	\N	ICE TEA	1.00	2.20	21.00	t
11735	3889	\N	JUPILER	10.00	2.50	21.00	t
11742	3892	\N	4 FROMAGES	1.00	6.50	6.00	t
11743	3892	\N	MENU DES FÊTES	1.00	14.50	21.00	t
11744	3892	\N	FORFAIT	1.00	20.00	12.00	t
11745	3892	\N	PLAT SPÉCIAL	1.00	11.50	6.00	t
11746	3892	\N	DIVERS	1.00	50.00	6.00	t
11711	3880	\N	Service Léa	-1.00	60.00	0.00	t
11608	3847	\N	Service ANTON	-1.00	45.00	0.00	t
11662	3865	\N	BLANC VERRE	1.00	5.00	21.00	t
11741	3892	\N	CORNET LARD	1.00	60.00	6.00	t
11663	3865	\N	ROUGE VERRE	3.00	5.00	21.00	t
11661	3865	\N	IRISH COFFEE	1.00	8.00	21.00	t
11665	3865	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	t
11668	3865	\N	ASSORTIMENT CROQUETTES	1.00	20.00	12.00	t
11670	3865	\N	PROSECCO Bouteille	1.00	25.00	21.00	t
11666	3865	\N	PINOT GRIGIO	1.00	20.00	21.00	t
11563	3826	\N	NOURRITURE	-1.00	15.00	0.00	t
11601	3844	\N	POLPETTE	1.00	16.00	12.00	t
11605	3844	\N	ICE TEA	1.00	2.20	21.00	t
11664	3865	\N	PÂTES STRACIATELLA SCAMPIS	3.00	20.00	12.00	t
11660	3865	\N	GLACE	1.00	5.00	12.00	t
11659	3865	\N	LIMONCELLO	5.00	6.00	21.00	t
11669	3865	\N	BEIGNETS DE COURGETTE	1.00	18.00	12.00	t
11603	3844	\N	COCA ZERO	1.00	2.20	21.00	t
11583	3841	\N	ROUGE VERRE	1.00	6.00	21.00	t
11632	3856	\N	SABAYON SPECIAL	1.00	10.00	12.00	t
11642	3856	\N	VIN DU MOIS	1.00	15.00	21.00	t
11600	3844	\N	PÂTES BOLO	1.00	14.00	12.00	t
11604	3844	\N	FANTA	1.00	2.20	21.00	t
11602	3844	\N	PÂTES CREME LARDONS	1.00	14.00	12.00	t
11637	3856	\N	VIANDE + GRATIN	2.00	24.00	12.00	t
11582	3841	\N	SPRITZ 0%	1.00	8.00	21.00	t
11585	3841	\N	PÂTES TRUFFE	1.00	14.00	12.00	t
11584	3841	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
11634	3856	\N	COCA ZERO	1.00	2.20	21.00	t
11640	3856	\N	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	t
11639	3856	\N	PECKET FRAISE	2.00	8.00	21.00	t
11635	3856	\N	PÂTES ASPERGES	1.00	18.00	12.00	t
11633	3856	\N	CREME BRULEE	1.00	6.00	12.00	t
11617	3853	\N	POULET	-1.00	87.50	0.00	t
11674	3868	\N	NOURRITURE	-1.00	48.17	0.00	f
11614	3850	\N	ROSÉ MAISON	3.00	3.50	21.00	t
11653	3862	\N	Service EVE	-1.00	50.00	0.00	t
11631	3856	\N	ROSÉ VERRE	1.00	5.00	21.00	t
11636	3856	\N	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	t
11677	3871	\N	ENERGIES	-1.00	301.69	0.00	t
11726	3886	\N	Service Cha	-1.00	40.02	0.00	t
11576	3835	\N	COMPTABLE	-1.00	272.25	0.00	t
11560	3823	\N	Service ANTON	-1.00	75.00	0.00	t
11573	3832	\N	ENERGIES	-1.00	301.69	0.00	t
11595	3843	\N	PÂTES BOMBE ATOMIQUE + BURRATA	1.00	17.00	12.00	t
11596	3843	\N	PÂTES SCAMPIS	1.00	17.00	12.00	t
11597	3843	\N	PÂTES BOLO	1.00	14.00	12.00	t
11598	3843	\N	PÂTES CREME LARDONS	1.00	14.00	12.00	t
11599	3843	\N	POLPETTE	1.00	16.00	12.00	t
11625	3855	\N	SMASH	4.00	4.50	21.00	t
11626	3855	\N	JUPILER	1.00	2.50	21.00	t
11627	3855	\N	PÂTES TRUFFE + BURRATA	1.00	18.00	12.00	t
11628	3855	\N	COUSCOUS PM	1.00	17.00	12.00	t
11629	3855	\N	PÂTES PESTO + BURRATA	1.00	18.00	12.00	t
11630	3855	\N	CANNELLONI RICO/EPI	2.00	17.00	12.00	t
11649	3861	\N	VIANDE + GRATIN	1.00	24.00	12.00	t
11650	3861	\N	SALADE PERLES MARINES	1.00	18.00	12.00	t
11651	3861	\N	ROUGE VERRE	1.00	5.00	21.00	t
11652	3861	\N	BLANC VERRE	1.00	5.00	21.00	t
11655	3864	\N	COCA ZERO	1.00	2.20	21.00	t
11656	3864	\N	BLANC VERRE	1.00	5.00	21.00	t
11657	3864	\N	TAJINE	1.00	17.00	12.00	t
11658	3864	\N	COUSCOUS PM	1.00	17.00	12.00	t
11706	3879	\N	POLPETTE	1.00	16.00	12.00	t
11707	3879	\N	TAJINE	1.00	17.00	12.00	t
11708	3879	\N	COUSCOUS PM	1.00	17.00	12.00	t
11709	3879	\N	PINOT GRIGIO	1.00	20.00	21.00	t
11710	3879	\N	ROUGE VERRE	1.00	5.00	21.00	t
11716	3882	\N	ROSÉ VERRE	1.00	5.00	21.00	t
11717	3882	\N	FANTA	1.00	2.20	21.00	t
11718	3882	\N	JUPILER	5.00	2.50	21.00	t
11724	3885	\N	JUPILER	6.00	2.50	21.00	t
11725	3885	\N	ROSÉ MAISON	2.00	3.50	21.00	t
11730	3888	\N	JUPILER	6.00	2.50	21.00	t
11731	3888	\N	ROSÉ MAISON	5.00	5.00	21.00	t
11739	3891	\N	JUPILER	4.00	2.50	21.00	t
11740	3891	\N	VAL DIEU	2.00	4.00	21.00	t
11607	3846	\N	Service INES	-1.00	20.00	0.00	t
11562	3825	\N	CREME BRULEE	2.00	5.00	6.00	f
10782	3615	\N	VIN DU MOIS	2.00	15.00	21.00	f
10824	3626	\N	THÉ MENTHE	1.00	2.50	21.00	f
10828	3626	\N	ASSORTIMENT CROQUETTES	1.00	20.00	12.00	f
10833	3629	\N	DIVERS	1.00	4.00	12.00	f
10835	3629	\N	COUSCOUS PM	1.00	17.00	12.00	f
10836	3629	\N	CANNELLONI VIANDE	1.00	17.00	12.00	f
10838	3629	\N	THÉ MENTHE	7.00	2.50	21.00	f
10841	3629	\N	PÂTES COURGETTE	2.00	14.00	12.00	f
10840	3629	\N	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	f
10837	3629	\N	GRAPPA	1.00	6.00	21.00	f
10839	3629	\N	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	f
10843	3629	\N	Cuba-Li	3.00	8.00	21.00	f
10845	3629	\N	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
10856	3633	\N	AMARONE	1.00	50.00	21.00	t
10857	3633	\N	SALADE PERLES MARINES	1.00	18.00	12.00	t
10859	3633	\N	SCAMPIS LUCIFER	1.00	12.00	12.00	t
11749	3895	472	ORANGE	-1.00	50.48	0.00	f
11750	3896	327	CARBURANT	-1.00	119.80	0.00	f
11751	3897	472	ORANGE	-1.00	28.00	0.00	f
11752	3898	327	CARBURANT	-1.00	50.24	0.00	f
11753	3899	566	BMW X3	-1.00	114.95	0.00	f
11754	3900	536	Service Léa	-1.00	75.00	0.00	f
11679	3873	\N	STNI	-1.00	102.19	0.00	f
11748	3894	\N	NOURRITURE	-1.00	84.03	0.00	t
11682	3876	\N	Nettoyage	-1.00	120.00	0.00	f
11800	3908	85	GLACE	1.00	5.00	12.00	t
11793	3908	227	COCA	6.00	2.20	21.00	t
11795	3908	316	SALADE PERLES MARINES	1.00	18.00	12.00	t
11798	3908	100	BLANC VERRE	3.00	5.00	21.00	t
11796	3908	291	VIANDE + GRATIN	1.00	24.00	12.00	t
11790	3908	300	ASSORTIMENT CROQUETTES	1.00	20.00	12.00	t
11797	3908	79	TAJINE	1.00	17.00	12.00	t
11794	3908	74	PECKET FRAISE	1.00	8.00	21.00	t
11799	3908	101	ROUGE VERRE	1.00	5.00	21.00	t
11763	3903	192	COCA ZERO	2.00	2.20	21.00	t
11770	3903	253	BLANC 1/4	1.00	8.00	21.00	t
11767	3903	144	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	t
11765	3903	4	PROSECCO VERRE	1.00	6.00	21.00	t
11766	3903	154	PÂTES BOLO	2.00	14.00	12.00	t
11769	3903	148	BLANC 1/2	1.00	13.00	21.00	t
11768	3903	81	COUSCOUS PM	1.00	17.00	12.00	t
11764	3903	100	BLANC VERRE	1.00	5.00	21.00	t
11782	3907	4	PROSECCO VERRE	1.00	6.00	21.00	t
11783	3907	111	JUPILER	1.00	2.50	21.00	t
11784	3907	9	VIOLETTE	1.00	8.00	21.00	t
11785	3907	81	COUSCOUS PM	2.00	17.00	12.00	t
11786	3907	183	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	t
11787	3907	100	BLANC VERRE	1.00	5.00	21.00	t
11762	3902	252	ROUGE 1/4	3.00	8.00	21.00	t
11761	3902	79	TAJINE	1.00	17.00	12.00	t
11779	3906	107	CHAKTCHOUKA	1.00	12.00	12.00	t
11777	3906	227	COCA	1.00	2.20	21.00	t
11778	3906	100	BLANC VERRE	1.00	5.00	21.00	t
11780	3906	79	TAJINE	1.00	17.00	12.00	t
11781	3906	316	SALADE PERLES MARINES	1.00	18.00	12.00	t
11755	3901	76	BLONDINETTE	2.00	4.00	21.00	t
11757	3901	100	BLANC VERRE	1.00	5.00	21.00	t
11756	3901	4	PROSECCO VERRE	1.00	6.00	21.00	t
11759	3901	316	SALADE PERLES MARINES	1.00	18.00	12.00	t
11758	3901	42	CAPUCCINO	1.00	2.80	21.00	t
11760	3901	183	PÂTES COURGETTE + SCAMPIS	1.00	18.00	12.00	t
11771	3904	299	ROSÉ MAISON	2.00	3.50	21.00	t
11772	3904	312	SMASH	1.00	4.50	21.00	t
11773	3904	111	JUPILER	4.00	2.50	21.00	t
11774	3905	100	BLANC VERRE	2.00	5.00	21.00	t
11776	3905	312	SMASH	1.00	4.50	21.00	t
11565	3828	\N	NOURRITURE	-1.00	92.51	0.00	t
11616	3852	\N	NOURRITURE	-1.00	77.61	0.00	t
11646	3858	\N	Service ANTON	-1.00	75.00	0.00	t
11613	3849	\N	ARROSTICINNI (5)	2.00	8.00	12.00	t
11612	3849	\N	ROSÉ MAISON	4.00	3.50	21.00	t
11673	3867	\N	NOURRITURE	-1.00	27.98	0.00	f
11611	3849	\N	JUPILER	1.00	2.50	21.00	t
11676	3870	\N	LOYER	-1.00	600.00	0.00	t
11788	3908	36	PINOT GRIGIO	1.00	20.00	21.00	t
11791	3908	73	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	t
11789	3908	232	CRÊPE CHAKCHOUKA	1.00	14.00	12.00	t
11804	3908	318	CUISSES DE GRENOUILLES AÏL	1.00	13.00	12.00	t
11802	3908	42	CAPUCCINO	1.00	2.80	21.00	t
11801	3908	65	TIRAMISU GLACÉ	2.00	6.00	12.00	t
11792	3908	9	VIOLETTE	2.00	8.00	21.00	t
11803	3908	4	PROSECCO VERRE	1.00	6.00	21.00	t
11809	3913	567	Work Today	-1.00	104.47	0.00	f
11775	3905	299	ROSÉ MAISON	1.00	3.50	21.00	t
11845	3924	570	Adibox	-1.00	160.33	0.00	t
11821	3916	194	ICE TEA	1.00	2.20	21.00	t
11822	3916	227	COCA	1.00	2.20	21.00	t
11823	3916	146	ROSÉ VERRE	1.00	5.00	21.00	t
11824	3916	107	CHAKTCHOUKA	1.00	16.00	12.00	t
11825	3916	228	PÂTES CREME LARDONS	1.00	14.00	12.00	t
11826	3916	82	POLPETTE	1.00	16.00	12.00	t
11849	3928	369	LOYER	-1.00	600.00	0.00	f
11832	3917	104	PÂTES	2.00	12.00	12.00	t
11831	3917	83	PÂTES SCAMPIS	1.00	17.00	12.00	t
11828	3917	193	FANTA	1.00	2.20	21.00	t
11829	3917	10	SOFT (Verre)	2.00	2.20	21.00	t
11827	3917	227	COCA	1.00	2.20	21.00	t
11830	3917	185	PÂTES PESTO + BURRATA	1.00	18.00	12.00	t
11810	3914	36	PINOT GRIGIO	1.00	20.00	21.00	t
11811	3914	182	BLUSH	2.00	20.00	21.00	t
11812	3914	99	EAU PET 1/2 L	1.00	3.50	21.00	t
11815	3914	316	SALADE PERLES MARINES	3.00	18.00	12.00	t
11813	3914	67	EAU PÉTILLANTE 1 L	1.00	5.00	21.00	t
11814	3914	153	ORVAL	1.00	5.00	21.00	t
11816	3914	41	CAFÉ	1.00	2.50	21.00	t
11817	3914	39	ESPRESSO	2.00	2.50	21.00	t
11667	3865	\N	PROSECCO VERRE	1.00	6.00	21.00	t
11834	3918	44	THÉ MENTHE	1.00	2.50	21.00	t
11833	3918	194	ICE TEA	2.00	2.20	21.00	t
11838	3918	81	COUSCOUS PM	1.00	17.00	12.00	t
11835	3918	41	CAFÉ	1.00	2.50	21.00	t
11836	3918	65	TIRAMISU GLACÉ	1.00	6.00	12.00	t
11837	3918	315	L'OR D'AURORE	1.00	8.00	21.00	t
11839	3918	79	TAJINE	1.00	17.00	12.00	t
11819	3915	81	COUSCOUS PM	1.00	17.00	12.00	t
11818	3915	194	ICE TEA	2.00	2.20	21.00	t
11820	3915	79	TAJINE	1.00	17.00	12.00	t
11641	3856	\N	ROUGE VERRE	1.00	5.00	21.00	t
11638	3856	\N	SALADE PERLES MARINES	1.00	18.00	12.00	t
11840	3919	349	NOSTRA LIEGE	1.00	137.94	0.00	f
11850	3929	330	COLRUYT	-1.00	198.18	0.00	f
11844	3923	569	Afsca	-1.00	217.90	0.00	f
11843	3922	568	Yooza	-1.00	181.50	0.00	f
11842	3921	345	MAISON ITALIENNE	-1.00	68.49	0.00	f
11841	3920	327	CARBURANT	-1.00	100.07	0.00	f
11852	3931	527	Service Elise	-1.00	30.00	0.00	f
11851	3930	527	Service Elise	-1.00	40.00	0.00	f
11853	3932	9	VIOLETTE	1.00	8.00	21.00	f
11854	3932	316	SALADE PERLES MARINES	1.00	18.00	12.00	f
11855	3932	144	PÂTES STRACIATELLA SCAMPIS	1.00	20.00	12.00	f
11856	3933	73	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
11857	3933	82	POLPETTE	1.00	16.00	12.00	f
11858	3933	84	PÂTES TRUFFE	1.00	14.00	12.00	f
11859	3933	259	MANDURIA	1.00	30.00	21.00	f
11860	3933	42	CAPUCCINO	1.00	2.80	21.00	f
11861	3934	75	Cuba-Li	2.00	8.00	21.00	f
11862	3934	73	ASSIETTE APERITIVE (2 p.)	1.00	19.00	12.00	f
11863	3934	246	CRÊPE CREME LARD XXL	1.00	17.00	12.00	f
11864	3934	79	TAJINE	1.00	17.00	12.00	f
11847	3926	346	MERGUEZ	-1.00	34.00	0.00	f
11848	3927	333	DELHAIZE	-1.00	7.98	0.00	f
\.


--
-- Data for Name: encaissements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.encaissements (id, table_nom, client_id, montant_carte, montant_cash, montant_total, nb_personnes, emporte, depenses, serveur, date_encaissement, remarque, cash_analyse, nom_reservation_archive) FROM stdin;
1	\N	\N	0.00	7.00	7.00	1	t	f	\N	2023-03-21 12:00:00	\N	0.00	Emporté
2	\N	\N	8.00	0.00	8.00	1	t	f	\N	2023-04-15 12:00:00	\N	0.00	Emporté
3	\N	\N	15.00	0.00	15.00	1	t	f	\N	2023-04-15 12:00:00	\N	0.00	Emporté
4	\N	\N	15.00	0.00	15.00	1	t	f	\N	2023-04-15 12:00:00	\N	0.00	Emporté
5	\N	\N	0.00	13.50	13.50	1	t	f	\N	2023-05-04 12:00:00	\N	13.50	Emporté
6	\N	\N	0.00	13.50	13.50	1	t	f	\N	2023-05-05 12:00:00	\N	13.50	Emporté
7	T14	\N	0.00	18.00	18.00	1	f	f	\N	2023-05-05 12:00:00	\N	0.00	T14
14	\N	\N	0.00	12.00	12.00	1	t	f	\N	2023-05-10 12:00:00	\N	12.00	Emporté
15	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-05-12 12:00:00	\N	6.00	Emporté
16	\N	\N	0.00	13.50	13.50	1	t	f	\N	2023-05-12 12:00:00	\N	13.50	Emporté
18	\N	\N	0.00	50.40	50.40	4	t	f	\N	2023-05-13 12:00:00	\N	50.40	Emporté
19	\N	\N	0.00	27.00	27.00	2	t	f	\N	2023-05-13 12:00:00	\N	27.00	Emporté
20	\N	\N	0.00	12.00	12.00	2	t	f	\N	2023-05-13 12:00:00	\N	12.00	Emporté
21	T7	\N	68.00	0.00	68.00	2	f	f	\N	2023-05-13 12:00:00	\N	68.00	chien
23	T11	\N	70.00	0.00	70.00	2	f	f	\N	2023-05-13 12:00:00	\N	70.00	buyens
24	\N	\N	19.00	0.00	19.00	3	t	f	\N	2023-05-17 12:00:00	\N	19.00	Emporté
25	\N	\N	18.00	0.00	18.00	3	t	f	\N	2023-05-17 12:00:00	\N	18.00	Emporté
26	\N	\N	0.00	7.00	7.00	1	t	f	\N	2023-05-18 12:00:00	\N	7.00	Emporté
27	\N	\N	0.00	13.50	13.50	1	t	f	\N	2023-05-18 12:00:00	\N	13.50	Emporté
28	\N	\N	0.00	8.00	8.00	1	t	f	\N	2023-05-19 12:00:00	\N	6.00	Emporté
29	\N	\N	13.50	0.00	13.50	1	t	f	\N	2023-05-19 12:00:00	\N	13.50	Emporté
30	T11	\N	67.00	0.00	67.00	2	f	f	\N	2023-05-19 12:00:00	\N	67.00	Ben molitor
31	T7	\N	0.00	132.50	132.50	5	f	f	\N	2023-05-19 12:00:00	\N	83.00	Farid
35	\N	\N	-163.84	-180.00	-343.84	1	f	t	\N	2023-05-03 12:00:00	\N	0.00	\N
36	\N	\N	-364.24	0.00	-364.24	1	t	t	\N	2023-05-04 12:00:00	\N	0.00	\N
37	\N	\N	-120.79	0.00	-120.79	1	f	t	\N	2023-05-05 12:00:00	\N	0.00	\N
38	\N	\N	-99.00	-50.00	-149.00	1	f	t	\N	2023-05-05 12:00:00	\N	0.00	\N
39	\N	\N	-41.58	-53.50	-95.08	1	f	t	\N	2023-05-06 12:00:00	\N	0.00	\N
40	\N	\N	-93.74	-60.00	-153.74	1	f	t	\N	2023-05-12 12:00:00	\N	0.00	\N
41	\N	\N	0.00	-50.00	-50.00	1	t	t	\N	2023-05-13 12:00:00	\N	0.00	\N
42	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-05-19 12:00:00	\N	0.00	\N
43	\N	\N	-11.74	0.00	-11.74	1	f	t	\N	2023-05-17 12:00:00	\N	0.00	\N
44	\N	\N	-19.12	0.00	-19.12	1	f	t	\N	2023-05-18 12:00:00	\N	0.00	\N
45	T2	\N	0.00	17.00	17.00	1	f	f	\N	2023-05-24 12:00:00	\N	0.00	T2
46	\N	\N	-1000.00	0.00	-1000.00	1	f	t	\N	2023-05-01 12:00:00	\N	0.00	\N
47	\N	\N	0.00	660.00	660.00	55	t	f	\N	2023-05-04 12:00:00	\N	0.00	Emporté
48	\N	\N	0.00	-100.00	-100.00	1	f	t	\N	2023-05-20 12:00:00	\N	0.00	\N
49	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-05-25 12:00:00	\N	6.00	Emporté
50	\N	\N	7.00	0.00	7.00	1	t	f	\N	2023-05-25 12:00:00	\N	7.00	Emporté
51	\N	\N	-84.61	0.00	-84.61	1	f	t	\N	2023-05-26 12:00:00	\N	0.00	\N
52	\N	\N	27.00	0.00	27.00	2	t	f	\N	2023-05-26 12:00:00	\N	27.00	Emporté
53	T4	\N	0.00	58.00	58.00	2	f	f	\N	2023-05-26 12:00:00	\N	31.00	T4
54	\N	\N	-50.26	-3.00	-53.26	1	f	t	\N	2023-05-26 12:00:00	\N	0.00	\N
55	\N	\N	0.00	40.50	40.50	3	t	f	\N	2023-05-26 12:00:00	\N	40.50	Emporté
56	\N	\N	0.00	27.00	27.00	2	t	f	\N	2023-05-26 12:00:00	\N	27.00	Emporté
57	T8	\N	75.50	0.00	75.50	2	f	f	\N	2023-05-26 12:00:00	\N	75.50	Christine
60	\N	\N	0.00	20.00	20.00	1	t	f	\N	2023-05-26 12:00:00	\N	20.00	Emporté
61	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-05-27 12:00:00	\N	6.00	Emporté
62	\N	\N	-59.95	0.00	-59.95	1	f	t	\N	2023-05-27 12:00:00	\N	0.00	\N
64	T14	\N	20.00	0.00	20.00	1	f	f	\N	2023-05-27 12:00:00	\N	20.00	T14
65	T4	\N	72.50	0.00	72.50	2	f	f	\N	2023-05-27 12:00:00	\N	72.50	camille
66	\N	\N	0.00	-110.00	-110.00	1	f	t	\N	2023-05-27 12:00:00	\N	0.00	\N
67	\N	\N	0.00	27.00	27.00	2	t	f	\N	2023-05-31 12:00:00	\N	27.00	Emporté
68	\N	\N	0.00	12.00	12.00	2	t	f	\N	2023-05-31 12:00:00	\N	12.00	Emporté
69	\N	\N	-32.40	0.00	-32.40	1	f	t	\N	2023-06-01 12:00:00	\N	0.00	\N
70	\N	\N	6.00	0.00	6.00	1	t	f	\N	2023-06-01 12:00:00	\N	6.00	Emporté
71	T8	\N	24.50	0.00	24.50	1	f	f	\N	2023-06-01 12:00:00	\N	24.50	T8
72	\N	\N	0.00	5.00	5.00	1	t	f	\N	2023-06-01 12:00:00	\N	5.00	Emporté
73	\N	\N	0.00	19.00	19.00	2	t	f	\N	2023-06-02 12:00:00	\N	19.00	Emporté
75	\N	\N	-23.22	0.00	-23.22	1	f	t	\N	2023-06-02 12:00:00	\N	0.00	\N
76	\N	\N	-50.23	0.00	-50.23	1	f	t	\N	2023-06-03 12:00:00	\N	0.00	\N
78	\N	\N	0.00	40.50	40.50	3	t	f	\N	2023-06-03 12:00:00	\N	0.00	Emporté
80	T7	\N	0.00	55.00	55.00	2	f	f	\N	2023-06-03 12:00:00	\N	0.00	Claude
83	\N	\N	0.00	27.00	27.00	2	t	f	\N	2023-06-03 12:00:00	\N	27.00	Emporté
84	\N	\N	-80.81	0.00	-80.81	1	f	t	\N	2023-06-07 12:00:00	\N	0.00	\N
85	\N	\N	0.00	11.50	11.50	1	t	f	\N	2023-06-07 12:00:00	\N	6.00	Emporté
86	\N	\N	0.00	8.00	8.00	1	t	f	\N	2023-06-07 12:00:00	\N	8.00	Emporté
88	\N	\N	0.00	30.50	30.50	2	t	f	\N	2023-06-08 12:00:00	\N	14.00	Emporté
94	\N	\N	0.00	19.00	19.00	3	t	f	\N	2023-06-09 12:00:00	\N	19.00	Emporté
130	\N	\N	0.00	13.50	13.50	1	t	f	\N	2023-06-16 12:00:00	\N	13.50	Emporté
100	T4	\N	132.00	0.00	132.00	4	f	f	\N	2023-06-09 12:00:00	\N	132.00	nollet
103	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-06-03 12:00:00	\N	0.00	\N
106	\N	\N	0.00	12.00	12.00	2	t	f	\N	2023-06-15 12:00:00	\N	12.00	Emporté
135	\N	\N	0.00	27.00	27.00	2	t	f	\N	2023-06-17 12:00:00	\N	27.00	Emporté
112	\N	\N	0.00	32.00	32.00	4	t	f	\N	2023-06-16 12:00:00	\N	24.00	Emporté
115	T7	\N	73.00	0.00	73.00	2	f	f	\N	2023-06-10 12:00:00	\N	73.00	T7
118	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-06-16 12:00:00	\N	0.00	\N
138	\N	\N	21.00	0.00	21.00	1	t	f	\N	2023-06-13 12:00:00	\N	21.00	Emporté
121	\N	\N	0.00	13.50	13.50	1	t	f	\N	2023-06-16 12:00:00	\N	13.50	Emporté
141	T4	\N	0.00	33.50	33.50	1	f	f	\N	2023-06-23 12:00:00	\N	33.50	T4
147	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-06-28 12:00:00	\N	0.00	Emporté
148	\N	\N	0.00	-99.05	-99.05	1	f	t	\N	2023-05-22 12:00:00	\N	0.00	\N
150	\N	\N	-20.26	0.00	-20.26	1	f	t	\N	2023-05-19 12:00:00	\N	0.00	\N
153	T8	\N	0.00	77.50	77.50	2	f	f	\N	2023-06-23 12:00:00	\N	65.50	T8
154	\N	\N	0.00	7.00	7.00	1	t	f	\N	2023-06-23 12:00:00	\N	7.00	Emporté
159	T4	\N	0.00	81.00	81.00	2	f	f	\N	2023-06-30 12:00:00	\N	0.00	T4
160	\N	\N	0.00	67.50	67.50	5	t	f	\N	2023-06-30 12:00:00	\N	0.00	Emporté
163	T8	\N	78.00	0.00	78.00	2	f	f	\N	2023-07-01 12:00:00	\N	78.00	Mathot
165	T4	\N	0.00	81.00	81.00	2	f	f	\N	2023-06-30 12:00:00	\N	57.00	T4
166	\N	\N	0.00	67.50	67.50	5	t	f	\N	2023-06-30 12:00:00	\N	0.00	Emporté
168	T14	\N	57.00	0.00	57.00	2	f	f	\N	2023-06-30 12:00:00	\N	57.00	T14
169	T13	\N	21.00	0.00	21.00	1	f	f	\N	2023-06-30 12:00:00	\N	21.00	T13
171	\N	\N	0.00	40.50	40.50	3	t	f	\N	2023-07-07 12:00:00	\N	40.50	Emporté
172	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-07-07 12:00:00	\N	6.00	Emporté
174	T8	\N	16.00	0.00	16.00	1	f	f	\N	2023-07-07 12:00:00	\N	16.00	T8
175	T8	\N	49.00	0.00	49.00	2	f	f	\N	2023-07-07 12:00:00	\N	49.00	T8
178	\N	\N	0.00	19.50	19.50	2	t	f	\N	2023-07-06 12:00:00	\N	19.50	Emporté
183	T11	\N	0.00	21.00	21.00	1	f	f	\N	2023-07-06 12:00:00	\N	21.00	T11
186	T14	\N	0.00	6.00	6.00	1	f	f	\N	2023-07-07 12:00:00	\N	6.00	T14
187	\N	\N	0.00	27.00	27.00	2	t	f	\N	2023-07-07 12:00:00	\N	27.00	Emporté
189	T4	\N	73.00	0.00	73.00	2	f	f	\N	2023-07-07 12:00:00	\N	73.00	T4
190	T8	\N	132.00	46.00	178.00	4	f	f	\N	2023-07-07 12:00:00	\N	132.00	T8
193	\N	\N	0.00	18.00	18.00	2	t	f	\N	2023-06-29 12:00:00	\N	18.00	Emporté
198	\N	\N	0.00	12.00	12.00	2	t	f	\N	2023-07-13 12:00:00	\N	12.00	Emporté
199	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-07-13 12:00:00	\N	6.00	Emporté
201	\N	\N	0.00	-53.20	-53.20	1	f	t	\N	2023-07-14 12:00:00	\N	0.00	\N
202	T10	\N	0.00	41.50	41.50	1	f	f	\N	2023-07-14 12:00:00	\N	41.50	T10
204	\N	\N	0.00	-29.61	-29.61	1	f	t	\N	2023-07-14 12:00:00	\N	0.00	\N
205	\N	\N	6.00	0.00	6.00	1	t	f	\N	2023-07-14 12:00:00	\N	6.00	Emporté
207	\N	\N	0.00	-35.65	-35.65	1	f	t	\N	2023-07-18 12:00:00	\N	0.00	\N
208	T7	\N	0.00	139.00	139.00	3	f	f	\N	2023-07-18 12:00:00	\N	59.00	T7
210	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-07-18 12:00:00	\N	6.00	Emporté
211	\N	\N	0.00	2.00	2.00	1	t	f	\N	2023-07-18 12:00:00	\N	2.00	Emporté
213	\N	\N	0.00	-4.60	-4.60	1	f	t	\N	2023-07-19 12:00:00	\N	0.00	\N
214	\N	\N	0.00	-44.05	-44.05	1	f	t	\N	2023-07-19 12:00:00	\N	0.00	\N
216	\N	\N	0.00	26.00	26.00	2	t	f	\N	2023-07-20 12:00:00	\N	26.00	Emporté
217	\N	\N	-36.07	0.00	-36.07	1	f	t	\N	2023-07-15 12:00:00	\N	0.00	\N
219	\N	\N	-36.05	0.00	-36.05	1	f	t	\N	2023-07-15 12:00:00	\N	0.00	\N
220	T8	\N	118.00	0.00	118.00	4	f	f	\N	2023-07-15 12:00:00	\N	118.00	T8
222	T4	\N	0.00	87.00	87.00	4	f	f	\N	2023-07-15 12:00:00	\N	51.00	T4
223	\N	\N	0.00	20.00	20.00	2	t	f	\N	2023-07-08 12:00:00	\N	0.00	Emporté
225	\N	\N	0.00	-60.00	-60.00	1	f	t	\N	2023-07-01 12:00:00	\N	0.00	\N
226	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-07-12 12:00:00	\N	6.00	Emporté
228	T4	\N	0.00	162.00	162.00	4	f	f	\N	2023-07-15 12:00:00	\N	97.00	T4
229	T4	\N	65.00	0.00	65.00	2	f	f	\N	2023-07-19 12:00:00	\N	65.00	T4
231	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-07-19 12:00:00	\N	6.00	Emporté
232	\N	\N	0.00	13.50	13.50	1	t	f	\N	2023-07-20 12:00:00	\N	13.50	Emporté
234	\N	\N	-10.50	0.00	-10.50	1	f	t	\N	2023-07-21 12:00:00	\N	0.00	\N
235	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2023-07-02 12:00:00	\N	0.00	\N
237	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-07-14 12:00:00	\N	0.00	\N
238	\N	\N	0.00	-60.00	-60.00	1	f	t	\N	2023-07-15 12:00:00	\N	0.00	\N
240	\N	\N	0.00	-60.00	-60.00	1	f	t	\N	2023-07-22 12:00:00	\N	0.00	\N
87	\N	\N	0.00	8.00	8.00	1	t	f	\N	2023-06-08 12:00:00	\N	0.00	Emporté
253	T10	\N	0.00	27.00	27.00	2	f	f	\N	2023-07-22 12:00:00	\N	27.00	T10
89	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-06-08 12:00:00	\N	6.00	Emporté
128	T7	\N	0.00	66.00	66.00	2	f	f	\N	2023-06-16 12:00:00	\N	0.00	Baronne
90	\N	-322567125	-45.13	0.00	-45.13	1	f	t	\N	2023-06-09 12:00:00	\N	0.00	\N
131	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-06-16 12:00:00	\N	0.00	\N
98	\N	\N	0.00	27.00	27.00	2	t	f	\N	2023-06-09 12:00:00	\N	27.00	Emporté
255	T8	\N	83.00	0.00	83.00	2	f	f	\N	2023-07-22 12:00:00	\N	83.00	T8
102	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-06-02 12:00:00	\N	0.00	\N
256	T7	\N	0.00	84.50	84.50	2	f	f	\N	2023-07-22 12:00:00	\N	47.00	T7
107	\N	\N	16.00	0.00	16.00	2	t	f	\N	2023-06-15 12:00:00	\N	16.00	Emporté
108	T6	\N	0.00	39.00	39.00	2	f	f	\N	2023-06-15 12:00:00	\N	39.00	Ouvriers
110	\N	\N	6.00	0.00	6.00	1	t	f	\N	2023-06-15 12:00:00	\N	6.00	Emporté
111	T8	\N	15.00	0.00	15.00	1	f	f	\N	2023-06-15 12:00:00	\N	15.00	T8
114	\N	\N	0.00	4.50	4.50	1	t	f	\N	2023-06-10 12:00:00	\N	0.00	Emporté
140	\N	\N	6.00	0.00	6.00	1	t	f	\N	2023-06-22 12:00:00	\N	6.00	Emporté
258	\N	\N	-151.03	0.00	-151.03	1	f	t	\N	2023-07-22 12:00:00	\N	0.00	\N
120	\N	\N	-1000.00	0.00	-1000.00	1	f	t	\N	2023-06-04 12:00:00	\N	0.00	\N
143	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-06-23 12:00:00	\N	6.00	Emporté
122	\N	\N	0.00	27.00	27.00	2	t	f	\N	2023-06-16 12:00:00	\N	0.00	Emporté
123	\N	\N	0.00	27.00	27.00	2	t	f	\N	2023-06-16 12:00:00	\N	27.00	Emporté
259	\N	\N	0.00	16.00	16.00	2	t	f	\N	2023-08-09 12:00:00	\N	16.00	Emporté
125	\N	\N	-8.00	0.00	-8.00	1	f	t	\N	2023-06-16 12:00:00	\N	0.00	\N
149	\N	\N	0.00	-13.60	-13.60	1	f	t	\N	2023-05-20 12:00:00	\N	0.00	\N
261	\N	\N	-400.00	0.00	-400.00	1	f	t	\N	2023-07-26 12:00:00	\N	0.00	\N
262	\N	\N	0.00	12.00	12.00	2	t	f	\N	2023-08-09 12:00:00	\N	12.00	Emporté
158	\N	\N	19.50	0.00	19.50	1	t	f	\N	2023-06-30 12:00:00	\N	19.50	Emporté
264	T13	\N	0.00	10.00	10.00	1	f	f	\N	2023-08-09 12:00:00	\N	10.00	T13
161	T3	\N	57.00	0.00	57.00	2	f	f	\N	2023-07-01 12:00:00	\N	57.00	T3
265	\N	\N	-24.04	0.00	-24.04	1	f	t	\N	2023-08-10 12:00:00	\N	0.00	\N
167	\N	\N	0.00	92.70	92.70	8	t	f	\N	2023-06-30 12:00:00	\N	0.00	Emporté
267	\N	\N	0.00	19.00	19.00	3	t	f	\N	2023-08-10 12:00:00	\N	19.00	Emporté
170	T4	\N	20.00	40.00	60.00	2	f	f	\N	2023-07-06 12:00:00	\N	20.00	T4
268	\N	\N	0.00	40.50	40.50	3	t	f	\N	2023-08-10 12:00:00	\N	40.50	Emporté
173	\N	\N	0.00	8.00	8.00	1	t	f	\N	2023-07-07 12:00:00	\N	8.00	Emporté
176	\N	\N	0.00	12.00	12.00	2	t	f	\N	2023-07-05 12:00:00	\N	12.00	Emporté
270	T6	\N	0.00	18.00	18.00	1	f	f	\N	2023-08-10 12:00:00	\N	18.00	T6
271	T7	\N	14.00	0.00	14.00	1	f	f	\N	2023-08-10 12:00:00	\N	14.00	T7
273	\N	\N	0.00	-106.00	-106.00	1	f	t	\N	2023-08-11 12:00:00	\N	0.00	\N
188	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-07-07 12:00:00	\N	6.00	Emporté
274	\N	\N	0.00	-10.65	-10.65	1	f	t	\N	2023-08-11 12:00:00	\N	0.00	\N
276	\N	\N	0.00	-26.00	-26.00	1	f	t	\N	2023-08-11 12:00:00	\N	0.00	\N
197	\N	\N	0.00	7.00	7.00	1	t	f	\N	2023-07-13 12:00:00	\N	7.00	Emporté
277	\N	\N	0.00	-30.00	-30.00	1	f	t	\N	2023-08-11 12:00:00	\N	0.00	\N
203	T7	\N	0.00	35.00	35.00	1	f	f	\N	2023-07-14 12:00:00	\N	35.00	T7
279	\N	\N	0.00	13.50	13.50	1	t	f	\N	2023-08-11 12:00:00	\N	13.50	Emporté
206	\N	\N	0.00	18.00	18.00	3	t	f	\N	2023-07-14 12:00:00	\N	18.00	Emporté
280	\N	\N	97.70	0.00	97.70	5	t	f	\N	2023-08-11 12:00:00	\N	97.70	Emporté
209	\N	\N	0.00	13.50	13.50	1	t	f	\N	2023-07-18 12:00:00	\N	13.50	Emporté
212	T10	\N	0.00	31.00	31.00	1	f	f	\N	2023-07-14 12:00:00	\N	31.00	T10
282	T4	\N	0.00	113.00	113.00	3	f	f	\N	2023-08-11 12:00:00	\N	55.00	Marchal
215	\N	\N	-13.89	0.00	-13.89	1	f	t	\N	2023-07-18 12:00:00	\N	0.00	\N
283	T3	\N	0.00	71.00	71.00	2	f	f	\N	2023-08-11 12:00:00	\N	17.00	T3
218	\N	\N	-18.03	0.00	-18.03	1	f	t	\N	2023-07-12 12:00:00	\N	0.00	\N
221	T3	\N	0.00	73.00	73.00	1	f	f	\N	2023-07-15 12:00:00	\N	0.00	T3
285	T4	\N	0.00	69.00	69.00	2	f	f	\N	2023-08-12 12:00:00	\N	33.00	Isa et Freddy
224	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-07-08 12:00:00	\N	0.00	\N
227	\N	\N	0.00	4.00	4.00	1	t	f	\N	2023-07-15 12:00:00	\N	4.00	Emporté
230	\N	\N	0.00	21.00	21.00	3	t	f	\N	2023-07-19 12:00:00	\N	21.00	Emporté
233	\N	\N	-6.29	0.00	-6.29	1	f	t	\N	2023-07-21 12:00:00	\N	0.00	\N
236	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-07-07 12:00:00	\N	0.00	\N
239	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-07-21 12:00:00	\N	0.00	\N
242	T8	\N	0.00	45.00	45.00	2	f	f	\N	2023-07-21 12:00:00	\N	30.00	Inconnue
248	T4	\N	84.00	0.00	84.00	2	f	f	\N	2023-07-21 12:00:00	\N	84.00	Chantal
251	\N	\N	-11.74	0.00	-11.74	1	f	t	\N	2023-07-22 12:00:00	\N	0.00	\N
241	\N	\N	0.00	12.00	12.00	2	t	f	\N	2023-07-21 12:00:00	\N	12.00	Emporté
126	\N	\N	0.00	40.50	40.50	3	t	f	\N	2023-06-16 12:00:00	\N	40.50	Emporté
252	\N	\N	0.00	-19.29	-19.29	1	f	t	\N	2023-07-21 12:00:00	\N	0.00	\N
243	T10	\N	0.00	36.00	36.00	1	f	f	\N	2023-07-21 12:00:00	\N	24.00	Wéry
272	\N	-1409108099	-270.36	0.00	-270.36	1	f	t	\N	2023-08-10 12:00:00	\N	0.00	\N
247	T9	\N	59.00	0.00	59.00	2	f	f	\N	2023-07-21 12:00:00	\N	59.00	Sébastien
254	T4	\N	0.00	155.00	155.00	6	f	f	\N	2023-07-22 12:00:00	\N	84.00	T4
249	T5	\N	84.00	0.00	84.00	2	f	f	\N	2023-07-21 12:00:00	\N	84.00	Wendy
250	\N	\N	-2.00	0.00	-2.00	1	f	t	\N	2023-07-22 12:00:00	\N	0.00	\N
257	T10	\N	0.00	50.00	50.00	1	f	f	\N	2023-07-22 12:00:00	\N	12.00	T10
260	\N	\N	0.00	-60.45	-60.45	1	f	t	\N	2023-08-09 12:00:00	\N	0.00	\N
263	T14	\N	0.00	6.00	6.00	1	f	f	\N	2023-08-09 12:00:00	\N	6.00	T14
266	\N	\N	-20.03	0.00	-20.03	1	f	t	\N	2023-08-09 12:00:00	\N	0.00	\N
269	T10	\N	0.00	15.00	15.00	1	f	f	\N	2023-08-10 12:00:00	\N	15.00	T10
275	\N	\N	0.00	-70.00	-70.00	1	f	t	\N	2023-08-11 12:00:00	\N	0.00	\N
278	\N	\N	0.00	54.00	54.00	6	t	f	\N	2023-08-11 12:00:00	\N	54.00	Emporté
281	T8	\N	84.50	0.00	84.50	2	f	f	\N	2023-08-11 12:00:00	\N	84.50	T8
284	\N	\N	-90.34	0.00	-90.34	1	f	t	\N	2023-08-11 12:00:00	\N	0.00	\N
289	\N	\N	0.00	11.50	11.50	1	t	f	\N	2023-08-17 12:00:00	\N	11.50	Emporté
290	\N	\N	-10.72	0.00	-10.72	1	f	t	\N	2023-08-17 12:00:00	\N	0.00	\N
291	\N	\N	0.00	-50.40	-50.40	1	f	t	\N	2023-08-17 12:00:00	\N	0.00	\N
292	\N	\N	0.00	13.50	13.50	1	t	f	\N	2023-08-17 12:00:00	\N	13.50	Emporté
293	T4	\N	0.00	27.00	27.00	1	f	f	\N	2023-08-17 12:00:00	\N	27.00	Eric
294	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2023-08-01 12:00:00	\N	0.00	\N
296	T4	\N	0.00	46.50	46.50	2	f	f	\N	2023-08-18 12:00:00	\N	46.50	ERNOTTE
297	\N	\N	-28.14	0.00	-28.14	1	f	t	\N	2023-08-18 12:00:00	\N	0.00	\N
298	\N	\N	-400.00	0.00	-400.00	1	f	t	\N	2023-08-19 12:00:00	\N	0.00	\N
299	\N	\N	0.00	21.50	21.50	1	t	f	\N	2023-08-19 12:00:00	\N	21.50	Emporté
300	T4	\N	87.00	100.00	187.00	5	f	f	\N	2023-08-19 12:00:00	\N	100.00	T4
301	\N	\N	0.00	-19.85	-19.85	1	f	t	\N	2023-08-18 12:00:00	\N	0.00	\N
302	T8	\N	0.00	65.00	65.00	2	f	f	\N	2023-08-18 12:00:00	\N	39.00	T8
303	T10	\N	0.00	40.00	40.00	2	f	f	\N	2023-08-18 12:00:00	\N	28.00	T10
304	T6	\N	0.00	29.00	29.00	1	f	f	\N	2023-08-18 12:00:00	\N	15.00	T6
305	T6	\N	0.00	67.10	67.10	2	f	f	\N	2023-08-18 12:00:00	\N	34.50	T6
306	\N	\N	0.00	13.50	13.50	1	t	f	\N	2023-08-18 12:00:00	\N	13.50	Emporté
307	\N	\N	-13.15	0.00	-13.15	1	f	t	\N	2023-08-18 12:00:00	\N	0.00	\N
308	\N	\N	0.00	-50.77	-50.77	1	f	t	\N	2023-08-18 12:00:00	\N	0.00	\N
309	T7	\N	22.50	100.00	122.50	3	f	f	\N	2023-08-18 12:00:00	\N	60.50	T7
310	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-08-24 12:00:00	\N	6.00	Emporté
311	T8	\N	103.50	0.00	103.50	5	f	f	\N	2023-08-25 12:00:00	\N	103.50	T8
312	\N	\N	-37.10	0.00	-37.10	1	f	t	\N	2023-08-25 12:00:00	\N	0.00	\N
313	\N	\N	0.00	-118.38	-118.38	1	f	t	\N	2023-08-25 12:00:00	\N	0.00	\N
314	\N	\N	-46.86	0.00	-46.86	1	f	t	\N	2023-08-25 12:00:00	\N	0.00	\N
315	\N	\N	-11.44	0.00	-11.44	1	f	t	\N	2023-08-25 12:00:00	\N	0.00	\N
316	T15	\N	29.00	0.00	29.00	2	f	f	\N	2023-08-25 12:00:00	\N	29.00	T15
317	T11	\N	0.00	80.00	80.00	2	f	f	\N	2023-08-25 12:00:00	\N	41.50	Pince
318	T4	\N	65.00	0.00	65.00	2	f	f	\N	2023-08-25 12:00:00	\N	65.00	0474552379
319	\N	\N	-37.10	0.00	-37.10	1	f	t	\N	2023-08-26 12:00:00	\N	0.00	\N
320	\N	\N	-4.28	0.00	-4.28	1	f	t	\N	2023-08-26 12:00:00	\N	0.00	\N
321	\N	\N	-8.76	0.00	-8.76	1	f	t	\N	2023-08-26 12:00:00	\N	0.00	\N
322	\N	\N	-55.00	0.00	-55.00	1	f	t	\N	2023-08-25 12:00:00	\N	0.00	\N
323	\N	\N	0.00	126.00	126.00	10	t	f	\N	2023-08-26 12:00:00	\N	0.00	Emporté
324	T4	\N	0.00	89.80	89.80	3	f	f	\N	2023-08-26 12:00:00	\N	54.80	T4
325	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-08-11 12:00:00	\N	0.00	\N
326	\N	\N	0.00	-60.00	-60.00	1	f	t	\N	2023-08-12 12:00:00	\N	0.00	\N
327	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-08-18 12:00:00	\N	0.00	\N
328	\N	\N	0.00	-60.00	-60.00	1	f	t	\N	2023-08-19 12:00:00	\N	0.00	\N
329	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-08-26 12:00:00	\N	0.00	\N
330	\N	\N	0.00	-22.06	-22.06	1	f	t	\N	2023-08-30 12:00:00	\N	0.00	\N
331	T8	\N	0.00	22.50	22.50	1	f	f	\N	2023-08-30 12:00:00	\N	22.50	T8
332	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-08-31 12:00:00	\N	6.00	Emporté
334	\N	\N	0.00	-10.96	-10.96	1	f	t	\N	2023-09-01 12:00:00	\N	0.00	\N
335	T5	\N	0.00	24.00	24.00	2	t	f	\N	2023-09-01 12:00:00	\N	0.00	T5
336	T10	\N	0.00	37.00	37.00	1	f	f	\N	2023-09-01 12:00:00	\N	0.00	T10
337	\N	\N	0.00	40.10	40.10	3	t	f	\N	2023-09-01 12:00:00	\N	0.00	Emporté
340	T15	\N	91.00	0.00	91.00	2	f	f	\N	2023-09-01 12:00:00	\N	91.00	T15
341	T2	\N	54.00	0.00	54.00	2	f	f	\N	2023-09-01 12:00:00	\N	57.50	Guylain
342	T7	\N	175.50	0.00	175.50	4	f	f	\N	2023-09-01 12:00:00	\N	175.50	Pauline
343	T8	\N	306.00	0.00	306.00	12	f	f	\N	2023-09-01 12:00:00	\N	306.00	Nic
344	T9	\N	37.00	0.00	37.00	1	f	f	\N	2023-09-01 12:00:00	\N	37.00	Occupé
345	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-09-01 12:00:00	\N	0.00	\N
346	\N	\N	0.00	-13.25	-13.25	1	f	t	\N	2023-09-01 12:00:00	\N	0.00	\N
348	\N	\N	0.00	-115.00	-115.00	1	f	t	\N	2023-09-02 12:00:00	\N	0.00	\N
349	\N	\N	-44.26	0.00	-44.26	1	f	t	\N	2023-09-02 12:00:00	\N	0.00	\N
350	\N	\N	-68.83	0.00	-68.83	1	f	t	\N	2023-09-02 12:00:00	\N	0.00	\N
351	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-09-02 12:00:00	\N	6.00	Emporté
352	T4	\N	129.50	0.00	129.50	4	f	f	\N	2023-09-02 12:00:00	\N	129.50	Famille
353	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-09-02 12:00:00	\N	0.00	\N
354	\N	\N	-69.01	0.00	-69.01	2	f	t	\N	2023-09-06 12:00:00	\N	0.00	\N
355	\N	\N	-88.26	0.00	-88.26	1	t	t	\N	2023-08-29 12:00:00	\N	0.00	\N
357	\N	\N	0.00	60.00	60.00	6	t	f	\N	2023-09-07 12:00:00	\N	0.00	Emporté
359	\N	\N	0.00	12.00	12.00	2	t	f	\N	2023-09-07 12:00:00	\N	0.00	Emporté
360	\N	\N	-11.44	0.00	-11.44	1	f	t	\N	2023-09-07 12:00:00	\N	0.00	\N
362	T13	\N	0.00	6.00	6.00	1	t	f	\N	2023-09-07 12:00:00	\N	0.00	T13
514	T6	\N	0.00	47.00	47.00	2	f	f	\N	2023-10-13 12:00:00	\N	34.00	Pibchault
365	\N	\N	-24.36	0.00	-24.36	1	f	t	\N	2023-09-08 12:00:00	\N	0.00	\N
386	\N	\N	0.00	-8.48	-8.48	1	f	t	\N	2023-09-09 12:00:00	\N	0.00	\N
371	\N	\N	0.00	76.50	76.50	6	t	f	\N	2023-09-08 12:00:00	\N	0.00	Emporté
389	\N	\N	0.00	-132.00	-132.00	1	f	t	\N	2023-09-14 12:00:00	\N	0.00	\N
374	T15	\N	0.00	27.50	27.50	1	f	f	\N	2023-09-08 12:00:00	\N	0.00	T15
517	T12	\N	0.00	35.00	35.00	1	f	f	\N	2023-10-13 12:00:00	\N	0.00	Ludo
392	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-09-14 12:00:00	\N	6.00	Emporté
380	\N	\N	0.00	-20.57	-20.57	1	f	t	\N	2023-09-09 12:00:00	\N	0.00	\N
395	T2	\N	23.00	0.00	23.00	2	f	f	\N	2023-09-14 12:00:00	\N	23.00	Marie&Lou
520	\N	\N	-36.39	0.00	-36.39	1	f	t	\N	2023-10-14 12:00:00	\N	0.00	\N
398	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-09-15 12:00:00	\N	6.00	Emporté
401	\N	\N	0.00	-13.00	-13.00	1	f	t	\N	2023-09-15 12:00:00	\N	0.00	\N
523	T8	\N	0.00	62.80	62.80	3	f	f	\N	2023-10-18 12:00:00	\N	15.00	Les Nanas
407	T4	\N	0.00	64.00	64.00	2	f	f	\N	2023-09-15 12:00:00	\N	0.00	Vieux
526	\N	\N	-55.13	0.00	-55.13	6	f	t	\N	2023-10-20 12:00:00	\N	0.00	\N
410	T14	\N	20.00	0.00	20.00	2	f	f	\N	2023-09-15 12:00:00	\N	20.00	Christophe
413	T8	\N	134.30	0.00	134.30	4	f	f	\N	2023-09-16 12:00:00	\N	134.30	Mme Rhum
529	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-10-20 12:00:00	\N	6.00	Emporté
416	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-09-16 12:00:00	\N	0.00	\N
419	T4	\N	54.00	0.00	54.00	2	f	f	\N	2023-09-20 12:00:00	\N	54.00	Maertens
532	\N	\N	0.00	-3.35	-3.35	1	f	t	\N	2023-10-20 12:00:00	\N	0.00	\N
422	\N	\N	0.00	-72.00	-72.00	1	f	f	\N	2023-09-20 12:00:00	\N	-72.00	Dépenses
425	\N	\N	0.00	-65.45	-65.45	1	f	t	\N	2023-09-21 12:00:00	\N	0.00	\N
535	T2	\N	0.00	45.00	45.00	2	f	f	\N	2023-10-20 12:00:00	\N	0.00	Inconnu vieux
431	\N	\N	12.00	0.00	12.00	1	t	f	\N	2023-09-22 12:00:00	\N	12.00	Emporté
538	T14	\N	0.00	7.00	7.00	1	f	f	\N	2023-10-20 12:00:00	\N	0.00	Manu
437	\N	\N	-29.30	0.00	-29.30	1	f	t	\N	2023-09-23 12:00:00	\N	0.00	\N
541	T14	\N	0.00	21.00	21.00	1	f	f	\N	2023-10-21 12:00:00	\N	15.00	T14
544	T2	\N	0.00	176.00	176.00	7	f	f	\N	2023-10-21 12:00:00	\N	85.00	T2
446	\N	\N	-4.52	0.00	-4.52	1	f	t	\N	2023-09-27 12:00:00	\N	0.00	\N
449	\N	\N	0.00	-30.88	-30.88	1	f	t	\N	2023-09-28 12:00:00	\N	0.00	\N
547	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-10-21 12:00:00	\N	0.00	\N
452	T14	\N	0.00	60.00	60.00	1	t	f	\N	2023-09-28 12:00:00	\N	30.00	T14
455	\N	\N	0.00	-75.97	-75.97	1	f	t	\N	2023-09-29 12:00:00	\N	0.00	\N
550	\N	\N	0.00	-20.00	-20.00	1	f	t	\N	2023-10-20 12:00:00	\N	0.00	\N
458	T4	\N	0.00	769.00	769.00	20	f	f	\N	2023-09-29 12:00:00	\N	0.00	T4
461	T5	\N	0.00	39.00	39.00	2	f	f	\N	2023-10-04 12:00:00	\N	0.00	T5
553	\N	\N	0.00	-71.05	-71.05	1	f	t	\N	2023-10-24 12:00:00	\N	0.00	\N
467	\N	\N	-22.92	0.00	-22.92	1	f	t	\N	2023-10-05 12:00:00	\N	0.00	\N
556	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-10-25 12:00:00	\N	6.00	Emporté
473	\N	\N	0.00	10.50	10.50	1	t	f	\N	2023-10-06 12:00:00	\N	6.00	Emporté
559	T8	\N	22.00	0.00	22.00	1	f	f	\N	2023-10-25 12:00:00	\N	22.00	T8
476	\N	\N	12.00	0.00	12.00	2	t	f	\N	2023-10-06 12:00:00	\N	12.00	Emporté
479	T4	\N	0.00	77.00	77.00	4	f	f	\N	2023-10-06 12:00:00	\N	0.00	Parmentier
562	\N	\N	-113.63	0.00	0.00	1	f	t	\N	2023-10-23 12:00:00	\N	0.00	\N
482	\N	\N	-68.57	0.00	-68.57	1	f	t	\N	2023-10-06 12:00:00	\N	0.00	\N
485	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-10-06 12:00:00	\N	6.00	Emporté
565	\N	\N	-25.00	0.00	-25.00	1	f	t	\N	2023-10-16 12:00:00	\N	0.00	\N
488	T9	\N	0.00	19.00	19.00	1	f	f	\N	2023-10-06 12:00:00	\N	0.00	France
491	T10	\N	98.00	0.00	98.00	3	f	f	\N	2023-10-06 12:00:00	\N	98.00	Marie
568	\N	\N	-117.23	0.00	-117.23	1	f	t	\N	2023-09-29 12:00:00	\N	0.00	\N
497	T7	\N	79.00	0.00	79.00	2	f	f	\N	2023-10-07 12:00:00	\N	79.00	Benoit
571	\N	\N	-25.00	0.00	-25.00	1	f	t	\N	2023-09-15 12:00:00	\N	0.00	\N
500	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-10-07 12:00:00	\N	0.00	\N
503	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-10-11 12:00:00	\N	0.00	Emporté
574	\N	\N	-116.36	0.00	-116.36	1	f	t	\N	2023-09-07 12:00:00	\N	0.00	\N
506	T11	\N	34.00	0.00	34.00	2	f	f	\N	2023-10-12 12:00:00	\N	34.00	Manon
509	T15	\N	8.00	0.00	8.00	1	t	f	\N	2023-10-13 12:00:00	\N	8.00	T15
577	\N	\N	-110.66	0.00	-110.66	1	f	t	\N	2023-10-16 12:00:00	\N	0.00	\N
512	\N	\N	-33.55	0.00	-33.55	1	f	t	\N	2023-10-13 12:00:00	\N	0.00	\N
580	\N	\N	-4.90	0.00	-4.90	1	f	t	\N	2023-10-25 12:00:00	\N	0.00	\N
583	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-10-27 12:00:00	\N	6.00	Emporté
586	\N	\N	-39.00	0.00	-39.00	1	f	t	\N	2023-08-25 12:00:00	\N	0.00	\N
589	T14	\N	0.00	14.50	14.50	1	f	f	\N	2023-10-26 12:00:00	\N	14.50	T14
592	T10	\N	0.00	27.00	27.00	1	f	f	\N	2023-10-26 12:00:00	\N	27.00	Dame Seule
598	T9	\N	0.00	27.00	27.00	1	f	f	\N	2023-10-27 12:00:00	\N	27.00	T9
601	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-10-27 12:00:00	\N	0.00	\N
604	\N	\N	0.00	27.00	27.00	2	t	f	\N	2023-10-28 12:00:00	\N	0.00	Emporté
607	T8	\N	0.00	84.00	84.00	2	f	f	\N	2023-10-28 12:00:00	\N	0.00	T8
610	\N	\N	0.00	-325.00	-325.00	1	f	t	\N	2023-10-28 12:00:00	\N	0.00	\N
613	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2023-10-28 12:00:00	\N	0.00	\N
616	T3	\N	0.00	7.50	7.50	1	f	f	\N	2023-10-31 12:00:00	\N	7.50	T3
623	T11	\N	0.00	52.00	52.00	2	f	f	\N	2023-11-03 12:00:00	\N	52.00	PAUL
513	T7	\N	62.00	0.00	62.00	2	f	f	\N	2023-10-13 12:00:00	\N	62.00	David
358	T11	\N	0.00	50.50	50.50	2	f	f	\N	2023-09-07 12:00:00	\N	0.00	Tabuyn
384	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-09-09 12:00:00	\N	0.00	\N
361	T4	\N	29.50	0.00	29.50	1	t	f	\N	2023-09-07 12:00:00	\N	29.50	T4
364	\N	\N	0.00	-96.25	-96.25	1	f	t	\N	2023-09-08 12:00:00	\N	0.00	\N
387	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-09-13 12:00:00	\N	6.00	Emporté
367	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-09-08 12:00:00	\N	0.00	Emporté
370	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2023-09-04 12:00:00	\N	0.00	\N
390	\N	\N	0.00	-5.47	-5.47	1	f	t	\N	2023-09-14 12:00:00	\N	0.00	\N
373	T8	\N	0.00	29.00	29.00	2	f	f	\N	2023-09-08 12:00:00	\N	0.00	inconnu
775	\N	\N	0.00	-20.00	-20.00	1	f	t	\N	2023-11-29 12:00:00	\N	0.00	\N
376	T13	\N	0.00	24.50	24.50	3	f	f	\N	2023-09-08 12:00:00	\N	0.00	T13
393	\N	\N	0.00	12.00	12.00	2	t	f	\N	2023-09-14 12:00:00	\N	12.00	Emporté
379	T10	\N	90.50	90.00	180.50	4	f	f	\N	2023-09-08 12:00:00	\N	90.50	Delcour
518	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-10-13 12:00:00	\N	0.00	\N
396	T8	\N	20.00	0.00	20.00	1	f	f	\N	2023-09-15 12:00:00	\N	20.00	T8
399	\N	\N	0.00	18.00	18.00	3	t	f	\N	2023-09-15 12:00:00	\N	18.00	Emporté
521	\N	\N	-68.35	0.00	-68.35	1	f	t	\N	2023-10-14 12:00:00	\N	0.00	\N
402	\N	\N	0.00	-9.51	-9.51	1	f	t	\N	2023-09-14 12:00:00	\N	0.00	\N
405	T3	\N	0.00	30.00	30.00	2	f	f	\N	2023-09-15 12:00:00	\N	0.00	couple
524	\N	\N	-28.65	0.00	-28.65	1	f	t	\N	2023-10-20 12:00:00	\N	0.00	\N
408	T7	\N	144.00	0.00	144.00	4	f	f	\N	2023-09-15 12:00:00	\N	144.00	Annick
411	\N	\N	-34.20	0.00	-34.20	1	f	t	\N	2023-09-15 12:00:00	\N	0.00	\N
527	T10	\N	0.00	40.00	40.00	1	f	f	\N	2023-10-20 12:00:00	\N	0.00	Sabine
530	\N	\N	0.00	27.00	27.00	2	t	f	\N	2023-10-20 12:00:00	\N	0.00	Emporté
420	T2	\N	0.00	112.00	112.00	2	f	f	\N	2023-09-20 12:00:00	\N	0.00	T2
423	\N	\N	0.00	8.00	8.00	1	t	f	\N	2023-09-21 12:00:00	\N	8.00	Emporté
533	\N	\N	0.00	27.00	27.00	2	t	f	\N	2023-10-20 12:00:00	\N	0.00	Emporté
429	\N	\N	0.00	-10.80	-10.80	1	f	t	\N	2023-09-22 12:00:00	\N	0.00	\N
435	T4	\N	0.00	170.00	170.00	6	f	f	\N	2023-09-22 12:00:00	\N	0.00	Voisin
539	T8	\N	364.50	0.00	364.50	10	f	f	\N	2023-10-20 12:00:00	\N	364.50	Aurelien
438	\N	\N	0.00	-99.44	-99.44	1	f	t	\N	2023-09-23 12:00:00	\N	0.00	\N
542	\N	\N	27.00	0.00	27.00	2	t	f	\N	2023-10-21 12:00:00	\N	27.00	Emporté
444	\N	\N	0.00	-28.45	-28.45	1	f	t	\N	2023-09-27 12:00:00	\N	0.00	\N
447	\N	\N	0.00	13.00	13.00	2	t	f	\N	2023-09-27 12:00:00	\N	13.00	Emporté
545	T8	\N	0.00	99.00	99.00	1	f	f	\N	2023-10-21 12:00:00	\N	0.00	T8
450	T13	\N	0.00	13.00	13.00	1	f	f	\N	2023-09-28 12:00:00	\N	6.00	T13
453	\N	\N	0.00	13.50	13.50	1	t	f	\N	2023-09-29 12:00:00	\N	13.50	Emporté
548	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-10-21 12:00:00	\N	0.00	\N
456	\N	\N	0.00	-3.50	-3.50	1	f	t	\N	2023-09-29 12:00:00	\N	0.00	\N
459	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-09-29 12:00:00	\N	0.00	\N
551	\N	\N	0.00	-20.00	-20.00	1	f	t	\N	2023-10-18 12:00:00	\N	0.00	\N
462	T6	\N	0.00	39.00	39.00	2	f	f	\N	2023-10-04 12:00:00	\N	0.00	T6
465	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-10-04 12:00:00	\N	6.00	Emporté
554	\N	\N	0.00	-29.25	-29.25	1	f	t	\N	2023-10-24 12:00:00	\N	0.00	\N
468	\N	\N	0.00	4.00	4.00	1	t	f	\N	2023-10-05 12:00:00	\N	4.00	Emporté
471	\N	\N	0.00	-36.48	-36.48	1	f	t	\N	2023-10-04 12:00:00	\N	0.00	\N
557	\N	\N	27.00	0.00	27.00	1	t	f	\N	2023-10-25 12:00:00	\N	27.00	Emporté
474	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-10-06 12:00:00	\N	6.00	Emporté
477	\N	\N	25.20	0.00	25.20	2	t	f	\N	2023-10-06 12:00:00	\N	25.20	Emporté
560	\N	\N	-533.33	0.00	-533.33	1	f	t	\N	2023-10-23 12:00:00	\N	0.00	\N
480	\N	\N	0.00	28.80	28.80	2	t	f	\N	2023-10-06 12:00:00	\N	0.00	Emporté
483	\N	\N	-51.57	0.00	-51.57	1	f	t	\N	2023-10-06 12:00:00	\N	0.00	\N
563	\N	\N	-200.73	0.00	-200.73	1	f	t	\N	2023-10-23 12:00:00	\N	0.00	\N
486	\N	\N	0.00	12.00	12.00	2	t	f	\N	2023-10-06 12:00:00	\N	12.00	Emporté
489	T6	\N	52.00	0.00	52.00	2	f	f	\N	2023-10-06 12:00:00	\N	52.00	Sikivie
566	\N	\N	-402.72	0.00	-402.72	1	f	t	\N	2023-10-16 12:00:00	\N	0.00	\N
569	\N	\N	-114.17	0.00	-114.17	1	f	t	\N	2023-09-27 12:00:00	\N	0.00	\N
501	\N	\N	0.00	-70.00	-70.00	2	f	t	\N	2023-10-06 12:00:00	\N	0.00	\N
572	\N	\N	-124.31	0.00	-124.31	1	f	t	\N	2023-09-14 12:00:00	\N	0.00	\N
504	\N	\N	-15.56	0.00	-15.56	1	f	t	\N	2023-10-11 12:00:00	\N	0.00	\N
575	\N	\N	-242.00	0.00	-242.00	1	f	t	\N	2023-09-04 12:00:00	\N	0.00	\N
510	\N	\N	0.00	25.00	25.00	4	t	f	\N	2023-10-13 12:00:00	\N	0.00	Emporté
578	\N	\N	-129.00	0.00	-129.00	1	f	t	\N	2023-08-24 12:00:00	\N	0.00	\N
584	\N	\N	-117.00	0.00	-117.00	1	f	t	\N	2023-08-28 12:00:00	\N	0.00	\N
587	\N	\N	-108.52	0.00	-108.52	1	f	t	\N	2023-08-21 12:00:00	\N	0.00	\N
590	T7	\N	48.00	0.00	48.00	2	f	f	\N	2023-10-26 12:00:00	\N	48.00	François
596	T13	\N	0.00	69.00	69.00	2	f	f	\N	2023-10-27 12:00:00	\N	0.00	T13
599	T7	\N	48.00	0.00	48.00	1	f	f	\N	2023-10-27 12:00:00	\N	48.00	T7
602	\N	\N	-20.00	0.00	-20.00	1	f	t	\N	2023-10-27 12:00:00	\N	0.00	\N
608	T8	\N	0.00	5.00	5.00	1	f	f	\N	2023-10-28 12:00:00	\N	5.00	T8
611	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-10-28 12:00:00	\N	0.00	\N
614	T4	\N	0.00	64.50	64.50	1	f	f	\N	2023-10-31 12:00:00	\N	0.00	T4
617	T4	\N	25.50	0.00	25.50	1	f	f	\N	2023-10-31 12:00:00	\N	25.50	T4
363	\N	\N	0.00	7.00	7.00	1	t	f	\N	2023-09-08 12:00:00	\N	0.00	Emporté
385	\N	\N	0.00	-80.00	-80.00	1	f	t	\N	2023-09-08 12:00:00	\N	0.00	\N
366	\N	\N	20.00	0.00	20.00	3	t	f	\N	2023-09-08 12:00:00	\N	20.00	Emporté
369	T7	\N	0.00	45.00	45.00	1	f	f	\N	2023-09-08 12:00:00	\N	0.00	Wéry
372	\N	\N	44.90	0.00	44.90	4	t	f	\N	2023-09-08 12:00:00	\N	44.90	Emporté
375	T14	\N	57.00	0.00	57.00	3	f	f	\N	2023-09-08 12:00:00	\N	57.00	T14
391	\N	\N	0.00	-37.96	-37.96	1	f	t	\N	2023-09-14 12:00:00	\N	0.00	\N
378	T7	\N	0.00	86.50	86.50	2	f	f	\N	2023-09-08 12:00:00	\N	0.00	Debatty
519	\N	\N	-27.58	0.00	-27.58	1	f	t	\N	2023-10-14 12:00:00	\N	0.00	\N
381	\N	\N	0.00	21.60	21.60	2	t	f	\N	2023-09-09 12:00:00	\N	0.00	Emporté
397	\N	\N	0.00	27.00	27.00	2	t	f	\N	2023-09-15 12:00:00	\N	0.00	Emporté
522	\N	\N	6.00	0.00	6.00	1	t	f	\N	2023-10-18 12:00:00	\N	6.00	Emporté
400	\N	\N	0.00	2.00	2.00	1	t	f	\N	2023-09-15 12:00:00	\N	0.00	Emporté
403	T2	\N	31.50	0.00	31.50	2	f	f	\N	2023-09-15 12:00:00	\N	31.50	T2
525	\N	\N	7.00	0.00	7.00	1	t	f	\N	2023-10-20 12:00:00	\N	7.00	Emporté
406	\N	\N	76.50	0.00	76.50	6	t	f	\N	2023-09-15 12:00:00	\N	76.50	Emporté
409	T8	\N	0.00	44.00	44.00	2	f	f	\N	2023-09-15 12:00:00	\N	0.00	Dernier
412	\N	\N	0.00	39.00	39.00	3	t	f	\N	2023-09-16 12:00:00	\N	0.00	Emporté
415	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-09-15 12:00:00	\N	0.00	\N
531	\N	\N	0.00	13.50	13.50	1	t	f	\N	2023-10-20 12:00:00	\N	0.00	Emporté
418	\N	\N	0.00	-11.06	-11.06	2	f	t	\N	2023-09-20 12:00:00	\N	0.00	\N
421	T14	\N	0.00	12.50	12.50	1	f	f	\N	2023-09-20 12:00:00	\N	0.00	T14
534	\N	\N	0.00	0.00	6.00	1	t	f	\N	2023-10-20 12:00:00	\N	6.00	Emporté
424	\N	\N	0.00	-60.76	-60.76	1	f	f	\N	2023-09-21 12:00:00	\N	-60.76	Dépenses
537	T13	\N	4.50	0.00	4.50	1	f	f	\N	2023-10-20 12:00:00	\N	4.50	annick
430	\N	\N	0.00	-26.85	-26.85	1	f	t	\N	2023-09-22 12:00:00	\N	0.00	\N
540	T14	\N	0.00	2.50	2.50	1	f	f	\N	2023-10-20 12:00:00	\N	0.00	Manu
436	\N	\N	0.00	-23.90	-23.90	1	f	t	\N	2023-09-23 12:00:00	\N	0.00	\N
439	\N	\N	27.00	0.00	27.00	2	t	f	\N	2023-09-23 12:00:00	\N	27.00	Emporté
543	T3	\N	0.00	75.00	75.00	5	f	f	\N	2023-10-21 12:00:00	\N	75.00	T3
442	\N	\N	0.00	-100.00	-100.00	1	f	t	\N	2023-09-23 12:00:00	\N	0.00	\N
445	\N	\N	0.00	-29.15	-29.15	1	f	t	\N	2023-09-27 12:00:00	\N	0.00	\N
546	\N	\N	-36.26	0.00	-36.26	1	f	t	\N	2023-10-21 12:00:00	\N	0.00	\N
448	\N	\N	0.00	12.00	12.00	2	t	f	\N	2023-09-27 12:00:00	\N	12.00	Emporté
451	T10	\N	0.00	28.00	28.00	2	f	f	\N	2023-09-28 12:00:00	\N	28.00	T10
549	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-10-20 12:00:00	\N	0.00	\N
454	\N	\N	0.00	27.30	27.30	2	t	f	\N	2023-09-29 12:00:00	\N	27.30	Emporté
457	\N	\N	32.60	0.00	32.60	3	t	f	\N	2023-09-29 12:00:00	\N	32.60	Emporté
552	\N	\N	0.00	-121.70	-121.70	1	f	t	\N	2023-10-24 12:00:00	\N	0.00	\N
460	\N	\N	-400.00	0.00	-400.00	1	f	t	\N	2023-09-30 12:00:00	\N	0.00	\N
555	\N	\N	-31.40	0.00	-31.40	1	f	t	\N	2023-10-23 12:00:00	\N	0.00	\N
466	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-10-04 12:00:00	\N	6.00	Emporté
469	T8	\N	18.50	0.00	18.50	1	f	f	\N	2023-10-05 12:00:00	\N	18.50	Kiné
558	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-10-25 12:00:00	\N	6.00	Emporté
472	\N	\N	0.00	-20.00	-20.00	1	f	t	\N	2023-10-05 12:00:00	\N	0.00	\N
475	\N	\N	6.00	0.00	6.00	1	t	f	\N	2023-10-06 12:00:00	\N	6.00	Emporté
561	\N	\N	-486.02	0.00	-486.02	1	f	t	\N	2023-10-24 12:00:00	\N	0.00	\N
478	\N	\N	0.00	7.00	7.00	1	t	f	\N	2023-10-06 12:00:00	\N	7.00	Emporté
481	\N	\N	-49.45	0.00	-49.45	1	f	t	\N	2023-10-06 12:00:00	\N	0.00	\N
564	\N	\N	-100.00	0.00	-100.00	1	f	t	\N	2023-10-18 12:00:00	\N	0.00	\N
484	T14	\N	0.00	10.00	10.00	1	t	f	\N	2023-10-06 12:00:00	\N	6.00	Sam
487	\N	\N	20.00	0.00	20.00	2	t	f	\N	2023-10-06 12:00:00	\N	20.00	Emporté
567	\N	\N	-115.83	0.00	-115.83	1	f	t	\N	2023-10-09 12:00:00	\N	0.00	\N
490	\N	\N	17.00	0.00	17.00	1	t	f	\N	2023-10-06 12:00:00	\N	17.00	Emporté
493	T12	\N	0.00	13.00	13.00	1	f	f	\N	2023-10-06 12:00:00	\N	0.00	T12
570	\N	\N	-116.20	0.00	-116.20	1	f	t	\N	2023-09-25 12:00:00	\N	0.00	\N
496	\N	\N	-79.96	0.00	-79.96	2	f	t	\N	2023-10-07 12:00:00	\N	0.00	\N
499	T8	\N	85.60	0.00	85.60	2	f	f	\N	2023-10-07 12:00:00	\N	85.60	Pharmacie
573	\N	\N	-90.00	0.00	-90.00	1	f	t	\N	2023-09-08 12:00:00	\N	0.00	\N
502	\N	\N	0.00	-66.00	-66.00	2	f	t	\N	2023-10-06 12:00:00	\N	0.00	\N
505	\N	\N	-51.85	0.00	-51.85	1	f	t	\N	2023-10-10 12:00:00	\N	0.00	\N
576	\N	\N	-500.00	0.00	-500.00	1	f	t	\N	2023-09-01 12:00:00	\N	0.00	\N
508	\N	\N	0.00	7.00	7.00	1	t	f	\N	2023-10-12 12:00:00	\N	0.00	Emporté
511	T7	\N	0.00	9.50	9.50	1	f	f	\N	2023-10-13 12:00:00	\N	0.00	T7
579	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-10-26 12:00:00	\N	6.00	Emporté
582	\N	\N	19.00	0.00	19.00	3	t	f	\N	2023-10-27 12:00:00	\N	19.00	Emporté
585	\N	\N	-48.50	0.00	-48.50	1	f	t	\N	2023-08-28 12:00:00	\N	0.00	\N
588	\N	\N	-400.00	0.00	-400.00	1	f	t	\N	2023-08-21 12:00:00	\N	0.00	\N
591	T4	\N	65.00	0.00	65.00	2	f	f	\N	2023-10-26 12:00:00	\N	65.00	Nico
600	T13	\N	0.00	14.50	14.50	1	f	f	\N	2023-10-27 12:00:00	\N	14.50	T13
603	\N	\N	-11.66	0.00	-11.66	1	f	t	\N	2023-10-27 12:00:00	\N	0.00	\N
606	\N	\N	0.00	20.00	20.00	1	t	f	\N	2023-10-28 12:00:00	\N	0.00	Emporté
609	\N	\N	13.50	0.00	13.50	1	t	f	\N	2023-10-28 12:00:00	\N	13.50	Emporté
612	\N	\N	-337.06	0.00	-337.06	1	f	t	\N	2023-10-16 12:00:00	\N	0.00	\N
615	T11	\N	0.00	40.50	40.50	1	f	f	\N	2023-10-31 12:00:00	\N	0.00	T11
618	T8	\N	63.00	0.00	63.00	1	f	f	\N	2023-10-31 12:00:00	\N	63.00	T8
621	T7	\N	35.00	0.00	35.00	2	f	f	\N	2023-11-03 12:00:00	\N	35.00	EZGI
622	T3	\N	0.00	66.00	66.00	3	f	f	\N	2023-11-03 12:00:00	\N	66.00	DORSAN
624	\N	\N	-32.38	0.00	-32.38	1	f	t	\N	2023-11-03 12:00:00	\N	0.00	\N
625	\N	\N	-29.04	0.00	-29.04	1	f	t	\N	2023-11-03 12:00:00	\N	0.00	\N
626	\N	\N	-11.54	0.00	-11.54	1	f	t	\N	2023-11-04 12:00:00	\N	0.00	\N
774	\N	\N	0.00	-20.00	-20.00	1	f	f	\N	2023-11-22 12:00:00	\N	-20.00	Dépenses
628	T2	\N	76.50	0.00	76.50	2	f	f	\N	2023-11-04 12:00:00	\N	76.50	Sam
629	T7	\N	58.00	0.00	58.00	3	f	f	\N	2023-11-04 12:00:00	\N	58.00	Jobé
631	\N	\N	-12.10	0.00	-12.10	1	f	t	\N	2023-11-08 12:00:00	\N	0.00	\N
632	\N	\N	0.00	13.50	13.50	1	t	f	\N	2023-11-08 12:00:00	\N	0.00	Emporté
776	\N	\N	-94.50	0.00	-94.50	1	f	t	\N	2023-11-29 12:00:00	\N	0.00	\N
634	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-11-08 12:00:00	\N	0.00	Emporté
635	\N	\N	-117.93	0.00	-117.93	1	f	t	\N	2023-11-06 12:00:00	\N	0.00	\N
637	\N	\N	-113.92	0.00	-113.92	1	f	t	\N	2023-10-31 12:00:00	\N	0.00	\N
640	\N	\N	0.00	2.00	2.00	1	t	f	\N	2023-11-08 12:00:00	\N	0.00	Emporté
641	\N	\N	0.00	-100.00	-100.00	1	f	t	\N	2023-11-07 12:00:00	\N	0.00	\N
643	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-11-09 12:00:00	\N	0.00	Emporté
644	T12	\N	0.00	7.00	7.00	1	t	f	\N	2023-11-09 12:00:00	\N	0.00	Pierre
782	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-12-02 12:00:00	\N	0.00	\N
794	\N	\N	0.00	-11.00	-11.00	1	f	t	\N	2023-12-08 12:00:00	\N	0.00	\N
797	T7	\N	0.00	47.00	47.00	2	f	f	\N	2023-12-08 12:00:00	\N	0.00	Voisin sabine
806	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-12-09 12:00:00	\N	0.00	\N
812	T4	\N	0.00	10.00	10.00	1	f	f	\N	2023-12-13 12:00:00	\N	0.00	FIEVET
815	\N	\N	0.00	-61.60	-61.60	1	f	t	\N	2023-12-14 12:00:00	\N	0.00	\N
818	\N	\N	-6.99	0.00	-6.99	1	f	t	\N	2023-12-15 12:00:00	\N	0.00	\N
824	\N	\N	0.00	-63.60	-63.60	1	f	t	\N	2023-12-14 12:00:00	\N	0.00	\N
830	T7	\N	0.00	57.00	57.00	2	f	f	\N	2023-12-16 12:00:00	\N	0.00	Français
833	\N	\N	0.00	-4.50	-4.50	2	f	t	\N	2023-12-16 12:00:00	\N	0.00	\N
839	\N	\N	-350.00	0.00	-350.00	1	f	t	\N	2024-01-22 12:00:00	\N	0.00	\N
842	T11	\N	0.00	55.00	55.00	1	f	f	\N	2023-12-19 12:00:00	\N	0.00	T11
845	T11	\N	0.00	35.00	35.00	2	f	f	\N	2023-12-19 12:00:00	\N	35.00	T11
848	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-12-19 12:00:00	\N	0.00	\N
851	\N	\N	0.00	-35.50	-35.50	1	f	t	\N	2023-12-19 12:00:00	\N	0.00	\N
860	T3	\N	14.00	0.00	14.00	1	f	f	\N	2023-12-22 12:00:00	\N	14.00	manon
863	\N	\N	0.00	2.00	2.00	1	t	f	\N	2023-12-22 12:00:00	\N	0.00	Emporté
866	\N	\N	0.00	20.00	20.00	4	t	f	\N	2023-12-22 12:00:00	\N	0.00	Emporté
872	\N	\N	0.00	5.00	5.00	1	t	f	\N	2023-12-22 12:00:00	\N	0.00	Emporté
875	\N	\N	0.00	15.00	15.00	3	t	f	\N	2023-12-22 12:00:00	\N	0.00	Emporté
878	\N	\N	-94.47	0.00	-94.47	1	f	t	\N	2023-12-21 12:00:00	\N	0.00	\N
881	T4	\N	0.00	53.00	53.00	1	f	f	\N	2023-12-28 12:00:00	\N	28.00	T4
884	\N	\N	-32.35	0.00	-32.35	1	f	t	\N	2023-12-29 12:00:00	\N	0.00	\N
885	T2	\N	0.00	116.00	116.00	2	f	f	\N	2023-12-29 12:00:00	\N	0.00	Alain
887	T4	\N	0.00	221.00	221.00	4	f	f	\N	2023-12-29 12:00:00	\N	0.00	David
890	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-12-29 12:00:00	\N	0.00	\N
893	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-12-22 12:00:00	\N	0.00	\N
901	\N	\N	-37.43	0.00	-37.43	1	f	t	\N	2024-01-04 12:00:00	\N	0.00	\N
902	T9	\N	36.00	0.00	36.00	1	f	f	\N	2024-01-04 12:00:00	\N	36.00	T9
904	\N	\N	-113.54	0.00	-113.54	1	f	t	\N	2024-01-05 12:00:00	\N	0.00	\N
907	\N	\N	0.00	15.00	15.00	1	t	f	\N	2024-01-05 12:00:00	\N	0.00	Emporté
908	T15	\N	0.00	17.00	17.00	1	t	f	\N	2024-01-05 12:00:00	\N	0.00	Chris
913	\N	\N	-14.99	0.00	-14.99	1	f	t	\N	2024-01-05 12:00:00	\N	0.00	\N
914	T3	\N	43.50	0.00	43.50	2	f	f	\N	2024-01-06 12:00:00	\N	43.50	T3
917	T7	\N	67.00	0.00	67.00	2	f	f	\N	2024-01-06 12:00:00	\N	67.00	T7
919	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2024-01-05 12:00:00	\N	0.00	\N
920	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2024-01-06 12:00:00	\N	0.00	\N
922	\N	\N	-416.52	0.00	-416.52	1	f	t	\N	2024-01-05 12:00:00	\N	0.00	\N
923	\N	\N	0.00	6.00	6.00	1	t	f	\N	2024-01-05 12:00:00	\N	6.00	Emporté
926	\N	\N	-32.33	0.00	-32.33	1	f	t	\N	2024-01-10 12:00:00	\N	0.00	\N
928	\N	\N	-50.07	0.00	-50.07	1	f	t	\N	2023-12-16 12:00:00	\N	0.00	\N
929	\N	\N	0.00	19.00	19.00	3	t	f	\N	2023-12-16 12:00:00	\N	19.00	Emporté
937	\N	\N	0.00	91.00	91.00	6	t	f	\N	2024-01-13 12:00:00	\N	0.00	Emporté
943	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2024-01-13 12:00:00	\N	0.00	\N
944	\N	\N	-12.34	0.00	-12.34	1	f	t	\N	2024-01-12 12:00:00	\N	0.00	\N
946	\N	\N	0.00	-8.57	-8.57	1	f	t	\N	2024-01-19 12:00:00	\N	0.00	\N
947	\N	\N	0.00	-6.58	-6.58	1	f	t	\N	2024-01-19 12:00:00	\N	0.00	\N
627	\N	\N	-6.16	0.00	-6.16	1	f	t	\N	2023-11-04 12:00:00	\N	0.00	\N
1422	\N	\N	-209.13	0.00	-209.13	1	f	t	\N	2024-05-08 12:00:00	\N	0.00	\N
630	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-11-04 12:00:00	\N	0.00	\N
633	\N	\N	-74.00	0.00	-74.00	1	f	t	\N	2023-11-07 12:00:00	\N	0.00	\N
636	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2023-11-10 12:00:00	\N	0.00	\N
639	\N	\N	8.00	0.00	8.00	1	t	f	\N	2023-11-08 12:00:00	\N	8.00	Emporté
642	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-11-09 12:00:00	\N	0.00	Emporté
645	\N	\N	-202.22	0.00	-202.22	1	f	t	\N	2023-11-29 12:00:00	\N	0.00	\N
646	\N	\N	-237.46	0.00	-237.46	1	f	t	\N	2023-11-23 12:00:00	\N	0.00	\N
647	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-11-03 12:00:00	\N	0.00	\N
648	T11	\N	0.00	40.50	40.50	1	f	f	\N	2023-11-10 12:00:00	\N	0.00	Sabine
650	T14	\N	33.00	0.00	33.00	2	f	f	\N	2023-11-10 12:00:00	\N	33.00	Manu
651	T12	\N	0.00	85.00	85.00	2	f	f	\N	2023-11-10 12:00:00	\N	0.00	JCC
652	T13	\N	0.00	4.00	4.00	1	f	f	\N	2023-11-10 12:00:00	\N	0.00	Christophe
653	T14	\N	24.00	0.00	24.00	1	t	f	\N	2023-11-10 12:00:00	\N	24.00	T14
654	T11	\N	0.00	36.00	36.00	2	f	f	\N	2023-11-10 12:00:00	\N	0.00	T11
655	T8	\N	82.00	0.00	82.00	3	f	f	\N	2023-11-10 12:00:00	\N	82.00	Bouhoule
658	T12	\N	81.00	0.00	81.00	2	f	f	\N	2023-11-10 12:00:00	\N	81.00	Laly
659	T11	\N	90.50	0.00	90.50	2	f	f	\N	2023-11-10 12:00:00	\N	90.50	couple lunette
661	T3	\N	0.00	56.50	56.50	2	f	f	\N	2023-11-10 12:00:00	\N	0.00	jenne
662	\N	\N	6.00	0.00	6.00	1	t	f	\N	2023-11-10 12:00:00	\N	6.00	Emporté
663	\N	\N	0.00	-75.00	-75.00	1	f	t	\N	2023-11-10 12:00:00	\N	0.00	\N
664	\N	\N	0.00	-60.00	-60.00	1	f	t	\N	2023-11-11 12:00:00	\N	0.00	\N
665	\N	\N	0.00	-31.00	-31.00	1	f	t	\N	2023-11-11 12:00:00	\N	0.00	\N
666	\N	\N	-61.15	0.00	-61.15	1	f	t	\N	2023-11-11 12:00:00	\N	0.00	\N
667	\N	\N	-21.15	0.00	-21.15	1	f	t	\N	2023-11-11 12:00:00	\N	0.00	\N
668	\N	\N	-16.90	0.00	-16.90	1	f	t	\N	2023-11-11 12:00:00	\N	0.00	\N
669	\N	\N	0.00	30.50	30.50	2	t	f	\N	2023-11-11 12:00:00	\N	0.00	Emporté
670	T2	\N	0.00	54.50	54.50	2	f	f	\N	2023-11-11 12:00:00	\N	37.00	T2
671	T14	\N	0.00	25.00	25.00	5	f	f	\N	2023-11-11 12:00:00	\N	0.00	T14
674	\N	\N	0.00	-27.60	-27.60	1	f	t	\N	2023-11-15 12:00:00	\N	0.00	\N
675	\N	\N	-10.31	0.00	-10.31	1	f	t	\N	2023-11-15 12:00:00	\N	0.00	\N
676	\N	\N	-15.90	0.00	-15.90	1	f	t	\N	2023-11-10 12:00:00	\N	0.00	\N
677	\N	\N	-113.65	0.00	-113.65	1	f	t	\N	2023-11-13 12:00:00	\N	0.00	\N
678	\N	\N	-70.75	0.00	-70.75	1	f	t	\N	2023-11-14 12:00:00	\N	0.00	\N
679	\N	\N	-90.00	0.00	-90.00	1	f	t	\N	2023-11-14 12:00:00	\N	0.00	\N
680	\N	\N	13.00	0.00	13.00	2	t	f	\N	2023-11-15 12:00:00	\N	13.00	Emporté
681	T12	\N	0.00	47.50	47.50	2	f	f	\N	2023-11-15 12:00:00	\N	15.50	2 Dames
682	\N	\N	0.00	-126.00	-126.00	1	f	t	\N	2023-11-16 12:00:00	\N	0.00	\N
683	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-11-16 12:00:00	\N	0.00	Emporté
684	\N	\N	12.00	0.00	12.00	2	t	f	\N	2023-11-16 12:00:00	\N	12.00	Emporté
685	T14	\N	43.00	0.00	43.00	2	f	f	\N	2023-11-16 12:00:00	\N	43.00	T14
686	T12	\N	42.00	0.00	42.00	2	f	f	\N	2023-11-17 12:00:00	\N	42.00	T12
688	T11	\N	21.00	0.00	21.00	1	f	f	\N	2023-11-17 12:00:00	\N	21.00	T11
689	\N	\N	40.00	0.00	40.00	3	t	f	\N	2023-11-17 12:00:00	\N	40.00	Emporté
690	\N	\N	0.00	-99.06	-99.06	1	f	t	\N	2023-11-17 12:00:00	\N	0.00	\N
691	\N	\N	0.00	-2.40	-2.40	1	f	t	\N	2023-11-17 12:00:00	\N	0.00	\N
692	T12	\N	0.00	75.00	75.00	2	f	f	\N	2023-11-17 12:00:00	\N	56.00	Servais
693	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-11-17 12:00:00	\N	0.00	\N
694	\N	\N	0.00	-30.05	-30.05	1	f	t	\N	2023-11-18 12:00:00	\N	0.00	\N
695	\N	\N	0.00	-75.00	-75.00	1	f	t	\N	2023-11-17 12:00:00	\N	0.00	\N
696	\N	\N	0.00	-32.72	-32.72	1	f	t	\N	2023-11-15 12:00:00	\N	0.00	\N
697	\N	\N	0.00	40.50	40.50	3	t	f	\N	2023-11-18 12:00:00	\N	0.00	Emporté
698	T2	\N	0.00	54.00	54.00	2	f	f	\N	2023-11-18 12:00:00	\N	0.00	LAURENT
699	T12	\N	0.00	26.00	26.00	1	f	f	\N	2023-11-18 12:00:00	\N	0.00	T12
700	T9	\N	118.00	0.00	118.00	3	f	f	\N	2023-11-18 12:00:00	\N	118.00	LION
701	T8	\N	0.00	126.00	126.00	3	f	f	\N	2023-11-18 12:00:00	\N	0.00	DALNE
703	\N	\N	-9.90	0.00	-9.90	1	f	t	\N	2023-11-22 12:00:00	\N	0.00	\N
704	\N	\N	0.00	-25.07	-25.07	1	f	t	\N	2023-11-17 12:00:00	\N	0.00	\N
705	\N	\N	0.00	-22.15	-22.15	1	f	t	\N	2023-11-19 12:00:00	\N	0.00	\N
706	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-11-22 12:00:00	\N	0.00	Emporté
708	T2	\N	40.30	0.00	40.30	2	f	f	\N	2023-11-22 12:00:00	\N	40.30	Mr-Mme
711	\N	\N	-350.00	0.00	-350.00	1	f	t	\N	2023-11-22 12:00:00	\N	0.00	\N
712	\N	\N	-63.02	0.00	-63.02	1	f	t	\N	2023-11-22 12:00:00	\N	0.00	\N
713	\N	\N	-87.02	0.00	-87.02	1	f	t	\N	2023-11-22 12:00:00	\N	0.00	\N
714	\N	\N	0.00	-20.00	-20.00	1	f	t	\N	2023-11-22 12:00:00	\N	0.00	\N
715	\N	\N	-19.30	0.00	-19.30	1	f	t	\N	2023-11-23 12:00:00	\N	0.00	\N
716	\N	\N	-36.83	0.00	-36.83	1	f	t	\N	2023-11-23 12:00:00	\N	0.00	\N
717	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-11-23 12:00:00	\N	0.00	Emporté
718	\N	\N	0.00	18.00	18.00	3	t	f	\N	2023-11-23 12:00:00	\N	18.00	Emporté
719	\N	\N	8.00	0.00	8.00	1	t	f	\N	2023-11-23 12:00:00	\N	8.00	Emporté
720	\N	\N	0.00	13.00	13.00	2	t	f	\N	2023-11-23 12:00:00	\N	13.00	Emporté
721	\N	\N	0.00	12.00	12.00	2	t	f	\N	2023-11-23 12:00:00	\N	12.00	Emporté
722	\N	\N	-246.46	0.00	-246.46	1	f	t	\N	2023-12-11 12:00:00	\N	0.00	\N
723	\N	\N	-47.33	0.00	-47.33	1	f	t	\N	2023-11-24 12:00:00	\N	0.00	\N
725	\N	\N	-48.93	0.00	-48.93	7	f	t	\N	2023-11-24 12:00:00	\N	0.00	\N
726	T14	\N	9.00	0.00	9.00	1	t	f	\N	2023-11-24 12:00:00	\N	9.00	T14
728	\N	\N	-105.72	0.00	-105.72	7	f	t	\N	2023-11-23 12:00:00	\N	0.00	\N
777	\N	\N	0.00	-38.70	-38.70	1	f	t	\N	2023-12-02 12:00:00	\N	0.00	\N
731	\N	\N	0.00	20.00	20.00	1	t	f	\N	2023-11-24 12:00:00	\N	0.00	Emporté
778	\N	\N	0.00	-19.74	-19.74	1	f	t	\N	2023-12-02 12:00:00	\N	0.00	\N
737	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-11-24 12:00:00	\N	0.00	\N
781	T9	\N	0.00	22.00	22.00	1	f	f	\N	2023-12-02 12:00:00	\N	0.00	Guillaume
743	\N	\N	-102.42	0.00	-102.42	4	f	t	\N	2023-11-20 12:00:00	\N	0.00	\N
746	\N	\N	-400.00	0.00	-400.00	1	f	t	\N	2023-11-13 12:00:00	\N	0.00	\N
783	\N	\N	8.00	0.00	8.00	1	t	f	\N	2023-12-06 12:00:00	\N	8.00	Emporté
749	\N	\N	20.00	0.00	20.00	4	t	f	\N	2023-11-29 12:00:00	\N	26.00	Emporté
784	\N	\N	0.00	-49.70	-49.70	1	f	t	\N	2023-12-06 12:00:00	\N	0.00	\N
752	\N	\N	-27.02	0.00	-27.02	1	f	t	\N	2023-12-01 12:00:00	\N	0.00	\N
755	\N	\N	0.00	-3.00	-3.00	1	f	t	\N	2023-12-01 12:00:00	\N	0.00	\N
786	T10	\N	0.00	63.00	63.00	2	f	f	\N	2023-12-06 12:00:00	\N	0.00	2 Dames
787	\N	\N	0.00	-25.00	-25.00	1	f	t	\N	2023-12-06 12:00:00	\N	0.00	\N
761	\N	\N	0.00	67.50	67.50	5	t	f	\N	2023-12-01 12:00:00	\N	0.00	Emporté
764	T8	\N	133.50	0.00	133.50	4	f	f	\N	2023-12-01 12:00:00	\N	133.50	JM Lux
789	\N	\N	0.00	13.00	13.00	2	t	f	\N	2023-12-08 12:00:00	\N	13.00	Emporté
767	T15	\N	0.00	36.00	36.00	1	f	f	\N	2023-12-01 12:00:00	\N	0.00	T15
790	T6	\N	0.00	123.00	123.00	2	f	f	\N	2023-12-08 12:00:00	\N	54.00	Dash  wish
770	\N	\N	0.00	-50.00	-50.00	4	f	t	\N	2023-11-24 12:00:00	\N	0.00	\N
773	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-11-18 12:00:00	\N	0.00	\N
793	\N	\N	-115.88	0.00	-115.88	1	f	t	\N	2023-12-08 12:00:00	\N	0.00	\N
795	\N	\N	-79.97	0.00	-79.97	1	f	t	\N	2023-12-08 12:00:00	\N	0.00	\N
796	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-12-08 12:00:00	\N	6.00	Emporté
801	\N	\N	0.00	-70.00	-70.00	1	f	t	\N	2023-12-08 12:00:00	\N	0.00	\N
804	T2	\N	58.00	0.00	58.00	3	f	f	\N	2023-12-09 12:00:00	\N	58.00	Peketeur
805	T12	\N	92.00	0.00	92.00	2	f	f	\N	2023-12-09 12:00:00	\N	92.00	Germeau
807	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2023-12-10 12:00:00	\N	0.00	\N
808	\N	\N	0.00	-70.00	-70.00	1	f	t	\N	2023-12-13 12:00:00	\N	0.00	\N
811	T11	\N	27.50	0.00	27.50	2	f	f	\N	2023-12-13 12:00:00	\N	27.50	Nanas
814	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2023-12-13 12:00:00	\N	0.00	\N
816	\N	\N	0.00	-19.05	-19.05	1	f	t	\N	2023-12-14 12:00:00	\N	0.00	\N
819	\N	\N	-6.50	0.00	-6.50	1	f	t	\N	2023-12-15 12:00:00	\N	0.00	\N
820	\N	\N	-114.81	0.00	-114.81	1	f	t	\N	2023-12-19 12:00:00	\N	0.00	\N
825	\N	\N	-38.41	0.00	-38.41	1	f	t	\N	2023-12-15 12:00:00	\N	0.00	\N
826	\N	\N	-69.27	0.00	-69.27	1	f	t	\N	2023-12-15 12:00:00	\N	0.00	\N
828	T2	\N	0.00	72.00	72.00	2	f	f	\N	2023-12-16 12:00:00	\N	0.00	Anaïs
829	T11	\N	231.50	30.00	261.50	8	f	f	\N	2023-12-16 12:00:00	\N	231.50	Pirson
831	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-12-16 12:00:00	\N	0.00	\N
832	\N	\N	0.00	-20.00	-20.00	1	f	t	\N	2023-12-15 12:00:00	\N	0.00	\N
834	\N	\N	0.00	-26.40	-26.40	2	f	t	\N	2023-12-16 12:00:00	\N	0.00	\N
835	T14	\N	16.00	0.00	16.00	1	f	f	\N	2023-12-16 12:00:00	\N	16.00	T14
837	T13	\N	0.00	15.00	15.00	1	f	f	\N	2023-12-16 12:00:00	\N	15.00	T13
838	\N	\N	-350.00	0.00	-350.00	1	f	t	\N	2023-12-21 12:00:00	\N	0.00	\N
840	\N	\N	-393.25	0.00	-393.25	1	f	t	\N	2023-12-27 12:00:00	\N	0.00	\N
841	\N	\N	-151.25	0.00	-151.25	1	f	t	\N	2023-12-17 12:00:00	\N	0.00	\N
846	T15	\N	0.00	31.00	31.00	5	t	f	\N	2023-12-19 12:00:00	\N	0.00	T15
847	T2	\N	108.00	377.00	485.00	9	f	f	\N	2023-12-19 12:00:00	\N	108.00	MILITAIRES
849	\N	\N	0.00	-201.00	-201.00	1	f	t	\N	2023-12-19 12:00:00	\N	0.00	\N
850	\N	\N	-95.84	0.00	-95.84	1	f	t	\N	2023-12-17 12:00:00	\N	0.00	\N
852	\N	\N	-10.78	0.00	-10.78	1	f	t	\N	2023-12-19 12:00:00	\N	0.00	\N
853	\N	\N	0.00	-80.00	-80.00	1	f	t	\N	2023-12-21 12:00:00	\N	0.00	\N
855	T9	\N	106.50	0.00	106.50	5	f	f	\N	2023-12-21 12:00:00	\N	106.50	MAUDE
856	\N	\N	0.00	-84.00	-84.00	1	f	t	\N	2023-12-21 12:00:00	\N	0.00	\N
858	\N	\N	0.00	74.00	74.00	6	t	f	\N	2023-12-22 12:00:00	\N	0.00	Emporté
859	T9	\N	130.00	0.00	130.00	6	f	f	\N	2023-12-22 12:00:00	\N	130.00	wendy
861	T3	\N	0.00	4.00	4.00	2	t	f	\N	2023-12-22 12:00:00	\N	0.00	T3
862	\N	\N	0.00	20.00	20.00	4	t	f	\N	2023-12-22 12:00:00	\N	0.00	Emporté
864	\N	\N	0.00	5.00	5.00	1	t	f	\N	2023-12-22 12:00:00	\N	0.00	Emporté
865	\N	\N	0.00	5.00	5.00	1	t	f	\N	2023-12-22 12:00:00	\N	0.00	Emporté
867	\N	\N	0.00	5.00	5.00	1	t	f	\N	2023-12-22 12:00:00	\N	0.00	Emporté
868	\N	\N	0.00	20.00	20.00	4	t	f	\N	2023-12-22 12:00:00	\N	0.00	Emporté
870	\N	\N	0.00	25.00	25.00	5	t	f	\N	2023-12-22 12:00:00	\N	0.00	Emporté
871	\N	\N	0.00	5.00	5.00	1	t	f	\N	2023-12-22 12:00:00	\N	0.00	Emporté
873	\N	\N	0.00	5.00	5.00	1	t	f	\N	2023-12-22 12:00:00	\N	0.00	Emporté
874	T14	\N	0.00	20.00	20.00	3	f	f	\N	2023-12-22 12:00:00	\N	0.00	Fred
876	T4	\N	20.00	0.00	20.00	4	f	f	\N	2023-12-22 12:00:00	\N	20.00	T4
877	T2	\N	0.00	10.00	10.00	1	f	f	\N	2023-12-22 12:00:00	\N	0.00	T2
879	\N	\N	0.00	-2.59	-2.59	1	f	t	\N	2023-12-23 12:00:00	\N	0.00	\N
880	\N	\N	-48.21	0.00	-48.21	1	f	t	\N	2023-12-27 12:00:00	\N	0.00	\N
883	\N	\N	-41.00	0.00	-41.00	1	f	t	\N	2023-12-29 12:00:00	\N	0.00	\N
727	T9	\N	208.00	0.00	208.00	7	f	f	\N	2023-11-24 12:00:00	\N	208.00	T9
729	\N	\N	-5.30	0.00	-5.30	7	f	t	\N	2023-11-23 12:00:00	\N	0.00	\N
730	\N	\N	0.00	20.00	20.00	1	t	f	\N	2023-11-24 12:00:00	\N	0.00	Emporté
888	\N	\N	-175.00	0.00	-175.00	1	f	t	\N	2023-12-27 12:00:00	\N	0.00	\N
732	\N	\N	0.00	40.50	40.50	3	t	f	\N	2023-11-24 12:00:00	\N	0.00	Emporté
889	\N	\N	-400.00	0.00	-400.00	1	f	t	\N	2023-12-30 12:00:00	\N	0.00	\N
736	T8	\N	0.00	20.00	20.00	1	f	f	\N	2023-11-24 12:00:00	\N	0.00	T8
738	\N	\N	-45.10	0.00	-45.10	1	f	t	\N	2023-11-25 12:00:00	\N	0.00	\N
739	\N	\N	0.00	-10.30	-10.30	1	f	t	\N	2023-11-25 12:00:00	\N	0.00	\N
891	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-12-22 12:00:00	\N	0.00	\N
742	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-11-25 12:00:00	\N	0.00	\N
892	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2023-12-22 12:00:00	\N	0.00	\N
744	\N	\N	-65.40	0.00	-65.40	4	f	t	\N	2023-11-21 12:00:00	\N	0.00	\N
745	\N	\N	-140.35	0.00	-140.35	1	f	t	\N	2023-12-19 12:00:00	\N	0.00	\N
747	\N	\N	0.00	7.00	7.00	1	t	f	\N	2023-11-29 12:00:00	\N	0.00	Emporté
894	\N	\N	0.00	-240.00	-240.00	1	f	t	\N	2024-01-01 12:00:00	\N	0.00	\N
750	T7	\N	0.00	73.00	73.00	2	f	f	\N	2023-11-29 12:00:00	\N	0.00	Mamy Nicole
753	\N	\N	-2.90	0.00	-2.90	1	f	t	\N	2023-12-01 12:00:00	\N	0.00	\N
1033	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2024-02-09 12:00:00	\N	0.00	\N
756	\N	\N	0.00	-78.00	-78.00	1	f	t	\N	2023-12-01 12:00:00	\N	0.00	\N
759	\N	\N	-40.93	0.00	-40.93	4	f	t	\N	2023-12-01 12:00:00	\N	0.00	\N
762	T14	\N	91.00	0.00	91.00	3	f	f	\N	2023-12-01 12:00:00	\N	91.00	Christophe
765	T5	\N	0.00	120.00	120.00	3	f	f	\N	2023-12-01 12:00:00	\N	0.00	Gene
949	\N	\N	6.00	0.00	6.00	1	t	f	\N	2024-01-19 12:00:00	\N	6.00	Emporté
771	T5	\N	0.00	15.00	15.00	3	f	f	\N	2023-12-01 12:00:00	\N	0.00	Gene
1035	\N	\N	0.00	-66.78	-66.78	1	f	t	\N	2024-02-13 12:00:00	\N	0.00	\N
1036	T9	\N	0.00	42.00	42.00	3	f	f	\N	2024-02-14 12:00:00	\N	0.00	PIPPO
958	\N	\N	-18.93	0.00	-18.93	1	f	t	\N	2024-01-20 12:00:00	\N	0.00	\N
959	\N	\N	0.00	-78.90	-78.90	1	f	t	\N	2024-01-20 12:00:00	\N	0.00	\N
961	\N	\N	0.00	75.00	75.00	5	t	f	\N	2024-01-20 12:00:00	\N	75.00	Emporté
964	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2024-01-20 12:00:00	\N	0.00	\N
965	\N	\N	-239.50	0.00	-239.50	1	f	t	\N	2024-01-08 12:00:00	\N	0.00	\N
967	\N	\N	-59.00	0.00	-59.00	1	f	t	\N	2024-01-22 12:00:00	\N	0.00	\N
968	\N	\N	-25.00	0.00	-25.00	1	f	t	\N	2024-01-16 12:00:00	\N	0.00	\N
1042	\N	\N	-220.00	0.00	-220.00	1	f	t	\N	2024-04-12 12:00:00	\N	0.00	\N
970	\N	\N	-91.16	0.00	-91.16	1	f	t	\N	2024-02-20 12:00:00	\N	0.00	\N
973	T6	\N	16.00	0.00	16.00	1	f	f	\N	2024-01-24 12:00:00	\N	16.00	Marie
974	T12	\N	0.00	0.00	0.00	2	f	f	\N	2024-01-24 12:00:00	\N	0.00	Théo
976	\N	\N	-12.30	0.00	-12.30	1	f	t	\N	2024-01-25 12:00:00	\N	0.00	\N
977	\N	\N	-24.32	0.00	-24.32	1	f	t	\N	2024-01-25 12:00:00	\N	0.00	\N
980	\N	\N	-64.92	0.00	-64.92	1	f	t	\N	2024-01-26 12:00:00	\N	0.00	\N
982	\N	\N	0.00	-13.82	-13.82	1	f	t	\N	2024-01-26 12:00:00	\N	0.00	\N
983	\N	\N	0.00	-20.00	-20.00	1	f	t	\N	2024-01-26 12:00:00	\N	0.00	\N
985	\N	\N	-36.04	0.00	-36.04	1	f	t	\N	2024-01-26 12:00:00	\N	0.00	\N
986	\N	\N	7.00	0.00	7.00	1	t	f	\N	2024-01-26 12:00:00	\N	7.00	Emporté
988	T6	\N	80.00	0.00	80.00	2	f	f	\N	2024-01-26 12:00:00	\N	80.00	T6
989	\N	\N	0.00	75.00	75.00	5	t	f	\N	2024-01-27 12:00:00	\N	75.00	Emporté
992	\N	\N	0.00	-30.00	-30.00	2	f	t	\N	2024-01-26 12:00:00	\N	0.00	\N
995	T7	\N	0.00	91.00	91.00	2	f	f	\N	2024-01-27 12:00:00	\N	0.00	CHEVOLET
997	\N	\N	0.00	45.00	45.00	3	t	f	\N	2024-01-31 12:00:00	\N	0.00	Emporté
998	\N	\N	0.00	30.00	30.00	2	t	f	\N	2024-01-31 12:00:00	\N	0.00	Emporté
1000	\N	\N	0.00	12.00	12.00	1	t	f	\N	2024-02-01 12:00:00	\N	0.00	Emporté
1003	T11	\N	77.00	0.00	77.00	3	f	f	\N	2024-02-01 12:00:00	\N	77.00	T11
1006	\N	\N	-53.07	0.00	-53.07	1	f	t	\N	2024-01-31 12:00:00	\N	0.00	\N
1007	\N	\N	-159.00	0.00	-159.00	1	f	t	\N	2024-02-02 12:00:00	\N	0.00	\N
1009	\N	\N	-14.25	0.00	-14.25	1	f	t	\N	2024-02-01 12:00:00	\N	0.00	\N
1010	\N	\N	0.00	-137.40	-137.40	1	f	t	\N	2024-02-01 12:00:00	\N	0.00	\N
1015	\N	\N	7.00	0.00	7.00	1	t	f	\N	2024-02-07 12:00:00	\N	7.00	Emporté
1018	\N	\N	-363.00	0.00	-363.00	1	f	t	\N	2024-02-05 12:00:00	\N	0.00	\N
1019	\N	\N	-14.00	0.00	-14.00	1	f	t	\N	2024-02-08 12:00:00	\N	0.00	\N
1021	T2	\N	0.00	43.50	43.50	2	f	f	\N	2024-02-08 12:00:00	\N	22.50	2 Nanas
1022	\N	\N	-600.00	0.00	-600.00	2	f	t	\N	2024-02-06 12:00:00	\N	0.00	\N
1024	\N	\N	0.00	-65.40	-65.40	1	f	t	\N	2024-02-09 12:00:00	\N	0.00	\N
1025	\N	\N	0.00	-26.25	-26.25	1	f	t	\N	2024-02-09 12:00:00	\N	0.00	\N
1029	T8	\N	66.00	0.00	66.00	2	f	f	\N	2024-02-09 12:00:00	\N	66.00	Axelle
748	\N	\N	0.00	6.00	6.00	1	t	f	\N	2023-11-29 12:00:00	\N	0.00	Emporté
900	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2024-01-01 12:00:00	\N	0.00	\N
754	\N	\N	-9.36	0.00	-9.36	1	f	t	\N	2023-12-01 12:00:00	\N	0.00	\N
903	\N	\N	-166.36	0.00	-166.36	1	f	t	\N	2024-01-05 12:00:00	\N	0.00	\N
757	\N	\N	7.00	0.00	7.00	1	t	f	\N	2023-12-01 12:00:00	\N	7.00	Emporté
906	T14	\N	20.00	0.00	20.00	1	t	f	\N	2024-01-05 12:00:00	\N	20.00	T14
763	T13	\N	0.00	19.00	19.00	1	f	f	\N	2023-12-01 12:00:00	\N	0.00	Manu
766	T9	\N	0.00	341.50	341.50	8	f	f	\N	2023-12-01 12:00:00	\N	0.00	Mumu
909	T14	\N	0.00	15.00	15.00	1	f	f	\N	2024-01-05 12:00:00	\N	0.00	Marie
769	\N	\N	0.00	2.50	2.50	1	t	f	\N	2023-12-01 12:00:00	\N	2.50	Emporté
1034	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2024-02-10 12:00:00	\N	0.00	\N
772	\N	\N	0.00	-100.00	-100.00	4	f	t	\N	2023-12-01 12:00:00	\N	0.00	\N
912	\N	\N	-29.50	0.00	-29.50	1	f	t	\N	2024-01-06 12:00:00	\N	0.00	\N
1037	T9	\N	0.00	77.00	77.00	3	f	f	\N	2024-02-15 12:00:00	\N	48.00	Leyens
918	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2024-01-02 12:00:00	\N	0.00	\N
921	\N	\N	-253.46	0.00	-253.46	1	f	t	\N	2024-01-09 12:00:00	\N	0.00	\N
1040	\N	\N	-37.49	0.00	-37.49	1	f	t	\N	2024-03-12 12:00:00	\N	0.00	\N
924	T9	\N	67.50	0.00	67.50	2	f	f	\N	2024-01-10 12:00:00	\N	67.50	T9
1041	\N	\N	-58.00	0.00	-58.00	1	f	t	\N	2024-03-12 12:00:00	\N	0.00	\N
927	\N	\N	0.00	-140.00	-140.00	1	f	t	\N	2024-01-10 12:00:00	\N	0.00	\N
1043	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2024-02-16 12:00:00	\N	0.00	\N
933	\N	\N	-13.42	0.00	-13.42	3	f	t	\N	2024-01-12 12:00:00	\N	0.00	\N
1044	\N	\N	0.00	-34.45	-34.45	1	f	t	\N	2024-02-16 12:00:00	\N	0.00	\N
1045	\N	\N	-17.77	0.00	-17.77	1	f	t	\N	2024-02-16 12:00:00	\N	0.00	\N
939	T3	\N	0.00	64.00	64.00	2	f	f	\N	2024-01-13 12:00:00	\N	64.00	T3
942	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2024-01-12 12:00:00	\N	0.00	\N
1046	\N	\N	0.00	15.00	15.00	1	t	f	\N	2024-02-16 12:00:00	\N	15.00	Emporté
945	\N	\N	0.00	-21.81	-21.81	1	f	t	\N	2024-01-19 12:00:00	\N	0.00	\N
948	\N	\N	0.00	-8.51	-8.51	1	f	t	\N	2024-01-19 12:00:00	\N	0.00	\N
1047	T13	\N	25.00	0.00	25.00	1	f	f	\N	2024-02-16 12:00:00	\N	25.00	T13
951	\N	\N	0.00	29.00	29.00	2	t	f	\N	2024-01-19 12:00:00	\N	29.00	Emporté
957	\N	\N	0.00	-50.00	-50.00	4	f	t	\N	2024-01-19 12:00:00	\N	0.00	\N
960	\N	\N	-18.27	0.00	-18.27	1	f	t	\N	2024-01-20 12:00:00	\N	0.00	\N
966	\N	\N	-111.02	0.00	-111.02	1	f	t	\N	2024-01-12 12:00:00	\N	0.00	\N
969	\N	\N	-100.00	0.00	-100.00	1	f	t	\N	2024-01-08 12:00:00	\N	0.00	\N
1052	\N	\N	0.00	-50.00	-50.00	2	f	t	\N	2024-02-16 12:00:00	\N	0.00	\N
975	\N	\N	0.00	-7.00	-7.00	1	f	t	\N	2024-01-25 12:00:00	\N	0.00	\N
1053	\N	\N	0.00	-140.00	-140.00	2	f	t	\N	2024-02-16 12:00:00	\N	0.00	\N
981	\N	\N	0.00	-70.00	-70.00	1	f	t	\N	2024-01-26 12:00:00	\N	0.00	\N
1054	\N	\N	-32.58	0.00	-32.58	1	f	t	\N	2024-02-17 12:00:00	\N	0.00	\N
984	\N	\N	0.00	6.00	6.00	1	t	f	\N	2024-01-26 12:00:00	\N	6.00	Emporté
1055	\N	\N	-76.45	0.00	-76.45	1	f	t	\N	2024-02-17 12:00:00	\N	0.00	\N
993	\N	\N	0.00	-50.00	-50.00	2	f	t	\N	2024-01-27 12:00:00	\N	0.00	\N
1056	\N	\N	-50.00	0.00	-50.00	1	f	f	\N	2024-02-17 12:00:00	\N	-50.00	Dépenses
1057	\N	\N	0.00	-35.00	-35.00	1	f	t	\N	2024-02-17 12:00:00	\N	0.00	\N
1002	T9	\N	88.00	0.00	88.00	4	f	f	\N	2024-02-01 12:00:00	\N	88.00	T9
1058	\N	\N	0.00	-35.00	-35.00	1	f	t	\N	2024-02-16 12:00:00	\N	0.00	\N
1005	\N	\N	-53.07	0.00	-53.07	1	f	t	\N	2024-02-01 12:00:00	\N	0.00	\N
1008	\N	\N	-24.51	0.00	-24.51	1	f	t	\N	2024-02-01 12:00:00	\N	0.00	\N
1059	\N	\N	0.00	-20.00	-20.00	1	f	t	\N	2024-02-15 12:00:00	\N	0.00	\N
1011	T12	\N	61.00	0.00	61.00	2	f	f	\N	2024-02-02 12:00:00	\N	61.00	T12
1014	\N	\N	-11.36	0.00	-11.36	1	f	t	\N	2024-02-02 12:00:00	\N	0.00	\N
1061	\N	\N	0.00	6.00	6.00	1	t	f	\N	2024-02-21 12:00:00	\N	6.00	Emporté
1020	T9	\N	0.00	33.00	33.00	2	f	f	\N	2024-02-08 12:00:00	\N	18.00	UK
1023	\N	\N	-290.95	0.00	-290.95	1	f	t	\N	2024-02-09 12:00:00	\N	0.00	\N
1062	\N	\N	0.00	6.00	6.00	1	t	f	\N	2024-02-22 12:00:00	\N	6.00	Emporté
1063	\N	\N	-17.49	0.00	-17.49	1	f	t	\N	2024-02-22 12:00:00	\N	0.00	\N
1064	\N	\N	12.00	0.00	12.00	2	t	f	\N	2024-02-23 12:00:00	\N	12.00	Emporté
1068	\N	\N	0.00	18.00	18.00	3	t	f	\N	2024-02-23 12:00:00	\N	18.00	Emporté
1070	\N	\N	0.00	-20.00	-20.00	1	f	t	\N	2024-02-23 12:00:00	\N	0.00	\N
1071	\N	\N	0.00	-50.00	-50.00	4	f	t	\N	2024-02-23 12:00:00	\N	0.00	\N
1072	\N	\N	0.00	-25.00	-25.00	1	f	t	\N	2024-02-23 12:00:00	\N	0.00	\N
1074	\N	\N	0.00	15.00	15.00	1	t	f	\N	2024-02-24 12:00:00	\N	0.00	Emporté
1421	\N	\N	-89.00	0.00	-89.00	1	f	t	\N	2024-05-07 12:00:00	\N	0.00	\N
1076	T4	\N	101.00	0.00	101.00	3	f	f	\N	2024-02-24 12:00:00	\N	101.00	Reumont
1079	T14	\N	87.00	0.00	87.00	3	f	f	\N	2024-02-24 12:00:00	\N	87.00	Occupé
1423	\N	\N	0.00	13.00	13.00	2	t	f	\N	2024-05-09 12:00:00	\N	0.00	Emporté
1082	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2024-02-24 12:00:00	\N	0.00	\N
1085	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-02-21 12:00:00	\N	0.00	\N
1426	T2	\N	0.00	56.00	56.00	2	f	f	\N	2024-05-10 12:00:00	\N	0.00	ALVIN
1088	\N	\N	-400.00	0.00	-400.00	1	f	t	\N	2024-02-19 12:00:00	\N	0.00	\N
1091	\N	\N	-19.73	0.00	-19.73	1	f	t	\N	2024-02-17 12:00:00	\N	0.00	\N
1097	\N	\N	0.00	30.00	30.00	2	t	f	\N	2024-03-02 12:00:00	\N	0.00	Emporté
1100	\N	\N	-446.06	0.00	-446.06	1	f	t	\N	2024-02-29 12:00:00	\N	0.00	\N
1103	\N	\N	0.00	6.00	6.00	1	t	f	\N	2024-03-07 12:00:00	\N	0.00	Emporté
1109	T7	\N	0.00	62.50	62.50	2	f	f	\N	2024-03-08 12:00:00	\N	0.00	FOERSTER
1438	T15	\N	0.00	20.00	20.00	1	t	f	\N	2024-05-10 12:00:00	\N	0.00	Steph
1112	\N	\N	0.00	-30.00	-30.00	1	f	t	\N	2024-03-08 12:00:00	\N	0.00	\N
1441	\N	\N	-10.00	0.00	-10.00	1	f	t	\N	2024-05-11 12:00:00	\N	0.00	\N
1118	T5	\N	116.00	0.00	116.00	4	f	f	\N	2024-03-08 12:00:00	\N	116.00	Foerster
1444	T13	\N	0.00	225.00	225.00	2	f	f	\N	2024-05-11 12:00:00	\N	0.00	Stephane
1124	\N	\N	-32.45	0.00	-32.45	1	f	t	\N	2024-03-09 12:00:00	\N	0.00	\N
1127	\N	\N	-16.55	0.00	-16.55	1	f	t	\N	2024-03-07 12:00:00	\N	0.00	\N
1130	\N	\N	-47.19	0.00	-47.19	1	f	t	\N	2024-03-08 12:00:00	\N	0.00	\N
1133	\N	\N	0.00	30.00	30.00	2	t	f	\N	2024-03-02 12:00:00	\N	0.00	Emporté
1450	\N	\N	-15.00	0.00	-15.00	1	f	t	\N	2024-05-14 12:00:00	\N	0.00	\N
1136	\N	\N	0.00	-30.00	-30.00	1	f	t	\N	2024-03-09 12:00:00	\N	0.00	\N
1139	T3	\N	109.50	0.00	109.50	3	f	f	\N	2024-03-09 12:00:00	\N	109.50	Aurélien
1453	\N	\N	-79.30	0.00	-79.30	1	f	t	\N	2024-05-13 12:00:00	\N	0.00	\N
1142	T14	\N	0.00	19.00	19.00	1	t	f	\N	2024-03-09 12:00:00	\N	0.00	T14
1145	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2024-03-01 12:00:00	\N	0.00	\N
1456	T5	\N	45.00	0.00	45.00	2	f	f	\N	2024-05-14 12:00:00	\N	45.00	T5
1148	\N	\N	40.00	0.00	40.00	4	t	f	\N	2024-03-14 12:00:00	\N	40.00	Emporté
1151	\N	\N	-14.07	0.00	-14.07	1	f	t	\N	2024-03-15 12:00:00	\N	0.00	\N
1459	T3	\N	0.00	8.00	8.00	1	t	f	\N	2024-05-14 12:00:00	\N	0.00	MANU
1154	T9	\N	65.00	0.00	65.00	2	f	f	\N	2024-03-15 12:00:00	\N	65.00	Dineur
1157	\N	\N	0.00	-16.48	-16.48	1	f	t	\N	2024-03-15 12:00:00	\N	0.00	\N
1462	T8	\N	0.00	165.00	165.00	9	f	f	\N	2024-05-14 12:00:00	\N	0.00	FILOU PLATS
1465	T14	\N	0.00	91.00	91.00	1	f	f	\N	2024-05-14 12:00:00	\N	0.00	APERO FILOU
1468	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-05-14 12:00:00	\N	0.00	\N
1474	T8	\N	79.00	0.00	79.00	1	f	f	\N	2024-05-15 12:00:00	\N	79.00	Daniel
1477	\N	\N	-20.00	0.00	-20.00	1	f	t	\N	2024-05-07 12:00:00	\N	0.00	\N
1480	\N	\N	-10.00	0.00	-10.00	1	f	t	\N	2024-05-16 12:00:00	\N	0.00	\N
1483	\N	\N	0.00	6.00	6.00	1	t	f	\N	2024-05-17 12:00:00	\N	0.00	Emporté
1486	\N	\N	-3.05	0.00	-3.05	1	f	t	\N	2024-05-17 12:00:00	\N	0.00	\N
1489	T15	\N	28.00	0.00	28.00	1	f	f	\N	2024-05-17 12:00:00	\N	28.00	Manu
1492	T16	\N	0.00	33.00	33.00	1	f	f	\N	2024-05-17 12:00:00	\N	0.00	T16
1495	T8	\N	0.00	154.50	154.50	3	f	f	\N	2024-05-17 12:00:00	\N	0.00	Jamard
1498	\N	\N	-51.20	0.00	-51.20	1	f	t	\N	2024-05-18 12:00:00	\N	0.00	\N
1501	\N	\N	-16.57	0.00	-16.57	1	f	t	\N	2024-05-10 12:00:00	\N	0.00	\N
1513	\N	\N	-75.00	0.00	-75.00	1	f	t	\N	2024-05-18 12:00:00	\N	0.00	\N
1516	T13	\N	0.00	10.00	10.00	1	f	f	\N	2024-05-22 12:00:00	\N	0.00	T13
1522	\N	\N	0.00	2.50	2.50	1	t	f	\N	2024-05-23 12:00:00	\N	0.00	Emporté
1525	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2024-05-22 12:00:00	\N	0.00	\N
1528	\N	\N	0.00	0.00	0.00	1	t	f	\N	2024-05-24 12:00:00	\N	0.00	Emporté
1531	T14	\N	0.00	0.00	0.00	1	f	f	\N	2024-05-24 12:00:00	\N	0.00	JM
1534	\N	\N	0.00	30.00	30.00	2	t	f	\N	2024-05-24 12:00:00	\N	0.00	Emporté
1537	T8	\N	87.00	0.00	87.00	2	f	f	\N	2024-05-24 12:00:00	\N	87.00	Lambrechts
1540	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2024-05-24 12:00:00	\N	0.00	\N
1543	\N	\N	30.00	0.00	30.00	2	t	f	\N	2024-05-29 12:00:00	\N	30.00	Emporté
1546	\N	\N	-61.35	0.00	-61.35	1	f	t	\N	2024-05-29 12:00:00	\N	0.00	\N
1681	\N	\N	-22.66	0.00	-22.66	1	f	t	\N	2024-06-22 12:00:00	\N	0.00	\N
1682	T12	\N	0.00	40.00	40.00	2	f	f	\N	2024-06-22 12:00:00	\N	0.00	0492315792
1684	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2024-06-22 12:00:00	\N	0.00	\N
1685	\N	\N	-122.00	0.00	-122.00	1	f	t	\N	2024-06-25 12:00:00	\N	0.00	\N
1687	T2	\N	0.00	91.00	91.00	2	f	f	\N	2024-06-26 12:00:00	\N	91.00	T2
1688	T10	\N	0.00	81.50	81.50	2	f	f	\N	2024-06-26 12:00:00	\N	81.50	FILOU
1690	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-06-26 12:00:00	\N	0.00	\N
1691	T12	\N	47.00	0.00	47.00	2	f	f	\N	2024-06-26 12:00:00	\N	47.00	2 NANAS
1693	T11	\N	0.00	20.00	20.00	1	f	f	\N	2024-06-26 12:00:00	\N	20.00	JEAN-MARIE
1694	T2	\N	0.00	44.00	44.00	2	f	f	\N	2024-06-27 12:00:00	\N	0.00	CHARLOTTE
1696	T9	\N	0.00	73.50	73.50	4	f	f	\N	2024-06-27 12:00:00	\N	73.50	4 NANAS
1697	T14	\N	0.00	24.00	24.00	1	f	f	\N	2024-06-27 12:00:00	\N	0.00	JEANMA
1699	\N	\N	-70.00	0.00	-70.00	1	f	t	\N	2024-06-27 12:00:00	\N	0.00	\N
1700	\N	\N	-25.04	0.00	-25.04	1	f	t	\N	2024-06-27 12:00:00	\N	0.00	\N
1702	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-06-27 12:00:00	\N	0.00	\N
1703	\N	\N	-20.00	0.00	-20.00	1	f	t	\N	2024-06-11 12:00:00	\N	0.00	\N
1705	\N	\N	-10.00	0.00	-10.00	1	f	t	\N	2024-06-13 12:00:00	\N	0.00	\N
1706	\N	\N	0.00	6.00	6.00	1	t	f	\N	2024-06-28 12:00:00	\N	0.00	Emporté
1081	T9	\N	0.00	76.00	76.00	2	f	f	\N	2024-02-24 12:00:00	\N	0.00	Morati
1083	\N	\N	0.00	-30.00	-30.00	1	f	t	\N	2024-02-24 12:00:00	\N	0.00	\N
1084	\N	\N	-36.00	0.00	-36.00	1	f	t	\N	2024-02-24 12:00:00	\N	0.00	\N
1086	\N	\N	-226.84	0.00	-226.84	1	f	t	\N	2024-02-24 12:00:00	\N	0.00	\N
1087	\N	\N	-54.00	0.00	-54.00	1	f	t	\N	2024-02-20 12:00:00	\N	0.00	\N
1089	\N	\N	-146.25	0.00	-146.25	1	f	t	\N	2024-03-09 12:00:00	\N	0.00	\N
1090	\N	\N	-73.50	0.00	-73.50	1	f	t	\N	2024-03-04 12:00:00	\N	0.00	\N
1092	\N	\N	-21.00	0.00	-21.00	1	f	t	\N	2024-02-29 12:00:00	\N	0.00	\N
1093	\N	\N	-8.10	0.00	-8.10	1	f	t	\N	2024-02-29 12:00:00	\N	0.00	\N
1095	\N	\N	-105.03	0.00	-105.03	1	f	t	\N	2024-03-01 12:00:00	\N	0.00	\N
1096	\N	\N	0.00	-66.00	-66.00	1	f	t	\N	2024-03-01 12:00:00	\N	0.00	\N
1098	\N	\N	-41.53	0.00	-41.53	1	f	t	\N	2024-03-02 12:00:00	\N	0.00	\N
1099	T13	\N	0.00	69.50	69.50	3	f	f	\N	2024-03-02 12:00:00	\N	0.00	MANU
1101	\N	\N	0.00	-27.00	-27.00	1	f	t	\N	2024-03-07 12:00:00	\N	0.00	\N
1102	\N	\N	-27.77	0.00	-27.77	1	f	t	\N	2024-03-07 12:00:00	\N	0.00	\N
1105	\N	\N	0.00	4.00	4.00	1	t	f	\N	2024-03-07 12:00:00	\N	4.00	Emporté
1108	T4	\N	0.00	58.00	58.00	4	f	f	\N	2024-03-08 12:00:00	\N	0.00	T4
1111	\N	\N	0.00	162.00	162.00	18	t	f	\N	2024-03-08 12:00:00	\N	0.00	Emporté
1113	\N	\N	0.00	-18.75	-18.75	1	f	t	\N	2024-03-08 12:00:00	\N	0.00	\N
1116	\N	\N	0.00	30.00	30.00	2	t	f	\N	2024-03-08 12:00:00	\N	0.00	Emporté
1117	T12	\N	72.50	0.00	72.50	2	f	f	\N	2024-03-08 12:00:00	\N	72.50	Defays
1119	\N	\N	0.00	10.00	10.00	1	t	f	\N	2024-03-08 12:00:00	\N	10.00	Emporté
1125	\N	\N	-54.20	0.00	-54.20	1	f	t	\N	2024-03-09 12:00:00	\N	0.00	\N
1126	\N	\N	-9.70	0.00	-9.70	1	f	t	\N	2024-03-09 12:00:00	\N	0.00	\N
1128	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2024-03-08 12:00:00	\N	0.00	\N
1129	\N	\N	0.00	-19.00	-19.00	1	f	t	\N	2024-03-08 12:00:00	\N	0.00	\N
1131	\N	\N	0.00	-313.80	-313.80	1	f	t	\N	2024-03-08 12:00:00	\N	0.00	\N
1132	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2024-03-08 12:00:00	\N	0.00	\N
1134	\N	\N	0.00	-40.00	-40.00	1	f	t	\N	2024-03-08 12:00:00	\N	0.00	\N
1135	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2024-03-09 12:00:00	\N	0.00	\N
1137	T7	\N	0.00	93.00	93.00	3	f	f	\N	2024-03-09 12:00:00	\N	0.00	Suisse
1140	T10	\N	337.00	0.00	337.00	8	f	f	\N	2024-03-09 12:00:00	\N	337.00	LOIC
1141	\N	\N	15.00	0.00	15.00	1	t	f	\N	2024-03-09 12:00:00	\N	15.00	Emporté
1143	\N	\N	-210.64	0.00	-210.64	1	f	t	\N	2024-04-04 12:00:00	\N	0.00	\N
1144	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2024-03-12 12:00:00	\N	0.00	\N
1146	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2024-03-02 12:00:00	\N	0.00	\N
1147	T11	\N	0.00	48.50	48.50	2	f	f	\N	2024-03-13 12:00:00	\N	0.00	Cointe
1149	T12	\N	41.00	0.00	41.00	2	f	f	\N	2024-03-14 12:00:00	\N	41.00	T12
1150	T14	\N	0.00	33.00	33.00	1	f	f	\N	2024-03-14 12:00:00	\N	0.00	Francois
1152	\N	\N	0.00	-186.00	-186.00	1	f	t	\N	2024-03-15 12:00:00	\N	0.00	\N
1153	T2	\N	33.00	0.00	33.00	2	f	f	\N	2024-03-15 12:00:00	\N	33.00	Nanas
1155	\N	\N	0.00	-56.55	-56.55	2	f	t	\N	2024-03-15 12:00:00	\N	0.00	\N
1156	\N	\N	-37.55	0.00	-37.55	1	f	t	\N	2024-03-15 12:00:00	\N	0.00	\N
1158	T7	\N	54.50	0.00	54.50	3	f	f	\N	2024-03-15 12:00:00	\N	54.50	Enfant voisin
1159	T4	\N	50.00	0.00	50.00	2	f	f	\N	2024-03-15 12:00:00	\N	50.00	Joyeux
1160	T2	\N	0.00	88.50	88.50	3	f	f	\N	2024-03-15 12:00:00	\N	0.00	3
1161	T12	\N	0.00	75.50	75.50	2	f	f	\N	2024-03-15 12:00:00	\N	0.00	PIERRET
1162	T10	\N	59.00	0.00	59.00	3	f	f	\N	2024-03-15 12:00:00	\N	59.00	Duchateau
1163	\N	\N	7.00	0.00	7.00	1	t	f	\N	2024-03-15 12:00:00	\N	7.00	Emporté
1164	T8	\N	0.00	96.50	96.50	2	f	f	\N	2024-03-15 12:00:00	\N	0.00	2
1165	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2024-03-15 12:00:00	\N	0.00	\N
1166	\N	\N	0.00	-30.00	-30.00	1	f	t	\N	2024-03-15 12:00:00	\N	0.00	\N
1167	\N	\N	-28.09	0.00	-28.09	1	f	t	\N	2024-03-16 12:00:00	\N	0.00	\N
1168	\N	\N	-10.25	0.00	-10.25	1	f	t	\N	2024-03-16 12:00:00	\N	0.00	\N
1169	\N	\N	-35.56	0.00	-35.56	1	f	t	\N	2024-03-16 12:00:00	\N	0.00	\N
1171	T4	\N	42.00	0.00	42.00	2	f	f	\N	2024-03-16 12:00:00	\N	42.00	Cop celia
1175	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2024-03-16 12:00:00	\N	0.00	\N
1176	\N	\N	0.00	-15.00	-15.00	1	f	t	\N	2024-03-16 12:00:00	\N	0.00	\N
1177	\N	\N	-40.00	-40.00	-40.00	1	f	t	\N	2024-03-16 12:00:00	\N	0.00	\N
1179	\N	\N	-40.00	-40.00	-40.00	4	f	t	\N	2024-03-16 12:00:00	\N	0.00	\N
1180	\N	\N	-14.68	0.00	-14.68	1	f	t	\N	2024-03-20 12:00:00	\N	0.00	\N
1181	\N	\N	-3.98	0.00	-3.98	1	f	t	\N	2024-03-20 12:00:00	\N	0.00	\N
1182	\N	\N	-78.00	0.00	-78.00	1	f	t	\N	2024-03-20 12:00:00	\N	0.00	\N
1184	T2	\N	0.00	76.00	76.00	2	f	f	\N	2024-03-20 12:00:00	\N	0.00	Manu
1185	T8	\N	182.00	0.00	182.00	4	f	f	\N	2024-03-20 12:00:00	\N	182.00	T8
1186	\N	\N	-25.00	-25.00	-25.00	1	f	t	\N	2024-03-20 12:00:00	\N	0.00	\N
1187	\N	\N	-24.52	0.00	-24.52	1	f	t	\N	2024-03-21 12:00:00	\N	0.00	\N
1188	\N	\N	-148.17	0.00	-148.17	1	f	t	\N	2024-03-21 12:00:00	\N	0.00	\N
1189	\N	\N	-172.80	0.00	-172.80	1	f	t	\N	2024-03-07 12:00:00	\N	0.00	\N
1190	\N	\N	-59.80	0.00	-59.80	1	f	t	\N	2024-03-07 12:00:00	\N	0.00	\N
1191	\N	\N	-107.70	0.00	-107.70	1	f	t	\N	2024-03-08 12:00:00	\N	0.00	\N
1192	\N	\N	-28.00	0.00	-28.00	1	f	t	\N	2024-03-18 12:00:00	\N	0.00	\N
1752	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2024-07-11 12:00:00	\N	0.00	\N
1193	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2024-03-18 12:00:00	\N	0.00	\N
1195	\N	\N	0.00	-120.00	-120.00	1	f	t	\N	2024-03-21 12:00:00	\N	0.00	\N
1424	\N	\N	-33.34	0.00	-33.34	1	f	t	\N	2024-05-09 12:00:00	\N	0.00	\N
1425	\N	\N	0.00	-75.00	-75.00	1	f	t	\N	2024-05-09 12:00:00	\N	0.00	\N
1201	\N	\N	0.00	15.00	15.00	1	t	f	\N	2024-03-22 12:00:00	\N	0.00	Emporté
1204	T9	\N	55.00	0.00	55.00	2	f	f	\N	2024-03-22 12:00:00	\N	55.00	T9
1427	T3	\N	41.50	0.00	41.50	1	t	f	\N	2024-05-10 12:00:00	\N	41.50	MANU
1207	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-03-21 12:00:00	\N	0.00	\N
1428	T9	\N	0.00	94.50	94.50	4	f	f	\N	2024-05-10 12:00:00	\N	0.00	T9
1210	T3	\N	0.00	60.00	60.00	2	f	f	\N	2024-03-21 12:00:00	\N	0.00	marocain
1213	\N	\N	0.00	-25.00	-25.00	2	f	t	\N	2024-03-21 12:00:00	\N	0.00	\N
1216	\N	\N	-166.36	0.00	-166.36	2	f	t	\N	2024-04-09 12:00:00	\N	0.00	\N
1431	\N	\N	0.00	0.00	-30.00	1	f	t	\N	2024-05-10 12:00:00	\N	0.00	\N
1219	\N	\N	-11.85	0.00	-11.85	1	f	t	\N	2024-03-23 12:00:00	\N	0.00	\N
1222	T8	\N	0.00	61.00	61.00	4	f	f	\N	2024-03-23 12:00:00	\N	0.00	JONET
1433	\N	\N	0.00	12.00	12.00	2	t	f	\N	2024-05-10 12:00:00	\N	0.00	Emporté
1225	T4	\N	108.00	0.00	108.00	4	f	f	\N	2024-03-23 12:00:00	\N	108.00	HANNON
1434	T8	\N	0.00	50.00	50.00	2	f	f	\N	2024-05-10 12:00:00	\N	0.00	Mangon
1231	\N	\N	0.00	-25.00	-25.00	1	f	t	\N	2024-03-22 12:00:00	\N	0.00	\N
1436	T2	\N	0.00	87.50	87.50	3	f	f	\N	2024-05-10 12:00:00	\N	0.00	Kris
1234	\N	\N	-34.03	0.00	-34.03	1	f	t	\N	2024-03-26 12:00:00	\N	0.00	\N
1237	T11	\N	0.00	2.50	2.50	1	f	f	\N	2024-03-26 12:00:00	\N	0.00	MANU
1240	\N	\N	-31.49	0.00	-31.49	1	f	t	\N	2024-03-27 12:00:00	\N	0.00	\N
1439	\N	\N	0.00	0.00	-70.00	1	f	t	\N	2024-05-10 12:00:00	\N	0.00	\N
1243	T15	\N	7.50	0.00	7.50	1	t	f	\N	2024-03-26 12:00:00	\N	7.50	Steph
1440	\N	\N	-48.96	0.00	-48.96	1	f	t	\N	2024-05-11 12:00:00	\N	0.00	\N
1246	\N	\N	-9.44	0.00	-9.44	1	f	t	\N	2024-03-27 12:00:00	\N	0.00	\N
1249	T5	\N	100.00	78.00	178.00	9	f	f	\N	2024-03-27 12:00:00	\N	178.00	DORSAN
1442	\N	\N	-10.00	0.00	-10.00	1	f	t	\N	2024-05-11 12:00:00	\N	0.00	\N
1252	\N	\N	0.00	-40.00	-40.00	10	f	t	\N	2024-03-27 12:00:00	\N	0.00	\N
1255	\N	\N	-9.56	0.00	-9.56	1	f	t	\N	2024-03-29 12:00:00	\N	0.00	\N
1258	T6	\N	0.00	85.00	85.00	2	f	f	\N	2024-03-29 12:00:00	\N	0.00	Hannon
1445	\N	\N	0.00	45.00	45.00	3	t	f	\N	2024-05-11 12:00:00	\N	0.00	Emporté
1261	T14	\N	0.00	94.00	94.00	3	f	f	\N	2024-03-29 12:00:00	\N	94.00	Ghislain
1264	\N	\N	0.00	-40.00	-40.00	1	f	t	\N	2024-03-29 12:00:00	\N	0.00	\N
1267	\N	\N	0.00	1980.00	1980.00	1	t	f	\N	2024-03-30 12:00:00	\N	0.00	Emporté
1448	\N	\N	0.00	0.00	-60.00	1	f	t	\N	2024-05-11 12:00:00	\N	0.00	\N
1270	T4	\N	50.00	0.00	50.00	2	f	f	\N	2024-04-03 12:00:00	\N	50.00	T4
1449	T7	\N	21.00	0.00	21.00	1	f	f	\N	2024-05-11 12:00:00	\N	21.00	T7
1273	T14	\N	0.00	35.00	35.00	1	t	f	\N	2024-04-03 12:00:00	\N	0.00	T14
1276	\N	\N	-20.90	0.00	-20.90	1	f	t	\N	2024-04-03 12:00:00	\N	0.00	\N
1451	\N	\N	-70.00	0.00	-70.00	1	f	t	\N	2024-05-14 12:00:00	\N	0.00	\N
1279	T14	\N	0.00	10.00	10.00	1	t	f	\N	2024-04-04 12:00:00	\N	0.00	Manu
1452	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-05-14 12:00:00	\N	0.00	\N
1282	\N	\N	-29.90	0.00	-29.90	1	f	t	\N	2024-04-05 12:00:00	\N	0.00	\N
1285	\N	\N	-170.00	0.00	-170.00	1	f	t	\N	2024-04-05 12:00:00	\N	0.00	\N
1454	\N	\N	0.00	0.00	-20.00	1	f	t	\N	2024-05-11 12:00:00	\N	0.00	\N
1288	\N	\N	0.00	-20.00	-20.00	3	f	t	\N	2024-04-05 12:00:00	\N	0.00	\N
1455	\N	\N	0.00	30.00	30.00	1	t	f	\N	2024-05-14 12:00:00	\N	0.00	Emporté
1457	T5	\N	0.00	2.50	2.50	1	f	f	\N	2024-05-14 12:00:00	\N	0.00	T5
1458	T5	\N	0.00	7.50	7.50	1	f	f	\N	2024-05-14 12:00:00	\N	0.00	MONSIEUR X
1460	T15	\N	26.00	0.00	26.00	1	f	f	\N	2024-05-14 12:00:00	\N	26.00	Daniel
1461	T11	\N	0.00	255.50	255.50	1	f	f	\N	2024-05-14 12:00:00	\N	0.00	BOISSONS
1463	T15	\N	17.00	0.00	17.00	1	f	f	\N	2024-05-14 12:00:00	\N	17.00	Daniel
1466	T12	\N	0.00	29.00	29.00	1	f	f	\N	2024-05-14 12:00:00	\N	0.00	T12
1467	\N	\N	-76.00	0.00	-76.00	1	f	t	\N	2024-05-15 12:00:00	\N	0.00	\N
1469	T9	\N	25.80	0.00	25.80	1	f	f	\N	2024-05-15 12:00:00	\N	25.80	Demoiselle
1470	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2024-05-15 12:00:00	\N	0.00	\N
1472	T12	\N	42.50	0.00	42.50	1	f	f	\N	2024-05-15 12:00:00	\N	42.50	T12
1473	T11	\N	12.50	0.00	12.50	1	f	f	\N	2024-05-15 12:00:00	\N	12.50	T11
1476	\N	\N	0.00	12.00	12.00	2	t	f	\N	2024-05-17 12:00:00	\N	0.00	Emporté
1478	\N	\N	-10.00	0.00	-10.00	1	f	t	\N	2024-05-10 12:00:00	\N	0.00	\N
1479	\N	\N	-20.00	0.00	-20.00	1	f	t	\N	2024-05-15 12:00:00	\N	0.00	\N
1481	\N	\N	-10.00	0.00	-10.00	1	f	t	\N	2024-05-17 12:00:00	\N	0.00	\N
1482	T6	\N	0.00	49.00	49.00	2	f	f	\N	2024-05-17 12:00:00	\N	0.00	TOULOUSE
1484	T11	\N	57.00	0.00	57.00	2	f	f	\N	2024-05-17 12:00:00	\N	57.00	Ouvriers
1485	T14	\N	0.00	10.00	10.00	1	f	f	\N	2024-05-17 12:00:00	\N	0.00	Christophe
1487	\N	\N	-2.60	0.00	-2.60	1	f	t	\N	2024-05-17 12:00:00	\N	0.00	\N
1488	\N	\N	-64.54	0.00	-64.54	1	f	t	\N	2024-05-17 12:00:00	\N	0.00	\N
1490	T14	\N	20.00	0.00	20.00	1	f	f	\N	2024-05-17 12:00:00	\N	20.00	Christophe
1491	T13	\N	0.00	104.00	104.00	4	f	f	\N	2024-05-17 12:00:00	\N	0.00	Français
1493	T9	\N	76.00	266.50	342.50	9	f	f	\N	2024-05-17 12:00:00	\N	76.00	Chloe
1494	T3	\N	0.00	181.00	181.00	4	f	f	\N	2024-05-17 12:00:00	\N	0.00	Romain
1496	\N	\N	-382.00	0.00	-382.00	1	f	t	\N	2024-05-15 12:00:00	\N	0.00	\N
1497	\N	\N	-48.34	0.00	-48.34	1	f	t	\N	2024-05-18 12:00:00	\N	0.00	\N
1499	\N	\N	-47.45	0.00	-47.45	1	f	t	\N	2024-05-18 12:00:00	\N	0.00	\N
1500	\N	\N	-13.12	0.00	-13.12	1	f	t	\N	2024-05-15 12:00:00	\N	0.00	\N
1502	\N	\N	-5.70	0.00	-5.70	1	f	t	\N	2024-05-16 12:00:00	\N	0.00	\N
1503	\N	\N	-31.59	0.00	-31.59	1	f	t	\N	2024-05-15 12:00:00	\N	0.00	\N
1505	T2	\N	38.00	0.00	38.00	2	f	f	\N	2024-05-18 12:00:00	\N	38.00	BEATRICE
1506	\N	\N	0.00	10.00	10.00	1	t	f	\N	2024-05-18 12:00:00	\N	0.00	Emporté
1508	T3	\N	56.50	0.00	56.50	3	f	f	\N	2024-05-18 12:00:00	\N	56.50	Barrato
1194	\N	\N	-211.75	0.00	-211.75	1	f	t	\N	2024-03-18 12:00:00	\N	0.00	\N
1196	\N	\N	-163.70	0.00	-163.70	1	f	t	\N	2024-03-21 12:00:00	\N	0.00	\N
1511	T9	\N	0.00	211.50	211.50	5	f	f	\N	2024-05-18 12:00:00	\N	0.00	Francis ADAM
1199	\N	\N	-64.79	0.00	-64.79	1	f	t	\N	2024-03-22 12:00:00	\N	0.00	\N
1200	\N	\N	-26.88	0.00	-26.88	1	f	t	\N	2024-03-22 12:00:00	\N	0.00	\N
1512	\N	\N	-75.00	0.00	-75.00	1	f	t	\N	2024-05-17 12:00:00	\N	0.00	\N
1202	T11	\N	32.30	0.00	32.30	2	f	f	\N	2024-03-22 12:00:00	\N	32.30	T11
1203	T8	\N	76.00	0.00	76.00	3	f	f	\N	2024-03-22 12:00:00	\N	76.00	T8
1205	T4	\N	61.00	0.00	61.00	2	f	f	\N	2024-03-22 12:00:00	\N	61.00	T4
1206	\N	\N	0.00	14.00	14.00	1	t	f	\N	2024-03-22 12:00:00	\N	0.00	Emporté
1514	T9	\N	49.50	0.00	49.50	2	f	f	\N	2024-05-22 12:00:00	\N	49.50	T9
1515	T13	\N	0.00	39.00	39.00	1	f	f	\N	2024-05-22 12:00:00	\N	0.00	T13
1211	\N	\N	-8.71	0.00	-8.71	1	f	t	\N	2024-03-21 12:00:00	\N	0.00	\N
1214	\N	\N	0.00	-40.00	-40.00	2	f	t	\N	2024-03-21 12:00:00	\N	0.00	\N
1517	T7	\N	0.00	24.00	24.00	1	f	f	\N	2024-05-22 12:00:00	\N	0.00	T7
1217	T11	\N	0.00	60.00	60.00	2	f	f	\N	2024-03-22 12:00:00	\N	0.00	T11
1518	T7	\N	24.00	0.00	24.00	1	f	f	\N	2024-05-22 12:00:00	\N	24.00	T7
1220	\N	\N	-7.00	0.00	-7.00	1	f	t	\N	2024-03-23 12:00:00	\N	0.00	\N
1223	T12	\N	0.00	10.00	10.00	1	f	f	\N	2024-03-23 12:00:00	\N	0.00	DIDIER
1520	\N	\N	-8.69	0.00	-8.69	1	f	t	\N	2024-05-22 12:00:00	\N	0.00	\N
1226	T9	\N	120.00	0.00	120.00	4	f	f	\N	2024-03-23 12:00:00	\N	120.00	MAUDOUX
1229	\N	\N	0.00	-30.00	-30.00	1	f	t	\N	2024-03-23 12:00:00	\N	0.00	\N
1232	\N	\N	-111.00	0.00	-111.00	1	f	t	\N	2024-03-26 12:00:00	\N	0.00	\N
1523	T2	\N	0.00	0.00	0.00	2	f	f	\N	2024-05-23 12:00:00	\N	0.00	VOISINE RALEUSE
1235	T11	\N	96.50	0.00	96.50	4	f	f	\N	2024-03-26 12:00:00	\N	96.50	MANU
1238	T12	\N	0.00	10.00	10.00	1	f	f	\N	2024-03-26 12:00:00	\N	0.00	FRED
1241	T13	\N	0.00	64.00	64.00	4	f	f	\N	2024-03-26 12:00:00	\N	0.00	Angèle
1526	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-05-23 12:00:00	\N	0.00	\N
1244	\N	\N	45.00	0.00	45.00	1	t	f	\N	2024-03-26 12:00:00	\N	45.00	Emporté
1527	\N	\N	0.00	18.00	18.00	1	t	f	\N	2024-05-24 12:00:00	\N	0.00	Emporté
1247	\N	\N	-78.00	0.00	-78.00	1	f	t	\N	2024-03-27 12:00:00	\N	0.00	\N
1250	\N	\N	0.00	-50.00	-50.00	10	f	t	\N	2024-03-26 12:00:00	\N	0.00	\N
1253	\N	\N	0.00	-30.00	-30.00	10	f	t	\N	2024-03-27 12:00:00	\N	0.00	\N
1530	T3	\N	0.00	130.00	130.00	2	f	f	\N	2024-05-24 12:00:00	\N	0.00	COPAIN DANIEL
1256	\N	\N	-3.49	0.00	-3.49	1	f	t	\N	2024-03-29 12:00:00	\N	0.00	\N
1259	T10	\N	0.00	100.00	100.00	3	f	f	\N	2024-03-29 12:00:00	\N	0.00	célia
1532	\N	\N	-25.00	0.00	-25.00	1	f	t	\N	2024-05-24 12:00:00	\N	0.00	\N
1262	\N	\N	0.00	-50.00	-50.00	3	f	t	\N	2024-03-29 12:00:00	\N	0.00	\N
1533	T2	\N	15.00	0.00	15.00	1	f	f	\N	2024-05-24 12:00:00	\N	15.00	T2
1265	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2024-03-29 12:00:00	\N	0.00	\N
1268	\N	\N	-400.00	0.00	-400.00	1	f	t	\N	2024-03-30 12:00:00	\N	0.00	\N
1271	T11	\N	23.00	0.00	23.00	1	f	f	\N	2024-04-03 12:00:00	\N	23.00	Mec
1536	\N	\N	0.00	30.00	30.00	2	t	f	\N	2024-05-24 12:00:00	\N	0.00	Emporté
1274	T13	\N	0.00	17.50	17.50	1	f	f	\N	2024-04-03 12:00:00	\N	0.00	T13
1277	\N	\N	0.00	16.00	16.00	2	t	f	\N	2024-04-04 12:00:00	\N	0.00	Emporté
1280	T9	\N	0.00	54.50	54.50	2	f	f	\N	2024-04-04 12:00:00	\N	0.00	VIO
1539	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-05-24 12:00:00	\N	0.00	\N
1283	\N	\N	-3.50	0.00	-3.50	1	f	t	\N	2024-04-05 12:00:00	\N	0.00	\N
1286	\N	\N	0.00	5.00	5.00	1	t	f	\N	2024-04-05 12:00:00	\N	0.00	Emporté
1541	\N	\N	-13.08	0.00	-13.08	1	f	t	\N	2024-05-23 12:00:00	\N	0.00	\N
1289	T15	\N	0.00	5.60	5.60	2	f	f	\N	2024-04-05 12:00:00	\N	0.00	T15
1542	\N	\N	0.00	30.00	30.00	1	t	f	\N	2024-05-29 12:00:00	\N	0.00	Emporté
1544	\N	\N	0.00	6.00	6.00	1	t	f	\N	2024-05-29 12:00:00	\N	0.00	Emporté
1545	T11	\N	0.00	46.00	46.00	2	f	f	\N	2024-05-29 12:00:00	\N	0.00	T11
1547	\N	\N	-75.78	0.00	-75.78	1	f	t	\N	2024-05-30 12:00:00	\N	0.00	\N
1548	\N	\N	-80.00	0.00	-80.00	1	f	t	\N	2024-05-30 12:00:00	\N	0.00	\N
1550	\N	\N	0.00	29.00	29.00	1	t	f	\N	2024-05-31 12:00:00	\N	0.00	Emporté
1683	\N	\N	-25.00	0.00	-25.00	1	f	t	\N	2024-06-22 12:00:00	\N	0.00	\N
1686	\N	\N	-13.41	0.00	-13.41	1	f	t	\N	2024-06-12 12:00:00	\N	0.00	\N
1689	T11	\N	0.00	46.50	46.50	1	f	f	\N	2024-06-26 12:00:00	\N	46.50	JEAN-MARIE
1692	T13	\N	0.00	15.00	15.00	1	f	f	\N	2024-06-26 12:00:00	\N	15.00	CHRISTOPHE
1695	T12	\N	0.00	54.50	54.50	1	f	f	\N	2024-06-27 12:00:00	\N	0.00	PATRICE
1698	T13	\N	0.00	0.00	0.00	1	f	f	\N	2024-06-27 12:00:00	\N	0.00	JM
1701	\N	\N	-160.00	0.00	-160.00	1	f	t	\N	2024-06-01 12:00:00	\N	0.00	\N
1704	\N	\N	-20.00	0.00	-20.00	1	f	t	\N	2024-06-19 12:00:00	\N	0.00	\N
1707	\N	\N	0.00	12.00	12.00	2	t	f	\N	2024-06-28 12:00:00	\N	0.00	Emporté
1713	\N	\N	0.00	6.00	6.00	1	t	f	\N	2024-06-28 12:00:00	\N	6.00	Emporté
1716	T9	\N	151.00	105.00	256.00	8	f	f	\N	2024-06-28 12:00:00	\N	256.00	Nathalie
1719	T10	\N	99.50	0.00	99.50	4	f	f	\N	2024-06-29 12:00:00	\N	99.50	LAUREIRO
1722	\N	\N	-10.00	0.00	-10.00	1	f	t	\N	2024-06-29 12:00:00	\N	0.00	\N
1725	\N	\N	-62.91	0.00	-62.91	1	f	t	\N	2024-07-18 12:00:00	\N	0.00	\N
1728	\N	\N	-15.40	0.00	-15.40	1	f	t	\N	2024-07-19 12:00:00	\N	0.00	\N
1731	\N	\N	-68.75	0.00	-68.75	1	f	t	\N	2024-07-04 12:00:00	\N	0.00	\N
1734	\N	\N	-24.52	0.00	-24.52	1	f	t	\N	2024-07-19 12:00:00	\N	0.00	\N
1735	\N	\N	-26.75	0.00	-26.75	1	f	t	\N	2024-07-19 12:00:00	\N	0.00	\N
1737	T14	\N	20.00	0.00	20.00	1	f	f	\N	2024-07-19 12:00:00	\N	20.00	Christophe
1740	T9	\N	229.00	0.00	229.00	7	f	f	\N	2024-07-19 12:00:00	\N	229.00	ARNOLD
1743	T2	\N	90.50	0.00	90.50	3	f	f	\N	2024-07-20 12:00:00	\N	90.50	T2
1746	\N	\N	-65.00	0.00	-65.00	1	f	t	\N	2024-07-22 12:00:00	\N	0.00	\N
1798	\N	\N	-37.05	0.00	-37.05	1	f	t	\N	2024-08-09 12:00:00	\N	0.00	\N
1209	\N	\N	0.00	5.00	5.00	1	t	f	\N	2024-03-22 12:00:00	\N	0.00	Emporté
1212	T5	\N	53.50	0.00	53.50	2	f	f	\N	2024-03-21 12:00:00	\N	53.50	goffin
1215	\N	\N	0.00	-40.00	-40.00	2	f	t	\N	2024-03-21 12:00:00	\N	0.00	\N
1218	\N	\N	-15.10	0.00	-15.10	1	f	t	\N	2024-03-23 12:00:00	\N	0.00	\N
1221	T12	\N	0.00	40.00	40.00	2	f	f	\N	2024-03-23 12:00:00	\N	0.00	DIDIER
1224	\N	\N	30.00	0.00	30.00	2	t	f	\N	2024-03-23 12:00:00	\N	30.00	Emporté
1227	T2	\N	136.50	0.00	136.50	3	f	f	\N	2024-03-23 12:00:00	\N	136.50	dalne
1230	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2024-03-23 12:00:00	\N	0.00	\N
1233	\N	\N	-40.74	0.00	-40.74	1	f	t	\N	2024-03-26 12:00:00	\N	0.00	\N
1236	T8	\N	0.00	274.50	274.50	1	f	f	\N	2024-03-26 12:00:00	\N	0.00	Boissons + Plats annick
1239	\N	\N	-32.93	0.00	-32.93	1	f	t	\N	2024-03-26 12:00:00	\N	0.00	\N
1242	T14	\N	65.00	0.00	65.00	2	f	f	\N	2024-03-26 12:00:00	\N	65.00	Rousse 2
1245	T10	\N	0.00	71.00	71.00	4	f	f	\N	2024-03-26 12:00:00	\N	0.00	Christophe
1248	T9	\N	77.00	0.00	77.00	3	f	f	\N	2024-03-27 12:00:00	\N	77.00	DORSAN
1251	\N	\N	0.00	-40.00	-40.00	10	f	t	\N	2024-03-26 12:00:00	\N	0.00	\N
1254	\N	\N	-68.89	0.00	-68.89	1	f	t	\N	2024-03-28 12:00:00	\N	0.00	\N
1257	T2	\N	0.00	78.00	78.00	2	f	f	\N	2024-03-29 12:00:00	\N	78.00	COLLARDA
1260	T12	\N	0.00	105.00	105.00	2	f	f	\N	2024-03-29 12:00:00	\N	0.00	T12
1263	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2024-03-29 12:00:00	\N	0.00	\N
1266	\N	\N	0.00	-90.00	-90.00	1	f	t	\N	2024-03-29 12:00:00	\N	0.00	\N
1269	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2024-04-02 12:00:00	\N	0.00	\N
1272	T8	\N	0.00	103.00	103.00	4	f	f	\N	2024-04-03 12:00:00	\N	103.00	T8
1275	\N	\N	-78.00	0.00	-78.00	1	f	t	\N	2024-04-03 12:00:00	\N	0.00	\N
1278	\N	\N	0.00	15.00	15.00	1	t	f	\N	2024-04-04 12:00:00	\N	0.00	Emporté
1281	\N	\N	-6.66	0.00	-6.66	1	f	t	\N	2024-04-03 12:00:00	\N	0.00	\N
1284	\N	\N	-19.25	0.00	-19.25	1	f	t	\N	2024-04-05 12:00:00	\N	0.00	\N
1290	\N	\N	0.00	6.00	6.00	1	t	f	\N	2024-04-05 12:00:00	\N	0.00	Emporté
1292	\N	\N	0.00	6.00	6.00	1	t	f	\N	2024-04-05 12:00:00	\N	0.00	Emporté
1294	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2024-04-05 12:00:00	\N	0.00	\N
1295	\N	\N	-51.64	0.00	-51.64	1	f	t	\N	2024-04-05 12:00:00	\N	0.00	\N
1296	\N	\N	-4.90	0.00	-4.90	3	f	t	\N	2024-03-09 12:00:00	\N	0.00	\N
1298	\N	\N	-30.00	0.00	-30.00	3	f	t	\N	2024-04-06 12:00:00	\N	0.00	\N
1299	\N	\N	-18.20	0.00	-18.20	1	f	t	\N	2024-04-10 12:00:00	\N	0.00	\N
1300	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-04-10 12:00:00	\N	0.00	\N
1301	T8	\N	110.50	0.00	110.50	4	f	f	\N	2024-04-11 12:00:00	\N	110.50	Daniel
1302	T11	\N	0.00	74.50	74.50	3	f	f	\N	2024-04-11 12:00:00	\N	0.00	JM
1303	T14	\N	0.00	15.00	15.00	1	f	f	\N	2024-04-11 12:00:00	\N	0.00	T14
1304	\N	\N	-32.60	0.00	-32.60	1	f	t	\N	2024-04-12 12:00:00	\N	0.00	\N
1305	T9	\N	0.00	32.00	32.00	2	f	f	\N	2024-04-12 12:00:00	\N	0.00	Maman Victor
1306	T14	\N	0.00	31.50	31.50	1	f	f	\N	2024-04-12 12:00:00	\N	0.00	Frère Denis
1307	T13	\N	20.00	0.00	20.00	1	f	f	\N	2024-04-12 12:00:00	\N	20.00	Denis
1709	T14	\N	0.00	0.00	0.00	2	f	f	\N	2024-06-28 12:00:00	\N	0.00	JEANMI
1308	T15	\N	12.00	0.00	12.00	1	t	f	\N	2024-04-12 12:00:00	\N	12.00	Manu
1309	\N	\N	-28.15	0.00	-28.15	1	f	t	\N	2024-04-12 12:00:00	\N	0.00	\N
1311	T12	\N	0.00	44.00	44.00	2	f	f	\N	2024-04-12 12:00:00	\N	0.00	Quolson
1315	\N	\N	0.00	-40.00	-40.00	1	f	t	\N	2024-04-12 12:00:00	\N	0.00	\N
1316	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2024-04-12 12:00:00	\N	0.00	\N
1319	T11	\N	38.00	0.00	38.00	1	f	f	\N	2024-04-12 12:00:00	\N	38.00	Frère denis
1320	\N	\N	-37.03	0.00	-37.03	1	f	t	\N	2024-04-16 12:00:00	\N	0.00	\N
1321	\N	\N	-25.13	0.00	-25.13	1	f	t	\N	2024-04-13 12:00:00	\N	0.00	\N
1322	\N	\N	-8.99	0.00	-8.99	1	f	t	\N	2024-04-13 12:00:00	\N	0.00	\N
1323	\N	\N	-5.58	0.00	-5.58	1	f	t	\N	2024-04-13 12:00:00	\N	0.00	\N
1324	\N	\N	-7.78	0.00	-7.78	1	f	t	\N	2024-04-13 12:00:00	\N	0.00	\N
1325	\N	\N	-327.43	0.00	-327.43	1	f	t	\N	2024-04-11 12:00:00	\N	0.00	\N
1326	\N	\N	-306.80	0.00	-306.80	1	f	t	\N	2024-04-11 12:00:00	\N	0.00	\N
1327	T9	\N	83.50	0.00	83.50	2	f	f	\N	2024-04-13 12:00:00	\N	83.50	T9
1328	T10	\N	0.00	48.00	48.00	2	f	f	\N	2024-04-13 12:00:00	\N	0.00	T10
1329	T8	\N	0.00	74.00	74.00	2	f	f	\N	2024-04-13 12:00:00	\N	0.00	T8
1330	T2	\N	101.00	0.00	101.00	4	f	f	\N	2024-04-13 12:00:00	\N	101.00	T2
1331	T12	\N	55.00	0.00	55.00	2	f	f	\N	2024-04-13 12:00:00	\N	55.00	T12
1332	T14	\N	0.00	72.00	72.00	2	f	f	\N	2024-04-13 12:00:00	\N	0.00	T14
1333	T6	\N	47.00	0.00	47.00	2	f	f	\N	2024-04-13 12:00:00	\N	47.00	T6
1334	T4	\N	57.50	0.00	57.50	1	f	f	\N	2024-04-13 12:00:00	\N	57.50	T4
1335	\N	\N	-19.15	0.00	-19.15	1	f	t	\N	2024-04-17 12:00:00	\N	0.00	\N
1336	\N	\N	6.00	0.00	6.00	1	t	f	\N	2024-04-17 12:00:00	\N	6.00	Emporté
1337	T12	\N	24.50	0.00	24.50	1	f	f	\N	2024-04-17 12:00:00	\N	24.50	Demoiselle
1338	T10	\N	34.00	0.00	34.00	1	f	f	\N	2024-04-17 12:00:00	\N	34.00	T10
1339	T9	\N	53.00	0.00	53.00	3	f	f	\N	2024-04-17 12:00:00	\N	53.00	T9
1341	\N	\N	-25.00	0.00	-25.00	1	f	t	\N	2024-04-17 12:00:00	\N	0.00	\N
1343	\N	\N	-30.66	0.00	-30.66	1	f	t	\N	2024-04-19 12:00:00	\N	0.00	\N
1344	\N	\N	0.00	0.00	-25.00	1	f	t	\N	2024-04-19 12:00:00	\N	0.00	\N
1345	\N	\N	0.00	335.00	335.00	13	t	f	\N	2024-04-20 12:00:00	\N	0.00	Emporté
1346	\N	\N	0.00	0.00	-40.00	1	f	t	\N	2024-04-19 12:00:00	\N	0.00	\N
1347	\N	\N	-29.08	0.00	-29.08	1	f	t	\N	2024-04-19 12:00:00	\N	0.00	\N
1350	\N	\N	-83.94	0.00	-83.94	1	f	t	\N	2024-04-22 12:00:00	\N	0.00	\N
1551	T14	\N	28.00	0.00	28.00	2	f	f	\N	2024-05-31 12:00:00	\N	28.00	Sarah
1352	\N	\N	-22.15	0.00	-22.15	1	f	t	\N	2024-04-25 12:00:00	\N	0.00	\N
1355	\N	\N	-10.93	0.00	-10.93	1	f	t	\N	2024-04-18 12:00:00	\N	0.00	\N
1553	T9	\N	0.00	14.50	14.50	1	f	f	\N	2024-05-31 12:00:00	\N	0.00	T9
1358	\N	\N	-213.06	0.00	-213.06	1	f	t	\N	2024-04-17 12:00:00	\N	0.00	\N
1554	T6	\N	83.00	0.00	83.00	1	f	f	\N	2024-05-31 12:00:00	\N	83.00	PAT
1361	T14	\N	22.00	0.00	22.00	1	f	f	\N	2024-04-26 12:00:00	\N	22.00	Manu
1364	\N	\N	-4.93	0.00	-4.93	1	f	t	\N	2024-04-26 12:00:00	\N	0.00	\N
1556	T4	\N	197.00	0.00	197.00	11	f	f	\N	2024-05-31 12:00:00	\N	197.00	Dan 1
1367	T9	\N	207.00	0.00	207.00	4	f	f	\N	2024-04-26 12:00:00	\N	207.00	Eve
1557	T5	\N	0.00	54.00	54.00	1	f	f	\N	2024-05-31 12:00:00	\N	0.00	BOISSONS
1370	T8	\N	0.00	248.00	248.00	4	f	f	\N	2024-04-26 12:00:00	\N	0.00	Denis
1373	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2024-04-26 12:00:00	\N	0.00	\N
1559	\N	\N	-39.89	0.00	-39.89	1	f	t	\N	2024-05-31 12:00:00	\N	0.00	\N
1376	\N	\N	-76.44	0.00	-76.44	1	f	t	\N	2024-04-30 12:00:00	\N	0.00	\N
1560	\N	\N	-40.47	0.00	-40.47	1	f	t	\N	2024-05-30 12:00:00	\N	0.00	\N
1379	T8	\N	0.00	88.50	88.50	2	f	f	\N	2024-05-01 12:00:00	\N	0.00	Voisins
1382	\N	\N	-10.00	0.00	-10.00	1	f	t	\N	2024-04-23 12:00:00	\N	0.00	\N
1385	\N	\N	-16.00	0.00	-16.00	1	f	t	\N	2024-04-25 12:00:00	\N	0.00	\N
1388	\N	\N	-400.00	0.00	-400.00	1	f	t	\N	2024-04-29 12:00:00	\N	0.00	\N
1391	\N	\N	-16.45	0.00	-16.45	1	f	t	\N	2024-05-02 12:00:00	\N	0.00	\N
1565	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2024-05-31 12:00:00	\N	0.00	\N
1394	\N	\N	-46.02	0.00	-46.02	1	f	t	\N	2024-05-03 12:00:00	\N	0.00	\N
1397	T6	\N	0.00	45.00	45.00	2	f	f	\N	2024-05-03 12:00:00	\N	0.00	Jeunes
1568	T12	\N	44.00	0.00	44.00	2	f	f	\N	2024-05-31 12:00:00	\N	44.00	T12
1403	T9	\N	0.00	178.50	178.50	5	f	f	\N	2024-05-03 12:00:00	\N	0.00	Nadine
1569	T3	\N	0.00	41.00	41.00	2	f	f	\N	2024-05-31 12:00:00	\N	0.00	T3
1406	\N	\N	-29.10	0.00	-29.10	1	f	t	\N	2024-05-03 12:00:00	\N	0.00	\N
1409	\N	\N	-17.00	0.00	-17.00	1	f	t	\N	2024-05-04 12:00:00	\N	0.00	\N
1572	T7	\N	0.00	115.00	115.00	3	f	f	\N	2024-05-30 12:00:00	\N	0.00	Moriet
1415	\N	\N	-28.85	0.00	0.00	1	f	t	\N	2024-05-08 12:00:00	\N	0.00	\N
1418	\N	\N	-151.25	0.00	-151.25	4	f	t	\N	2024-05-07 12:00:00	\N	0.00	\N
1574	T12	\N	42.00	0.00	42.00	2	f	f	\N	2024-06-05 12:00:00	\N	42.00	SARAH
1575	T15	\N	0.00	59.00	59.00	3	f	f	\N	2024-06-05 12:00:00	\N	0.00	CLOES
1577	\N	\N	-14.00	0.00	-14.00	1	f	t	\N	2024-06-06 12:00:00	\N	0.00	\N
1578	\N	\N	-30.25	0.00	-30.25	1	f	t	\N	2024-06-06 12:00:00	\N	0.00	\N
1580	T16	\N	0.00	7.50	7.50	1	f	f	\N	2024-06-05 12:00:00	\N	0.00	T16
1581	\N	\N	-115.30	0.00	-115.30	1	f	t	\N	2024-06-06 12:00:00	\N	0.00	\N
1583	T13	\N	0.00	6.00	6.00	1	f	f	\N	2024-06-06 12:00:00	\N	0.00	Manu
1584	\N	\N	-219.75	0.00	-219.75	1	f	t	\N	2024-06-04 12:00:00	\N	0.00	\N
1586	\N	\N	-14.00	0.00	-14.00	1	f	t	\N	2024-06-03 12:00:00	\N	0.00	\N
1587	\N	\N	-100.00	0.00	-100.00	1	f	t	\N	2024-06-03 12:00:00	\N	0.00	\N
1589	\N	\N	6.00	0.00	6.00	1	t	f	\N	2024-06-07 12:00:00	\N	6.00	Emporté
1590	T3	\N	31.00	52.50	83.50	5	f	f	\N	2024-06-07 12:00:00	\N	83.50	VUE
1593	T11	\N	62.00	0.00	62.00	2	f	f	\N	2024-06-07 12:00:00	\N	62.00	T11
1598	\N	\N	12.00	0.00	12.00	2	t	f	\N	2024-06-07 12:00:00	\N	12.00	Emporté
1599	\N	\N	0.00	30.00	30.00	2	t	f	\N	2024-06-07 12:00:00	\N	0.00	Emporté
1601	T2	\N	133.50	0.00	133.50	4	f	f	\N	2024-06-07 12:00:00	\N	133.50	Boulanger
1602	T14	\N	0.00	31.00	31.00	1	f	f	\N	2024-06-07 12:00:00	\N	0.00	Dany
1604	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2024-06-07 12:00:00	\N	0.00	\N
1605	\N	\N	-126.00	0.00	-126.00	1	f	t	\N	2024-06-08 12:00:00	\N	0.00	\N
1607	\N	\N	-13.44	0.00	-13.44	1	f	t	\N	2024-06-05 12:00:00	\N	0.00	\N
1608	\N	\N	-20.00	0.00	-20.00	1	f	t	\N	2024-05-20 12:00:00	\N	0.00	\N
1610	\N	\N	-10.00	0.00	-10.00	1	f	t	\N	2024-05-29 12:00:00	\N	0.00	\N
1611	\N	\N	-20.00	0.00	-20.00	1	f	t	\N	2024-06-04 12:00:00	\N	0.00	\N
1613	T9	\N	0.00	73.50	73.50	2	f	f	\N	2024-06-08 12:00:00	\N	73.50	T9
1614	\N	\N	-121.00	0.00	-121.00	1	f	t	\N	2024-06-06 12:00:00	\N	0.00	\N
1616	\N	\N	-97.27	0.00	-97.27	1	f	t	\N	2024-06-03 12:00:00	\N	0.00	\N
1617	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-06-08 12:00:00	\N	0.00	\N
1619	\N	\N	-400.00	0.00	-400.00	1	f	t	\N	2024-06-11 12:00:00	\N	0.00	\N
1620	\N	\N	-163.70	0.00	-163.70	1	f	t	\N	2024-06-20 12:00:00	\N	0.00	\N
1622	\N	\N	-14.00	0.00	-14.00	1	f	t	\N	2024-04-03 12:00:00	\N	0.00	\N
1623	\N	\N	-28.00	0.00	-28.00	1	f	t	\N	2024-04-15 12:00:00	\N	0.00	\N
1625	\N	\N	6.00	0.00	6.00	1	t	f	\N	2024-06-12 12:00:00	\N	6.00	Emporté
1626	\N	\N	-63.65	0.00	-63.65	1	f	t	\N	2024-06-13 12:00:00	\N	0.00	\N
1632	\N	\N	-187.70	0.00	-187.70	1	f	t	\N	2024-06-13 12:00:00	\N	0.00	\N
1634	\N	\N	0.00	7.00	7.00	1	t	f	\N	2024-06-14 12:00:00	\N	0.00	Emporté
1635	\N	\N	0.00	12.00	12.00	2	t	f	\N	2024-06-14 12:00:00	\N	0.00	Emporté
1637	T12	\N	48.00	0.00	48.00	2	f	f	\N	2024-06-14 12:00:00	\N	48.00	Herbelin
1640	\N	\N	0.00	15.00	15.00	1	t	f	\N	2024-06-14 12:00:00	\N	0.00	Emporté
1643	\N	\N	0.00	15.00	15.00	1	t	f	\N	2024-06-14 12:00:00	\N	0.00	Emporté
1646	\N	\N	-31.99	0.00	-31.99	1	f	t	\N	2024-06-14 12:00:00	\N	0.00	\N
1647	\N	\N	-3.84	0.00	-3.84	1	f	t	\N	2024-06-14 12:00:00	\N	0.00	\N
1649	T2	\N	0.00	129.00	129.00	3	f	f	\N	2024-06-14 12:00:00	\N	0.00	HOUGARDY
1650	T9	\N	33.00	0.00	33.00	2	f	f	\N	2024-06-14 12:00:00	\N	33.00	Goffin
1351	\N	\N	-8.26	0.00	-8.26	1	f	t	\N	2024-04-25 12:00:00	\N	0.00	\N
1564	T8	-1631695881	110.00	0.00	110.00	3	f	f	\N	2024-05-31 12:00:00	\N	110.00	T8
1353	\N	\N	-55.65	0.00	-55.65	1	f	t	\N	2024-04-25 12:00:00	\N	0.00	\N
1354	\N	\N	-27.97	0.00	-27.97	1	f	t	\N	2024-04-05 12:00:00	\N	0.00	\N
1552	T9	\N	0.00	25.00	25.00	1	f	f	\N	2024-05-31 12:00:00	\N	0.00	T9
1356	\N	\N	-9.06	0.00	-9.06	1	f	t	\N	2024-04-18 12:00:00	\N	0.00	\N
1357	\N	\N	-54.76	0.00	-54.76	1	f	t	\N	2024-04-18 12:00:00	\N	0.00	\N
1359	T8	\N	70.00	0.00	70.00	2	f	f	\N	2024-04-25 12:00:00	\N	70.00	Daniel
1360	\N	\N	7.00	0.00	7.00	1	t	f	\N	2024-04-26 12:00:00	\N	7.00	Emporté
1555	T8	\N	32.50	0.00	32.50	1	f	f	\N	2024-05-31 12:00:00	\N	32.50	T8
1363	\N	\N	-16.18	0.00	-16.18	1	f	t	\N	2024-04-26 12:00:00	\N	0.00	\N
1365	\N	\N	0.00	-150.00	-150.00	1	f	t	\N	2024-04-26 12:00:00	\N	0.00	\N
1366	T11	\N	114.00	0.00	114.00	2	f	f	\N	2024-04-26 12:00:00	\N	114.00	Baert
1558	\N	\N	-63.46	0.00	-63.46	1	f	t	\N	2024-05-31 12:00:00	\N	0.00	\N
1368	T12	\N	0.00	129.00	129.00	2	f	f	\N	2024-04-26 12:00:00	\N	0.00	Lescrenier
1369	T5	\N	124.00	186.00	310.00	5	f	f	\N	2024-04-26 12:00:00	\N	310.00	Nicole
1371	T14	\N	0.00	20.30	20.30	1	f	f	\N	2024-04-26 12:00:00	\N	0.00	Occupé
1372	T13	\N	0.00	235.00	235.00	4	f	f	\N	2024-04-26 12:00:00	\N	0.00	Didier
1561	\N	\N	13.00	0.00	13.00	2	t	f	\N	2024-05-30 12:00:00	\N	13.00	Emporté
1374	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2024-04-26 12:00:00	\N	0.00	\N
1377	T9	\N	0.00	94.00	94.00	3	f	f	\N	2024-05-01 12:00:00	\N	0.00	Italiens
1380	\N	\N	-20.28	0.00	-20.28	1	f	t	\N	2024-05-02 12:00:00	\N	0.00	\N
1383	\N	\N	-10.00	0.00	-10.00	1	f	t	\N	2024-04-25 12:00:00	\N	0.00	\N
1567	T11	\N	244.10	0.00	244.10	6	f	f	\N	2024-05-31 12:00:00	\N	244.10	T11
1386	\N	\N	-20.00	0.00	-20.00	1	f	t	\N	2024-05-02 12:00:00	\N	0.00	\N
1389	\N	\N	0.00	30.00	30.00	2	t	f	\N	2024-05-03 12:00:00	\N	0.00	Emporté
1570	T14	\N	0.00	131.00	131.00	3	f	f	\N	2024-05-30 12:00:00	\N	0.00	T14
1395	\N	\N	-726.99	0.00	-726.99	1	f	t	\N	2024-05-02 12:00:00	\N	0.00	\N
1573	T2	\N	42.00	0.00	42.00	2	f	f	\N	2024-06-05 12:00:00	\N	42.00	T2
1398	T3	\N	0.00	39.50	39.50	2	f	f	\N	2024-05-03 12:00:00	\N	0.00	Adam
1401	T8	\N	75.00	0.00	75.00	3	f	f	\N	2024-05-03 12:00:00	\N	75.00	Wilkin
1576	\N	\N	-18.55	0.00	-18.55	1	f	t	\N	2024-06-06 12:00:00	\N	0.00	\N
1407	\N	\N	-180.00	0.00	-180.00	1	f	t	\N	2024-04-29 12:00:00	\N	0.00	\N
1413	T2	\N	46.00	0.00	46.00	2	f	f	\N	2024-05-04 12:00:00	\N	46.00	T2
1582	T8	\N	0.00	53.00	53.00	2	f	f	\N	2024-06-06 12:00:00	\N	0.00	Elise
1416	\N	\N	-219.75	0.00	-219.75	1	f	f	\N	2024-05-06 12:00:00	\N	-219.75	Dépenses
1419	\N	\N	-242.00	0.00	-242.00	1	f	t	\N	2024-05-06 12:00:00	\N	0.00	\N
1585	\N	\N	-140.10	0.00	-140.10	1	f	t	\N	2024-06-04 12:00:00	\N	0.00	\N
1588	\N	\N	-29.96	0.00	-29.96	1	f	t	\N	2024-06-07 12:00:00	\N	0.00	\N
1591	T8	\N	0.00	120.00	120.00	4	f	f	\N	2024-06-07 12:00:00	\N	0.00	DANIEL
1594	T14	\N	0.00	32.00	32.00	1	f	f	\N	2024-06-07 12:00:00	\N	0.00	Dany
1597	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-06-07 12:00:00	\N	0.00	\N
1600	T9	\N	0.00	40.00	40.00	2	f	f	\N	2024-06-07 12:00:00	\N	0.00	Grivegnée
1603	T12	\N	0.00	156.00	156.00	2	f	f	\N	2024-06-07 12:00:00	\N	0.00	Marc
1609	\N	\N	-20.00	0.00	-20.00	1	f	t	\N	2024-05-29 12:00:00	\N	0.00	\N
1612	\N	\N	-10.00	0.00	-10.00	1	f	t	\N	2024-06-04 12:00:00	\N	0.00	\N
1615	\N	\N	-27.17	0.00	-27.17	1	f	t	\N	2024-06-05 12:00:00	\N	0.00	\N
1618	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2024-06-10 12:00:00	\N	0.00	\N
1621	\N	\N	-28.00	0.00	-28.00	1	f	t	\N	2024-05-17 12:00:00	\N	0.00	\N
1624	\N	\N	0.00	13.00	13.00	2	t	f	\N	2024-06-12 12:00:00	\N	0.00	Emporté
1627	\N	\N	33.50	0.00	33.50	1	t	f	\N	2024-06-13 12:00:00	\N	33.50	Emporté
1630	T9	\N	0.00	57.50	57.50	2	f	f	\N	2024-06-13 12:00:00	\N	0.00	Piret
1633	\N	\N	0.00	12.00	12.00	2	t	f	\N	2024-06-14 12:00:00	\N	0.00	Emporté
1639	\N	\N	0.00	6.00	6.00	1	t	f	\N	2024-06-14 12:00:00	\N	0.00	Emporté
1642	T2	\N	0.00	68.00	68.00	2	f	f	\N	2024-06-14 12:00:00	\N	0.00	Defaweux
1648	\N	\N	-5.73	0.00	-5.73	1	f	t	\N	2024-06-14 12:00:00	\N	0.00	\N
1651	\N	\N	29.00	0.00	29.00	2	t	f	\N	2024-06-14 12:00:00	\N	29.00	Emporté
1654	\N	\N	-100.00	0.00	-100.00	1	f	t	\N	2024-06-14 12:00:00	\N	0.00	\N
1660	\N	\N	-8.20	0.00	-8.20	1	f	t	\N	2024-06-21 12:00:00	\N	0.00	\N
1663	T8	\N	0.00	0.00	0.00	1	f	f	\N	2024-06-21 12:00:00	\N	0.00	T8
1666	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-06-08 12:00:00	\N	0.00	\N
1669	\N	\N	-14.47	0.00	-14.47	1	f	t	\N	2024-06-19 12:00:00	\N	0.00	\N
1672	\N	\N	-18.00	0.00	-18.00	1	f	t	\N	2024-06-10 12:00:00	\N	0.00	\N
1675	\N	\N	-16.00	0.00	-16.00	1	f	t	\N	2024-06-11 12:00:00	\N	0.00	\N
1711	\N	\N	-107.61	0.00	-107.61	1	f	t	\N	2024-06-28 12:00:00	\N	0.00	\N
1712	\N	\N	-35.46	0.00	-35.46	1	f	t	\N	2024-06-28 12:00:00	\N	0.00	\N
1714	T8	\N	0.00	54.00	54.00	3	f	f	\N	2024-06-28 12:00:00	\N	54.00	Uwera
1715	T2	\N	0.00	14.00	14.00	2	f	f	\N	2024-06-28 12:00:00	\N	14.00	Pirotte
1718	\N	\N	-54.00	0.00	-54.00	1	f	t	\N	2024-06-28 12:00:00	\N	0.00	\N
1721	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2024-06-29 12:00:00	\N	0.00	\N
1723	\N	\N	-130.00	0.00	-130.00	1	f	t	\N	2024-06-30 12:00:00	\N	0.00	\N
1724	\N	\N	-87.50	0.00	-87.50	1	f	t	\N	2024-07-18 12:00:00	\N	0.00	\N
1726	\N	\N	-8.00	0.00	-8.00	1	f	t	\N	2024-07-18 12:00:00	\N	0.00	\N
1727	\N	\N	-82.72	0.00	-82.72	1	f	t	\N	2024-07-19 12:00:00	\N	0.00	\N
1729	\N	\N	-400.00	0.00	-400.00	1	f	t	\N	2024-07-19 12:00:00	\N	0.00	\N
1730	\N	\N	-166.36	0.00	-166.36	1	f	t	\N	2024-07-09 12:00:00	\N	0.00	\N
1732	\N	\N	-14.07	0.00	-14.07	1	f	t	\N	2024-07-03 12:00:00	\N	0.00	\N
1733	\N	\N	-366.67	0.00	-366.67	1	f	t	\N	2024-07-04 12:00:00	\N	0.00	\N
1420	\N	\N	-14.00	0.00	-14.00	4	f	t	\N	2024-05-06 12:00:00	\N	0.00	\N
1375	T15	\N	15.50	0.00	15.50	1	f	f	\N	2024-04-26 12:00:00	\N	15.50	Manu
1378	T11	\N	0.00	17.00	17.00	1	f	f	\N	2024-05-01 12:00:00	\N	0.00	Dame
1652	\N	\N	-420.00	0.00	-420.00	1	f	t	\N	2024-05-01 12:00:00	\N	0.00	\N
1381	\N	\N	-71.77	0.00	-71.77	1	f	t	\N	2024-05-02 12:00:00	\N	0.00	\N
1653	T10	\N	0.00	15.00	15.00	1	f	f	\N	2024-06-14 12:00:00	\N	15.00	T10
1384	\N	\N	0.00	-20.00	-20.00	1	f	t	\N	2024-05-01 12:00:00	\N	0.00	\N
1387	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2024-05-02 12:00:00	\N	0.00	\N
1655	\N	\N	-23.32	0.00	-23.32	1	f	t	\N	2024-06-15 12:00:00	\N	0.00	\N
1390	T14	\N	0.00	15.00	15.00	1	f	f	\N	2024-05-03 12:00:00	\N	0.00	Eric
1656	T2	\N	0.00	70.00	70.00	2	f	f	\N	2024-06-15 12:00:00	\N	70.00	T2
1393	\N	\N	-438.48	0.00	-438.48	1	f	t	\N	2024-05-07 12:00:00	\N	0.00	\N
1396	\N	\N	-72.99	0.00	-72.99	1	f	t	\N	2024-05-03 12:00:00	\N	0.00	\N
1658	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2024-06-15 12:00:00	\N	0.00	\N
1399	T4	\N	0.00	66.50	66.50	2	f	f	\N	2024-05-03 12:00:00	\N	0.00	Petitjean
1659	\N	\N	-36.54	0.00	-36.54	1	f	t	\N	2024-06-14 12:00:00	\N	0.00	\N
1402	T11	\N	0.00	45.00	45.00	1	f	f	\N	2024-05-03 12:00:00	\N	0.00	Sabine
1405	\N	\N	0.00	-50.00	-50.00	1	f	t	\N	2024-05-03 12:00:00	\N	0.00	\N
1661	\N	\N	-166.25	0.00	-166.25	1	f	t	\N	2024-05-23 12:00:00	\N	0.00	\N
1408	T14	\N	0.00	15.00	15.00	1	f	f	\N	2024-05-04 12:00:00	\N	0.00	T14
1662	\N	\N	-535.00	0.00	-535.00	1	f	t	\N	2024-06-21 12:00:00	\N	0.00	\N
1414	T9	\N	0.00	351.00	351.00	5	f	f	\N	2024-05-04 12:00:00	\N	0.00	HANNON
1664	T7	\N	0.00	0.00	0.00	8	f	f	\N	2024-06-21 12:00:00	\N	0.00	Daniel
1665	T10	\N	0.00	104.50	104.50	4	f	f	\N	2024-06-21 12:00:00	\N	0.00	ANTHONY
1667	\N	\N	-61.98	0.00	-61.98	1	f	t	\N	2024-06-17 12:00:00	\N	0.00	\N
1668	\N	\N	-30.79	0.00	-30.79	1	f	t	\N	2024-06-21 12:00:00	\N	0.00	\N
1670	\N	\N	-28.00	0.00	-28.00	1	f	t	\N	2024-06-17 12:00:00	\N	0.00	\N
1671	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-06-10 12:00:00	\N	0.00	\N
1673	\N	\N	-30.67	0.00	-30.67	1	f	t	\N	2024-06-10 12:00:00	\N	0.00	\N
1674	\N	\N	-214.41	0.00	-214.41	1	f	t	\N	2024-06-25 12:00:00	\N	0.00	\N
1676	\N	\N	0.00	0.00	0.00	1	t	f	\N	2024-06-21 12:00:00	\N	0.00	Emporté
1677	\N	\N	0.00	13.00	13.00	2	t	f	\N	2024-06-21 12:00:00	\N	0.00	Emporté
1679	T10	\N	0.00	157.00	157.00	4	f	f	\N	2024-06-21 12:00:00	\N	0.00	Maria Lopez
1680	\N	\N	-58.00	0.00	-58.00	1	f	t	\N	2024-06-21 12:00:00	\N	0.00	\N
1736	\N	\N	12.00	0.00	12.00	2	t	f	\N	2024-07-19 12:00:00	\N	12.00	Emporté
1738	T13	\N	20.00	0.00	20.00	2	f	f	\N	2024-07-19 12:00:00	\N	20.00	Sarah
1739	T2	\N	0.00	35.00	35.00	2	f	f	\N	2024-07-19 12:00:00	\N	35.00	NANAS
1741	\N	\N	-6.52	0.00	-6.52	1	f	t	\N	2024-07-20 12:00:00	\N	0.00	\N
1742	T14	\N	0.00	10.00	10.00	1	f	f	\N	2024-07-20 12:00:00	\N	10.00	T14
1744	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-07-20 12:00:00	\N	0.00	\N
1745	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-07-19 12:00:00	\N	0.00	\N
1747	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2024-07-22 12:00:00	\N	0.00	\N
1748	\N	\N	-70.00	0.00	-70.00	1	f	t	\N	2024-07-21 12:00:00	\N	0.00	\N
1750	\N	\N	-6.76	0.00	-6.76	1	f	t	\N	2024-07-25 12:00:00	\N	0.00	\N
1751	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-07-09 12:00:00	\N	0.00	\N
1753	\N	\N	-10.00	0.00	-10.00	1	f	t	\N	2024-07-23 12:00:00	\N	0.00	\N
1754	\N	\N	-10.50	0.00	-10.50	1	f	t	\N	2024-07-22 12:00:00	\N	0.00	\N
1755	\N	\N	-100.00	0.00	-100.00	1	f	t	\N	2024-07-20 12:00:00	\N	0.00	\N
1756	T7	\N	0.00	10.00	10.00	2	f	f	\N	2024-07-25 12:00:00	\N	10.00	JM
1757	\N	\N	-137.40	0.00	-137.40	1	f	t	\N	2024-07-25 12:00:00	\N	0.00	\N
1758	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2024-07-23 12:00:00	\N	0.00	\N
1759	\N	\N	-58.00	0.00	-58.00	1	f	t	\N	2024-07-25 12:00:00	\N	0.00	\N
1762	\N	\N	0.00	0.00	0.00	1	t	f	\N	2024-07-01 12:00:00	\N	0.00	Emporté
1763	\N	\N	0.00	0.00	0.00	1	t	f	\N	2024-07-26 12:00:00	\N	0.00	Emporté
1764	\N	\N	0.00	0.00	0.00	1	t	f	\N	2024-07-02 12:00:00	\N	0.00	Emporté
1765	T9	\N	37.50	0.00	37.50	2	f	f	\N	2024-07-31 12:00:00	\N	37.50	Bourge
1766	T2	\N	0.00	105.50	105.50	3	f	f	\N	2024-07-31 12:00:00	\N	0.00	Lauriers
1767	T11	\N	38.40	0.00	38.40	2	f	f	\N	2024-07-31 12:00:00	\N	38.40	Marieeve
1768	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-07-31 12:00:00	\N	0.00	\N
1769	\N	\N	-32.72	0.00	-32.72	1	f	t	\N	2024-08-01 12:00:00	\N	0.00	\N
1770	T9	\N	66.00	0.00	66.00	2	f	f	\N	2024-08-01 12:00:00	\N	66.00	Voisins
1771	\N	\N	0.00	13.00	13.00	1	t	f	\N	2024-08-01 12:00:00	\N	0.00	Emporté
1773	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2024-08-01 12:00:00	\N	0.00	\N
1774	T12	\N	135.50	0.00	135.50	1	f	f	\N	2024-08-01 12:00:00	\N	135.50	eve solo
1775	T7	\N	180.00	90.20	270.20	10	f	f	\N	2024-08-01 12:00:00	\N	180.00	Eve
1776	\N	\N	0.00	17.00	17.00	1	t	f	\N	2024-08-02 12:00:00	\N	0.00	Emporté
1777	\N	\N	8.80	0.00	8.80	1	t	f	\N	2024-08-02 12:00:00	\N	8.80	Emporté
1778	\N	\N	-14.07	0.00	-14.07	1	f	t	\N	2024-08-02 12:00:00	\N	0.00	\N
1779	T4	\N	30.00	0.00	30.00	2	f	f	\N	2024-08-02 12:00:00	\N	30.00	Célia
1780	\N	\N	0.00	4.40	4.40	1	t	f	\N	2024-08-02 12:00:00	\N	0.00	Emporté
1781	\N	\N	-23.73	0.00	-23.73	1	f	t	\N	2024-08-01 12:00:00	\N	0.00	\N
1782	\N	\N	-107.37	0.00	-107.37	1	f	t	\N	2024-08-02 12:00:00	\N	0.00	\N
1783	\N	\N	0.00	24.00	24.00	4	t	f	\N	2024-08-02 12:00:00	\N	0.00	Emporté
1785	T3	\N	0.00	49.90	49.90	3	f	f	\N	2024-08-02 12:00:00	\N	0.00	Néerlandophone
1787	\N	\N	-18.30	0.00	-18.30	1	f	t	\N	2024-08-03 12:00:00	\N	0.00	\N
1788	T12	\N	48.70	0.00	48.70	2	f	f	\N	2024-08-03 12:00:00	\N	48.70	Françoise
1789	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-08-05 12:00:00	\N	0.00	\N
1790	\N	\N	-219.75	0.00	-219.75	1	f	t	\N	2024-08-05 12:00:00	\N	0.00	\N
1791	\N	\N	-211.75	0.00	-211.75	1	f	t	\N	2024-08-20 12:00:00	\N	0.00	\N
1792	\N	\N	-28.00	0.00	-28.00	1	f	t	\N	2024-08-16 12:00:00	\N	0.00	\N
1793	T14	\N	0.00	0.00	0.00	2	f	f	\N	2024-08-08 12:00:00	\N	0.00	JM
1794	\N	\N	-3.70	0.00	-3.70	1	f	t	\N	2024-08-09 12:00:00	\N	0.00	\N
1795	\N	\N	-58.39	0.00	-58.39	1	f	t	\N	2024-08-09 12:00:00	\N	0.00	\N
1796	T11	\N	0.00	153.00	153.00	4	f	f	\N	2024-08-09 12:00:00	\N	0.00	Filou
1812	T9	\N	54.80	60.00	114.80	4	f	f	\N	2024-08-16 12:00:00	\N	114.80	MARIEEVE
1802	\N	\N	0.00	38.40	38.40	2	t	f	\N	2024-08-10 12:00:00	\N	0.00	Emporté
1815	T15	\N	0.00	16.70	16.70	1	f	f	\N	2024-08-16 12:00:00	\N	0.00	T15
1805	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2024-08-10 12:00:00	\N	0.00	\N
1808	T3	\N	0.00	93.00	93.00	4	f	f	\N	2024-08-16 12:00:00	\N	0.00	T3
1818	\N	\N	-219.08	0.00	-219.08	1	f	t	\N	2024-08-06 12:00:00	\N	0.00	\N
1811	T13	\N	52.40	0.00	52.40	1	f	f	\N	2024-08-16 12:00:00	\N	52.40	Luc
1821	\N	\N	-317.97	0.00	-317.97	1	f	t	\N	2024-04-05 12:00:00	\N	0.00	\N
1824	\N	\N	-12.11	0.00	-12.11	1	f	t	\N	2024-08-21 12:00:00	\N	0.00	\N
1827	T4	\N	0.00	36.40	36.40	2	f	f	\N	2024-08-22 12:00:00	\N	0.00	Dame-enfant
1830	T12	\N	0.00	2.50	2.50	1	f	f	\N	2024-08-23 12:00:00	\N	0.00	T12
1833	T13	\N	0.00	0.00	0.00	1	f	f	\N	2024-08-23 12:00:00	\N	0.00	PREUN
1836	\N	\N	-15.21	0.00	-15.21	1	f	t	\N	2024-08-22 12:00:00	\N	0.00	\N
1839	\N	\N	0.00	30.00	30.00	1	t	f	\N	2024-08-23 12:00:00	\N	0.00	Emporté
1842	T8	\N	131.40	0.00	131.40	4	f	f	\N	2024-08-23 12:00:00	\N	131.40	ARNOLD
1845	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2024-08-23 12:00:00	\N	0.00	\N
1848	\N	\N	-120.72	0.00	-120.72	1	f	t	\N	2024-08-26 12:00:00	\N	0.00	\N
1851	\N	\N	0.00	10.00	10.00	1	t	f	\N	2024-08-24 12:00:00	\N	0.00	Emporté
1854	T4	\N	80.00	0.00	80.00	2	f	f	\N	2024-08-24 12:00:00	\N	80.00	Pierre
1857	T14	\N	44.50	0.00	44.50	1	f	f	\N	2024-08-24 12:00:00	\N	44.50	Marie
1860	\N	\N	-10.00	0.00	-10.00	1	f	t	\N	2024-08-14 12:00:00	\N	0.00	\N
1863	\N	\N	-20.00	0.00	-20.00	1	f	t	\N	2024-08-27 12:00:00	\N	0.00	\N
1866	\N	\N	-16.79	0.00	-16.79	1	f	t	\N	2024-08-23 12:00:00	\N	0.00	\N
1869	T14	\N	0.00	0.00	0.00	1	f	f	\N	2024-08-28 12:00:00	\N	0.00	JM
1872	\N	\N	-200.00	0.00	-200.00	1	f	t	\N	2024-08-28 12:00:00	\N	0.00	\N
1875	\N	\N	-80.00	0.00	-80.00	1	f	t	\N	2024-08-12 12:00:00	\N	0.00	\N
1878	\N	\N	0.00	26.00	26.00	2	t	f	\N	2024-08-29 12:00:00	\N	0.00	Emporté
1881	\N	\N	-74.04	0.00	-74.04	1	f	t	\N	2024-08-30 12:00:00	\N	0.00	\N
1884	T12	\N	0.00	20.00	20.00	1	f	f	\N	2024-08-30 12:00:00	\N	0.00	Dany
1887	\N	\N	-7.26	0.00	-7.26	1	f	t	\N	2024-08-30 12:00:00	\N	0.00	\N
1890	T2	\N	0.00	174.60	174.60	5	f	f	\N	2024-08-30 12:00:00	\N	0.00	Morati
1893	T5	\N	0.00	57.00	57.00	2	f	f	\N	2024-08-30 12:00:00	\N	0.00	Lebrun
1896	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-08-30 12:00:00	\N	0.00	\N
1899	\N	\N	-20.30	0.00	-20.30	1	f	t	\N	2024-08-31 12:00:00	\N	0.00	\N
1902	T9	\N	54.00	0.00	54.00	2	f	f	\N	2024-08-29 12:00:00	\N	54.00	Pasleau
1905	\N	\N	0.00	12.00	12.00	2	t	f	\N	2024-09-04 12:00:00	\N	0.00	Emporté
1911	T7	\N	0.00	17.00	17.00	1	f	f	\N	2024-09-04 12:00:00	\N	0.00	CHRISTOPHE
1914	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-09-02 12:00:00	\N	0.00	\N
1917	T9	\N	28.00	0.00	28.00	2	f	f	\N	2024-09-05 12:00:00	\N	28.00	AMERICAN
1920	\N	\N	6.00	0.00	6.00	1	t	f	\N	2024-09-06 12:00:00	\N	6.00	Emporté
1926	\N	\N	-5.58	0.00	-5.58	1	f	t	\N	2024-09-06 12:00:00	\N	0.00	\N
1929	T2	\N	0.00	104.00	104.00	2	f	f	\N	2024-09-06 12:00:00	\N	0.00	T2
1932	\N	\N	-75.86	0.00	-75.86	1	f	t	\N	2024-09-07 12:00:00	\N	0.00	\N
1935	T11	\N	0.00	53.00	53.00	3	f	f	\N	2024-09-07 12:00:00	\N	0.00	Monseur
1938	T8	\N	0.00	38.00	38.00	1	f	f	\N	2024-09-07 12:00:00	\N	0.00	T8
1941	T2	\N	0.00	79.00	79.00	2	f	f	\N	2024-09-07 12:00:00	\N	0.00	François
1942	T8	\N	35.00	0.00	35.00	1	f	f	\N	2024-09-11 12:00:00	\N	35.00	T8
1945	T11	\N	0.00	45.50	45.50	2	f	f	\N	2024-09-11 12:00:00	\N	0.00	Nanas
2667	\N	\N	-196.00	0.00	-196.00	1	f	t	\N	2025-03-18 12:00:00	\N	0.00	\N
1951	T2	\N	51.00	0.00	51.00	2	f	f	\N	2024-09-12 12:00:00	\N	51.00	T2
1954	T11	\N	0.00	33.00	33.00	1	f	f	\N	2024-09-12 12:00:00	\N	33.00	T11
1957	\N	\N	-140.00	0.00	-140.00	1	f	t	\N	2024-09-11 12:00:00	\N	0.00	\N
1960	T4	\N	0.00	34.50	34.50	2	f	f	\N	2024-09-12 12:00:00	\N	34.50	LAURENT
1963	T13	\N	15.50	0.00	15.50	1	f	f	\N	2024-09-12 12:00:00	\N	15.50	DANIEL
1966	\N	\N	-57.20	0.00	-57.20	1	f	t	\N	2024-09-13 12:00:00	\N	0.00	\N
1969	T2	\N	74.00	0.00	74.00	2	f	f	\N	2024-09-13 12:00:00	\N	74.00	T2
1972	\N	\N	-233.40	0.00	-233.40	1	f	t	\N	2024-09-23 12:00:00	\N	0.00	\N
1975	\N	\N	-25.25	0.00	-25.25	1	f	t	\N	2024-09-14 12:00:00	\N	0.00	\N
1978	T12	\N	0.00	92.00	92.00	3	f	f	\N	2024-09-14 12:00:00	\N	0.00	HERBELIN
1981	T9	\N	176.00	0.00	176.00	4	f	f	\N	2024-09-14 12:00:00	\N	176.00	SCHUTZ
1984	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2024-09-14 12:00:00	\N	0.00	\N
1987	\N	\N	-6.45	0.00	-6.45	1	f	t	\N	2024-09-18 12:00:00	\N	0.00	\N
1990	T11	\N	0.00	49.00	49.00	2	f	f	\N	2024-09-18 12:00:00	\N	49.00	Mamie
1993	\N	\N	0.00	6.00	6.00	1	t	f	\N	2024-09-20 12:00:00	\N	0.00	Emporté
1996	\N	\N	0.00	10.00	10.00	1	t	f	\N	2024-09-20 12:00:00	\N	0.00	Emporté
1999	\N	\N	-85.64	0.00	-85.64	1	f	t	\N	2024-09-16 12:00:00	\N	0.00	\N
2002	\N	\N	-166.36	0.00	-166.36	1	f	t	\N	2024-10-05 12:00:00	\N	0.00	\N
2005	T4	\N	59.00	0.00	59.00	2	f	f	\N	2024-09-26 12:00:00	\N	59.00	Célia
2011	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-09-27 12:00:00	\N	0.00	\N
2014	\N	\N	-28.40	0.00	-28.40	1	f	t	\N	2024-09-27 12:00:00	\N	0.00	\N
2017	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-09-28 12:00:00	\N	0.00	\N
2020	T14	\N	0.00	35.00	35.00	2	f	f	\N	2024-10-02 12:00:00	\N	0.00	2
2023	\N	\N	-26.84	0.00	-26.84	1	f	t	\N	2024-10-02 12:00:00	\N	0.00	\N
2026	\N	\N	-27.25	0.00	-27.25	1	f	t	\N	2024-10-02 12:00:00	\N	0.00	\N
2029	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-10-02 12:00:00	\N	0.00	\N
2032	\N	\N	6.00	0.00	6.00	1	t	f	\N	2024-10-04 12:00:00	\N	6.00	Emporté
2035	\N	\N	0.00	6.00	0.00	1	t	f	\N	2024-10-04 12:00:00	\N	0.00	Emporté
2038	\N	\N	-28.95	0.00	-28.95	1	f	t	\N	2024-09-11 12:00:00	\N	0.00	\N
2041	T14	\N	20.00	20.00	40.00	1	f	f	\N	2024-10-04 12:00:00	\N	40.00	T14
2044	T11	\N	74.50	0.00	74.50	3	f	f	\N	2024-10-04 12:00:00	\N	74.50	Gene
2047	T2	\N	0.00	41.20	0.00	1	f	f	\N	2024-10-05 12:00:00	\N	0.00	Nathalie
1801	\N	\N	-15.35	0.00	-15.35	1	f	t	\N	2024-08-10 12:00:00	\N	0.00	\N
1813	\N	\N	6.00	0.00	6.00	1	t	f	\N	2024-08-16 12:00:00	\N	6.00	Emporté
1806	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2024-08-09 12:00:00	\N	0.00	\N
1816	\N	\N	-70.00	0.00	-70.00	1	f	t	\N	2024-08-16 12:00:00	\N	0.00	\N
1809	T14	\N	46.40	0.00	46.40	2	f	f	\N	2024-08-16 12:00:00	\N	46.40	JM
1819	\N	\N	-6.49	0.00	-6.49	1	f	t	\N	2024-08-17 12:00:00	\N	0.00	\N
1822	\N	\N	-314.62	0.00	-314.62	1	f	t	\N	2024-06-06 12:00:00	\N	0.00	\N
1825	\N	\N	-108.00	0.00	-108.00	1	f	t	\N	2024-08-21 12:00:00	\N	0.00	\N
1828	\N	\N	0.00	10.00	10.00	1	t	f	\N	2024-08-22 12:00:00	\N	0.00	Emporté
1831	T11	\N	32.00	0.00	32.00	2	f	f	\N	2024-08-23 12:00:00	\N	32.00	T11
1834	\N	\N	0.00	51.00	51.00	3	t	f	\N	2024-08-23 12:00:00	\N	0.00	Emporté
1837	\N	\N	-8.40	0.00	-8.40	1	f	t	\N	2024-08-23 12:00:00	\N	0.00	\N
1840	T4	\N	35.00	0.00	35.00	2	f	f	\N	2024-08-23 12:00:00	\N	35.00	ADAM
1843	T6	\N	0.00	64.00	64.00	2	f	f	\N	2024-08-23 12:00:00	\N	0.00	GUISSET
1846	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-08-23 12:00:00	\N	0.00	\N
1849	T2	\N	0.00	74.90	74.90	2	f	f	\N	2024-08-24 12:00:00	\N	0.00	Tanguy
1852	T9	\N	0.00	67.00	67.00	2	f	f	\N	2024-08-24 12:00:00	\N	0.00	ERIC-IRENE
1855	\N	\N	-243.38	0.00	-243.38	1	f	t	\N	2024-08-26 12:00:00	\N	0.00	\N
1858	T13	\N	37.00	0.00	37.00	1	f	f	\N	2024-08-24 12:00:00	\N	37.00	Isa
1861	\N	\N	-10.00	0.00	-10.00	1	f	t	\N	2024-08-20 12:00:00	\N	0.00	\N
1864	\N	\N	-10.00	0.00	-10.00	1	f	t	\N	2024-08-27 12:00:00	\N	0.00	\N
1867	\N	\N	-65.00	0.00	-65.00	1	f	t	\N	2024-08-28 12:00:00	\N	0.00	\N
1873	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-08-28 12:00:00	\N	0.00	\N
1876	\N	\N	-70.70	0.00	-70.70	1	f	t	\N	2024-08-27 12:00:00	\N	0.00	\N
1879	T9	\N	39.40	0.00	39.40	2	f	f	\N	2024-08-29 12:00:00	\N	39.40	JEUNES
1882	\N	\N	12.00	0.00	12.00	1	t	f	\N	2024-08-30 12:00:00	\N	12.00	Emporté
1885	T8	\N	0.00	175.50	175.50	5	f	f	\N	2024-08-30 12:00:00	\N	0.00	PHILOU
1888	T8	\N	0.00	40.00	40.00	5	f	f	\N	2024-08-30 12:00:00	\N	0.00	PHILOU
1891	T13	\N	94.70	0.00	94.70	3	f	f	\N	2024-08-30 12:00:00	\N	94.70	Voisins
1894	T3	\N	0.00	4.00	4.00	1	f	f	\N	2024-08-30 12:00:00	\N	0.00	MANU
1897	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-08-30 12:00:00	\N	0.00	\N
1900	\N	\N	-21.59	0.00	-21.59	1	f	t	\N	2024-08-31 12:00:00	\N	0.00	\N
1903	T2	\N	80.00	0.00	80.00	2	f	f	\N	2024-08-31 12:00:00	\N	80.00	T2
1906	\N	\N	-12.05	0.00	-12.05	1	f	t	\N	2024-09-04 12:00:00	\N	0.00	\N
1909	T7	\N	54.60	0.00	54.60	3	f	f	\N	2024-09-04 12:00:00	\N	54.60	CHRISTOPHE
1912	\N	\N	0.00	51.00	51.00	3	t	f	\N	2024-09-05 12:00:00	\N	51.00	Emporté
1915	\N	\N	-63.10	0.00	-63.10	1	f	t	\N	2024-08-28 12:00:00	\N	0.00	\N
1918	\N	\N	-23.20	0.00	-23.20	1	f	t	\N	2024-09-05 12:00:00	\N	0.00	\N
1921	\N	\N	0.00	2.00	2.00	1	t	f	\N	2024-09-06 12:00:00	\N	0.00	Emporté
1927	T14	\N	0.00	15.00	15.00	1	f	f	\N	2024-09-06 12:00:00	\N	0.00	MANU
1930	T12	\N	85.50	0.00	85.50	2	f	f	\N	2024-09-06 12:00:00	\N	85.50	T12
1933	\N	\N	-27.65	0.00	-27.65	1	f	t	\N	2024-09-07 12:00:00	\N	0.00	\N
1936	T7	\N	0.00	34.00	34.00	1	f	f	\N	2024-09-07 12:00:00	\N	0.00	T7
1939	T9	\N	0.00	214.20	214.20	3	f	f	\N	2024-09-07 12:00:00	\N	214.20	Marc
1943	T7	\N	0.00	34.50	34.50	1	f	f	\N	2024-09-11 12:00:00	\N	0.00	T7
1946	T14	\N	0.00	22.00	22.00	1	f	f	\N	2024-09-11 12:00:00	\N	0.00	T14
1949	T14	\N	0.00	8.00	8.00	1	t	f	\N	2024-09-11 12:00:00	\N	0.00	T14
1952	T14	\N	9.00	0.00	9.00	1	f	f	\N	2024-09-12 12:00:00	\N	9.00	T14
1955	\N	\N	-115.64	0.00	-115.64	1	f	t	\N	2024-09-12 12:00:00	\N	0.00	\N
1958	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2024-09-11 12:00:00	\N	0.00	\N
1961	T14	\N	0.00	29.00	29.00	1	f	f	\N	2024-09-12 12:00:00	\N	0.00	CHRISTOPHE
1964	\N	\N	18.00	0.00	18.00	3	t	f	\N	2024-09-13 12:00:00	\N	18.00	Emporté
1967	\N	\N	-10.07	0.00	-10.07	1	f	t	\N	2024-09-13 12:00:00	\N	0.00	\N
1970	T10	\N	0.00	38.40	38.40	1	f	f	\N	2024-09-13 12:00:00	\N	38.40	T10
1973	\N	\N	-165.29	0.00	-165.29	1	f	t	\N	2024-09-23 12:00:00	\N	0.00	\N
1976	T2	\N	109.10	0.00	109.10	4	f	f	\N	2024-09-14 12:00:00	\N	109.10	ARNOLD
1979	T6	\N	50.20	0.00	50.20	2	f	f	\N	2024-09-14 12:00:00	\N	50.20	FLAMMAND
1982	T14	\N	92.50	0.00	92.50	3	f	f	\N	2024-09-14 12:00:00	\N	92.50	PIERRET
1985	\N	\N	-243.38	0.00	-243.38	1	f	t	\N	2024-09-16 12:00:00	\N	0.00	\N
1988	\N	\N	-13.60	0.00	-13.60	1	f	t	\N	2024-09-18 12:00:00	\N	0.00	\N
1991	\N	\N	0.00	12.00	12.00	2	t	f	\N	2024-09-20 12:00:00	\N	0.00	Emporté
1994	T9	\N	0.00	39.50	39.50	2	f	f	\N	2024-09-20 12:00:00	\N	0.00	DEWINT
1997	\N	\N	-207.05	0.00	-207.05	1	f	t	\N	2024-09-23 12:00:00	\N	0.00	\N
2000	\N	\N	-15.60	0.00	-15.60	1	f	t	\N	2024-09-09 12:00:00	\N	0.00	\N
2003	T8	\N	63.60	0.00	63.60	3	f	f	\N	2024-09-25 12:00:00	\N	63.60	ARNOLD
2006	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-09-20 12:00:00	\N	0.00	\N
2012	\N	\N	-42.00	0.00	-42.00	1	f	t	\N	2024-09-28 12:00:00	\N	0.00	\N
2015	T5	\N	0.00	80.00	80.00	1	f	f	\N	2024-09-27 12:00:00	\N	0.00	T5
2018	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2024-09-29 12:00:00	\N	0.00	\N
2021	T7	\N	33.70	0.00	33.70	1	f	f	\N	2024-10-02 12:00:00	\N	33.70	T7
2024	T2	\N	0.00	116.20	0.00	3	f	f	\N	2024-10-02 12:00:00	\N	0.00	J-M
2027	\N	\N	-124.81	0.00	-124.81	1	f	t	\N	2024-10-03 12:00:00	\N	0.00	\N
2030	\N	\N	12.00	0.00	12.00	2	t	f	\N	2024-10-03 12:00:00	\N	12.00	Emporté
2033	T10	\N	16.20	0.00	16.20	1	f	f	\N	2024-10-04 12:00:00	\N	16.20	T10
2036	\N	\N	-87.50	0.00	-87.50	1	f	t	\N	2024-09-18 12:00:00	\N	0.00	\N
2039	\N	\N	0.00	17.00	17.00	1	t	f	\N	2024-10-04 12:00:00	\N	0.00	Emporté
2045	T12	\N	44.00	0.00	44.00	2	f	f	\N	2024-10-04 12:00:00	\N	44.00	T12
2048	T12	\N	0.00	86.40	86.40	1	f	f	\N	2024-10-05 12:00:00	\N	86.40	Véro
2051	T9	\N	73.50	0.00	73.50	2	f	f	\N	2024-10-05 12:00:00	\N	73.50	Nelson
2054	\N	\N	-219.75	0.00	-219.75	1	f	t	\N	2024-10-04 12:00:00	\N	0.00	\N
2057	\N	\N	-211.75	0.00	-211.75	1	f	t	\N	2024-09-24 12:00:00	\N	0.00	\N
2058	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-09-16 12:00:00	\N	0.00	\N
1804	T2	\N	77.00	0.00	77.00	3	f	f	\N	2024-08-10 12:00:00	\N	77.00	Monsoeur
1814	T3	\N	0.00	179.00	179.00	4	f	f	\N	2024-08-16 12:00:00	\N	0.00	IRENE
1807	\N	\N	-17.52	0.00	-17.52	1	f	t	\N	2024-08-16 12:00:00	\N	0.00	\N
1810	T8	\N	39.00	39.00	78.00	2	f	f	\N	2024-08-16 12:00:00	\N	78.00	DANIEL
1817	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2024-08-17 12:00:00	\N	0.00	\N
1820	\N	\N	-9.52	0.00	-9.52	1	f	t	\N	2024-08-17 12:00:00	\N	0.00	\N
1823	\N	\N	-13.00	0.00	-13.00	1	f	t	\N	2024-08-16 12:00:00	\N	0.00	\N
1826	T11	\N	71.00	0.00	71.00	3	f	f	\N	2024-08-22 12:00:00	\N	71.00	JEUNES
1829	\N	\N	-572.47	0.00	-572.47	1	f	t	\N	2024-08-22 12:00:00	\N	0.00	\N
1832	T14	\N	0.00	4.50	4.50	1	f	f	\N	2024-08-23 12:00:00	\N	0.00	T14
1835	\N	\N	0.00	0.00	0.00	1	t	f	\N	2024-08-23 12:00:00	\N	0.00	Emporté
1838	\N	\N	-73.62	0.00	-73.62	1	f	t	\N	2024-08-23 12:00:00	\N	0.00	\N
1841	T2	\N	0.00	93.90	93.90	4	f	f	\N	2024-08-23 12:00:00	\N	0.00	DEWINT
1844	T9	\N	0.00	199.40	199.40	7	f	f	\N	2024-08-23 12:00:00	\N	0.00	BOURGUIGNON
1847	\N	\N	-29.50	0.00	-29.50	1	f	t	\N	2024-08-24 12:00:00	\N	0.00	\N
1850	T3	\N	41.00	40.00	81.00	2	f	f	\N	2024-08-24 12:00:00	\N	41.00	DESTEXHE
1853	T12	\N	0.00	48.50	48.50	2	f	f	\N	2024-08-24 12:00:00	\N	0.00	DEHOUSSE
1856	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-08-24 12:00:00	\N	0.00	\N
1859	\N	\N	-44.90	0.00	-44.90	1	f	t	\N	2024-07-26 12:00:00	\N	0.00	\N
1862	\N	\N	-10.00	0.00	-10.00	1	f	t	\N	2024-08-22 12:00:00	\N	0.00	\N
1865	\N	\N	-11.69	0.00	-11.69	1	f	t	\N	2024-08-27 12:00:00	\N	0.00	\N
1868	\N	\N	18.00	0.00	18.00	3	t	f	\N	2024-08-28 12:00:00	\N	18.00	Emporté
1871	T13	\N	0.00	10.00	10.00	1	f	f	\N	2024-08-28 12:00:00	\N	0.00	MANU
1874	\N	\N	-117.50	0.00	-117.50	1	f	t	\N	2024-08-22 12:00:00	\N	0.00	\N
1877	\N	\N	-87.50	0.00	-87.50	1	f	t	\N	2024-08-29 12:00:00	\N	0.00	\N
1880	T11	\N	0.00	39.00	39.00	2	f	f	\N	2024-08-29 12:00:00	\N	0.00	Asia
1886	T7	\N	0.00	40.00	40.00	1	f	f	\N	2024-08-30 12:00:00	\N	0.00	T7
1889	\N	\N	0.00	12.00	12.00	2	t	f	\N	2024-08-30 12:00:00	\N	0.00	Emporté
1892	T4	\N	0.00	80.00	80.00	2	f	f	\N	2024-08-30 12:00:00	\N	0.00	Hannon
1895	T10	\N	239.40	0.00	349.40	8	f	f	\N	2024-08-30 12:00:00	\N	239.40	Elise
1898	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-08-30 12:00:00	\N	0.00	\N
1901	\N	\N	-25.00	0.00	-25.00	1	f	t	\N	2024-08-31 12:00:00	\N	0.00	\N
1904	\N	\N	0.00	6.00	6.00	1	t	f	\N	2024-09-04 12:00:00	\N	0.00	Emporté
1907	\N	\N	-7.42	0.00	-7.42	1	f	t	\N	2024-09-04 12:00:00	\N	0.00	\N
1910	T13	\N	34.00	0.00	34.00	1	f	f	\N	2024-09-04 12:00:00	\N	34.00	T13
1913	\N	\N	-14.00	0.00	-14.00	1	f	t	\N	2024-09-03 12:00:00	\N	0.00	\N
1916	\N	\N	6.00	0.00	6.00	1	t	f	\N	2024-09-05 12:00:00	\N	6.00	Emporté
1919	\N	\N	18.00	0.00	18.00	1	t	f	\N	2024-09-06 12:00:00	\N	18.00	Emporté
1922	T13	\N	28.40	0.00	28.40	2	f	f	\N	2024-09-06 12:00:00	\N	28.40	Sarah
1925	\N	\N	-52.63	0.00	-52.63	1	f	t	\N	2024-09-06 12:00:00	\N	0.00	\N
1928	\N	\N	0.00	39.00	39.00	6	t	f	\N	2024-09-06 12:00:00	\N	0.00	Emporté
1931	T4	\N	168.00	0.00	168.00	4	f	f	\N	2024-09-06 12:00:00	\N	168.00	T4
1934	T14	\N	0.00	53.90	53.90	2	f	f	\N	2024-09-07 12:00:00	\N	0.00	Claude
1937	T4	\N	0.00	188.00	188.00	4	f	f	\N	2024-09-07 12:00:00	\N	0.00	Hansez
1940	T3	\N	0.00	31.50	31.50	1	f	f	\N	2024-09-07 12:00:00	\N	0.00	T3
1944	T8	\N	25.50	0.00	25.50	1	f	f	\N	2024-09-11 12:00:00	\N	25.50	T8
1947	\N	\N	0.00	21.00	21.00	3	t	f	\N	2024-09-11 12:00:00	\N	0.00	Emporté
1950	\N	\N	-219.75	0.00	-219.75	1	f	t	\N	2024-09-04 12:00:00	\N	0.00	\N
1953	T10	\N	0.00	65.60	65.60	2	f	f	\N	2024-09-12 12:00:00	\N	65.60	T10
1956	\N	\N	-22.26	0.00	-22.26	1	f	t	\N	2024-09-11 12:00:00	\N	0.00	\N
1959	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-09-12 12:00:00	\N	0.00	\N
1962	T13	\N	19.70	0.00	19.70	1	f	f	\N	2024-09-12 12:00:00	\N	19.70	DANIEL
1965	T9	\N	0.00	46.20	46.20	2	f	f	\N	2024-09-13 12:00:00	\N	46.20	Mamie
1971	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-09-13 12:00:00	\N	0.00	\N
1974	\N	\N	0.00	17.00	17.00	1	t	f	\N	2024-09-14 12:00:00	\N	0.00	Emporté
1977	T7	\N	60.00	0.00	60.00	2	f	f	\N	2024-09-14 12:00:00	\N	60.00	DELIZEE
1980	T6	\N	52.70	0.00	52.70	2	f	f	\N	2024-09-14 12:00:00	\N	52.70	FLAMMAND
1983	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-09-14 12:00:00	\N	0.00	\N
1986	\N	\N	0.00	63.00	63.00	2	t	f	\N	2024-09-18 12:00:00	\N	63.00	Emporté
1989	\N	\N	-36.68	0.00	-36.68	1	f	t	\N	2024-09-18 12:00:00	\N	0.00	\N
1995	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2024-09-19 12:00:00	\N	0.00	\N
1998	\N	\N	-92.49	0.00	-92.49	1	f	t	\N	2024-09-23 12:00:00	\N	0.00	\N
2001	\N	\N	-88.40	0.00	-88.40	1	f	t	\N	2024-09-06 12:00:00	\N	0.00	\N
2004	\N	\N	-118.33	0.00	-118.33	1	f	t	\N	2024-09-26 12:00:00	\N	0.00	\N
2007	\N	\N	-100.00	0.00	-100.00	1	f	t	\N	2024-09-25 12:00:00	\N	0.00	\N
2010	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-09-27 12:00:00	\N	0.00	\N
2013	\N	\N	-61.16	0.00	-61.16	1	f	t	\N	2024-09-28 12:00:00	\N	0.00	\N
2016	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-09-28 12:00:00	\N	0.00	\N
2019	\N	\N	0.00	12.00	12.00	1	t	f	\N	2024-10-02 12:00:00	\N	0.00	Emporté
2022	T12	\N	179.40	0.00	179.40	8	f	f	\N	2024-10-02 12:00:00	\N	179.40	DANIEL
2025	T14	\N	0.00	4.00	0.00	1	f	f	\N	2024-10-02 12:00:00	\N	0.00	2
2028	\N	\N	-28.45	0.00	-28.45	1	f	t	\N	2024-10-03 12:00:00	\N	0.00	\N
2031	\N	\N	6.00	0.00	6.00	1	t	f	\N	2024-10-03 12:00:00	\N	6.00	Emporté
2034	T9	\N	0.00	31.90	0.00	2	f	f	\N	2024-10-04 12:00:00	\N	0.00	T9
2037	\N	\N	-21.65	0.00	-21.65	1	f	t	\N	2024-09-14 12:00:00	\N	0.00	\N
2040	\N	\N	-32.78	0.00	-32.78	1	f	t	\N	2024-10-04 12:00:00	\N	0.00	\N
2043	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2024-10-04 12:00:00	\N	0.00	\N
2046	T16	\N	29.50	0.00	29.50	2	f	f	\N	2024-10-05 12:00:00	\N	29.50	T16
2050	T4	\N	67.00	0.00	67.00	2	f	f	\N	2024-10-05 12:00:00	\N	67.00	T4
2052	T13	\N	50.00	85.00	135.00	3	f	f	\N	2024-10-05 12:00:00	\N	135.00	T13
2053	\N	\N	-85.00	0.00	-85.00	1	f	t	\N	2024-10-05 12:00:00	\N	0.00	\N
2055	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-09-30 12:00:00	\N	0.00	\N
2056	\N	\N	-98.98	0.00	-98.98	1	f	t	\N	2024-09-30 12:00:00	\N	0.00	\N
2059	\N	\N	-28.00	0.00	-28.00	1	f	t	\N	2024-09-16 12:00:00	\N	0.00	\N
2060	\N	\N	-203.47	0.00	-203.47	1	f	t	\N	2024-09-16 12:00:00	\N	0.00	\N
2335	T14	\N	0.00	33.50	33.50	1	f	f	\N	2024-12-06 12:00:00	\N	0.00	T14
2062	\N	\N	-89.47	0.00	-89.47	1	f	t	\N	2024-10-07 12:00:00	\N	0.00	\N
2063	\N	\N	-27.93	0.00	-27.93	1	f	t	\N	2024-10-04 12:00:00	\N	0.00	\N
8	T4	1496710206	100.50	0.00	100.50	4	f	f	\N	2023-05-05 12:00:00	\N	100.50	Labiouse
2065	\N	\N	-72.00	0.00	-72.00	1	f	t	\N	2024-10-09 12:00:00	\N	0.00	\N
2066	\N	\N	-121.96	0.00	-121.96	1	f	t	\N	2024-10-09 12:00:00	\N	0.00	\N
2337	T2	\N	82.00	0.00	82.00	2	f	f	\N	2024-12-06 12:00:00	\N	82.00	ELODIE
2068	\N	\N	-9.98	0.00	-9.98	1	f	t	\N	2024-10-10 12:00:00	\N	0.00	\N
2069	\N	\N	-23.58	0.00	-23.58	1	f	t	\N	2024-10-10 12:00:00	\N	0.00	\N
2338	T7	\N	53.00	0.00	53.00	1	f	f	\N	2024-12-06 12:00:00	\N	53.00	T7
9	T2	3	0.00	97.50	97.50	2	f	f	\N	2023-05-05 12:00:00	\N	51.00	Filou
2340	\N	\N	-70.00	0.00	-70.00	1	f	t	\N	2024-12-06 12:00:00	\N	0.00	\N
2341	\N	\N	-150.00	0.00	-150.00	1	f	t	\N	2024-12-04 12:00:00	\N	0.00	\N
10	T10	743392239	205.00	0.00	205.00	5	f	f	\N	2023-05-05 12:00:00	\N	205.00	Nic
2343	T13	\N	0.00	27.00	0.00	2	f	f	\N	2024-12-07 12:00:00	\N	0.00	JM
2344	T5	\N	0.00	44.00	0.00	2	f	f	\N	2024-12-07 12:00:00	\N	0.00	T5
11	T8	1105205458	0.00	116.50	116.50	2	f	f	\N	2023-05-05 12:00:00	\N	67.00	Stéphane&Laety
2346	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-12-07 12:00:00	\N	0.00	\N
2347	\N	\N	-168.61	0.00	-168.61	1	f	t	\N	2024-12-07 12:00:00	\N	0.00	\N
12	T4	-1769468414	0.00	47.50	47.50	2	f	f	\N	2023-05-06 12:00:00	\N	30.00	Laurent
2349	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-12-08 12:00:00	\N	0.00	\N
2350	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-12-08 12:00:00	\N	0.00	\N
13	T7	-2047331794	0.00	43.00	43.00	2	f	f	\N	2023-05-06 12:00:00	\N	0.00	Véro
2352	\N	\N	-100.00	0.00	-100.00	1	f	t	\N	2024-12-09 12:00:00	\N	0.00	\N
2353	\N	\N	-278.42	0.00	-278.42	1	f	t	\N	2025-01-04 12:00:00	\N	0.00	\N
17	T4	3	0.00	118.00	118.00	3	f	f	\N	2023-05-12 12:00:00	\N	58.50	Philippe
2355	\N	\N	-72.36	0.00	-72.36	1	f	t	\N	2024-12-12 12:00:00	\N	0.00	\N
2356	\N	\N	0.00	10.00	10.00	1	t	f	\N	2024-12-13 12:00:00	\N	10.00	Emporté
2418	\N	\N	-78.00	0.00	-78.00	1	f	t	\N	2025-01-10 12:00:00	\N	0.00	\N
2358	\N	\N	0.00	0.00	0.00	1	t	f	\N	2024-12-13 12:00:00	\N	0.00	Emporté
2359	T14	\N	0.00	18.00	18.00	1	f	f	\N	2024-12-13 12:00:00	\N	18.00	MANU
2361	T8	\N	70.00	0.00	70.00	7	f	f	\N	2024-12-13 12:00:00	\N	70.00	Maman Victor
2362	\N	\N	-8.99	0.00	-8.99	1	f	t	\N	2024-12-13 12:00:00	\N	0.00	\N
2430	\N	\N	-33.65	0.00	-33.65	1	f	t	\N	2025-01-11 12:00:00	\N	0.00	\N
2364	T10	\N	144.40	0.00	144.40	4	f	f	\N	2024-12-14 12:00:00	\N	144.40	FRED
2365	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2024-12-14 12:00:00	\N	0.00	\N
2431	\N	\N	-484.00	0.00	-484.00	1	f	t	\N	2025-01-06 12:00:00	\N	0.00	\N
2367	\N	\N	-97.44	0.00	-97.44	1	f	t	\N	2024-12-16 12:00:00	\N	0.00	\N
2368	T5	\N	165.50	0.00	165.50	5	f	f	\N	2024-12-19 12:00:00	\N	165.50	T5
2433	\N	\N	-100.00	0.00	-100.00	1	f	t	\N	2025-01-11 12:00:00	\N	0.00	\N
2370	T11	\N	0.00	44.00	44.00	2	f	f	\N	2024-12-20 12:00:00	\N	44.00	T11
2371	T13	\N	0.00	38.00	38.00	1	f	f	\N	2024-12-20 12:00:00	\N	18.00	FILOU
2434	\N	\N	-113.44	0.00	-113.44	1	f	t	\N	2025-01-13 12:00:00	\N	0.00	\N
2373	\N	\N	-48.41	0.00	-48.41	1	f	t	\N	2024-12-20 12:00:00	\N	0.00	\N
2374	\N	\N	-13.10	0.00	-13.10	1	f	t	\N	2024-12-20 12:00:00	\N	0.00	\N
2436	\N	\N	-8.46	0.00	-8.46	1	f	t	\N	2025-01-16 12:00:00	\N	0.00	\N
2376	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2024-12-21 12:00:00	\N	0.00	\N
2377	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2024-12-21 12:00:00	\N	0.00	\N
22	T4	-2118670673	0.00	130.00	130.00	4	f	f	\N	2023-05-13 12:00:00	\N	106.00	Pierre
2379	\N	\N	-36.59	0.00	-36.59	1	f	t	\N	2024-12-28 12:00:00	\N	0.00	\N
2380	\N	\N	-98.00	0.00	-98.00	1	f	t	\N	2024-12-28 12:00:00	\N	0.00	\N
32	T4	967995154	0.00	61.00	61.00	2	f	f	\N	2023-05-19 12:00:00	\N	54.50	Chantal
2382	T9	\N	47.60	0.00	47.60	2	f	f	\N	2024-12-28 12:00:00	\N	47.60	FLOREE
2383	T8	\N	0.00	99.50	99.50	2	f	f	\N	2024-12-28 12:00:00	\N	0.00	T8
2388	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2025-01-01 12:00:00	\N	0.00	\N
2389	\N	\N	-96.07	0.00	-96.07	1	f	t	\N	2025-01-03 12:00:00	\N	0.00	\N
2391	T12	\N	0.00	38.40	38.40	2	f	f	\N	2025-01-03 12:00:00	\N	0.00	T12
2392	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2025-01-03 12:00:00	\N	0.00	\N
2394	\N	\N	0.00	8.00	8.00	1	t	f	\N	2025-01-04 12:00:00	\N	0.00	Emporté
2395	\N	\N	-177.55	0.00	-177.55	1	f	t	\N	2025-01-04 12:00:00	\N	0.00	\N
2397	T5	\N	0.00	41.50	41.50	2	f	f	\N	2025-01-04 12:00:00	\N	0.00	CLAUDE
2400	T7	\N	32.00	32.00	64.00	2	f	f	\N	2025-01-04 12:00:00	\N	64.00	T7
2401	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2025-01-06 12:00:00	\N	0.00	\N
2403	\N	\N	-44.58	0.00	-44.58	1	f	t	\N	2025-01-06 12:00:00	\N	0.00	\N
2404	\N	\N	-30.60	0.00	-30.60	1	f	t	\N	2025-01-02 12:00:00	\N	0.00	\N
2406	\N	\N	-14.00	0.00	-14.00	1	f	t	\N	2025-01-07 12:00:00	\N	0.00	\N
2407	\N	\N	-30.60	0.00	-30.60	1	f	t	\N	2025-01-08 12:00:00	\N	0.00	\N
2409	\N	\N	-64.55	0.00	-64.55	1	f	t	\N	2025-01-07 12:00:00	\N	0.00	\N
2410	\N	\N	-103.50	0.00	-103.50	1	f	t	\N	2025-01-07 12:00:00	\N	0.00	\N
2413	\N	\N	-32.55	0.00	-32.55	1	f	t	\N	2025-01-10 12:00:00	\N	0.00	\N
2415	\N	\N	-51.59	0.00	-51.59	1	f	t	\N	2025-01-10 12:00:00	\N	0.00	\N
2416	\N	\N	0.00	18.00	18.00	3	t	f	\N	2025-01-10 12:00:00	\N	0.00	Emporté
2439	T12	\N	0.00	33.10	33.10	2	f	f	\N	2025-01-17 12:00:00	\N	0.00	NANAS
2442	\N	\N	0.00	6.00	6.00	1	t	f	\N	2025-01-17 12:00:00	\N	0.00	Emporté
2443	\N	\N	12.00	0.00	12.00	2	t	f	\N	2025-01-17 12:00:00	\N	12.00	Emporté
2445	T9	\N	0.00	63.20	63.20	2	f	f	\N	2025-01-17 12:00:00	\N	0.00	T9
2449	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2025-01-18 12:00:00	\N	0.00	\N
2458	\N	\N	-46.31	0.00	-46.31	1	f	t	\N	2025-01-23 12:00:00	\N	0.00	\N
2061	\N	\N	-39.95	0.00	-39.95	1	f	t	\N	2024-09-30 12:00:00	\N	0.00	\N
2064	\N	\N	-75.25	0.00	-75.25	1	f	t	\N	2024-10-07 12:00:00	\N	0.00	\N
2067	\N	\N	-20.00	0.00	-20.00	1	f	t	\N	2024-10-09 12:00:00	\N	0.00	\N
2070	\N	\N	0.00	20.00	20.00	1	t	f	\N	2024-10-10 12:00:00	\N	0.00	Emporté
2072	\N	\N	7.00	0.00	7.00	1	t	f	\N	2024-10-11 12:00:00	\N	7.00	Emporté
2073	\N	\N	0.00	5.00	5.00	1	t	f	\N	2024-10-11 12:00:00	\N	5.00	Emporté
2074	T8	\N	54.50	0.00	54.50	6	f	f	\N	2024-10-11 12:00:00	\N	54.50	DANIEL
2078	T14	\N	0.00	17.00	17.00	1	f	f	\N	2024-10-11 12:00:00	\N	0.00	T14
2079	\N	\N	-23.22	0.00	-23.22	1	f	t	\N	2024-10-11 12:00:00	\N	0.00	\N
2080	T3	\N	71.00	0.00	71.00	3	f	f	\N	2024-10-11 12:00:00	\N	71.00	Lejeune
2081	T11	\N	0.00	51.40	51.40	2	f	f	\N	2024-10-11 12:00:00	\N	0.00	Lejeune
2082	T4	\N	0.00	52.50	52.50	2	f	f	\N	2024-10-11 12:00:00	\N	35.00	T4
2083	\N	\N	-9.87	0.00	-9.87	1	f	t	\N	2024-10-12 12:00:00	\N	0.00	\N
2084	\N	\N	-104.94	0.00	-104.94	1	f	t	\N	2024-10-10 12:00:00	\N	0.00	\N
2085	\N	\N	-243.38	0.00	-243.38	1	f	t	\N	2024-10-07 12:00:00	\N	0.00	\N
2086	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-10-11 12:00:00	\N	0.00	\N
2087	T12	\N	84.00	0.00	84.00	2	f	f	\N	2024-10-12 12:00:00	\N	84.00	Anonyme
2088	T9	\N	58.00	0.00	58.00	2	f	f	\N	2024-10-12 12:00:00	\N	58.00	Lescrenier
2089	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-10-12 12:00:00	\N	0.00	\N
2092	\N	\N	0.00	4.70	4.70	1	t	f	\N	2024-10-16 12:00:00	\N	4.70	Emporté
2093	\N	\N	-132.00	0.00	-132.00	1	f	t	\N	2024-10-16 12:00:00	\N	0.00	\N
2094	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2024-10-14 12:00:00	\N	0.00	\N
2095	\N	\N	0.00	4.00	4.00	1	t	f	\N	2024-10-16 12:00:00	\N	4.00	Emporté
2096	\N	\N	-8.00	0.00	-8.00	1	f	t	\N	2024-10-16 12:00:00	\N	0.00	\N
2097	\N	\N	-24.31	0.00	-24.31	1	f	t	\N	2024-10-16 12:00:00	\N	0.00	\N
2099	\N	\N	-39.71	0.00	-39.71	1	f	t	\N	2024-10-16 12:00:00	\N	0.00	\N
2100	\N	\N	-102.31	0.00	-102.31	1	f	t	\N	2024-10-17 12:00:00	\N	0.00	\N
2101	\N	\N	0.00	12.00	0.00	1	t	f	\N	2024-10-18 12:00:00	\N	0.00	Emporté
2102	\N	\N	0.00	13.00	0.00	2	t	f	\N	2024-10-18 12:00:00	\N	0.00	Emporté
2104	T11	\N	186.00	0.00	186.00	7	f	f	\N	2024-10-18 12:00:00	\N	186.00	Daniel
2106	\N	\N	-27.00	0.00	-27.00	1	f	t	\N	2024-10-18 12:00:00	\N	0.00	\N
2107	\N	\N	-4.28	0.00	-4.28	1	f	t	\N	2024-10-18 12:00:00	\N	0.00	\N
2108	\N	\N	0.00	6.00	0.00	1	t	f	\N	2024-10-18 12:00:00	\N	0.00	Emporté
2109	\N	\N	0.00	30.00	0.00	1	t	f	\N	2024-10-18 12:00:00	\N	0.00	Emporté
2110	\N	\N	0.00	34.00	0.00	2	t	f	\N	2024-10-18 12:00:00	\N	0.00	Emporté
2111	T2	\N	0.00	61.00	0.00	2	f	f	\N	2024-10-18 12:00:00	\N	0.00	T2
2112	T10	\N	97.20	0.00	97.20	3	f	f	\N	2024-10-18 12:00:00	\N	97.20	Laurence
2113	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-10-18 12:00:00	\N	0.00	\N
2114	\N	\N	-28.52	0.00	-28.52	1	f	t	\N	2024-10-19 12:00:00	\N	0.00	\N
2115	\N	\N	-46.22	0.00	-46.22	1	f	t	\N	2024-10-19 12:00:00	\N	0.00	\N
2116	T9	\N	0.00	56.00	56.00	2	f	f	\N	2024-10-19 12:00:00	\N	36.00	Guillermo
2117	T2	\N	0.00	49.40	49.40	2	f	f	\N	2024-10-19 12:00:00	\N	45.00	Petrozino
2119	T10	\N	0.00	199.50	199.50	4	f	f	\N	2024-10-19 12:00:00	\N	49.00	stephane et leatitia
2120	\N	\N	0.00	34.00	34.00	1	t	f	\N	2024-10-19 12:00:00	\N	0.00	Emporté
2121	T10	\N	0.00	54.00	54.00	4	t	f	\N	2024-10-19 12:00:00	\N	0.00	stephane et leatitia
2123	T5	\N	0.00	123.00	123.00	2	f	f	\N	2024-10-19 12:00:00	\N	0.00	Fred
2124	T13	\N	0.00	26.00	26.00	1	f	f	\N	2024-10-19 12:00:00	\N	0.00	Steph
2125	\N	\N	6.00	0.00	6.00	1	t	f	\N	2024-10-24 12:00:00	\N	6.00	Emporté
2126	\N	\N	-14.00	0.00	-14.00	1	f	t	\N	2024-10-24 12:00:00	\N	0.00	\N
2127	\N	\N	-127.81	0.00	-127.81	1	f	t	\N	2024-10-21 12:00:00	\N	0.00	\N
2128	\N	\N	-28.00	0.00	-28.00	1	f	t	\N	2024-10-18 12:00:00	\N	0.00	\N
2129	\N	\N	-80.00	0.00	-80.00	1	f	t	\N	2024-10-14 12:00:00	\N	0.00	\N
2130	\N	\N	-70.45	0.00	-70.45	1	f	t	\N	2024-10-24 12:00:00	\N	0.00	\N
2131	\N	\N	-98.56	0.00	-98.56	1	f	t	\N	2024-10-21 12:00:00	\N	0.00	\N
2132	\N	\N	-68.00	0.00	-68.00	1	f	t	\N	2024-10-23 12:00:00	\N	0.00	\N
2133	T9	\N	250.00	0.00	250.00	7	f	f	\N	2024-10-25 12:00:00	\N	250.00	T9
2134	\N	\N	0.00	34.00	34.00	1	t	f	\N	2024-10-25 12:00:00	\N	0.00	Emporté
2136	\N	\N	0.00	28.00	28.00	1	t	f	\N	2024-10-25 12:00:00	\N	0.00	Emporté
2137	\N	\N	-22.00	0.00	-22.00	1	f	t	\N	2024-10-25 12:00:00	\N	0.00	\N
2138	\N	\N	-12.00	0.00	-12.00	1	f	t	\N	2024-10-25 12:00:00	\N	0.00	\N
2139	\N	\N	-57.13	0.00	-57.13	1	f	t	\N	2024-10-25 12:00:00	\N	0.00	\N
2140	T8	\N	0.00	499.70	499.70	12	f	f	\N	2024-10-25 12:00:00	\N	129.00	Marc
2141	\N	\N	-156.09	0.00	-156.09	1	f	t	\N	2024-10-25 12:00:00	\N	0.00	\N
2142	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-10-25 12:00:00	\N	0.00	\N
2143	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-10-25 12:00:00	\N	0.00	\N
2144	T5	\N	0.00	56.00	56.00	1	f	f	\N	2024-10-25 12:00:00	\N	0.00	T5
2145	T14	\N	0.00	10.00	10.00	1	f	f	\N	2024-10-26 12:00:00	\N	10.00	T14
2147	\N	\N	-66.87	0.00	-66.87	1	f	t	\N	2024-10-26 12:00:00	\N	0.00	\N
2148	\N	\N	-140.00	0.00	-140.00	1	f	t	\N	2024-10-26 12:00:00	\N	0.00	\N
2149	\N	\N	-20.00	0.00	-20.00	1	f	t	\N	2024-10-26 12:00:00	\N	0.00	\N
2150	T9	\N	27.50	0.00	27.50	1	f	f	\N	2024-10-26 12:00:00	\N	27.50	T9
2151	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-10-28 12:00:00	\N	0.00	\N
2152	\N	\N	-97.35	0.00	-97.35	1	f	t	\N	2024-10-28 12:00:00	\N	0.00	\N
2153	\N	\N	-500.62	0.00	-500.62	1	f	t	\N	2024-10-28 12:00:00	\N	0.00	\N
2154	\N	\N	-55.00	0.00	-55.00	1	f	t	\N	2024-10-28 12:00:00	\N	0.00	\N
2155	\N	\N	-51.89	0.00	-51.89	1	f	t	\N	2024-10-27 12:00:00	\N	0.00	\N
2156	\N	\N	-26.55	0.00	-26.55	1	f	t	\N	2024-10-27 12:00:00	\N	0.00	\N
33	T8	-1931747542	141.00	0.00	141.00	3	f	f	\N	2023-05-19 12:00:00	\N	141.00	Guillaume
2158	\N	\N	-24.30	0.00	-24.30	1	f	t	\N	2024-10-29 12:00:00	\N	0.00	\N
2336	T4	\N	0.00	166.00	166.00	4	f	f	\N	2024-12-06 12:00:00	\N	0.00	T4
2161	T2	\N	0.00	98.20	98.20	2	f	f	\N	2024-10-30 12:00:00	\N	0.00	Véro
34	T2	1378554073	232.00	408.00	640.00	18	f	f	\N	2023-05-20 12:00:00	\N	403.00	T2
2164	T14	\N	10.00	0.00	10.00	1	f	f	\N	2024-10-31 12:00:00	\N	10.00	T14
2339	T9	\N	0.00	307.90	307.90	6	f	f	\N	2024-12-06 12:00:00	\N	111.00	DENIS
2167	T14	\N	0.00	7.50	7.50	1	f	f	\N	2024-10-31 12:00:00	\N	0.00	T14
356	T10	-1632933197	49.00	0.00	49.00	2	f	f	\N	2023-09-06 12:00:00	\N	49.00	Wéry
2170	T4	\N	0.00	10.00	10.00	1	f	f	\N	2024-10-31 12:00:00	\N	0.00	T4
2342	\N	\N	-20.00	0.00	-20.00	1	f	t	\N	2024-12-07 12:00:00	\N	0.00	\N
2173	\N	\N	0.00	12.00	12.00	2	t	f	\N	2024-10-31 12:00:00	\N	12.00	Emporté
58	T4	1297670515	136.00	0.00	136.00	4	f	f	\N	2023-05-26 12:00:00	\N	136.00	Marraine
2176	\N	\N	0.00	34.00	34.00	4	t	f	\N	2024-10-31 12:00:00	\N	24.00	Emporté
2345	T9	\N	250.00	86.80	336.80	10	f	f	\N	2024-12-07 12:00:00	\N	336.80	ALEX
2179	T12	\N	0.00	12.00	12.00	2	t	f	\N	2024-10-31 12:00:00	\N	12.00	voisine
59	T3	-1868135159	61.00	30.50	91.50	3	f	f	\N	2023-05-26 12:00:00	\N	61.50	Gaelle
2182	T8	\N	0.00	40.00	40.00	4	t	f	\N	2024-10-31 12:00:00	\N	24.00	mega mindy
2348	\N	\N	-73.40	0.00	-73.40	1	f	t	\N	2024-12-12 12:00:00	\N	0.00	\N
2185	T2	\N	0.00	7.50	7.50	1	f	f	\N	2024-10-31 12:00:00	\N	0.00	Rudy
63	T11	-1769468414	0.00	76.50	76.50	2	f	f	\N	2023-05-27 12:00:00	\N	46.50	Laurent
2188	\N	\N	0.00	34.00	0.00	2	t	f	\N	2024-11-01 12:00:00	\N	0.00	Emporté
2351	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-12-08 12:00:00	\N	0.00	\N
2191	T8	\N	0.00	57.50	0.00	2	f	f	\N	2024-11-01 12:00:00	\N	0.00	T8
74	T4	1588048427	0.00	57.00	57.00	2	f	f	\N	2023-06-02 12:00:00	\N	41.00	Elise
2194	\N	\N	-67.00	0.00	-67.00	1	f	t	\N	2024-11-01 12:00:00	\N	0.00	\N
2354	\N	\N	-51.10	0.00	-51.10	1	f	t	\N	2024-12-09 12:00:00	\N	0.00	\N
2197	T11	\N	131.50	0.00	131.50	4	f	f	\N	2024-11-01 12:00:00	\N	131.50	LION
77	T15	1647538147	98.00	0.00	98.00	1	f	f	\N	2023-06-03 12:00:00	\N	98.00	Pirard
2200	\N	\N	-3.78	0.00	-3.78	1	f	t	\N	2024-11-03 12:00:00	\N	0.00	\N
2357	T14	\N	0.00	22.50	22.50	1	f	f	\N	2024-12-13 12:00:00	\N	22.50	T14
2203	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2024-11-01 12:00:00	\N	0.00	\N
79	T11	-1631695881	78.50	0.00	78.50	2	f	f	\N	2023-06-03 12:00:00	\N	78.50	Moray
2360	\N	\N	-18.00	0.00	-18.00	1	f	t	\N	2024-12-13 12:00:00	\N	0.00	\N
2414	\N	\N	-18.19	0.00	-18.19	1	f	t	\N	2025-01-07 12:00:00	\N	0.00	\N
2363	\N	\N	-9.00	0.00	-9.00	1	f	t	\N	2024-12-13 12:00:00	\N	0.00	\N
2417	\N	\N	0.00	13.00	13.00	1	t	f	\N	2025-01-10 12:00:00	\N	0.00	Emporté
2366	\N	\N	-132.21	0.00	-132.21	1	f	t	\N	2024-12-16 12:00:00	\N	0.00	\N
2429	\N	\N	-8.00	0.00	-8.00	1	f	t	\N	2025-01-11 12:00:00	\N	0.00	\N
2369	\N	\N	0.00	36.40	36.40	1	t	f	\N	2024-12-20 12:00:00	\N	36.40	Emporté
2447	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2025-01-17 12:00:00	\N	0.00	\N
2372	\N	\N	-10.92	0.00	-10.92	1	f	t	\N	2024-12-20 12:00:00	\N	0.00	\N
2450	\N	\N	-78.27	0.00	-78.27	1	f	t	\N	2025-01-22 12:00:00	\N	0.00	\N
2375	\N	\N	18.00	0.00	18.00	1	t	f	\N	2024-12-20 12:00:00	\N	18.00	Emporté
2378	\N	\N	-168.61	0.00	-168.61	1	f	t	\N	2025-01-09 12:00:00	\N	0.00	\N
2682	T14	\N	0.00	12.00	12.00	1	f	f	\N	2025-03-22 12:00:00	\N	0.00	Manu
2381	T6	\N	0.00	187.90	187.90	7	f	f	\N	2024-12-28 12:00:00	\N	0.00	SCHREURS
2687	\N	\N	-31.03	0.00	-31.03	1	f	t	\N	2025-03-22 12:00:00	\N	0.00	\N
2384	T11	\N	0.00	96.50	96.50	2	f	f	\N	2024-12-28 12:00:00	\N	0.00	T11
2688	\N	\N	-49.45	0.00	-49.45	1	f	t	\N	2025-03-21 12:00:00	\N	0.00	\N
2717	T13	\N	16.00	0.00	16.00	1	f	f	\N	2025-03-28 12:00:00	\N	16.00	MANU
2396	\N	\N	0.00	34.00	34.00	2	t	f	\N	2025-01-04 12:00:00	\N	0.00	Emporté
81	T2	-1531179267	0.00	149.50	149.50	4	f	f	\N	2023-06-03 12:00:00	\N	95.50	JM
2399	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2025-01-04 12:00:00	\N	0.00	\N
82	T8	1647291379	0.00	353.00	353.00	9	f	f	\N	2023-06-03 12:00:00	\N	227.00	Mike
2402	\N	\N	-28.00	0.00	-28.00	1	f	t	\N	2025-01-16 12:00:00	\N	0.00	\N
127	T11	-1632933197	0.00	36.00	36.00	1	f	f	\N	2023-06-16 12:00:00	\N	36.00	Wéry
2405	\N	\N	-251.65	0.00	-251.65	1	f	t	\N	2025-01-07 12:00:00	\N	0.00	\N
2408	\N	\N	-104.73	0.00	-104.73	1	f	t	\N	2025-01-08 12:00:00	\N	0.00	\N
2441	\N	\N	-151.37	0.00	-151.37	1	f	t	\N	2025-01-20 12:00:00	\N	0.00	\N
2444	\N	\N	0.00	6.00	6.00	1	t	f	\N	2025-01-17 12:00:00	\N	0.00	Emporté
2456	\N	\N	-296.77	0.00	-296.77	1	f	t	\N	2025-02-13 12:00:00	\N	0.00	\N
2459	\N	\N	-26.00	0.00	-26.00	1	f	t	\N	2025-01-23 12:00:00	\N	0.00	\N
2669	T11	\N	0.00	19.50	19.50	1	f	f	\N	2025-03-20 12:00:00	\N	19.50	Hom
2670	\N	\N	10.00	0.00	10.00	1	t	f	\N	2025-03-20 12:00:00	\N	10.00	Emporté
2678	\N	\N	0.00	20.00	20.00	1	t	f	\N	2025-03-21 12:00:00	\N	0.00	Emporté
2679	T12	\N	0.00	58.00	58.00	2	f	f	\N	2025-03-21 12:00:00	\N	58.00	LEHAUT
2685	T5	\N	0.00	76.50	76.50	2	f	f	\N	2025-03-22 12:00:00	\N	0.00	Chien
2699	\N	\N	-269.00	0.00	-269.00	1	f	t	\N	2025-03-27 12:00:00	\N	0.00	\N
2708	\N	\N	-56.81	0.00	-56.81	1	f	t	\N	2025-03-24 12:00:00	\N	0.00	\N
2711	\N	\N	-32.35	0.00	-32.35	1	f	t	\N	2025-03-28 12:00:00	\N	0.00	\N
2724	\N	\N	-48.00	0.00	-48.00	1	f	t	\N	2025-03-29 12:00:00	\N	0.00	\N
2725	\N	\N	0.00	440.00	440.00	1	t	f	\N	2025-03-29 12:00:00	\N	0.00	Emporté
2157	\N	\N	-243.38	0.00	-243.38	1	f	t	\N	2024-07-19 12:00:00	\N	0.00	\N
91	\N	2113986679	-42.98	0.00	-42.98	1	f	t	\N	2023-06-09 12:00:00	\N	0.00	\N
2159	\N	\N	-47.00	0.00	-47.00	1	f	t	\N	2024-10-30 12:00:00	\N	0.00	\N
2162	T9	\N	0.00	59.00	59.00	2	f	f	\N	2024-10-30 12:00:00	\N	0.00	Caro
2461	\N	\N	-23.09	0.00	-23.09	1	f	t	\N	2025-01-24 12:00:00	\N	0.00	\N
2165	T12	\N	0.00	26.00	26.00	1	f	f	\N	2024-10-31 12:00:00	\N	18.00	DORSAN
129	T4	687226325	150.00	50.00	200.00	5	f	f	\N	2023-06-16 12:00:00	\N	150.00	LOÏC
2168	T14	\N	0.00	5.00	5.00	1	f	f	\N	2024-10-31 12:00:00	\N	0.00	T14
2463	T10	\N	0.00	75.40	75.40	3	f	f	\N	2025-01-24 12:00:00	\N	0.00	TATOUE
2171	T2	\N	0.00	20.00	20.00	1	f	f	\N	2024-10-31 12:00:00	\N	0.00	T2
2464	T5	\N	0.00	104.00	104.00	2	f	f	\N	2025-01-25 12:00:00	\N	0.00	T5
2174	\N	\N	0.00	34.00	34.00	4	t	f	\N	2024-10-31 12:00:00	\N	24.00	Emporté
97	\N	1878081881	-21.05	0.00	-21.05	1	f	t	\N	2023-06-09 12:00:00	\N	0.00	\N
2177	T16	\N	0.00	30.00	30.00	1	f	f	\N	2024-10-31 12:00:00	\N	0.00	Annick
2180	\N	\N	0.00	21.00	21.00	1	t	f	\N	2024-10-31 12:00:00	\N	6.00	Emporté
132	\N	1846656499	-4.89	0.00	-4.89	1	f	t	\N	2023-06-17 12:00:00	\N	0.00	\N
2183	T7	\N	36.00	0.00	36.00	1	t	f	\N	2024-10-31 12:00:00	\N	36.00	elodie flyers
2186	T3	\N	0.00	88.80	88.80	1	f	f	\N	2024-10-31 12:00:00	\N	6.00	Denis
2189	\N	\N	-80.00	0.00	-80.00	1	f	t	\N	2024-10-31 12:00:00	\N	0.00	\N
2466	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2025-01-25 12:00:00	\N	0.00	\N
2192	T2	\N	59.00	0.00	59.00	2	f	f	\N	2024-11-01 12:00:00	\N	59.00	T2
2694	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2025-03-26 12:00:00	\N	0.00	\N
2195	T4	\N	0.00	87.40	62.00	4	f	f	\N	2024-11-01 12:00:00	\N	62.00	LION
2695	\N	\N	-78.74	0.00	-78.74	1	f	t	\N	2025-03-27 12:00:00	\N	0.00	\N
2198	T5	\N	0.00	47.80	32.00	2	f	f	\N	2024-11-01 12:00:00	\N	32.00	allemands
2697	\N	\N	0.00	6.00	6.00	1	t	f	\N	2025-03-27 12:00:00	\N	0.00	Emporté
2201	\N	\N	-79.60	0.00	-79.60	1	f	t	\N	2024-11-02 12:00:00	\N	0.00	\N
2700	T9	\N	0.00	46.50	46.50	2	f	f	\N	2025-03-27 12:00:00	\N	0.00	Dames
2701	\N	\N	-723.44	0.00	-723.44	1	f	t	\N	2025-03-26 12:00:00	\N	0.00	\N
133	\N	1846656499	0.00	-57.70	-57.70	1	f	t	\N	2023-06-17 12:00:00	\N	0.00	\N
109	\N	-769963217	-26.73	0.00	-26.73	1	f	t	\N	2023-06-15 12:00:00	\N	0.00	\N
2719	T10	\N	76.00	0.00	76.00	1	f	f	\N	2025-03-28 12:00:00	\N	76.00	T10
136	T4	-1632933197	75.00	0.00	75.00	2	f	f	\N	2023-06-17 12:00:00	\N	75.00	Wéry
2707	\N	\N	-50.04	0.00	-50.04	1	f	t	\N	2025-03-20 12:00:00	\N	0.00	\N
2760	T9	\N	0.00	17.20	17.20	1	f	f	\N	2025-04-11 12:00:00	\N	0.00	T9
2709	\N	\N	-107.39	0.00	-107.39	1	f	t	\N	2025-03-24 12:00:00	\N	0.00	\N
2710	\N	\N	-108.44	0.00	-108.44	1	f	t	\N	2025-03-03 12:00:00	\N	0.00	\N
139	T6	68822247	0.00	303.50	303.50	9	f	f	\N	2023-06-13 12:00:00	\N	0.00	T6
2713	T11	\N	51.60	0.00	51.60	3	f	f	\N	2025-03-28 12:00:00	\N	51.60	OUVRIERS
124	\N	1878081881	-8.52	0.00	-8.52	1	f	t	\N	2023-06-16 12:00:00	\N	0.00	\N
142	\N	-769963217	-48.81	0.00	-48.81	1	f	t	\N	2023-06-23 12:00:00	\N	0.00	\N
144	\N	-769963217	-27.08	0.00	-27.08	1	f	t	\N	2023-06-28 12:00:00	\N	0.00	\N
145	\N	-769963217	-33.37	0.00	-33.37	1	f	t	\N	2023-06-26 12:00:00	\N	0.00	\N
2718	T8	\N	0.00	16.00	16.00	1	f	f	\N	2025-03-28 12:00:00	\N	0.00	XAVIER
151	T4	232453727	111.00	0.00	111.00	4	f	f	\N	2023-06-28 12:00:00	\N	111.00	Sarah
156	T9	-1319489455	50.00	92.50	142.50	4	f	f	\N	2023-06-30 12:00:00	\N	50.00	Thierry
157	\N	-769963217	-10.39	0.00	-10.39	1	f	t	\N	2023-06-30 12:00:00	\N	0.00	\N
162	T14	6908928	0.00	40.50	40.50	1	f	f	\N	2023-07-01 12:00:00	\N	40.50	Luc Royal Thaï
177	\N	1846656499	0.00	-86.00	-86.00	1	f	t	\N	2023-07-06 12:00:00	\N	0.00	\N
180	\N	672071925	-38.31	0.00	-38.31	1	f	t	\N	2023-07-05 12:00:00	\N	0.00	\N
181	\N	-769963217	-9.91	0.00	-9.91	1	f	t	\N	2023-07-06 12:00:00	\N	0.00	\N
2728	T5	\N	151.40	0.00	151.40	5	f	f	\N	2025-03-29 12:00:00	\N	151.40	anniversaire
2731	\N	\N	-94.34	0.00	-94.34	1	f	t	\N	2025-03-23 12:00:00	\N	0.00	\N
2732	T9	\N	34.00	0.00	34.00	2	f	f	\N	2025-04-02 12:00:00	\N	34.00	BENEDICTE
2733	\N	\N	-7.36	0.00	-7.36	1	f	t	\N	2025-04-02 12:00:00	\N	0.00	\N
2734	\N	\N	-14.40	0.00	-14.40	1	f	t	\N	2025-04-02 12:00:00	\N	0.00	\N
2737	\N	\N	-37.82	0.00	-37.82	1	f	t	\N	2025-04-03 12:00:00	\N	0.00	\N
2739	T13	\N	0.00	18.00	18.00	1	f	f	\N	2025-04-03 12:00:00	\N	0.00	T13
2741	\N	\N	0.00	30.40	30.40	2	t	f	\N	2025-04-04 12:00:00	\N	30.40	Emporté
2744	T6	\N	0.00	93.00	93.00	5	f	f	\N	2025-04-04 12:00:00	\N	93.00	T6
2749	\N	\N	-144.00	0.00	-144.00	1	f	t	\N	2025-04-05 12:00:00	\N	0.00	\N
2750	\N	\N	-87.50	0.00	-87.50	1	f	t	\N	2025-04-10 12:00:00	\N	0.00	\N
2751	\N	\N	-10.33	0.00	-10.33	1	f	t	\N	2025-04-10 12:00:00	\N	0.00	\N
3156	\N	\N	12.00	0.00	12.00	2	t	f	\N	2025-10-04 12:00:00	\N	12.00	Emporté
2758	T10	\N	19.20	0.00	19.20	1	f	f	\N	2025-04-11 12:00:00	\N	19.20	Occupé
2759	T9	\N	29.00	0.00	29.00	10	f	f	\N	2025-04-11 12:00:00	\N	29.00	T9
2762	\N	\N	0.00	10.00	10.00	1	t	f	\N	2025-04-11 12:00:00	\N	10.00	Emporté
2763	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2025-04-11 12:00:00	\N	0.00	\N
2765	T9	\N	0.00	66.00	66.00	2	f	f	\N	2025-04-11 12:00:00	\N	66.00	T9
2766	T7	\N	80.40	0.00	80.40	4	f	f	\N	2025-04-11 12:00:00	\N	80.40	T7
2767	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2025-04-11 12:00:00	\N	0.00	\N
2467	\N	\N	-30.60	0.00	-30.60	1	f	t	\N	2025-01-22 12:00:00	\N	0.00	\N
2160	\N	\N	8.00	0.00	8.00	1	t	f	\N	2024-10-30 12:00:00	\N	8.00	Emporté
2163	\N	\N	-120.00	0.00	-120.00	1	f	t	\N	2024-10-30 12:00:00	\N	0.00	\N
2166	\N	\N	-17.98	0.00	-17.98	1	f	t	\N	2024-10-31 12:00:00	\N	0.00	\N
2169	T12	\N	0.00	15.00	15.00	1	f	f	\N	2024-10-31 12:00:00	\N	0.00	Rudy
2172	\N	\N	0.00	12.00	12.00	2	t	f	\N	2024-10-31 12:00:00	\N	12.00	Emporté
2175	T15	\N	0.00	20.00	20.00	1	f	f	\N	2024-10-31 12:00:00	\N	0.00	Nerea
2178	T3	\N	0.00	56.00	56.00	5	f	f	\N	2024-10-31 12:00:00	\N	30.00	T3
2181	T3	\N	0.00	33.80	33.80	1	f	f	\N	2024-10-31 12:00:00	\N	0.00	T3
2184	T11	\N	33.00	0.00	33.00	3	t	f	\N	2024-10-31 12:00:00	\N	33.00	sœur flyers
2187	\N	\N	-120.00	0.00	-120.00	1	f	t	\N	2024-11-01 12:00:00	\N	0.00	\N
2190	T11	\N	0.00	39.00	0.00	2	f	f	\N	2024-11-01 12:00:00	\N	0.00	T11
2193	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-11-01 12:00:00	\N	0.00	\N
2196	T3	\N	130.70	0.00	130.70	3	f	f	\N	2024-11-01 12:00:00	\N	130.70	MARC
2199	\N	\N	-14.51	0.00	-14.51	1	f	t	\N	2024-11-03 12:00:00	\N	0.00	\N
2202	\N	\N	-2.98	0.00	-2.98	1	f	t	\N	2024-11-03 12:00:00	\N	0.00	\N
2204	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2024-11-01 12:00:00	\N	0.00	\N
2205	\N	\N	0.00	170.00	170.00	10	t	f	\N	2024-11-03 12:00:00	\N	0.00	Emporté
2206	\N	\N	-264.85	0.00	-264.85	1	f	t	\N	2024-11-05 12:00:00	\N	0.00	\N
2207	\N	\N	-81.35	0.00	-81.35	1	f	t	\N	2024-11-06 12:00:00	\N	0.00	\N
2208	\N	\N	-118.00	0.00	-118.00	1	f	t	\N	2024-11-06 12:00:00	\N	0.00	\N
2209	\N	\N	-91.68	0.00	-91.68	1	f	t	\N	2024-11-06 12:00:00	\N	0.00	\N
2210	\N	\N	-8.90	0.00	-8.90	1	f	t	\N	2024-11-06 12:00:00	\N	0.00	\N
2211	T4	\N	178.20	0.00	178.20	8	f	f	\N	2024-11-06 12:00:00	\N	178.20	IFAPME Christian
2212	T10	\N	0.00	228.60	228.60	12	f	f	\N	2024-11-06 12:00:00	\N	0.00	IFAPME
2213	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-11-06 12:00:00	\N	0.00	\N
2214	\N	\N	-69.00	0.00	-69.00	1	f	t	\N	2024-11-06 12:00:00	\N	0.00	\N
2215	\N	\N	-17.41	0.00	-17.41	1	f	t	\N	2024-11-07 12:00:00	\N	0.00	\N
2216	\N	\N	-93.14	0.00	-93.14	1	f	t	\N	2024-11-08 12:00:00	\N	0.00	\N
2217	\N	\N	-17.16	0.00	-17.16	1	f	t	\N	2024-11-08 12:00:00	\N	0.00	\N
2218	\N	\N	0.00	51.00	51.00	3	t	f	\N	2024-11-08 12:00:00	\N	51.00	Emporté
2219	\N	\N	-356.00	0.00	-356.00	1	f	t	\N	2024-11-08 12:00:00	\N	0.00	\N
2220	T2	\N	0.00	36.50	36.50	2	f	f	\N	2024-11-08 12:00:00	\N	0.00	T2
2221	T12	\N	0.00	55.00	55.00	2	f	f	\N	2024-11-08 12:00:00	\N	0.00	T12
2222	T14	\N	0.00	8.00	8.00	1	f	f	\N	2024-11-08 12:00:00	\N	0.00	T14
2223	T4	\N	0.00	19.50	19.50	2	f	f	\N	2024-11-08 12:00:00	\N	0.00	T4
2225	\N	\N	0.00	47.00	47.00	3	t	f	\N	2024-11-08 12:00:00	\N	47.00	Emporté
2226	T12	\N	0.00	105.00	105.00	2	f	f	\N	2024-11-08 12:00:00	\N	0.00	Didier
2227	T9	\N	0.00	215.00	215.00	4	f	f	\N	2024-11-08 12:00:00	\N	0.00	Marc
2228	T8	\N	240.00	0.00	240.00	4	f	f	\N	2024-11-08 12:00:00	\N	240.00	CALBERG
2229	T14	\N	0.00	55.50	55.50	2	f	f	\N	2024-11-08 12:00:00	\N	0.00	Filou
2230	T4	\N	0.00	220.00	220.00	4	f	f	\N	2024-11-08 12:00:00	\N	0.00	Guillaume
2231	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2024-11-08 12:00:00	\N	0.00	\N
2232	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2024-11-08 12:00:00	\N	0.00	\N
2233	\N	\N	-150.00	0.00	-150.00	1	f	t	\N	2024-11-08 12:00:00	\N	0.00	\N
2234	\N	\N	-80.00	0.00	-80.00	1	f	t	\N	2024-11-08 12:00:00	\N	0.00	\N
2235	T12	\N	0.00	0.00	0.00	2	f	f	\N	2024-11-08 12:00:00	\N	0.00	Didier
2236	T14	\N	0.00	0.00	0.00	2	f	f	\N	2024-11-08 12:00:00	\N	0.00	Filou
2237	T4	\N	0.00	0.00	0.00	4	f	f	\N	2024-11-08 12:00:00	\N	0.00	Guillaume
2238	T9	\N	0.00	0.00	0.00	4	f	f	\N	2024-11-08 12:00:00	\N	0.00	Marc
2239	T8	\N	0.00	0.00	0.00	4	f	f	\N	2024-11-08 12:00:00	\N	0.00	CALBERG
2240	T14	\N	0.00	116.00	116.00	4	f	f	\N	2024-11-12 12:00:00	\N	16.00	T14
2241	\N	\N	-50.50	0.00	-50.50	1	f	t	\N	2024-11-10 12:00:00	\N	0.00	\N
2242	\N	\N	-80.00	0.00	-80.00	1	f	t	\N	2024-11-09 12:00:00	\N	0.00	\N
2243	\N	\N	-46.90	0.00	-46.90	1	f	t	\N	2024-11-09 12:00:00	\N	0.00	\N
2244	\N	\N	-101.61	0.00	-101.61	1	f	t	\N	2024-11-07 12:00:00	\N	0.00	\N
2245	\N	\N	-158.26	0.00	-158.26	1	f	t	\N	2024-11-05 12:00:00	\N	0.00	\N
2246	\N	\N	-232.14	0.00	-232.14	1	f	t	\N	2024-11-04 12:00:00	\N	0.00	\N
2247	\N	\N	-45.90	0.00	-45.90	1	f	t	\N	2024-11-02 12:00:00	\N	0.00	\N
2248	\N	\N	-441.59	0.00	-441.59	1	f	t	\N	2024-11-17 12:00:00	\N	0.00	\N
2249	\N	\N	-278.42	0.00	-278.42	1	f	t	\N	2024-12-04 12:00:00	\N	0.00	\N
2250	\N	\N	-243.38	0.00	-243.38	1	f	t	\N	2024-11-12 12:00:00	\N	0.00	\N
2251	T11	\N	0.00	27.50	27.50	1	f	f	\N	2024-11-13 12:00:00	\N	0.00	Seul
2252	\N	\N	0.00	34.00	34.00	2	t	f	\N	2024-11-13 12:00:00	\N	34.00	Emporté
2253	T14	\N	0.00	6.00	6.00	1	f	f	\N	2024-11-13 12:00:00	\N	0.00	Manu
2254	T12	\N	0.00	37.00	37.00	1	f	f	\N	2024-11-14 12:00:00	\N	0.00	OUVRIER
2256	\N	\N	0.00	10.00	10.00	1	t	f	\N	2024-11-15 12:00:00	\N	10.00	Emporté
2257	\N	\N	0.00	10.50	8.00	1	t	f	\N	2024-11-15 12:00:00	\N	8.00	Emporté
2258	T5	\N	160.40	40.10	200.50	5	f	f	\N	2024-11-15 12:00:00	\N	200.50	CHANTAL
2259	T4	\N	8.00	0.00	8.00	1	f	f	\N	2024-11-15 12:00:00	\N	8.00	T4
2260	T4	\N	0.00	119.80	119.80	4	f	f	\N	2024-11-16 12:00:00	\N	0.00	Arnold
2261	T5	\N	115.50	0.00	115.50	3	f	f	\N	2024-11-16 12:00:00	\N	115.50	T5
2264	\N	\N	0.00	17.00	17.00	1	t	f	\N	2024-11-20 12:00:00	\N	0.00	Emporté
2267	T14	\N	68.20	0.00	68.20	2	f	f	\N	2024-11-20 12:00:00	\N	68.20	Couple
2268	\N	\N	-80.91	0.00	-80.91	1	f	t	\N	2024-11-20 12:00:00	\N	0.00	\N
2269	\N	\N	-8.20	0.00	-8.20	1	f	t	\N	2024-11-20 12:00:00	\N	0.00	\N
2270	\N	\N	-102.01	0.00	-102.01	1	f	t	\N	2024-11-13 12:00:00	\N	0.00	\N
2271	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2024-11-20 12:00:00	\N	0.00	\N
2272	\N	\N	0.00	4.00	4.00	1	t	f	\N	2024-11-20 12:00:00	\N	0.00	Emporté
2273	\N	\N	-95.33	0.00	-95.33	1	f	t	\N	2024-11-19 12:00:00	\N	0.00	\N
2274	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2024-11-06 12:00:00	\N	0.00	\N
2275	\N	\N	-3.00	0.00	-3.00	1	f	t	\N	2024-11-21 12:00:00	\N	0.00	\N
2276	T8	\N	95.50	0.00	95.50	2	f	f	\N	2024-11-21 12:00:00	\N	95.50	DANIEL
2277	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2024-11-22 12:00:00	\N	0.00	\N
184	\N	-769963217	0.00	0.00	-6.15	1	f	t	\N	2023-07-08 12:00:00	\N	0.00	\N
2279	\N	\N	0.00	6.00	6.00	1	t	f	\N	2024-11-22 12:00:00	\N	6.00	Emporté
2468	\N	\N	-53.00	0.00	-53.00	1	f	t	\N	2025-01-29 12:00:00	\N	0.00	\N
2282	T14	\N	0.00	18.00	18.00	1	f	f	\N	2024-11-22 12:00:00	\N	0.00	T14
192	\N	-769963217	0.00	-6.44	-6.44	1	f	t	\N	2023-06-29 12:00:00	\N	0.00	\N
2285	T12	\N	147.90	0.00	147.90	4	f	f	\N	2024-11-22 12:00:00	\N	147.90	DESSERS
2471	\N	\N	0.00	18.00	18.00	1	t	f	\N	2025-01-29 12:00:00	\N	0.00	Emporté
2288	T5	\N	0.00	121.80	121.80	1	f	f	\N	2024-11-23 12:00:00	\N	0.00	Occupé
195	\N	363385425	0.00	-50.00	-50.00	1	f	t	\N	2023-06-23 12:00:00	\N	0.00	\N
2291	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-11-23 12:00:00	\N	0.00	\N
2294	\N	\N	-23.41	0.00	-23.41	1	f	t	\N	2024-11-27 12:00:00	\N	0.00	\N
196	\N	363385425	0.00	-50.00	-50.00	1	f	t	\N	2023-06-30 12:00:00	\N	0.00	\N
2300	T9	\N	0.00	46.20	46.20	2	f	f	\N	2024-11-28 12:00:00	\N	0.00	flam
92	\N	1878081881	-10.72	0.00	-10.72	1	f	t	\N	2023-06-09 12:00:00	\N	0.00	\N
2303	\N	\N	-31.55	0.00	-31.55	1	f	t	\N	2024-11-29 12:00:00	\N	0.00	\N
2306	\N	\N	0.00	33.00	33.00	2	t	f	\N	2024-11-29 12:00:00	\N	33.00	Emporté
93	\N	1846656499	0.00	-12.00	-12.00	1	f	t	\N	2023-06-09 12:00:00	\N	0.00	\N
2309	T13	\N	153.40	0.00	153.40	4	f	f	\N	2024-11-29 12:00:00	\N	153.40	Juding
95	T8	456697569	88.50	0.00	88.50	2	f	f	\N	2023-06-09 12:00:00	\N	88.50	Michaël
2312	\N	\N	0.00	102.00	102.00	6	t	f	\N	2024-11-30 12:00:00	\N	34.00	Emporté
96	\N	672071925	0.00	-122.00	-122.00	1	f	t	\N	2023-06-09 12:00:00	\N	0.00	\N
2315	T13	\N	0.00	0.00	15.00	3	f	f	\N	2024-11-30 12:00:00	\N	0.00	JM
2486	\N	\N	0.00	49.00	49.00	3	t	f	\N	2025-01-31 12:00:00	\N	0.00	Emporté
2318	\N	\N	-95.86	0.00	-95.86	1	f	t	\N	2024-12-05 12:00:00	\N	0.00	\N
99	T2	6908928	0.00	121.00	121.00	3	f	f	\N	2023-06-09 12:00:00	\N	70.00	luc
2321	\N	\N	-89.00	0.00	-89.00	1	f	t	\N	2024-12-02 12:00:00	\N	0.00	\N
2324	T13	\N	27.50	0.00	27.50	1	f	f	\N	2024-12-04 12:00:00	\N	27.50	Manu
101	T9	232453727	63.00	0.00	63.00	2	f	f	\N	2023-06-09 12:00:00	\N	63.00	Sarah
2327	\N	\N	-28.00	0.00	-28.00	1	f	t	\N	2024-12-15 12:00:00	\N	0.00	\N
2330	\N	\N	-27.17	0.00	-27.17	1	f	t	\N	2024-12-04 12:00:00	\N	0.00	\N
134	\N	2113986679	-27.43	0.00	-27.43	1	f	t	\N	2023-06-17 12:00:00	\N	0.00	\N
104	\N	363385425	0.00	-50.00	-50.00	1	f	t	\N	2023-06-09 12:00:00	\N	0.00	\N
2498	\N	\N	-107.32	0.00	-107.32	1	f	t	\N	2025-01-25 12:00:00	\N	0.00	\N
105	T11	232453727	43.00	0.00	43.00	2	f	f	\N	2023-06-14 12:00:00	\N	43.00	Sarah
137	\N	672071925	-77.91	0.00	-77.91	1	f	t	\N	2023-06-13 12:00:00	\N	0.00	\N
113	\N	672071925	0.00	-70.00	-70.00	1	f	t	\N	2023-06-16 12:00:00	\N	0.00	\N
116	T8	-1632933197	0.00	62.00	62.00	2	f	f	\N	2023-06-10 12:00:00	\N	37.00	T8
117	T6	-1163187653	236.00	0.00	236.00	4	f	f	\N	2023-06-10 12:00:00	\N	236.00	T6
119	\N	-913310719	0.00	-20.00	-20.00	1	f	t	\N	2023-06-16 12:00:00	\N	0.00	\N
146	\N	-1409108099	0.00	-46.73	-46.73	1	f	t	\N	2023-06-28 12:00:00	\N	0.00	\N
152	T5	1936806253	0.00	167.00	167.00	4	f	f	\N	2023-06-23 12:00:00	\N	167.00	T5
2480	\N	\N	-190.00	0.00	-190.00	1	f	t	\N	2025-01-30 12:00:00	\N	0.00	\N
155	\N	-769963217	-30.86	0.00	-30.86	1	f	t	\N	2023-06-29 12:00:00	\N	0.00	\N
2495	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2025-01-31 12:00:00	\N	0.00	\N
2510	\N	\N	0.00	13.20	13.20	1	t	f	\N	2025-02-07 12:00:00	\N	0.00	Emporté
2528	T2	\N	0.00	8.80	8.80	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
2519	T2	\N	0.00	28.40	28.40	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
2525	T2	\N	0.00	10.00	10.00	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
164	\N	-769963217	-35.29	0.00	-35.29	1	f	t	\N	2023-07-01 12:00:00	\N	0.00	\N
2531	T2	\N	0.00	2.50	2.50	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
2537	T2	\N	0.00	40.40	40.40	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
2540	T2	\N	0.00	73.40	73.40	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
179	\N	-769963217	-23.91	0.00	-23.91	1	f	t	\N	2023-07-05 12:00:00	\N	0.00	\N
2546	T2	\N	0.00	39.10	39.10	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
2549	\N	\N	0.00	367.50	367.50	1	t	f	\N	2025-02-08 12:00:00	\N	0.00	Emporté
2552	\N	\N	0.00	6.00	6.00	1	t	f	\N	2025-02-12 12:00:00	\N	0.00	Emporté
2567	\N	\N	-47.13	0.00	-47.13	1	f	t	\N	2025-02-15 12:00:00	\N	0.00	\N
182	\N	1846656499	0.00	-7.10	-7.10	1	f	t	\N	2023-07-06 12:00:00	\N	0.00	\N
2588	\N	\N	-85.00	0.00	-85.00	1	f	t	\N	2025-02-21 12:00:00	\N	0.00	\N
2600	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2025-02-21 12:00:00	\N	0.00	\N
2564	\N	\N	0.00	6.00	6.00	1	t	f	\N	2025-02-14 12:00:00	\N	0.00	Emporté
2618	T8	\N	0.00	72.00	72.00	1	f	f	\N	2025-02-28 12:00:00	\N	0.00	T8
2591	\N	\N	17.00	0.00	17.00	1	t	f	\N	2025-02-21 12:00:00	\N	17.00	Emporté
2642	T6	\N	48.40	0.00	48.40	1	f	f	\N	2025-03-12 12:00:00	\N	48.40	Apéro
2648	\N	\N	-40.08	0.00	-40.08	1	f	t	\N	2025-03-13 12:00:00	\N	0.00	\N
2661	T11	\N	129.90	0.00	129.90	4	f	f	\N	2025-03-14 12:00:00	\N	129.90	T11
2278	T11	\N	0.00	2.50	2.50	1	f	f	\N	2024-11-22 12:00:00	\N	0.00	T11
185	\N	-769963217	-21.83	0.00	-21.83	1	f	t	\N	2023-06-22 12:00:00	\N	0.00	\N
2280	T14	\N	0.00	36.40	36.40	1	f	f	\N	2024-11-22 12:00:00	\N	0.00	T14
2281	\N	\N	0.00	17.00	17.00	1	t	f	\N	2024-11-22 12:00:00	\N	17.00	Emporté
2469	\N	\N	13.00	0.00	13.00	2	t	f	\N	2025-01-29 12:00:00	\N	13.00	Emporté
2284	T4	\N	0.00	126.20	126.20	5	f	f	\N	2024-11-22 12:00:00	\N	0.00	Axelle
191	\N	-1409108099	0.00	-86.00	-86.00	1	f	t	\N	2023-07-07 12:00:00	\N	0.00	\N
2286	\N	\N	-90.00	0.00	-90.00	1	f	t	\N	2024-11-22 12:00:00	\N	0.00	\N
2287	\N	\N	-35.00	0.00	-35.00	1	f	t	\N	2024-11-22 12:00:00	\N	0.00	\N
2289	T12	\N	0.00	76.60	76.60	2	f	f	\N	2024-11-23 12:00:00	\N	0.00	MAMY
2290	\N	\N	0.00	30.00	30.00	2	t	f	\N	2024-11-23 12:00:00	\N	30.00	Emporté
194	\N	363385425	0.00	-60.00	-60.00	1	f	t	\N	2023-06-17 12:00:00	\N	0.00	\N
2292	T14	\N	0.00	40.00	40.00	1	f	f	\N	2024-11-23 12:00:00	\N	0.00	Denis
2293	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2024-11-22 12:00:00	\N	0.00	\N
2295	T9	\N	0.00	51.00	0.00	2	f	f	\N	2024-11-27 12:00:00	\N	0.00	DADOUMONT
200	T4	-1769468414	0.00	40.00	40.00	2	f	f	\N	2023-07-13 12:00:00	\N	40.00	Laurent
2298	T11	\N	88.50	0.00	88.50	3	f	f	\N	2024-11-27 12:00:00	\N	88.50	MICHEL
2478	\N	\N	0.00	34.00	34.00	2	t	f	\N	2025-01-30 12:00:00	\N	0.00	Emporté
2301	T11	\N	0.00	30.00	30.00	1	f	f	\N	2024-11-28 12:00:00	\N	0.00	thomas
286	T6	1936806253	0.00	135.50	135.50	4	f	f	\N	2023-08-12 12:00:00	\N	66.50	Pasleau
2304	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2024-11-25 12:00:00	\N	0.00	\N
2307	T7	\N	0.00	79.20	79.20	3	f	f	\N	2024-11-29 12:00:00	\N	0.00	Sagot
245	T14	686373030	59.50	0.00	59.50	1	f	f	\N	2023-07-21 12:00:00	\N	59.50	Annick
2310	T3	\N	0.00	0.00	0.00	2	f	f	\N	2024-11-29 12:00:00	\N	0.00	Caro
2313	T5	\N	122.70	0.00	122.70	4	f	f	\N	2024-11-30 12:00:00	\N	122.70	Lion
244	T7	1647606316	78.00	0.00	78.00	2	f	f	\N	2023-07-21 12:00:00	\N	78.00	Adrien
2316	\N	\N	-6.85	0.00	-6.85	1	f	t	\N	2024-11-30 12:00:00	\N	0.00	\N
246	T14	686373030	0.00	4.00	4.00	1	f	f	\N	2023-07-21 12:00:00	\N	4.00	Annick
2319	\N	\N	-26.98	0.00	-26.98	1	f	t	\N	2024-12-04 12:00:00	\N	0.00	\N
287	T2	967995154	133.50	0.00	133.50	5	f	f	\N	2023-08-12 12:00:00	\N	133.50	T2
2322	\N	\N	-14.00	0.00	-14.00	1	f	t	\N	2024-12-03 12:00:00	\N	0.00	\N
2490	\N	\N	0.00	4.00	4.00	1	t	f	\N	2025-02-01 12:00:00	\N	0.00	Emporté
2325	T14	\N	0.00	85.00	85.00	2	f	f	\N	2024-12-04 12:00:00	\N	0.00	Denis
288	T8	1105205458	80.00	302.10	382.10	10	f	f	\N	2023-08-12 12:00:00	\N	161.10	T8
2328	\N	\N	-39.31	0.00	-39.31	1	f	t	\N	2024-12-06 12:00:00	\N	0.00	\N
2331	\N	\N	5.00	0.00	5.00	2	t	f	\N	2024-12-06 12:00:00	\N	5.00	Emporté
295	\N	-1409108099	0.00	-108.00	-108.00	1	f	t	\N	2023-08-17 12:00:00	\N	0.00	\N
2334	T12	\N	0.00	111.00	111.00	2	f	f	\N	2024-12-06 12:00:00	\N	0.00	T12
333	T10	-1770452859	44.00	0.00	44.00	2	f	f	\N	2023-08-31 12:00:00	\N	44.00	Scheffer
338	T4	1120105367	45.00	0.00	45.00	2	f	f	\N	2023-09-01 12:00:00	\N	45.00	Lamarche
339	T3	-1459600805	65.00	0.00	65.00	2	f	f	\N	2023-09-01 12:00:00	\N	65.00	Didier
347	\N	-832235899	0.00	39.00	39.00	3	t	f	\N	2023-09-02 12:00:00	\N	0.00	Emporté
383	T4	1936806253	219.50	0.00	219.50	7	f	f	\N	2023-09-09 12:00:00	\N	219.50	Pasleau
368	T9	1936806253	76.00	0.00	76.00	3	f	f	\N	2023-09-08 12:00:00	\N	76.00	Fille pasleau
377	T4	402457021	0.00	126.00	126.00	4	f	f	\N	2023-09-08 12:00:00	\N	0.00	Camille
404	T10	-1632933197	0.00	48.50	48.50	1	f	f	\N	2023-09-15 12:00:00	\N	0.00	Wéry
428	T8	1458243463	0.00	44.00	44.00	2	f	f	\N	2023-09-22 12:00:00	\N	0.00	PARMENTIER
2484	\N	\N	-31.38	0.00	-31.38	1	f	t	\N	2025-01-31 12:00:00	\N	0.00	\N
2496	\N	\N	-7.49	0.00	-7.49	1	f	t	\N	2025-02-04 12:00:00	\N	0.00	\N
2505	\N	\N	-89.21	0.00	-89.21	1	f	t	\N	2025-02-06 12:00:00	\N	0.00	\N
2523	T2	\N	0.00	10.00	10.00	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
2532	T2	\N	0.00	4.00	4.00	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
2535	T2	\N	0.00	13.00	13.00	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
2547	T2	\N	0.00	12.00	12.00	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
2556	\N	\N	-30.08	0.00	-30.08	1	f	t	\N	2025-02-08 12:00:00	\N	0.00	\N
2580	\N	\N	-14.94	0.00	-14.94	1	f	t	\N	2025-02-19 12:00:00	\N	0.00	\N
2589	\N	\N	-22.56	0.00	-22.56	1	f	t	\N	2025-02-20 12:00:00	\N	0.00	\N
2592	\N	\N	-36.00	0.00	-36.00	1	f	t	\N	2025-02-21 12:00:00	\N	0.00	\N
2601	\N	\N	-106.93	0.00	-106.93	1	f	t	\N	2025-02-17 12:00:00	\N	0.00	\N
2604	\N	\N	-5.00	0.00	-5.00	1	f	t	\N	2025-02-26 12:00:00	\N	0.00	\N
2607	\N	\N	-28.00	0.00	-28.00	1	f	t	\N	2025-02-17 12:00:00	\N	0.00	\N
2634	\N	\N	-109.01	0.00	-109.01	1	f	t	\N	2025-02-25 12:00:00	\N	0.00	\N
2637	\N	\N	-28.00	0.00	-28.00	1	f	t	\N	2025-03-14 12:00:00	\N	0.00	\N
2640	\N	\N	6.00	0.00	6.00	1	t	f	\N	2025-03-12 12:00:00	\N	6.00	Emporté
2586	T8	\N	0.00	14.00	14.00	1	f	f	\N	2025-02-19 12:00:00	\N	0.00	T8
2652	\N	\N	-50.99	0.00	-50.99	1	f	t	\N	2025-03-13 12:00:00	\N	0.00	\N
2689	\N	\N	-37.38	0.00	-37.38	1	f	t	\N	2025-03-21 12:00:00	\N	0.00	\N
2619	T8	\N	44.20	0.00	44.20	2	f	f	\N	2025-02-28 12:00:00	\N	44.20	T8
2625	T2	\N	86.00	0.00	86.00	1	f	f	\N	2025-03-01 12:00:00	\N	86.00	T2
2643	T5	\N	251.10	0.00	251.10	10	f	f	\N	2025-03-12 12:00:00	\N	251.10	Saint Laurent
2649	\N	\N	-59.20	0.00	-59.20	1	f	t	\N	2025-03-13 12:00:00	\N	0.00	\N
2655	\N	\N	-76.18	0.00	-76.18	1	f	t	\N	2025-03-13 12:00:00	\N	0.00	\N
2296	T7	\N	44.00	0.00	44.00	2	f	f	\N	2024-11-27 12:00:00	\N	44.00	MARIE
2299	\N	\N	0.00	6.00	6.00	1	t	f	\N	2024-11-28 12:00:00	\N	6.00	Emporté
434	T3	804734236	0.00	83.00	83.00	2	f	f	\N	2023-09-22 12:00:00	\N	0.00	Flas
2302	T7	\N	64.40	0.00	64.40	2	f	f	\N	2024-11-29 12:00:00	\N	64.40	ARNOLD
2305	\N	\N	-32.00	0.00	-32.00	1	f	t	\N	2024-11-28 12:00:00	\N	0.00	\N
440	T7	-1632933197	0.00	52.50	52.50	1	f	f	\N	2023-09-23 12:00:00	\N	0.00	Wéry
2311	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2024-11-29 12:00:00	\N	0.00	\N
443	T8	-186986451	239.50	0.00	239.50	9	f	f	\N	2023-09-23 12:00:00	\N	239.50	Sébastien
2317	\N	\N	-26.95	0.00	-26.95	1	f	t	\N	2024-11-30 12:00:00	\N	0.00	\N
464	T14	-479672637	22.00	0.00	22.00	2	f	f	\N	2023-10-04 12:00:00	\N	22.00	T14
2320	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2024-12-01 12:00:00	\N	0.00	\N
470	T11	-1769468414	0.00	64.00	64.00	2	f	f	\N	2023-10-05 12:00:00	\N	22.50	T11
2323	T7	\N	25.00	0.00	25.00	1	f	f	\N	2024-12-04 12:00:00	\N	25.00	OUVRIER
494	T7	-1632933197	0.00	66.00	66.00	1	f	f	\N	2023-10-06 12:00:00	\N	0.00	Wéry
2326	T8	\N	0.00	108.00	108.00	2	f	f	\N	2024-12-04 12:00:00	\N	0.00	FILOU
2485	\N	\N	30.00	0.00	30.00	5	t	f	\N	2025-01-31 12:00:00	\N	30.00	Emporté
2329	\N	\N	-122.73	0.00	-122.73	1	f	t	\N	2024-12-06 12:00:00	\N	0.00	\N
595	T16	-479672637	23.00	0.00	23.00	1	f	f	\N	2023-10-27 12:00:00	\N	23.00	T16
515	T4	1936806253	0.00	53.00	53.00	2	f	f	\N	2023-10-13 12:00:00	\N	0.00	Célia
382	T8	428145220	0.00	53.00	53.00	2	f	f	\N	2023-09-09 12:00:00	\N	0.00	Philippe
414	T4	1751496538	29.00	0.00	29.00	2	f	f	\N	2023-09-16 12:00:00	\N	29.00	Marie
417	T8	-2091502576	0.00	48.60	48.60	2	f	f	\N	2023-09-20 12:00:00	\N	0.00	0499879834
2500	T10	\N	0.00	40.20	40.20	2	f	f	\N	2025-02-05 12:00:00	\N	40.20	DAMES
426	T10	-1632933197	0.00	62.00	62.00	1	f	f	\N	2023-09-21 12:00:00	\N	0.00	Wéry
536	T14	686373030	97.00	44.00	141.00	4	f	f	\N	2023-10-20 12:00:00	\N	97.00	Manu
432	T10	1453381743	0.00	74.00	74.00	2	f	f	\N	2023-09-22 12:00:00	\N	36.00	Bonfond
441	T4	1936806253	52.50	50.00	102.50	3	f	f	\N	2023-09-23 12:00:00	\N	52.50	Pasleau
2509	\N	\N	-24.71	0.00	-24.71	1	f	t	\N	2025-02-07 12:00:00	\N	0.00	\N
492	T11	686373030	109.00	0.00	109.00	3	f	f	\N	2023-10-06 12:00:00	\N	109.00	Annick
2512	T12	\N	0.00	43.00	43.00	2	f	f	\N	2025-02-07 12:00:00	\N	0.00	ANGLAIS
495	\N	-1459600805	0.00	45.00	45.00	3	t	f	\N	2023-10-07 12:00:00	\N	0.00	Emporté
498	T4	1936806253	101.50	0.00	101.50	3	f	f	\N	2023-10-07 12:00:00	\N	101.50	Pasleau
507	T14	627317039	0.00	18.50	18.50	1	f	f	\N	2023-10-12 12:00:00	\N	0.00	T14
581	T10	-1632933197	0.00	39.00	39.00	1	f	f	\N	2023-10-25 12:00:00	\N	39.00	Wery
593	T8	-612734926	0.00	46.00	46.00	2	f	f	\N	2023-10-27 12:00:00	\N	0.00	T8
2527	T2	\N	0.00	28.00	28.00	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
2494	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2025-02-01 12:00:00	\N	0.00	\N
2497	\N	\N	-105.92	0.00	-105.92	1	f	t	\N	2025-01-17 12:00:00	\N	0.00	\N
2503	\N	\N	-34.65	0.00	-34.65	1	f	t	\N	2025-02-06 12:00:00	\N	0.00	\N
2545	T2	\N	0.00	75.00	75.00	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
2533	T2	\N	0.00	4.00	4.00	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
2548	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2025-02-08 12:00:00	\N	0.00	\N
2536	T2	\N	4.40	0.00	4.40	1	f	f	\N	2025-02-08 12:00:00	\N	4.40	T2
2551	\N	\N	28.00	0.00	28.00	2	t	f	\N	2025-02-12 12:00:00	\N	28.00	Emporté
2539	T2	\N	0.00	34.50	34.50	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
2557	\N	\N	-39.00	0.00	-39.00	1	f	t	\N	2025-02-14 12:00:00	\N	0.00	\N
2566	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2025-02-14 12:00:00	\N	0.00	\N
2569	\N	\N	-72.08	0.00	-72.08	1	f	t	\N	2025-02-15 12:00:00	\N	0.00	\N
2581	\N	\N	-26.10	0.00	-26.10	1	f	t	\N	2025-02-19 12:00:00	\N	0.00	\N
2587	\N	\N	-328.70	0.00	-328.70	1	f	t	\N	2025-02-20 12:00:00	\N	0.00	\N
2605	\N	\N	-311.55	0.00	-311.55	1	f	t	\N	2025-02-24 12:00:00	\N	0.00	\N
2575	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2025-02-15 12:00:00	\N	0.00	\N
2617	\N	\N	-41.96	0.00	-41.96	1	f	t	\N	2025-02-28 12:00:00	\N	0.00	\N
2578	\N	\N	-25.00	0.00	-25.00	1	f	t	\N	2025-02-16 12:00:00	\N	0.00	\N
2647	\N	\N	-220.00	0.00	-220.00	1	f	t	\N	2025-03-13 12:00:00	\N	0.00	\N
2653	\N	\N	-69.25	0.00	-69.25	1	f	t	\N	2025-03-13 12:00:00	\N	0.00	\N
2662	\N	\N	-5.00	0.00	-5.00	1	f	t	\N	2025-03-14 12:00:00	\N	0.00	\N
3035	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2025-08-22 12:00:00	\N	0.00	\N
2602	\N	\N	0.00	34.00	34.00	2	t	f	\N	2025-02-22 12:00:00	\N	34.00	Emporté
2632	\N	\N	-101.94	0.00	-101.94	1	f	t	\N	2025-02-03 12:00:00	\N	0.00	\N
2635	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2025-03-01 12:00:00	\N	0.00	\N
2638	\N	\N	-30.60	0.00	-30.60	1	f	t	\N	2025-03-03 12:00:00	\N	0.00	\N
2641	T13	\N	44.00	0.00	44.00	2	f	f	\N	2025-03-12 12:00:00	\N	44.00	CHAPON
2644	T9	\N	57.00	0.00	57.00	2	f	f	\N	2025-03-12 12:00:00	\N	57.00	CLAESSEN
2650	\N	\N	-46.35	0.00	-46.35	1	f	t	\N	2025-03-13 12:00:00	\N	0.00	\N
2656	T12	\N	0.00	58.00	58.00	2	f	f	\N	2025-03-14 12:00:00	\N	58.00	T12
2665	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2025-03-14 12:00:00	\N	0.00	\N
2666	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2025-03-14 12:00:00	\N	0.00	\N
2668	\N	\N	-45.76	0.00	-45.76	1	f	t	\N	2025-03-19 12:00:00	\N	0.00	\N
2671	\N	\N	0.00	15.00	15.00	1	t	f	\N	2025-03-20 12:00:00	\N	15.00	Emporté
2674	T10	\N	0.00	29.00	29.00	7	f	f	\N	2025-03-21 12:00:00	\N	0.00	Boissons  Repas
2771	\N	\N	-5.00	0.00	-5.00	1	f	t	\N	2025-04-18 12:00:00	\N	0.00	\N
605	\N	-479672637	40.00	0.00	40.00	2	t	f	\N	2023-10-28 12:00:00	\N	40.00	Emporté
3036	\N	\N	34.00	0.00	34.00	1	t	f	\N	2025-08-30 12:00:00	\N	34.00	Emporté
620	T9	-1632933197	0.00	47.00	47.00	1	f	f	\N	2023-11-03 12:00:00	\N	0.00	Sabine
3039	T13	\N	8.50	0.00	8.50	1	f	f	\N	2025-08-30 12:00:00	\N	8.50	RUDY
2782	\N	\N	-375.00	0.00	-375.00	1	f	t	\N	2025-04-19 12:00:00	\N	0.00	\N
516	T8	687226325	75.00	143.00	218.00	9	f	f	\N	2023-10-13 12:00:00	\N	81.00	Ludo&Caro
388	T10	-1632933197	71.00	0.00	71.00	2	f	f	\N	2023-09-13 12:00:00	\N	71.00	Wéry
394	T10	-1801614408	0.00	24.00	24.00	1	f	f	\N	2023-09-14 12:00:00	\N	0.00	JM
2791	\N	\N	-381.15	0.00	-381.15	1	f	t	\N	2025-04-22 12:00:00	\N	0.00	\N
3045	\N	\N	-20.99	0.00	-20.99	1	f	t	\N	2025-08-30 12:00:00	\N	0.00	\N
528	T4	3	0.00	215.00	215.00	6	f	f	\N	2023-10-20 12:00:00	\N	0.00	Filou
427	T2	1751496538	42.00	0.00	42.00	2	f	f	\N	2023-09-21 12:00:00	\N	42.00	Marie
433	\N	-1769468414	0.00	22.50	22.50	2	t	f	\N	2023-09-22 12:00:00	\N	22.50	Emporté
463	T10	-1632933197	0.00	44.00	44.00	1	f	f	\N	2023-10-04 12:00:00	\N	44.00	Wéry
2803	\N	\N	26.00	0.00	26.00	2	t	f	\N	2025-04-25 12:00:00	\N	26.00	Emporté
594	T2	402457021	92.00	0.00	92.00	3	f	f	\N	2023-10-27 12:00:00	\N	92.00	T2
597	T4	347476400	65.00	0.00	65.00	2	f	f	\N	2023-10-27 12:00:00	\N	65.00	T4
2809	\N	\N	-38.99	0.00	-38.99	1	f	t	\N	2025-04-30 12:00:00	\N	0.00	\N
3054	T6	\N	55.40	0.00	55.40	2	f	f	\N	2025-09-05 12:00:00	\N	55.40	amoureux
619	\N	2098037424	0.00	2.50	2.50	1	t	f	\N	2023-10-31 12:00:00	\N	0.00	Emporté
638	\N	-833506467	0.00	31.50	31.50	4	t	f	\N	2023-11-08 12:00:00	\N	0.00	Emporté
779	T9	-1931747542	0.00	160.00	160.00	4	f	f	\N	2023-12-02 12:00:00	\N	60.00	Guillaume
785	T11	-1632933197	75.50	0.00	75.50	2	f	f	\N	2023-12-06 12:00:00	\N	75.50	Sabine
788	\N	-479672637	0.00	11.00	11.00	1	t	f	\N	2023-12-07 12:00:00	\N	11.00	Emporté
2824	\N	\N	-48.28	0.00	-48.28	1	f	t	\N	2025-05-02 12:00:00	\N	0.00	\N
791	T8	-1632933197	0.00	52.00	52.00	1	f	f	\N	2023-12-08 12:00:00	\N	0.00	Sabine
800	T12	-1632933197	0.00	33.00	33.00	1	f	f	\N	2023-12-08 12:00:00	\N	15.00	Sabine
3063	\N	\N	6.00	0.00	6.00	1	t	f	\N	2025-09-12 12:00:00	\N	6.00	Emporté
2830	\N	\N	-246.84	0.00	-246.84	1	f	t	\N	2025-05-02 12:00:00	\N	0.00	\N
803	T8	-867980635	86.50	0.00	86.50	4	f	f	\N	2023-12-09 12:00:00	\N	86.50	Arnold
809	T14	1936806253	0.00	6.00	6.00	1	t	f	\N	2023-12-13 12:00:00	\N	0.00	T14
3066	\N	\N	0.00	12.00	12.00	1	t	f	\N	2025-09-12 12:00:00	\N	0.00	Emporté
821	\N	-479672637	0.00	6.00	6.00	1	t	f	\N	2023-12-15 12:00:00	\N	0.00	Emporté
2839	\N	\N	-28.00	0.00	-28.00	1	f	t	\N	2025-05-17 12:00:00	\N	0.00	\N
827	\N	647511427	40.00	0.00	40.00	3	t	f	\N	2023-12-16 12:00:00	\N	40.00	Emporté
836	T14	-960371656	10.00	0.00	10.00	1	f	f	\N	2023-12-16 12:00:00	\N	10.00	T14
2851	\N	\N	0.00	38.00	38.00	2	t	f	\N	2025-05-09 12:00:00	\N	0.00	Emporté
854	\N	-960371656	0.00	12.00	12.00	2	t	f	\N	2023-12-21 12:00:00	\N	0.00	Emporté
857	T2	-1632933197	0.00	37.00	37.00	1	f	f	\N	2023-12-21 12:00:00	\N	0.00	SABINE
869	\N	-960371656	0.00	10.50	10.50	3	t	f	\N	2023-12-22 12:00:00	\N	0.00	Emporté
2869	T5	\N	0.00	70.00	70.00	2	f	f	\N	2025-05-16 12:00:00	\N	70.00	T5
2776	T5	\N	20.00	0.00	20.00	1	f	f	\N	2025-04-18 12:00:00	\N	20.00	T5
2878	T6	\N	0.00	51.00	51.00	2	f	f	\N	2025-05-23 12:00:00	\N	51.00	Manu
2773	\N	\N	-27.63	0.00	-27.63	1	f	t	\N	2025-04-18 12:00:00	\N	0.00	\N
3090	T9	\N	20.00	0.00	20.00	1	f	f	\N	2025-09-21 12:00:00	\N	20.00	3: Marie et fanny
2884	\N	\N	-100.00	0.00	-100.00	1	f	t	\N	2025-05-23 12:00:00	\N	0.00	\N
2779	\N	\N	-55.00	0.00	-55.00	1	f	t	\N	2025-04-18 12:00:00	\N	0.00	\N
2887	\N	\N	-2.10	0.00	-2.10	1	f	t	\N	2025-05-28 12:00:00	\N	0.00	\N
2788	T13	\N	0.00	20.00	20.00	1	f	f	\N	2025-04-23 12:00:00	\N	20.00	ERIC
2812	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2025-04-30 12:00:00	\N	0.00	\N
3105	T6	\N	4.00	0.00	4.00	1	f	f	\N	2025-09-21 12:00:00	\N	4.00	Sylvain
2818	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2025-05-02 12:00:00	\N	0.00	\N
2842	\N	\N	-46.15	0.00	-46.15	1	f	t	\N	2025-05-09 12:00:00	\N	0.00	\N
3111	T14	\N	51.50	0.00	51.50	2	f	f	\N	2025-09-21 12:00:00	\N	51.50	10:VERO&FANON
2836	\N	\N	13.00	0.00	13.00	1	t	f	\N	2025-05-07 12:00:00	\N	13.00	Emporté
2845	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2025-05-09 12:00:00	\N	0.00	\N
2857	\N	\N	0.00	300.00	300.00	1	t	f	\N	2025-05-10 12:00:00	\N	0.00	Emporté
3123	T14	\N	0.00	10.50	10.50	1	f	f	\N	2025-09-26 12:00:00	\N	0.00	T14
3126	\N	\N	0.00	204.00	204.00	1	t	f	\N	2025-09-26 12:00:00	\N	0.00	Emporté
3135	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2025-09-27 12:00:00	\N	0.00	\N
3138	\N	\N	-87.50	0.00	-87.50	1	f	t	\N	2025-10-02 12:00:00	\N	0.00	\N
3150	T5	\N	123.20	0.00	123.20	4	f	f	\N	2025-10-03 12:00:00	\N	123.20	aurore
3153	T8	\N	69.00	0.00	69.00	2	f	f	\N	2025-10-04 12:00:00	\N	69.00	T8
896	T2	-1931747542	0.00	130.80	130.80	4	f	f	\N	2024-01-01 12:00:00	\N	0.00	T2
899	\N	1105205458	0.00	72.00	72.00	3	t	f	\N	2024-01-01 12:00:00	\N	0.00	Emporté
2783	\N	\N	-150.00	0.00	-150.00	1	f	t	\N	2025-04-19 12:00:00	\N	0.00	\N
905	\N	-960371656	10.00	0.00	10.00	1	t	f	\N	2024-01-05 12:00:00	\N	10.00	Emporté
910	T12	1899778452	0.00	98.00	98.00	2	f	f	\N	2024-01-05 12:00:00	\N	0.00	Legros
911	T13	-479672637	0.00	5.00	5.00	1	f	f	\N	2024-01-05 12:00:00	\N	0.00	Manu
916	\N	-960371656	24.00	0.00	24.00	2	t	f	\N	2024-01-06 12:00:00	\N	24.00	Emporté
925	T8	686373030	0.00	46.00	46.00	2	f	f	\N	2024-01-10 12:00:00	\N	26.00	T8
2804	T9	\N	0.00	90.20	90.20	2	f	f	\N	2025-04-25 12:00:00	\N	0.00	T9
931	\N	-1057878124	0.00	69.00	69.00	3	t	f	\N	2024-01-12 12:00:00	\N	0.00	Emporté
932	T13	-1163187653	30.50	0.00	30.50	3	t	f	\N	2024-01-12 12:00:00	\N	30.50	Pierre
934	T3	-1931747542	108.50	0.00	108.50	2	f	f	\N	2024-01-12 12:00:00	\N	108.50	T3
2813	T7	\N	0.00	77.00	77.00	1	f	f	\N	2025-04-30 12:00:00	\N	77.00	T7
935	T3	-1931747542	26.00	0.00	26.00	2	f	f	\N	2024-01-12 12:00:00	\N	26.00	Frere Rhum
938	T7	-867980635	66.00	0.00	66.00	2	f	f	\N	2024-01-13 12:00:00	\N	66.00	T7
940	T13	-960371656	33.00	0.00	33.00	1	f	f	\N	2024-01-13 12:00:00	\N	33.00	T13
3052	\N	\N	0.00	31.00	31.00	1	t	f	\N	2025-09-05 12:00:00	\N	0.00	Emporté
941	T9	-960371656	234.00	0.00	234.00	8	f	f	\N	2024-01-13 12:00:00	\N	234.00	Fred
2825	T7	\N	76.00	0.00	76.00	2	f	f	\N	2025-05-02 12:00:00	\N	76.00	2 Dames
649	T9	1458243463	0.00	72.00	72.00	3	f	f	\N	2023-11-10 12:00:00	\N	0.00	Famille
2828	\N	\N	-13.00	0.00	-13.00	1	f	t	\N	2025-05-02 12:00:00	\N	0.00	\N
3055	T12	\N	41.50	0.00	41.50	2	f	f	\N	2025-09-05 12:00:00	\N	41.50	3X20
3056	\N	\N	-311.55	0.00	-311.55	1	f	t	\N	2025-09-04 12:00:00	\N	0.00	\N
656	T13	686373030	20.00	0.00	20.00	1	f	f	\N	2023-11-10 12:00:00	\N	20.00	T13
657	T13	-12121761	40.00	0.00	40.00	2	f	f	\N	2023-11-10 12:00:00	\N	40.00	T13
2840	\N	\N	-14.40	0.00	-14.40	1	f	t	\N	2025-05-15 12:00:00	\N	0.00	\N
660	T7	-867980635	0.00	63.50	63.50	2	f	f	\N	2023-11-10 12:00:00	\N	0.00	Arnold
3061	\N	\N	-37.57	0.00	-37.57	1	f	t	\N	2025-09-12 12:00:00	\N	0.00	\N
2855	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2025-05-09 12:00:00	\N	0.00	\N
2858	\N	\N	0.00	108.00	108.00	5	t	f	\N	2025-05-14 12:00:00	\N	108.00	Emporté
3067	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2025-09-12 12:00:00	\N	0.00	\N
3068	\N	\N	15.00	0.00	15.00	1	t	f	\N	2025-09-13 12:00:00	\N	15.00	Emporté
2870	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2025-05-16 12:00:00	\N	0.00	\N
3070	T5	\N	45.00	0.00	45.00	2	f	f	\N	2025-09-13 12:00:00	\N	45.00	T5
3074	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2025-09-13 12:00:00	\N	0.00	\N
2888	T12	\N	0.00	21.00	21.00	1	t	f	\N	2025-05-28 12:00:00	\N	0.00	OUVRIER
2891	\N	\N	0.00	34.00	34.00	2	t	f	\N	2025-05-30 12:00:00	\N	34.00	Emporté
3077	\N	\N	0.00	6.00	6.00	1	t	f	\N	2025-09-17 12:00:00	\N	0.00	Emporté
2900	T7	\N	0.00	17.20	17.20	1	f	f	\N	2025-05-30 12:00:00	\N	0.00	T7
2775	T5	\N	0.00	20.00	20.00	1	f	f	\N	2025-04-18 12:00:00	\N	0.00	T5
3082	\N	\N	0.00	7.00	7.00	1	t	f	\N	2025-09-19 12:00:00	\N	0.00	Emporté
3085	\N	\N	-18.26	0.00	-18.26	1	f	t	\N	2025-09-19 12:00:00	\N	0.00	\N
2774	\N	\N	12.00	0.00	12.00	1	t	f	\N	2025-04-18 12:00:00	\N	12.00	Emporté
3088	T6	\N	109.00	0.00	109.00	4	f	f	\N	2025-09-20 12:00:00	\N	109.00	FOURNEAUX
2778	T6	\N	18.00	0.00	18.00	1	f	f	\N	2025-04-18 12:00:00	\N	18.00	T6
3092	T11	\N	0.00	20.00	20.00	1	f	f	\N	2025-09-21 12:00:00	\N	0.00	5: Oli et laurence
2780	T5	\N	29.00	0.00	29.00	1	f	f	\N	2025-04-18 12:00:00	\N	29.00	T5
3094	T11	\N	19.00	0.00	19.00	1	f	f	\N	2025-09-21 12:00:00	\N	19.00	MARIE
3095	T11	\N	0.00	9.50	9.50	1	t	f	\N	2025-09-21 12:00:00	\N	0.00	T11
2792	\N	\N	-42.57	0.00	-42.57	1	f	t	\N	2025-04-25 12:00:00	\N	0.00	\N
2798	\N	\N	0.00	10.00	10.00	1	t	f	\N	2025-04-25 12:00:00	\N	10.00	Emporté
2831	\N	\N	0.00	10.00	10.00	1	t	f	\N	2025-05-03 12:00:00	\N	10.00	Emporté
2846	\N	\N	-110.00	0.00	-110.00	1	f	t	\N	2025-05-09 12:00:00	\N	0.00	\N
2849	\N	\N	55.00	0.00	55.00	1	t	f	\N	2025-05-09 12:00:00	\N	55.00	Emporté
672	T4	-960371656	0.00	176.00	176.00	7	f	f	\N	2023-11-11 12:00:00	\N	147.00	Fievez
673	T11	-1801614408	0.00	462.90	462.90	12	f	f	\N	2023-11-11 12:00:00	\N	0.00	JMI
3098	T13	\N	0.00	57.60	57.60	2	f	f	\N	2025-09-21 12:00:00	\N	57.60	9: Les baboukis
687	T2	1936806253	51.50	0.00	51.50	2	f	f	\N	2023-11-17 12:00:00	\N	51.50	Célia
702	T4	-960371656	0.00	145.50	145.50	4	f	f	\N	2023-11-18 12:00:00	\N	97.50	FIEVEZ
2793	\N	\N	54.00	0.00	54.00	1	t	f	\N	2025-04-25 12:00:00	\N	54.00	Emporté
707	T12	-1632933197	0.00	38.50	38.50	1	f	f	\N	2023-11-22 12:00:00	\N	0.00	Sabine
709	T9	3	0.00	220.50	220.50	4	f	f	\N	2023-11-22 12:00:00	\N	0.00	Filou
2799	T8	\N	0.00	55.40	55.40	2	f	f	\N	2025-04-25 12:00:00	\N	0.00	T8
710	\N	-1769468414	0.00	50.00	50.00	1	t	f	\N	2023-11-22 12:00:00	\N	0.00	Emporté
724	\N	-259160509	60.50	0.00	60.50	5	t	f	\N	2023-11-24 12:00:00	\N	60.50	Emporté
734	T4	-960371656	0.00	149.00	149.00	7	f	f	\N	2023-11-24 12:00:00	\N	0.00	T4
780	T12	967995154	0.00	106.00	106.00	3	f	f	\N	2023-12-02 12:00:00	\N	46.00	Chantal
740	T12	-1997312316	58.50	0.00	58.50	2	f	f	\N	2023-11-25 12:00:00	\N	58.50	Elogia
758	T4	6908928	0.00	113.00	113.00	4	f	f	\N	2023-12-01 12:00:00	\N	50.00	Luc
792	T14	-479672637	10.00	0.00	10.00	1	t	f	\N	2023-12-08 12:00:00	\N	10.00	Manu
798	T2	351063202	0.00	143.00	143.00	4	f	f	\N	2023-12-08 12:00:00	\N	66.00	Lo Presti
2823	T5	\N	0.00	22.90	22.90	1	f	f	\N	2025-05-02 12:00:00	\N	0.00	3 dames
2790	\N	\N	-454.99	0.00	-454.99	1	f	t	\N	2025-04-22 12:00:00	\N	0.00	\N
2826	T10	\N	0.00	45.70	45.70	2	f	f	\N	2025-05-02 12:00:00	\N	45.70	Tshirt
2829	\N	\N	-10.00	0.00	-10.00	1	f	t	\N	2025-05-02 12:00:00	\N	0.00	\N
2808	\N	\N	-18.84	0.00	-18.84	1	f	t	\N	2025-04-30 12:00:00	\N	0.00	\N
2811	\N	\N	-32.98	0.00	-32.98	1	f	t	\N	2025-04-19 12:00:00	\N	0.00	\N
2817	\N	\N	0.00	0.00	0.00	1	t	f	\N	2025-05-02 12:00:00	\N	0.00	Emporté
2820	T12	\N	0.00	18.00	18.00	1	f	f	\N	2025-05-02 12:00:00	\N	0.00	Mr seul
2835	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2025-04-29 12:00:00	\N	0.00	\N
2847	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2025-05-09 12:00:00	\N	0.00	\N
2850	\N	\N	0.00	12.00	12.00	2	t	f	\N	2025-05-09 12:00:00	\N	0.00	Emporté
799	T9	-1163187653	0.00	289.00	289.00	6	f	f	\N	2023-12-08 12:00:00	\N	0.00	Pierre
802	T9	-1513168700	78.00	0.00	78.00	2	f	f	\N	2023-12-09 12:00:00	\N	78.00	Mélanie
2895	\N	\N	-30.72	0.00	-30.72	1	f	t	\N	2025-05-30 12:00:00	\N	0.00	\N
2909	\N	\N	-40.47	0.00	-40.47	1	f	t	\N	2025-05-12 12:00:00	\N	0.00	\N
2844	\N	\N	0.00	34.00	34.00	1	t	f	\N	2025-05-09 12:00:00	\N	0.00	Emporté
810	T4	-960371656	0.00	161.00	161.00	3	f	f	\N	2023-12-13 12:00:00	\N	0.00	FIEVET
2868	\N	\N	0.00	6.00	6.00	1	t	f	\N	2025-05-16 12:00:00	\N	6.00	Emporté
2871	T13	\N	0.00	12.00	12.00	1	t	f	\N	2025-05-21 12:00:00	\N	0.00	T13
813	\N	-1769468414	0.00	30.00	30.00	2	t	f	\N	2023-12-13 12:00:00	\N	0.00	Emporté
2877	T11	\N	0.00	38.00	38.00	1	f	f	\N	2025-05-23 12:00:00	\N	38.00	Ouvrier
817	\N	-1571398319	0.00	12.00	12.00	2	t	f	\N	2023-12-14 12:00:00	\N	12.00	Emporté
822	T11	-1632933197	0.00	32.00	32.00	1	f	f	\N	2023-12-15 12:00:00	\N	20.00	Sabine
823	T14	6908928	0.00	64.00	64.00	2	f	f	\N	2023-12-15 12:00:00	\N	30.00	Luc
2886	\N	\N	-10.00	0.00	-10.00	1	f	t	\N	2025-05-28 12:00:00	\N	0.00	\N
2892	T10	\N	0.00	71.50	71.50	4	f	f	\N	2025-05-30 12:00:00	\N	0.00	FAMILLE
2898	T13	\N	0.00	47.40	47.40	2	f	f	\N	2025-05-30 12:00:00	\N	0.00	ELISE
2904	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2025-05-31 12:00:00	\N	0.00	\N
2911	\N	\N	-390.37	0.00	-390.37	1	f	t	\N	2025-04-29 12:00:00	\N	0.00	\N
2912	\N	\N	-79.10	0.00	-79.10	1	f	t	\N	2025-05-15 12:00:00	\N	0.00	\N
2913	\N	\N	0.00	102.00	102.00	6	t	f	\N	2025-06-04 12:00:00	\N	0.00	Emporté
2915	\N	\N	0.00	12.00	12.00	2	t	f	\N	2025-06-06 12:00:00	\N	0.00	Emporté
2918	T11	\N	215.00	0.00	215.00	7	f	f	\N	2025-06-06 12:00:00	\N	215.00	T11
2921	\N	\N	0.00	51.00	51.00	3	t	f	\N	2025-06-06 12:00:00	\N	0.00	Emporté
2928	\N	\N	-100.00	0.00	-100.00	1	f	t	\N	2025-06-06 12:00:00	\N	0.00	\N
2929	\N	\N	0.00	54.00	54.00	1	t	f	\N	2025-06-07 12:00:00	\N	0.00	Emporté
2930	T5	\N	38.70	0.00	38.70	2	f	f	\N	2025-06-07 12:00:00	\N	38.70	T5
2948	\N	\N	-187.46	0.00	-187.46	1	f	t	\N	2025-06-11 12:00:00	\N	0.00	\N
843	\N	-479672637	22.00	0.00	22.00	2	t	f	\N	2023-12-19 12:00:00	\N	22.00	Emporté
2952	T12	\N	14.00	0.00	14.00	1	t	f	\N	2025-06-18 12:00:00	\N	14.00	NANA
3100	\N	\N	6.00	0.00	6.00	1	t	f	\N	2025-09-21 12:00:00	\N	6.00	Emporté
844	T9	1936806253	97.00	0.00	97.00	3	f	f	\N	2023-12-19 12:00:00	\N	97.00	EVE
3103	T9	\N	0.00	49.00	49.00	1	f	f	\N	2025-09-21 12:00:00	\N	0.00	fanny
882	T14	-479672637	0.00	130.00	130.00	1	f	f	\N	2023-12-28 12:00:00	\N	0.00	T14
886	T11	1936806253	140.00	0.00	140.00	3	f	f	\N	2023-12-29 12:00:00	\N	140.00	Eve
2970	\N	\N	-31.29	0.00	-31.29	1	f	t	\N	2025-06-27 12:00:00	\N	0.00	\N
1030	T14	-479672637	0.00	27.00	27.00	2	f	f	\N	2024-02-10 12:00:00	\N	0.00	T14
733	T9	290949060	0.00	72.00	72.00	2	f	f	\N	2023-11-24 12:00:00	\N	0.00	Xavier
735	T11	-1602796250	0.00	82.50	82.50	3	f	f	\N	2023-11-24 12:00:00	\N	0.00	JeanChrist
741	T9	-1931747542	0.00	152.80	152.80	4	f	f	\N	2023-11-25 12:00:00	\N	88.80	Rhum
1032	T10	2047405728	0.00	95.00	95.00	2	f	f	\N	2024-02-10 12:00:00	\N	0.00	DEBATTY
2988	\N	\N	-77.87	0.00	-77.87	1	f	t	\N	2025-08-20 12:00:00	\N	0.00	\N
3112	T8	\N	0.00	59.50	59.50	1	f	f	\N	2025-09-21 12:00:00	\N	0.00	GENE
895	T14	2098037424	84.00	0.00	84.00	3	f	f	\N	2024-01-01 12:00:00	\N	84.00	T14
2997	T2	\N	0.00	42.40	42.40	1	f	f	\N	2025-08-22 12:00:00	\N	0.00	T2
897	T9	1105205458	162.00	0.00	324.00	8	f	f	\N	2024-01-01 12:00:00	\N	162.00	T9
898	T4	1378554073	0.00	192.00	192.00	8	f	f	\N	2024-01-01 12:00:00	\N	0.00	T4
3003	T8	\N	0.00	138.60	138.60	4	f	f	\N	2025-08-23 12:00:00	\N	0.00	MARIEEVE
768	T2	-1632933197	58.50	0.00	58.50	2	f	f	\N	2023-12-01 12:00:00	\N	58.50	Sabine
3006	T14	\N	0.00	45.20	45.20	1	f	f	\N	2025-08-23 12:00:00	\N	45.20	JOCELYNE
3009	T9	\N	0.00	12.00	12.00	1	f	f	\N	2025-08-23 12:00:00	\N	0.00	SABINE
950	\N	522262762	44.00	0.00	44.00	3	t	f	\N	2024-01-19 12:00:00	\N	44.00	Emporté
3012	\N	\N	-44.05	0.00	-44.05	1	f	t	\N	2025-08-23 12:00:00	\N	0.00	\N
952	T2	1496710206	0.00	86.50	86.50	3	f	f	\N	2024-01-19 12:00:00	\N	0.00	Labiouse
3015	\N	\N	-68.70	0.00	-68.70	1	f	t	\N	2025-08-27 12:00:00	\N	0.00	\N
3018	T7	\N	0.00	18.50	18.50	1	f	f	\N	2025-08-27 12:00:00	\N	0.00	RUDY
3122	T6	\N	81.40	0.00	81.40	4	f	f	\N	2025-09-26 12:00:00	\N	81.40	arnold
953	\N	-960371656	47.50	0.00	47.50	3	t	f	\N	2024-01-19 12:00:00	\N	47.50	Emporté
3024	\N	\N	0.00	10.00	10.00	1	t	f	\N	2025-08-29 12:00:00	\N	10.00	Emporté
3125	T8	\N	0.00	95.50	95.50	2	f	f	\N	2025-09-26 12:00:00	\N	0.00	couple
3030	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2025-08-29 12:00:00	\N	0.00	\N
955	T7	1900657782	128.50	0.00	128.50	3	f	f	\N	2024-01-19 12:00:00	\N	128.50	Pirotte
956	T9	428145220	201.00	0.00	201.00	4	f	f	\N	2024-01-19 12:00:00	\N	201.00	Philippe
3127	T9	\N	185.50	0.00	185.50	8	f	f	\N	2025-09-26 12:00:00	\N	185.50	PROF
3128	\N	\N	-26.37	0.00	-26.37	1	f	t	\N	2025-09-26 12:00:00	\N	0.00	\N
1038	T11	1932514883	46.50	0.00	46.50	2	f	f	\N	2024-02-15 12:00:00	\N	46.50	T11
3134	T8	\N	58.00	0.00	58.00	2	f	f	\N	2025-09-27 12:00:00	\N	58.00	Tilman
3137	\N	\N	0.00	7.50	7.50	1	t	f	\N	2025-10-02 12:00:00	\N	0.00	Emporté
3139	\N	\N	-39.40	0.00	-39.40	1	f	t	\N	2025-10-02 12:00:00	\N	0.00	\N
3142	\N	\N	6.00	0.00	6.00	1	t	f	\N	2025-10-03 12:00:00	\N	6.00	Emporté
3149	T10	\N	0.00	115.00	115.00	2	f	f	\N	2025-10-03 12:00:00	\N	0.00	père fille
3151	\N	\N	0.00	22.00	22.00	1	t	f	\N	2025-10-04 12:00:00	\N	0.00	Emporté
2950	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2025-06-13 12:00:00	\N	0.00	\N
3154	T9	\N	64.00	0.00	64.00	2	f	f	\N	2025-10-04 12:00:00	\N	64.00	T9
3155	\N	\N	-75.00	0.00	-75.00	1	f	t	\N	2025-10-04 12:00:00	\N	0.00	\N
2958	\N	\N	-11.30	0.00	-11.30	1	f	t	\N	2025-06-20 12:00:00	\N	0.00	\N
2991	\N	\N	0.00	6.00	6.00	1	t	f	\N	2025-08-20 12:00:00	\N	0.00	Emporté
3166	T5	\N	0.00	82.00	82.00	3	f	f	\N	2025-10-10 12:00:00	\N	0.00	MAÎTRE
3107	T12	\N	0.00	144.00	144.00	1	f	f	\N	2025-09-21 12:00:00	\N	0.00	6: Pollet
3109	T5	\N	32.00	0.00	32.00	1	f	f	\N	2025-09-21 12:00:00	\N	32.00	MARIE
3172	\N	\N	-136.80	0.00	-136.80	1	f	t	\N	2025-10-10 12:00:00	\N	0.00	\N
3110	T12	\N	0.00	22.00	22.00	1	f	f	\N	2025-09-21 12:00:00	\N	0.00	6: Pollet
3175	T12	\N	84.50	0.00	84.50	2	f	f	\N	2025-10-16 12:00:00	\N	84.50	T12
3113	T11	\N	40.20	0.00	40.20	1	f	f	\N	2025-09-21 12:00:00	\N	40.20	JUSTINE
3130	\N	\N	-13.83	0.00	-13.83	1	f	t	\N	2025-09-26 12:00:00	\N	0.00	\N
3131	\N	\N	-77.91	0.00	-77.91	1	f	t	\N	2025-09-26 12:00:00	\N	0.00	\N
3190	\N	\N	-27.63	0.00	-27.63	1	f	t	\N	2025-10-23 12:00:00	\N	0.00	\N
3140	\N	\N	-41.02	0.00	-41.02	1	f	t	\N	2025-10-02 12:00:00	\N	0.00	\N
3146	\N	\N	0.00	52.00	52.00	1	t	f	\N	2025-10-03 12:00:00	\N	52.00	Emporté
3152	T12	\N	44.60	0.00	44.60	1	f	f	\N	2025-10-04 12:00:00	\N	44.60	T12
3202	T13	\N	0.00	0.00	0.00	3	f	f	\N	2025-10-24 12:00:00	\N	0.00	DENIS
3205	T5	\N	0.00	71.00	71.00	2	f	f	\N	2025-10-25 12:00:00	\N	0.00	Veronique
3214	T2	\N	6.00	0.00	6.00	1	f	f	\N	2025-10-31 12:00:00	\N	6.00	T2
962	\N	-1769468414	0.00	20.00	20.00	2	t	f	\N	2024-01-20 12:00:00	\N	20.00	Emporté
2953	\N	\N	16.40	0.00	16.40	2	t	f	\N	2025-06-18 12:00:00	\N	16.40	Emporté
2960	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2025-06-20 12:00:00	\N	0.00	\N
1039	T3	-479672637	20.00	0.00	20.00	2	t	f	\N	2024-02-15 12:00:00	\N	20.00	T3
971	T13	-479672637	0.00	33.00	33.00	2	f	f	\N	2024-01-24 12:00:00	\N	33.00	Manu
2966	T13	\N	0.00	22.00	22.00	1	f	f	\N	2025-06-27 12:00:00	\N	0.00	T13
979	T12	363385425	0.00	0.00	0.00	2	f	f	\N	2024-01-25 12:00:00	\N	0.00	Caro
2968	\N	\N	-18.42	0.00	-18.42	1	f	t	\N	2025-06-27 12:00:00	\N	0.00	\N
2969	\N	\N	-31.29	0.00	-31.29	1	f	t	\N	2025-06-27 12:00:00	\N	0.00	\N
991	T3	-1763527961	0.00	57.00	57.00	2	f	f	\N	2024-01-27 12:00:00	\N	57.00	LEBRUN
994	T6	907055032	0.00	77.00	77.00	2	f	f	\N	2024-01-27 12:00:00	\N	0.00	Laurence
1001	T14	-479672637	0.00	11.00	11.00	1	t	f	\N	2024-02-01 12:00:00	\N	0.00	T14
1004	T2	3	0.00	74.00	74.00	2	f	f	\N	2024-02-01 12:00:00	\N	35.00	philou
1012	\N	-479672637	0.00	6.00	6.00	1	t	f	\N	2024-02-02 12:00:00	\N	6.00	Emporté
3204	\N	\N	0.00	23.00	23.00	1	t	f	\N	2025-10-25 12:00:00	\N	0.00	Emporté
2986	T12	\N	0.00	44.00	44.00	1	t	f	\N	2025-07-26 12:00:00	\N	44.00	Dalne
1013	T14	686373030	6.00	0.00	6.00	1	f	f	\N	2024-02-02 12:00:00	\N	6.00	Christophe
3207	T9	\N	72.50	0.00	72.50	2	f	f	\N	2025-10-25 12:00:00	\N	72.50	T9
1016	\N	1936806253	52.00	0.00	52.00	3	t	f	\N	2024-02-07 12:00:00	\N	52.00	Emporté
1027	T9	-2090111404	0.00	117.00	117.00	4	f	f	\N	2024-02-09 12:00:00	\N	52.00	Lo Presti
1028	T14	-1551998939	0.00	60.00	60.00	2	f	f	\N	2024-02-09 12:00:00	\N	35.00	Didier
3001	\N	\N	0.00	-90.00	-90.00	1	f	t	\N	2025-08-22 12:00:00	\N	0.00	\N
751	T2	-1632933197	27.00	0.00	27.00	1	f	f	\N	2023-11-29 12:00:00	\N	27.00	Françoise
3004	T12	\N	85.50	0.00	85.50	2	f	f	\N	2025-08-23 12:00:00	\N	85.50	JEFF
1031	T6	-1769468414	0.00	67.00	67.00	2	f	f	\N	2024-02-10 12:00:00	\N	0.00	Laurent
3216	\N	\N	0.00	10.00	10.00	1	t	f	\N	2025-10-31 12:00:00	\N	0.00	Emporté
3010	\N	\N	-300.00	0.00	-300.00	1	f	t	\N	2025-08-20 12:00:00	\N	0.00	\N
3217	T2	\N	0.00	2.50	2.50	1	f	f	\N	2025-10-31 12:00:00	\N	0.00	T2
760	T14	-1850234108	10.00	0.00	10.00	1	f	f	\N	2023-12-01 12:00:00	\N	10.00	T14
3016	\N	\N	-130.32	0.00	-130.32	1	f	t	\N	2025-08-27 12:00:00	\N	0.00	\N
915	T10	-1551998939	72.00	72.00	144.00	4	f	f	\N	2024-01-06 12:00:00	\N	74.00	Didier
930	T11	-1632933197	0.00	47.00	47.00	1	f	f	\N	2024-01-11 12:00:00	\N	27.00	T11
936	T11	-2027096864	0.00	77.00	77.00	2	f	f	\N	2024-01-12 12:00:00	\N	45.00	Nadine
1048	T6	7614925	103.00	0.00	103.00	2	f	f	\N	2024-02-16 12:00:00	\N	103.00	Destexhe
3031	\N	\N	-25.17	0.00	-25.17	1	f	t	\N	2025-08-30 12:00:00	\N	0.00	\N
954	T14	-1632933197	0.00	85.50	85.50	1	f	f	\N	2024-01-19 12:00:00	\N	60.50	T14
1049	T2	1158611139	76.50	0.00	76.50	2	f	f	\N	2024-02-16 12:00:00	\N	76.50	Istace
963	T9	804734236	0.00	73.00	73.00	2	f	f	\N	2024-01-20 12:00:00	\N	73.00	Flas
1050	T9	-867980635	402.00	0.00	402.00	13	f	f	\N	2024-02-16 12:00:00	\N	402.00	Arnold
2956	T13	-479672637	0.00	6.00	6.00	1	f	f	\N	2025-06-20 12:00:00	\N	0.00	MANU
3235	\N	\N	0.00	12.00	12.00	1	t	f	\N	2025-10-31 12:00:00	\N	0.00	Emporté
3237	\N	\N	21.00	0.00	21.00	1	t	f	\N	2025-10-31 12:00:00	\N	21.00	Emporté
3238	\N	\N	12.00	0.00	12.00	1	t	f	\N	2025-10-31 12:00:00	\N	12.00	Emporté
2954	\N	\N	-34.80	0.00	-34.80	1	f	t	\N	2025-06-20 12:00:00	\N	0.00	\N
3240	\N	\N	23.00	0.00	23.00	1	t	f	\N	2025-10-31 12:00:00	\N	23.00	Emporté
2957	\N	\N	-36.75	0.00	-36.75	1	f	t	\N	2025-06-20 12:00:00	\N	0.00	\N
3243	T7	\N	0.00	22.00	22.00	2	f	f	\N	2025-10-31 12:00:00	\N	0.00	DOCTEUR
3244	T13	\N	0.00	14.40	14.40	4	f	f	\N	2025-11-01 12:00:00	\N	0.00	amis
2962	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2025-06-21 12:00:00	\N	0.00	\N
2972	T13	\N	0.00	17.00	17.00	1	f	f	\N	2025-06-28 12:00:00	\N	0.00	RUDY
2974	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2025-07-25 12:00:00	\N	0.00	\N
3255	T13	\N	0.00	53.20	53.20	2	f	f	\N	2025-11-07 12:00:00	\N	0.00	FRED
3256	T15	\N	24.00	0.00	24.00	1	f	f	\N	2025-11-07 12:00:00	\N	24.00	T15
2984	T9	\N	0.00	42.20	42.20	1	f	f	\N	2025-07-26 12:00:00	\N	42.20	T9
2989	\N	\N	-50.03	0.00	-50.03	1	f	t	\N	2025-08-20 12:00:00	\N	0.00	\N
2992	\N	\N	-300.00	0.00	-300.00	1	f	t	\N	2025-08-13 12:00:00	\N	0.00	\N
3270	\N	\N	9.00	0.00	9.00	1	t	f	\N	2025-11-09 12:00:00	\N	9.00	Emporté
3034	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2025-08-22 12:00:00	\N	0.00	\N
3158	\N	\N	-13.74	0.00	-13.74	1	f	t	\N	2025-10-09 12:00:00	\N	0.00	\N
3159	\N	\N	0.00	6.00	6.00	1	t	f	\N	2025-10-09 12:00:00	\N	0.00	Emporté
3279	T5	\N	0.00	101.80	101.80	1	f	f	\N	2025-11-09 12:00:00	\N	0.00	T5
3161	\N	\N	-93.00	0.00	-93.00	1	f	t	\N	2025-10-10 12:00:00	\N	0.00	\N
3219	\N	\N	7.00	0.00	7.00	1	t	f	\N	2025-10-31 12:00:00	\N	7.00	Emporté
1051	T14	1105205458	84.50	0.00	84.50	2	f	f	\N	2024-02-16 12:00:00	\N	84.50	stephane
3165	\N	\N	0.00	10.00	10.00	1	t	f	\N	2025-10-10 12:00:00	\N	10.00	Emporté
2996	T7	\N	0.00	24.00	24.00	1	t	f	\N	2025-08-22 12:00:00	\N	24.00	T7
972	T6	-479672637	0.00	38.50	38.50	1	f	f	\N	2024-01-24 12:00:00	\N	38.50	Marie
2999	T9	\N	202.30	0.00	202.30	4	f	f	\N	2025-08-22 12:00:00	\N	202.30	T9
3002	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2025-08-22 12:00:00	\N	0.00	\N
3005	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2025-08-23 12:00:00	\N	0.00	\N
978	T8	-1418201111	0.00	65.50	65.50	2	f	f	\N	2024-01-25 12:00:00	\N	65.50	Amie Laurent
987	T13	-1769468414	0.00	17.00	17.00	1	t	f	\N	2024-01-26 12:00:00	\N	17.00	T13
3011	\N	\N	-103.20	0.00	-103.20	1	f	t	\N	2025-08-27 12:00:00	\N	0.00	\N
3171	\N	\N	-134.67	0.00	-134.67	1	f	t	\N	2025-09-15 12:00:00	\N	0.00	\N
3014	T8	\N	0.00	81.00	81.00	3	f	f	\N	2025-08-27 12:00:00	\N	81.00	3 freres
990	T11	-1632933197	0.00	30.00	30.00	1	f	f	\N	2024-01-27 12:00:00	\N	30.00	Sabine
3173	\N	\N	-118.58	0.00	-118.58	1	f	t	\N	2025-10-10 12:00:00	\N	0.00	\N
3020	\N	\N	34.00	0.00	34.00	2	t	f	\N	2025-08-29 12:00:00	\N	34.00	Emporté
3023	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2025-08-29 12:00:00	\N	0.00	\N
996	T8	3	0.00	411.00	411.00	10	f	f	\N	2024-01-31 12:00:00	\N	0.00	philou
3029	\N	\N	-45.00	0.00	-45.00	1	f	t	\N	2025-08-29 12:00:00	\N	0.00	\N
3032	\N	\N	-39.17	0.00	-39.17	1	f	t	\N	2025-08-29 12:00:00	\N	0.00	\N
999	T8	3	0.00	60.00	60.00	1	f	f	\N	2024-01-31 12:00:00	\N	0.00	philou
1060	T14	232453727	0.00	0.00	0.00	2	f	f	\N	2024-02-21 12:00:00	\N	0.00	Sarah
1017	T12	-1632933197	0.00	35.00	35.00	1	f	f	\N	2024-02-07 12:00:00	\N	15.00	Sabine
3186	T12	\N	319.50	0.00	319.50	8	f	f	\N	2025-10-18 12:00:00	\N	319.50	Occupé
1026	T13	-1163187653	0.00	50.00	50.00	2	f	f	\N	2024-02-09 12:00:00	\N	21.00	Pierre
1065	T9	-1769468414	0.00	109.50	109.50	3	f	f	\N	2024-02-23 12:00:00	\N	43.50	Laurent
3191	T5	\N	142.20	0.00	142.20	4	f	f	\N	2025-10-23 12:00:00	\N	142.20	T5
3192	T12	\N	62.00	0.00	62.00	2	f	f	\N	2025-10-23 12:00:00	\N	62.00	T12
1066	\N	907055032	0.00	15.00	15.00	1	t	f	\N	2024-02-23 12:00:00	\N	15.00	Emporté
1067	T7	3	0.00	233.00	233.00	6	f	f	\N	2024-02-23 12:00:00	\N	0.00	Filou
1069	T2	35667300	0.00	151.00	151.00	4	f	f	\N	2024-02-23 12:00:00	\N	0.00	T2
1073	T11	1936806253	200.00	52.00	252.00	8	f	f	\N	2024-02-23 12:00:00	\N	252.00	Célia
1075	T11	-1632933197	0.00	39.00	39.00	1	f	f	\N	2024-02-24 12:00:00	\N	0.00	Sabine
3203	\N	\N	0.00	6.00	6.00	1	t	f	\N	2025-10-25 12:00:00	\N	0.00	Emporté
3209	T14	\N	119.90	0.00	119.90	4	f	f	\N	2025-10-30 12:00:00	\N	119.90	MANU
3215	T2	\N	0.00	4.00	4.00	1	f	f	\N	2025-10-31 12:00:00	\N	0.00	T2
3218	\N	\N	-60.15	0.00	-60.15	1	f	t	\N	2025-10-31 12:00:00	\N	0.00	\N
3168	T8	\N	0.00	64.00	64.00	1	f	f	\N	2025-10-10 12:00:00	\N	0.00	DOCTEUR
2993	T13	\N	0.00	3.50	3.50	1	f	f	\N	2025-08-22 12:00:00	\N	3.50	T13
3179	\N	\N	-22.95	0.00	-22.95	1	f	t	\N	2025-10-17 12:00:00	\N	0.00	\N
3188	\N	\N	-75.00	0.00	-75.00	1	f	t	\N	2025-10-18 12:00:00	\N	0.00	\N
3189	\N	\N	-109.00	0.00	-109.00	1	f	t	\N	2025-10-18 12:00:00	\N	0.00	\N
3212	\N	\N	-81.63	0.00	-81.63	1	f	t	\N	2025-10-31 12:00:00	\N	0.00	\N
3236	\N	\N	26.50	0.00	26.50	1	t	f	\N	2025-10-31 12:00:00	\N	26.50	Emporté
3221	\N	\N	10.00	0.00	10.00	1	t	f	\N	2025-10-31 12:00:00	\N	10.00	Emporté
3239	\N	\N	-135.00	0.00	-135.00	1	f	t	\N	2025-10-31 12:00:00	\N	0.00	\N
3224	\N	\N	0.00	19.00	19.00	1	t	f	\N	2025-10-31 12:00:00	\N	0.00	Emporté
3227	\N	\N	15.00	0.00	15.00	1	t	f	\N	2025-10-31 12:00:00	\N	15.00	Emporté
3233	\N	\N	0.00	4.00	4.00	1	t	f	\N	2025-10-31 12:00:00	\N	0.00	Emporté
3245	\N	\N	0.00	8.20	8.20	1	t	f	\N	2025-11-01 12:00:00	\N	0.00	Emporté
3266	T15	\N	0.00	30.00	30.00	1	f	f	\N	2025-11-08 12:00:00	\N	0.00	ERIC
3257	T7	\N	0.00	104.00	104.00	2	f	f	\N	2025-11-07 12:00:00	\N	0.00	ALEX
3274	T5	\N	0.00	34.10	34.10	1	f	f	\N	2025-11-09 12:00:00	\N	0.00	T5
3291	\N	\N	6.00	0.00	6.00	1	t	f	\N	2025-11-14 12:00:00	\N	6.00	Emporté
3263	T7	\N	0.00	69.50	69.50	2	f	f	\N	2025-11-07 12:00:00	\N	0.00	T7
3268	T9	\N	56.00	0.00	56.00	2	f	f	\N	2025-11-08 12:00:00	\N	56.00	VEFFERT
3271	\N	\N	0.00	5.00	5.00	1	t	f	\N	2025-11-09 12:00:00	\N	5.00	Emporté
3275	\N	\N	0.00	20.00	20.00	1	t	f	\N	2025-11-09 12:00:00	\N	0.00	Emporté
3277	T5	\N	0.00	13.00	13.00	1	t	f	\N	2025-11-09 12:00:00	\N	0.00	T5
3278	T5	\N	0.00	53.10	53.10	1	f	f	\N	2025-11-09 12:00:00	\N	0.00	T5
3281	T6	\N	0.00	53.00	53.00	1	f	f	\N	2025-11-09 12:00:00	\N	0.00	Babette
3282	T9	\N	0.00	122.40	122.40	1	f	f	\N	2025-11-09 12:00:00	\N	0.00	Manu et pablo
3283	\N	\N	-100.00	0.00	-100.00	1	f	t	\N	2025-11-09 12:00:00	\N	0.00	\N
3288	T11	\N	68.00	0.00	68.00	2	f	f	\N	2025-11-13 12:00:00	\N	68.00	NANAS
3289	\N	\N	-8.00	0.00	-8.00	1	f	t	\N	2025-11-14 12:00:00	\N	0.00	\N
3294	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2025-11-11 12:00:00	\N	0.00	\N
1429	T7	-2101073188	78.50	0.00	78.50	1	f	f	\N	2024-05-10 12:00:00	\N	78.50	DANIEL
1094	T7	-2018722768	0.00	79.00	79.00	2	f	f	\N	2024-03-01 12:00:00	\N	0.00	CHEVOLET
1432	T15	-479672637	32.00	0.00	32.00	2	f	f	\N	2024-05-10 12:00:00	\N	32.00	T15
3303	\N	\N	-16.69	0.00	-16.69	1	f	t	\N	2025-11-11 12:00:00	\N	0.00	\N
2524	T2	\N	0.00	5.00	5.00	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
3300	\N	\N	-11.34	0.00	-11.34	1	f	t	\N	2025-11-06 12:00:00	\N	0.00	\N
2530	T2	\N	0.00	16.00	16.00	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
3312	T12	\N	0.00	80.00	80.00	2	f	f	\N	2025-11-21 12:00:00	\N	0.00	T12
3315	\N	\N	-48.03	0.00	-48.03	1	f	t	\N	2025-11-22 12:00:00	\N	0.00	\N
3898	DÉPENSES	\N	-50.24	0.00	-50.24	1	f	t	\N	2026-06-16 15:51:00	\N	0.00	\N
1435	T9	-708274188	0.00	155.50	155.50	4	f	f	\N	2024-05-10 12:00:00	\N	0.00	DEFAWEUX
3309	\N	\N	-38.45	0.00	-38.45	1	f	t	\N	2025-11-21 12:00:00	\N	0.00	\N
3916	T8	\N	55.40	0.00	55.40	1	f	f	\N	2026-06-26 12:00:00	\N	0.00	Jean-christophe
1106	T4	686373030	0.00	66.00	66.00	3	f	f	\N	2024-03-07 12:00:00	\N	0.00	Annick
3324	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2025-11-22 12:00:00	\N	0.00	\N
3920	DÉPENSES	\N	-100.07	0.00	-100.07	1	f	f	\N	2026-05-26 12:00:00	\N	0.00	\N
3342	\N	\N	-49.50	0.00	-49.50	1	f	t	\N	2025-11-12 12:00:00	\N	0.00	\N
1115	T2	-1632933197	0.00	25.00	25.00	1	f	f	\N	2024-03-08 12:00:00	\N	0.00	Sabine
3345	\N	\N	-296.28	0.00	-296.28	1	f	t	\N	2025-11-04 12:00:00	\N	0.00	\N
3363	T9	\N	104.50	0.00	104.50	2	f	f	\N	2025-12-05 12:00:00	\N	104.50	CHIEN
3348	\N	\N	-576.50	0.00	-576.50	1	f	t	\N	2025-10-29 12:00:00	\N	0.00	\N
1121	T15	686373030	0.00	16.00	16.00	2	f	f	\N	2024-03-08 12:00:00	\N	0.00	Christophe
3327	\N	\N	-23.13	0.00	-23.13	1	f	t	\N	2025-11-27 12:00:00	\N	0.00	\N
3354	\N	\N	-768.35	0.00	-768.35	1	f	t	\N	2025-12-02 12:00:00	\N	0.00	\N
1447	T8	-2101073188	172.00	0.00	172.00	4	f	f	\N	2024-05-11 12:00:00	\N	172.00	Daniel
3378	\N	\N	-99.37	0.00	-99.37	1	f	t	\N	2025-12-12 12:00:00	\N	0.00	\N
3360	T14	\N	0.00	12.00	12.00	1	t	f	\N	2025-12-05 12:00:00	\N	12.00	T14
3336	\N	\N	-112.72	0.00	-112.72	1	f	t	\N	2025-11-24 12:00:00	\N	0.00	\N
1471	T7	-2101073188	0.00	210.00	210.00	7	f	f	\N	2024-05-15 12:00:00	\N	0.00	T7
1504	T8	-1769468414	0.00	74.00	74.00	3	f	f	\N	2024-05-18 12:00:00	\N	0.00	LAURENT
3369	T9	\N	204.00	0.00	204.00	7	f	f	\N	2025-12-12 12:00:00	\N	204.00	ALEX
3934	T12	\N	69.00	0.00	69.00	1	f	f	\N	2026-07-03 12:00:00	\N	0.00	Cheveux
1507	T15	686373030	0.00	30.00	30.00	1	f	f	\N	2024-05-18 12:00:00	\N	0.00	Christophe
3929	DÉPENSES	\N	-198.18	0.00	-198.18	1	f	t	\N	2026-06-25 12:00:00	\N	0.00	\N
3375	\N	\N	51.00	0.00	51.00	3	t	f	\N	2025-12-12 12:00:00	\N	51.00	Emporté
1510	T14	-479672637	20.00	0.00	20.00	1	f	f	\N	2024-05-18 12:00:00	\N	20.00	Manu
3339	\N	\N	-388.66	0.00	-388.66	1	f	t	\N	2025-11-18 12:00:00	\N	0.00	\N
3399	T7	\N	0.00	67.40	67.40	2	f	f	\N	2025-12-14 12:00:00	\N	67.40	DOMI
3918	T11	1404998520	57.40	0.00	57.40	1	f	f	\N	2026-06-26 12:00:00	\N	0.00	Bidaine
3387	\N	\N	-105.62	0.00	-105.62	1	f	t	\N	2025-12-03 12:00:00	\N	0.00	\N
3390	T2	\N	0.00	4.50	4.50	1	f	f	\N	2025-12-14 12:00:00	\N	0.00	T2
1519	T11	-1801614408	0.00	0.00	0.00	1	f	f	\N	2024-05-22 12:00:00	\N	0.00	J-M
3396	T11	\N	0.00	59.00	59.00	2	f	f	\N	2025-12-14 12:00:00	\N	0.00	RENAUD
3402	T10	\N	0.00	80.70	80.70	2	f	f	\N	2025-12-14 12:00:00	\N	0.00	PABLO
3411	T7	\N	0.00	42.00	42.00	1	f	f	\N	2025-12-19 12:00:00	\N	0.00	T7
3414	T13	\N	0.00	25.00	25.00	1	f	f	\N	2025-12-19 12:00:00	\N	0.00	T13
3417	T2	\N	0.00	5.00	5.00	1	f	f	\N	2025-12-19 12:00:00	\N	0.00	T2
1549	T9	1170351074	0.00	59.00	59.00	2	f	f	\N	2024-05-30 12:00:00	\N	0.00	MANCINI
3351	\N	\N	-100.00	0.00	-100.00	1	f	t	\N	2025-10-20 12:00:00	\N	0.00	\N
3381	\N	\N	-25.00	0.00	-25.00	1	f	t	\N	2025-12-04 12:00:00	\N	0.00	\N
3384	\N	\N	-100.00	0.00	-100.00	1	f	t	\N	2025-11-12 12:00:00	\N	0.00	\N
3408	T2	\N	0.00	50.20	50.20	1	f	f	\N	2025-12-19 12:00:00	\N	0.00	T2
1077	T2	-1931747542	0.00	135.00	135.00	3	f	f	\N	2024-02-24 12:00:00	\N	0.00	Guillaume
3420	T6	\N	0.00	25.00	25.00	1	f	f	\N	2025-12-19 12:00:00	\N	0.00	T6
1078	T12	-1551998939	42.00	0.00	42.00	2	f	f	\N	2024-02-24 12:00:00	\N	42.00	Didier
1080	T7	-2018722768	0.00	96.50	96.50	2	f	f	\N	2024-02-24 12:00:00	\N	0.00	Chevolet
1104	T13	686373030	29.00	0.00	29.00	1	f	f	\N	2024-03-07 12:00:00	\N	29.00	T13
1107	T14	6908928	66.00	0.00	66.00	2	f	f	\N	2024-03-08 12:00:00	\N	66.00	Luc
1110	T14	6908928	39.00	0.00	39.00	1	f	f	\N	2024-03-08 12:00:00	\N	39.00	Luc
1114	\N	-960371656	36.00	0.00	36.00	3	t	f	\N	2024-03-08 12:00:00	\N	36.00	Emporté
2542	T2	\N	0.00	7.00	7.00	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
1120	T10	1936806253	221.00	0.00	221.00	6	f	f	\N	2024-03-08 12:00:00	\N	221.00	Eve
1122	T10	1936806253	0.00	11.00	11.00	1	f	f	\N	2024-03-08 12:00:00	\N	11.00	Eve
2590	\N	\N	0.00	23.60	23.60	1	t	f	\N	2025-02-21 12:00:00	\N	23.60	Emporté
1123	T7	-1931747542	120.00	0.00	120.00	4	f	f	\N	2024-03-08 12:00:00	\N	120.00	Guillaume
1138	T4	-1769468414	0.00	89.00	89.00	2	f	f	\N	2024-03-09 12:00:00	\N	0.00	Laurent
2560	\N	\N	-171.00	0.00	-171.00	1	f	t	\N	2025-02-14 12:00:00	\N	0.00	\N
2563	\N	\N	6.00	0.00	6.00	1	t	f	\N	2025-02-14 12:00:00	\N	6.00	Emporté
2572	T2	\N	0.00	40.00	40.00	1	f	f	\N	2025-02-15 12:00:00	\N	0.00	T2
2593	\N	\N	0.00	20.00	20.00	1	t	f	\N	2025-02-21 12:00:00	\N	20.00	Emporté
2608	\N	\N	0.00	8.50	8.50	1	t	f	\N	2025-02-26 12:00:00	\N	8.50	Emporté
2611	\N	\N	-83.13	0.00	-83.13	1	f	t	\N	2025-02-26 12:00:00	\N	0.00	\N
2614	\N	\N	-46.08	0.00	-46.08	1	f	t	\N	2025-02-27 12:00:00	\N	0.00	\N
1170	\N	-479672637	64.00	0.00	64.00	4	t	f	\N	2024-03-16 12:00:00	\N	64.00	Emporté
1172	T3	-867980635	0.00	119.50	119.50	4	f	f	\N	2024-03-16 12:00:00	\N	0.00	Arnold
1173	T7	-1769468414	0.00	52.50	52.50	2	f	f	\N	2024-03-16 12:00:00	\N	0.00	Laurent
1174	T10	3	0.00	222.00	222.00	8	f	f	\N	2024-03-16 12:00:00	\N	0.00	Filou
1178	T14	1105205458	0.00	142.30	142.30	4	f	f	\N	2024-03-16 12:00:00	\N	0.00	Stephane
3301	\N	\N	-47.22	0.00	-47.22	1	f	t	\N	2025-11-06 12:00:00	\N	0.00	\N
3302	\N	\N	-21.77	0.00	-21.77	1	f	t	\N	2025-11-08 12:00:00	\N	0.00	\N
3304	\N	\N	-28.85	0.00	-28.85	1	f	t	\N	2025-11-11 12:00:00	\N	0.00	\N
3305	\N	\N	-87.50	0.00	-87.50	1	f	t	\N	2025-11-20 12:00:00	\N	0.00	\N
1183	\N	-1959562082	0.00	30.00	30.00	2	t	f	\N	2024-03-20 12:00:00	\N	0.00	Emporté
1198	\N	-1409108099	-35.94	0.00	-35.94	1	f	t	\N	2024-03-21 12:00:00	\N	0.00	\N
1430	T14	-1801614408	0.00	63.00	63.00	2	f	f	\N	2024-05-10 12:00:00	\N	0.00	J-M
1228	\N	-1769468414	0.00	135.00	135.00	9	t	f	\N	2024-03-23 12:00:00	\N	0.00	Emporté
3919	DÉPENSES	\N	137.94	0.00	137.94	1	f	f	\N	2026-05-22 12:00:00	\N	0.00	\N
3314	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2025-11-21 12:00:00	\N	0.00	\N
1437	T9	-708274188	0.00	29.00	29.00	4	f	f	\N	2024-05-10 12:00:00	\N	0.00	DEFAWEUX
3316	\N	\N	-31.92	0.00	-31.92	1	f	t	\N	2025-11-22 12:00:00	\N	0.00	\N
3048	\N	\N	0.00	6.00	6.00	1	t	f	\N	2025-09-05 12:00:00	\N	6.00	Emporté
1443	T14	6908928	55.00	0.00	55.00	3	f	f	\N	2024-05-11 12:00:00	\N	55.00	Luc
1446	T2	-867980635	116.00	0.00	116.00	4	f	f	\N	2024-05-11 12:00:00	\N	116.00	Arnold
3326	T5	\N	0.00	122.20	122.20	3	f	f	\N	2025-11-27 12:00:00	\N	122.20	SAM
1464	T13	3	0.00	170.00	170.00	1	f	f	\N	2024-05-14 12:00:00	\N	0.00	Filou2
1475	T13	232453727	36.50	0.00	36.50	2	f	f	\N	2024-05-16 12:00:00	\N	36.50	SARAH
1509	T5	7614925	139.00	0.00	139.00	4	f	f	\N	2024-05-18 12:00:00	\N	139.00	Béa DESTEXHE
1197	\N	-1409108099	-89.10	-89.10	-89.10	1	f	t	\N	2024-03-21 12:00:00	\N	0.00	\N
1208	\N	-1639649453	0.00	40.00	40.00	3	t	f	\N	2024-03-21 12:00:00	\N	0.00	Emporté
1521	\N	-479672637	0.00	11.00	11.00	1	t	f	\N	2024-05-23 12:00:00	\N	0.00	Emporté
3343	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2025-11-10 12:00:00	\N	0.00	\N
1524	T13	686373030	0.00	16.00	16.00	1	f	f	\N	2024-05-23 12:00:00	\N	0.00	CHRISTOPHE
3346	\N	\N	-296.45	0.00	-296.45	1	f	t	\N	2025-11-03 12:00:00	\N	0.00	\N
1529	T15	-2101073188	0.00	17.50	17.50	1	f	f	\N	2024-05-24 12:00:00	\N	0.00	T15
3349	\N	\N	-101.49	0.00	-101.49	1	f	t	\N	2025-10-27 12:00:00	\N	0.00	\N
1535	T2	-479672637	0.00	4.00	4.00	1	f	f	\N	2024-05-24 12:00:00	\N	0.00	T2
1538	T5	-708274188	0.00	181.00	181.00	4	f	f	\N	2024-05-24 12:00:00	\N	0.00	Defaweux
1708	T2	-1632933197	64.00	0.00	64.00	2	f	f	\N	2024-06-28 12:00:00	\N	64.00	SABINE
3358	T11	\N	0.00	64.00	64.00	2	f	f	\N	2025-12-04 12:00:00	\N	0.00	JEUNES
1710	T13	-479672637	12.00	0.00	12.00	1	f	f	\N	2024-06-28 12:00:00	\N	12.00	MANU
1749	T2	-1632933197	0.00	34.00	34.00	1	f	f	\N	2024-07-24 12:00:00	\N	34.00	SABINE
1287	T8	-2101073188	111.80	0.00	111.80	3	f	f	\N	2024-04-05 12:00:00	\N	111.80	BLUM
1291	\N	647511427	47.00	0.00	47.00	3	t	f	\N	2024-04-05 12:00:00	\N	47.00	Emporté
3367	T9	\N	108.00	0.00	108.00	2	f	f	\N	2025-12-06 12:00:00	\N	108.00	T9
3370	T12	\N	15.00	0.00	15.00	1	f	f	\N	2025-12-12 12:00:00	\N	15.00	T12
1293	T7	-2101073188	52.50	0.00	52.50	2	f	f	\N	2024-04-05 12:00:00	\N	52.50	Magistrat
3373	T13	\N	0.00	5.00	5.00	1	f	f	\N	2025-12-12 12:00:00	\N	5.00	T13
3379	\N	\N	-25.00	0.00	-25.00	1	f	t	\N	2025-12-12 12:00:00	\N	0.00	\N
1297	T2	-1198282750	112.50	0.00	112.50	3	f	f	\N	2024-04-06 12:00:00	\N	112.50	Lion
1310	T2	35667300	0.00	88.50	88.50	4	f	f	\N	2024-04-12 12:00:00	\N	88.50	dewindt
3385	\N	\N	-376.50	0.00	-376.50	1	f	t	\N	2025-12-12 12:00:00	\N	0.00	\N
1312	T15	-479672637	18.50	0.00	18.50	1	f	f	\N	2024-04-12 12:00:00	\N	18.50	Manu
1313	T8	-2018722768	0.00	66.50	66.50	2	f	f	\N	2024-04-12 12:00:00	\N	66.50	Chevolet
1314	T4	1139066072	0.00	110.00	110.00	2	f	f	\N	2024-04-12 12:00:00	\N	0.00	David
1317	T10	-1931747542	0.00	201.50	201.50	4	f	f	\N	2024-04-12 12:00:00	\N	0.00	Guillaume
3397	T13	\N	0.00	43.50	43.50	2	f	f	\N	2025-12-14 12:00:00	\N	0.00	Loic et fred/2
1318	T15	-479672637	35.00	0.00	35.00	4	f	f	\N	2024-04-12 12:00:00	\N	35.00	Manu
1340	T8	-2101073188	0.00	85.50	85.50	3	f	f	\N	2024-04-17 12:00:00	\N	0.00	T8
2827	T5	\N	0.00	71.50	71.50	3	f	f	\N	2025-05-02 12:00:00	\N	71.50	AMIS IRENE
2866	\N	\N	0.00	911.00	911.00	109	t	f	\N	2025-05-17 12:00:00	\N	0.00	Emporté
3415	T6	\N	0.00	16.00	16.00	1	f	f	\N	2025-12-19 12:00:00	\N	0.00	T6
2807	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2025-04-25 12:00:00	\N	0.00	\N
3325	T12	\N	51.00	0.00	51.00	1	t	f	\N	2025-11-27 12:00:00	\N	51.00	TURCS
3406	T9	\N	0.00	154.50	154.50	1	f	f	\N	2025-12-18 12:00:00	\N	0.00	Table 6 pers
2853	T9	\N	0.00	74.50	74.50	1	f	f	\N	2025-05-09 12:00:00	\N	74.50	T9
2822	\N	\N	-14.32	0.00	-14.32	1	f	t	\N	2025-05-02 12:00:00	\N	0.00	\N
2833	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2025-05-03 12:00:00	\N	0.00	\N
2843	\N	\N	-38.99	0.00	-38.99	1	f	t	\N	2025-05-09 12:00:00	\N	0.00	\N
2856	T13	\N	0.00	49.00	49.00	1	f	f	\N	2025-05-09 12:00:00	\N	0.00	T13
3900	T1	\N	-75.00	0.00	-75.00	1	f	t	\N	2026-06-24 20:49:08.766663	\N	0.00	\N
1342	T9	1190480647	0.00	74.00	74.00	3	f	f	\N	2024-04-19 12:00:00	\N	74.00	T9
1348	\N	-1602796250	0.00	6.00	6.00	1	t	f	\N	2024-04-19 12:00:00	\N	6.00	Emporté
1349	T8	-2101073188	54.00	108.50	162.50	3	f	f	\N	2024-04-24 12:00:00	\N	78.00	Daniel
1562	T3	-2091564144	0.00	49.00	49.00	2	f	f	\N	2024-05-30 12:00:00	\N	0.00	CARWASH
1563	T12	1507213074	44.00	0.00	44.00	2	f	f	\N	2024-05-30 12:00:00	\N	44.00	Mercyni
3344	\N	\N	-208.63	0.00	-208.63	1	f	t	\N	2025-11-07 12:00:00	\N	0.00	\N
1566	T13	1139066072	133.00	0.00	133.00	3	f	f	\N	2024-05-31 12:00:00	\N	133.00	T13
1400	T2	1936806253	67.50	0.00	67.50	2	f	f	\N	2024-05-03 12:00:00	\N	67.50	Eve
3350	\N	\N	-98.49	0.00	-98.49	1	f	t	\N	2025-10-24 12:00:00	\N	0.00	\N
1571	T6	738464830	92.00	0.00	92.00	3	f	f	\N	2024-05-31 12:00:00	\N	92.00	HANSEZ
1412	T4	-1769468414	0.00	54.00	54.00	2	f	f	\N	2024-05-04 12:00:00	\N	0.00	Laurent
1592	T13	627317039	0.00	10.00	10.00	1	f	f	\N	2024-06-07 12:00:00	\N	0.00	T13
3359	\N	\N	0.00	53.00	53.00	3	t	f	\N	2025-12-05 12:00:00	\N	0.00	Emporté
1595	T15	-479672637	0.00	6.00	6.00	1	f	f	\N	2024-06-07 12:00:00	\N	0.00	Manu
3362	T13	\N	0.00	14.50	14.50	1	f	f	\N	2025-12-05 12:00:00	\N	14.50	T13
1596	T10	3	0.00	198.00	198.00	4	f	f	\N	2024-06-07 12:00:00	\N	0.00	FILOU
1628	T14	6908928	40.00	0.00	40.00	2	f	f	\N	2024-06-13 12:00:00	\N	40.00	Luc
1629	T3	686373030	0.00	71.00	71.00	2	f	f	\N	2024-06-13 12:00:00	\N	0.00	Christophe
3368	\N	\N	0.00	26.00	26.00	1	t	f	\N	2025-12-11 12:00:00	\N	0.00	Emporté
1631	T13	-479672637	0.00	4.00	4.00	1	f	f	\N	2024-06-13 12:00:00	\N	0.00	Manu
3371	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2025-12-12 12:00:00	\N	0.00	\N
1638	T8	-2101073188	91.00	0.00	91.00	3	f	f	\N	2024-06-14 12:00:00	\N	91.00	T8
1641	T4	-1769468414	70.50	0.00	70.50	3	f	f	\N	2024-06-14 12:00:00	\N	70.50	LAURENT
1644	T9	-1850234108	0.00	63.00	63.00	2	f	f	\N	2024-06-14 12:00:00	\N	0.00	JCC
1362	T6	-1769468414	0.00	44.00	44.00	2	f	f	\N	2024-04-26 12:00:00	\N	0.00	Laurent
3380	\N	\N	-79.08	0.00	-79.08	1	f	t	\N	2025-12-09 12:00:00	\N	0.00	\N
1392	T8	-2101073188	99.00	0.00	99.00	2	f	f	\N	2024-05-03 12:00:00	\N	99.00	Daniel
1404	T14	1139066072	69.50	0.00	69.50	2	f	f	\N	2024-05-03 12:00:00	\N	69.50	David
1579	T14	-1801614408	0.00	40.50	40.50	2	f	f	\N	2024-06-05 12:00:00	\N	0.00	JM
3386	\N	\N	-325.95	0.00	-325.95	1	f	t	\N	2025-12-04 12:00:00	\N	0.00	\N
1410	\N	351063202	0.00	40.00	40.00	1	t	f	\N	2024-05-04 12:00:00	\N	0.00	Emporté
1606	\N	686373030	0.00	30.00	30.00	2	t	f	\N	2024-06-08 12:00:00	\N	30.00	Emporté
1636	T13	232453727	0.00	28.00	28.00	2	f	f	\N	2024-06-14 12:00:00	\N	0.00	SARAH
3395	T5	\N	0.00	95.50	95.50	2	f	f	\N	2025-12-14 12:00:00	\N	95.50	YVES
3347	\N	\N	-183.00	0.00	-183.00	1	f	t	\N	2025-10-30 12:00:00	\N	0.00	\N
3398	T5	\N	0.00	8.00	8.00	2	f	f	\N	2025-12-14 12:00:00	\N	0.00	YVES
1645	T10	-1850234108	0.00	46.00	46.00	2	f	f	\N	2024-06-14 12:00:00	\N	0.00	T10
3335	\N	\N	-63.42	0.00	-63.42	1	f	t	\N	2025-11-27 12:00:00	\N	0.00	\N
3338	\N	\N	-104.05	0.00	-104.05	1	f	t	\N	2025-11-24 12:00:00	\N	0.00	\N
3341	\N	\N	-376.50	0.00	-376.50	1	f	t	\N	2025-11-14 12:00:00	\N	0.00	\N
3353	\N	\N	-272.25	0.00	-272.25	1	f	t	\N	2025-10-07 12:00:00	\N	0.00	\N
3413	T7	\N	0.00	18.50	18.50	1	f	f	\N	2025-12-19 12:00:00	\N	0.00	T7
3374	\N	\N	-63.69	0.00	-63.69	1	f	t	\N	2025-12-12 12:00:00	\N	0.00	\N
3426	T15	\N	0.00	5.00	5.00	1	f	f	\N	2025-12-19 12:00:00	\N	0.00	T15
3442	\N	\N	-303.21	0.00	-303.21	1	f	t	\N	2026-01-05 12:00:00	\N	0.00	\N
3443	\N	\N	-87.50	0.00	-87.50	1	f	t	\N	2026-01-09 12:00:00	\N	0.00	\N
3455	T2	\N	0.00	4.00	4.00	1	f	f	\N	2026-01-17 12:00:00	\N	4.00	T2
3466	\N	\N	-70.00	0.00	-70.00	1	f	t	\N	2026-01-16 12:00:00	\N	0.00	\N
3428	\N	\N	0.00	34.00	34.00	1	t	f	\N	2025-12-19 12:00:00	\N	34.00	Emporté
3468	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2026-01-17 12:00:00	\N	0.00	\N
3429	T15	\N	0.00	18.20	18.20	1	f	f	\N	2025-12-19 12:00:00	\N	0.00	T15
3469	\N	\N	-20.00	0.00	-20.00	1	f	t	\N	2026-01-18 12:00:00	\N	0.00	\N
3471	\N	\N	-75.00	0.00	-75.00	1	f	t	\N	2026-01-18 12:00:00	\N	0.00	\N
3473	\N	\N	-14.98	0.00	-14.98	1	f	t	\N	2026-01-19 12:00:00	\N	0.00	\N
3474	\N	\N	-30.68	0.00	-30.68	1	f	t	\N	2026-01-22 12:00:00	\N	0.00	\N
3433	T12	\N	0.00	260.00	260.00	1	t	f	\N	2025-12-19 12:00:00	\N	260.00	T12
3434	\N	\N	-145.63	0.00	-145.63	1	f	t	\N	2025-12-19 12:00:00	\N	0.00	\N
3435	\N	\N	-160.00	0.00	-160.00	1	f	t	\N	2025-12-19 12:00:00	\N	0.00	\N
3436	\N	\N	-150.00	0.00	-150.00	1	f	t	\N	2025-12-19 12:00:00	\N	0.00	\N
3437	\N	\N	-150.00	0.00	-150.00	1	f	t	\N	2025-12-19 12:00:00	\N	0.00	\N
3438	\N	\N	-20.00	0.00	-20.00	1	f	t	\N	2025-12-19 12:00:00	\N	0.00	\N
3439	\N	\N	-97.16	0.00	-97.16	1	f	t	\N	2025-12-30 12:00:00	\N	0.00	\N
3446	T5	\N	0.00	61.00	61.00	3	f	f	\N	2026-01-09 12:00:00	\N	61.00	T5
3449	\N	\N	-17.67	0.00	-17.67	1	f	t	\N	2026-01-16 12:00:00	\N	0.00	\N
3450	\N	\N	-38.89	0.00	-38.89	1	f	t	\N	2026-01-16 12:00:00	\N	0.00	\N
3451	\N	\N	-116.01	0.00	-116.01	1	f	t	\N	2026-01-16 12:00:00	\N	0.00	\N
3463	T13	\N	0.00	129.00	129.00	4	f	f	\N	2026-01-17 12:00:00	\N	129.00	Occupé
3477	T12	\N	0.00	61.00	61.00	2	f	f	\N	2026-01-22 12:00:00	\N	61.00	0492671579
3626	T6	\N	75.40	0.00	75.40	2	f	f	\N	2026-03-07 12:00:00	\N	0.00	Occupé
3479	\N	\N	-9.60	0.00	-9.60	1	f	t	\N	2026-01-23 12:00:00	\N	0.00	\N
3485	\N	\N	-21.25	0.00	-21.25	1	f	t	\N	2026-01-23 12:00:00	\N	0.00	\N
1657	T14	-1459600805	0.00	48.00	48.00	2	f	f	\N	2024-06-15 12:00:00	\N	48.00	DIDIER
1678	T3	686373030	0.00	53.50	53.50	2	f	f	\N	2024-06-21 12:00:00	\N	0.00	Christophe
3491	\N	\N	-102.16	0.00	-102.16	1	f	t	\N	2026-01-14 12:00:00	\N	0.00	\N
1717	T13	-479672637	16.00	0.00	16.00	1	f	f	\N	2024-06-28 12:00:00	\N	16.00	Manu
3494	T13	\N	0.00	35.50	35.50	1	f	f	\N	2026-01-24 12:00:00	\N	0.00	Occupé
1720	T7	-1931747542	0.00	79.00	79.00	3	f	f	\N	2024-06-29 12:00:00	\N	79.00	T7
3497	T12	\N	133.30	0.00	133.30	4	f	f	\N	2026-01-24 12:00:00	\N	133.30	ARNOLD
1411	T13	-479672637	53.50	0.00	53.50	1	f	f	\N	2024-05-04 12:00:00	\N	53.50	Manu
3500	\N	\N	-73.31	0.00	-73.31	1	f	t	\N	2026-01-31 12:00:00	\N	0.00	\N
1417	T9	-708274188	65.50	0.00	65.50	2	f	f	\N	2024-05-08 12:00:00	\N	65.50	Eric
3901	T8	\N	0.00	57.80	57.80	1	f	f	\N	2026-06-20 09:36:00	\N	57.80	Gordatti
1760	T11	-1769468414	0.00	31.50	31.50	2	f	f	\N	2024-07-26 12:00:00	\N	31.50	LAURENT
1761	T2	-1319489455	0.00	79.00	79.00	2	f	f	\N	2024-07-26 12:00:00	\N	79.00	THIERRY
1772	\N	686373030	0.00	12.00	12.00	2	t	f	\N	2024-08-01 12:00:00	\N	0.00	Emporté
3515	T5	\N	0.00	7.50	7.50	1	f	f	\N	2026-01-31 12:00:00	\N	0.00	DENIS
1784	T11	-1632933197	0.00	36.00	36.00	1	f	f	\N	2024-08-02 12:00:00	\N	0.00	Sabine
3518	T8	\N	176.20	0.00	176.20	4	f	f	\N	2026-02-05 12:00:00	\N	176.20	delsa
3895	DÉPENSES	\N	-50.48	0.00	-50.48	1	f	t	\N	2026-06-22 15:48:00	\N	0.00	\N
1786	\N	811323752	0.00	51.00	51.00	3	t	f	\N	2024-08-02 12:00:00	\N	0.00	Emporté
3897	DÉPENSES	\N	-28.00	0.00	-28.00	1	f	t	\N	2026-06-18 15:49:00	\N	0.00	\N
3524	\N	\N	-57.85	0.00	-57.85	1	f	t	\N	2026-02-06 12:00:00	\N	0.00	\N
3906	T12	\N	0.00	54.20	54.20	1	f	f	\N	2026-06-19 09:54:00	\N	54.20	Whitney
3527	\N	\N	0.00	9.20	9.20	1	t	f	\N	2026-02-06 12:00:00	\N	0.00	Emporté
1797	T14	-479672637	0.00	6.00	6.00	1	f	f	\N	2024-08-09 12:00:00	\N	0.00	T14
3905	T13	\N	18.00	0.00	18.00	1	f	f	\N	2026-06-19 09:52:00	\N	0.00	Ludo
1799	T14	686373030	0.00	7.50	7.50	1	f	f	\N	2024-08-09 12:00:00	\N	0.00	Christophe
1908	T11	798729588	25.00	0.00	25.00	1	f	f	\N	2024-09-04 12:00:00	\N	25.00	FRANCOISE
3904	T14	-479672637	21.50	0.00	21.50	1	f	f	\N	2026-06-19 09:51:00	\N	0.00	Manu
1923	T11	190114966	43.50	0.00	43.50	2	f	f	\N	2024-09-06 12:00:00	\N	43.50	ERIC
3482	T12	\N	41.40	0.00	41.40	1	f	f	\N	2026-01-23 12:00:00	\N	41.40	0492501273
3542	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2026-02-04 12:00:00	\N	0.00	\N
1948	T8	-2101073188	80.00	39.00	119.00	3	f	f	\N	2024-09-11 12:00:00	\N	119.00	Daniel
2008	T9	3	0.00	55.00	55.00	2	f	f	\N	2024-09-27 12:00:00	\N	0.00	FILOU
3548	T11	\N	0.00	137.70	137.70	4	f	f	\N	2026-02-13 12:00:00	\N	0.00	maurine
3557	T5	\N	0.00	43.20	43.20	2	f	f	\N	2026-02-19 12:00:00	\N	0.00	0497459835
3569	\N	\N	-56.00	0.00	-56.00	1	f	t	\N	2026-02-21 12:00:00	\N	0.00	\N
3572	T8	\N	0.00	75.00	75.00	2	f	f	\N	2026-02-21 12:00:00	\N	0.00	couple
3575	T5	\N	51.00	0.00	51.00	2	f	f	\N	2026-02-26 12:00:00	\N	51.00	T5
3578	\N	\N	-91.80	0.00	-91.80	1	f	t	\N	2026-03-02 12:00:00	\N	0.00	\N
3509	T8	\N	0.00	124.70	124.70	1	f	f	\N	2026-01-31 12:00:00	\N	0.00	MARC
3581	\N	\N	-23.94	0.00	-23.94	1	f	t	\N	2026-02-27 12:00:00	\N	0.00	\N
3536	T14	\N	20.00	0.00	20.00	1	f	f	\N	2026-02-12 12:00:00	\N	20.00	MANU
3587	T8	\N	54.00	0.00	54.00	2	f	f	\N	2026-02-27 12:00:00	\N	54.00	SOPHIE
3566	\N	\N	-34.45	0.00	-34.45	1	f	t	\N	2026-02-19 12:00:00	\N	0.00	\N
3590	\N	\N	-44.20	0.00	-44.20	1	f	t	\N	2026-02-28 12:00:00	\N	0.00	\N
3599	\N	\N	-175.47	0.00	-175.47	1	f	t	\N	2026-02-27 12:00:00	\N	0.00	\N
3608	\N	\N	-301.69	0.00	-301.69	1	f	t	\N	2026-03-04 12:00:00	\N	0.00	\N
3623	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2026-03-06 12:00:00	\N	0.00	\N
3641	\N	\N	0.00	6.00	6.00	1	t	f	\N	2026-03-13 12:00:00	\N	6.00	Emporté
3602	\N	\N	-106.83	0.00	-106.83	1	f	t	\N	2026-02-23 12:00:00	\N	0.00	\N
3614	T13	\N	0.00	409.10	409.10	14	f	f	\N	2026-03-06 12:00:00	\N	0.00	FILOU
3617	T2	\N	0.00	13.00	13.00	3	f	f	\N	2026-03-06 12:00:00	\N	0.00	alex
3620	T15	\N	0.00	58.50	58.50	1	f	f	\N	2026-03-06 12:00:00	\N	0.00	Xavier
3632	T5	\N	0.00	108.00	108.00	6	f	f	\N	2026-03-12 12:00:00	\N	0.00	SOPHIE
3635	\N	\N	0.00	24.40	24.40	2	t	f	\N	2026-03-13 12:00:00	\N	24.40	Emporté
3638	T9	\N	0.00	60.00	60.00	2	f	f	\N	2026-03-13 12:00:00	\N	60.00	EVE
3503	T8	\N	0.00	49.00	49.00	2	f	f	\N	2026-01-31 12:00:00	\N	0.00	MARC
3644	\N	\N	-22.10	0.00	-22.10	1	f	t	\N	2026-03-13 12:00:00	\N	0.00	\N
3650	\N	\N	0.00	34.00	34.00	2	t	f	\N	2026-03-14 12:00:00	\N	34.00	Emporté
3653	T5	\N	0.00	0.00	0.00	4	f	f	\N	2026-03-14 12:00:00	\N	0.00	steph
3659	T5	\N	6.90	0.00	6.90	1	f	f	\N	2026-03-15 12:00:00	\N	6.90	vero
3662	T9	\N	76.40	0.00	76.40	2	f	f	\N	2026-03-15 12:00:00	\N	76.40	PABLO
3647	\N	\N	-105.00	0.00	-105.00	1	f	t	\N	2026-03-13 12:00:00	\N	0.00	\N
3656	T2	\N	0.00	29.50	29.50	1	f	f	\N	2026-03-15 12:00:00	\N	0.00	voisin
2874	T9	\N	0.00	21.00	21.00	1	f	f	\N	2025-05-21 12:00:00	\N	0.00	Dame seule
3671	\N	\N	-16.22	0.00	-16.22	1	f	t	\N	2026-03-15 12:00:00	\N	0.00	\N
2907	\N	\N	-114.20	0.00	-114.20	1	f	t	\N	2025-06-04 12:00:00	\N	0.00	\N
3674	\N	\N	0.00	35.00	35.00	2	t	f	\N	2026-03-20 12:00:00	\N	35.00	Emporté
2908	\N	\N	-111.28	0.00	-111.28	1	f	t	\N	2025-05-10 12:00:00	\N	0.00	\N
3677	T13	\N	0.00	176.00	176.00	5	f	f	\N	2026-03-20 12:00:00	\N	176.00	eve
2914	\N	\N	-26.65	0.00	-26.65	1	f	t	\N	2025-06-06 12:00:00	\N	0.00	\N
2939	\N	\N	-78.00	0.00	-78.00	1	f	t	\N	2025-06-13 12:00:00	\N	0.00	\N
2943	T15	\N	22.00	0.00	22.00	1	f	f	\N	2025-06-13 12:00:00	\N	22.00	ami
3488	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2026-01-20 12:00:00	\N	0.00	\N
3665	T10	\N	6.00	0.00	6.00	1	f	f	\N	2026-03-15 12:00:00	\N	6.00	Tetons
3478	\N	\N	-33.30	0.00	-33.30	1	f	t	\N	2026-01-23 12:00:00	\N	0.00	\N
3615	T14	\N	160.00	0.00	160.00	5	f	f	\N	2026-03-06 12:00:00	\N	0.00	VINS
3480	\N	\N	-92.82	0.00	-92.82	1	f	t	\N	2026-01-23 12:00:00	\N	0.00	\N
3481	T5	\N	38.70	0.00	38.70	2	f	f	\N	2026-01-23 12:00:00	\N	38.70	ROEKENS
3633	T12	\N	99.50	0.00	99.50	2	f	f	\N	2026-03-12 12:00:00	\N	0.00	FELICE
1800	T10	1936806253	51.00	38.20	89.20	2	f	f	\N	2024-08-09 12:00:00	\N	51.00	Eve
1803	T11	798729588	65.40	0.00	65.40	2	f	f	\N	2024-08-10 12:00:00	\N	65.40	Sabine
1870	T11	798729588	55.40	0.00	55.40	3	f	f	\N	2024-08-28 12:00:00	\N	55.40	FRANCOISE
1924	T8	-2101073188	0.00	110.50	110.50	3	f	f	\N	2024-09-06 12:00:00	\N	0.00	DANIEL
2009	\N	-479672637	0.00	10.00	10.00	1	t	f	\N	2024-09-27 12:00:00	\N	0.00	Emporté
3489	\N	\N	-217.80	0.00	-217.80	1	f	t	\N	2026-01-20 12:00:00	\N	0.00	\N
3490	\N	\N	-28.00	0.00	-28.00	1	f	t	\N	2026-01-19 12:00:00	\N	0.00	\N
2042	T8	1588048427	0.00	45.40	45.40	2	f	f	\N	2024-10-04 12:00:00	\N	0.00	ELISE
3492	\N	\N	-532.63	0.00	-532.63	1	f	t	\N	2026-01-13 12:00:00	\N	0.00	\N
3493	\N	\N	-376.50	0.00	-376.50	1	f	t	\N	2026-01-13 12:00:00	\N	0.00	\N
1883	T2	1170351074	0.00	65.00	65.00	2	f	f	\N	2024-08-30 12:00:00	\N	65.00	MANCINI
3496	T5	\N	162.50	0.00	162.50	4	f	f	\N	2026-01-24 12:00:00	\N	162.50	DUBART
1968	T12	-1769468414	0.00	42.00	42.00	1	f	f	\N	2024-09-13 12:00:00	\N	42.00	T12
3498	\N	\N	0.00	6.00	6.00	1	t	f	\N	2026-01-29 12:00:00	\N	0.00	Emporté
3499	T6	\N	68.40	0.00	68.40	2	f	f	\N	2026-01-29 12:00:00	\N	68.40	FANETTE
1992	T11	798729588	25.00	0.00	25.00	1	f	f	\N	2024-09-20 12:00:00	\N	25.00	FRANCOISE
2049	T7	-2101073188	84.00	168.50	252.50	6	f	f	\N	2024-10-05 12:00:00	\N	252.50	DANIEL
2071	T11	190114966	0.00	60.00	60.00	2	f	f	\N	2024-10-10 12:00:00	\N	0.00	Eric
2422	T9	-867980635	0.00	119.00	119.00	1	f	f	\N	2025-01-11 12:00:00	\N	0.00	Arnold
2385	T15	644045150	72.00	0.00	72.00	1	f	f	\N	2025-01-01 12:00:00	\N	72.00	RUDY
3505	T10	\N	330.40	0.00	330.40	8	f	f	\N	2026-01-31 12:00:00	\N	330.40	PIROTTE
2386	T6	1776719868	92.20	0.00	92.20	4	f	f	\N	2025-01-01 12:00:00	\N	92.20	AURORE
2398	T9	-384455030	0.00	327.90	327.90	9	f	f	\N	2025-01-04 12:00:00	\N	0.00	0485108494
2412	T9	1063798313	0.00	80.00	80.00	2	f	f	\N	2025-01-08 12:00:00	\N	0.00	TANTE STEPH
3896	DÉPENSES	\N	-119.80	0.00	-119.80	1	f	t	\N	2026-06-19 15:48:00	\N	0.00	\N
2419	T13	-1769468414	0.00	44.50	44.50	2	f	f	\N	2025-01-10 12:00:00	\N	0.00	LAURENT
2421	T11	1369254710	72.00	0.00	72.00	2	f	f	\N	2025-01-10 12:00:00	\N	72.00	GOUDERS
2446	T5	-469180033	167.30	0.00	167.30	4	f	f	\N	2025-01-17 12:00:00	\N	167.30	BIFERI
2448	T10	116918907	96.00	0.00	96.00	2	f	f	\N	2025-01-18 12:00:00	\N	96.00	Delcomte
2457	T12	1170351074	115.50	0.00	115.50	3	f	f	\N	2025-01-22 12:00:00	\N	115.50	MICHEL MANCINI
3516	T13	\N	0.00	2.50	2.50	1	f	f	\N	2026-02-05 12:00:00	\N	0.00	T13
3517	T6	\N	60.60	0.00	60.60	2	f	f	\N	2026-02-05 12:00:00	\N	60.60	eric
2075	T8	-2101073188	0.00	12.50	12.50	1	f	f	\N	2024-10-11 12:00:00	\N	0.00	DANIEL
3519	T11	\N	73.90	0.00	73.90	2	f	f	\N	2026-02-05 12:00:00	\N	73.90	lion
2076	T12	3	0.00	115.00	115.00	2	f	f	\N	2024-10-11 12:00:00	\N	0.00	FILOU
2077	T11	3	0.00	34.00	34.00	1	f	f	\N	2024-10-11 12:00:00	\N	0.00	T11
3522	\N	\N	-8.00	0.00	-8.00	1	f	t	\N	2026-02-06 12:00:00	\N	0.00	\N
3523	\N	\N	-46.00	0.00	-46.00	1	f	t	\N	2026-02-06 12:00:00	\N	0.00	\N
2090	T9	-2101073188	345.10	0.00	345.10	16	f	f	\N	2024-10-16 12:00:00	\N	345.10	T9
3525	\N	\N	-153.42	0.00	-153.42	1	f	t	\N	2026-02-05 12:00:00	\N	0.00	\N
3526	\N	\N	-94.56	0.00	-94.56	1	f	t	\N	2026-02-05 12:00:00	\N	0.00	\N
2091	T14	627317039	0.00	109.20	109.20	2	f	f	\N	2024-10-16 12:00:00	\N	109.20	JM&Eric
3528	\N	\N	35.00	0.00	35.00	2	t	f	\N	2026-02-07 12:00:00	\N	35.00	Emporté
3529	\N	\N	-109.25	0.00	-109.25	1	f	t	\N	2026-02-07 12:00:00	\N	0.00	\N
2098	T2	-133521499	0.00	82.00	82.00	2	f	f	\N	2024-10-17 12:00:00	\N	0.00	Charlotte
3537	T10	\N	47.40	0.00	47.40	2	f	f	\N	2026-02-12 12:00:00	\N	47.40	0496940135
3543	T11	\N	0.00	59.00	59.00	2	f	f	\N	2026-02-13 12:00:00	\N	0.00	MANCINI
3546	T5	\N	0.00	80.40	80.40	3	f	f	\N	2026-02-13 12:00:00	\N	0.00	DENIS
3495	T9	\N	0.00	72.00	72.00	1	f	f	\N	2026-01-24 12:00:00	\N	0.00	CAYET
3486	\N	\N	-138.97	0.00	-138.97	1	f	t	\N	2026-01-23 12:00:00	\N	0.00	\N
3555	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2026-02-14 12:00:00	\N	0.00	\N
3513	T2	\N	17.00	0.00	17.00	1	f	f	\N	2026-01-31 12:00:00	\N	17.00	VAM
3549	T13	\N	10.00	0.00	10.00	1	f	f	\N	2026-02-14 12:00:00	\N	10.00	MANU
3561	T12	\N	0.00	66.40	66.40	2	f	f	\N	2026-02-20 12:00:00	\N	0.00	vam
3564	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2026-02-20 12:00:00	\N	0.00	\N
3588	T2	\N	13.50	0.00	13.50	1	f	f	\N	2026-02-28 12:00:00	\N	13.50	manu
3567	\N	\N	-105.96	0.00	-105.96	1	f	t	\N	2026-02-19 12:00:00	\N	0.00	\N
3606	\N	\N	-88.74	0.00	-88.74	1	f	t	\N	2026-03-05 12:00:00	\N	0.00	\N
3570	\N	\N	-7.20	0.00	-7.20	1	f	t	\N	2026-02-21 12:00:00	\N	0.00	\N
3609	\N	\N	-363.00	0.00	-363.00	1	f	t	\N	2026-03-03 12:00:00	\N	0.00	\N
3573	T5	\N	0.00	156.80	156.80	5	f	f	\N	2026-02-21 12:00:00	\N	0.00	EVE
3627	\N	\N	-10.27	0.00	-10.27	1	f	t	\N	2026-03-07 12:00:00	\N	0.00	\N
3576	\N	\N	0.00	88.00	88.00	6	t	f	\N	2026-02-27 12:00:00	\N	0.00	Emporté
3630	\N	\N	-75.17	0.00	-75.17	1	f	t	\N	2026-03-12 12:00:00	\N	0.00	\N
3639	T13	\N	0.00	18.00	18.00	1	f	f	\N	2026-03-13 12:00:00	\N	18.00	ELISE
3645	\N	\N	-14.60	0.00	-14.60	1	f	t	\N	2026-03-13 12:00:00	\N	0.00	\N
3585	T14	\N	453.40	0.00	453.40	21	f	f	\N	2026-02-27 12:00:00	\N	453.40	Français
3654	\N	\N	-90.00	0.00	-90.00	1	f	t	\N	2026-03-14 12:00:00	\N	0.00	\N
3657	T2	\N	0.00	30.00	30.00	1	f	f	\N	2026-03-15 12:00:00	\N	0.00	voisin
3591	T5	\N	0.00	136.00	136.00	3	f	f	\N	2026-02-28 12:00:00	\N	0.00	foerster
3603	\N	\N	-28.00	0.00	-28.00	1	f	t	\N	2026-02-16 12:00:00	\N	0.00	\N
3618	\N	\N	0.00	8.20	8.20	1	t	f	\N	2026-03-06 12:00:00	\N	0.00	Emporté
3621	T5	\N	0.00	179.60	179.60	7	f	f	\N	2026-03-06 12:00:00	\N	179.60	gouvy
3624	\N	\N	-105.00	0.00	-105.00	1	f	t	\N	2026-03-06 12:00:00	\N	0.00	\N
3636	T11	\N	0.00	18.00	18.00	1	f	f	\N	2026-03-13 12:00:00	\N	18.00	T11
3642	T9	\N	0.00	50.50	50.50	2	f	f	\N	2026-03-13 12:00:00	\N	0.00	T9
3648	T5	\N	0.00	179.60	179.60	4	f	f	\N	2026-03-13 12:00:00	\N	0.00	FONTAINE
3660	T9	\N	0.00	0.00	0.00	1	f	f	\N	2026-03-15 12:00:00	\N	5.00	rudy
3663	T11	\N	0.00	28.00	28.00	2	f	f	\N	2026-03-15 12:00:00	\N	0.00	CHRIS & DOM
3672	T12	\N	0.00	37.00	37.00	1	f	f	\N	2026-03-20 12:00:00	\N	0.00	Pierre
2103	T12	-2101073188	22.20	0.00	22.20	1	f	f	\N	2024-10-18 12:00:00	\N	22.20	T12
3535	T6	\N	89.90	0.00	89.90	3	f	f	\N	2026-02-12 12:00:00	\N	89.90	TILMAN
2105	T13	3	0.00	100.40	0.00	2	f	f	\N	2024-10-18 12:00:00	\N	0.00	FILOU
3538	T12	\N	62.20	0.00	62.20	2	f	f	\N	2026-02-12 12:00:00	\N	62.20	Fanette
2118	\N	-479672637	0.00	19.00	19.00	1	t	f	\N	2024-10-19 12:00:00	\N	15.00	Emporté
3541	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2026-02-06 12:00:00	\N	0.00	\N
2122	T7	-1801614408	0.00	0.00	0.00	3	f	f	\N	2024-10-19 12:00:00	\N	0.00	lara et louis
3544	\N	\N	-10.37	0.00	-10.37	1	f	t	\N	2026-02-07 12:00:00	\N	0.00	\N
2135	T13	1105205458	0.00	12.00	12.00	1	f	f	\N	2024-10-25 12:00:00	\N	0.00	T13
2146	T13	1393851931	0.00	32.00	32.00	1	f	f	\N	2024-10-26 12:00:00	\N	32.00	Christophe
2672	T5	-1500277506	0.00	50.00	50.00	1	f	f	\N	2025-03-21 12:00:00	\N	0.00	MARIANNE
3553	T9	\N	0.00	80.00	80.00	2	f	f	\N	2026-02-14 12:00:00	\N	0.00	florkin
2387	T9	1105205458	312.80	241.00	553.80	13	f	f	\N	2025-01-01 12:00:00	\N	312.80	STEPHANE
2435	T9	1705886505	56.50	0.00	56.50	1	f	f	\N	2025-01-15 12:00:00	\N	56.50	DELGADO
3559	T15	\N	19.00	0.00	19.00	1	f	f	\N	2026-02-20 12:00:00	\N	19.00	T15
2390	T8	-1763527961	38.40	0.00	38.40	2	f	f	\N	2025-01-03 12:00:00	\N	38.40	MAURINE
2438	T13	-1850234108	60.00	23.00	83.00	1	f	f	\N	2025-01-17 12:00:00	\N	83.00	JC
2393	T9	-467686845	0.00	165.00	165.00	6	f	f	\N	2025-01-03 12:00:00	\N	0.00	CALBERG
2411	T11	1170351074	0.00	117.00	117.00	3	f	f	\N	2025-01-08 12:00:00	\N	0.00	MICHEL
2420	T6	-1763527961	0.00	193.00	193.00	4	f	f	\N	2025-01-10 12:00:00	\N	0.00	ERIC&IRENE
3568	\N	\N	-36.05	0.00	-36.05	1	f	t	\N	2026-02-21 12:00:00	\N	0.00	\N
2462	T12	-1602796250	0.00	0.00	0.00	2	f	f	\N	2025-01-24 12:00:00	\N	39.40	JEANCRI
3571	T13	\N	9.00	0.00	9.00	1	f	f	\N	2026-02-21 12:00:00	\N	9.00	T13
2465	T13	-1769468414	0.00	38.00	38.00	1	f	f	\N	2025-01-25 12:00:00	\N	0.00	LAURENT
3574	\N	\N	0.00	0.00	0.00	1	t	f	\N	2026-02-26 12:00:00	\N	0.00	Emporté
2673	T9	-1454545753	0.00	403.90	403.90	13	f	f	\N	2025-03-21 12:00:00	\N	0.00	XAVIER
3577	T9	\N	97.50	0.00	97.50	2	f	f	\N	2026-02-26 12:00:00	\N	97.50	T9
2684	T9	1671272237	63.00	0.00	63.00	2	f	f	\N	2025-03-22 12:00:00	\N	63.00	COUNE
3580	\N	\N	0.00	46.00	46.00	1	t	f	\N	2026-02-27 12:00:00	\N	0.00	Emporté
3586	\N	\N	-11.20	0.00	-11.20	1	f	t	\N	2026-02-27 12:00:00	\N	0.00	\N
3550	\N	\N	-8.16	0.00	-8.16	1	f	t	\N	2026-02-14 12:00:00	\N	0.00	\N
3547	T9	\N	0.00	18.20	18.20	1	f	f	\N	2026-02-13 12:00:00	\N	0.00	stephane
3556	\N	\N	-19.38	0.00	-19.38	1	f	t	\N	2026-02-13 12:00:00	\N	0.00	\N
3595	\N	\N	-105.00	0.00	-105.00	1	f	t	\N	2026-02-27 12:00:00	\N	0.00	\N
3598	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2026-02-28 12:00:00	\N	0.00	\N
3601	\N	\N	-127.79	0.00	-127.79	1	f	t	\N	2026-02-23 12:00:00	\N	0.00	\N
3607	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2026-03-01 12:00:00	\N	0.00	\N
3631	T2	\N	0.00	9.00	9.00	1	f	f	\N	2026-03-12 12:00:00	\N	0.00	T2
3640	T15	\N	0.00	5.00	5.00	1	f	f	\N	2026-03-13 12:00:00	\N	5.00	MANU
3646	\N	\N	-156.90	0.00	-156.90	1	f	t	\N	2026-03-13 12:00:00	\N	0.00	\N
3655	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2026-03-14 12:00:00	\N	0.00	\N
3616	\N	\N	0.00	17.00	17.00	1	t	f	\N	2026-03-06 12:00:00	\N	17.00	Emporté
3683	\N	\N	-45.00	0.00	-45.00	1	f	t	\N	2026-03-21 12:00:00	\N	0.00	\N
3619	T2	\N	0.00	8.00	8.00	1	f	f	\N	2026-03-06 12:00:00	\N	0.00	manu
3704	\N	\N	-151.56	0.00	-151.56	1	f	t	\N	2026-03-28 12:00:00	\N	0.00	\N
3622	T12	\N	0.00	72.00	72.00	2	f	f	\N	2026-03-06 12:00:00	\N	0.00	timmers
3705	\N	\N	-85.44	0.00	-85.44	1	f	t	\N	2026-03-27 12:00:00	\N	0.00	\N
3625	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2026-03-06 12:00:00	\N	0.00	\N
3713	\N	\N	0.00	2.20	2.20	1	t	f	\N	2026-03-28 12:00:00	\N	2.20	Emporté
3714	\N	\N	-93.00	0.00	-93.00	1	f	t	\N	2026-04-01 12:00:00	\N	0.00	\N
3634	T9	\N	0.00	51.00	51.00	2	f	f	\N	2026-03-12 12:00:00	\N	0.00	T9
3637	T14	\N	0.00	8.00	8.00	1	f	f	\N	2026-03-13 12:00:00	\N	0.00	T14
3643	T12	\N	0.00	70.00	70.00	2	f	f	\N	2026-03-13 12:00:00	\N	0.00	JULEMONT
3649	\N	\N	30.00	0.00	30.00	1	t	f	\N	2026-03-14 12:00:00	\N	30.00	Emporté
3652	T14	\N	0.00	272.50	272.50	7	f	f	\N	2026-03-14 12:00:00	\N	0.00	legros
3658	T2	\N	0.00	29.50	29.50	1	f	f	\N	2026-03-15 12:00:00	\N	0.00	voisin
3661	T12	\N	0.00	21.50	21.50	2	f	f	\N	2026-03-15 12:00:00	\N	0.00	CHRIS & ETIENNE
3670	\N	\N	-44.49	0.00	-44.49	1	f	t	\N	2026-03-06 12:00:00	\N	0.00	\N
3676	T12	\N	0.00	104.70	104.70	3	t	f	\N	2026-03-20 12:00:00	\N	104.70	mannard
3678	\N	\N	-90.00	0.00	-90.00	1	f	t	\N	2026-03-20 12:00:00	\N	0.00	\N
3679	\N	\N	0.00	110.00	110.00	22	t	f	\N	2026-03-21 12:00:00	\N	110.00	Emporté
3681	T5	\N	0.00	105.50	105.50	4	f	f	\N	2026-03-21 12:00:00	\N	0.00	foester
3684	T9	\N	127.20	0.00	127.20	6	t	f	\N	2026-03-14 12:00:00	\N	127.20	0472226112
3685	\N	\N	-10.64	0.00	-10.64	1	f	t	\N	2026-03-26 12:00:00	\N	0.00	\N
3686	\N	\N	-9.60	0.00	-9.60	1	f	t	\N	2026-03-26 12:00:00	\N	0.00	\N
3687	\N	\N	-49.57	0.00	-49.57	1	f	t	\N	2026-03-26 12:00:00	\N	0.00	\N
3688	\N	\N	-14.56	0.00	-14.56	1	f	t	\N	2026-03-21 12:00:00	\N	0.00	\N
3689	\N	\N	-7.95	0.00	-7.95	1	f	t	\N	2026-03-21 12:00:00	\N	0.00	\N
3690	T13	\N	0.00	18.00	18.00	1	f	f	\N	2026-03-26 12:00:00	\N	0.00	DENIS
3691	T5	\N	71.00	0.00	71.00	2	f	f	\N	2026-03-26 12:00:00	\N	71.00	T5
3692	T12	\N	65.00	0.00	65.00	1	t	f	\N	2026-03-26 12:00:00	\N	65.00	T12
3693	T7	\N	0.00	84.50	84.50	2	f	f	\N	2026-03-26 12:00:00	\N	84.50	T7
3694	T9	\N	0.00	69.20	69.20	2	f	f	\N	2026-03-26 12:00:00	\N	69.20	T9
3697	\N	\N	0.00	17.00	17.00	1	t	f	\N	2026-03-27 12:00:00	\N	17.00	Emporté
3698	T2	\N	88.00	0.00	88.00	2	f	f	\N	2026-03-27 12:00:00	\N	88.00	Maisse
3699	T14	\N	65.20	0.00	65.20	3	f	f	\N	2026-03-27 12:00:00	\N	65.20	T14
3700	T6	\N	0.00	115.20	115.20	3	f	f	\N	2026-03-27 12:00:00	\N	115.20	Tassoudis
3701	T5	\N	0.00	87.00	87.00	2	f	f	\N	2026-03-27 12:00:00	\N	87.00	Jaquemain
3702	T8	\N	84.50	0.00	84.50	2	f	f	\N	2026-03-27 12:00:00	\N	84.50	Philippe
3703	T12	\N	0.00	264.00	264.00	7	f	f	\N	2026-03-27 12:00:00	\N	264.00	Gazon
3706	\N	\N	-104.10	0.00	-104.10	1	f	t	\N	2026-03-27 12:00:00	\N	0.00	\N
3708	T5	\N	0.00	83.00	83.00	2	f	f	\N	2026-03-28 12:00:00	\N	83.00	HALLEUX
3710	T11	\N	0.00	61.10	61.10	3	f	f	\N	2026-03-28 12:00:00	\N	61.10	T11
3711	T9	\N	0.00	141.00	141.00	2	f	f	\N	2026-03-28 12:00:00	\N	0.00	PONCETTE
2714	T7	3	0.00	202.20	202.20	4	f	f	\N	2025-03-28 12:00:00	\N	0.00	FILOU
3718	T12	\N	53.00	0.00	53.00	2	f	f	\N	2026-04-03 12:00:00	\N	53.00	NANAS
3892	\N	\N	162.50	0.00	162.50	1	t	f	\N	2026-06-15 12:00:00	\N	0.00	Emporté
2460	T10	1634782901	47.90	0.00	47.90	2	f	f	\N	2025-01-23 12:00:00	\N	47.90	0488678384
2691	T5	-1632933197	110.40	0.00	110.40	2	f	f	\N	2025-03-26 12:00:00	\N	110.40	SABINE
2692	T7	3	0.00	58.40	58.40	2	f	f	\N	2025-03-26 12:00:00	\N	0.00	FILOU
2698	T13	548676026	0.00	44.00	44.00	1	f	f	\N	2025-03-27 12:00:00	\N	0.00	PATRICE
2712	T5	-479672637	28.00	0.00	28.00	2	f	f	\N	2025-03-28 12:00:00	\N	28.00	MANU
3856	T13	-1931747542	68.20	100.00	168.20	5	f	f	\N	2026-05-29 12:00:00	\N	100.00	DENIS
3733	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2026-04-04 12:00:00	\N	0.00	\N
2727	T9	-1632933197	73.00	0.00	73.00	2	f	f	\N	2025-03-29 12:00:00	\N	73.00	SABINE
2742	T9	1908980572	0.00	62.00	62.00	3	f	f	\N	2025-04-04 12:00:00	\N	62.00	MUMU
3739	\N	\N	-118.76	0.00	-118.76	1	f	t	\N	2026-04-10 12:00:00	\N	0.00	\N
3915	T9	\N	38.40	0.00	38.40	1	f	f	\N	2026-06-26 12:00:00	\N	0.00	2 jeunes
3745	\N	\N	-75.00	0.00	-75.00	1	f	t	\N	2026-04-10 12:00:00	\N	0.00	\N
3889	T2	190114966	0.00	45.40	45.40	1	f	f	\N	2026-06-15 12:00:00	\N	45.40	eric
3748	T2	\N	88.20	0.00	88.20	3	f	f	\N	2026-04-11 12:00:00	\N	88.20	humblet
3917	T9	\N	67.80	0.00	67.80	1	f	f	\N	2026-06-26 12:00:00	\N	0.00	Afrique
3751	\N	\N	-301.69	0.00	-301.69	1	f	t	\N	2026-04-07 12:00:00	\N	0.00	\N
3844	T9	\N	50.60	0.00	50.60	3	f	f	\N	2026-05-22 12:00:00	\N	0.00	bebe
2743	T13	-1163187653	52.20	0.00	52.20	4	f	f	\N	2025-04-04 12:00:00	\N	52.20	PIERRE
3903	T7	1090130270	101.40	0.00	101.40	1	f	f	\N	2026-06-20 09:50:00	\N	0.00	Wos
2745	T7	-1632933197	90.70	0.00	90.70	2	f	f	\N	2025-04-04 12:00:00	\N	90.70	SABINE
3841	T9	\N	0.00	45.00	45.00	2	f	f	\N	2026-05-22 12:00:00	\N	45.00	T9
2746	T9	-61916888	0.00	293.50	293.50	8	f	f	\N	2025-04-04 12:00:00	\N	0.00	HAUZER
2752	T12	-1632933197	0.00	31.00	31.00	1	f	f	\N	2025-04-10 12:00:00	\N	0.00	SABINE
2755	T9	-560080272	0.00	302.00	302.00	10	f	f	\N	2025-04-11 12:00:00	\N	302.00	OUVRIERS
3769	T9	\N	0.00	43.00	43.00	2	f	f	\N	2026-04-17 12:00:00	\N	0.00	T9
2756	T9	-560080272	22.40	0.00	22.40	10	f	f	\N	2025-04-11 12:00:00	\N	22.40	OUVRIERS
3772	T15	\N	38.00	0.00	38.00	1	f	f	\N	2026-04-17 12:00:00	\N	38.00	manu
3775	T14	\N	92.00	0.00	92.00	2	f	f	\N	2026-04-17 12:00:00	\N	92.00	maurine
2757	T9	-560080272	0.00	30.50	30.50	10	f	f	\N	2025-04-11 12:00:00	\N	30.50	OUVRIERS
3778	\N	\N	-75.00	0.00	-75.00	1	f	t	\N	2026-04-17 12:00:00	\N	0.00	\N
2761	T7	3	0.00	252.00	252.00	5	f	f	\N	2025-04-11 12:00:00	\N	0.00	FILOU
2764	T5	798729588	22.00	0.00	22.00	1	f	f	\N	2025-04-11 12:00:00	\N	22.00	FRANCOISE
3787	T5	\N	0.00	112.40	112.40	2	f	f	\N	2026-04-24 12:00:00	\N	0.00	Couple
2768	T13	-1931747542	48.00	0.00	48.00	2	f	f	\N	2025-04-11 12:00:00	\N	48.00	DENIS
2224	T7	3	0.00	178.00	178.00	3	f	f	\N	2024-11-08 12:00:00	\N	0.00	T7
2255	T14	-1769468414	0.00	41.50	41.50	2	f	f	\N	2024-11-14 12:00:00	\N	0.00	LAURENT
3793	T12	\N	0.00	474.00	474.00	5	f	f	\N	2026-04-24 12:00:00	\N	0.00	Filou
2262	\N	798729588	0.00	24.00	24.00	4	t	f	\N	2024-11-20 12:00:00	\N	24.00	Emporté
3799	T8	\N	0.00	253.20	253.20	4	f	f	\N	2026-04-25 12:00:00	\N	0.00	veneria
2263	T4	-133521499	0.00	62.00	62.00	2	f	f	\N	2024-11-20 12:00:00	\N	0.00	T4
2265	T9	1484643075	228.00	0.00	228.00	9	f	f	\N	2024-11-20 12:00:00	\N	228.00	IFAPME
3805	\N	\N	-55.81	0.00	-55.81	1	f	t	\N	2026-04-15 12:00:00	\N	0.00	\N
2266	T2	1393851931	0.00	39.50	39.50	1	f	f	\N	2024-11-20 12:00:00	\N	0.00	Christophe
2474	T7	-479672637	22.00	0.00	22.00	1	f	f	\N	2025-01-29 12:00:00	\N	22.00	MANU
2297	T5	232453727	73.10	0.00	73.10	3	f	f	\N	2024-11-27 12:00:00	\N	73.10	SARAH
3814	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2026-04-25 12:00:00	\N	0.00	\N
2489	T10	-1551998939	78.20	0.00	78.20	3	f	f	\N	2025-01-31 12:00:00	\N	78.20	DIDIER
2333	\N	-479672637	10.00	0.00	10.00	1	t	f	\N	2024-12-06 12:00:00	\N	10.00	Emporté
2501	T7	3	0.00	76.20	76.20	2	f	f	\N	2025-02-05 12:00:00	\N	0.00	FILOU
2513	T5	769723709	123.50	0.00	123.50	3	f	f	\N	2025-02-07 12:00:00	\N	123.50	FRED BC VERLAINE
3826	\N	\N	-15.00	0.00	-15.00	1	f	t	\N	2026-05-21 12:00:00	\N	0.00	\N
3829	T10	\N	0.00	63.00	63.00	2	f	f	\N	2026-05-21 12:00:00	\N	63.00	T10
2477	T6	-1931747542	0.00	5.00	5.00	1	f	f	\N	2025-01-29 12:00:00	\N	0.00	Denis
3832	\N	\N	-301.69	0.00	-301.69	1	f	t	\N	2026-05-04 12:00:00	\N	0.00	\N
3853	\N	\N	-87.50	0.00	-87.50	1	f	t	\N	2026-05-29 12:00:00	\N	0.00	\N
3859	\N	\N	0.00	34.00	34.00	2	t	f	\N	2026-05-30 12:00:00	\N	34.00	Emporté
3862	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2026-05-30 12:00:00	\N	0.00	\N
2681	T5	\N	187.40	0.00	187.40	5	f	f	\N	2025-03-21 12:00:00	\N	187.40	LIO
2706	\N	\N	-126.65	0.00	-126.65	1	f	t	\N	2025-03-24 12:00:00	\N	0.00	\N
3871	\N	\N	-301.69	0.00	-301.69	1	f	t	\N	2026-06-04 12:00:00	\N	0.00	\N
2729	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2025-03-29 12:00:00	\N	0.00	\N
3877	T10	\N	0.00	355.40	355.40	9	f	f	\N	2026-06-12 12:00:00	\N	355.40	VENERIA
3880	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2026-06-13 12:00:00	\N	0.00	\N
3883	\N	\N	0.00	6.50	6.50	1	t	f	\N	2026-06-15 12:00:00	\N	6.50	Emporté
2424	T13	\N	0.00	114.90	114.90	1	f	f	\N	2025-01-11 12:00:00	\N	0.00	Voisine
2428	T6	\N	30.00	0.00	30.00	1	f	f	\N	2025-01-11 12:00:00	\N	30.00	Occupé
2432	\N	\N	-230.00	0.00	-230.00	1	f	t	\N	2025-01-11 12:00:00	\N	0.00	\N
2492	T9	-732188617	81.20	0.00	81.20	1	f	f	\N	2025-02-01 12:00:00	\N	81.20	OLIVIER
2561	T12	-1763527961	0.00	59.50	59.50	1	f	f	\N	2025-02-14 12:00:00	\N	0.00	ERIC
3723	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2026-04-01 12:00:00	\N	0.00	\N
2597	T5	1461066836	68.00	0.00	68.00	1	f	f	\N	2025-02-21 12:00:00	\N	68.00	LAM
3842	T12	\N	55.20	0.00	55.20	1	f	f	\N	2026-05-22 12:00:00	\N	0.00	T12
3728	\N	\N	-114.71	0.00	-114.71	1	f	t	\N	2026-04-03 12:00:00	\N	0.00	\N
2573	T9	-1248698199	143.70	0.00	143.70	6	f	f	\N	2025-02-15 12:00:00	\N	143.70	Sagot
3872	\N	\N	-114.95	0.00	-114.95	1	f	t	\N	2026-06-11 12:00:00	\N	0.00	\N
3734	\N	\N	-149.27	0.00	-149.27	1	f	t	\N	2026-04-01 12:00:00	\N	0.00	\N
3735	\N	\N	-62.89	0.00	-62.89	1	f	t	\N	2026-04-09 12:00:00	\N	0.00	\N
3878	T10	\N	86.00	0.00	86.00	3	f	f	\N	2026-06-13 12:00:00	\N	0.00	PEUTAT
3738	\N	\N	16.00	0.00	16.00	1	t	f	\N	2026-04-09 12:00:00	\N	16.00	Emporté
2576	T9	-867980635	348.50	0.00	348.50	13	f	f	\N	2025-02-16 12:00:00	\N	348.50	ARNOLD
3740	T10	\N	0.00	52.00	52.00	2	f	f	\N	2026-04-10 12:00:00	\N	0.00	T10
2585	T14	-1931747542	0.00	26.00	26.00	1	f	f	\N	2025-02-19 12:00:00	\N	0.00	DENIS
3746	T12	\N	37.50	0.00	37.50	1	f	f	\N	2026-04-11 12:00:00	\N	37.50	dewandre
2594	T9	3	0.00	267.50	267.50	4	f	f	\N	2025-02-21 12:00:00	\N	0.00	FILOU
3749	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2026-04-11 12:00:00	\N	0.00	\N
3750	\N	\N	-124.00	0.00	-124.00	1	f	t	\N	2026-04-13 12:00:00	\N	0.00	\N
2615	T13	-479672637	0.00	40.40	40.40	2	f	f	\N	2025-02-28 12:00:00	\N	0.00	MANU
2627	T5	-1198282750	131.20	0.00	131.20	4	f	f	\N	2025-03-01 12:00:00	\N	131.20	LION
2645	T14	863154534	20.80	0.00	20.80	2	f	f	\N	2025-03-12 12:00:00	\N	20.80	SAM
2658	T9	798729588	108.00	0.00	108.00	2	f	f	\N	2025-03-14 12:00:00	\N	108.00	FRANCOISE
2660	T5	1590358994	108.10	0.00	108.10	5	f	f	\N	2025-03-14 12:00:00	\N	108.10	MORATI
3758	\N	\N	-175.47	0.00	-175.47	1	f	t	\N	2026-03-23 12:00:00	\N	0.00	\N
3759	T5	\N	73.70	0.00	73.70	2	f	f	\N	2026-04-16 12:00:00	\N	73.70	Huque
3933	T5	\N	0.00	81.80	81.80	2	f	f	\N	2026-07-03 12:00:00	\N	0.00	David
2664	T9	-982451183	0.00	298.50	298.50	6	f	f	\N	2025-03-14 12:00:00	\N	0.00	BURTON
2283	T13	3	148.00	0.00	148.00	1	f	f	\N	2024-11-22 12:00:00	\N	148.00	Filou
3928	DÉPENSES	\N	-600.00	0.00	-600.00	1	f	t	\N	2026-07-02 12:00:00	\N	0.00	\N
3767	\N	\N	-4.08	0.00	-4.08	1	f	t	\N	2026-04-17 12:00:00	\N	0.00	\N
2516	\N	\N	-100.00	0.00	-100.00	1	f	t	\N	2025-02-07 12:00:00	\N	0.00	\N
2475	T8	-1931747542	78.00	0.00	78.00	2	f	f	\N	2025-01-29 12:00:00	\N	78.00	DENIS
3773	T7	\N	80.40	0.00	80.40	4	f	f	\N	2026-04-17 12:00:00	\N	80.40	T7
2522	T2	\N	0.00	18.00	18.00	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
3927	DÉPENSES	\N	-7.98	0.00	-7.98	1	f	t	\N	2026-07-02 12:00:00	\N	0.00	\N
3779	\N	\N	-105.00	0.00	-105.00	1	f	t	\N	2026-04-17 12:00:00	\N	0.00	\N
2493	T5	-1763527961	0.00	50.00	50.00	2	f	f	\N	2025-02-01 12:00:00	\N	0.00	ERIC
3785	T5	\N	0.00	7.80	7.80	1	t	f	\N	2026-04-24 12:00:00	\N	7.80	T5
3788	T6	\N	265.00	0.00	265.00	4	f	f	\N	2026-04-24 12:00:00	\N	265.00	groupe
2511	T13	232453727	39.40	0.00	39.40	2	f	f	\N	2025-02-07 12:00:00	\N	39.40	SARAH
2514	T10	-1163187653	96.00	0.00	96.00	2	f	f	\N	2025-02-07 12:00:00	\N	96.00	PIERRE
2472	T14	-1163187653	8.00	0.00	8.00	1	f	f	\N	2025-01-29 12:00:00	\N	8.00	PIERRE
3800	\N	\N	-129.00	0.00	-129.00	1	f	t	\N	2026-04-28 12:00:00	\N	0.00	\N
2481	T13	232453727	35.40	0.00	35.40	1	f	f	\N	2025-01-31 12:00:00	\N	35.40	SARAH
3806	\N	\N	-78.73	0.00	-78.73	1	f	t	\N	2026-04-15 12:00:00	\N	0.00	\N
2534	T2	\N	0.00	8.00	8.00	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
3809	T9	\N	0.00	201.60	201.60	6	f	f	\N	2026-04-30 12:00:00	\N	201.60	BOUSSUROY
2508	T5	2098037424	0.00	44.20	44.20	1	f	f	\N	2025-02-07 12:00:00	\N	0.00	DORSAN
3812	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2026-04-30 12:00:00	\N	0.00	\N
3815	\N	\N	-500.00	0.00	-500.00	1	f	t	\N	2026-04-24 12:00:00	\N	0.00	\N
3821	T12	\N	166.20	0.00	166.20	6	f	f	\N	2026-05-15 12:00:00	\N	166.20	stephanie
3827	\N	\N	-6.40	0.00	-6.40	1	f	t	\N	2026-05-21 12:00:00	\N	0.00	\N
2543	T13	\N	0.00	75.00	75.00	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	BULLES
3830	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2026-05-01 12:00:00	\N	0.00	\N
2558	\N	\N	-45.57	0.00	-45.57	1	f	t	\N	2025-02-14 12:00:00	\N	0.00	\N
2570	T7	\N	0.00	109.60	109.60	7	f	f	\N	2025-02-15 12:00:00	\N	0.00	black
2582	T12	\N	0.00	17.00	17.00	1	f	f	\N	2025-02-19 12:00:00	\N	0.00	T12
3866	T13	1588048427	0.00	32.00	32.00	1	f	f	\N	2026-06-12 12:00:00	\N	32.00	elise
3848	\N	\N	0.00	11.00	11.00	1	t	f	\N	2026-05-29 12:00:00	\N	11.00	Emporté
3761	T12	\N	87.70	0.00	87.70	1	f	f	\N	2026-04-16 12:00:00	\N	87.70	VINCENT
3851	\N	\N	-91.80	0.00	-91.80	1	f	t	\N	2026-05-29 12:00:00	\N	0.00	\N
3854	T7	\N	0.00	100.20	100.20	3	f	f	\N	2026-05-29 12:00:00	\N	100.20	elouad
3722	\N	\N	-90.00	0.00	-90.00	1	f	t	\N	2026-04-03 12:00:00	\N	0.00	\N
3725	\N	\N	-147.50	0.00	-147.50	1	f	t	\N	2026-04-01 12:00:00	\N	0.00	\N
3860	\N	\N	-28.49	0.00	-28.49	1	f	t	\N	2026-05-30 12:00:00	\N	0.00	\N
3726	\N	\N	-148.00	0.00	-148.00	1	f	t	\N	2026-03-24 12:00:00	\N	0.00	\N
3863	T15	\N	0.00	7.50	7.50	1	f	f	\N	2026-06-11 12:00:00	\N	7.50	MANU
3744	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2026-04-10 12:00:00	\N	0.00	\N
2579	\N	\N	-36.79	0.00	-36.79	1	f	t	\N	2025-02-16 12:00:00	\N	0.00	\N
3881	\N	\N	0.00	45.40	45.40	1	t	f	\N	2026-06-15 12:00:00	\N	45.40	Emporté
3890	T8	\N	0.00	22.20	22.20	1	f	f	\N	2026-06-15 12:00:00	\N	22.20	Ludo
3893	\N	\N	-28.65	0.00	-28.65	1	f	t	\N	2026-06-17 12:00:00	\N	0.00	\N
3825	\N	\N	0.00	10.00	10.00	1	t	f	\N	2026-05-21 12:00:00	\N	0.00	Emporté
3765	T11	\N	326.70	0.00	326.70	5	f	f	\N	2026-04-17 12:00:00	\N	326.70	Fabricom
2574	T12	-495515213	56.00	0.00	56.00	2	f	f	\N	2025-02-15 12:00:00	\N	56.00	QUOILIBN
3768	\N	\N	-47.21	0.00	-47.21	1	f	t	\N	2026-04-17 12:00:00	\N	0.00	\N
2598	T12	-495515213	52.00	0.00	52.00	2	f	f	\N	2025-02-21 12:00:00	\N	52.00	QUOILIN
3771	T5	\N	108.50	0.00	108.50	2	f	f	\N	2026-04-17 12:00:00	\N	108.50	piedboeuf
2616	T7	1588048427	0.00	117.60	117.60	4	f	f	\N	2025-02-28 12:00:00	\N	0.00	ELISE
2622	T13	-1683800573	115.70	0.00	115.70	4	f	f	\N	2025-02-28 12:00:00	\N	115.70	Massin
2628	T8	1530628075	0.00	67.50	67.50	2	f	f	\N	2025-03-01 12:00:00	\N	0.00	PIERRET
2646	T14	863154534	10.00	0.00	10.00	2	f	f	\N	2025-03-12 12:00:00	\N	10.00	SAM
2470	T9	-1769468414	0.00	59.20	59.20	3	f	f	\N	2025-01-29 12:00:00	\N	0.00	LAURENT
2482	\N	\N	0.00	0.00	0.00	1	t	f	\N	2025-01-31 12:00:00	\N	0.00	Emporté
3786	T8	\N	0.00	160.50	160.50	2	f	f	\N	2026-04-24 12:00:00	\N	0.00	Marc
3789	T9	\N	0.00	252.80	252.80	4	f	f	\N	2026-04-24 12:00:00	\N	0.00	Eve
3819	T8	\N	0.00	188.00	188.00	4	f	f	\N	2026-05-15 12:00:00	\N	188.00	ethienne
2473	T13	3	0.00	61.90	61.90	2	f	f	\N	2025-01-29 12:00:00	\N	0.00	FILOU
2606	\N	\N	-14.40	0.00	-14.40	1	f	t	\N	2025-02-24 12:00:00	\N	0.00	\N
2308	T12	-1769468414	0.00	64.00	64.00	2	f	f	\N	2024-11-29 12:00:00	\N	0.00	T12
3774	T2	\N	94.00	0.00	94.00	1	f	f	\N	2026-04-17 12:00:00	\N	94.00	T2
3926	DÉPENSES	\N	-34.00	0.00	-34.00	1	f	t	\N	2026-07-02 12:00:00	\N	0.00	\N
3801	\N	\N	-122.87	0.00	-122.87	1	f	t	\N	2026-04-23 12:00:00	\N	0.00	\N
3879	T8	-1607156744	0.00	75.00	75.00	3	f	f	\N	2026-06-13 12:00:00	\N	75.00	Sophie
2314	T12	190114966	0.00	61.00	61.00	2	f	f	\N	2024-11-30 12:00:00	\N	0.00	Lebrun
2332	T3	-479672637	26.50	0.00	26.50	1	f	f	\N	2024-12-06 12:00:00	\N	26.50	MANU
3810	T8	\N	64.00	0.00	64.00	2	f	f	\N	2026-04-30 12:00:00	\N	64.00	inconu
3813	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2026-04-25 12:00:00	\N	0.00	\N
2488	T12	-1611704114	73.40	0.00	73.40	2	f	f	\N	2025-01-31 12:00:00	\N	73.40	0499401320
3822	T13	\N	139.00	0.00	139.00	3	f	f	\N	2026-05-15 12:00:00	\N	139.00	morier
3828	\N	\N	-92.51	0.00	-92.51	1	f	t	\N	2026-05-21 12:00:00	\N	0.00	\N
3831	\N	\N	-329.53	0.00	-329.53	1	f	t	\N	2026-05-11 12:00:00	\N	0.00	\N
2491	T11	798729588	21.20	0.00	21.20	1	f	f	\N	2025-02-01 12:00:00	\N	21.20	FRANCOISE
2476	T6	-1931747542	21.00	0.00	21.00	1	f	f	\N	2025-01-29 12:00:00	\N	21.00	Denis
2479	T8	-1966843488	118.00	0.00	118.00	1	f	f	\N	2025-01-30 12:00:00	\N	118.00	Michael
2554	T7	548676026	0.00	47.50	47.50	1	f	f	\N	2025-02-12 12:00:00	\N	0.00	DTB
3843	T5	\N	0.00	101.10	101.10	5	f	f	\N	2026-05-22 12:00:00	\N	101.10	americain
2599	T13	-1931747542	0.00	46.50	46.50	1	f	f	\N	2025-02-21 12:00:00	\N	46.50	DENIS
2629	T7	693372496	58.50	0.00	58.50	1	f	f	\N	2025-03-01 12:00:00	\N	58.50	BOUKILY
2596	T9	-278690184	48.20	0.00	48.20	2	f	f	\N	2025-02-21 12:00:00	\N	48.20	EVE
2659	T13	3	0.00	139.00	139.00	3	f	f	\N	2025-03-14 12:00:00	\N	0.00	Filou
2683	T12	-1027211030	36.20	0.00	36.20	2	f	f	\N	2025-03-22 12:00:00	\N	36.20	BENJAMIN
3858	\N	\N	-75.00	0.00	-75.00	1	f	t	\N	2026-05-29 12:00:00	\N	0.00	\N
3861	T10	\N	0.00	52.00	52.00	2	f	f	\N	2026-05-30 12:00:00	\N	52.00	DOCTEUR
3864	T12	\N	0.00	41.20	41.20	2	f	f	\N	2026-06-11 12:00:00	\N	41.20	T12
2785	T13	-1931747542	109.00	0.00	109.00	2	f	f	\N	2025-04-19 12:00:00	\N	109.00	T13
2800	T5	155646985	64.00	0.00	64.00	2	f	f	\N	2025-04-25 12:00:00	\N	64.00	MIGNOLET
3870	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2026-06-01 12:00:00	\N	0.00	\N
2806	T7	-1931747542	0.00	51.50	51.50	2	f	f	\N	2025-04-25 12:00:00	\N	51.50	DENIS
3069	T9	-1686520547	48.50	0.00	48.50	2	f	f	\N	2025-09-13 12:00:00	\N	48.50	CAUFFMAN
3072	T14	644045150	30.00	0.00	30.00	1	f	f	\N	2025-09-13 12:00:00	\N	30.00	RUDY
2848	T12	-560080272	323.60	0.00	323.60	9	f	f	\N	2025-05-09 12:00:00	\N	323.60	La bande à Alex
3882	\N	\N	0.00	19.70	19.70	1	t	f	\N	2026-06-15 12:00:00	\N	19.70	Emporté
3075	T14	644045150	0.00	24.00	24.00	1	f	f	\N	2025-09-13 12:00:00	\N	0.00	RUDY
3891	T7	\N	0.00	18.00	18.00	1	f	f	\N	2026-06-15 12:00:00	\N	18.00	Steph
3894	\N	\N	-84.03	0.00	-84.03	1	f	t	\N	2026-06-15 12:00:00	\N	0.00	\N
3798	T9	\N	0.00	81.50	81.50	1	f	f	\N	2026-04-25 12:00:00	\N	0.00	barcq
2499	\N	\N	-87.50	0.00	-87.50	1	f	t	\N	2025-01-10 12:00:00	\N	0.00	\N
2502	\N	\N	-28.41	0.00	-28.41	1	f	t	\N	2025-02-05 12:00:00	\N	0.00	\N
2506	\N	\N	0.00	4.00	4.00	1	t	f	\N	2025-02-07 12:00:00	\N	0.00	Emporté
2520	T2	\N	0.00	6.00	6.00	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
2526	T2	\N	0.00	24.00	24.00	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
2854	T12	-1763527961	0.00	209.00	209.00	4	f	f	\N	2025-05-09 12:00:00	\N	0.00	Lebrun
2860	T7	3	0.00	129.50	129.50	3	f	f	\N	2025-05-16 12:00:00	\N	0.00	FILOU
3084	T13	-479672637	0.00	8.50	8.50	1	f	f	\N	2025-09-19 12:00:00	\N	0.00	MANU
2529	T2	\N	0.00	2.20	2.20	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
2538	T2	\N	0.00	4.00	4.00	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
2544	T2	\N	0.00	73.40	73.40	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
2550	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2025-02-08 12:00:00	\N	0.00	\N
2559	\N	\N	-170.00	0.00	-170.00	1	f	t	\N	2025-02-14 12:00:00	\N	0.00	\N
2565	T10	\N	103.00	0.00	103.00	2	f	f	\N	2025-02-14 12:00:00	\N	103.00	T10
2568	\N	\N	-49.61	0.00	-49.61	1	f	t	\N	2025-02-15 12:00:00	\N	0.00	\N
2571	T5	\N	0.00	75.00	75.00	2	f	f	\N	2025-02-15 12:00:00	\N	0.00	bibou
2610	\N	\N	-206.00	0.00	-206.00	1	f	t	\N	2025-02-26 12:00:00	\N	0.00	\N
2613	\N	\N	-56.86	0.00	-56.86	1	f	t	\N	2025-02-27 12:00:00	\N	0.00	\N
2515	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2025-02-07 12:00:00	\N	0.00	\N
2518	T2	\N	0.00	4.00	4.00	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
2521	T2	\N	0.00	8.80	8.80	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
3855	T9	\N	0.00	107.50	107.50	5	f	f	\N	2026-05-29 12:00:00	\N	107.50	melun
3096	T5	687226325	0.00	66.50	66.50	2	t	f	\N	2025-09-21 12:00:00	\N	0.00	1: Loic et fred
2797	T14	644045150	0.00	21.00	21.00	1	f	f	\N	2025-04-25 12:00:00	\N	21.00	RUDY
2902	T7	-530889051	62.00	0.00	62.00	4	f	f	\N	2025-05-31 12:00:00	\N	62.00	HOUARD
3099	T6	1779896331	0.00	69.50	69.50	1	f	f	\N	2025-09-21 12:00:00	\N	0.00	2: Jeanmi et pablo
2815	T9	-1632933197	0.00	34.00	34.00	1	f	f	\N	2025-05-02 12:00:00	\N	0.00	SABINE
3117	T7	3	0.00	122.00	122.00	3	f	f	\N	2025-09-26 12:00:00	\N	0.00	FILOU
2863	T7	3	0.00	28.50	28.50	1	f	f	\N	2025-05-16 12:00:00	\N	0.00	FILOU
2875	T14	-479672637	0.00	25.00	25.00	1	f	f	\N	2025-05-21 12:00:00	\N	0.00	Manu
2893	T13	644045150	0.00	15.00	15.00	1	f	f	\N	2025-05-30 12:00:00	\N	0.00	RUDY
2896	T6	644045150	0.00	11.00	11.00	1	f	f	\N	2025-05-30 12:00:00	\N	0.00	rudy
2890	T13	1588048427	41.80	0.00	41.80	1	f	f	\N	2025-05-28 12:00:00	\N	41.80	ELISE
3144	T5	-1375258664	0.00	67.00	67.00	1	f	f	\N	2025-10-03 12:00:00	\N	67.00	DARDENNE
3037	T13	644045150	0.00	5.00	5.00	1	f	f	\N	2025-08-30 12:00:00	\N	5.00	RUDY
3038	T5	1105205458	0.00	64.00	64.00	2	t	f	\N	2025-08-30 12:00:00	\N	64.00	STEPHANE
2781	T5	232453727	0.00	210.90	210.90	5	f	f	\N	2025-04-19 12:00:00	\N	210.90	T5
3040	T14	-1931747542	0.00	89.00	89.00	1	f	f	\N	2025-08-30 12:00:00	\N	0.00	DENIS
2786	T10	1899778452	0.00	64.90	64.90	4	f	f	\N	2025-04-19 12:00:00	\N	0.00	LEGROS
3041	T11	798729588	59.00	0.00	59.00	2	f	f	\N	2025-09-03 12:00:00	\N	59.00	FRANCOISE
2789	T12	1588048427	0.00	36.40	36.40	2	f	f	\N	2025-04-23 12:00:00	\N	36.40	ELISE
2795	T9	-1632933197	0.00	107.00	107.00	2	f	f	\N	2025-04-25 12:00:00	\N	0.00	SABINE
2801	T12	-1248698199	0.00	61.00	61.00	3	f	f	\N	2025-04-25 12:00:00	\N	61.00	sagot
2810	T12	-1319489455	0.00	48.50	48.50	2	f	f	\N	2025-04-30 12:00:00	\N	48.50	THIERRY
2819	T13	-479672637	0.00	20.00	20.00	1	f	f	\N	2025-05-02 12:00:00	\N	0.00	MANU
3053	T8	-1632933197	0.00	23.00	23.00	1	t	f	\N	2025-09-05 12:00:00	\N	0.00	sabine
2834	T12	225199455	96.40	0.00	96.40	3	f	f	\N	2025-05-03 12:00:00	\N	96.40	BRIOL
3059	T12	1831621911	0.00	42.20	42.20	2	f	f	\N	2025-09-10 12:00:00	\N	0.00	LOPEZ
3062	T12	-560080272	55.60	0.00	55.60	3	f	f	\N	2025-09-12 12:00:00	\N	55.60	OUVRIERS
2852	T5	1588048427	0.00	84.60	84.60	3	f	f	\N	2025-05-09 12:00:00	\N	84.60	Elise
3064	T8	402497292	69.40	0.00	69.40	3	f	f	\N	2025-09-12 12:00:00	\N	69.40	SCHOOTERBEN
3065	T10	-867980635	61.00	0.00	61.00	2	f	f	\N	2025-09-12 12:00:00	\N	61.00	ARNOLD
2861	T13	-479672637	0.00	16.00	16.00	1	f	f	\N	2025-05-16 12:00:00	\N	16.00	MANU
2876	T10	863154534	32.00	0.00	32.00	2	f	f	\N	2025-05-21 12:00:00	\N	32.00	SAM
3071	T12	1900657782	68.40	0.00	68.40	2	f	f	\N	2025-09-13 12:00:00	\N	68.40	PIROTTE
2882	T10	-1632933197	0.00	50.00	50.00	1	f	f	\N	2025-05-23 12:00:00	\N	50.00	Sabine
3073	T8	713968666	85.50	0.00	85.50	2	f	f	\N	2025-09-13 12:00:00	\N	85.50	RODRIGUEZ
2897	T9	1936806253	103.20	0.00	103.20	3	f	f	\N	2025-05-30 12:00:00	\N	103.20	EVE
2772	T12	-867980635	0.00	54.80	54.80	1	f	f	\N	2025-04-18 12:00:00	\N	54.80	ARNOLD
2903	T6	-867980635	104.60	0.00	104.60	4	f	f	\N	2025-05-31 12:00:00	\N	104.60	ARNOLD
3083	T13	-479672637	0.00	14.00	14.00	1	f	f	\N	2025-09-19 12:00:00	\N	0.00	MANU
2777	T9	1671272237	74.00	0.00	74.00	1	f	f	\N	2025-04-18 12:00:00	\N	74.00	FANETTE
3089	T12	-1931747542	0.00	21.70	21.70	1	f	f	\N	2025-09-20 12:00:00	\N	0.00	DENIS
3049	T10	232453727	33.40	0.00	33.40	1	f	f	\N	2025-09-05 12:00:00	\N	33.40	SARAH
2837	T10	-1632933197	0.00	43.00	43.00	1	f	f	\N	2025-05-07 12:00:00	\N	0.00	Sabine
2864	T14	644045150	0.00	21.00	21.00	1	f	f	\N	2025-05-16 12:00:00	\N	21.00	RUDY
2879	T13	-1931747542	0.00	17.00	17.00	1	f	f	\N	2025-05-23 12:00:00	\N	0.00	DENIS
2787	T12	1105205458	0.00	350.40	350.40	1	f	f	\N	2025-04-19 12:00:00	\N	0.00	STEPHANE
2802	T13	-47553642	51.70	0.00	51.70	2	f	f	\N	2025-04-25 12:00:00	\N	51.70	LECLUSE
2805	T8	644045150	0.00	36.50	36.50	2	f	f	\N	2025-04-25 12:00:00	\N	0.00	RUDY
2814	T8	3	0.00	154.00	154.00	4	f	f	\N	2025-04-30 12:00:00	\N	0.00	FILOU
2796	T13	1588048427	0.00	19.40	19.40	1	f	f	\N	2025-04-25 12:00:00	\N	19.40	ELISE
2832	T5	1936806253	73.00	0.00	73.00	3	f	f	\N	2025-05-03 12:00:00	\N	73.00	PASLEAU
2841	T13	1588048427	0.00	0.00	0.00	1	f	f	\N	2025-05-07 12:00:00	\N	0.00	ELISE
2838	T11	-560080272	0.00	21.70	21.70	1	f	f	\N	2025-05-07 12:00:00	\N	0.00	Ouvrier
3133	T5	\N	0.00	50.20	50.20	2	f	f	\N	2025-09-27 12:00:00	\N	0.00	Delvaux
3196	T9	\N	0.00	84.60	84.60	3	f	f	\N	2025-10-24 12:00:00	\N	0.00	T9
2977	T7	\N	0.00	40.50	40.50	2	t	f	\N	2025-07-25 12:00:00	\N	40.50	2 mr
3247	T5	\N	0.00	99.00	99.00	3	f	f	\N	2025-11-01 12:00:00	\N	0.00	ANNE
3261	T5	\N	0.00	68.00	68.00	2	f	f	\N	2025-11-07 12:00:00	\N	0.00	ALEXANDRE
3170	\N	\N	-147.00	0.00	-147.00	1	f	t	\N	2025-10-06 12:00:00	\N	0.00	\N
3242	T12	\N	27.40	0.00	27.40	4	f	f	\N	2025-10-31 12:00:00	\N	27.40	T12
3260	T12	\N	46.00	0.00	46.00	2	f	f	\N	2025-11-07 12:00:00	\N	46.00	Depas
3262	T9	\N	88.00	0.00	88.00	2	f	f	\N	2025-11-07 12:00:00	\N	88.00	JOSQUIN
3364	T11	\N	66.50	0.00	66.50	2	f	f	\N	2025-12-05 12:00:00	\N	66.50	SOPHIE
3409	T11	\N	0.00	56.00	56.00	1	f	f	\N	2025-12-19 12:00:00	\N	0.00	T11
3401	T9	\N	0.00	37.60	37.60	2	f	f	\N	2025-12-14 12:00:00	\N	37.60	NIC
3116	T10	\N	40.20	0.00	40.20	1	f	f	\N	2025-09-26 12:00:00	\N	40.20	NANAS
3241	T9	\N	0.00	25.00	25.00	1	f	f	\N	2025-10-31 12:00:00	\N	0.00	T9
3403	T12	\N	0.00	23.50	23.50	1	f	f	\N	2025-12-14 12:00:00	\N	0.00	ERIC
3506	T13	\N	98.50	0.00	98.50	1	f	f	\N	2026-01-31 12:00:00	\N	98.50	LESCRENIER
2859	T14	644045150	0.00	38.00	38.00	1	f	f	\N	2025-05-16 12:00:00	\N	0.00	RUDY
2889	T14	-479672637	14.00	0.00	14.00	1	f	f	\N	2025-05-28 12:00:00	\N	14.00	MANU
2862	T9	-1632933197	0.00	104.20	104.20	2	f	f	\N	2025-05-16 12:00:00	\N	104.20	SABINE
2923	T9	-1763527961	58.00	0.00	58.00	1	f	f	\N	2025-06-06 12:00:00	\N	58.00	MAURINE
2932	T9	-1632933197	0.00	11.00	11.00	1	f	f	\N	2025-06-07 12:00:00	\N	0.00	Sabine
2945	T5	804734236	0.00	73.00	73.00	1	f	f	\N	2025-06-14 12:00:00	\N	73.00	FLAS
2947	T8	1461066836	0.00	57.50	57.50	1	f	f	\N	2025-06-14 12:00:00	\N	57.50	Lam
2883	T12	1595640756	54.00	0.00	54.00	2	f	f	\N	2025-05-23 12:00:00	\N	54.00	Adam
2901	T8	-1931747542	0.00	121.00	121.00	3	f	f	\N	2025-05-30 12:00:00	\N	121.00	Denis
2906	T9	-1931747542	0.00	133.90	133.90	8	f	f	\N	2025-05-31 12:00:00	\N	0.00	DENIS
2916	T14	-1931747542	0.00	20.00	20.00	3	f	f	\N	2025-06-06 12:00:00	\N	0.00	Denis
2917	T5	-1581012734	0.00	38.00	38.00	2	f	f	\N	2025-06-06 12:00:00	\N	0.00	Califice
2919	T13	-479672637	0.00	6.00	6.00	1	f	f	\N	2025-06-06 12:00:00	\N	0.00	Manu
2922	T5	-272858789	193.60	0.00	193.60	6	f	f	\N	2025-06-06 12:00:00	\N	193.60	Bossuroy
2924	T8	2098037424	57.20	0.00	57.20	2	f	f	\N	2025-06-06 12:00:00	\N	57.20	Dorsan
2925	T11	1588048427	269.00	0.00	269.00	5	f	f	\N	2025-06-06 12:00:00	\N	269.00	Elise
2927	T14	-1931747542	68.20	0.00	68.20	1	f	f	\N	2025-06-06 12:00:00	\N	68.20	Denis
2931	T9	-1632933197	0.00	105.50	105.50	2	f	f	\N	2025-06-07 12:00:00	\N	0.00	Sabine
2935	T9	631314543	0.00	51.20	51.20	2	f	f	\N	2025-06-11 12:00:00	\N	51.20	T9
2940	T5	1343913728	0.00	98.50	98.50	3	f	f	\N	2025-06-13 12:00:00	\N	98.50	MARQUET
2942	T14	-479672637	32.20	0.00	32.20	1	f	f	\N	2025-06-13 12:00:00	\N	32.20	MANU
3104	T13	-1931747542	0.00	18.00	18.00	2	t	f	\N	2025-09-21 12:00:00	\N	18.00	DENIS
2967	T13	-479672637	0.00	5.00	5.00	1	f	f	\N	2025-06-27 12:00:00	\N	5.00	MANU
3106	T5	-12121761	11.50	0.00	11.50	1	f	f	\N	2025-09-21 12:00:00	\N	11.50	MARIE
2973	T9	1588048427	0.00	0.00	0.00	2	f	f	\N	2025-06-28 12:00:00	\N	0.00	Elise
2994	T6	3	0.00	240.20	240.20	4	f	f	\N	2025-08-22 12:00:00	\N	0.00	T6
3000	T6	190114966	0.00	170.00	170.00	4	f	f	\N	2025-08-22 12:00:00	\N	0.00	Irene
3021	T8	1393851931	0.00	40.60	40.60	2	t	f	\N	2025-08-29 12:00:00	\N	40.60	CHRISTOPHE
3124	T14	-479672637	17.50	0.00	17.50	1	f	f	\N	2025-09-26 12:00:00	\N	0.00	MANU
3027	T12	-1248698199	223.30	0.00	223.30	9	f	f	\N	2025-08-29 12:00:00	\N	223.30	Sagot
3136	T13	-1931747542	0.00	16.50	16.50	1	f	f	\N	2025-10-02 12:00:00	\N	0.00	DENIS
2955	T7	3	0.00	206.00	206.00	3	f	f	\N	2025-06-20 12:00:00	\N	0.00	FILOU
3148	T12	-781131527	129.50	0.00	129.50	3	f	f	\N	2025-10-03 12:00:00	\N	129.50	beguin
3584	\N	\N	90.00	0.00	90.00	6	t	f	\N	2026-02-27 12:00:00	\N	90.00	Emporté
3611	T2	\N	0.00	66.00	66.00	3	f	f	\N	2026-03-06 12:00:00	\N	0.00	alex
3484	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2026-01-23 12:00:00	\N	0.00	\N
3507	T5	\N	165.20	0.00	165.20	5	f	f	\N	2026-01-31 12:00:00	\N	165.20	DENIS
3508	T13	\N	28.00	0.00	28.00	2	f	f	\N	2026-01-31 12:00:00	\N	28.00	LESCRENIER
3552	T12	\N	0.00	43.40	43.40	2	f	f	\N	2026-02-14 12:00:00	\N	0.00	schmetz
3558	T5	\N	0.00	213.40	213.40	5	f	f	\N	2026-02-20 12:00:00	\N	0.00	Filou
3582	T9	\N	242.10	0.00	242.10	9	f	f	\N	2026-02-27 12:00:00	\N	242.10	ZICOT
3594	T12	\N	463.10	0.00	463.10	15	f	f	\N	2026-02-28 12:00:00	\N	463.10	arnold
3600	\N	\N	-105.00	0.00	-105.00	1	f	t	\N	2026-02-26 12:00:00	\N	0.00	\N
3612	T8	\N	0.00	9.00	9.00	1	f	f	\N	2026-03-06 12:00:00	\N	0.00	Manu voisin
3562	T9	\N	92.00	0.00	92.00	2	f	f	\N	2026-02-20 12:00:00	\N	92.00	piedboeuf
3583	\N	\N	0.00	21.70	21.70	1	t	f	\N	2026-02-27 12:00:00	\N	0.00	Emporté
3695	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2026-03-26 12:00:00	\N	0.00	\N
2440	\N	\N	0.00	17.00	17.00	1	t	f	\N	2025-01-17 12:00:00	\N	0.00	Emporté
2451	\N	\N	-10.75	0.00	-10.75	1	f	t	\N	2025-01-22 12:00:00	\N	0.00	\N
2452	\N	\N	-30.63	0.00	-30.63	1	f	t	\N	2025-01-22 12:00:00	\N	0.00	\N
2603	\N	\N	-24.00	0.00	-24.00	1	f	t	\N	2025-02-22 12:00:00	\N	0.00	\N
2612	\N	\N	-77.32	0.00	-77.32	1	f	t	\N	2025-02-27 12:00:00	\N	0.00	\N
2630	\N	\N	-30.00	0.00	-30.00	1	f	t	\N	2025-03-01 12:00:00	\N	0.00	\N
2633	\N	\N	-106.06	0.00	-106.06	1	f	t	\N	2025-02-09 12:00:00	\N	0.00	\N
2636	\N	\N	-14.40	0.00	-14.40	1	f	t	\N	2025-03-07 12:00:00	\N	0.00	\N
2639	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2025-03-09 12:00:00	\N	0.00	\N
2651	\N	\N	-46.74	0.00	-46.74	1	f	t	\N	2025-03-13 12:00:00	\N	0.00	\N
2654	\N	\N	-69.83	0.00	-69.83	1	f	t	\N	2025-03-13 12:00:00	\N	0.00	\N
2657	\N	\N	0.00	2.00	2.00	1	t	f	\N	2025-03-14 12:00:00	\N	2.00	Emporté
2663	\N	\N	-21.62	0.00	-21.62	1	f	t	\N	2025-03-14 12:00:00	\N	0.00	\N
2690	\N	\N	-87.50	0.00	-87.50	1	f	t	\N	2025-03-14 12:00:00	\N	0.00	\N
2693	T13	\N	0.00	35.20	35.20	1	f	f	\N	2025-03-26 12:00:00	\N	0.00	DENIS
2696	\N	\N	-80.94	0.00	-80.94	1	f	t	\N	2025-03-27 12:00:00	\N	0.00	\N
2702	\N	\N	-199.83	0.00	-199.83	1	f	t	\N	2025-03-24 12:00:00	\N	0.00	\N
2703	\N	\N	-30.60	0.00	-30.60	1	f	t	\N	2025-03-17 12:00:00	\N	0.00	\N
2704	\N	\N	-28.00	0.00	-28.00	1	f	t	\N	2025-03-17 12:00:00	\N	0.00	\N
2705	\N	\N	-311.55	0.00	-311.55	1	f	t	\N	2025-03-05 12:00:00	\N	0.00	\N
2715	T8	\N	0.00	16.00	16.00	1	f	f	\N	2025-03-28 12:00:00	\N	0.00	XAVIER
2716	\N	\N	0.00	68.00	68.00	1	t	f	\N	2025-03-28 12:00:00	\N	68.00	Emporté
2723	\N	\N	-40.73	0.00	-40.73	1	f	t	\N	2025-03-29 12:00:00	\N	0.00	\N
3563	T5	\N	0.00	97.00	97.00	1	f	f	\N	2026-02-20 12:00:00	\N	0.00	nicolas
3504	T2	\N	0.00	50.70	50.70	1	f	f	\N	2026-01-31 12:00:00	\N	0.00	VAM
3510	T2	\N	0.00	25.00	25.00	1	f	f	\N	2026-01-31 12:00:00	\N	0.00	VAM
3520	T10	\N	76.00	0.00	76.00	1	f	f	\N	2026-02-05 12:00:00	\N	76.00	fanette
3680	\N	\N	0.00	29.00	29.00	1	t	f	\N	2026-03-21 12:00:00	\N	29.00	Emporté
3820	T9	\N	0.00	44.00	44.00	1	f	f	\N	2026-05-15 12:00:00	\N	44.00	eve
2453	\N	\N	-127.81	0.00	-127.81	1	f	t	\N	2025-01-22 12:00:00	\N	0.00	\N
2454	\N	\N	-326.70	0.00	-326.70	1	f	t	\N	2025-01-09 12:00:00	\N	0.00	\N
2455	\N	\N	-7.71	0.00	-7.71	1	f	t	\N	2025-01-22 12:00:00	\N	0.00	\N
2483	\N	\N	-8.00	0.00	-8.00	1	f	t	\N	2025-01-31 12:00:00	\N	0.00	\N
2504	\N	\N	-11.46	0.00	-11.46	1	f	t	\N	2025-02-06 12:00:00	\N	0.00	\N
2675	\N	\N	0.00	68.00	68.00	1	t	f	\N	2025-03-21 12:00:00	\N	0.00	Emporté
2961	T9	-1632933197	0.00	107.00	107.00	1	f	f	\N	2025-06-21 12:00:00	\N	107.00	sabine
2976	T13	1588048427	0.00	23.40	23.40	1	t	f	\N	2025-07-25 12:00:00	\N	23.40	ELISE
3163	T12	-1850234108	0.00	79.00	79.00	2	f	f	\N	2025-10-10 12:00:00	\N	0.00	JC
3101	T15	686373030	48.00	0.00	48.00	1	f	f	\N	2025-09-21 12:00:00	\N	48.00	Annick
3118	T2	644045150	0.00	64.20	64.20	1	f	f	\N	2025-09-21 12:00:00	\N	0.00	Rudy
3121	T13	-1931747542	0.00	17.50	17.50	1	f	f	\N	2025-09-26 12:00:00	\N	0.00	DENIS
3199	T9	-2003413660	58.20	0.00	58.20	2	f	f	\N	2025-10-24 12:00:00	\N	58.20	MASSOTTE
3157	T5	-1931747542	0.00	111.50	111.50	1	f	f	\N	2025-10-04 12:00:00	\N	0.00	DENIS
3208	T15	2098037424	0.00	16.00	16.00	1	f	f	\N	2025-10-30 12:00:00	\N	0.00	DORSAN
3211	T5	-1222882766	0.00	18.00	18.00	2	f	f	\N	2025-10-30 12:00:00	\N	0.00	ARTHUR
2951	T14	-479672637	59.50	0.00	59.50	3	f	f	\N	2025-06-18 12:00:00	\N	59.50	MANU
2959	T9	-612734926	130.20	0.00	130.20	5	f	f	\N	2025-06-20 12:00:00	\N	130.20	PITOU
2965	T6	-1635161824	62.00	0.00	62.00	2	f	f	\N	2025-06-27 12:00:00	\N	62.00	ROISEUX
2971	T10	-1632933197	0.00	98.50	98.50	2	f	f	\N	2025-06-27 12:00:00	\N	0.00	SABINE
3198	T12	-296848433	81.20	0.00	81.20	2	f	f	\N	2025-10-24 12:00:00	\N	81.20	MILAZZO
2975	T5	3	0.00	228.00	228.00	4	f	f	\N	2025-07-25 12:00:00	\N	0.00	FILOU
2981	T9	-1632933197	0.00	21.00	21.00	1	f	f	\N	2025-07-26 12:00:00	\N	21.00	T9
2987	T14	-1931747542	0.00	36.00	36.00	1	f	f	\N	2025-07-26 12:00:00	\N	0.00	Denis
3210	T5	-1222882766	0.00	75.00	75.00	2	f	f	\N	2025-10-30 12:00:00	\N	0.00	ARTHUR
2998	T13	1936806253	0.00	110.00	110.00	3	f	f	\N	2025-08-22 12:00:00	\N	110.00	Eve
3007	T13	-1931747542	0.00	32.00	32.00	1	f	f	\N	2025-08-23 12:00:00	\N	0.00	DENIS
3013	T9	-1632933197	0.00	32.00	32.00	1	f	f	\N	2025-08-27 12:00:00	\N	32.00	SABINE
3019	T13	-1931747542	0.00	15.00	15.00	1	f	f	\N	2025-08-27 12:00:00	\N	0.00	DENIIS
3022	T13	-1931747542	0.00	8.00	8.00	1	f	f	\N	2025-08-29 12:00:00	\N	8.00	DENIS
3025	T9	-1632933197	0.00	96.00	96.00	2	f	f	\N	2025-08-29 12:00:00	\N	0.00	Sabine
3028	T6	190114966	0.00	159.50	159.50	4	f	f	\N	2025-08-29 12:00:00	\N	0.00	Irene
3246	T11	-2129673309	0.00	40.20	40.20	2	f	f	\N	2025-11-01 12:00:00	\N	0.00	FOERSTER
3249	T12	-1763527961	66.00	0.00	66.00	2	f	f	\N	2025-11-06 12:00:00	\N	66.00	eric
2978	T9	-1632933197	0.00	27.50	27.50	1	f	f	\N	2025-07-25 12:00:00	\N	27.50	sabine
2980	T12	-1931747542	0.00	24.00	24.00	1	f	f	\N	2025-07-25 12:00:00	\N	0.00	DENIS
2983	T13	3	0.00	30.20	30.20	1	f	f	\N	2025-07-26 12:00:00	\N	0.00	Filou
3252	T5	-294468688	89.00	0.00	89.00	1	f	f	\N	2025-11-06 12:00:00	\N	89.00	rossion
3296	T15	-479672637	8.00	0.00	8.00	1	f	f	\N	2025-11-14 12:00:00	\N	8.00	MANU
2990	T10	-1632933197	0.00	31.50	31.50	1	f	f	\N	2025-08-20 12:00:00	\N	0.00	SABINE
3164	T13	1588048427	0.00	0.00	0.00	1	f	f	\N	2025-10-10 12:00:00	\N	0.00	ELISE
3008	T10	-1632933197	105.00	0.00	105.00	2	f	f	\N	2025-08-23 12:00:00	\N	105.00	SABINE
3017	T14	-479672637	12.70	0.00	12.70	1	f	f	\N	2025-08-27 12:00:00	\N	12.70	MANU
3174	T9	-1632933197	97.20	0.00	97.20	2	f	f	\N	2025-10-16 12:00:00	\N	97.20	sabine
3026	T13	-1931747542	0.00	28.00	28.00	1	f	f	\N	2025-08-29 12:00:00	\N	28.00	DENIS
3176	T8	1588048427	0.00	0.00	0.00	1	f	f	\N	2025-10-16 12:00:00	\N	0.00	elise
3177	T13	1105205458	0.00	10.00	10.00	2	f	f	\N	2025-10-17 12:00:00	\N	0.00	STEPH
3180	T9	-1551998939	0.00	76.20	76.20	3	f	f	\N	2025-10-17 12:00:00	\N	0.00	DIDIER
3182	T8	-1198282750	57.00	0.00	57.00	2	f	f	\N	2025-10-17 12:00:00	\N	57.00	LION
3183	T13	-479672637	12.00	0.00	12.00	1	f	f	\N	2025-10-18 12:00:00	\N	12.00	MANU
3185	T7	190114966	0.00	214.50	214.50	6	f	f	\N	2025-10-18 12:00:00	\N	0.00	Occupé
3197	T13	-479672637	14.00	0.00	14.00	1	f	f	\N	2025-10-24 12:00:00	\N	14.00	MANU
3206	T12	2015681173	0.00	71.70	71.70	2	f	f	\N	2025-10-25 12:00:00	\N	0.00	Vam Michel
3167	T13	1547125190	80.20	0.00	80.20	3	f	f	\N	2025-10-10 12:00:00	\N	80.20	TILMANN
2726	\N	\N	0.00	350.00	350.00	1	t	f	\N	2025-03-29 12:00:00	\N	0.00	Emporté
2730	\N	\N	-99.69	0.00	-99.69	1	f	t	\N	2025-03-12 12:00:00	\N	0.00	\N
2735	\N	\N	-168.61	0.00	-168.61	1	f	t	\N	2025-04-02 12:00:00	\N	0.00	\N
2736	\N	\N	-90.30	0.00	-90.30	1	f	t	\N	2025-04-03 12:00:00	\N	0.00	\N
2738	\N	\N	0.00	7.00	7.00	1	t	f	\N	2025-04-03 12:00:00	\N	0.00	Emporté
2740	\N	\N	-64.00	0.00	-64.00	1	f	t	\N	2025-04-04 12:00:00	\N	0.00	\N
2747	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2025-04-04 12:00:00	\N	0.00	\N
2748	\N	\N	0.00	11.00	11.00	1	t	f	\N	2025-04-04 12:00:00	\N	0.00	Emporté
2753	\N	\N	0.00	28.00	28.00	1	t	f	\N	2025-04-11 12:00:00	\N	28.00	Emporté
2754	T10	\N	0.00	83.50	83.50	1	f	f	\N	2025-04-11 12:00:00	\N	0.00	Occupé
2769	\N	\N	-101.36	0.00	-101.36	1	f	t	\N	2025-04-15 12:00:00	\N	0.00	\N
2899	T6	\N	0.00	77.70	77.70	1	f	f	\N	2025-05-30 12:00:00	\N	0.00	rudy
2905	T2	\N	0.00	20.00	20.00	1	f	f	\N	2025-05-31 12:00:00	\N	0.00	mme Rosé
2910	\N	\N	-40.35	0.00	-40.35	1	f	t	\N	2025-05-12 12:00:00	\N	0.00	\N
2920	\N	\N	-69.24	0.00	-69.24	1	f	t	\N	2025-06-06 12:00:00	\N	0.00	\N
2926	\N	\N	-12.00	0.00	-12.00	1	f	t	\N	2025-06-06 12:00:00	\N	0.00	\N
2934	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2025-06-07 12:00:00	\N	0.00	\N
2936	\N	\N	22.00	0.00	22.00	1	t	f	\N	2025-06-13 12:00:00	\N	22.00	Emporté
2937	\N	\N	0.00	17.00	17.00	1	t	f	\N	2025-06-13 12:00:00	\N	0.00	Emporté
2938	\N	\N	0.00	17.00	17.00	1	t	f	\N	2025-06-13 12:00:00	\N	17.00	Emporté
2949	\N	\N	-47.00	0.00	-47.00	1	f	t	\N	2025-06-18 12:00:00	\N	0.00	\N
3042	\N	\N	0.00	7.50	7.50	1	t	f	\N	2025-09-03 12:00:00	\N	0.00	Emporté
3044	\N	\N	-42.96	0.00	-42.96	1	f	t	\N	2025-09-04 12:00:00	\N	0.00	\N
3057	\N	\N	-63.42	0.00	-63.42	1	f	t	\N	2025-09-04 12:00:00	\N	0.00	\N
3081	\N	\N	-224.00	0.00	-224.00	1	f	t	\N	2025-09-19 12:00:00	\N	0.00	\N
3087	\N	\N	-52.67	0.00	-52.67	1	f	t	\N	2025-09-20 12:00:00	\N	0.00	\N
3093	T8	\N	0.00	69.90	69.90	1	f	f	\N	2025-09-21 12:00:00	\N	69.90	8: Denis et eric
3102	T6	\N	23.00	0.00	23.00	1	f	f	\N	2025-09-21 12:00:00	\N	23.00	Sylvain
3114	T7	\N	8.00	0.00	8.00	1	f	f	\N	2025-09-21 12:00:00	\N	8.00	Isa
3120	\N	\N	-240.00	0.00	-240.00	1	f	t	\N	2025-09-26 12:00:00	\N	0.00	\N
3251	T9	-732188617	147.20	0.00	147.20	6	f	f	\N	2025-11-06 12:00:00	\N	147.20	OLIVIER
3248	T14	-479672637	0.00	16.00	16.00	1	f	f	\N	2025-11-06 12:00:00	\N	0.00	MANU
3292	T13	-1931747542	0.00	10.50	10.50	1	f	f	\N	2025-11-14 12:00:00	\N	0.00	DENIS
3269	T13	3	0.00	132.00	132.00	2	f	f	\N	2025-11-08 12:00:00	\N	0.00	FILOU
3287	T5	-1763527961	0.00	73.50	73.50	3	f	f	\N	2025-11-13 12:00:00	\N	0.00	ERIC
3295	T15	-479672637	0.00	8.00	8.00	1	f	f	\N	2025-11-14 12:00:00	\N	0.00	MANU
3297	T12	-867980635	0.00	73.80	73.80	4	f	f	\N	2025-11-14 12:00:00	\N	73.80	ARNOLD
3306	\N	-1632933197	12.00	0.00	12.00	2	t	f	\N	2025-11-20 12:00:00	\N	12.00	Emporté
3321	T13	1423511228	66.00	0.00	66.00	3	f	f	\N	2025-11-22 12:00:00	\N	66.00	GASON
3357	T9	-1632933197	0.00	75.00	75.00	2	f	f	\N	2025-12-04 12:00:00	\N	0.00	SABINE
3330	T15	-479672637	8.00	0.00	8.00	1	f	f	\N	2025-11-28 12:00:00	\N	8.00	MANU
2794	T12	1936806253	43.20	0.00	43.20	1	f	f	\N	2025-04-25 12:00:00	\N	43.20	Célia
3405	T12	-1763527961	0.00	33.00	33.00	1	f	f	\N	2025-12-14 12:00:00	\N	0.00	ERIC
2584	T7	1588048427	0.00	11.40	11.40	1	f	f	\N	2025-02-19 12:00:00	\N	0.00	ELISE
2620	T7	-984714471	72.50	0.00	72.50	2	f	f	\N	2025-02-28 12:00:00	\N	72.50	THONON
2623	T9	-1763527961	0.00	326.70	326.70	8	f	f	\N	2025-02-28 12:00:00	\N	161.00	MAURINE
2626	T11	-1763527961	0.00	161.30	161.30	4	f	f	\N	2025-03-01 12:00:00	\N	0.00	ERIC & IRENE
3298	T6	428145220	133.00	0.00	133.00	4	f	f	\N	2025-11-14 12:00:00	\N	133.00	PHILIPPE ALLO
3299	T7	1139066072	0.00	113.50	113.50	2	f	f	\N	2025-11-14 12:00:00	\N	0.00	DAVID
3308	T14	1588048427	0.00	46.00	46.00	2	f	f	\N	2025-11-21 12:00:00	\N	46.00	ELISE
3311	T13	3	0.00	214.10	214.10	4	f	f	\N	2025-11-21 12:00:00	\N	0.00	FILOU
3313	T15	-479672637	0.00	42.00	42.00	1	f	f	\N	2025-11-21 12:00:00	\N	42.00	Manu
3317	T15	-1763527961	0.00	20.00	20.00	1	f	f	\N	2025-11-22 12:00:00	\N	0.00	ERIC
3319	T5	1090130270	119.40	0.00	119.40	4	f	f	\N	2025-11-22 12:00:00	\N	119.40	WOS
3320	T8	420446599	0.00	98.00	98.00	2	f	f	\N	2025-11-22 12:00:00	\N	0.00	marc
3322	T9	-261849331	219.00	0.00	219.00	7	f	f	\N	2025-11-22 12:00:00	\N	219.00	CAROLINE
3323	T7	-837811382	0.00	54.00	54.00	2	f	f	\N	2025-11-22 12:00:00	\N	0.00	cayet
3355	T13	-479672637	0.00	2.50	2.50	1	f	f	\N	2025-12-04 12:00:00	\N	2.50	MANU
3376	T5	-1763527961	0.00	53.50	53.50	2	f	f	\N	2025-12-12 12:00:00	\N	0.00	IRENE
3388	T5	1090130270	0.00	73.20	73.20	2	f	f	\N	2025-12-13 12:00:00	\N	0.00	VERONIQUE
3394	T14	373719688	0.00	46.00	46.00	2	f	f	\N	2025-12-14 12:00:00	\N	0.00	FANON
3412	T5	-560080272	0.00	190.00	190.00	7	f	f	\N	2025-12-19 12:00:00	\N	190.00	Bande à Alex
3108	T10	-479672637	78.50	0.00	78.50	2	f	f	\N	2025-09-21 12:00:00	\N	78.50	4: Manu et bernard
3076	T13	-1931747542	0.00	84.00	84.00	1	f	f	\N	2025-09-13 12:00:00	\N	0.00	DENIS
3086	T10	1461066836	67.00	0.00	67.00	2	f	f	\N	2025-09-19 12:00:00	\N	67.00	Lam
2784	T10	1899778452	0.00	301.20	301.20	4	f	f	\N	2025-04-19 12:00:00	\N	301.20	LEGROS
3361	T7	2084900867	64.00	0.00	64.00	2	f	f	\N	2025-12-05 12:00:00	\N	64.00	MINET
2816	T14	1588048427	0.00	15.20	15.20	1	f	f	\N	2025-05-02 12:00:00	\N	0.00	ELISE
2821	T13	-479672637	0.00	4.00	4.00	1	f	f	\N	2025-05-02 12:00:00	\N	0.00	MANU
3356	T14	644045150	0.00	15.50	15.50	1	f	f	\N	2025-12-04 12:00:00	\N	15.50	RUDY
3389	T12	1034625513	85.00	0.00	85.00	2	f	f	\N	2025-12-13 12:00:00	\N	85.00	MORGANTE
3329	T15	-479672637	8.00	0.00	8.00	1	f	f	\N	2025-11-27 12:00:00	\N	8.00	MANU
3416	T10	3	0.00	347.00	347.00	6	f	f	\N	2025-12-19 12:00:00	\N	0.00	Filou
3392	T2	-479672637	47.50	0.00	47.50	1	f	f	\N	2025-12-14 12:00:00	\N	47.50	T2
3430	T13	-1850234108	0.00	45.00	45.00	1	f	f	\N	2025-12-19 12:00:00	\N	0.00	JCC
3457	T11	-1339696487	36.20	0.00	36.20	1	f	f	\N	2026-01-17 12:00:00	\N	36.20	bion
3460	T2	-1769468414	0.00	60.00	60.00	1	f	f	\N	2026-01-17 12:00:00	\N	60.00	laurent
3427	T11	3	0.00	111.50	111.50	1	f	f	\N	2025-12-19 12:00:00	\N	0.00	Filou 2
3444	T9	2098037424	0.00	98.40	98.40	3	f	f	\N	2026-01-09 12:00:00	\N	98.40	DORSAN
3445	T13	-479672637	17.00	0.00	17.00	1	f	f	\N	2026-01-09 12:00:00	\N	17.00	MANU
3452	T5	1090130270	109.40	0.00	109.40	4	f	f	\N	2026-01-16 12:00:00	\N	109.40	Véro Wos
3453	T12	1776813363	0.00	15.00	15.00	19	f	f	\N	2026-01-16 12:00:00	\N	0.00	MOY
3454	T6	-1607156744	0.00	188.00	188.00	4	f	f	\N	2026-01-16 12:00:00	\N	0.00	SOPHIE
3456	T8	1423511228	46.00	0.00	46.00	1	f	f	\N	2026-01-17 12:00:00	\N	46.00	gason
3459	T5	1105205458	124.20	0.00	124.20	5	f	f	\N	2026-01-17 12:00:00	\N	124.20	stephane
3464	T7	3	0.00	322.20	322.20	10	f	f	\N	2026-01-18 12:00:00	\N	0.00	T7
3310	\N	\N	-45.00	0.00	-45.00	1	f	t	\N	2025-11-19 12:00:00	\N	0.00	\N
3331	\N	\N	23.00	0.00	23.00	1	t	f	\N	2025-11-28 12:00:00	\N	23.00	Emporté
3334	\N	\N	-655.11	0.00	-655.11	1	f	t	\N	2025-11-28 12:00:00	\N	0.00	\N
3337	\N	\N	-99.00	0.00	-99.00	1	f	t	\N	2025-11-24 12:00:00	\N	0.00	\N
3340	\N	\N	-28.00	0.00	-28.00	1	f	t	\N	2025-11-18 12:00:00	\N	0.00	\N
3418	T2	\N	0.00	10.50	10.50	1	f	f	\N	2025-12-19 12:00:00	\N	0.00	T2
3721	\N	\N	-90.00	0.00	-90.00	1	f	t	\N	2026-04-03 12:00:00	\N	0.00	\N
3724	\N	\N	-87.50	0.00	-87.50	1	f	t	\N	2026-04-03 12:00:00	\N	0.00	\N
3727	\N	\N	-54.95	0.00	-54.95	1	f	t	\N	2026-03-16 12:00:00	\N	0.00	\N
3736	\N	\N	-20.45	0.00	-20.45	1	f	t	\N	2026-04-09 12:00:00	\N	0.00	\N
3752	\N	\N	-40.24	0.00	-40.24	1	f	t	\N	2026-04-07 12:00:00	\N	0.00	\N
3753	\N	\N	-127.50	0.00	-127.50	1	f	t	\N	2026-04-10 12:00:00	\N	0.00	\N
3754	\N	\N	-81.90	0.00	-81.90	1	f	t	\N	2026-04-08 12:00:00	\N	0.00	\N
3755	\N	\N	-87.50	0.00	-87.50	1	f	t	\N	2026-04-07 12:00:00	\N	0.00	\N
3756	\N	\N	-146.76	0.00	-146.76	1	f	t	\N	2026-04-04 12:00:00	\N	0.00	\N
3757	\N	\N	-110.12	0.00	-110.12	1	f	t	\N	2026-03-21 12:00:00	\N	0.00	\N
3762	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2026-04-16 12:00:00	\N	0.00	\N
3764	T14	\N	0.00	6.00	6.00	1	f	f	\N	2026-04-17 12:00:00	\N	0.00	T14
3766	T14	\N	38.70	0.00	38.70	1	f	f	\N	2026-04-17 12:00:00	\N	38.70	ALEX
3781	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2026-04-22 12:00:00	\N	0.00	\N
3782	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2026-04-22 12:00:00	\N	0.00	\N
3783	\N	\N	-25.00	0.00	-25.00	1	f	t	\N	2026-04-23 12:00:00	\N	0.00	\N
3784	\N	\N	-13.50	0.00	-13.50	1	f	t	\N	2026-04-23 12:00:00	\N	0.00	\N
3790	T13	\N	0.00	75.40	75.40	1	f	f	\N	2026-04-24 12:00:00	\N	75.40	T13
3792	T10	\N	0.00	30.00	30.00	1	f	f	\N	2026-04-24 12:00:00	\N	0.00	ivan
3794	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2026-04-24 12:00:00	\N	0.00	\N
3476	T5	1950985781	0.00	67.50	67.50	4	f	f	\N	2026-01-22 12:00:00	\N	67.50	MANDOUX
3629	T12	190114966	0.00	259.50	259.50	7	f	f	\N	2026-03-07 12:00:00	\N	0.00	IRENE et ERIC
2865	T15	-1931747542	0.00	54.50	54.50	1	f	f	\N	2025-05-16 12:00:00	\N	54.50	DENIS
3593	T2	-1769468414	0.00	100.00	100.00	2	f	f	\N	2026-02-28 12:00:00	\N	0.00	laurent
2880	T7	3	0.00	193.40	193.40	3	f	f	\N	2025-05-23 12:00:00	\N	0.00	Filou
2941	T13	686373030	0.00	50.00	50.00	3	f	f	\N	2025-06-13 12:00:00	\N	50.00	ANNICK
2946	T14	-1931747542	0.00	117.50	117.50	2	f	f	\N	2025-06-14 12:00:00	\N	0.00	DENIS&RUDY
2964	T11	1105205458	172.80	0.00	172.80	6	f	f	\N	2025-06-27 12:00:00	\N	172.80	FLUXYS
3592	T8	-2090111404	0.00	73.00	73.00	2	f	f	\N	2026-02-28 12:00:00	\N	0.00	lo presti
3716	T6	3	0.00	148.00	148.00	3	f	f	\N	2026-04-03 12:00:00	\N	0.00	FILOU
3730	T11	628858951	64.40	0.00	64.40	2	f	f	\N	2026-04-04 12:00:00	\N	64.40	GERARD
3865	T13	-278690184	230.00	0.00	230.00	4	f	f	\N	2026-06-11 12:00:00	\N	0.00	eve
3742	T9	-1143299298	202.00	0.00	202.00	4	f	f	\N	2026-04-10 12:00:00	\N	202.00	MICHEL
2425	T8	1461066836	0.00	65.50	65.50	2	f	f	\N	2025-01-11 12:00:00	\N	0.00	Lam
3760	T2	-801412725	0.00	133.10	133.10	3	f	f	\N	2026-04-16 12:00:00	\N	0.00	TAMARA
3850	T14	-479672637	10.50	0.00	10.50	1	f	f	\N	2026-05-29 12:00:00	\N	0.00	MANU
2427	T5	-1655278907	201.20	0.00	201.20	5	f	f	\N	2025-01-11 12:00:00	\N	201.20	Loic
2423	T2	-856482689	0.00	57.60	57.60	2	f	f	\N	2025-01-11 12:00:00	\N	0.00	Hannon
2720	T5	-1632933197	0.00	78.40	78.40	2	f	f	\N	2025-03-28 12:00:00	\N	78.40	T5
2721	T11	-1931747542	0.00	98.40	98.40	3	f	f	\N	2025-03-28 12:00:00	\N	0.00	DENIS
2507	T12	-282106964	0.00	48.20	48.20	2	f	f	\N	2025-02-07 12:00:00	\N	0.00	FRANCOISE
3811	T2	2098037424	0.00	53.20	53.20	1	f	f	\N	2026-04-30 12:00:00	\N	53.20	DORSAN
2437	T5	3	0.00	148.90	148.90	1	f	f	\N	2025-01-16 12:00:00	\N	0.00	FILOU
2426	T11	351063202	0.00	117.00	117.00	1	f	f	\N	2025-01-11 12:00:00	\N	0.00	Lo Presti
3719	T5	1936806253	140.00	174.40	314.40	10	f	f	\N	2026-04-03 12:00:00	\N	314.40	eve
3720	T7	1105205458	0.00	262.40	262.40	6	f	f	\N	2026-04-03 12:00:00	\N	0.00	pirotte-oger
3731	T5	1751496538	83.00	0.00	83.00	3	f	f	\N	2026-04-04 12:00:00	\N	83.00	Marie
3732	T8	-479672637	0.00	10.00	10.00	1	f	f	\N	2026-04-04 12:00:00	\N	0.00	MANU
3857	T2	-479672637	46.50	0.00	46.50	2	f	f	\N	2026-05-29 12:00:00	\N	0.00	manu
3737	T9	1139160753	111.50	0.00	111.50	2	f	f	\N	2026-04-09 12:00:00	\N	111.50	HUQUE
3741	T8	-272858789	67.00	0.00	67.00	2	f	f	\N	2026-04-10 12:00:00	\N	67.00	bossuroy
3887	T13	-479672637	49.70	0.00	49.70	1	f	f	\N	2026-06-15 12:00:00	\N	0.00	Manu
3743	T2	-1639649453	0.00	97.00	97.00	3	f	f	\N	2026-04-10 12:00:00	\N	0.00	DEHIN
3747	T9	-419139728	124.50	0.00	124.50	3	f	f	\N	2026-04-11 12:00:00	\N	124.50	halleux
3770	T2	1588048427	0.00	36.00	36.00	2	f	f	\N	2026-04-17 12:00:00	\N	0.00	elise
3776	T9	1776812018	0.00	137.40	137.40	3	f	f	\N	2026-04-17 12:00:00	\N	0.00	collet
2555	\N	-479672637	0.00	9.00	9.00	1	t	f	\N	2025-02-12 12:00:00	\N	0.00	Emporté
3717	T5	1588048427	0.00	22.40	22.40	1	f	f	\N	2026-04-03 12:00:00	\N	0.00	elise
3777	T12	-1763527961	0.00	86.20	86.20	2	f	f	\N	2026-04-17 12:00:00	\N	0.00	eric
3780	T5	-560080272	0.00	470.60	470.60	10	f	f	\N	2026-04-22 12:00:00	\N	0.00	JEREMY
3888	T14	-1931747542	0.00	40.00	40.00	1	f	f	\N	2026-06-15 12:00:00	\N	40.00	Denis
2609	T6	769723709	222.50	0.00	222.50	6	f	f	\N	2025-02-26 12:00:00	\N	222.50	BC VERLAINE
2621	T5	863154534	0.00	141.70	141.70	3	f	f	\N	2025-02-28 12:00:00	\N	0.00	Sam
2624	T9	-1775645180	0.00	112.00	112.00	3	f	f	\N	2025-03-01 12:00:00	\N	0.00	MAURIZIO
2487	T5	1899778452	0.00	139.50	139.50	3	f	f	\N	2025-01-31 12:00:00	\N	0.00	LEGROS
2517	T14	1588048427	0.00	275.00	275.00	24	f	f	\N	2025-02-08 12:00:00	\N	275.00	ELISE
2631	T13	-867980635	89.80	0.00	89.80	4	f	f	\N	2025-03-01 12:00:00	\N	89.80	ARNOLD
2979	T11	-1931747542	0.00	127.20	127.20	4	f	f	\N	2025-07-25 12:00:00	\N	0.00	denis
2982	T5	-1376027346	0.00	63.60	63.60	3	f	f	\N	2025-07-26 12:00:00	\N	63.60	Brasseur
3184	T13	1547125190	153.20	0.00	153.20	7	f	f	\N	2025-10-18 12:00:00	\N	153.20	TILLMAN
3201	T13	-1931747542	96.70	0.00	96.70	3	f	f	\N	2025-10-24 12:00:00	\N	96.70	DENIS
3253	T9	-560080272	212.50	0.00	212.50	5	f	f	\N	2025-11-07 12:00:00	\N	212.50	FABRICOM
3254	T5	-2114157071	33.20	0.00	33.20	2	f	f	\N	2025-11-07 12:00:00	\N	33.20	BLAISE
3284	T2	1105205458	0.00	479.50	479.50	12	f	f	\N	2025-11-11 12:00:00	\N	0.00	T2
3400	T12	-1763527961	0.00	39.10	39.10	2	f	f	\N	2025-12-14 12:00:00	\N	0.00	ERIC
3448	T11	-1763527961	0.00	117.00	117.00	5	f	f	\N	2026-01-15 12:00:00	\N	117.00	IRENE
3462	T5	1105205458	0.00	17.20	17.20	5	f	f	\N	2026-01-17 12:00:00	\N	17.20	stephane
3470	T13	1588048427	0.00	52.00	52.00	2	f	f	\N	2026-01-18 12:00:00	\N	0.00	ELISE
3404	T6	420446599	0.00	105.20	105.20	1	f	f	\N	2025-12-14 12:00:00	\N	105.20	MARC
3407	T2	-479672637	0.00	12.00	12.00	1	t	f	\N	2025-12-18 12:00:00	\N	12.00	T2
3696	\N	-867980635	0.00	12.00	12.00	2	t	f	\N	2026-03-27 12:00:00	\N	12.00	Emporté
2595	T12	1588048427	0.00	18.60	18.60	1	f	f	\N	2025-02-21 12:00:00	\N	0.00	ELISE
2676	T15	-479672637	20.00	0.00	20.00	1	f	f	\N	2025-03-21 12:00:00	\N	20.00	MANU
2933	T13	-1931747542	38.00	0.00	38.00	1	f	f	\N	2025-06-07 12:00:00	\N	38.00	Denis
2944	T10	-1632933197	0.00	40.50	40.50	1	f	f	\N	2025-06-14 12:00:00	\N	40.50	sabine
3043	T13	-479672637	15.00	0.00	15.00	1	f	f	\N	2025-09-03 12:00:00	\N	15.00	MANU
3051	T14	-479672637	14.00	0.00	14.00	1	f	f	\N	2025-09-05 12:00:00	\N	14.00	MANU
3817	\N	-479672637	0.00	5.00	5.00	1	t	f	\N	2026-05-15 12:00:00	\N	5.00	Emporté
3802	\N	\N	-125.62	0.00	-125.62	1	f	t	\N	2026-04-20 12:00:00	\N	0.00	\N
3804	\N	\N	-28.00	0.00	-28.00	1	f	t	\N	2026-04-20 12:00:00	\N	0.00	\N
3807	\N	\N	-376.50	0.00	-376.50	1	f	t	\N	2026-04-14 12:00:00	\N	0.00	\N
3808	\N	\N	0.00	285.00	285.00	1	t	f	\N	2026-05-01 12:00:00	\N	285.00	Emporté
3833	\N	\N	-28.00	0.00	-28.00	1	f	t	\N	2026-05-18 12:00:00	\N	0.00	\N
3834	\N	\N	-190.58	0.00	-190.58	1	f	t	\N	2026-05-19 12:00:00	\N	0.00	\N
3835	\N	\N	-272.25	0.00	-272.25	1	f	t	\N	2026-05-19 12:00:00	\N	0.00	\N
3836	\N	\N	-135.70	0.00	-135.70	1	f	t	\N	2026-05-11 12:00:00	\N	0.00	\N
3837	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2026-05-11 12:00:00	\N	0.00	\N
3840	T2	\N	0.00	2.50	2.50	1	f	f	\N	2026-05-22 12:00:00	\N	2.50	T2
3845	\N	\N	-20.00	0.00	-20.00	1	f	t	\N	2026-05-22 12:00:00	\N	0.00	\N
3846	\N	\N	-20.00	0.00	-20.00	1	f	t	\N	2026-05-22 12:00:00	\N	0.00	\N
3852	\N	\N	-77.61	0.00	-77.61	1	f	t	\N	2026-05-28 12:00:00	\N	0.00	\N
3867	\N	\N	-27.98	0.00	-27.98	1	f	t	\N	2026-06-12 12:00:00	\N	0.00	\N
3868	\N	\N	-48.17	0.00	-48.17	1	f	t	\N	2026-06-12 12:00:00	\N	0.00	\N
3060	T13	1588048427	0.00	20.00	20.00	1	t	f	\N	2025-09-10 12:00:00	\N	0.00	ELISE
3091	T2	644045150	7.50	0.00	7.50	1	f	f	\N	2025-09-21 12:00:00	\N	7.50	Rudy
3391	T13	-1931747542	0.00	28.30	28.30	1	f	f	\N	2025-12-14 12:00:00	\N	0.00	T13
3763	T13	-1931747542	0.00	15.00	15.00	1	f	f	\N	2026-04-17 12:00:00	\N	0.00	DENIS
2680	T9	-2020207416	80.00	0.00	80.00	1	f	f	\N	2025-03-21 12:00:00	\N	80.00	LESCRENIER
3079	T12	1474477203	0.00	63.20	63.20	1	f	f	\N	2025-09-17 12:00:00	\N	63.20	RENAULT
3080	T13	3	0.00	117.40	117.40	1	f	f	\N	2025-09-17 12:00:00	\N	0.00	FILOU
3293	T14	1588048427	0.00	25.00	25.00	1	f	f	\N	2025-11-14 12:00:00	\N	25.00	ELISE
3143	T13	1588048427	0.00	0.00	0.00	1	f	f	\N	2025-10-03 12:00:00	\N	0.00	ELISE
3145	T14	-1931747542	0.00	7.00	7.00	1	f	f	\N	2025-10-03 12:00:00	\N	7.00	DENIS
3267	T14	-479672637	18.00	0.00	18.00	1	f	f	\N	2025-11-08 12:00:00	\N	18.00	MANU
3885	T13	-1931747542	0.00	22.00	22.00	1	f	f	\N	2026-06-15 12:00:00	\N	22.00	T13
2583	T13	-479672637	21.00	0.00	21.00	1	f	f	\N	2025-02-19 12:00:00	\N	21.00	MANU
3147	\N	-479672637	0.00	2.50	2.50	1	t	f	\N	2025-10-03 12:00:00	\N	0.00	Emporté
3250	T13	-282106964	45.00	44.00	89.00	1	f	f	\N	2025-11-06 12:00:00	\N	89.00	FRANCOISE
3285	\N	1588048427	0.00	47.00	47.00	1	t	f	\N	2025-11-11 12:00:00	\N	0.00	Emporté
3307	T13	-479672637	14.00	0.00	14.00	1	f	f	\N	2025-11-20 12:00:00	\N	14.00	MANU
2686	T7	\N	112.50	0.00	112.50	1	f	f	\N	2025-03-22 12:00:00	\N	112.50	Antoine
2894	\N	\N	-25.18	0.00	-25.18	1	f	t	\N	2025-05-30 12:00:00	\N	0.00	\N
3181	T5	\N	74.00	0.00	74.00	1	f	f	\N	2025-10-17 12:00:00	\N	74.00	GILSON
2867	\N	\N	0.00	60.00	60.00	1	t	f	\N	2025-05-17 12:00:00	\N	0.00	Emporté
2872	\N	\N	0.00	7.00	7.00	1	t	f	\N	2025-05-21 12:00:00	\N	0.00	Emporté
2873	\N	\N	7.00	0.00	7.00	1	t	f	\N	2025-05-21 12:00:00	\N	7.00	Emporté
2881	T8	\N	0.00	30.00	30.00	1	f	f	\N	2025-05-23 12:00:00	\N	30.00	Occupé
3483	T13	\N	0.00	26.00	26.00	1	f	f	\N	2026-01-23 12:00:00	\N	26.00	Laurent
3651	T12	\N	0.00	78.50	78.50	1	f	f	\N	2026-03-14 12:00:00	\N	78.50	lancel
3675	T11	\N	0.00	226.00	226.00	1	f	f	\N	2026-03-20 12:00:00	\N	0.00	FILOU
3715	\N	\N	-119.94	0.00	-119.94	1	f	t	\N	2026-04-01 12:00:00	\N	0.00	\N
3667	T5	\N	0.00	50.90	50.90	1	f	f	\N	2026-03-15 12:00:00	\N	0.00	Eric
3682	T14	\N	0.00	52.50	52.50	1	f	f	\N	2026-03-21 12:00:00	\N	0.00	DIDIER
3709	T7	\N	86.00	0.00	86.00	1	f	f	\N	2026-03-28 12:00:00	\N	86.00	renier
3712	T14	\N	0.00	68.00	68.00	1	f	f	\N	2026-03-28 12:00:00	\N	0.00	caro
2722	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2025-03-28 12:00:00	\N	0.00	\N
3129	\N	\N	-32.95	0.00	-32.95	1	f	t	\N	2025-09-26 12:00:00	\N	0.00	\N
3141	\N	\N	0.00	10.00	10.00	1	t	f	\N	2025-10-03 12:00:00	\N	0.00	Emporté
3160	\N	\N	14.00	0.00	14.00	1	t	f	\N	2025-10-09 12:00:00	\N	14.00	Emporté
3178	\N	\N	-39.14	0.00	-39.14	1	f	t	\N	2025-10-17 12:00:00	\N	0.00	\N
3187	\N	\N	-45.00	0.00	-45.00	1	f	t	\N	2025-10-16 12:00:00	\N	0.00	\N
3223	\N	\N	0.00	15.50	15.50	1	t	f	\N	2025-10-31 12:00:00	\N	0.00	Emporté
3225	\N	\N	5.00	0.00	5.00	1	t	f	\N	2025-10-31 12:00:00	\N	5.00	Emporté
3226	\N	\N	0.00	17.00	17.00	1	t	f	\N	2025-10-31 12:00:00	\N	0.00	Emporté
3228	\N	\N	0.00	5.00	5.00	1	t	f	\N	2025-10-31 12:00:00	\N	0.00	Emporté
3229	\N	\N	0.00	12.00	12.00	1	t	f	\N	2025-10-31 12:00:00	\N	0.00	Emporté
3231	T5	\N	0.00	16.00	16.00	1	f	f	\N	2025-10-31 12:00:00	\N	0.00	T5
3232	\N	\N	0.00	11.00	11.00	1	t	f	\N	2025-10-31 12:00:00	\N	0.00	Emporté
3234	\N	\N	0.00	20.00	20.00	1	t	f	\N	2025-10-31 12:00:00	\N	0.00	Emporté
3258	T15	\N	46.20	0.00	46.20	1	f	f	\N	2025-11-07 12:00:00	\N	46.20	T15
3259	T12	\N	0.00	20.00	20.00	1	f	f	\N	2025-11-07 12:00:00	\N	0.00	T12
3873	\N	\N	-102.19	0.00	-102.19	1	f	t	\N	2026-06-11 12:00:00	\N	0.00	\N
3874	\N	\N	0.00	7.00	7.00	1	t	f	\N	2026-06-12 12:00:00	\N	7.00	Emporté
3875	T2	\N	0.00	12.00	12.00	1	f	f	\N	2026-06-12 12:00:00	\N	12.00	T2
3876	\N	\N	-120.00	0.00	-120.00	1	f	t	\N	2026-06-12 12:00:00	\N	0.00	\N
3886	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2026-06-15 12:00:00	\N	0.00	\N
3899	DÉPENSES	\N	-114.95	0.00	-114.95	1	f	t	\N	2026-06-24 15:54:04.48937	\N	0.00	\N
3907	T6	\N	73.50	0.00	73.50	1	f	f	\N	2026-06-19 09:55:00	\N	0.00	Gordatti
3908	T6	\N	228.00	0.00	228.00	1	f	f	\N	2026-06-19 10:01:00	\N	0.00	Veneria
3913	DÉPENSES	\N	-104.47	0.00	-104.47	1	f	t	\N	2026-06-24 12:00:00	\N	0.00	\N
3914	T5	3	0.00	135.00	135.00	1	f	f	\N	2026-06-26 12:00:00	\N	135.00	FILOU
3923	DÉPENSES	\N	-217.90	0.00	-217.90	1	f	f	\N	2026-05-27 12:00:00	\N	0.00	\N
3924	DÉPENSES	\N	-160.33	0.00	-160.33	1	f	t	\N	2026-06-28 12:00:00	\N	0.00	\N
3931	DÉPENSES	\N	-30.00	0.00	-30.00	1	f	t	\N	2026-06-24 12:00:00	\N	0.00	\N
3932	T14	1588048427	0.00	46.00	46.00	1	f	f	\N	2026-07-03 12:00:00	\N	0.00	Elise
2677	T14	\N	0.00	338.50	338.50	1	f	f	\N	2025-03-21 12:00:00	\N	0.00	BOISSONS
3318	\N	\N	-89.10	0.00	-89.10	1	f	t	\N	2025-11-22 12:00:00	\N	0.00	\N
3333	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2025-11-03 12:00:00	\N	0.00	\N
3366	T13	\N	0.00	9.00	9.00	1	f	f	\N	2025-12-06 12:00:00	\N	9.00	T13
3372	\N	\N	-55.82	0.00	-55.82	1	f	t	\N	2025-12-12 12:00:00	\N	0.00	\N
3393	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2025-12-14 12:00:00	\N	0.00	\N
2541	T2	\N	0.00	13.00	13.00	1	f	f	\N	2025-02-08 12:00:00	\N	0.00	T2
2553	T9	\N	0.00	30.00	30.00	1	f	f	\N	2025-02-12 12:00:00	\N	0.00	T9
2562	\N	\N	-9.46	0.00	-9.46	1	f	t	\N	2025-02-14 12:00:00	\N	0.00	\N
2577	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2025-02-16 12:00:00	\N	0.00	\N
2770	\N	\N	-34.83	0.00	-34.83	1	f	t	\N	2025-04-17 12:00:00	\N	0.00	\N
2885	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2025-05-23 12:00:00	\N	0.00	\N
2963	\N	\N	0.00	6.00	6.00	1	t	f	\N	2025-06-27 12:00:00	\N	6.00	Emporté
2985	T8	\N	0.00	40.40	40.40	1	f	f	\N	2025-07-26 12:00:00	\N	40.40	Noah
2995	\N	\N	0.00	34.00	34.00	1	t	f	\N	2025-08-22 12:00:00	\N	0.00	Emporté
3033	\N	\N	-11.00	0.00	-11.00	1	f	t	\N	2025-08-29 12:00:00	\N	0.00	\N
3046	\N	\N	-37.30	0.00	-37.30	1	f	t	\N	2025-09-05 12:00:00	\N	0.00	\N
3047	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2025-09-05 12:00:00	\N	0.00	\N
3050	\N	\N	0.00	6.00	6.00	1	t	f	\N	2025-09-05 12:00:00	\N	6.00	Emporté
3058	\N	\N	-219.32	0.00	-219.32	1	f	t	\N	2025-08-11 12:00:00	\N	0.00	\N
3078	\N	\N	0.00	6.00	6.00	1	t	f	\N	2025-09-17 12:00:00	\N	0.00	Emporté
3097	T7	\N	0.00	51.50	51.50	1	t	f	\N	2025-09-21 12:00:00	\N	51.50	7: Les 10 de der
3115	\N	\N	-100.00	0.00	-100.00	1	f	t	\N	2025-09-21 12:00:00	\N	0.00	\N
3119	T12	\N	8.00	0.00	8.00	1	f	f	\N	2025-09-21 12:00:00	\N	8.00	6: Pollet
3132	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2025-09-26 12:00:00	\N	0.00	\N
3162	\N	\N	-53.84	0.00	-53.84	1	f	t	\N	2025-10-10 12:00:00	\N	0.00	\N
3169	\N	\N	-600.00	0.00	-600.00	1	f	t	\N	2025-10-10 12:00:00	\N	0.00	\N
3193	\N	\N	-11.76	0.00	-11.76	1	f	t	\N	2025-10-24 12:00:00	\N	0.00	\N
3194	\N	\N	0.00	10.00	10.00	1	t	f	\N	2025-10-24 12:00:00	\N	0.00	Emporté
3195	\N	\N	-27.17	0.00	-27.17	1	f	t	\N	2025-10-24 12:00:00	\N	0.00	\N
3200	\N	\N	-50.00	0.00	-50.00	1	f	t	\N	2025-10-24 12:00:00	\N	0.00	\N
3213	T2	\N	0.00	10.00	10.00	1	f	f	\N	2025-10-31 12:00:00	\N	0.00	T2
3220	\N	\N	30.00	0.00	30.00	1	t	f	\N	2025-10-31 12:00:00	\N	30.00	Emporté
3222	\N	\N	18.00	0.00	18.00	1	t	f	\N	2025-10-31 12:00:00	\N	18.00	Emporté
3230	\N	\N	27.00	25.00	52.00	1	t	f	\N	2025-10-31 12:00:00	\N	52.00	Emporté
3264	\N	\N	-70.00	0.00	-70.00	1	f	t	\N	2025-11-07 12:00:00	\N	0.00	\N
3265	\N	\N	-213.00	0.00	-213.00	1	f	t	\N	2025-11-08 12:00:00	\N	0.00	\N
3272	\N	\N	0.00	9.00	9.00	1	t	f	\N	2025-11-09 12:00:00	\N	9.00	Emporté
3273	T2	\N	0.00	5.00	5.00	1	f	f	\N	2025-11-09 12:00:00	\N	5.00	Monsieurs
3276	T5	\N	0.00	6.20	6.20	1	f	f	\N	2025-11-09 12:00:00	\N	6.20	T5
3280	T5	\N	60.50	0.00	60.50	1	f	f	\N	2025-11-09 12:00:00	\N	60.50	Dominique et chris
3286	\N	\N	-49.47	0.00	-49.47	1	f	t	\N	2025-11-13 12:00:00	\N	0.00	\N
3290	\N	\N	-38.83	0.00	-38.83	1	f	t	\N	2025-11-14 12:00:00	\N	0.00	\N
3328	\N	\N	7.00	0.00	7.00	1	t	f	\N	2025-11-28 12:00:00	\N	7.00	Emporté
3332	T12	\N	32.50	0.00	32.50	1	f	f	\N	2025-11-28 12:00:00	\N	32.50	SOLO
3352	\N	\N	-28.00	0.00	-28.00	1	f	t	\N	2025-10-17 12:00:00	\N	0.00	\N
3365	T13	\N	12.00	0.00	12.00	1	f	f	\N	2025-12-06 12:00:00	\N	12.00	T13
3377	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2025-12-12 12:00:00	\N	0.00	\N
3382	\N	\N	-105.68	0.00	-105.68	1	f	t	\N	2025-12-03 12:00:00	\N	0.00	\N
3383	\N	\N	-83.16	0.00	-83.16	1	f	t	\N	2025-11-17 12:00:00	\N	0.00	\N
3410	T2	\N	0.00	70.00	70.00	1	f	f	\N	2025-12-19 12:00:00	\N	0.00	T2
3421	T15	\N	0.00	8.00	8.00	1	f	f	\N	2025-12-19 12:00:00	\N	0.00	T15
3422	T15	\N	0.00	4.00	4.40	1	f	f	\N	2025-12-19 12:00:00	\N	0.00	T15
3423	T15	\N	0.00	15.50	15.50	1	f	f	\N	2025-12-19 12:00:00	\N	0.00	T15
3424	T15	\N	0.00	5.00	5.00	1	f	f	\N	2025-12-19 12:00:00	\N	0.00	T15
3425	T15	\N	0.00	2.20	2.20	1	f	f	\N	2025-12-19 12:00:00	\N	0.00	T15
3431	T15	\N	26.50	0.00	26.50	1	f	f	\N	2025-12-19 12:00:00	\N	26.50	T15
3432	T15	\N	0.00	5.00	5.00	1	f	f	\N	2025-12-19 12:00:00	\N	0.00	T15
3440	\N	\N	-109.66	0.00	-109.66	1	f	t	\N	2025-12-03 12:00:00	\N	0.00	\N
3441	\N	\N	-172.16	0.00	-172.16	1	f	t	\N	2025-11-24 12:00:00	\N	0.00	\N
3447	\N	\N	-68.38	0.00	-68.38	1	f	t	\N	2026-01-15 12:00:00	\N	0.00	\N
3465	\N	\N	-70.00	0.00	-70.00	1	f	t	\N	2026-01-16 12:00:00	\N	0.00	\N
3467	\N	\N	-70.00	0.00	-70.00	1	f	t	\N	2026-01-17 12:00:00	\N	0.00	\N
3472	\N	\N	-45.00	0.00	-45.00	1	f	t	\N	2025-12-29 12:00:00	\N	0.00	\N
3475	\N	\N	-71.06	0.00	-71.06	1	f	t	\N	2026-01-18 12:00:00	\N	0.00	\N
3487	\N	\N	-100.92	0.00	-100.92	1	f	t	\N	2026-01-23 12:00:00	\N	0.00	\N
3501	\N	\N	-10.00	0.00	-10.00	1	f	t	\N	2026-01-29 12:00:00	\N	0.00	\N
3502	\N	\N	-39.62	0.00	-39.62	1	f	t	\N	2026-01-29 12:00:00	\N	0.00	\N
3511	\N	\N	-70.00	0.00	-70.00	1	f	t	\N	2026-01-31 12:00:00	\N	0.00	\N
3512	\N	\N	-55.00	0.00	-55.00	1	f	t	\N	2026-01-31 12:00:00	\N	0.00	\N
3514	\N	\N	-40.00	0.00	-40.00	1	f	t	\N	2026-01-31 12:00:00	\N	0.00	\N
3521	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2026-02-05 12:00:00	\N	0.00	\N
3530	\N	\N	-76.50	0.00	-76.50	1	f	t	\N	2026-02-05 12:00:00	\N	0.00	\N
3531	\N	\N	-301.69	0.00	-301.69	1	f	t	\N	2026-02-04 12:00:00	\N	0.00	\N
3532	\N	\N	-124.23	0.00	-124.23	1	f	t	\N	2026-02-04 12:00:00	\N	0.00	\N
3533	\N	\N	-104.66	0.00	-104.66	1	f	t	\N	2026-02-02 12:00:00	\N	0.00	\N
3534	\N	\N	-87.50	0.00	-87.50	1	f	t	\N	2026-01-30 12:00:00	\N	0.00	\N
3539	T13	\N	0.00	14.00	14.00	1	f	f	\N	2026-02-12 12:00:00	\N	0.00	DENIS
3540	T14	\N	12.00	0.00	12.00	1	f	f	\N	2026-02-12 12:00:00	\N	12.00	MANU
3545	T13	\N	0.00	24.00	24.00	1	t	f	\N	2026-02-13 12:00:00	\N	0.00	T13
3551	\N	\N	-34.88	0.00	-34.88	1	f	t	\N	2026-02-14 12:00:00	\N	0.00	\N
3554	\N	\N	-75.00	0.00	-75.00	1	f	t	\N	2026-02-13 12:00:00	\N	0.00	\N
3560	T13	\N	24.00	0.00	24.00	1	f	f	\N	2026-02-20 12:00:00	\N	24.00	manu
3565	\N	\N	-60.00	0.00	-60.00	1	f	t	\N	2026-02-20 12:00:00	\N	0.00	\N
3579	\N	\N	-103.15	0.00	-103.15	1	f	t	\N	2026-02-26 12:00:00	\N	0.00	\N
3589	\N	\N	-7.96	0.00	-7.96	1	f	t	\N	2026-02-28 12:00:00	\N	0.00	\N
3596	\N	\N	-90.00	0.00	-90.00	1	f	t	\N	2026-02-28 12:00:00	\N	0.00	\N
3597	\N	\N	-90.00	0.00	-90.00	1	f	t	\N	2026-02-28 12:00:00	\N	0.00	\N
3604	\N	\N	-376.50	0.00	-376.50	1	f	t	\N	2026-02-13 12:00:00	\N	0.00	\N
3605	\N	\N	-35.35	0.00	-35.35	1	f	t	\N	2026-03-05 12:00:00	\N	0.00	\N
3610	\N	\N	-363.00	0.00	-363.00	1	f	t	\N	2026-03-04 12:00:00	\N	0.00	\N
3613	T7	\N	0.00	6.70	6.70	1	f	f	\N	2026-03-06 12:00:00	\N	6.70	Papa
3628	\N	\N	-125.00	0.00	-125.00	1	f	t	\N	2026-03-06 12:00:00	\N	0.00	\N
3664	T11	\N	0.00	6.00	6.00	1	t	f	\N	2026-03-15 12:00:00	\N	6.00	CHRIS & DOM
3666	T2	\N	9.00	0.00	9.00	1	f	f	\N	2026-03-15 12:00:00	\N	9.00	voisin
3668	\N	\N	-176.00	0.00	-176.00	1	f	t	\N	2026-03-19 12:00:00	\N	0.00	\N
3669	\N	\N	-54.68	0.00	-54.68	1	f	t	\N	2026-03-14 12:00:00	\N	0.00	\N
3673	T13	\N	0.00	10.00	10.00	1	f	f	\N	2026-03-20 12:00:00	\N	0.00	Occupé
3707	\N	\N	-33.20	0.00	-33.20	1	f	t	\N	2026-03-28 12:00:00	\N	0.00	\N
3791	T14	\N	6.90	0.00	6.90	1	f	f	\N	2026-04-24 12:00:00	\N	6.90	manu
3795	\N	\N	-75.00	0.00	-75.00	1	f	t	\N	2026-04-24 12:00:00	\N	0.00	\N
3796	\N	\N	-15.00	0.00	-15.00	1	f	t	\N	2026-04-24 12:00:00	\N	0.00	\N
3797	\N	\N	-45.00	0.00	-45.00	1	f	t	\N	2026-04-24 12:00:00	\N	0.00	\N
3803	\N	\N	-36.35	0.00	-36.35	1	f	t	\N	2026-04-20 12:00:00	\N	0.00	\N
3816	\N	\N	-57.09	0.00	-57.09	1	f	t	\N	2026-05-15 12:00:00	\N	0.00	\N
3818	T15	\N	0.00	4.00	4.00	1	f	f	\N	2026-05-15 12:00:00	\N	4.00	T15
3823	\N	\N	-75.00	0.00	-75.00	1	f	t	\N	2026-05-15 12:00:00	\N	0.00	\N
3847	\N	\N	-45.00	0.00	-45.00	1	f	t	\N	2026-05-22 12:00:00	\N	0.00	\N
3869	\N	\N	-7.50	0.00	-7.50	1	f	t	\N	2026-06-12 12:00:00	\N	0.00	\N
3902	T14	\N	0.00	41.00	41.00	1	f	f	\N	2026-06-20 09:37:00	\N	41.00	Ouvrier 
3921	DÉPENSES	\N	-68.49	0.00	-68.49	1	f	f	\N	2026-05-27 12:00:00	\N	0.00	\N
3922	DÉPENSES	\N	-181.50	0.00	-181.50	1	f	f	\N	2026-05-27 12:00:00	\N	0.00	\N
3930	DÉPENSES	\N	-40.00	0.00	-40.00	1	f	t	\N	2026-07-01 12:00:00	\N	0.00	\N
3419	T2	-560080272	33.00	0.00	33.00	1	f	f	\N	2025-12-19 12:00:00	\N	33.00	ALEX
3458	T9	1936806253	0.00	70.20	70.20	1	f	f	\N	2026-01-17 12:00:00	\N	70.20	eve
3461	T8	383682159	0.00	40.00	40.00	1	f	f	\N	2026-01-17 12:00:00	\N	40.00	docteur
3729	T7	-479672637	23.00	0.00	23.00	1	f	f	\N	2026-04-04 12:00:00	\N	23.00	T7
3824	T13	-1931747542	0.00	7.00	7.00	1	f	f	\N	2026-05-21 12:00:00	\N	7.00	DENIS
3849	T13	-1931747542	32.50	0.00	32.50	1	f	f	\N	2026-05-29 12:00:00	\N	0.00	DENIS
\.


--
-- Data for Name: recap_mensuel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recap_mensuel (id, annee, mois, memo, km_defaut, km_par_jour, ferme_par_jour) FROM stdin;
4	2026	4		53.40	{}	{}
6	2026	8	03 Août : Nettoyage\n10 Août : Nettoyage\n17 Août : Nettoyage\n24 Août : Nettoyage\n31 Août : Nettoyage	53.40	{"2": 0.0, "3": 53.4, "4": 0.0, "5": 0.0, "9": 0.0, "11": 0.0, "12": 0.0, "16": 0.0, "18": 0.0, "19": 0.0, "23": 0.0, "25": 0.0, "26": 0.0, "30": 0.0}	{}
1	2026	5	04 mai : nettoyage\n11 mai : nettoyage\n18 mai : nettoyage\n25 mai : nettoyage 	53.40	{"3": 0.0, "4": 53.4, "5": 0.0, "6": 0.0, "10": 0.0, "12": 0.0, "13": 0.0, "16": 53.4, "17": 0.0, "19": 0.0, "20": 0.0, "24": 0.0, "25": 0.0}	{}
3	2026	3		53.40	{"1": 0.0, "2": 0.0, "3": 0.0, "8": 0.0, "9": 0.0, "10": 0.0, "11": 53.4, "12": 53.4, "13": 53.4, "16": 0.0, "17": 0.0, "18": 0.0, "19": 53.2, "20": 53.4, "22": 0.0, "23": 0.0, "24": 0.0, "28": 53.4, "29": 0.0, "30": 0.0, "31": 0.0}	{}
5	2026	7		53.40	{"1": 0.0, "5": 0.0, "6": 0.0, "7": 0.0, "8": 0.0, "12": 0.0, "13": 0.0, "14": 0.0, "15": 0.0, "19": 0.0, "20": 0.0, "21": 0.0, "22": 0.0, "26": 0.0, "27": 0.0, "28": 0.0, "29": 0.0}	{}
2	2026	6	03 juin : nettoyage \n10 juin : nettoyage \n17 juin : nettoyage \n24 juin : nettoyage \n	53.40	{"1": 0.0, "2": 0.0, "3": 53.4, "7": 0.0, "8": 0.0, "9": 0.0, "14": 0.0, "15": 0.0, "16": 0.0, "20": 53.4, "21": 0.0, "22": 0.0, "23": 0.0, "27": 0.0, "28": 0.0, "29": 0.0, "30": 0.0}	{"1": true, "2": true, "3": true, "7": true, "8": true, "9": true, "10": true, "14": true, "16": true, "17": true, "21": true, "22": true, "23": true, "24": true, "27": true, "28": true, "29": true, "30": true}
\.


--
-- Data for Name: reservations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reservations (id, table_id, client_id, nom_client, date_reservation, heure, nb_personnes, remarque, statut, created_at) FROM stdin;
1	\N	\N	Bidaine	2026-06-26	19:30:00	2	0493762011	confirmee	2026-06-21 12:04:58.04404
3	6	\N	Gordatti	2026-06-20	19:00:00	2	\N	confirmee	2026-06-21 15:42:34.90343
5	7	\N	Manu	2026-06-21	20:00:00	2	\N	confirmee	2026-06-21 23:28:05.086531
6	5	\N	Wos	2026-06-20	19:30:00	4	\N	confirmee	2026-06-22 01:02:45.683803
7	10	\N	Whitney	2026-06-20	19:45:00	2	\N	confirmee	2026-06-23 17:08:18.059383
8	12	\N	Filou	2026-06-24	12:15:00	4	\N	confirmee	2026-06-24 20:55:20.585931
9	6	\N	Elise	2026-06-24	19:00:00	1	\N	confirmee	2026-06-24 20:56:41.636465
10	3	\N	FILOU	2026-06-26	12:00:00	3	\N	confirmee	2026-06-26 13:59:32.132487
11	6	\N	Jean-christophe	2026-06-26	20:00:00	3	\N	confirmee	2026-06-27 21:44:03.285223
12	7	\N	Afrique	2026-06-26	21:00:00	4	\N	confirmee	2026-06-27 21:46:43.170139
13	9	\N	Bidaine	2026-06-26	19:30:00	2	\N	confirmee	2026-06-27 21:49:20.553868
14	12	\N	Elise	2026-07-03	18:30:00	2	\N	confirmee	2026-07-03 16:24:55.395034
15	3	\N	David	2026-07-03	20:00:00	2	\N	confirmee	2026-07-03 21:42:23.545515
16	10	\N	Cheveux	2026-07-03	20:30:00	2	\N	confirmee	2026-07-03 21:42:39.228301
\.


--
-- Data for Name: table_position_jour; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.table_position_jour (id, table_id, date, pos_x, pos_y, statut, heure_arrivee) FROM stdin;
19	6	2026-06-20	405	187	\N	\N
20	3	2026-06-25	\N	\N	libre	\N
22	3	2026-06-26	405	14	\N	\N
24	3	2026-06-27	\N	\N	libre	\N
25	1	2026-06-29	\N	\N	libre	\N
26	14	2026-06-29	\N	\N	libre	\N
27	1	2026-07-03	168	11	libre	\N
30	12	2026-07-03	\N	\N	occupee	\N
31	1	2026-07-04	\N	\N	libre	\N
38	1	2026-07-05	\N	\N	libre	\N
\.


--
-- Data for Name: tables; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tables (id, nom, capacite, pos_x, pos_y, forme, statut, created_at, updated_at, nom_reservation, heure_arrivee, type) FROM stdin;
5	T7	4	406	277	rect	libre	2026-06-20 00:43:35.990228	2026-06-20 00:43:35.990228	\N	\N	salle
2	T2	4	30	141	rect	libre	2026-06-20 00:43:35.990228	2026-06-20 00:43:35.990228	\N	\N	salle
14	DÉPENSES	1	0	0	rect	libre	2026-06-22 12:35:04.005214	2026-06-22 12:35:04.005214	\N	\N	depenses
12	T14	2	265	274	rect	libre	2026-06-20 00:43:35.990228	2026-06-20 00:43:35.990228	\N	\N	salle
4	T6	4	405	93	rect	libre	2026-06-20 00:43:35.990228	2026-06-20 00:43:35.990228	\N	\N	salle
8	T10	4	606	98	rect	libre	2026-06-20 00:43:35.990228	2026-06-20 00:43:35.990228	\N	\N	salle
3	T5	0	405	11	rect	libre	2026-06-20 00:43:35.990228	2026-06-20 00:43:35.990228	Test	2026-06-21 09:30:00	salle
13	T15	4	97	274	rect	libre	2026-06-20 00:43:35.990228	2026-06-20 00:43:35.990228	\N	\N	salle
10	T12	4	603	276	rect	libre	2026-06-20 00:43:35.990228	2026-06-20 00:43:35.990228	\N	\N	salle
11	T13	4	266	362	rect	libre	2026-06-20 00:43:35.990228	2026-06-20 00:43:35.990228	\N	\N	salle
1	T1	0	164	12	rect	occupee	2026-06-20 00:43:35.990228	2026-06-20 00:43:35.990228	\N	\N	salle
6	T8	4	402	186	rect	libre	2026-06-20 00:43:35.990228	2026-06-20 00:43:35.990228	\N	\N	salle
7	T9	4	606	11	rect	libre	2026-06-20 00:43:35.990228	2026-06-20 00:43:35.990228	\N	\N	salle
9	T11	4	602	186	rect	libre	2026-06-20 00:43:35.990228	2026-06-20 00:43:35.990228	\N	\N	salle
\.


--
-- Data for Name: utilisateurs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.utilisateurs (id, username, mot_de_passe, actif) FROM stdin;
1	LOLIVE	$2b$12$CKFkMjBhE4VnY0/klL4jKuXPGGuCQp98kzFJBY5SOAZb4ibNwF1x.	t
\.


--
-- Name: article_composants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.article_composants_id_seq', 203, true);


--
-- Name: articles_achat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.articles_achat_id_seq', 163, true);


--
-- Name: articles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.articles_id_seq', 570, true);


--
-- Name: clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clients_id_seq', 2113986680, true);


--
-- Name: commandes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.commandes_id_seq', 142, true);


--
-- Name: encaissement_lignes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.encaissement_lignes_id_seq', 11870, true);


--
-- Name: encaissements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.encaissements_id_seq', 3936, true);


--
-- Name: recap_mensuel_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recap_mensuel_id_seq', 6, true);


--
-- Name: reservations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reservations_id_seq', 16, true);


--
-- Name: table_position_jour_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.table_position_jour_id_seq', 38, true);


--
-- Name: tables_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tables_id_seq', 14, true);


--
-- Name: utilisateurs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.utilisateurs_id_seq', 1, true);


--
-- Name: article_composants article_composants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.article_composants
    ADD CONSTRAINT article_composants_pkey PRIMARY KEY (id);


--
-- Name: articles_achat articles_achat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.articles_achat
    ADD CONSTRAINT articles_achat_pkey PRIMARY KEY (id);


--
-- Name: articles articles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: commandes commandes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commandes
    ADD CONSTRAINT commandes_pkey PRIMARY KEY (id);


--
-- Name: encaissement_lignes encaissement_lignes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encaissement_lignes
    ADD CONSTRAINT encaissement_lignes_pkey PRIMARY KEY (id);


--
-- Name: encaissements encaissements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encaissements
    ADD CONSTRAINT encaissements_pkey PRIMARY KEY (id);


--
-- Name: recap_mensuel recap_mensuel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recap_mensuel
    ADD CONSTRAINT recap_mensuel_pkey PRIMARY KEY (id);


--
-- Name: reservations reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_pkey PRIMARY KEY (id);


--
-- Name: table_position_jour table_position_jour_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.table_position_jour
    ADD CONSTRAINT table_position_jour_pkey PRIMARY KEY (id);


--
-- Name: tables tables_nom_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tables
    ADD CONSTRAINT tables_nom_key UNIQUE (nom);


--
-- Name: tables tables_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tables
    ADD CONSTRAINT tables_pkey PRIMARY KEY (id);


--
-- Name: recap_mensuel uq_recap_annee_mois; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recap_mensuel
    ADD CONSTRAINT uq_recap_annee_mois UNIQUE (annee, mois);


--
-- Name: table_position_jour uq_table_position_jour_table_date; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.table_position_jour
    ADD CONSTRAINT uq_table_position_jour_table_date UNIQUE (table_id, date);


--
-- Name: utilisateurs utilisateurs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateurs
    ADD CONSTRAINT utilisateurs_pkey PRIMARY KEY (id);


--
-- Name: utilisateurs utilisateurs_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateurs
    ADD CONSTRAINT utilisateurs_username_key UNIQUE (username);


--
-- Name: idx_article_composants_article_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_article_composants_article_id ON public.article_composants USING btree (article_id);


--
-- Name: idx_articles_actif; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_articles_actif ON public.articles USING btree (actif);


--
-- Name: idx_articles_categorie; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_articles_categorie ON public.articles USING btree (categorie);


--
-- Name: idx_clients_nom; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_clients_nom ON public.clients USING btree (nom);


--
-- Name: idx_clients_telephone; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_clients_telephone ON public.clients USING btree (telephone_mobile);


--
-- Name: idx_commandes_article; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_commandes_article ON public.commandes USING btree (article_id);


--
-- Name: idx_commandes_table; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_commandes_table ON public.commandes USING btree (table_id);


--
-- Name: idx_encaissements_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_encaissements_date ON public.encaissements USING btree (date_encaissement);


--
-- Name: idx_encaissements_table; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_encaissements_table ON public.encaissements USING btree (table_nom);


--
-- Name: idx_lignes_encaissement; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_lignes_encaissement ON public.encaissement_lignes USING btree (encaissement_id);


--
-- Name: idx_reservations_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reservations_date ON public.reservations USING btree (date_reservation);


--
-- Name: idx_reservations_table; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reservations_table ON public.reservations USING btree (table_id);


--
-- Name: article_composants article_composants_article_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.article_composants
    ADD CONSTRAINT article_composants_article_id_fkey FOREIGN KEY (article_id) REFERENCES public.articles(id);


--
-- Name: commandes commandes_article_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commandes
    ADD CONSTRAINT commandes_article_id_fkey FOREIGN KEY (article_id) REFERENCES public.articles(id);


--
-- Name: commandes commandes_table_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commandes
    ADD CONSTRAINT commandes_table_id_fkey FOREIGN KEY (table_id) REFERENCES public.tables(id) ON DELETE CASCADE;


--
-- Name: encaissement_lignes encaissement_lignes_article_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encaissement_lignes
    ADD CONSTRAINT encaissement_lignes_article_id_fkey FOREIGN KEY (article_id) REFERENCES public.articles(id);


--
-- Name: encaissement_lignes encaissement_lignes_encaissement_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encaissement_lignes
    ADD CONSTRAINT encaissement_lignes_encaissement_id_fkey FOREIGN KEY (encaissement_id) REFERENCES public.encaissements(id) ON DELETE CASCADE;


--
-- Name: encaissements encaissements_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encaissements
    ADD CONSTRAINT encaissements_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: reservations reservations_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id);


--
-- Name: reservations reservations_table_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_table_id_fkey FOREIGN KEY (table_id) REFERENCES public.tables(id);


--
-- Name: table_position_jour table_position_jour_table_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.table_position_jour
    ADD CONSTRAINT table_position_jour_table_id_fkey FOREIGN KEY (table_id) REFERENCES public.tables(id);


--
-- PostgreSQL database dump complete
--

\unrestrict 5cVkgOxRjtecxkpA9i8SmGtJyhD8LEYVeCTwKnZuTDXpJ8sZfORz40mJ0VhuPxw

