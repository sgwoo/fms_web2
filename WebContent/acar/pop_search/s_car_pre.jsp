<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.beans.*, acar.ma.*, acar.cc.*"%>
<jsp:useBean id="c_db" scope="page" class="acar.ma.CodeDatabase"/>
<jsp:useBean id="CaNoDb" class="acar.ca.CaNoDatabase" scope="page" />
<%@ include file="/acar/cookies_base.jsp" %>
<% 
	Vector vt = CaNoDb.getCaNoList(s_kd, t_wd);
	
	if(vt.size()==1){	
		Hashtable car = (Hashtable)vt.elementAt(0);
%>
		<jsp:forward page="/acar/pop_search/s_carno.jsp" />
		<jsp:param name="m_st" value="<%= m_st %>" />
		<jsp:param name="m_st2" value="<%= m_st2 %>" />
		<jsp:param name="m_cd" value="<%= m_cd %>" />
		<jsp:param name="rent_mng_id" value="<%= rent_mng_id %>" />
		<jsp:param name="rent_l_cd" value="<%= rent_l_cd %>" />

<html>
<head><title>자동차 조회</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function sel_car(rent_mng_id, rent_l_cd){
	<%if(go_url.equals("")){%>
	opener.parent.s_body.location.href = "../<%=m_st%>/<%=m_st+m_st2%>/<%=m_st+m_st2+m_cd%>/<%=m_st+m_st2+m_cd%>_sc.jsp?m_st=<%= m_st %>&m_st2=<%= m_st2 %>&m_cd=<%= m_cd %>&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd;
	<%}else{%>
	opener.parent.s_body.location.href = "<%=go_url%>?m_st=<%= m_st %>&m_st2=<%= m_st2 %>&m_cd=<%= m_cd %>&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd;
	<%}%>
	this.close();
}
function searchCar(){
	fm = document.form1;
	fm.action = "s_car_in.jsp";
	fm.target = "inner";
	fm.submit();
}
//-->
</script>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../include/table.css">
<body leftmargin="15" topmargin="10">
<form name='form1' method='post'>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
      <td align='left'><font color="#666600">- 자동차 조회 -</font></td>
    </tr>
    <tr> 
      <td align='left'><select name="s_kd">
          <option value="1" selected>차량번호</option>
          <option value="2">상호</option>
        </select> <input type='text' class='text' name='t_wd' size='15'> <a href="javascript:searchCar();"><img src="../images/bbs/but_search.gif" width="50" height="18" align="absmiddle" border="0" alt="검색"></a> 
      </td>
    </tr>
    <tr> 
      <td class='line'> <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class='title' width="6%">연번</td>
            <td class='title' width="20%">차량번호</td>
            <td class='title' width="30%">차명</td>
            <td class='title' width="30%">상호</td>
            <td class='title' width="14%">상태</td>
          </tr>
        </table></td>
    </tr>
    <tr>
      <td><iframe src="./s_car_in.jsp?s_kd=<%=s_kd%>&t_wd=<%=t_wd%>" name="inner" width="100%" height="200" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        </iframe></td>
    </tr>
    <tr> 
      <td align='right'> <a href="javascript:window.close()"><img src="../images/bbs/but_close.gif" width="50" height="18" aligh="absmiddle" border="0" alt="목록"></a></td>
    </tr>
  </table>
</form>
</body>
<%

	
%>
</html>
