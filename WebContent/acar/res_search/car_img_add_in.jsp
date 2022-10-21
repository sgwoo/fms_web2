<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*, acar.car_register.*, acar.offls_pre.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	String nm = "";
	String img = "";
	
	//차량정보
	Off_ls_pre_apprsl bean = rs_db.getCarBinImg2(c_id);
	
	int a_yn = rs_db.getApprslChk(c_id);
	
	if(idx.equals("1")){
		nm = "앞측";
		if(a_yn > 0) img = bean.getImgfile1();
	}else if(idx.equals("2")){
		nm = "실내";
		if(a_yn > 0) img = bean.getImgfile2();
	}else if(idx.equals("3")){
		nm = "뒤";
		if(a_yn > 0) img = bean.getImgfile3();
	}else if(idx.equals("4")){
		nm = "뒤측";
		if(a_yn > 0) img = bean.getImgfile4();
	}else if(idx.equals("5")){
		nm = "앞";
		if(a_yn > 0) img = bean.getImgfile5();
	}else if(idx.equals("6")){
		nm = "앞측_s";
		if(a_yn > 0) img = bean.getImgfile6();
	}
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save(){
		var fm = document.form1;	
		fm.mode.value = 'i';	
		if(confirm('등록(수정) 하시겠습니까?')){
			fm.target='i_no';
			fm.action = "https://fms3.amazoncar.co.kr/acar/upload/res_search_car_img_add_a.jsp";
			fm.submit();
		}				
	}
	
	function img_delete(){
		var fm = document.form1;	
		fm.mode.value = 'd';
		if(confirm('삭제하시겠습니까?')){
			fm.target='i_no';
			fm.action = "https://fms3.amazoncar.co.kr/acar/upload/res_search_car_img_add_a.jsp";			
			fm.submit();
		}
	}	
//-->
</script>
</head>
<body leftmargin="15" rightmargin=0>
<form name='form1' action='' method='post' enctype="multipart/form-data">
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='mode' value=''>
<input type='hidden' name='o_img' value='<%=img%>'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10% rowspan="2"><%=nm%></td>
                    <td width=18% align="center" rowspan="2"> 
                      <%if(!img.equals("")){%>
                      <img src="https://fms3.amazoncar.co.kr/images/carImg/<%=img%>.gif" width="66" height="53" align=absmiddle name="f"> 
                      <%}else{%>
                      <img src=../images/center/no_photo.gif align=absmiddle name="f"> 
                      <%}%>
                    </td>
                    <td width=72% style='height:26'> 
                      &nbsp;<input type="file" name="filename" size="40">
                    </td>
                </tr>
                <tr> 
                    <td  align="right" style='height:26'> <a href="javascript:save();"><img src=../images/center/button_in_reg.gif align=absmiddle border=0></a>&nbsp; 
                    <a href="javascript:img_delete();"><img src=../images/center/button_in_delete.gif align=absmiddle border=0></a>&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
