-- Init tables for Oil and Gas DataBase
-- 

--Create schemas to differentiate tables that updates daily

CREATE SCHEMA list;
CREATE SCHEMA daily;
CREATE SCHEMA events;

-- Basins table
CREATE TABLE list.basins (
    id integer PRIMARY KEY,
    basin text NOT NULL,
    symbol varchar(3) NOT NULL,
    polygon geometry
);

-- Blocks table
CREATE TABLE list.blocks (
    id integer PRIMARY KEY,
    block text NOT NULL,
    basin_id integer references list.basins(id) NOT NULL,
    polygon geometry
);

-- Fields table
CREATE TABLE list.fields (
    id integer PRIMARY KEY,
    field text NOT NULL,
    block_id integer references list.blocks(id) NOT NULL,
    polygon geometry
);

-- Stations table
CREATE TABLE list.stations (
    id integer PRIMARY KEY,
    station text NOT NULL,
    point geometry
);

-- Als table
CREATE TABLE list.als (
    id integer PRIMARY KEY,
    als text NOT NULL
);

-- Wells table
CREATE TABLE list.wells (
    id integer PRIMARY KEY,
    uwi varchar(10) NOT NULL,
    well text NOT NULL,
    symbol varchar(10) NOT NULL,
    field_id integer references list.fields(id),
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
    parent_id integer references list.wells(id),
    station_id integer references list.stations(id),
    point geometry
);

--Surveys Table
CREATE TABLE list.surveys (
    id bigint PRIMARY KEY,
    well_id integer references list.wells(id) NOT NULL,
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
    well_id integer NOT NULL references list.wells(id),
    start_date date NOT NULL CHECK (end_date >= start_date),
    end_date date NOT NULL CHECK (end_date >= start_date),
    status text NOT NULL,
    type text NOT NULL,
    als_id integer references list.als(id),
    work_int numeric CHECK (work_int >= 0  AND work_int <= 1),
    comment text
);

--FORMATIONS

-- Formations Table
CREATE TABLE list.formations (
    id integer PRIMARY KEY,
    formation text NOT NULL,
    period text NOT NULL,
    basin_id integer NOT NULL references list.basins(id)
);

-- formations tops
CREATE TABLE list.formations_tops (
    id bigint PRIMARY KEY,
    well_id integer NOT NULL references list.wells(id),
    formation_id integer NOT NULL references list.formations(id),
    md_top numeric NOT NULL,
    md_bottom numeric,
    tvd_top numeric,
    tvd_bottom numeric,
    tvdss_top numeric,
    tvdss_bottom numeric,
    northing numeric,
    easting numeric,
    point geometry
);

--Units table
CREATE TABLE list.units (
    id integer PRIMARY KEY,
    unit text NOT NULL,
    formation_id integer NOT NULL references list.formations(id),
    field_id integer not null references list.fields(id)
);

-- Units tops
CREATE TABLE list.units_tops (
    id bigint PRIMARY KEY,
    well_id integer NOT NULL references list.wells(id),
    unit_id integer NOT NULL references list.units(id),
    md_top numeric NOT NULL,
    md_bottom numeric,
    tvd_top numeric,
    tvd_bottom numeric,
    tvdss_top numeric,
    tvdss_bottom numeric,
    northing numeric,
    easting numeric,
    point geometry
);

-- Perforations Table
CREATE TABLE list.perforations (
    id bigint PRIMARY KEY,
    well_id integer NOT NULL references list.wells(id),
    formation_id integer references list.formations(id),
    unit_id integer references list.units(id),
    md_top numeric NOT NULL,
    md_bottom numeric NOT NULL,
    tvd_top numeric,
    tvd_bottom numeric,
    tvdss_top numeric,
    tvdss_bottom numeric,
    perf_date date,
    spf numeric,
    comments text,
    easting numeric,
    northing numeric,
    point geometry
);

-- Perforations Status Table
CREATE TABLE events.perforations_status (
    id bigint PRIMARY KEY,
    perf_id bigint NOT NULL references list.perforations(id),
    start_date date NOT NULL CHECK (end_date >= start_date),
    end_date date NOT NULL CHECK (end_date >= start_date),
    status text,
    type text,
    comment text
);

-- Forecast table
CREATE TABLE events.forecast (
    id bigint PRIMARY KEY,
    well_id integer NOT NULL references list.wells(id),
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
    well_id integer not null references list.wells(id),
    bipd numeric check(bipd >=0) default 0,
    thp numeric check(thp>=0),
    hrs numeric check(hrs>=0 and hrs<=24),
    formation_id integer references list.formations(id)
);

--Production table
CREATE TABLE daily.production (
    id bigint PRIMARY KEY,
    date date NOT NULL,
    well_id integer NOT NULL references list.wells(id),
    formation_id integer references list.formations(id),
    unit_id integer references list.units(id),
    bf numeric check(bf>=0) default 0,
    gas numeric check(gas>=0) default 0,
    bsw numeric check(bsw>=0 and bsw<=1),
    bo numeric check(bo>=0) default 0,
    bw numeric check(bw>=0) default 0,
    als_id integer references list.als(id),
    api numeric check(api>=0),
    choke_size numeric check(choke_size>=0),
    choke_ref numeric check(choke_size>=0),
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
    well_id integer not null references list.wells(id),
    hrs numeric not null check(hrs>=0 and hrs<=24),
    from_time time,
    to_time time,
    comments text,
    code bigint
);


CREATE TABLE list.tanks (
    id integer PRIMARY KEY,
    tank_code varchar(15) not null,
    tank text NOT NULL,
    nominal_capacity numeric,
    real_capacity numeric,
    station_id integer references list.stations(id)
);

CREATE TABLE daily.tanks_balance (
    id bigint PRIMARY KEY,
    date date NOT NULL,
    tank_id integer not null references list.tanks(id),
    estado varchar(20) not null,
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

-- Static pressure table
CREATE TABLE events.static_pressure (
    id bigint PRIMARY KEY,
    date date not null,
    well_id integer not null references list.wells(id),
    pressure_datum numeric not null,
    formation_id integer not null references list.formations(id),
    unit_id integer references list.units(id)
);

-- Surface Pumps Equipment
CREATE TABLE list.surface_pumps (
    id integer PRIMARY KEY,
    pump varchar(10) not null,
    station_id integer not null references list.stations(id),
    brand text
);

CREATE TABLE daily.pumps_parameters (
    id serial PRIMARY KEY,
    datetime timestamp not null,
    pump_id integer not null references list.surface_pumps(id),
    freq numeric check(freq >= 0),
    suction_pressure numeric check(suction_pressure >= 0),
    discharge_pressure numeric check(discharge_pressure >= 0)
);

-- Separators Equipment
CREATE TABLE list.separators (
    id integer PRIMARY KEY,
    separator varchar(15) not null,
    station_id integer not null references list.stations(id),
    capacity text
);


CREATE TABLE daily.separators_parameters (
    id serial PRIMARY KEY,
    datetime timestamp not null,
    separator_id integer not null references list.separators(id),
    static_pressure numeric check(static_pressure >= 0),
    diff_pressure numeric,
    tem_gas numeric,
    prod_gas numeric
);


-- Wells Parameters
CREATE TABLE daily.wells_parameters (
    id serial PRIMARY KEY,
    datetime timestamp not null,
    well_id integer not null references list.wells(id),
    thp numeric check(thp >= 0),
    chp numeric check(chp >= 0),
    hp_qinj numeric check(hp_qinj >= 0),
    esp_freq numeric check(esp_freq >= 0),
    esp_pip numeric check(esp_pip >= 0),
    esp_amp numeric check(esp_amp >= 0),
    esp_temp numeric check(esp_temp >= 0),
    pcp_rpm numeric check(pcp_rpm >= 0),
    pcp_amp numeric check(pcp_amp >= 0),
    pcp_torque numeric check(pcp_torque >= 0),
    gas_flow numeric check(gas_flow >=0),
    choke_size numeric check(choke_size>=0),
    choke_ref numeric check(choke_size>=0)
);

-- Despachos

CREATE TABLE daily.trucks (
    tiquete bigint PRIMARY KEY,
    date date not null,
    guia text not null,
    placa_vehiculo varchar(6) not null,
    placa_trailer varchar(7) not null,
    nombre_conductor text not null,
    cedula numeric not null,
    empresa text not null,
    origen_id integer not null references list.stations(id),
    destino_id integer not null references list.stations(id),
    cliente text not null,
    bbls_bts numeric not null,
    bbls_nts numeric not null,
    sello_1 bigint,
    sello_2 bigint,
    sello_3 bigint,
    sello_4 bigint,
    sello_5 bigint,
    sello_6 bigint,
    sello_7 bigint,
    presintos text,
    api_60_f numeric,
    bsw numeric,
    temp_f numeric,
    factor_volumetrico numeric,
    factor_bsw numeric,
    sal_lbs_1000_bls numeric
);

CREATE TABLE daily.gas_plant (
    id serial PRIMARY KEY,
    datetime timestamp not null,
    pressure_manifold numeric check(pressure_manifold >= 0),
    pressure_plant numeric check(pressure_plant >= 0),
    gas_flow numeric check(gas_flow >= 0),
    pressure_tgi numeric check(pressure_tgi >= 0)
);
