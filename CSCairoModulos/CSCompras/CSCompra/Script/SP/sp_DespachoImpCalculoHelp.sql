if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_DespachoImpCalculoHelp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DespachoImpCalculoHelp]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

 sp_DespachoImpCalculoHelp 1,1,1,'',0,0

 sp_DespachoImpCalculoHelp 3,'',0,0,1 

*/
create procedure sp_DespachoImpCalculoHelp (
  @@emp_id          int,
  @@us_id           int,
  @@bForAbm         tinyint,
  @@filter           varchar(255)  = '',
  @@check            smallint       = 0,
  @@dic_id          int,
  @@filter2          varchar(5000) = ''
)
as
begin

  set nocount on

  declare @us_EmpresaEx tinyint
  declare @us_EmpXDpto  tinyint

  if @@check <> 0 begin

    select  dic_id,
            dic_nrodoc,
            dic_numero

    from DespachoImpCalculo

    where (dic_nrodoc = @@filter or convert(varchar,dic_numero) = @@filter )
      and (dic_id = @@dic_id or @@dic_id=0)

  end else begin

      select top 50
             dic_id,
             dic_nrodoc        as Número,
             dic_titulo        as Nombre,
             dic_numero        as [Código],
             prov_nombre       as [Proveedor],
             dic_viaempresa    as Empresa,
             dic_fecha         as Fecha,
             dic_via           as Via,
             case dic_tipo
                  when 1 then 'Provisorio'
                  when 2 then 'Definitivo'
             end               as Tipo
             

      from DespachoImpCalculo dic left join Proveedor prov on dic.prov_id = prov.prov_id

      where (dic_viaempresa like '%'+@@filter+'%' or dic_nrodoc like '%'+@@filter+'%' 
              or dic_titulo like '%'+@@filter+'%' 
              or prov_nombre like '%'+@@filter+'%' 
              or @@filter = '')
  end

end

GO