package acar.admin;

import java.util.*;

public class StatMngBean {
    //Table : STAT_DLY
    private String save_dt;			//�������
	private String seq;				//�Ϸù�ȣ
    private String user_id;			//���ID
	private int client_cnt;			//������ü ��
	private int client_cnt_o;		//������ü �ܵ����
	private int client_cnt_t;		//������ü �������
	private float client_ga;		//������ü ����ġ
	private int gen_cnt;			//�Ϲݽ� ���
	private int gen_cnt_o;			//�Ϲݽ� �ܵ����
	private int gen_cnt_t;			//�Ϲݽ� �������
	private float gen_ga;			//�Ϲݽ� ����ġ
	private int put_cnt;			//����� ���
	private int put_cnt_o;			//����� �ܵ����
	private int put_cnt_t;			//����� �������
	private float put_ga;			//����� ����ġ
	private int bas_cnt;			//�⺻�� ���
	private int bas_cnt_o;			//�⺻�� �ܵ����
	private int bas_cnt_t;			//�⺻�� �������
	private float bas_ga;			//�⺻�� ����ġ
	private int tot_cnt;			//������
	private float tot_ga;			//������ ����ġ
	private String dept_id;
	private String dept_nm;			//�μ���
	private String user_nm;			//����
	private String enter_dt;		//�Ի�����	
	private String reg_id;

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
}