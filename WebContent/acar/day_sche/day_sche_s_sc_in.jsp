<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.day_sche.*"%>
<jsp:useBean id="dsch_db" scope="page" class="acar.day_sche.DScheDatabase"/>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script language="JavaScript">
<!--
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck = fm.elements[i];
			if(ck.name == "pr"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}	
		}
		return;
	}
//-->
</script>
</head>
<%
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_day = request.getParameter("s_day")==null?"":request.getParameter("s_day");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	Vector scds = dsch_db.getDailyScds(s_year, s_mon, s_day);
	int scd_size = scds.size();
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<body>
<form name='form1' action='' method="POST">
<input type='hidden' name='cmd' value=''>
<table border=0 cellspacing=0 cellpadding=0 width='100%'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class='line'>
            <table border=0 cellspacing=1 width='100%'>
				<tr>
					<td width=4% class='title'><input type="checkbox" name="all_pr" value="Y" onclick='javascript:AllSelect()'></td>
					<td width=5% class='title'> 연번 </td>
					<td width=12% class='title'> 등록일자 </td>
					<td width=10% class='title'> 등록자 </td>
					<td width=36% class='title'> 제목 </td>
					<td width=11% class='title'> 내용보기 </td>
					<td width=12% class='title'> 처리일자 </td>
					<td width=10% class='title'> 처리자 </td>
				</tr>
<%
	if(scd_size > 0)
	{
		for(int i = 0 ; i < scd_size ; i++)
		{
			DayScheBean scd = (DayScheBean)scds.elementAt(i);
			String seq = scd.getSeq();
			String year = scd.getYear();
			String mon = scd.getMon();
			String day = scd.getDay();
			
			if(scd.getStatus().equals("1")){
				String pr_dt = scd.getPr_dt();
				String pr_dt_year = pr_dt.substring(0,4);
				String pr_dt_mon = pr_dt.substring(4,6);
				String pr_dt_day = pr_dt.substring(6,8); %>
				<tr>
					<td align='center'> </td>
					<td align='center'><%=(i+1)%></td>
					<td align='center'><%=year%>-<%=mon%>-<%=day%></td>
					<td align='center'><%=c_db.getNameById(scd.getUser_id(), "USER")%></td>
					<td align='center'><%=scd.getTitle()%></td>
					<td align='center'>&nbsp;<a href="javascript:parent.view_content('<%=year%>', '<%=mon%>', '<%=day%>', '<%=seq%>')" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_nybg.gif align=absmiddle border=0></a></td>
					<td align='center'><%=pr_dt_year%>-<%=pr_dt_mon%>-<%=pr_dt_day%></td>
					<td align='center'><%=c_db.getNameById(scd.getPr_id(), "USER")%></td>
				</tr>
			<%}else{%>
				<tr>
					<td align='center'><input type='checkbox' name='pr' value='<%=seq%>'></td>								
					<td align='center'><%=(i+1)%></td>
					<td align='center'><%=year%>-<%=mon%>-<%=day%></td>
					<td align='center'><%=c_db.getNameById(scd.getUser_id(), "USER")%></td>
					<td align='center'><%=scd.getTitle()%></td>
					<td align='center'>&nbsp;<a href="javascript:parent.view_content('<%=year%>', '<%=mon%>', '<%=day%>', '<%=seq%>')" onMouseOver="window.status=''; return true"><img src=../images/center/button_in_nybg.gif align=absmiddle border=0></a></td>
					<td align='center'>미처리</td>
					<td align='center'> </td>
				</tr>
			<%}
		}
	}
	else
	{
%>
				<tr>
					<td colspan='8' align='center'>등록된 데이타가 없습니다</td>
				</tr>
<%
	}%>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>