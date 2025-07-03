package com.bookmymovies.model;

import lombok.Data;

@Data
public class MoviesResponse {
    /*
    * This class describes the landing page of the application
    * Landing page should display the list of movies being shown in the selected city.
    * A default city will be chosen based on the user's location data or the city selection made by the user
    * If the user changes the city, new API request will be triggered to get this list again
    * The list of movies has the below details:
    * Movie Title
    * Movie Thumbnail (poster URL) to show in the UI list
    * Language
    * Release Date
    * Theatre Name
    * City name
    *  */
    String movie_id;
    String title;
    String release_date;
    String language;
    String poster_url;
    String venue_name;
    String city;

    public MoviesResponse(String movie_id, String title, String release_date, String language, String poster_url, String venue_name, String city) {
        
        this.movie_id = movie_id;
        this.title = title;
        this.release_date = release_date;
        this.language = language;
        this.poster_url = poster_url;
        this.venue_name = venue_name;
        this.city = city;
    }

    public String getMovieId() {
        return movie_id;
    }

    public void setMovieId(String movie_id) {
        this.movie_id = movie_id;
    }

   public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getRelease_date() {
        return release_date;
    }

    public void setRelease_date(String release_date) {
        this.release_date = release_date;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getPoster_url() {
        return poster_url;
    }

    public void setPoster_url(String poster_url) {
        this.poster_url = poster_url;
    }

    public String getVenue_name() {
        return venue_name;
    }

    public void setVenue_name(String venue_name) {
        this.venue_name = venue_name;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }
}
