package acar.client;

public class ClientSiteBean
{
	//Table : CLIENT_SITE
	private String client_id;
	private String seq;	
	private String r_site;
	private String reg_dt;
	private String reg_id;	
	private String site_st;
	private String site_jang;
	private String enp_no;
	private String bus_cdt;
	private String bus_itm;
	private String open_year;
	private String tel;
	private String fax;
	private String zip;
	private String addr;
	private String agnt_nm;
	private String agnt_tel;
	private String ven_code;
	private String upd_id;
	private String upd_dt;
	private int l_cnt;

	private String agnt_m_tel	= "";
	private String agnt_fax		= "";
	private String agnt_email	= "";
	private String agnt_dept	= "";
	private String agnt_title	= "";
	private String item_mail_yn	= "";
	private String tax_mail_yn	= "";
	private String taxregno		= "";
	private String bigo_value	= "";
	//20170710 계산서 추가수신자	
	private String agnt_nm2		= "";
	private String agnt_tel2	= "";
	private String agnt_m_tel2	= "";
	private String agnt_fax2	= "";
	private String agnt_email2	= "";
	private String agnt_dept2	= "";
	private String agnt_title2	= "";




	// CONSTRCTOR   	
	public ClientSiteBean()
	{
		client_id		= "";
		seq				= "";
		r_site			= "";
		reg_dt			= "";
		reg_id			= "";
		site_st			= "";
		site_jang		= "";
		enp_no			= "";
		bus_cdt			= "";
		bus_itm			= "";
		open_year		= "";
		tel				= "";
		fax				= "";
		zip				= "";
		addr			= "";
		agnt_nm			= "";
		agnt_tel		= "";
		ven_code		= "";
		upd_id			= "";
		upd_dt			= "";
		l_cnt			= 0;
		agnt_m_tel		= "";
		agnt_fax		= "";
		agnt_email		= "";
		agnt_dept		= "";
		agnt_title		= "";
		item_mail_yn	= "";
		tax_mail_yn		= "";
		taxregno		= "";
		bigo_value		= "";	
		agnt_nm2		= "";
		agnt_tel2		= "";
		agnt_m_tel2		= "";
		agnt_fax2		= "";
		agnt_email2		= "";
		agnt_dept2		= "";
		agnt_title2		= "";

	}
	
	//Set Method
	public void setClient_id	(String str) 	{	if(str==null) str="";	client_id		= str; }
	public void setSeq			(String str)	{	if(str==null) str="";	seq				= str; }
	public void setR_site		(String str)	{	if(str==null) str="";	r_site			= str; }		
	public void setReg_dt		(String str)	{	if(str==null) str="";	reg_dt			= str; }    
	public void setReg_id		(String str)	{	if(str==null) str="";	reg_id			= str; }    	
	public void setSite_st		(String str)	{	if(str==null) str="";	site_st			= str; }    	
	public void setSite_jang	(String str)	{	if(str==null) str="";	site_jang		= str; }    		
	public void setEnp_no		(String str)	{	if(str==null) str="";	enp_no			= str; }    		
	public void setBus_cdt		(String str)	{	if(str==null) str="";	bus_cdt			= str; }    		
	public void setBus_itm		(String str)	{	if(str==null) str="";	bus_itm			= str; }		
	public void setOpen_year	(String str)	{	if(str==null) str="";	open_year		= str; }		
	public void setTel			(String str)	{	if(str==null) str="";	tel				= str; }		
	public void setFax			(String str)	{	if(str==null) str="";	fax				= str; }
	public void setZip			(String str)	{	if(str==null) str="";	zip				= str; }    	
	public void setAddr			(String str)	{	if(str==null) str="";	addr			= str; }    
	public void setAgnt_nm		(String str)	{	if(str==null) str="";	agnt_nm			= str; }    			
	public void setAgnt_tel		(String str)	{	if(str==null) str="";	agnt_tel		= str; }    	
	public void setVen_code		(String str)	{	if(str==null) str="";	ven_code		= str; }    	
	public void setUpd_id		(String str)	{	if(str==null) str="";	upd_id			= str; }    	
	public void setUpd_dt		(String str)	{	if(str==null) str="";	upd_dt			= str; }		
	public void setL_cnt		(int str)		{							l_cnt			= str; }		
	public void setAgnt_m_tel	(String str) 	{	if(str==null) str="";	agnt_m_tel		= str; }  
	public void setAgnt_fax		(String str)	{	if(str==null) str="";	agnt_fax		= str; }
	public void setAgnt_email	(String str)	{	if(str==null) str="";	agnt_email		= str; }  
	public void setAgnt_dept	(String str)	{	if(str==null) str="";	agnt_dept		= str; }	
	public void setAgnt_title	(String str)	{	if(str==null) str="";	agnt_title		= str; }  
	public void setItem_mail_yn	(String str)	{	if(str==null) str="";	item_mail_yn    = str; }	
	public void setTax_mail_yn	(String str)	{	if(str==null) str="";	tax_mail_yn	    = str; }	
	public void setTaxregno		(String str)	{	if(str==null) str="";	taxregno	    = str; }	
	public void setBigo_value	(String str)	{	if(str==null) str="";	bigo_value		= str; }	
	public void setAgnt_nm2		(String str)	{	if(str==null) str="";	agnt_nm2		= str; }    			
	public void setAgnt_tel2	(String str)	{	if(str==null) str="";	agnt_tel2		= str; }    	
	public void setAgnt_m_tel2	(String str) 	{	if(str==null) str="";	agnt_m_tel2		= str; }  
	public void setAgnt_fax2	(String str)	{	if(str==null) str="";	agnt_fax2		= str; }
	public void setAgnt_email2	(String str)	{	if(str==null) str="";	agnt_email2		= str; }  
	public void setAgnt_dept2	(String str)	{	if(str==null) str="";	agnt_dept2		= str; }	
	public void setAgnt_title2	(String str)	{	if(str==null) str="";	agnt_title2		= str; }  

	//Get Method	
	public String getClient_id		()	{	return client_id;		}
	public String getSeq			()	{	return seq;				}
	public String getR_site			()	{	return r_site;			}
	public String getReg_dt			()	{	return reg_dt;			}
	public String getReg_id			()	{	return reg_id;			}
	public String getSite_st		()	{	return site_st;			}
	public String getSite_jang		()	{	return site_jang;		}
	public String getEnp_no			()	{	return enp_no;			}
	public String getBus_cdt		()	{	return bus_cdt;			}
	public String getBus_itm		()	{	return bus_itm;			}
	public String getOpen_year		()	{	return open_year;		}
	public String getTel			()	{	return tel;				}
	public String getFax			()	{	return fax;				}
	public String getZip			()	{	return zip;				}
	public String getAddr			()	{	return addr;			}
	public String getAgnt_nm		()	{	return agnt_nm;			}
	public String getAgnt_tel		()	{	return agnt_tel;		}
	public String getVen_code		()	{	return ven_code;		}
	public String getUpd_id			()	{	return upd_id;			}
	public String getUpd_dt			()	{	return upd_dt;			}
	public int getL_cnt				()	{	return l_cnt;			}
	public String getAgnt_m_tel		() 	{	return agnt_m_tel;		}
	public String getAgnt_fax		()	{	return agnt_fax;		}
	public String getAgnt_email		()	{	return agnt_email;		}
	public String getAgnt_dept		()	{	return agnt_dept;		}
	public String getAgnt_title		()	{	return agnt_title;		}
	public String getItem_mail_yn	()	{	return item_mail_yn;	}
	public String getTax_mail_yn	()	{	return tax_mail_yn;		}
	public String getTaxregno		()	{	return taxregno;		}
	public String getBigo_value		()	{	return bigo_value;		}	
	public String getAgnt_nm2		()	{	return agnt_nm2;		}
	public String getAgnt_tel2		()	{	return agnt_tel2;		}
	public String getAgnt_m_tel2	() 	{	return agnt_m_tel2;		}
	public String getAgnt_fax2		()	{	return agnt_fax2;		}
	public String getAgnt_email2	()	{	return agnt_email2;		}
	public String getAgnt_dept2		()	{	return agnt_dept2;		}
	public String getAgnt_title2	()	{	return agnt_title2;		}


}