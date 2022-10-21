/**
 * �ڵ���������
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_office;

import java.util.*;

public class CarOffEdhBean {
    //Table : CAR_OFF_EDH
    private String emp_id;				//����������̵�
    private String seq;					//����
    private String damdang_id;			//����ھ��̵�
    private String cng_dt;				//����������
    private String cng_rsn;				//�����������
    private String reg_id;				//�����
    private String reg_dt;				//�����
        
    // CONSTRCTOR            
    public CarOffEdhBean() {  
    	this.emp_id = "";
	    this.seq = "";
	    this.damdang_id = "";
	    this.cng_dt = "";
	    this.cng_rsn = "";
	    this.reg_id = "";
	    this.reg_dt = "";
	}

	// get Method
	public void setEmp_id(String val){		if(val==null) val="";		this.emp_id = val;	}
	public void setSeq(String val){			if(val==null) val="";		this.seq = val;	}
	public void setDamdang_id(String val){	if(val==null) val="";		this.damdang_id = val;	}
	public void setCng_dt(String val){		if(val==null) val="";		this.cng_dt = val;	}
	public void setCng_rsn(String val){		if(val==null) val="";		this.cng_rsn = val;	}
	public void setReg_id(String val){		if(val==null) val="";		this.reg_id = val;	}
	public void setReg_dt(String val){		if(val==null) val="";		this.reg_dt = val;	}
		
	//Get Method
	public String getEmp_id(){		return emp_id;	}
	public String getSeq(){			return seq;	}
	public String getDamdang_id(){	return damdang_id;	}
	public String getCng_dt(){		return cng_dt;	}
	public String getCng_rsn(){		return cng_rsn;	}
	public String getReg_id(){		return reg_id;	}
	public String getReg_dt(){		return reg_dt;	}

}