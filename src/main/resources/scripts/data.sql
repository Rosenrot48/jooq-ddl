create table if not exists demo(id uuid, name varchar);
create table if not exists  description(id uuid, text varchar);
create or replace view demo_description(id, name, description) as select de.id as id,  de.name as name, ds.text as text from demo de inner join description ds on ds.id = de.id;
