package acar.stat_bus;

import java.util.*;

public class StatBusBean {
    //Table : STAT_DLY
    private String save_dt;			//�������
	private String seq;				//�Ϸù�ȣ
    private String user_id;			//���ID
    
    private int client_cnt;			//������ü ��
	private float client_ga;		//������ü ����ġ
	private int gen_cnt_1;			//�Ϲݽ� �ű�
	private int gen_cnt_2;			//�Ϲݽ� ����
	private int gen_cnt_3;			//�Ϲݽ� ����
	private int gen_cnt_4;			//�Ϲݽ� ����
	private int gen_cnt_5;			//�Ϲݽ� ������(6����)
	private float gen_ga;			//�Ϲݽ� ����ġ
	private int put_cnt_1;			//�����
	private int put_cnt_2;			//�����
	private int put_cnt_3;			//�����
	private int put_cnt_4;			//�����
	private int put_cnt_5;			//�����
	private float put_ga;			//����� ����ġ
	private int bas_cnt_1;			//�⺻��
	private int bas_cnt_2;			//�⺻��
	private int bas_cnt_3;			//�⺻��
	private int bas_cnt_4;			//�⺻��
	private int bas_cnt_5;			//�⺻��
	private float bas_ga;			//�⺻�� ����ġ
	private int tot_cnt;			//������
	private float tot_ga;			//������ ����ġ
	private String dept_id;
	private String dept_nm;			//�μ���
	private String user_nm;			//����
	private String enter_dt;		//�Ի�����	
	private String reg_id;


	public StatBusBean() {  
		this.save_dt = "";
		this.seq = "";
		this.user_id = "";
		
		
		this.client_cnt = 0;
		this.client_ga = 0;
		this.gen_cnt_1 = 0;
		this.gen_cnt_2 = 0;
		this.gen_cnt_3 = 0;
		this.gen_cnt_4 = 0;
		this.gen_cnt_5 = 0;
		this.gen_ga = 0;
		this.put_cnt_1 = 0;
		this.put_cnt_2 = 0;
		this.put_cnt_3 = 0;
		this.put_cnt_4 = 0;
		this.put_cnt_5 = 0;
		this.put_ga = 0;
		this.bas_cnt_1 = 0;
		this.bas_cnt_2 = 0;
		this.bas_cnt_3 = 0;
		this.bas_cnt_4 = 0;
		this.bas_cnt_5 = 0;
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
    public void setClient_ga(float i){	this.client_ga = i;							}
	public void setGen_cnt_1(int i){	this.gen_cnt_1 = i;							}
	public void setGen_cnt_2(int i){	this.gen_cnt_2 = i;							}
	public void setGen_cnt_3(int i){	this.gen_cnt_3 = i;							}
	public void setGen_cnt_4(int i){	this.gen_cnt_4 = i;							}
	public void setGen_cnt_5(int i){	this.gen_cnt_5 = i;							}
    public void setGen_ga(float i){		this.gen_ga = i;							}
	public void setPut_cnt_1(int i){	this.put_cnt_1 = i;							}
	public void setPut_cnt_2(int i){	this.put_cnt_2 = i;							}
	public void setPut_cnt_3(int i){	this.put_cnt_3 = i;							}
	public void setPut_cnt_4(int i){	this.put_cnt_4 = i;							}
	public void setPut_cnt_5(int i){	this.put_cnt_5 = i;							}
    public void setPut_ga(float i){		this.put_ga = i;							}
	public void setBas_cnt_1(int i){	this.bas_cnt_1 = i;							}
	public void setBas_cnt_2(int i){	this.bas_cnt_2 = i;							}
	public void setBas_cnt_3(int i){	this.bas_cnt_3 = i;							}
	public void setBas_cnt_4(int i){	this.bas_cnt_4 = i;							}
	public void setBas_cnt_5(int i){	this.bas_cnt_5 = i;							}
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
	public float getClient_ga(){		return client_ga;	}
	public int getGen_cnt_1(){			return gen_cnt_1;	}
	public int getGen_cnt_2(){			return gen_cnt_2;	}
	public int getGen_cnt_3(){			return gen_cnt_3;	}
	public int getGen_cnt_4(){			return gen_cnt_4;	}
	public int getGen_cnt_5(){			return gen_cnt_5;	}
	public float getGen_ga(){			return gen_ga;		}
	public int getPut_cnt_1(){			return put_cnt_1;	}
	public int getPut_cnt_2(){			return put_cnt_2;	}
	public int getPut_cnt_3(){			return put_cnt_3;	}
	public int getPut_cnt_4(){			return put_cnt_4;	}
	public int getPut_cnt_5(){			return put_cnt_5;	}
	public float getPut_ga(){			return put_ga;		}
	public int getBas_cnt_1(){			return bas_cnt_1;	}
	public int getBas_cnt_2(){			return bas_cnt_2;	}
	public int getBas_cnt_3(){			return bas_cnt_3;	}
	public int getBas_cnt_4(){			return bas_cnt_4;	}
	public int getBas_cnt_5(){			return bas_cnt_5;	}
	public float getBas_ga(){			return bas_ga;		}
    public String getDept_id(){			return dept_id;		}
    public String getDept_nm(){			return dept_nm;		}
    public String getUser_nm(){			return user_nm;		}
    public String getEnter_dt(){		return enter_dt;	}	
	public int getTot_cnt(){			return tot_cnt;		}
	public float getTot_ga(){			return tot_ga;		}
    public String getReg_id(){			return reg_id;		}
}