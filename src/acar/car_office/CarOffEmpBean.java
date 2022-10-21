/**
 * 지급수수료
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package acar.car_office;

import java.util.*;

public class CarOffEmpBean {
    //Table : COMMI
    private String rent_mng_id; 				//계약관리번호
	private String emp_id;						//영업사원ID
    private String car_off_id;					//영업소ID
    private String car_off_nm;					//영업소명칭
    private String car_off_st;					//영업소구분
    private String owner_nm;
    private String car_comp_id;					//자동차회사ID
    private String car_comp_nm;					//자동차회사 명칭
    private String cust_st;						//고객구분
    private String emp_nm;						//성명
    private String emp_ssn;						//주민등록번호
    private String emp_ssn1;						//주민등록번호
    private String emp_ssn2;						//주민등록번호
    private String car_off_tel;					//사무실전화
	private String car_off_fax;					//팩스
    private String emp_m_tel;					//핸드폰
    private String emp_pos;						//직위
    private String emp_email;					//이메일
    private String emp_bank;					//은행
    private String emp_acc_no;					//계좌번호
    private String emp_acc_nm;					//예금주
    private String emp_post;
    private String emp_addr;
	private String etc;							//비고
	private String car_off_post;				//영업소우편번호
	private String car_off_addr;				//영업소주소
	private String reg_dt;
	private String reg_id;
	private String upd_dt;
	private String upd_id;
	private String emp_h_tel;					//영업사원-집전화
	private String emp_sex;						//영업사원-성별
	private String use_yn;						//sms문자수신여부
	private String sms_denial_rsn;				//sms문자수신거부사유
	private String seq;							//담당자변경순번
	private String damdang_id;					//담당자
	private String cng_rsn;						//담당자 지정사유
	private String cng_dt;						//담당 지정(변경)일자
	private String file_name1;					//스캔파일-신분증
	private String file_name2;					//스캔파일-통장
	private String job_st;						//20080228
	private String file_gubun1;					//스캔파일-신분증
	private String file_gubun2;					//스캔파일-통장
	private String one_self_yn;					//자체출고영업소여부
	private String agent_id;					//에이전트코드
	private String emp_dept;					//부서
	private String fraud_care;					//사기거래 관련 주의요망
	private String bank_cd;					

        
    // CONSTRCTOR            
    public CarOffEmpBean() {  
		this.rent_mng_id	= ""; 					//계약관리번호
		this.emp_id			= "";					//영업사원ID
	    this.car_off_id		= "";					//영업소ID
	    this.car_off_nm		= "";					//영업소명칭
	    this.car_off_st		= "";					
	    this.owner_nm		= "";
	    this.car_comp_id	= "";					//자동차회사ID
	    this.car_comp_nm	= "";					//자동차회사 명칭
	    this.cust_st		= "";					//고객구분
	    this.emp_nm			= "";					//성명
	    this.emp_ssn		= "";					//주민등록번호
	    this.emp_ssn1		= "";					//주민등록번호
	    this.emp_ssn2		= "";					//주민등록번호
	    this.car_off_tel	= "";					//사무실전화
		this.car_off_fax	= "";					//팩스
	    this.emp_m_tel		= "";					//핸드폰
	    this.emp_pos		= "";					//직위
	    this.emp_email		= "";					//이메일
	    this.emp_bank		= "";					//은행
	    this.emp_acc_no		= "";					//계좌번호
	    this.emp_acc_nm		= "";					//예금주
	    this.emp_post		= "";						
	    this.emp_addr		= "";						
		this.etc			= "";
		this.car_off_post	= "";					//영업소 우편번호   
		this.car_off_addr	= "";					//영업소 주소
		this.reg_dt			= "";
		this.reg_id			= "";
		this.upd_dt			= "";
		this.upd_id			= "";
		this.emp_h_tel		= "";
		this.emp_sex		= "";
		this.use_yn			= "";
		this.sms_denial_rsn = "";
		this.seq			= "";
		this.damdang_id		= "";
		this.cng_rsn		= "";
		this.cng_dt			= "";
		this.file_name1		= "";
		this.file_name2		= "";
		this.job_st 		= "";
		this.file_gubun1	= "";
		this.file_gubun2	= "";
		this.one_self_yn	= "";
		this.agent_id		= "";
		this.emp_dept		= "";
		this.fraud_care     = "";
		this.bank_cd		= "";

	}

	// get Method
	public void setRent_mng_id		(String val){		if(val==null) val="";		this.rent_mng_id	= val;	}
	public void setEmp_id			(String val){		if(val==null) val="";		this.emp_id			= val;	}
	public void setCar_off_id		(String val){		if(val==null) val="";		this.car_off_id		= val;	}
	public void setCar_off_nm		(String val){		if(val==null) val="";		this.car_off_nm		= val;	}
	public void setCar_off_st		(String val){		if(val==null) val="";		this.car_off_st		= val;	}
	public void setOwner_nm			(String val){		if(val==null) val="";		this.owner_nm		= val;	}
	public void setCar_comp_id		(String val){		if(val==null) val="";		this.car_comp_id	= val;	}
	public void setCar_comp_nm		(String val){		if(val==null) val="";		this.car_comp_nm	= val;	}
	public void setCust_st			(String val){		if(val==null) val="";		this.cust_st		= val;	}
	public void setEmp_nm			(String val){		if(val==null) val="";		this.emp_nm			= val;	}
	public void setEmp_ssn			(String val){		if(val==null) val="";		this.emp_ssn		= val;	}
	public void setCar_off_tel		(String val){		if(val==null) val="";		this.car_off_tel	= val;	}
	public void setCar_off_fax		(String val){		if(val==null) val="";		this.car_off_fax	= val;	}
	public void setEmp_m_tel		(String val){		if(val==null) val="";		this.emp_m_tel		= val;	}
	public void setEmp_pos			(String val){		if(val==null) val="";		this.emp_pos		= val;	}
	public void setEmp_email		(String val){		if(val==null) val="";		this.emp_email		= val;	}
	public void setEmp_bank			(String val){		if(val==null) val="";		this.emp_bank		= val;	}
	public void setEmp_acc_no		(String val){		if(val==null) val="";		this.emp_acc_no		= val;	}
	public void setEmp_acc_nm		(String val){		if(val==null) val="";		this.emp_acc_nm		= val;	}
	public void setEmp_post			(String val){		if(val==null) val="";		this.emp_post		= val;	}
	public void setEmp_addr			(String val){		if(val==null) val="";		this.emp_addr		= val;	}
	public void setEtc				(String val){		if(val==null) val="";		this.etc			= val;	}
	public void setCar_off_post		(String val){		if(val==null) val="";		this.car_off_post	= val;	}
	public void setCar_off_addr		(String val){		if(val==null) val="";		this.car_off_addr	= val;	}
	public void setReg_dt			(String val){		if(val==null) val="";		this.reg_dt			= val;	}
	public void setReg_id			(String val){		if(val==null) val="";		this.reg_id			= val;	}
	public void setUpd_dt			(String val){		if(val==null) val="";		this.upd_dt			= val;	}
	public void setUpd_id			(String val){		if(val==null) val="";		this.upd_id			= val;	}
	public void setEmp_h_tel		(String val){		if(val==null) val="";		this.emp_h_tel		= val;	}
	public void setEmp_sex			(String val){		if(val==null) val="";		this.emp_sex		= val;	}
	public void setUse_yn			(String val){		if(val==null) val="";		this.use_yn			= val;	}
	public void setSms_denial_rsn	(String val){		if(val==null) val="";		this.sms_denial_rsn = val;	}
	public void setSeq				(String val){		if(val==null) val="";		this.seq			= val;	}
	public void setDamdang_id		(String val){		if(val==null) val="";		this.damdang_id		= val;	}
	public void setCng_rsn			(String val){		if(val==null) val="";		this.cng_rsn		= val;	}
	public void setCng_dt			(String val){		if(val==null) val="";		this.cng_dt			= val;	}
	public void setFile_name1		(String val){		if(val==null) val="";		this.file_name1		= val;	}
	public void setFile_name2		(String val){		if(val==null) val="";		this.file_name2		= val;	}
	public void setFile_gubun1		(String val){		if(val==null) val="";		this.file_gubun1	= val;	}
	public void setFile_gubun2		(String val){		if(val==null) val="";		this.file_gubun2	= val;	}
	public void setJob_st		 	(String val){		if(val==null) val="";		this.job_st	 	  	= val;	}
	public void setOne_self_yn		(String val){		if(val==null) val="";		this.one_self_yn	= val;	}
	public void setAgent_id			(String val){		if(val==null) val="";		this.agent_id		= val;	}
	public void setEmp_dept			(String val){		if(val==null) val="";		this.emp_dept		= val;	}
	public void setFraud_care		(String val){		if(val==null) val="";		this.fraud_care		= val;	}
	public void setBank_cd			(String val){		if(val==null) val="";		this.bank_cd		= val;	}
	
		
	//Get Method
	public String getRent_mng_id	(){		return rent_mng_id;		}
	public String getEmp_id			(){		return emp_id;			}
	public String getCar_off_id		(){		return car_off_id;		}
	public String getCar_off_nm		(){		return car_off_nm;		}
	public String getCar_off_st		(){		return car_off_st;		}
	public String getOwner_nm		(){		return owner_nm;		}
	public String getCar_comp_id	(){		return car_comp_id;		}
	public String getCar_comp_nm	(){		return car_comp_nm;		}
	public String getCust_st		(){		return cust_st;			}
	public String getEmp_nm			(){		return emp_nm;			}
	public String getEmp_ssn		(){		return emp_ssn;			}
	public String getCar_off_tel	(){		return car_off_tel;		}
	public String getCar_off_fax	(){		return car_off_fax;		}
	public String getEmp_m_tel		(){		return emp_m_tel;		}
	public String getEmp_pos		(){		return emp_pos;			}
	public String getEmp_email		(){		return emp_email;		}
	public String getEmp_bank		(){		return emp_bank;		}
	public String getEmp_acc_no		(){		return emp_acc_no;		}
	public String getEmp_acc_nm		(){		return emp_acc_nm;		}
	public String getEmp_post		(){		return emp_post;		}
	public String getEmp_addr		(){		return emp_addr;		}
	public String getEtc			(){		return etc;				}
	public String getCar_off_post	(){		return car_off_post;	}
	public String getCar_off_addr	(){		return car_off_addr;	}
	public String getReg_dt			(){		return reg_dt;			}
	public String getReg_id			(){		return reg_id;			}
	public String getUpd_dt			(){		return upd_dt;			}
	public String getUpd_id			(){		return upd_id;			}
	public String getEmp_h_tel		(){		return emp_h_tel;		}
	public String getEmp_sex		(){		return emp_sex;			}
	public String getUse_yn			(){		return use_yn;			}
	public String getSms_denial_rsn	(){		return sms_denial_rsn;	}
	public String getSeq			(){		return seq;				}
	public String getDamdang_id		(){		return damdang_id;		}
	public String getCng_rsn		(){		return cng_rsn;			}
	public String getCng_dt			(){		return cng_dt;			}
	public String getFile_name1		(){		return file_name1;		}
	public String getFile_name2		(){		return file_name2;		}
	public String getJob_st		   	(){		return job_st;		   	}  
	public String getFile_gubun1	(){		return file_gubun1;		}
	public String getFile_gubun2	(){		return file_gubun2;		}
	public String getOne_self_yn	(){		return one_self_yn;		}
	public String getAgent_id		(){		return agent_id;		}
	public String getEmp_dept		(){		return emp_dept;		}
	public String getFraud_care		(){		return fraud_care;		}
	public String getBank_cd		(){		return bank_cd;			}
	

	public String getEmp_ssn1		(){
		if(emp_ssn.equals("")){
			return emp_ssn1;
		}else{
			if(emp_ssn.length()>6){
				return emp_ssn.substring(0,6);	
			}else{
				return emp_ssn1;	
			}
		}
	}
	public String getEmp_ssn2		(){
		if(emp_ssn.equals("")){
			return emp_ssn2;
		}else{
			if(emp_ssn.length()>6){	
				return emp_ssn.substring(6);
			}else{
				return emp_ssn2;
			}
		}
	}

}
