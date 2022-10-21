/**
 * �������� �������� ����
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 01. 23.
 * @ last modify date : - 3.14.Fri. �ڵ�����Ͽ��� ����������ȿ�Ⱓ1,2 �߰�.
 *						- 2003.06.18.Thu. �����,������ȿ�Ⱓ �߰�
 *						- 2004.02.12.��. car_jnm �����߰�.
 */
package acar.offls_yb;

import java.util.*;

public class Offls_ybBean {
    //Table : CAR_REG �ڵ������
	private String car_mng_id; 					//�ڵ���������ȣ
	private String car_no; 						//������ȣ
	private String car_num; 					//�����ȣ
	private String init_reg_dt; 				//���ʵ����
	private String car_kd; 						//����
	private String car_use; 					//�뵵
	private String car_nm; 						//����
	private String car_jnm;						//������
	private String car_form;					//����
	private String car_y_form; 					//����
	private String dpm; 						//���_��ⷮ
	private String fuel_kd; 					//���_����������
	private String maint_st_dt; 				//�˻���ȿ�Ⱓ1
	private String maint_end_dt; 				//�˻���ȿ�Ⱓ2
	private String test_st_dt;					//������ȿ�Ⱓ1
	private String test_end_dt;					//������ȿ�Ⱓ2
	private String car_l_cd;					//�����⵵����ϼ���
	private String prepare;						//��������20060424
	//Table : CAR_ETC �����⺻����
	private String rent_mng_id;	//��������ȣ
	private String rent_l_cd;	//����ȣ
	private String car_id;	//������̵�
	private String colo;	//Į��
	private String opt;	//���û��
	private int car_cs_amt;//��������_�Һ���_���ް�
	private int car_cv_amt; //��������_�Һ���_�ΰ���
	private int car_fs_amt; //��������_�鼼_���ް�
	private int car_fv_amt; //��������_�鼼_�ΰ���
	private int opt_cs_amt; //�ɼǰ���_�Һ���_���ް�
	private int opt_cv_amt; //�ɼǰ���_�Һ���_�ΰ���
	private int opt_fs_amt; //�ɼǰ���_�鼼_���ް�
	private int opt_fv_amt; //�ɼǰ���_�鼼_�ΰ���
	private int clr_cs_amt; //Į�󰡰�_�Һ���_���ް�
	private int clr_cv_amt; //Į�󰡰�_�Һ���_�ΰ���
	private int clr_fs_amt; //Į�󰡰�_�鼼_���ް�
	private int clr_fv_amt; //Į�󰡰�_�鼼_�ΰ���
	private int sd_cs_amt; //Ź�۰���_�Һ���_���ް�
	private int sd_cv_amt; //Ź�۰���_�Һ���_�ΰ���
	private int sd_fs_amt; //Ź�۰���_�鼼_���ް�
	private int sd_fv_amt; //Ź�۰���_�鼼_�ΰ���
	private int dc_cs_amt; //����DC_�Һ���_���ް�
	private int dc_cv_amt; //����DC_�Һ���_�ΰ���
	private int dc_fs_amt; //����DC_�鼼_���ް�
	private int dc_fv_amt; //����DC_�鼼_�ΰ���
	//Table : CONT ������
	private String mng_id;	//���������
	private String dlv_dt;	//�������
	//Table : ACCIDENT �������
	private String accident_yn;
	//Table : SERVICE ����/����
	private int tot_dist;		//������Ÿ�
	private int average_dist;	//�������Ÿ�
	private int today_dist;		//���翹������Ÿ�
	//Table : ALLOT �Һ�
	private String bank_nm;		//�������
	private int lend_prn;		//�������
	private int lend_rem;		//��ȯ�����ܾ�
	private String alt_end_dt;	//�ҺαⰣ_����(��ȯ������)
	//Table : APPRSL ��ǰ��
	private String lev;			//�򰡵��
	private String reason;		//�򰡿���
	private String car_st;		//��������
	private String imgfile1;	//�̹���1
	private String imgfile2;	//�̹���2
	private String imgfile3;	//�̹���3
	private String imgfile4;	//�̹���4
	private String imgfile5;	//�̹���5
	private String damdang_id;	//�����id
	private String modify_id;	//����������id
	private String apprsl_dt;	//��ǰ������
	private String driver;		//�ݳ���������
	//Table : CAR_CHA ������ġ�������
	private String car_cha_yn;	//������������
	//Table : INSUR ����
	private String ins_com_nm;	//����ȸ���
	private String ins_exp_dt;	//���踸����
	//Table : RENT_CONT ����ý���
	private String rent_st_nm;	//���౸��
	private String ret_plan_dt;	//���������Ͻ�
	private String secondhand;	//�縮������
	private String use_mon;		//���ɰ���
	private String car_end_dt;	//���������Ͻ�
	private String gps;
	private String park_nm;
	private String jg_code;		//�����ڵ�
	private String con_f_nm;	//�����Ǻ�����
	private String park_cont;
	private String rm_yn; //����Ʈ����
	private String car_gu; //�ڻ�������
	private String ncar_spe_dc_amt;		//�����μ��ź� Ư������ �ݾ�
	private String spe_dc_per;			//Ư��������
	
    // CONSTRCTOR            
    public Offls_ybBean() {
		this.car_mng_id = ""; 					//�ڵ���������ȣ
		this.car_no = ""; 						//������ȣ
		this.car_num = "";						//�����ȣ
		this.init_reg_dt = ""; 					//���ʵ����
		this.car_kd = ""; 						//����
		this.car_use = ""; 						//�뵵
		this.car_nm = ""; 						//����
		this.car_jnm = "";						//������
		this.car_form = "";						//����
		this.car_y_form = ""; 					//����
		this.dpm = ""; 							//���_��ⷮ
		this.fuel_kd = ""; 						//���_����������
		this.maint_st_dt = ""; 					//�˻���ȿ�Ⱓ1
		this.maint_end_dt = ""; 				//�˻���ȿ�Ⱓ2
		this.test_st_dt = "";					//������ȿ�Ⱓ1
		this.test_end_dt = "";					//������ȿ�Ⱓ2
		this.car_l_cd = "";						//�⵵����������
		this.prepare = "";						//��������20060424
		this.rent_mng_id = ""; //��������ȣ
		this.rent_l_cd = ""; //����ȣ
		this.car_id = ""; //������̵�
		this.colo = ""; //Į��
		this.opt = ""; //���û��
		this.car_cs_amt = 0; //��������_�Һ���_���ް�
		this.car_cv_amt = 0; //�ΰ���
		this.car_fs_amt = 0; //�鼼_���ް�
		this.car_fv_amt = 0; //�ΰ���
		this.opt_cs_amt = 0;
		this.opt_cv_amt = 0;
		this.opt_fs_amt = 0;
		this.opt_fv_amt = 0;
		this.clr_cs_amt = 0;
		this.clr_cv_amt = 0;
		this.clr_fs_amt = 0;
		this.clr_fv_amt = 0;
		this.sd_cs_amt = 0;
		this.sd_cv_amt = 0;
		this.sd_fs_amt = 0;
		this.sd_fv_amt = 0;
		this.dc_cs_amt = 0;
		this.dc_cv_amt = 0;
		this.dc_fs_amt = 0;
		this.dc_fv_amt = 0;
		this.mng_id = "";
		this.dlv_dt = "";
		this.accident_yn = "";
		this.tot_dist = 0;
		this.average_dist = 0;
		this.today_dist = 0;
		this.bank_nm = "";
		this.lend_prn = 0;
		this.lend_rem = 0;
		this.alt_end_dt = "";
		this.lev = "";
		this.reason = "";
		this.car_st = "";
		this.imgfile1 = "";
		this.imgfile2 = "";
		this.imgfile3 = "";
		this.imgfile4 = "";
		this.imgfile5 = "";
		this.damdang_id = "";
		this.modify_id = "";
		this.apprsl_dt = "";
		this.driver = "";
		this.car_cha_yn = "";
		this.ins_com_nm = "";
		this.ins_exp_dt = "";
		this.rent_st_nm = "";
		this.ret_plan_dt = "";
		this.secondhand = "";
		this.use_mon = "";
		this.car_end_dt = "";
		this.gps = "";
		this.park_nm ="";
		this.jg_code ="";
		this.con_f_nm="";
		this.park_cont ="";
		this.rm_yn = "";
		this.car_gu = "";
		this.ncar_spe_dc_amt= "";
		this.spe_dc_per= "";
	}

	// set Method
	public void setCar_mng_id(String val){if(val==null) val="";	this.car_mng_id = val;}
	public void setCar_no(String val){if(val==null) val="";	this.car_no = val;}
	public void setCar_num(String val){if(val==null) val=""; this.car_num = val;}
	public void setInit_reg_dt(String val){	if(val==null) val=""; this.init_reg_dt = val;}
	public void setCar_kd(String val){if(val==null) val=""; this.car_kd = val;}
	public void setCar_use(String val){if(val==null) val=""; this.car_use = val;}
	public void setCar_nm(String val){if(val==null) val=""; this.car_nm = val;}
	public void setCar_jnm(String val){if(val==null) val=""; this.car_jnm = val;}
	public void setCar_form(String val){if(val==null) val=""; this.car_form = val;}
	public void setCar_y_form(String val){if(val==null) val=""; this.car_y_form = val;}
	public void setDpm(String val){if(val==null) val=""; this.dpm = val;}
	public void setFuel_kd(String val){if(val==null) val=""; this.fuel_kd = val;}
	public void setMaint_st_dt(String val){if(val==null) val=""; this.maint_st_dt = val;}
	public void setMaint_end_dt(String val){if(val==null) val=""; this.maint_end_dt = val;}
	public void setTest_st_dt(String val){if(val==null) val=""; this.test_st_dt = val;}
	public void setTest_end_dt(String val){if(val==null) val=""; this.test_end_dt = val;}
	public void setCar_l_cd(String val){ if(val==null) val=""; this.car_l_cd = val; }
	public void setPrepare(String val){ if(val==null) val=""; this.prepare = val; }
	public void setRent_mng_id(String val){ if (val==null) val=""; this.rent_mng_id = val; }
	public void setRent_l_cd(String val){ if(val==null) val=""; this.rent_l_cd = val; }
	public void setCar_id(String val){ if(val==null) val=""; this.car_id = val;}
	public void setColo(String val){if(val==null) val=""; this.colo = val;}
	public void setOpt(String val){if(val==null) val=""; this.opt = val;}
	public void setCar_cs_amt(int val){ this.car_cs_amt = val;}
	public void setCar_cv_amt(int val){ this.car_cv_amt = val;}
	public void setCar_fs_amt(int val){ this.car_fs_amt = val;}
	public void setCar_fv_amt(int val){ this.car_fv_amt = val;}
	public void setOpt_cs_amt(int val){ this.opt_cs_amt = val;}
	public void setOpt_cv_amt(int val){ this.opt_cv_amt = val;}
	public void setOpt_fs_amt(int val){ this.opt_fs_amt = val;}
	public void setOpt_fv_amt(int val){ this.opt_fv_amt = val;}
	public void setClr_cs_amt(int val){ this.clr_cs_amt = val;}
	public void setClr_cv_amt(int val){ this.clr_cv_amt = val;}
	public void setClr_fs_amt(int val){ this.clr_fs_amt = val;}
	public void setClr_fv_amt(int val){ this.clr_fv_amt = val;}
	public void setSd_cs_amt(int val){ this.sd_cs_amt = val;}
	public void setSd_cv_amt(int val){ this.sd_cv_amt = val;}
	public void setSd_fs_amt(int val){ this.sd_fs_amt = val;}
	public void setSd_fv_amt(int val){ this.sd_fv_amt = val;}
	public void setDc_cs_amt(int val){ this.dc_cs_amt = val;}
	public void setDc_cv_amt(int val){ this.dc_cv_amt = val;}
	public void setDc_fs_amt(int val){ this.dc_fs_amt = val;}
	public void setDc_fv_amt(int val){ this.dc_fv_amt = val;}
	public void setMng_id(String val){ if(val==null) val=""; this.mng_id = val; }
	public void setDlv_dt(String val){ if(val==null) val=""; this.dlv_dt = val; }
	public void setAccident_yn(String val){ if(val==null) val=""; this.accident_yn = val; }
	public void setTot_dist(int val){ this.tot_dist = val; }
	public void setAverage_dist(int val){ this.average_dist = val; }
	public void setToday_dist(int val){ this.today_dist = val; }
	public void setBank_nm(String val){ if(val==null) val=""; this.bank_nm = val; }
	public void setLend_prn(int val){ this.lend_prn = val; }
	public void setLend_rem(int val){ this.lend_rem = val; }
	public void setAlt_end_dt(String val){ if(val==null) val=""; this.alt_end_dt = val; }
	public void setLev(String val){ if(val==null) val=""; this.lev = val; }
	public void setReason(String val){ if(val==null) val=""; this.reason = val; }
	public void setCar_st(String val){ if(val==null) val=""; this.car_st = val; }
	public void setImgfile1(String val){ if(val==null) val=""; this.imgfile1 = val; }
	public void setImgfile2(String val){ if(val==null) val=""; this.imgfile2 = val; }
	public void setImgfile3(String val){ if(val==null) val=""; this.imgfile3 = val; }
	public void setImgfile4(String val){ if(val==null) val=""; this.imgfile4 = val; }
	public void setImgfile5(String val){ if(val==null) val=""; this.imgfile5 = val; }
	public void setDamdang_id(String val){ if(val==null) val=""; this.damdang_id = val; }
	public void setModify_id(String val){ if(val==null) val=""; this.modify_id = val; }
	public void setApprsl_dt(String val){ if(val==null) val=""; this.apprsl_dt = val; }
	public void setDriver(String val){ if(val==null) val=""; this.driver = val; }
	public void setCar_cha_yn(String val){ if(val==null) val=""; this.car_cha_yn = val; }
	public void setIns_com_nm(String val){ if(val==null) val=""; this.ins_com_nm = val; }
	public void setIns_exp_dt(String val){ if(val==null) val=""; this.ins_exp_dt = val; }
	public void setRent_st_nm(String val){ if(val==null) val=""; this.rent_st_nm = val; }
	public void setRet_plan_dt(String val){ if(val==null) val=""; this.ret_plan_dt = val; }
	public void setSecondhand(String val){ if(val==null) val=""; this.secondhand = val; }
	public void setUse_mon(String val){ if(val==null) val=""; this.use_mon = val; }
	public void setCar_end_dt(String val){ if(val==null) val=""; this.car_end_dt = val; }
	public void setGps(String val){ if(val==null) val=""; this.gps = val; }
	public void setPark_nm(String val){ if(val==null) val=""; this.park_nm = val; }
	public void setJg_code(String val){ if(val==null) val=""; this.jg_code = val; }
	public void setCon_f_nm(String val){ if(val==null) val=""; this.con_f_nm = val; }
	public void setPark_cont(String val){ if(val==null) val=""; this.park_cont = val; }
	public void setRm_yn(String val){ if(val==null) val=""; this.rm_yn = val; }
	public void setCar_gu(String val){ if(val==null) val=""; this.car_gu = val; }
	public void setNcar_spe_dc_amt(String val){		if(val==null) val="";		this.ncar_spe_dc_amt= val;	}	
	public void setSpe_dc_per(String val){			if(val==null) val="";		this.spe_dc_per= val;		}	

	//get Method
	public String getCar_mng_id(){return car_mng_id;}
	public String getCar_no(){return car_no;}
	public String getCar_num(){	return car_num;}
	public String getInit_reg_dt(){	return init_reg_dt;}
	public String getCar_kd(){	return car_kd;}
	public String getCar_use(){	return car_use;}
	public String getCar_nm(){return car_nm;}
	public String getCar_jnm(){return car_jnm;}
	public String getCar_form(){ return car_form; }
	public String getCar_y_form(){return car_y_form;}
	public String getDpm(){return dpm;}
	public String getFuel_kd(){return fuel_kd;}
	public String getMaint_st_dt(){return maint_st_dt;}
	public String getMaint_end_dt(){return maint_end_dt;}
	public String getTest_st_dt(){return test_st_dt;}
	public String getTest_end_dt(){return test_end_dt;}
	public String getCar_l_cd(){ return car_l_cd; }
	public String getPrepare(){ return prepare; }
	public String getRent_mng_id(){ return rent_mng_id; }
	public String getRent_l_cd(){ return rent_l_cd; }
	public String getCar_id(){ return car_id; }
	public String getColo(){ return colo; }
	public String getOpt(){ return opt; }
	public int getCar_cs_amt(){ return car_cs_amt; }
	public int getCar_cv_amt(){ return car_cv_amt; }
	public int getCar_fs_amt(){ return car_fs_amt; }
	public int getCar_fv_amt(){ return car_fv_amt; }
	public int getOpt_cs_amt(){ return opt_cs_amt; }
	public int getOpt_cv_amt(){ return opt_cv_amt; }
	public int getOpt_fs_amt(){ return opt_fs_amt; }
	public int getOpt_fv_amt(){ return opt_fv_amt; }
	public int getClr_cs_amt(){ return clr_cs_amt; }
	public int getClr_cv_amt(){ return clr_cv_amt; }
	public int getClr_fs_amt(){ return clr_fs_amt; }
	public int getClr_fv_amt(){ return clr_fv_amt; }
	public int getSd_cs_amt(){ return sd_cs_amt; }
	public int getSd_cv_amt(){ return sd_cv_amt; }
	public int getSd_fs_amt(){ return sd_fs_amt; }
	public int getSd_fv_amt(){ return sd_fv_amt; }
	public int getDc_cs_amt(){ return dc_cs_amt; }
	public int getDc_cv_amt(){ return dc_cv_amt; }
	public int getDc_fs_amt(){ return dc_fs_amt; }
	public int getDc_fv_amt(){ return dc_fv_amt; }
	public String getMng_id(){ return mng_id; }
	public String getDlv_dt(){ return dlv_dt; }
	public String getAccident_yn(){ return accident_yn; }
	public int getTot_dist(){ return tot_dist; }
	public int getAverage_dist(){ return average_dist; }
	public int getToday_dist(){ return today_dist; }
	public String getBank_nm(){ return bank_nm; }
	public int getLend_prn(){ return lend_prn; }
	public int getLend_rem(){ return lend_rem; }
	public String getAlt_end_dt(){ return alt_end_dt; }
	public String getLev(){ return lev; }
	public String getReason(){ return reason; }
	public String getCar_st(){ return car_st; }
	public String getImgfile1(){ return imgfile1; }
	public String getImgfile2(){ return imgfile2; }
	public String getImgfile3(){ return imgfile3; }
	public String getImgfile4(){ return imgfile4; }
	public String getImgfile5(){ return imgfile5; }
	public String getDamdang_id(){ return damdang_id; }
	public String getModify_id(){ return modify_id; }
	public String getApprsl_dt(){ return apprsl_dt; }
	public String getDriver(){ return driver; }
	public String getCar_cha_yn(){ return car_cha_yn; }
	public String getIns_com_nm(){ return ins_com_nm; }
	public String getIns_exp_dt(){ return ins_exp_dt; }
	public String getRent_st_nm(){ return rent_st_nm; }
	public String getRet_plan_dt(){ return ret_plan_dt; }
	public String getSecondhand(){ return secondhand; }
	public String getUse_mon(){ return use_mon; }
	public String getCar_end_dt(){ return car_end_dt; }
	public String getGps(){ return gps; }
	public String getPark_nm(){ return park_nm; }
	public String getJg_code(){ return jg_code; }
	public String getCon_f_nm(){ return con_f_nm; }
	public String getPark_cont(){ return park_cont; }
	public String getRm_yn(){ return rm_yn; }
	public String getCar_gu(){ return car_gu; }
	public String getNcar_spe_dc_amt(){		return ncar_spe_dc_amt;	}
	public String getSpe_dc_per(){			return spe_dc_per;	}
	
}