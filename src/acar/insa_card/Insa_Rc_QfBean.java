package acar.insa_card;
//테이블 INSA_RC_QF
public class Insa_Rc_QfBean {
	private String reg_id ; 
    private int rc_no;
    private String rc_edu ; //학력조건
    private String rc_qf_var1;
    private String rc_qf_var2;
    private String rc_qf_var3;
    private String rc_qf_var4;
    private String rc_qf_var5;
    private String rc_qf_var6;
    private String rc_qf_var7;
    private String rc_qf_var8;
    private String rc_qf_var9;
    private String rc_nm;
    
	public Insa_Rc_QfBean() {}

	public Insa_Rc_QfBean(String reg_id, int rc_no, String rc_edu, 
						  String rc_qf_var1, String rc_qf_var2, String rc_qf_var3, String rc_qf_var4, String rc_qf_var5, String rc_qf_var6, String rc_qf_var7, String rc_qf_var8, String rc_qf_var9) {
		this.reg_id = reg_id;
		this.rc_no = rc_no;
		this.rc_edu = rc_edu;
		this.rc_qf_var1 = rc_qf_var1;
		this.rc_qf_var2 = rc_qf_var2;
		this.rc_qf_var3 = rc_qf_var3;
		this.rc_qf_var4 = rc_qf_var4;
		this.rc_qf_var5 = rc_qf_var5;
		this.rc_qf_var6 = rc_qf_var6;
		this.rc_qf_var7 = rc_qf_var7;
		this.rc_qf_var8 = rc_qf_var8;
		this.rc_qf_var9 = rc_qf_var9;
	}
	
	public Insa_Rc_QfBean(int rc_no, String rc_edu,
						  String rc_qf_var1, String rc_qf_var2, String rc_qf_var3, String rc_qf_var4, String rc_qf_var5, String rc_qf_var6, String rc_qf_var7, String rc_qf_var8, String rc_qf_var9) {
		this.rc_no = rc_no;
		this.rc_edu = rc_edu;
		this.rc_qf_var1 = rc_qf_var1;
		this.rc_qf_var2 = rc_qf_var2;
		this.rc_qf_var3 = rc_qf_var3;
		this.rc_qf_var4 = rc_qf_var4;
		this.rc_qf_var5 = rc_qf_var5;
		this.rc_qf_var6 = rc_qf_var6;
		this.rc_qf_var7 = rc_qf_var7;
		this.rc_qf_var8 = rc_qf_var8;
		this.rc_qf_var9 = rc_qf_var9;
	}

	public void setReg_id(String reg_id) {this.reg_id = reg_id;}
	public void setRc_no(int rc_no) {this.rc_no = rc_no;}
	public void setRc_edu(String rc_edu) {this.rc_edu = rc_edu;}
	public void setRc_qf_var1(String rc_qf_var1) {this.rc_qf_var1 = rc_qf_var1;}
	public void setRc_qf_var2(String rc_qf_var2) {this.rc_qf_var2 = rc_qf_var2;}
	public void setRc_qf_var3(String rc_qf_var3) {this.rc_qf_var3 = rc_qf_var3;}
	public void setRc_qf_var4(String rc_qf_var4) {this.rc_qf_var4 = rc_qf_var4;}
	public void setRc_qf_var5(String rc_qf_var5) {this.rc_qf_var5 = rc_qf_var5;}
	public void setRc_qf_var6(String rc_qf_var6) {this.rc_qf_var6 = rc_qf_var6;}
	public void setRc_qf_var7(String rc_qf_var7) {this.rc_qf_var7 = rc_qf_var7;}
	public void setRc_qf_var8(String rc_qf_var8) {this.rc_qf_var8 = rc_qf_var8;}
	public void setRc_qf_var9(String rc_qf_var9) {this.rc_qf_var9 = rc_qf_var9;}
	public void setRc_nm(String rc_nm) {this.rc_nm = rc_nm;}

	//getter
	public String getReg_id() {return reg_id;}
	public int getRc_no() {return rc_no;}
	public String getRc_edu() {return rc_edu;}
	public String getRc_qf_var1() {return rc_qf_var1;}
	public String getRc_qf_var2() {return rc_qf_var2;}
	public String getRc_qf_var3() {return rc_qf_var3;}
	public String getRc_qf_var4() {return rc_qf_var4;}
	public String getRc_qf_var5() {return rc_qf_var5;}
	public String getRc_qf_var6() {return rc_qf_var6;}
	public String getRc_qf_var7() {return rc_qf_var7;}
	public String getRc_qf_var8() {return rc_qf_var8;}
	public String getRc_qf_var9() {return rc_qf_var9;}
	public String getRc_nm() {return rc_nm;}

}
