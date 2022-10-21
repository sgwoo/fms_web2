package acar.cont;

public class ContEvalBean
{
	private String rent_mng_id	= "";    
	private String rent_l_cd	= "";
	private String e_seq	= "";
	private String eval_gu	= "";    
	private String eval_nm  = "";    
	private String eval_gr	= "";    
	private String eval_off = "";    
	private String eval_s_dt	= "";    
	private String ass1_type	= "";
	private String ass1_addr	= "";
	private String ass1_zip		= "";
	private String ass2_type	= "";
	private String ass2_addr	= "";
	private String ass2_zip		= "";
	private String eval_b_dt	= "";    
	private String eval_score = "";
	//대체키관리
	private String key_no		= "";    
	private String key_name		= "";    
	private String key_birth_dt	= "";    
	private String key_m_tel	= "";    
	private String key_memo		= "";    
	private String key_nice		= "";    
	private String key_kcb		= "";    
	

	// CONSTRCTOR   	
	public ContEvalBean()
	{
		rent_mng_id		= "";    
		rent_l_cd		= "";        
		e_seq			= "";    
		eval_gu			= "";    
		eval_nm			= "";
		eval_gr			= "";
		eval_off		= "";    
		eval_s_dt		= "";    
		eval_score		= "";
		ass1_type		= "";    
		ass1_addr		= "";    
		ass1_zip		= "";    
		ass2_type		= "";    
		ass2_addr		= "";    
		ass2_zip		= "";    
		eval_b_dt		= "";    
		key_no			= "";    
		key_name		= "";    
		key_birth_dt	= "";    
		key_m_tel		= "";    
		key_memo		= "";    
		key_nice		= "";    
		key_kcb			= "";    

	}
		
	//Set Method
	public void setRent_mng_id	(String str) 	{	if(str==null) str="";	rent_mng_id		= str; }
	public void setRent_l_cd	(String str)	{	if(str==null) str="";	rent_l_cd		= str; }
	public void setE_seq		(String str)	{	if(str==null) str="";	e_seq			= str; }		
	public void setEval_gu		(String str)	{	if(str==null) str="";	eval_gu			= str; }    
	public void setEval_nm		(String str)	{	if(str==null) str="";	eval_nm			= str; }    	
	public void setEval_gr		(String str)	{	if(str==null) str="";	eval_gr			= str; }    	
	public void setEval_off		(String str)	{	if(str==null) str="";	eval_off		= str; }    		
	public void setEval_s_dt	(String str)	{	if(str==null) str="";	eval_s_dt		= str; }    		
	public void setAss1_type	(String str)	{	if(str==null) str="";	ass1_type		= str; }    		
	public void setAss1_addr	(String str)	{	if(str==null) str="";	ass1_addr		= str; }		
	public void setAss1_zip		(String str)	{	if(str==null) str="";	ass1_zip		= str; }		
	public void setAss2_type	(String str)	{	if(str==null) str="";	ass2_type		= str; }		
	public void setAss2_addr	(String str)	{	if(str==null) str="";	ass2_addr		= str; }
	public void setAss2_zip		(String str)	{	if(str==null) str="";	ass2_zip		= str; }    	
	public void setEval_b_dt	(String str)	{	if(str==null) str="";	eval_b_dt		= str; }    		
	public void setEval_score	(String str)	{	if(str==null) str="";	eval_score		= str; }    		
	public void setKey_no		(String str)	{	if(str==null) str="";	key_no			= str; }    		
	public void setKey_name		(String str)	{	if(str==null) str="";	key_name		= str; }		
	public void setKey_birth_dt	(String str)	{	if(str==null) str="";	key_birth_dt	= str; }		
	public void setKey_m_tel	(String str)	{	if(str==null) str="";	key_m_tel		= str; }		
	public void setKey_memo		(String str)	{	if(str==null) str="";	key_memo		= str; }
	public void setKey_nice		(String str)	{	if(str==null) str="";	key_nice		= str; }    	
	public void setKey_kcb		(String str)	{	if(str==null) str="";	key_kcb			= str; }    		

	//Get Method	
	public String getRent_mng_id	()	{	return rent_mng_id;		}
	public String getRent_l_cd		()	{	return rent_l_cd;		}
	public String getE_seq			()	{	return e_seq;			}
	public String getEval_gu		()	{	return eval_gu;			}
	public String getEval_nm		()	{	return eval_nm;			}
	public String getEval_gr		()	{	return eval_gr;			}
	public String getEval_off		()	{	return eval_off;		}
	public String getEval_s_dt		()	{	return eval_s_dt;		}
	public String getAss1_type		()	{	return ass1_type;		}
	public String getAss1_addr		()	{	return ass1_addr;		}
	public String getAss1_zip		()	{	return ass1_zip;		}
	public String getAss2_type		()	{	return ass2_type;		}
	public String getAss2_addr		()	{	return ass2_addr;		}
	public String getAss2_zip		()	{	return ass2_zip;		}
	public String getEval_b_dt		()	{	return eval_b_dt;		}						 
	public String getEval_score		()	{	return eval_score;		}						 
	public String getKey_no			()	{	return key_no;			}
	public String getKey_name		()	{	return key_name;		}
	public String getKey_birth_dt	()	{	return key_birth_dt;	}
	public String getKey_m_tel		()	{	return key_m_tel;		}
	public String getKey_memo		()	{	return key_memo;		}
	public String getKey_nice		()	{	return key_nice;		}
	public String getKey_kcb		()	{	return key_kcb;			}
	
}

