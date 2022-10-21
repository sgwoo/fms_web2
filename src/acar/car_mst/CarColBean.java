/**
 * 차종
 */
package acar.car_mst;

import java.util.*;

public class CarColBean {
    //Table : CAR_COL
	private String car_comp_id;		//자동차사코드
    private String car_cd;			//차종분류코드
    private String car_u_seq;		//차명업데이트관리번호
    private String car_c_seq;		//색상 관리번호
	private String use_yn;			//사용여부
	private String car_c;			//색상명
	private int    car_c_p;			//색상 가격
	private String car_c_dt;		//색상 기준일
	private String etc;				//비고
	private String col_st;			//내외장구분
	private String jg_opt_st;		//사양 조정잔가 구분자
       
    // CONSTRCTOR            
    public CarColBean() { 
		this.car_comp_id	= ""; 
    	this.car_cd			= "";					
	    this.car_u_seq		= "";				
	    this.car_c_seq		= "";
	    this.use_yn			= "";
	    this.car_c			= "";
		this.car_c_p		= 0;
	    this.car_c_dt		= "";
		this.etc			= "";	
		this.col_st			= "";
		this.jg_opt_st		= "";
	}

	// get Method
	public void setCar_comp_id	(String val){	if(val==null) val="";	this.car_comp_id	= val;	}
	public void setCar_cd		(String val){	if(val==null) val="";	this.car_cd			= val;	}
	public void setCar_u_seq	(String val){	if(val==null) val="";	this.car_u_seq		= val;	}
	public void setCar_c_seq	(String val){	if(val==null) val="";	this.car_c_seq		= val;	}
	public void setUse_yn		(String val){	if(val==null) val="";	this.use_yn			= val;	}
	public void setCar_c		(String val){	if(val==null) val="";	this.car_c			= val;	}
	public void setCar_c_p		(int      i){							this.car_c_p		= i;	}
	public void setCar_c_dt		(String val){	if(val==null) val="";	this.car_c_dt		= val;	}
	public void setEtc			(String val){	if(val==null) val="";	this.etc			= val;	}
	public void setCol_st		(String val){	if(val==null) val="";	this.col_st			= val;	}
	public void setJg_opt_st	(String val){	if(val==null) val="";	this.jg_opt_st		= val;	}
		
	//Get Method
	public String getCar_comp_id(){		return car_comp_id;	}
	public String getCar_cd		(){		return car_cd;		}
	public String getCar_u_seq	(){		return car_u_seq;	}
	public String getCar_c_seq	(){		return car_c_seq;	}
	public String getUse_yn		(){		return use_yn;		}
	public String getCar_c		(){		return car_c;		}
	public int    getCar_c_p	(){		return car_c_p;		}
	public String getCar_c_dt	(){		return car_c_dt;	}
	public String getEtc		(){		return etc;			}
	public String getCol_st		(){		return col_st;		}
	public String getJg_opt_st	(){		return jg_opt_st;	}

}
