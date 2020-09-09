SELECT 
  source.id,
  CONCAT('Flora',REGEXP_REPLACE(source.name, '^(?:Use)?LPI_Flora([A-z]+)([0-9]{2})?(Diseased)?(.+)$', '\\1\\3'), 'Marker') AS type,
  CAST(REGEXP_REPLACE(source.name, '^(?:Use)?LPI_Flora([A-z]+)([0-9]{2})?(.+)$', '\\2') AS SIGNED) AS label,
  source.x,
  source.y
FROM
  source
WHERE
  source.name LIKE '%Flora%';