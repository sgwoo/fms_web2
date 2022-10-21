<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.attend.*" %>
<jsp:useBean id="bean" class="acar.attend.AttendBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	AttendDatabase ad = AttendDatabase.getInstance();
		
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String start_year = request.getParameter("start_year")==null?"":request.getParameter("start_year");
	String start_mon = request.getParameter("start_mon")==null?"":request.getParameter("start_mon");
	String start_day = request.getParameter("start_day")==null?"":request.getParameter("start_day");
	
    bean  = ad.getAttendUserDay(user_id, start_year,start_mon, start_day );

%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language='javascript'>
<!--
function AttendReg()
{
	var theForm = document.ScheDispForm;
	
	if(!confirm('사유를 등록하시겠습니까?'))
	{
		return;
	}
	theForm.target = "i_no";
	theForm.submit();
}
//-->
</script>
</HEAD>
<BODY>
<table border="0" cellspacing="0" cellpadding="0" width=680>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 근태관리 > 출근관리 > <span class=style5>스케줄</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<form action="sch_reason_null_ui.jsp" name='ScheDispForm' method='post'>
		<input type="hidden" name="user_id" value="<%=user_id%>">
		<input type="hidden" name="start_year" value="<%=start_year%>">
		<input type="hidden" name="start_mon" value="<%=start_mon%>">
		<input type="hidden" name="start_day" value="<%=start_day%>">
	<tr>
		<td align='right' width=680>
		<a href="javascript:AttendReg()"><img src=../images/center/button_reg.gif border=0 align=absmiddle></a>
		<a href="javascript:self.close();"><img src=../images/center/button_close.gif border=0 align=absmiddle></a> 
		</td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=680>
                <tr> 
                    <td width=100 class='title'>이름</td>
                    <td width=200 align=left>&nbsp;<%=c_db.getNameById(user_id, "USER")%></td>
                    <td width=100 class='title'>일자</td>
                    <td width=280 align=left>&nbsp;<%=start_year%>년&nbsp;<%=start_mon%>월&nbsp;<%=start_day%>일</td>
                </tr>
                <tr> 
                    <td class='title'>사유</td>
                    <td colspan="3">&nbsp;<input type='text' name='remark' value='<%=bean.getRemark()%>' size='80' MAXLENGTH='100' class=text>
                    </td>
                </tr>
            
            </table>
			
		</td>
	</tr>
	
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe>
</BODY>
</HTML>
