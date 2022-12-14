package acar.stat_mng;

import java.util.*;

public class StatMngBean {
    //Table : STAT_DLY
    private String save_dt;			//등록일자
	private String seq;				//일련번호
    private String user_id;			//사원ID
	private int client_cnt;			//관리업체 수
	private int client_cnt_o;		//관리업체 단독대수
	private int client_cnt_t;		//관리업체 공동대수
	private float client_ga;		//관리업체 가중치
	private int gen_cnt;			//일반식 대수
	private int gen_cnt_o;			//일반식 단독대수
	private int gen_cnt_t;			//일반식 공동대수
	private float gen_ga;			//일반식 가중치
	private int put_cnt;			//맞춤식 대수
	private int put_cnt_o;			//맞춤식 단독대수
	private int put_cnt_t;			//맞춤식 공동대수
	private float put_ga;			//맞춤식 가중치
	private int bas_cnt;			//기본식 대수
	private int bas_cnt_o;			//기본식 단독대수
	private int bas_cnt_t;			//기본식 공동대수
	private float bas_ga;			//기본식 가중치
	private int tot_cnt;			//차량합
	private float tot_ga;			//차량합 가중치
	private String dept_id;
	private String dept_nm;			//부서명
	private String user_nm;			//성명
	private String enter_dt;		//입사년월일	
	private String reg_id;
	private int c_gen_cnt_b1;		//업체-일반식-최초영업
	private int c_gen_cnt_b2;		//업체-일반식-영업관리
	private int c_gen_cnt_m1;		//업체-일반식-정비관리
	private float c_gen_ga;			//업체-일반식-가중치
	private int c_bp_cnt_b1;			//업체-일반식-최초영업
	private int c_bp_cnt_b2;			//업체-일반식-영업관리
	private int c_bp_cnt_m1;			//업체-일반식-정비관리
	private float c_bp_ga;			//업체-일반식-가중치
	private int c_client_cnt;			//관리업체 수
	private int c_client_cnt_o;		//관리업체 단독대수
	private int c_client_cnt_t;		//관리업체 공동대수
	private float c_client_ga;		//관리업체 가중치
	private float cnt_b1_ga;		//최초영업 평점
	private float cnt_b2_ga;		//영엽관리 평점
	private float cnt_m1_ga;		//정비관리 평점
	private int ins_cnt_b2;			//기본식차량 - 피보험자가 고객인 경우 제외



	public StatMngBean() {  
		this.save_dt = "";
		this.seq = "";
		this.user_id = "";
		this.client_cnt = 0;
		this.client_cnt_o = 0;
		this.client_cnt_t = 0;
		this.client_ga = 0;
		this.gen_cnt = 0;
		this.gen_cnt_o = 0;
		this.gen_cnt_t = 0;
		this.gen_ga = 0;
		this.put_cnt = 0;
		this.put_cnt_o = 0;
		this.put_cnt_t = 0;
		this.put_ga = 0;
		this.bas_cnt = 0;
		this.bas_cnt_o = 0;
		this.bas_cnt_t = 0;
		this.bas_ga = 0;
		this.dept_id = "";
		this.dept_nm = "";
		this.user_nm = "";
		this.enter_dt = "";
		this.tot_cnt = 0;
		this.tot_ga = 0;
		this.reg_id = "";
		this.c_gen_cnt_b1 = 0;
		this.c_gen_cnt_b2 = 0;
		this.c_gen_cnt_m1 = 0;
		this.c_gen_ga = 0;
		this.c_bp_cnt_b1 = 0;
		this.c_bp_cnt_b2 = 0;
		this.c_bp_cnt_m1 = 0;
		this.c_bp_ga = 0;
		this.c_client_cnt = 0;
		this.c_client_cnt_o = 0;
		this.c_client_cnt_t = 0;
		this.c_client_ga = 0;
		this.cnt_b1_ga = 0;
		this.cnt_b2_ga = 0;
		this.cnt_m1_ga = 0;
		this.ins_cnt_b2 = 0;

	}

	// set Method
	public void setSave_dt(String val){	if(val==null) val=""; this.save_dt = val;	}
	public void setSeq(String val){		if(val==null) val=""; this.seq = val;		}
	public void setUser_id(String val){	if(val==null) val=""; this.user_id = val;	}
	public void setClient_cnt(int i){	this.client_cnt = i;						}
	public void setClient_cnt_o(int i){	this.client_cnt_o = i;						}
	public void setClient_cnt_t(int i){	this.client_cnt_t = i;						}
    public void setClient_ga(float i){	this.client_ga = i;							}
	public void setGen_cnt(int i){		this.gen_cnt = i;							}
	public void setGen_cnt_o(int i){	this.gen_cnt_o = i;							}
	public void setGen_cnt_t(int i){	this.gen_cnt_t = i;							}
    public void setGen_ga(float i){		this.gen_ga = i;							}
	public void setPut_cnt(int i){		this.put_cnt = i;							}
	public void setPut_cnt_o(int i){	this.put_cnt_o = i;							}
	public void setPut_cnt_t(int i){	this.put_cnt_t = i;							}
    public void setPut_ga(float i){		this.put_ga = i;							}
	public void setBas_cnt(int i){		this.bas_cnt = i;							}
	public void setBas_cnt_o(int i){	this.bas_cnt_o = i;							}
	public void setBas_cnt_t(int i){	this.bas_cnt_t = i;							}
    public void setBas_ga(float i){		this.bas_ga = i;							}
	public void setDept_id(String val){	if(val==null) val=""; this.dept_id = val;	}
	public void setDept_nm(String val){	if(val==null) val=""; this.dept_nm = val;	}
	public void setUser_nm(String val){	if(val==null) val=""; this.user_nm = val;	}
	public void setEnter_dt(String val){if(val==null) val=""; this.enter_dt = val;	}
	public void setTot_cnt(int i){		this.tot_cnt = i;							}
    public void setTot_ga(float i){		this.tot_ga = i;							}
	public void setReg_id(String val){	if(val==null) val=""; this.reg_id = val;	}
	public void setC_Gen_cnt_b1(int i){	this.c_gen_cnt_b1 = i;						}
	public void setC_Gen_cnt_b2(int i){	this.c_gen_cnt_b2 = i;						}
	public void setC_Gen_cnt_m1(int i){	this.c_gen_cnt_m1 = i;						}
    public void setC_Gen_ga(float i){	this.c_gen_ga = i;							}
	public void setC_BP_cnt_b1(int i){	this.c_bp_cnt_b1 = i;						}
	public void setC_BP_cnt_b2(int i){	this.c_bp_cnt_b2 = i;						}
	public void setC_BP_cnt_m1(int i){	this.c_bp_cnt_m1 = i;						}
    public void setC_BP_ga(float i){	this.c_bp_ga = i;							}
	public void setC_Client_cnt(int i){	this.c_client_cnt = i;						}
	public void setC_Client_cnt_o(int i){	this.c_client_cnt_o = i;						}
	public void setC_Client_cnt_t(int i){	this.c_client_cnt_t = i;						}
    public void setC_Client_ga(float i){	this.c_client_ga = i;							}
    public void setCnt_b1_ga(float i){	this.cnt_b1_ga = i;							}
    public void setCnt_b2_ga(float i){	this.cnt_b2_ga = i;							}
    public void setCnt_m1_ga(float i){	this.cnt_m1_ga = i;							}
    public void setIns_cnt_b2(int i){	this.ins_cnt_b2 = i;						}

	
	//Get Method
	public String getSave_dt(){			return save_dt;		}
    public String getSeq(){				return seq;			}
    public String getUser_id(){			return user_id;		}
	public int getClient_cnt(){			return client_cnt;	}
	public int getClient_cnt_o(){		return client_cnt_o;}
	public int getClient_cnt_t(){		return client_cnt_t;}
	public float getClient_ga(){		return client_ga;	}
	public int getGen_cnt(){			return gen_cnt;		}
	public int getGen_cnt_o(){			return gen_cnt_o;	}
	public int getGen_cnt_t(){			return gen_cnt_t;	}
	public float getGen_ga(){			return gen_ga;		}
	public int getPut_cnt(){			return put_cnt;		}
	public int getPut_cnt_o(){			return put_cnt_o;	}
	public int getPut_cnt_t(){			return put_cnt_t;	}
	public float getPut_ga(){			return put_ga;		}
	public int getBas_cnt(){			return bas_cnt;		}
	public int getBas_cnt_o(){			return bas_cnt_o;	}
	public int getBas_cnt_t(){			return bas_cnt_t;	}
	public float getBas_ga(){			return bas_ga;		}
    public String getDept_id(){			return dept_id;		}
    public String getDept_nm(){			return dept_nm;		}
    public String getUser_nm(){			return user_nm;		}
    public String getEnter_dt(){		return enter_dt;	}	
	public int getTot_cnt(){			return tot_cnt;		}
	public float getTot_ga(){			return tot_ga;		}
    public String getReg_id(){			return reg_id;		}
	public int getC_Gen_cnt_b1(){		return c_gen_cnt_b1;}	
	public int getC_Gen_cnt_b2(){		return c_gen_cnt_b2;}	
	public int getC_Gen_cnt_m1(){		return c_gen_cnt_m1;}
	public float getC_Gen_ga(){			return c_gen_ga;	}	
	public int getC_BP_cnt_b1(){		return c_bp_cnt_b1;	}	
	public int getC_BP_cnt_b2(){		return c_bp_cnt_b2;	}	
	public int getC_BP_cnt_m1(){		return c_bp_cnt_m1;	}
	public float getC_BP_ga(){			return c_bp_ga;		}	
	public int getC_Client_cnt(){		return c_client_cnt;	}
	public int getC_Client_cnt_o(){		return c_client_cnt_o;}
	public int getC_Client_cnt_t(){		return c_client_cnt_t;}
	public float getC_Client_ga(){		return c_client_ga;	}
	public float getCnt_b1_ga(){		return cnt_b1_ga;	}
	public float getCnt_b2_ga(){		return cnt_b2_ga;	}
	public float getCnt_m1_ga(){		return cnt_m1_ga;	}
	public int getIns_cnt_b2(){			return ins_cnt_b2;}

}