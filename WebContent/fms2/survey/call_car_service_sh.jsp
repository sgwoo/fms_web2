<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	/*������� ��������*/
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank = request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");
	String ref_dt1 = request.getParameter("ref_dt1")==null?Util.getDate():request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?Util.getDate():request.getParameter("ref_dt2");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");

	String sort = request.getParameter("sort")==null?"7":request.getParameter("sort");
	String g_fm = "1";
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
%>

<html>

<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function SearchRentCond()
{
	var theForm = document.RentCondSearchForm;
	theForm.target = "c_foot";
	theForm.submit();
}
function EnterDown() 
{
	var keyValue = event.keyCode;
	if (keyValue =='13') SearchRentCond();
}
function ChangeDT(arg)
{
	var theForm = document.RentCondSearchForm;
	if(arg=="ref_dt1")
	{
	theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
	}else if(arg=="ref_dt2"){
	theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
	}

}

	//���÷��� Ÿ��
	function cng_input(){
		var fm = document.RentCondSearchForm;
		if(fm.gubun3.options[fm.gubun3.selectedIndex].value != ''){
			td_user.style.display 	= '';
		}else{
			td_user.style.display 	= 'none';
		}
	}
//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
<style type=text/css>

<!--

.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
select {
    width: 40%;
    padding: 4px 8px;
    border: 1px solid ;
    border-radius: 4px;
    background-color: #ffff;
	font-size: 1em;
}
</style>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>
<form action="./call_car_service_sc.jsp" name="RentCondSearchForm" method="POST" target="c_foot">
<div class="navigation">
	<span class=style1>�ݼ��� ></span><span class=style5>�����ݵ����Ȳ</span>
</div>
<div class="search-area">
<input type="radio" name="dt" value="4" <%if(dt.equals("4"))%>checked<%%>><label>����</label>
<input type="radio" name="dt" value="1" <%if(dt.equals("1"))%>checked<%%>><label>���</label> 
<input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>><label>����</label> 
<input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>><label>��ȸ�Ⱓ</label>
<label><i class="fa fa-check-circle"></i> ���� </label> 
<select name="gubun2" class="select" style="width:150px;">
<option value="1" <%if(gubun2.equals("1"))%>selected<%%>>������</option>
<option value="2" <%if(gubun2.equals("2"))%>selected<%%>>�ݵ����</option>
</select>
<input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
~ 
<input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" onKeydown="javasript:EnterDown()"> 
<label><i class="fa fa-check-circle"></i>�˻�����</label> 
<select name="s_kd" class="select" style="width:150px;">
<option value=""  <%if(s_kd.equals("")){%> selected <%}%>>��ü</option>
<option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>��ȣ</option>
<option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>�����</option>
</select>
<span id='td_nm' style='display:none'> 
<input type='text' size='20' name='st_nm' class='text' value=''>
</span>
<input type="button" class="button" value="�˻�" onclick="SearchRentCond()"/>    

<input type='hidden' name='sh_height' value='<%=sh_height%>'> 	    
</div>
</form>


</body>
</html>