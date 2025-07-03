package com.bookmymovies.repository;

import com.bookmymovies.model.Movies;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface BookingRepository  extends JpaRepository<Movies, Long> {

    @Query(value = "select CAST(sh.show_id AS CHAR) as show_id,  CAST(sh.movie_id AS CHAR) as movie_id, \n" +
            " CAST(sh.screen_id  AS CHAR) as screen_id ,sc.screen_name, vn.venue_name, CAST(sh.start_datetime AS CHAR) as start_datetime,\n" +
           "  CAST(sinv.seat_id AS CHAR) as seat_id,(sm.row_number + sm.seat_number) as seatname, st.type_name as SeatType, \n" +
            " CAST(sinv.price AS CHAR) AS price, sinv.currency_code, \n" +
            " case when (sinv.is_booked=1 or sinv.is_locked=1) then 'Not Available' else 'Available' end as seat_status \n" +
            " from Movies mv\n" +
            " left join Shows sh on mv.movie_id = sh.movie_id\n" +
            " left join Screens sc on sh.screen_id = sc.screen_id\n" +
            " left join Venues vn on sc.venue_id = vn.venue_id\n" +
            " left join Addresses ad on vn.addressid = ad.addressid\n" +
            " left join Seatinventroy sinv on sh.show_id=sinv.show_id\n" +
            " left join Seats sm on sm.seat_id=sinv.seat_id\n" +
            " left join seattypes st on sm.seat_type_id=st.seat_type_id\n" +
            " where  sh.show_id= :show_id " , nativeQuery = true)
    List<Object[]> getSeatsStatus(String show_id);

    @Modifying
    @Transactional
    @Query(value = "update  Seatinventroy \n" +
            "set is_locked=1,lock_time=current_timestamp,expiry_time=DATEADD(mi, 3,current_timestamp),lockedforuser= ?1 ,updated_by=current_user,updated_at=current_timestamp \n \n" +
            "where show_id = ?2 and seat_id in ?3")
    int bookSeats(String user_id,String show_id, String seat_ids);

}


