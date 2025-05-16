package com.example.sp.entity.board;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.annotations.ColumnDefault;
import com.example.sp.entity.user.Member;
import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Lob;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Transient;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class Board {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private int boardIdx;
	
	private String title;
	
	@Lob
	@Column(columnDefinition = "TEXT")
	private String contents;
	
	@Enumerated(EnumType.STRING)
	private BoardType boardType;
	
	@ToString.Exclude
	@ManyToOne(fetch = FetchType.LAZY, optional = false)
	@JoinColumn(name = "userid", nullable = false)
	private Member member;
	
	@Column(name = "regdate", updatable = false)
	private LocalDateTime regdate;
	
	@Transient
	private String formattedRegdate;
	
	
	@ColumnDefault("0")
	private int hit;
	
	
	@JsonIgnore // Attach 목록을 JSON 출력에서 제외
	@OneToMany(mappedBy = "board", cascade = CascadeType.REMOVE, orphanRemoval = true)
	private List<Attach> attachList = new ArrayList<>();
	
	
	
	@JsonIgnore // Reply 목록을 JSON 출력에서 제외
	@OneToMany(mappedBy = "board", cascade = CascadeType.REMOVE, orphanRemoval = true)
	private List<Reply> replyList = new ArrayList<>();
	
	
}
