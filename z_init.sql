-- Init tables for Oil and Gas DataBase
-- 

--Create schemas to differentiate tables that updates daily

CREATE SCHEMA inventory;
CREATE SCHEMA daily;
CREATE SCHEMA events;

-- Basins table
CREATE TABLE inventory.basins (
    id integer PRIMARY KEY,
    basin text NOT NULL,
    symbol varchar(3) NOT NULL,
    polygon geometry
);

-- Blocks table
CREATE TABLE inventory.blocks (
    id integer PRIMARY KEY,
    block text NOT NULL,
    basin_id integer references inventory.basins(id) NOT NULL,
    polygon geometry
);

-- Fields table
CREATE TABLE inventory.fields (
    id integer PRIMARY KEY,
    field text NOT NULL,
    block_id integer references inventory.blocks(id) NOT NULL,
    polygon geometry
);

-- Stations table
CREATE TABLE inventory.stations (
    id integer PRIMARY KEY,
    station text NOT NULL,
    point geometry
);

-- Als table
CREATE TABLE inventory.als (
    id integer PRIMARY KEY,
    als text NOT NULL
);

-- Wells table
CREATE TABLE inventory.wells (
    id integer PRIMARY KEY,
    uwi varchar(10) NOT NULL,
    well text NOT NULL,
    symbol varchar(10) NOT NULL,
    field_id integer references inventory.fields(id),
    spud_date date,
    completion_date date,
    surface_x numeric CHECK (surface_x >= 0),
    surface_y numeric CHECK (surface_x >= 0),
    epsg integer CHECK (surface_x >= 0),
    kbe numeric,
    gle numeric,
    td_md numeric CHECK (td_md >= 0),
    td_tvd numeric CHECK (td_tvd >= 0),
    classification varchar(3),
    geometry text,
    parent_id integer references inventory.wells(id),
    station_id integer references inventory.stations(id),
    point geometry
);

--Surveys Table
CREATE TABLE inventory.surveys (
    id bigint PRIMARY KEY,
    well_id integer references inventory.wells(id) NOT NULL,
    md numeric NOT NULL CHECK (md >= 0),
    inc numeric NOT NULL CHECK (inc >= 0),
    azi numeric NOT NULL CHECK (azi >= 0 AND azi <= 360),
    tvd numeric CHECK (tvd >= 0),
    tvdss numeric,
    north_offset numeric,
    east_offset numeric,
    northing numeric,
    easting numeric,
    dleg numeric,
    point geometry
);

-- Well status Table
CREATE TABLE events.wells_status (
    id bigint PRIMARY KEY,
    well_id integer NOT NULL references inventory.wells(id),
    start_date date NOT NULL CHECK (end_date >= start_date),
    end_date date NOT NULL CHECK (end_date >= start_date),
    status text NOT NULL,
    type text NOT NULL,
    als_id integer references inventory.als(id),
    work_int numeric CHECK (work_int >= 0  AND work_int <= 1),
    comment text
);

--FORMATIONS

-- Formations Table
CREATE TABLE inventory.formations (
    id integer PRIMARY KEY,
    formation text NOT NULL,
    period text NOT NULL,
    basin_id integer NOT NULL references inventory.basins(id)
);

-- formations tops
CREATE TABLE inventory.formations_tops (
    id bigint PRIMARY KEY,
    well_id integer NOT NULL references inventory.wells(id),
    formation_id integer NOT NULL references inventory.formations(id),
    md_top numeric NOT NULL,
    md_base numeric,
    tvd_top numeric,
    tvd_base numeric,
    tvdss_top numeric,
    tvdss_base numeric,
    northing numeric,
    easting numeric,
    point geometry
);

--Units table
CREATE TABLE inventory.units (
    id integer PRIMARY KEY,
    unit text NOT NULL,
    formation_id integer NOT NULL references inventory.formations(id)
);

-- Units tops
CREATE TABLE inventory.units_tops (
    id bigint PRIMARY KEY,
    well_id integer NOT NULL references inventory.wells(id),
    unit_id integer NOT NULL references inventory.formations(id),
    md_top numeric NOT NULL,
    md_base numeric,
    tvd_top numeric,
    tvd_base numeric,
    tvdss_top numeric,
    tvdss_base numeric,
    northing numeric,
    easting numeric,
    point geometry
);

-- Perforations Table
CREATE TABLE inventory.perforations (
    id bigint PRIMARY KEY,
    well_id integer NOT NULL references inventory.wells(id),
    formation_id integer references inventory.formations(id),
    unit_id integer references inventory.units(id),
    md_top numeric NOT NULL,
    md_base numeric NOT NULL,
    tvd_top numeric,
    tvd_base numeric,
    tvdss_top numeric,
    tvdss_base numeric,
    perf_date date,
    spf numeric,
    comments text
);

-- Perforations Status Table
CREATE TABLE events.perforations_status (
    id bigint PRIMARY KEY,
    perf_id bigint NOT NULL references inventory.perforations(id),
    start_date date NOT NULL CHECK (end_date >= start_date),
    end_date date NOT NULL CHECK (end_date >= start_date),
    status text,
    type text,
    comment text
);

-- Forecast table
CREATE TABLE eventsforecast (
    id bigint PRIMARY KEY,
    well_id integer NOT NULL references inventory.wells(id),
    type text NOT NULL,
    date date NOT NULL,
    bo numeric DEFAULT 0,
    bw numeric DEFAULT 0,
    gas numeric DEFAULT 0,
    probability numeric check(probability>=0 and probability<=1) default 0.5 
);

--PRODUCCTION AND INJECTION TABLES

--Injection Table
CREATE TABLE daily.injection (
    id bigint PRIMARY KEY,
    date date not null,
    well_id integer not null references inventory.wells(id),
    bipd numeric check(bipd >=0) default 0,
    thp numeric check(thp>=0),
    hrs numeric check(hrs>=0 and hrs<=24),
    formation_id integer references inventory.formations(id)
);

--Production table
CREATE TABLE daily.production (
    id bigint PRIMARY KEY,
    date date NOT NULL,
    well_id integer NOT NULL references inventory.wells(id),
    formation_id integer references inventory.formations(id),
    unit_id integer references inventory.units(id),
    bf numeric check(bf>=0) default 0,
    gas numeric check(gas>=0) default 0,
    bsw numeric check(bsw>=0 and bsw<=1),
    bo numeric check(bo>=0) default 0,
    bw numeric check(bw>=0) default 0,
    als_id integer references inventory.als(id),
    api numeric check(api>=0),
    choke_size numeric check(choke_size>=0) default 0,
    choke_ref numeric check(choke_size>=0) default 64,
    thp numeric check(thp>=0),
    chp numeric check(chp>=0),
    tht numeric,
    esp_freq numeric check(esp_freq>=0),
    hrs numeric check(hrs>=0 and hrs<=24),
    esp_pip numeric check(esp_pip >= 0),
    esp_amp numeric check(esp_amp >= 0),
    esp_temp numeric,
    hp_pinj numeric check(hp_pinj >= 0),
    hp_qinj numeric check(hp_qinj >= 0),
    bp_strokes numeric check(bp_strokes >= 0),
    bp_pip numeric check(bp_pip >= 0),
    pcp_rpm numeric check(pcp_rpm >= 0),
    pcp_amp numeric check(pcp_amp >= 0),
    pcp_torque numeric check(pcp_torque >= 0),
    comments text
);

CREATE TABLE daily.stops (
    id bigint PRIMARY KEY,
    date date not null,
    well_id integer not null references inventory.wells(id),
    hrs numeric not null check(hrs>=0 and hrs<=24),
    from_time time,
    to_time time,
    comments text,
    code bigint
);


CREATE TABLE inventory.tanks (
    id integer PRIMARY KEY,
    tank_code varchar(15) not null,
    tank text NOT NULL,
    nominal_capacity numeric,
    real_capacity numeric,
    station_id integer references inventory.stations(id)
);

CREATE TABLE daily.tanks_balance (
    id bigint PRIMARY KEY,
    date date NOT NULL,
    tank_id integer not null references inventory.tanks(id),
    estado varchar(3) not null,
    medida numeric not null check(medida >= 0),
    bls_gross numeric not null check(bls_gross >= 0),
    api_obser numeric not null check(api_obser >= 0),
    t_obser numeric not null,
    t_tk numeric not null,
    sw numeric not null check(sw >= 0 and sw <= 100),
    api_60_f numeric not null check(api_60_f >= 0),
    fac_temp numeric not null check(fac_temp >= 0),
    fac_bsw numeric not null check(fac_bsw >= 0),
    temp_ambiente numeric not null,
    fac_correc_lamina numeric not null,
    bls_netos numeric not null check(bls_netos >= 0),
    recibo numeric not null check(recibo >= 0),
    consumo numeric not null check(consumo >= 0),
    transferencia numeric not null check(transferencia >= 0),
    entrega numeric not null check(entrega >= 0)
);