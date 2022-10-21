package acar.call;

public class LivePollBean
{
	private int poll_id;
	private String question;
	private String answer1;
	private String answer2;
	private String answer3;	
	private String answer4;
	private String answer5;
	private String answer6;
	private String answer7;	
	private String answer8;
	private String use_yn;
	private String answer1_rem;
	private String answer2_rem;
	private String answer3_rem;	
	private String answer4_rem;
	private String answer5_rem;
	private String answer6_rem;
	private String answer7_rem;	
	private String answer8_rem;
	private String poll_st;
	private int poll_seq;
	private String poll_type;
	private String answer9;
	private String answer9_rem;	
	private String answer10;
	private String answer10_rem;	

	private String poll_title;
	private String count_num;
	private String start_dt;
	private String end_dt;
	private String reg_id;
	private String reg_dt;

	private int poll_s_id;
		
	public LivePollBean()
	{
		poll_id = 0;
		question = "";
		answer1 = "";
		answer2 = "";
		answer3 = "";
		answer4 = "";
		answer5 = "";
		answer6 = "";
		answer7 = "";
		answer8 = "";
		answer1_rem = "";
		answer2_rem = "";
		answer3_rem = "";
		answer4_rem = "";
		answer5_rem = "";
		answer6_rem = "";
		answer7_rem = "";
		answer8_rem = "";
		use_yn = "";
		poll_st = "";
		poll_seq = 0;
		poll_type = "";
		answer9 = "";
		answer9_rem = "";
		answer10 = "";
		answer10_rem = "";

		poll_title = "";
		count_num = "";
		start_dt = "";
		end_dt = "";
		reg_id = "";
		reg_dt = "";

		poll_s_id = 0;
	
	}
	
	public void setPoll_id(int i)		{	poll_id= i;	}
	public void setQuestion(String str)	{	question = str;	}
	public void setAnswer1(String str)	{	answer1= str;	}
	public void setAnswer2(String str)	{	answer2= str;	}
	public void setAnswer3(String str)	{	answer3= str;	}
	public void setAnswer4(String str)	{	answer4= str;	}
	public void setAnswer5(String str)	{	answer5= str;	}
	public void setAnswer6(String str)	{	answer6= str;	}
	public void setAnswer7(String str)	{	answer7= str;	}
	public void setAnswer8(String str)	{	answer8= str;	}
	public void setUse_yn(String str)	{	use_yn= str;	}
	public void setAnswer1_rem(String str)	{	answer1_rem= str;	}
	public void setAnswer2_rem(String str)	{	answer2_rem= str;	}
	public void setAnswer3_rem(String str)	{	answer3_rem= str;	}
	public void setAnswer4_rem(String str)	{	answer4_rem= str;	}
	public void setAnswer5_rem(String str)	{	answer5_rem= str;	}
	public void setAnswer6_rem(String str)	{	answer6_rem= str;	}
	public void setAnswer7_rem(String str)	{	answer7_rem= str;	}
	public void setAnswer8_rem(String str)	{	answer8_rem= str;	}
	public void setPoll_st(String str)	{	poll_st= str;	}
	public void setPoll_seq(int i)		{	poll_seq= i;	}
	public void setPoll_type(String str)	{	poll_type= str;	}
	public void setAnswer9(String str)	{	answer9= str;	}
	public void setAnswer9_rem(String str)	{	answer9_rem= str;	}
	public void setAnswer10(String str)	{	answer10= str;	}
	public void setAnswer10_rem(String str)	{	answer10_rem= str;	}

	public void setPoll_title(String str)	{	poll_title= str;	}
	public void setCount_num(String str)	{	count_num= str;	}
	public void setStart_dt(String str)	{	start_dt= str;	}
	public void setEnd_dt(String str)	{	end_dt= str;	}

	public void setReg_id(String str)	{	reg_id= str;	}
	public void setReg_dt(String str)	{	reg_dt= str;	}

	public void setPoll_s_id(int i)		{	poll_s_id= i;	}

		
	public int	  getPoll_id()	{	return poll_id;		}
	public String getQuestion()	{	return question;	}
	public String getAnswer1()	{	return answer1;	}
	public String getAnswer2()	{	return answer2;	}
	public String getAnswer3()	{	return answer3;	}
	public String getAnswer4()	{	return answer4;	}
	public String getAnswer5()	{	return answer5;	}
	public String getAnswer6()	{	return answer6;	}
	public String getAnswer7()	{	return answer7;	}
	public String getAnswer8()	{	return answer8;	}
	public String getAnswer1_rem()	{	return answer1_rem;	}
	public String getAnswer2_rem()	{	return answer2_rem;	}
	public String getAnswer3_rem()	{	return answer3_rem;	}
	public String getAnswer4_rem()	{	return answer4_rem;	}
	public String getAnswer5_rem()	{	return answer5_rem;	}
	public String getAnswer6_rem()	{	return answer6_rem;	}
	public String getAnswer7_rem()	{	return answer7_rem;	}
	public String getAnswer8_rem()	{	return answer8_rem;	}
	public String getUse_yn()	{	return use_yn;	}
	public String getPoll_st()	{	return poll_st;	}
	public int	  getPoll_seq()	{	return poll_seq;		}
	public String getPoll_type()	{	return poll_type;	}
	public String getAnswer9()	{	return answer9;	}
	public String getAnswer9_rem()	{	return answer9_rem;	}
	public String getAnswer10()	{	return answer10;	}
	public String getAnswer10_rem()	{	return answer10_rem;	}

	public String getPoll_title()	{	return poll_title;	}
	public String getCount_num()	{	return count_num;	}
	public String getStart_dt()	{	return start_dt;	}
	public String getEnd_dt()	{	return end_dt;	}

	public String getReg_id()	{	return reg_id;	}
	public String getReg_dt()	{	return reg_dt;	}

	public int	  getPoll_s_id()	{	return poll_s_id;		}
	
}