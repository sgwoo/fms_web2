/**
 * �������� ��ǰó����Ȳ ����
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 06. 07. Sat.
 * @ last modify date : 
 *						- 2003.06.18.Thu. �����,������ȿ�Ⱓ �߰�
						- 2004.02.12.��. car_jnm �����߰�.
 */
package acar.offls_after;

import java.util.*;

public class Offls_afterBean {
    //Table : CAR_REG �ڵ������
	private String car_mng_id; 					//�ڵ���������ȣ
	private String car_no; 						//������ȣ
	private String car_num; 					//�����ȣ
	private String init_reg_dt; 				//���ʵ����
	private String car_kd; 						//����
	private String car_use; 					//�뵵
	private String car_nm; 						//����
	private String car_jnm; 					//������
	private String car_form;					//����
	private String car_y_form; 					//����
	private String dpm; 						//���_��ⷮ
	private String fuel_kd; 					//���_����������
	private String maint_st_dt; 				//�˻���ȿ�Ⱓ1
	private String maint_end_dt; 				//�˻���ȿ�Ⱓ2
	private String test_st_dt;					//������ȿ�Ⱓ1
	private String test_end_dt;					//������ȿ�Ⱓ2
	private String off_ls;						//������������
	private String car_l_cd;					//�⵵��������ϼ���
	//Table : CAR_ETC �����⺻����
	private String rent_mng_id;	//��������ȣ
	private String rent_l_cd;	//����ȣ
	private String car_id;	//�������̵�
	private String colo;	//Į��
	private String opt;	//���û��
	private String lpg_yn;		//LPG����
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
	private String alt_end_dt;	//�ҺαⰣ�շ�(��ȯ������)
	//Table : APPRSL ��ǰ��
	private String lev;			//�򰡵��
	private String reason;		//�򰡿���
	private String car_st;		//��������
	private String imgfile1;	//�̹���1
	private String imgfile2;	//�̹���2
	private String imgfile3;	//�̹���3
	private String imgfile4;	//�̹���4
	private String imgfile5;	//�̹���5
	private String km;			//km��
	private String determ_id;	//���ݰ�����
	private int hppr;			//�����
	private int stpr;			//���۰�
	private String damdang_id;	//�����id
	private String modify_id;	//����������id
	private String apprsl_dt;	//��ǰ������
	private String actn_id;		//�����id
	//Table : CAR_CHA ������ġ�������
	private String car_cha_yn;	//������������
	//Table : CLTR ������
	private int cltr_amt;	//�����缳���ݾ�
	//Table : CAR_CHANGE �ڵ��������̷°���
	private String car_pre_no;	//������ ������ȣ
	private String cha_dt;		//���泯¥
	//Table : AUCTION ���
	private String actn_st;		//��Ż���
	private String actn_dt;		//�Ű�����
		//Table : SUI ���ǰ��
	private String sui_nm;		//���ǰ���ڸ�
	private int mm_pr;		//�ŸŰ�
	private String cont_dt;		//�������
	private String ass_ed_dt_actn;	//�������ۼ���(����÷�ο�������)-��ſ��� �Ű��Ȱ�
	private String ass_ed_dt_sui;	//������������ ���ǰ���ؼ� �Ű��Ѱ�
	//Table : INSUR ����
	private String ins_com_nm;	//����ȸ���
	private String ins_exp_dt;	//���踸����
	//table : car_tax Ư�Ҽ�
	private String cls_man_st;	//Ư�Ҽ��������ο���
	private String tax_st;		//
	private String req_dt;		//�������� û����
        
    // CONSTRCTOR            
    public Offls_afterBean() {
		this.car_mng_id = ""; 					//�ڵ���������ȣ
		this.car_no = ""; 						//������ȣ
		this.car_pre_no = "";		//������ ������ȣ
		this.cha_dt = "";			//���泯¥
		this.car_num = "";						//�����ȣ
		this.init_reg_dt = ""; 					//���ʵ����
		this.car_kd = ""; 						//����
		this.car_use = ""; 						//�뵵
		this.car_nm = ""; 						//����
		this.car_jnm = ""; 						//������
		this.car_form = "";						//����
		this.car_y_form = ""; 					//����
		this.dpm = ""; 							//���_��ⷮ
		this.fuel_kd = ""; 						//���_����������
		this.maint_st_dt = ""; 					//�˻���ȿ�Ⱓ1
		this.maint_end_dt = ""; 				//�˻���ȿ�Ⱓ2
		this.test_st_dt = "";					//������ȿ�Ⱓ1
		this.test_end_dt = "";					//������ȿ�Ⱓ2
		this.off_ls = "";						//������������
		this.car_l_cd = "";						//�⵵��������ϼ���
		this.rent_mng_id = ""; //��������ȣ
		this.rent_l_cd = ""; //����ȣ
		this.car_id = ""; //�������̵�
		this.colo = ""; //Į��
		this.opt = ""; //���û��
		this.lpg_yn = "";	//LPG����
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
		this.km = "";
		this.determ_id = "";
		this.hppr = 0;
		this.stpr = 0;
		this.damdang_id = "";
		this.modify_id = "";
		this.apprsl_dt = "";
		this.actn_id = "";
		this.car_cha_yn = "";
		this.cltr_amt = 0;
		this.actn_st = "";
		this.actn_dt = "";
		this.sui_nm = "";
		this.mm_pr = 0;
		this.cont_dt = "";
		this.ass_ed_dt_actn = "";
		this.ass_ed_dt_sui = "";
		this.ins_com_nm = "";
		this.ins_exp_dt = "";
		this.cls_man_st = "";
		this.tax_st = "";
		this.req_dt = "";
	}

	// set Method
	public void setCar_mng_id(String val){if(val==null) val="";	this.car_mng_id = val;}
	public void setCar_no(String val){if(val==null) val="";	this.car_no = val;}
	public void setCar_pre_no(String val){if(val==null) val="";	this.car_pre_no = val;}
	public void setCha_dt(String val){if(val==null) val="";	this.cha_dt = val;}
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
	public void setOff_ls(String val){ if(val==null) val=""; this.off_ls = val; }
	public void setCar_l_cd(String val){ if(val==null) val=""; this.car_l_cd = val; }
	public void setRent_mng_id(String val){ if (val==null) val=""; this.rent_mng_id = val; }
	public void setRent_l_cd(String val){ if(val==null) val=""; this.rent_l_cd = val; }
	public void setCar_id(String val){ if(val==null) val=""; this.car_id = val;}
	public void setColo(String val){if(val==null) val=""; this.colo = val;}
	public void setOpt(String val){if(val==null) val=""; this.opt = val;}
	public void setLpg_yn(String val){if(val==null) val=""; this.lpg_yn = val; }
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
	public void setKm(String val){ if(val==null) val=""; this.km = val; }
	public void setDeterm_id(String val){ if(val==null) val=""; this.determ_id = val; }
	public void setHppr(int val){ this.hppr = val; }
	public void setStpr(int val){ this.stpr = val; }
	public void setDamdang_id(String val){ if(val==null) val=""; this.damdang_id = val; }
	public void setModify_id(String val){ if(val==null) val=""; this.modify_id = val; }
	public void setApprsl_dt(String val){ if(val==null) val=""; this.apprsl_dt = val; }
	public void setActn_id(String val){ if(val==null) val=""; this.actn_id = val; }
	public void setCar_cha_yn(String val){ if(val==null) val=""; this.car_cha_yn = val; }
	public void setCltr_amt(int val){ this.cltr_amt = val; }
	public void setActn_st(String val){ if(val==null) val=""; this.actn_st = val; }
	public void setActn_dt(String val){ if(val==null) val=""; this.actn_dt = val; }
	public void setSui_nm(String val){ if(val==null) val=""; this.sui_nm = val; }
	public void setMm_pr(int val){ this.mm_pr = val; }
	public void setCont_dt(String val){ if(val==null) val=""; this.cont_dt = val; }
	public void setAss_ed_dt_actn(String val){ if(val==null) val=""; this.ass_ed_dt_actn = val; }
	public void setAss_ed_dt_sui(String val){ if(val==null) val=""; this.ass_ed_dt_sui = val; }
	public void setIns_com_nm(String val){ if(val==null) val=""; this.ins_com_nm = val; }
	public void setIns_exp_dt(String val){ if(val==null) val=""; this.ins_exp_dt = val; }
	public void setCls_man_st(String val){ if(val==null) val=""; this.cls_man_st = val; }
	public void setTax_st(String val){ if(val==null) val=""; this.tax_st = val; }
	public void setReq_dt(String val){ if(val==null) val=""; this.req_dt = val; }

	//get Method
	public String getCar_mng_id(){return car_mng_id;}
	public String getCar_no(){return car_no;}
	public String getCar_pre_no(){ return car_pre_no; }
	public String getCha_dt(){ return cha_dt; }
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
	public String getOff_ls(){ return off_ls; }
	public String getCar_l_cd(){ return car_l_cd; }
	public String getRent_mng_id(){ return rent_mng_id; }
	public String getRent_l_cd(){ return rent_l_cd; }
	public String getCar_id(){ return car_id; }
	public String getColo(){ return colo; }
	public String getOpt(){ return opt; }
	public String getLpg_yn(){ return lpg_yn; }
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
	public String getKm(){ return km; }
	public String getDeterm_id(){ return determ_id; }
	public int getHppr(){ return hppr; }
	public int getStpr(){ return stpr; }
	public String getDamdang_id(){ return damdang_id; }
	public String getModify_id(){ return modify_id; }
	public String getApprsl_dt(){ return apprsl_dt; }
	public String getActn_id(){ return actn_id; }
	public String getCar_cha_yn(){ return car_cha_yn; }
	public int getCltr_amt(){ return cltr_amt; }
	public String getActn_st(){ return actn_st; }
	public String getActn_dt(){ return actn_dt; }
	public String getSui_nm(){ return sui_nm; }
	public int getMm_pr(){ return mm_pr; }
	public String getCont_dt(){ return cont_dt; }
	public String getAss_ed_dt_actn(){ return ass_ed_dt_actn; }
	public String getAss_ed_dt_sui(){ return ass_ed_dt_sui; }
	public String getIns_com_nm(){ return ins_com_nm; }
	public String getIns_exp_dt(){ return ins_exp_dt; }
	public String getCls_man_st(){ return cls_man_st; }
	public String getTax_st(){	return tax_st; }
	public String getReq_dt(){	return req_dt; }
}