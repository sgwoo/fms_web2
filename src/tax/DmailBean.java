package tax;

import java.util.*;

public class DmailBean {

	//Table : 이벤트 메일
	private String table;      
	private String sequence;      
	private int    seqidx;
	private String subject;      
	private String sql;      
	private int    reject_slist_idx;      
	private int    block_group_idx;   
	private String mailfrom;    
	private String mailto;     
	private String replyto;     
	private String errosto;     
	private int    html;      
	private int    encoding;       
	private String charset;      
	private String sdate;   
	private String tdate;      
	private int    duration_set;      
	private int    click_set;      
	private int    site_set;      
	private int    atc_set;      
	private String gubun;        
	private String rname;      
	private int    mtype;        
	private int    u_idx;          
	private int    g_idx;      
	private int    msgflag;       
	private String content;        
	private String index;       
	private String seq;    
	private String gubun2;        
	private String v_content;        
	private String v_mailfrom;    
	private String v_mailto;     

	// CONSTRCTOR            
	public DmailBean() {  
		table				= "";
		sequence			= "";
		seqidx				= 0;
		subject				= "";
		sql					= "";
		reject_slist_idx    = 0;
		block_group_idx		= 0;
		mailfrom			= "";
		mailto				= "";
		replyto				= "";
		errosto				= "";
		html				= 0;
		encoding			= 0;
		charset				= "";
		sdate				= "";
		tdate				= "";
		duration_set		= 0;
		click_set			= 0;
		site_set			= 0;
		atc_set				= 0;
		gubun				= "";
		rname				= "";
		mtype       		= 0; 
		u_idx       		= 0; 
		g_idx				= 0; 
		msgflag     		= 0; 
		content				= "";     
		index				= "";
		seq					= "";
		gubun2				= "";
		v_content			= "";     
		v_mailfrom			= "";
		v_mailto			= "";
	}

	//Set Method
	public void setTable			(String val){	if(val==null) val="";		table				= val;		}
	public void setSequence			(String val){	if(val==null) val="";		sequence			= val;		}
	public void setSeqidx			(int    val){								seqidx				= val;		}
	public void setSubject			(String val){	if(val==null) val="";		subject				= val;		}
	public void setSql				(String val){	if(val==null) val="";		sql					= val;		}
	public void setReject_slist_idx	(int    val){								reject_slist_idx    = val;		}
	public void setBlock_group_idx	(int    val){								block_group_idx		= val;		}	
	public void setMailfrom			(String val){	if(val==null) val="";		mailfrom			= val;		}	
	public void setMailto			(String val){	if(val==null) val="";		mailto				= val;		}
	public void setReplyto			(String val){	if(val==null) val="";		replyto				= val;		}
	public void setErrosto			(String val){	if(val==null) val="";		errosto				= val;		}
	public void setHtml				(int    val){								html				= val;		}
	public void setEncoding			(int    val){								encoding			= val;		}
	public void setCharset			(String val){	if(val==null) val="";		charset				= val;		}
	public void setSdate			(String val){	if(val==null) val="";		sdate				= val;		}
	public void setTdate			(String val){	if(val==null) val="";		tdate				= val;		}
	public void setDuration_set		(int    val){								duration_set		= val;		}
	public void setClick_set		(int    val){								click_set			= val;		}
	public void setSite_set			(int    val){								site_set			= val;		}
	public void setAtc_set			(int    val){								atc_set				= val;		}
	public void setGubun			(String val){	if(val==null) val="";		gubun				= val;		}
	public void setRname			(String val){	if(val==null) val="";		rname				= val;		}
	public void setMtype       		(int    val){								mtype       		= val;		}
	public void setU_idx       		(int    val){								u_idx       		= val;		}
	public void setG_idx			(int    val){								g_idx				= val;		}
	public void setMsgflag     		(int    val){								msgflag     		= val;		}
	public void setContent			(String val){	if(val==null) val="";		content				= val;		}
	public void setIndex			(String val){	if(val==null) val="";		index				= val;		}
	public void setSeq				(String val){	if(val==null) val="";		seq					= val;		}
	public void setGubun2			(String val){	if(val==null) val="";		gubun2				= val;		}
	public void setV_content		(String val){	if(val==null) val="";		v_content			= val;		}
	public void setV_mailfrom		(String val){	if(val==null) val="";		v_mailfrom			= val;		}	
	public void setV_mailto			(String val){	if(val==null) val="";		v_mailto			= val;		}

	//Get Method
	public String getTable				(){		return		table;				}
	public String getSequence			(){		return		sequence;			}
	public int    getSeqidx				(){		return		seqidx;             }
	public String getSubject			(){		return		subject;            }
	public String getSql				(){		return		sql;                }
	public int    getReject_slist_idx	(){		return		reject_slist_idx;   }
	public int    getBlock_group_idx	(){		return		block_group_idx;    }	
	public String getMailfrom			(){		return		mailfrom;           }	
	public String getMailto				(){		return		mailto;             }
	public String getReplyto			(){		return		replyto;            }
	public String getErrosto			(){		return		errosto;            }
	public int    getHtml				(){		return		html;               }
	public int    getEncoding			(){		return		encoding;           }
	public String getCharset			(){		return		charset;            }
	public String getSdate				(){		return		sdate;              }
	public String getTdate				(){		return		tdate;              }
	public int    getDuration_set		(){		return		duration_set;       }
	public int    getClick_set			(){		return		click_set;          }
	public int    getSite_set			(){		return		site_set;           }
	public int    getAtc_set			(){		return		atc_set;            }
	public String getGubun				(){		return		gubun;              }
	public String getRname				(){		return		rname;              }
	public int    getMtype       		(){		return		mtype;              }
	public int    getU_idx       		(){		return		u_idx;              }
	public int    getG_idx				(){		return		g_idx;              }
	public int    getMsgflag     		(){		return		msgflag;            }
	public String getContent			(){		return		content;            }
	public String getIndex				(){		return		index;              }
	public String getSeq				(){		return		seq;                }	
	public String getGubun2				(){		return		gubun2;             }
	public String getV_content			(){		return		v_content;          }
	public String getV_mailfrom			(){		return		v_mailfrom;         }	
	public String getV_mailto			(){		return		v_mailto;           }

}

