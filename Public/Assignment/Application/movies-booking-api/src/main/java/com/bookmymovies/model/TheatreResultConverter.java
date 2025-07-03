package com.bookmymovies.model;

import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;

@Component
public class TheatreResultConverter implements Converter<Object[], TheatreResponse> {

    @Override
    public TheatreResponse convert(Object[] source) {
        String venue_name = (String) source[0];
        String title = (String) source[1];
        String show_time = (String) source[2];
        String screen_name = (String) source[3];
        Long total_seats = (Long) source[4];
        Long booked_seats = (Long) source[5];

        return new TheatreResponse(venue_name, title,show_time,screen_name,total_seats,booked_seats);
    }
}
