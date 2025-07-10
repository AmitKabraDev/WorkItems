package com.bookmymovies.controller;

import java.util.ArrayList;
import java.util.List;

import com.bookmymovies.model.MovieWithShowsResponse;
import com.bookmymovies.model.MoviesResponse;
import com.bookmymovies.model.TheatreResponse;
import com.bookmymovies.service.impl.MovieServiceImpl;
import com.bookmymovies.util.InputValidator;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;


@CrossOrigin(origins = "http://localhost:8080")
@RestController
@RequestMapping("/api")
/*
* This movie controller class will show all details related to movies
* All the resources will use city constrain to only returns the data related to the given city
* Default city as Mumbai will be used if no city is provided
* */
public class MoviesController {

	@Autowired
	MovieServiceImpl movieService;

	@GetMapping("/movies")
	public ResponseEntity<List<MoviesResponse>> getAllMovies(@RequestParam(required = false,defaultValue = "mumbai") String city) {
		try {
			List<MoviesResponse> movies = new ArrayList<>();
			System.out.println("city is: "+city);

			if (InputValidator.isValidInput(city)  )
			{
				movies = movieService.getAllMovies(city);

				if (movies.isEmpty()) {
					return new ResponseEntity<>(HttpStatus.NO_CONTENT);
				}

				return new ResponseEntity<>(movies, HttpStatus.OK);
			} 
			else {
				return ResponseEntity.badRequest().body(null);
			}	
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	@GetMapping("/movies/{movie_id}")
	public ResponseEntity<MovieWithShowsResponse> getMovie(@RequestParam(required = false) String city, @RequestParam(required = false) String showdate, @PathVariable(required = true) String movie_id) {
		try {
			MovieWithShowsResponse movieDetail;
			System.out.println("city is: "+ String.valueOf(city)  + ", Movieid:"  + String.valueOf(movie_id) + ", showdate:"  + String.valueOf(showdate));
			
			if (InputValidator.isValidInput( movie_id, 10, true)  )
			{
				LocalDate parsedDate = null;
				if (showdate != null && !(showdate.isEmpty())) {
			
					DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
					parsedDate = LocalDate.parse(showdate, formatter);
			
				}
				
				movieDetail = movieService.getMovieWithShows(city,movie_id,parsedDate);

				if (movieDetail == null) {
					return new ResponseEntity<>(HttpStatus.NO_CONTENT);
				}

				return new ResponseEntity<>(movieDetail, HttpStatus.OK);
			} 
			else {
				return ResponseEntity.badRequest().body(null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	@GetMapping("/theatres/{theatre_id}")
	public ResponseEntity<List<TheatreResponse>> getTheatreDetail(@PathVariable(required = true) String theatre_id) {
		try {
			List<TheatreResponse> movies = new ArrayList<>();

		
			if (InputValidator.isValidInput( theatre_id, 10, true)  )
			{
				movies = movieService.getTheatreDetail(theatre_id);

				if (movies.isEmpty()) {
					return new ResponseEntity<>(HttpStatus.NO_CONTENT);
				}

				return new ResponseEntity<>(movies, HttpStatus.OK);
			} 
			else {
				return ResponseEntity.badRequest().body(null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

}
