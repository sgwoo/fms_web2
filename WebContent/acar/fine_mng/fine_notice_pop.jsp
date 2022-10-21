<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.* "%>
<%@ include file="/acar/cookies.jsp" %>
<%

	String col_1_nm = request.getParameter("col_1_nm")==null?"":request.getParameter("col_1_nm");
	String col_1_val = request.getParameter("col_1_val")==null?"":request.getParameter("col_1_val");
	String col_2_nm = request.getParameter("col_2_nm")==null?"":request.getParameter("col_2_nm");
	String col_2_val = request.getParameter("col_2_val")==null?"":request.getParameter("col_2_val");
	String col_3_nm = request.getParameter("col_3_nm")==null?"":request.getParameter("col_3_nm");
	String col_3_val = request.getParameter("col_3_val")==null?"":request.getParameter("col_3_val");
	String col_4_nm = request.getParameter("col_4_nm")==null?"":request.getParameter("col_4_nm");
	String col_4_val = request.getParameter("col_4_val")==null?"":request.getParameter("col_4_val");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	CommonEtcBean[] ce_bean1 = c_db.getCommonEtcAll("fine_notice_ment", "", "", "", "", "", "", "", "");
	int ce_bean_size1 = ce_bean1.length;
	
	if(ce_bean_size1 > 0 && col_1_val.equals("")){
		col_1_nm = "gubun";
		col_1_val = ce_bean1[0].getCol_1_val();
	}
	CommonEtcBean ce_bean2 = c_db.getCommonEtc("fine_notice_ment", "gubun", col_1_val, col_2_nm, col_2_val, col_3_nm, col_3_val, col_4_nm, col_4_nm);
	
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type="text/css">
.checked{		color:red;		}
</style>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src='/include/common.js'></script>
<script>
$(document).on(function(){

});

//안내문 등록
function reg_notice_ment(){
	var chk = check_notice_title();
	if(chk){
		alert("같은 제목의 문구제목이 있습니다. 문구제목을 변경후 등록해주세요.");
	}else{
		$("#col_1_val").val($("#col_1_val").val().replace(/ /gi,'')); 
		if($("#col_1_val").val()==""){	alert("제목을 입력하세요.");	return false;	}
		var fm = document.form1;
		fm.mode.value = "I";
		fm.submit();
	}
}

//안내문 수정
function modi_notice_ment(){
	var chk = check_notice_title();
	if(chk){
		if($("#col_1_val").val()==""){	alert("제목을 입력하세요.");	return false;	}
		var fm = document.form1;
		fm.mode.value = "U";
		fm.submit();
	}else{
		alert("문구제목은 수정 할 수 없습니다. 등록/삭제를 통해 관리해주세요.");
	}
}

//안내문 삭제
function del_notice_ment(){
	var chk = check_notice_title();
	if(chk){
		if($("#col_1_val").val()==""){	alert("제목을 입력하세요.");	return false;	}
		if(confirm("삭제하시겠습니까?")){
			var fm = document.form1;
			fm.mode.value = "D";
			fm.submit();
		}
	}else{
		alert("문구제목에 해당하는 내용이 없어서 삭제 할 내역이 없습니다.");
	}
}

//문구제목체크
function check_notice_title(){
		var title = $("#col_1_val").val();
		var chk = false;	//같은 제목이 있으면 true, 없으면 false
<%	for(int i=0;i<ce_bean_size1;i++){%>
			if(title=='<%=ce_bean1[i].getCol_1_val()%>'){		chk	=	true;		}
<%	}%>
		return chk;
}

//문구선택시 보여주기
function change_notice(val){
	 var fm = document.form1;
	//fm.col_1_val.value = val;
	$("#col_1_val").val(val);
	fm.action = "fine_notice_pop.jsp";
	fm.submit();
}

</script>
</head>
<body>
<form name='form1' method='post' action="fine_notice_pop_a.jsp">
<input type="hidden" name="mode" value="">

<div class="navigation" style="margin-bottom:0px !important">
	<span class="style1">차량관리 > 과태료관리 > 등록/수정 ></span><span class="style5"> 과태료안내문 문구 설정 </span>
</div>
<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top: 20px;">

	<tr> 
  		<td><label><i class="fa fa-check-circle"></i> 안내문 문구 </label>&nbsp;		
    		<select name='s_kd' class='select' onchange="javascript:change_notice(this.value);">
	<%	if(ce_bean_size1 > 0){ 
   				for(int i=0;i<ce_bean_size1;i++){%>
 					<option <%if(ce_bean1[i].getCol_1_val().equals(col_1_val)){%>selected<%}%>><%=ce_bean1[i].getCol_1_val()%></option>			
   		<%	}
   			}%>
			</select>
      	</td>
    </tr>
    <tr> 
      	<td>&nbsp;</td>
	</tr>
    <tr><td class=line2></td></tr>
    <tr> 
      	<td class=line>
   		<%-- <%if(!ce_bean2.getEtc_content().equals("")){	%> --%>
        	<table border="0" cellspacing="1" width=100%>
        		<colgroup>
	        		<col width='12%'>
	        		<col width='*'>
        		</colgroup>
        		<tr>
        			<td class="title">문구제목</td>
        			<td><input type="text" name="col_1_val" id="col_1_val" size="60" value="<%=ce_bean2.getCol_1_val() %>"></td>
        		</tr>
        		<tr>
        			<td class="title">문구내용</td>
        			<td><textarea cols=72 rows=10 class=default name="etc_content"><%=ce_bean2.getEtc_content()%></textarea></td>
        		</tr>
        	</table>
        <%-- <%}%> --%>	
       	</td>
   	</tr>
</table>
<div align="center">
	<input type='button' value='등록'  class='button' onclick="javascript:reg_notice_ment();">
	<input type='button' value='수정'  class='button' onclick="javascript:modi_notice_ment();">
	<input type='button' value='삭제'  class='button' onclick="javascript:del_notice_ment();">
    <input type='button' value='닫기'  class='button' onclick='javascript:window.close();'>
</div>
</form>
</body>
</html>