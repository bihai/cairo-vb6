if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocResolucionCuponSetEstado]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocResolucionCuponSetEstado]

/*

 sp_DocResolucionCuponSetEstado 21

*/

go
create procedure sp_DocResolucionCuponSetEstado (
  @@rcup_id       int,
  @@Select        tinyint = 0,
  @@est_id        int = 0 out 
)
as

begin

  if @@rcup_id = 0 return

  declare @est_id          int
  declare @llevaFirma     tinyint
  declare @firmado        tinyint
  declare @doc_id         int
  declare @doc_llevafirma tinyint

  declare @estado_pendiente         int set @estado_pendiente         =1
  declare @estado_pendienteFirma    int set @estado_pendienteFirma    =4
  declare @estado_finalizado        int set @estado_finalizado        =5
  declare @estado_anulado           int set @estado_anulado           =7

  select @firmado = rcup_firmado, @est_id = est_id, @doc_id = doc_id
  from ResolucionCupon where rcup_id = @@rcup_id

  select @doc_llevafirma = doc_llevafirma from Documento where doc_id = @doc_id

  if @est_id <> @estado_anulado begin

    -- Si el documento requiere firma y el comprobante no esta firmado
    -- y no esta finalizado (puede ser que se finalizo y luego se modifico el documento
    -- para que requiera firma en cuyo caso no se exige firma para documentos finalizados)
    if @firmado = 0 and @doc_llevafirma <> 0 and @est_id <> @estado_finalizado begin             
      set @est_id = @estado_pendienteFirma 
    end
    else begin                                
      set @est_id = @estado_finalizado          
    end
  
    update ResolucionCupon set est_id = @est_id
    where rcup_id = @@rcup_id
  
  end

  set @@est_id = @est_id  
  if @@Select <> 0 select @est_id

  return
ControlError:

  raiserror ('Ha ocurrido un error al actualizar el estado de la resolucion de cupones. sp_DocResolucionCuponSetEstado.', 16, 1)

end