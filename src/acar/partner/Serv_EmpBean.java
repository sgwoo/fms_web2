/**  명함관리-담당자 등록
 * 
 * @ author : Gill Sun Ryu
 * @ e-mail : 
 * @ create date : 2015. 04. 21
 * @ last modify date : 
 */
package acar.partner;

import java.util.*;

public class Serv_EmpBean {
    //Table : Serv_EmpBean
    private String off_id;				//업체 아이디
  	private int		seq;				//시퀀스
	private String emp_nm;				//담당자
	private String dept_nm;				//부서
	private String pos;					//직책
	private String emp_level;			//직급
	private String emp_tel;				//대표전화
	private String emp_htel;			//직통전화
	private String emp_fax;				//팩스
	private String emp_mtel;			//휴대폰
	private String emp_email;			//e-mail
	private String reg_dt;				//최초등록일
	private String upt_dt;				//변경등록(수정일)
	private String emp_role;			//담당업무
	private String emp_valid;			//유효구분(1유효, 2전출, 3삭제)
	private String emp_addr;			//주소
	private String emp_post;			//우편번호
	private String emp_email_yn;		//메일발송대상/비대상

    // CONSTRCTOR            
public Serv_EmpBean() {  
	this.off_id = "";
  	this.seq = 0;
	this.emp_nm = "";
	this.dept_nm = "";
	this.pos = "";
	this.emp_level = "";
	this.emp_tel = "";
	this.emp_htel = "";
	this.emp_fax = "";
	this.emp_mtel = "";
	this.emp_email = "";
	this.reg_dt = "";
	this.upt_dt = "";
	this.emp_role = "";
	this.emp_valid = "";
	this.emp_addr = "";
	this.emp_post = "";
	this.emp_email_yn = "";

	}

	// set Method
	public void setOff_id(String val){		if(val==null) val="";		this.off_id = val;		}
	public void setSeq		(int val){									this.seq	= val;		}
	public void setEmp_nm(String val){		if(val==null) val="";		this.emp_nm = val;		}
	public void setDept_nm(String val){		if(val==null) val="";		this.dept_nm = val;		}
	public void setPos(String val){			if(val==null) val="";		this.pos = val;			}
	public void setEmp_level(String val){	if(val==null) val="";		this.emp_level = val;	}
	public void setEmp_tel(String val){		if(val==null) val="";		this.emp_tel = val;		}
	public void setEmp_htel(String val){	if(val==null) val="";		this.emp_htel = val;	}
	public void setEmp_fax(String val){		if(val==null)val = "";		this.emp_fax = val;		}
	public void setEmp_mtel(String val){	if(val==null)val = "";		this.emp_mtel = val;	}
	public void setEmp_email(String val){	if(val==null)val = "";		this.emp_email = val;	}
	public void setReg_dt(String val){		if(val==null)val = "";		this.reg_dt = val;		}
	public void setUpt_dt(String val){		if(val==null)val = "";		this.upt_dt = val;		}
	public void setEmp_role(String val){	if(val==null)val = "";		this.emp_role = val;	}
	public void setEmp_valid(String val){	if(val==null)val = "";		this.emp_valid = val;	}
	public void setEmp_addr(String val){	if(val==null)val = "";		this.emp_addr = val;	}
	public void setEmp_post(String val){	if(val==null)val = "";		this.emp_post = val;	}
	public void setEmp_email_yn(String val){	if(val==null)val = "";		this.emp_email_yn = val;	}
				
	//Get Method
	public String 	getOff_id(){		return off_id;		}
	public int 		getSeq(){			return seq;			}
	public String	getEmp_nm(){		return emp_nm;		}
	public String	getDept_nm(){		return dept_nm;		}
	public String	getPos(){			return pos;			}
	public String	getEmp_level(){		return emp_level;	}
	public String	getEmp_tel(){		return emp_tel;		}
	public String	getEmp_htel(){		return emp_htel;	}
	public String	getEmp_fax(){		return emp_fax;		}
	public String	getEmp_mtel(){		return emp_mtel;	}
	public String	getEmp_email(){		return emp_email;	}
	public String	getReg_dt(){		return reg_dt;		}
	public String	getUpt_dt(){		return upt_dt;		}
	public String	getEmp_role(){		return emp_role;	}
	public String	getEmp_valid(){		return emp_valid;	}
	public String	getEmp_addr(){		return emp_addr;	}
	public String	getEmp_post(){		return emp_post;	}
	public String	getEmp_email_yn(){		return emp_email_yn;	}

}