package com.bookmymovies.model;

import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;

@Component
public class SeatsStatusConverter implements Converter<Object[], SeatsStatusResponse> {

    @Override
    public SeatsStatusResponse convert(Object[] source) {

        String show_id = (String) source[0];
        String movie_id = (String) source[1];
        String screen_id = (String) source[2];
        String screen_name = (String) source[3];
        String venue_name = (String) source[4];
        String start_datetime = (String) source[5];
        String seat_id = (String) source[6];
        String seatname = (String) source[7];
        String seatType = (String) source[8];
        String seatPrice = (String) source[9];
        String currencyCode = (String) source[10];
        String seat_status = (String) source[11];

        return new SeatsStatusResponse(show_id, movie_id, screen_id, screen_name, venue_name, start_datetime, seat_id, seatname,  seatType,  seatPrice,  currencyCode,  seat_status);
    }
    
}
