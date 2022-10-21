package acar.insa_card;

import java.util.Date;

public class Insa_Rc_InfoBean {
	 //Table : insa_rc_intro

	private String reg_id ; 
    private int rc_no;
    private String rc_cur_dt ;    //현재기준
    private int rc_tot_capital ;    //자본총계
    private int rc_tot_asset;        //자산총계
    private int rc_sales ;         //매출액
    private int rc_per_off ;       //재직자수
    private int rc_per_off_per ;    //재직자퍼센트
    private int rc_num_com ;      //전국업체수   
    private int rc_busi_rank ;     //업계순위
    
	public Insa_Rc_InfoBean() {}

	public Insa_Rc_InfoBean(String reg_id, 
							int rc_no, String rc_cur_dt, int rc_tot_capital, int rc_tot_asset, int rc_sales, 
							int rc_per_off, int rc_per_off_per, int rc_num_com, int rc_busi_rank) {
		this.reg_id = reg_id;
		this.rc_no = rc_no;
		this.rc_cur_dt = rc_cur_dt;
		this.rc_tot_capital = rc_tot_capital;
		this.rc_tot_asset = rc_tot_asset;
		this.rc_sales = rc_sales;
		this.rc_per_off = rc_per_off;
		this.rc_per_off_per = rc_per_off_per;
		this.rc_num_com = rc_num_com;
		this.rc_busi_rank = rc_busi_rank;
	}
	
	

	public Insa_Rc_InfoBean(int rc_no, String rc_cur_dt, int rc_tot_capital, int rc_tot_asset, int rc_sales,
							int rc_per_off, int rc_per_off_per, int rc_num_com, int rc_busi_rank) {
		this.rc_no = rc_no;
		this.rc_cur_dt = rc_cur_dt;
		this.rc_tot_capital = rc_tot_capital;
		this.rc_tot_asset = rc_tot_asset;
		this.rc_sales = rc_sales;
		this.rc_per_off = rc_per_off;
		this.rc_per_off_per = rc_per_off_per;
		this.rc_num_com = rc_num_com;
		this.rc_busi_rank = rc_busi_rank;
	}

	public Insa_Rc_InfoBean(String rc_cur_dt, int rc_tot_capital, int rc_tot_asset, int rc_sales, 
							int rc_per_off, int rc_per_off_per, int rc_num_com, int rc_busi_rank) {
		this.rc_cur_dt = rc_cur_dt;
		this.rc_tot_capital = rc_tot_capital;
		this.rc_tot_asset = rc_tot_asset;
		this.rc_sales = rc_sales;
		this.rc_per_off = rc_per_off;
		this.rc_per_off_per = rc_per_off_per;
		this.rc_num_com = rc_num_com;
		this.rc_busi_rank = rc_busi_rank;
	}
	
	//setter
	public void setReg_id(String reg_id) {this.reg_id = reg_id;}
	public void setRc_no(int rc_no) {this.rc_no = rc_no;}
	public void setRc_cur_dt(String rc_cur_dt) {this.rc_cur_dt = rc_cur_dt;}
	public void setRc_tot_capital(int rc_tot_capital) {this.rc_tot_capital = rc_tot_capital;}
	public void setRc_tot_asset(int rc_tot_asset) {this.rc_tot_asset = rc_tot_asset;}
	public void setRc_sales(int rc_sales) {this.rc_sales = rc_sales;}
	public void setRc_per_off(int rc_per_off) {this.rc_per_off = rc_per_off;}
	public void setRc_per_off_per(int rc_per_off_per) {this.rc_per_off_per = rc_per_off_per;	}
	public void setRc_num_com(int rc_num_com) {this.rc_num_com = rc_num_com;}
	public void setRc_busi_rank(int rc_busi_rank) {this.rc_busi_rank = rc_busi_rank;}

	//getter
	public String getReg_id() {return reg_id;}
	public int getRc_no() {return rc_no;}
	public String getRc_cur_dt() {return rc_cur_dt;}
	public int getRc_tot_capital() {return rc_tot_capital;}
	public int getRc_tot_asset() {return rc_tot_asset;}
	public int getRc_sales() {return rc_sales;}
	public int getRc_per_off() {return rc_per_off;}
	public int getRc_per_off_per() {return rc_per_off_per;}
	public int getRc_num_com() {return rc_num_com;}
	public int getRc_busi_rank() {return rc_busi_rank;}
    
}
