/**
 * 공지사항
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.off_anc;

import java.util.*;

public class Bbs_FBean {
    //Table : Bbs_FBean
    private int bbs_id;
    private String reg_id;
    private String reg_dt;
	private String d_user_nm;
    private String d_br_id;
    private String d_br_nm;
    private String d_dept_id;
    private String d_dept_nm;
    private String d_user_h_tel;
    private String title;
    private String d_user_id;	
	private String d_day_st;
	private String d_day_ed;
	private String place_nm;
	private String place_tel;
	private String place_addr;
	private String chief_nm;
	private String d_day_place;
	private String family_relations;
	private String deceased_nm;
	private String deceased_day;
	private String title_st;
		
	
    // CONSTRCTOR            
    public Bbs_FBean() {  
    	this.bbs_id = 0;
    	this.reg_id = "";
	    this.reg_dt = "";
		this.d_user_nm = "";
    	this.d_br_id = "";
    	this.d_br_nm = "";
    	this.d_dept_id = "";
    	this.d_dept_nm = "";
		this.d_user_h_tel = "";
	    this.title = "";
	    this.d_user_id = "";		
		this.d_day_st = "";
		this.d_day_ed = "";
		this.place_nm = "";
		this.place_tel = "";
		this.place_addr = "";
		this.chief_nm = "";
		this.d_day_place = "";
		this.family_relations = "";
		this.deceased_nm = "";
		this.deceased_day = "";
		this.title_st = "";
	

	}

	// set Method
	public void setBbs_id(int val)				{		this.bbs_id = val;											}
	public void setReg_id(String val)			{		if(val==null) val="";		this.reg_id = val;				}
	public void setReg_dt(String val)			{		if(val==null) val="";		this.reg_dt = val;				}
	public void setD_user_nm(String val)		{		if(val==null) val="";		this.d_user_nm = val;			}
	public void setD_br_id(String val)			{		if(val==null) val="";		this.d_br_id = val;				}
	public void setD_br_nm(String val)			{		if(val==null) val="";		this.d_br_nm = val;				}
	public void setD_dept_id(String val)		{		if(val==null) val="";		this.d_dept_id = val;			}
	public void setD_dept_nm(String val)		{		if(val==null) val="";		this.d_dept_nm = val;			}
	public void setD_user_h_tel(String val)		{		if(val==null) val="";		this.d_user_h_tel = val;		}
	public void setTitle(String val)			{		if(val==null) val="";		this.title = val;				}
	public void setD_user_id(String val)		{		if(val==null) val="";		this.d_user_id = val;			}
	public void setD_day_st(String val)			{		if(val==null) val="";		this.d_day_st = val;			}
	public void setD_day_ed(String val)			{		if(val==null) val="";		this.d_day_ed = val;			}
	public void setPlace_nm(String val)			{		if(val==null) val="";		this.place_nm = val;			}
	public void setPlace_tel(String val)		{		if(val==null) val="";		this.place_tel = val;			}
	public void setPlace_addr(String val)		{		if(val==null) val="";		this.place_addr = val;			}
	public void setChief_nm(String val)			{		if(val==null) val="";		this.chief_nm = val;			}
	public void setD_day_place(String val)		{		if(val==null) val="";		this.d_day_place = val;			}
	public void setFamily_relations(String val)	{		if(val==null) val="";		this.family_relations = val;	}
	public void setDeceased_nm(String val)		{		if(val==null) val="";		this.deceased_nm = val;			}
	public void setDeceased_day(String val)		{		if(val==null) val="";		this.deceased_day = val;		}
	public void setTitle_st(String val)			{		if(val==null) val="";		this.title_st = val;			}
	
	
	//Get Method
	public int getBbs_id()				{		return bbs_id;				}
	public String getReg_id()			{		return reg_id;				}
	public String getReg_dt()			{		return reg_dt;				}
	public String getD_user_nm()		{		return d_user_nm;			}
	public String getD_br_id()			{		return d_br_id;				}
	public String getD_br_nm()			{		return d_br_nm;				}
	public String getD_dept_id()		{		return d_dept_id;			}
	public String getD_dept_nm()		{		return d_dept_nm;			}
	public String getD_user_h_tel()		{		return d_user_h_tel;		}
	public String getTitle()			{		return title;				}
	public String getD_user_id()		{		return d_user_id;			}
	public String getD_day_st()			{		return d_day_st;			}
	public String getD_day_ed()			{		return d_day_ed;			}
	public String getPlace_nm()			{		return place_nm;			}
	public String getPlace_tel()		{		return place_tel;			}
	public String getPlace_addr()		{		return place_addr;			}
	public String getChief_nm()			{		return chief_nm;			}
	public String getD_day_place()		{		return d_day_place;			}
	public String getFamily_relations()	{		return family_relations;	}
	public String getDeceased_nm()		{		return deceased_nm;			}
	public String getDeceased_day()		{		return deceased_day;		}
	public String getTitle_st()			{		return title_st;			}
	
}