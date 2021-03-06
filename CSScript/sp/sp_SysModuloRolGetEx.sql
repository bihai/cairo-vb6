if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_SysModuloRolGetEx]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_SysModuloRolGetEx]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

  sp_SysModuloRolGetEx 1

*/
create procedure sp_SysModuloRolGetEx (

  @@rol_id    int

) 
as
begin

  set nocount on

  declare @us_id int

  declare c_users insensitive cursor for

  select us_id from usuariorol where rol_id = @@rol_id

  open c_users

  fetch next from c_users into @us_id
  while @@fetch_status=0
  begin

    exec sp_SysModuloGetEx @us_id

    fetch next from c_users into @us_id
  end

  close c_users
  deallocate c_users

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

