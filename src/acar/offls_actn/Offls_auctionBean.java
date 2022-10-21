/**
 * �������� �������� ����
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 03. 25. Tue.
 * @ last modify date : -3.28.Fri.;nak_pr,nak_nm �߰�
 *						-4.23.Wed.;car_pr,carhp ����
 *						-4.25.Fri.;ama_nm,actn_nm �߰�
 */
package acar.offls_actn;

import java.util.*;

public class Offls_auctionBean {
	//Table : AUCTION	��������
	private String car_mng_id;	//�ڵ���������ȣ
	private String seq;			//����
	private String actn_st;		//��Ż���
	private String actn_cnt;	//���ȸ��
	private String actn_num;	//��ǰ��ȣ
	private String actn_dt;		//�������
	private int st_pr;		//���۰�
	private int hp_pr;		//�����
	private String ama_jum;		//�Ƹ���ī����
	private String ama_rsn;		//�Ƹ���ī��������
	private String ama_nm;		//�Ƹ���ī��������
	private String actn_jum;	//���������
	private String actn_rsn;	//�������������
	private String actn_nm;		//�������������
	private String damdang_id;	//�����
	private String modify_id;	//����������
	private int nak_pr;			//��������
	private String nak_nm;		//������
	private String choi_st;		//��������
	private int o_s_amt;		//��������
	private String offls_file;	//���ݰ�꼭
	private int out_amt;		//��ǰ������

	public Offls_auctionBean(){
		this.car_mng_id = "";
		this.seq = "";
		this.actn_st = "";
		this.actn_cnt = "";
		this.actn_num = "";
		this.actn_dt = "";
		this.st_pr = 0;
		this.hp_pr = 0;
		this.ama_jum = "";
		this.ama_rsn = "";
		this.ama_nm = "";
		this.actn_jum = "";
		this.actn_rsn = "";
		this.actn_nm = "";
		this.damdang_id = "";
		this.modify_id = "";
		this.nak_pr = 0;
		this.nak_nm = "";
		this.choi_st = "";
		this.o_s_amt = 0;
		this.offls_file ="";
		this.out_amt = 0;
	}

	//set
	public void setCar_mng_id(String val){if(val==null) val="";	this.car_mng_id = val;}
	public void setSeq(String val){ if(val==null) val=""; this.seq = val; }
	public void setActn_st(String val){ if(val==null) val=""; this.actn_st = val; }
	public void setActn_cnt(String val){ if(val==null) val=""; this.actn_cnt = val; }
	public void setActn_num(String val){ if(val==null) val=""; this.actn_num = val; }
	public void setActn_dt(String val){ if(val==null) val=""; this.actn_dt = val; }
	public void setSt_pr(int val){ this.st_pr = val; }
	public void setHp_pr(int val){ this.hp_pr = val; }
	public void setAma_jum(String val){ if(val==null) val=""; this.ama_jum = val; }
	public void setAma_rsn(String val){ if(val==null) val=""; this.ama_rsn = val; }
	public void setAma_nm(String val){ if(val==null) val=""; this.ama_nm = val; }
	public void setActn_jum(String val){ if(val==null) val=""; this.actn_jum = val; }
	public void setActn_rsn(String val){ if(val==null) val=""; this.actn_rsn = val; }
	public void setActn_nm(String val){ if(val==null) val=""; this.actn_nm = val; }
	public void setDamdang_id(String val){ if(val==null) val=""; this.damdang_id = val; }
	public void setModify_id(String val){ if(val==null) val=""; this.modify_id = val; }
	public void setNak_pr(int val){ this.nak_pr = val; }
	public void setNak_nm(String val){ if(val==null) val=""; this.nak_nm = val; }
	public void setChoi_st(String val){ if(val==null) val=""; this.choi_st = val; }
	public void setO_s_amt(int val){ this.o_s_amt = val; }
	public void setOffls_file(String val){ if(val==null) val=""; this.offls_file = val; }
	public void setOut_amt(int val){ this.out_amt = val; }

	

	//get
	public String getCar_mng_id(){ return car_mng_id; }
	public String getSeq(){ return seq; }
	public String getActn_st(){ return actn_st; }
	public String getActn_cnt(){ return actn_cnt; }
	public String getActn_num(){ return actn_num; }
	public String getActn_dt(){ return actn_dt; }
	public int getSt_pr(){ return st_pr; }
	public int getHp_pr(){ return hp_pr; }
	public String getAma_jum(){ return ama_jum; }
	public String getAma_rsn(){ return ama_rsn; }
	public String getAma_nm(){ return ama_nm; }
	public String getActn_jum(){ return actn_jum; }
	public String getActn_rsn(){ return actn_rsn; }
	public String getActn_nm(){ return actn_nm; }
	public String getDamdang_id(){ return damdang_id; }
	public String getModify_id(){ return modify_id; }
	public int getNak_pr(){ return nak_pr; }
	public String getNak_nm(){ return nak_nm; }
	public String getChoi_st(){ return choi_st; }
	public int getO_s_amt(){ return o_s_amt; }
	public String getOffls_file(){ return offls_file; }
	public int getOut_amt(){ return out_amt; }

}