use TSQL2012
--Criação da tabela
Create table TBL_CTRL_ACESSO (
login VARCHAR primary key ,
senha VARBINARY,
dicasenha varbinary
)

CREATE SYMMETRIC KEY Aluno			
			WITH ALGORITHM = AES_256
			ENCRYPTION BY PASSWORD = 'IMPACTA2018';


---CRIANDO A PROCEDURE
create procedure pr_encrypt 
@texto VARCHAR(max) 
as
begin
declare @retorno varbinary(max)
open symmetric key chavesimetrica DECRYPTION BY PASSWORD = 'semsenha';
declare @ke uniqueidentifier = (select KEY_GUID('chavesimetrica'))
set @retorno = ENCRYPTBYKEY (@ke,@texto)
select @retorno
return @retorno
end

drop procedure pr_encrypt
----RESULTADO
declare @TESTE VARCHAR(MAX) =N'texto'
declare @variavel VARBINARY
set @variavel =select @retorno pr_encrypt @TESTE 



---CRIANDO PROCEDURE
create procedure pr_descrypt
@texto varbinary(max)
as
begin
select CONVERT(VARCHAR,DECRYPTBYKEY(@texto))
end


Create Procedure  pr_hash 
		@pass varchar(255)
		, @result varbinary(max) output
		as
		Begin		
		declare 
				@salt varchar(8) = 'Luiz2018'
		select @result = HASHBYTES('sha1',@pass+@salt)
		end




-- Insert do Usuario
		declare @aux1 varbinary(max), @aux2 varbinary(max);	   
		exec pr_hash @pass='PassWor', @resulte = @aux1 output
		exec pr_encrypt @Testo = 'Password', @result = @aux2 output
		 
		insert into TBL_CTRL_ACESSO values('Daniel', @aux1, @aux2 );
		
		select * from TBL_CTRL_ACESSO
		

		---Inserindo dados
OPEN SYMMETRIC KEY chavesimetrica DECRYPTION BY PASSWORD = 'semsenha';
INSERT INTO TBL_CTRL_ACESSO
VALUES(
EncryptByKey(Key_GUID('chavesimetrica'), CONVERT(VARBINARY, N'123456')) ,
EncryptByKey(Key_GUID('Cchavesimetrica'), CONVERT(VARBINARY, N'loginSecreto')) 


Create Procedure TestaUser 
			@User varchar(max)
			, @Senha varbinary(max)
			,@Resultado tinyint output
		as
		Begin
		declare @AUX varbinary(max)  
		exec pr_hash @certo = @Senha, @resultado = @AUX output
		if exists(select * from TBL_CTRL_ACESSO where Login = @User and Senha = @AUX)		
		set @Resultado = 1		
		else
		set @Resultado = 0
		End

Create Procedure RetornaSenha
				@User varchar(255),
				@resulta varchar(255) output
				as 
				Begin
				declare @AUX varbinary(max)
				select @AUX = DicaSenha from TBL_CTRL_ACESSO where Login = @User
				 exec pr_decrypt @Testo = @AUX, @resultado = @resulta output  
				End