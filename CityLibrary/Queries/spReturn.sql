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