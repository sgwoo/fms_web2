<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.con_ins.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript">
<!--
	//등록
	function InsComReg(){
		var fm = document.form1;
		fm.cmd.value = "i";		
		if(fm.ins_com_id.value!=""){	alert("수정만이 가능합니다.");	return;	}
		if(!CheckField()){	return;	}
		if(!confirm('등록하시겠습니까?')){
			return;
		}
		fm.target = "i_no"
		fm.submit();
	}

	//수정
	function InsComUp(){
		var fm = document.form1;
		fm.cmd.value = "u";		
		if(fm.ins_com_id.value==""){	alert("등록만이 가능합니다.");	return;	}
		if(!CheckField()){	return;	}
		if(!confirm('수정하시겠습니까?')){
			return;
		}
		fm.target = "i_no";
		fm.submit();
	}

	function ClearM(){
		var fm = document.form1;
		fm.ins_com_id.value = '';
		fm.ins_com_nm.value = '';
		fm.car_rate.value = '';
		fm.ins_rate.value = '';
		fm.ext_rate.value = '';
		fm.agnt_tel.value = '';
		fm.agnt_fax.value = '';
		fm.agnt_imgn_tel.value = '';
		fm.acc_tel.value = '';
	}
	
	//입력값 null 체크
	function CheckField(){
		var fm = document.form1;
		if(fm.ins_com_id.value=="" && fm.cmd.value=="u"){	alert("보험사ID를 입력하십시요");	fm.ins_com_id.focus();	return false;	}
		if(fm.ins_com_nm.value==""){	alert("보험사명을 입력하십시요");	fm.ins_com_nm.focus();	return false;	}
		return true;
	}
	
	//우편번호 검색
	function search_zip(str){
		window.open("/fms2/lc_rent/zip_s.jsp?idx="+str, "ZIP", "left=100, top=100, height=500, width=400, scrollbars=yes");
	}	
	
//-->
</script>
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

</style>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
%>
<form action="ins_com_sc_a.jsp" name="form1" method="post">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>		
        <td> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr>
                    <td class=line2></td>
                </tr>
				<tr>					
                    <td class='line'> 
                        <table  border=0 cellspacing=1 width="100%">
                            <tr> 
                                <td class=title>보험사ID</td>
                                <td><input type="text" name="ins_com_id" size="10" class="whitetext" readonly></td>
                                <td class=title>보험사명</td>
                                <td colspan="5"><input type="text" name="ins_com_nm" size="20" style='IME-MODE: active' class=text></td>
                            </tr>
                            <tr> 
                                <td class=title >가입경력율</td>
                                <td><input type="text" name="car_rate" size="5" class=text_p>%</td>
                                <td class=title >보험율</td>
                                <td> <input type="text" name="ins_rate" size="5" class=text_p>%</td>
                                <td class=title>할인할증율</td>
                                <td colspan="3">
                                <input type="text" name="ext_date" size="5" class=text_p>%</td>
                            </tr>
                            <tr> 
                                <td class=title width=10%>전화번호</td>
                                <td width=14%><input type="text" name="agnt_tel" size="15" class=text></td>
                                <td class=title width=10%>FAX</td>
                                <td width=18%><input type="text" name="agnt_fax" size="15" class=text></td>
                                <td class=title width=10%>긴급출동번호</td>
                                <td width=14%><input type="text" name="agnt_imgn_tel" size="15" class=text></td>
                                <td class=title width=10%>사고접수번호</td>
                                <td width=14%><input type="text" name="acc_tel" size="15" class=text></td>
                            </tr>
                            <tr> 
                                <td class=title >보험사명 풀네임</td>
                                <td colspan='3'><input type="text" name="ins_com_f_nm" size="40" class=text></td>
                                <td class=title>주소</td>
								<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
								<script>
									function openDaumPostcode() {
										new daum.Postcode({
											oncomplete: function(data) {
												document.getElementById('t_zip').value = data.zonecode;
												document.getElementById('t_addr').value = data.address;
												
											}
										}).open();
									}
								</script>
                                <td colspan="3">
								<input type="text" name='t_zip' id="t_zip" value="" size="7" maxlength='7'>
								<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
								&nbsp;&nbsp;<input type="text" name='t_addr' id="t_addr" value="" size="50">
								
								</td>
                            </tr>  
                            <tr>
                            	<td class=title >대여료 주소</td>
								<script>
									function openDaumPostcode1() {
										new daum.Postcode({
											oncomplete: function(data) {
												document.getElementById('t_zip1').value = data.zonecode;
												document.getElementById('t_addr1').value = data.address;
												
											}
										}).open();
									}
								</script>
                        		<td colspan="8">
                        			<input type="text" name='t_zip1' id="t_zip1" value="" size="7" maxlength='7'>
									<input type="button" onclick="openDaumPostcode1()" value="우편번호 찾기"><br>
									&nbsp;&nbsp;<input type="text" name='t_addr1' id="t_addr1" value="" size="50">
                        		</td>
                            </tr>                          
                        </table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>        
        <td class=h></td>
    </tr>			
    <tr>        
        <td align="right">
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>        
        <a href="javascript:InsComReg()"><img src=../images/center/button_reg.gif border=0 align=absmiddle></a>
        <a href="javascript:InsComUp()"><img src=../images/center/button_modify.gif border=0 align=absmiddle></a>
        <a href="javascript:ClearM()"><img src=../images/center/button_init.gif border=0 align=absmiddle></a> 
        <%}%>
	    </td>
    </tr>	
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>