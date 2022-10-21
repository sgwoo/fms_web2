/**
 * 세금계산서
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.bill_mng;

import java.util.*;

public class BillMngBean {
    //Table : CONT, CAR_REG, CLIENT, FEE, USERS, CAR_PUR, CAR_ETC, CAR_NM, ALLOT, CODE

    private String tax_kd;
    private String brch_id;//
    private String car_no;//
    private String ven_code;//
    private String client_st;//
    private String tax_kd_nm;
    private String rent_mng_id;
    private String rent_l_cd;
    private String rent_st;
    private String client_id;
    private String bus_cdt;
    private String bus_itm;
    private String enp_no;
    private String client_nm;
    private String firm_nm;
    private String fee_est_dt;
    private String reg_dt;
    private String fee_tm;
    private String tm_st1;
    private String fee_s_amt;
    private String fee_v_amt;
    private String fee_t_amt;
    private String tax_gubun;
	private String fee_bank;
	private String site_id;

    // CONSTRCTOR            
    public BillMngBean() {  
    	this.tax_kd = "";
    	this.tax_kd_nm = "";
    	this.brch_id = "";//
	    this.car_no = "";//
	    this.ven_code = "";//
	    this.client_st = "";//
    	this.rent_mng_id = "";					//계약관리ID
	    this.rent_l_cd = "";					//계약코드
	    this.rent_st = "";
	    this.client_id = "";					//고객ID
	    this.bus_cdt = "";
	    this.bus_itm = "";
	    this.enp_no = "";
	    this.client_nm = "";
	    this.firm_nm = "";
	    this.fee_est_dt = "";
	    this.reg_dt = "";
	    this.fee_tm = "";
	    this.tm_st1 = "";
	    this.fee_s_amt = "";
	    this.fee_v_amt = "";
	    this.fee_t_amt = "";
    	this.tax_gubun = "";
		this.fee_bank = "";
		this.site_id = "";
	}

	// get Method
	public void setTax_kd(String val){
		if(val==null) val="";
		this.tax_kd = val;
	}
	public void setRent_mng_id(String val){
		if(val==null) val="";
		this.rent_mng_id = val;
	}
	public void setBrch_id(String val){
		if(val==null) val="";
		this.brch_id = val;
	}
	public void setCar_no(String val){
		if(val==null) val="";
		this.car_no = val;
	}
	public void setVen_code(String val){
		if(val==null) val="";
		this.ven_code = val;
	}
	public void setClient_st(String val){
		if(val==null) val="";
		this.client_st = val;
	}
    public void setRent_l_cd(String val){
		if(val==null) val="";
		this.rent_l_cd = val;
	}
	public void setRent_st(String val){
		if(val==null) val="";
		this.rent_st = val;
	}
	public void setClient_id(String val){
		if(val==null) val="";
		this.client_id = val;
	}
    public void setBus_cdt(String val){
		if(val==null) val="";
		this.bus_cdt = val;
	}
    public void setBus_itm(String val){
		if(val==null) val="";
		this.bus_itm = val;
	}
    public void setEnp_no(String val){
		if(val==null) val="";
		this.enp_no = val;
	}
    public void setClient_nm(String val){
		if(val==null) val="";
		this.client_nm = val;
	}
    public void setFirm_nm(String val){
		if(val==null) val="";
		this.firm_nm = val;
	}
    public void setFee_est_dt(String val){
		if(val==null) val="";
		this.fee_est_dt = val;
	}
	public void setReg_dt(String val){
		if(val==null) val="";
		this.reg_dt = val;
	}
    public void setFee_tm(String val){
		if(val==null) val="";
		this.fee_tm = val;
	}
    public void setTm_st1(String val){
		if(val==null) val="";
		this.tm_st1 = val;
	}
    public void setFee_s_amt(String val){
		if(val==null) val="";
		this.fee_s_amt = val;
	}
    public void setFee_v_amt(String val){
		if(val==null) val="";
		this.fee_v_amt = val;
	}
	public void setFee_t_amt(String val){
		if(val==null) val="";
		this.fee_t_amt = val;
	}
	public void setTax_gubun(String val){
		if(val==null) val="";
		this.tax_gubun = val;
	}
	public void setFee_bank(String val){
		if(val==null) val="";
		this.fee_bank = val;
	}
	public void setSite_id(String val){
		if(val==null) val="";
		this.site_id = val;
	}
		
	//Get Method
	public String getTax_kd(){
		return tax_kd;
	}
	public String getTax_kd_nm(){
		if(tax_kd.equals("1"))
		{
			tax_kd_nm = "대여료";
		}
		return tax_kd_nm;
	}
	public String getBrch_id(){
		return brch_id;
	}
	public String getCar_no(){
		return car_no;
	}
	public String getVen_code(){
		return ven_code;
	}
	public String getClient_st(){
		return client_st;
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
	public String getClient_id(){
		return client_id;
	}
    public String getBus_cdt(){
		return bus_cdt;
	}
    public String getBus_itm(){
		return bus_itm;
	}
    public String getEnp_no(){
		return enp_no;
	}
    public String getClient_nm(){
		return client_nm;
	}
    public String getFirm_nm(){
		return firm_nm;
	}
    public String getFee_est_dt(){
		return fee_est_dt;
	}
	public String getReg_dt(){
		return reg_dt;
	}
    public String getFee_tm(){
		return fee_tm;
	}
    public String getTm_st1(){
		return tm_st1;
	}
    public String getFee_s_amt(){
		return fee_s_amt;
	}
    public String getFee_v_amt(){
		return fee_v_amt;
	}
	public String getFee_t_amt(){
		return fee_t_amt;
	}
	public String getTax_gubun(){
		return tax_gubun;
	}
	public String getFee_bank(){
		return fee_bank;
	}
	public String getSite_id(){
		return site_id;
	}
}