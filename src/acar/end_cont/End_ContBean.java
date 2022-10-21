/**
 * 계약만기 진행 담당자 
 * @ author : Gill Sun	Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2009. 10. 27
 * @ last modify date : 
 */
package acar.end_cont;

import java.util.*;

public class End_ContBean {
    //Table : end_cont
	private String rent_mng_id;
	private String rent_l_cd;
    private String reg_id;
    private String reg_dt;
	private String re_bus_id;
    private String content;	
    private int seq;

		
	
    // CONSTRCTOR            
    public End_ContBean() {  
	this.rent_mng_id = "";	
	this.rent_l_cd = "";
	this.reg_id = "";
	this.reg_dt = "";
	this.re_bus_id ="";
	this.content = "";		
	this.seq = 0;

	}

	// set Method
	public void setRent_mng_id(String val){
		if(val==null) val="";
		this.rent_mng_id = val;
	}
	public void setRent_l_cd(String val){
		if(val==null) val="";
		this.rent_l_cd = val;
	}
	public void setReg_id(String val){
		if(val==null) val="";
		this.reg_id = val;
	}
	public void setReg_dt(String val){
		if(val==null) val="";
		this.reg_dt = val;
	}
	public void setRe_bus_id(String val){
		if(val==null) val="";
		this.re_bus_id = val;
	}

	public void setContent(String val){
		if(val==null) val="";
		this.content = val;
	}
	public void setSeq(int val){
		this.seq = val;
	}
	
	//Get Method

	public String getRent_mng_id()  {		return rent_mng_id; }
	public String getRent_l_cd()    {		return rent_l_cd; }
	public String getReg_id()    {		return reg_id;	}
	public String getReg_dt()    {		return reg_dt;	}
	public String getRe_bus_id() {		return re_bus_id;	}
	public String getContent()   {		return content;	}
	public int    getSeq()	     {		return seq;		}
	
}