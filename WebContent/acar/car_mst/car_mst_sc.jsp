<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");		
	
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")		==null?"":request.getParameter("code");
	String car_id 		= request.getParameter("car_id")	==null?"":request.getParameter("car_id");
	String view_dt 		= request.getParameter("view_dt")	==null?"":request.getParameter("view_dt");
	String t_wd 		= request.getParameter("t_wd")		==null?"":request.getParameter("t_wd");
	String t_wd2 		= request.getParameter("t_wd2")		==null?"":request.getParameter("t_wd2");
	String t_wd3 		= request.getParameter("t_wd3")		==null?"":request.getParameter("t_wd3");
	String t_wd4 		= request.getParameter("t_wd4")		==null?"":request.getParameter("t_wd4");
	String t_wd5 		= request.getParameter("t_wd5")		==null?"":request.getParameter("t_wd5");
	String gubun1 		= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String sort_gubun 	= request.getParameter("sort_gubun")	==null?"":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")		==null?"":request.getParameter("asc");
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 4; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
			"&car_comp_id="+car_comp_id+"&code="+code+"&car_id="+car_id+"&view_dt="+view_dt+"&t_wd="+t_wd+"&t_wd2="+t_wd2+"&t_wd3="+t_wd3+"&t_wd4="+t_wd4+"&t_wd5="+t_wd5+
			"&gubun1="+gubun1+"&s_car_id="+car_id+"&sort_gubun="+sort_gubun+"&asc="+asc+
			"&sh_height="+height+"";	
	
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	function Update(car_id, car_seq){	
		var fm = document.form1;
		fm.car_id.value = car_id;
		fm.car_seq.value = car_seq;		
		fm.target="d_content";
		fm.submit();
	}
//-->
</script>
</head>
<body>
<form action="./car_mst_u.jsp" name="form1" method="POST" >
  <input type="hidden" name="auth_rw" 	value="<%=auth_rw%>">
  <input type="hidden" name="br_id" 	value="<%=br_id%>">
  <input type="hidden" name="user_id" 	value="<%=user_id%>">    
  <input type="hidden" name="car_comp_id" value="<%=car_comp_id%>">    
  <input type="hidden" name="code" 	value="<%= code %>">
  <input type="hidden" name="view_dt" 	value="<%= view_dt %>">
  <input type="hidden" name="t_wd" 	value="<%= t_wd %>">  
  <input type="hidden" name="t_wd2" 	value="<%= t_wd2 %>">  
  <input type="hidden" name="t_wd3" 	value="<%= t_wd3 %>">  
  <input type="hidden" name="t_wd4" 	value="<%= t_wd4 %>">    
  <input type="hidden" name="t_wd5" 	value="<%= t_wd5 %>">      
  <input type="hidden" name="gubun1" 	value="<%= gubun1 %>">
  <input type="hidden" name="sort_gubun" value="<%= sort_gubun %>">
  <input type="hidden" name="asc" 	value="<%= asc %>">
  <input type="hidden" name="s_car_id" 	value="<%= car_id %>">  
  <input type="hidden" name="car_id" 	value="<%=car_id%>">
  <input type="hidden" name="car_seq" 	value="">  
  <input type="hidden" name="cmd" 	value="">  
</form>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
        <td> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class='line' width="100%"> 
                        <table  border=0 cellspacing=1 width="100%">
                            <tr> 
                                <td class=title width="3%" rowspan="3">연번</td>
                                <td class=title width="20%">차명</td>
                                <td class=title width="39%">차종</td>
				<td class=title width="4%">년형</td>
				<td class=title width="6%">차종코드</td>
                                <td class=title width="4%">배기량</td>
                                <td class=title width="6%">사용여부</td>
                                <td class=title width="9%">기본가격</td>
                                <td class=title width="9%">기준일자</td>
                            </tr>
                            <tr> 
                                <td class=title colspan="8" >기본사양</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
        <td width=16>&nbsp;</td>
    </tr>
    <tr> 
        <td colspan=2><iframe src="./car_mst_sc_in.jsp<%=valus%>" name="i_inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe></td>
    </tr>
</table>
</body>
</html>