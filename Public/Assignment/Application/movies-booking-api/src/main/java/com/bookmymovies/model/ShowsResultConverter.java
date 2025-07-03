package com.bookmymovies.model;

import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;

@Component
public class ShowsResultConverter implements Converter<Object[], ShowsResponse> {

        @Override
        public ShowsResponse convert(Object[] source) {
            String show_id = (String) source[0];
            String screen_name = (String) source[1];
            String venue_name = (String) source[2];
            String city = (String) source[3];
            String start_datetime = (String) source[4];
            return new ShowsResponse(show_id, screen_name,venue_name,city,start_datetime);
        }
    }
