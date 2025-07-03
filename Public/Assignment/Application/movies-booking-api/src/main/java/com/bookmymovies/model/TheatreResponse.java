package com.bookmymovies.model;

import lombok.Data;

@Data
public class TheatreResponse {
    String venue_name;
    String title;
    String show_time;
    String screen_name;
    Long total_seats;
    Long booked_seats;


    public TheatreResponse(String venue_name, String title, String show_time, String screen_name, Long total_seats, Long booked_seats) {
        this.venue_name = venue_name;
        this.title = title;
        this.show_time = show_time;
        this.screen_name = screen_name;
        this.total_seats = total_seats;
        this.booked_seats = booked_seats;
    }

    public String getVenue_name() {
        return venue_name;
    }

    public void setVenue_name(String venue_name) {
        this.venue_name = venue_name;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getShow_time() {
        return show_time;
    }

    public void setShow_time(String show_time) {
        this.show_time = show_time;
    }

    public String getScreen_name() {
        return screen_name;
    }

    public void setScreen_name(String screen_name) {
        this.screen_name = screen_name;
    }

    public Long getTotal_seats() {
        return total_seats;
    }

    public void setTotal_seats(Long total_seats) {
        this.total_seats = total_seats;
    }

    public Long getBooked_seats() {
        return booked_seats;
    }

    public void setBooked_seats(Long booked_seats) {
        this.booked_seats = booked_seats;
    }
}
