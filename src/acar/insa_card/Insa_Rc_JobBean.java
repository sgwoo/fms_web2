package acar.insa_card;
//Å×ÀÌºí INSA_RC_JOB
public class Insa_Rc_JobBean {
	private String reg_id ; 
    private int rc_no;
    private String rc_job ;
    private String rc_job_cont;
    private String rc_nm;
    
	public Insa_Rc_JobBean() {}

	public Insa_Rc_JobBean(String reg_id, int rc_no, String rc_job, String rc_job_cont) {
		this.reg_id = reg_id;
		this.rc_no = rc_no;
		this.rc_job = rc_job;
		this.rc_job_cont = rc_job_cont;

	}
	
	public Insa_Rc_JobBean(int rc_no, String rc_job, String rc_job_cont) {
		this.rc_no = rc_no;
		this.rc_job = rc_job;
		this.rc_job_cont = rc_job_cont;
		
	}

	public void setReg_id(String reg_id) {this.reg_id = reg_id;}
	public void setRc_no(int rc_no) {this.rc_no = rc_no;}
	public void setRc_job(String rc_job) {this.rc_job = rc_job;}
	public void setRc_job_cont(String rc_job_cont) {this.rc_job_cont = rc_job_cont;}
	public void setRc_nm(String rc_nm) {this.rc_nm = rc_nm;}

	//getter
	public String getReg_id() {return reg_id;}
	public int getRc_no() {return rc_no;}
	public String getRc_job() {return rc_job;}
	public String getRc_job_cont() {return rc_job_cont;}
	public String getRc_nm() {return rc_nm;}


}
