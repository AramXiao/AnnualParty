select * from itid_prize;
select * from itid_win_prize;
select * from itid_params;
select * from itid_sign;


#already run
insert into itid_params(param, value) values('lottery_status','0');
insert into itid_params(param, value) values('last_lottery_prize',0);
#sign up flag default set to 1
insert into itid_params(param, value) values('sign_flag', 1);


# for add hot
insert into itid_prize(seq,prize_count,prize_name,prize_image)values(6,1,'特别奖','../images/present.jpg');

#init run sql
delete from itid_sign where 1=1;
delete from itid_win_prize where 1=1;

update itid_params set value=0 where param='lottery_status';
update itid_params set value=0 where param='last_lottery_prize';
update itid_params set value=1 where param='sign_flag';