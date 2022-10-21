package acar.common;

/***
 *	계좌정보
 */
public class BankAccBean 
{
	
	public String off_st 		= "";
	public String off_id 		= "";
	public int    seq 			= 0;
	public String bank_id 		= "";
	public String acc_st 		= "";
	public String acc_no 		= "";
	public String acc_nm 		= "";
	public String use_yn 		= "";
	public String etc 			= "";
	public String reg_id 		= "";
	public String reg_dt 		= "";
	public String update_id		= "";
	public String update_dt		= "";
	public String acc_ssn 		= "";
	public String acc_zip		= "";
	public String acc_addr		= "";
	public String file_name1	= "";				//스캔파일-신분증
	public String file_name2	= "";				//스캔파일-통장
	public String file_gubun1	= "";				//스캔파일-신분증
	public String file_gubun2	= "";				//스캔파일-통장
	public String conf_st 		= "";

  
	public void setOff_st		(String str)	{	off_st		= str;	}
	public void setOff_id		(String str)	{	off_id		= str;	}
	public void setSeq			(int    str)	{	seq			= str;	}
	public void setBank_id		(String str)	{	bank_id		= str;	}
	public void setAcc_st		(String str)	{	acc_st		= str;	}
	public void setAcc_no		(String str)	{	acc_no		= str;	}
	public void setAcc_nm		(String str)	{	acc_nm		= str;	}
	public void setUse_yn		(String str)	{	use_yn		= str;	}
	public void setEtc			(String str)	{	etc			= str;	}
	public void setReg_id		(String str)	{	reg_id		= str;	}
	public void setReg_dt		(String str)	{	reg_dt		= str;	}
	public void setUpdate_id	(String str)	{	update_id	= str;	}
	public void setUpdate_dt	(String str)	{	update_dt	= str;	}
	public void setAcc_ssn		(String str)	{	acc_ssn		= str;	}
	public void setAcc_zip		(String str)	{	acc_zip		= str;	}
	public void setAcc_addr		(String str)	{	acc_addr	= str;	}
	public void setFile_name1	(String val)	{	if(val==null) val="";		this.file_name1		= val;	}
	public void setFile_name2	(String val)	{	if(val==null) val="";		this.file_name2		= val;	}
	public void setFile_gubun1	(String val)	{	if(val==null) val="";		this.file_gubun1	= val;	}
	public void setFile_gubun2	(String val)	{	if(val==null) val="";		this.file_gubun2	= val;	}
	public void setConf_st		(String str)	{	conf_st		= str;	}

	
	public String getOff_st		()				{	return off_st;		}
	public String getOff_id		()				{	return off_id;		}
	public int    getSeq		()				{	return seq;			}
	public String getBank_id	()				{	return bank_id;		}
	public String getAcc_st		()				{	return acc_st;		}
	public String getAcc_no		()				{	return acc_no;		}
	public String getAcc_nm		()				{	return acc_nm;		}
	public String getUse_yn		()				{	return use_yn;		}
	public String getEtc		()				{	return etc;			}
	public String getReg_id		()				{	return reg_id;		}
	public String getReg_dt		()				{	return reg_dt;		}
	public String getUpdate_id	()				{	return update_id;	}
	public String getUpdate_dt	()				{	return update_dt;	}
	public String getAcc_ssn	()				{	return acc_ssn;		}
	public String getAcc_zip	()				{	return acc_zip;		}
	public String getAcc_addr	()				{	return acc_addr;	}
	public String getFile_name1	()				{	return file_name1;	}
	public String getFile_name2	()				{	return file_name2;	}
	public String getFile_gubun1()				{	return file_gubun1;	}
	public String getFile_gubun2()				{	return file_gubun2;	}
	public String getConf_st	()				{	return conf_st;		}
	
}