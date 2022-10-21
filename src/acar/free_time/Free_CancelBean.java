/**
 * 년차신청
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2009. 03. 27
 * @ last modify date : 
 */
package acar.free_time;

import java.util.*;

public class Free_CancelBean {
    //Table : 	Free_CancelBean;

	private String doc_no;
	private int		can_seq;
	private String user_id;
	private String reg_dt;
	private String cancel_dt;
	private String cancel_tit;
	private String cancel_cmt;
	private String cm_check;


        
    // CONSTRCTOR            
    public Free_CancelBean() {  

		this.doc_no = "";
		this.can_seq = 0;
		this.user_id = "";
		this.reg_dt = "";
		this.cancel_dt = "";
		this.cancel_tit = "";
		this.cancel_cmt = "";
		this.cm_check = "";

	}

	// get Method
	public void setDoc_no		(String val)	{	if(val==null)	val=""; this.doc_no  = val;			}
	public void setCan_seq		(int val)		{							this.can_seq = val;			}
	public void setUser_id		(String val)	{	if(val==null)	val="";	this.user_id = val;			}
	public void setReg_dt		(String val)	{	if(val==null)	val="";	this.reg_dt = val;			}
	public void setCancel_dt	(String val)	{	if(val==null)	val="";	this.cancel_dt = val;		}
	public void setCancel_tit	(String val)	{	if(val==null)	val="";	this.cancel_tit = val;		}
	public void setCancel_cmt	(String val)	{	if(val==null)	val="";	this.cancel_cmt = val;		}
	public void setCm_check		(String val)	{	if(val==null)	val="";	this.cm_check = val;			}


	//Get Method

	public String	getDoc_no()			{		return doc_no;		}
	public int		getCan_seq()		{		return can_seq;		}
	public String	getUser_id()		{		return user_id;		}
	public String	getReg_dt ()		{		return reg_dt;		}
	public String	getCancel_dt()		{		return cancel_dt;	}
	public String	getCancel_tit()		{		return cancel_tit;	}
	public String	getCancel_cmt()		{		return cancel_cmt;	}
	public String	getCm_check()		{		return cm_check;	}
	
}

