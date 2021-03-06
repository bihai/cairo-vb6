if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_SysDomainUpdateDB]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_SysDomainUpdateDB]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

  select * from basedatos

  sp_SysDomainUpdateDB 7

sp_SysDomainUpdateDB 
                        1,
                        'Cairo',
                        'souyirozeta',
                        'Cairo',
                        'sa',
                        0,
                        ''

sp_columns basedatos

*/
create procedure sp_SysDomainUpdateDB (
  @@id            int,
  @@empresa       varchar(255),
  @@server        varchar(255),
  @@database      varchar(100),
  @@login         varchar(100),
  @@securitytype  tinyint,
  @@password      varchar(20)
)
as
begin
  set nocount on

  if not exists(select * from BaseDatos where bd_id = @@id) begin


    select @@id=max(bd_id) from basedatos
    set @@id = IsNull(@@id,0)+1
    insert into BaseDatos (bd_id,bd_empresa,bd_server,bd_nombre,bd_login,bd_securitytype,bd_pwd)
        values (@@id,@@empresa,@@server,@@database,@@login,@@securitytype,@@password)

  end else begin

    update BaseDatos set 

      bd_empresa         = @@empresa,
      bd_server          = @@server,
      bd_nombre          = @@database,
      bd_login          = @@login,
      bd_securitytype    = @@securitytype,
      bd_pwd            = @@password 

    where bd_id = @@id


  end

  select @@id

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

