<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies_base.jsp" %>

<%
	String type = request.getParameter("type")==null?"":request.getParameter("type");
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
		fm.action='./s_clientsite.jsp';
		fm.submit();
	}	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	

	function select(client_id, site_id){		
		var fm = document.form1;
		<%if(go_url.equals("")){%>
		opener.parent.s_body.location.href = "../<%=m_st%>/<%=m_st+m_st2%>/<%=m_st+m_st2+m_cd%>/<%=m_st+m_st2+m_cd%>_sc.jsp?m_st=<%= m_st %>&m_st2=<%= m_st2 %>&m_cd=<%= m_cd %>&client_id="+client_id+"&site_id="+site_id;
		<%}else{%>
		opener.parent.s_body.location.href = "<%=go_url%>?m_st=<%= m_st %>&m_st2=<%= m_st2 %>&m_cd=<%= m_cd %>&client_id="+client_id+"&site_id="+site_id;
		<%}%>
		this.close();
	}
//-->
</script>
</head>

<body leftmargin="15" topmargin="10" onLoad="javascript:document.form1.t_wd.focus();">
<form name='form1' action='' method='post'>
 <input type='hidden' name='m_st' value='<%=m_st%>'>
 <input type='hidden' name='m_st2' value='<%=m_st2%>'>  
 <input type='hidden' name='m_cd' value='<%=m_cd%>'>   
 <input type='hidden' name='type' value='<%=type%>'>
 <input type='hidden' name='go_url' value='<%=go_url%>'>  
  <table border="0" cellspacing="0" cellpadding="0" width=600>
    <tr> 
      <td align='left' colspan="2"><font color="#666600">- 고객 조회 -</font></td>
    </tr>
    <tr> 
      <td align='left'>
	    <jsp:include page="/acar/code/get_code.jsp" flush="true">
	  	  <jsp:param name="f_nm" value="s_kd" />
	  	  <jsp:param name="nm_cd" value="cl_s_kd" />
	  	  <jsp:param name="app_st" value="Y" />
  		  <jsp:param name="value" value="<%=s_kd%>" />
	  	  <jsp:param name="onChange" value="" />
	    </jsp:include>
		<input type='text' name='t_wd' size='15' class='text' value='<%=t_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'> 
        <a href='javascript:search()' onMouseOver="window.status=''; return true"><img src="../images/bbs/but_search.gif" width="50" height="18" align="bottom" border="0" alt="검색"></a> 
      </td>
      <td align='right'>&nbsp;
	  </td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class='title' width="30">연번</td>
            <td class='title' width="110">구분</td>
            <td class='title' width="190">상호</td>
            <td class='title' width="70">대표자</td>
            <td class='title' width="100">사업자번호</td>
            <td class='title' width="100">연락처</td>
          </tr>
        </table></td>
    </tr>
  </table>
  <table width="620" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td><iframe src="./s_clientsite_in.jsp?type=<%=type%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>" name="inner" width="620" height="270" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
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
