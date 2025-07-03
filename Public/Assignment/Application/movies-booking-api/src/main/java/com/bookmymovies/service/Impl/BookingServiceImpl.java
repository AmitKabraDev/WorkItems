package com.bookmymovies.service.Impl;

import com.bookmymovies.model.BookSeatRequest;
import com.bookmymovies.model.BookSeatResponse;
import com.bookmymovies.model.SeatsStatusConverter;
import com.bookmymovies.model.SeatsStatusResponse;
import com.bookmymovies.repository.BookingRepository;
import com.bookmymovies.service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import jakarta.persistence.EntityManager;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;    
import jakarta.persistence.ParameterMode;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;


@Service
public class BookingServiceImpl implements BookingService {

    @PersistenceContext
    private EntityManager entityManager;

      public BookingServiceImpl(BookingRepository bookingRepository) {
        this.bookingRepository = bookingRepository;
    }

    @Autowired
    BookingRepository bookingRepository;

    @Autowired
    SeatsStatusConverter seatsStatusConverter;

    @Override
    public List<SeatsStatusResponse> getSeatsStatusForShow( String showId) {
        List<Object[]> resp = bookingRepository.getSeatsStatus(showId);
        System.out.println("result size: "+resp.size());
        return resp.stream()
                .map(seatsStatusConverter::convert)
                .collect(Collectors.toList());
    }

    public BookSeatResponse bookSeats(BookSeatRequest seatDetails){
        int bookedSeats = bookingRepository.bookSeats(seatDetails.getUserId(),seatDetails.getShow_id(), seatDetails.getSeat_ids());
        BookSeatResponse resp = new BookSeatResponse();
        System.out.println(bookedSeats+" row(s) updated.");
        if(bookedSeats > 0){
            resp.setMessage("Seats has been reserved. Please complete the payment.");
            resp.setStatusCode(200);
            return resp;
        } else if (bookedSeats == 0) {
            resp.setStatusCode(404);
            resp.setMessage("No available seats found for the provided selection.");
            return resp;
        }
        resp.setStatusCode(500);
        resp.setMessage("Reservation unsuccessful.");
        return resp;
    }


public int callBookTicket(Long showId, String userId, String seatIdsCsv) {

        StoredProcedureQuery query = entityManager
            .createStoredProcedureQuery("SpBookTicket")
            .registerStoredProcedureParameter("show_id", Long.class, ParameterMode.IN)
            .registerStoredProcedureParameter("bookinguser", String.class, ParameterMode.IN)
            .registerStoredProcedureParameter("seat_ids", String.class, ParameterMode.IN)
            .registerStoredProcedureParameter("bookcount", Integer.class, ParameterMode.OUT); 
            query.setParameter("show_id", showId);
            query.setParameter("bookinguser", userId);
            query.setParameter("seat_ids", seatIdsCsv);
        query.execute();
        Integer returnValue = (Integer) query.getOutputParameterValue("bookcount");
        return returnValue;

        
    }



}
   







