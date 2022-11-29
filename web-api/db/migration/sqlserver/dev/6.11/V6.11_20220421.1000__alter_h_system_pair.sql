ALTER TABLE h_system_pair add uniqueCode nvarchar(120);
GO
ALTER TABLE h_system_pair add type nvarchar(40);
GO
ALTER TABLE h_system_pair add expireTime datetime;
GO
