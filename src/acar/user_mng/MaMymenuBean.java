package acar.user_mng;

import java.util.*;

public class MaMymenuBean {
    //Table : MA_MYMENU
    private String user_id;				//사용자코드
    private int seq;					//일련번호
    private String m_st;				//대메뉴
    private String m_st2;				//중메뉴
    private String m_cd;				//소메뉴
    private int sort;					//정렬
        
    // CONSTRCTOR            
    public MaMymenuBean() {  
	    this.user_id = "";
	    this.seq = 1;
		this.m_st = "";
    	this.m_st2 = "";
	    this.m_cd = "";
		this.sort = 1;
	}

	//Set Method
	public void setUser_id(String val){		if(val==null) val="";		this.user_id = val;		}
	public void setSeq(int val){										this.seq = val;			}
	public void setM_st(String val){		if(val==null) val="";		this.m_st = val;		}
	public void setM_st2(String val){		if(val==null) val="";		this.m_st2 = val;		}
	public void setM_cd(String val){		if(val==null) val="";		this.m_cd = val;		}
	public void setSort(int val){										this.sort = val;		}

	//Get Method	
	public String getUser_id(){		return user_id;	}
	public int getSeq(){			return seq;		}
	public String getM_st(){		return m_st;	}
	public String getM_st2(){		return m_st2;	}
	public String getM_cd(){		return m_cd;	}
	public int getSort(){			return sort;	}

}