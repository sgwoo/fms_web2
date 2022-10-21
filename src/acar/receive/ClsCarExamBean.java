package acar.receive;

public class ClsCarExamBean
{

	private String rent_mng_id;	// 계약관리번호
	private String rent_l_cd;	// 계약번호    
	private int s_seq; 
	private String exam_dt; 
	private String exam_id; 
	private String s_gu1; 
	private String s_gu2; 
	private String s_gu3; 
	private String s_gu4; 
	private String s_remark; 
	private String s_result; 
		
	public ClsCarExamBean()
	{
		rent_mng_id = "";
		rent_l_cd   = ""; 		
		s_seq	= 0;	
		exam_dt	= "";
		exam_id		= "";
		s_gu1	= "";
		s_gu2 = "";
		s_gu3 = "";
		s_gu4 = "";
		s_remark = "";
		s_result = "";
	
	}
	
	
	public void setRent_mng_id(String str)	{ rent_mng_id	= str; } 
	public void setRent_l_cd(String str)		{ rent_l_cd		= str; } 
	public void setS_seq(int i)			{ s_seq		= i;   } 
	public void setExam_dt(String str)		{ exam_dt		= str; } 
	public void setExam_id(String str)		{ exam_id	= str; } 
	public void setS_gu1(String str)		{ s_gu1		= str; } 
	public void setS_gu2(String str)		{ s_gu2	= str; }
	public void setS_gu3(String str)		{ s_gu3		= str; } 
	public void setS_gu4(String str)		{ s_gu4	= str; }
	public void setS_remark(String str)		{ s_remark	= str; }
	public void setS_result(String str)		{ s_result = str; }	
		
	public String getRent_mng_id()	{ return rent_mng_id;	} 
	public String getRent_l_cd()		{ return rent_l_cd;		} 
	public int       getS_seq()			{ return s_seq;		} 	
	public String getExam_dt()		{ return exam_dt;		} 
	public String getExam_id()		{ return exam_id;	} 
	public String getS_gu1()			{ return s_gu1;		}  
	public String getS_gu2()			{ return s_gu2; }  
	public String getS_gu3()			{ return s_gu3; }  
	public String getS_gu4()			{ return s_gu4; }  
	public String getS_remark()		{ return s_remark; }  
	public String getS_result()		{ return s_result; }  

}