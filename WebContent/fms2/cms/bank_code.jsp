<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cms.*" %>

<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	//사용자별 정보 조회 및 수정 페이지
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	
	//등록
	function CodeReg(){
		var fm = document.form1;
		fm.cmd.value = "i";		
	
		if(fm.reg_dt.value!=""){	alert("수정만이 가능합니다.");	return;	}
		if(!CheckField()){	return;	}
		if(!confirm('등록하시겠습니까?')){
			return;
		}
		fm.target = "i_no"
		fm.submit();
	}

	//수정
	function CodeUp(){
		var fm = document.form1;
		fm.cmd.value = "u";		
		if(fm.reg_dt.value==""){	alert("등록만이 가능합니다.");	return;	}
		if(!CheckField()){	return;	}
		if(!confirm('수정하시겠습니까?')){
			return;
		}
		fm.target = "i_no";
		fm.submit();
	}

	function ClearM(){
		var fm = document.form1;
		fm.bcode.value = '';
		fm.bname.value = '';
		fm.c_code.value = '';		
	}
	
	//입력값 null 체크
	function CheckField(){
		var fm = document.form1;
		if(fm.bcode.value==""){	alert("이체은행코드를 입력하십시요");		fm.bcode.focus();	return false;	}
		if(fm.bname.value==""){	alert("이체은행명칭을 입력하십시요");	fm.bname.focus();	return false;	}
		
		return true;
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
<form action="./bank_code_null_ui.jsp" name="form1" method="POST" >
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">  
  <input type="hidden" name="cmd" value="">
  <input type="hidden" name="reg_dt" value="">
<table border=0 cellspacing=0 cellpadding=0 width=98%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> 재무회게 > CMS > <span class=style5>CMS참가 은행관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    
     <tr>
		<td>
			<iframe src="/fms2/cms/bank_code_in.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>" name="i_no" width="100%" height="650" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling='yes' marginwidth='0' marginheight='0'></iframe>
		</td>
	</tr>
	
	  <tr>        
        <td></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>			
    <tr>		
        <td> 
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>					
                    <td class='line' width="100%"> 
                        <table  border=0 cellspacing=1 width="100%">
                            <tr> 
                                <td class=title>이체은행코드</td>
                                <td>&nbsp; 
                                    <input type="text" name="bcode" size="3" value="" class="text">
                                </td>
                                                            
                                <td class=title >이체은행명칭</td>
                                <td>&nbsp; 
                                    <input type="text" name="bname" value="" size="30" class="text" >
                                </td>
                                <td class=title >FMS은행코드</td>
                                <td>&nbsp; 
                                    <input type="text" name="c_code" size="4" class="text"></td>
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
        <td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr>			    	
					<td class=title colspan=3>
					  <a href="javascript:CodeReg()"><img src=/acar/images/center/button_reg.gif  align=absmiddle></a> 		
					<a href="javascript:CodeUp()"><img src=/acar/images/center/button_save.gif  align=absmiddle></a> 		
					  <a href="javascript:ClearM()"><img src=/acar/images/center/button_init.gif border=0 align=absmiddle></a> 
					</td>
				</tr>
			</table>
		</td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>