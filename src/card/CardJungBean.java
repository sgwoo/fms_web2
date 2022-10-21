package card;

import java.util.*;

public class CardJungBean {

	//Table : 카드 경비 정산 관련
	private String jung_dt;			
	private String user_id;	
	private String user_nm;				
	private String acct_code;		
	private String acct_code_g;		
	private String acct_code_g2;			
	private int    basic_amt;
	private int    real_amt;
	private int    jung_amt;
	private int    remain_amt;
	private String remark;			
	// CONSTRCTOR            
	public CardJungBean() {  
		jung_dt				= "";
		user_id				= "";
		user_nm				= "";
		acct_code			= "";
		acct_code_g			= "";
		acct_code_g2		= "";
		basic_amt			= 0;
		real_amt			= 0;
		jung_amt			= 0;
		remain_amt			= 0;
		remark		= "";
		
	}

	//Set Method
	public void setJung_dt				(String val){	if(val==null) val="";		jung_dt				= val;		}
	public void setUser_id				(String val){	if(val==null) val="";		user_id				= val;		}
	public void setUser_nm				(String val){	if(val==null) val="";		user_nm				= val;		}
	public void setAcct_code			(String val){	if(val==null) val="";		acct_code			= val;		}	
	public void setAcct_code_g			(String val){	if(val==null) val="";		acct_code_g			= val;		}	
	public void setAcct_code_g2			(String val){	if(val==null) val="";		acct_code_g2		= val;		}	
	public void setBasic_amt			(int val){									basic_amt			= val;		}
	public void setReal_amt				(int val){									real_amt			= val;		}
	public void setJung_amt				(int val){									jung_amt			= val;		}
	public void setRemain_amt			(int val){									remain_amt			= val;		}
	public void setRemark				(String val){								remark				= val;		}
	
	//Get Method
	public String getJung_dt				(){		return		jung_dt;				}
	public String getUser_id				(){		return		user_id;				}
	public String getUser_nm				(){		return		user_nm;				}
	public String getAcct_code				(){		return		acct_code;				}
	public String getAcct_code_g			(){		return		acct_code_g;				}
	public String getAcct_code_g2			(){		return		acct_code_g2;				}
	public int    getBasic_amt				(){		return		basic_amt;          }
	public int    getReal_amt				(){		return		real_amt;          }
	public int    getJung_amt				(){		return		jung_amt;            }
	public int    getRemain_amt				(){		return		remain_amt;            }
	public String getRemark					(){		return		remark;				}

}
