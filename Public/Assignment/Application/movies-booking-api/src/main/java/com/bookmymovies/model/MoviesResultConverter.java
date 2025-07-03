package com.bookmymovies.model;

import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class MoviesResultConverter implements Converter<Object[], MoviesResponse> {

        @Override
        public MoviesResponse convert(Object[] source) {
            String movie_id = (String) source[0];
            String title = (String) source[1];
            String release_date = (String) source[2];
            String language = (String) source[3];
            String poster_url = (String) source[4];
            String venue_name = (String) source[5];
            String city = (String) source[5];
            return new MoviesResponse(movie_id, title, release_date,language,poster_url,venue_name,city);
        }
    }
