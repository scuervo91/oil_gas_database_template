-- Init tables for Oil and Gas DataBase
-- 

-- Basins table
CREATE TABLE basins (
    id integer PRIMARY KEY,
    basin text,
    symbol varchar(3),
    polygon geometry
)

-- Blocks table
CREATE TABLE blocks (
    id integer PRIMARY KEY,
    block text,
    basin_id integer references basins(id),
    polygon geometry
)

-- Fields table
CREATE TABLE fields (
    id integer PRIMARY KEY,
    field text,
    block_id integer references blocks(id),
    polygon geometry
)

-- Stations table
CREATE TABLE stations (
    id integer PRIMARY KEY,
    station text,
    point geometry
)

-- Als table
CREATE TABLE als (
    id integer PRIMARY KEY,
    als text
)

-- Wells table
CREATE TABLE wells (
    id integer PRIMARY KEY,
    uwi varchar(10),
    well text,
    symbol varchar(10),
    field_id integer references fields(id),
    spud_date date,
    completion_date date,
    surface_x numeric,
    surface_y numeric,
    epsg integer,
    kbe numeric,
    gle numeric,
    td_md numeric,
    td_tvd numeric,
    classification varchar(2),
    geom text,
    parent_id integer references wells(id),
    point geometry
)

--Surveys Table
CREATE TABLE surveys (
    id bigint PRIMARY KEY,
    well_id integer references well(id),
    md numeric,
    inc numeric,
    azi numeric,
    tvd numeric,
    tvdss numeric,
    north_offset numeric,
    east_offset numeric,
    northing numeric,
    easting numeric,
    dleg numeric,
    point geometry
)

-- Well status Table
CREATE TABLE wells_status (
    id bigint PRIMARY KEY,
    well_id integer references well(id),
    start_date date,
    end_date date,
    status text,
    type text,
    als_id integer references als(id),
    work_int numeric,
    comment text
)

--FORMATIONS

-- Formations Table
CREATE TABLE formations (
    id integer PRIMARY KEY,
    formation text,
    period text,
    basin_id integer references basins(id)
)

-- formations tops
CREATE TABLE formations_tops (
    id bigint PRIMARY KEY,
    well_id integer references wells(id),
    formation_id integer references formations(id),
    md_top numeric,
    md_base numeric,
    tvd_top numeric,
    tvd_base numeric,
    tvdss_top numeric,
    tvdss_base numeric,
    northing numeric,
    easting numeric,
    point geometry
)

--Units table
CREATE TABLE units (
    id integer PRIMARY KEY,
    unit text,
    formation_id integer references formations(id)
)

-- Units tops
CREATE TABLE units_tops (
    id bigint PRIMARY KEY,
    well_id integer references wells(id),
    unit_id integer references formations(id),
    md_top numeric,
    md_base numeric,
    tvd_top numeric,
    tvd_base numeric,
    tvdss_top numeric,
    tvdss_base numeric,
    northing numeric,
    easting numeric,
    point geometry
)

-- Perforations Table
CREATE TABLE perforations (
    id bigint PRIMARY KEY,
    well_id integer references wells(id),
    formation_id integer references formations(id),
    unit_id integer references units(id),
    md_top numeric,
    md_base numeric,
    tvd_top numeric,
    tvd_base numeric,
    tvdss_top numeric,
    tvdss_base numeric,
    perf_date date,
    spf numeric,
    comments text
)

-- Perforations Status Table
CREATE TABLE perforations_status (
    id bigint PRIMARY KEY,
    perf_id bigint references perforations(id),
    start_date date,
    end_date date,
    status text,
    type text
)

-- Forecast table
CREATE TABLE forecast (
    id bigint PRIMARY KEY,
    well_id integer references wells(id),
    type text,
    date date,
    bo numeric,
    bw numeric,
    gas numeric,
    probability numeric
)

--PRODUCCTION AND INJECTION TABLES

--Injection Table
CREATE TABLE injection (
    id bigint PRIMARY KEY,
    date date,
    well_id integer references wells(id),
    bipd numeric,
    thp numeric,
    hrs numeric,
    formation_id integer references formations(id)
)

--Production table
CREATE TABLE production (
    id bigint PRIMARY KEY,
    date date,
    well_id integer references wells(id),
    formation_id integer references formations(id),
    unit_id integer references units(id),
    bf numeric,
    gas numeric,
    bsw numeric,
    bo numeric,
    bw numeric,
    als_id integer references als(id),
    api numeric
    choke numeric,
    thp numeric,
    chp numeric,
    tht numeric,
    esp_freq numeric,
    hrs numeric,
    esp_pip numeric,
    esp_amp numeric,
    esp_temo numeric,
    hp_pinj numeric,
    hp_qinj numeric,
    bp_strokes numeric,
    bp_pip numeric,
    pcp_rpm numeric,
    pcp_amp numeric,
    pcp_torque numeric,
    comments text
)
