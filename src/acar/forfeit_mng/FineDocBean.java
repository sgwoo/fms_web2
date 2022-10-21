package acar.forfeit_mng;

import java.util.*;

public class FineDocBean {
    //Table : fine_doc (과태료 이의신청공문)
	private String doc_id; 					
	private String doc_dt;
	private String gov_id;
	private String mng_dept;
	private String print_dt;
	private String print_id;
	private String reg_id;
	private String reg_dt;
	private String upd_id;
	private String upd_dt;
	private String gov_st;
	private String mng_nm;
	private String mng_pos;
	private String h_mng_id;
	private String b_mng_id;
	private String app_doc1;
	private String app_doc2;
	private String app_doc3;
	private String app_doc4;
	//20070521 최고장관련추가
	private String gov_nm;
	private String gov_nm2;
	private String gov_addr;
	private String title;
	private String end_dt;
	private String filename;
	private String app_doc5;
	private int	   i_amt;
	private String post_num; //등기번호
	private String f_result; //내용증명 반송 결과
	private String f_reason; //내용증명 반송 사유
	private String gov_zip; //우편번호
	private String regyn;
	private String app_docs; //첨부문서들

	private int		amt1;
	private int		amt2;
	private String req_dt;
	private String ip_dt;
	private String s_dt;
	private String e_dt;
	private String remarks;

	private String scd_yn;		//대출금 상환스케쥴 등록 여부 확인
	private String cms_code;	         //cms 기관코드	
	private String cltr_rat;	         //근저당설정률	
	private int	   cltr_amt;    //건당 설정금액
	private String cltr_chk;    //공동.개별 구분
	private String off_id;	     //대출담당자	
	private int	   seq;    //대출담당자
	private String app_dt;    //대출승인일 - 카드할부인경우
	private String	card_yn;    //카드할부여부
	private String	fund_yn;    //리스자금 여부 
        
    // CONSTRCTOR            
    public FineDocBean() {  
		this.doc_id		= ""; 					
		this.doc_dt		= "";
		this.gov_id		= "";
		this.mng_dept	= "";
		this.print_dt	= "";
		this.print_id	= "";
		this.reg_id		= "";
		this.reg_dt		= "";
		this.upd_id		= "";
		this.upd_dt		= "";
		this.gov_st		= "";
		this.mng_nm		= "";
		this.mng_pos	= "";
		this.h_mng_id	= "";
		this.b_mng_id	= "";
		this.app_doc1	= "";
		this.app_doc2	= "";
		this.app_doc3	= "";
		this.app_doc4	= "";
		this.gov_nm		= "";
		this.gov_nm2		= "";
		this.gov_addr	= "";
		this.title		= "";
		this.end_dt		= "";
		this.filename	= "";
		this.app_doc5	= "";
		this.i_amt		= 0;
		this.post_num	= "";
		this.f_result	= "";
		this.f_reason	= "";
		this.gov_zip	= "";
		this.regyn="";
		this.app_docs	= "";

		this.amt1 = 0;
		this.amt2 = 0;
		this.req_dt ="";
		this.ip_dt = "";
		
		this.s_dt = "";
		this.e_dt = "";
		this.remarks = "";

		this.scd_yn = "";
		this.cms_code = "";
		this.cltr_rat = "";
		this.cltr_amt = 0;
		this.cltr_chk = "";
		this.off_id = "";
		this.seq = 0;
		this.app_dt	= "";
		this.card_yn	= "";
		this.fund_yn	= "";
	}
	// get Method
	public void setDoc_id	(String val){		if(val==null) val="";	this.doc_id		= val;	}
	public void setDoc_dt	(String val){		if(val==null) val="";	this.doc_dt		= val;	}
	public void setGov_id	(String val){		if(val==null) val="";	this.gov_id		= val;	}	
	public void setMng_dept	(String val){		if(val==null) val="";	this.mng_dept	= val;	}	
	public void setPrint_dt	(String val){		if(val==null) val="";	this.print_dt	= val;	}	
	public void setPrint_id	(String val){		if(val==null) val="";	this.print_id	= val;	}	
	public void setReg_id	(String val){		if(val==null) val="";	this.reg_id		= val;	}	
	public void setReg_dt	(String val){		if(val==null) val="";	this.reg_dt		= val;	}	
	public void setUpd_id	(String val){		if(val==null) val="";	this.upd_id		= val;	}	
	public void setUpd_dt	(String val){		if(val==null) val="";	this.upd_dt		= val;	}	
	public void setGov_st	(String val){		if(val==null) val="";	this.gov_st		= val;	}	
	public void setMng_nm	(String val){		if(val==null) val="";	this.mng_nm		= val;	}	
	public void setMng_pos	(String val){		if(val==null) val="";	this.mng_pos	= val;	}	
	public void setH_mng_id	(String val){		if(val==null) val="";	this.h_mng_id	= val;	}	
	public void setB_mng_id	(String val){		if(val==null) val="";	this.b_mng_id	= val;	}	
	public void setApp_doc1	(String val){		if(val==null) val="";	this.app_doc1	= val;	}	
	public void setApp_doc2	(String val){		if(val==null) val="";	this.app_doc2	= val;	}	
	public void setApp_doc3	(String val){		if(val==null) val="";	this.app_doc3	= val;	}	
	public void setApp_doc4	(String val){		if(val==null) val="";	this.app_doc4	= val;	}	
	public void setGov_nm	(String val){		if(val==null) val="";	this.gov_nm		= val;	}
	public void setGov_nm2	(String val){		if(val==null) val="";	this.gov_nm2		= val;	}
	public void setGov_addr (String val){		if(val==null) val="";	this.gov_addr	= val;	}	
	public void setTitle	(String val){		if(val==null) val="";	this.title		= val;	}	
	public void setEnd_dt	(String val){		if(val==null) val="";	this.end_dt		= val;	}	
	public void setFilename	(String val){		if(val==null) val="";	this.filename	= val;	}	
	public void setApp_doc5	(String val){		if(val==null) val="";	this.app_doc5	= val;	}	
	public void setI_amt	(int val){									this.i_amt		= val;	}	
	public void setPost_num	(String val){		if(val==null) val="";	this.post_num	= val;	}	
	public void setF_result	(String val){		if(val==null) val="";	this.f_result	= val;	}	
	public void setF_reason	(String val){		if(val==null) val="";	this.f_reason	= val;	}	
	public void setGov_zip (String val){		if(val==null) val="";	this.gov_zip	= val;	}	
	public void setRegyn (String val){			if(val==null) val="";	this.regyn	= val;	}
	public void setApp_docs	(String val){		if(val==null) val="";	this.app_docs	= val;	}	

	public void setAmt1	(int val){									this.amt1		= val;	}	
	public void setAmt2	(int val){									this.amt2		= val;	}	
	public void setReq_dt	(String val){		if(val==null) val="";	this.req_dt	= val;	}	
	public void setIp_dt	(String val){		if(val==null) val="";	this.ip_dt	= val;	}	
	
	public void setS_dt	(String val){		if(val==null) val="";	this.s_dt	= val;	}	
	public void setE_dt	(String val){		if(val==null) val="";	this.e_dt	= val;	}	
	public void setRemarks	(String val){		if(val==null) val="";	this.remarks = val;	}	

	public void setScd_yn	(String val){		if(val==null) val="";	this.scd_yn	= val;	}	
	public void setCms_code	(String val){		if(val==null) val="";	this.cms_code	= val;	}	
	
	public void setCltr_rat	(String val){		if(val==null) val="";	this.cltr_rat	= val;	}	
	public void setCltr_amt	(int val){									this.cltr_amt		= val;	}	
	public void setCltr_chk	(String val){		if(val==null) val="";	this.cltr_chk	= val;	}	
	
	public void setOff_id	(String val){		if(val==null) val="";	this.off_id	= val;	}	
	public void setSeq	(int val){									this.seq		= val;	}	
	
	public void setApp_dt	(String val){		if(val==null) val="";	this.app_dt	= val;	}	
	public void setCard_yn	(String val){		if(val==null) val="";	this.card_yn	= val;	}	
	public void setFund_yn	(String val){		if(val==null) val="";	this.fund_yn	= val;	}	
	
	//Get Method
	public String getDoc_id		(){		return doc_id; 		}
	public String getDoc_dt		(){		return doc_dt;   	}
	public String getGov_id		(){		return gov_id;   	}	
	public String getMng_dept	(){		return mng_dept; 	}	
	public String getPrint_dt	(){		return print_dt; 	}	
	public String getPrint_id	(){		return print_id; 	}	
	public String getReg_id		(){		return reg_id;   	}	
	public String getReg_dt		(){		return reg_dt;   	}	
	public String getUpd_id		(){		return upd_id;   	}	
	public String getUpd_dt		(){		return upd_dt;   	}	
	public String getGov_st		(){		return gov_st;		}
	public String getMng_nm		(){		return mng_nm;		}	
	public String getMng_pos	(){		return mng_pos;		}
	public String getH_mng_id	(){		return h_mng_id;	}	
	public String getB_mng_id	(){		return b_mng_id;	}
	public String getApp_doc1	(){		return app_doc1;	}
	public String getApp_doc2	(){		return app_doc2;	}	
	public String getApp_doc3	(){		return app_doc3;	}
	public String getApp_doc4	(){		return app_doc4;	}	
	public String getGov_nm		(){		return gov_nm;   	}	
	public String getGov_nm2		(){		return gov_nm2;   	}	
	public String getGov_addr	(){		return gov_addr;   	}	
	public String getTitle		(){		return title;   	}	
	public String getEnd_dt		(){		return end_dt;   	}	
	public String getFilename	(){		return filename;   	}	
	public String getApp_doc5	(){		return app_doc5;	}	
	public int    getI_amt		(){		return i_amt;		}	
	public String getPost_num	(){		return post_num;	}	
	public String getF_result	(){		return f_result;	}	
	public String getF_reason	(){		return f_reason;	}	
	public String getGov_zip	(){		return gov_zip;		}	
	public String getRegyn		(){		return regyn;		}	
	public String getApp_docs	(){		return app_docs;	}	

	public int    getAmt1		(){		return amt1;		}	
	public int    getAmt2		(){		return amt2;		}	
	public String getReq_dt		(){		return req_dt;		}	
	public String getIp_dt		(){		return ip_dt;		}	
	
	public String getS_dt		(){			return s_dt;		}	
	public String getE_dt		(){		return e_dt;		}	
	public String getRemarks		(){		return remarks;		}	

	public String getScd_yn		(){			return scd_yn;		}	
	public String getCms_code	(){			return cms_code;		}	
	
	public String getCltr_rat	(){			return cltr_rat;		}	
	public int    getCltr_amt		(){		return cltr_amt;		}	
	public String getCltr_chk	(){			return cltr_chk;		}	
	
	public String getOff_id	(){			return off_id;		}	
	public int    getSeq		(){		return seq;		}	
	
	public String getApp_dt	(){			return app_dt;		}	
	public String getCard_yn	(){			return card_yn;		}	
	public String getFund_yn	(){			return fund_yn;		}	
	
}


