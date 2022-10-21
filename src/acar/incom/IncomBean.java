package acar.incom;

import java.util.*;

public class IncomBean {
    //Table : incom 
	private String incom_dt;		//거래일자
	private int incom_seq;			//거래순번
	private long incom_amt;	
	private String incom_gubun;
	private String jung_type;
	private String ip_method;
	private String bank_nm;
	private String bank_no;
	private String remark;
	private String bank_office;  //거래점
	
 	private String card_cd;		
    private String card_nm;		
    private String card_no;		
   	private String card_owner;	
	private String card_get_id;	
	private String cash_area;
	private String cash_get_id;	
	private String rent_l_cd;	
    private String client_id;	
    private String not_yet;	
	private String pay_gur;	
	private String pay_gur_nm;	
	private String pay_gur_rel;	
	private String except_st1;	//대여료
	private String except_st2;	//면책금
	private String except_st3;	//연체이자
	private String pay_reason;	
	private String pay_sac_id;		
	private String neom_yn;	
	private String ven_code;	
	private String cont;	
	private String trusbill_yn;	
	private String mail_yn;	
	private String reg_id;	
	private String reg_dt;	
	private String sac_id;	
	private String sac_dt;	
	private String p_gubun;
	private int card_tax;
	private String card_doc_cont;  //카드인경우 적요
	
	private String re_chk;  //확인
	private String reason;   //확인됨에도 불구하고 처리못한 사유
	
	private String acct_seq;   // inside bank
	private String tr_date_seq;   //inside bank
	private String row_id;   //전표번호

														
	public IncomBean() {  
		incom_dt = "";
		incom_seq = 0;
		incom_amt = 0;	
		incom_gubun = "";	
		jung_type = "";	
		ip_method = "";	
		bank_nm = "";	
		bank_no = "";	
		remark = "";	
		bank_office = "";	  //거래점
	
		card_cd = "";					
    	card_nm = "";			
    	card_no = "";			
   		card_owner = "";		
		card_get_id = "";	
		cash_area = "";	
		cash_get_id = "";	
		rent_l_cd = "";	
    	client_id = "";	
    	not_yet = "";	
		pay_gur = "";	
		pay_gur_nm = "";	
		pay_gur_rel = "";	
		except_st1 = "";	
		except_st2 = "";	
		except_st3 = "";	
		pay_reason = "";	
		pay_sac_id = "";		
		neom_yn = "";	
		ven_code = "";	
		cont = "";	
		trusbill_yn = "";	
		mail_yn = "";	
		reg_id = "";	
		reg_dt = "";	
		sac_id = "";	
		sac_dt = "";	
		p_gubun = "";	
		card_tax = 0;	
		card_doc_cont = "";
		
		re_chk = "";
		reason = "";
		
		acct_seq = "";
		tr_date_seq = "";
		row_id = "";
		
		
	}

	// set Method
	public void setIncom_dt(String str){		incom_dt = str;	}
	public void setIncom_seq(int i){			incom_seq = i;	}
	public void setIncom_amt(long i){			incom_amt = i;	}
	public void setIncom_gubun(String str){		incom_gubun = str;	}
	public void setJung_type(String str){		jung_type = str;	}	
	public void setIp_method(String str){		ip_method = str;	}	
	public void setBank_nm(String str){			bank_nm = str;	}	
	public void setBank_no(String str){			bank_no = str;	}	
	public void setRemark(String str){			remark = str;	}	
	public void setBank_office(String str){		bank_office = str;	}	  //거래점

	public void setCard_cd(String str){			card_cd = str;	}			
    public void setCard_nm(String str){			card_nm = str;	}			
    public void setCard_no(String str){			card_no = str;	}			
   	public void setCard_owner(String str){		card_owner = str;	}		
	public void setCard_get_id(String str){		card_get_id = str;	}	
	public void setCash_area(String str){		cash_area = str;	}	
	public void setCash_get_id(String str){		cash_get_id = str;	}	
	public void setRent_l_cd(String str){		rent_l_cd = str;	}	
    public void setClient_id(String str){		client_id = str;	}	
    public void setNot_yet(String str){			not_yet = str;	}	
	public void setPay_gur(String str){			pay_gur = str;	}	
	public void setPay_gur_nm(String str){		pay_gur_nm = str;	}	
	public void setPay_gur_rel(String str){		pay_gur_rel = str;	}	
	public void setExcept_st1(String str){		except_st1 = str;	}	
	public void setExcept_st2(String str){		except_st2 = str;	}	
	public void setExcept_st3(String str){		except_st3 = str;	}	
	public void setPay_reason(String str){		pay_reason = str;	}	
	public void setPay_sac_id(String str){		pay_sac_id = str;	}		
	public void setNeom_yn(String str){			neom_yn = str;	}	
	public void setVen_code(String str){		ven_code = str;	}	
	public void setCont(String str){			cont = str;	}	
	public void setTrusbill_yn(String str){		trusbill_yn = str;	}	
	public void setMail_yn(String str){			mail_yn = str;	}	
	public void setReg_id(String str){			reg_id = str;	}	
	public void setReg_dt(String str){			reg_dt = str;	}	
	public void setSac_id(String str){			sac_id = str;	}	
	public void setSac_dt(String str){			sac_dt = str;	}	
	public void setP_gubun(String str){			p_gubun = str;	}	
	public void setCard_tax(int i){				card_tax = i;	}
	public void setCard_doc_cont(String str){	card_doc_cont = str;	}	
	
	public void setRe_chk(String str){	re_chk = str;	}	
	public void setReason(String str){	reason = str;	}	
	
	public void setAcct_seq(String str){	acct_seq = str;	}	
	public void setTr_date_seq(String str){	tr_date_seq = str;	}	
	public void setRow_id(String str){	row_id = str;	}	
		
	//Get Method
	public String getIncom_dt(){		return incom_dt;	}
	public int getIncom_seq(){			return incom_seq;	}	
	public long getIncom_amt(){		return incom_amt; }
	public String getIncom_gubun(){		return incom_gubun;	}
	public String getJung_type(){		return jung_type;	}	
	public String getIp_method(){		return ip_method;	}	
	public String getBank_nm(){			return bank_nm;	}	
	public String getBank_no(){			return bank_no;	}	
	public String getRemark(){			return remark;	}	
	public String getBank_office(){		return bank_office;	}	  //거래점
	
    public String getCard_cd(){			return card_cd;	}		
    public String getCard_nm(){			return card_nm;	}			
    public String getCard_no(){			return card_no;	}			
   	public String getCard_owner(){		return card_owner;	}		
	public String getCard_get_id(){		return card_get_id;	}	
	public String getCash_area(){		return cash_area;	}	
	public String getCash_get_id(){		return cash_get_id;	}	
	public String getRent_l_cd(){		return rent_l_cd;	}	
    public String getClient_id(){		return client_id;	}	
    public String getNot_yet(){			return not_yet;	}	
	public String getPay_gur(){			return pay_gur;	}	
	public String getPay_gur_nm(){		return pay_gur_nm;	}	
	public String getPay_gur_rel(){		return pay_gur_rel;	}	
	public String getExcept_st1(){		return except_st1;	}	
	public String getExcept_st2(){		return except_st2;	}	
	public String getExcept_st3(){		return except_st3;	}	
	public String getPay_reason(){		return pay_reason;	}	
	public String getPay_sac_id(){		return pay_sac_id;	}		
	public String getNeom_yn(){			return neom_yn;	}	
	public String getVen_code(){		return ven_code;	}	
	public String getCont(){			return cont;	}	
	public String getTrusbill_yn(){		return trusbill_yn;	}	
	public String getMail_yn(){			return mail_yn;	}	
	public String getReg_id(){			return reg_id;	}	
	public String getReg_dt(){			return reg_dt;	}
	public String getSac_id(){			return sac_id;	}	
	public String getSac_dt(){			return sac_dt;	}	
	public int getCard_tax(){			return card_tax;}	
	public String getP_gubun(){			return p_gubun;	}	
	public String getCard_doc_cont(){			return card_doc_cont;	}	
	
	public String getRe_chk(){			return re_chk;	}
	public String getReason(){			return reason;	}
	
	public String getAcct_seq(){			return acct_seq;	}
	public String getTr_date_seq(){		return tr_date_seq;	}
	public String getRow_id(){		return row_id;	}
	
}