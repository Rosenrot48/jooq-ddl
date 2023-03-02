select t.*, array_to_string(analyzer_models, '; ') as analyzer_models_search, array_to_string(t.test_tags,'; ') as test_tags_search
from
    (select
         ot.id,
         ot.catalog_id,
         olc.name as catalog,
         ot.is_active,
         ot.is_real,
         ot.updated_at,
         ot.analyte_id,
         ot.analyzer_id,
         ot.biomaterial_id,
         ot.reagent_id,
         gt.code::varchar(12) as guc_code,
         oat.code as analyte_code,
         oat.name as analyte_name,
         ob.name as biomaterial_name,
         case when ore.manufacturer is null then gmr.name else ore.manufacturer end  as reagent_manufacturer,
         case when ore.name is null then gr.full_name else ore.name end  as reagent_full_name,
         gat.full_name as guc_analyte_full_name,
         gb.full_name as guc_biomaterial_full_name,
         gmaz.name as guc_analyzer_manufacturer,
         gazf.name as guc_analyzer_family,
         gmr.name as guc_reagent_manufacturer,
         gr.full_name as guc_reagent_full_name,
         array (select oam.name from omni_catalog.omc_analyzer_analyzer_models oaam
                                         inner join omni_catalog.omc_analyzer_models oam on oam.id = oaam.model_id
                where oaam.analyzer_id = ot.analyzer_id ) as analyzer_models,
         array (select ott.name from omni_catalog.omc_test_test_tags ottt
                                         inner join omni_catalog.omc_test_tags ott on ott.id = ottt.tag_id
                where ottt.test_id = ot.id ) as test_tags

     from omni_catalog.omc_tests ot
              inner join omni_catalog.omc_local_catalogs olc on olc.id = ot.catalog_id
              inner join omni_catalog.omc_analytes oat on oat.id = ot.analyte_id
              inner join omni_catalog.omc_analyzers oaz on oaz.id = ot.analyzer_id
              inner join omni_catalog.omc_biomaterials ob on ob.id = ot.biomaterial_id
              inner join omni_catalog.omc_reagents ore on ore.id = ot.reagent_id
              inner join unified_catalog.guc_analytes gat on gat.id = oat.guc_id
              inner join unified_catalog.guc_analyzers gaz on gaz.id = oaz.guc_id
              inner join unified_catalog.guc_biomaterials gb on gb.id = ob.guc_id
              inner join unified_catalog.guc_reagents gr on gr.id = ore.guc_id
              left join unified_catalog.guc_tests gt
                        on gt.analyte_id = oat.guc_id and gt.analyzer_id = oaz.guc_id
                            and  gt.biomaterial_id = ob.guc_id and gt.reagent_id = ore.guc_id
              inner join unified_catalog.guc_manufacturers gmr on gmr.id = gr.manufacturer_id
              inner join unified_catalog.guc_manufacturers gmaz on gmaz.id = gaz.manufacturer_id
              inner join unified_catalog.guc_analyzer_families gazf on gazf.id = gaz.family_id) t
;
