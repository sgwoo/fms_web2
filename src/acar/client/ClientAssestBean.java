package acar.client;

public class ClientAssestBean
{
	//Table : CLIENT_ASSEST

	private String client_id		= "";
	private String a_seq			= "";
	private String c_ass1_type		= "";
	private String c_ass1_addr		= "";
	private String c_ass1_zip		= "";
	private String c_ass2_type		= "";
	private String c_ass2_addr		= "";
	private String c_ass2_zip		= "";
	private String r_ass1_type		= "";
	private String r_ass1_addr		= "";
	private String r_ass1_zip		= "";
	private String r_ass2_type		= "";
	private String r_ass2_addr		= "";
	private String r_ass2_zip		= "";

	
	// CONSTRCTOR   	
	public ClientAssestBean()
	{
		client_id		= "";    
		a_seq			= "";        
		c_ass1_type		= "";    
		c_ass1_addr		= "";    
		c_ass1_zip		= "";
		c_ass2_type		= "";
		c_ass2_addr		= "";    
		c_ass2_zip		= "";    
		r_ass1_type		= "";    
		r_ass1_addr		= "";    
		r_ass1_zip		= "";    
		r_ass2_type		= "";    
		r_ass2_addr		= "";    
		r_ass2_zip		= "";    
	
	}
	
	//Set Method
	public void setClient_id	(String str) 	{	if(str==null) str="";	client_id	= str; }
	public void setA_seq		(String str)	{	if(str==null) str="";	a_seq		= str; }
	public void setC_ass1_type	(String str)	{	if(str==null) str="";	c_ass1_type	= str; }		
	public void setC_ass1_addr	(String str)	{	if(str==null) str="";	c_ass1_addr	= str; }    
	public void setC_ass1_zip	(String str)	{	if(str==null) str="";	c_ass1_zip	= str; }    	
	public void setC_ass2_type	(String str)	{	if(str==null) str="";	c_ass2_type	= str; }    	
	public void setC_ass2_addr	(String str)	{	if(str==null) str="";	c_ass2_addr	= str; }    		
	public void setC_ass2_zip	(String str)	{	if(str==null) str="";	c_ass2_zip	= str; }    		
	public void setR_ass1_type	(String str)	{	if(str==null) str="";	r_ass1_type	= str; }    		
	public void setR_ass1_addr	(String str)	{	if(str==null) str="";	r_ass1_addr	= str; }		
	public void setR_ass1_zip	(String str)	{	if(str==null) str="";	r_ass1_zip	= str; }		
	public void setR_ass2_type	(String str)	{	if(str==null) str="";	r_ass2_type	= str; }		
	public void setR_ass2_addr	(String str)	{	if(str==null) str="";	r_ass2_addr	= str; }
	public void setR_ass2_zip	(String str)	{	if(str==null) str="";	r_ass2_zip	= str; }    	



	//Get Method	
	public String getClient_id		()	{	return client_id;	}
	public String getA_seq			()	{	return a_seq;		}
	public String getC_ass1_type	()	{	return c_ass1_type;		}
	public String getC_ass1_addr	()	{	return c_ass1_addr;	}
	public String getC_ass1_zip		()	{	return c_ass1_zip;	}
	public String getC_ass2_type	()	{	return c_ass2_type;		}
	public String getC_ass2_addr	()	{	return c_ass2_addr;	}
	public String getC_ass2_zip		()	{	return c_ass2_zip;		}
	public String getR_ass1_type	()	{	return r_ass1_type;		}
	public String getR_ass1_addr	()	{	return r_ass1_addr;	}
	public String getR_ass1_zip		()	{	return r_ass1_zip;	}
	public String getR_ass2_type	()	{	return r_ass2_type;		}
	public String getR_ass2_addr	()	{	return r_ass2_addr;	}
	public String getR_ass2_zip		()	{	return r_ass2_zip;		}
						 
                                    										
}