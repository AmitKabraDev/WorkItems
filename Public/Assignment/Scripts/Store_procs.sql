IF OBJECT_ID('dbo.release_locked_seats', 'P') IS NOT NULL
    DROP PROCEDURE dbo.release_locked_seats;
GO


CREATE PROCEDURE dbo.release_locked_seats
(
  
    @number_of_loops nvarchar(50) = 60,
    @wait_timer nvarchar(50) = '00:03:00'
)
AS

/*
example to execute it
exec dbo.release_locked_seats @number_of_loops=30,@wait_timer='00:01:00'
*/

BEGIN

    SET NOCOUNT ON

    Declare @a int = 0
WHILE 1=1
BEGIN
  -- Example code
update dbo.seatinventory with(rowlock)  set is_locked=0 where  is_locked=1 and is_booked=0 and expiry_time<CURRENT_TIMESTAMP

  WAITFOR DELAY @wait_timer -- 1 minute
  IF @a = @number_of_loops -- stop after 120 
     Break;
  SET @a = @a + 1
END

END
GO


-----------------------------------------------
IF OBJECT_ID('dbo.GetBookingMessage', 'P') IS NOT NULL
    DROP PROCEDURE dbo.GetBookingMessage;
GO

CREATE PROCEDURE dbo.GetBookingMessage
    @BookingId INT,
    @message NVARCHAR(MAX) OUTPUT
AS
BEGIN
    DECLARE @SeatNames NVARCHAR(MAX);
    DECLARE @TotalAmount NVARCHAR(50), @Discount NVARCHAR(50), @NetAmount NVARCHAR(50);

    -- Get seat names
    SELECT @SeatNames = STRING_AGG(sm.row_number + sm.seat_number, ',')
    FROM BookedSeats bs
    INNER JOIN Seatinventory sinv ON sinv.seatinventory_id = bs.seat_id
    INNER JOIN Seats sm ON sm.seat_id = sinv.seat_id
    WHERE bs.booking_id = @BookingId;

    -- Get booking details
    SELECT 
        @TotalAmount = CAST(total_amount AS NVARCHAR),
        @Discount = CAST(discount_amount AS NVARCHAR),
        @NetAmount = CAST(Net_amount AS NVARCHAR)
    FROM bookings
    WHERE booking_id = @BookingId;

    -- Compose the message
    SET @message = 
        'Booking Reference number: ' + CAST(@BookingId AS NVARCHAR) + CHAR(13) + CHAR(10) +
        'Seats: ' + ISNULL(@SeatNames, 'N/A') + CHAR(13) + CHAR(10) +
        'Total Amount: ' + ISNULL(@TotalAmount, '0') + + CHAR(13) + CHAR(10) +
        'Offer discount: ' + ISNULL(@Discount, '0') + CHAR(13) + CHAR(10) +
        'Net Payable Amount: ' + ISNULL(@NetAmount, '0') + + CHAR(13) + CHAR(10);
END;



GO
-----------------------------------------------

IF OBJECT_ID('dbo.SpBookTicket', 'P') IS NOT NULL
Begin
    DROP PROCEDURE dbo.SpBookTicket;
End
GO

Create PROCEDURE dbo.SpBookTicket
    @show_id BIGINT,
    @bookinguser NVARCHAR(50),
    @seat_ids NVARCHAR(MAX), -- comma-separated list of seat IDs
    @bookcount Int output,
    @Message NVARCHAR(500) output
AS
BEGIN
    SET NOCOUNT ON;
    /*
     -- Example of how to call
        DECLARE @result INT;
        EXEC  SpBookTicket  @show_id = 1005, @bookinguser = 'username', @seat_ids = '444,445',  @bookcount=@result, @Message=@resultMessage output
        SELECT @result AS RowsAffected
    */
    -- Convert comma-separated seat_ids into a table variable
    DECLARE @SeatTable TABLE (seatinventory_id VARCHAR(50));
    DECLARE @lockexpirytime DATETIME;
    DECLARE @UpdatedRecords int;


    BEGIN TRY



        INSERT INTO @SeatTable (seatinventory_id)
        SELECT value FROM STRING_SPLIT(@seat_ids, ',');

  
        SET @lockexpirytime = DATEADD(MINUTE, 5, CURRENT_TIMESTAMP);

        -- Update seat inventory
    
         PRINT 'Seats: ' + @seat_ids;
         PRINT 'Booking initiated for : ' + cast(@@ROWCOUNT as char) ;

        Begin Tran

        UPDATE Seatinventory
        SET 
            is_locked = 1,
            lock_time = CURRENT_TIMESTAMP,
            expiry_time = @lockexpirytime,
            lockedforuser = @bookinguser,
            updated_by = CURRENT_USER,
            updated_at = CURRENT_TIMESTAMP
        WHERE 
            show_id = @show_id
            and is_locked=0 and is_booked=0 AND seatinventory_id IN (SELECT seatinventory_id FROM @SeatTable);
       
           set @UpdatedRecords = @@ROWCOUNT;

        IF @UpdatedRecords = (SELECT COUNT(seatinventory_id) FROM @SeatTable)
        BEGIN
            COMMIT;
           set @bookcount= @UpdatedRecords;

       
           Begin Tran

            DECLARE @BookingId BIGINT, @BookingseatId BIGINT;

             SELECT @BookingId =  MAX(booking_id)+1  from Bookings;
             SELECT @BookingseatId = MAX(booking_seat_id)  FROM BookedSeats;


            Insert into Bookings (booking_id,User_id,show_id,booking_time,currency_code,	total_amount,	discount_amount, net_amount,booking_status_code, is_deleted,	created_by,	created_at,	updated_by,	updated_at   ) 
                    SELECT  @BookingId as booking_id, @bookinguser as User_id, max(si.show_id) as show_id, GETUTCDATE() as booking_time, max(si.currency_code) as currency_code, sum(si.price) as total_amount, 
                    sum(case when dt.calculation_type='fixed' then ISNULL(sd.discount_value,0) else  ISNULL(si.price,0) * ISNULL(sd.discount_value,0)/100  end) as discount_amount, sum(si.price) -  sum(case when dt.calculation_type='fixed' then ISNULL(sd.discount_value,0) else  ISNULL(si.price,0) * ISNULL(sd.discount_value,0)/100  end) as net_amount, 'Reserved' as StatusCode, 0 as is_deleted,@bookinguser,  GETUTCDATE(), @bookinguser, GETUTCDATE()    
                    FROM @SeatTable tmp
               inner join Seatinventory si on si.seatinventory_id = tmp.seatinventory_id
               left outer join show_discounts sd on sd.show_id=si.show_id
               left outer join discount_types dt on sd.discount_type_id=dt.discount_type_id
                         
            Insert into BookedSeats (booking_seat_id,booking_id,seat_id,currency_code,	seat_price,statuscode, is_deleted,	created_by,	created_at,	updated_by,	updated_at   ) 
               SELECT @BookingseatId + ROW_NUMBER() OVER (ORDER BY Seat_id) AS booking_seat_id, @BookingId as booking_id, si.seatinventory_id as Seat_id, si.currency_code, si.price as Seat_price, 'Reserved' as StatusCode, 0,@bookinguser,  GETUTCDATE(), @bookinguser, GETUTCDATE()    FROM @SeatTable tmp
               inner join Seatinventory si on si.seatinventory_id = tmp.seatinventory_id;

            EXEC  GetBookingMessage  @BookingId = @BookingId,   @message=@message output


            Commit;


        END
        ELSE
        BEGIN
            ROLLBACK;
             set @bookcount= 0;
        END

       
    END TRY
    BEGIN CATCH
        -- Error handling logic
          SET @message = 
        'ERROR_NUMBER: ' + CAST(ERROR_NUMBER() AS VARCHAR) + 
        ' | ERROR_MESSAGE: ' + ERROR_MESSAGE() + 
        ' | ERROR_LINE: ' + CAST(ERROR_LINE() AS VARCHAR);

    END CATCH;
        
END;



