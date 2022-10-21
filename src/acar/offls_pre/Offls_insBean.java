/**
 * �������� ����
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 06. 19. Thu.
 * @ last modify date : 
 */
package acar.offls_pre;

import java.util.*;

public class Offls_insBean{
	private String	car_mng_id;
	private String	ins_com_id;	//����ȸ��id
	private String	ins_type;	//��������(å��,����)
	private String	ins_st_dt;	//���������
	private String	ins_ed_dt;	//���踸����
	private int		pay_pr;		//���谡��
	private String	pay_pr_dt;	//���谡���Ա�����

	public Offls_insBean(){
		this.car_mng_id = "";
		this.ins_com_id = "";
		this.ins_type = "";
		this.ins_st_dt = "";
		this.ins_ed_dt = "";
		this.pay_pr = 0;
		this.pay_pr_dt = "";
	}

	//setMethod
	public void setCar_mng_id(String val){ if(val==null) val=""; this.car_mng_id = val; }
	public void setIns_com_id(String val){ if(val==null) val=""; this.ins_com_id = val; }
	public void setIns_type(String val){ if(val==null) val=""; this.ins_type = val; }
	public void setIns_st_dt(String val){ if(val==null) val=""; this.ins_st_dt = val; }
	public void setIns_ed_dt(String val){ if(val==null) val=""; this.ins_ed_dt = val; }
	public void setPay_pr(int val){ this.pay_pr = val; }
	public void setPay_pr_dt(String val){ if(val==null) val=""; this.pay_pr_dt = val; }

	//getMethod
	public String getCar_mng_id(){ return car_mng_id; }
	public String getIns_com_id(){ return ins_com_id; }
	public String getIns_type(){ return ins_type; }
	public String getIns_st_dt(){ return ins_st_dt; }
	public String getIns_ed_dt(){ return ins_ed_dt; }
	public int getPay_pr(){ return pay_pr; }
	public String getPay_pr_dt(){ return pay_pr_dt; }
}