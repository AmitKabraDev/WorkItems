package com.bookmymovies.model;

import lombok.Getter;
import lombok.Setter;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Getter
@Setter
@Entity
@Table(name = "Shows")
public class Shows {

    @Id
    String show_id;
    String movie_id;
    String screen_id;
    String start_datetime;
    String end_datetime;
    String currency_code;
    int baseticket_price;
    boolean is_deleted;
}
