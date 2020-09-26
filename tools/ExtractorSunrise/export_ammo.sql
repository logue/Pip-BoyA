SELECT
  source.id,
  CONCAT('Ammo',REGEXP_REPLACE(source.name, '^LPI_Ammo_([A-z0-9]+)?(.+)$', '\\1\\3'), 'Marker') AS type,
  source.x,
  source.y
FROM
  source
WHERE
  source.name LIKE '%LPI_Ammo%';
