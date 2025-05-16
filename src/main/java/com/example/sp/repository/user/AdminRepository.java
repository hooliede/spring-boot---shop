package com.example.sp.repository.user;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.sp.entity.user.Admin;

public interface AdminRepository extends JpaRepository<Admin, String>{
	Optional<Admin> findByUseridAndPasswd(String userid, String passwd);
}
