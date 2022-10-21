package tax;

import java.util.*;

public class PayBean {

	//Table : 입금표발행 
	private String rent_mng_id;			
	private String rent_l_cd;			
	private String client_id;	
	private String gubun;			
	private String pay_dt;	
	private int    pay_amt;				
	private String seqid;		
	private String reg_dt;		
	private String reg_id;		

	// CONSTRCTOR            
	public PayBean() {  
		rent_mng_id			= "";
		rent_l_cd			= "";
		client_id			= "";
		gubun				= "";
		pay_dt				= "";
		pay_amt				= 0;
		seqid				= "";
		reg_dt				= "";
		reg_id				= "";
	
	}

	//Set Method
	public void setRent_mng_id			(String val){	if(val==null) val="";		rent_mng_id 		= val;	} 
	public void setRent_l_cd			(String val){	if(val==null) val="";		rent_l_cd			= val;		}
	public void setPay_dt				(String val){	if(val==null) val="";		pay_dt				= val;		}
	public void setGubun				(String val){	if(val==null) val="";		gubun				= val;		}
	public void setPay_amt				(int val)	{								pay_amt				= val;		}
	public void setClient_id			(String val){	if(val==null) val="";		client_id			= val;		}
	public void setSeqid				(String val){	if(val==null) val="";		seqid				= val;		}
	public void setReg_dt				(String val){	if(val==null) val="";		reg_dt				= val;		}
	public void setReg_id				(String val){	if(val==null) val="";		reg_id				= val;		}


	//Get Method
	public String getRent_mng_id		(){		return 		rent_mng_id; 			} 
	public String getRent_l_cd			(){		return		rent_l_cd;				}	
	public String getPay_dt				(){		return		pay_dt;					}
	public String getGubun				(){		return		gubun;					}	
	public int	  getPay_amt			(){		return		pay_amt;				}
	public String getClient_id			(){		return		client_id;				}
	public String getSeqid				(){		return		seqid;					}
	public String getReg_dt				(){		return		reg_dt;					}
	public String getReg_id				(){		return		reg_id;					}


}
