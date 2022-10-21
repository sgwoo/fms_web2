package acar.cont;

public class ContDebtBean
{
	private String rent_mng_id;     // 계약관리번호            
	private String rent_l_cd;       // 계약번호                
	private String allot_st;        // 구분                    
	private String cpt_cd;          // 금융사명                
	private String lend_int;        // 대출이율                
	private int    lend_prn;        // 대출원금                
	private int    alt_fee;         // 할부수수료              
	private int    rtn_tot_amt;     // 상환총금액              
	private String loan_debtor;     // 상환의무자              
	private String rtn_cdt;         // 상환조건                
	private String rtn_way;         // 상환방법                
	private String rtn_est_dt;      // 상환약정일              
	private String lend_no;         // 대출번호                
	private int    ntrl_fee;        // 공증료                  
	private int    stp_fee;         // 인지대                  
	private String lend_dt;         // 대출일자                
	private int    lend_int_amt;    // 대출이자                 
	private int    alt_amt;         // 할부금액                
	private String tot_alt_tm;      // 할부횟수                
	private String alt_start_dt;    // 할부기간_시작일          
	private String alt_end_dt;      // 할부기간_종료           
	private String bond_get_st;     // 채권확보유형            
	private String bond_st;         // 채권유형                
	private String loan_con_nm;     // Loan 계약자_이름        
	private String loan_con_ssn;    // Loan 계약자_주민등록번호 
	private String loan_con_rel;    // Loan 계약자_관계         
	private String loan_con_tel;    // Loan 계약자_연락처       
	private String loan_con_addr;   // Loan 계약자_주소         
	private String grtr_nm1;        // 연대보증인1_이름        
	private String grtr_ssn1;       // 연대보증인1_주민등록번호
	private String grtr_rel1;       // 연대보증인1_관계        
	private String grtr_tel1;       // 연대보증인1_연락처      
	private String grtr_addr1;      // 연대보증인1_주소        
	private String grtr_nm2;        // 연대보증인2_이름        
	private String grtr_ssn2;       // 연대보증인2_주민등록번호
	private String grtr_rel2;       // 연대보증인2_관계        
	private String grtr_tel2;       // 연대보증인2_연락처      
	private String grtr_addr2;      // 연대보증인2_주소        
	private String grtr_nm3;        // 연대보증인3_이름        
	private String grtr_ssn3;       // 연대보증인3_주민등록번호
	private String grtr_rel3;       // 연대보증인3_관계        
	private String grtr_tel3;       // 연대보증인3_연락처      
	private String grtr_addr3;      // 연대보증인3_주소        
	private String fst_pay_dt;      // 1회차 상환금액          
	private int    fst_pay_amt;     // 1회차결재일   
	private String bond_get_st_sub;	//채권확보유형-기타
	private String cls_rtn_dt;		//중도일시상환일
	private int	   cls_rtn_amt;		//중도상환액
	private int	   cls_rtn_fee;		//중도상환수수료
//	private int	   cls_rtn_int_amt;	//중도상환경과이자
//	private String cls_rtn_int;		//중도상환이자율
	private String cls_rtn_cau;		//중도상환사유
	private String note;			//기타
	private String lend_id;			//대출관리번호
	private String cpt_cd_st;		//금융사 구분
	private String car_mng_id;		//자동차관리번호
	private String loan_st_dt;		//대출신청일
	private int    loan_sch_amt;	//대출예상금액
	private int    pay_sch_amt;		//지출예상금액
	private int	   dif_amt;			//차감입금액
	private String imsi_chk;		//차량관리번호 임시코드 체크
	private String rtn_seq;			//상환번호
	private String loan_st;			//상환구분(1:개별대출, 2:은행대출매핑)
	private String rimitter;		//송금처
	private String cls_yn;			//중도해지 유/무
	//2003.07.11 추가
	private int	lend_int_vat;		//할부이자 부가세
	//2004.01.27 추가
	private String	autodoc_yn;		//자동전표 여부
	private String	ven_code;		//거래처코드
	private String	bank_code;		//은행코드
	private String	deposit_no;		//계좌번호
	private String	acct_code;		//계정과목
	//2011.08.11 추가
	private String	cls_rtn_fee_int;	//중도상환수수료
	private String	cls_rtn_etc;		//중도상환수수료 특이사항 : 약정율과 실적용율이 틀린 경우
	private String  file_name;			//금융약정계약서 스캔파일
	private String  file_type;			//스캔파일
	//cms 기관코드 (다중기관코드사용에 따라 : 없으면 신한:9951572587,  외환:      (20131113 현재)
	private String  cms_code;			//cms  기관코드
	private String  fund_id;			//자금관리번호
	
	private String alt_etc;     	 // 기타비용내용
	private int    alt_etc_amt;      // 기타비용금액
	private String alt_etc_tm;       // 기타비용회차
	                                
	public ContDebtBean()
	{
		rent_mng_id  = "";
		rent_l_cd    = "";
		allot_st     = "";
		cpt_cd       = "";
		lend_int     = "";
		lend_prn     = 0;
		alt_fee      = 0;
		rtn_tot_amt  = 0;
		loan_debtor  = "";
		rtn_cdt      = "";
		rtn_way      = "";
		rtn_est_dt   = "";
		lend_no      = "";
		ntrl_fee     = 0;
		stp_fee      = 0;
		lend_dt      = "";
		lend_int_amt = 0;
		alt_amt      = 0;
		tot_alt_tm   = "";
		alt_start_dt = "";
		alt_end_dt   = "";
		bond_get_st  = "";
		bond_st      = "";
		loan_con_nm  = "";
		loan_con_ssn = "";
		loan_con_rel = "";
		loan_con_tel = "";
		loan_con_addr= "";
		grtr_nm1     = "";
		grtr_ssn1    = "";
		grtr_rel1    = "";
		grtr_tel1    = "";
		grtr_addr1   = "";
		grtr_nm2     = "";
		grtr_ssn2    = "";
		grtr_rel2    = "";
		grtr_tel2    = "";
		grtr_addr2   = "";
		grtr_nm3     = "";
		grtr_ssn3    = "";
		grtr_rel3    = "";
		grtr_tel3    = "";
		grtr_addr3   = "";
		fst_pay_dt   = "";
		fst_pay_amt  = 0;
		bond_get_st_sub = "";
		cls_rtn_dt	 = "";
		cls_rtn_amt	= 0;
		cls_rtn_fee = 0;
		cls_rtn_cau = "";
		note = "";
		lend_id = "";
		cpt_cd_st = "";
		car_mng_id = "";
		loan_st_dt = "";
		loan_sch_amt = 0;
		pay_sch_amt = 0;
		dif_amt = 0;
		imsi_chk = "";
		rtn_seq = "";		
		loan_st	= "";
		rimitter = "";
		cls_yn = "";
		lend_int_vat = 0;
		autodoc_yn = "";
		ven_code = "";
		bank_code = "";
		deposit_no = "";
		acct_code = "";
		cls_rtn_fee_int	= "";
		cls_rtn_etc		= "";	
		file_name		= "";
		file_type		= "";
		cms_code		= "";
		fund_id = "";
		alt_etc = "";
		alt_etc_amt = 0;
		alt_etc_tm = "";
	}
	
	public void setRent_mng_id(String str)	{ rent_mng_id  = str; }
	public void setRent_l_cd(String str)	{ rent_l_cd    = str; }
	public void setAllot_st(String str)		{ allot_st     = str; }
	public void setCpt_cd(String str)		{ cpt_cd       = str; }
	public void setLend_int(String str)		{ lend_int     = str; }
	public void setLend_prn(int i)			{ lend_prn     = i; }
	public void setAlt_fee(int i)			{ alt_fee      = i; }
	public void setRtn_tot_amt(int i)		{ rtn_tot_amt  = i; }
	public void setLoan_debtor(String str)	{ loan_debtor  = str; }
	public void setRtn_cdt(String str)		{ rtn_cdt      = str; }
	public void setRtn_way(String str)		{ rtn_way      = str; }
	public void setRtn_est_dt(String str)	{ rtn_est_dt   = str; }
	public void setLend_no(String str)		{ lend_no      = str; }
	public void setNtrl_fee(int i)			{ ntrl_fee     = i; }
	public void setStp_fee(int i)			{ stp_fee      = i; }
	public void setLend_dt(String str)		{ lend_dt      = str; }
	public void setLend_int_amt(int i)		{ lend_int_amt = i; }
	public void setAlt_amt(int i)			{ alt_amt      = i; }
	public void setTot_alt_tm(String str)	{ tot_alt_tm   = str; }
	public void setAlt_start_dt(String str)	{ alt_start_dt = str; }
	public void setAlt_end_dt(String str)	{ alt_end_dt   = str; }
	public void setBond_get_st(String str)	{ bond_get_st  = str; }
	public void setBond_st(String str)		{ bond_st      = str; }
	public void setLoan_con_nm(String str)	{ loan_con_nm  = str; }
	public void setLoan_con_ssn(String str)	{ loan_con_ssn = str; }
	public void setLoan_con_rel(String str)	{ loan_con_rel = str; }
	public void setLoan_con_tel(String str)	{ loan_con_tel = str; }
	public void setLoan_con_addr(String str){ loan_con_addr= str; }
	public void setGrtr_nm1(String str)		{ grtr_nm1     = str; }
	public void setGrtr_ssn1(String str)	{ grtr_ssn1    = str; }
	public void setGrtr_rel1(String str)	{ grtr_rel1    = str; }
	public void setGrtr_tel1(String str)	{ grtr_tel1    = str; }
	public void setGrtr_addr1(String str)	{ grtr_addr1   = str; }
	public void setGrtr_nm2(String str)		{ grtr_nm2     = str; }
	public void setGrtr_ssn2(String str)	{ grtr_ssn2    = str; }
	public void setGrtr_rel2(String str)	{ grtr_rel2    = str; }
	public void setGrtr_tel2(String str)	{ grtr_tel2    = str; }
	public void setGrtr_addr2(String str)	{ grtr_addr2   = str; }
	public void setGrtr_nm3(String str)		{ grtr_nm3     = str; }
	public void setGrtr_ssn3(String str)	{ grtr_ssn3    = str; }
	public void setGrtr_rel3(String str)	{ grtr_rel3    = str; }
	public void setGrtr_tel3(String str)	{ grtr_tel3    = str; }
	public void setGrtr_addr3(String str)	{ grtr_addr3   = str; }
	public void setFst_pay_dt(String str)	{ fst_pay_dt   = str; }
	public void setFst_pay_amt(int i)		{ fst_pay_amt  = i;	  }
	public void setBond_get_st_sub(String str){ bond_get_st_sub=str;}
	public void setCls_rtn_dt(String str)	{ cls_rtn_dt   = str; }
	public void setCls_rtn_amt(int i)		{ cls_rtn_amt  = i;	  }
	public void setCls_rtn_fee(int i)		{ cls_rtn_fee  = i;	  }
	public void setCls_rtn_cau(String str)	{ cls_rtn_cau   = str; }
	public void setNote(String str)			{ note		   = str; }
	public void setLend_id(String str)		{ lend_id	   = str; }
	public void setCpt_cd_st(String str)	{ cpt_cd_st    = str; }
	public void setCar_mng_id(String str)	{ car_mng_id   = str; }
	public void setLoan_st_dt(String str)	{ loan_st_dt   = str; }
	public void setLoan_sch_amt(int i)		{ loan_sch_amt = i;	  }
	public void setPay_sch_amt(int i)		{ pay_sch_amt  = i;	  }
	public void setDif_amt(int i)			{ dif_amt	   = i;	  }
	public void setImsi_chk(String str)		{ imsi_chk     = str; }
	public void setRtn_seq(String str)		{ rtn_seq	   = str; }
	public void setLoan_st(String str)		{ loan_st	   = str; }
	public void setRimitter(String str)		{ rimitter	   = str; }
	public void setCls_yn(String str)		{ cls_yn	   = str; }
	public void setLend_int_vat(int i)		{ lend_int_vat = i;	  }
	public void setAutodoc_yn(String str)	{ autodoc_yn   = str; }
	public void setVen_code(String str)		{ ven_code	   = str; }
	public void setBank_code(String str)	{ bank_code    = str; }
	public void setDeposit_no(String str)	{ deposit_no   = str; }
	public void setAcct_code(String str)	{ acct_code    = str; }
	public void setCls_rtn_fee_int	(String str)		{	cls_rtn_fee_int = str;	}	
	public void setCls_rtn_etc		(String str)		{	cls_rtn_etc		= str;	}		
	public void setFile_name		(String str)		{	if(str==null) str="";	this.file_name	= str;	}	
	public void setFile_type		(String str)		{	if(str==null) str="";	this.file_type	= str;	}
	public void setCms_code		(String str)		{	if(str==null) str="";	this.cms_code	= str;	}
	public void setFund_id		(String str)		{	if(str==null) str="";	this.fund_id	= str;	}
	
	public void setAlt_etc		(String str)		{	if(str==null) str="";	this.alt_etc	= str;	}
	public void setAlt_etc_amt	(int i)				{ 							alt_etc_amt 	= i;	}
	public void setAlt_etc_tm	(String str)		{	if(str==null) str="";	this.alt_etc_tm	= str;	}


	
	public String getRent_mng_id()	{ return rent_mng_id  ; }
	public String getRent_l_cd()	{ return rent_l_cd    ; }
	public String getAllot_st()		{ return allot_st     ; }
	public String getCpt_cd()		{ return cpt_cd       ; }
	public String getLend_int()		{ return lend_int     ; }
	public int    getLend_prn()		{ return lend_prn     ; }
	public int    getAlt_fee()		{ return alt_fee      ; }
	public int    getRtn_tot_amt()	{ return rtn_tot_amt  ; }
	public String getLoan_debtor()	{ return loan_debtor  ; }
	public String getRtn_cdt()		{ return rtn_cdt      ; }
	public String getRtn_way()		{ return rtn_way      ; }
	public String getRtn_est_dt()	{ return rtn_est_dt   ; }
	public String getLend_no()		{ return lend_no      ; }
	public int    getNtrl_fee()		{ return ntrl_fee     ; }
	public int    getStp_fee()		{ return stp_fee      ; }
	public String getLend_dt()		{ return lend_dt      ; }
	public int    getLend_int_amt()	{ return lend_int_amt ; }
	public int    getAlt_amt()		{ return alt_amt      ; }
	public String getTot_alt_tm()	{ return tot_alt_tm   ; }
	public String getAlt_start_dt()	{ return alt_start_dt ; }
	public String getAlt_end_dt()	{ return alt_end_dt   ; }
	public String getBond_get_st()	{ return bond_get_st  ; }
	public String getBond_st()		{ return bond_st      ; }
	public String getLoan_con_nm()	{ return loan_con_nm  ; }
	public String getLoan_con_ssn()	{ return loan_con_ssn ; }
	public String getLoan_con_rel()	{ return loan_con_rel ; }
	public String getLoan_con_tel()	{ return loan_con_tel ; }
	public String getLoan_con_addr(){ return loan_con_addr; }
	public String getGrtr_nm1()		{ return grtr_nm1     ; }
	public String getGrtr_ssn1()	{ return grtr_ssn1    ; }
	public String getGrtr_rel1()	{ return grtr_rel1    ; }
	public String getGrtr_tel1()	{ return grtr_tel1    ; }
	public String getGrtr_addr1()	{ return grtr_addr1   ; }
	public String getGrtr_nm2()		{ return grtr_nm2     ; }
	public String getGrtr_ssn2()	{ return grtr_ssn2    ; }
	public String getGrtr_rel2()	{ return grtr_rel2    ; }
	public String getGrtr_tel2()	{ return grtr_tel2    ; }
	public String getGrtr_addr2()	{ return grtr_addr2   ; }
	public String getGrtr_nm3()		{ return grtr_nm3     ; }
	public String getGrtr_ssn3()	{ return grtr_ssn3    ; }
	public String getGrtr_rel3()	{ return grtr_rel3    ; }
	public String getGrtr_tel3()	{ return grtr_tel3    ; }
	public String getGrtr_addr3()	{ return grtr_addr3   ; }
	public String getFst_pay_dt()	{ return fst_pay_dt   ; }
	public int 	  getFst_pay_amt()	{ return fst_pay_amt  ; }
	public String getBond_get_st_sub(){return bond_get_st_sub;}
	public String getCls_rtn_dt()	{ return cls_rtn_dt   ; }
	public int	  getCls_rtn_amt()	{ return cls_rtn_amt;	}
	public int	  getCls_rtn_fee()	{ return cls_rtn_fee;	}
	public String getCls_rtn_cau()	{ return cls_rtn_cau;	}
	public String getNote()			{ return note;			}
	public String getLend_id()		{ return lend_id;		}
	public String getCpt_cd_st()	{ return cpt_cd_st;		}
	public String getCar_mng_id()	{ return car_mng_id;	}
	public String getLoan_st_dt()	{ return loan_st_dt;	}
	public int	  getLoan_sch_amt()	{ return loan_sch_amt;	}
	public int	  getPay_sch_amt()	{ return pay_sch_amt;	}
	public int    getDif_amt()		{ return dif_amt;		}
	public String getImsi_chk()		{ return imsi_chk;		}
	public String getRtn_seq()		{ return rtn_seq;		}
	public String getLoan_st()		{ return loan_st;		}
	public String getRimitter()		{ return rimitter;		}
	public String getCls_yn()		{ return cls_yn;		}
	public int    getLend_int_vat()	{ return lend_int_vat;	}
	public String getAutodoc_yn()	{ return autodoc_yn;	}
	public String getVen_code()		{ return ven_code;		}
	public String getBank_code()	{ return bank_code;		}
	public String getDeposit_no()	{ return deposit_no;	}
	public String getAcct_code()	{ return acct_code;		}
	public String getCls_rtn_fee_int()		{	return	cls_rtn_fee_int;	}
	public String getCls_rtn_etc	()		{	return	cls_rtn_etc;		}
	public String getFile_name		()		{	return  file_name;			}
	public String getFile_type		()		{	return  file_type;			}  
	public String getCms_code		()		{	return  cms_code;			}  
	public String getFund_id		()		{	return  fund_id;			}  	
	public String getAlt_etc()		{ return alt_etc;		}
	public int    getAlt_etc_amt()	{ return alt_etc_amt;	}
	public String getAlt_etc_tm()	{ return alt_etc_tm;	}

	
}