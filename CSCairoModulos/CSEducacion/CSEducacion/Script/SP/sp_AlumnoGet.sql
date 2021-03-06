SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_AlumnoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_AlumnoGet]
GO

/*

sp_AlumnoGet 7

*/

create procedure sp_AlumnoGet
(
  @@alum_id   int
)
as
begin

  select   Alumno.*,
          Persona.*, 
           dpto_nombre, 
           cli_nombre,
           suc_nombre,
          prsdt_nombre,
          pro_nombre,
          pprof.prs_apellido + ', ' + pprof.prs_nombre   as prof_nombre,
          pref.prs_apellido + ', ' + pref.prs_nombre     as Referido,
          clict_nombre,
          proy_nombre,

          nive_nombre,
          profe_nombre,
          pa_nombre,
          estc_nombre



  from  Alumno    inner join Persona               on Alumno.prs_id    = Persona.prs_id
                 left  join Cliente               on Persona.cli_id   = Cliente.cli_id
                 left  join Sucursal               on Persona.suc_id    = Sucursal.suc_id
                 left  join Departamento           on Persona.dpto_id   = Departamento.dpto_id
                 left  join PersonaDocumentoTipo  on Persona.prsdt_id = PersonaDocumentoTipo.prsdt_id
                 left  join Provincia             on Persona.pro_id   = Provincia.pro_id
                 left  join Profesor              on Alumno.prof_id   = Profesor.prof_id
                 left  join Persona pprof         on Profesor.prs_id  = pprof.prs_id

                 left  join ClienteContactoTipo clict   on Alumno.clict_id           = clict.clict_id
                 left  join Alumno ref                  on Alumno.alum_id_referido   = ref.alum_id
                 left  join Persona pref                on ref.prs_id               = pref.prs_id
                 left  join Proyecto proy                on Alumno.proy_id           = proy.proy_id

                 left  join NivelEstudio nive     on Persona.nive_id = nive.nive_id
                 left  join Profesion profe       on Persona.profe_id = profe.profe_id
                 left  join Pais pa               on Persona.pa_id = pa.pa_id
                 left  join EstadoCivil estc      on Persona.estc_id = estc.estc_id

  where Alumno.alum_id= @@alum_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go

