/**
 * �ڵ����ٹ�ó �̷°���
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 20040824
 * @ last modify date : 
 */
package acar.car_office;

import java.util.*;

public class CarOffCngBean {
    //Table : CAR_OFF_CNG
    private String emp_id;				//�������ID
    private int seq;					//����
    private String car_off_id;			//������id
    private String emp_pos;				//�����ҿ� ������ ����
        
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