set sql dialect 3;
update tests set EDIT_BY='NN' where EDIT_BY is null;
update tests set "DATE"='01.01.80' where "DATE"<'01.01.80';
update series_comment set EDIT_BY='NN' where EDIT_BY is null;
update series_comment set CREATED_BY='NN' where CREATED_BY is null;
update series_comment set "DATE"='01.01.80' where "DATE" is null;
update series_comment set EDIT_DATE='01.01.80' where EDIT_DATE is null;

commit;
exit;
