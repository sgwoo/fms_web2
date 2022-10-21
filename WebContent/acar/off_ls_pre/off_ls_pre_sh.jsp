<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");		
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun_nm = request.getParameter("gubun_nm")==null?"":request.getParameter("gubun_nm");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector branches = c_db.getBranchList(); //영업소 리스트 조회
	int brch_size = branches.size();
	
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
%>
<html>
<head>
<title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="javascript">
<!--
function EnterDown()
{
	var keyValue = event.keyCode;
	if (keyValue =='13') preSearch();
}
function preSearch()
{
	var theForm = document.form1;
	theForm.target = "c_foot";
	theForm.submit();
}
function offls_pre_cancel(){
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
	if(!confirm('매각결정을 취소 하시겠습니까?')){	return;	}
	fm.action = "off_ls_pre_cancel.jsp";
	fm.target = "i_no";
	fm.submit();
}
function off_ls_auction(){
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
				//if(idnum.substring(6,7) != 'Y'){
				//	alert('구비서류가 미비된 차량이 있읍니다!');
				//	return;
				//}
			}
		}
	}
	if(cnt == 0){ alert("먼저 차량을 선택하세요 !"); return; }
	if(!confirm('경매 하시겠습니까?')){	return;	}
	fm.action = "/acar/off_ls_jh/off_ls_jh_set.jsp";
	fm.target = "i_no";
	fm.submit();
}
function off_ls_sui(){
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
	if(cnt == 0){ alert("먼저 차량을 선택하세요 !"); return; }
	if(!confirm('수의매각 하시겠습니까?')){	return;	}
	fm.action = "/acar/off_ls_sui/off_ls_sui_set.jsp";
	fm.target = "i_no";
	fm.submit();
}


function off_ls_junk(){
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
	if(cnt == 0){ alert("먼저 차량을 선택하세요 !"); return; }
	if(!confirm('폐차처리 하시겠습니까?')){	return;	}
	fm.action = "/acar/off_ls_sui/off_ls_junk_set.jsp";
	fm.target = "i_no";
	fm.submit();
}


function SendSms(){
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
//alert(idnum);				
			}
		}
	}
	if(cnt == 0){ alert("차량을 선택하세요 !"); return; }
	//if(!confirm('문자를 전송 하시겠습니까?')){	return;	}
	window.open('about:blank', "SendSms", "left=0, top=0, width=500, height=700, scrollbars=yes, status=yes, resizable=yes");
	fm.target = "SendSms";
	fm.action = "off_ls_sms.jsp";
	fm.submit();

}

function off_ls_pre_excel(){
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
	
	fm.target = "_blank";
	fm.action = "off_ls_pre_excel.jsp";
	fm.submit();
}

//-->
</script>
</head>
<body>
<form name='form1' method='post' action='./off_ls_pre_sc.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'> 
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td colspan=5>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>오프리스 > 오프리스현황 > <span class=style5>매각결정차량현황</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td width='190' align='left'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_gshm.gif align=absmiddle>&nbsp;
        <select name='gubun'>
          <option value='all' >전체</option>
          <option value='car_no' <%if(gubun.equals("car_no")){%>selected<%}%>>차량번호</option>
          <option value='car_nm' <%if(gubun.equals("car_nm")){%>selected<%}%>>차명</option>
          <option value='init_reg_dt' <%if(gubun.equals("init_reg_dt")){%>selected<%}%>>최초등록일</option>
        </select> </td>
        <td width="105"> <input type="text" name="gubun_nm" value="<%=gubun_nm%>" class="text" size="15" onKeydown="javasript:EnterDown()"></td>
        <td width=30><a href="javascript:preSearch()"><img src=../images/center/button_search.gif border=0 align=absmiddle></a></td>
	    <td width="219">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_yuscd.gif align=absmiddle>&nbsp;
        <select name='brch_id' onChange='javascript:preSearch();'>
          <option value=''>전체</option>
          <%	if(brch_size > 0){
							for (int i = 0 ; i < brch_size ; i++){
								Hashtable branch = (Hashtable)branches.elementAt(i);%>
          <option value='<%= branch.get("BR_ID") %>'  <%if(brch_id.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> 
          <%= branch.get("BR_NM")%> </option>
          <%							}
						}		%>
        </select></td>
        <td align="right">&nbsp; 
        <%if(auth_rw.equals("6")){%>
		&nbsp;<a href="javascript:off_ls_pre_excel()"><img src=../images/center/button_excel.gif border=0 align=absmiddle></a>		
		&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:SendSms()"><img src=/acar/images/center/button_send_smsgo.gif align=absmiddle border=0></a>
        <a href="javascript:offls_pre_cancel()"><img src=../images/center/button_mg_cancel.gif border=0 align=absmiddle></a>  
		<a href="javascript:off_ls_auction()"><img src=../images/center/button_gm.gif border=0 align=absmiddle></a> 
         <a href="javascript:off_ls_sui()"><img src=../images/center/button_se.gif border=0 align=absmiddle></a>&nbsp;&nbsp;&nbsp;&nbsp; 
      <!--   <a href="javascript:off_ls_junk()">폐차</a>&nbsp;&nbsp;&nbsp;&nbsp;   폐차처리와 입금일의 시점으로 인해서 처리 불가 -->
        <%}%>
        </td>      
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>