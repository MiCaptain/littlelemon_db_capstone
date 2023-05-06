CREATE DEFINER=`root`@`localhost` PROCEDURE `new_procedure`(IN TableNumb INT, IN BookingD date)
BEGIN
START TRANSACTION; 
	If (SELECT count(TableNO) FROM Bookings WHERE TableNO=TableNumb AND BookingDate=BookingD) THEN
		SELECT concat('Table', TableNumb, 'is allready booked') AS TableStatus;
    ELSE
        SELECT 'Working 2' AS Result;
    END IF;
COMMIT; 
END