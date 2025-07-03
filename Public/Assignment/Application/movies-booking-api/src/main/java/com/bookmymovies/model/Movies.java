package com.bookmymovies.model;

import lombok.Getter;
import lombok.Setter;

import jakarta.persistence.Id;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Getter
@Setter
@Entity
@Table(name = "Movies")
public class Movies {
    @Id
    String movie_id;
    String title;
    String language;
    String release_date;
    String duration_minutes;
    String director;
    String casts;
    String description;
    String rating;
    String poster_url;
    String trailer_url;
    boolean is_deleted;
}
