package acar.admin;

import java.util.*;

public class StatDebtBean {
    //Table : STAT_DEBT
    private String save_dt;			//�������
	private String seq;				//�Ϸù�ȣ
    private String cpt_cd;			//������ID
	private long last_mon_amt;		//�����̿����Ա�
	private long over_mon_amt;		//�����̿����Ա�
	private long this_mon_new_amt;	//����ű����Ա�
	private long this_mon_plan_amt;	//����������Ա�
	private long this_mon_pay_amt;	//�����ȯ���Ա�
	private long this_mon_jan_amt;	//����ܾ����Ա�
	private long whan_amt;			//�����ڱ� �Ǵ� ��Ÿ �ݾ�
	private String reg_id;			//�����
	private String reg_dt;			//�����

	public StatDebtBean() {  
		this.save_dt = "";
		this.seq = "";
		this.cpt_cd = "";
		this.last_mon_amt = 0;
		this.over_mon_amt = 0;
		this.this_mon_new_amt = 0;
		this.this_mon_plan_amt = 0;
		this.this_mon_pay_amt = 0;
		this.this_mon_jan_amt = 0;
		this.whan_amt = 0;
		this.reg_id = "";
		this.reg_dt = "";
	}

	// set Method
	public void setSave_dt(String val){			if(val==null) val=""; this.save_dt = val;	}
	public void setSeq(String val){				if(val==null) val=""; this.seq = val;		}
	public void setCpt_cd(String val){			if(val==null) val=""; this.cpt_cd = val;	}
	public void setLast_mon_amt(long i){		this.last_mon_amt = i;		}
    public void setOver_mon_amt(long i){		this.over_mon_amt = i;		}
    public void setThis_mon_new_amt(long i){	this.this_mon_new_amt = i;	}
    public void setThis_mon_plan_amt(long i){	this.this_mon_plan_amt = i;	}
    public void setThis_mon_pay_amt(long i){	this.this_mon_pay_amt = i;	}
    public void setThis_mon_jan_amt(long i){	this.this_mon_jan_amt = i;	}
    public void setWhan_amt(long i){			this.whan_amt = i;			}
    public void setReg_id(String val){			if(val==null) val=""; this.reg_id = val;	}
	public void setReg_dt(String val){			if(val==null) val=""; this.reg_dt = val;	}

	
	//Get Method
	public String getSave_dt(){			return save_dt;				}
    public String getSeq(){				return seq;					}
    public String getCpt_cd(){			return cpt_cd;				}
	public long getLast_mon_amt(){		return last_mon_amt;		}
	public long getOver_mon_amt(){		return over_mon_amt;		}
    public long getThis_mon_new_amt(){	return this_mon_new_amt;	}
    public long getThis_mon_plan_amt(){	return this_mon_plan_amt;	}
	public long getThis_mon_pay_amt(){	return this_mon_pay_amt;	}
    public long getThis_mon_jan_amt(){	return this_mon_jan_amt;	}
    public long getWhan_amt(){			return whan_amt;			}
    public String getReg_id(){			return reg_id;				}
	public String getReg_dt(){			return reg_dt;				}
	
}