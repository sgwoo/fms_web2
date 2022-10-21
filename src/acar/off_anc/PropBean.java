/**
 * 공지사항을 제안함으로 수정
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.off_anc;

import java.util.*;

public class PropBean {
    //Table : PROP_BBS
    private int prop_id;
	private String user_id;
    private String user_nm;
    private String br_id;
    private String br_nm;
    private String dept_id;
    private String dept_nm;
	private String prop_step;
	private String reg_id;
    private String reg_dt;
    private String title;
	private String content;
	private String content1;	
	private String content2;	
	private String content3;	
	private String act_yn; //시행여부 - 채택에 안되도 시행가능 (FMS에 개발중인경우 등)
	private String act_dt;
	private String exp_dt;
	private int prize;
	private String use_yn;  //채택여부
	private String jigub_dt;  //지급일
	private int cnt1;
	private int cnt2;
	private int cnt3;
	private int cnt4;
	private int cnt5;
	private String	file_name1		;
	private String	file_name2		;
	private String	file_name3		;
	private int pp_amt;
	private int pe_amt;
	private String open_yn;

	private String day7;  //등록일+7일날짜 계산용
	
	private String eval_dt;
	private int jigub_amt; //지급액
	private int eval;  //제안평가점수
	private String eval_magam;  //평가마감
	private String public_yn;  //외부 공개 포
	
    // CONSTRCTOR            
    public PropBean() {  
    	this.prop_id = 0;
    	this.user_id = "";
    	this.user_nm = "";
    	this.br_id = "";
    	this.br_nm = "";
    	this.dept_id = "";
    	this.dept_nm = "";
		this.prop_step = "";
		this.reg_id = "";
		this.reg_dt = "";
	    this.title = "";
	    this.content = "";		
	    this.content1 = "";		
		this.content2 = "";		
		this.content3 = "";		
		this.act_yn = "";
		this.act_dt = "";
	    this.exp_dt = "";
		this.prize = 0;
		this.use_yn = "";
		this.jigub_dt = "";
		this.cnt1 = 0;
		this.cnt2 = 0;
		this.cnt3 = 0;
		this.cnt4 = 0;
		this.cnt5 = 0;
		this.file_name1 = "";
		this.file_name2 = "";
		this.file_name3 = "";
		
		this.pp_amt = 0;
		this.pe_amt = 0;
		this.open_yn = "";

		this.day7 = "";
		
		this.eval_dt = "";
		this.jigub_amt = 0;
		this.eval = 0;
		this.eval_magam = "";  
		this.public_yn = "";  
		
	}

	// set Method
	public void setProp_id(int val){									this.prop_id = val;		}
	public void setUser_id(String val){		if(val==null) val="";		this.user_id = val;		}	
	public void setUser_nm(String val){		if(val==null) val="";		this.user_nm = val;		}
	public void setBr_id(String val){		if(val==null) val="";		this.br_id = val;		}
	public void setBr_nm(String val){		if(val==null) val="";		this.br_nm = val;		}
	public void setDept_id(String val){		if(val==null) val="";		this.dept_id = val;		}
	public void setDept_nm(String val){		if(val==null) val="";		this.dept_nm = val;		}
	public void setProp_step(String val){	if(val==null) val="";		this.prop_step = val;	}
	public void setReg_id(String val){		if(val==null) val="";		this.reg_id = val;		}	
	public void setReg_dt(String val){		if(val==null) val="";		this.reg_dt = val;		}
	public void setTitle(String val){		if(val==null) val="";		this.title = val;		}
	public void setContent(String val){	if(val==null) val="";		this.content = val;	}
	public void setContent1(String val){	if(val==null) val="";		this.content1 = val;	}
	public void setContent2(String val){	if(val==null) val="";		this.content2 = val;	}
	public void setContent3(String val){	if(val==null) val="";		this.content3 = val;	}
	public void setAct_yn(String val){		if(val==null) val="";		this.act_yn = val;		}
	public void setAct_dt(String val){		if(val==null) val="";		this.act_dt = val;		}
	public void setExp_dt(String val){		if(val==null) val="";		this.exp_dt = val;		}
	public void setPrize(int val){										this.prize = val;		}
	public void setUse_yn(String val){		if(val==null) val="";		this.use_yn = val;		}
	public void setJigub_dt(String val){		if(val==null) val="";	this.jigub_dt = val;		}
	public void setCnt1(int val){										this.cnt1 = val;		}
	public void setCnt2(int val){										this.cnt2 = val;		}
	public void setCnt3(int val){										this.cnt3 = val;		}
	public void setCnt4(int val){										this.cnt4 = val;		}
	public void setCnt5(int val){										this.cnt5 = val;		}
	
	public void setFile_name1(String val){		if(val==null) val="";	this.file_name1 = val;		}
	public void setFile_name2(String val){		if(val==null) val="";	this.file_name2 = val;		}
	public void setFile_name3(String val){		if(val==null) val="";	this.file_name3 = val;		}
	
	public void setPp_amt(int val){										this.pp_amt = val;		}
	public void setPe_amt(int val){										this.pe_amt = val;		}
	public void setOpen_yn(String val){		if(val==null) val="";		this.open_yn = val;	}

	public void setDay7(String val){		if(val==null) val="";	this.day7 = val;		}
	
	public void setEval_dt(String val){		if(val==null) val="";	this.eval_dt = val;		}
	public void setJigub_amt(int val){									this.jigub_amt = val;		}
	public void setEval(int val){									this.eval = val;		}
	public void setEval_magam(String val){		if(val==null) val="";	this.eval_magam = val;		}
	public void setPublic_yn(String val){		if(val==null) val="";	this.public_yn = val;		}
	
	//Get Method
	public int    getProp_id(){		return prop_id;		}
	public String getUser_id(){		return user_id;		}
	public String getUser_nm(){		return user_nm;		}
	public String getBr_id(){		return br_id;		}
	public String getBr_nm(){		return br_nm;		}
	public String getDept_id(){		return dept_id;		}
	public String getDept_nm(){		return dept_nm;		}
	public String getProp_step(){	return prop_step;	}
	public String getReg_id(){		return reg_id;		}
	public String getReg_dt(){		return reg_dt;		}
	public String getTitle(){		return title;		}
	public String getContent(){	return content;	}
	public String getContent1(){	return content1;	}
	public String getContent2(){	return content2;	}
	public String getContent3(){	return content3;	}
	public String getAct_yn(){		return act_yn;		}
	public String getAct_dt(){		return act_dt;		}
	public String getExp_dt(){		return exp_dt;		}
	public int getPrize(){			return prize;		}
	public String getUse_yn(){		return use_yn;		}
	public String getJigub_dt(){	return jigub_dt;		}
	public int getCnt1(){			return cnt1;		}
	public int getCnt2(){			return cnt2;		}
	public int getCnt3(){			return cnt3;		}
	public int getCnt4(){			return cnt4;		}
	public int getCnt5(){			return cnt5;		}
	
	public String getFile_name1(){	return file_name1;		}
	public String getFile_name2(){	return file_name2;		}
	public String getFile_name3(){	return file_name3;		}
	
	public int getPp_amt(){			return pp_amt;		}
	public int getPe_amt(){			return pe_amt;		}
	public String getOpen_yn(){		return open_yn;		}

	public String getDay7(){		return day7;	}
	
	public String getEval_dt(){		return eval_dt;	}
	public int getJigub_amt(){		return jigub_amt;		}
	public int getEval(){		return eval;		}
	public String getEval_magam(){		return eval_magam;	}
	public String getPublic_yn(){		return public_yn;	}
	
}