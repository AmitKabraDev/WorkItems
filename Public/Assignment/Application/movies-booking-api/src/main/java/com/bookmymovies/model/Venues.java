package com.bookmymovies.model;

import lombok.Getter;
import lombok.Setter;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Getter
@Setter
@Entity
@Table(name = "Venues")
public class Venues {
    @Id
    String venue_id;
    String venue_name;
    String addressid;
    String contact_email;
    String contact_phone;
    boolean is_deleted;
}
