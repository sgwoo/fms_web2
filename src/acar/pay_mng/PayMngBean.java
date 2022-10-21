package acar.pay_mng;

import java.util.*;

public class PayMngBean {

    //Table : pay ��ݿ���
	private String	reqseq;					//�Ϸù�ȣ
	private String	p_est_dt;				//������Ÿ��������
	private String	p_gubun;				//����׸�	
    private String	p_way;					//��ݹ��(����,����,�ڵ���ü,����ī��,�ĺ�ī��,ī���Һ�)
    private String	p_cd1;					//�ڵ�1
    private String	p_cd2;					//�ڵ�2
    private String	p_cd3;					//�ڵ�3
    private String	p_cd4;					//�ڵ�4
	private String	p_cd5;					//�ڵ�5
	private String	p_cd6;					//�ڵ�6
    private String	p_st1;					//����1
    private String	p_st2;					//����2
    private String	p_st3;					//����3
    private String	p_st4;					//����4
    private String	p_st5;					//����5
	private String	p_cont;					//����
	private String	off_st;					//����ó����
	private String	off_id;					//����ó������ȣ
	private String	off_nm;					//����ó�̸�
	private String	ven_code;				//�׿����ŷ�ó�ڵ�
	private String	ven_name;				//�׿����ŷ�ó��
	private long	amt;					//�����ѱݾ�
	private String	bank_nm;				//����ó(�Ա�)-�����
	private String	bank_no;				//����ó(�Ա�)-���¹�ȣ
	private String	reg_dt;					//�����
	private String	reg_id;					//�����
	private String	reg_st;					//��ϱ���(��ȸ,����)
	private String	p_pay_dt;				//��������
	private String	doc_code;				//�����ڵ�
	private String	p_step;					//����
	private String	p_gubun_etc;			//����׸��Ÿ����
	private String	acct_code;				//��������
	private String	bank_id;				//����ó(�Ա�)-�����ڵ�
	private String	p_req_dt;				//��û����
	private String	r_est_dt;				//��������
	private String	a_bank_id;				//�Ƹ���ī(���)-�����ڵ�
	private String	a_bank_nm;				//�Ƹ���ī(���)-�����
	private String	a_bank_no;				//�Ƹ���ī(���)-���¹�ȣ
	private String	a_pay_dt;				//�������
	private String  autodocu_write_date;	//��ǥ����
	private String  autodocu_data_no;		//��ǥ��ȣ
	private String	pay_code;				//���ó���ڵ�
	private long	sub_amt1;				//��Ÿ�ݾ�1
	private long	sub_amt2;				//��Ÿ�ݾ�2
	private long	sub_amt3;				//��Ÿ�ݾ�3
	private long	sub_amt4;				//��Ÿ�ݾ�4
	private long	sub_amt5;				//��Ÿ�ݾ�5
	private long	sub_amt6;				//��Ÿ�ݾ�6
	private String	card_id;				//�Ƹ���īī���ڵ�
	private String	card_nm;				//�Ƹ���īī���
	private String	card_no;				//�Ƹ���īī���ȣ
	private String	bank_code;				//�۱��ڵ�
	private String	buy_user_id;			//�����
	private String	buy_user_nm;			//�����
	private String	ven_st;					//����ó����
	private String	tax_yn;					//���ݰ�꼭����
	private String	savepath;				//÷�����ϰ��
	private String	filename1;				//÷������1
	private String	filename2;				//÷������2
	private String	filename3;				//÷������3
	private String	filename4;				//÷������4
	private String	filename5;				//÷������5
	private String  acct_code_g;			//�������� ����1
	private String  acct_code_g2;			//�������� ����2
	private String  o_cau;					//�������� ��� ����	
	private String  call_t_nm;				//�����̿���
	private String  call_t_tel;				//����ó
	private String  call_t_chk;				//�縮�� ������ ����
	private String  user_su;				//�ο���
	private String  user_cont;				//�����ο�
	private String	acct_code2;				//��������
	private String	acct_code3;				//��������
	private String	acct_code4;				//��������
	private String	acct_code5;				//��������
	private String	s_idno;					//����ڹ�ȣ
	private String	r_acct_code;			//�ǰ�������
	private String  autodocu_data_gubun;	//��ǥ����
	private int		m_amt;					//������ݾ�
	private String	m_cau;					//���������
	private long	s_amt;
	private long	v_amt;
	private long	i_amt;
	private long	i_s_amt;
	private long	i_v_amt;
	private int		i_seq;
	private int		u_seq;
	private String	search_code;
	private String	acct_code_st;
	private String	cash_acc_no;			//���ݿ��������ι�ȣ
	private String	accid_reg_yn;			//����ĵ�Ͽ���
	private String	serv_reg_yn;			//�����ĵ�Ͽ���
	private String	maint_reg_yn;			//�˻��ĵ�Ͽ���
	private String	bank_acc_nm;			//����ó(�Ա�)-�����ָ�
	private String	cost_gubun;				//��뱸��
	private String	actrs_code;				//�۱ݰ���ڵ�
	private int		commi;					//�۱ݼ�����
	private String	bank_cms_bk;			//����ó(�Ա�)-�����ڵ�
	private String	a_bank_cms_bk;			//����ó(���)-�����ڵ�
	private String	off_tel;				//����ó����ó
	private String	p_est_dt2;				//���⿹������
	private String	at_once;				//��ÿ���
	private String	act_union_yn;			//���տ���
    private String  m_doc_code;    
    private int		tot_dist;				//����Ÿ�


	public PayMngBean() {  
		reqseq				= "";
		p_est_dt			= "";
		p_gubun				= "";
		p_way				= "";
		p_cd1				= "";
		p_cd2				= "";
		p_cd3				= "";
		p_cd4				= "";
		p_cd5				= "";
		p_cd6				= "";
		p_st1				= "";
		p_st2				= "";
		p_st3				= "";
		p_st4				= "";
		p_st5				= "";
		p_cont				= "";
		off_st				= "";
		off_id				= "";
		off_nm				= "";
		ven_code			= "";
		ven_name			= "";
		amt					= 0;
		bank_nm				= "";
		bank_no				= "";
		reg_dt				= "";
		reg_id				= "";
		reg_st				= "";
		p_pay_dt			= "";
		doc_code			= "";
		p_step				= "";
		p_gubun_etc			= "";
		acct_code			= "";
		bank_id				= "";
		p_req_dt			= "";
		r_est_dt			= "";
		a_bank_id			= "";
		a_bank_nm			= "";
		a_bank_no			= "";
		a_pay_dt			= "";
		autodocu_write_date	= "";
		autodocu_data_no	= "";
		pay_code			= "";
		sub_amt1			= 0;
		sub_amt2			= 0;
		sub_amt3			= 0;
		sub_amt4			= 0;
		sub_amt5			= 0;
		sub_amt6			= 0;
		card_id				= "";
		card_nm				= "";
		card_no				= "";
		bank_code			= "";
		buy_user_id			= "";
		buy_user_nm			= "";
		ven_st				= "";		
		tax_yn				= "";	
		savepath			= "";	
		filename1			= "";	
		filename2			= "";	
		filename3			= "";	
		filename4			= "";	
		filename5			= "";	
		acct_code_g			= "";	
		acct_code_g2		= "";	
		o_cau				= "";	
		call_t_nm			= "";	
		call_t_tel			= "";	
		call_t_chk			= "";	
		user_su				= "";	
		user_cont			= "";	
		acct_code2			= "";	
		acct_code3			= "";	
		acct_code4			= "";	
		acct_code5			= "";	
		s_idno				= "";
		autodocu_data_gubun	= "";
		r_acct_code			= "";	
		m_amt				= 0;
		m_cau				= "";
		s_amt				= 0;
		v_amt				= 0;
		i_amt				= 0;
		i_s_amt				= 0;
		i_v_amt				= 0;
		i_seq				= 0;
		u_seq				= 0;
		search_code			= "";	
		acct_code_st		= "";	
		cash_acc_no			= "";
		accid_reg_yn		= "";
		serv_reg_yn			= "";
		maint_reg_yn		= "";
		bank_acc_nm			= "";
		cost_gubun			= "";
		actrs_code			= "";
		commi				= 0;
		bank_cms_bk			= "";
		a_bank_cms_bk		= "";
		off_tel				= "";
		p_est_dt2			= "";
		at_once				= "";
		act_union_yn		= "";
		m_doc_code			= "";
		tot_dist			= 0;

	}


	// set Method
	public void setReqseq				(String str){	reqseq				= str;	}
	public void setP_est_dt				(String str){	p_est_dt			= str;	}
	public void setP_gubun				(String str){	p_gubun				= str;	}
	public void setP_way				(String str){	p_way				= str;	}
	public void setP_cd1				(String str){	p_cd1				= str;	}
	public void setP_cd2				(String str){	p_cd2				= str;	}
	public void setP_cd3				(String str){	p_cd3				= str;	}
	public void setP_cd4				(String str){	p_cd4				= str;	}
	public void setP_cd5				(String str){	p_cd5				= str;	}
	public void setP_cd6				(String str){	p_cd6				= str;	}
	public void setP_st1				(String str){	p_st1				= str;	}
	public void setP_st2				(String str){	p_st2				= str;	}
	public void setP_st3				(String str){	p_st3				= str;	}
	public void setP_st4				(String str){	p_st4				= str;	}
	public void setP_st5				(String str){	p_st5				= str;	}
	public void setP_cont				(String str){	p_cont				= str;	}
	public void setOff_st				(String str){	off_st				= str;	}
	public void setOff_id				(String str){	off_id				= str;	}
	public void setOff_nm				(String str){	off_nm				= str;	}
	public void setVen_code				(String str){	ven_code			= str;	}
	public void setVen_name				(String str){	ven_name			= str;	}
	public void setAmt					(long     i){	amt					= i;	}
	public void setBank_nm				(String str){	bank_nm				= str;	}
	public void setBank_no				(String str){	bank_no				= str;	}
	public void setReg_dt				(String str){	reg_dt				= str;	}
	public void setReg_id				(String str){	reg_id				= str;	}
	public void setReg_st				(String str){	reg_st				= str;	}
	public void setP_pay_dt				(String str){	p_pay_dt			= str;	}
	public void setDoc_code				(String str){	doc_code			= str;	}
	public void setP_step				(String str){	p_step				= str;	}
	public void setP_gubun_etc			(String str){	p_gubun_etc			= str;	}
	public void setAcct_code			(String str){	acct_code			= str;	}
	public void setBank_id				(String str){	bank_id				= str;	}
	public void setP_req_dt				(String str){	p_req_dt			= str;	}
	public void setR_est_dt				(String str){	r_est_dt			= str;	}	
	public void setA_bank_id			(String str){	a_bank_id			= str;	}
	public void setA_bank_nm			(String str){	a_bank_nm			= str;	}
	public void setA_bank_no			(String str){	a_bank_no			= str;	}
	public void setA_pay_dt				(String str){	a_pay_dt			= str;	}
	public void setAutodocu_write_date	(String str){	autodocu_write_date	= str;	}
	public void setAutodocu_data_no		(String str){	autodocu_data_no	= str;	}
	public void setPay_code				(String str){	pay_code			= str;	}
	public void setSub_amt1				(long     i){	sub_amt1			= i;	}
	public void setSub_amt2				(long     i){	sub_amt2			= i;	}
	public void setSub_amt3				(long     i){	sub_amt3			= i;	}
	public void setSub_amt4				(long     i){	sub_amt4			= i;	}
	public void setSub_amt5				(long     i){	sub_amt5			= i;	}
	public void setSub_amt6				(long     i){	sub_amt6			= i;	}
	public void setCard_id				(String str){	card_id				= str;	}
	public void setCard_nm				(String str){	card_nm				= str;	}
	public void setCard_no				(String str){	card_no				= str;	}
	public void setBank_code			(String str){	bank_code			= str;	}
	public void setBuy_user_id			(String str){	buy_user_id			= str;	}
	public void setBuy_user_nm			(String str){	buy_user_nm			= str;	}
	public void setVen_st				(String str){	ven_st				= str;	}
	public void setTax_yn				(String str){	tax_yn				= str;	}
	public void setSavepath				(String str){	savepath			= str;	}
	public void setFilename1			(String str){	filename1			= str;	}
	public void setFilename2			(String str){	filename2			= str;	}
	public void setFilename3			(String str){	filename3			= str;	}
	public void setFilename4			(String str){	filename4			= str;	}	
	public void setFilename5			(String str){	filename5			= str;	}
	public void setAcct_code_g			(String str){	acct_code_g			= str;	}
	public void setAcct_code_g2			(String str){	acct_code_g2		= str;	}
	public void setO_cau				(String str){	o_cau				= str;	}
	public void setCall_t_nm			(String str){	call_t_nm			= str;	}
	public void setCall_t_tel			(String str){	call_t_tel			= str;	}
	public void setCall_t_chk			(String str){	call_t_chk			= str;	}
	public void setUser_su				(String str){	user_su				= str;	}
	public void setUser_cont			(String str){	user_cont			= str;	}
	public void setAcct_code2			(String str){	acct_code2			= str;	}
	public void setAcct_code3			(String str){	acct_code3			= str;	}
	public void setAcct_code4			(String str){	acct_code4			= str;	}
	public void setAcct_code5			(String str){	acct_code5			= str;	}
	public void setS_idno				(String str){	s_idno				= str;	}
	public void setAutodocu_data_gubun	(String str){	autodocu_data_gubun	= str;	}
	public void setR_acct_code			(String str){	r_acct_code			= str;	}
	public void setM_amt				(int      i){	m_amt				= i;	}
	public void setM_cau				(String str){	m_cau				= str;	}
	public void setS_amt				(long     i){	s_amt				= i;	}
	public void setV_amt				(long     i){	v_amt				= i;	}
	public void setI_amt				(long     i){	i_amt				= i;	}
	public void setI_s_amt				(long     i){	i_s_amt				= i;	}
	public void setI_v_amt				(long     i){	i_v_amt				= i;	}
	public void setI_seq				(int      i){	i_seq				= i;	}
	public void setU_seq				(int      i){	u_seq				= i;	}
	public void setSearch_code			(String str){	search_code			= str;	}
	public void setAcct_code_st			(String str){	acct_code_st		= str;	}
	public void setCash_acc_no			(String str){	cash_acc_no			= str;	}
	public void setAccid_reg_yn			(String str){	accid_reg_yn		= str;	}
	public void setServ_reg_yn			(String str){	serv_reg_yn			= str;	}
	public void setMaint_reg_yn			(String str){	maint_reg_yn		= str;	}
	public void setBank_acc_nm			(String str){	bank_acc_nm			= str;	}
	public void setCost_gubun			(String str){	cost_gubun			= str;	}
	public void setActrs_code			(String str){	actrs_code			= str;	}
	public void setCommi				(int      i){	commi				= i;	}
	public void setBank_cms_bk			(String str){	bank_cms_bk			= str;	}
	public void setA_bank_cms_bk		(String str){	a_bank_cms_bk		= str;	}
	public void setOff_tel				(String str){	off_tel				= str;	}
	public void setP_est_dt2			(String str){	p_est_dt2			= str;	}
	public void setAt_once				(String str){	at_once				= str;	}
	public void setAct_union_yn			(String str){	act_union_yn		= str;	}
	public void setM_doc_code			(String str){	m_doc_code			= str;	}
	public void setTot_dist				(int      i){	tot_dist			= i;	}
	



	
	//Get Method
	public String getReqseq				(){		return reqseq;					}
	public String getP_est_dt			(){		return p_est_dt;				}
	public String getP_gubun			(){		return p_gubun;					}
	public String getP_way				(){		return p_way;					}
	public String getP_cd1				(){		return p_cd1;					}
	public String getP_cd2				(){		return p_cd2;					}
	public String getP_cd3				(){		return p_cd3;					}
	public String getP_cd4				(){		return p_cd4;					}
	public String getP_cd5				(){		return p_cd5;					}
	public String getP_cd6				(){		return p_cd6;					}
	public String getP_st1				(){		return p_st1;					}
	public String getP_st2				(){		return p_st2;					}
	public String getP_st3				(){		return p_st3;					}
	public String getP_st4				(){		return p_st4;					}
	public String getP_st5				(){		return p_st5;					}
	public String getP_cont				(){		return p_cont;					}
	public String getOff_st				(){		return off_st;					}
	public String getOff_id				(){		return off_id;					}
	public String getOff_nm				(){		return off_nm;					}
	public String getVen_code			(){		return ven_code;				}
	public String getVen_name			(){		return ven_name;				}
	public long   getAmt				(){		return amt;						}
	public String getBank_nm			(){		return bank_nm;					}
	public String getBank_no			(){		return bank_no;					}
	public String getReg_dt				(){		return reg_dt;					}
	public String getReg_id				(){		return reg_id;					}
	public String getReg_st				(){		return reg_st;					}
	public String getP_pay_dt			(){		return p_pay_dt;				}
	public String getDoc_code			(){		return doc_code;				}
	public String getP_step				(){		return p_step;					}
	public String getP_gubun_etc		(){		return p_gubun_etc;				}
	public String getAcct_code			(){		return acct_code;				}
	public String getBank_id			(){		return bank_id;					}
	public String getP_req_dt			(){		return p_req_dt;				}
	public String getR_est_dt			(){		return r_est_dt;				}
	public String getA_bank_id			(){		return a_bank_id;				}
	public String getA_bank_nm			(){		return a_bank_nm;				}
	public String getA_bank_no			(){		return a_bank_no;				}
	public String getA_pay_dt			(){		return a_pay_dt;				}
	public String getAutodocu_write_date(){		return	autodocu_write_date;	}
	public String getAutodocu_data_no	(){		return	autodocu_data_no;		}
	public String getPay_code			(){		return pay_code;				}
	public long   getSub_amt1			(){		return sub_amt1;				}
	public long   getSub_amt2			(){		return sub_amt2;				}
	public long   getSub_amt3			(){		return sub_amt3;				}
	public long   getSub_amt4			(){		return sub_amt4;				}
	public long   getSub_amt5			(){		return sub_amt5;				}
	public long   getSub_amt6			(){		return sub_amt6;				}
	public String getCard_id			(){		return card_id;					}
	public String getCard_nm			(){		return card_nm;					}
	public String getCard_no			(){		return card_no;					}
	public String getBank_code			(){		return bank_code;				}
	public String getBuy_user_id		(){		return buy_user_id;				}
	public String getBuy_user_nm		(){		return buy_user_nm;				}
	public String getVen_st				(){		return ven_st;					}
	public String getTax_yn				(){		return tax_yn;					}
	public String getSavepath			(){		return savepath;				}
	public String getFilename1			(){		return filename1;				}
	public String getFilename2			(){		return filename2;				}
	public String getFilename3			(){		return filename3;				}
	public String getFilename4			(){		return filename4;				}
	public String getFilename5			(){		return filename5;				}
	public String getAcct_code_g		(){		return acct_code_g;				}
	public String getAcct_code_g2		(){		return acct_code_g2;			}
	public String getO_cau				(){		return o_cau;					}
	public String getCall_t_nm			(){		return call_t_nm;				}
	public String getCall_t_tel			(){		return call_t_tel;				}
	public String getCall_t_chk			(){		return call_t_chk;				}
	public String getUser_su			(){		return user_su;					}
	public String getUser_cont			(){		return user_cont;				}
	public String getAcct_code2			(){		return acct_code2;				}
	public String getAcct_code3			(){		return acct_code3;				}
	public String getAcct_code4			(){		return acct_code4;				}
	public String getAcct_code5			(){		return acct_code5;				}
	public String getS_idno				(){		return s_idno;					}
	public String getAutodocu_data_gubun(){		return autodocu_data_gubun;		}
	public String getR_acct_code		(){		return r_acct_code;				}
	public int    getM_amt				(){		return m_amt;					}
	public String getM_cau				(){		return m_cau;					}
	public long   getS_amt				(){		return s_amt;					}
	public long   getV_amt				(){		return v_amt;					}
	public long   getI_amt				(){		return i_amt;					}
	public long   getI_s_amt			(){		return i_s_amt;					}
	public long   getI_v_amt			(){		return i_v_amt;					}
	public int    getI_seq				(){		return i_seq;					}
	public int    getU_seq				(){		return u_seq;					}
	public String getSearch_code		(){		return search_code;				}
	public String getAcct_code_st		(){		return acct_code_st;			}
	public String getCash_acc_no		(){		return cash_acc_no;				}
	public String getAccid_reg_yn		(){		return accid_reg_yn;			}
	public String getServ_reg_yn		(){		return serv_reg_yn;				}
	public String getMaint_reg_yn		(){		return maint_reg_yn;			}
	public String getBank_acc_nm		(){		return bank_acc_nm;				}
	public String getCost_gubun			(){		return cost_gubun;				}
	public String getActrs_code			(){		return actrs_code;				}
	public int    getCommi				(){		return commi;					}
	public String getBank_cms_bk		(){		return bank_cms_bk;				}
	public String getA_bank_cms_bk		(){		return a_bank_cms_bk;			}
	public String getOff_tel			(){		return off_tel;					}
	public String getP_est_dt2			(){		return p_est_dt2;				}
	public String getAt_once			(){		return at_once;					}
	public String getAct_union_yn		(){		return act_union_yn;			}
	public String getM_doc_code			(){		return m_doc_code;				}
	public int    getTot_dist			(){		return tot_dist;				}
	

}
