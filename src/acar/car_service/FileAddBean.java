/**
 * 파일첨부
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_service;

import java.util.*;

public class FileAddBean {
    //Table : CAR_REG
	private String car_mng_id; 					//자동차관리번호
	private String serv_id;
	private int seq_no; 
	private String file_nm; 
	private String dir; 
	private String exec; 
	private String cont; 
        
    // CONSTRCTOR            
    public FileAddBean() {  
		this.car_mng_id = ""; 					//자동차관리번호
		this.serv_id = "";
		this.seq_no = 0; 
		this.file_nm = "";
		this.dir = "";
		this.exec = "";
		this.cont = "";
	}

	// get Method
	public void setCar_mng_id(String val){
		if(val==null) val="";
		this.car_mng_id = val;
	}
	public void setServ_id(String val){
		if(val==null) val="";
		this.serv_id = val;
	}
	public void setSeq_no(int val){
		this.seq_no = val;
	} 
	public void setFile_nm(String val){
		if(val==null) val="";
		this.file_nm = val;
	}
	public void setDir(String val){
		if(val==null) val="";
		this.dir = val;
	}
	public void setExec(String val){
		if(val==null) val="";
		this.exec = val;
	}
	public void setCont(String val){
		if(val==null) val="";
		this.cont = val;
	}
		
	//Get Method
	public String getCar_mng_id(){
		return car_mng_id;
	}
	public String getServ_id(){
		return serv_id;
	}
	public int getSeq_no(){
		return seq_no;
	} 
	public String getFile_nm(){
		return file_nm;
	}
	public String getDir(){
		return dir;
	}
	public String getExec(){
		return exec;
	}
	public String getCont(){
		return cont;
	}
}