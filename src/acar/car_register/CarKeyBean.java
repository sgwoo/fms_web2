/**
 * �ڵ���Ű ���, ��/������
 * @ author : JHM
 * @ create date : 2007. 07. 12
 * @ last modify date : 
 */
package acar.car_register;

import java.util.*;

public class CarKeyBean {
    //Table : CAR_KEY + CAR_KDY_MNG
    private String	car_mng_id;			//�ڵ���������ȣ
	private int		seq;				//�Ϸù�ȣ
	private String	out_dt;				//�������
	private String	out_id;				//�����
	private String	out_st;				//����������
	private String	cau;				//��Ÿ����
	private String	in_dt;				//�԰�����
	private String	key_kd;				//Ű����
	private String	key_yn;				//��������
	private int		key_kd1;			//Ű������������=�Ϲݺ���Ű
	private int		key_kd2;			//Ű������������=ī�Ǻ���Ű
	private int		key_kd3;			//Ű������������=������
	private int		key_kd4;			//Ű������������=����ƮŰ
	private int		key_kd5;			//Ű������������=��Ÿ
	private String	reg_id;				//�����
	private String	reg_dt;				//�����
	private String	upd_id;				//������
	private String	upd_dt;				//������
	private String	out_st_nm;			//����������
	private String	out_id_nm;			//�����
	private String	key_kd_nm;			//Ű����
	private String	key_kd5_nm;			//Ű����
        
    // CONSTRCTOR            
    public CarKeyBean() {  
	    this.car_mng_id	= "";
		this.seq		= 0;
		this.out_dt		= "";
		this.out_id		= "";
		this.out_st		= "";
		this.cau		= "";
		this.in_dt		= "";
		this.key_kd		= "";
		this.key_yn		= "";
		this.key_kd1	= 0;
		this.key_kd2	= 0;
		this.key_kd3	= 0;
		this.key_kd4	= 0;
		this.key_kd5	= 0;
		this.reg_id		= "";
		this.reg_dt		= "";
		this.upd_id		= "";
		this.upd_dt		= "";
		this.out_id_nm	= "";
		this.out_st_nm	= "";
		this.key_kd_nm	= "";
		this.key_kd5_nm	= "";
	}

	// get Method
	public void setCar_mng_id	(String val){		if(val==null) val="";		this.car_mng_id	= val;	}
	public void setSeq			(int val)	{									this.seq		= val;	}	
	public void setOut_dt		(String val){		if(val==null) val="";		this.out_dt		= val;	}
	public void setOut_id		(String val){		if(val==null) val="";		this.out_id		= val;	}
	public void setOut_st		(String val){		if(val==null) val="";		this.out_st		= val;	}
	public void setCau			(String val){		if(val==null) val="";		this.cau		= val;	}
	public void setIn_dt		(String val){		if(val==null) val="";		this.in_dt		= val;	}
	public void setKey_kd		(String val){		if(val==null) val="";		this.key_kd		= val;	}
	public void setKey_yn		(String val){		if(val==null) val="";		this.key_yn		= val;	}
	public void setKey_kd1		(int val)	{									this.key_kd1	= val;	}	
	public void setKey_kd2		(int val)	{									this.key_kd2	= val;	}	
	public void setKey_kd3		(int val)	{									this.key_kd3	= val;	}	
	public void setKey_kd4		(int val)	{									this.key_kd4	= val;	}	
	public void setKey_kd5		(int val)	{									this.key_kd5	= val;	}	
	public void setReg_id		(String val){		if(val==null) val="";		this.reg_id		= val;	}
	public void setReg_dt		(String val){		if(val==null) val="";		this.reg_dt		= val;	}
	public void setUpd_id		(String val){		if(val==null) val="";		this.upd_id		= val;	}
	public void setUpd_dt		(String val){		if(val==null) val="";		this.upd_dt		= val;	}
	public void setOut_id_nm	(String val){		if(val==null) val="";		this.out_id_nm	= val;	}
	public void setOut_st_nm	(String val){		if(val==null) val="";		this.out_st_nm	= val;	}
	public void setKey_kd_nm	(String val){		if(val==null) val="";		this.key_kd_nm	= val;	}
	public void setKey_kd5_nm	(String val){		if(val==null) val="";		this.key_kd5_nm	= val;	}
	
	//Get Method
	public String	getCar_mng_id	(){		return car_mng_id;	}
	public int		getSeq			(){		return seq;			}
	public String	getOut_dt		(){		return out_dt;		}
	public String	getOut_id		(){		return out_id;		}
	public String	getOut_st		(){		return out_st;		}
	public String	getCau			(){		return cau;			}
	public String	getIn_dt		(){		return in_dt;		}
	public String	getKey_kd		(){		return key_kd;		}
	public String	getKey_yn		(){		return key_yn;		}
	public int		getKey_kd1		(){		return key_kd1;		}
	public int		getKey_kd2		(){		return key_kd2;		}
	public int		getKey_kd3		(){		return key_kd3;		}
	public int		getKey_kd4		(){		return key_kd4;		}
	public int		getKey_kd5		(){		return key_kd5;		}
	public String	getReg_id		(){		return reg_id;		}
	public String	getReg_dt		(){		return reg_dt;		}
	public String	getUpd_id		(){		return upd_id;		}
	public String	getUpd_dt		(){		return upd_dt;		}
	public String	getOut_id_nm	(){		return out_id_nm;	}
	public String	getOut_st_nm	(){		return out_st_nm;	}
	public String	getKey_kd_nm	(){		return key_kd_nm;	}
	public String	getKey_kd5_nm	(){		return key_kd5_nm;	}
}