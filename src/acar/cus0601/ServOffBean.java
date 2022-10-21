/**
 * �����ü
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.cus0601;

import java.util.*;

public class ServOffBean {
    //Table : SERV_OFF �����ü
	private String off_id;			//�����üid
	private String car_comp_id;		//������ü
	private String off_nm;			//��ȣ
	private String off_st;			//���
	private String off_st_nm;		//6-��Ÿ
	private String own_nm;			//��ǥ��
	private String ent_no;			//����ڹ�ȣ
	private String off_sta;			//����
	private String off_item;		//����
	private String off_tel;			//�繫����ȭ
	private String off_fax;			//�ѽ�
	private String homepage;		//Ȩ������
	private String off_post;		//�����ȣ
	private String off_addr;		//�ּ�
	private String bank;			//���°�������
	private String acc_no;			//���¹�ȣ
	private String acc_nm;			//���¸�
	private String note;			//���
	private String reg_dt;			//�����
	private String reg_id;			//�����
	private String upd_dt;			//������
	private String upd_id;			//������
	private String br_id;			//�����ü�����������ڵ�
	private String off_type;			//��ü����
	private int serv_cnt;			//������Ǽ�
	private int serv_amt;			//������ݾ�
	private String ven_code;		//�׿����ŷ�ó
	//2015-04-16 ���԰��������� �߰� Ryu 
	private String cpt_cd;		//�������
	private String start_dt;		//���ʰŷ���������
	private String close_dt;		//�ŷ���������
	private String deal_note;		//���԰����� ���
	private String acc_note;		//���԰����� �ŷ����¿� ����
	private String gubun_b;			//������ ����(1=����, 2=��������, 3=ĳ��Ż, 4=ī��)
	//2016-05-12 Ź�۾�ü ��뿩�� �߰�: ������
	private String use_yn;
	private String bank_cd;

	private String user_id;			//��ȣ�Ϳ����� �������̵�
	private String est_st;			//����ڱ���
	private String ssn;			//�ֹι�ȣ
	
        
    // CONSTRCTOR            
    public ServOffBean() {  
		this.off_id = ""; 
		this.car_comp_id = ""; 
		this.off_nm = ""; 
		this.off_st = "";
		this.off_st_nm = ""; 
		this.own_nm = ""; 
		this.ent_no = ""; 
		this.off_sta = ""; 
		this.off_item = ""; 
		this.off_tel = ""; 
		this.off_fax = ""; 
		this.homepage = ""; 
		this.off_post = ""; 
		this.off_addr = ""; 
		this.bank = ""; 
		this.acc_no = ""; 
		this.acc_nm = ""; 
		this.note = "";
		this.reg_dt = "";
		this.reg_id = "";
		this.upd_dt = "";
		this.upd_id = "";
		this.br_id = "";
		this.serv_cnt = 0;
		this.serv_amt = 0;
		this.off_type = "";
		this.ven_code = "";
		this.cpt_cd = "";
		this.start_dt = "";
		this.close_dt = "";
		this.deal_note = "";
		this.acc_note = "";
		this.gubun_b = "";
		this.use_yn = "";
		this.bank_cd = "";
		this.bank_cd = "";
		this.user_id = "";
		this.est_st = "";
		this.ssn = "";
	}

	// get Method

	public void setOff_id(String val){
		if(val==null) val="";
		this.off_id = val;
	}
	public void setCar_comp_id(String val){
		if(val==null) val="";
		this.car_comp_id = val;
	}
	public void setOff_nm(String val){
		if(val==null) val="";
		this.off_nm = val;
	}
	public void setOff_st(String val){
		if(val==null) val="";
		this.off_st = val;
	}
	public void setOwn_nm(String val){
		if(val==null) val="";
		this.own_nm = val;
	}
	public void setEnt_no(String val){
		if(val==null) val="";
		this.ent_no = val;
	}
	public void setOff_sta(String val){
		if(val==null) val="";
		this.off_sta = val;
	}
	public void setOff_item(String val){
		if(val==null) val="";
		this.off_item = val;
	}
	public void setOff_tel(String val){
		if(val==null) val="";
		this.off_tel = val;
	}
	public void setOff_fax(String val){
		if(val==null) val="";
		this.off_fax = val;
	}
	public void setHomepage(String val){
		if(val==null) val="";
		this.homepage = val;
	}
	public void setOff_post(String val){
		if(val==null) val="";
		this.off_post = val;
	}
	public void setOff_addr(String val){
		if(val==null) val="";
		this.off_addr = val;
	}
	public void setBank(String val){
		if(val==null) val="";
		this.bank = val;
	}
	public void setAcc_no(String val){
		if(val==null) val="";
		this.acc_no = val;
	}
	public void setAcc_nm(String val){
		if(val==null) val="";
		this.acc_nm = val;
	}
	public void setNote(String val){
		if(val==null) val="";
		this.note = val;
	}
	public void setReg_dt(String val){ if(val==null) val=""; this.reg_dt = val; }
	public void setReg_id(String val){ if(val==null) val=""; this.reg_id = val; }
	public void setUpd_dt(String val){ if(val==null) val=""; this.upd_dt = val; }
	public void setUpd_id(String val){ if(val==null) val=""; this.upd_id = val; }
	public void setBr_id(String val){ if(val==null) val=""; this.br_id = val; }
	public void setServ_cnt(int val){ this.serv_cnt = val; }
	public void setServ_amt(int val){ this.serv_amt = val; }
	public void setOff_type(String val){ if(val==null) val=""; this.off_type = val; }
	public void setVen_code(String val){ if(val==null) val=""; this.ven_code = val; }

	public void setCpt_cd(String val){ if(val==null) val=""; this.cpt_cd = val; }
	public void setStart_dt(String val){ if(val==null) val=""; this.start_dt = val; }
	public void setClose_dt(String val){ if(val==null) val=""; this.close_dt = val; }
	public void setDeal_note(String val){ if(val==null) val=""; this.deal_note = val; }
	public void setAcc_note(String val){ if(val==null) val=""; this.acc_note = val; }
	public void setGubun_b(String val){ if(val==null) val=""; this.gubun_b = val; }
	public void setUse_yn(String val){ if(val==null) val=""; this.use_yn = val; }
	public void setBank_cd(String val){ if(val==null) val=""; this.bank_cd = val; }
	public void setUser_id(String val){ if(val==null) val=""; this.user_id = val; }
	public void setEst_st(String val){ if(val==null) val=""; this.est_st = val; }
	public void setSsn(String val){ if(val==null) val=""; this.ssn = val; }
		
	//Get Method
	public String getOff_id(){
		return off_id;
	}
	public String getCar_comp_id(){
		return car_comp_id;
	}
	public String getOff_nm(){
		return off_nm;
	}
	public String getOff_st(){
		return off_st;
	}
	public String getOff_st_nm(){
		if(off_st.equals("6"))
		{
			off_st_nm = "��Ÿ";
		}else{
			off_st_nm = off_st + " ��";
		}
		return off_st_nm;
	}
	public String getOwn_nm(){
		return own_nm;
	}
	public String getEnt_no(){
		return ent_no;
	}
	public String getOff_sta(){
		return off_sta;
	}
	public String getOff_item(){
		return off_item;
	}
	public String getOff_tel(){
		return off_tel;
	}
	public String getOff_fax(){
		return off_fax;
	}
	public String getHomepage(){
		return homepage;
	}
	public String getOff_post(){
		return off_post;
	}
	public String getOff_addr(){
		return off_addr;
	}
	public String getBank(){
		return bank;
	}
	public String getAcc_no(){
		return acc_no;
	}
	public String getAcc_nm(){
		return acc_nm;
	}
	public String getNote(){
		return note;
	}
	public String getReg_dt(){ return reg_dt; }
	public String getReg_id(){ return reg_id; }
	public String getUpd_dt(){ return upd_dt; }
	public String getUpd_id(){ return upd_id; }
	public String getBr_id(){ return br_id; }
	public int getServ_cnt(){ return serv_cnt; }
	public int getServ_amt(){ return serv_amt; }
	public String getOff_type(){ return off_type; }
	public String getVen_code(){ return ven_code; }
	public String getCpt_cd(){ return cpt_cd; }
	public String getStart_dt(){ return start_dt; }
	public String getClose_dt(){ return close_dt; }
	public String getDeal_note(){ return deal_note; }
	public String getAcc_note(){ return acc_note; }
	public String getGubun_b(){ return gubun_b; }	
	public String getUse_yn(){ return use_yn; }
	public String getBank_cd(){ return bank_cd; }
	public String getUser_id(){ return user_id; }
	public String getEst_st(){ return est_st; }
	public String getSsn(){ return ssn; }

}