/**
 * �ڵ�������� ��/������
 * @ author : JHM
 * @ create date : 2007. 07. 12
 * @ last modify date : 
 */
package acar.car_register;

import java.util.*;

public class CarDocBean {
    //Table : CAR_DOC_MNG
    private String	car_mng_id;			//�ڵ���������ȣ
	private int		seq;				//�Ϸù�ȣ
	private String	out_dt;				//�������
	private String	out_id;				//�����
	private String	out_st;				//����������
	private String	cau;				//��Ÿ����
	private String	in_dt;				//�԰�����
	private String	out_st_nm;			//����������
	private String	out_id_nm;			//�����
        
    // CONSTRCTOR            
    public CarDocBean() {  
	    this.car_mng_id	= "";
		this.seq		= 0;
		this.out_dt		= "";
		this.out_id		= "";
		this.out_st		= "";
		this.cau		= "";
		this.in_dt		= "";
		this.out_id_nm	= "";
		this.out_st_nm	= "";
	}

	// get Method
	public void setCar_mng_id	(String val){		if(val==null) val="";		this.car_mng_id	= val;	}
	public void setSeq			(int val)	{									this.seq		= val;	}	
	public void setOut_dt		(String val){		if(val==null) val="";		this.out_dt		= val;	}
	public void setOut_id		(String val){		if(val==null) val="";		this.out_id		= val;	}
	public void setOut_st		(String val){		if(val==null) val="";		this.out_st		= val;	}
	public void setCau			(String val){		if(val==null) val="";		this.cau		= val;	}
	public void setIn_dt		(String val){		if(val==null) val="";		this.in_dt		= val;	}
	public void setOut_id_nm	(String val){		if(val==null) val="";		this.out_id_nm	= val;	}
	public void setOut_st_nm	(String val){		if(val==null) val="";		this.out_st_nm	= val;	}
	
	//Get Method
	public String	getCar_mng_id	(){		return car_mng_id;	}
	public int		getSeq			(){		return seq;			}
	public String	getOut_dt		(){		return out_dt;		}
	public String	getOut_id		(){		return out_id;		}
	public String	getOut_st		(){		return out_st;		}
	public String	getCau			(){		return cau;			}
	public String	getIn_dt		(){		return in_dt;		}
	public String	getOut_id_nm	(){		return out_id_nm;	}
	public String	getOut_st_nm	(){		return out_st_nm;	}

}