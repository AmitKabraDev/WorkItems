package com.bookmymovies.model;

public class SeatsStatusResponse {
    String show_id;
    String movie_id;
    String screen_id;
    String screen_name;
    String venue_name;
    String start_datetime;
    String seat_id;
    String seatname;
    String seatType;
    String seatPrice;
    String currencyCode;
    String seat_status;


            

    public SeatsStatusResponse(String show_id, String movie_id, String screen_id, String screen_name, String venue_name, String start_datetime, String seat_id,  String seatname, String seatType, String seatPrice, String currencyCode, String seat_status) {
        this.show_id = show_id;
        this.movie_id = movie_id;
        this.screen_id = screen_id;
        this.screen_name = screen_name;
        this.venue_name = venue_name;
        this.start_datetime = start_datetime;
        this.seat_id = seat_id;
        this.seatname = seatname;
        this.seatType = seatType;
        this.seatPrice = seatPrice;
        this.currencyCode = currencyCode;
        this.seat_status = seat_status;
    }


    public String getSeatname() {
        return seatname;
    }
    public void setSeatname(String seatname) {
        this.seatname = seatname;
    }
    public String getSeatType() {
        return seatType;
    }



    public void setSeatType(String seatType) {
        this.seatType = seatType;
    }
    public String getSeatPrice() {
        return seatPrice;
    }
    public void setSeatPrice(String seatPrice) {
        this.seatPrice = seatPrice;
    }
    public String getCurrencyCode() {
        return currencyCode;
    }


    public void setCurrencyCode(String currencyCode) {
        this.currencyCode = currencyCode;
    }
    
    public String getShow_id() {
        return show_id;
    }

    public void setShow_id(String show_id) {
        this.show_id = show_id;
    }

    public String getMovie_id() {
        return movie_id;
    }

    public void setMovie_id(String movie_id) {
        this.movie_id = movie_id;
    }

    public String getScreen_id() {
        return screen_id;
    }

    public void setScreen_id(String screen_id) {
        this.screen_id = screen_id;
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

    public String getStart_datetime() {
        return start_datetime;
    }

    public void setStart_datetime(String start_datetime) {
        this.start_datetime = start_datetime;
    }

    public String getSeat_id() {
        return seat_id;
    }

    public void setSeat_id(String seat_id) {
        this.seat_id = seat_id;
    }

    public String getSeat_status() {
        return seat_status;
    }

    public void setSeat_status(String seat_status) {
        this.seat_status = seat_status;
    }
}
