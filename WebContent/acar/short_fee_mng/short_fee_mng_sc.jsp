<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	function OpenList(c_st){ 	//차량구분
		var fm = document.form1;	
		var SUBWIN = "/acar/add_mark/s_code_i.jsp";
		window.open(SUBWIN+"?auth_rw="+fm.auth_rw.value+"&user_id="+fm.user_id.value+"&br_id="+fm.br_id.value+"&c_st="+c_st, "OpenList", "left=100, top=100, width=575, height=350, scrollbars=nof");
	}

	function CarLink(){	//차종연결
		var fm = document.form1;		
		var SUBWIN="./car_nm_i.jsp?auth_rw="+fm.auth_rw.value;	
		window.open(SUBWIN, "CarLink", "left=50, top=50, width=510, height=750, scrollbars=yes, status=yes");
	}

	function Update(section, reg_dt){	
		var fm = document.form1;
		fm.section.value = section;
		fm.reg_dt.value = reg_dt;
		fm.target="d_content";
		fm.submit();
	}
//-->
</script>
</head>
<body>

<form action="short_fee_mng_c.jsp" name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="section" value="">
<input type="hidden" name="reg_dt" value="">
</form>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                    <td class='line'> 
                        <table  border=0 cellspacing=1 width="100%">
                            <tr> 
                                <td class=title width='5%'>연번</td>
                                <td class=title width='8%'>차량구분</td>
                                <td class=title width='5%'>코드</td>
                                <td class=title width='15%'>기준차량</td>
                                <td class=title width='59%'>해당차종</td>
                                <td class=title width='8%'>기준일자</td>
                            </tr>
                        </table>
                    </td>
                    
                </tr>
            </table>
        </td>
        <td width=17>&nbsp;</td>
    </tr>
    <tr> 
        <td colspan=2> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                    <td><iframe src="./short_fee_mng_sc_in.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>" name="inner" width="100%" height=<%=height%> cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</body>
</html>