<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_idx = request.getParameter("s_idx")==null?"":request.getParameter("s_idx");
	
		
	
	if(!st_dt.equals("")) 	st_dt 	= AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) 	end_dt 	= AddUtil.replace(end_dt, "-", "");
	
	Vector fines = FineDocDb.getFineSearchLists(t_wd, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt);
	
	int fine_size = fines.size();
%>

<html>
<head><title>FMS</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language='javascript'>
$(document).ready(function(){
	
	//조회하면 바로 30컨 체크 되어 있게 처리(20190830)
	select_chk_box('30');
	
	$("#select_chk_box", parent.document).on("change",function(){
		var fine_size = '<%=fine_size%>';
		if(fine_size >0){
			select_chk_box(this.value);
		}
	});
	
});

function select_chk_box(val){
	var fine_size = '<%=fine_size%>';
	//초기화
	for(var i=0; i<fine_size; i++){
		$("#cho_id_"+i).prop("checked",false);
	}
	//선택한 수만큼 체크
	for(var i=0; i<val; i++){
		$("#cho_id_"+i).prop("checked",true);
	} 
}
<!--
	//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "cho_id"){
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
	}
//-->	
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='s_idx' value='<%=s_idx%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>   
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' width="5%">연번</td>
                    <td class='title' width="5%"><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
                    <td width='10%' class='title'>차량번호</td>
                    <td width='35%' class='title'>상호</td>
                    <td width='20%' class='title'>고지서번호</td>
                    <td width='15%' class='title'>위반일시</td>
                    <td width='10%' class='title' style="font-size : 8pt;">최종이의신청일</td>
                </tr>
                <%for (int i = 0 ; i < fine_size ; i++){
                    Hashtable fine = (Hashtable)fines.elementAt(i);%>
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td><input type="checkbox" name="cho_id" id="cho_id_<%=i%>" value="<%=fine.get("RENT_MNG_ID")%>/<%=fine.get("RENT_L_CD")%>/<%=fine.get("CAR_MNG_ID")%>/<%=fine.get("SEQ_NO")%>/<%=fine.get("RENT_ST")%>/<%=fine.get("VIO_DT")%>"></td>
                    <td><%=fine.get("CAR_NO")%></td>
                    <td><%=fine.get("FIRM_NM")%> <font color=red><%=fine.get("RM_ST")%></font></span></td>
                    <td><%=fine.get("PAID_NO")%></td>
                    <td><span title='<%=fine.get("VIO_CONT")%>'><%=AddUtil.ChangeDate3(String.valueOf(fine.get("VIO_DT")))%></span></td>
                    <td><%=AddUtil.ChangeDate2(String.valueOf(fine.get("DOC_DT")))%></td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
</table>
</form>
</script>
</body>
</html>
