/**
 * ������DC����
 */
package acar.car_mst;

import java.util.*;

public class CarKmBean {
    //Table : CAR_KM
	private String car_comp_id;	//�������ڵ�
    private String car_cd;			//�����з��ڵ�
    private String car_k_seq;		//���������Ʈ������ȣ
    private String car_k_dt;		//�������� �Ϸù�ȣ
	private String car_k;			//���տ���
	private String engine;			//����
	private String car_k_etc;		//���
	private String use_yn;		//���

       
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
