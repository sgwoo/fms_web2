package acar.attend;

import java.util.*;

public class AttendBean {
    //Table : Attend
    private String dt;			//��¥
	private String dept_id;		//�μ�ID
    private String dept_nm;		//�μ���			
	private String user_id;		//�����ID
    private String user_nm;		//����ڸ�
    private String user_pos;	//����   
    private String login_dt;	//ù�α��νð�	
    private String ip;			//�����ǹ�ȣ
    private String ip_chk;		//�����Ǳ���
	private String content;		//��������
	private String title;		//�������� ����
	private String remark;		//�������� ����
	private String logout_dt;	//ù�α��νð�	

	public AttendBean() {  
		this.dt = "";
		this.dept_id = "";
		this.dept_nm = "";
		this.user_id = "";
		this.user_nm = "";
		this.user_pos = "";
		this.login_dt = "";
		this.ip = "";
		this.ip_chk = "";
		this.content = "";
		this.title = "";
		this.remark = "";
		this.logout_dt = "";
	}

	// set Method
	public void setDt(String val){			if(val==null) val=""; this.dt = val;		}
	public void setDept_id(String val){		if(val==null) val=""; this.dept_id = val;	}
	public void setDept_nm(String val){		if(val==null) val=""; this.dept_nm = val;	}
	public void setUser_id(String val){		if(val==null) val=""; this.user_id = val;	}
    public void setUser_nm(String val){		if(val==null) val=""; this.user_nm = val;	}
    public void setUser_pos(String val){	if(val==null) val=""; this.user_pos = val;	}
    public void setLogin_dt(String val){	if(val==null) val=""; this.login_dt = val;	}
    public void setIp(String val){			if(val==null) val=""; this.ip = val;		}
    public void setIp_chk(String val){		if(val==null) val=""; this.ip_chk = val;	}
    public void setContent(String val){		if(val==null) val=""; this.content = val;	}
    public void setTitle(String val){		if(val==null) val=""; this.title = val;		}
     public void setRemark(String val){		if(val==null) val=""; this.remark = val;		}
    public void setLogout_dt(String val){	if(val==null) val=""; this.logout_dt = val;	}
	
	//Get Method
	public String getDt(){			return dt;			}
    public String getDept_id(){		return dept_id;		}
    public String getDept_nm(){		return dept_nm;		}
	public String getUser_id(){		return user_id;		}
	public String getUser_nm(){		return user_nm;		}
    public String getUser_pos(){	return user_pos;	}
    public String getLogin_dt(){	return login_dt;	}
	public String getIp(){			return ip;			}
    public String getIp_chk(){		return ip_chk;		}
    public String getContent(){		return content;		}
    public String getTitle(){		return title;		}
    public String getRemark(){		return remark;		}
    public String getLogout_dt(){	return logout_dt;	}
	
}