CREATE DEFINER=`root`@`localhost` PROCEDURE `CheckBooking`(IN BS TIME, IN CustID INT, IN TableNumb INT, IN BookingD date)
BEGIN
START TRANSACTION; 
	If (SELECT count(TableNO) FROM Bookings WHERE TableNO=TableNumb AND BookingDate=BookingD) THEN
		SELECT concat('Table ', TableNumb,' on date',BookingD, ' is allready booked.') AS "Booking Status";
        rollback;
    ELSE
        INSERT IGNORE INTO Bookings (BookingSlot, CustomersID, TableNO, BookingDate)
		VALUES
		(BS, CustID, TableNumb, BookingD);
        SELECT concat('Your booking at table number: ', TableNumb, ' on date: ', BookingD, ' is placed.') AS "Booking Status";

    END IF;
COMMIT; 
END