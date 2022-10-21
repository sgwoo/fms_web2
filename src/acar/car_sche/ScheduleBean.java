package acar.car_sche;

import java.io.*;
import java.sql.*;
import java.util.*;


public class ScheduleBean 
{

	public ScheduleBean() throws SQLException 
	{
    }

	// 부서관리 쪽 부서 분류 가져오기 //
	public String showHtmlDeptCombo(String code)
	{
		String html = "";

		if(code.equals(""))
		{
			html = " <select name='input_tribute'>\n"
				 + "	<option value='nul'>선 택</option>\n"
				 + "	<option value='DD01'>기술직</option>\n"
				 + "	<option value='DD02'>관리직</option>\n"
				 + "	<option value='DD03'>기타직</option>\n"
				 + " </select>";
		}
		else if(code.equals("DD01"))
		{
			html = " <select name='tribute'>\n"
				 + "	<option value='DD01' SELECTED>기술직</option>\n"
				 + "	<option value='DD02'>관리직</option>\n"
				 + "	<option value='DD03'>기타직</option>\n"
				 + " </select>";
		}
		else if(code.equals("DD02"))
		{
			html = " <select name='tribute'>\n"
				 + "	<option value='DD01'>기술직</option>\n"
				 + "	<option value='DD02' SELECTED>관리직</option>\n"
				 + "	<option value='DD03'>기타직</option>\n"
				 + " </select>";
		}
		else
		{
			html = " <select name='tribute'>\n"
				 + "	<option value='DD01'>기술직</option>\n"
				 + "	<option value='DD02'>관리직</option>\n"
				 + "	<option value='DD03' SELECTED>기타직</option>\n"
				 + " </select>";
		}
		return html;
	}

	// 시간선택 - 연 Selet Box //
	public String showHtmlYear()
	{
		String html = "";

		for(int i = 2001 ; i < 2010 ; i++)
		{
			html = html + "<option value="+i+">"+i+"</option>\n";
		}

		return html;
	}

	// 시간선택 - 월 Select Box //
	public String showHtmlMonth()
	{
		String html = "";
		String opt_month = "";

		for(int i = 1 ; i < 13 ; i++)
		{
			if(i < 10)
				opt_month = "0"+Integer.toString(i);
			else
				opt_month = Integer.toString(i);
			
			html = html + "<option value="+opt_month+">"+opt_month+"</option>\n";
		}
		return html;
	}

	// 시간선택 - 월 Select Box //
	public String showHtmlDay()
	{
		String html = "";
		String opt_day = "";

		for(int i = 1 ; i < 32 ; i++)
		{
			if(i < 10)
				opt_day = "0"+Integer.toString(i);
			else
				opt_day = Integer.toString(i);
			
			html = html + "<option value="+opt_day+">"+opt_day+"</option>\n";
		}
		return html;
	}

	public String showHtmlNoon(String noon)
	{
		String html = "";

		html = "<option value='0'>AM</option>\n"
			 + "<option value='1'>PM</option>\n";

		return html;
	}

	// 오전/오후 라디오 버튼
	public String showHtmlNoon(String gubun, String noon)
	{
		String html = "";

		if(noon.equals("0"))
		{
			html = "<input type='radio' name='"+gubun+"' value='0' onClick='javascript:modify_noon(0,\""+gubun.substring(0,1)+"\");' CHECKED>AM.&nbsp; \n"
				 + "<input type='radio' name='"+gubun+"' value='1' onClick='javascript:modify_noon(1,\""+gubun.substring(0,1)+"\");'>PM.&nbsp; ";
		}
		else
		{
			html = "<input type='radio' name='"+gubun+"' value='0' onClick='javascript:modify_noon(0,\""+gubun.substring(0,1)+"\");'>AM.&nbsp; \n"
				 + "<input type='radio' name='"+gubun+"' value='1' onClick='javascript:modify_noon(1,\""+gubun.substring(0,1)+"\");' CHECKED>PM.&nbsp; "; 
		}
		return html;
	}

	// 오전/오후 라디오 버튼
	public String showHtmlNoon(int i)
	{
		String html = "";
		
		if(i == 0)
		{
			html = "<input type='radio' name='noon' value='0' CHECKED>AM.&nbsp;\n"
				 + "<input type='radio' name='noon' value='1'>PM.&nbsp;\n";
		}
		else
		{
			html = "<input type='radio' name='noon' value='0'>AM.&nbsp;\n"
				 + "<input type='radio' name='noon' value='1' CHECKED>PM.&nbsp;\n";
		}
		return html;
	}

	// 시간선택 - 시 Select Box //
	public String showHtmlHour()
	{
		String html = "";
		String value = "";
		String view = "";

		for(int i = 0 ; i < 24 ; i++)
		{
			if(i == 0)
			{
				value = "00";
				view = "AM. 00";
			}
			else if(i < 10)
			{
				value = "0"+Integer.toString(i);
				view = "AM. 0"+Integer.toString(i);
			}
			else if(i < 13)
			{
				value = Integer.toString(i);
				view = "AM. "+Integer.toString(i);
			}
			else if(i < 22)
			{
				value = Integer.toString(i);
				view = "PM. 0"+Integer.toString(i - 12);
			}
			else
			{
				value = Integer.toString(i);
				view = "PM. "+Integer.toString(i - 12);
			}
			html = html + "	<option value="+value+">"+view+"</option>\n";
		}
		return html;
	}

	public String showHtmlHourSub()
	{
		String html = "";
		String value = "";

		html = " <option value=00>12</option>\n";
		
		for(int i = 1 ; i < 12 ; i++)
		{
			if(i < 10)
				value = "0"+Integer.toString(i);
			else
				value = Integer.toString(i);

			html = html + " <option value="+value+">"+value+"</option>\n";
		}
		return html;
	}

	// 시간선택 - 분 Select Box //
	public String showHtmlMinute()
	{
		String html = "";

		html = "	<option value=00>00</option>\n"
			 + "	<option value=10>10</option>\n"
			 + "	<option value=20>20</option>\n"
			 + "	<option value=30>30</option>\n"
			 + "	<option value=40>40</option>\n"
			 + "	<option value=50>50</option>\n";

		return html;
	}

}
