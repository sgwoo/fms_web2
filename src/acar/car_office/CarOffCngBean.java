/**
 * 자동차근무처 이력관리
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 20040824
 * @ last modify date : 
 */
package acar.car_office;

import java.util.*;

public class CarOffCngBean {
    //Table : CAR_OFF_CNG
    private String emp_id;				//영업사원ID
    private int seq;					//순번
    private String car_off_id;			//영업소id
    private String emp_pos;				//영업소에 있을때 직위
        
    // CONSTRCTOR            
    public CarOffCngBean() {  
    	this.emp_id = "";
	    this.seq = 0;
	    this.car_off_id = "";
	    this.emp_pos = "";
	}

	// get Method
	public void setEmp_id(String val){		if(val==null) val="";		this.emp_id = val;	}
	public void setSeq(int val){										this.seq = val;	}
	public void setCar_off_id(String val){	if(val==null) val="";		this.car_off_id = val;	}
	public void setEmp_pos(String val){		if(val==null) val="";		this.emp_pos = val;	}
		
	//Get Method
	public String getEmp_id(){		return emp_id;	}
	public int getSeq(){			return seq;	}
	public String getCar_off_id(){	return car_off_id;	}
	public String getEmp_pos(){		return emp_pos;	}
}