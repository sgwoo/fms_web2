<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String tm_st = request.getParameter("tm_st")==null?"":request.getParameter("tm_st");	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String mng_id = request.getParameter("mng_id")==null?"":request.getParameter("mng_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
%>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save(){
		var fm = document.form1;
		if((fm.reg_dt.value == '') || !isDate(fm.reg_dt.value))	{	alert('등록일을 확인하십시오');	return;	}
		else if(fm.content.value == '')							{	alert('메모내용을 확인하십시오');	return;	}		
		<%if(!tm_st.equals("9")){%>
		else if(fm.speaker.value == '')							{	alert('담당자를 확인하십시오');	return;	}		
		<%}%>
		if(confirm('등록하시겠습니까?')){		
			fm.target='i_no';
			fm.submit();
		}
	}
	
	function pop_close(){
//		parent.opener.location.reload();
		parent.window.close();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
</head>
<body>

<form name='form1' method='post' action='/acar/con_ins_m/ins_memo_i_a.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='tm_st' value='<%=tm_st%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='serv_id' value='<%=serv_id%>'>
<input type='hidden' name='mng_id' value='<%=mng_id%>'>
<input type='hidden' name='reg_id' value='<%=user_id%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	    <td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
		            <td class='title' width=12%> 작성일 </td>
		            <td colspan='3' width=88%>&nbsp;
		            <input type='text' name='reg_dt' value='<%=Util.getDate()%>' size='11' class='text' onBlur='javascript:this.value = ChangeDate(this.value);'></td>
		        </tr>
        		<tr>
        		    <td class='title'> 작성자</td>
        		    <td colspan='3'>&nbsp;
        		    <%=c_db.getNameById(user_id, "USER")%></td>
        		</tr>
        		<%if(tm_st.equals("9")){%>
        		<input type='hidden' name='speaker' value=''>
        		<tr>
        		    <td class='title'> 채권구분</td>
        		    <td colspan='3'>&nbsp;
                      <select name="accid_id">
                        <option value="추심">추심</option>
                        <option value="진행">진행</option>
                        <option value="종료">종료</option>
                      </select>		  
        		    </td>
        		</tr>				
        		<%}else{%>
        		<input type='hidden' name='accid_id' value='<%=accid_id%>'>
        		<tr>
        		    <td class='title'> 담당자</td>
        		    <td colspan='3'>&nbsp;
        		    <input type='text' name='speaker' size='20' class='text' style='IME-MODE: active'></td>
        		</tr>				
        		<%}%>
        		<tr>
        		    <td class='title'> 내용</td>
        		    <td colspan='3'>&nbsp;
                      <textarea name='content' rows='3' cols='88' style='IME-MODE: active'></textarea>
                    </td>
        		</tr>
	        </table>
	    </td>
	    <td width=16>&nbsp;</td>
    </tr>
    <tr>
	    <td align='right' colspan=2> <a href="javascript:save()"><img src=../images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;<a href="javascript:pop_close()"><img src=../images/center/button_close.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize>
</body>
</html>
