package acar.add_mark;

import java.util.*;

public class AddMarkBean {
    //Table : ADD_MARK
	private String seq;				//�Ϸù�ȣ
    private String br_id;			//������ID
    private String dept_id;			//�μ�ID
    private String mng_st;			//��������
    private String mng_way;			//�������
	private String marks;			//����
	private String start_dt;		//���������
	private String end_dt;			//���븸����
	private String reg_id;			//�����
	private String use_yn;			//��������
	private String gubun;
	private String mng_who;

	public AddMarkBean() {  
		this.seq = "";
		this.br_id = "";
		this.dept_id = "";
		this.mng_st = "";
		this.mng_way = "";
		this.marks = "";
		this.start_dt = "";
		this.end_dt = "";
		this.reg_id = "";
		this.use_yn = "";
		this.gubun = "";
		this.mng_who = "";
	}

	//set Method
	public void setSeq(String val){		if(val==null) val=""; this.seq = val;		}
	public void setBr_id(String val){	if(val==null) val=""; this.br_id = val;		}
	public void setDept_id(String val){	if(val==null) val=""; this.dept_id = val;	}
	public void setMng_st(String val){	if(val==null) val=""; this.mng_st = val;	}
	public void setMng_way(String val){	if(val==null) val=""; this.mng_way = val;	}
	public void setMarks(String val){	if(val==null) val=""; this.marks = val;		}
	public void setStart_dt(String val){if(val==null) val=""; this.start_dt = val;	}
	public void setEnd_dt(String val){	if(val==null) val=""; this.end_dt = val;	}
    public void setReg_id(String val){	if(val==null) val=""; this.reg_id = val;	}
    public void setUse_yn(String val){	if(val==null) val=""; this.use_yn = val;	}
    public void setGubun(String val){	if(val==null) val=""; this.gubun = val;	}
    public void setMng_who(String val){	if(val==null) val=""; this.mng_who = val;	}
	
	//Get Method

    public String getSeq(){				return seq;			}
    public String getBr_id(){			return br_id;		}
    public String getDept_id(){			return dept_id;		}
    public String getMng_st(){			return mng_st;		}
	public String getMng_way(){			return mng_way;		}
	public String getMarks(){			return marks;		}
	public String getStart_dt(){		return start_dt;	}
	public String getEnd_dt(){			return end_dt;		}
    public String getReg_id(){			return reg_id;		}
    public String getUse_yn(){			return use_yn;		}
    public String getGubun(){			return gubun;		}
    public String getMng_who(){			return mng_who;		}
}

