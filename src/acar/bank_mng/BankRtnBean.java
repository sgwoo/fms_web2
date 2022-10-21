package acar.bank_mng;

public class BankRtnBean
{
	private String lend_id;
	private String seq;
	private long   rtn_tot_amt;         //상환총금액        
	private String cont_start_dt;       //상환개시일        
	private String cont_end_dt;         //상환만료일        
	private String cont_term;           //상환개월          
	private String rtn_est_dt;          //상환약정일        
	private int    alt_amt;             //월상환금액        
	private String rtn_cdt;             //상환조건          
	private String rtn_way;             //상환방법          
	private String cls_rtn_condi;		//중도상환조건
	private int    rtn_one_amt;			//1차일시상환
	private String rtn_one_dt;			//1차일시상환
	private int    rtn_two_amt;			//2차장기분할상환
	private String fst_pay_dt;			//1회차결제일
  	private int    fst_pay_amt;			//1회차상환금액
  	private long   rtn_cont_amt;		//대출금액
	private String loan_start_dt;		//대출기간
	private String loan_end_dt;			//대출기간
	private String rtn_move_st;			//진행여부
	private String cls_yn;				//해지여부
	private String deposit_no;			//계좌번호
	private String ven_code;				//거래처코드
		
	public BankRtnBean()
	{
		lend_id	= "";
		seq		= "";
		rtn_tot_amt	= 0;
		cont_start_dt= "";
		cont_end_dt	= "";
		cont_term	= "";
		rtn_est_dt	= "";
		alt_amt		= 0;
		rtn_cdt		= "";
		rtn_way		= "";
		cls_rtn_condi= "";
		rtn_one_amt	= 0;
		rtn_one_dt	= "";
		rtn_two_amt	= 0;
		fst_pay_dt	= "";
		fst_pay_amt	= 0;
		rtn_cont_amt= 0;
		loan_start_dt="";
		loan_end_dt	= "";
		rtn_move_st = "";
		cls_yn		= "";
		deposit_no	= "";
		ven_code	= "";
	}
	
	public void setLend_id			(String str)	{	lend_id			= str;	}
	public void setSeq				(String str)	{	seq				= str;	}
	public void setRtn_tot_amt		(long i)		{	rtn_tot_amt		= i;	}
	public void setCont_start_dt	(String str)	{	cont_start_dt	= str;	}
	public void setCont_end_dt		(String str)	{	cont_end_dt		= str;	}
	public void setCont_term		(String str)	{	cont_term		= str;	}
	public void setRtn_est_dt		(String str)	{	rtn_est_dt		= str;	}
	public void setAlt_amt			(int i)			{	alt_amt			= i;	}
	public void setRtn_cdt			(String str)	{	rtn_cdt			= str;	}
	public void setRtn_way			(String str)	{	rtn_way			= str;	}
	public void setCls_rtn_condi	(String str)	{	cls_rtn_condi	= str;	}
	public void setRtn_one_amt		(int i)			{	rtn_one_amt		= i;	}
	public void setRtn_one_dt		(String str)	{	rtn_one_dt		= str;	}
	public void setRtn_two_amt		(int i)			{	rtn_two_amt		= i;	}
	public void setFst_pay_dt		(String str)	{	fst_pay_dt		= str;	}
	public void setFst_pay_amt		(int i)			{	fst_pay_amt		= i;	}
	public void setRtn_cont_amt		(long i)		{	rtn_cont_amt	= i;	}
	public void setLoan_start_dt	(String str)	{	loan_start_dt	= str;	}
	public void setLoan_end_dt		(String str)	{	loan_end_dt		= str;	}
	public void setRtn_move_st		(String str)	{	rtn_move_st		= str;	}
	public void setCls_yn			(String str)	{	cls_yn			= str;	}
	public void setDeposit_no		(String str)	{	deposit_no		= str;	}
	public void setVen_code			(String str)	{	ven_code		= str;	}
	
	public String getLend_id		(){	return	lend_id;		} 
	public String getSeq			(){	return	seq;			} 
	public long   getRtn_tot_amt	(){	return	rtn_tot_amt;	}
	public String getCont_start_dt	(){	return	cont_start_dt;	}
	public String getCont_end_dt	(){	return	cont_end_dt;	}    
	public String getCont_term		(){	return	cont_term;		}    
	public String getRtn_est_dt		(){	return	rtn_est_dt;		}    
	public int    getAlt_amt		(){	return	alt_amt;		}
	public String getRtn_cdt		(){	return	rtn_cdt;		}
	public String getRtn_way		(){	return	rtn_way;		}
	public String getCls_rtn_condi	(){	return 	cls_rtn_condi;	}
	public int    getRtn_one_amt	(){	return 	rtn_one_amt;	}
	public String getRtn_one_dt		(){	return 	rtn_one_dt;		}
	public int    getRtn_two_amt	(){	return 	rtn_two_amt;	}
	public String getFst_pay_dt		(){	return	fst_pay_dt;		}
	public int    getFst_pay_amt	(){	return	fst_pay_amt;	}
	public long   getRtn_cont_amt	(){	return	rtn_cont_amt;	}
	public String getLoan_start_dt	(){	return	loan_start_dt;	}
	public String getLoan_end_dt	(){	return	loan_end_dt;	}
	public String getRtn_move_st	(){	return	rtn_move_st;	}
	public String getCls_yn			(){	return	cls_yn;			}
	public String getDeposit_no		(){	return	deposit_no;		}
	public String getVen_code		(){	return  ven_code;		}

}