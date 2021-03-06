SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_web_EncuestaDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_EncuestaDelete]
GO

/*
select * from Encuesta
sp_web_EncuestaDelete 1,10,0

*/

create Procedure sp_web_EncuestaDelete
(
  @@us_id   int,
  @@ec_id   int,
  @@rtn     int out
) 
as

  /* select tbl_id,tbl_nombrefisico from tabla where tbl_nombrefisico like '%%'*/
  declare @@ec_nombre varchar (255)
  select @@ec_nombre = ec_nombre from Encuesta where ec_id = @@ec_id
  exec sp_HistoriaUpdate 1028, @@ec_id, @@us_id, 4, @@ec_nombre

  delete EncuestaRespuesta 
  where exists(select * 
               from EncuestaPreguntaItem ecpi 
                    inner join EncuestaPregunta ecp
                      on ecpi.ecp_id = ecp.ecp_id
               where ecpi_id = EncuestaRespuesta.ecpi_id 
                 and ecp.ec_id = @@ec_id
              )
  delete EncuestaPreguntaItem
  where exists(select * 
               from EncuestaPregunta
               where ecp_id = EncuestaPreguntaItem.ecp_id 
                 and ec_id = @@ec_id
              )

  delete EncuestaPregunta where ec_id = @@ec_id
  delete Encuesta where ec_id = @@ec_id 

  set @@rtn = 1
go
set quoted_identifier off 
go
set ansi_nulls on 
go

