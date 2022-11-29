ALTER TABLE h_im_work_record MODIFY title varchar2(200) default null;
ALTER TABLE h_im_work_record_history MODIFY title varchar2(200) default '';

ALTER TABLE h_im_message MODIFY title varchar2(200) default '';
ALTER TABLE h_im_message_history MODIFY title varchar2(200) default '';