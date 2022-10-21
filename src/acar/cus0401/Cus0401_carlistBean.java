/**
 * 고객지원 차량리스트 빈
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 11. 5.
 * @ last modify date : - 
 */
package acar.cus0401;

import java.util.*;

public class Cus0401_carlistBean {
	//car_reg 자동차관리
	private String car_mng_id;
	//cont 계약
	private String rent_mng_id;
	private String rent_l_cd;
	//car_nm 자동차명
	private String car_nm;
	
    public Cus0401_carlistBean() {
		this.car_mng_id = "";	//car_reg
		this.rent_mng_id = "";	//cont
		this.rent_l_cd = "";
		this.car_nm = "";		//car_nm
	}

	public void setCar_mng_id(String val){if(val==null) val="";	this.car_mng_id = val;}
	public void setRent_mng_id(String val){ if (val==null) val=""; this.rent_mng_id = val; }
	public void setRent_l_cd(String val){ if(val==null) val=""; this.rent_l_cd = val; }
	public void setCar_nm(String val){ if(val==null) val=""; this.car_nm = val; }
	
	public String getCar_mng_id(){return car_mng_id; }
	public String getRent_mng_id(){ return rent_mng_id; }
	public String getRent_l_cd(){ return rent_l_cd; }
	public String getCar_nm(){ return car_nm; }
}
