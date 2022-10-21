package acar.client;

public class ClientFinBean
{
	//Table : CLIENT_FIN

	private String client_id		= "";
	private String f_seq			= "";
	private String c_kisu			= "";
	private String c_ba_year		= "";
	private float c_asset_tot		= 0;
	private float c_cap				= 0;
	private float c_cap_tot			= 0;
	private float c_sale			= 0;
	private float c_profit			= 0;
	private String f_kisu			= "";
	private String f_ba_year		= "";
	private float f_asset_tot		= 0;
	private float f_cap				= 0;
	private float f_cap_tot			= 0;
	private float f_sale			= 0;
	private float f_profit			= 0;
	private String c_ba_year_s		= "";
	private String f_ba_year_s		= "";

	
	// CONSTRCTOR   	
	public ClientFinBean()
	{
		client_id		= "";    
		f_seq			= "";        
		c_kisu			= "";    
		c_ba_year		= "";    
		c_asset_tot		= 0;
		c_cap			= 0;
		c_cap_tot		= 0;    
		c_sale			= 0;    
		c_profit		= 0;    
		f_kisu			= "";    
		f_ba_year		= "";    
		f_asset_tot		= 0;    
		f_cap			= 0;    
		f_cap_tot		= 0;    
		f_sale			= 0;    
		f_profit		= 0;    
		c_ba_year_s		= "";
		f_ba_year_s		= "";
	
	}
	
	//Set Method
	public void setClient_id	(String str) 	{	if(str==null) str="";	client_id	= str; }
	public void setF_seq		(String str)	{	if(str==null) str="";	f_seq		= str; }
	public void setC_kisu		(String str)	{	if(str==null) str="";	c_kisu		= str; }		
	public void setC_ba_year	(String str)	{	if(str==null) str="";	c_ba_year	= str; }    
	public void setC_asset_tot	(float val){	c_asset_tot	= val; }
	public void setC_cap		(float val){	c_cap		= val; }
	public void setC_cap_tot	(float val){	c_cap_tot	= val; }
	public void setC_sale		(float val){	c_sale		= val; }
	public void setC_profit		(float val){	c_profit	= val; }
	public void setF_kisu		(String str)	{	if(str==null) str="";	f_kisu		= str; }    		
	public void setF_ba_year	(String str)	{	if(str==null) str="";	f_ba_year	= str; }		
	public void setF_asset_tot	(float val){	f_asset_tot	= val; }		
	public void setF_cap		(float val){	f_cap		= val; }		
	public void setF_cap_tot	(float val){	f_cap_tot	= val; }
	public void setF_sale		(float val){	f_sale		= val; }  
	public void setF_profit		(float val){	f_profit	= val; }	
	public void setC_ba_year_s	(String str)	{	if(str==null) str="";	c_ba_year_s	= str; }    
	public void setF_ba_year_s	(String str)	{	if(str==null) str="";	f_ba_year_s	= str; }    



	//Get Method	
	public String getClient_id		()	{	return client_id;	}
	public String getF_seq			()	{	return f_seq;		}
	public String getC_kisu			()	{	return c_kisu;		}
	public String getC_ba_year		()	{	return c_ba_year;	}
	public float  getC_asset_tot	()	{	return c_asset_tot; }
	public float  getC_cap			()	{	return c_cap;		}
	public float  getC_cap_tot		()	{	return c_cap_tot;	}
	public float  getC_sale			()	{	return c_sale;		}
	public float  getC_profit		()	{	return c_profit;	}
	public String getF_kisu			()	{	return f_kisu;		}
	public String getF_ba_year		()	{	return f_ba_year;	}
	public float  getF_asset_tot	()	{	return f_asset_tot;	}
	public float  getF_cap			()	{	return f_cap;		}
	public float  getF_cap_tot		()	{	return f_cap_tot;	}
	public float  getF_sale			()	{	return f_sale;		}
	public float  getF_profit		()	{	return f_profit;	}
	public String getC_ba_year_s	()	{	return c_ba_year_s;	}
	public String getF_ba_year_s	()	{	return f_ba_year_s;	}
						 
                                    										
}