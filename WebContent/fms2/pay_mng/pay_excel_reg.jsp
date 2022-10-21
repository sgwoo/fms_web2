<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ include file="/acar/cookies.jsp"%>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
%>
	
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		theURL = "https://fms3.amazoncar.co.kr/data/doc/"+theURL;
		window.open(theURL,winName,features);
	}
	
	//네오엠 조회하기
	function ven_search(){
		var fm = document.form1;	
		window.open("/card/doc_reg/vendor_list2.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&idx=&t_wd=&from_page=/fms2/pay_mng/pay_excel_reg.jsp", "VENDOR_LIST", "left=150, top=150, width=950, height=550, scrollbars=yes");		
	}			
	
//-->
</script>
</head>

<body>

<form name='form1' action='' method='post' enctype="multipart/form-data">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 집금관리 > <span class=style5>
						출금원장[엑셀]등록</span></span></td>
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
                    <td width="100" class='title'>파일</td>
                    <td>&nbsp;
                    	 <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
    			        <a href="/fms2/pay_mng/pay_excel.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>" target="_blank"><img src=/acar/images/center/button_igdr.gif align=absmiddle border=0></a>
    			        <%}%>
                </tr>						
            </table>
		</td>
    </tr>
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td>* 파일확장자 <b>*.xls</b> 인 파일만 가능합니다.</td>
    </tr>	  
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td><a href="javascript:MM_openBrWindow('pay_excel_reg_base_form.xls','popwin_in1','scrollbars=no,status=yes,resizable=yes,menubar=yes,toolbar=yes,width=820,height=600,left=50, top=50')" title='엑셀 등록을 위한 기본양식 파일 다운받기'><img src="/acar/images/center/button_excel_bform.gif"  align="absmiddle" border="0"></a>&nbsp;		
		  : 출금원장을 엑셀을 이용해서 등록하기 위한 기본양식입니다.  다른이름으로 저장하여 내용 작성후 등록에 사용하시기 바랍니다.
		  --> 2017-12-01 사용자들 빼고 참고금액1~5 추가함.
		</td>
    </tr>	
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td><a href="javascript:ven_search()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_search_nglc.gif"  align="absmiddle" border="0"></a>&nbsp;		
		  : 네오엠 거래처 코드를 조회하는 화면을 팝업합니다. 엑셀파일 작성시 참고하세요.
		</td>
    </tr>
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td><font color=red>* 엑셀양식이 기본양식과 틀릴 경우 정상적으로 등록이 되지 않습니다.</font></td>
    </tr>
	
  </table>
  </form>

</body>
</html>
