/**
 * �������� ����
 */
package acar.esti_mng;

import java.util.*;


public class EstiContBean {
    //Table : ESTI_CONT
    private String  est_id;			//������ȣ(�⵵2�ڸ�+��2�ڸ�+��2�ڸ�+'-'+�Ϸù�ȣ4�ڸ�)
	private String  seq;			//�Ϸù�ȣ
	private String  reg_dt;			//�����
	private String  reg_id;			//�����
    private String	title;			//����
    private String	cont;			//����
    private String  end_type;		//��������
    private String  nend_st;		//��ü�ᱸ��
    private String  nend_cau;		//��ü�����
	private String  reg_time;

    // CONSTRCTOR            
    public EstiContBean() {  
    	this.est_id		= "";
    	this.seq		= "";
		this.reg_dt		= "";
    	this.reg_id		= "";
	    this.title		= "";
	    this.cont		= "";
	    this.end_type	= "";
	    this.nend_st	= "";
		this.nend_cau	= "";
		this.reg_time	= "";
	}

	// get Method
	public void setEst_id	(String val)	{	if(val==null) val="";	this.est_id		= val;	}
	public void setSeq		(String val)	{	if(val==null) val="";	this.seq		= val;	}
	public void setReg_dt	(String val)	{	if(val==null) val="";	this.reg_dt		= val;	}
	public void setReg_id	(String val)	{	if(val==null) val="";	this.reg_id		= val;	}
    public void setTitle	(String val)	{	if(val==null) val="";	this.title		= val;	}
    public void setCont		(String val)	{	if(val==null) val="";	this.cont		= val;	}
	public void setEnd_type	(String val)	{	if(val==null) val="";	this.end_type	= val;	}
    public void setNend_st	(String val)	{	if(val==null) val="";	this.nend_st	= val;	}
    public void setNend_cau	(String val)	{	if(val==null) val="";	this.nend_cau	= val;	}
    public void setReg_time	(String val)	{	if(val==null) val="";	this.reg_time	= val;	}
	
	//Get Method
	public String getEst_id		(){			return est_id;		}
	public String getSeq		(){			return seq;			}
    public String getReg_dt		(){			return reg_dt;		}
    public String getReg_id		(){			return reg_id;		}
	public String getTitle		(){			return title;		}
	public String getCont		(){			return cont;		}
    public String getEnd_type	(){			return end_type;	}
	public String getNend_st	(){			return nend_st;		}
	public String getNend_cau	(){			return nend_cau;	}
	public String getReg_time	(){			return reg_time;	}

}
