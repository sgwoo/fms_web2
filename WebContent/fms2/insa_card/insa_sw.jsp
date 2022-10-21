<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.cont.*, acar.util.*, acar.user_mng.*, acar.insa_card.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	int seq = request.getParameter("seq")==null?1:Util.parseInt(request.getParameter("seq"));
	String sw_gubun = request.getParameter("sw_gubun")==null?"":request.getParameter("sw_gubun");
	String sw_name = request.getParameter("sw_name")==null?"":request.getParameter("sw_name");
	String sw_ssn = request.getParameter("sw_ssn")==null?"":request.getParameter("sw_ssn");
	String sw_addr = request.getParameter("sw_addr")==null?"":request.getParameter("sw_addr");
	String sw_tel = request.getParameter("sw_tel")==null?"":request.getParameter("sw_tel");
	String sw_my_gubun = request.getParameter("sw_my_gubun")==null?"":request.getParameter("sw_my_gubun");
	String sw_st_dt = request.getParameter("sw_st_dt")==null?"":request.getParameter("sw_st_dt");
	String sw_ed_de = request.getParameter("sw_ed_de")==null?"":request.getParameter("sw_ed_de");
	String sw_up_dt = request.getParameter("sw_up_dt")==null?"":request.getParameter("sw_up_dt");
	String sw_insu_nm = request.getParameter("sw_insu_nm")==null?"":request.getParameter("sw_insu_nm");
	String sw_insu_no = request.getParameter("sw_insu_no")==null?"":request.getParameter("sw_insu_no");
	String sw_insu_money = request.getParameter("sw_insu_money")==null?"":request.getParameter("sw_insu_money");
	String sw_jesan = request.getParameter("sw_jesan")==null?"":request.getParameter("sw_jesan");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<title>신원보증사항 입력</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
function reg(){
	var fm = document.form1;
	
	fm.cmd.value = "sw";	
	fm.target="i_no";
//	fm.action="./insa_card_null.jsp";		
	fm.action="./insa_sw_a.jsp";
	fm.submit();
}

//-->
</script>
</head>

<body>
<form name='form1'  method='post' enctype="multipart/form-data">
<input type="hidden" name="user_id" value="<%=user_id%>"> 
<input type="hidden" name="cmd" value="">	
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr> 
        <td colspan=100>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>인사관리 > 조직관리 > 인사기록카드 > <span class=style5> 신원보증사항 입력</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
   
	<TR>
		<td class=line>
			<table border=0 cellspacing=1 width='100%'>
				<TR>
					<TD rowspan="7" width="40" height="227" class=title>신<br>원<br>보<br>증<br>사<br>항</TD>
					<TD colspan="7" width="673" height="28" class=title>  <INPUT TYPE="checkbox" NAME="sw_gubun" value='1'>인보증</TD>
				</TR>
				<TR>
					<TD width="16%" height="28" class=title>성명</TD>
					<TD width="16%" height="28" class=title>주민번호</TD>
					<TD colspan="2" width="32%" height="28" class=title>주소</TD>
					<TD width="16%" height="28" class=title>연락처</TD>
					<TD width="16%" height="28" class=title>본인과의 관계</TD>
				</TR>
				<TR>
					<TD width="16%" height="28" align="center"><input type='text' name="sw_name" value='' size='18' class='text'></TD>
					<TD width="16%" height="28" align="center"><input type='text' name="sw_ssn" value='' size='18' class='text'></TD>
					<TD colspan="2" width="32%" height="28" align="center"><input type='text' name="sw_addr" value='' size='38' class='text'></TD>
					<TD width="16%" height="28" align="center"><input type='text' name="sw_tel" value='' size='18' class='text'></TD>
					<TD width="16%" height="28" align="center"><input type='text' name="sw_my_gubun" value='' size='18' class='text'></TD>
				</TR>
				<TR>
					<TD colspan="" width="16%" height="28" class=title>인보증 스캔파일</TD>
					<TD colspan="3" width="673" height="28"><input type="file" name="sw_file" size="35"></TD>
					<TD width="16%" height="28" class=title>재산</TD>
					<TD width="16%" height="28" align="center">
						<SELECT NAME="sw_jesan">
							<OPTION VALUE="1">있음</OPTION>
							<OPTION VALUE="2">없음</OPTION>
						</SELECT>
						</TD>
				</TR>
				<TR>
					<TD colspan="6" width="673" height="28" class=title><INPUT TYPE="checkbox" NAME="sw_gubun" value='2'>보증보험</TD>
				</TR>
				<TR>
					<TD colspan="2" width="40%" height="28" class=title>보험사명</TD>
					<TD colspan="2" width="40%" height="28" class=title>보험증권번호</TD>
					<TD colspan="2" width="40%" height="28" class=title>보험금액</TD>
				</TR>
				<TR>
					<TD colspan="2" width="40%" height="28" align="center"><input type='text' name="sw_insu_nm" value='' size='30' class='text'></TD>
					<TD colspan="2" width="40%" height="28" align="center"><input type='text' name="sw_insu_no" value='' size='30' class='text'></TD>
					<TD colspan="2" width="40%" height="28" align="center"><input type='text' name="sw_insu_money" value='' size='30' class='text'>&nbsp;만원</TD>
				</TR>
			</table>
		</td>
	</tr>
	<tr> 
        <td class=h align="right">  </td>
	<tr> 
        <td class=h align="right">
        	<a href="javascript:reg()"><img src="/acar/images/center/button_reg.gif" border="0" align="absmiddle"></a>
			<a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif" border="0" align="absmiddle"></a>        	
        	</td>
    </tr>
</table>

</body>
</html>
