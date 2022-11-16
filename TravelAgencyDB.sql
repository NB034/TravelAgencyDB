USE master
GO
CREATE DATABASE TravelAgencyDB
GO
USE TravelAgencyDB
GO

-- Tables --

CREATE TABLE Employees
(
	id int NOT NULL IDENTITY CONSTRAINT PK_Employees_id PRIMARY KEY,
	surname nvarchar(30) NOT NULL,
	name nvarchar(30) NOT NULL,
	patronymic nvarchar(30),
	birth_date date NOT NULL,
	passport_data nvarchar(15),
	email nvarchar(40),
	phone nvarchar(12) NOT NULL CONSTRAINT UQ_Employees_phone UNIQUE,
	salary money CONSTRAINT CK_Employees_salary CHECK(salary IS NULL OR salary >= 0)

	CONSTRAINT UQ_Employees_phone_surname_name UNIQUE(phone, surname, name)
)
GO
CREATE TABLE Positions
(
	id int NOT NULL IDENTITY CONSTRAINT PK_Positions_id PRIMARY KEY,
	name nvarchar(50) NOT NULL
)
GO
CREATE TABLE Departments
(
	id int NOT NULL IDENTITY CONSTRAINT PK_Departments_id PRIMARY KEY,
	name nvarchar(50) NOT NULL
)
GO
CREATE TABLE Transport
(
	id int NOT NULL IDENTITY CONSTRAINT PK_Transport_id PRIMARY KEY,
	name nvarchar(30) NOT NULL,
	description nvarchar(MAX),
	commentary nvarchar(80)
)
GO
CREATE TABLE Countries
(
	id int NOT NULL IDENTITY CONSTRAINT PK_Countries_id PRIMARY KEY,
	name nvarchar(50) NOT NULL
)
GO
CREATE TABLE Cities
(
	id int NOT NULL IDENTITY CONSTRAINT PK_Cities_id PRIMARY KEY,
	name nvarchar(50) NOT NULL,
	country_id int NOT NULL CONSTRAINT FK_Cities_ref_Countries_id FOREIGN KEY REFERENCES Countries(id)
)
GO
CREATE TABLE Streets
(
	id      int NOT NULL IDENTITY CONSTRAINT PK_Streets_id PRIMARY KEY,
	name    nvarchar(50) NOT NULL,
	city_id int NOT NULL CONSTRAINT FK_Streets_ref_Cities_id FOREIGN KEY REFERENCES Cities(id)
)
GO
CREATE TABLE Addresses
(
	id int NOT NULL IDENTITY CONSTRAINT PK_Addresses_id PRIMARY KEY,
	house smallint NOT NULL CONSTRAINT CK_Addresses_house CHECK(house >= 0),
	street_id int NOT NULL CONSTRAINT FK_Addresses_ref_Streets_id FOREIGN KEY REFERENCES Streets(id),
	what_is_located nvarchar(30),
	commentary nvarchar(80)
)
GO
CREATE TABLE Landmarks
(
	id int NOT NULL IDENTITY CONSTRAINT PK_Landmarks_id PRIMARY KEY,
	name nvarchar(60) NOT NULL,
	address_id int NOT NULL CONSTRAINT FK_Landmarks_ref_Addresses_id FOREIGN KEY REFERENCES Addresses(id),
	path_to_image nvarchar(100),
	commentary nvarchar(80)
)
GO
CREATE TABLE Hotels
(
	id int NOT NULL IDENTITY CONSTRAINT PK_Hotels_id PRIMARY KEY,
	name nvarchar(40) NOT NULL,
	address_id int NOT NULL CONSTRAINT FK_Hotels_ref_Addresses_id FOREIGN KEY REFERENCES Addresses(id),
	path_to_image nvarchar(100),
	commentary nvarchar(80)
)
GO
CREATE TABLE Clients
(
	id int NOT NULL IDENTITY CONSTRAINT PK_Clients_id PRIMARY KEY,
	surname nvarchar(30) NOT NULL,
	name nvarchar(30) NOT NULL,
	patronymic nvarchar(30),
	birth_date date NOT NULL,
	email nvarchar(40),
	phone nvarchar(12) NOT NULL,
	commentary nvarchar(80)

	CONSTRAINT UQ_Clients_phone_surname_name UNIQUE(phone, surname, name, birth_date)
)
GO
CREATE TABLE Tours
(
	id int NOT NULL IDENTITY CONSTRAINT PK_Tours_id PRIMARY KEY,
	name nvarchar(80) NOT NULL,
	status nvarchar(9) NOT NULL CONSTRAINT CK_Tours_status CHECK(status IN ('planned', 'cancelled', 'finished', 'goes')),
	price money CONSTRAINT CK_Tours_price CHECK(price IS NULL OR price >= 0),
	start_date date,
	end_date date,
	max_tourists smallint,
	responsible_employee_id int CONSTRAINT FK_Tours_ref_Employees_id FOREIGN KEY REFERENCES Employees(id),
	description nvarchar(MAX),
	commentary nvarchar(80)
)
GO
CREATE TABLE EmployeesPositionsDepartments
(
	id int NOT NULL IDENTITY CONSTRAINT UQ_EmpPosDep_id UNIQUE,
	employee_id int NOT NULL CONSTRAINT FK_EmpPosDep_ref_Employees_id FOREIGN KEY REFERENCES Employees(id),
	position_id int NOT NULL CONSTRAINT FK_EmpPosDep_ref_Positions_id FOREIGN KEY REFERENCES Positions(id),
	department_id int NOT NULL CONSTRAINT FK_EmpPosDep_ref_Departments_id FOREIGN KEY REFERENCES Departments(id),
	date_of_employment date NOT NULL,
	date_of_dismissal date,
	commentary nvarchar(80)

	CONSTRAINT PK_EmpPosDep_emp_id_pos_id_dep_id  PRIMARY KEY(employee_id, position_id, department_id)
)
GO
CREATE TABLE EmployeesCountries
(
	id int NOT NULL IDENTITY CONSTRAINT UQ_EmloyeesCountries_id UNIQUE,
	employee_id int CONSTRAINT FK_EmloyeesCountries_ref_Employees_id FOREIGN KEY REFERENCES Employees(id),
	country_id int NOT NULL CONSTRAINT FK_EmloyeesCountries_ref_Countries_id FOREIGN KEY REFERENCES Countries(id),
	commentary nvarchar(80)
)
GO
CREATE TABLE ToursTransport
(
	id int NOT NULL IDENTITY CONSTRAINT UQ_ToursTransport_id UNIQUE,
	tour_id int NOT NULL CONSTRAINT FK_ToursTransport_ref_Tours_id FOREIGN KEY REFERENCES Tours(id),
	transport_id int CONSTRAINT FK_ToursTransport_ref_Transport_id FOREIGN KEY REFERENCES Transport(id),
	departure_date date,
	departure_address_id int NOT NULL CONSTRAINT FK_ToursTransport_ref_departure_Addresses_id FOREIGN KEY REFERENCES Addresses(id),
	arrival_date date,
	arrival_address_id int NOT NULL CONSTRAINT FK_ToursTransport_ref_arrival_Addresses_id FOREIGN KEY REFERENCES Addresses(id),
	description nvarchar(MAX),
	commentary nvarchar(80)
)
GO
CREATE TABLE ToursCities
(
	id int NOT NULL IDENTITY CONSTRAINT UQ_ToursCities_id UNIQUE,
	tour_id int NOT NULL CONSTRAINT FK_ToursCities_ref_Tours_id FOREIGN KEY REFERENCES Tours(id),
	city_id int NOT NULL CONSTRAINT FK_ToursCities_ref_Cities_id FOREIGN KEY REFERENCES Cities(id),
	arrival_date date,
	departure_date date,
	commentary nvarchar(80)
)
GO
CREATE TABLE ToursLandmarks
(
	id int NOT NULL IDENTITY CONSTRAINT UQ_ToursLandmarks_id UNIQUE,
	tour_id int NOT NULL CONSTRAINT FK_ToursLandmarks_ref_Tours_id FOREIGN KEY REFERENCES Tours(id),
	landmark_id int NOT NULL CONSTRAINT FK_ToursLandmarks_ref_Landmarks_id FOREIGN KEY REFERENCES Landmarks(id),
	date date,
	price money CONSTRAINT CK_ToursLandmarks_date CHECK(price IS NULL OR price >= 0),
	commentary nvarchar(80)
)
GO
CREATE TABLE ToursHotels
(
	id int NOT NULL IDENTITY CONSTRAINT UQ_ToursHotels_ID UNIQUE,
	tour_id int NOT NULL CONSTRAINT FK_ToursHotels_ref_Tours_id FOREIGN KEY REFERENCES Tours(id),
	hotel_id int NOT NULL CONSTRAINT FK_ToursHotels_ref_Hotels_id FOREIGN KEY REFERENCES Hotels(id),
	arrival_date date,
	departure_date date,
	commentary nvarchar(80)
)
GO
CREATE TABLE ToursClients
(
	id int NOT NULL IDENTITY CONSTRAINT UQ_ToursClients_id UNIQUE,
	tour_id int NOT NULL CONSTRAINT FK_ToursClients_ref_Tours_id FOREIGN KEY REFERENCES Tours(id),
	client_id int NOT NULL CONSTRAINT FK_ToursClients_ref_Clients_id FOREIGN KEY REFERENCES Clients(id),
	status nvarchar(10) NOT NULL CONSTRAINT CK_ToursClients_status CHECK(status IN ('paid', 'not paid', 'interested', 'missed')),
	commentary nvarchar(80)

	CONSTRAINT PK_ToursClients_tour_id_client_id PRIMARY KEY(tour_id, client_id)
)
GO

-- Archives --

CREATE TABLE Archive_Tours
(
	id int NOT NULL IDENTITY CONSTRAINT UQ_Archive_Tours_id UNIQUE,
	record_id int NOT NULL CONSTRAINT PK_Archive_Tours_record_id PRIMARY KEY,
	name nvarchar(80) NOT NULL,
	status nvarchar(9) NOT NULL,
	price money,
	start_date date,
	end_date date,
	max_tourists smallint,
	responsible_employee_id int CONSTRAINT FK_Archive_Tours_ref_Employees_id FOREIGN KEY REFERENCES Employees(id),
	description nvarchar(MAX),
	commentary nvarchar(80)
)
GO
CREATE TABLE Archive_ToursTransport
(
	id int NOT NULL IDENTITY CONSTRAINT UQ_Archive_ToursTransport_id UNIQUE,
	record_id int NOT NULL,
	tour_id int NOT NULL CONSTRAINT FK_Archive_ToursTransport_ref_Tours_id FOREIGN KEY REFERENCES Archive_Tours(id),
	transportation_id int CONSTRAINT FK_Archive_ToursTransport_ref_Transport_id FOREIGN KEY REFERENCES Transport(id),
	departure_date date,
	departure_address_id int NOT NULL CONSTRAINT FK_Archive_ToursTransport_ref_departure_Addresses_id FOREIGN KEY REFERENCES Addresses(id),
	arrival_date date,
	arrival_address_id int NOT NULL CONSTRAINT FK_Archive_ToursTransport_ref_arrival_Addresses_id FOREIGN KEY REFERENCES Addresses(id),
	description nvarchar(MAX),
	commentary nvarchar(80)
)
GO
CREATE TABLE Archive_ToursCities
(
	id int NOT NULL IDENTITY CONSTRAINT UQ_Archive_ToursCities_id UNIQUE,
	record_id int NOT NULL,
	tour_id int NOT NULL CONSTRAINT FK_Archive_ToursCities_ref_Tours_id FOREIGN KEY REFERENCES Archive_Tours(id),
	city_id int NOT NULL CONSTRAINT FK_Archive_ToursCities_ref_Cities_id FOREIGN KEY REFERENCES Cities(id),
	arrival_date date,
	departure_date date,
	commentary nvarchar(80)
)
GO
CREATE TABLE Archive_ToursLandmarks
(
	id int NOT NULL IDENTITY CONSTRAINT UQ_Archive_ToursLandmarks_id UNIQUE,
	record_id int NOT NULL,
	tour_id int NOT NULL CONSTRAINT FK_Archive_ToursLandmarks_ref_Tours_id FOREIGN KEY REFERENCES Archive_Tours(id),
	landmark_id int NOT NULL CONSTRAINT FK_Archive_ToursLandmarks_ref_Landmarks_id FOREIGN KEY REFERENCES Landmarks(id),
	date date,
	price money,
	commentary nvarchar(80)
)
GO
CREATE TABLE Archive_ToursHotels
(
	id int NOT NULL IDENTITY CONSTRAINT UQ_Archive_ToursHotels_ID UNIQUE,
	record_id int NOT NULL,
	tour_id int NOT NULL CONSTRAINT FK_Archive_ToursHotels_ref_Tours_id FOREIGN KEY REFERENCES Archive_Tours(id),
	hotel_id int NOT NULL CONSTRAINT FK_Archive_ToursHotels_ref_Hotels_id FOREIGN KEY REFERENCES Hotels(id),
	arrival_date date,
	departure_date date,
	commentary nvarchar(80)
)
GO
CREATE TABLE Archive_ToursClients
(
	id int NOT NULL IDENTITY CONSTRAINT UQ_Archive_ToursClients_id UNIQUE,
	record_id int NOT NULL,
	tour_id int NOT NULL CONSTRAINT FK_Archive_ToursClients_ref_Tours_id FOREIGN KEY REFERENCES Archive_Tours(id),
	client_id int NOT NULL CONSTRAINT FK_Archive_ToursClients_ref_Clients_id FOREIGN KEY REFERENCES Clients(id),
	status nvarchar(10) NOT NULL,
	commentary nvarchar(80)

	CONSTRAINT PK_Archive_ToursClients_tour_id_client_id PRIMARY KEY(tour_id, client_id)
)
GO

-- Indexes for the non-archive tables--

CREATE CLUSTERED INDEX CL_EmployeesCountries_employee_id        ON TravelAgencyDB.dbo.EmployeesCountries(employee_id);              
CREATE CLUSTERED INDEX CL_ToursTransport_tour_id                ON TravelAgencyDB.dbo.ToursTransport(tour_id);                     
CREATE CLUSTERED INDEX CL_ToursCities_tour_id                   ON TravelAgencyDB.dbo.ToursCities(tour_id);                        
CREATE CLUSTERED INDEX CL_ToursLandmarks_tour_id                ON TravelAgencyDB.dbo.ToursLandmarks(tour_id);                     
CREATE CLUSTERED INDEX CL_ToursHotels_tour_id                   ON TravelAgencyDB.dbo.ToursHotels(tour_id);                        
CREATE UNIQUE INDEX    UX_ToursClients_tour_id_client_id_status ON TravelAgencyDB.dbo.ToursClients(tour_id, client_id, status);    
CREATE UNIQUE INDEX    UX_ToursClients_client_id_tour_id_status ON TravelAgencyDB.dbo.ToursClients(client_id, tour_id, status);    
CREATE INDEX           IX_Landmarks_address                     ON TravelAgencyDB.dbo.Landmarks(address_id);                       
CREATE INDEX           IX_Hotels_address                        ON TravelAgencyDB.dbo.Hotels(address_id);                          
CREATE INDEX           IX_Tours_start_date_end_date_status      ON TravelAgencyDB.dbo.Tours(start_date, end_date, status);         
CREATE INDEX           IX_ToursTransport_dep_date_arr_date      ON TravelAgencyDB.dbo.ToursTransport(departure_date, arrival_date);
CREATE INDEX           IX_ToursCities_arr_date_dep_date         ON TravelAgencyDB.dbo.ToursCities(arrival_date, departure_date);   
CREATE INDEX           IX_ToursLandmarks_date                   ON TravelAgencyDB.dbo.ToursLandmarks(date);                        
CREATE INDEX           IX_ToursHotels_arr_date_dep_date         ON TravelAgencyDB.dbo.ToursHotels(arrival_date, departure_date); 
GO

-- Indexes for the archive tables--

CREATE CLUSTERED INDEX CL_Archive_ToursTransport_tour_id                ON TravelAgencyDB.dbo.Archive_ToursTransport(tour_id);                      
CREATE CLUSTERED INDEX CL_Archive_ToursCities_tour_id                   ON TravelAgencyDB.dbo.Archive_ToursCities(tour_id);                         
CREATE CLUSTERED INDEX CL_Archive_ToursLandmarks_tour_id                ON TravelAgencyDB.dbo.Archive_ToursLandmarks(tour_id);                      
CREATE CLUSTERED INDEX CL_Archive_ToursHotels_tour_id                   ON TravelAgencyDB.dbo.Archive_ToursHotels(tour_id);                         
CREATE UNIQUE INDEX    UX_Archive_ToursClients_tour_id_client_id_status ON TravelAgencyDB.dbo.Archive_ToursClients(tour_id, client_id, status);     
CREATE UNIQUE INDEX    UX_Archive_ToursClients_client_id_tour_id_status ON TravelAgencyDB.dbo.Archive_ToursClients(client_id, tour_id, status);     
CREATE INDEX           IX_Archive_Tours_start_date_end_date_status      ON TravelAgencyDB.dbo.Archive_Tours(start_date, end_date, status);          
CREATE INDEX           IX_Archive_ToursTransport_dep_date_arr_date      ON TravelAgencyDB.dbo.Archive_ToursTransport(departure_date, arrival_date); 
CREATE INDEX           IX_Archive_ToursCities_arr_date_dep_date         ON TravelAgencyDB.dbo.Archive_ToursCities(arrival_date, departure_date);    
CREATE INDEX           IX_Archive_ToursLandmarks_date                   ON TravelAgencyDB.dbo.Archive_ToursLandmarks(date);                         
CREATE INDEX           IX_Archive_ToursHotels_arr_date_dep_date         ON TravelAgencyDB.dbo.Archive_ToursHotels(arrival_date, departure_date); 
GO

-- Roles and users --
/*
EXECUTE sp_addlogin @loginame = 'Director',        @passwd = 'temporary', @defdb = 'TravelAgencyDB'
EXECUTE sp_addlogin @loginame = 'Admin assistant', @passwd = 'temporary', @defdb = 'TravelAgencyDB'
EXECUTE sp_addlogin @loginame = 'User admin',      @passwd = 'temporary', @defdb = 'TravelAgencyDB'
EXECUTE sp_addlogin @loginame = 'Data admin',      @passwd = 'temporary', @defdb = 'TravelAgencyDB'
EXECUTE sp_addlogin @loginame = 'Backup operator', @passwd = 'temporary', @defdb = 'TravelAgencyDB'
EXECUTE sp_addlogin @loginame = 'Accountant',      @passwd = 'temporary', @defdb = 'TravelAgencyDB'
EXECUTE sp_addlogin @loginame = 'Client manager',  @passwd = 'temporary', @defdb = 'TravelAgencyDB'
EXECUTE sp_addlogin @loginame = 'Tourism manager', @passwd = 'temporary', @defdb = 'TravelAgencyDB'
EXECUTE sp_addlogin @loginame = 'HR manager',      @passwd = 'temporary', @defdb = 'TravelAgencyDB'

EXECUTE sp_grantdbaccess @loginame = 'Director'
EXECUTE sp_grantdbaccess @loginame = 'Admin assistant'
EXECUTE sp_grantdbaccess @loginame = 'Backup operator'
EXECUTE sp_grantdbaccess @loginame = 'User admin'
EXECUTE sp_grantdbaccess @loginame = 'Data admin'
EXECUTE sp_grantdbaccess @loginame = 'Accountant'
EXECUTE sp_grantdbaccess @loginame = 'Client manager'
EXECUTE sp_grantdbaccess @loginame = 'Tourism manager'
EXECUTE sp_grantdbaccess @loginame = 'HR manager'

EXECUTE sp_addsrvrolemember @loginame = 'Director',        @rolename = 'sysadmin'
EXECUTE sp_addsrvrolemember @loginame = 'Admin assistant', @rolename = 'serveradmin'
EXECUTE sp_addsrvrolemember @loginame = 'Admin assistant', @rolename = 'setupadmin'
EXECUTE sp_addsrvrolemember @loginame = 'Admin assistant', @rolename = 'securityadmin'
EXECUTE sp_addsrvrolemember @loginame = 'Admin assistant', @rolename = 'processadmin'
EXECUTE sp_addsrvrolemember @loginame = 'User admin',      @rolename = 'securityadmin'
EXECUTE sp_addsrvrolemember @loginame = 'Data admin',      @rolename = 'bulkadmin'

EXECUTE sp_addrolemember @rolename = 'db_owner',          @membername = 'Director'
EXECUTE sp_addrolemember @rolename = 'db_accessadmin',    @membername = 'Admin assistant'
EXECUTE sp_addrolemember @rolename = 'db_securityadmin',  @membername = 'Admin assistant'
EXECUTE sp_addrolemember @rolename = 'db_ddladmin',       @membername = 'Admin assistant'
EXECUTE sp_addrolemember @rolename = 'db_datareader',     @membername = 'Admin assistant'
EXECUTE sp_addrolemember @rolename = 'db_datawriter',     @membername = 'Admin assistant'
EXECUTE sp_addrolemember @rolename = 'db_accessadmin',    @membername = 'User admin'
EXECUTE sp_addrolemember @rolename = 'db_securityadmin',  @membername = 'User admin'
EXECUTE sp_addrolemember @rolename = 'db_datareader',     @membername = 'Data admin'
EXECUTE sp_addrolemember @rolename = 'db_datawriter',     @membername = 'Data admin'
EXECUTE sp_addrolemember @rolename = 'db_backupoperator', @membername = 'Backup operator'
EXECUTE sp_addrolemember @rolename = 'db_datareader',     @membername = 'Accountant'
EXECUTE sp_addrolemember @rolename = 'db_datawriter',     @membername = 'Accountant'

EXECUTE sp_addrole @rolename = 'db_clientmanager'
GRANT   SELECT, INSERT, UPDATE ON Clients                TO db_clientmanager
GRANT   SELECT, INSERT, UPDATE ON ToursClients           TO db_clientmanager
GRANT   SELECT                 ON Transport              TO db_clientmanager
GRANT   SELECT                 ON Countries		         TO db_clientmanager
GRANT   SELECT                 ON Cities		         TO db_clientmanager
GRANT   SELECT                 ON Streets		         TO db_clientmanager
GRANT   SELECT                 ON Addresses		         TO db_clientmanager
GRANT   SELECT                 ON Landmarks		         TO db_clientmanager
GRANT   SELECT                 ON Hotels		         TO db_clientmanager
GRANT   SELECT                 ON Tours			         TO db_clientmanager
GRANT   SELECT                 ON ToursTransport         TO db_clientmanager
GRANT   SELECT                 ON ToursCities	         TO db_clientmanager
GRANT   SELECT                 ON ToursLandmarks         TO db_clientmanager
GRANT   SELECT                 ON ToursHotels	         TO db_clientmanager
GRANT   SELECT                 ON Archive_Tours			 TO db_clientmanager
GRANT   SELECT                 ON Archive_ToursTransport TO db_clientmanager
GRANT   SELECT                 ON Archive_ToursCities	 TO db_clientmanager
GRANT   SELECT                 ON Archive_ToursLandmarks TO db_clientmanager
GRANT   SELECT                 ON Archive_ToursHotels	 TO db_clientmanager
GRANT   SELECT                 ON Archive_ToursClients	 TO db_clientmanager

EXECUTE sp_addrole @rolename = 'db_tourismmanager'
GRANT   SELECT, INSERT, UPDATE ON Tours                         TO db_tourismmanager
GRANT   SELECT, INSERT, UPDATE ON ToursTransport                TO db_tourismmanager
GRANT   SELECT, INSERT, UPDATE ON ToursCities                   TO db_tourismmanager
GRANT   SELECT, INSERT, UPDATE ON ToursLandmarks                TO db_tourismmanager
GRANT   SELECT, INSERT, UPDATE ON ToursHotels                   TO db_tourismmanager
GRANT   SELECT, INSERT, UPDATE ON ToursClients					TO db_tourismmanager
GRANT   SELECT                 ON Transport                     TO db_tourismmanager
GRANT   SELECT                 ON Countries						TO db_tourismmanager
GRANT   SELECT                 ON Cities						TO db_tourismmanager
GRANT   SELECT                 ON Streets						TO db_tourismmanager
GRANT   SELECT                 ON Addresses						TO db_tourismmanager
GRANT   SELECT                 ON Landmarks						TO db_tourismmanager
GRANT   SELECT                 ON Hotels						TO db_tourismmanager
GRANT   SELECT                 ON Clients						TO db_tourismmanager
GRANT   SELECT                 ON EmployeesPositionsDepartments	TO db_tourismmanager
GRANT   SELECT                 ON EmployeesCountries			TO db_tourismmanager
GRANT   SELECT                 ON Archive_Tours			        TO db_tourismmanager
GRANT   SELECT                 ON Archive_ToursTransport        TO db_tourismmanager
GRANT   SELECT                 ON Archive_ToursCities	        TO db_tourismmanager
GRANT   SELECT                 ON Archive_ToursLandmarks        TO db_tourismmanager
GRANT   SELECT                 ON Archive_ToursHotels	        TO db_tourismmanager
GRANT   SELECT                 ON Archive_ToursClients	        TO db_tourismmanager

EXECUTE sp_addrole @rolename = 'db_hrmanager'
GRANT   SELECT, INSERT, UPDATE ON Employees                     TO db_hrmanager
GRANT   SELECT, INSERT, UPDATE ON EmployeesCountries            TO db_hrmanager
GRANT   SELECT, INSERT, UPDATE ON EmployeesPositionsDepartments TO db_hrmanager
GRANT   SELECT                 ON Countries                     TO db_hrmanager
GRANT   SELECT                 ON Positions                     TO db_hrmanager
GRANT   SELECT                 ON Departments                   TO db_hrmanager

EXECUTE sp_addrolemember @rolename = 'db_clientmanager',  @membername = 'Client manager'
EXECUTE sp_addrolemember @rolename = 'db_tourismmanager', @membername = 'Tourism manager'
EXECUTE sp_addrolemember @rolename = 'db_hrmanager',      @membername = 'HR manager'
GO
*/

-- Views --

CREATE VIEW V_tours
AS
SELECT t.id [tour_id],     t.name [tour_name], t.status, t.price, t.start_date,  t.end_date, t.max_tourists, 
	   e.id [employee_id], e.surname,          e.name,   e.phone, t.description, t.commentary
FROM Tours t
LEFT JOIN Employees e ON t.responsible_employee_id = e.id
GO

CREATE VIEW V_archive_tours
AS
SELECT t.record_id [tour_id], t.name [tour_name], t.status, t.price, t.start_date,  t.end_date, t.max_tourists, 
	   e.id [employee_id],    e.surname,          e.name,   e.phone, t.description, t.commentary
FROM Archive_Tours t
LEFT JOIN Employees e ON t.responsible_employee_id = e.id
GO

CREATE VIEW V_all_tours
AS
SELECT * FROM V_tours
UNION ALL
SELECT * FROM V_archive_tours
GO

CREATE VIEW V_planned_tours
AS
SELECT *
FROM V_tours vt
WHERE vt.status = 'planned'
GO

CREATE VIEW V_list_of_clients_in_planned_tours
AS
SELECT vpt.tour_id,      vpt.name [tour_name], vpt.start_date, vpt.end_date, vpt.max_tourists,
	   c.id [client_id], c.surname,            c.name,         c.phone,      tc.status
FROM V_planned_tours vpt
LEFT JOIN ToursClients tc ON tc.tour_id = vpt.tour_id
LEFT JOIN Clients c ON c.id = tc.client_id
GO

CREATE VIEW V_list_of_clients_in_archive_tours
AS
SELECT vat.tour_id,      vat.name [tour_name], vat.start_date, vat.end_date, vat.max_tourists,
	   c.id [client_id], c.surname,            c.name,         c.phone,      tc.status
FROM V_archive_tours vat
LEFT JOIN ToursClients tc ON tc.tour_id = vat.tour_id
LEFT JOIN Clients c ON c.id = tc.client_id
GO

CREATE VIEW V_full_addresses
AS
SELECT co.id [country_id], co.name [country], c.id [city_id],  c.name [city], 
	   s.id  [street_id],  s.name  [street],  a.id [house_id], a.house,
	   co.name + ', ' + c.name + ', ' + s.name + ', ' + a.house [full_address]
FROM Addresses a
LEFT JOIN Streets s    ON s.id = a.street_id
LEFT JOIN Cities c     ON c.id = s.city_id
LEFT JOIN Countries co ON co.id = c.country_id
GO

CREATE VIEW V_number_of_clients_in_planned_tours
AS
SELECT tour_id, tour_name, max_tourists, COUNT(client_id) [vouchers_purchased]
FROM V_list_of_clients_in_planned_tours
WHERE status = 'paid'
GROUP BY tour_id, tour_name, max_tourists
GO

CREATE VIEW V_number_of_clients_in_archive_tours
AS
SELECT tour_id, tour_name, max_tourists, COUNT(client_id) [vouchers_purchased]
FROM V_list_of_clients_in_archive_tours
WHERE status = 'paid'
GROUP BY tour_id, tour_name, max_tourists
GO

-- Functions --

CREATE FUNCTION F_tours_in_range(@start_date date, @end_date date)
RETURNS TABLE
AS
RETURN	SELECT *
		FROM V_tours vt
		WHERE @start_date <= vt.start_date AND vt.end_date <= @end_date
GO

CREATE FUNCTION F_tours_visits_countries()
RETURNS TABLE
AS
RETURN	SELECT DISTINCT vt.tour_id, vt.name [tour], co.name [country]
		FROM V_tours vt
		LEFT JOIN ToursCities tc ON tc.tour_id = vt.tour_id
		LEFT JOIN Cities c       ON tc.city_id = c.id
		LEFT JOIN Countries co   ON co.id      = c.country_id
GO

CREATE FUNCTION F_all_tours_visits_countries()
RETURNS TABLE
AS
RETURN	SELECT DISTINCT vt.tour_id, vt.name [tour], co.name [country]
		FROM V_all_tours vt
		LEFT JOIN ToursCities tc ON tc.tour_id = vt.tour_id
		LEFT JOIN Cities c       ON tc.city_id = c.id
		LEFT JOIN Countries co   ON co.id      = c.country_id
GO

CREATE FUNCTION F_tours_that_visits(@country nvarchar(50))
RETURNS TABLE
AS
RETURN	SELECT vt.*
		FROM V_tours vt
		INNER JOIN (SELECT * FROM F_tours_visits_countries() WHERE country = @country) t ON t.tour_id = vt.tour_id
GO

CREATE FUNCTION F_popularity_of_countries()
RETURNS TABLE
AS
RETURN	SELECT country, COUNT(country) [tours_visits]
		FROM F_all_tours_visits_countries()
		GROUP BY country
GO

CREATE FUNCTION F_most_popular_country(@country nvarchar(50))
RETURNS TABLE
AS
RETURN	SELECT *
		FROM F_popularity_of_countries()
		WHERE tours_visits = (SELECT MAX(tours_visits) FROM F_popularity_of_countries())
GO

CREATE FUNCTION F_most_popular_tours()
RETURNS TABLE
AS
RETURN	SELECT *
		FROM V_number_of_clients_in_planned_tours
		WHERE vouchers_purchased = (SELECT MAX(vouchers_purchased) 
									FROM V_number_of_clients_in_planned_tours)
GO

CREATE FUNCTION F_most_popular_archive_tours()
RETURNS TABLE
AS
RETURN	SELECT *
		FROM V_number_of_clients_in_archive_tours
		WHERE vouchers_purchased = (SELECT MAX(vouchers_purchased) 
									FROM V_number_of_clients_in_archive_tours)
GO

CREATE FUNCTION F_most_unpopular_tours()
RETURNS TABLE
AS
RETURN	SELECT *
		FROM V_number_of_clients_in_planned_tours
		WHERE vouchers_purchased = (SELECT MIN(vouchers_purchased) 
									FROM V_number_of_clients_in_planned_tours)
GO

CREATE FUNCTION F_tours_of_client(@surname nvarchar(30), @name nvarchar(30), @patronymic nvarchar(30) = NULL)
RETURNS TABLE 
AS
RETURN	SELECT vt.*
		FROM V_tours vt
		LEFT JOIN ToursClients tc ON tc.tour_id = vt.tour_id
		LEFT JOIN Clients c On c.id = tc.client_id
		WHERE 1 = 1
		AND tc.status = 'paid'
		AND @surname = c.surname
		AND @name = c.name
		AND (@patronymic IS NULL OR @patronymic = c.patronymic)
GO

CREATE FUNCTION F_archive_tours_of_client(@surname nvarchar(30), @name nvarchar(30), @patronymic nvarchar(30) = NULL)
RETURNS TABLE 
AS
RETURN	SELECT vat.*
		FROM V_archive_tours vat
		LEFT JOIN ToursClients tc ON tc.tour_id = vat.tour_id
		LEFT JOIN Clients c On c.id = tc.client_id
		WHERE 1 = 1
		AND tc.status = 'paid'
		AND @surname = c.surname
		AND @name = c.name
		AND (@patronymic IS NULL OR @patronymic = c.patronymic)
GO

CREATE FUNCTION F_all_tours_of_client(@surname nvarchar(30), @name nvarchar(30), @patronymic nvarchar(30) = NULL)
RETURNS TABLE 
AS
RETURN	SELECT * FROM F_tours_of_client(@surname, @name, @patronymic)
		UNION ALL
		SELECT * FROM F_archive_tours_of_client(@surname, @name, @patronymic)
GO

CREATE FUNCTION F_clients_activity()
RETURNS TABLE
AS
RETURN  SELECT c.surname, c.name, c.phone, 
			  (SELECT COUNT(1)
			   FROM F_all_tours_of_client(c.surname, c.name, c.phone) t
			   WHERE t.status = 'paid') [tours]
	    FROM Clients c
GO

CREATE FUNCTION F_most_active_client()
RETURNS TABLE
AS
RETURN  SELECT *
		FROM F_clients_activity() t
		WHERE t.tours = (SELECT MAX(tours) FROM F_clients_activity()) 
GO

CREATE FUNCTION F_tours_that_involved_transport(@transport_name nvarchar(30))
RETURNS TABLE
AS
RETURN  SELECT DISTINCT vat.*
		FROM V_all_tours vat
		LEFT JOIN ToursTransport tt ON tt.tour_id = vat.tour_id
		LEFT JOIN Transport t On t.id = tt.transport_id
		WHERE @transport_name = t.name
GO

CREATE FUNCTION F_hotels_visited()
RETURNS TABLE
AS
RETURN  SELECT t.name, COUNT(1) [visits], vfa.full_address
		FROM (SELECT h.name, h.address_id
			  FROM V_tours vt
			  LEFT JOIN ToursHotels th ON th.tour_id = vt.tour_id
			  LEFT JOIN Hotels h ON h.id = th.hotel_id
			  UNION ALL
			  SELECT h.name, h.address_id
			  FROM V_archive_tours vat
			  LEFT JOIN Archive_ToursHotels ath ON ath.tour_id = vat.tour_id
			  LEFT JOIN Hotels h ON h.id = ath.hotel_id) t
		LEFT JOIN V_full_addresses vfa ON t.address_id = vfa.house_id
		GROUP BY t.name, vfa.full_address
GO

-- Procedures --

CREATE PROCEDURE P_which_tour_is_the_client_on(@surname nvarchar(30), @name nvarchar(30), @patronymic nvarchar(30) = NULL)
AS
BEGIN
	DECLARE @check int
	SET @check = (SELECT COUNT(1) 
		FROM F_tours_of_client(@surname, @name, @patronymic) t
		WHERE t.status = 'goes')
	IF @check = 0
		RAISERROR('The client is not on tour.', 0, 1)
	ELSE
		SELECT *
		FROM F_tours_of_client(@surname, @name, @patronymic) t
		WHERE t.status = 'goes'
	IF @check > 1
		RAISERROR('Wrong data! Multiple records found.', 0, 1)
END
GO

CREATE PROCEDURE P_where_is_client(@surname nvarchar(30), @name nvarchar(30), @patronymic nvarchar(30) = NULL)
AS
BEGIN
	DECLARE @check int
	SET @check = (SELECT COUNT(1) 
		FROM F_tours_of_client(@surname, @name, @patronymic) t
		WHERE t.status = 'goes')
	IF @check = 0
		RAISERROR('The client is not on tour.', 0, 1)
	ELSE
		SELECT t.tour_name, co.name
		FROM (SELECT *
			  FROM F_tours_of_client(@surname, @name, @patronymic) t
			  WHERE t.status = 'goes') t
			  LEFT JOIN ToursCities tc ON tc.tour_id = t.tour_id
			  LEFT JOIN Cities c       ON tc.city_id = c.id
			  LEFT JOIN Countries co   ON co.id = c.country_id
		WHERE GETDATE() BETWEEN tc.arrival_date AND tc.departure_date
	IF @check > 1
		RAISERROR('Wrong data! Multiple records found.', 0, 1)
END
GO

-- Triggers --

CREATE TRIGGER T_delete_tours_into_archive
ON Tours
INSTEAD OF DELETE
AS
BEGIN
	INSERT INTO Archive_Tours
	SELECT * 
	FROM deleted

	INSERT INTO Archive_ToursCities
	SELECT * 
	FROM ToursCities 
	WHERE tour_id IN (SELECT id FROM deleted)

	INSERT INTO Archive_ToursClients
	SELECT * 
	FROM ToursClients 
	WHERE tour_id IN (SELECT id FROM deleted)

	INSERT INTO Archive_ToursHotels
	SELECT * 
	FROM ToursHotels 
	WHERE tour_id IN (SELECT id FROM deleted)

	INSERT INTO Archive_ToursLandmarks
	SELECT * 
	FROM ToursLandmarks 
	WHERE tour_id IN (SELECT id FROM deleted)

	INSERT INTO Archive_ToursTransport
	SELECT * 
	FROM ToursTransport 
	WHERE tour_id IN (SELECT id FROM deleted)

	DELETE FROM ToursCities
	WHERE tour_id IN (SELECT id FROM deleted)

	DELETE FROM ToursClients
	WHERE tour_id IN (SELECT id FROM deleted)

	DELETE FROM ToursHotels
	WHERE tour_id IN (SELECT id FROM deleted)

	DELETE FROM ToursLandmarks
	WHERE tour_id IN (SELECT id FROM deleted)

	DELETE FROM ToursTransport
	WHERE tour_id IN (SELECT id FROM deleted)

	DELETE FROM Tours
	WHERE id IN (SELECT id FROM deleted)
END
GO

CREATE TRIGGER T_is_max_tourists_on_insert
ON ToursClients
INSTEAD OF INSERT
AS
BEGIN
	IF EXISTS (SELECT * 
			   FROM inserted i
			   INNER JOIN V_number_of_clients_in_planned_tours v ON v.tour_id = i.tour_id
			   WHERE v.max_tourists < v.vouchers_purchased + (SELECT COUNT(1)
															  FROM inserted
															  WHERE tour_id = i.tour_id))
	BEGIN
		RAISERROR('The data cannot be inserted because the limit of seats in one or more tours will be exceeded.', 0, 1)
	END

	ELSE
	BEGIN
		INSERT INTO ToursClients
		SELECT i.tour_id, i.client_id, i.status, i.commentary
		FROM inserted i
	END
END
GO

CREATE TRIGGER T_is_max_tourists_on_update
ON ToursClients
INSTEAD OF UPDATE
AS
BEGIN
	IF UPDATE(status) 
	AND EXISTS (SELECT *
				FROM inserted i
				INNER JOIN V_number_of_clients_in_planned_tours v ON v.tour_id = i.tour_id
				WHERE v.max_tourists < v.vouchers_purchased + (SELECT COUNT(status) 
															   FROM inserted 
															   WHERE status = 'paid' AND i.tour_id = tour_id) 
															- (SELECT COUNT(status) 
															   FROM deleted 
															   WHERE status = 'paid' AND i.tour_id = tour_id))
	BEGIN
		RAISERROR('The data cannot be updated because the limit of seats in one or more tours will be exceeded.', 0, 1)
	END

	ELSE
	BEGIN
		IF UPDATE(tour_id)
			UPDATE ToursClients 
			SET tour_id = i.tour_id
			FROM inserted i
			WHERE ToursClients.id = i.id
		IF UPDATE(client_id)
			UPDATE ToursClients 
			SET client_id = i.client_id
			FROM inserted i
			WHERE ToursClients.id = i.id
		IF UPDATE(status)
			UPDATE ToursClients 
			SET status = i.status
			FROM inserted i
			WHERE ToursClients.id = i.id
		IF UPDATE(commentary)
			UPDATE ToursClients 
			SET commentary = i.commentary
			FROM inserted i
			WHERE ToursClients.id = i.id
	END
END
GO

-- For backups --

--BACKUP DATABASE TravelAgencyDB
--TO DISK = 'path'
--   WITH FORMAT,
--      NAME = 'TravelAgencyDB full backup';
--GO

--BACKUP DATABASE TravelAgencyDB
--   TO DISK = 'path'
--   WITH DIFFERENTIAL;  
--GO

--BACKUP LOG TravelAgencyDB
--   TO DISK = 'path'
--GO