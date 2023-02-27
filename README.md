# Demo project with issue on exporting ddl for view via JOOQ

### JOOQ Usage

```java

import org.springframework.stereotype.Service;

@Service
public class Demo {

    private final DataSource dataSource;

    public GenerateData(@Qualifier("dataSource") DataSource dataSource) {
        this.dataSource = dataSource;
    }


    @PostConstruct
    public void execute() {
        var context = DSL.using(dataSource, SQLDialect.POSTGRES);
        var queries = context.meta().ddl();
        for (Query query : queries) {
            logger.info("Result query: " + query);
        }
    }

}

```


### Expected result

Something like this

create view "public"."demo_description"(
"id",
"name",
"description"
)
as (SELECT de.id,
de.name,
ds.text AS description
FROM demo de
JOIN description ds ON ds.id = de.id;)



### Actual result

2023-02-27 17:13:42.513  INFO 87359 --- [           main] com.example.demo.service.GenerateData    : Result query: create view "public"."demo_description"(
"id",
"name",
"description"
)
as
