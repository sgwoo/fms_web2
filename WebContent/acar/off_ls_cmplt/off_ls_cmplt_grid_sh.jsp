<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	String dt		= request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="javascript">
function EnterDown()
{
	var keyValue = event.keyCode;
	if (keyValue =='13') search();
}
function search()
{
	var theForm = document.form1;
	theForm.target = "c_foot";
	theForm.submit();
}

function off_ls_after(){
	var fm = parent.c_foot.form1;
	var len = fm.elements.length;
	var cnt=parent.c_foot.document.getElementById("selectValueList").value;
	if(cnt == 0){ alert("차량을 선택하세요 !"); return; }
	if(!confirm('자동차 처분 사후관리로 넘기시겠습니까?')){	return;	}
	fm.action = "/acar/off_ls_after/off_ls_after_set.jsp";
	fm.target = "i_no";
	fm.submit();
}
function car_gbu_doc(){
	var fm = parent.c_foot.form1;
	var len = fm.elements.length;
	var cnt=parent.c_foot.document.getElementById("selectValueList").value;
	if(cnt == 0){ alert("차량을 선택하세요 !"); return; }
	fm.action = "car_gbu_doc.jsp";
	fm.target = "_blank";
	fm.submit();
}

function ChangeDT(arg)
{
	var theForm = document.form1;
	if(arg=="ref_dt1")
	{
	theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
	}else if(arg=="ref_dt2"){
	theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
	}

}

function cng_dt(){
	var fm = document.form1;
	if(fm.dt.options[fm.dt.selectedIndex].value == '3'){ //기간
		esti.style.display 	= '';
	}else{
		esti.style.display 	= 'none';
	}
}

//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>

<body>
<form name='form1' method='post' action='./off_ls_cmplt_grid_sc.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan=5>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>오프리스 > 경매관리 > <span class=style5>낙찰현황</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td width="150px">&nbsp;&nbsp;
        	<img src=../images/center/arrow_gggs.gif align=absmiddle>&nbsp;
        	<select name="dt" onChange='javascript:cng_dt()'>
				<option value='' <%if(dt.equals("")){%> selected <%}%>>선택</option>
				<option value='2' <%if(dt.equals("2")){%> selected <%}%>>당월</option>
				<option value='3' <%if(dt.equals("3")){%> selected <%}%>>조회기간</option>
			</select>        	
		</td>
        <td width="170px" id="esti" style="display:none;">
          	<input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')"> ~ 
			<input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()">
		</td>
		<td width="200px">
		  	<img src=../images/center/arrow_g_gy.gif align=absmiddle>&nbsp;
			<select name='gubun1'>
          		<option value='' >전체</option> 
          		<option value='rt' <%if(gubun1.equals("rt")){%>selected<%}%>>렌트</option>
          		<option value='ls' <%if(gubun1.equals("ls")){%>selected<%}%>>리스</option>
        	</select>		
		&nbsp;<a href="javascript:search()"><img src=../images/center/button_search.gif border=0 align=absmiddle></a>
		</td>
		<td width="*" align="right">&nbsp; 
			<%if(auth_rw.equals("6")){%>
				<a href="javascript:off_ls_after()"><img src=../images/center/button_shgr.gif align=absmiddle border=0></a>&nbsp;&nbsp;
				<a href="javascript:car_gbu_doc()"><img src=../images/center/button_gbbgsc.gif align=absmiddle border=0></a>&nbsp;
			<%}%>
		</td>
    </tr>
  </table>
</form>
</body>
</html>