if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_ProveedorHelp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProveedorHelp]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO
/*

 sp_ProveedorHelp 1,1,1,'sp%',0,0

 sp_ProveedorHelp 3,'',0,0,1 

  select * from usuario where us_nombre like '%ahidal%'

*/
create procedure sp_ProveedorHelp (
  @@emp_id          int,
  @@us_id           int,
  @@bForAbm         tinyint,
  @@filter           varchar(255)  = '',
  @@check            smallint       = 0,
  @@prov_id         int,
  @@filter2          varchar(5000)  = ''
)
as
begin

  set nocount on

  declare @us_EmpresaEx tinyint
  declare @us_EmpXDpto  tinyint

  select @us_EmpresaEx = us_empresaex, @us_EmpXDpto = us_empxdpto from Usuario where us_id = @@us_id

  if @us_EmpresaEx <> 0 begin

    if @@check <> 0 begin

      select  prov_id,
              prov_nombre        as [Nombre],
              prov_codigo       as [Codigo]
  
      from Proveedor
  
      where (prov_nombre = @@filter or prov_codigo = @@filter)
        and (activo <> 0 or @@bForAbm <> 0)
        and (prov_id = @@prov_id or @@prov_id=0)
        and (      @@bForAbm <> 0 
              or (
                       (exists (select * from EmpresaProveedor where prov_id = Proveedor.prov_id and emp_id = @@emp_id))
                  and (exists (select * from UsuarioEmpresa where prov_id = Proveedor.prov_id and us_id = @@us_id) or @@us_id = 1)
                  )
            )
  
    end else begin
  
        select top 50
               prov_id,
               prov_nombre        as Nombre,
               prov_razonsocial   as [Razon social],
               prov_cuit          as [CUIT],
               prov_codigo        as Codigo,
               case prov_catfiscal
                  when 1 then 'Inscripto'
                  when 2 then 'Exento'
                  when 3 then 'No inscripto'
                  when 4 then 'Consumidor Final'
                  when 5 then 'Extranjero'
                  when 6 then 'Mono Tributo'
                  when 7 then 'Extranjero Iva'
                  when 8 then 'No responsable'
                  when 9 then 'No Responsable exento'
                  when 10 then 'No categorizado'
                  else 'Sin categorizar'
               end as [Categoria Fiscal]

        from Proveedor 
  
        where (prov_codigo like '%'+@@filter+'%' or prov_nombre like '%'+@@filter+'%' 
                or prov_razonsocial like '%'+@@filter+'%' 
                or prov_cuit like '%'+@@filter+'%' 
                or @@filter = '')
        and (@@bForAbm <> 0 or (
                  (exists (select * from EmpresaProveedor where prov_id = Proveedor.prov_id and emp_id = @@emp_id))
              and (exists (select * from UsuarioEmpresa where prov_id = Proveedor.prov_id and us_id = @@us_id) or @@us_id = 1)
              and activo <> 0
            ))
    end

  end else begin 
    if @us_EmpXDpto <> 0 begin

      if @@check <> 0 begin
      
        select   prov_id,
                prov_nombre        as [Nombre],
                prov_codigo         as [Codigo]
    
        from Proveedor
    
        where (prov_nombre = @@filter or prov_codigo = @@filter)
          and (activo <> 0 or @@bForAbm <> 0)
          and (prov_id = @@prov_id or @@prov_id=0)
          and (@@bForAbm <> 0 or (
                     (exists (select * from EmpresaProveedor where prov_id = Proveedor.prov_id and emp_id = @@emp_id))
                and (exists (select * from DepartamentoProveedor dc inner join UsuarioDepartamento ud on dc.dpto_id = ud.dpto_id
                              where prov_id = Proveedor.prov_id and us_id = @@us_id
                             ) 
                      or @@us_id = 1
                     )    
               ))
    
      end else begin
    
        select top 50
               prov_id,
               prov_nombre        as Nombre,
               prov_razonsocial   as [Razon social],
               prov_cuit          as [CUIT],
               prov_codigo        as Codigo,
               case prov_catfiscal
                  when 1 then 'Inscripto'
                  when 2 then 'Exento'
                  when 3 then 'No inscripto'
                  when 4 then 'Consumidor Final'
                  when 5 then 'Extranjero'
                  when 6 then 'Mono Tributo'
                  when 7 then 'Extranjero Iva'
                  when 8 then 'No responsable'
                  when 9 then 'No Responsable exento'
                  when 10 then 'No categorizado'
                  else 'Sin categorizar'
               end as [Categoria Fiscal]
        from Proveedor 
  
        where (prov_codigo like '%'+@@filter+'%' or prov_nombre like '%'+@@filter+'%' 
                or prov_razonsocial like '%'+@@filter+'%' 
                or prov_cuit like '%'+@@filter+'%' 
                or @@filter = '')
        and (@@bForAbm <> 0 or (
                     (exists (select * from EmpresaProveedor where prov_id = Proveedor.prov_id and emp_id = @@emp_id))
                and (exists (select * from DepartamentoProveedor dc inner join UsuarioDepartamento ud on dc.dpto_id = ud.dpto_id
                              where prov_id = Proveedor.prov_id and us_id = @@us_id
                             ) 
                      or @@us_id = 1
                     )
                and activo <> 0    
            ))
      end    

    end else begin
  
      if @@check <> 0 begin
      
        select   prov_id,
                prov_nombre        as [Nombre],
                prov_codigo       as [Codigo]
    
        from Proveedor
    
        where (prov_nombre = @@filter or prov_codigo = @@filter)
          and (activo <> 0 or @@bForAbm <> 0)
          and (prov_id = @@prov_id or @@prov_id=0)
        and (
                @@bForAbm <> 0 
              or 
                (exists (select * from EmpresaProveedor where prov_id = Proveedor.prov_id and emp_id = @@emp_id))
            )
    
      end else begin
    
        select top 50
               prov_id,
               prov_nombre        as Nombre,
               prov_razonsocial   as [Razon social],
               prov_cuit          as [CUIT],
               prov_codigo        as Codigo,
               case prov_catfiscal
                  when 1 then 'Inscripto'
                  when 2 then 'Exento'
                  when 3 then 'No inscripto'
                  when 4 then 'Consumidor Final'
                  when 5 then 'Extranjero'
                  when 6 then 'Mono Tributo'
                  when 7 then 'Extranjero Iva'
                  when 8 then 'No responsable'
                  when 9 then 'No Responsable exento'
                  when 10 then 'No categorizado'
                  else 'Sin categorizar'
               end as [Categoria Fiscal]
        from Proveedor 
  
        where (prov_codigo like '%'+@@filter+'%' or prov_nombre like '%'+@@filter+'%' 
                or prov_razonsocial like '%'+@@filter+'%' 
                or prov_cuit like '%'+@@filter+'%' 
                or @@filter = '')
        and (    @@bForAbm <> 0 
              or 
                (      exists (select * from EmpresaProveedor where prov_id = Proveedor.prov_id and emp_id = @@emp_id)
                  and activo <> 0
                )
            )
    
      end    
    end
  end
end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

