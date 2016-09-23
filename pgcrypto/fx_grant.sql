/***
Function to Grant permissions to objects within a schema
-- Usage: select schema_grant('role','permission','object','schema');
-- Usage: select schema_grant('role','all','%','schema');
***/

CREATE OR REPLACE FUNCTION grant_permission(text, text, text, text)
RETURNS integer AS
$BODY$

DECLARE obj record;
num integer;
BEGIN
num:=0;
FOR obj IN SELECT relname FROM pg_class c
JOIN pg_namespace ns ON (c.relnamespace = ns.oid) WHERE
relkind in ('r','v','S') AND
nspname = $4 AND
relname LIKE $3
LOOP
EXECUTE 'GRANT ' ||$2|| ' ON ' ||$4|| '.' || obj.relname || ' TO ' ||$1;
num := num + 1;
END LOOP;
RETURN num;
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE SECURITY DEFINER;