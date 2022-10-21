package acar.fee;

public class FeeScdStopBean
{
	//세금계산서 발행 일시중지 관리 테이블

	private String rent_mng_id;		// 계약관리번호
	private String rent_l_cd;		// 계약번호    
	private String seq;				// 일련번호        
	private String stop_st;			// 중지구분:연체-1, 고객요청-2
	private String stop_s_dt;		// 중지기간
	private String stop_e_dt;		// 중지기간        
	private String stop_cau;		// 중지사유        
	private String stop_doc_dt;		// 내용증명발신일자
	private String stop_doc;		// 내용증명스캔파일명        
	private String stop_tax_dt;		// 일괄발행일자(고객요청시 분기내 마지막일자에 일괄자동발행일)        
	private String reg_dt;			// 등록일      
	private String reg_id;			// 등록자      
	private String cancel_dt;		// 해제일자        
	private String cancel_id;		// 해제등록자        
	private String doc_id;			// 해제등록자    
	private String rent_seq;		// 분할일련번호
	private String firm_nm;			// 분할고객
	
	public FeeScdStopBean()
	{
		rent_mng_id	= "";
		rent_l_cd 	= "";
		seq 		= "";
		stop_st 	= "";
		stop_s_dt 	= "";
		stop_e_dt 	= "";
		stop_cau 	= "";
		stop_doc_dt	= "";
		stop_doc 	= "";
		stop_tax_dt	= "";
		reg_dt 		= "";
		reg_id 		= "";
		cancel_dt 	= "";
		cancel_id 	= "";
		doc_id		= "";
		rent_seq	= "";
		firm_nm		= "";
	}
	
	public void setRent_mng_id	(String str)		{	rent_mng_id	= str;	}
	public void setRent_l_cd	(String str)		{	rent_l_cd 	= str;	}
	public void setSeq 			(String str)		{	seq 		= str;	}
	public void setStop_st 		(String str)		{	stop_st 	= str;	}
	public void setStop_s_dt	(String str)		{	stop_s_dt 	= str;	}
	public void setStop_e_dt	(String str)		{	stop_e_dt 	= str;	}
	public void setStop_cau		(String str)		{	stop_cau 	= str;	}
	public void setStop_doc_dt 	(String str)		{	stop_doc_dt = str;	}
	public void setStop_doc		(String str)		{	stop_doc 	= str;	}
	public void setStop_tax_dt	(String str)		{	stop_tax_dt = str;	}
	public void setReg_dt 		(String str)		{	reg_dt 		= str;	}
	public void setReg_id 		(String str)		{	reg_id 		= str;	}
	public void setCancel_dt	(String str)		{	cancel_dt 	= str;	}
	public void setCancel_id	(String str)		{	cancel_id 	= str;	}
	public void setDoc_id		(String str)		{	doc_id	 	= str;	}
	public void setRent_seq		(String str)		{	rent_seq	= str;	}
	public void setFirm_nm		(String str)		{	firm_nm		= str;	}
	
	public String getRent_mng_id()					{	return rent_mng_id;	}
	public String getRent_l_cd	()					{	return rent_l_cd;	}
	public String getSeq 		()					{	return seq;			}
	public String getStop_st 	()					{	return stop_st;		}
	public String getStop_s_dt	()					{	return stop_s_dt;	}
	public String getStop_e_dt	()					{	return stop_e_dt;	}
	public String getStop_cau	()					{	return stop_cau;	}
	public String getStop_doc_dt()					{	return stop_doc_dt;	}
	public String getStop_doc	()					{	return stop_doc;	}
	public String getStop_tax_dt()					{	return stop_tax_dt;	}
	public String getReg_dt 	()					{	return reg_dt;		}
	public String getReg_id 	()					{	return reg_id;		}
	public String getCancel_dt	()					{	return cancel_dt;	}
	public String getCancel_id	()					{	return cancel_id;	}
	public String getDoc_id		()					{	return doc_id;		}
	public String getRent_seq	()					{	return rent_seq;	}
	public String getFirm_nm	()					{	return firm_nm;		}
}
