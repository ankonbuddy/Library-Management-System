Create database LabFinal
use LabFinal
CREATE TABLE Branch (Libid INT, Name nvarchar(50) NOT NULL, Location nvarchar(50) NOT NULL, CONSTRAINT pk_Branch PRIMARY KEY (Libid))
INSERT INTO Branch VALUES (1,'Kunipara Libraray','Tejgaon')
INSERT INTO Branch VALUES (2,'Fatullah Libraray','Narayanganj')
INSERT INTO Branch VALUES (3,'ECB chattor Libraray ','Mirpur')
INSERT INTO Branch VALUES (4,'BusStand Libraray','Kallayanpur')
INSERT INTO Branch VALUES (5,'House Building Libraray','Uttara')
CREATE TABLE Reader (Reader_id INT, Type nvarchar(20) NOT NULL, ReaderName nvarchar(50) NOT NULL, Phone_no nvarchar(12) NOT NULL, Address nvarchar(100) NOT NULL, CONSTRAINT pk_Reader PRIMARY KEY (Reader_id), CONSTRAINT uq_Reader_Phone UNIQUE (Phone_no))
INSERT INTO Reader VALUES(1001,'Student','Tabassum Susmita','01848987247','Tejgaon')
INSERT INTO Reader VALUES(1002,'Senior citizen','Nafiur Rahman','019137837768','Kallayanpur')
INSERT INTO Reader VALUES(1003,'Senior citizen','Ashraf Ahmed','01842926249','Mirpur')
INSERT INTO Reader VALUES(1004,'Student','Arafat Islam','01896423297','Tejgaon')
INSERT INTO Reader VALUES(1005,'Staff','Nafis Ahmed','01798484822','Uttara')
INSERT INTO Reader VALUES(1006,'Staff','Moinul Islam','01768324999','Tejaon')
INSERT INTO Reader VALUES(1007,'Student','Ether Islam','01889383687','Kallayanpur')
CREATE TABLE Publisher (Publisher_id INT, Pub_Name nvarchar(50) NOT NULL, Address nvarchar(100) NOT NULL, CONSTRAINT pk_Publisher PRIMARY KEY (Publisher_id), CONSTRAINT uq_PubName UNIQUE(Pub_Name))
INSERT INTO Publisher VALUES(2001,'Akkhorpotro','Mirpur')
INSERT INTO Publisher VALUES(2002,'Agani prokasoni','Mirpur')
INSERT INTO Publisher VALUES(2003,'Publishing House','khilgaon')
INSERT INTO Publisher VALUES(2004,'Biddaprokash','Tejgaon')
INSERT INTO Publisher VALUES(2005,'Asia Publication','Uttara')
INSERT INTO Publisher VALUES(2006,'Boral Prokasoni','Khilgaon')

CREATE TABLE BOR_Transaction (BorNumber INT, BorDateTime DATETIME NOT NULL, RetDateTime DATETIME, CONSTRAINT pk_BOR_Transaction Primary key (BorNumber))
INSERT INTO BOR_Transaction VALUES(3001,'1-3-2023 09:20','2-13-2023 09:20')
INSERT INTO BOR_Transaction VALUES(3002,'1-13-2023 17:00','2-20-2023 17:00')
INSERT INTO BOR_Transaction VALUES(3003,'1-23-2023 16:40','2-21-2023 16:40')
INSERT INTO BOR_Transaction VALUES(3004,'1-24-2023 16:20','5-16-2023 16:20')
INSERT INTO BOR_Transaction VALUES(3005,'2-2-2023 16:00','5-23-2023 16:00')
INSERT INTO BOR_Transaction VALUES(3006,'2-9-2023 15:40','5-25-2023 15:40')
CREATE TABLE Reservation (ResNumber int, ResDateTime datetime NOT NULL, Reservation_Status nvarchar(10) constraint pk_Reservation PRIMARY key (ResNumber))
INSERT INTO Reservation VALUES(4001,'5-11-2023 13:40','Cancelled')
INSERT INTO Reservation VALUES(4002,'6-30-2023 13:40', 'Reserved')
INSERT INTO Reservation VALUES(4003,'9-19-2023 12:20', 'Cancelled')
INSERT INTO Reservation VALUES(4004,'11-21-2023 10:00', 'Cancelled')
INSERT INTO Reservation VALUES(4005,'6-14-2023 13:20', 'Reserved')
INSERT INTO Reservation VALUES(4006,'5-23-2023 16:00', 'Reserved')
INSERT INTO Reservation VALUES(4008,'5-23-2023 16:00', 'Reserved')
CREATE TABLE Chief_Editor (EditorId int, Ename nvarchar(50) NOT NULL, CONSTRAINT pk_Cheif_Editor primary key (EditorId))
INSERT INTO Chief_Editor VALUES(4001,'Fariha Islam')
INSERT INTO Chief_Editor VALUES(4002,'Mushfiq Rahman')
INSERT INTO Chief_Editor VALUES(4003,'Ashraf Ahmad')
INSERT INTO Chief_Editor VALUES(4004,'Ziaul Hasan')
INSERT INTO Chief_Editor VALUES(4005,'Zakia Pranty')
INSERT INTO Chief_Editor VALUES(4006,'Zarin Tasnim')

CREATE TABLE Author (AuthorId int, Aname nvarchar(50) NOT NULL, constraint pk_Author primary key (AuthorId))
INSERT INTO Author VALUES(5001,'Humayan Ahmed')
INSERT INTO Author VALUES(5002,'Zafor Iqbal')
INSERT INTO Author VALUES(5003,'Zahanara Emam')
INSERT INTO Author VALUES(5004,'Begum Rockeya')
INSERT INTO Author VALUES(5005,'Rabindranath Tagor')
INSERT INTO Author VALUES(5006,'Kazi Nazrul Islam')

CREATE TABLE Document (DocId int, Title nvarchar(50) NOT NULL, Pdate DATE, PublisherID int, CONSTRAINT pk_Document Primary key (DocId), Constraint fk_Document_Publisher Foreign key (PublisherId) references Publisher)
INSERT INTO Document VALUES(6001,'Amar ache jol','3-23-2009','2001')
INSERT INTO Document VALUES(6002,'Dipu Number 1','7-7-2009','2003')
INSERT INTO Document VALUES(6003,'Ekkaturer Dinguli','4-1-2010','2004')
INSERT INTO Document VALUES(6004,'Sultanar Sopno','6-30-2010','2004')
INSERT INTO Document VALUES(6005,'Choker Bali','9-28-2010','2001')
INSERT INTO Document VALUES(6006,'Sonchita','9-28-2010','2002')
Select * from Document
CREATE TABLE Book (DocId int, ISBN nvarchar(15) NOT NULL, constraint pk_Book primary key (DocId), Constraint fk_Book_Document FOREIGN KEY (DocId) REFERENCES Document)
INSERT INTO book VALUES(6006,'7197364657922')
INSERT INTO book VALUES(6003,'9858110330262')
INSERT INTO book VALUES(6005,'0175037910599')
INSERT INTO book VALUES(6001,'4991257779220')
INSERT INTO book VALUES(6002,'9982792269430')
INSERT INTO book VALUES(6004,'8553472733173')

CREATE TABLE Writes (DocId int, AuthorId int, constraint pk_Writes Primary Key (DocId,AuthorId), Constraint fk_Writes_Book FOREIGN KEY (DocId) References Book, Constraint fk_Writes_Author FOREIGN KEY (AuthorId) References Author)
INSERT INTO writes VALUES(6001,5001)
INSERT INTO writes VALUES(6002,5002)
INSERT INTO writes VALUES(6003,5003)
INSERT INTO writes VALUES(6004,5004)
INSERT INTO writes VALUES(6005,5005)
INSERT INTO writes VALUES(6006,5006)

CREATE TABLE Proceedings (DocId INT, CDate DATE NOT NULL, Clocation nvarchar(50), Ceditor nvarchar(50) NOT NULL, constraint pk_Proceedings Primary Key (DocId), Constraint fk_Proceedings_Document FOREIGN KEY (DocId) References Document)
INSERT INTO Proceedings VALUES(6001,'1-18-2022','Tejgaon','Arisha Islam')
INSERT INTO Proceedings VALUES(6002,'2-1-2023','Dhanmondi','Kamrul Hasan')
INSERT INTO Proceedings VALUES(6003,'4-7-2023','Mohakhali','Arafat Hasan')
INSERT INTO Proceedings VALUES(6004,'6-24-2023','Uttara','Nusaiba Surovi')
INSERT INTO Proceedings VALUES(6005,'7-5-2019','Puran Dhaka','Daliya Islam')
INSERT INTO Proceedings VALUES(6006,'9-2-2016','Polton','Riaz Ahmed')

CREATE TABLE Journal_Volume (DocId INT, Volumeno int NOT NULL, Editorid INT NOT NULL, Constraint pk_Journal_Volume Primary key (DocId), Constraint fk_Journal_Volume_Chief_Editor FOREIGN KEY (Editorid) References Chief_Editor, Constraint fk_Journal_Volume_Document FOREIGN KEY (DocId) References Document)
INSERT INTO Journal_Volume VALUES(6001,7001,4001)
INSERT INTO Journal_Volume VALUES(6002,7002,4002)
INSERT INTO Journal_Volume VALUES(6003,7003,4006)
INSERT INTO Journal_Volume VALUES(6004,7004,4005)
INSERT INTO Journal_Volume VALUES(6005,7005,4002)
INSERT INTO Journal_Volume VALUES(6006,7006,4001)



CREATE TABLE Journal_Issue (DocId int, Issueno int, Scope nvarchar(10), Constraint pk_Journal_Issue Primary Key (DOcId,Issueno), Constraint fk_Journal_Issue_Journal_Volume FOREIGN KEY (DocId) References Journal_Volume)
INSERT INTO Journal_Issue VALUES(6001,8001,'0-46')
INSERT INTO Journal_Issue VALUES(6002,8002,'24-38')
INSERT INTO Journal_Issue VALUES(6003,8003,'56-78')
INSERT INTO Journal_Issue VALUES(6004,8004,'2-19')
INSERT INTO Journal_Issue VALUES(6005,8005,'2-78')
INSERT INTO Journal_Issue VALUES(6006,8006,'67-99')


CREATE TABLE Guest_Editor (DocId INT, Issueno INT, IEditor nvarchar(50), Constraint pk_Guest_Editor Primary Key (DocId, Issueno, IEditor), Constraint fk_Guest_Editor_Journal_Issue FOREIGN KEY (DocId,Issueno) References Journal_Issue)
INSERT INTO Guest_Editor VALUES(6001,8001,'Rayan Islam')
INSERT INTO Guest_Editor VALUES(6002,8002,'Ahmed Anan')
INSERT INTO Guest_Editor VALUES(6003,8003,'Arafat Alam')
INSERT INTO Guest_Editor VALUES(6004,8004,'Shahed Karim')
INSERT INTO Guest_Editor VALUES(6005,8005,'Munim Sarker')
INSERT INTO Guest_Editor VALUES(6006,8006,'Azizah Abha')

CREATE TABLE Copy(LibId int, DocID int, Copyno int, Position char(6) NOT NULL, Constraint pk_Copy Primary key  (LibId, DocId, Copyno), Constraint fk_Copy_Branch FOREIGN KEY (LibId) References Branch,Constraint fk_Copy_Document FOREIGN KEY (DocId) References Document)
INSERT INTO Copy VALUES (1,6001,9001,'Left')
INSERT INTO Copy VALUES (1,6002,9002,'Corner')
INSERT INTO Copy VALUES (2,6003,9003,'Right')
INSERT INTO Copy VALUES (3,6004,9004,'Left')
INSERT INTO Copy VALUES (4,6005,9005,'Left')
INSERT INTO Copy VALUES (4,6006,9006,'Corner')

Create Table Reserves( ResNumber int,DocID int NOT NULL, LibId int NOT NULL, Copyno int NOT NULL,ReaderId int NOT NULL, Constraint pk_Reserves primary key (ResNumber),Constraint fk_Reserves_reader FOREIGN KEY (ReaderId) References Reader,Constraint fk_Reserves_Copy FOREIGN KEY (LibId, DocId, Copyno) References Copy,Constraint fk_Reserves_Reservation FOREIGN KEY (ResNumber) References Reservation)
INSERT INTO Reserves VALUES (4002,6001,1,9001,1001)
INSERT INTO Reserves VALUES (4002,6004,4,9002,1004)
INSERT INTO Reserves VALUES (4003,6005,4,9005,1002)
INSERT INTO Reserves VALUES (4006,6006,4,9006,1004)
INSERT INTO Reserves VALUES (4005,6005,4,9005,1003)
INSERT INTO Reserves VALUES (4001,6001,1,9001,1001)
select * from Reserves
Create Table  Borrows(BorNumber int,DocID int NOT NULL, LibId int NOT NULL, Copyno int NOT NULL,ReaderId int NOT NULL, Constraint pk_Borrows primary key (BorNumber),Constraint fk_Borrows_reader FOREIGN KEY (ReaderId) References Reader,Constraint fk_Borrows_Copy FOREIGN KEY (LibId, DocId, Copyno) References Copy,Constraint fk_Borrows_BOR_Transaction FOREIGN KEY (BorNumber) References Bor_Transaction)
INSERT INTO Borrows VALUES (3001,6001,1,9001,1001)
INSERT INTO Borrows VALUES (3002,6002,1,9002,1006)
INSERT INTO Borrows VALUES (3003,6003,2,9003,1005)
INSERT INTO Borrows VALUES (3004,6004,3,9004,1004)
INSERT INTO Borrows VALUES (3005,6005,4,9005,1004)
INSERT INTO Borrows VALUES (3006,6006,4,9006,1003)
select * from Borrows






CREATE PROCEDURE spAddDocument(@docTitle nvarchar(50), @pdate date, @pubid INT, @libid int, @copyno int, @position nvarchar(10), @status INT out)
AS
DECLARE @count1 INT	 -- to check if publisher exists
DECLARE @count2 INT	 -- to check if libid exists
DECLARE @docId INT
BEGIN
	SET @docId=0
	select @count1=count(1) from Publisher where Publisher_id=@pubid	
	if(@count1>0)
	BEGIN
		SELECT @count2=count(1) from Branch where Libid=@libid
		if(@count2>0)
		BEGIN			
			SELECT @docId=MAX(DocID) from Document
			IF @docId is null
				SET @docId = 6000
			SET @docId+=1
			INSERT INTO Document Values(@docId,@docTitle,@pdate,@pubid)
			INSERT INTO Copy Values(@libid,@docId,@copyno,@position)
			SET @status=1
		END
		else
			SET @status=-1
	END
	else
		SET @status=0
END





CREATE PROCEDURE spAddReader (@readerName nvarchar(50), @type nvarchar(10), @phoneno nvarchar(12),@address nvarchar(100))
AS
DECLARE @readerId as INT
BEGIN
	SELECT @readerId=MAX(Reader_id) from Reader
	if @readerId is null
		SET @readerId = 1000
	SET @readerId +=1+@phoneno % 100
	INSERT INTO Reader VALUES (@readerId, @type, @readerName, @phoneno, @address)
END
DROP PROCEDURE spAddReader
select * from Reader

Create PROCEDURE spCheckDocStatus(@docId int, @libId int, @copyno int, @status int out)
AS
DECLARE @count1 INT;  --If document exists
DECLARE @count2 INT;  --If document is borrowed
DECLARE @count3 INT;  --If document is reserved
BEGIN
	UPDATE Reservation SET Reservation_Status = 'Cancelled' where ResDateTime<SYSDATETIME()
	if(DATEDIFF(Second, CAST(CURRENT_TIMESTAMP as time) , CAST('18:00:00' as time)) < 0)                    --  TO CHECK CURRENT TIME
		UPDATE Reservation SET Reservation_Status = 'Cancelled' where ResDateTime=SYSDATETIME()
	SELECT @count1=count(1) from Document where DocId=@docId
	SELECT @count2=count(1) from Borrows B inner join BOR_Transaction BT on B.BorNumber=BT.BorNumber where DocID=@docId and libID=@libId and copyno=@copyno and (BorDateTime is not null and RetDateTime is null)
	SELECT @count3=count(1) from Reserves R inner join Reservation RV on R.ResNumber=RV.ResNumber where DocID=@docId and libID=@libId and copyno=@copyno and Reservation_Status='Reserved'
	if(@count1 > 0 and @count2 = 0 and @count3 = 0)
	SET @status = 1
	else if (@count1 = 0)
	SET @status = 0
	else if (@count2 > 0 )
	SET @status = -1
	else if (@count3 > 0)				
	SET @status = -2
END

-- spCheckDocStatus 5



CREATE PROCEDURE spCheckout(@readerId INT,
@docId INT,
@copyNo INT,
@libId INT,
@result INT out)
AS
DECLARE @count1 INT  --To check if book exists
DECLARE @count2 INT  --To check if someone has borrowed it
DECLARE @count3 INT  --To check if someone else has reserved it
DECLARE @BORNumber INT
BEGIN
	UPDATE Reservation SET Reservation_Status = 'Cancelled' where ResDateTime<SYSDATETIME()
	if(DATEDIFF(Second, CAST(CURRENT_TIMESTAMP as time) , CAST('18:00:00' as time)) < 0)                    --  TO CHECK CURRENT TIME
		UPDATE Reservation SET Reservation_Status = 'Cancelled' where ResDateTime=SYSDATETIME()
	SELECT @count1=count(1) from Copy where DocID=@docId and Copyno=@copyNo and LibId=@libId	
	if @count1>0
	begin
		SELECT @count2=count(1) from Borrows B inner join BOR_Transaction BT on B.BorNumber=BT.BorNumber WHERE DocID=@docId and Copyno=@copyNo and LibId=@libId and RetDateTime is null
		SELECT @count3=count(1) from  Reserves R inner join Reservation RV on R.ResNumber=Rv.ResNumber WHERE DocID=@docId and LibId=@libId and Copyno=@copyNo and ReaderId<>@readerId and Reservation_Status = 'Reserved'
		if @count2=0 and @count3=0
		begin
			SELECT @BORNumber=MAX(BORNumber) from Borrows
			IF @BORNumber is null
				SET @BORNumber=3000
			SET @BORNumber += 1
			INSERT INTO BOR_Transaction VALUES (@BORNumber,SYSDATETIME(),null)
			INSERT INTO Borrows VALUES (@BORNumber,@docId,@libId,@copyNo,@readerId)			
			Update Reservation SET Reservation_Status = 'Cancelled' Where ResNumber in (SELECT ResNumber from Reserves where ReaderId=@readerId and DocID=@docId and LibId=@libId and Copyno=@copyNo)
			SET @result = @BORNumber		 			
		end	
		ELSE
		BEGIN
			SET @result = 0
		END					
	end
	else
	begin
		SET @result = -1
	end
END

-- *************************************************************************************** --





CREATE PROCEDURE spGetReservedDocs(@readerId as Int)
As
Begin
	UPDATE Reservation SET Reservation_Status = 'Cancelled' where ResDateTime<SYSDATETIME()
	if(DATEDIFF(Second, CAST(CURRENT_TIMESTAMP as time) , CAST('18:00:00' as time)) < 0)                    --  TO CHECK CURRENT TIME
			UPDATE Reservation SET Reservation_Status = 'Cancelled' where ResDateTime=SYSDATETIME()
	select R.DocID, Title, Reservation_Status AS STATUS from Reserves R Inner Join Document D on R.DocID = D.DocId Left outer join Reservation RV on R.ResNumber=Rv.ResNumber where ReaderId = @readerId
ENd



CREATE PROCEDURE [dbo].[spReserve](@readerId INT,
@docId INT,
@copyNo INT,
@libId INT,
@resDate DATE,
@result INT out)
AS
DECLARE @count1 INT  --To check if book exists
DECLARE @count2 INT  --To check if someone has borrowed it
DECLARE @count3 INT  --To check if someone else has reserved it
DECLARE @count4 INT  --To check if user has already reserved 10 documents
DECLARE @ResNumber INT
BEGIN
	UPDATE Reservation SET Reservation_Status = 'Cancelled' where ResDateTime<SYSDATETIME()
	if(DATEDIFF(Second, CAST(CURRENT_TIMESTAMP as time) , CAST('18:00:00' as time)) < 0)                    --  TO CHECK CURRENT TIME
			UPDATE Reservation SET Reservation_Status = 'Cancelled' where ResDateTime=SYSDATETIME()
	SELECT @count1=count(1) from Copy where DocID=@docId and Copyno=@copyNo and LibId=@libId	
	if @count1>0
	begin
		SELECT @count2=count(1) from Borrows B inner join BOR_Transaction BT on B.BorNumber=BT.BorNumber WHERE DocID=@docId and Copyno=@copyNo and LibId=@libId and RetDateTime is null
		SELECT @count3=count(1) from  Reserves R inner join Reservation RV on R.ResNumber=RV.ResNumber where DocID=@docId and LibId=@libId and Copyno=@copyNo and Reservation_Status = 'Reserved'		
		if @count2=0 and @count3=0
		begin
			SELECT @count4=count(1) from Reserves R inner join Reservation RV on R.ResNumber=RV.ResNumber where ReaderId=@readerId and Reservation_Status = 'Reserved'
			if @count4<10
			begin
				SELECT @ResNumber=MAX(ResNumber) from Reservation
				IF @ResNumber is Null
					SET @ResNumber=4000
				SET @ResNumber += 1
				INSERT INTO Reservation VALUES (@ResNumber,@resDate,'Reserved')
				INSERT INTO Reserves VALUES (@ResNumber,@docId,@libId,@copyNo,@readerId)				
				SET @result = @ResNumber		 			
			end
			else
			begin
				set @result = 0
			end
		end	
		ELSE
		BEGIN
			SET @result = -1
		END					
	end
	else
	begin
		SET @result = -2
	end
END




CREATE PROCEDURE spReturn(@readerId INT,
@docId INT,
@copyNo INT,
@libId INT,
@result INT out)
AS
DECLARE @count1 INT
DECLARE @temp INT
BEGIN
	SELECT @count1=count(1) from Borrows B INNER JOIN BOR_Transaction BT on B.BorNumber=BT.BorNumber WHERE DocID=@docId and Copyno=@copyNo and LibId=@libId and RetDateTime is null and BorDateTime is not null
	IF @count1=1
	BEGIN
		Update BOR_Transaction set RetDateTime=SYSDATETIME() where BorNumber in (SELECT B.BorNumber from Borrows B INNER JOIN BOR_Transaction BT on B.BorNumber=BT.BorNumber WHERE DocID=@docId and Copyno=@copyNo and LibId=@libId and RetDateTime is null and BorDateTime is not null)
		IF @@ROWCOUNT = 1
			SET @result = 1					-- Updated successfully
		ELSE
			SET @result = 0					-- Error	
	END
	ELSE
		SET @result = -1					-- No record found of borrowing
END