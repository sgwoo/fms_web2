/**사내 게시판
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */

package acar.off_anc;

import java.util.*;

public class BulBean {
    //Table : Bulletin
    private int b_id;
    private String user_id;
    private String user_nm;
    private String br_id;
    private String br_nm;
    private String dept_id;
    private String dept_nm;
    private String reg_dt;
    private String exp_dt;
    private String title;
    private String content;	
	private String read_chk;
	private String use_chk;
	private String att_file1;
	private String att_file2;
	private String att_file3;
	private String att_file4;
	private String att_file5;
    private int visit_cnt;
	private String b_st;
          
    // CONSTRCTOR            
    public BulBean() {  
    	this.b_id = 0;
    	this.user_id = "";
    	this.user_nm = "";
    	this.br_id = "";
    	this.br_nm = "";
    	this.dept_id = "";
    	this.dept_nm = "";
	    this.reg_dt = "";
	    this.exp_dt = "";
	    this.title = "";
	    this.content = "";		
		this.read_chk = "";
		this.use_chk = "";
		this.att_file1 = "";
		this.att_file2 = "";
		this.att_file3 = "";
		this.att_file4 = "";
		this.att_file5 = "";
		this.visit_cnt = 0;
		this.b_st = "";
		}


	// set Method
	public void setB_id(int val){
		this.b_id = val;
	}
	public void setUser_id(String val){
		if(val==null) val="";
		this.user_id = val;
	}
	public void setUser_nm(String val){
		if(val==null) val="";
		this.user_nm = val;
	}
	public void setBr_id(String val){
		if(val==null) val="";
		this.br_id = val;
	}
	public void setBr_nm(String val){
		if(val==null) val="";
		this.br_nm = val;
	}
	public void setDept_id(String val){
		if(val==null) val="";
		this.dept_id = val;
	}
	public void setDept_nm(String val){
		if(val==null) val="";
		this.dept_nm = val;
	}
	public void setReg_dt(String val){
		if(val==null) val="";
		this.reg_dt = val;
	}
	public void setExp_dt(String val){
		if(val==null) val="";
		this.exp_dt = val;
	}
	public void setTitle(String val){
		if(val==null) val="";
		this.title = val;
	}
	public void setContent(String val){
		if(val==null) val="";
		this.content = val;
	}
	public void setRead_chk(String val){
		if(val==null) val="";
		this.read_chk = val;
	}
	public void setUse_chk(String val){
		if(val==null) val="";
		this.use_chk = val;
	}
	public void setAtt_file1(String val){
		if(val==null) val="";
		this.att_file1 = val;
	}
	public void setAtt_file2(String val){
		if(val==null) val="";
		this.att_file2 = val;
	}
	public void setAtt_file3(String val){
		if(val==null) val="";
		this.att_file3 = val;
	}
	public void setAtt_file4(String val){
		if(val==null) val="";
		this.att_file4 = val;
	}
	public void setAtt_file5(String val){
		if(val==null) val="";
		this.att_file5 = val;
	}
	public void setVisit_cnt(int val){
		//if(val ==null) val=0;
		this.visit_cnt = val;
	}
	public void setB_st(String val){
		if(val==null) val="";
		this.b_st = val;
	}
	
	
	//Get Method
	public int getB_id(){
		return b_id;
	}
	public String getUser_id(){
		return user_id;
	}
	public String getUser_nm(){
		return user_nm;
	}
	public String getBr_id(){
		return br_id;
	}
	public String getBr_nm(){
		return br_nm;
	}
	public String getDept_id(){
		return dept_id;
	}
	public String getDept_nm(){
		return dept_nm;
	}
	public String getReg_dt(){
		return reg_dt;
	}
	public String getExp_dt(){
		return exp_dt;
	}
	public String getTitle(){
		return title;
	}
	public String getContent(){
		return content;
	}
	public String getRead_chk(){
		return read_chk;
	}
	public String getUse_chk(){
		return use_chk;
	}
	public String getAtt_file1(){
		return att_file1;
	}
	public String getAtt_file2(){
		return att_file2;
	}
	public String getAtt_file3(){
		return att_file3;
	}
	public String getAtt_file4(){
		return att_file4;
	}
	public String getAtt_file5(){
		return att_file5;
	}
	public int getVisit_cnt(){
		return visit_cnt;
	}
	public String getB_st(){
		return b_st;
	}
}