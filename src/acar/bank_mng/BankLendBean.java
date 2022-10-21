package acar.bank_mng;

public class BankLendBean
{
	private String lend_id;				//�������ID        
	private String cont_dt;             //�����            
	private String cont_bn;             //�������          
	private String cont_st;             //��౸��          
	private String bn_br;               //��������          
	private String bn_tel;              //������ȭ��ȣ      
	private String bn_fax;              //�����ѽ���ȣ      
	private String lend_no;             //�����ȣ        
	private long cont_amt;          //����ݾ�  
	private int    lend_int_amt;        //��������          
	private String lend_int;            //��������          
	private int    rtn_tot_amt;         //��ȯ�ѱݾ�        
	private String cont_start_dt;       //��ȯ������        
	private String cont_end_dt;         //��ȯ������        
	private String cont_term;           //��ȯ����          
	private String rtn_est_dt;          //��ȯ������        
	private int    alt_amt;             //����ȯ�ݾ�        
	private String rtn_cdt;             //��ȯ����          
	private String rtn_way;             //��ȯ���          
	private String f_rat;               //��������          
	private String condi;               //����              
	private String docs;                //�����û���غ񼭷�
	private int    pm_amt;              //�����ݾ�          
	private long   lend_a_amt;          //������αݾ�      
	private long   pm_rest_amt;         //�����ܾ�          
 	private int    charge_amt;			//������
 	private int    ntrl_fee;			//������
 	private int    stp_fee;				//������
	private String bond_get_st;			//ä��Ȯ������
	private String fst_pay_dt;
  	private int    fst_pay_amt;
	//�߰� 2002.12.16
	private String cont_bn_st;			//�����籸��
	private String br_id;				//��翵����
	private String mng_id;				//�����
	private String cl_lim;				//�ŷ�ó����
	private String cl_lim_sub;			//������
	private String ps_lim;				//��������
	private String lend_amt_lim;		//����ݾ�����
	private String max_cltr_rat;		//�����缳��ä���ְ��
	private String lend_lim_st;			//�����û�Ⱓ����
	private String lend_lim_et;			//�����û�Ⱓ����
	private String cre_docs;			//ä�Ǿ絵�����༭
	private String note;				//��Ÿ
	private int    f_amt;				//�����ھ�
	private String f_start_dt;			//����Ⱓ
	private String f_end_dt;			//����Ⱓ
	private String rtn_st;				//��ȯ����
	private String bond_get_st_sub;		//ä��Ȯ������ ��Ÿ
	private String cls_rtn_condi;		//�ߵ���ȯ����
	private int    rtn_one_amt;			//1���Ͻû�ȯ
	private String rtn_one_dt;			//1���Ͻû�ȯ
	private int    rtn_two_amt;			//2�������һ�ȯ
	private int    rtn_cont_amt;		//����ݾ�-��ȯ
	private String move_st;				//���࿩��
	private String lend_lim;			//�����û�Ⱓ��������
	private String rtn_su;				//��ȯ����-���Ҽ�
	private String loan_start_dt;		//��ġ�Ⱓ
	private String loan_end_dt;			//��ġ�Ⱓ
	private String rtn_move_st;			//��ȯ���࿩��
	private String rtn_change;			//��ȯ���� �����ܾ����� ��ü���� ����
	private int    alt_pay_amt;			//��ȯ���޾�
	private String deposit_no;			//���¹�ȣ
	//2004.01.27 �߰�
	private String	autodoc_yn;			//�ڵ���ǥ ����
	private String	ven_code;			//�ŷ�ó�ڵ�
	private String	bank_code;			//�����ڵ�
	private String	deposit_no_d;		//���¹�ȣ
	private String	acct_code;			//��������
	//2011.08.11 �߰�
	private String	cls_rtn_fee_int;	//�ߵ���ȯ������
	private String	cls_rtn_etc;		//�ߵ���ȯ������ Ư�̻��� : �������� ���������� Ʋ�� ���
	private String  file_name;			//����������༭ ��ĵ����
	private String  file_type;			//��ĵ����
	//2011.11.23
	private String  fund_id;			//�ڱݰ����Ϸù�ȣ
	private long    l_rtn_tot_amt;         //��ȯ�ѱݾ�
	//20211104
	private String	p_bank_id;		//������ü�� ���¹�ȣ
	private String	p_bank_nm;		//������ü�� ���¹�ȣ
	private String	p_bank_no;		//������ü�� ���¹�ȣ



	public BankLendBean()
	{
		lend_id			= "";
		cont_dt			= "";
		cont_bn			= "";
		cont_st			= "";
		bn_br			= "";
		bn_tel			= "";
		bn_fax			= "";
		lend_no			= "";
		cont_amt		= 0;
		lend_int_amt	= 0;
		lend_int		= "";
		rtn_tot_amt		= 0;
		cont_start_dt	= "";
		cont_end_dt		= "";
		cont_term		= "";
		rtn_est_dt		= "";
		alt_amt			= 0;
		rtn_cdt			= "";
		rtn_way			= "";
		f_rat			= "";
		condi			= "";
		docs			= "";
		pm_amt			= 0;
		lend_a_amt		= 0;
		pm_rest_amt		= 0;
		charge_amt		= 0;
		ntrl_fee		= 0;
		stp_fee			= 0;
		bond_get_st		= "";
		fst_pay_dt		= "";
		fst_pay_amt		= 0;
		cont_bn_st		= "";
		br_id			= "";
		mng_id			= "";
		cl_lim			= "";
		cl_lim_sub		= "";
		ps_lim			= "";
		lend_amt_lim	= "";
		max_cltr_rat	= "";
		lend_lim_st		= "";
		lend_lim_et		= "";
		cre_docs		= "";
		note			= "";
		f_amt			= 0;
		f_start_dt		= "";
		f_end_dt		= "";
		rtn_st			= "";
		bond_get_st_sub	= "";
		cls_rtn_condi	= "";
		rtn_one_amt		= 0;
		rtn_one_dt		= "";
		rtn_two_amt		= 0;
		rtn_cont_amt	= 0;
		move_st			= "";
		lend_lim		= "";
		rtn_su			= "";
		loan_start_dt	="";
		loan_end_dt		= "";
		rtn_move_st		= "";
		rtn_change		= "";
		alt_pay_amt		= 0;
		deposit_no		= "";
		autodoc_yn		= "";
		ven_code		= "";
		bank_code		= "";
		deposit_no_d	= "";
		acct_code		= "";
		cls_rtn_fee_int	= "";
		cls_rtn_etc		= "";	
		file_name		= "";
		file_type		= "";
		fund_id			= "";
		l_rtn_tot_amt	= 0;
		p_bank_id	= "";
		p_bank_nm	= "";
		p_bank_no	= "";
		
}


	public void setLend_id			(String str)		{	lend_id			= str;	}
	public void setCont_dt			(String str)		{	cont_dt			= str;	}
	public void setCont_bn			(String str)		{	cont_bn			= str;	}
	public void setCont_st			(String str)		{	cont_st			= str;	}
	public void setBn_br			(String str)		{	bn_br			= str;	}
	public void setBn_tel			(String str)		{	bn_tel			= str;	}
	public void setBn_fax			(String str)		{	bn_fax			= str;	}
	public void setLend_no			(String str)		{	lend_no			= str;	}
	public void setCont_amt			(long i)			{	cont_amt		= i;	}
	public void setLend_int_amt		(int i)				{	lend_int_amt	= i;	}
	public void setLend_int			(String str)		{	lend_int		= str;	}
	public void setRtn_tot_amt		(int i)				{	rtn_tot_amt		= i;	}
	public void setCont_start_dt	(String str)		{	cont_start_dt	= str;	}
	public void setCont_end_dt		(String str)		{	cont_end_dt		= str;	}
	public void setCont_term		(String str)		{	cont_term		= str;	}
	public void setRtn_est_dt		(String str)		{	rtn_est_dt		= str;	}
	public void setAlt_amt			(int i)				{	alt_amt			= i;	}
	public void setRtn_cdt			(String str)		{	rtn_cdt			= str;	}
	public void setRtn_way			(String str)		{	rtn_way			= str;	}
	public void setF_rat			(String str)		{	f_rat			= str;	}
	public void setCondi			(String str)		{	condi			= str;	}
	public void setDocs				(String str)		{	docs			= str;	}
	public void setPm_amt			(int i)				{	pm_amt			= i;	}
	public void setLend_a_amt		(long i)			{	lend_a_amt		= i;	}
	public void setPm_rest_amt		(long i)			{	pm_rest_amt		= i;	}
	public void setCharge_amt		(int i)				{	charge_amt		= i;	}
	public void setNtrl_fee			(int i)				{	ntrl_fee		= i;	}
	public void setStp_fee			(int i)				{	stp_fee			= i;	}
	public void setBond_get_st		(String str)		{	bond_get_st		= str;	}
	public void setFst_pay_dt		(String str)		{	fst_pay_dt		= str;	}
	public void setFst_pay_amt		(int i)				{	fst_pay_amt		= i;	}
	public void setCont_bn_st		(String str)		{	cont_bn_st		= str;	}
	public void setBr_id			(String str)		{	br_id			= str;	}
	public void setMng_id			(String str)		{	mng_id			= str;	}
	public void setCl_lim			(String str)		{	cl_lim			= str;	}
	public void setCl_lim_sub		(String str)		{	cl_lim_sub		= str;	}
	public void setPs_lim			(String str)		{	ps_lim			= str;	}
	public void setLend_amt_lim		(String str)		{	lend_amt_lim	= str;	}
	public void setMax_cltr_rat		(String str)		{	max_cltr_rat	= str;	}
	public void setLend_lim_st		(String str)		{	lend_lim_st		= str;	}
	public void setLend_lim_et		(String str)		{	lend_lim_et		= str;	}
	public void setCre_docs			(String str)		{	cre_docs		= str;	}
	public void setNote				(String str)		{	note			= str;	}
	public void setF_amt			(int i)				{	f_amt			= i;	}
	public void setF_start_dt		(String str)		{	f_start_dt		= str;	}
	public void setF_end_dt			(String str)		{	f_end_dt		= str;	}
	public void setRtn_st			(String str)		{	rtn_st			= str;	}
	public void setBond_get_st_sub	(String str)		{	bond_get_st_sub	= str;	}
	public void setCls_rtn_condi	(String str)		{	cls_rtn_condi	= str;	}
	public void setRtn_one_amt		(int i)				{	rtn_one_amt		= i;	}
	public void setRtn_one_dt		(String str)		{	rtn_one_dt		= str;	}
	public void setRtn_two_amt		(int i)				{	rtn_two_amt		= i;	}
	public void setRtn_cont_amt		(int i)				{	rtn_cont_amt	= i;	}
	public void setMove_st			(String str)		{	move_st			= str;	}
	public void setLend_lim			(String str)		{	lend_lim		= str;	}
	public void setRtn_su			(String str)		{	rtn_su			= str;	}
	public void setLoan_start_dt	(String str)		{	loan_start_dt	= str;	}
	public void setLoan_end_dt		(String str)		{	loan_end_dt		= str;	}
	public void setRtn_move_st		(String str)		{	rtn_move_st		= str;	}
	public void setRtn_change		(String str)		{	rtn_change		= str;	}
	public void setAlt_pay_amt		(int i)				{	alt_pay_amt		= i;	}
	public void setDeposit_no		(String str)		{	deposit_no		= str;	}
	public void setAutodoc_yn		(String str)		{	autodoc_yn		= str;	}
	public void setVen_code			(String str)		{	ven_code		= str;	}
	public void setBank_code		(String str)		{	bank_code		= str;	}
	public void setDeposit_no_d		(String str)		{	deposit_no_d	= str;	}
	public void setAcct_code		(String str)		{	acct_code		= str;	}
	public void setCls_rtn_fee_int	(String str)		{	cls_rtn_fee_int = str;	}	
	public void setCls_rtn_etc		(String str)		{	cls_rtn_etc		= str;	}		
	public void setFile_name		(String str)		{	if(str==null) str="";	this.file_name	= str;	}	
	public void setFile_type		(String str)		{	if(str==null) str="";	this.file_type	= str;	}
	public void setFund_id			(String str)		{	fund_id			= str;	}		
	public void setL_rtn_tot_amt	(long i)			{	l_rtn_tot_amt	= i;	}
	public void setP_bank_id	    (String str)		{	p_bank_id		= str;	}
	public void setP_bank_nm	    (String str)		{	p_bank_nm		= str;	}
	public void setP_bank_no	    (String str)		{	p_bank_no		= str;	}
	
	  
	public String getLend_id		()		{	return	lend_id;			}	
	public String getCont_dt		()		{	return	cont_dt;			}
	public String getCont_bn		()		{	return	cont_bn;			}
	public String getCont_st		()		{	return	cont_st;			}
	public String getBn_br			()		{	return	bn_br;				}
	public String getBn_tel			()		{	return	bn_tel;				}
	public String getBn_fax			()		{	return	bn_fax;				}
	public String getLend_no		()		{	return	lend_no;			}
	public long   getCont_amt()			{ 	return       cont_amt;            }	
	public int    getLend_int_amt	()		{	return	lend_int_amt;		}
	public String getLend_int		()		{	return	lend_int;			}
	public int    getRtn_tot_amt	()		{	return	rtn_tot_amt;		}
	public String getCont_start_dt	()		{	return	cont_start_dt;		}
	public String getCont_end_dt	()		{	return	cont_end_dt;		}    
	public String getCont_term		()		{	return	cont_term;			}    
	public String getRtn_est_dt		()		{	return	rtn_est_dt;			}    
	public int    getAlt_amt		()		{	return	alt_amt;			}
	public String getRtn_cdt		()		{	return	rtn_cdt;			}
	public String getRtn_way		()		{	return	rtn_way;			}
	public String getF_rat			()		{	return	f_rat;				}
	public String getCondi			()		{	return	condi;				}
	public String getDocs			()		{	return	docs;				}
	public int    getPm_amt			()		{	return	pm_amt;				}
	public long   getLend_a_amt		()		{	return	lend_a_amt;			}
	public long   getPm_rest_amt	()		{	return	pm_rest_amt;		}
	public int    getCharge_amt		()		{	return	charge_amt;			}
	public int    getNtrl_fee		()		{	return	ntrl_fee;			}
	public int    getStp_fee		()		{	return	stp_fee;			}	
	public String getBond_get_st	()		{	return	bond_get_st;		}
	public String getFst_pay_dt		()		{	return	fst_pay_dt;			}
	public int    getFst_pay_amt	()		{	return	fst_pay_amt;		}
	public String getCont_bn_st		()		{	return	cont_bn_st;			}
	public String getBr_id			()		{	return	br_id;				}
	public String getMng_id			()		{	return	mng_id;				}
	public String getCl_lim			()		{	return	cl_lim;				}
	public String getCl_lim_sub		()		{	return	cl_lim_sub;			}
	public String getPs_lim			()		{	return	ps_lim;				}
	public String getLend_amt_lim	()		{	return	lend_amt_lim;		}
	public String getMax_cltr_rat	()		{	return	max_cltr_rat;		}
	public String getLend_lim_st	()		{	return 	lend_lim_st;		}
	public String getLend_lim_et	()		{	return 	lend_lim_et;		}
	public String getCre_docs		()		{	return 	cre_docs;			}
	public String getNote			()		{	return 	note;				}
	public int	  getF_amt			()		{	return 	f_amt;				}
	public String getF_start_dt		()		{	return 	f_start_dt;			}
	public String getF_end_dt		()		{	return 	f_end_dt;			}
	public String getRtn_st			()		{	return 	rtn_st;				}
	public String getBond_get_st_sub()		{	return 	bond_get_st_sub;	}
	public String getCls_rtn_condi	()		{	return 	cls_rtn_condi;		}
	public int    getRtn_one_amt	()		{	return 	rtn_one_amt;		}
	public String getRtn_one_dt		()		{	return 	rtn_one_dt;			}
	public int    getRtn_two_amt	()		{	return 	rtn_two_amt;		}
	public int    getRtn_cont_amt	()		{	return 	rtn_cont_amt;		}
	public String getMove_st		()		{	return	move_st;			}
	public String getLend_lim		()		{	return	lend_lim;			}
	public String getRtn_su			()		{	return	rtn_su;				}
	public String getLoan_start_dt	()		{	return	loan_start_dt;		}
	public String getLoan_end_dt	()		{	return	loan_end_dt;		}
	public String getRtn_move_st	()		{	return	rtn_move_st;		}
	public String getRtn_change		()		{	return	rtn_change;			}
	public int getAlt_pay_amt		()		{	return 	alt_pay_amt;		}
	public String getDeposit_no		()		{	return	deposit_no;			}
	public String getAutodoc_yn		()		{	return	autodoc_yn;			}
	public String getVen_code		()		{	return	ven_code;			}
	public String getBank_code		()		{	return	bank_code;			}
	public String getDeposit_no_d	()		{	return	deposit_no_d;		}
	public String getAcct_code		()		{	return	acct_code;			}
	public String getCls_rtn_fee_int()		{	return	cls_rtn_fee_int;	}
	public String getCls_rtn_etc	()		{	return	cls_rtn_etc;		}
	public String getFile_name		()		{	return  file_name;			}
	public String getFile_type		()		{	return  file_type;			}  
	public String getFund_id		()		{	return  fund_id;			}  
	public long   getL_rtn_tot_amt	()		{	return	l_rtn_tot_amt;		}
	public String getP_bank_id	    ()		{	return	p_bank_id;			}
	public String getP_bank_nm	    ()		{	return	p_bank_nm;			}
	public String getP_bank_no	    ()		{	return	p_bank_no;			}

}
