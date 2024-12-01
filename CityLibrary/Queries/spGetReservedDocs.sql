CREATE PROCEDURE spGetReservedDocs(@readerId as Int)
As
Begin
	UPDATE Reservation SET Reservation_Status = 'Cancelled' where ResDateTime<SYSDATETIME()
	if(DATEDIFF(Second, CAST(CURRENT_TIMESTAMP as time) , CAST('18:00:00' as time)) < 0)                    --  TO CHECK CURRENT TIME
			UPDATE Reservation SET Reservation_Status = 'Cancelled' where ResDateTime=SYSDATETIME()
	select R.DocID, Title, Reservation_Status AS STATUS from Reserves R Inner Join Document D on R.DocID = D.DocId Left outer join Reservation RV on R.ResNumber=Rv.ResNumber where ReaderId = @readerId
ENd