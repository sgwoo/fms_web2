/**
 * �������� �������� �������
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 03. 28. Fri.
 * @ last modify date : -3.28.Fri.;nak_pr�� auction ���̺��� nak_nm�� �Բ� ����
 *						-4.04.Fri. ;��������� �� ���ȸ�����ΰ����ϱ� ���� actn_cnt���ȸ�� �߰�
 */
package acar.offls_actn;

import java.util.*;

public class Offls_per_talkBean {
	//Table : PER_TALK	�������
	private String car_mng_id;	//�ڵ���������ȣ
	private String actn_cnt;	//���ȸ��
	private String seq;			//����
	private int cust_pr;		//�����þ�
	private int ama_pr;			//������þ�
	private String reason;		//��Ļ���
	private String nak_yn;		//��������

	public Offls_per_talkBean(){
		this.car_mng_id = "";
		this.actn_cnt = "";
		this.seq = "";
		this.cust_pr = 0;
		this.ama_pr = 0;
		this.reason = "";
		this.nak_yn = "";
	}

	//set
	public void setCar_mng_id(String val){if(val==null) val="";	this.car_mng_id = val;}
	public void setActn_cnt(String val){ if(val==null) val=""; this.actn_cnt = val; }
	public void setSeq(String val){ if(val==null) val=""; this.seq = val; }
	public void setCust_pr(int val){ this.cust_pr = val; }
	public void setAma_pr(int val){ this.ama_pr = val; }
	public void setReason(String val){ if(val==null) val=""; this.reason = val; }
	public void setNak_yn(String val){ if(val==null) val=""; this.nak_yn = val; }

	//get
	public String getCar_mng_id(){ return car_mng_id; }
	public String getActn_cnt(){ return actn_cnt; }
	public String getSeq(){ return seq; }
	public int getCust_pr(){ return cust_pr; }
	public int getAma_pr(){ return ama_pr; }
	public String getReason(){ return reason; }
	public String getNak_yn(){ return nak_yn; }
}