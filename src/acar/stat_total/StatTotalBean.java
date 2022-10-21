package acar.stat_total;

import java.util.*;

public class StatTotalBean {
    //Table : STAT_DLY
    private String save_dt;			//�������
	private String seq;				//�Ϸù�ȣ
    private String user_id;			//���ID
	private float mng_ga;			//������Ȳ ����ġ
	private float dly_ga;			//��ü��Ȳ ����ġ
	private float bus_ga;			//������Ȳ ����ġ
	private float tot_ga;			//����ġ��
	private float avg_ga;			//����ġ���
	private float dly_per;			//��ü��Ȳ ��ü��
	private String dept_id;
	private String dept_nm;			//�μ���
	private String user_nm;			//����
	private String enter_dt;		//�Ի�����	
	private String reg_id;


	public StatTotalBean() {  
		this.save_dt = "";
		this.seq = "";
		this.user_id = "";
		this.mng_ga = 0;
		this.dly_ga = 0;
		this.bus_ga = 0;
		this.tot_ga = 0;
		this.avg_ga = 0;
		this.dly_per = 0;
		this.dept_id = "";
		this.dept_nm = "";
		this.user_nm = "";
		this.enter_dt = "";
		this.reg_id = "";
	}

	// set Method
	public void setSave_dt(String val){	if(val==null) val=""; this.save_dt = val;	}
	public void setSeq(String val){		if(val==null) val=""; this.seq = val;		}
	public void setUser_id(String val){	if(val==null) val=""; this.user_id = val;	}
    public void setMng_ga(float i){		this.mng_ga = i;							}
    public void setDly_ga(float i){		this.dly_ga = i;							}
    public void setBus_ga(float i){		this.bus_ga = i;							}
    public void setTot_ga(float i){		this.tot_ga = i;							}
    public void setAvg_ga(float i){		this.avg_ga = i;							}
    public void setDly_per(float i){	this.dly_per = i;							}
	public void setDept_id(String val){	if(val==null) val=""; this.dept_id = val;	}
	public void setDept_nm(String val){	if(val==null) val=""; this.dept_nm = val;	}
	public void setUser_nm(String val){	if(val==null) val=""; this.user_nm = val;	}
	public void setEnter_dt(String val){if(val==null) val=""; this.enter_dt = val;	}
	public void setReg_id(String val){	if(val==null) val=""; this.reg_id = val;	}
	
	//Get Method
	public String getSave_dt(){			return save_dt;		}
    public String getSeq(){				return seq;			}
    public String getUser_id(){			return user_id;		}
	public float getMng_ga(){			return mng_ga;		}
	public float getDly_ga(){			return dly_ga;		}
	public float getBus_ga(){			return bus_ga;		}
	public float getTot_ga(){			return tot_ga;		}
	public float getAvg_ga(){			return avg_ga;		}
	public float getDly_per(){			return dly_per;		}
    public String getDept_id(){			return dept_id;		}
    public String getDept_nm(){			return dept_nm;		}
    public String getUser_nm(){			return user_nm;		}
    public String getEnter_dt(){		return enter_dt;	}	
    public String getReg_id(){			return reg_id;		}

}