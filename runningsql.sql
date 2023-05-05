USE littlelemonfinaldb;
SELECT customers.CustomersID, CONCAT(customers.GuestFirstName, ' ', customers.GuestLastName) AS FullName, orders.OrderID AS "Order ID", orders.BillAmount, menus.MenuName, menuitems.CourseName, menuitems.StarterName
FROM customers
INNER JOIN bookings ON bookings.CustomersID = customers.CustomersID
JOIN orders ON orders.BookingID = bookings.BookingID
RIGHT JOIN menus ON menus.MenuID = orders.MenuID
RIGHT JOIN menuitems ON menuitems.ItemID = menus.ItemID
WHERE orders.BillAmount > 150
ORDER BY orders.BillAmount ASC;

PREPARE GetOrderDetail FROM 
    'SELECT orders.orderID, orders.quantity, orders.BillAmount 
     FROM Orders
     JOIN bookings ON bookings.OrderID = orders.OrderID
     JOIN customers ON customers.CustomersID = bookings.CustomersID
     WHERE customers.CustomersID = ?';

SET @id = 7;
EXECUTE GetOrderDetail USING @id;

SELECT * from bookings;

call CheckBooking('19:00:00', 5, 2, '2022-10-19');
call AddBooking(5, 2, '2022-10-20');
call UpdateBooking(14, '2022-10-23');
call CancelBooking(13);
SELECT * FROM orders;
