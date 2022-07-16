CREATE DATABASE PawNClaw
GO

USE PawNClaw
GO

CREATE TABLE [Roles]
(
    code VARCHAR(32) PRIMARY KEY,
	role_name NVARCHAR(256) NOT NULL,
	status BIT DEFAULT 1
)
GO
INSERT [dbo].[Roles] ([code], [role_name], [status]) VALUES (N'AD', N'Admin', 1)
GO
INSERT [dbo].[Roles] ([code], [role_name], [status]) VALUES (N'MOD', N'Mod', 1)
GO
INSERT [dbo].[Roles] ([code], [role_name], [status]) VALUES (N'OWN', N'Owner', 1)
GO
INSERT [dbo].[Roles] ([code], [role_name], [status]) VALUES (N'STF', N'Staff', 1)
GO
INSERT [dbo].[Roles] ([code], [role_name], [status]) VALUES (N'CUS', N'Customer', 1)
GO

CREATE TABLE Accounts (
	id INT PRIMARY KEY IDENTITY,
	user_name NVARCHAR(256) NOT NULL,
	role_code VARCHAR(32) NOT NULL DEFAULT 'CUS',
	created_user INT DEFAULT 0,
	device_id VARCHAR(512),
	phone VARCHAR(32),
	status BIT DEFAULT 1
)
ALTER TABLE dbo.Accounts ADD FOREIGN KEY (role_code) REFERENCES [Roles](code)
GO

CREATE TABLE [Admins]
(
    id INT PRIMARY KEY,
	name NVARCHAR(256) NOT NULL,
	email NVARCHAR(256),  -- dùng để hiện thông tin liên lạc, không dùng để login
	gender INT
)
GO
ALTER TABLE dbo.[Admins] ADD FOREIGN KEY (id) REFERENCES [dbo].[Accounts](id)
GO

CREATE TABLE [Owners]
(
    id INT PRIMARY KEY,
	name NVARCHAR(256) NOT NULL,
	email NVARCHAR(256) NOT NULL,
	gender INT
)
ALTER TABLE dbo.[Owners] ADD FOREIGN KEY (id) REFERENCES [dbo].[Accounts](id)
GO

CREATE TABLE Customers
(
    id INT PRIMARY KEY,
	name NVARCHAR(256) NOT NULL,
	birth DATE,
	gender TINYINT
)
ALTER TABLE dbo.Customers ADD FOREIGN KEY (id) REFERENCES [dbo].[Accounts](id)
GO

CREATE TABLE CustomerAddresses
(
    id INT IDENTITY PRIMARY KEY,
	name NVARCHAR(512) NOT NULL,
	address NVARCHAR(512) NOT NULL,
	longtitude VARCHAR(64),
	latitude VARCHAR(64),
	status BIT DEFAULT 1,
	customer_id INT NOT NULL
)
ALTER TABLE dbo.CustomerAddresses ADD FOREIGN KEY (customer_id) REFERENCES [dbo].Customers(id)
GO

CREATE TABLE Brands
(
    id INT PRIMARY KEY IDENTITY,
	name NVARCHAR(256) NOT NULL,
	description NVARCHAR(512),
	create_date DATE DEFAULT GETDATE(),
	modify_date DATE DEFAULT GETDATE(),
	create_user INT,
	modify_user INT,
	status BIT DEFAULT 1,
	owner_id INT NOT NULL
)
ALTER TABLE dbo.Brands ADD FOREIGN KEY (create_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.Brands ADD FOREIGN KEY (modify_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.Brands ADD FOREIGN KEY (owner_id) REFERENCES [dbo].[Owners](id)
GO
CREATE INDEX i ON dbo.Brands (id)
GO

CREATE TABLE PetCenters
(
    id INT PRIMARY KEY IDENTITY,
	name NVARCHAR(256) NOT NULL,
	address NVARCHAR(256),
	phone VARCHAR(32),
	rating INT,
	open_time TIME,
	close_time TIME,
	create_date DATE DEFAULT GETDATE(),
	modify_date DATE DEFAULT GETDATE(),
	create_user INT,
	modify_user INT,
	status BIT DEFAULT 1,
	brand_id INT NOT NULL,
	description NVARCHAR(512),
	checkin NVARCHAR(256),
	checkout NVARCHAR(256)
)
ALTER TABLE dbo.PetCenters ADD FOREIGN KEY (create_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.PetCenters ADD FOREIGN KEY (modify_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.PetCenters ADD FOREIGN KEY (brand_id) REFERENCES [dbo].Brands(id)
GO
CREATE INDEX i ON dbo.PetCenters (id)
GO

CREATE TABLE City (
	code VARCHAR(32) PRIMARY KEY,
	name NVARCHAR(256) NOT NULL
)

CREATE TABLE District
(
    code VARCHAR(32) PRIMARY KEY,
	name NVARCHAR(256) NOT NULL,
	city_code VARCHAR(32) NOT NULL,
	latitude VARCHAR(64),
	longtitude VARCHAR(64)
)	
ALTER TABLE dbo.District ADD FOREIGN KEY (city_code) REFERENCES [dbo].City(code)
GO

CREATE TABLE Ward
(
    code VARCHAR(32) PRIMARY KEY,
	name NVARCHAR(256) NOT NULL,
	city_code VARCHAR(32) NOT NULL,
	district_code VARCHAR(32) NOT NULL
)
ALTER TABLE dbo.Ward ADD FOREIGN KEY (city_code) REFERENCES [dbo].City(code)
GO
ALTER TABLE dbo.Ward ADD FOREIGN KEY (district_code) REFERENCES [dbo].District(code)
GO

CREATE TABLE [Locations]
(
    id INT PRIMARY KEY,
	longtitude VARCHAR(64),
	latitude VARCHAR(64),
	city_code VARCHAR(32) NOT NULL,
	district_code VARCHAR(32) NOT NULL,
	ward_code VARCHAR(32) NOT NULL
)
ALTER TABLE dbo.[Locations] ADD FOREIGN KEY (id) REFERENCES [dbo].PetCenters(id)
GO
ALTER TABLE dbo.[Locations] ADD FOREIGN KEY (city_code) REFERENCES [dbo].City(code)
GO
ALTER TABLE dbo.[Locations] ADD FOREIGN KEY (district_code) REFERENCES [dbo].District(code)
GO
ALTER TABLE dbo.[Locations] ADD FOREIGN KEY (ward_code) REFERENCES [dbo].Ward(code)
GO
CREATE INDEX i ON dbo.[Locations] (id)
GO

CREATE TABLE Staffs
(
    id INT PRIMARY KEY,
	name NVARCHAR(256),
	center_id INT NOT NULL,
	create_date DATE DEFAULT GETDATE(),
	modify_date DATE DEFAULT GETDATE(),
	create_user INT,
	modify_user INT
)
ALTER TABLE dbo.Staffs ADD FOREIGN KEY (create_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.Staffs ADD FOREIGN KEY (modify_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.Staffs ADD FOREIGN KEY (center_id) REFERENCES [dbo].PetCenters(id)
GO
ALTER TABLE dbo.Staffs ADD FOREIGN KEY (id) REFERENCES [dbo].Accounts(id)
GO

CREATE TABLE PriceTypes
(
    code VARCHAR(32) PRIMARY KEY,
	type_name NVARCHAR(256) NOT NULL,
	create_date DATE DEFAULT GETDATE(),
	modify_date DATE DEFAULT GETDATE(),
	create_user INT,  -- Admin
	modify_user INT,  -- Admin
	status BIT DEFAULT 1
)
GO
ALTER TABLE dbo.PriceTypes ADD FOREIGN KEY (create_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.PriceTypes ADD FOREIGN KEY (modify_user) REFERENCES [dbo].Accounts(id)
GO

CREATE TABLE CageTypes
(
    id INT IDENTITY PRIMARY KEY,
	type_name NVARCHAR(256) NOT NULL,
	description NVARCHAR(512),
	height NUMERIC(19, 5) NOT NULL,
	width NUMERIC(19, 5) NOT NULL,
	length NUMERIC(19, 5) NOT NULL,
	is_single BIT NOT NULL,
	create_date DATE DEFAULT GETDATE(),
	modify_date DATE DEFAULT GETDATE(),
	create_user INT,
	modify_user INT,
	status BIT DEFAULT 1,
	center_id INT NOT NULL
)
GO
ALTER TABLE dbo.CageTypes ADD FOREIGN KEY (create_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.CageTypes ADD FOREIGN KEY (modify_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.CageTypes ADD FOREIGN KEY (center_id) REFERENCES [dbo].PetCenters(id)
GO
CREATE INDEX i ON dbo.CageTypes (id)
GO

CREATE TABLE Prices
(
    id INT IDENTITY PRIMARY KEY,
	unit_price NUMERIC(19, 5) NOT NULL,
	date_from DATE,
	date_to DATE,
	create_date DATE DEFAULT GETDATE(),
	modify_date DATE DEFAULT GETDATE(),
	create_user INT,
	modify_user INT,
	status BIT DEFAULT 1,
	cage_type_id INT NOT NULL,
	price_type_code VARCHAR(32) NOT NULL
)
GO
ALTER TABLE dbo.Prices ADD FOREIGN KEY (create_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.Prices ADD FOREIGN KEY (modify_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.Prices ADD FOREIGN KEY (cage_type_id) REFERENCES [dbo].CageTypes(id)
GO
ALTER TABLE dbo.Prices ADD FOREIGN KEY (price_type_code) REFERENCES [dbo].PriceTypes(code)
GO

CREATE TABLE Cages
(
    code VARCHAR(32) NOT NULL,
	center_id INT NOT NULL,
	name NVARCHAR(256) NOT NULL,
	color NVARCHAR(256),
	isOnline BIT NOT NULL,
	create_date DATE DEFAULT GETDATE(),
	modify_date DATE DEFAULT GETDATE(),
	create_user INT,
	modify_user INT,
	status BIT DEFAULT 1,
	cage_type_id INT NOT NULL
)
ALTER TABLE Cages WITH NOCHECK ADD CONSTRAINT PK_Cage PRIMARY KEY CLUSTERED(code, center_id) ON [PRIMARY]
GO
ALTER TABLE dbo.Cages ADD FOREIGN KEY (create_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.Cages ADD FOREIGN KEY (modify_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.Cages ADD FOREIGN KEY (cage_type_id) REFERENCES [dbo].CageTypes(id)
GO
ALTER TABLE dbo.Cages ADD FOREIGN KEY (center_id) REFERENCES [dbo].PetCenters(id)
GO

CREATE TABLE PetTypes
(
    code VARCHAR(32) PRIMARY KEY,
	name NVARCHAR(256) NOT NULL,
	create_date DATE DEFAULT GETDATE(),
	modify_date DATE DEFAULT GETDATE(),
	create_user INT,
	modify_user INT,
	status BIT DEFAULT 1
)
GO
ALTER TABLE dbo.PetTypes ADD FOREIGN KEY (create_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.PetTypes ADD FOREIGN KEY (modify_user) REFERENCES [dbo].Accounts(id)
GO

CREATE TABLE Pets
(
    id INT IDENTITY PRIMARY KEY,
	weight NUMERIC(19, 5) NOT NULL,
	length NUMERIC(19, 5) NOT NULL,
	height NUMERIC(19, 5) NOT NULL,
	name NVARCHAR(256) NOT NULL,
	birth DATE,
	breed_name NVARCHAR(256),
	status BIT DEFAULT 1,
	customer_id INT NOT NULL,
	pet_type_code VARCHAR(32) NOT NULL
)
ALTER TABLE dbo.Pets ADD FOREIGN KEY (customer_id) REFERENCES [dbo].Customers(id)
GO
ALTER TABLE dbo.Pets ADD FOREIGN KEY (pet_type_code) REFERENCES [dbo].PetTypes(code)
GO

CREATE TABLE PetHealthHistories
(
    id INT IDENTITY PRIMARY KEY,
	checked_date DATE DEFAULT GETDATE() NOT NULL,
	description NVARCHAR(512) NOT NULL,
	center_name NVARCHAR(256) NOT NULL,
	weight NUMERIC(19, 5),
	height NUMERIC(19, 5),
	length NUMERIC(19, 5),
	pet_id INT NOT NULL,
	booking_id INT NOT NULL
)
ALTER TABLE dbo.PetHealthHistories ADD FOREIGN KEY (pet_id) REFERENCES [dbo].Pets(id)
GO
ALTER TABLE dbo.PetHealthHistories ADD FOREIGN KEY (booking_id) REFERENCES [dbo].Bookings(id)
GO

CREATE TABLE [Services]
(
    id INT PRIMARY KEY IDENTITY,
	name NVARCHAR(256) NOT NULL,
	description NVARCHAR(512),
	discount_price NUMERIC(19, 5) DEFAULT 0,
	create_date DATE DEFAULT GETDATE(),
	modify_date DATE DEFAULT GETDATE(),
	create_user INT,
	modify_user INT,
	status BIT DEFAULT 1,
	center_id INT NOT NULL
)
ALTER TABLE dbo.[Services] ADD FOREIGN KEY (create_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.[Services] ADD FOREIGN KEY (modify_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.[Services] ADD FOREIGN KEY (center_id) REFERENCES [dbo].PetCenters(id)
GO

CREATE TABLE SupplyTypes
(
    code VARCHAR(32) PRIMARY KEY,
	name NVARCHAR(256) NOT NULL,
	create_date DATE DEFAULT GETDATE(),
	modify_date DATE DEFAULT GETDATE(),
	create_user INT,
	modify_user INT,
	status BIT DEFAULT 1
)
ALTER TABLE dbo.SupplyTypes ADD FOREIGN KEY (create_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.SupplyTypes ADD FOREIGN KEY (modify_user) REFERENCES [dbo].Accounts(id)
GO


CREATE TABLE Supplies
(
    id INT PRIMARY KEY IDENTITY,
	name NVARCHAR(256) NOT NULL,
	sell_price NUMERIC(19, 5) NOT NULL,
	discount_price NUMERIC(19, 5) DEFAULT 0,
	quantity INT NOT NULL,
	create_date DATE DEFAULT GETDATE(),
	modify_date DATE DEFAULT GETDATE(),
	create_user INT,
	modify_user INT,
	status BIT DEFAULT 1,
	supply_type_code VARCHAR(32) NOT NULL,
	center_id INT NOT NULL
)
ALTER TABLE dbo.Supplies ADD FOREIGN KEY (create_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.Supplies ADD FOREIGN KEY (modify_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.Supplies ADD FOREIGN KEY (supply_type_code) REFERENCES [dbo].SupplyTypes(code)
GO
ALTER TABLE dbo.Supplies ADD FOREIGN KEY (center_id) REFERENCES [dbo].PetCenters(id)
GO

CREATE TABLE VoucherTypes
(
    code VARCHAR(32) PRIMARY KEY,
	name NVARCHAR(256) NOT NULL,
	create_date DATE DEFAULT GETDATE(),
	modify_date DATE DEFAULT GETDATE(),
	create_user INT,
	modify_user INT,
	status BIT DEFAULT 1
)
ALTER TABLE dbo.VoucherTypes ADD FOREIGN KEY (create_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.VoucherTypes ADD FOREIGN KEY (modify_user) REFERENCES [dbo].Accounts(id)
GO

CREATE TABLE Vouchers
(
    code VARCHAR(32) PRIMARY KEY,
	min_condition NUMERIC(19, 5),
	value NUMERIC(19, 5),
	start_date DATE,
	expire_date DATE,
	create_date DATE DEFAULT GETDATE(),
	modify_date DATE DEFAULT GETDATE(),
	create_user INT,
	modify_user INT,
	status BIT DEFAULT 1,
	center_id INT NOT NULL,
	voucher_type_code VARCHAR(32) NOT NULL
)
ALTER TABLE dbo.Vouchers ADD FOREIGN KEY (create_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.Vouchers ADD FOREIGN KEY (modify_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.Vouchers ADD FOREIGN KEY (center_id) REFERENCES [dbo].PetCenters(id)
GO
ALTER TABLE dbo.Vouchers ADD FOREIGN KEY (voucher_type_code) REFERENCES [dbo].VoucherTypes(code)
GO

CREATE TABLE BookingStatuses
(
    id INT PRIMARY KEY,
	name NVARCHAR(256) NOT NULL
)
GO

CREATE TABLE Bookings
(
    id INT PRIMARY KEY IDENTITY,
	sub_total NUMERIC(19, 5),
	discount NUMERIC(19, 5),
	total NUMERIC(19, 5),
	check_in DATETIME,
	check_out DATETIME,
	create_time DATETIME DEFAULT GETDATE(),
	start_booking DATETIME,
	end_booking DATETIME,
	status_id INT DEFAULT 1 NOT NULL,
	voucher_code VARCHAR(32),
	customer_id INT NOT NULL,
	center_id INT NOT NULL,
	rating TINYINT,
	customer_note NVARCHAR(512),
	staff_note NVARCHAR(512)
)
ALTER TABLE dbo.Bookings ADD FOREIGN KEY (status_id) REFERENCES [dbo].BookingStatuses(id)
GO
ALTER TABLE dbo.Bookings ADD FOREIGN KEY (voucher_code) REFERENCES [dbo].Vouchers(code)
GO
ALTER TABLE dbo.Bookings ADD FOREIGN KEY (customer_id) REFERENCES [dbo].Customers(id)
GO
ALTER TABLE dbo.Bookings ADD FOREIGN KEY (center_id) REFERENCES [dbo].PetCenters(id)
GO

CREATE TABLE SupplyOrders
(
    supply_id INT NOT NULL,
	booking_id INT NOT NULL,
	quantity INT,
	sell_price NUMERIC(19, 5),
	total_price NUMERIC(19, 5),
	note NVARCHAR(512),
	pet_id INT NOT NULL
)
ALTER TABLE SupplyOrders WITH NOCHECK ADD CONSTRAINT PK_SupplyOrder PRIMARY KEY CLUSTERED(supply_id, booking_id) ON [PRIMARY]
GO
ALTER TABLE dbo.SupplyOrders ADD FOREIGN KEY (booking_id) REFERENCES [dbo].Bookings(id)
GO
ALTER TABLE dbo.SupplyOrders ADD FOREIGN KEY (supply_id) REFERENCES [dbo].Supplies(id)
GO
ALTER TABLE dbo.SupplyOrders ADD FOREIGN KEY (pet_id) REFERENCES [dbo].Pets(id)
GO

CREATE TABLE ServiceOrders
(
    service_id INT NOT NULL,
	booking_id INT NOT NULL,
	quantity INT,
	sell_price NUMERIC(19, 5),
	total_price NUMERIC(19, 5),
	note NVARCHAR(512),
	pet_id INT NOT NULL
)
ALTER TABLE ServiceOrders WITH NOCHECK ADD CONSTRAINT PK_ServiceOrder PRIMARY KEY CLUSTERED(service_id, booking_id) ON [PRIMARY]
GO
ALTER TABLE dbo.ServiceOrders ADD FOREIGN KEY (service_id) REFERENCES [dbo].[Services](id)
GO
ALTER TABLE dbo.ServiceOrders ADD FOREIGN KEY (booking_id) REFERENCES [dbo].Bookings(id)
GO
ALTER TABLE dbo.ServiceOrders ADD FOREIGN KEY (pet_id) REFERENCES [dbo].Pets(id)
GO

CREATE TABLE BookingDetails
(
	id INT PRIMARY KEY IDENTITY,
    booking_id INT NOT NULL,
	price NUMERIC(19, 5),
	cage_code VARCHAR(32) NOT NULL,
	center_id INT NOT NULL,
	duration NUMERIC(19, 5),
	note NVARCHAR(512)
)
ALTER TABLE dbo.BookingDetails ADD FOREIGN KEY (cage_code, center_id) REFERENCES [dbo].Cages(code, center_id)
GO
ALTER TABLE dbo.BookingDetails ADD FOREIGN KEY (booking_id) REFERENCES [dbo].Bookings(id)
GO

CREATE TABLE GeneralLedgers
(
    id INT PRIMARY KEY,
	total_money NUMERIC(19, 5),
	commision_rate NUMERIC(19, 5),
	booking_date DATE,
	center_id INT NOT NULL
)
ALTER TABLE dbo.GeneralLedgers ADD FOREIGN KEY (id) REFERENCES [dbo].Bookings(id)
GO
ALTER TABLE dbo.GeneralLedgers ADD FOREIGN KEY (center_id) REFERENCES [dbo].PetCenters(id)
GO

CREATE TABLE PetBookingDetails
(
    booking_detail_id INT NOT NULL,
	pet_id INT NOT NULL
)
ALTER TABLE PetBookingDetails WITH NOCHECK ADD CONSTRAINT PK_PetBookingDetails PRIMARY KEY CLUSTERED(booking_detail_id, pet_id) ON [PRIMARY]
ALTER TABLE dbo.PetBookingDetails ADD FOREIGN KEY (booking_detail_id) REFERENCES [dbo].BookingDetails(id)
GO
ALTER TABLE dbo.PetBookingDetails ADD FOREIGN KEY (pet_id) REFERENCES [dbo].Pets(id)
GO

CREATE TABLE PhotoTypes
(
    id INT PRIMARY KEY,
	name NVARCHAR(256),
	status BIT DEFAULT 1
)
GO

INSERT INTO dbo.PhotoTypes (id, name)
VALUES (1, 'Admin'),
(2, 'Owner'),
(3, 'Brand'),
(4, 'Pet Center'),
(5, 'Cage'),
(6, 'Customer'),
(7, 'Pet Profile'),
(8, 'Banner'),
(9, 'Service'),
(10, 'Supply'),
(11, 'Activity')
GO

CREATE TABLE Photos
(
	id INT PRIMARY KEY IDENTITY,
	photo_type_id INT NOT NULL,
	id_actor INT NOT NULL,
	url NVARCHAR(512) NOT NULL,
	isThumbnail BIT,
	status BIT DEFAULT 1
)
ALTER TABLE dbo.Photos ADD FOREIGN KEY (photo_type_id) REFERENCES [dbo].PhotoTypes(id)
GO

CREATE TABLE SponsorBanners
(
    id INT IDENTITY PRIMARY KEY,
	title NVARCHAR(256) NOT NULL,
	content NVARCHAR(1024) NOT NULL,
	start_date DATE,
	end_date DATE,
	duration NUMERIC(19, 5),
	create_date DATE DEFAULT GETDATE(),
	modify_date DATE DEFAULT GETDATE(),
	create_user INT,
	modify_user INT,
	status BIT DEFAULT 1,
	brand_id INT NOT NULL
)
ALTER TABLE dbo.SponsorBanners ADD FOREIGN KEY (create_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.SponsorBanners ADD FOREIGN KEY (modify_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.SponsorBanners ADD FOREIGN KEY (brand_id) REFERENCES [dbo].Brands(id)
GO

CREATE TABLE ServicePrices
(
    id INT PRIMARY KEY IDENTITY,
	price NUMERIC(19, 5) NOT NULL,
	min_weight NUMERIC(19, 5),
	max_weight NUMERIC(19, 5),
	create_user INT,
	modify_user INT,
	status BIT DEFAULT 1,
	service_id INT NOT NULL
)
ALTER TABLE dbo.ServicePrices ADD FOREIGN KEY (create_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.ServicePrices ADD FOREIGN KEY (modify_user) REFERENCES [dbo].Accounts(id)
GO
ALTER TABLE dbo.ServicePrices ADD FOREIGN KEY (service_id) REFERENCES [dbo].[Services](id)
GO

--CREATE TABLE BookingActivityLogs
--(
--    id INT PRIMARY KEY IDENTITY,
--	booking_id INT NOT NULL,
--	service_order_id INT NOT NULL,
--	supply_order_id INT NOT NULL,
--	time DATETIME DEFAULT GETDATE(),
--	description NVARCHAR(1024)
--)
--ALTER TABLE dbo.BookingActivityLogs ADD FOREIGN KEY (booking_id) REFERENCES [dbo].Bookings(id)
--GO
--ALTER TABLE dbo.BookingActivityLogs ADD FOREIGN KEY (service_order_id) REFERENCES [dbo].[ServiceOrders](id)
--GO
--ALTER TABLE dbo.BookingActivityLogs ADD FOREIGN KEY (supply_order_id) REFERENCES [dbo].[SupplyOrders](id)
--GO

CREATE TABLE BookingActivities
(
    id INT IDENTITY PRIMARY KEY,
	provide_time DATETIME DEFAULT GETDATE(),
	description NVARCHAR(1024),
	booking_id INT NOT NULL,
	booking_detail_id INT,
	pet_id INT,
	supply_id INT,
	service_id INT
)
ALTER TABLE dbo.BookingActivities ADD FOREIGN KEY (booking_id) REFERENCES [dbo].Bookings(id)
GO
ALTER TABLE dbo.BookingActivities ADD FOREIGN KEY (booking_detail_id) REFERENCES [dbo].BookingDetails(id)
GO
ALTER TABLE dbo.BookingActivities ADD FOREIGN KEY (pet_id) REFERENCES [dbo].Pets(id)
GO
ALTER TABLE dbo.BookingActivities ADD FOREIGN KEY (supply_id) REFERENCES [dbo].Supplies(id)
GO
ALTER TABLE dbo.BookingActivities ADD FOREIGN KEY (service_id) REFERENCES [dbo].[Services](id)
GO

CREATE TABLE FoodSchedule
(
    id INT PRIMARY KEY IDENTITY,
	from_time TIME NOT NULL,
	to_time TIME NOT NULL,
	name NVARCHAR(256),
	cage_type_id INT NOT NULL
)
ALTER TABLE dbo.FoodSchedule ADD FOREIGN KEY (cage_type_id) REFERENCES [dbo].CageTypes(id)
GO