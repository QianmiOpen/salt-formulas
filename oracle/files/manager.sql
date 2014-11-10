create user autodb identified by ofcard;

grant connect,resource,dba to autodb;

conn autodb/ofcard

create table version_info(username varchar2(50),version varchar2(20),operatdate date,isinstall varchar2(10));
