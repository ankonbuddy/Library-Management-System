CREATE TABLE Branch (Libid INT, Name nvarchar(50) NOT NULL, Location nvarchar(50) NOT NULL, CONSTRAINT pk_Branch PRIMARY KEY (Libid))

CREATE TABLE Reader (Reader_id INT, Type nvarchar(20) NOT NULL, ReaderName nvarchar(50) NOT NULL, Phone_no nvarchar(12) NOT NULL, Address nvarchar(100) NOT NULL, CONSTRAINT pk_Reader PRIMARY KEY (Reader_id), CONSTRAINT uq_Reader_Phone UNIQUE (Phone_no))

CREATE TABLE Publisher (Publisher_id INT, Pub_Name nvarchar(50) NOT NULL, Address nvarchar(100) NOT NULL, CONSTRAINT pk_Publisher PRIMARY KEY (Publisher_id), CONSTRAINT uq_PubName UNIQUE(Pub_Name))

CREATE TABLE BOR_Transaction (BorNumber INT, BorDateTime DATETIME NOT NULL, RetDateTime DATETIME, CONSTRAINT pk_BOR_Transaction Primary key (BorNumber))

CREATE TABLE Reservation (ResNumber int, ResDateTime datetime NOT NULL, Reservation_Status nvarchar(10) constraint pk_Reservation PRIMARY key (ResNumber))

CREATE TABLE Chief_Editor (EditorId int, Ename nvarchar(50) NOT NULL, CONSTRAINT pk_Cheif_Editor primary key (EditorId))

CREATE TABLE Author (AuthorId int, Aname nvarchar(50) NOT NULL, constraint pk_Author primary key (AuthorId))

CREATE TABLE Document (DocId int, Title nvarchar(50) NOT NULL, Pdate DATE, PublisherID int, CONSTRAINT pk_Document Primary key (DocId), Constraint fk_Document_Publisher Foreign key (PublisherId) references Publisher)

CREATE TABLE Book (DocId int, ISBN nvarchar(15) NOT NULL, constraint pk_Book primary key (DocId), Constraint fk_Book_Document FOREIGN KEY (DocId) REFERENCES Document)

CREATE TABLE Writes (DocId int, AuthorId int, constraint pk_Writes Primary Key (DocId,AuthorId), Constraint fk_Writes_Book FOREIGN KEY (DocId) References Book, Constraint fk_Writes_Author FOREIGN KEY (AuthorId) References Author)

CREATE TABLE Proceedings (DocId INT, CDate DATE NOT NULL, Clocation nvarchar(50), Ceditor nvarchar(50) NOT NULL, constraint pk_Proceedings Primary Key (DocId), Constraint fk_Proceedings_Document FOREIGN KEY (DocId) References Document)

CREATE TABLE Journal_Volume (DocId INT, Volumeno int NOT NULL, Editorid INT NOT NULL, Constraint pk_Journal_Volume Primary key (DocId), Constraint fk_Journal_Volume_Chief_Editor FOREIGN KEY (Editorid) References Chief_Editor, Constraint fk_Journal_Volume_Document FOREIGN KEY (DocId) References Document)

CREATE TABLE Journal_Issue (DocId int, Issueno int, Scope nvarchar(10), Constraint pk_Journal_Issue Primary Key (DOcId,Issueno), Constraint fk_Journal_Issue_Journal_Volume FOREIGN KEY (DocId) References Journal_Volume)

CREATE TABLE Guest_Editor (DocId INT, Issueno INT, IEditor nvarchar(50), Constraint pk_Guest_Editor Primary Key (DocId, Issueno, IEditor), Constraint fk_Guest_Editor_Journal_Issue FOREIGN KEY (DocId,Issueno) References Journal_Issue)

CREATE TABLE Copy(LibId int, DocID int, Copyno int, Position char(6) NOT NULL, Constraint pk_Copy Primary key  (LibId, DocId, Copyno), Constraint fk_Copy_Branch FOREIGN KEY (LibId) References Branch,Constraint fk_Copy_Document FOREIGN KEY (DocId) References Document)

Create Table Reserves( ResNumber int,DocID int NOT NULL, LibId int NOT NULL, Copyno int NOT NULL,ReaderId int NOT NULL, Constraint pk_Reserves primary key (ResNumber),Constraint fk_Reserves_reader FOREIGN KEY (ReaderId) References Reader,Constraint fk_Reserves_Copy FOREIGN KEY (LibId, DocId, Copyno) References Copy,Constraint fk_Reserves_Reservation FOREIGN KEY (ResNumber) References Reservation)

Create Table  Borrows(BorNumber int,DocID int NOT NULL, LibId int NOT NULL, Copyno int NOT NULL,ReaderId int NOT NULL, Constraint pk_Borrows primary key (BorNumber),Constraint fk_Borrows_reader FOREIGN KEY (ReaderId) References Reader,Constraint fk_Borrows_Copy FOREIGN KEY (LibId, DocId, Copyno) References Copy,Constraint fk_Borrows_BOR_Transaction FOREIGN KEY (BorNumber) References Bor_Transaction)