ALTER TABLE h_im_work_record MODIFY COLUMN `title` varchar(200) default '';
ALTER TABLE h_im_work_record_history MODIFY COLUMN `title` varchar(200) default '';

ALTER TABLE h_im_message MODIFY COLUMN `title` varchar(200) default '';
ALTER TABLE h_im_message_history MODIFY COLUMN `title` varchar(200) default '';