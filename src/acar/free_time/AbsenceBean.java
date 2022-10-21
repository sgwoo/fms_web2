/**
 * ÈÞÁ÷ÇöÈ² 
 * @ author : Gill Sun Ryu
 * @ e-mail : koobuk@gmail.com
 * @ create date : 2015-10-02
 * @ last modify date : 
 */
package acar.free_time;

import java.util.*;

public class AbsenceBean {
    //Table : 	AbsenceBean;

	private String doc_id;
	private int		seq;
	private String gubun;
	private String start_dt;
	private String end_dt;
	private String jse_dt;
	private String jse_mng;
	private String jss_dt;
	private String jss_mng;


        
    // CONSTRCTOR            
    public AbsenceBean() {  

		this.doc_id = "";
		this.seq = 0;
		this.gubun = "";
		this.start_dt = "";
		this.end_dt = "";
		this.jse_dt = "";
		this.jse_mng = "";
		this.jss_dt = "";
		this.jss_mng = "";

	}

	// get Method
	public void setDoc_id	(String val)	{	if(val==null)	val=""; this.doc_id  = val;		}
	public void setSeq		(int val)		{							this.seq = val;			}
	public void setGubun	(String val)	{	if(val==null)	val="";	this.gubun = val;		}
	public void setStart_dt	(String val)	{	if(val==null)	val="";	this.start_dt = val;	}
	public void setEnd_dt	(String val)	{	if(val==null)	val="";	this.end_dt = val;		}
	public void setJse_dt	(String val)	{	if(val==null)	val="";	this.jse_dt = val;		}
	public void setJse_mng	(String val)	{	if(val==null)	val="";	this.jse_mng = val;		}
	public void setJss_dt	(String val)	{	if(val==null)	val="";	this.jss_dt = val;		}
	public void setJss_mng	(String val)	{	if(val==null)	val="";	this.jss_mng = val;		}


	//Get Method

	public String	getDoc_id()		{		return doc_id;		}
	public int		getSeq()		{		return seq;			}
	public String	getGubun()		{		return gubun;		}
	public String	getStart_dt ()	{		return start_dt;	}
	public String	getEnd_dt()		{		return end_dt;		}
	public String	getJse_dt()		{		return jse_dt;		}
	public String	getJse_mng()	{		return jse_mng;		}
	public String	getJss_dt()		{		return jss_dt;		}
	public String	getJss_mng()	{		return jss_mng;		}
	
}

