/**
 * 차종
 */
package acar.car_mst;

import java.util.*;

public class CarSelBean {
    //Table : CAR_SEL
  private String car_comp_id;   //자동차사코드
    private String car_cd;			//차종분류코드
    private String car_u_seq;		//차명업데이트관리번호
    private String car_s_seq;		//선택사양관리번호
	private String use_yn;			//사용여부
	private String car_s;			//선택사양 옵션명
	private int car_s_p;			//선택사양 가격
	private String car_s_dt;		//선택사양 기준일
       
    // CONSTRCTOR            
    public CarSelBean() { 
      this.car_comp_id = ""; 
    	this.car_cd = "";					
	    this.car_u_seq = "";				
	    this.car_s_seq = "";
	    this.use_yn = "";
	    this.car_s = "";
		this.car_s_p = 0;
	    this.car_s_dt = "";
	}

	// get Method
	public void setCar_comp_id(String val){		if(val==null) val="";	this.car_comp_id = val;		}
	public void setCar_cd(String val){		if(val==null) val="";	this.car_cd = val;		}
	public void setCar_u_seq(String val){	if(val==null) val="";	this.car_u_seq = val;	}
	public void setCar_s_seq(String val){	if(val==null) val="";	this.car_s_seq = val;	}
	public void setUse_yn(String val){		if(val==null) val="";	this.use_yn = val;		}
	public void setCar_s(String val){		if(val==null) val="";	this.car_s = val;		}
	public void setCar_s_p(int i){									this.car_s_p = i;		}
	public void setCar_s_dt(String val){	if(val==null) val="";	this.car_s_dt = val;	}
		
	//Get Method
	public String getCar_comp_id(){		return car_comp_id;		}
	public String getCar_cd(){		return car_cd;		}
	public String getCar_u_seq(){	return car_u_seq;	}
	public String getCar_s_seq(){	return car_s_seq;	}
	public String getUse_yn(){		return use_yn;		}
	public String getCar_s(){		return car_s;		}
	public int getCar_s_p(){		return car_s_p;		}
	public String getCar_s_dt(){	return car_s_dt;	}
}
