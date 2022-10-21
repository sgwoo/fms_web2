<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*, acar.insa_card.*" %>
<jsp:useBean id="ic_db" scope="page" class="acar.insa_card.InsaCardDatabase"/>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>


<%@ include file="/acar/cookies.jsp" %>
<%
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String acar_id = login.getCookieValue(request, "acar_id");
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_br_id = request.getParameter("s_br_id")==null?"":request.getParameter("s_br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String sort_gubun 	= request.getParameter("sort_gubun")==null?"4":request.getParameter("sort_gubun");
	String asc 	= request.getParameter("asc")==null?"":request.getParameter("asc");
	
	Vector vt = ic_db.InsaCard(user_id, auth_rw, s_kd, t_wd, sort_gubun, asc);
	int vt_size = vt.size();
	
	double year = 0;
	double month= 0;

	double  y_aver = 0;
	double  m_aver = 0;
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>사용자관리</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--

function UserDisp(user_id,auth_rw)
{
	
	var SUBWIN="insa_card_c.jsp?auth_rw="+auth_rw+"&user_id="+user_id;	
	window.open(SUBWIN, "UserDisp1", "left=100, top=100, width=800, height=1000, scrollbars=auto");
}


	function view_insa(user_id,auth_rw){
		var fm = document.form1;

		fm.target ='d_content';
		fm.action = "insa_card_c.jsp?auth_rw="+auth_rw+"&user_id="+user_id;	
		fm.submit();
	}
	
//-->
</script>
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
</head>

<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>			 
<input type='hidden' name='s_kd'  value='<%=s_kd%>'>
<input type='hidden' name='sort_gubun' value="<%=sort_gubun%>"> 
<input type='hidden' name='asc' value='<%=asc%>'>

<table border=0 cellspacing=0 cellpadding=0  width=100%>

	<tr>
        <td align="right">
        </td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
            	<tr>
            		<td width=5% class=title>연번</td>
            		<td width=10% class=title>지점</td>
            		<td width=8% class=title>부서</td>
            		<td width=8% class=title>직책</td>
            		<td width=8% class=title>성명</td>
					<td width=8% class=title>나이(만)</td>
            		<td width=9% class=title>입사일자</td>
            		<td width=10% class=title>근무개월수</td>
            		<td width=9% class=title>진급일자</td>
            		<td width=13% class=title>휴대폰</td>
            		<td width=10% class=title>E-MAIL</td>
            		<td width=10% class=title>재직증명서</td>
            	
            	</tr>
<% if(vt_size > 0)	{
	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			year = year + AddUtil.parseInt(String.valueOf(ht.get("E_YEAR")));
			month = month + AddUtil.parseInt(String.valueOf(ht.get("E_MONTH")));
%> 
            	<tr>
            		<td align="center"><%= i+1%></td>
            		<td align=center><%=ht.get("BR_NM")%></td>
            		<td align=center><%=ht.get("DEPT_NM")%></td>
            		<td align=center><%=ht.get("USER_POS")%></td>
            		<td align=center>
<%if(acar_id.equals(ht.get("USER_ID")) || nm_db.getWorkAuthUser("전산팀",acar_id) || nm_db.getWorkAuthUser("인사담당",acar_id)){%>
					<a href="javascript:view_insa('<%=ht.get("USER_ID")%>',<%=auth_rw%>)"><%=ht.get("USER_NM")%></a>
<%}else{%>
					<%=ht.get("USER_NM")%>
<%}%>					
            		</td>
					<td align=center>만<%=ht.get("AGE")%>세</td>
            		<td align=center><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%></td>
            		<td align=center><%=ht.get("E_YEAR")%> 년&nbsp;<%=ht.get("E_MONTH")%> 개월</td>
            		<td align=center><%=AddUtil.ChangeDate2(String.valueOf(ht.get("JG_DT")))%> </td>
            		<td align=center><%=ht.get("USER_M_TEL")%></td>
            		<td align=center><%=ht.get("USER_EMAIL")%></td>
            		<td align=center><% if (  String.valueOf(ht.get("USER_ID")).equals(acar_id)  ) {%><a href="javascript:var win=window.open('doc_cert.jsp?user_id=<%=acar_id%>','certificate','left=0, top=0, width=746, height=800, status=no, scrollbars=yes, resizable=no');">
            		<img src=/acar/images/center/button_in_print_st.gif border=0></a><%} %><br>
            		<% if (  String.valueOf(ht.get("USER_ID")).equals(acar_id)  ) {%><a href="javascript:var win=window.open('doc_cert_nos.jsp?user_id=<%=acar_id%>','certificate','left=0, top=0, width=746, height=800, status=no, scrollbars=yes, resizable=no');">
            		<img src=/acar/images/center/button_in_print_nst.gif border=0></a><%} %></td>
            		
            	</tr>
<%}%>
<%

y_aver = year / vt_size;
m_aver = month / vt_size;
y_aver = (y_aver * 100) / 100;       
m_aver = (m_aver * 100) / 100;       
%>
				<tr>
					<td align=center colspan="4" class=title>근무기간 합계</td>
					<td align=center colspan="2" class=title><%=year%> 년&nbsp;<%=month%> 개월</td>
					<td align=center class=title>근무기간 평균</td>
            		<td align=center class=title><fmt:formatNumber value="<%=y_aver%>" pattern=".##"/> 년&nbsp;<fmt:formatNumber value="<%=m_aver%>" pattern=".##"/> 개월</td>
            		<td align=center colspan="4" class=title></td>

				</tr>
<%}else{ %>
            <tr>
                <td colspan=12 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>  
            </table>
        </td>
    </tr>
</table>
</from>
</body>
</html>