/**
 * �������� ���
 */
package acar.esti_mng;

import java.util.*;


public class EstiRegBean {
    //Table : ESTI_REG
    private String  est_id;			//������ȣ(�⵵2�ڸ�+��2�ڸ�+��2�ڸ�+'-'+�Ϸù�ȣ4�ڸ�)
	private String  est_st;			//��������(1:������, 2:������, 3:����)
	private String  car_type;		//��������(1:����, 2:�縮��)
	private String  est_dt;			//��������
    private String  est_nm;			//��/��ȣ��
    private String  est_mgr;		//�����
    private String  est_tel;		//����ó
    private String  est_fax;		//�ѽ���ȣ
    private String  car_comp_id;	//�ڵ������ȣ
    private String  car_name;		//����
    private int		car_amt;		//�����⺻����
    private int		opt_amt;		//���ð���
    private int		o_1;			//����������(����-��������, �縮��-�߰���)
    private String  car_no;			//������ȣ(�縮�����)
    private String  car_mng_id;		//����������ȣ(�縮�����)
    private String  mng_id;			//�����
	private String  reg_id;			//�����
    private String  reg_dt;			//����Ͻ�
    private String  upd_id;			//������	
    private String  upd_dt;			//��������
	private String  emp_id;
	private String  spr_kd;


    // CONSTRCTOR            
    public EstiRegBean() {  
    	this.est_id		= "";
    	this.est_st		= "";
		this.car_type	= "";
    	this.est_dt		= "";
	    this.est_nm		= "";
	    this.est_mgr	= "";
	    this.est_tel	= "";
	    this.est_fax	= "";
	    this.car_comp_id= "";
	    this.car_name	= "";
	    this.car_amt	= 0;
	    this.opt_amt	= 0;
	    this.o_1		= 0;
	    this.car_no		= "";
	    this.car_mng_id	= "";
	    this.mng_id		= "";
	    this.reg_id		= "";
		this.reg_dt		= "";
	    this.upd_id		= "";
		this.upd_dt		= "";
		this.emp_id		= "";
		this.spr_kd		= "";
	}

	// get Method
	public void setEst_id	(String val)	{	if(val==null) val="";	this.est_id		= val;	}
	public void setEst_st	(String val)	{	if(val==null) val="";	this.est_st		= val;	}
	public void setCar_type	(String val)	{	if(val==null) val="";	this.car_type	= val;	}
	public void setEst_dt	(String val)	{	if(val==null) val="";	this.est_dt		= val;	}
    public void setEst_nm	(String val)	{	if(val==null) val="";	this.est_nm		= val;	}
    public void setEst_mgr	(String val)	{	if(val==null) val="";	this.est_mgr	= val;	}
    public void setEst_tel	(String val)	{	if(val==null) val="";	this.est_tel	= val;	}
    public void setEst_fax	(String val)	{	if(val==null) val="";	this.est_fax	= val;	}
    public void setCar_comp_id(String val)	{	if(val==null) val="";	this.car_comp_id = val;	}
	public void setCar_name	(String val)	{	if(val==null) val="";	this.car_name	= val;	}
    public void setCar_amt	(int val)		{							this.car_amt	= val;	}
    public void setOpt_amt	(int val)		{							this.opt_amt	= val;	}
    public void setO_1		(int val)		{							this.o_1		= val;	}
    public void setCar_no	(String val)	{	if(val==null) val="";	this.car_no		= val;	}
    public void setCar_mng_id(String val)	{	if(val==null) val="";	this.car_mng_id = val;	}
    public void setMng_id	(String val)	{	if(val==null) val="";	this.mng_id		= val;	}
	public void setReg_id	(String val)	{	if(val==null) val="";	this.reg_id		= val;	}
	public void setReg_dt	(String val)	{	if(val==null) val="";	this.reg_dt		= val;	}
	public void setUpd_id	(String val)	{	if(val==null) val="";	this.upd_id		= val;	}
	public void setUpd_dt	(String val)	{	if(val==null) val="";	this.upd_dt		= val;	}
	public void setEmp_id	(String val)	{	if(val==null) val="";	this.emp_id		= val;	}
	public void setSpr_kd	(String val)	{	if(val==null) val="";	this.spr_kd		= val;	}
	
	//Get Method
	public String getEst_id		(){			return est_id;		}
	public String getEst_st		(){			return est_st;		}
    public String getCar_type	(){			return car_type;	}
    public String getEst_dt		(){			return est_dt;		}
    public String getEst_nm		(){			return est_nm;		}
    public String getEst_mgr	(){			return est_mgr;		}
    public String getEst_tel	(){			return est_tel;		}
    public String getEst_fax	(){			return est_fax;		}
    public String getCar_comp_id(){			return car_comp_id;	}
    public String getCar_name	(){			return car_name;	}
	public int	  getCar_amt	(){			return car_amt;		}
    public int	  getOpt_amt	(){			return opt_amt;		}
    public int	  getO_1		(){			return o_1;			}
	public String getCar_no		(){			return car_no;		}
    public String getCar_mng_id	(){			return car_mng_id;	}
    public String getMng_id		(){			return mng_id;		}
	public String getReg_id		(){			return reg_id;		}
    public String getReg_dt		(){			return reg_dt;		}
    public String getUpd_id		(){			return upd_id;		}
    public String getUpd_dt		(){			return upd_dt;		}
    public String getEmp_id		(){			return emp_id;		}
    public String getSpr_kd		(){			return spr_kd;		}

}