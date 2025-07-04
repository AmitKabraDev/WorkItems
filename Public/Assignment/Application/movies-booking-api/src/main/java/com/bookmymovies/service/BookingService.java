package com.bookmymovies.service;

import com.bookmymovies.model.SeatsStatusResponse;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface BookingService {

    List<SeatsStatusResponse> getSeatsStatusForShow( String showId);


}


    