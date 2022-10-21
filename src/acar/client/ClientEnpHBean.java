package acar.client;

public class ClientEnpHBean
{
	//Table : CLIENT_ENP_H
	private String client_id		= "";
	private String seq				= "";
	private String firm_nm			= "";
	private String client_nm		= "";
	private String ssn				= "";
	private String enp_no			= "";
	private String bus_cdt			= "";
	private String bus_itm			= "";
	private String ho_addr			= "";
	private String ho_zip			= "";
	private String o_addr			= "";
	private String o_zip			= "";
	private String cng_dt			= "";
	private String reg_dt			= "";
	private String reg_id			= "";
	private String taxregno			= "";
	
	// CONSTRCTOR   	
	public ClientEnpHBean()
	{
		client_id	= "";    
		seq			= "";        
		firm_nm		= "";    
		client_nm	= "";    
		ssn			= "";
		enp_no		= "";
		bus_cdt		= "";    
		bus_itm		= "";    
		ho_addr		= "";    
		ho_zip		= "";    
		o_addr		= "";    
		o_zip		= "";    
		cng_dt		= "";    
		reg_dt		= "";    
		reg_id		= "";    
		taxregno		= "";
	}
	
	//Set Method
	public void setClient_id	(String str) 	{	if(str==null) str="";	client_id		= str; }
	public void setSeq			(String str)	{	if(str==null) str="";	seq				= str; }
	public void setFirm_nm		(String str)	{	if(str==null) str="";	firm_nm			= str; }    
	public void setClient_nm	(String str)	{	if(str==null) str="";	client_nm		= str; }		
	public void setSsn			(String str)	{	if(str==null) str="";	ssn				= str; }    	
	public void setEnp_no		(String str)	{	if(str==null) str="";	enp_no			= str; }    		
	public void setBus_cdt		(String str)	{	if(str==null) str="";	bus_cdt			= str; }    
	public void setBus_itm		(String str)	{	if(str==null) str="";	bus_itm			= str; }    			
	public void setHo_addr		(String str)	{	if(str==null) str="";	ho_addr			= str; }    	
	public void setHo_zip		(String str)	{	if(str==null) str="";	ho_zip			= str; }    	
	public void setO_addr		(String str)	{	if(str==null) str="";	o_addr			= str; }    	
	public void setO_zip		(String str)	{	if(str==null) str="";	o_zip			= str; }		
	public void setCng_dt		(String str)	{	if(str==null) str="";	cng_dt			= str; }    
	public void setReg_dt		(String str)	{	if(str==null) str="";	reg_dt			= str; }	
	public void setReg_id		(String str)	{	if(str==null) str="";	reg_id			= str; }	
	public void setTaxregno		(String str)	{	if(str==null) str="";	taxregno	    = str; }	

	//Get Method	
	public String getClient_id	()	{	return client_id;		}
	public String getSeq		()	{	return seq;				}
	public String getFirm_nm	()	{	return firm_nm;			}
	public String getClient_nm	()	{	return client_nm;		}
	public String getSsn		()	{	return ssn;				}
	public String getEnp_no		()	{	return enp_no;			}
	public String getBus_cdt	()	{	return bus_cdt;			}
	public String getBus_itm	()	{	return bus_itm;			}
	public String getHo_addr	()	{	return ho_addr;			}
	public String getHo_zip		()	{	return ho_zip;			}
	public String getO_addr		()	{	return o_addr;			}
	public String getO_zip		()	{	return o_zip;			}
	public String getCng_dt		()	{	return cng_dt;			}
	public String getReg_dt		()	{	return reg_dt;			}
	public String getReg_id		()	{	return reg_id;			}
	public String getTaxregno	()	{	return taxregno;		}


}