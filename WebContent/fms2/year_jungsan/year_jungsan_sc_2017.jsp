<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
		
	String dt	= request.getParameter("dt")==null?"":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String gubun1	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String minus	= request.getParameter("minus")==null?"":request.getParameter("minus");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 1; //sc 출력라인수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-200;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?minus="+minus+"&auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&gubun1="+gubun1+"&gubun2="+gubun2+"&dt="+dt+"&ref_dt1="+ref_dt1+"&ref_dt2="+ref_dt2+
				   	"&sh_height="+height+"";
%>
<html>
<head><title>FMS</title>

<script language='javascript'>
<!--
	function jungsan_reg()	{
		var SUBWIN="./year_scan_i.jsp<%=valus%>&s_year=<%=dt%>";	
		window.open(SUBWIN, "save", "left=100, top=50, width=700, height=400, scrollbars=yes");
	}		
//-->
</script>

<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<body leftmargin="15">
<form name='form1' method='post'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'> 
<input type='hidden' name='gubun2' value='<%=gubun2%>'> 
<input type='hidden' name='dt' value='<%=dt%>'> 
<input type='hidden' name='ref_dt1' value='<%=ref_dt1%>'> 
<input type='hidden' name='ref_dt2' value='<%=ref_dt2%>'> 
<input type='hidden' name='s_user_id' value=''> 
<input type='hidden' name='minus' value='<%=minus%>'> 
<input type='hidden' name='scanfile_nm' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
     <% 	if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <td align='right'>
		<!-- <a href='javascript:jungsan_reg()'><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;&nbsp;&nbsp; -->
        </td>
	<%}%>	
    </tr>
    <tr>
		<td>
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr>
                    <td>
                        <iframe src="year_jungsan_sc_in_2017.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe>
					</td>
				</tr>
			</table>
		</td>
    </tr>
</table>

</form>
</body>
</html>
