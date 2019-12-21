//***********************************************************************************************************
//插入电影信息
//Movie节点属性：movie_id,title,runtime,IMDB,release_year,release_month,release_day,introduction,
//              formats,average_rating,rating_num,rate_1,rate_2,rate_3,rate_4,rate_5
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
        CREATE INDEX ON :Studio(studio_id);
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
//插入演员信息
//注：演员和导演都用节点Person来表示，这样在表示同一个人导演一些电影和演出一些电影时更符合逻辑
//Person节点基本属性:person_name(我们认为名字相同的人是同一个人)
//演员特有的属性:actor_id,staring_num,supporting_num,acting_num
        USING PERIODIC COMMIT
        LOAD CSV WITH HEADERS FROM "file:///actor_table(num).csv" AS row
        CREATE (:Person {person_name:row.actor_name, actor_id:row.actor_id, starring_num:toInteger(row.staring_num),
                supporting_num:toInteger(row.supporting_num),acting_num:toInteger(row.acting_num)});
//Added 172144 labels, created 172144 nodes, set 860720 properties, completed after 3405 ms.

//在person_name上建立索引
        CREATE INDEX ON :Person(person_name);
//Added 1 index, completed after 7 ms.
//因为建立actor和movie的联系时用到了actor_id和movie_id，所以在actor_id上建立索引
        CREATE INDEX ON :Person(actor_id);
//Added 1 index, completed after 5 ms.
//***********************************************************************************************************
//创建演员和电影的联系（实际操作中先做了演员-电影关系）
//关系ACTS_IN形如:(p:Person)-[r:ACTS_IN{}]->(m:Movie)
        USING PERIODIC COMMIT
        LOAD CSV WITH HEADERS FROM "file:///actor_movie_table1.csv" AS row
        MATCH (p:Person {actor_id: row.actor_id})
        MATCH (m:Movie {movie_id: row.movie_id})
        MERGE (p)-[r:ACTS_IN]->(m)
	ON CREATE SET r.role=
	CASE 
		WHEN row.staring='0' and row.supporting='0' THEN 0
		WHEN row.staring='1' and row.supporting='0' THEN 1
		WHEN row.staring='0' and row.supporting='1' THEN 2
		WHEN row.staring='1' and row.supporting='1' THEN 3 
	END;
//Set 624846 properties, created 624846 relationships, completed after 101685 ms.
//***********************************************************************************************************
//插入导演信息
//导演特有的属性:director_id,movie_num
        USING PERIODIC COMMIT
        LOAD CSV WITH HEADERS FROM "file:///director_table(num).csv" AS row
        MERGE (p:Person {person_name:row.director_name})
	ON CREATE SET p.director_id=row.director_id, p.movie_num=toInteger(row.movie_num);
//Added 7749 labels, created 7749 nodes, set 23247 properties, completed after 4939 ms.
	USING PERIODIC COMMIT
        LOAD CSV WITH HEADERS FROM "file:///director_table(num).csv" AS row
        MATCH (p:Person {person_name:row.director_name})
	SET p.director_id=row.director_id, p.movie_num=toInteger(row.movie_num);
//Set 20582 properties, completed after 1310 ms.
//***********************************************************************************************************
//创建导演和电影的联系
//关系DIRECTS形如:(p:Person)-[r:DIRECTS]->(m:Movie)
        USING PERIODIC COMMIT
        LOAD CSV WITH HEADERS FROM "file:///director_movie_table.csv" AS row
        MATCH (p:Person {director_id: row.director_id})
        MATCH (m:Movie {movie_id: row.movie_id})
        MERGE (p)-[r:DIRECTS]->(m);
//Created 19663 relationships, completed after 2693 ms.
//***********************************************************************************************************
//插入电影类别信息
//Genre节点属性：genre_name,movie_num
	USING PERIODIC COMMIT
        LOAD CSV WITH HEADERS FROM "file:///genre_table(num).csv" AS row
        CREATE (:Genre {genre_name:row.genre_name, movie_num:toInteger(row.movie_num)});
//Added 31 labels, created 31 nodes, set 62 properties, completed after 480 ms.

//在genre_name上建立索引
	CREATE INDEX ON :Genre(genre_name)
//Added 1 index, completed after 17 ms.

//创建类别和电影的联系
//关系IS_GENRE形如:(m:Movie)-[r:IS_GENRE]->(g:GENRE)
	USING PERIODIC COMMIT
        LOAD CSV WITH HEADERS FROM "file:///genre_movie_table.csv" AS row
        MATCH (g:Genre {genre_name: row.genre_name})
        MATCH (m:Movie {movie_id: row.movie_id})
        MERGE (m)-[r:IS_GENRE]->(g);
//Created 38623 relationships, completed after 15676 ms.
//***********************************************************************************************************
//插入评论信息，同时创建用户写评论、电影拥有评论的关系
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///user_movie_table_new_new.csv" AS row
MATCH (m:Movie{movie_id: row.movie_id})
MATCH (u:User {user_id:row.user_id})
MERGE (u)-[r:WRITES_COMMENT]->(c:Comment)<-[r2:HAS_COMMENT]-(m)
ON CREATE SET c.content=row.content,c.summary=row.summary,c.timestamp=row.timestamp,c.score=toFloat(row.score),
     c.likeNum=toInteger(row.likeNum),c.unlikeNum=toInteger(row.unlikeNum);
//Added 5024040 lables, created 5024040 nodes, set 15054587 properties, created 10048080 relationships, completed after 12013849 ms.
