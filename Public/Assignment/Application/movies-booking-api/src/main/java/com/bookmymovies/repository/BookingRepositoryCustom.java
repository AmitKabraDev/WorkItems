package com.bookmymovies.repository;

import java.util.List;

public interface BookingRepositoryCustom {
    int callBookTicket(Long showId, String userId, String seatIds);
}