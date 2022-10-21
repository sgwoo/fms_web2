/**
 * 제조사DC관리
 */
package acar.car_mst;

import java.util.*;

public class CarDcBean {
    //Table : CAR_DC
	private String car_comp_id;		//자동차사코드
    private String car_cd;			//차종분류코드
    private String car_d_seq;		//제조사DC 관리번호
    private String car_u_seq;		//차명업데이트관리번호
	private String car_d_dt;		//제조사DC 기준일
	private int    car_d_p;			//제조사DC 가격
	private float  car_d_per;		//제조사DC율
	private int    car_d_p2;		//제조사DC 가격
	private float  car_d_per2;		//제조사DC율
	private String ls_yn;			//제조사DC 리스상이
	private String car_d;			//제조사DC 구분명
	private String car_d_per_b;		//제조사DC율 반영차가 구분
	private String car_d_per_b2;	//제조사DC율 반영차가 구분
    private String car_comp_nm;		//자동차회사이름
	private String car_nm;
	private String car_d_dt2;		//제조사DC 완료일
	private String car_d_etc;		//제조사DC 비고(추가, 2018.01.22)
	private String esti_d_etc;		//견적서 제조사DC 추가문구(추가, 2020.05.07)
	private String hp_flag;         //홈페이지 견적 미적용 여부

       
    // CONSTRCTOR            
    public CarDcBean() { 
		this.car_comp_id	= ""; 
    	this.car_cd			= "";					
	    this.car_d_seq		= "";
		this.car_u_seq		= "";			
	    this.car_d_dt		= "";
		this.car_d_p		= 0;
		this.car_d_per		= 0;
		this.car_d_p2		= 0;
		this.car_d_per2		= 0;
		this.ls_yn			= "";
		this.car_d			= "";
		this.car_d_per_b	= "";
		this.car_d_per_b2	= "";
		this.car_comp_nm	 = "";					//자동차회사이름
		this.car_nm			= "";
		this.car_d_dt2		= "";
		this.car_d_etc		= "";					//제조사DC 비고(추가, 2018.01.22)
		this.esti_d_etc		= "";				//견적서 제조사DC 추가문구(추가, 2020.05.07)
		this.hp_flag        = "";
	}

	// get Method
	public void setCar_comp_id		(String val){	if(val==null) val="";	this.car_comp_id	= val;	}
	public void setCar_cd			(String val){	if(val==null) val="";	this.car_cd			= val;	}
	public void setCar_u_seq		(String val){	if(val==null) val="";	this.car_u_seq		= val;	}
	public void setCar_d_seq		(String val){	if(val==null) val="";	this.car_d_seq		= val;	}
	public void setCar_d_dt			(String val){	if(val==null) val="";	this.car_d_dt		= val;	}
	public void setCar_d_p			(int i){								this.car_d_p		= i;	}
	public void setCar_d_per		(float val){							this.car_d_per		= val;	}
	public void setCar_d_p2			(int i){								this.car_d_p2		= i;	}
	public void setCar_d_per2		(float val){							this.car_d_per2		= val;	}
	public void setLs_yn			(String val){	if(val==null) val="";	this.ls_yn			= val;	}
	public void setCar_d			(String val){	if(val==null) val="";	this.car_d			= val;	}
	public void setCar_d_per_b		(String val){	if(val==null) val="";	this.car_d_per_b	= val;	}
	public void setCar_d_per_b2		(String val){	if(val==null) val="";	this.car_d_per_b2	= val;	}
	public void setCar_comp_nm		(String val){	if(val==null) val="";	this.car_comp_nm	= val;	}
	public void setCar_nm			(String val){	if(val==null) val="";	this.car_nm			= val;	}
	public void setCar_d_dt2		(String val){	if(val==null) val="";	this.car_d_dt2		= val;	}
	public void setCar_d_etc		(String val){	if(val==null) val="";	this.car_d_etc		= val;	}
	public void setEsti_d_etc		(String val){	if(val==null) val="";	this.esti_d_etc		= val;	}
	public void setHp_flag          (String val){   if(val==null) val="";   this.hp_flag        = val;  }

		
	//Get Method
	public String getCar_comp_id	()			{	return car_comp_id;		}
	public String getCar_cd			()			{	return car_cd;			}
	public String getCar_u_seq		()			{	return car_u_seq;		}
	public String getCar_d_seq		()			{	return car_d_seq;		}
	public String getCar_d_dt		()			{	return car_d_dt;		}
	public int    getCar_d_p		()			{	return car_d_p;			}
	public float  getCar_d_per		()			{	return car_d_per;		}
	public int    getCar_d_p2		()			{	return car_d_p2;		}
	public float  getCar_d_per2		()			{	return car_d_per2;		}
	public String getLs_yn			()			{	return ls_yn;			}
	public String getCar_d			()			{	return car_d;			}
	public String getCar_d_per_b	()			{	return car_d_per_b;		}
	public String getCar_d_per_b2	()			{	return car_d_per_b2;	}
	public String getCar_comp_nm	()			{	return car_comp_nm;		}
	public String getCar_nm			()			{	return car_nm;			}
	public String getCar_d_dt2		()			{	return car_d_dt2;		}
	public String getCar_d_etc		()			{	return car_d_etc;		}
	public String getEsti_d_etc		()			{	return esti_d_etc;		}
	public String getHp_flag        ()          {   return hp_flag;         }

}
