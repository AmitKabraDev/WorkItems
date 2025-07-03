package com.bookmymovies.model;

import lombok.Getter;
import lombok.Setter;

import jakarta.persistence.Id;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Getter
@Setter
@Entity
@Table(name = "Screens")
public class Screens {
    @Id
    String screen_id;
    String venue_id;
    String screen_name;
    String capacity;
    String seatlayot_id;
    boolean is_deleted;
}
