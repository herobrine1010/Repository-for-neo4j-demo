//查找在Alfred导演的电影中演出过的演员
{   
  "query":"MATCH (p1:Person{name:{person_name}})-[r1:DIRECTS]->(m:Movie)<-[r2:ACTS_IN]-(p2:Person) RETURN p2.name",   
	"params":{   
		"person_name":"Alfred"   
	}	   
} 

//查找在Alfred导演的电影中作为主演/配角演出的演员
{   
  "query":"MATCH (p1:Person{name:{person_name}})-[r1:DIRECTS]->(m:Movie)<-[r2:ACTS_IN{role:{role}}]-(p2:Person) RETURN p2.name",   
	"params":{   
		"person_name":"Alfred",
    "role":"star/support"
	}	   
} 

//查找和Alfred一起导演过电影的导演
{   
  "query":"MATCH (p1:Person{name:{person_name}})-[r1:DIRECTS]->(m:Movie)<-[r2:DIRECTS]-(p2:Person) RETURN p2.name",   
	"params":{   
		"person_name":"Alfred",
    	"role":"star"
	}	   
} 

//查找Alfred演出过的电影中作为主演/配角演出的演员
{   
  "query":"MATCH (p1:Person{name:{person_name}})-[r1:ACTS_IN]->(m:Movie)<-[r2:ACTS_IN{role:{role}}]-(p2:Person) RETURN p2.name",   
	"params":{   
		"person_name":"Alfred",
    "role":"star/support"
	}	   
} 

//查找Alfred作为主演/配角演出过的电影中作为主演/配角演出过的演员
{   
  "query":"MATCH (p1:Person{name:{person_name}})-[r1:ACTS_IN{role:{role1}}]->(m:Movie)<-[r2:ACTS_IN{role:{role2}}]-(p2:Person) RETURN p2.name",   
	"params":{   
		"person_name":"Bob",
    	"role1":"star",
    	"role2":"support"
	}	   
} 

//查找与Alfred共同参与演出某部电影的演员
{   
  "query":"MATCH (p1:Person{name:{person_name}})-[r1:ACTS_IN]->(m:Movie)<-[r2:ACTS_IN]-(p2:Person) RETURN p2.name",   
	"params":{   
		"person_name":"Alfred"   
	}	   
} 

//查找导演过Alfred演出过的电影的导演
{   
  "query":"MATCH (p1:Person)-[r1:DIRECTS]->(m:Movie)<-[r2:ACTS_IN]-(p2:Person{name:{person_name}}) RETURN p1.name",   
	"params":{   
		"person_name":"Alfred"   
	}	   
} 

//查找导演过Alfred作为主演/配角演出过的电影的导演
{   
  "query":"MATCH (p1:Person})-[r1:DIRECTS]->(m:Movie)<-[r2:ACTS_IN{role:{role}}]-(p2:Person{name:{person_name}) RETURN p1.name",   
	"params":{   
		"person_name":"Alfred",
    "role":"star/support"
	}	   
} 


https://my.oschina.net/u/3847203/blog/1818128
