CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateBooking`(IN BookID INT, IN BookingD date)
BEGIN
START TRANSACTION; 
	UPDATE Bookings SET BookingDate=BookingD WHERE BookingID=BookID;
	SELECT concat('Your booking at ID: ', BookID, ' is booked for ', BookingD, ' now.') AS "Booking Status";

COMMIT; 
END