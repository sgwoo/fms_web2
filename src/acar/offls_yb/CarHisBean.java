/**
 * �������� �������� ����
 * - ������ �� �����̷�����
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 02. 10. Mon.
 * @ last modify date : 
 *						- 2003.06.19.Thu. ;�������� CLS_ST �߰�.
 */
package acar.offls_yb;

public class CarHisBean {
	//Table : CONT, CLS_CONT, FEE
	private String client_nm;
	private String firm_nm;
	private String rent_st_dt;
	private String rent_ed_dt;
	private String cls_st;

	// CONSTRCTOR            
    public CarHisBean() {
		this.client_nm = "";
		this.firm_nm = "";
		this.rent_st_dt = "";
		this.rent_ed_dt = "";
		this.cls_st = "";
	}

	// set Method
	public void setClient_nm(String val){ if(val==null) val=""; this.client_nm = val; }
	public void setFirm_nm(String val){ if(val==null) val=""; this.firm_nm = val; }
	public void setRent_st_dt(String val){ if(val==null) val=""; this.rent_st_dt = val; }
	public void setRent_ed_dt(String val){ if(val==null) val=""; this.rent_ed_dt = val; }
	public void setCls_st(String val){ if(val==null) val=""; this.cls_st = val; }

	//get Method
	public String getClient_nm(){ return client_nm; }
	public String getFirm_nm(){ return firm_nm; }
	public String getRent_st_dt(){ return rent_st_dt; }
	public String getRent_ed_dt(){ return rent_ed_dt; }
	public String getCls_st(){ return cls_st; }
}