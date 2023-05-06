CREATE DEFINER=`root`@`localhost` PROCEDURE `CancelBooking`(IN BookID INT)
BEGIN
START TRANSACTION; 
	DELETE FROM Bookings WHERE BookingID=BookID ;
	SELECT concat('Your booking at ID: ', BookID, ' is deleted now.') AS "Booking Status";

COMMIT; 
END