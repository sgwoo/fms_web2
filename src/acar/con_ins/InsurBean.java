package acar.con_ins;

public class InsurBean
{
	private String car_mng_id;		//�ڵ���������ȣ
	private String ins_st;			//���豸��
	private String ins_sts;			//����
	private String age_scp;			//���ɹ���
	private String car_use;			//�����뵵
	private String ins_com_id;		//����ȸ���ȣ
	private String ins_con_no;		//�������ȣ
	private String conr_nm;			//�����
	private String ins_start_dt;	//���������
	private String ins_exp_dt;		//���踸����
	private int    rins_pcp_amt;	//å�Ӻ���-���ι��-����
	private String vins_pcp_kd;		//���Ǻ���-���ι��-����
	private int    vins_pcp_amt;	//���Ǻ���-���ι��-����
	private String vins_gcp_kd;		//���Ǻ���-�빰���-����
	private int    vins_gcp_amt;	//���Ǻ���-�빰���-����
	private String vins_bacdt_kd;	//���Ǻ���-�ڱ��ü���-����1
	private int    vins_bacdt_amt;	//���Ǻ���-�ڱ��ü���-����
	private int    vins_cacdt_amt;	//���Ǻ���-�ڱ���������-����
	private String pay_tm;			//����Ƚ��
	private String change_dt;		//����� ������
	private String change_cau;		//����� ���� ����
	private String change_itm_kd1;	//����� �����׸�1-����
	private int    change_itm_amt1;	//����� �����׸�1-����
	private String change_itm_kd2;	//����� �����׸�2-����
	private int    change_itm_amt2;	//����� �����׸�2-����
	private String change_itm_kd3;	//����� �����׸�3-����
	private int    change_itm_amt3;	//����� �����׸�3-����
	private String change_itm_kd4;	//����� �����׸�4-����
	private int    change_itm_amt4;	//����� �����׸�4-����
	private String car_rate;		//���԰����
	private String ins_rate;		//������
	private String ext_rate;		//����������
	private String air_ds_yn;		//����� ������ ����
	private String air_as_yn;		//����� ������ ����
	private String agnt_nm;			//�������ڸ�
	private String agnt_tel;		//�������ڿ���ó
	private String agnt_fax;		//���������ѽ�
	private String agnt_imgn_tel;	//����⵿��ȣ
	private String exp_dt;			//��������
	private String exp_cau;			//��������
	private int    rtn_amt;			//����ȯ�ޱ�
	private String rtn_dt;			//����ȯ������
	private String rent_mng_id;		//����ȣ	
	private String rent_l_cd;		//����ȣ
	private String car_no;			//������ȣ
	private String car_nm;			//����
	private String client_nm;		//����
	private String firm_nm;			//��ȣ
	private String car_num;			//�����ȣ
	private String car_name;		//����
	private int pay_amt;			//���Ժ����
	
	private int change_amt;			//���Ժ��� �հ�
	private String ins_com_nm;		//����ȸ���
	private String ins_start_dt2;	//���������(bar)
	private String ins_exp_dt2;		//���踸����(bar)
	
	private String use_yn;			
	private String enable_renew;	//���ſ���
	private int vins_canoisr_amt;		//���Ǻ���_������������_����
	private int vins_cacdt_car_amt;		//���Ǻ���_�ڱ���������_����_����
	private int vins_cacdt_me_amt;		//���Ǻ���_�ڱ���������_�ڱ�δ��
	private int vins_cacdt_cm_amt;		//���Ǻ���_�ڱ���������_���谡��(����+�ڱ�δ��)
	
	/*2002/4/12�߰�(mylee)*/
	private String con_f_nm;		//�Ǻ������̸�
	private String acc_tel;			// ����⵿��ȭ��ȣ
	private String agnt_dept;		//����ںμ���
	//�߰�
	private String vins_bacdt_kc2;	//���Ǻ���-�ڱ��ü��� ����2
	private String vins_spe;		//���Ǻ���-Ư�� ����
	private int vins_spe_amt;		//���Ǻ���-Ư�� ����
	private int car_ja;				//������å��
	private String scan_file;		//������ ��ĵ
	private String reg_id;				//���ʵ����
	private String reg_dt;				//���ʵ����
	private String update_id;			//����������
	private String update_dt;			//����������
	//20030623�߰�
	private String change_dt1;
	private String change_dt2;
	private String change_dt3;
	private String change_dt4;
	private String change_ins_no1;
	private String change_ins_no2;
	private String change_ins_no3;
	private String change_ins_no4;
	private String change_ins_start_dt1;
	private String change_ins_start_dt2;
	private String change_ins_start_dt3;
	private String change_ins_start_dt4;	
	private String change_ins_exp_dt1;
	private String change_ins_exp_dt2;
	private String change_ins_exp_dt3;
	private String change_ins_exp_dt4;
	private String ins_est_dt;
	private String r_ins_est_dt;

	public InsurBean()
	{
		car_mng_id	= "";
		ins_st		= "";
		ins_sts		= "";
		age_scp		= "";
		car_use		= "";
		ins_com_id	= "";
		ins_con_no	= "";
		conr_nm		= "";
		ins_start_dt	= "";
		ins_exp_dt	= "";
		rins_pcp_amt	= 0;
		vins_pcp_kd	= "";
		vins_pcp_amt	= 0;
		vins_gcp_kd	= "";
		vins_gcp_amt	= 0;
		vins_bacdt_kd	= "";
		vins_bacdt_amt	= 0;
		vins_cacdt_amt	= 0;
		pay_tm		= "";
		change_dt	= "";
		change_cau	= "";
		change_itm_kd1	= "";
		change_itm_amt1	= 0;
		change_itm_kd2	= "";
		change_itm_amt2	= 0;
		change_itm_kd3	= "";
		change_itm_amt3	= 0;
		change_itm_kd4	= "";
		change_itm_amt4	= 0;
		car_rate	= "";
		ins_rate	= "";
		ext_rate	= "";
		air_ds_yn	= "";
		air_as_yn	= "";
		agnt_nm		= "";
		agnt_tel	= "";
		agnt_imgn_tel	= "";
		agnt_fax	= "";
		exp_dt		= "";
		exp_cau		= "";
		rtn_amt		= 0;
		rtn_dt		= "";
		rent_mng_id	= "";				
		rent_l_cd	= "";
		car_no		= "";
		car_nm		= "";
		client_nm	= "";
		firm_nm		= "";
		car_num		= "";
		car_name	= "";
		pay_amt		= 0;
		
		change_amt = 0;
		ins_com_nm	= "";
		ins_start_dt2	= "";
		ins_exp_dt2	= "";
		use_yn		= "";
		enable_renew	= "";
		
		con_f_nm	= "";
		acc_tel		= "";
		agnt_dept	= "";

		vins_bacdt_kc2 = "";
		vins_spe = "";
		vins_spe_amt = 0;
		car_ja = 0;
		scan_file = "";
		this.reg_id = "";
		this.reg_dt = "";
		this.update_id = "";
		this.update_dt = "";
		this.vins_canoisr_amt = 0;				//���Ǻ���_������������_����
		this.vins_cacdt_car_amt = 0;			//���Ǻ���_�ڱ���������_����_����
		this.vins_cacdt_me_amt = 0;				//���Ǻ���_�ڱ���������_�ڱ�δ��
		this.vins_cacdt_cm_amt = 0;				//���Ǻ���_�ڱ���������_���谡��(����+�ڱ�δ��)

		change_dt1 = "";
		change_dt2 = "";
		change_dt3 = "";
		change_dt4 = "";
		change_ins_no1 = "";
		change_ins_no2 = "";
		change_ins_no3 = "";
		change_ins_no4 = "";
		change_ins_start_dt1 = "";
		change_ins_start_dt2 = "";
		change_ins_start_dt3 = "";
		change_ins_start_dt4 = "";
		change_ins_exp_dt1 = "";
		change_ins_exp_dt2 = "";
		change_ins_exp_dt3 = "";
		change_ins_exp_dt4 = "";
		ins_est_dt	= "";
		r_ins_est_dt= "";

	}
	
	public void setCar_mng_id(String str)	{	car_mng_id		= str;	}
	public void setIns_st(String str)		{	ins_st			= str;	}
	public void setIns_sts(String str)		{	ins_sts			= str;	}
	public void setAge_scp(String str)		{	age_scp			= str;	}
	public void setCar_use(String str)		{	car_use			= str;	}
	public void setIns_com_id(String str)	{	ins_com_id		= str;	}
	public void setIns_con_no(String str)	{	ins_con_no		= str;	}
	public void setConr_nm(String str)		{	conr_nm			= str;	}
	public void setIns_start_dt(String str)	{	ins_start_dt	= str;	}
	public void setIns_exp_dt(String str)	{	ins_exp_dt		= str;	}
	public void setRins_pcp_amt(int i)		{	rins_pcp_amt	= i;	}
	public void setVins_pcp_kd(String str)	{	vins_pcp_kd		= str;	}
	public void setVins_pcp_amt(int i)		{	vins_pcp_amt	= i;	}
	public void setVins_gcp_kd(String str)	{	vins_gcp_kd		= str;	}
	public void setVins_gcp_amt(int i)		{	vins_gcp_amt	= i;	}
	public void setVins_bacdt_kd(String str){	vins_bacdt_kd	= str;	}
	public void setVins_bacdt_amt(int i)	{	vins_bacdt_amt	= i;	}
	public void setVins_cacdt_amt(int i)	{	vins_cacdt_amt	= i;	}
	public void setPay_tm(String str)		{	pay_tm			= str;	}
	public void setChange_dt(String str)	{	change_dt		= str;	}
	public void setChange_cau(String str)	{	change_cau		= str;	}
	public void setChange_itm_kd1(String str){	change_itm_kd1	= str;	}
	public void setChange_itm_amt1(int i)	{	change_itm_amt1 = i;	}
	public void setChange_itm_kd2(String str){	change_itm_kd2	= str;	}
	public void setChange_itm_amt2(int i)	{	change_itm_amt2 = i;	}
	public void setChange_itm_kd3(String str){	change_itm_kd3	= str;	}
	public void setChange_itm_amt3(int i)	{	change_itm_amt3 = i;	}
	public void setChange_itm_kd4(String str){	change_itm_kd4	= str;	}
	public void setChange_itm_amt4(int i)	{	change_itm_amt4 = i;	}
	public void setCar_rate(String str)		{	car_rate		= str;	}
	public void setIns_rate(String str)		{	ins_rate		= str;	}
	public void setExt_rate(String str)		{	ext_rate		= str;	}
	public void setAir_ds_yn(String str)	{	air_ds_yn		= str;	}
	public void setAir_as_yn(String str)	{	air_as_yn		= str;	}
	public void setAgnt_nm(String str)		{	agnt_nm			= str;	}
	public void setAgnt_tel(String str)		{	agnt_tel		= str;	}
	public void setAgnt_imgn_tel(String str){	agnt_imgn_tel	= str;	}
	public void setAgnt_fax(String str)		{	agnt_fax		= str;	}
	public void setExp_dt(String str)		{	exp_dt			= str;	}
	public void setExp_cau(String str)		{	exp_cau			= str;	}
	public void setRtn_amt(int i)			{	rtn_amt			= i;	}
	public void setRtn_dt(String str)		{	rtn_dt			= str;	}
	public void setRent_mng_id(String str)	{	rent_mng_id		= str;	}
	public void setRent_l_cd(String str)	{	rent_l_cd		= str;	}
	public void setCar_no(String str)		{	car_no			= str;	}
	public void setCar_nm(String str)		{	car_nm			= str;	}
	public void setClient_nm(String str)	{	client_nm		= str;	}
	public void setFirm_nm(String str)		{	firm_nm			= str;	}
	public void setCar_num(String str)		{	car_num			= str;	}
	public void setCar_name(String str)		{	car_name		= str;	}
	public void setPay_amt(int i)			{	pay_amt			= i;	}
	public void setChange_amt(int i)		{	change_amt		= i;	}
	public void setIns_com_nm(String str)	{	ins_com_nm		= str;	}
	public void setIns_start_dt2(String str){	ins_start_dt2	= str;	}
	public void setIns_exp_dt2(String str)	{	ins_exp_dt2		= str;	}
	public void setUse_yn(String str)		{	use_yn			= str;	}
	public void setEnable_renew(String str)	{	enable_renew	= str;	}	
	public void setCon_f_nm(String str)		{	con_f_nm		= str;	}	
	public void setAcc_tel(String str)		{	acc_tel			= str;	}		
	public void setAgnt_dept(String str)	{	agnt_dept		= str;	}
	public void setVins_bacdt_kc2(String str){	vins_bacdt_kc2	= str;	}
	public void setVins_spe(String str)		{	vins_spe		= str;	}
	public void setVins_spe_amt(int i)		{	vins_spe_amt	= i;	}
	public void setCar_ja(int i)			{	car_ja			= i;	}
	public void setScan_file(String str)	{	scan_file		= str;	}
	public void setReg_id(String val){
		if(val==null) val="";
		this.reg_id = val;
	}
	public void setReg_dt(String val){
		if(val==null) val="";
		this.reg_dt = val;
	}
	public void setUpdate_id(String val){
		if(val==null) val="";
		this.update_id = val;
	}
	public void setUpdate_dt(String val){
		if(val==null) val="";
		this.update_dt = val;
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

	public void setChange_dt1(String str)	{	change_dt1		= str;	}
	public void setChange_dt2(String str)	{	change_dt2		= str;	}
	public void setChange_dt3(String str)	{	change_dt3		= str;	}
	public void setChange_dt4(String str)	{	change_dt4		= str;	}
	public void setChange_ins_no1(String str){	change_ins_no1	= str;	}
	public void setChange_ins_no2(String str){	change_ins_no2	= str;	}
	public void setChange_ins_no3(String str){	change_ins_no3	= str;	}
	public void setChange_ins_no4(String str){	change_ins_no4	= str;	}
	public void setChange_ins_start_dt1(String str){change_ins_start_dt1= str;	}
	public void setChange_ins_start_dt2(String str){change_ins_start_dt2= str;	}
	public void setChange_ins_start_dt3(String str){change_ins_start_dt3= str;	}
	public void setChange_ins_start_dt4(String str){change_ins_start_dt4= str;	}
	public void setChange_ins_exp_dt1(String str){change_ins_exp_dt1= str;	}
	public void setChange_ins_exp_dt2(String str){change_ins_exp_dt2= str;	}
	public void setChange_ins_exp_dt3(String str){change_ins_exp_dt3= str;	}
	public void setChange_ins_exp_dt4(String str){change_ins_exp_dt4= str;	}
	public void setIns_est_dt(String str)	{	ins_est_dt	= str;	}
	public void setR_ins_est_dt(String str)	{	r_ins_est_dt= str;	}

	
	public String getCar_mng_id()		{	return	car_mng_id;		}
	public String getIns_st()			{	return	ins_st;			}
	public String getIns_sts()			{	return	ins_sts;		}
	public String getAge_scp()			{	return	age_scp;		}
	public String getCar_use()			{	return	car_use;		}
	public String getIns_com_id()		{	return	ins_com_id;		}
	public String getIns_con_no()		{	return	ins_con_no;		}
	public String getConr_nm()			{	return	conr_nm;		}
	public String getIns_start_dt()		{	return	ins_start_dt;	}
	public String getIns_exp_dt()		{	return	ins_exp_dt;		}
	public int    getRins_pcp_amt()		{	return	rins_pcp_amt;	}
	public String getVins_pcp_kd()		{	return	vins_pcp_kd;	}
	public int    getVins_pcp_amt()		{	return	vins_pcp_amt;	}
	public String getVins_gcp_kd()		{	return	vins_gcp_kd;	}
	public int    getVins_gcp_amt()		{	return	vins_gcp_amt;	}
	public String getVins_bacdt_kd()	{	return	vins_bacdt_kd;	}
	public int    getVins_bacdt_amt()	{	return	vins_bacdt_amt;	}
	public int    getVins_cacdt_amt()	{	return	vins_cacdt_amt;	}
	public String getPay_tm()			{	return	pay_tm;			}
	public String getChange_dt()		{	return	change_dt;		}
	public String getChange_cau()		{	return	change_cau;		}
	public String getChange_itm_kd1()	{	return	change_itm_kd1;	}
	public int    getChange_itm_amt1()	{	return	change_itm_amt1;}
	public String getChange_itm_kd2()	{	return	change_itm_kd2;	}
	public int    getChange_itm_amt2()	{	return	change_itm_amt2;}
	public String getChange_itm_kd3()	{	return	change_itm_kd3;	}
	public int    getChange_itm_amt3()	{	return	change_itm_amt3;}
	public String getChange_itm_kd4()	{	return	change_itm_kd4;	}
	public int    getChange_itm_amt4()	{	return	change_itm_amt4;}
	public String getCar_rate()			{	return	car_rate;		}
	public String getIns_rate()			{	return	ins_rate;		}
	public String getExt_rate()			{	return	ext_rate;		}
	public String getAir_ds_yn()		{	return	air_ds_yn;		}
	public String getAir_as_yn()		{	return	air_as_yn;		}
	public String getAgnt_nm()			{	return	agnt_nm;		}
	public String getAgnt_tel()			{	return	agnt_tel;		}
	public String getAgnt_imgn_tel()	{	return	agnt_imgn_tel;	}
	public String getAgnt_fax()			{	return	agnt_fax;		}
	public String getExp_dt()			{	return	exp_dt;			}
	public String getExp_cau()			{	return	exp_cau;		}
	public int    getRtn_amt()			{	return	rtn_amt;		}
	public String getRtn_dt()			{	return	rtn_dt;			}
	public String getRent_mng_id()		{	return	rent_mng_id;	}		
	public String getRent_l_cd()		{	return	rent_l_cd;		}
	public String getCar_no()			{	return	car_no;			}
	public String getCar_nm()			{	return	car_nm;			}
	public String getClient_nm()		{	return	client_nm;		}
	public String getFirm_nm()			{	return	firm_nm;		}
	public String getCar_num()			{	return car_num;			}
	public String getCar_name()			{	return car_name;		}
	public int    getPay_amt()			{	return pay_amt;			}
	public int    getChange_amt()		{	return change_amt;		}
	public String getIns_com_nm()		{	return ins_com_nm;		}
	public String getIns_start_dt2()	{	return	ins_start_dt2;	}
	public String getIns_exp_dt2()		{	return	ins_exp_dt2;	}	
	public String getUse_yn()			{	return use_yn;			}
	public String getEnable_renew()		{	return enable_renew;	}	
	public String getCon_f_nm()			{	return con_f_nm;		}
	public String getAcc_tel()			{	return acc_tel;			}
	public String getAgnt_dept()		{	return agnt_dept;		}
	public String getVins_bacdt_kc2()	{	return vins_bacdt_kc2;	}
	public String getVins_spe()			{	return vins_spe;		}
	public int    getVins_spe_amt()		{	return vins_spe_amt;	}
	public int    getCar_ja()			{	return car_ja;			}
	public String getScan_file()		{	return scan_file;		}
	public String getReg_id(){
		return reg_id;
	}
	public String getReg_dt(){
		return reg_dt;
	}
	public String getUpdate_id(){
		return update_id;
	}
	public String getUpdate_dt(){
		return update_dt;
	}
	public int getVins_canoisr_amt(){ return vins_canoisr_amt; }
	public int getVins_cacdt_car_amt(){ return vins_cacdt_car_amt; }
	public int getVins_cacdt_me_amt(){ return vins_cacdt_me_amt; }
	public int getVins_cacdt_cm_amt(){ return vins_cacdt_cm_amt; }

	public String getChange_dt1()		{	return change_dt1;		}
	public String getChange_dt2()		{	return change_dt2;		}
	public String getChange_dt3()		{	return change_dt3;		}
	public String getChange_dt4()		{	return change_dt4;		}
	public String getChange_ins_no1()	{	return change_ins_no1;	}
	public String getChange_ins_no2()	{	return change_ins_no2;	}
	public String getChange_ins_no3()	{	return change_ins_no3;	}
	public String getChange_ins_no4()	{	return change_ins_no4;	}
	public String getChange_ins_start_dt1(){return change_ins_start_dt1;}
	public String getChange_ins_start_dt2(){return change_ins_start_dt2;}
	public String getChange_ins_start_dt3(){return change_ins_start_dt3;}
	public String getChange_ins_start_dt4(){return change_ins_start_dt4;}
	public String getChange_ins_exp_dt1(){	return change_ins_exp_dt1;	}
	public String getChange_ins_exp_dt2(){	return change_ins_exp_dt2;	}
	public String getChange_ins_exp_dt3(){	return change_ins_exp_dt3;	}
	public String getChange_ins_exp_dt4(){	return change_ins_exp_dt4;	}
	public String getIns_est_dt()	{	return	ins_est_dt;	}
	public String getR_ins_est_dt()	{	return	r_ins_est_dt;}

}