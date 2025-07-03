package com.bookmymovies.model;

import lombok.Getter;
import lombok.Setter;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Getter
@Setter
@Entity
@Table(name = "Bookings")
public class Bookings {
    @Id
    String booking_id;
    String user_id;
    String show_id;
    String booking_time;
    String currency_code;
    int total_amount;
    String booking_status_code;
    boolean is_deleted;

}
