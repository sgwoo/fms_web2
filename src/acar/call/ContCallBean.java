package acar.call;

public class ContCallBean
{
	private String rent_mng_id;
	private String rent_l_cd;
	private String car_mng_id;
	private String serv_id;
	private String accid_id;
	private int poll_id;
	private String question;
	private String answer;
	private String answer_rem;
	private String p_gubun;
	private String reg_id;
	private int poll_s_id;
	
	
	public ContCallBean()
	{
		rent_mng_id = "";
		rent_l_cd = "";
		car_mng_id = "";
		serv_id = "";
		accid_id = "";
		poll_id = 0;
		question = "";
		answer = "";
		answer_rem = "";
		p_gubun = "";
		reg_id = "";

		poll_s_id = 0;
		
	}
	
	public void setRent_mng_id(String str)	{	rent_mng_id = str;	}
	public void setRent_l_cd(String str)	{	rent_l_cd = str;	}
	public void setCar_mng_id(String str)	{	car_mng_id = str;	}
	public void setServ_id(String str)	{	serv_id = str;	}
	public void setAccid_id(String str)	{	accid_id = str;	}
	public void setPoll_id(int i)		{	poll_id= i;	}
	public void setQuestion(String str)	{	question = str;	}
	public void setAnswer(String str)	{	answer= str;	}
	public void setAnswer_rem(String str)	{	answer_rem= str;	}
	public void setP_gubun(String str)	{	p_gubun= str;	}
	public void setReg_id(String str)	{	reg_id= str;	}

	public void setPoll_s_id(int i)		{	poll_s_id= i;	}

	public String getRent_mng_id()	{	return rent_mng_id;	}
	public String getRent_l_cd()	{	return rent_l_cd;	}
	public String getCar_mng_id()	{	return car_mng_id;	}
	public String getServ_id()	{	return serv_id;	}
	public String getAccid_id()	{	return accid_id;	}
	public int	  getPoll_id()	{	return poll_id;		}
	public String getQuestion()	{	return question;	}
	public String getAnswer()	{	return answer;	}
	public String getAnswer_rem()	{	return answer_rem;	}
	public String getP_gubun()	{	return p_gubun;	}
	public String getReg_id()	{	return reg_id;	}

	public int	  getPoll_s_id()	{	return poll_s_id;		}
	
}