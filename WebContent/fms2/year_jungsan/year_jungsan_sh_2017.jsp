<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String dt	= request.getParameter("dt")==null?"":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	
	String gubun1	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
		
	int cnt = 2; //현황 출력 총수
	int sh_height = cnt*sh_line_height;
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50-15;//현황 라인수만큼 제한 아이프레임 사이즈

%>

<html>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript" src="/include/common.js"></script>
<script language='javascript'>
<!--
function enter() 
{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
}
	

function Search(){
		var fm = document.form1;
	
		fm.action="year_jungsan_sc.jsp";
			
		fm.target="c_foot";		
		fm.submit();
}
//-->
</script>
</head>
<body>
<form name='form1'  method='post' >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">     
<input type='hidden' name="dt" value="<%=dt%>">     
<input type='hidden' name="ref_dt1" value="<%=ref_dt1%>">     
<input type='hidden' name="ref_dt2" value="<%=ref_dt2%>">     
  
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 연말정산관리 > <span class=style5>세액공제신고서접수</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>            
		</td>
	</tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=1>
                <tr> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    	<!--성명-->
                    	<img src=/acar/images/center/arrow_sm.gif align=absmiddle>&nbsp;
                    	<input type="text" name="gubun1" class="text" value='<%=gubun1%>' style='IME-MODE: active'>
            		&nbsp;&nbsp;
            		&nbsp;&nbsp;
            		&nbsp;&nbsp;
            		&nbsp;&nbsp;
                    	<!--정렬-->
                    	<img src=/acar/images/center/arrow_jr.gif align=absmiddle>&nbsp;
                    	<select name='gubun2'>
                    	  <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>등록일자</option>
		    	  <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>성명</option>
            		</select>
            		&nbsp;&nbsp;
            		&nbsp;&nbsp;            		
            		<a href="javascript:Search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
		    </td>
                </tr>
            </table>
        </td>
    </tr>	
</table>
</form>
</body>
</html>
