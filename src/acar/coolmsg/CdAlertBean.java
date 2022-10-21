package acar.coolmsg;

import java.util.*;

public class CdAlertBean {
    //Table : Cd_alert
    private String fldidx;				
    private String flddata;				
    private String fldtype;				

    // CONSTRCTOR            
    public CdAlertBean() {  
    	this.fldidx		= "";
	    this.flddata	= "";
	    this.fldtype	= "";
	}

	// get Method
	public void setFldidx	(String val){		if(val==null) val="";		this.fldidx		= val;	}
	public void setFlddata	(String val){		if(val==null) val="";		this.flddata	= val;	}
	public void setFldtype	(String val){		if(val==null) val="";		this.fldtype	= val;	}
		
	//Get Method
	public String getFldidx	(){		return fldidx;		}
	public String getFlddata(){		return flddata;		}
	public String getFldtype(){		return fldtype;		}
	
}