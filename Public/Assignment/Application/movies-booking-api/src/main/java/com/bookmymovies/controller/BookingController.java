package com.bookmymovies.controller;

import com.bookmymovies.model.MovieWithShowsResponse;
import com.bookmymovies.model.BookSeatRequest;
import com.bookmymovies.model.BookSeatResponse;
import com.bookmymovies.model.MoviesResponse;
import com.bookmymovies.model.SeatsStatusResponse;
import com.bookmymovies.service.BookingService;
import com.bookmymovies.repository.BookingRepository;
import com.bookmymovies.repository.BookingRepositoryCustom;
import com.bookmymovies.repository.impl.BookingRepositoryImpl;
import com.bookmymovies.service.impl.BookingServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.bookmymovies.util.InputValidator;
import java.io.DataInput;
import java.util.List;
import java.util.Arrays;



@CrossOrigin(origins = "http://localhost:8080")
@RestController
@RequestMapping("/api/booking")
public class BookingController {

	private final BookingRepositoryImpl bookingRepository;

    public BookingController(BookingRepositoryImpl bookingRepository) {
        this.bookingRepository = bookingRepository;
    }

	@Autowired
	BookingServiceImpl bookingService; 

	@GetMapping("/seats")
	public ResponseEntity<List<SeatsStatusResponse>> getSeatsForShow( @RequestParam(required = true)String show_id) {
		try {
			
		
			if (InputValidator.isValidInput(show_id,10, true)) {	

				List<SeatsStatusResponse> seats = bookingService.getSeatsStatusForShow(show_id);
				if (seats.isEmpty()) {
					return new ResponseEntity<>(HttpStatus.NO_CONTENT);
				}
				return new ResponseEntity<>(seats, HttpStatus.OK);

			} else {
					return ResponseEntity.badRequest().body(null);
				}

		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}



    @PostMapping(value = "/book",consumes = "application/json", produces = "application/json")
    public ResponseEntity<String> bookTickets(@RequestBody BookSeatRequest req) {

		try {	
			
			 System.out.println("Seat: "+req.getSeat_ids() + " show_id: "+req.getShow_id() + " userId: "+req.getUserId());

			if (req== null || !InputValidator.isValidInput(req.getUserId()) || !InputValidator.isValidInput(req.getShow_id(),10, true) || !InputValidator.isValidInput(req.getSeat_ids()) ) {
				return ResponseEntity.badRequest().body("Invalid input parameters. expected " + //
								"{\"user_id\":\"XXXX\",\r\n\"show_id\":1005,\r\n\"seat_ids\":\"406,407\"}");
			}
			

        BookSeatResponse bookSeatResponse = bookingRepository.callBookTicket(Long.parseLong(req.getShow_id()), req.getUserId(),  req.getSeat_ids());
 		System.out.println("Call Message: " + bookSeatResponse.getMessage());

        if (bookSeatResponse.getStatusCode() > 0) {
            return ResponseEntity.ok("Successfully reserved " + bookSeatResponse.getStatusCode() + " seat(s). Please complete the payment.\n" + bookSeatResponse.getMessage());
        } else {
            return ResponseEntity.status(HttpStatus.CONFLICT).body("Booking failed. Seats may be already locked or unavailable.");
        }

		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
		}

    }
}




 

