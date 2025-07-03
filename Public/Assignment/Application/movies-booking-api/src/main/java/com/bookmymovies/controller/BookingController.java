package com.bookmymovies.controller;

import com.bookmymovies.model.BookSeatRequest;
import com.bookmymovies.model.BookSeatResponse;
import com.bookmymovies.model.MoviesResponse;
import com.bookmymovies.model.SeatsStatusResponse;
import com.bookmymovies.service.BookingService;
import com.bookmymovies.service.Impl.BookingServiceImpl;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.DataInput;
import java.util.List;

@CrossOrigin(origins = "http://localhost:8080")
@RestController
@RequestMapping("/api/booking")
public class BookingController {

	@Autowired
	BookingServiceImpl bookingService;

	@GetMapping("/seats")
	public ResponseEntity<List<SeatsStatusResponse>> getSeatsForShow( @RequestParam(required = true)String show_id) {
		try {
				List<SeatsStatusResponse> seats = bookingService.getSeatsStatusForShow(show_id);
			if (seats.isEmpty()) {
				return new ResponseEntity<>(HttpStatus.NO_CONTENT);
			}
			return new ResponseEntity<>(seats, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	@PostMapping(value = "/seats",consumes = "application/json", produces = "application/json")
	public ResponseEntity<BookSeatResponse> bookSeatsForShow( @RequestBody BookSeatRequest req) {
		try {

			BookSeatResponse bookingStatus = bookingService.bookSeats(req);
			/*if (bookingStatus==null) {
				return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
			}*/
			return new ResponseEntity<>(bookingStatus, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
		}

	}


    @PostMapping(value = "/book",consumes = "application/json", produces = "application/json")
    public ResponseEntity<String> bookTickets(@RequestParam Long showId,
                                            @RequestParam String userId,
                                            @RequestBody String seatIds) {

		try {	
			
			if (showId == null || userId == null || seatIds == null || seatIds.isEmpty()) {
			return ResponseEntity.badRequest().body("Invalid input parameters. expected " + //
								"{\"user_id\":\"XXXX\",\r\n\"show_id\":1005,\r\n\"seat_ids\":\"406,407\"}");
			}
			
        int bookedCount = bookingService.callBookTicket(showId, userId, seatIds);

        if (bookedCount > 0) {
            return ResponseEntity.ok("Successfully booked " + bookedCount + " seats.");
        } else {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Booking failed. Seats may be already locked or unavailable.");
        }

		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
		}

    }
}





