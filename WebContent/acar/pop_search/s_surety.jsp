<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies_base.jsp" %>

<%
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gu_nm = request.getParameter("gu_nm")==null?"":request.getParameter("gu_nm");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String chk = request.getParameter("chk")==null?"2":request.getParameter("chk");
%>

<html>
<head><title>장기대여 계약(연대보증) 조회</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') SearchCarOffP();
	}
	function SearchCarOffP(){
		var fm = document.form1;
		fm.action = "s_surety_in.jsp";
		fm.target = "inner";
		fm.submit();
	}

	//영업소-사원명 셋팅
	function set_lc(rent_mng_id, rent_l_cd){
	<%if(mode.equals("reg")){%>
//		opener.document.form1.rent_mng_id.value = rent_mng_id;
//		opener.document.form1.rent_l_cd.value = rent_l_cd;
	<%}else{%>
		<%if(go_url.equals("")){%>
		opener.parent.s_body.location.href = "../<%=m_st%>/<%=m_st+m_st2%>/<%=m_st+m_st2+m_cd%>/<%=m_st+m_st2+m_cd%>_sc.jsp?m_st=<%= m_st %>&m_st2=<%= m_st2 %>&m_cd=<%= m_cd %>&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd;
		<%}else{%>
		opener.parent.s_body.location.href = "<%=go_url%>?m_st=<%= m_st %>&m_st2=<%= m_st2 %>&m_cd=<%= m_cd %>&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd;
		<%}%>	
	<%}%>
	this.close();
	}
//-->
</script>
</head>
<link rel=stylesheet type="text/css" href="../include/table.css">
<body leftmargin="15" topmargin="10" onLoad="javascript:document.form1.gu_nm.focus();">
<form name='form1' action='./s_surety_in.jsp' method='post'>
 <input type='hidden' name='mode' value='<%=mode%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=680>
    <tr> 
      <td align='left'><font color="#666600">- 장기대여 계약(연대보증) 조회 -</font></td>
    </tr>
    <tr> 
      <td align='left'> <select name="gubun">
          <option value='1' <%if(gubun.equals("1")){%> selected <%}%>> 계약번호 </option>
          <option value='2' <%if(gubun.equals("2") || gubun.equals("")){%> selected <%}%>> 차량번호 </option>
          <option value='3' <%if(gubun.equals("3")){%> selected <%}%>> 고객명 </option>		  
        </select> <input type="text" class="text" name="gu_nm" size="15" value="<%= gu_nm %>"  onKeyDown='javascript:enter()' style='IME-MODE: active'>
        <input type="radio" name="chk" value="0" <%if(chk.equals("0")){%> checked <%}%>>
        전체
        <input type="radio" name="chk" value="1" <%if(chk.equals("1")){%> checked <%}%>>
        등록 
        <input type="radio" name="chk" value="2" <%if(chk.equals("2")){%> checked <%}%>>
        미등록&nbsp;&nbsp;<a href="javascript:SearchCarOffP()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="../images/bbs/but_search.gif" width="50" height="18" aligh="absmiddle" border="0" alt="검색"></a> 
      </td>
    </tr>
    <tr> 
      <td class='line'> 
	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class='title' width="4%">연번</td>
            <td class='title' width="20%">계약번호</td>
            <td class='title' width="20%">차량번호</td>
            <td class='title' width="20%">차명</td>
            <td class='title' width="20%">상호</td>
            <td class='title' width="8%">가입여부</td>
            <td class='title' width="8%">등록여부</td>
          </tr>
        </table>
	  </td>
    </tr>
  </table>
  <table border="0" cellspacing="0" cellpadding="0" width=700>
    <tr> 
      <td><iframe src="./s_surety_in.jsp?gubun=<%=gubun%>&gu_nm=<%=gu_nm%>&chk=<%=chk%>&mode=<%=mode%>" name="inner" width="700" height="300" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
    </tr>	
    <tr> 
      <td></td>
    </tr>
    <tr> 
      <td align='right'>
	  <a href="javascript:window.close()"><img src="../images/bbs/but_close.gif" width="50" height="18" aligh="absmiddle" border="0" alt=""></a>
	  </td>
    </tr>
  </table>  
</form>
</body>
</html>