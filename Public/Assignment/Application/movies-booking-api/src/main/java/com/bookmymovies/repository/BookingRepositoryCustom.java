package com.bookmymovies.repository;


import java.util.List;
import com.bookmymovies.model.BookSeatRequest;
import com.bookmymovies.model.BookSeatResponse;

public interface BookingRepositoryCustom {
    BookSeatResponse callBookTicket(Long showId, String userId, String seatIds);

    
}