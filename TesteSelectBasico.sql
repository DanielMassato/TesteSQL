--1)
go 
use Concessionaria
 
select COUNT(*) from VendasAnuais
select COUNT(*) from Veiculo
select COUNT(*) from Modelo
select COUNT(*) from Fabricante
select COUNT(*) from Mes
select COUNT(*) from AnoFabricacao


--2)
go 
use Concessionaria
 
declare @VendasAnuais int=0, @Veiculo smallint=0, @Modelo tinyint=0, @Fabricante tinyint=0, @Mes tinyint=0, @AnoFabricacao tinyint=0   
select @VendasAnuais=COUNT(*) from VendasAnuais
select @Veiculo=COUNT(*) from Veiculo
select @Modelo=COUNT(*) from Modelo
select @Fabricante=COUNT(*) from Fabricante
select @Mes=COUNT(*) from Mes
select @AnoFabricacao = COUNT(*) from AnoFabricacao
select @VendasAnuais as VendasAnuais ,@Veiculo as Veiculo, @Modelo as Modelo, @Fabricante Fabricante, @Mes as Mes
,@AnoFabricacao as AnoFabricacao

--3) 

go 
use Concessionaria
 
declare @VendasAnuais int=0, @Veiculo smallint=0, @Modelo tinyint=0, @Fabricante tinyint=0, @Mes tinyint=0, @AnoFabricacao tinyint=0   
select @VendasAnuais=COUNT(*) from VendasAnuais
select @Veiculo=COUNT(*) from Veiculo
select @Modelo=COUNT(*) from Modelo
select @Fabricante=COUNT(*) from Fabricante
select @Mes=COUNT(*) from Mes
select @AnoFabricacao = COUNT(*) from AnoFabricacao
declare @TotalTabelas table(TotalVendasAnuais int, TotalVeiculo int, TotalModelo tinyint, TotalFabricante tinyint, TotalMes tinyint, TotalAnoFabricacao tinyint )
insert into @TotalTabelas values(@VendasAnuais, @Veiculo, @Modelo, @Fabricante,@Mes,@AnoFabricacao)
select * from @TotalTabelas

--4) 
go 
use Concessionaria
 
declare @TotalTabelas table(TotalVendasAnuais int, TotalVeiculo smallint, TotalModelo tinyint, TotalFabricante tinyint, TotalMes tinyint, TotalAnoFabricacao tinyint )
insert into @TotalTabelas values(  (select COUNT(*) from VendasAnuais), (select COUNT(*) from Veiculo), (select COUNT(*) from Modelo),(select COUNT(*) from Fabricante),(select COUNT(*) from Mes),(select COUNT(*) from AnoFabricacao));
select * from @TotalTabelas



--5)
go
USE Concessionaria
declare @1 smallint = 0, @2 smallint =0 ,@3 smallint = 0,@4 smallint =0,@5 smallint =0,@6 smallint=0, @oid int = -2147483648, @aux decimal = 0 

while exists(select   *  from Veiculo where idVeiculo > @oid )
Begin
select  @oid = min(idVeiculo)   from Veiculo   where idVeiculo > @oid
select @aux = valor from Veiculo where idVeiculo = @oid 
   if      @aux <= 6000.00  set @1 +=1 
   if     @aux > 6000.00  and  @aux <= 10000.00  set @2 +=1
   if     @aux > 10000.00 and  @aux <= 20000.00  set @3 +=1
   if     @aux > 20000.00 and  @aux <= 30000.00  set @4 +=1
   if     @aux > 30000.00 and  @aux <= 40000.00  set @5 +=1
   if @aux > 40000set @6 +=1    
End

select @1 as [1.até R$ 6.000,00],@2 as [2.De R$ 6.000,01 até 10.000,00],@3 as [3.De R$ 10.000,01 até 20.000,00],@4 as [4.De R$ 20.000,01 até 30.000,00],@5 as [5.De R$ 30.000,01 até 40.000,00],@6 as [6.Maior que R$ 4.000,00 ]

--6)

go 
use Concessionaria
 
Create Table #TpDBVend
(
	Ano tinyint,
	Mes tinyint,
	Qtd int
)

declare @ano int =0,@mes int =0,@qtd int =0,@qtd_total int =0, @vid int = -2147483648

while exists(select   *  from VendasAnuais where idVendas > @vid )
Begin
		select  @vid = min(idVendas) from VendasAnuais   where idVendas > @vid 
		select   @ano = idAno, @mes = idMes, @qtd = qtd from VendasAnuais   where idVendas = @vid 
			set @qtd_total = 0				
					
		 if ( exists(select * from #TpDBVend where Ano=@ano  and Mes = @mes  ))
				begin
					select @qtd_total = Qtd  from #TpDBVend where Ano = @ano and Mes = @mes
					set @qtd_total = @qtd_total+  @qtd
					update  #TpDBVend set Qtd = @qtd_total where  Ano =@ano  and  Mes = @mes 
				
				end
		 else
		 begin 
		
			insert into #TpDBVend values ( @ano, @mes,  @qtd);
			
			--select @ano,@mes,@qtd
			
	     end
	end


select * from #TpDBVend order by Ano, Mes, Qtd



--7)
go 
use Concessionaria
 
--declare @1 smallint = 0, @2 smallint =0 ,@3 smallint = 0,@4 smallint =0,@5 smallint =0,@6 smallint=0, @oid int = -2147483648, @aux table(Faixa varchar(20)) 

3select   COUNT(*),case    when     valor <= 6000.00  then  '1.até R$ 6.000,00'
   when     valor > 6000.00  and  valor <= 10000.00  then '2.De R$ 6.000,01 até 10.000,00'
   when     valor > 10000.00 and  valor <= 20000.00  then '3.De R$ 10.000,01 até 20.000,00'
   when     valor > 20000.00 and  valor <= 30000.00  then '4.De R$ 20.000,01 até 30.000,00'
   when     valor > 30000.00 and  valor <= 40000.00  then '5.De R$ 30.000,01 até 40.000,00'
     else  '5.De R$ 30.000,01 até 40.000,00' end as Faixa
   from Veiculo 
   
   group by (case    when     valor <= 6000.00  then  '1.até R$ 6.000,00'
   when     valor > 6000.00  and  valor <= 10000.00  then '2.De R$ 6.000,01 até 10.000,00'
   when     valor > 10000.00 and  valor <= 20000.00  then '3.De R$ 10.000,01 até 20.000,00'
   when     valor > 20000.00 and  valor <= 30000.00  then '4.De R$ 20.000,01 até 30.000,00'
   when     valor > 30000.00 and  valor <= 40000.00  then '5.De R$ 30.000,01 até 40.000,00'
     else  '5.De R$ 30.000,01 até 40.000,00' end)    


select * from VendasAnuais

--8)
go 
use Concessionaria
 

select   idAno, idMes, count(qtd) as quantidade from VendasAnuais group by idAno, idMes
having count(qtd) < 3

--10)
go 
use Concessionaria
 
select idVeiculo, qtd,(select V.descricao from Veiculo as V where V.idVeiculo = Maximo.idVeiculo ) as descricao, 
(select V.valor from Veiculo as V where V.idVeiculo = Maximo.idVeiculo ) * qtd as valorTotal   
from(select top 3 idVeiculo, sum(qtd) as qtd from VendasAnuais group by idVeiculo order by qtd desc) as Maximo
union
select idVeiculo, qtd,(select V.descricao from Veiculo as V where V.idVeiculo = Minimo.idVeiculo ) as descricao, 
(select V.valor from Veiculo as V where V.idVeiculo = Minimo.idVeiculo ) * qtd as valorTotal 
 from(select top 2 idVeiculo, sum(qtd) as qtd from VendasAnuais group by idVeiculo order by qtd asc)  as Minimo 
order by qtd


--11)
go 
use Concessionaria
 

with CTE_MAX AS
(select top 5 idVeiculo, sum(qtd) as qtd from VendasAnuais group by idVeiculo order by qtd desc),
CTE_VALOR_DESCR AS (select valor, idVeiculo,descricao from Veiculo ),
 CTE_MIN AS
(select top 3 idVeiculo, sum(qtd) as qtd from VendasAnuais group by idVeiculo order by qtd asc)

select CTE_MAX.idVeiculo,CTE_VALOR_DESCR.descricao ,CTE_MAX.qtd, CTE_VALOR_DESCR.valor * CTE_MAX.qtd as ValorTotal 
From CTE_MAX,CTE_VALOR_DESCR where CTE_MAX.idVeiculo =CTE_VALOR_DESCR.idVeiculo

UNION

select CTE_MIN.idVeiculo,CTE_VALOR_DESCR.descricao ,CTE_MIN.qtd, CTE_VALOR_DESCR.valor * CTE_MIN.qtd as ValorTotal 
From CTE_MIN,CTE_VALOR_DESCR where CTE_MIN.idVeiculo =CTE_VALOR_DESCR.idVeiculo


select * from VendasAnuais order by qtd asc  