package acar.insa_card;
//테이블 INSA_RC_BENEFIT
public class Insa_Rc_BnBean {
	private String reg_id ; 
    private int rc_no;
    private String rc_bene_cont ; //지점직무내용
    private String rc_bene_st ; 
    private String rc_nm ; 
    
	public Insa_Rc_BnBean() {}

	public Insa_Rc_BnBean(String reg_id, int rc_no, String rc_bene_cont, String rc_bene_st) {
		this.reg_id = reg_id;
		this.rc_no = rc_no;
		this.rc_bene_cont = rc_bene_cont;
		this.rc_bene_st = rc_bene_st;
	}
	
	public Insa_Rc_BnBean( int rc_no, String rc_bene_cont, String rc_bene_st) {
		this.rc_no = rc_no;
		this.rc_bene_cont = rc_bene_cont;
		this.rc_bene_st = rc_bene_st;
	}
	
	//setter
	public void setReg_id(String reg_id) {this.reg_id = reg_id;}
	public void setRc_no(int rc_no) {this.rc_no = rc_no;}
	public void setRc_bene_cont(String rc_bene_cont) {this.rc_bene_cont = rc_bene_cont;}
	public void setRc_bene_st(String rc_bene_st) {this.rc_bene_st = rc_bene_st;}
	public void setRc_nm(String rc_nm) {this.rc_nm = rc_nm;}

	//getter
	public String getReg_id() {return reg_id;}
	public int getRc_no() {return rc_no;}
	public String getRc_bene_cont() {return rc_bene_cont;}
	public String getRc_bene_st() {return rc_bene_st;}
	public String getRc_nm() {return rc_nm;}

}
