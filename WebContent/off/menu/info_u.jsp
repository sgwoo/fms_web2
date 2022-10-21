<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/off/cookies.jsp" %>

<%
	//사용자별 정보 조회 및 수정 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String br_id = "";
	String br_nm = "";
	String user_nm = "";
	String id = "";
	String user_psd = "";
	String user_cd = "";
	String user_ssn = "";
	String user_ssn1 = "";
	String user_ssn2 = "";
	String dept_id = "";
	String dept_nm = "";
	String user_h_tel = "";
	String user_m_tel = "";
	String user_i_tel = "";
	String user_email = "";
	String user_pos = "";
	String lic_no = "";
	String lic_dt = "";
	String enter_dt = "";
	String user_zip = "";
	String user_addr = "";
	String content = "";
	String filename = "";
	String filename2 = "";
	String user_aut2 = "";
	String user_work = "";
	String in_tel = "";
	String hot_tel = "";
	String out_dt = "";
	String taste = "";
	String special ="";
	String gundea = "";
	String area_id = "";
	int count = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	//사용자 정보 조회
	user_bean 	= umd.getUsersBean(user_id);
	user_nm 	= user_bean.getUser_nm();
	id 		= user_bean.getId();
	user_psd 	= user_bean.getUser_psd();	
	user_h_tel 	= user_bean.getUser_h_tel();
	user_m_tel 	= user_bean.getUser_m_tel();
	user_i_tel 	= user_bean.getUser_i_tel();
	user_email 	= user_bean.getUser_email();
	user_pos 	= user_bean.getUser_pos();	
	user_work 	= user_bean.getUser_work();
	in_tel		= user_bean.getIn_tel();
	hot_tel		= user_bean.getHot_tel();
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	//수정
	function UserUp(){
		var theForm = document.form1;						
		if(!confirm('수정하시겠습니까?')){ return; }
		theForm.cmd.value= "u";
		theForm.target="i_no";
		theForm.submit();
	}

	
	//우편번호 검색
	function search_zip(str){
		window.open("zip_s.jsp?idx="+str, "ZIP", "left=100, top=100, height=500, width=400, scrollbars=yes");
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
<body  onLoad="self.focus()">
<center>
<form action="./user_null_ui.jsp" name="form1" method="POST" >
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">  
  <input type="hidden" name="filename" value="<%=filename%>">
  <input type="hidden" name="user_ssn" value="">
  <input type="hidden" name="cmd" value="">
<table border=0 cellspacing=0 cellpadding=0 width=450>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > <span class=style5>사용자정보수정</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" width=450>

           	    <tr>
		            <td class=title>이름</td>
		            <td>&nbsp;<%=user_nm%></td>
			        <td class=title>ID</td>
			        <td>&nbsp;<%=id%></td>
           	    </tr>
           	    <tr>
		            <td class=title>집전화</td>
		            <td>&nbsp;<input type="text" name="user_h_tel" value="<%=user_h_tel%>" size="15" class=text></td>
			        <td class=title>휴대폰</td>
			        <td>&nbsp;<input type="text" name="user_m_tel" value="<%=user_m_tel%>" size="16" class=text></td>
           	    </tr>
				<tr>
		            <td class=title>내선번호</td>
		            <td>&nbsp;<input type="text" name="in_tel" value="<%=in_tel%>" size="15" class=text></td>
			        <td class=title>사무실(직통)</td>
			        <td>&nbsp;<input type="text" name="hot_tel" value="<%=hot_tel%>" size="16" class=text></td>
           	    </tr>
           	    
				 <tr>
		            <td class=title>직위</td>
		            <td colspan=3>&nbsp;<input type="text" name="user_pos" value="<%=user_pos%>" size="15" class=text></td>
           	    </tr>
				<tr>
		            <td class=title>팩스번호</td>
		            <td colspan=3>&nbsp;<input type="text" name="i_fax" value="<%=user_bean.getI_fax()%>" size="15" class=text style="ime-mode:disabled"></td>
           	    </tr>
			        <td class=title>이메일</td>
			        <td colspan=3>&nbsp;<input type='text' size='40' name='user_email' value='<%=user_email%>' maxlength='100' class='text' style='IME-MODE: inactive'>					  
				</td>
           	    </tr>

           	    <tr>
		            <td class=title>주민등록주소</td>
		            <td colspan=3>&nbsp;<input type="text" name="t_zip" class=text value="<%=user_bean.getZip()%>" size="7" maxlength='7' readonly onClick="javascript:search_zip('')">
		    	            &nbsp;<input type="text" name="t_addr" class=text value="<%=user_bean.getAddr()%>" size="43" style='IME-MODE: active'>
                    </td>
           	    </tr>
           	    <tr>
		            <td class=title>담당업무</td>
		            <td colspan=3>&nbsp;<textarea name="user_work" cols="51" rows="3" class="text"><%=user_work%></textarea></td>
           	    </tr>
            </table>
        </td>
    </tr>   
        <td>
            <table border="0" cellspacing="2" width=450>
                <tr>
    			    <td align="right">
    		        <a href="javascript:UserUp()"><img src=/acar/images/pop/button_modify.gif border=0></a>
     		        <a href="javascript:self.close();window.close();"><img src=/acar/images/pop/button_close.gif border=0></a>
    			    </td>
			    </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>