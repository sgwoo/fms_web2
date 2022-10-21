<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies_base.jsp" %>

<%
	String s_con = request.getParameter("s_con")==null?"":request.getParameter("s_con");
	String type = request.getParameter("type")==null?"":request.getParameter("type");

//System.out.println("m_st="+m_st+", m_st2="+m_st2+", m_cd="+m_cd);	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>고객조회</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../include/table.css">
<script language='javascript'>
<!--
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
	
	function search(){
		var fm = document.form1;
		fm.action='./s_client.jsp?m_st=<%= m_st %>&m_st2=<%= m_st2 %>&m_cd=<%= m_cd %>';
		fm.submit();
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	

	function select(client_id){		
		var fm = document.form1;
		if(fm.type.value == 'search'){
			<%if(go_url.equals("")){%>
			opener.parent.s_body.location.href = "../<%=m_st%>/<%=m_st+m_st2%>/<%=m_st+m_st2+m_cd%>/<%=m_st+m_st2+m_cd%>_sc.jsp?m_st=<%= m_st %>&m_st2=<%= m_st2 %>&m_cd=<%= m_cd %>&client_id="+client_id;
			<%}else{%>
			opener.parent.s_body.location.href = "<%=go_url%>?m_st=<%= m_st %>&m_st2=<%= m_st2 %>&m_cd=<%= m_cd %>&client_id="+client_id;
			<%}%>
			this.close();
		}else{
			<% if((m_st+m_st2+m_cd).equals("020101")){ %>
				fm.action='./s_client_set.jsp?page_gubun=RES&client_id='+client_id;	//h_page_gubun=RES:기존고객 세팅
			<% }else{ %>		
				fm.action='./s_client_set.jsp?page_gubun=EXT&client_id='+client_id;	//h_page_gubun=EXT:기존고객 세팅
			<% } %>		

			//fm.target='i_no';
			fm.submit();
		}
	}
//-->
</script>
</head>

<body leftmargin="15" topmargin="10" onLoad="javascript:document.form1.t_wd.focus();">
<form name='form1' action='' method='post'>
 <input type='hidden' name='type' value='<%=type%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=600>
    <tr> 
      <td align='left' colspan="2"><font color="#666600">- 고객 조회 -</font></td>
    </tr>
    <tr> 
      <td align='left'>
	    <select name='s_con'>
          <option value='1' <%if(s_con.equals("1")){%> selected <%}%>> 상호 </option>
          <option value='2' <%if(s_con.equals("2")){%> selected <%}%>> 고객명 </option>
        </select>
		<input type='text' name='t_wd' size='15' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'> 
        <a href='javascript:search()' onMouseOver="window.status=''; return true"><img src="../images/bbs/but_search.gif" width="50" height="18" align="bottom" border="0" alt="검색"></a> 
      </td>
      <td align='right'>
	  <%if(type.equals("")){%>
	    <a href='./s_client_i.jsp' onMouseOver="window.status=''; return true"><img src="../images/bbs/but_in.gif" width="50" height="18" align="bottom" border="0" alt="등록"></a>
 	  <%}%>
	  </td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class='title' width="30">연번</td>
            <td class='title' width="70">구분</td>
            <td class='title' width="180">상호</td>
            <td class='title' width="120">대표자</td>
            <td class='title' width="100">사업자등록번호</td>
            <td class='title' width="100">연락처</td>
          </tr>
        </table></td>
    </tr>
  </table>
  <table width="620" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td><iframe src="./s_client_in.jsp?type=<%=type%>&s_con=<%=s_con%>&t_wd=<%=t_wd%>" name="inner" width="620" height="270" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
    </tr>
    <tr>
      <td><table width="600" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr> 
            <td><div align="right"> 
                <a href="javascript:window.close()"><img src="../images/bbs/but_close.gif" width="50" height="18" aligh="absmiddle" border="0" alt="닫기"></a></div></td>
          </tr>
        </table></td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
