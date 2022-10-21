/**
 * 세금계산서
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.bill_mng;

import java.util.*;

public class TaxBean {
    //Table : CONT, CAR_REG, CLIENT, FEE, USERS, CAR_PUR, CAR_ETC, CAR_NM, ALLOT, CODE

    private String tax_id;
    private String car_no;
    private String ven_code;
    private String firm_nm;
    private String enp_no;
    private String client_st;
    private String brch_id;
    private String rent_mng_id;
    private String rent_l_cd;
    private String rent_st;
    private String tm_st1;
    private String fee_tm;
    private String exch_id;
    private String item_st;
    private String reg_dt;
    private String iss_dt;
    private int sup_amt;
    private int add_amt;
    private int tot_amt;
        
    // CONSTRCTOR            
    public TaxBean() {  
    	this.tax_id = "";
    	this.car_no = "";
	    this.ven_code = "";
	    this.firm_nm = "";
	    this.enp_no = "";
	    this.client_st = "";
	    this.brch_id = "";
    	this.rent_mng_id = "";					//계약관리ID
	    this.rent_l_cd = "";					//계약코드
	    this.rent_st = "";
	    this.tm_st1 = "";
	    this.fee_tm = "";
	    this.exch_id = "";
	    this.item_st = "";
	    this.reg_dt = "";
	    this.iss_dt = "";
	    this.sup_amt = 0;
	    this.add_amt = 0;
	    this.tot_amt = 0;
	}

	// get Method
	public void setTax_id(String val){
		if(val==null) val="";
		this.tax_id = val;
	}
	public void setCar_no(String val){
		if(val==null) val="";
		this.car_no = val;
	}
	public void setVen_code(String val){
		if(val==null) val="";
		this.ven_code = val;
	}
	public void setFirm_nm(String val){
		if(val==null) val="";
		this.firm_nm = val;
	}
	public void setEnp_no(String val){
		if(val==null) val="";
		this.enp_no = val;
	}
	public void setClient_st(String val){
		if(val==null) val="";
		this.client_st = val;
	}
	public void setBrch_id(String val){
		if(val==null) val="";
		this.brch_id = val;
	}
	public void setRent_mng_id(String val){
		if(val==null) val="";
		this.rent_mng_id = val;
	}
    public void setRent_l_cd(String val){
		if(val==null) val="";
		this.rent_l_cd = val;
	}
	public void setRent_st(String val){
		if(val==null) val="";
		this.rent_st = val;
	}
	public void setTm_st1(String val){
		if(val==null) val="";
		this.tm_st1 = val;
	}
   	public void setFee_tm(String val){
		if(val==null) val="";
		this.fee_tm = val;
	}
    public void setExch_id(String val){
		if(val==null) val="";
		this.exch_id = val;
	}
    public void setItem_st(String val){
		if(val==null) val="";
		this.item_st = val;
	}
    public void setReg_dt(String val){
		if(val==null) val="";
		this.reg_dt = val;
	}
    public void setIss_dt(String val){
		if(val==null) val="";
		this.iss_dt = val;
	}
    public void setSup_amt(int val){
		this.sup_amt = val;
	}
    public void setAdd_amt(int val){
		this.add_amt = val;
	}
    public void setTot_amt(int val){
		this.tot_amt = val;
	}
	
	//Get Method
	public String getTax_id(){
		return tax_id;
	}
	public String getCar_no(){
		return car_no;
	}
	public String getVen_code(){
		return ven_code;
	}
	public String getFirm_nm(){
		return firm_nm;
	}
	public String getEnp_no(){
		return enp_no;
	}
	public String getClient_st(){
		return client_st;
	}
	public String getBrch_id(){
		return brch_id;
	}
	public String getRent_mng_id(){
		return rent_mng_id;
	}
    public String getRent_l_cd(){
		return rent_l_cd;
	}
	public String getRent_st(){
		return rent_st;
	}
	public String getTm_st1(){
		return tm_st1;
	}
    public String getFee_tm(){
		return fee_tm;
	}
    public String getExch_id(){
		return exch_id;
	}
    public String getItem_st(){
		return item_st;
	}
    public String getReg_dt(){
		return reg_dt;
	}
    public String getIss_dt(){
		return iss_dt;
	}
    public int getSup_amt(){
		return sup_amt;
	}
    public int getAdd_amt(){
		return add_amt;
	}
    public int getTot_amt(){
		return tot_amt;
	}
}