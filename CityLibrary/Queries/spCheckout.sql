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