/**
 * ������ �������� ��
 * @ author : Yongsoon Kwon
 * @ e-mail : 
 * @ create date : 2003. 12. 23. ȭ.
 * @ last modify date : - 2004.7.15. SpeedCheckBean ���� SpdchkBean ���� ����
 */
package acar.cus_reg;

import java.util.*;

public class SpdchkBean {
	//speedcheck ��������
	private String chk_id;
	private String chk_nm;
	private String chk_cont;

	
    public SpdchkBean() {
		this.chk_id = "";
		this.chk_nm = "";
		this.chk_cont = "";
	}

	public void setChk_id(String val){if(val==null) val="";	this.chk_id = val;}
	public void setChk_nm(String val){if(val==null) val="";	this.chk_nm = val;}
	public void setChk_cont(String val){if(val==null) val="";	this.chk_cont = val;}
	
	public String getChk_id(){return chk_id; }
	public String getChk_nm(){return chk_nm; }
	public String getChk_cont(){return chk_cont; }

}
