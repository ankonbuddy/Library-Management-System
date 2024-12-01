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