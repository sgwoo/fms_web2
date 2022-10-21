/**
 * 관리담당
 * @ author : Gill Sun Ryu
 * @ e-mail : gillsun@empal.com
 * @ create date : 2009. 07. 01
 * @ last modify date : 
 */
package acar.cooperation;

import java.util.*;

public class CooperationBean {
    //Table : CooperationBean
	private int seq;
	private String in_id;
	private String in_dt;
	private String out_dt;
	private String out_id;
	private String title;
	private String content;
	private String out_content;
	private String sub_id;
	private String file_name1;
	private String file_name2;
	private String req_st;
	private String client_id;
	private String agnt_nm;
	private String agnt_m_tel;
	private String agnt_email;
	private String com_id;
	private int prop_id;
	private String cls_dt;
	private String sub_dt;
        
    // CONSTRCTOR            
    public CooperationBean() {
		this.seq			= 0;
		this.in_id			= "";
		this.in_dt			= "";
		this.out_dt			= "";
		this.out_id			= "";
		this.title			= "";
		this.content		= "";
		this.out_content	= "";
		this.sub_id			= "";
		this.file_name1		= "";
		this.file_name2		= "";
		this.req_st			= "";
		this.client_id		= "";
		this.agnt_nm		= "";
		this.agnt_m_tel		= "";
		this.agnt_email		= "";
		this.com_id			= "";
		this.prop_id		= 0;  //제안함에서 이관 
		this.cls_dt			= "";
		this.sub_dt			= "";

	}

	// Set Method
	public void setSeq			(int    val)	{							this.seq			= val; }
	public void setIn_id		(String val)	{	if(val==null)	val=""; this.in_id			= val; }
	public void setIn_dt		(String val)	{	if(val==null)	val=""; this.in_dt			= val; }
	public void setOut_dt		(String val)	{	if(val==null)	val=""; this.out_dt			= val; }
	public void setOut_id		(String val)	{	if(val==null)	val=""; this.out_id			= val; }
	public void setTitle		(String val)	{	if(val==null)	val="";	this.title			= val; }
	public void setContent		(String val)	{	if(val==null)	val=""; this.content		= val; }
	public void setOut_content	(String val)	{	if(val==null)	val=""; this.out_content	= val; }
	public void setSub_id		(String val)	{	if(val==null)	val="";	this.sub_id			= val; }
	public void setFile_name1	(String val)	{	if(val==null)	val="";	this.file_name1		= val;	}
	public void setFile_name2	(String val)	{	if(val==null)	val="";	this.file_name2		= val;	}
	public void setReq_st		(String val)	{	if(val==null)	val="";	this.req_st			= val;	}
	public void setClient_id	(String val)	{	if(val==null)	val="";	this.client_id		= val;	}
	public void setAgnt_nm		(String val)	{	if(val==null)	val="";	this.agnt_nm		= val;	}    
	public void setAgnt_m_tel	(String val)	{	if(val==null)	val="";	this.agnt_m_tel		= val;	}  
	public void setAgnt_email	(String val)	{	if(val==null)	val="";	this.agnt_email		= val;	}
	public void setCom_id		(String val)	{	if(val==null)	val="";	this.com_id		= val;	}
	public void setProp_id 		(int    val)	{							this.prop_id			= val; }
	public void setCls_dt		(String val)	{	if(val==null)	val=""; this.cls_dt			= val; }
	public void setSub_dt		(String val)	{	if(val==null)	val=""; this.sub_dt			= val; }

	
	// Get Method
	public int    getSeq		()	{	return seq;			}
	public String getIn_id		()	{	return in_id;		}
	public String getIn_dt		()	{	return in_dt;		}
	public String getOut_dt		()	{	return out_dt;		}
	public String getOut_id		()	{	return out_id;		}
	public String getTitle		()	{	return title;		}
	public String getContent	()	{	return content;		}
	public String getOut_content()	{	return out_content;	}
	public String getSub_id		()	{	return sub_id;		}
	public String getFile_name1	()	{	return file_name1;  }  
	public String getFile_name2	()	{	return file_name2;  }  
	public String getReq_st		()	{	return req_st;		}
	public String getClient_id	()	{	return client_id; 	}
	public String getAgnt_nm	()	{	return agnt_nm;   	}
	public String getAgnt_m_tel	()	{	return agnt_m_tel;	}
	public String getAgnt_email	()	{	return agnt_email;	}
	public String getCom_id		()	{	return com_id; 		}
	public int    getProp_id	()	{	return prop_id;		}
	public String getCls_dt		()	{	return cls_dt;		}
	public String getSub_dt		()	{	return sub_dt;		}

}