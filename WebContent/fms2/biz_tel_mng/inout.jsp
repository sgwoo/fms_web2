<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*, acar.biz_tel_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	
	LoginBean login = LoginBean.getInstance();
	BiztelDatabase biz_db = BiztelDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String acar_id = login.getCookieValue(request, "acar_id");
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_br_id = request.getParameter("s_br_id")==null?"":request.getParameter("s_br_id");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	String m_io = request.getParameter("m_io")==null?"":request.getParameter("m_io");

	Vector vt = biz_db.inout_list();
	int vt_size = vt.size();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--

function reg(){
	var fm = document.form1;
	if(!confirm("상담 메세지 메신져로 받기를 등록 하시겠습니까?"))
	{
		return;
	}
	fm.cmd.value = "i";
	fm.target="i_no";
	fm.action="inout_a.jsp";		
	fm.submit();
}

function cancel(del_id){
	var fm = document.form1;
	
	if(!confirm("상담 메세지 메신져로 받기를 해제 하시겠습니까?"))
	{
		return;
	}
	
	fm.cmd.value = "d";
	fm.del_id.value =del_id;
	fm.target="i_no";
	fm.action="inout_a.jsp";		
	fm.submit();
}

//-->
</script>
</head>

<body>
<form name='form1' action='' method='post'>
<input type="hidden" name="user_id" value="<%=user_id%>"> 
<input type="hidden" name="cmd" value="">
<input type="hidden" name="del_id" value="">
<table border=0 cellspacing=0 cellpadding=0  width=100%>
	<tr> 
        <td colspan=5>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업관리 > 견적관리 > <span class=style5> 상담메세지받기 신청/해제</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
	<tr>
		<td align="">※ 스마트 견적 및 고객상담요청이 등록될때 메신져로 내용 받기를 원하시면 <a href="javascript:reg()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>버튼을 눌러 등록해 주세요.<br>
					 ※ 만약, 메세지를 받기 않기를 원하시면 해제 버튼을 눌러 주시기 바랍니다.
		</td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=100%>
            	<tr>
            		<td width=3% class=title>연번</td>
            		<td width=6% class=title>지점</td>
            		<td width=6% class=title>부서</td>
            		<td width=6% class=title>직책</td>
            		<td width=6% class=title>이름</td>
            		<td width=6% class=title>해제</td>
            	</tr>
<% if(vt_size > 0)	{
	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
%> 
            	<tr>
            		<td align="center"><%= i+1%></td>
            		<td align=center><%=ht.get("BR_NM")%></td>
            		<td align=center><%=ht.get("DEPT_NM")%></td>
            		<td align=center><%=ht.get("USER_POS")%></td>
            		<td align=center><%=ht.get("USER_NM")%></td>
            		<td align=center>
<%if(acar_id.equals(ht.get("USER_ID")) || nm_db.getWorkAuthUser("전산팀",acar_id) || nm_db.getWorkAuthUser("임원",acar_id)){%>					
					<a href="javascript:cancel('<%=ht.get("USER_ID")%>')"><img src=/acar/images/center/button_in_hej.gif align="absmiddle" border="0"></a>
<%}else{%>
					<img src=/acar/images/center/button_in_hej.gif align="absmiddle" border="0">
<%}%>
					</td>
            	</tr>
<%}%>
<%}else{ %>
				<tr>
					<td colspan=6 align=center height=25>등록된 데이타가 없습니다.</td>
				</tr>
<%}%>  
            </table>
        </td>
    </tr>
</table>
</from>
</body>
</html>