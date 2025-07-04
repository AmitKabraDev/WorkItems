package com.bookmymovies.repository.impl;

import jakarta.annotation.PostConstruct;
import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;
import org.springframework.stereotype.Repository;

import com.bookmymovies.repository.BookingRepository;
import com.bookmymovies.repository.BookingRepositoryCustom;

import java.util.List;

@Repository
public class BookingRepositoryImpl implements BookingRepositoryCustom {


    @PersistenceContext
    private EntityManager entityManager;

    @PostConstruct
    public void init() {
        System.out.println("EntityManager injected? " + (entityManager != null));
    }


    @Override
    public int callBookTicket(Long showId, String userId, String seatIds) {
        //String seatIdsCsv = String.join(",", seatIds);

        StoredProcedureQuery query = entityManager
            .createStoredProcedureQuery("SpBookTicket")
            .registerStoredProcedureParameter("show_id", Long.class, ParameterMode.IN)
            .registerStoredProcedureParameter("bookinguser", String.class, ParameterMode.IN)
            .registerStoredProcedureParameter("seat_ids", String.class, ParameterMode.IN)
            .registerStoredProcedureParameter("bookcount", Integer.class, ParameterMode.OUT);

        query.setParameter("show_id", showId);
        query.setParameter("bookinguser", userId);
        query.setParameter("seat_ids", seatIds);

        query.execute();
        return (Integer) query.getOutputParameterValue("bookcount");
    }
}

