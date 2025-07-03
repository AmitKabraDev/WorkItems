package com.bookmymovies.model;


public class BookSeatRequest {
    String show_id;
    String seat_ids;
    String userId;

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getShow_id() {
        return show_id;
    }

    public void setShow_id(String show_id) {
        this.show_id = show_id;
    }

    public String getSeat_ids() {
        return seat_ids;
    }

    public void setSeat_id(String seat_ids) {
        this.seat_ids = seat_ids;
    }
}
