/**
 * SearchList 조회
 */
package acar.search;

import java.util.*;

public class SearchListBean {
    //Table : CONT, CAR_REG, CLIENT, FEE, USERS, ALLOT
    private String rent_mng_id;			//계약관리ID
    private String rent_l_cd;			//계약코드
    private String rent_dt;				//계약일자
    private String bus_nm;				//영업담당자 이름
    private String mng_nm;				//관리담당자 이
    private String car_no;				//차량번호
    private String car_nm;				//차명
    private String car_mng_id;			//자동차관리ID
    private String firm_nm;				//상호
	private String client_nm;			//고객 대표자명
	private int fee_s_amt;				//대여료 공급가
	private int fee_v_amt;				//대여료 부가세
	private String rent_start_dt;		//대여개시일
        
    //CONSTRCTOR            
    public SearchListBean() {  
    	this.rent_mng_id = "";					
	    this.rent_l_cd = "";					
	    this.rent_dt = "";					
		this.bus_nm = "";					
		this.mng_nm = "";					
	    this.car_no = "";						
	    this.car_nm = "";					
	    this.car_mng_id = "";					
	    this.firm_nm = "";						
		this.client_nm = "";				
		this.fee_s_amt = 0;
		this.fee_v_amt = 0;
	    this.rent_start_dt = "";				
	}

	// get Method
	public void setRent_mng_id(String val){
		if(val==null) val="";
		this.rent_mng_id = val;
	}
    public void setRent_l_cd(String val){
		if(val==null) val="";
		this.rent_l_cd = val;
	}
	public void setRent_dt(String val){
		if(val==null) val="";
		this.rent_dt = val;
	}
	public void setBus_nm(String val){
		if(val==null) val="";
		this.bus_nm = val;
	}
	public void setMng_nm(String val){
		if(val==null) val="";
		this.mng_nm = val;
	}
    public void setClient_nm(String val){
		if(val==null) val="";
		this.client_nm = val;
	}
    public void setFirm_nm(String val){
		if(val==null) val="";
		this.firm_nm = val;
	}
    public void setCar_mng_id(String val){
		if(val==null) val="";
		this.car_mng_id = val;
	}
    public void setCar_no(String val){
		if(val==null) val="";
		this.car_no = val;
	}
    public void setCar_nm(String val){
		if(val==null) val="";
		this.car_nm = val;
	}
    public void setRent_start_dt(String val){
		if(val==null) val="";
		this.rent_start_dt = val;
	}
	public void setFee_s_amt(int val)
	{
		this.fee_s_amt = val;
	}
	public void setFee_v_amt(int val)
	{
		this.fee_v_amt = val;
	}
		
	//Get Method
	public String getRent_mng_id(){
		return rent_mng_id;
	}
    public String getRent_l_cd(){
		return rent_l_cd;
	}
	public String getRent_dt(){
		return rent_dt;
	}
	public String getBus_nm(){
		return bus_nm;
	}
	public String getMng_nm(){
		return mng_nm;
	}
    public String getClient_nm(){
		return client_nm;
	}
    public String getFirm_nm(){
		return firm_nm;
	}
    public String getCar_mng_id(){
		return car_mng_id;
	}
    public String getCar_no(){
		return car_no;
	}
    public String getCar_nm(){
		return car_nm;
	}
    public String getRent_start_dt(){
		return rent_start_dt;
	}
	public int getFee_s_amt()
	{
		return fee_s_amt;
	}
	public int getFee_v_amt()
	{
		return fee_v_amt;
	}

}