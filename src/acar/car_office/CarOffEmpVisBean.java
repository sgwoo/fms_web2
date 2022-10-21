/**
 * 지급수수료
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_office;

import java.util.*;

public class CarOffEmpVisBean {
    //Table : COMMI
   
	private String emp_id;						//영업사원ID
	private int seq_no;
	private String vis_nm;
	private String vis_dt;
	private String sub;
	private String vis_cont;
        
    // CONSTRCTOR            
    public CarOffEmpVisBean() {  
		this.emp_id = "";						//영업사원ID
	    this.seq_no = 0;
		this.vis_nm = "";
		this.vis_dt = "";
		this.sub = "";
		this.vis_cont = "";
	}

	// get Method
	public void setEmp_id(String val){
		if(val==null) val="";
		this.emp_id = val;
	}
	public void setSeq_no(int val){
		this.seq_no = val;
	}
	public void setVis_nm(String val){
		if(val==null) val="";
		this.vis_nm = val;
	}
	public void setVis_dt(String val){
		if(val==null) val="";
		this.vis_dt = val;
	}
	public void setSub(String val){
		if(val==null) val="";
		this.sub = val;
	}
	public void setVis_cont(String val){
		if(val==null) val="";
		this.vis_cont = val;
	}
		
	//Get Method
	public String getEmp_id(){
		return emp_id;
	}
	public int getSeq_no(){
		return seq_no;
	}
	public String getVis_nm(){
		return vis_nm;
	}
	public String getVis_dt(){
		return vis_dt;
	}
	public String getSub(){
		return sub;
	}
	public String getVis_cont(){
		return vis_cont;
	}
	
}