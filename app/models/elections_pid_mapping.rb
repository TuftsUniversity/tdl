#CREATE TABLE `hyd_tdl`.`elections_pid_mapping` (
#  `id` INT NOT NULL AUTO_INCREMENT,
#  `f3_pid` VARCHAR(100) NOT NULL,
#  `f4_id` VARCHAR(100) NOT NULL,
#  PRIMARY KEY (`id`),
#  UNIQUE INDEX `f3_pid_UNIQUE` (`f3_pid` ASC),
#  UNIQUE INDEX `f4_id_UNIQUE` (`f4_id` ASC));
class ElectionsPidMapping < ActiveRecord::Base
    self.table_name = "elections_pid_mapping"
    attr_accessible :f3_pid, :f4_id
end
