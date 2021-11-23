INSERT INTO `addon_account` (name, label, shared) VALUES
  ('society_flywheels','Flywheels',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
  ('society_flywheels','Flywheels',1)
;

INSERT INTO `jobs` (name, label) VALUES
  ('flywheels','Flywheels')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  ('flywheels',0,'recrue','Recruit',12,'{}','{}'),
  ('flywheels',1,'novice','Novice',24,'{}','{}'),
  ('flywheels',2,'experimente','Experienced',36,'{}','{}'),
  ('flywheels',3,'chief','Leader',48,'{}','{}'),
  ('flywheels',4,'boss','Boss',0,'{}','{}')
;

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
  ('moteurkit', 'Kit Moteur', 1, 0, 1),

  ('caroskit', 'Kit Carosserie', 1, 0, 1),

  ('gazbottle', 'Bouteille de gaz', 1, 0, 1),

  ('chiffon', 'Chiffon', 1, 0, 1)
;