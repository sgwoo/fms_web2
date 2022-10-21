package acar.insa_card;

import java.util.Date;

public class Insa_Rc_rcBean {
	private String reg_id ; 
    private int rc_no = 0;
    private String reg_name ;     
    private String rc_title;        //게시판 제목
	private String rc_branch ;   //지점
    private String rc_type ;     //지점모집직종
    private int rc_hire_per ;    //지점채용인원
    private String rc_bran_addr; //지점주소
    private String rc_bran_tel ; //지점연락처
    private String rc_job_contA ; //지점직무내용
    private String rc_job_contB ; //지점직무내용
    private String rc_job_contC ; //지점직무내용
    private String rc_job_contD ; //지점직무내용
    private String rc_apl_st_dt; //접수시작일
    private String  rc_apl_ed_dt;//접수마감일
    private String rc_pass_dt;   //합격자발표
    private String rc_apl_mat;   //전형방법
    private String rc_manager;   //담당자
    private String rc_tel;		 //연락처
    private Date rc_reg_dt;      //등록날짜
    private int rnum;
    private String rc_edu;		 //학력조건
    private String rc_nm;		 //코드명
    private String edu_nm;		 //학력명

	public Insa_Rc_rcBean() {	}

	public Insa_Rc_rcBean(String reg_id, int rc_no, String reg_name, String rc_title, String rc_branch, String rc_type,
			int rc_hire_per, String rc_bran_addr, String rc_bran_tel, String rc_job_contA, String rc_job_contB,
			String rc_job_contC, String rc_job_contD, String rc_apl_st_dt, String rc_apl_ed_dt, String rc_pass_dt,
			String rc_apl_mat, String rc_manager, String rc_tel, Date rc_reg_dt, String rc_edu, int rnum) {
		super();
		this.reg_id = reg_id;
		this.rc_no = rc_no;
		this.reg_name = reg_name;
		this.rc_title = rc_title;
		this.rc_branch = rc_branch;
		this.rc_type = rc_type;
		this.rc_hire_per = rc_hire_per;
		this.rc_bran_addr = rc_bran_addr;
		this.rc_bran_tel = rc_bran_tel;
		this.rc_job_contA = rc_job_contA;
		this.rc_job_contB = rc_job_contB;
		this.rc_job_contC = rc_job_contC;
		this.rc_job_contD = rc_job_contD;
		this.rc_apl_st_dt = rc_apl_st_dt;
		this.rc_apl_ed_dt = rc_apl_ed_dt;
		this.rc_pass_dt = rc_pass_dt;
		this.rc_apl_mat = rc_apl_mat;
		this.rc_manager = rc_manager;
		this.rc_tel = rc_tel;
		this.rc_reg_dt = rc_reg_dt;
		this.rc_edu = rc_edu;
		this.rnum = rnum;
		
	}


	public Insa_Rc_rcBean(String reg_id, int rc_no, String reg_name, String rc_title, String rc_branch, String rc_type,
			int rc_hire_per, String rc_bran_addr, String rc_bran_tel, String rc_job_contA, String rc_job_contB,
			String rc_job_contC, String rc_job_contD, String rc_apl_st_dt, String rc_apl_ed_dt, String rc_pass_dt,
			String rc_apl_mat, String rc_manager, String rc_tel, Date rc_reg_dt, String rc_edu) {
		super();
		this.reg_id = reg_id;
		this.rc_no = rc_no;
		this.reg_name = reg_name;
		this.rc_title = rc_title;
		this.rc_branch = rc_branch;
		this.rc_type = rc_type;
		this.rc_hire_per = rc_hire_per;
		this.rc_bran_addr = rc_bran_addr;
		this.rc_bran_tel = rc_bran_tel;
		this.rc_job_contA = rc_job_contA;
		this.rc_job_contB = rc_job_contB;
		this.rc_job_contC = rc_job_contC;
		this.rc_job_contD = rc_job_contD;
		this.rc_apl_st_dt = rc_apl_st_dt;
		this.rc_apl_ed_dt = rc_apl_ed_dt;
		this.rc_pass_dt = rc_pass_dt;
		this.rc_apl_mat = rc_apl_mat;
		this.rc_manager = rc_manager;
		this.rc_tel = rc_tel;
		this.rc_reg_dt = rc_reg_dt;
		this.rc_edu = rc_edu;
	}
	
	public Insa_Rc_rcBean(String reg_id, int rc_no, String rc_branch, String rc_type,
			int rc_hire_per, String rc_apl_ed_dt, String rc_pass_dt,
			String rc_apl_mat, String rc_manager, String rc_tel, String rc_edu) {
		super();
		this.reg_id = reg_id;
		this.rc_no = rc_no;
		this.rc_branch = rc_branch;
		this.rc_type = rc_type;
		this.rc_hire_per = rc_hire_per;
		this.rc_apl_ed_dt = rc_apl_ed_dt;
		this.rc_pass_dt = rc_pass_dt;
		this.rc_apl_mat = rc_apl_mat;
		this.rc_manager = rc_manager;
		this.rc_tel = rc_tel;
		this.rc_edu = rc_edu;
	}	

	public void setReg_id(String reg_id) {this.reg_id = reg_id;}
	public void setRc_no(int rc_no) {this.rc_no = rc_no;}
	public void setReg_name(String reg_name) {this.reg_name = reg_name;}
	public void setRc_title(String rc_title) {this.rc_title = rc_title;}
	public void setRc_branch(String rc_branch) {this.rc_branch = rc_branch;}
	public void setRc_type(String rc_type) {this.rc_type = rc_type;}
	public void setRc_hire_per(int rc_hire_per) {this.rc_hire_per = rc_hire_per;}
	public void setRc_bran_addr(String rc_bran_addr) {this.rc_bran_addr = rc_bran_addr;}
	public void setRc_bran_tel(String rc_bran_tel) {this.rc_bran_tel = rc_bran_tel;}
	public void setRc_job_contA(String rc_job_contA) {this.rc_job_contA = rc_job_contA;}
	public void setRc_job_contB(String rc_job_contB) {this.rc_job_contB = rc_job_contB;}
	public void setRc_job_contC(String rc_job_contC) {this.rc_job_contC = rc_job_contC;}
	public void setRc_job_contD(String rc_job_contD) {this.rc_job_contD = rc_job_contD;}
	public void setRc_apl_st_dt(String rc_apl_st_dt) {this.rc_apl_st_dt = rc_apl_st_dt;}
	public void setRc_apl_ed_dt(String rc_apl_ed_dt) {this.rc_apl_ed_dt = rc_apl_ed_dt;}
	public void setRc_pass_dt(String rc_pass_dt) {this.rc_pass_dt = rc_pass_dt;}
	public void setRc_apl_mat(String rc_apl_mat){ 	if(rc_apl_mat==null) rc_apl_mat="";	this.rc_apl_mat		= rc_apl_mat;	}  
	public void setRc_manager(String rc_manager){ 	if(rc_manager==null) rc_manager="";	this.rc_manager		= rc_manager;	}  
	public void setRc_tel(String rc_tel){ 	if(rc_tel==null) rc_tel="";	this.rc_tel		= rc_tel;	}  	
	public void setRc_reg_dt(Date rc_reg_dt) {this.rc_reg_dt = rc_reg_dt;}
	public void setRnum(int rnum) {this.rnum = rnum;}
	public void setRc_edu(String rc_edu) {this.rc_edu = rc_edu;}
	public void setRc_nm(String rc_nm) {this.rc_nm = rc_nm;}
	public void setEdu_nm(String edu_nm){ 	if(edu_nm==null) edu_nm="";	this.edu_nm		= edu_nm;	}  
	
	//getter
	public String getReg_id() {return reg_id;}
	public int getRc_no() {return rc_no;}
	public String getReg_name() {return reg_name;}
	public String getRc_title() {return rc_title;}
	public String getRc_branch() {return rc_branch;}
	public String getRc_type() {return rc_type;}
	public int getRc_hire_per() {return rc_hire_per;}
	public String getRc_bran_addr() {return rc_bran_addr;}
	public String getRc_bran_tel() {return rc_bran_tel;}
	public String getRc_job_contA() {return rc_job_contA;}
	public String getRc_job_contB() {return rc_job_contB;}
	public String getRc_job_contC() {return rc_job_contC;}
	public String getRc_job_contD() {return rc_job_contD;}
	public String getRc_apl_st_dt() {return rc_apl_st_dt;}
	public String getRc_apl_ed_dt() {return rc_apl_ed_dt;}
	public String getRc_pass_dt() {return rc_pass_dt;}
	public String getRc_apl_mat() {return rc_apl_mat;}
	public String getRc_manager() {return rc_manager;}
	public String getRc_tel() {return rc_tel;}
	public Date getRc_reg_dt() {return rc_reg_dt;}
	public int getRnum() {return rnum;}
	public String getRc_edu() {return rc_edu;}
	public String getRc_nm() {return rc_nm;}
	public String getEdu_nm() {return edu_nm;}
    
}
