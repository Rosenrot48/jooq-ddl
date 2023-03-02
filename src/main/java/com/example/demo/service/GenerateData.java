package com.example.demo.service;

import org.jooq.Query;
import org.jooq.SQLDialect;
import org.jooq.Schema;
import org.jooq.impl.DSL;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import javax.sql.DataSource;
import java.sql.SQLException;
import java.util.logging.Logger;
import java.util.stream.Collectors;

@Service
public class GenerateData {

    Logger logger = Logger.getLogger(GenerateData.class.getName());


    private final DataSource dataSource;

    public GenerateData(@Qualifier("dataSource") DataSource dataSource) {
        this.dataSource = dataSource;
    }


    @PostConstruct
    public void execute() {


//        var view = dataSource.getConnection().getMetaData().getTables(null, null, null ,new String[]{"VIEW"});


        var context = DSL.using(dataSource, SQLDialect.POSTGRES);
        var schemas = context.meta().getSchemas().stream().filter(schema -> !schema.getName().startsWith("pg_") && !schema.getName().startsWith("information")).collect(Collectors.toList());

        for (Schema schema: schemas) {
            var queries = context.meta(schema).ddl();
            for (Query query : queries) {
                logger.info("Result query: " + query);
            }
        }
    }


}
