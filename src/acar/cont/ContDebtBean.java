package acar.cont;

public class ContDebtBean
{
	private String rent_mng_id;     // ��������ȣ            
	private String rent_l_cd;       // ����ȣ                
	private String allot_st;        // ����                    
	private String cpt_cd;          // �������                
	private String lend_int;        // ��������                
	private int    lend_prn;        // �������                
	private int    alt_fee;         // �Һμ�����              
	private int    rtn_tot_amt;     // ��ȯ�ѱݾ�              
	private String loan_debtor;     // ��ȯ�ǹ���              
	private String rtn_cdt;         // ��ȯ����                
	private String rtn_way;         // ��ȯ���                
	private String rtn_est_dt;      // ��ȯ������              
	private String lend_no;         // �����ȣ                
	private int    ntrl_fee;        // ������                  
	private int    stp_fee;         // ������                  
	private String lend_dt;         // ��������                
	private int    lend_int_amt;    // ��������                 
	private int    alt_amt;         // �Һαݾ�                
	private String tot_alt_tm;      // �Һ�Ƚ��                
	private String alt_start_dt;    // �ҺαⰣ_������          
	private String alt_end_dt;      // �ҺαⰣ_����           
	private String bond_get_st;     // ä��Ȯ������            
	private String bond_st;         // ä������                
	private String loan_con_nm;     // Loan �����_�̸�        
	private String loan_con_ssn;    // Loan �����_�ֹε�Ϲ�ȣ 
	private String loan_con_rel;    // Loan �����_����         
	private String loan_con_tel;    // Loan �����_����ó       
	private String loan_con_addr;   // Loan �����_�ּ�         
	private String grtr_nm1;        // ���뺸����1_�̸�        
	private String grtr_ssn1;       // ���뺸����1_�ֹε�Ϲ�ȣ
	private String grtr_rel1;       // ���뺸����1_����        
	private String grtr_tel1;       // ���뺸����1_����ó      
	private String grtr_addr1;      // ���뺸����1_�ּ�        
	private String grtr_nm2;        // ���뺸����2_�̸�        
	private String grtr_ssn2;       // ���뺸����2_�ֹε�Ϲ�ȣ
	private String grtr_rel2;       // ���뺸����2_����        
	private String grtr_tel2;       // ���뺸����2_����ó      
	private String grtr_addr2;      // ���뺸����2_�ּ�        
	private String grtr_nm3;        // ���뺸����3_�̸�        
	private String grtr_ssn3;       // ���뺸����3_�ֹε�Ϲ�ȣ
	private String grtr_rel3;       // ���뺸����3_����        
	private String grtr_tel3;       // ���뺸����3_����ó      
	private String grtr_addr3;      // ���뺸����3_�ּ�        
	private String fst_pay_dt;      // 1ȸ�� ��ȯ�ݾ�          
	private int    fst_pay_amt;     // 1ȸ��������   
	private String bond_get_st_sub;	//ä��Ȯ������-��Ÿ
	private String cls_rtn_dt;		//�ߵ��Ͻû�ȯ��
	private int	   cls_rtn_amt;		//�ߵ���ȯ��
	private int	   cls_rtn_fee;		//�ߵ���ȯ������
//	private int	   cls_rtn_int_amt;	//�ߵ���ȯ�������
//	private String cls_rtn_int;		//�ߵ���ȯ������
	private String cls_rtn_cau;		//�ߵ���ȯ����
	private String note;			//��Ÿ
	private String lend_id;			//���������ȣ
	private String cpt_cd_st;		//������ ����
	private String car_mng_id;		//�ڵ���������ȣ
	private String loan_st_dt;		//�����û��
	private int    loan_sch_amt;	//���⿹��ݾ�
	private int    pay_sch_amt;		//���⿹��ݾ�
	private int	   dif_amt;			//�����Աݾ�
	private String imsi_chk;		//����������ȣ �ӽ��ڵ� üũ
	private String rtn_seq;			//��ȯ��ȣ
	private String loan_st;			//��ȯ����(1:��������, 2:����������)
	private String rimitter;		//�۱�ó
	private String cls_yn;			//�ߵ����� ��/��
	//2003.07.11 �߰�
	private int	lend_int_vat;		//�Һ����� �ΰ���
	//2004.01.27 �߰�
	private String	autodoc_yn;		//�ڵ���ǥ ����
	private String	ven_code;		//�ŷ�ó�ڵ�
	private String	bank_code;		//�����ڵ�
	private String	deposit_no;		//���¹�ȣ
	private String	acct_code;		//��������
	//2011.08.11 �߰�
	private String	cls_rtn_fee_int;	//�ߵ���ȯ������
	private String	cls_rtn_etc;		//�ߵ���ȯ������ Ư�̻��� : �������� ���������� Ʋ�� ���
	private String  file_name;			//����������༭ ��ĵ����
	private String  file_type;			//��ĵ����
	//cms ����ڵ� (���߱���ڵ��뿡 ���� : ������ ����:9951572587,  ��ȯ:      (20131113 ����)
	private String  cms_code;			//cms  ����ڵ�
	private String  fund_id;			//�ڱݰ�����ȣ
	
	private String alt_etc;     	 // ��Ÿ��볻��
	private int    alt_etc_amt;      // ��Ÿ���ݾ�
	private String alt_etc_tm;       // ��Ÿ���ȸ��
	                                
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