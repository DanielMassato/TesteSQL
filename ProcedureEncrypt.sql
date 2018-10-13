use TSQL2012
--Criação da tabela
Create Table TBL_CTRL_ACESSO (
		Login varchar(255) not null,
		Senha varbinary(max) not null,
		DicaSenha varbinary(max) not null
		Constraint PK_Login PRIMARY KEY (Login) 

);


Create Procedure  pr_hash 
		@pass varchar(255)
		, @result varbinary(max) output
		as
		Begin
		
		declare @salt_start varchar(7) = 'Impacta',
				@salt_end varchar(4) = '2018'
		select @result = HASHBYTES('sha1',@salt_start+@pass+@salt_end)
		end




			CREATE SYMMETRIC KEY Aluno			
			WITH ALGORITHM = AES_256
			ENCRYPTION BY PASSWORD = '0x0062A9754F55AC7FA15108640CD825168E0EB689';

Create Procedure pr_encrypt
		@Testo varchar(255)
		, @result varbinary(max) output
		as
		Begin
		OPEN SYMMETRIC KEY Aluno DECRYPTION BY PASSWORD = N'0x0062A9754F55AC7FA15108640CD825168E0EB689';

		
		
		Declare @key UNIQUEIDENTIFIER = (select Key_GUID('Aluno'))
		
		select @result =EncryptByKey(@key, @Testo);
		
		--select CONVERT(VARCHAR,DECRYPTBYKEY(@result))
		
		CLOSE SYMMETRIC KEY Aluno 
		 
		end

Create Procedure pr_decrypt
			@Testo varbinary(max)
			, @result varchar(255) output
		as
		Begin
		OPEN SYMMETRIC KEY Aluno DECRYPTION BY PASSWORD = N'0x0062A9754F55AC7FA15108640CD825168E0EB689';
		declare 
		 @decry varchar(max)
		  
		--Declare @key UNIQUEIDENTIFIER = (select Key_GUID('Aluno'))
		
		--select @result = EncryptByKey(@key, @Testo);
		
		   select CONVERT(VARCHAR,DECRYPTBYKEY(@Testo))
		
		CLOSE SYMMETRIC KEY Aluno 
		end
-- Insert do Usuario
		declare @aux1 varbinary(max), @aux2 varbinary(max);	   
		exec pr_hash @pass='PassWor', @resulte = @aux1 output
		exec pr_encrypt @Testo = 'Password', @result = @aux2 output
		 
		insert into TBL_CTRL_ACESSO values('Daniel', @aux1, @aux2 );
		
		select * from TBL_CTRL_ACESSO
		
Create Procedure verificaUsuario 
			@User varchar(max)
			, @Senha varbinary(max)
			,@Result tinyint output
		as
		Begin
		declare @AUX varbinary(max)  
		exec pr_hash @pass = @Senha, @result = @AUX output

		if exists(select * from TBL_CTRL_ACESSO where Login = @User and Senha = @AUX) 
		begin
		set @Result = 1
		end
		else
		set @Result = 0
		End

Create Procedure RetornaDicaSenha
				@User varchar(255),
				@resulta varchar(255) output
				as 
				Begin
				declare @AUX varbinary(max)
				select @AUX = DicaSenha from TBL_CTRL_ACESSO where Login = @User
				 exec pr_decrypt @Testo = @AUX, @result = @resulta output  
				End