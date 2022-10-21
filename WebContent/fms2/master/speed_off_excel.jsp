<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
%>	
	
<html>
<head>
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//등록하기
	function save(){
		var fm = document.form1;
		
		if(fm.filename.value == ''){					alert('파일을 선택하십시오.'); 						return; 	}
		if(fm.filename.value.indexOf('xls') == -1){		alert('엑셀파일이 아닙니다.');						return;		}
		if(fm.filename.value.indexOf('xlsx') != -1){	alert('Excel97-2003통합문서(*.xls)가 아닙니다.');	return;		}
		
		fm.target = '_blank';
		
		fm.action = 'speed_off_excel_reg.jsp';		
		
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
		fm.submit();
	}
	
//-->
</script>
</head>

<body>

  <form name='form1' action='' method='post' enctype="multipart/form-data">
  <input type="hidden" name="reg_id" value="<%=user_id%>">
    <table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>ADMIN > <span class=style5>스피드메이트업체등록</span></span></td>
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
        <td align="right" class="line">
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="15%" class='title'>파일</td>
                    <td>&nbsp;
    			        <input type="file" name="filename" size="70">
                    </td>
                </tr>		
            
            </table>
		</td>
    </tr>
    <tr>
        <td align=right>* 파일확장자 <b>*.xls</b> 인 파일만 가능합니다.</td>
    </tr>	  
    <tr>
        <td align="left">&nbsp;SITE|점포명|전화번호|팩스|사업장주소|우편번호의 셀 순서로 excel파일을 작성후 해당파일을 올리세요.					
</td>
    </tr>
    <tr>
        <td align="right"><a href='javascript:save()'><img src="/acar/images/center/button_reg.gif"  align="absmiddle" border="0"></a>&nbsp;		
		</td>
    </tr>
  </table>
  </form>

</body>
</html>
