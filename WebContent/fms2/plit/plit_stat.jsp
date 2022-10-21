<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소

	
	int st_year = request.getParameter("st_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("st_year"));	
	int st_mon = request.getParameter("st_mon")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("st_mon"));	
	String gubun = request.getParameter("gubun")==null?"1":request.getParameter("gubun");  //1:급여 , 2:사업/기타(영업사원)
	int year =AddUtil.getDate2(1);
	
	
	if(user_id.equals(""))	user_id = ck_acar_id;
	if(br_id.equals(""))	br_id 	= acar_br;
				
	int cnt = 3; //검색 라인수
	int sh_height = cnt*sh_line_height  ;
	
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height) - 50;//현황 라인수만큼 제한 아이프레임 사이즈
	
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">

<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//조회
	function search(){
		var fm = document.form1;		
		var i_fm = i_view.form1;
		
		i_fm.st_year.value = fm.st_year.value;
		i_fm.st_mon.value = fm.st_mon.value;		
			
		if(fm.gubun[0].checked == true ) {
		
			i_fm.action = "./plit_in_view.jsp";	
		} else {
		
			i_fm.action = "./plit_in_view1.jsp";	
		} 
		
		i_fm.target='i_view';												
		i_fm.submit();				
	}
	
//-->
</script>
</head>
<body>

<form action="" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='brch_id' value=''>
<input type='hidden' name='height' value='<%=height%>'>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 인사연동관리 > <span class=style5>연동데이터조회</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle>&nbsp;귀속년월&nbsp;
			<select name="st_year">
                        <%for(int i=2022; i<=year; i++){%>
                        <option value="<%=i%>" <%if(st_year == i){%>selected<%}%>><%=i%>년</option>
                        <%}%>
                      </select> <select name="st_mon">
                        <%for(int i=1; i<=12; i++){%>
                        <option value="<%=i%>" <%if(st_mon == i){%>selected<%}%>><%=i%>월</option>
                        <%}%>
             </select>
             &nbsp;&nbsp;
               <input type="radio" name="gubun" value="1" checked>
           	         인사자료  
              <input type="radio" name="gubun" value="2" >
             	 사업소득/기타소득 
			&nbsp;&nbsp;&nbsp;<a href="javascript:search();"><img src="/acar/images/center/button_search.gif" border="0" align=absmiddle></a>
		</td>
	</tr>
	
    <tr> 
      <td>&nbsp;</td>
    </tr>		
    <tr> 
      <td><iframe src="./plit_in_view.jsp?height=<%=height%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&st_mon=<%=st_mon%>&st_year=<%=st_year%>" name="i_view" width="100%" height="<%=height+10%>" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0"></iframe> 
      </td>
    </tr>
  </table>
</form>
</body>
</html>
