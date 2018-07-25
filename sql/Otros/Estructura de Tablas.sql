-- Estructura de tabla
select	so.name, sc.name, st.name, sc.max_length, sc.precision, sc.collation_name, sc.is_nullable
from	sys.objects so, sys.columns sc, sys.types st
where	so.object_id  = sc.object_id and sc.system_type_id = st.system_type_id and 
		so.name = 'SE_PAIS'


select	sc.*, sc.name 'CAMPO', st.name 'TIPO', sc.max_length 'TAM', case when sc.is_nullable = 0 then 'NO' else 'SI' end 'NULL'
from	sys.objects so, sys.columns sc, sys.types st
where	so.object_id  = sc.object_id and sc.system_type_id = st.system_type_id and 
		so.name = 'SE_PROGRAMAOSE'
