/**
 * ����
 */
package acar.car_mst;

import java.util.*;

public class CarTrimBean {
    //Table : CAR_COL
	private String car_comp_id;		//�ڵ���ȸ���ڵ�
    private String car_cd;			//�����з��ڵ�
    private String car_id;			//Ʈ���з��ڵ�
    private String car_u_seq;		//���������Ʈ������ȣ
    private String car_c_seq;		//���� ������ȣ
       
    // CONSTRCTOR            
    public CarTrimBean() { 
		this.car_comp_id	= ""; 
    	this.car_cd			= "";	
    	this.car_id			= "";					
	    this.car_u_seq		= "";				
	    this.car_c_seq		= "";
	}

	// get Method
	public void setCar_comp_id	(String val){	if(val==null) val="";	this.car_comp_id	= val;	}
	public void setCar_cd		(String val){	if(val==null) val="";	this.car_cd			= val;	}
	public void setCar_id		(String val){	if(val==null) val="";	this.car_id			= val;	}
	public void setCar_u_seq	(String val){	if(val==null) val="";	this.car_u_seq		= val;	}
	public void setCar_c_seq	(String val){	if(val==null) val="";	this.car_c_seq		= val;	}
		
	//Get Method
	public String getCar_comp_id(){		return car_comp_id;	}
	public String getCar_cd		(){		return car_cd;		}
	public String getCar_id		(){		return car_id;		}
	public String getCar_u_seq	(){		return car_u_seq;	}
	public String getCar_c_seq	(){		return car_c_seq;	}

}
