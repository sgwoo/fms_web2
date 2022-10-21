<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");		
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");		
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
			//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	function Search(){
		var fm = document.form1;
		fm.action="ins_s_sc.jsp";
		fm.target="c_foot";		
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') Search(3);
	}
	
function car_gbu_doc(){
	var fm = parent.c_foot.i_no.form1;
	var len = fm.elements.length;
	var cnt=0;
	var idnum="";
	for(var i=0 ; i<len ; i++){
		var ck = fm.elements[i];
		if(ck.name == 'pr'){
			if(ck.checked == true){
				cnt++;
				idnum = ck.value;
			}
		}
	}
	if(cnt == 0){ alert("차량을 선택하세요 !"); return; }
	fm.action = "/acar/off_ls_cmplt/car_gbu_doc.jsp";
	fm.target = "_blank";
	fm.submit();
}

function list_excel_s(){
		fm = document.form1;
		//window.open("about:blank",'list_excel','scrollbars=yes,status=yes,resizable=yes,width=1200,height=800,left=50,top=50');
		fm.target = "_blank";
		fm.action = "ins_s_excel.jsp";
		fm.submit();
	}				
//-->
</script>
</head>
<body>

<form action="./ins_s_sc.jsp" name="form1" method="POST" target="c_foot">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="idx" value="<%=idx%>">
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=4>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>사고 및 보험 > 보험관리 > <span class=style5>보험해지조회</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>   
    <tr> 
        <td width=40%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_g_hjsy.gif align=absmiddle>&nbsp;
            <input type='radio' name='gubun1' value='' <%if(gubun1.equals("")){%> checked <%}%>>
            전체 
            <input type='radio' name='gubun1' value='1' <%if(gubun1.equals("1")){%> checked <%}%>>
            용도변경 
            <input type='radio' name='gubun1' value='2' <%if(gubun1.equals("2")){%> checked <%}%>>
            매각
            <input type='radio' name='gubun1' value='3' <%if(gubun1.equals("3")){%> checked <%}%>>
            매입옵션
            <input type='radio' name='gubun1' value='4' <%if(gubun1.equals("4")){%> checked <%}%>>
            폐차
	    </td>
        <td width=14%><img src=../images/center/arrow_g_cg.gif align=absmiddle>&nbsp; 
            <select name="gubun2" >
              <option value=""  <%if(gubun2.equals("")){ %>selected<%}%>>전체</option>
              <option value="1" <%if(gubun2.equals("1")){%>selected<%}%>>청구</option>
              <option value="2" <%if(gubun2.equals("2")){%>selected<%}%>>미청구</option>
            </select>
        </td>
        <td width=12%><img src=../images/center/arrow_g_sg.gif align=absmiddle>&nbsp;
            <select name="gubun3" >
              <option value=""  <%if(gubun3.equals("")){ %>selected<%}%>>전체</option>
              <option value="1" <%if(gubun3.equals("1")){%>selected<%}%>>수금</option>
              <option value="2" <%if(gubun3.equals("2")){%>selected<%}%>>미수금</option>
            </select>
        </td>
        <td width=14%><img src=../images/center/arrow_jrjg.gif align=absmiddle>&nbsp; 
            <select name="gubun4" >
              <option value="1" <%if(gubun4.equals("1")){%>selected<%}%>>발생일자</option>
              <option value="2" <%if(gubun4.equals("2")){%>selected<%}%>>보험사</option>
              <option value="3" <%if(gubun4.equals("3")){%>selected<%}%>>처리일자</option>
            </select>
        </td>        
        <td> <a href="javascript:Search()"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a></td>
        <td> <a href="javascript:list_excel_s()"><img src="/acar/images/center/button_bhex.gif"  align="absmiddle" border="0"></a></td>
        <td align="right"> <%if(auth_rw.equals("6")){%><a href="javascript:car_gbu_doc()"><img src=../images/center/button_gbbgsc.gif align=absmiddle></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%}%></td>
    </tr>
</table>
</form>
</body>
</html>