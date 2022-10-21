/**
 * 견적관리 내용
 */
package acar.esti_mng;

import java.util.*;


public class EstiContBean {
    //Table : ESTI_CONT
    private String  est_id;			//견적번호(년도2자리+월2자리+일2자리+'-'+일련번호4자리)
	private String  seq;			//일련번호
	private String  reg_dt;			//등록자
	private String  reg_id;			//등록일
    private String	title;			//제목
    private String	cont;			//내용
    private String  end_type;		//마감구분
    private String  nend_st;		//미체결구분
    private String  nend_cau;		//미체결사유
	private String  reg_time;

    // CONSTRCTOR            
    public EstiContBean() {  
    	this.est_id		= "";
    	this.seq		= "";
		this.reg_dt		= "";
    	this.reg_id		= "";
	    this.title		= "";
	    this.cont		= "";
	    this.end_type	= "";
	    this.nend_st	= "";
		this.nend_cau	= "";
		this.reg_time	= "";
	}

	// get Method
	public void setEst_id	(String val)	{	if(val==null) val="";	this.est_id		= val;	}
	public void setSeq		(String val)	{	if(val==null) val="";	this.seq		= val;	}
	public void setReg_dt	(String val)	{	if(val==null) val="";	this.reg_dt		= val;	}
	public void setReg_id	(String val)	{	if(val==null) val="";	this.reg_id		= val;	}
    public void setTitle	(String val)	{	if(val==null) val="";	this.title		= val;	}
    public void setCont		(String val)	{	if(val==null) val="";	this.cont		= val;	}
	public void setEnd_type	(String val)	{	if(val==null) val="";	this.end_type	= val;	}
    public void setNend_st	(String val)	{	if(val==null) val="";	this.nend_st	= val;	}
    public void setNend_cau	(String val)	{	if(val==null) val="";	this.nend_cau	= val;	}
    public void setReg_time	(String val)	{	if(val==null) val="";	this.reg_time	= val;	}
	
	//Get Method
	public String getEst_id		(){			return est_id;		}
	public String getSeq		(){			return seq;			}
    public String getReg_dt		(){			return reg_dt;		}
    public String getReg_id		(){			return reg_id;		}
	public String getTitle		(){			return title;		}
	public String getCont		(){			return cont;		}
    public String getEnd_type	(){			return end_type;	}
	public String getNend_st	(){			return nend_st;		}
	public String getNend_cau	(){			return nend_cau;	}
	public String getReg_time	(){			return reg_time;	}

}
