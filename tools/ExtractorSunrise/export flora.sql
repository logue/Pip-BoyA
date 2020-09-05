SELECT 
  source.id,
  CONCAT(REGEXP_REPLACE(source.name, '^LPI_Flora([A-z]+)([0-9]{2})?(.+)$', '\\1'), 'Marker') AS type,
  CAST(REGEXP_REPLACE(source.name, '^LPI_Flora([A-z]+)([0-9]{2})?(.+)$', '\\2') AS SIGNED) AS label,
  source.x,
  source.y
FROM
  source
WHERE
  source.name LIKE 'LPI_Flora%';