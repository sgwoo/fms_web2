<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");	

	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//등록하기
	function save(){
		var fm = document.form1;
		if(fm.filename.value == ''){					alert('파일을 선택하십시오.'); 						return; 	}
		if(fm.filename.value.indexOf('xls') == -1 && fm.filename.value.indexOf('xlsx') == -1) {		alert('엑셀파일이 아닙니다.');		return;	}
		
		fm.action = 'in_excel_reg.jsp';
		
		if(fm.gubun1[1].checked == true){			fm.action = 'in_excel_reg_deep.jsp';	}	
		
		fm.target = '_blank';	
			
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
		fm.submit();
	}
	
	
//-->
</script>
</head>

<body>
<center>
  <form name='form1' action='' method='post' enctype="multipart/form-data">
    <input type='hidden' name='user_id' value='<%=user_id%>'>
    <table border="0" cellspacing="0" cellpadding="0" width=570>
      <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;고객지원 > 과태료관리 > <span class=style1><span class=style5>엑셀파일 등록</span></span></td>
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
                    <td colspan="2">&nbsp;
    			        <input type="file" name="filename" size="50">
                    </td>
                </tr>			
                <tr>
                    <td class='title' rowspan='2'>구분</td>
                    <td>&nbsp;
				    <input type="radio" name="gubun1" value="1"  checked>낙찰현황 등록
			        </td>
					<td align="center"></td>
                </tr>
                <tr>
                    <td>&nbsp;
				    <input type="radio" name="gubun1" value="2" <%if(from_page.equals("/acar/off_ls_cmplt/off_ls_stat_grid_sc.jsp")){ %>checked<%}%>>딥러닝 예측낙찰가 등록
			        </td>
					<td align="center"></td>
                </tr>
            </table>
		</td>
    </tr>
    <tr>
        <td align=right>* 엑셀 파일만 가능합니다.</td>
    </tr>	  
    <tr>
        <td class=h>&nbsp;</td>
    </tr>
    <tr>
        <td align="right"><a href='javascript:save()'><img src="/acar/images/center/button_reg.gif"  align="absmiddle" border="0"></a>&nbsp;
		<a href='javascript:window.close()'><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
  </table>
  </form>
</center>
</body>
</html>
