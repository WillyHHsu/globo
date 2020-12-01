1
with tabela as (
	SELECT A.id_user, A.id_conteudo, A.data, A.horas_consumidas
  			,B.conteudo ,B.categoria
  	from consumo A 
  	LEFT JOIN categorias B 
  		on A.id_conteudo = B.id_conteudo)

 SELECT COALESCE(categoria,'desconhecido')
 		, sum(horas_consumidas) as horas_consumidas
		, count(1) as plays 
 FROM tabela
 GROUP BY categoria
 
-----------------------------------------------------------------------
2
with tabela as (
	SELECT A.id_user, A.id_conteudo, A.data, A.horas_consumidas
  			,B.conteudo ,B.categoria
  	from consumo A 
  	LEFT JOIN categorias B 
  		on A.id_conteudo = B.id_conteudo)
 

  select  id_conteudo,categoria,sum(horas_consumidas) as tempo,month(data) as mes
  ,row_number() over (partition by month(data) order by sum(horas_consumidas)  desc) rn
  from tabela
  group by id_conteudo, month(data),categoria
  having categoria = 'novela'
  order by month(data)

-----------------------------------------------------------------------
3
with tabela as (
	SELECT A.id_user, A.id_conteudo, A.data, A.horas_consumidas
  			,B.conteudo ,B.categoria
  	from consumo A 
  	LEFT JOIN categorias B 
  		on A.id_conteudo = B.id_conteudo)


select * 
from(
  SELECT id_user
  		,id_conteudo
          ,coalesce(conteudo,'?') as conteudo
          ,coalesce(categoria,'?') as categoria
          ,rank() OVER (PARTITION BY id_user
              ORDER BY data DESC) as rn

  FROM tabela) X
WHERE x.RN =1

-----------------------------------------------------------------------
4.

select 
concat(id_user,id_conteudo) as id
,id_user
,horas_consumidas*60
from consumo

-----------------------------------------------------------------------
5.

with tabela as (
	SELECT A.id_user, A.id_conteudo, A.data, A.horas_consumidas
  			,B.conteudo ,B.categoria
  	from consumo A 
  	LEFT JOIN categorias B 
  		on A.id_conteudo = B.id_conteudo)
 
select id_user, categoria,contagem, rn
from(
  select id_user, categoria, count(1) as contagem, row_number() over (partition by id_user order by count(1)  desc) rn
  from tabela
  group by id_user,categoria) X
where rn = 1
