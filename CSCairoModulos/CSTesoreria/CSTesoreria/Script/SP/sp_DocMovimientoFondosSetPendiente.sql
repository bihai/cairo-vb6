if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocMovimientoFondosSetPendiente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocMovimientoFondosSetPendiente]

/*

 sp_DocMovimientoFondosSetPendiente 

*/

go
create procedure sp_DocMovimientoFondosSetPendiente (
  @@desde       datetime = '19900101',
  @@hasta       datetime = '21000101'
)
as

begin

  declare @mf_id int

  declare c_Ventas insensitive cursor for 
    select mf_id from MovimientoFondo where mf_fecha between @@desde and @@hasta

  open c_Ventas

  fetch next from c_Ventas into @mf_id
  while @@fetch_status = 0 begin

    exec sp_DocMovimientoFondoSetPendiente @mf_id

    fetch next from c_Ventas into @mf_id
  end

  close c_Ventas
  deallocate c_Ventas
end