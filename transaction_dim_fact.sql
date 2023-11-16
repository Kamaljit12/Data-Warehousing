create database ECommerce;
use ECommerce;
-----------------------------------------------------------------------------------------
# dim_transaction_table
create table if not exists dim_transactions
	(
    transaction_id varchar(50) primary key,
    transaction_type varchar(50),
    transaction_purpose varchar(100)
    );
    
# insert values in dim_transactions table
insert into dim_transactions
	values
    ('10kamal10', 'UPI', 'Purchasing book'),
    ('11chanda11', 'Credit Card', 'Purchasing Lahnga'),
    ('12durga12', 'Debit Card', 'Ear ring'),
    ('14somil14', 'Cash', 'Mobile');

------------------------------------------------------------------------

# dim_user
create table if not exists dim_user
	(
    user_id varchar(50) primary key,
    age_band varchar(50),
    salary_band varchar(50),
    postcode varchar(20),
    LSOA varchar(50),
    derived_gender enum('Male', 'Female', 'Others')
    );
# insert values in dim_user table
insert into dim_user
	values
    ('1001', '24', 8000, 802165, 'yes', 'Male'),
    ('1002', '18', 9000, 802465, 'yes', 'Male'),
    ('1003', '20', 8500, 803165, 'yes', 'Female'),
    ('1004', '22', 10000, 802165, 'not', 'Male'),
    ('1005', '17', 8040, 802165, 'yes', 'Female'),
    ('1006', '14', 8450, 802165, 'not', 'Female');
    

-------------------------------------------------------------------------
# dim_merchants
create table if not exists dim_merchants
	(
    merchant_id varchar(50) primary key,
    merchant_name varchar(50),
    merchant_business_line varchar(50)
    );
# insert values in dim_merchant
insert into dim_merchants
		values
        (2001, 'kamal', 'IT Field'),
        (2002, 'Durga', 'Garment'),
        (2003, 'Chanda', 'Education'),
        (2004, 'somil', 'Mobile Accessories');

-------------------------------------------------------------------------
# dim_date
create table if not exists dim_date
	(
    da_of_month varchar(20),
    day_name varchar(20),
    month_year varchar(20),
    month_name varchar(20),
    year varchar(10),
	transaction_date date
    );
# rename column da_of_month to day_of_month
alter table dim_date rename column da_of_month to day_of_month;
# add a transaction date column in dim_date table
alter table dim_date add column transaction_date date;

select * from dim_date;
    
# inset values into dim_date table
insert into dim_date
	values
	(02, 'Wednesday', '11-2023', 'November', '2023', '2023-11-02'),
    (02, 'Wednesday', '11-2023', 'November', '2023', '2023-11-02'),
    (04, 'Thursday', '11-2023', 'November', '2023', '2023-11-04'),
    (05, 'Fridat', '11-2023', 'November', '2023', '2023-11-05'),
    (06, 'Saturday', '11-2023', 'November', '2023', '2023-11-06');

-------------------------------------------------------------------------
# dim_accounts
create table if not exists dim_accounts
	(
    account_id varchar(50),
    bank_name varchar(20),
    account_type varchar(20),
    account_created_date date,
    account_last_refreshed date
    );
# add constraint primary key to account_id
alter table dim_accounts add constraint primary key(account_id);
# inset values into dim_accounts
insert into dim_accounts
	values
    ('330001212', 'BOI', 'Saving', '2023-11-02', '2023-11-03'),
	('330001213', 'ICICI', 'Current', '2023-11-03', '2023-11-05'),
    ('330001214', 'BOI', 'Saving', '2023-11-04', '2023-11-04'),
    ('330001215', 'HDFC', 'Current', '2023-11-05', '2023-11-06'),
    ('330001216', 'IDBI', 'Saving', '2023-11-08', '2023-11-09');

-------------------------------------------------------------------------
# create table fact_transaction
create table if not exists fact_transaction
	(
    transaction_date date references dim_date(transaction_date),
    transaction_id varchar(50) references dim_transaction(transaction_id),
    user_id varchar(20) references dim_user(user_id),
    account_id varchar(20) references dim_accounts(account_id),
    merchant_id varchar(20) references dim_merchant (merchant_id),
    amount int
    );
    
    drop table fact_transaction;
    
# add foreighn constraint in fact table
-- alter table fact_transaction add constraint transaction_id_fk foreign key(transaction_id) references dim_transactions(transaction_id);
-- alter table fact_transaction add constraint user_id_fk foreign key(user_id) references dim_user(user_id);
-- alter table fact_transaction add constraint account_id_fk foreign key(account_id) references dim_accounts(account_id);
-- alter table fact_transaction add constraint merchant_id_fk foreign key(merchant_id) references dim_merchants(merchant_id);

# insert values in fact_transaction

    
select * from fact_transaction;
insert into fact_transaction
	(transaction_date, transaction_id, user_id, account_id, merchant_id, amount)
	values
	('2023-11-02', '10kamal10', 1001, '330001212', 2001, 8000),
    ('2023-11-02', '10kamal10', 1001, '330001212', 2001, 9000),
    ('2023-11-04', '12durga12', 1003, '330001213', 2002, 8000),
    ('2023-11-05', '11chanda11', 1005, '330001212', 2003, 5000),
    ('2023-11-02', '11chanda11', 1005, '330001212', 2003, 8000),
    ('2023-11-04', '12durga12', 1003, '330001213', 2002, 5000),
    ('2023-11-05', '14somil14', 1002, '330001216', 2004, 7000),
    ('2023-11-06', '14somil14', 1002, '330001216', 2004, 15000),
    ('2023-11-06', '14somil14', 1002, '330001216', 2004, 2500);
    
    
select * from fact_transaction;