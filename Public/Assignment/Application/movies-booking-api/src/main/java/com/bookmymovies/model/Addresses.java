package com.bookmymovies.model;

import lombok.Getter;
import lombok.Setter;

import jakarta.persistence.Id;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Getter
@Setter
@Entity
@Table(name = "Addresses")
public class Addresses {
    @Id
    String addressid;
    String addressline1;
    String addressline2;
    String city;
    String postal_code;
    String latitude;
    String longitude;
    boolean is_deleted;
}
