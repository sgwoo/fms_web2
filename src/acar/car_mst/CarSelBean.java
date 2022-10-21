/**
 * ����
 */
package acar.car_mst;

import java.util.*;

public class CarSelBean {
    //Table : CAR_SEL
  private String car_comp_id;   //�ڵ������ڵ�
    private String car_cd;			//�����з��ڵ�
    private String car_u_seq;		//���������Ʈ������ȣ
    private String car_s_seq;		//���û�������ȣ
	private String use_yn;			//��뿩��
	private String car_s;			//���û�� �ɼǸ�
	private int car_s_p;			//���û�� ����
	private String car_s_dt;		//���û�� ������
       
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
