package com.example.sp.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.sp.repository.board.AttachRepository;
import com.example.sp.util.UploadFileUtils;

import jakarta.transaction.Transactional;

@Controller
public class UploadController {
   @Autowired
   AttachRepository attachRepository;

   String upload_path = "c:/upload";

   @ResponseBody
   @PostMapping(value = "/upload/ajax_upload", produces = "text/plain;charset=utf-8")
   public ResponseEntity<String> ajax_upload(@RequestParam(name = "file") MultipartFile file) throws Exception {

      String filename = UploadFileUtils.uploadFile(upload_path, file.getOriginalFilename(), file.getBytes());
      return new ResponseEntity<String>(filename, HttpStatus.OK);

   }


   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   @ResponseBody
   @GetMapping("/upload/display_file")
   public ResponseEntity<byte[]> display_file(@RequestParam(name= "file_name") String file_name) {
                                    //file_name 파라미터를 받아서 해당 파일을 업로드 경로에서 검색
       InputStream in = null;
       ResponseEntity<byte[]> entity = null;
       
       // BoardController에서 저장한 경로 그대로 사용
       String uploadPath = "C:\\spring\\shopJpa\\src\\main\\webapp\\resources\\static\\images\\board_images\\";
       //이제 업로드 될 경로
       try {
           File file = new File(uploadPath + file_name);
           if (!file.exists()) {
               return new ResponseEntity<>(HttpStatus.NOT_FOUND); // 파일이 없으면 404 응답
           }
           
           in = new FileInputStream(file);//파일 존재하면 FileInputStream을 통해 파일을 읽어들임
           HttpHeaders headers = new HttpHeaders();

           // 파일 확장자에 따라 Content-Type 자동 설정
           String contentType = Files.probeContentType(file.toPath());//이거를 통해 파일의 MIME타입(Content-type)을 자동으로 설정
           if (contentType == null) {
               contentType = "application/octet-stream"; // 확장자 모르면 기본값
           }
           headers.setContentType(MediaType.parseMediaType(contentType));

           entity = new ResponseEntity<>(IOUtils.toByteArray(in), headers, HttpStatus.OK);//상태 코드는 200OK.
       } catch (Exception e) {
           e.printStackTrace();
           entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);//파일이 없으면 404 Not Found, 오류는 404 BAD REQUEST
       } finally {
           try {
               if (in != null) in.close();
           } catch (IOException e) {
               e.printStackTrace();
           }
       }
       return entity;
   }
}
   
/*
 * // 상품 이미지 업로드
 * 
 * @ResponseBody
 * 
 * @PostMapping(value = "/upload/product_image_upload", produces =
 * "text/plain;charset=utf-8") public ResponseEntity<String>
 * product_image_upload(@RequestParam(name = "file") MultipartFile file) throws
 * Exception { // 상품 이미지 저장 경로로 업로드 String filename =
 * UploadFileUtils.uploadFile(product_image_path, file.getOriginalFilename(),
 * file.getBytes()); return new ResponseEntity<String>(filename, HttpStatus.OK);
 * } // 상품 이미지 다운로드
 * 
 * @ResponseBody
 * 
 * @GetMapping("/upload/display_product_image") public ResponseEntity<byte[]>
 * display_product_image(@RequestParam(name = "file_name") String file_name) {
 * InputStream in = null; ResponseEntity<byte[]> entity = null; // 상품 이미지 저장 경로
 * 사용 String productImagePath = "C:/upload/product_images/"; try { File file =
 * new File(productImagePath + file_name); if (!file.exists()) { return new
 * ResponseEntity<>(HttpStatus.NOT_FOUND); } in = new FileInputStream(file);
 * HttpHeaders headers = new HttpHeaders(); String contentType =
 * Files.probeContentType(file.toPath()); if (contentType == null) { contentType
 * = "application/octet-stream"; }
 * headers.setContentType(MediaType.parseMediaType(contentType)); entity = new
 * ResponseEntity<>(IOUtils.toByteArray(in), headers, HttpStatus.OK); } catch
 * (Exception e) { e.printStackTrace(); entity = new
 * ResponseEntity<>(HttpStatus.BAD_REQUEST); } finally { try { if (in != null)
 * in.close(); } catch (IOException e) { e.printStackTrace(); } } return entity;
 * } }
 * 
 */

