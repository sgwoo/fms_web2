/**
 * 지점별 계약통계
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.condition;

import java.util.*;

public class BranchCondBean {
    //Table : CONT, CAR_REG, CLIENT, FEE, USERS, CAR_PUR, CAR_ETC, CAR_NM, ALLOT, CODE
   
    private String br_id;						//지점코드
    private String br_nm;
    private int cont_cnt;
    private int rent_way_s;
    private int rent_way_m;
	private int rent_way_b;
    private int con_mon_12;
    private int con_mon_24;
    private int con_mon_36;
    private int con_mon_48;
    private int con_mon_etc;
    private int un_dlv_cnt;
    private int dlv_cnt;
    private int un_reg_cnt;
    private int reg_cnt;
    
    // CONSTRCTOR            
    public BranchCondBean() {  
    	
	    this.br_id = "";						//지점코드
	    this.br_nm = "";
	    this.cont_cnt = 0;
	    this.rent_way_s = 0;
	    this.rent_way_m = 0;
	    this.rent_way_b = 0;
	    this.con_mon_12 = 0;
	    this.con_mon_24 = 0;
	    this.con_mon_36 = 0;
	    this.con_mon_48 = 0;
	    this.con_mon_etc = 0;
	    this.un_dlv_cnt = 0;
	    this.dlv_cnt = 0;
	    this.un_reg_cnt = 0;
	    this.reg_cnt = 0;
	}

	// get Method
	
	public void setBr_id(String val){
		if(val==null) val="";
		this.br_id = val;
	}
	public void setBr_nm(String val){
		if(val==null) val="";
		this.br_nm = val;
	}
    public void setCont_cnt(int val){
		this.cont_cnt = val;
	}
	public void setRent_way_s(int val){
		this.rent_way_s = val;
	}
	public void setRent_way_m(int val){
		this.rent_way_m = val;
	}
	public void setRent_way_b(int val){
		this.rent_way_b = val;
	}
	public void setCon_mon_12(int val){
		this.con_mon_12 = val;
	}
	public void setCon_mon_24(int val){
		this.con_mon_24 = val;
	}
	public void setCon_mon_36(int val){
		this.con_mon_36 = val;
	}
	public void setCon_mon_48(int val){
		this.con_mon_48 = val;
	}
	public void setCon_mon_etc(int val){
		this.con_mon_etc = val;
	}
	public void setUn_dlv_cnt(int val){
		this.un_dlv_cnt = val;
	}
	public void setDlv_cnt(int val){
		this.dlv_cnt = val;
	}
	public void setUn_reg_cnt(int val){
		this.un_reg_cnt = val;
	}
	public void setReg_cnt(int val){
		this.reg_cnt = val;
	}
		
	//Get Method
	
	public String getBr_id(){
		return br_id;
	}
	public String getBr_nm(){
		return br_nm;
	}
    public int getCont_cnt(){
		return cont_cnt;
	}
	public int getRent_way_s(){
		return rent_way_s;
	}
	public int getRent_way_m(){
		return rent_way_m;
	}
	public int getRent_way_b(){
		return rent_way_b;
	}
	public int getCon_mon_12(){
		return con_mon_12;
	}
	public int getCon_mon_24(){
		return con_mon_24;
	}
	public int getCon_mon_36(){
		return con_mon_36;
	}
	public int getCon_mon_48(){
		return con_mon_48;
	}
	public int getCon_mon_etc(){
		return con_mon_etc;
	}
	public int getUn_dlv_cnt(){
		return un_dlv_cnt;
	}
	public int getDlv_cnt(){
		return dlv_cnt;
	}
	public int getUn_reg_cnt(){
		return un_reg_cnt;
	}
	public int getReg_cnt(){
		return reg_cnt;
	}
}