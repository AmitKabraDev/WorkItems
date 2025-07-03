package com.bookmymovies.model;

import lombok.Getter;
import lombok.Setter;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Getter
@Setter
@Entity
@Table(name = "Seatinventroy")
public class Seatinventroy {
    @Id
    String seatinventroy_id;
    String lockedforuser;
    String seat_id;
    boolean is_booked;
    boolean is_locked;
    boolean is_deleted;
    String show_id;

}
