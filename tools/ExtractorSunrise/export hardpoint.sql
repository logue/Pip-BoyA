SELECT
  source.id,
  CONCAT('Hardpoint', REGEXP_REPLACE(source.name, '^[H|h]ard[P|p]oint([A-z_]+)([0-9]{2})?(?:.+)$', '\\1'), 'Marker') AS type,
  CAST(REGEXP_REPLACE(source.name, '^[H|h]ard[P|p]oint([A-z]+)([0-9]{2})?(.+)$', '\\2') AS SIGNED) AS label,
  source.x,
  source.y
FROM
  source
WHERE
  LOWER(source.name) LIKE 'hardpoint%';
