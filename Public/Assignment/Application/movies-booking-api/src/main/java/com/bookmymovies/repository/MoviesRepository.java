package com.bookmymovies.repository;

import java.util.List;
import java.time.LocalDate;
import com.bookmymovies.model.Movies;
import com.bookmymovies.model.MoviesResponse;
import com.bookmymovies.model.TheatreResponse;
import org.springframework.data.jpa.repository.JpaRepository;

import org.springframework.data.jpa.repository.Query;


public interface MoviesRepository extends JpaRepository<Movies, Long> {

  @Query(value=" SELECT DISTINCT mv.movie_id, mv.title, mv.release_date, mv.language, mv.poster_url, vn.venue_name, ad.city\n" +
          "FROM Movies mv\n" +
          "JOIN \n" +
          "    Shows sh ON mv.movie_id = sh.movie_id\n" +
          "JOIN \n" +
          "    Screens sc ON sh.screen_id = sc.screen_id\n" +
          "JOIN \n" +
          "    Venues vn ON sc.venue_id = vn.venue_id\n" +
          "JOIN \n" +
          "    Addresses ad ON vn.addressid = ad.addressid\n" +
          "WHERE \n" +
          "    LOWER(ad.city) = ?1")
  List<Object[]> getMoviesByCity(String city);

  @Query(value= "select vn.venue_name, mv.title, sh.start_datetime, sc.screen_name, count(st.seat_id) as total_seats,\n" +
          "count( distinct bk.booking_id) as booked_seats\n" +
          "from Movies mv\n" +
          "left join Shows sh on mv.movie_id = sh.movie_id\n" +
          "left join Screens sc on sh.screen_id = sc.screen_id\n" +
          "left join Venues vn on sc.venue_id = vn.venue_id\n" +
          "left join Addresses ad on vn.addressid = ad.addressid \n" +
          "left join Seats st on st.screen_id = sh.screen_id\n" +
          "left join Bookings bk on bk.show_id = sh.show_id \n" +
          "where  \n" +
          " LOWER(vn.venue_id)= ?1 group by sc.screen_name,vn.venue_name, mv.title, sh.start_datetime")
  List<Object[]> getMoviesByTheatre(String theatre_id);

  @Query(value=" SELECT DISTINCT mv.movie_id, mv.title, mv.release_date, mv.language, mv.poster_url, vn.venue_name, ad.city\n" +
          "FROM Movies mv\n" +
          "JOIN \n" +
          "    Shows sh ON mv.movie_id = sh.movie_id\n" +
          "JOIN \n" +
          "    Screens sc ON sh.screen_id = sc.screen_id\n" +
          "JOIN \n" +
          "    Venues vn ON sc.venue_id = vn.venue_id\n" +
          "JOIN \n" +
          "    Addresses ad ON vn.addressid = ad.addressid\n" +
          "WHERE \n" +
          " mv.movie_id = :movie_id and ( LOWER(ad.city) =:city or :city is NULL ) ")
  List<Object[]> getMovieDetail(String movie_id,String city);

  @Query(value= "select sh.show_id, sc.screen_name, vn.venue_name, ad.city, sh.start_datetime\n" +
          "          from Movies mv\n" +
          "          left join Shows sh on mv.movie_id = sh.movie_id\n" +
          "          left join Screens sc on sh.screen_id = sc.screen_id\n" +
          "          left join Venues vn on sc.venue_id = vn.venue_id\n" +
          "          left join Addresses ad on vn.addressid = ad.addressid\n" +
          "          where mv.movie_id = :movie_id and ( LOWER(ad.city) =:city or :city is NULL )  and ( cast(sh.start_datetime as date) =:showdate or :showdate is NULL )")
  List<Object[]> getShowsForMovie(String movie_id,String city, LocalDate showdate );
}
