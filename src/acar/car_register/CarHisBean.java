/**
 * 저당권 등록
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_register;

import java.util.*;

public class CarHisBean {
    //Table : CAR_CHANGE
    private String car_mng_id;			//자동차관리번호
	private String cha_seq;				//SEQ_NO
	private String cha_dt;				//변경일
	private String cha_cau;				//변경사유
	private String cha_cau_sub;			//변경사유
	private String cha_car_no;			//변경사유
	private String reg_id;				//
	private String reg_dt;				//
	private String use_yn;				//
	private String scanfile;			//등록증스캔
	private String file_type;			//스캔파일 확장자
	private String car_ext;				//사용본거지
	        
    // CONSTRCTOR            
    public CarHisBean() {  
	    this.car_mng_id = "";			//자동차관리번호
		this.cha_seq = "";				//SEQ_NO
		this.cha_dt = "";				//변경일
		this.cha_cau = "";				//변경사유
		this.cha_cau_sub = "";			//변경사유
		this.cha_car_no = "";
		this.reg_id = "";
		this.reg_dt = "";
		this.use_yn = "";
		this.scanfile = "";
		this.file_type = "";
		this.car_ext = "";

	}

	// get Method
	public void setCar_mng_id(String val){
		if(val==null) val="";
		this.car_mng_id = val;
	}
	public void setCha_seq(String val){
		this.cha_seq = val;
	}
	public void setCha_dt(String val){
		if(val==null) val="";
		this.cha_dt = val;
	}
	public void setCha_cau(String val){
		if(val==null) val="";
		this.cha_cau = val;
	}
	public void setCha_cau_sub(String val){
		if(val==null) val="";
		this.cha_cau_sub = val;
	}
	public void setCha_car_no(String val){
		if(val==null) val="";
		this.cha_car_no = val;
	}
	public void setReg_id		(String val){		if(val==null) val="";	reg_id		= val; }
	public void setReg_dt		(String val){		if(val==null) val="";	reg_dt		= val; }
	public void setUse_yn		(String val){		if(val==null) val="";	use_yn		= val; }
	public void setScanfile		(String val){		if(val==null) val="";	scanfile	= val; }		
	public void setFile_type	(String str){		if(str==null) str="";	file_type	= str; }
	public void setCar_ext		(String str){		if(str==null) str="";	car_ext		= str; }
		
	//Get Method
	public String getCar_mng_id(){
		return car_mng_id;
	}
	public String getCha_seq(){
		return cha_seq;
	}
	public String getCha_dt(){
		return cha_dt;
	}
	public String getCha_cau(){
		return cha_cau;
	}
	public String getCha_cau_sub(){
		return cha_cau_sub;
	}
	public String getCha_car_no(){
		return cha_car_no;
	}
	public String getReg_id		(){		return reg_id;		}
	public String getReg_dt		(){		return reg_dt;		}
	public String getUse_yn		(){		return use_yn;		}
	public String getScanfile	(){		return scanfile;	}
	public String getFile_type	(){		return file_type;	}
	public String getCar_ext	(){		return car_ext;		}

}