package acar.biz_partner;

import java.util.*;

public class ErpSweepActListBean {

    //Table : erp_sweep_act_list 자금집금 마스터

	private String	biz_reg_no;         //사업자번호                    
	private String	user_id;         	//집금자ID             
	private String	sweep_no;        	//목록번호             
	private int   	execut_seq;      	//실행일련번호         
	private int   	retry_seq;       	//재처리회차           
	private String	execut_cd;       	//실행조건             
	private String	action_nm;       	//목록명      
	private String	execut_dt;       	//실행일자    
	private String	execut_tm;       	//실행시간    
	private String	insert_dt;       	//등록일자    

	
	public ErpSweepActListBean() {  
		biz_reg_no		= "";
		user_id			= "";
		sweep_no		= "";
		execut_seq		= 0;
		retry_seq		= 0;
		execut_cd		= "";
		action_nm		= "";
		execut_dt		= "";
		execut_tm		= "";
		insert_dt		= "";

	}

	// set Method
	public void setBiz_reg_no				(String var){	biz_reg_no			= var;	}
	public void setUser_id					(String var){	user_id				= var;	}
	public void setSweep_no					(String var){	sweep_no			= var;	}
	public void setExecut_seq				(int    var){	execut_seq			= var;	}
	public void setRetry_seq				(int    var){	retry_seq			= var;	}
	public void setExecut_cd				(String var){	execut_cd			= var;	}
	public void setAction_nm				(String var){	action_nm			= var;	}
	public void setExecut_dt				(String var){	execut_dt			= var;	}
	public void setExecut_tm				(String var){	execut_tm			= var;	}
	public void setInsert_dt				(String var){	insert_dt			= var;	}

	//Get Method
	public String getBiz_reg_no				(){				return biz_reg_no;			}
	public String getUser_id				(){				return user_id;				}
	public String getSweep_no				(){				return sweep_no;			}
	public int    getExecut_seq				(){				return execut_seq;			}
	public int    getRetry_seq				(){				return retry_seq;			}
	public String getExecut_cd				(){				return execut_cd;			}
	public String getAction_nm				(){				return action_nm;			}
	public String getExecut_dt				(){				return execut_dt;			}
	public String getExecut_tm				(){				return execut_tm;			}
	public String getInsert_dt				(){				return insert_dt;			}

}
