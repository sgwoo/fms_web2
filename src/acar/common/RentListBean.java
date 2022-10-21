/**
 * 계약사항에 대한 세부사항 조회
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.common;

import java.util.*;

public class RentListBean {
    	//Table : CONT, CAR_REG, CLIENT, FEE, USERS, CAR_PUR, CAR_ETC, CAR_NM, ALLOT, CODE
	private String rent_mng_id;	//계약관리ID
    private String rent_l_cd;	//계약코드
   	private String rent_dt;		//계약일자
    private String dlv_dt;		//출고일자
	private String dlv_est_dt;	//출고예정일자    
    private String bus_id;		//영업담당자 ID
    private String bus_nm;		//영업담당자 이름
    private String mng_id;		//관리담당자 ID
    private String mng_id2;		//관리담당자 ID2
    private String mng_nm;		//관리담당자 이
	private String mng_nm2;		//관리담당자 이
	private String bus_id2;
   	private String client_id;	//고객ID
   	private String client_nm;	//고객 대표자명
   	private String firm_nm;		//상호
   	private String o_tel;		//사무실전화번호
   	private String m_tel;		//휴대폰
   	private String fax;		//팩스
   	private String br_id;		//지점코드
   	private String car_mng_id;	//자동차관리ID
   	private String init_reg_dt;	//최초등록일
   	private String reg_gubun;	//등록구분
   	private String car_no;		//차량번호
   	private String first_car_no;		//차량번호
   	private String car_num;		//차대번호
   	private String r_st;			
   	private String rent_way;	//대여방식 코드
   	private String rent_way_nm;	//대여방식 이름
   	private String con_mon;		//대여개월
   	private String car_id;		//차명ID
   	private int    imm_amt;		//자차면책금
   	private String car_name;	//차명
   	private String car_nm;
   	private String rent_start_dt;	//대여개시일
   	private String rent_end_dt;	//대여종료일
   	private String reg_ext_dt;	//등록예정일
   	private String rpt_no;		//계출번호
   	private String cpt_cd;		//은행코드
	private String bank_nm;		//은행명
   	private String reg_id;
    /*추가*/
	private String use_yn;
	private String rent_st;
	private String cls_st;
	private String cls_dt;
	private String car_st;
	private String scan_file;
	private String cha_seq;
	private int car_ja;
	private String r_site;
	//20040615 추가
	private String r_site_seq;
	//20050700 추가
	private String rent_dt2;
	private String fee_rent_st;
	//20050927 추가
	private String lend_id;
	private String rtn_seq;
	private String cont_bn;
	private String car_doc_no;
	//20060227추가
	private String migr_dt;
	//20061222
	private String sanction_id;		//결재자
	private String sanction_date;	//결재일
	private String sanction;		//결재내용
	//20070420추가
	private String car_end_dt;
	private String fine_mm;
	//20070612
	private String car_ext;
	//20070830
	private long reg_amt;  //자동차등록세
	private long acq_amt;  //자동차취득세
	private int no_m_amt;  //자동차번호제작비
	private int etc;  //기타 
	private int loan_s_amt;  //공채할인시
	private String car_a_yn;  //전표발행 
	
	//영업구분
	private String bus_st_nm;  //영업구분명
	
	private String reg_amt_card;  //등록세 카드전표발행 
	private String no_amt_card;  //번호판대 카드전표발행 

	//류길선 추가 RE_BUS_NM
	private String re_bus_nm;
	private String off_ls;
	
	
	private String reco_dt; //차량회수일
	private String car_deli_dt;  //차량인도일
	private String rent_suc_dt;  //승계일

	private String est_area;  //차량사용지역

	private String emp_nm;  //영업사원

	private String rrm;  //월렌트
	private String car_end_yn;
	private String prepare;
	
	private String sh_base_dt;  //중고차관련 
	private String jg_g_16;  //저공해대상여부
	
	private String end_req_dt;  //차령만료 - 처리예정일
	      	    
   	// CONSTRCTOR            
   	public RentListBean() {  
   		this.rent_mng_id= "";	
    	this.rent_l_cd	= "";					
    	this.rent_dt 	= "";					
    	this.dlv_dt 	= "";					
    	this.dlv_est_dt	= "";					
    	this.bus_id 	= "";					 
		this.bus_nm 	= "";					
		this.mng_id 	= "";					  
		this.mng_id2 	= "";					  
		this.mng_nm 	= "";					
		this.mng_nm2 	= "";					
    	this.client_id	= "";					
    	this.client_nm 	= "";					
    	this.firm_nm 	= "";						
    	this.o_tel 		= "";
    	this.m_tel 		= "";
    	this.fax 		= "";
    	this.br_id 		= "";					
    	this.car_mng_id = "";					
    	this.init_reg_dt= "";					
    	this.reg_gubun 	= "";					
    	this.car_no 	= "";						
    	this.first_car_no 	= "";						
    	this.car_num 	= "";						
    	this.r_st 		= "";
    	this.rent_way 	= "";					
    	this.rent_way_nm= "";					
    	this.con_mon 	= "";						
    	this.car_id 	= "";						
    	this.imm_amt 	= 0;
    	this.car_name 	= "";					
    	this.car_nm 	= "";
    	this.rent_start_dt = "";				
    	this.rent_end_dt= "";					
    	this.reg_ext_dt = "";					
    	this.rpt_no 	= "";					
    	this.cpt_cd 	= "";						
    	this.bank_nm 	= "";						
    	this.reg_id 	= "";
		this.use_yn 	= "";
		this.bus_id2	= "";
		this.rent_st 	= "";
		this.cls_st 	= "";
		this.cls_dt 	= "";
		this.car_st 	= "";
		this.scan_file	= "";
		this.cha_seq	= "";
		this.car_ja		= 0;
		this.r_site		= "";
		this.r_site_seq	= "";
		this.rent_dt2	= "";
		this.fee_rent_st= "";
		this.lend_id	= "";
		this.rtn_seq= "";
		this.cont_bn="";
		this.car_doc_no="";
		this.migr_dt="";
		this.sanction_id="";
		this.sanction_date="";
		this.sanction="";
		this.car_end_dt="";
		this.fine_mm="";
		this.car_ext="";
		this.reg_amt	= 0;
		this.acq_amt	= 0;
		this.no_m_amt	= 0;
		this.etc	= 0;
		this.loan_s_amt	= 0;
		this.car_a_yn="";
		this.bus_st_nm="";
		
		this.reg_amt_card="";
		this.no_amt_card="";

		this.re_bus_nm="";
		this.off_ls="";

		
		this.reco_dt="";
		this.car_deli_dt="";
		this.rent_suc_dt="";
		this.est_area="";
		this.emp_nm="";
		
		this.rrm="";
		this.car_end_yn="";
		this.prepare = "";
		
		this.sh_base_dt="";
		this.jg_g_16 = "";
		
		this.end_req_dt = "";
		
		
	}
	
	// SET Method
	public void setRent_mng_id(String val){	if(val==null) val="";	this.rent_mng_id = val;	}
   	public void setRent_l_cd(String val){	if(val==null) val="";	this.rent_l_cd = val;	}
	public void setRent_dt(String val){		if(val==null) val="";	this.rent_dt = val;		}
	public void setDlv_dt(String val){		if(val==null) val="";	this.dlv_dt = val;		}	
	public void setDlv_est_dt(String val){	if(val==null) val="";	this.dlv_est_dt = val;	}	
	public void setBus_id(String val){		if(val==null) val="";	this.bus_id = val;		}
	public void setBus_nm(String val){		if(val==null) val="";	this.bus_nm = val;		}
	public void setBus_id2(String val){		if(val==null) val="";	this.bus_id2 = val;		}
	public void setMng_id(String val){		if(val==null) val="";	this.mng_id = val;		}
	public void setMng_id2(String val){		if(val==null) val="";	this.mng_id2 = val;		}
	public void setMng_nm(String val){		if(val==null) val="";	this.mng_nm = val;		}
	public void setMng_nm2(String val){		if(val==null) val="";	this.mng_nm2 = val;		}
   	public void setClient_id(String val){	if(val==null) val="";	this.client_id = val;	}
   	public void setClient_nm(String val){	if(val==null) val="";	this.client_nm = val;	}
   	public void setFirm_nm(String val){		if(val==null) val="";	this.firm_nm = val;		}
	public void setO_tel(String val){		if(val==null) val="";	this.o_tel = val;		}
	public void setM_tel(String val){		if(val==null) val="";	this.m_tel = val;		}
	public void setFax(String val){			if(val==null) val="";	this.fax = val;			}
	public void setBr_id(String val){		if(val==null) val="";	this.br_id = val;		}
   	public void setCar_mng_id(String val){	if(val==null) val="";	this.car_mng_id = val;	}
   	public void setInit_reg_dt(String val){	if(val==null) val="";	this.init_reg_dt = val;	}
	public void setR_st(String val){		if(val==null) val="";	this.r_st = val;		}
	public void setReg_gubun(String val){	if(val==null) val="";	this.reg_gubun = val;	}
   	public void setCar_no(String val){		if(val==null) val="";	this.car_no = val;		}
   	public void setFirst_car_no(String val){		if(val==null) val="";	this.first_car_no = val;		}
   	public void setCar_num(String val){		if(val==null) val="";	this.car_num = val;		}
   	public void setRent_way(String val){	if(val==null) val="";	this.rent_way = val;	}
	public void setCon_mon(String val){		if(val==null) val="";	this.con_mon = val;		}
   	public void setCar_id(String val){		if(val==null) val="";	this.car_id = val;		}
	public void setImm_amt(int val){								this.imm_amt = val;		}
   	public void setCar_name(String val){	if(val==null) val="";	this.car_name = val;	}
	public void setCar_nm(String val){		if(val==null) val="";	this.car_nm = val;		}
   	public void setRent_start_dt(String val){if(val==null)val="";	this.rent_start_dt = val;}
   	public void setRent_end_dt(String val){	if(val==null) val="";	this.rent_end_dt = val;	}
   	public void setReg_ext_dt(String val){	if(val==null) val="";	this.reg_ext_dt = val;	}
   	public void setRpt_no(String val){		if(val==null) val="";	this.rpt_no = val;		}
   	public void setCpt_cd(String val){		if(val==null) val="";	this.cpt_cd = val;		}
   	public void setBank_nm(String val){		if(val==null) val="";	this.bank_nm = val;		}
	public void setReg_id(String val){		if(val==null) val="";	this.reg_id = val;		}
	public void setUse_yn(String val){		if(val==null) val="";	this.use_yn = val;		}
	public void setRent_st(String val){		if(val==null) val="";	this.rent_st = val;		}
	public void setCls_st(String val){		if(val==null) val="";	this.cls_st = val;		}
	public void setCls_dt(String val){		if(val==null) val="";	this.cls_dt = val;		}
	public void setCar_st(String val){		if(val==null) val="";	this.car_st = val;		}
	public void setScan_file(String val){	if(val==null) val="";	this.scan_file = val;	}
	public void setCha_seq(String val){		if(val==null) val="";	this.cha_seq = val;		}
	public void setCar_ja(int val){									this.car_ja = val;		}
	public void setR_site(String val){		if(val==null) val="";	this.r_site = val;		}
	public void setR_site_seq(String val){	if(val==null) val="";	this.r_site_seq = val;	}
	public void setRent_dt2(String val){	if(val==null) val="";	this.rent_dt2 = val;	}
	public void setFee_rent_st(String val){	if(val==null) val="";	this.fee_rent_st = val;	}
	public void setLend_id(String val){		if(val==null) val="";	this.lend_id = val;		}
	public void setRtn_seq(String val){		if(val==null) val="";	this.rtn_seq = val;		}
	public void setCont_bn(String val){		if(val==null) val="";	this.cont_bn = val;		}
	public void setCar_doc_no(String val){	if(val==null) val="";	this.car_doc_no = val;	}
	public void setMigr_dt(String val){		if(val==null) val="";	this.migr_dt = val;		}
	public void setSanction_id(String val)		{	if(val==null) val="";	this.sanction_id	= val;}
	public void setSanction_date(String val)	{	if(val==null) val="";	this.sanction_date	= val;}
	public void setSanction(String val)			{	if(val==null) val="";	this.sanction		= val;}
	public void setCar_end_dt(String val)		{	if(val==null) val="";	this.car_end_dt		= val;}
	public void setFine_mm(String val)			{	if(val==null) val="";	this.fine_mm		= val;}
	public void setCar_ext(String val)			{	if(val==null) val="";	this.car_ext		= val;}
	public void setReg_amt(long val)			{							this.reg_amt		= val;}
	public void setAcq_amt(long val)			{							this.acq_amt		= val;}
	public void setNo_m_amt(int val)			{							this.no_m_amt		= val;}
	public void setEtc(int val)			{							this.etc		= val;}
	public void setLoan_s_amt(int val)			{							this.loan_s_amt		= val;}
	public void setCar_a_yn(String val)			{	if(val==null) val="";	this.car_a_yn		= val;}
	public void setBus_st_nm(String val)		{	if(val==null) val="";	this.bus_st_nm		= val;}	
	public void setReg_amt_card(String val)		{	if(val==null) val="";	this.reg_amt_card	= val;}
	public void setNo_amt_card(String val)		{	if(val==null) val="";	this.no_amt_card	= val;}
	public void setRe_bus_nm(String val)		{	if(val==null) val="";	this.re_bus_nm		= val;}
	public void setOff_ls(String val)			{	if(val==null) val="";	this.off_ls			= val;}	
	public void setReco_dt(String val)			{	if(val==null) val="";	this.reco_dt		= val;}
	public void setCar_deli_dt(String val)		{	if(val==null) val="";	this.car_deli_dt	= val;}
	public void setRent_suc_dt(String val)		{	if(val==null) val="";	this.rent_suc_dt	= val;}
	public void setEst_area(String val)			{	if(val==null) val="";	this.est_area		= val;}
	public void setEmp_nm(String val)			{	if(val==null) val="";	this.emp_nm			= val;}	
	public void setRrm(String val)				{	if(val==null) val="";	this.rrm			= val;}
	public void setCar_end_yn(String val)		{	if(val==null) val="";	this.car_end_yn		= val;}
	public void setPrepare(String val)			{	if(val==null) val="";	this.prepare		= val;}
	public void setSh_base_dt(String val)		{	if(val==null) val="";	this.sh_base_dt	= val;}
	public void setJg_g_16(String val)			{	if(val==null) val="";	this.jg_g_16	= val;}
	
	public void setEnd_req_dt(String val)			{	if(val==null) val="";	this.end_req_dt	= val;}
	
	
		
	//GET Method
	public String getRent_mng_id(){	return rent_mng_id;	}
   	public String getRent_l_cd(){	return rent_l_cd;	}
	public String getRent_dt(){		return rent_dt;		}
   	public String getDlv_dt(){		return dlv_dt;		}	
	public String getDlv_est_dt(){	return dlv_est_dt;	}	
	public String getBus_id(){		return bus_id;		}
	public String getBus_nm(){		return bus_nm;		}
	public String getBus_id2(){		return bus_id2;		}
	public String getMng_id(){		return mng_id;		}
	public String getMng_id2(){		return mng_id2;		}
	public String getMng_nm(){		return mng_nm;		}
	public String getMng_nm2(){		return mng_nm2;		}
   	public String getClient_id(){	return client_id;	}
   	public String getClient_nm(){	return client_nm;	}
   	public String getFirm_nm(){		return firm_nm;		}
	public String getO_tel(){		return o_tel;		}
	public String getM_tel(){		return m_tel;		}
	public String getFax(){			return fax;			}
	public String getBr_id(){		return br_id;		}
   	public String getCar_mng_id(){	return car_mng_id;	}
   	public String getInit_reg_dt(){	return init_reg_dt;	}
	public String getReg_gubun(){	return reg_gubun;	}
   	public String getCar_no(){		return car_no;		}
   	public String getFirst_car_no(){		return first_car_no;		}
   	public String getCar_num(){		return car_num;		}
   	public String getRent_way(){	return rent_way;	}
	public String getR_st(){		return r_st;		}
	public String getRent_way_nm(){
		if(rent_way.equals("1"))		rent_way_nm = "일반식";
		else if(rent_way.equals("2"))	rent_way_nm = "맞춤식";		
		else 							rent_way_nm = "기본식";		
		return rent_way_nm;
	}
   	public String getCon_mon(){		return con_mon;		}
   	public String getCar_id(){		return car_id;		}
	public int getImm_amt(){		return imm_amt;		}
   	public String getCar_name(){	return car_name;	}
	public String getCar_nm(){		return car_nm;		}
   	public String getRent_start_dt(){return rent_start_dt;}
   	public String getRent_end_dt(){	return rent_end_dt;	}
   	public String getReg_ext_dt(){	return reg_ext_dt;	}
   	public String getRpt_no(){		return rpt_no;		}
   	public String getCpt_cd(){		return cpt_cd;		}
   	public String getBank_nm(){		return bank_nm;		}
	public String getReg_id(){		return reg_id;		}
	public String getUse_yn(){		return use_yn;		}
	public String getRent_st(){		return rent_st;		}
	public String getCls_st(){		return cls_st;		}
	public String getCls_dt(){		return cls_dt;		}
	public String getCar_st(){		return car_st;		}
	public String getScan_file(){	return scan_file;	}
	public String getCha_seq(){		return cha_seq;		}
	public int getCar_ja(){			return car_ja;		}
	public String getR_site(){		return r_site;		}
	public String getR_site_seq(){	return r_site_seq;	}
	public String getRent_dt2(){	return rent_dt2;	}
	public String getFee_rent_st(){	return fee_rent_st;	}
	public String getLend_id(){		return lend_id;		}
	public String getRtn_seq(){		return rtn_seq;		}
	public String getCont_bn(){		return cont_bn;		}
	public String getCar_doc_no(){	return car_doc_no;	}
	public String getMigr_dt(){		return migr_dt;		}
	public String getSanction_id()	{	return sanction_id;		}
	public String getSanction_date(){	return sanction_date;	}
	public String getSanction()		{	return sanction;		}
	public String getCar_end_dt()	{	return car_end_dt;		}
	public String getFine_mm()		{	return fine_mm;		}
	public String getCar_ext()		{	return car_ext;		}
	public long  getReg_amt(){			return reg_amt;		}
	public long  getAcq_amt(){			return acq_amt;		}
	public int getNo_m_amt(){			return no_m_amt;		}
	public int getEtc(){				return etc;		}
	public int getLoan_s_amt(){			return loan_s_amt;		}
	public String getCar_a_yn()		{	return car_a_yn;		}
	public String getBus_st_nm()	{	return bus_st_nm;		}
	
	public String getReg_amt_card()	{	return reg_amt_card;		}
	public String getNo_amt_card()	{	return no_amt_card;		}

	public String getRe_bus_nm()	{	return re_bus_nm;	}
	public String getOff_ls()		{	return off_ls;	}

	public String getReco_dt()		{	return reco_dt;			}
	public String getCar_deli_dt()	{	return car_deli_dt;		}
	public String getRent_suc_dt()	{	return rent_suc_dt;		}
	public String getEst_area()		{	return est_area;		}
	public String getEmp_nm()		{	return emp_nm;			}
	public String getRrm()			{	return rrm;				}
	public String getCar_end_yn()	{	return car_end_yn;		}
	public String getPrepare()		{	return prepare;			}	
	public String getSh_base_dt()	{	return sh_base_dt;		}
	public String getJg_g_16()		{	return jg_g_16;			}
	
	public String getEnd_req_dt()		{	return end_req_dt;			}
	
	
}

