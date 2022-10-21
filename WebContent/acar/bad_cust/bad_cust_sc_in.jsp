<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.bad_cust.*,acar.common.*"%>
<jsp:useBean id="bc_db" class="acar.bad_cust.BadCustDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "06", "02");
	
	Vector custs = bc_db.getBadCustAll(s_kd, t_wd);
	int cust_size = custs.size();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
//-->
</script>
</head>
<body onLoad="javascript:init()">
<table border=0 cellspacing=0 cellpadding=0 width=1640>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='430' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>                     
                    <td width=40 class=title>연번</td>		  
                    <td width=80 class=title>등록일자</td>		  
                    <td width=60 class=title>등록자</td>
                    <td width=150 class=title>성명</td>		  
                    <td width=100 class=title>생년월일</td>		  
				</tr>
			</table>
		</td>
		<td class='line' width='1210'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>                    
                    <td width=150 class=title>주소</td>
                    <td width=110 class=title>운전면허번호</td>
                    <td width=100 class=title>휴대폰번호</td>
                    <td width=150 class=title>이메일주소</td>
                    <td width=100 class=title>FAX</td>
                    <td width=200 class=title>피해업체</td>
                    <td width=400 class=title>피해내용</td>
				</tr>
			</table>
		</td>
	</tr>
  <%if(cust_size > 0){%>
	<tr>
		<td class='line' width='430' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
        		<%
        			for(int i = 0 ; i < cust_size ; i++){
        				Hashtable cust = (Hashtable)custs.elementAt(i);%>
                <tr> 
                    <td width=40 align=center><%=i+1%></td>
                    <td width=80 align=center><%=AddUtil.ChangeDate2(String.valueOf(cust.get("REG_DT")))%></td>
                    <td width=60 align=center><%=c_db.getNameById(String.valueOf(cust.get("REG_ID")), "USER")%></td>
                    <td width=150 align=center><a href="javascript:parent.BadCustUpdate('<%=cust.get("SEQ")%>')"><%=cust.get("BC_NM")%></a></td>
                    <td width=100 align=center><%=AddUtil.ChangeEnpH(String.valueOf(cust.get("BC_ENT_NO")))%></td>
                </tr>
                <%	}%>
			</table>
		</td>
		<td class='line' width='1210'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
        		<%
        			for(int i = 0 ; i < cust_size ; i++){
        				Hashtable cust = (Hashtable)custs.elementAt(i);%>
                <tr> 
                    <td width=150>&nbsp;<span title='<%=cust.get("BC_ADDR")%>'><%=AddUtil.substringbdot(String.valueOf(cust.get("BC_ADDR")), 22)%></span></td>
                    <td width=110 align=center><%=cust.get("BC_LIC_NO")%> </td>
                    <td width=100 align=center><%=cust.get("BC_M_TEL")%></td>
                    <td width=150 align=center><%=cust.get("BC_EMAIL")%> </td>
                    <td width=100 align=center><%=cust.get("BC_FAX")%></td>
                    <td width=200>&nbsp;<span title='<%=cust.get("BC_FIRM_NM")%>'><%=AddUtil.substringbdot(String.valueOf(cust.get("BC_FIRM_NM")), 30)%></span></td>
                    <td width=400>&nbsp;<span title='<%=cust.get("BC_CONT")%>'><%=AddUtil.substringbdot(String.valueOf(cust.get("BC_CONT")), 65)%></span></td>
                </tr>
                <%	}%>
			</table>
		</td>                
	</tr>                                
  <%}else{%>
	<tr>
		<td class='line' width='430' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>검색어를 입력하십시오.
					<%}else{%>등록된 데이타가 없습니다<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='1210'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
  <%}%>
</table>
</body>
</html>
