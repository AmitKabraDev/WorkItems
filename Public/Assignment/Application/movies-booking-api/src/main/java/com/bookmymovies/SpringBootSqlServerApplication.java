package com.bookmymovies;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
@EnableJpaRepositories(basePackages = "com.bookmymovies.repository")
@EntityScan(basePackages = "com.bookmymovies.model")
public class SpringBootSqlServerApplication {

	public static void main(String[] args) {
		SpringApplication.run(SpringBootSqlServerApplication.class, args);
	}

}
