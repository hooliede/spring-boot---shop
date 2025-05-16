package com.example.sp.util;

import java.io.File;
import java.text.DecimalFormat;
import java.util.Calendar;
import java.util.UUID;

import org.springframework.util.FileCopyUtils;

public class UploadFileUtils {
	//makeDir()메소드
	static void makeDir(String uploadPath, String... paths) {
										//String... paths를 사용하여 여러개의 디렉토리를 한 번에 생성 가능
		if (new File(paths[paths.length - 1]).exists()) {
			//paths[paths.length - 1]이 이미 존재하면 메소드를 종료
			return;
		}
		for (String path: paths) {
			File dirPath = new File(uploadPath + path);
			if (!dirPath.exists()) {
				dirPath.mkdir();//존재하지 않으면 mkdir() 메소드로 디렉토리 생성
			}
		}
	}
	
	//calcPath() 메소드
	static String calcPath(String upload_path) {
		Calendar cal = Calendar.getInstance();//현재 날짜를 가져옴
		String year = "/" + cal.get(Calendar.YEAR);//현재 연도를 문자열로 생성
		String month = year + "/" + new DecimalFormat("00").format(cal.get(Calendar.MONTH) + 1);//연도 뒤에 월을 추가하여, DecimalFormat("00")으로 두 자라리로 포멧
		String path = month + "/" + new DecimalFormat("00").format(cal.get(Calendar.DATE));//path 뒤에 월 일을 추가하여 최종 경로를 만듬
		makeDir(upload_path, year, month, path);//메소드를 호출하여 해당 디렉토리가 없으면 생성
		return path;
	}
	
	
	//uploadFile()메소드:파일을 업로드 폴더에 저장하고 해당 파일의 경로를 문자열로 반환
	public static String uploadFile(String uploadPath, String originalName, byte[] fileData) throws Exception {
								//업로드 기본 경로         원본 파일명              파일의 데이터(바이너리 형태:2진수 형태)
		UUID uid = UUID.randomUUID();//고유한 파일 이름 생성
		//UUID는 파일명이 중복되지 않도록 고유 식별자를 생성
		String filename = uid.toString() + "_" + originalName;
		String path = calcPath(uploadPath);//해당 파일을 저장할 날짜별 경로 생성
		File target = new File(uploadPath + path, filename);//파일의 최종 저장 경로와 파일명을 지정
		FileCopyUtils.copy(fileData, target);//실제 파일 데이터를 해당 경로에 복사, fileData는 바이너리데이터
		String str = uploadPath + path + "/" + filename;//최종 파일 경로를 문자열로 구성
		System.out.println("upload:"+str);
		return str;
	}
}
