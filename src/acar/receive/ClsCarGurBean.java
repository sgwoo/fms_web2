package acar.receive;

public class ClsCarGurBean
{

	private String rent_mng_id;	// 계약관리번호
	private String rent_l_cd;	// 계약번호    
	private int gu_seq; 
	private String gu_nm; 
	private String gu_addr; 
	private String gu_zip; 
	private String gu_tel; 
	private String gu_rel; 
	private String plan_st; 
	private String eff_st; 
	private String plan_rem; 
	private String eff_rem; 
		
	public ClsCarGurBean()
	{
		rent_mng_id = "";
		rent_l_cd   = ""; 		
		gu_seq	= 0;	
		gu_nm	= "";
		gu_addr		= "";
		gu_zip	= "";
		gu_tel = "";
		gu_rel = "";
		plan_st = "";
		eff_st = "";
		plan_rem = "";
		eff_rem = "";
	
	}	
	
	public void setRent_mng_id(String str)	{ rent_mng_id	= str; } 
	public void setRent_l_cd(String str)		{ rent_l_cd		= str; } 
	public void setGu_seq(int i)			{ gu_seq		= i;   } 
	public void setGu_nm(String str)		{ gu_nm		= str; } 
	public void setGu_addr(String str)		{ gu_addr	= str; } 
	public void setGu_zip(String str)		{ gu_zip		= str; } 
	public void setGu_tel(String str)		{ gu_tel	= str; }
	public void setGu_rel(String str)		{ gu_rel		= str; } 
	public void setPlan_st(String str)		{ plan_st	= str; }
	public void setEff_st(String str)			{ eff_st	= str; }
	public void setPlan_rem(String str)		{ plan_rem = str; }	
	public void setEff_rem(String str)		{ eff_rem = str; }	
		
	public String getRent_mng_id()	{ return rent_mng_id;	} 
	public String getRent_l_cd()		{ return rent_l_cd;		} 
	public int       getGu_seq()			{ return gu_seq;		} 	
	public String getGu_nm()			{ return gu_nm;		} 
	public String getGu_addr()		{ return gu_addr;	} 
	public String getGu_zip()			{ return gu_zip;		}  
	public String getGu_tel()			{ return gu_tel; }  
	public String getGu_rel()			{ return gu_rel; }  
	public String getPlan_st()			{ return plan_st; }  
	public String getEff_st()			{ return eff_st; }  
	public String getPlan_rem()		{ return plan_rem; }  
	public String getEff_rem()		{ return eff_rem; }  

}