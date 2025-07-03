package com.bookmymovies.service;

import com.bookmymovies.model.MovieWithShowsResponse;
import com.bookmymovies.model.MoviesResponse;
import com.bookmymovies.model.TheatreResponse;
import org.springframework.stereotype.Service;

import java.util.List;


public interface MovieService {
    List<MoviesResponse> getAllMovies(String city);

    List<TheatreResponse> getTheatreDetail(String theatreName);

    MovieWithShowsResponse getMovieWithShows(String city, String movie_id, String showdate);
}
