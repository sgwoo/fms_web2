/**
 * 사장님과 직원간 메세지 프로그램
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2004. 2. 17. 화.
 * @ last modify date : - 20040528;고객접속화면개발시 정비예약신청하면 메세지로 보여주기 위해 ires(고객정비예약테이블)와 연결위해
 *									rent_mng_id, rent_l_cd, ires_id추가(Foreign Key)
 */

package acar.memo;

import java.util.*;

public class MemoBean {
	//memo	메세지
	private String memo_id;		//메세지번호
	private String dept_id;		//부서번호
	private String send_id;		//보낸사람id
	private String rece_id;		//받는사람id
	private String title;		//메세지제목
	private String content;		//메세지내용
	private String memo_dt;		//메세지작성일자
	private String rece_yn;		//수신여부
	private String rent_mng_id;	
	private String rent_l_cd;
	private String ires_id;
	private String anonym_yn;	//익명발송여부
	private String anrece_yn;	//익명받기여부
	        
    public MemoBean() {
		this.memo_id = "";
		this.dept_id = "";
		this.send_id = "";
		this.rece_id = "";
		this.title = "";
		this.content = "";
		this.memo_dt = "";
		this.rece_yn = "";
		this.rent_mng_id = "";
		this.rent_l_cd = "";
		this.ires_id = "";
		this.anonym_yn = "";
		this.anrece_yn = "";
	}

	public void setMemo_id		(String val){ if(val==null) val=""; this.memo_id		= val.trim(); }
	public void setDept_id		(String val){ if(val==null) val=""; this.dept_id		= val.trim(); }
	public void setSend_id		(String val){ if(val==null) val=""; this.send_id		= val.trim(); }
	public void setRece_id		(String val){ if(val==null) val=""; this.rece_id		= val.trim(); }
	public void setTitle		(String val){ if(val==null) val=""; this.title			= val.trim(); }
	public void setContent		(String val){ if(val==null) val=""; this.content		= val.trim(); }
	public void setMemo_dt		(String val){ if(val==null) val=""; this.memo_dt		= val.trim(); }
	public void setRece_yn		(String val){ if(val==null) val=""; this.rece_yn		= val.trim(); }
	public void setRent_mng_id	(String val){ if(val==null) val=""; this.rent_mng_id	= val.trim(); }
	public void setRent_l_cd	(String val){ if(val==null) val=""; this.rent_l_cd		= val.trim(); }
	public void setIres_id		(String val){ if(val==null) val=""; this.ires_id		= val.trim(); }
	public void setAnonym_yn	(String val){ if(val==null) val=""; this.anonym_yn		= val.trim(); }
	public void setAnrece_yn	(String val){ if(val==null)	val="";	this.anrece_yn		= val.trim(); }
	
	public String getMemo_id	(){ return memo_id;		}
	public String getDept_id	(){ return dept_id;		}
	public String getSend_id	(){ return send_id;		}
	public String getRece_id	(){ return rece_id;		}
	public String getTitle		(){ return title;		}
	public String getContent	(){ return content;		}
	public String getMemo_dt	(){ return memo_dt;		}
	public String getRece_yn	(){ return rece_yn;		}
	public String getRent_mng_id(){ return rent_mng_id; }
	public String getRent_l_cd	(){ return rent_l_cd;	}
	public String getIres_id	(){ return ires_id;		}
	public String getAnonym_yn	(){ return anonym_yn;	}
	public String getAnrece_yn	(){	return anrece_yn;	}

}