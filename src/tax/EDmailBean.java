//메일 첨부파일 삽입용으로 만듬.
package tax;

import java.util.*;

public class EDmailBean {

	//Table : 이벤트 메일
	private String table;      
	private String sequence;      
	private int    idx;
	private int    seqidx;
	private String fileinfo;      
	private String content;      


	// CONSTRCTOR            
	public EDmailBean() {  
		table				= "";
		sequence			= "";
		idx					= 0;
		seqidx				= 0;
		fileinfo			= "";
		content				= "";     

	}

	//Set Method
	public void setTable			(String val){	if(val==null) val="";		table				= val;		}
	public void setSequence			(String val){	if(val==null) val="";		sequence			= val;		}
	public void setIdx				(int    val){								idx					= val;		}
	public void setSeqidx			(int    val){								seqidx				= val;		}
	public void setFileinfo			(String val){	if(val==null) val="";		fileinfo			= val;		}
	public void setContent			(String val){	if(val==null) val="";		content				= val;		}

	//Get Method
	public String getTable				(){		return		table;				}
	public String getSequence			(){		return		sequence;			}
	public int    getIdx				(){		return		idx;	            }
	public int    getSeqidx				(){		return		seqidx;             }
	public String getFileinfo			(){		return		fileinfo;           }
	public String getContent			(){		return		content;            }

}
