/**
 * 견적관리 내용
 */
package acar.esti_mng;

import java.util.*;


public class EstiListBean {
    //Table : ESTI_LIST
    private String  est_id;			//견적번호(년도2자리+월2자리+일2자리+'-'+일련번호4자리)
	private String  seq;			//일련번호
	private String  a_a;			//상품코드
	private String  a_b;			//계약기간
    private int		fee_amt;		//월대여료
    private int		pp_amt;			//초기납입금
    private String  ro_13;			//적용잔가율
    private String  gu_yn;			//보증보험가입여부
	//그외 값변환
	private String	good;			//상품명

    // CONSTRCTOR            
    public EstiListBean() {  
    	this.est_id	= "";
    	this.seq	= "";
		this.a_a	= "";
    	this.a_b	= "";
	    this.fee_amt= 0;
	    this.pp_amt	= 0;
	    this.ro_13	= "";
	    this.gu_yn	= "";
		this.good	= "";
	}

	// get Method
	public void setEst_id	(String val)	{	if(val==null) val="";	this.est_id	= val;	}
	public void setSeq		(String val)	{	if(val==null) val="";	this.seq	= val;	}
	public void setA_a		(String val)	{	if(val==null) val="";	this.a_a	= val;	}
	public void setA_b		(String val)	{	if(val==null) val="";	this.a_b	= val;	}
    public void setFee_amt	(int val)		{							this.fee_amt= val;	}
    public void setPp_amt	(int val)		{							this.pp_amt	= val;	}
    public void setRo_13	(String val)	{	if(val==null) val="";	this.ro_13	= val;	}
    public void setGu_yn	(String val)	{	if(val==null) val="";	this.gu_yn	= val;	}
    public void setGood		(String val)	{	if(val==null) val="";	this.good	= val;	}
	
	//Get Method
	public String getEst_id	(){			return est_id;		}
	public String getSeq	(){			return seq;			}
    public String getA_a	(){			return a_a;			}
    public String getA_b	(){			return a_b;			}
	public int	  getFee_amt(){			return fee_amt;		}
    public int	  getPp_amt	(){			return pp_amt;		}
	public String getRo_13	(){			return ro_13;		}
	public String getGu_yn	(){			return gu_yn;		}
	public String getGood	(){			return good;		}

}

