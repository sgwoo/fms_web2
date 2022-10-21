/**
 * ������������
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.forfeit_mng;

import java.util.*;
import java.text.*;

public class FineBean {
    //Table : CAR_CHA

	private String car_mng_id;			//�ڵ���������ȣ
	private String rent_mng_id;			//��������ȣ
	private String rent_l_cd;			//����ȣ
	private String car_no;
	private String firm_nm;
	private String car_nm;
	private String car_name;
	private int    seq_no;				//SEQ_NO
	private String fine_st;				//���·�,��Ģ�� ����(1: ���·�, 2:��Ģ��)
	private String fine_st_nm;
	private String call_nm;				//��ȭ��
	private String tel;					//��ȭ��ȣ
	private String fax;					//�ѽ�
	private String vio_dt;				//�����Ͻ�
	private String vio_dt_view;
	private String vio_pla;				//�������
	private String vio_cont;			//���ݳ���
	private String paid_st;				//���α���
	private String paid_st_nm;
	private String rec_dt;				//��������
	private String paid_end_dt;			//���α���
	private int    paid_amt;			//���αݾ�
	private int    paid_amt2;			//���αݾ�-���Ǻδ��
	private String proxy_dt;			//�볳����
	private String pol_sta;				//������
	private String paid_no;				//���ΰ�������ȣ
	private String fault_st;			//���Ǳ���
	private String fault_st_nm;
	private String dem_dt;				//û������
	private String coll_dt;				//��������
	private String rec_plan_dt;			//�Աݿ�����
	private String note;				//Ư�̻���
	//�߰�
	private String no_paid_yn;			//��������
	private String no_paid_cau;			//��������
	private String reg_id;				//���ʵ����
	private String reg_dt;				//���ʵ����
	private String update_id;			//����������
	private String update_dt;			//����������
	private String gubun;
	private int    dly_amt;
	private String dly_days;
	private String fault_nm;
	private String ext_dt;				//���ݰ�꼭 ��������
	private String ext_id;				//���ݰ�꼭 ������
	//2���߰�
	private String obj_dt1;				//1�����ǽ�û����
	private String obj_dt2;				//2�����ǽ�û����
	private String obj_dt3;				//3�����ǽ�û����
   	private String bill_doc_yn;			//�ŷ��������Կ���
	private String bill_mon;			//�ŷ��������Կ�
	private int    fault_amt;			//���������ںδ�ݾ�
	//3���߰�(2004-1-19)
	private String vat_yn;				//�ΰ��� ���Կ���
	private String tax_yn;				//���ݰ�꼭 ���࿩��
	private String f_dem_dt;			//����û����
	private String e_dem_dt;			//����û����
	private String busi_st;				//�ŷ�����
	//�߰�(2005-07-08)
	private String rent_s_cd;			//�ܱ����ȣ
	private String notice_dt;			//���Ȯ��(������)��������
	private String obj_end_dt;			//�ǰ���������
	//�߰�(2008-09-17)
	private String mng_id;				//�����
	//�߰�(2008-10-09)
	private String file_name;			//��ĵ����
	private String reg_code;			//����ڵ�
	private String file_type;			//��ĵ����	
	private String incom_dt;   //�Աݿ���:�Ա���
	private int	   incom_seq;  //�Աݿ���:����
	private String file_name2;			//��ĵ����
	private String file_type2;			//��ĵ����	
	private String proxy_est_dt;		//�볳�������� (�Ƹ���ī����)
	private int		dmidx;
	private String fine_gb; //����/�۱�
	private String fine_nm; //����/�۱�	
	private String rent_st; //20160412 �߰� 
	//20180328
	private String re_reg_id;				//������
	private String re_reg_dt;				//������
	private String vio_st;					//���ݱ���
	private String email_yn;					//�̸��� �߼� ����


    // CONSTRCTOR            
    public FineBean() {  
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
		this.vio_dt_view	= "";
		this.vio_pla		= "";		//�������
		this.vio_cont		= "";		//���ݳ���
		this.paid_st		= "";		//���α���
		this.paid_st_nm		= "";
		this.rec_dt			= "";		//��������
		this.paid_end_dt	= "";		//���α���
		this.paid_amt		= 0;		//���αݾ�
		this.paid_amt2		= 0;		//���αݾ�-���Ǻδ��
		this.proxy_dt		= "";		//�볳����
		this.pol_sta		= "";		//������
		this.paid_no		= "";		//���ΰ�������ȣ
		this.fault_st		= "";		//���Ǳ���
		this.fault_st_nm	= "";
		this.dem_dt			= "";		//û������
		this.coll_dt		= "";		//��������
		this.rec_plan_dt	= "";		//�Աݿ�����
		this.note			= "";		//Ư�̻���
		this.no_paid_yn		= "";
		this.no_paid_cau	= "";
		this.reg_id			= "";
		this.reg_dt			= "";
		this.update_id		= "";
		this.update_dt		= "";
		this.gubun			= "";
		this.dly_amt		= 0;
		this.dly_days		= "";
		this.fault_nm		= "";
		this.ext_dt			= "";
		this.ext_id			= "";
		this.obj_dt1		= "";
		this.obj_dt2		= "";
		this.obj_dt3		= "";
		this.bill_doc_yn	= "";
		this.bill_mon		= "";
		this.fault_amt		= 0;
		this.vat_yn			= "";
		this.tax_yn			= "";
		this.f_dem_dt		= "";
		this.e_dem_dt		= "";
		this.busi_st		= "";
		this.rent_s_cd		= "";
		this.notice_dt		= "";
		this.obj_end_dt		= "";
		this.mng_id			= "";
		this.file_name		= "";
		this.reg_code		= "";
		this.file_type		= "";		
		this.incom_dt 		= "";
		this.incom_seq 		= 0;
		this.file_name2		= "";
		this.file_type2		= "";		
		this.proxy_est_dt   = "";
		this.dmidx			=0;
		this.fine_gb		= "";
		this.fine_nm		= "";
		this.rent_st		= "";
		this.re_reg_id		= "";
		this.re_reg_dt		= "";
		this.vio_st			= "";		
		this.email_yn		= "";
		

		try{
    		TimeZone tz = new SimpleTimeZone( 9 * 60 * 60 * 1000, "KST" );
    		TimeZone.setDefault(tz);
    		java.util.Date d = new java.util.Date();
    		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmm");
    		vio_dt = sdf.format(d);
    	}catch(Exception dfdf){}
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
	public void setVio_dt_view	(String val){		if(val==null) val="";		this.vio_dt_view	= val;	}
	public void setVio_pla		(String val){		if(val==null) val="";		this.vio_pla		= val;	}
	public void setVio_cont		(String val){		if(val==null) val="";		this.vio_cont		= val;	}
	public void setPaid_st		(String val){		if(val==null) val="";		this.paid_st		= val;	}
	public void setPaid_st_nm	(String val){		if(val==null) val="";		this.paid_st_nm		= val;	}
	public void setRec_dt		(String val){		if(val==null) val="";		this.rec_dt			= val;	}
	public void setPaid_end_dt	(String val){		if(val==null) val="";		this.paid_end_dt	= val;	}
	public void setPaid_amt		(int val)   {									this.paid_amt		= val;	}	
	public void setPaid_amt2	(int val)   {									this.paid_amt2		= val;	}	
	public void setProxy_dt		(String val){		if(val==null) val="";		this.proxy_dt		= val;	}
	public void setPol_sta		(String val){		if(val==null) val="";		this.pol_sta		= val;	}
	public void setPaid_no		(String val){		if(val==null) val="";		this.paid_no		= val;	}
	public void setFault_st		(String val){		if(val==null) val="";		this.fault_st		= val;	}
	public void setDem_dt		(String val){		if(val==null) val="";		this.dem_dt			= val;	}
	public void setColl_dt		(String val){		if(val==null) val="";		this.coll_dt		= val;	}
	public void setRec_plan_dt	(String val){		if(val==null) val="";		this.rec_plan_dt	= val;	}
	public void setNote			(String val){		if(val==null) val="";		this.note			= val;	}
	public void setNo_paid_yn	(String val){		if(val==null) val="";		this.no_paid_yn		= val;	}
	public void setNo_paid_cau	(String val){		if(val==null) val="";		this.no_paid_cau	= val;	}
	public void setReg_id		(String val){		if(val==null) val="";		this.reg_id			= val;	}
	public void setReg_dt		(String val){		if(val==null) val="";		this.reg_dt			= val;	}
	public void setUpdate_id	(String val){		if(val==null) val="";		this.update_id		= val;	}
	public void setUpdate_dt	(String val){		if(val==null) val="";		this.update_dt		= val;	}
	public void setGubun		(String val){		if(val==null) val="";		this.gubun			= val;	}
	public void setDly_amt		(int val)   {									this.dly_amt		= val;	}	
	public void setDly_days		(String val){		if(val==null) val="";		this.dly_days		= val;	}
	public void setFault_nm		(String val){		if(val==null) val="";		this.fault_nm		= val;	}
	public void setExt_dt		(String str){		if(str==null) str="";		this.ext_dt			= str;	}
	public void setExt_id		(String str){		if(str==null) str="";		this.ext_id			= str;	}
	public void setObj_dt1		(String str){		if(str==null) str="";		this.obj_dt1		= str;	}
	public void setObj_dt2		(String str){		if(str==null) str="";		this.obj_dt2		= str;	}
	public void setObj_dt3		(String str){		if(str==null) str="";		this.obj_dt3		= str;	}
	public void setBill_doc_yn	(String str){		if(str==null) str="";		this.bill_doc_yn	= str;	}
	public void setBill_mon		(String str){		if(str==null) str="";		this.bill_mon		= str;	}
	public void setFault_amt	(int val)   {									this.fault_amt		= val;	}
	public void setVat_yn		(String str){		if(str==null) str="";		this.vat_yn			= str;	}
	public void setTax_yn		(String str){		if(str==null) str="";		this.tax_yn			= str;	}
	public void setF_dem_dt		(String str){		if(str==null) str="";		this.f_dem_dt		= str;	}
	public void setE_dem_dt		(String str){		if(str==null) str="";		this.e_dem_dt		= str;	}
	public void setBusi_st		(String str){		if(str==null) str="";		this.busi_st		= str;	}
	public void setRent_s_cd	(String str){		if(str==null) str="";		this.rent_s_cd		= str;	}
	public void setNotice_dt	(String str){		if(str==null) str="";		this.notice_dt		= str;	}
	public void setObj_end_dt	(String str){		if(str==null) str="";		this.obj_end_dt		= str;	}
	public void setMng_id		(String str){		if(str==null) str="";		this.mng_id			= str;	}
	public void setFile_name	(String str){		if(str==null) str="";		this.file_name		= str;	}
	public void setReg_code		(String str){		if(str==null) str="";		this.reg_code		= str;	}
	public void setFile_type	(String str){		if(str==null) str="";		this.file_type		= str;	}	
	public void setIncom_dt		(String str){		if(str==null) str="";		this.incom_dt		= str;	}
	public void setIncom_seq	(int val)   {									this.incom_seq		= val;	}
	public void setFile_name2	(String str){		if(str==null) str="";		this.file_name2		= str;	}
	public void setFile_type2	(String str){		if(str==null) str="";		this.file_type2		= str;	}		
	public void setProxy_est_dt	(String str){		if(str==null) str="";		this.proxy_est_dt	= str;	}	
	public void setDmidx		(int val)   {									this.dmidx			= val;	}	
	public void setFine_gb		(String str){		if(str==null) str="";		this.fine_gb		= str;	}	
	public void setFine_nm		(String str){		if(str==null) str="";		this.fine_nm		= str;	}	
	public void setRent_st		(String str){		if(str==null) str="";		this.rent_st		= str;	}	
	public void setRe_reg_id	(String val){		if(val==null) val="";		this.re_reg_id		= val;	}
	public void setRe_reg_dt	(String val){		if(val==null) val="";		this.re_reg_dt		= val;	}
	public void setVio_st		(String val){		if(val==null) val="";		this.vio_st			= val;	}
	public void setEmail_yn		(String val){		if(val==null) val="";		this.email_yn			= val;	}


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
	public String getVio_dt_view()		{	return vio_dt_view;	}
	public String getVio_pla	()		{	return vio_pla;		}
	public String getVio_cont	()		{	return vio_cont;	}
	public String getPaid_st	()		{	return paid_st;		}
	public String getRec_dt		()		{	return rec_dt;		}
	public String getPaid_end_dt()		{	return paid_end_dt;	}
	public int    getPaid_amt	()		{	return paid_amt;	}
	public int    getPaid_amt2	()		{	return paid_amt2;	}
	public String getProxy_dt	()		{	return proxy_dt;	}
	public String getPol_sta	()		{	return pol_sta;		}
	public String getPaid_no	()		{	return paid_no;		}
	public String getFault_st	()		{	return fault_st;	}
	public String getDem_dt		()		{	return dem_dt;		}
	public String getColl_dt	()		{	return coll_dt;		}
	public String getRec_plan_dt()		{	return rec_plan_dt;	}
	public String getNote		()		{	return note;		}
	public String getNo_paid_yn	()		{	return no_paid_yn;	}
	public String getNo_paid_cau()		{	return no_paid_cau;	}
	public String getReg_id		()		{	return reg_id;		}
	public String getReg_dt		()		{	return reg_dt;		}
	public String getUpdate_id	()		{	return update_id;	}
	public String getUpdate_dt	()		{	return update_dt;	}
	public String getGubun		()		{	return gubun;		}
	public int    getDly_amt	()		{	return dly_amt;		}
	public String getDly_days	()		{	return dly_days;	}
	public String getFault_nm	()		{	return fault_nm;	}
	public String getExt_dt		()		{	return ext_dt;		}  
	public String getExt_id		()		{	return ext_id;		}  
	public String getObj_dt1	()		{	return obj_dt1;		}  
	public String getObj_dt2	()		{	return obj_dt2;		}  
	public String getObj_dt3	()		{	return obj_dt3;		}  
	public String getBill_doc_yn()		{	return bill_doc_yn; }  
	public String getBill_mon	()		{	return bill_mon;	}  
	public int    getFault_amt	()		{	return fault_amt;	}
	public String getVat_yn		()		{	return vat_yn;		}  
	public String getTax_yn		()		{	return tax_yn;		}  
	public String getF_dem_dt	()		{	return f_dem_dt;	}  
	public String getE_dem_dt	()		{	return e_dem_dt;	}  
	public String getBusi_st	()		{	return busi_st;		}  
	public String getRent_s_cd	()		{	return rent_s_cd;	}  
	public String getNotice_dt	()		{	return notice_dt;	}  
	public String getObj_end_dt	()		{	return obj_end_dt;	}  
	public String getMng_id		()		{	return mng_id;		}  
	public String getFile_name	()		{	return file_name;	}  
	public String getFile_type	()		{	return file_type;	}  
	public String getReg_code	()		{	return reg_code;	}  	
	public String getIncom_dt	()		{	return incom_dt;	}  
	public int    getIncom_seq	()		{	return incom_seq;	}
	public String getFile_name2	()		{	return file_name2;	}  
	public String getFile_type2	()		{	return file_type2;	}  	
	public String getProxy_est_dt()		{	return proxy_est_dt;}  
	public int    getDmidx		()		{	return dmidx;		}
	public String getFine_gb	()		{	return fine_gb;		}  
	public String getFine_nm	()		{	return fine_nm;		}  
	public String getRent_st	()		{	return rent_st;		} 
	public String getRe_reg_id	()		{	return re_reg_id;	}
	public String getRe_reg_dt	()		{	return re_reg_dt;	}
	public String getVio_st		()		{	return vio_st;		}
	public String getEmail_yn		()		{	return email_yn;		}

	public String getFine_st_nm(){
		if(fine_st.equals("1"))			{		fine_st_nm = "���·�";
		}else if(fine_st.equals("2"))	{		fine_st_nm = "��Ģ��";
		}
		return fine_st_nm;
	}
	public String getPaid_st_nm(){
		if(paid_st.equals("1"))			{		paid_st_nm = "�����ں���";
		}else if(paid_st.equals("2"))	{		paid_st_nm = "������";
		}else if(paid_st.equals("3"))	{		paid_st_nm = "ȸ��볳";
		}else if(paid_st.equals("4"))	{		paid_st_nm = "���ݳ���";
		}
		return paid_st_nm;
	}
	public String getFault_st_nm(){
		if(fault_st.equals("1"))		{		fault_st_nm = "������";
		}else if(fault_st.equals("2"))	{		fault_st_nm = "���������";
		}
		return fault_st_nm;
	}
	
}
