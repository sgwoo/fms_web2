<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function preSearch()
{
	var theForm = document.form1;
	theForm.target = "c_foot";
	theForm.submit();
}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}		
		
	//의뢰 선택
	function loan_confirm(){
		var fm1= document.form1;	
		var fm = i_no.document.form1;	
		var len=fm.elements.length;	
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "pr"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("차량을 선택하세요.");
			return;
		}	
				
		fm.target = "c_foot";
		fm.action = "cons_reg_step1_off_sc.jsp" ;		
		fm.submit();
		window.close();
	}			
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body>
<form name='form1' action='find_cont_search_in.jsp' method='post' target='i_no'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='r_off_id' value='<%=off_id%>'>
<table border="0" cellspacing="0" cellpadding="0" width=1030>
    <tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1><span class=style5>차량조회</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td class=h></td></tr>
        <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr> 
					        <td width='80' align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>&nbsp;
					        <select name='gubun'>
					          <option value='all' >전체</option>
					          <option value='car_no' <%if(gubun.equals("car_no")){%>selected<%}%>>차량번호</option>
					          <option value='car_nm' <%if(gubun.equals("car_nm")){%>selected<%}%>>차명</option>
					          <option value='init_reg_dt' <%if(gubun.equals("init_reg_dt")){%>selected<%}%>>최초등록일</option>
					        </select> </td>
					        <td width="105"> <input type="text" name="gubun_nm" value="<%=gubun_nm%>" class="text" size="15" onKeydown="javasript:EnterDown()"></td>
					        <td width=30><a href="javascript:preSearch()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a></td>
                                  
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><iframe src="./find_cont_search_in.jsp?r_off_id=<%=off_id%>&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gubun=<%=gubun%>&gubun_nm=<%=gubun_nm%>" name="i_no" width="1020" height="530" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 ></iframe></td>
    </tr>
    <tr>
        <td style='height:5'></td>
    </tr>
    <tr> 
        <td align="center"><a href="javascript:loan_confirm()"><img src=/acar/images/center/button_conf.gif align=absmiddle border=0></a>&nbsp;&nbsp;<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</body>
</html>
