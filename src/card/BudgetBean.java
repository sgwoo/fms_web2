/*
 * 사용자관리
 * @ author : Jung Tae Kim
 * @ e-mail : jtkim@nicstech.com
 * @ create date : 2001. 12. 24
 * @ last modify date : 
 */
package card;

import java.util.*;

public class BudgetBean {
    //Table : USERS
    private String user_id;					//사용자관리번호
    private String br_id;					// 지점ID
    private String br_nm;					//지점명칭
    private String user_nm;					//사용자이름
    private String dept_id;					//부서ID
    private String dept_nm;					//부서이름
    private String user_pos;				//직위
 	private String enter_dt;				//입사년월일
	private String use_yn;					//근무여부
    private String out_dt;					//퇴사일자
    private int    prv; //이월 ( 회식+ ㅍ상)
    private int    jan;
    private int    feb;
    private int    mar;
    private int    apr;
    private int    may;
    private int    jun;
    private int    jul;
    private int    aug;
    private int    sep;
    private int    oct;
    private int    nov;
    private int    dec; //회식 
    
    private int    jan1;
    private int    feb1;
    private int    mar1;
    private int    apr1;
    private int    may1;
    private int    jun1;
    private int    jul1;
    private int    aug1;
    private int    sep1;
    private int    oct1;
    private int    nov1;
    private int    dec1;  // 포상
    
    private int    tot;
    private String byear;					//예산년도
    private String bgubun;					//예산구분 -> 01:회식&야유회 02:유류대
                   
	
    // CONSTRCTOR            
    public BudgetBean() {  
    	this.user_id = "";					//사용자관리번호
	    this.br_id = "";					// 지점ID
	    this.br_nm = "";					//지점명칭
	    this.user_nm = "";					//사용자이름
	    this.dept_id = "";					//부서ID
	    this.dept_nm = "";					//부서이름
	    this.user_pos = "";					//직위
		this.enter_dt = "";	
		this.use_yn = "";
		this.out_dt = "";
		this.prv	= 0;
		this.jan	= 0;
		this.feb	= 0;
		this.mar	= 0;
		this.apr	= 0;
		this.may	= 0;
		this.jun	= 0;
		this.jul	= 0;
		this.aug	= 0;
		this.sep	= 0;
		this.oct	= 0;
		this.nov	= 0;
		this.dec	= 0;
		this.jan1	= 0;
		this.feb1	= 0;
		this.mar1	= 0;
		this.apr1	= 0;
		this.may1	= 0;
		this.jun1	= 0;
		this.jul1	= 0;
		this.aug1	= 0;
		this.sep1	= 0;
		this.oct1	= 0;
		this.nov1	= 0;
		this.dec1	= 0;
		this.tot	= 0;
		this.byear = "";
		this.bgubun = "";																		
								
	}

	// get Method
	public void setUser_id(String val){
		if(val==null) val="";
		this.user_id = val;
	}
	public void setBr_id(String val){
		if(val==null) val="";
		this.br_id = val;
	}
	public void setBr_nm(String val){
		if(val==null) val="";
		this.br_nm = val;
	}
	public void setUser_nm(String val){
		if(val==null) val="";
		this.user_nm = val;
	}
	public void setDept_id(String val){
		if(val==null) val="";
		this.dept_id = val;
	}
	public void setDept_nm(String val){
		if(val==null) val="";
		this.dept_nm = val;
	}

	public void setUser_pos(String val){
		if(val==null) val="";
		this.user_pos = val;
	}

	public void setEnter_dt(String val){if(val==null) val="";	this.enter_dt = val;}	
	public void setUse_yn(String val){	if(val==null) val="";	this.use_yn = val;	}	
	public void setOut_dt(String val){	if(val==null) val="";	this.out_dt = val;	}	
	public void setPrv				(int val){					this.prv		= val;	}
	public void setJan				(int val){					this.jan		= val;	}
	public void setFeb				(int val){					this.feb		= val;	}
	public void setMar				(int val){					this.mar		= val;	}
	public void setApr				(int val){					this.apr		= val;	}
	public void setMay				(int val){					this.may		= val;	}
	public void setJun				(int val){					this.jun		= val;	}
	public void setJul				(int val){					this.jul		= val;	}
	public void setAug				(int val){					this.aug		= val;	}
	public void setSep				(int val){					this.sep		= val;	}
	public void setOct				(int val){					this.oct		= val;	}
	public void setNov				(int val){					this.nov		= val;	}
	public void setDec				(int val){					this.dec		= val;	}
	public void setJan1				(int val){					this.jan1		= val;	}
	public void setFeb1				(int val){					this.feb1		= val;	}
	public void setMar1				(int val){					this.mar1		= val;	}
	public void setApr1				(int val){					this.apr1		= val;	}
	public void setMay1				(int val){					this.may1		= val;	}
	public void setJun1				(int val){					this.jun1		= val;	}
	public void setJul1				(int val){					this.jul1		= val;	}
	public void setAug1				(int val){					this.aug1		= val;	}
	public void setSep1				(int val){					this.sep1		= val;	}
	public void setOct1				(int val){					this.oct1		= val;	}
	public void setNov1				(int val){					this.nov1		= val;	}
	public void setDec1				(int val){					this.dec1		= val;	}
	public void setTot				(int val){					this.tot		= val;	}
	public void setByear(String val){	if(val==null) val="";	this.byear = val;	}	
	public void setBgubun(String val){	if(val==null) val="";	this.bgubun = val;	}	
	
	//Get Method
	public String getUser_id(){
		return user_id;
	}
	public String getBr_id(){
		return br_id;
	}
	public String getBr_nm(){
		return br_nm;
	}
	public String getUser_nm(){
		return user_nm;
	}
	
	public String getDept_id(){
		return dept_id;
	}
	public String getDept_nm(){
		return dept_nm;
	}
	
	public String getUser_pos(){
		return user_pos;
	}

	public String getEnter_dt(){return enter_dt;}
	public String getUse_yn(){	return use_yn;	}
	public String getOut_dt(){	return out_dt;	}
	public int    getPrv		(){		return		prv;          }
	public int    getJan		(){		return		jan;          }
	public int    getFeb		(){		return		feb;          }
	public int    getMar		(){		return		mar;          }
	public int    getApr		(){		return		apr;          }
	public int    getMay		(){		return		may;          }
	public int    getJun		(){		return		jun;          }
	public int    getJul		(){		return		jul;          }
	public int    getAug		(){		return		aug;          }
	public int    getSep		(){		return		sep;          }
	public int    getOct		(){		return		oct;          }
	public int    getNov		(){		return		nov;          }
	public int    getDec		(){		return		dec;          }
	public int    getJan1		(){		return		jan1;          }
	public int    getFeb1		(){		return		feb1;          }
	public int    getMar1		(){		return		mar1;          }
	public int    getApr1		(){		return		apr1;          }
	public int    getMay1		(){		return		may1;          }
	public int    getJun1		(){		return		jun1;          }
	public int    getJul1		(){		return		jul1;          }
	public int    getAug1		(){		return		aug1;          }
	public int    getSep1		(){		return		sep1;          }
	public int    getOct1		(){		return		oct1;          }
	public int    getNov1		(){		return		nov1;          }
	public int    getDec1		(){		return		dec1;          }
	public int    getTot		(){		return		tot;          }
	public String getByear(){	return byear;	}
	public String getBgubun(){	return bgubun;	}
}