/**
 * 견적변수관리-공통 계산식
 */
package acar.estimate_mng;
import java.util.*;

public class EstiSikVarBean {

	//Table : ESTI_SIK_VAR
    private String a_a;			//대여구분-일단 공통으로 '1'
    private String seq;			//일련번호
    private String var_cd;		//계산식코드명
    private String var_nm;		//계산식명
    private String var_sik;		//계산식
	private String a_j;			//견적적용일
 

	// CONSTRCTOR            
    public EstiSikVarBean() {  
    	this.a_a = "";
    	this.seq = "";
		this.var_cd = "";
		this.var_nm = "";
		this.var_sik = "";
    	this.a_j = "";
	}

	// get Method
    public void setA_a(String val){		if(val==null) val="";	this.a_a = val;		}
    public void setSeq(String val){		if(val==null) val="";	this.seq = val;		}
	public void setVar_cd(String val){	if(val==null) val="";	this.var_cd = val;	}		
	public void setVar_nm(String val){	if(val==null) val="";	this.var_nm = val;	}
	public void setVar_sik(String val){	if(val==null) val="";	this.var_sik = val;	}
	public void setA_j(String val){		if(val==null) val="";	this.a_j = val;		}

	//Get Method
	public String getA_a(){			return a_a;		}
	public String getSeq(){			return seq;		}
	public String getVar_cd(){		return var_cd;	}
	public String getVar_nm(){		return var_nm;	}
	public String getVar_sik(){		return var_sik;	}
	public String getA_j(){			return a_j;		}

}
