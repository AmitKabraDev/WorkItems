package com.bookmymovies.model;

import lombok.Getter;
import lombok.Setter;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Getter
@Setter
@Entity
@Table(name = "Seats")
public class Seats {

    @Id
    String seat_id;
    String screen_id;
    String row_number;
    int seat_number;
    String seat_type_id;
    String currency_code;
    int seat_price;
    boolean is_deleted;
}
