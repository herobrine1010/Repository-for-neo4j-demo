//***********************************************************************************************************
//插入电影信息
//Movie节点属性：movie_id,title,runtime,IMDB,release_year,release_month,release_day,introduction,
//              formats,average_rating,rating_num,rate_1,rate_2,rate_3,rate_4,rate_5.
//@cypher start
        USING PERIODIC COMMIT
        LOAD CSV WITH HEADERS FROM "file:///movie_table.csv" AS row
        CREATE (:Movie {movie_id: row.movie_id, title: row.title, runtime: row.runtime, IMDB: row.IMDB,
                        release_year:toInteger(row.release_year), release_month:toInteger(row.release_month), 
                        release_day:toInteger(row.release_day),introduction: row.introduction, 
                        formats:row.formats, average_rating:toFloat(row.average_rating),
                        rating_num:toInteger(row.rating_num), rate_1:toFloat(row.rate_5), 
                        rate_2:toFloat(row.rate_4), rate_3:toFloat(row.rate_3),
                        rate_4:toFloat(row.rate_2), rate_5:toFloat(row.rate_1)});
//Added 173405 labels, created 173405 nodes, set 2392539 properties, completed after 7328 ms.

//在movie_id上增加索引
        CREATE INDEX ON :Movie(movie_id);
//Added 1 index, completed after 2 ms.
//***********************************************************************************************************
//插入工作室信息
//Studio节点属性：studio_id,studio_name,movie_num
        USING PERIODIC COMMIT
        LOAD CSV WITH HEADERS FROM "file:///studio_table(num).csv" AS row
        CREATE (:Studio {studio_id:row.studio_id, studio_name:row.studio_name, movie_num:toInteger(row.movie_num)});
//Added 13371 labels, created 13371 nodes, set 40093 properties, completed after 250 ms.

//在studio_id上增加索引
        CREATE INDEX ON :Studio(studio_id)
//Added 1 index, completed after 2 ms.
//***********************************************************************************************************
//创建工作室和电影的联系
//关系PRODUCES形如:(st:Studio)-[r:PRODUCES]->(m:Movie)
        USING PERIODIC COMMIT
        LOAD CSV WITH HEADERS FROM "file:///studio_movie_table.csv" AS row
        MATCH (st:Studio {studio_id: row.studio_id})
        MATCH (m:Movie {movie_id: row.movie_id})
        MERGE (st)-[r:PRODUCES]->(m);
//Created 157323 relationships, completed after 15839 ms.
//***********************************************************************************************************
//插入电影类别信息
//Genre节点属性：


