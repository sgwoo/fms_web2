/**
 * ����
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_register;

import java.util.*;

public class InsurBean {
    //Table : INSUR
	private String car_mng_id;			//�ڵ���������ȣ
	private String ins_st;			//���豸��
	private String ins_sts;			//����
	private String age_scp;			//���ɹ���
	private String car_use;			//�����뵵
	private String ins_com_id;			//����ȸ��
	private String ins_con_no;			//�������ȣ
	private String conr_nm;			//�����
	private String ins_start_dt;			//���������
	private String ins_exp_dt;			//���踸����
	private int rins_pcp_amt;			//å�Ӻ���_���ι��_����
	private int vins_pcp_amt;			//���Ǻ���_���ι��_����
	private String vins_pcp_kd;			//���Ǻ���_���ι��_����
	private int vins_gcp_amt;			//���Ǻ���_�빰���_����
	private String vins_gcp_kd;			//���Ǻ���_�빰���_����
	private int vins_bacdt_amt;			//���Ǻ���_�ڱ��ü���_����
	private String vins_bacdt_kd;			//���Ǻ���_�ڱ��ü���_����
	private int vins_cacdt_amt;			//���Ǻ���_�ڱ���������_����(������å��)
	private int vins_canoisr_amt;		//���Ǻ���_������������_����
	private int vins_cacdt_car_amt;		//���Ǻ���_�ڱ���������_����_����
	private int vins_cacdt_me_amt;		//���Ǻ���_�ڱ���������_�ڱ�δ��
	private int vins_cacdt_cm_amt;		//���Ǻ���_�ڱ���������_���谡��(����+�ڱ�δ��)
	private String pay_tm;			//����Ƚ��
	private String change_dt;			//����ắ����
	private String change_cau;			//����ắ�����
	private String change_itm_kd1;			//����ắ���׸�1_����
	private int change_itm_amt1;			//����ắ���׸�1_����
	private String change_itm_kd2;			//����ắ���׸�2_����
	private int change_itm_amt2;			//����ắ���׸�2_����
	private String change_itm_kd3;			//����ắ���׸�3_����
	private int change_itm_amt3;			//����ắ���׸�3_����
	private String change_itm_kd4;			//����ắ���׸�4_����
	private int change_itm_amt4;			//����ắ���׸�4_����
	private String car_rate;			//���԰����
	private String ins_rate;			//������
	private String ext_rate;			//����������
	private String air_ds_yn;			//���������_������
	private String air_as_yn;			//���������������
	private String agnt_nm;			//��������_�̸�
	private String agnt_tel;			//��������_��ȭ��ȣ
	private String agnt_imgn_tel;			//��������_�����ȭ��ȣ
	private String agnt_fax;			//	��������_FAX
	private String exp_dt;			//��������
	private String exp_cau;			//��������
	private int rtn_amt;			//����ȯ�ޱ�
	private String rtn_dt;			//����ȯ������

        
    // CONSTRCTOR            
    public InsurBean() {  
	    this.car_mng_id = "";			//�ڵ���������ȣ
		this.ins_st = "";			//���豸��
		this.ins_sts = "";			//����
		this.age_scp = "";			//���ɹ���
		this.car_use = "";			//�����뵵
		this.ins_com_id = "";			//����ȸ��
		this.ins_con_no = "";			//�������ȣ
		this.conr_nm = "";			//�����
		this.ins_start_dt = "";			//���������
		this.ins_exp_dt = "";			//���踸����
		this.rins_pcp_amt = 0;			//å�Ӻ���_���ι��_����
		this.vins_pcp_amt = 0;			//���Ǻ���_���ι��_����
		this.vins_pcp_kd = "";			//���Ǻ���_���ι��_����
		this.vins_gcp_amt = 0;			//���Ǻ���_�빰���_����
		this.vins_gcp_kd = "";			//���Ǻ���_�빰���_����
		this.vins_bacdt_amt = 0;			//���Ǻ���_�ڱ��ü���_����
		this.vins_bacdt_kd = "";			//���Ǻ���_�ڱ��ü���_����
		this.vins_cacdt_amt = 0;			//���Ǻ���_�ڱ���������_����
		this.vins_canoisr_amt = 0;				//���Ǻ���_������������_����
		this.vins_cacdt_car_amt = 0;			//���Ǻ���_�ڱ���������_����_����
		this.vins_cacdt_me_amt = 0;				//���Ǻ���_�ڱ���������_�ڱ�δ��
		this.vins_cacdt_cm_amt = 0;				//���Ǻ���_�ڱ���������_���谡��(����+�ڱ�δ��)
		this.pay_tm = "";			//����Ƚ��
		this.change_dt = "";			//����ắ����
		this.change_cau = "";			//����ắ�����
		this.change_itm_kd1 = "";			//����ắ���׸�1_����
		this.change_itm_amt1 = 0;			//����ắ���׸�1_����
		this.change_itm_kd2 = "";			//����ắ���׸�2_����
		this.change_itm_amt2 = 0;			//����ắ���׸�2_����
		this.change_itm_kd3 = "";			//����ắ���׸�3_����
		this.change_itm_amt3 = 0;			//����ắ���׸�3_����
		this.change_itm_kd4 = "";			//����ắ���׸�4_����
		this.change_itm_amt4 = 0;			//����ắ���׸�4_����
		this.car_rate = "";			//���԰����
		this.ins_rate = "";			//������
		this.ext_rate = "";			//����������
		this.air_ds_yn = "";			//���������_������
		this.air_as_yn = "";			//���������������
		this.agnt_nm = "";			//��������_�̸�
		this.agnt_tel = "";			//��������_��ȭ��ȣ
		this.agnt_imgn_tel = "";			//��������_�����ȭ��ȣ
		this.agnt_fax = "";			//	��������_FAX
		this.exp_dt = "";			//��������
		this.exp_cau = "";			//��������
		this.rtn_amt = 0;			//����ȯ�ޱ�
		this.rtn_dt = "";			//����ȯ������
	}

	// get Method
	public void setCar_mng_id(String val){
		if(val==null) val="";
		this.car_mng_id = val;
	}
	public void setIns_st(String val){
		if(val==null) val="";
		this.ins_st = val;
	}
	public void setIns_sts(String val){
		if(val==null) val="";
		this.ins_sts = val;
	}
	public void setAge_scp(String val){
		if(val==null) val="";
		this.age_scp = val;
	}
	public void setCar_use(String val){
		if(val==null) val="";
		this.car_use = val;
	}
	public void setIns_com_id(String val){
		if(val==null) val="";
		this.ins_com_id = val;
	}
	public void setIns_con_no(String val){
		if(val==null) val="";
		this.ins_con_no = val;
	}
	public void setConr_nm(String val){
		if(val==null) val="";
		this.conr_nm = val;
	}
	public void setIns_start_dt(String val){
		if(val==null) val="";
		this.ins_start_dt = val;
	}
	public void setIns_exp_dt(String val){
		if(val==null) val="";
		this.ins_exp_dt = val;
	}
	public void setRins_pcp_amt(int val){
		this.rins_pcp_amt = val;
	}
	public void setVins_pcp_amt(int val){
		this.vins_pcp_amt = val;
	}
	public void setVins_pcp_kd(String val){
		if(val==null) val="";
		this.vins_pcp_kd = val;
	}
	public void setVins_gcp_amt(int val){
		this.vins_gcp_amt = val;
	}
	public void setVins_gcp_kd(String val){
		if(val==null) val="";
		this.vins_gcp_kd = val;
	}
	public void setVins_bacdt_amt(int val){
		this.vins_bacdt_amt = val;
	}
	public void setVins_bacdt_kd(String val){
		if(val==null) val="";
		this.vins_bacdt_kd = val;
	}
	public void setVins_cacdt_amt(int val){
		this.vins_cacdt_amt = val;
	}
	public void setVins_canoisr_amt(int val){
		this.vins_canoisr_amt = val;
	}
	public void setVins_cacdt_car_amt(int val){
		this.vins_cacdt_car_amt = val;
	}
	public void setVins_cacdt_me_amt(int val){
		this.vins_cacdt_me_amt = val;
	}
	public void setVins_cacdt_cm_amt(int val){ this.vins_cacdt_cm_amt = val; }
	public void setPay_tm(String val){
		if(val==null) val="";
		this.pay_tm = val;
	}
	public void setChange_dt(String val){
		if(val==null) val="";
		this.change_dt = val;
	}
	public void setChange_cau(String val){
		if(val==null) val="";
		this.change_cau = val;
	}
	public void setChange_itm_kd1(String val){
		if(val==null) val="";
		this.change_itm_kd1 = val;
	}
	public void setChange_itm_amt1(int val){
		this.change_itm_amt1 = val;
	}
	public void setChange_itm_kd2(String val){
		if(val==null) val="";
		this.change_itm_kd2 = val;
	}
	public void setChange_itm_amt2(int val){
		this.change_itm_amt2 = val;
	}
	public void setChange_itm_kd3(String val){
		if(val==null) val="";
		this.change_itm_kd3 = val;
	}
	public void setChange_itm_amt3(int val){
		this.change_itm_amt3 = val;
	}
	public void setChange_itm_kd4(String val){
		if(val==null) val="";
		this.change_itm_kd4 = val;
	}
	public void setChange_itm_amt4(int val){
		this.change_itm_amt4 = val;
	}
	public void setCar_rate(String val){
		if(val==null) val="";
		this.car_rate = val;
	}
	public void setIns_rate(String val){
		if(val==null) val="";
		this.ins_rate = val;
	}
	public void setExt_rate(String val){
		if(val==null) val="";
		this.ext_rate = val;
	}
	public void setAir_ds_yn(String val){
		if(val==null) val="";
		this.air_ds_yn = val;
	}
	public void setAir_as_yn(String val){
		if(val==null) val="";
		this.air_as_yn = val;
	}
	public void setAgnt_nm(String val){
		if(val==null) val="";
		this.agnt_nm = val;
	}
	public void setAgnt_tel(String val){
		if(val==null) val="";
		this.agnt_tel = val;
	}
	public void setAgnt_imgn_tel(String val){
		if(val==null) val="";
		this.agnt_imgn_tel = val;
	}
	public void setAgnt_fax(String val){
		if(val==null) val="";
		this.agnt_fax = val;
	}
	public void setExp_dt(String val){
		if(val==null) val="";
		this.exp_dt = val;
	}
	public void setExp_cau(String val){
		if(val==null) val="";
		this.exp_cau = val;
	}
	public void setRtn_amt(int val){
		this.rtn_amt = val;
	}
	public void setRtn_dt(String val){
		if(val==null) val="";
		this.rtn_dt = val;
	}
	
	//Get Method
	public String getCar_mng_id(){
		return car_mng_id;
	}
	public String getIns_st(){
		return ins_st;
	}
	public String getIns_sts(){
		return ins_sts;
	}
	public String getAge_scp(){
		return age_scp;
	}
	public String getCar_use(){
		return car_use;
	}
	public String getIns_com_id(){
		return ins_com_id;
	}
	public String getIns_con_no(){
		return ins_con_no;
	}
	public String getConr_nm(){
		return conr_nm;
	}
	public String getIns_start_dt(){
		return ins_start_dt;
	}
	public String getIns_exp_dt(){
		return ins_exp_dt;
	}
	public int getRins_pcp_amt(){
		return rins_pcp_amt;
	}
	public int getVins_pcp_amt(){
		return vins_pcp_amt;
	}
	public String getVins_pcp_kd(){
		return vins_pcp_kd;
	}
	public int getVins_gcp_amt(){
		return vins_gcp_amt;
	}
	public String getVins_gcp_kd(){
		return vins_gcp_kd;
	}
	public int getVins_bacdt_amt(){
		return vins_bacdt_amt;
	}
	public String getVins_bacdt_kd(){
		return vins_bacdt_kd;
	}
	public int getVins_cacdt_amt(){
		return vins_cacdt_amt;
	}
	public int getVins_canoisr_amt(){ return vins_canoisr_amt; }
	public int getVins_cacdt_car_amt(){ return vins_cacdt_car_amt; }
	public int getVins_cacdt_me_amt(){ return vins_cacdt_me_amt; }
	public int getVins_cacdt_cm_amt(){ return vins_cacdt_cm_amt; }
	public String getPay_tm(){
		return pay_tm;
	}
	public String getChange_dt(){
		return change_dt;
	}
	public String getChange_cau(){
		return change_cau;
	}
	public String getChange_itm_kd1(){
		return change_itm_kd1;
	}
	public int getChange_itm_amt1(){
		return change_itm_amt1;
	}
	public String getChange_itm_kd2(){
		return change_itm_kd2;
	}
	public int getChange_itm_amt2(){
		return change_itm_amt2;
	}
	public String getChange_itm_kd3(){
		return change_itm_kd3;
	}
	public int getChange_itm_amt3(){
		return change_itm_amt3;
	}
	public String getChange_itm_kd4(){
		return change_itm_kd4;
	}
	public int getChange_itm_amt4(){
		return change_itm_amt4;
	}
	public String getCar_rate(){
		return car_rate;
	}
	public String getIns_rate(){
		return ins_rate;
	}
	public String getExt_rate(){
		return ext_rate;
	}
	public String getAir_ds_yn(){
		return air_ds_yn;
	}
	public String getAir_as_yn(){
		return air_as_yn;
	}
	public String getAgnt_nm(){
		return agnt_nm;
	}
	public String getAgnt_tel(){
		return agnt_tel;
	}
	public String getAgnt_imgn_tel(){
		return agnt_imgn_tel;
	}
	public String getAgnt_fax(){
		return agnt_fax;
	}
	public String getExp_dt(){
		return exp_dt;
	}
	public String getExp_cau(){
		return exp_cau;
	}
	public int getRtn_amt(){
		return rtn_amt;
	}
	public String getRtn_dt(){
		return rtn_dt;
	}
}