/**  명함관리- 금융권 상담이력 등록
 * 
 * @ author : Gill Sun Ryu
 * @ e-mail : 
 * @ create date : 2016. 05. 31
 * @ last modify date : 
 */
package acar.partner;

import java.util.*;

public class BizcardBean {
    //Table : Serv_EmpBean
    private String off_id;			//업체 아이디
	private String serv_id;			//상담 아이디
  	private int		seq_no;			//시퀀스
	private String gubun;			//구분
	private String sd_dt;			//상담일자
	private String g_smng1;			//거래처 상담자1
	private String g_smng2;			//2
	private String g_smng3;			//3
	private String d_smng1;			//본사 상담자 1
	private String d_smng2;			//2
	private String d_smng3;			//3
	private String item1;			//금리
	private String item2;			//한도
	private String note;			//기타
	private String reg_id;			//
	private String reg_dt;			//
	private String update_id;			//
	private String update_dt;			//

    // CONSTRCTOR            
public BizcardBean() {  
	this.off_id = "";
	this.serv_id = "";
	this.seq_no = 0;
	this.gubun = "";
	this.sd_dt = "";
	this.g_smng1 = "";
	this.g_smng2 = "";
	this.g_smng3 = "";
	this.d_smng1 = "";
	this.d_smng2 = "";
	this.d_smng3 = "";
	this.item1 = "";
	this.item2 = "";
	this.note = "";
	this.reg_id = "";
	this.reg_dt = "";
	this.update_id = "";
	this.update_dt = "";

	}

	// set Method
	public void setOff_id(String val){		if(val==null) val="";		this.off_id = val;		}
	public void setServ_id(String val){		if(val==null) val="";		this.serv_id = val;		}
	public void setSeq_no		(int val){								this.seq_no	= val;		}
	public void setGubun(String val){		if(val==null) val="";		this.gubun = val;		}
	public void setSd_dt(String val){		if(val==null) val="";		this.sd_dt = val;		}
	public void setG_smng1(String val){		if(val==null) val="";		this.g_smng1 = val;		}
	public void setG_smng2(String val){		if(val==null) val="";		this.g_smng2 = val;		}
	public void setG_smng3(String val){		if(val==null) val="";		this.g_smng3 = val;		}
	public void setD_smng1(String val){		if(val==null)val = "";		this.d_smng1 = val;		}
	public void setD_smng2(String val){		if(val==null)val = "";		this.d_smng2 = val;		}
	public void setD_smng3(String val){		if(val==null)val = "";		this.d_smng3 = val;		}
	public void setItem1(String val){		if(val==null)val = "";		this.item1 = val;		}
	public void setItem2(String val){		if(val==null)val = "";		this.item2 = val;		}
	public void setNote(String val){		if(val==null)val = "";		this.note = val;		}
	public void setReg_id(String val){		if(val==null)val = "";		this.reg_id = val;		}
	public void setReg_dt(String val){		if(val==null)val = "";		this.reg_dt = val;		}
	public void setUpdate_id(String val){		if(val==null)val = "";		this.update_id = val;		}
	public void setUpdate_dt(String val){		if(val==null)val = "";		this.update_dt = val;		}
				
	//Get Method
	public String 	getOff_id(){		return off_id;		}
	public int 		getSeq_no(){		return seq_no;		}
	public String	getServ_id(){		return serv_id;		}
	public String	getGubun(){			return gubun;		}
	public String	getSd_dt(){			return sd_dt;		}
	public String	getG_smng1(){		return g_smng1;		}
	public String	getG_smng2(){		return g_smng2;		}
	public String	getG_smng3(){		return g_smng3;		}
	public String	getD_smng1(){		return d_smng1;		}
	public String	getD_smng2(){		return d_smng2;		}
	public String	getD_smng3(){		return d_smng3;		}
	public String	getItem1(){			return item1;		}
	public String	getItem2(){			return item2;		}
	public String	getNote(){			return note;		}
	public String	getReg_id(){		return reg_id;		}
	public String	getReg_dt(){		return reg_dt;		}

	public String	getUpdate_id(){		return update_id;		}
	public String	getUpdate_dt(){		return update_dt;		}

}