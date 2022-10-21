<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.fee.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save()
	{
		if(confirm('등록하시겠습니까?'))
		{
			var fm = document.form1;
			if((fm.t_reg_dt.value == '') || !isDate(fm.t_reg_dt.value))	{	alert('등록일을 확인하십시오');	return;	}
			else if(fm.t_speaker.value == '')							{	alert('담당자를 확인하십시오');	return;	}
			else if(fm.t_content.value == '')							{	alert('메모내용을 확인하십시오');	return;	}
			
			fm.target='i_no';
			fm.submit();
		}
	}
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String r_st = request.getParameter("r_st")==null?"":request.getParameter("r_st");
	String fee_tm = request.getParameter("fee_tm")==null?"":request.getParameter("fee_tm");
	String tm_st1 = request.getParameter("tm_st1")==null?"":request.getParameter("tm_st1");
	String bus_id2 = request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	LoginBean login = LoginBean.getInstance();
	String reg_id = login.getCookieValue(request, "acar_id");
%>
<form name='form1' method='post' action='/fms2/con_fee/fee_memo_i_a.jsp'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='r_st' value='<%=r_st%>'>
<input type='hidden' name='fee_tm' value='<%=fee_tm%>'>
<input type='hidden' name='tm_st1' value='<%=tm_st1%>'>

<table border="0" cellspacing="0" cellpadding="0" width=350>
	<tr>
		<td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=550>
              <%if(tm_st1.equals("7") || tm_st1.equals("8") || tm_st1.equals("9")){%>
                <tr> 
                    <td class='title' width="70"> 작성일 </td>
                    <td>&nbsp; <input type='text' name='t_reg_dt' size='12' class='text' onBlur='javascript:this.value = ChangeDate(this.value);' value = '<%=Util.getDate()%>' ></td>
                </tr>
              <%}else{%>
                <tr> 
                    <td class='title' width="70"> 작성일 </td>
                    <td>&nbsp; <input type='text' name='t_reg_dt' size='12' class='text' onBlur='javascript:this.value = ChangeDate(this.value);' value = '<%=Util.getDate()%>' > 
                  &nbsp; </td>
                </tr>
              <%}%>
                <tr> 
                    <td class='title' width="70"> 작성자</td>
                    <td>&nbsp; <%=c_db.getNameById(reg_id, "USER")%></td>
                </tr>
                <tr> 
                    <td class='title' width="70"> 담당자</td>
                    <td>&nbsp; <input type='text' name='t_speaker' size='20' class='text'></td>
                </tr>
                <tr> 
                    <td class='title' width="70"> 내용</td>
                    <td>&nbsp; <textarea name='t_content' rows='3' cols='70'></textarea> 
                    </td>
                </tr>
            </table>
		</td>
	</tr>
	<tr>
		<td align='right'> <a href="javascript:save()"> 등록 </a> &nbsp; <a href="javascript:parent.close()"> 닫기 </a> </td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>
