/**
 * ������������
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.receive;

import java.util.*;
import java.text.*;

public class ReceiveBean {
    //Table : CAR_CHA

	private String car_mng_id;			//�ڵ���������ȣ
	private String rent_mng_id;			//��������ȣ
	private String rent_l_cd;			//����ȣ
	private String car_no;
	private String firm_nm;
	private String car_nm;
	private String car_name;
	private int    seq_no;				//SEQ_NO
	private String fine_st;				//���·�,��Ģ�� ����(3:��Ұ��, 4:�Ҽ�)
	private String fine_st_nm;
	private String call_nm;				//��ȭ��
	private String tel;					//��ȭ��ȣ
	private String fax;					//�ѽ�
	private String vio_dt;				//�����Ͻ�
	private String vio_pla;				//�������
	private String vio_cont;			//���ݳ���
	private String pol_sta;				//������	
	private String note;				//Ư�̻���	
	private String reg_id;				//���ʵ����
	private String reg_dt;				//���ʵ����
	private String update_id;			//����������
	private String update_dt;			//����������
	private String gubun;
		
	private String rent_s_cd;			//�ܱ����ȣ
	private String notice_dt;			//���Ȯ��(������)��������
	
	
    // CONSTRCTOR            
    public ReceiveBean() {  
	    this.car_mng_id		= "";		//�ڵ���������ȣ
		this.rent_mng_id	= "";		//��������ȣ
		this.rent_l_cd		= "";		//����ȣ
		this.car_no			= "";
		this.firm_nm		= "";
		this.car_nm			= "";
		this.car_name		= "";
		this.seq_no			= 0;		//SEQ_NO
		this.fine_st		= "";
		this.fine_st_nm		= "";
		this.call_nm		= "";		//��ȭ��
		this.tel			= "";		//��ȭ��ȣ
		this.fax			= "";		//�ѽ�
		this.vio_dt			= "";		//�����Ͻ�	
		this.vio_pla		= "";		//�������
		this.vio_cont		= "";		//���ݳ���	
		this.pol_sta		= "";		//������	
		this.note			= "";		//Ư�̻���		
		this.reg_id			= "";
		this.reg_dt			= "";
		this.update_id		= "";
		this.update_dt		= "";
		this.gubun			= "";	
		this.rent_s_cd		= "";
		this.notice_dt		= "";
					
	}


	// get Method
	public void setCar_mng_id	(String val){		if(val==null) val="";		this.car_mng_id		= val;	}
	public void setRent_mng_id	(String val){		if(val==null) val="";		this.rent_mng_id	= val;	}
	public void setRent_l_cd	(String val){		if(val==null) val="";		this.rent_l_cd		= val;	}
	public void setCar_no		(String val){		if(val==null) val="";		this.car_no			= val;	}
	public void setFirm_nm		(String val){		if(val==null) val="";		this.firm_nm		= val;	}
	public void setCar_nm		(String val){		if(val==null) val="";		this.car_nm			= val;	}
	public void setCar_name		(String val){		if(val==null) val="";		this.car_name		= val;	}
	public void setSeq_no		(int val)   {									this.seq_no			= val;	}	
	public void setFine_st		(String val){		if(val==null) val="";		this.fine_st		= val;	}	
	public void setCall_nm		(String val){		if(val==null) val="";		this.call_nm		= val;	}	
	public void setTel			(String val){		if(val==null) val="";		this.tel			= val;	}
	public void setFax			(String val){		if(val==null) val="";		this.fax			= val;	}
	public void setVio_dt		(String val){		if(val==null) val="";		this.vio_dt			= val;	}
	public void setVio_pla		(String val){		if(val==null) val="";		this.vio_pla		= val;	}
	public void setVio_cont		(String val){		if(val==null) val="";		this.vio_cont		= val;	}	
	public void setPol_sta		(String val){		if(val==null) val="";		this.pol_sta		= val;	}	
	public void setNote			(String val){		if(val==null) val="";		this.note			= val;	}	
	public void setReg_id		(String val){		if(val==null) val="";		this.reg_id			= val;	}
	public void setReg_dt		(String val){		if(val==null) val="";		this.reg_dt			= val;	}
	public void setUpdate_id	(String val){		if(val==null) val="";		this.update_id		= val;	}
	public void setUpdate_dt	(String val){		if(val==null) val="";		this.update_dt		= val;	}
	public void setGubun		(String val){		if(val==null) val="";		this.gubun			= val;	}
	
	public void setRent_s_cd	(String str){		if(str==null) str="";		this.rent_s_cd		= str;	}
	public void setNotice_dt	(String str){		if(str==null) str="";		this.notice_dt		= str;	}
	
	//Get Method
	public String getCar_mng_id	()		{	return car_mng_id;	}
	public String getRent_mng_id()		{	return rent_mng_id;	}
	public String getCar_no		()		{	return car_no;		}
	public String getFirm_nm	()		{	return firm_nm;		}
	public String getCar_nm		()		{	return car_nm;		}
	public String getCar_name	()		{	return car_name;	}
	public String getRent_l_cd	()		{	return rent_l_cd;	}
	public int    getSeq_no		()		{	return seq_no;		}
	public String getFine_st	()		{	return fine_st;		}
	public String getCall_nm	()		{	return call_nm;		}
	public String getTel		()		{	return tel;			}
	public String getFax		()		{	return fax;			}
	public String getVio_dt		()		{	return vio_dt;		}	
	public String getVio_pla	()		{	return vio_pla;		}
	public String getVio_cont	()		{	return vio_cont;	}
	public String getPol_sta	()		{	return pol_sta;		}
	public String getNote		()		{	return note;		}	
	public String getReg_id		()		{	return reg_id;		}
	public String getReg_dt		()		{	return reg_dt;		}
	public String getUpdate_id	()		{	return update_id;	}
	public String getUpdate_dt	()		{	return update_dt;	}
	public String getGubun		()		{	return gubun;		}

	public String getRent_s_cd	()		{	return rent_s_cd;	}  
	public String getNotice_dt	()		{	return notice_dt;	}  
	
}
