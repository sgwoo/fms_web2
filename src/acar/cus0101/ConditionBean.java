/**
 * 계약사항에 대한 세부사항 조회
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.cus0101;

import java.util.*;

public class ConditionBean {
    //Table : CONT, CAR_REG, CLIENT, FEE, USERS, CAR_PUR, CAR_ETC, CAR_NM, ALLOT, CODE
    private String rent_mng_id;					//계약관리ID
    private String rent_l_cd;					//계약코드
    private String rent_dt;					//계약일자
    private String dlv_dt;					//출고일자
    private String dlv_est_dt;				//출고예정일
    private String bus_id;					//영업담당자 ID
    private String bus_nm;					//영업담당자 이름
    private String mng_id;					//관리담당자 ID
    private String mng_nm;					//관리담당자 이
    private String client_id;					//고객ID
    private String client_nm;					//고객 대표자명
    private String firm_nm;						//상호
    private String o_tel;						//사무실전화번호
    private String m_tel;						//휴대폰
    private String fax;							//팩스
    private String br_id;						//지점코드
    private String fn_id;						//검색항목
    private String car_mng_id;					//자동차관리ID
    private String init_reg_dt;					//최초등록일
    private String reg_gubun;					//등록구분
    private String car_no;						//차량번호
    private String car_num;						//차대번호
    private String r_st;
    private String rent_way;					//대여방식 코드
    private String rent_way_nm;					//대여방식 이름
    private String con_mon;						//대여개월
    private String car_id;						//차명ID
    private int imm_amt;						//자차면책금
    private String car_name;					//차명
    private String rent_start_dt;				//대여개시일
    private String rent_end_dt;					//대여종료일
    private String reg_ext_dt;					//등록예정일
    private String rpt_no;						//계출번호
    private String cpt_cd;						//은행코드
    private String bank_nm;						//은행명
    private String in_emp_id;
    private String in_emp_nm;
    private String in_car_off_id;
    private String in_car_off_nm;
    private String in_car_off_tel;
    private String out_emp_id;
    private String out_emp_nm;
    private String out_car_off_id;
    private String out_car_off_nm;
    private String out_car_off_tel;
	private String cls_dt;						//해지일

    // CONSTRCTOR            
    public ConditionBean() {  
    	this.rent_mng_id = "";					//계약관리ID
	    this.rent_l_cd = "";					//계약코드
	    this.rent_dt = "";					//계약일자
	    this.dlv_dt = "";					//출고일자
	    this.dlv_est_dt = "";
	    this.bus_id = "";					//영업담당자 ID  
		this.bus_nm = "";					//영업담당자 이름
		this.mng_id = "";					//관리담당자 ID  
		this.mng_nm = "";					//관리담당자 이름
	    this.client_id = "";					//고객ID
	    this.client_nm = "";					//고객 대표자명
	    this.firm_nm = "";						//상호
	    this.o_tel = "";
	    this.m_tel = "";
	    this.fax = "";
	    this.br_id = "";						//지점코드
	    this.fn_id = "";						//검색
	    this.car_mng_id = "";					//자동차관리ID
	    this.init_reg_dt = "";					//최초등록일
	    this.reg_gubun = "";					//등록구분
	    this.car_no = "";						//차량번호
	    this.car_num = "";						//차대번호
	    this.r_st = "";
	    this.rent_way = "";					//대여방식
	    this.rent_way_nm = "";					//대여방식
	    this.con_mon = "";						//대여개월
	    this.car_id = "";						//차명ID
	    this.imm_amt = 0;
	    this.car_name = "";					//차명
	    this.rent_start_dt = "";				//대여개시일
	    this.rent_end_dt = "";					//대여종료일
	    this.reg_ext_dt = "";					//등록예정일
	    this.rpt_no = "";					//계출번호
	    this.cpt_cd = "";						//은행코드
	    this.bank_nm = "";						//은행명
	    this.in_emp_id = "";
	    this.in_emp_nm = "";
	    this.in_car_off_id = "";
	    this.in_car_off_nm = "";
	    this.in_car_off_tel = "";
	    this.out_emp_id = "";
	    this.out_emp_nm = "";
	    this.out_car_off_id = "";
	    this.out_car_off_nm = "";
	    this.out_car_off_tel = "";
		this.cls_dt = "";
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
	public void setDlv_dt(String val){
		if(val==null) val="";
		this.dlv_dt = val;
	}
	public void setDlv_est_dt(String val){
		if(val==null) val="";
		this.dlv_est_dt = val;
	}
	public void setBus_id(String val){
		if(val==null) val="";
		this.bus_id = val;
	}
	public void setBus_nm(String val){
		if(val==null) val="";
		this.bus_nm = val;
	}
	public void setMng_id(String val){
		if(val==null) val="";
		this.mng_id = val;
	}
	public void setMng_nm(String val){
		if(val==null) val="";
		this.mng_nm = val;
	}
    public void setClient_id(String val){
		if(val==null) val="";
		this.client_id = val;
	}
    public void setClient_nm(String val){
		if(val==null) val="";
		this.client_nm = val;
	}
    public void setFirm_nm(String val){
		if(val==null) val="";
		this.firm_nm = val;
	}
	public void setO_tel(String val){
		if(val==null) val="";
		this.o_tel = val;
	}
	public void setM_tel(String val){
		if(val==null) val="";
		this.m_tel = val;
	}
	public void setFax(String val){
		if(val==null) val="";
		this.fax = val;
	}
	public void setBr_id(String val){
		if(val==null) val="";
		this.br_id = val;
	}
	
	public void setFn_id(String val){
		if(val==null) val="";
		this.fn_id = val;
	}
	
    public void setCar_mng_id(String val){
		if(val==null) val="";
		this.car_mng_id = val;
	}
    public void setInit_reg_dt(String val){
		if(val==null) val="";
		this.init_reg_dt = val;
	}
	public void setReg_gubun(String val){
		if(val==null) val="";
		this.reg_gubun = val;
	}
    public void setCar_no(String val){
		if(val==null) val="";
		this.car_no = val;
	}
    public void setCar_num(String val){
		if(val==null) val="";
		this.car_num = val;
	}
    public void setR_st(String val){
		if(val==null) val="";
		this.r_st = val;
	}
	public void setRent_way(String val){
		if(val==null) val="";
		this.rent_way = val;
	}
	public void setCon_mon(String val){
		if(val==null) val="";
		this.con_mon = val;
	}
    public void setCar_id(String val){
		if(val==null) val="";
		this.car_id = val;
	}
	public void setImm_amt(int val){
		this.imm_amt = val;
	}
    public void setCar_name(String val){
		if(val==null) val="";
		this.car_name = val;
	}
    public void setRent_start_dt(String val){
		if(val==null) val="";
		this.rent_start_dt = val;
	}
    public void setRent_end_dt(String val){
		if(val==null) val="";
		this.rent_end_dt = val;
	}
    public void setReg_ext_dt(String val){
		if(val==null) val="";
		this.reg_ext_dt = val;
	}
    public void setRpt_no(String val){
		if(val==null) val="";
		this.rpt_no = val;
	}
    public void setCpt_cd(String val){
		if(val==null) val="";
		this.cpt_cd = val;
	}
    public void setBank_nm(String val){
		if(val==null) val="";
		this.bank_nm = val;
	}
	public void setIn_emp_id(String val){
		if(val==null) val="";
		this.in_emp_id = val;
	}
	public void setIn_emp_nm(String val){
		if(val==null) val="";
		this.in_emp_nm = val;
	}
	public void setIn_car_off_id(String val){
		if(val==null) val="";
		this.in_car_off_id = val;
	}
	public void setIn_car_off_nm(String val){
		if(val==null) val="";
		this.in_car_off_nm = val;
	}
	public void setIn_car_off_tel(String val){
		if(val==null) val="";
		this.in_car_off_tel = val;
	}
	public void setOut_emp_id(String val){
		if(val==null) val="";
		this.out_emp_id = val;
	}
	public void setOut_emp_nm(String val){
		if(val==null) val="";
		this.out_emp_nm = val;
	}
	public void setOut_car_off_id(String val){
		if(val==null) val="";
		this.out_car_off_id = val;
	}
	public void setOut_car_off_nm(String val){
		if(val==null) val="";
		this.out_car_off_nm = val;
	}
	public void setOut_car_off_tel(String val){
		if(val==null) val="";
		this.out_car_off_tel = val;
	}
	public void setCls_dt(String val){ if(val==null) val=""; this.cls_dt = val; }
		
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
    public String getDlv_dt(){
		return dlv_dt;
	}
	public String getDlv_est_dt(){
		return dlv_est_dt;
	}
	public String getBus_id(){
		return bus_id;
	}
	public String getBus_nm(){
		return bus_nm;
	}
	public String getMng_id(){
		return mng_id;
	}
	public String getMng_nm(){
		return mng_nm;
	}
    public String getClient_id(){
		return client_id;
	}
    public String getClient_nm(){
		return client_nm;
	}
    public String getFirm_nm(){
		return firm_nm;
	}
	public String getO_tel(){
		return o_tel;
	}
	public String getM_tel(){
		return m_tel;
	}
	public String getFax(){
		return fax;
	}
	public String getBr_id(){
		return br_id;
	}
	
	public String getFn_id(){
		return fn_id;
	}
	
    public String getCar_mng_id(){
		return car_mng_id;
	}
    public String getInit_reg_dt(){
		return init_reg_dt;
	}
	public String getReg_gubun(){
		return reg_gubun;
	}
    public String getCar_no(){
		return car_no;
	}
    public String getCar_num(){
		return car_num;
	}
	public String getR_st(){
		return r_st;
	}
    public String getRent_way(){
		return rent_way;
	}
	public String getRent_way_nm(){
		if(rent_way.equals("1"))
		{
			rent_way_nm = "일반식";
		}else if(rent_way.equals("2")){
			rent_way_nm = "맞춤식";
		}else{
			rent_way_nm = "기본식";
		}
		return rent_way_nm;
	}
    public String getCon_mon(){
		return con_mon;
	}
    public String getCar_id(){
		return car_id;
	}
	public int getImm_amt(){
		return imm_amt;
	}
    public String getCar_name(){
		return car_name;
	}
    public String getRent_start_dt(){
		return rent_start_dt;
	}
    public String getRent_end_dt(){
		return rent_end_dt;
	}
    public String getReg_ext_dt(){
		return reg_ext_dt;
	}
    public String getRpt_no(){
		return rpt_no;
	}
    public String getCpt_cd(){
		return cpt_cd;
	}
    public String getBank_nm(){
		return bank_nm;
	}
	public String getIn_emp_id(){
		return in_emp_id;
	}
	public String getIn_emp_nm(){
		return in_emp_nm;
	}
	public String getIn_car_off_id(){
		return in_car_off_id;
	}
	public String getIn_car_off_nm(){
		return in_car_off_nm;
	}
	public String getIn_car_off_tel(){
		return in_car_off_tel;
	}
	public String getOut_emp_id(){
		return out_emp_id;
	}
	public String getOut_emp_nm(){
		return out_emp_nm;
	}
	public String getOut_car_off_id(){
		return out_car_off_id;
	}
	public String getOut_car_off_nm(){
		return out_car_off_nm;
	}
	public String getOut_car_off_tel(){
		return out_car_off_tel;
	}
	public String getCls_dt(){ return cls_dt; }
}