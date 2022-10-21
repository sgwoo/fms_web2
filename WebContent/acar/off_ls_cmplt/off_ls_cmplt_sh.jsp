<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");	
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	String dt		= request.getParameter("dt")==null?"3":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
	String s_au = request.getParameter("s_au")==null?"":request.getParameter("s_au");
		
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<html>
<head><%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="javascript">
<!--
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
	var fm = parent.c_foot.inner.form1;
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
	if(!confirm('자동차 처분 사후관리로 넘기시겠습니까?')){	return;	}
	fm.action = "/acar/off_ls_after/off_ls_after_set.jsp";
	fm.target = "i_no";
	fm.submit();
}
function car_gbu_doc(){
	var fm = parent.c_foot.inner.form1;
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

//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</head>

<body>
<form name='form1' method='post' action='./off_ls_cmplt_sc.jsp'>
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
        <td colspan=5>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gggs.gif align=absmiddle>&nbsp;<input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
          당월 
          <input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
          조회기간&nbsp;&nbsp;
          <input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
          ~ 
          <input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()">
		  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_g_gy.gif align=absmiddle>&nbsp;
		<select name='gubun1'>
          <option value='' >전체</option> 
          <option value='rt' <%if(gubun1.equals("rt")){%>selected<%}%>>렌트</option>
          <option value='ls' <%if(gubun1.equals("ls")){%>selected<%}%>>리스</option>
        </select>
		
		&nbsp;<a href="javascript:search()"><img src=../images/center/button_search.gif border=0 align=absmiddle></a>
		</td>
    </tr>
    <tr> 
      <td width='180' align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
        <select name='gubun'>
          <option value='all' >전체</option> 
          <option value='car_no' <%if(gubun.equals("car_no")){%>selected<%}%>>차량번호</option>
          <option value='car_nm' <%if(gubun.equals("car_nm")){%>selected<%}%>>차명</option>
          <option value='init_reg_dt' <%if(gubun.equals("init_reg_dt")){%>selected<%}%>>최초등록일</option>      
        </select>
      </td>
      <td width="100"> 
        <input type="text" name="gubun_nm" value="<%=gubun_nm%>" class="text" size="15" onKeydown="javasript:EnterDown()">
      </td>
	  <td width='220' align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gmj.gif align=absmiddle> 
          <select name="s_au" >
                <option value=""  <%if(s_au.equals("")){%> selected <%}%>>전체</option>
				<option value="000502" <%if(s_au.equals("000502")){%> selected <%}%>>현대글로비스(주)-시화</option>
				<option value="013011" <%if(s_au.equals("013011")){%> selected <%}%>>현대글로비스(주)-분당</option>
                <option value="020385" <%if(s_au.equals("020385")){%> selected <%}%>>에이제이셀카(주)</option>
				<option value="003226" <%if(s_au.equals("003226")){%> selected <%}%>>서울오토</option>
				<option value="011723" <%if(s_au.equals("011723")){%> selected <%}%>>서울자동차경매</option>
				<option value="013222" <%if(s_au.equals("013222")){%> selected <%}%>>동화엠파크 주식회사</option>
				<option value="022846" <%if(s_au.equals("022846")){%> selected <%}%>>롯데렌탈</option>
           </select>
      </td>
	  <td width="0"></td>
	  <td align="right">&nbsp; <%if(auth_rw.equals("6")){%><a href="javascript:off_ls_after()"><img src=../images/center/button_shgr.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%}%>
	  <%if(auth_rw.equals("6")){%><a href="javascript:car_gbu_doc()"><img src=../images/center/button_gbbgsc.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%}%>
	  
	  </td>
    </tr>
  </table>
</form>
</body>
</html>