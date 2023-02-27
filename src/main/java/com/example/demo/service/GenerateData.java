package com.example.demo.service;

import org.jooq.Query;
import org.jooq.SQLDialect;
import org.jooq.impl.DSL;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import javax.sql.DataSource;
import java.util.logging.Logger;

@Service
public class GenerateData {

    Logger logger = Logger.getLogger(GenerateData.class.getName());


    private final DataSource dataSource;

    public GenerateData(@Qualifier("dataSource") DataSource dataSource) {
        this.dataSource = dataSource;
    }



    @PostConstruct
    public void execute() {
        var context = DSL.using(dataSource, SQLDialect.POSTGRES);
        var queries = context.meta().ddl();
        for (Query query: queries) {
            logger.info("Result query: " + query);
        }
    }


}
