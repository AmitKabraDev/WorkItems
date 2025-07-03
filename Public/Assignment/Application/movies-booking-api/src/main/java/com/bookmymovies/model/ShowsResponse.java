package com.bookmymovies.model;

import java.util.List;

public class ShowsResponse {
    String show_id;
    String screen_name;
    String venue_name;
    String city;
    String start_datetime;

    public ShowsResponse(String show_id, String screen_name, String venue_name, String city, String start_datetime) {
        this.show_id = show_id;
        this.screen_name = screen_name;
        this.venue_name = venue_name;
        this.city = city;
        this.start_datetime = start_datetime;
    }

    public String getShow_id() {
        return show_id;
    }   
    public void setShow_id(String show_id) {
        this.show_id = show_id;
    }
    
  public String getScreen_name() {
        return screen_name;
    }

    public void setScreen_name(String screen_name) {
        this.screen_name = screen_name;
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

    public String getStart_datetime() {
        return start_datetime;
    }

    public void setStart_datetime(String start_datetime) {
        this.start_datetime = start_datetime;
    }
}
