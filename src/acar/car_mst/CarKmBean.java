/**
 * 제조사DC관리
 */
package acar.car_mst;

import java.util.*;

public class CarKmBean {
    //Table : CAR_KM
	private String car_comp_id;	//제조사코드
    private String car_cd;			//차종분류코드
    private String car_k_seq;		//차명업데이트관리번호
    private String car_k_dt;		//차량연비 일련번호
	private String car_k;			//복합연비
	private String engine;			//엔진
	private String car_k_etc;		//비고
	private String use_yn;		//비고

       
    // CONSTRCTOR            
    public CarKmBean() { 
		this.car_comp_id	= ""; 
    	this.car_cd			= "";					
	    this.car_k_seq		= "";
		this.car_k_dt		= "";			
	    this.car_k			= "";
		this.engine			= "";
		this.car_k_etc		= "";
		this.use_yn			= "";
		
	}

	// get Method
	public void setCar_comp_id		(String val){	if(val==null) val="";	this.car_comp_id	= val;	}
	public void setCar_cd			(String val){	if(val==null) val="";	this.car_cd			= val;	}
	public void setCar_k_seq		(String val){	if(val==null) val="";	this.car_k_seq		= val;	}
	public void setCar_k_dt			(String val){	if(val==null) val="";	this.car_k_dt		= val;	}
	public void setCar_k		(String val){	if(val==null) val="";	this.car_k		= val;}
	public void setEngine			(String val){	if(val==null) val="";	this.engine			= val;	}
	public void setCar_k_etc		(String val){	if(val==null) val="";	this.car_k_etc	= val;	}
	public void setUse_yn			(String val){	if(val==null) val="";	this.use_yn			= val;	}

		
	//Get Method
	public String getCar_comp_id	()			{	return car_comp_id;		}
	public String getCar_cd			()			{	return car_cd;			}
	public String getCar_k_seq		()			{	return car_k_seq;		}
	public String getCar_k_dt		()			{	return car_k_dt;		}
	public String getCar_k		()			{	return car_k;		}
	public String getEngine		()			{	return engine;		}
	public String getCar_k_etc			()			{	return car_k_etc;			}
	public String getUse_yn			()			{	return use_yn;			}

}
