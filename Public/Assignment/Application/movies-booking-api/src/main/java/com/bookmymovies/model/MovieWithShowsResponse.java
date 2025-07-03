package com.bookmymovies.model;

import java.util.List;

public class MovieWithShowsResponse {
    /*
    * This class describes the detail about the movie:
    * Trailer link
    * Poster URL to display thumbnail
    * Which theatres in your city are showing this movie
    * What are the show timings
    * If the seats are available for those timings (green: >50%, yellow: 50%<70%, red)
    * */

    MoviesResponse movieDetail;
    List<ShowsResponse> shows;

    public MovieWithShowsResponse(MoviesResponse movieDetail, List<ShowsResponse> shows) {
        this.movieDetail = movieDetail;
        this.shows = shows;
    }

    public MoviesResponse getMovieDetail() {
        return movieDetail;
    }

    public void setMovieDetail(MoviesResponse movieDetail) {
        this.movieDetail = movieDetail;
    }

    public List<ShowsResponse> getShows() {
        return shows;
    }

    public void setShows(List<ShowsResponse> shows) {
        this.shows = shows;
    }
}
