package acar.admin;

import java.util.*;

public class StatCmpBean {
    //Table : STAT_DLY
    private String save_dt;			//�������
	private int seq;				//�Ϸù�ȣ
	private String c_yy;			//�⵵ 
	private String c_mm;			//�б� 
	private String gubun;			//���� 
    private String user_id;			//���ID
	private int amt;				//���޾�
	private float amt1;				//�������� ��տ�ü��
	private float amt2;				//�ܱ�:������ü��, ���� :�ʹ�1���� ���� ��ü��
	private float amt3;				//�Ĺ� 2���� ���� ��ü��
	private String s_type;			//1: ����� 2: ���� 
	
	public StatCmpBean() {  
		this.save_dt = "";
		this.seq = 0;
		this.gubun = "";
		this.c_yy = "";
		this.c_mm = "";
		this.user_id = "";
		this.amt = 0;
		this.amt1 = 0;
		this.amt2 = 0;
		this.amt3 = 0;
		this.s_type = "";

	}

	// set Method
	public void setSave_dt(String val){	if(val==null) val="";	this.save_dt = val;		}
	public void setSeq(int i){									this.seq = i;			}
	public void setGubun(String val){	if(val==null) val="";	this.gubun = val;		}
	public void setC_yy(String val){	if(val==null) val="";	this.c_yy = val;		}
	public void setC_mm(String val){	if(val==null) val="";	this.c_mm = val;		}
	public void setUser_id(String val){	if(val==null) val="";	this.user_id = val;		}
	public void setAmt(int i){									this.amt = i;			}
	public void setAmt1(float i){									this.amt1 = i;			}
	public void setAmt2(float i){									this.amt2 = i;			}
	public void setAmt3(float i){									this.amt3 = i;			}
	public void setS_type(String val){	if(val==null) val="";	this.s_type = val;		}
	
	//Get Method
	public String getSave_dt(){			return save_dt;		}
    public int getSeq(){				return seq;			}
    public String getGubun(){			return gubun;		}
    public String getC_yy(){			return c_yy;		}
    public String getC_mm(){			return c_mm;		}
    public String getUser_id(){			return user_id;		}
	public int getAmt(){				return amt;			}
	public float getAmt1(){				return amt1;		}
	public float getAmt2(){				return amt2;		}
	public float getAmt3(){				return amt3;		}
	public String getS_type(){			return s_type;		}
 
}