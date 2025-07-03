package com.bookmymovies.service.Impl;

import com.bookmymovies.model.*;
import com.bookmymovies.repository.MoviesRepository;
import com.bookmymovies.service.MovieService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.convert.converter.Converter;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class MovieServiceImpl implements MovieService {

    @Autowired
    MoviesRepository moviesRepository;

    @Autowired
    private Converter<Object[], MoviesResponse> moviesResultConverter;

    @Autowired
    private Converter<Object[], TheatreResponse> theatreResponseConverter;

    @Autowired
    private Converter<Object[], ShowsResponse> showsResponseConverter;

    @Override
    public List<MoviesResponse> getAllMovies(String city) {
        List<Object[]> resp = moviesRepository.getMoviesByCity(city);
        System.out.println("total movies: "+resp.size());
        return resp.stream()
                .map(moviesResultConverter::convert)
                .collect(Collectors.toList());
    }

    @Override
    public List<TheatreResponse> getTheatreDetail(String theatre_id) {
        List<Object[]> resp = moviesRepository.getMoviesByTheatre(theatre_id);
        System.out.println("result size: "+resp.size());
        return resp.stream()
                .map(theatreResponseConverter::convert)
                .collect(Collectors.toList());
    }

    @Override
    public MovieWithShowsResponse getMovieWithShows(String city, String movie_id, String showdate ) {
        MoviesResponse movie = moviesRepository.getMovieDetail(movie_id,city).stream()
                .map(moviesResultConverter::convert)
                .toList().get(0);
        System.out.println("movie detail: "+movie.toString());
        List<ShowsResponse> shows = moviesRepository.getShowsForMovie(movie_id,city,showdate).stream()
                .map(showsResponseConverter::convert)
                .toList();
        return new MovieWithShowsResponse(movie,shows);
    }
}
