/**
 * �����׿� ���� ���λ��� ��ȸ
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : - 2004.02.13.��. car_jnm ������ �߰�.
 */
package acar.condition;

import java.util.*;

public class ConditionBean {
    //Table : CONT, CAR_REG, CLIENT, FEE, USERS, CAR_PUR, CAR_ETC, CAR_NM, ALLOT, CODE
    private String rent_mng_id;					//������ID
    private String rent_l_cd;					//����ڵ�
    private String rent_dt;					//�������
    private String dlv_dt;					//�������
    private String dlv_est_dt;				//�������
    private String bus_id;					//��������� ID
    private String bus_nm;					//��������� �̸�
    private String mng_id;					//��������� ID
    private String mng_nm;					//��������� ��
    private String client_id;					//��ID
    private String client_nm;					//�� ��ǥ�ڸ�
    private String firm_nm;						//��ȣ
    private String o_tel;						//�繫����ȭ��ȣ
    private String m_tel;						//�޴���
    private String fax;							//�ѽ�
    private String br_id;						//�����ڵ�
    private String fn_id;						//�˻��׸�
    private String car_mng_id;					//�ڵ�������ID
    private String init_reg_dt;					//���ʵ����
    private String reg_gubun;					//��ϱ���
    private String car_no;						//������ȣ
    private String car_num;						//�����ȣ
    private String r_st;
    private String rent_way;					//�뿩��� �ڵ�
    private String rent_way_nm;					//�뿩��� �̸�
    private String con_mon;						//�뿩����
    private String car_id;						//����ID
    private int imm_amt;						//������å��
	private String car_jnm;						//������
    private String car_name;					//����
    private String rent_start_dt;				//�뿩������
    private String rent_end_dt;					//�뿩������
    private String reg_ext_dt;					//��Ͽ�����
    private String rpt_no;						//�����ȣ
    private String cpt_cd;						//�����ڵ�
    private String bank_nm;						//�����
    private String in_emp_id;
    private String in_emp_nm;
    private String in_car_off_id;
    private String in_car_off_nm;
    private String in_car_off_tel;
    private String out_emp_id;
    private String out_emp_nm;
    private String out_car_off_id;
    private String out_car_off_nm;
    private String out_car_off_tel;
    private String out_car_off_fax;			//<--������� �ѽ���ȣ �߰�(2017.12.07)
    private String bus_st;    
    private String emp_nm;    
    private String pur_pay_dt;				//������ݰ�����
    private String car_ext;    
    private int scan_cnt;						//��ĵ�Ǽ�
    private int scan_cnt2;						//��ĵ�Ǽ�
	private String delay_cont;    
	private String pur_req_dt; 

	private String car_off_name1;
	private String car_off_name2;
	private String engine_nm;
	private String maint_st_dt;
	private String maint_end_dt;
	private String car_end_dt;
	
       
    // CONSTRCTOR            
    public ConditionBean() {  
    	this.rent_mng_id = "";					//������ID
	    this.rent_l_cd = "";					//����ڵ�
	    this.rent_dt = "";					//�������
	    this.dlv_dt = "";					//�������
	    this.dlv_est_dt = "";
	    this.bus_id = "";					//��������� ID  
		this.bus_nm = "";					//��������� �̸�
		this.mng_id = "";					//��������� ID  
		this.mng_nm = "";					//��������� �̸�
	    this.client_id = "";					//��ID
	    this.client_nm = "";					//�� ��ǥ�ڸ�
	    this.firm_nm = "";						//��ȣ
	    this.o_tel = "";
	    this.m_tel = "";
	    this.fax = "";
	    this.br_id = "";						//�����ڵ�
	    this.fn_id = "";						//�˻�
	    this.car_mng_id = "";					//�ڵ�������ID
	    this.init_reg_dt = "";					//���ʵ����
	    this.reg_gubun = "";					//��ϱ���
	    this.car_no = "";						//������ȣ
	    this.car_num = "";						//�����ȣ
	    this.r_st = "";
	    this.rent_way = "";					//�뿩���
	    this.rent_way_nm = "";					//�뿩���
	    this.con_mon = "";						//�뿩����
	    this.car_id = "";						//����ID
	    this.imm_amt = 0;
		this.car_jnm ="";					//������
	    this.car_name = "";					//����
	    this.rent_start_dt = "";				//�뿩������
	    this.rent_end_dt = "";					//�뿩������
	    this.reg_ext_dt = "";					//��Ͽ�����
	    this.rpt_no = "";					//�����ȣ
	    this.cpt_cd = "";						//�����ڵ�
	    this.bank_nm = "";						//�����
	    this.in_emp_id = "";
	    this.in_emp_nm = "";
	    this.in_car_off_id = "";
	    this.in_car_off_nm = "";
	    this.in_car_off_tel = "";
	    this.out_emp_id = "";
	    this.out_emp_nm = "";
	    this.out_car_off_id = "";
	    this.out_car_off_nm = "";
	    this.out_car_off_tel = "";
	    this.out_car_off_fax = "";			// <-- ������� �ѽ���ȣ �߰�(2017.12.07)
	    this.bus_st = "";					//��������
	    this.emp_nm = "";						//�������
	    this.pur_pay_dt = "";	
	    this.car_ext = "";		
		this.scan_cnt = 0;
		this.scan_cnt2 = 0;
		this.delay_cont = "";
		this.pur_req_dt = "";

		this.car_off_name1 = ""; //������� ������� �Ҽӻ�
		this.car_off_name2 = ""; //������� ����� ����Ŀ
		this.engine_nm = "";
		
		this.maint_st_dt = "";
		this.maint_end_dt = "";
		this.car_end_dt = "";

	}

	// get Method
	public void setRent_mng_id(String val){
		if(val==null) val="";
		this.rent_mng_id = val;
	}
    public void setRent_l_cd(String val){
		if(val==null) val="";
		this.rent_l_cd = val;
	}
	public void setRent_dt(String val){
		if(val==null) val="";
		this.rent_dt = val;
	}
	public void setDlv_dt(String val){
		if(val==null) val="";
		this.dlv_dt = val;
	}
	public void setDlv_est_dt(String val){
		if(val==null) val="";
		this.dlv_est_dt = val;
	}
	public void setBus_id(String val){
		if(val==null) val="";
		this.bus_id = val;
	}
	public void setBus_nm(String val){
		if(val==null) val="";
		this.bus_nm = val;
	}
	public void setMng_id(String val){
		if(val==null) val="";
		this.mng_id = val;
	}
	public void setMng_nm(String val){
		if(val==null) val="";
		this.mng_nm = val;
	}
    public void setClient_id(String val){
		if(val==null) val="";
		this.client_id = val;
	}
    public void setClient_nm(String val){
		if(val==null) val="";
		this.client_nm = val;
	}
    public void setFirm_nm(String val){
		if(val==null) val="";
		this.firm_nm = val;
	}
	public void setO_tel(String val){
		if(val==null) val="";
		this.o_tel = val;
	}
	public void setM_tel(String val){
		if(val==null) val="";
		this.m_tel = val;
	}
	public void setFax(String val){
		if(val==null) val="";
		this.fax = val;
	}
	public void setBr_id(String val){
		if(val==null) val="";
		this.br_id = val;
	}
	
	public void setFn_id(String val){
		if(val==null) val="";
		this.fn_id = val;
	}
	
    public void setCar_mng_id(String val){
		if(val==null) val="";
		this.car_mng_id = val;
	}
    public void setInit_reg_dt(String val){
		if(val==null) val="";
		this.init_reg_dt = val;
	}
	public void setReg_gubun(String val){
		if(val==null) val="";
		this.reg_gubun = val;
	}
    public void setCar_no(String val){
		if(val==null) val="";
		this.car_no = val;
	}
    public void setCar_num(String val){
		if(val==null) val="";
		this.car_num = val;
	}
    public void setR_st(String val){
		if(val==null) val="";
		this.r_st = val;
	}
	public void setRent_way(String val){
		if(val==null) val="";
		this.rent_way = val;
	}
	public void setCon_mon(String val){
		if(val==null) val="";
		this.con_mon = val;
	}
    public void setCar_id(String val){
		if(val==null) val="";
		this.car_id = val;
	}
	public void setImm_amt(int val){
		this.imm_amt = val;
	}
	public void setCar_jnm(String val){
		if(val==null) val="";
		this.car_jnm = val;
	}
    public void setCar_name(String val){
		if(val==null) val="";
		this.car_name = val;
	}
    public void setRent_start_dt(String val){
		if(val==null) val="";
		this.rent_start_dt = val;
	}
    public void setRent_end_dt(String val){
		if(val==null) val="";
		this.rent_end_dt = val;
	}
    public void setReg_ext_dt(String val){
		if(val==null) val="";
		this.reg_ext_dt = val;
	}
    public void setRpt_no(String val){
		if(val==null) val="";
		this.rpt_no = val;
	}
    public void setCpt_cd(String val){
		if(val==null) val="";
		this.cpt_cd = val;
	}
    public void setBank_nm(String val){
		if(val==null) val="";
		this.bank_nm = val;
	}
	public void setIn_emp_id(String val){
		if(val==null) val="";
		this.in_emp_id = val;
	}
	public void setIn_emp_nm(String val){
		if(val==null) val="";
		this.in_emp_nm = val;
	}
	public void setIn_car_off_id(String val){
		if(val==null) val="";
		this.in_car_off_id = val;
	}
	public void setIn_car_off_nm(String val){
		if(val==null) val="";
		this.in_car_off_nm = val;
	}
	public void setIn_car_off_tel(String val){
		if(val==null) val="";
		this.in_car_off_tel = val;
	}
	public void setOut_emp_id(String val){
		if(val==null) val="";
		this.out_emp_id = val;
	}
	public void setOut_emp_nm(String val){
		if(val==null) val="";
		this.out_emp_nm = val;
	}
	public void setOut_car_off_id(String val){
		if(val==null) val="";
		this.out_car_off_id = val;
	}
	public void setOut_car_off_nm(String val){
		if(val==null) val="";
		this.out_car_off_nm = val;
	}
	public void setOut_car_off_tel(String val){
		if(val==null) val="";
		this.out_car_off_tel = val;
	}
	public void setOut_car_off_fax(String val){		//<--������� �ѽ���ȣ �߰�(2017.12.07)
		if(val==null) val="";
		this.out_car_off_fax = val;
	}
	public void setBus_st(String val){		if(val==null) val="";		this.bus_st = val;	}
	public void setEmp_nm(String val){		if(val==null) val="";		this.emp_nm = val;	}
	
	public void setPur_pay_dt(String val){
		if(val==null) val="";
		this.pur_pay_dt = val;
	}
	
	public void setCar_ext(String val){		if(val==null) val="";		this.car_ext = val;	}
	public void setScan_cnt(int val){		this.scan_cnt = val;	}
	public void setScan_cnt2(int val){		this.scan_cnt2 = val;	}
	public void setDelay_cont	(String val){		if(val==null) val="";		this.delay_cont = val;	}
	public void setPur_req_dt	(String val){		if(val==null) val="";		this.pur_req_dt	= val;	}

	public void setCar_off_name1	(String val){		if(val==null) val="";		this.car_off_name1	= val;	}
	public void setCar_off_name2	(String val){		if(val==null) val="";		this.car_off_name2	= val;	}
	public void setEngine_nm		(String val){		if(val==null) val="";		this.engine_nm	= val;	}
	
	public void setMaint_st_dt		(String val){		if(val==null) val="";		this.maint_st_dt	= val;	}
	public void setMaint_end_dt		(String val){		if(val==null) val="";		this.maint_end_dt	= val;	}
	public void setCar_end_dt		(String val){		if(val==null) val="";		this.car_end_dt	= val;	}
		
	
	
	//Get Method
	public String getRent_mng_id(){
		return rent_mng_id;
	}
    public String getRent_l_cd(){
		return rent_l_cd;
	}
	public String getRent_dt(){
		return rent_dt;
	}
    public String getDlv_dt(){
		return dlv_dt;
	}
	public String getDlv_est_dt(){
		return dlv_est_dt;
	}
	public String getBus_id(){
		return bus_id;
	}
	public String getBus_nm(){
		return bus_nm;
	}
	public String getMng_id(){
		return mng_id;
	}
	public String getMng_nm(){
		return mng_nm;
	}
    public String getClient_id(){
		return client_id;
	}
    public String getClient_nm(){
		return client_nm;
	}
    public String getFirm_nm(){
		return firm_nm;
	}
	public String getO_tel(){
		return o_tel;
	}
	public String getM_tel(){
		return m_tel;
	}
	public String getFax(){
		return fax;
	}
	public String getBr_id(){
		return br_id;
	}
	
	public String getFn_id(){
		return fn_id;
	}
	
    public String getCar_mng_id(){
		return car_mng_id;
	}
    public String getInit_reg_dt(){
		return init_reg_dt;
	}
	public String getReg_gubun(){
		return reg_gubun;
	}
    public String getCar_no(){
		return car_no;
	}
    public String getCar_num(){
		return car_num;
	}
	public String getR_st(){
		return r_st;
	}
    public String getRent_way(){
		return rent_way;
	}
	public String getRent_way_nm(){
		if(rent_way.equals("1"))
		{
			rent_way_nm = "�Ϲݽ�";
		}else if(rent_way.equals("2")){
			rent_way_nm = "�����";
		}else{
			rent_way_nm = "�⺻��";
		}
		return rent_way_nm;
	}
    public String getCon_mon(){
		return con_mon;
	}
    public String getCar_id(){
		return car_id;
	}
	public int getImm_amt(){
		return imm_amt;
	}
	public String getCar_jnm(){
		return car_jnm;
	}
    public String getCar_name(){
		return car_name;
	}
    public String getRent_start_dt(){
		return rent_start_dt;
	}
    public String getRent_end_dt(){
		return rent_end_dt;
	}
    public String getReg_ext_dt(){
		return reg_ext_dt;
	}
    public String getRpt_no(){
		return rpt_no;
	}
    public String getCpt_cd(){
		return cpt_cd;
	}
    public String getBank_nm(){
		return bank_nm;
	}
	public String getIn_emp_id(){
		return in_emp_id;
	}
	public String getIn_emp_nm(){
		return in_emp_nm;
	}
	public String getIn_car_off_id(){
		return in_car_off_id;
	}
	public String getIn_car_off_nm(){
		return in_car_off_nm;
	}
	public String getIn_car_off_tel(){
		return in_car_off_tel;
	}
	public String getOut_emp_id(){
		return out_emp_id;
	}
	public String getOut_emp_nm(){
		return out_emp_nm;
	}
	public String getOut_car_off_id(){
		return out_car_off_id;
	}
	public String getOut_car_off_nm(){
		return out_car_off_nm;
	}
	public String getOut_car_off_tel(){
		return out_car_off_tel;
	}
	public String getOut_car_off_fax(){		//<--������� �ѽ���ȣ �߰�(2017.12.07)
		return out_car_off_fax;
	}
	public String getBus_st(){		return bus_st;	}
	public String getEmp_nm(){		return emp_nm;	}
	
	public String getPur_pay_dt(){	return pur_pay_dt;	}
	public String getCar_ext(){		return car_ext;	}
	public int getScan_cnt(){		return scan_cnt;	}
	public int getScan_cnt2(){		return scan_cnt2;	}
	public String getDelay_cont(){	return delay_cont;	}
	public String getPur_req_dt	()	{ return pur_req_dt;		}

	public String getCar_off_name1	()	{ return car_off_name1;		} 
	public String getCar_off_name2	()	{ return car_off_name2;		}
	public String getEngine_nm	()	{ return engine_nm;		}
	
	public String getMaint_st_dt	()	{ return maint_st_dt;		}
	public String getMaint_end_dt	()	{ return maint_end_dt;		}
	public String getCar_end_dt	()	{ return car_end_dt;		}
	


}