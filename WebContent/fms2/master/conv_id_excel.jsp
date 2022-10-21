<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
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
		
		if(fm.gubun1[0].checked == true) 		fm.action = 'conv_busid2_excel_reg.jsp';	
		if(fm.gubun1[1].checked == true) 		fm.action = 'conv_mngid2_excel_reg.jsp';
		if(fm.gubun1[2].checked == true) 		fm.action = 'conv_busidmngid_excel_reg.jsp';
		//fm.action = 'conv_busid2_excel_reg.jsp';		
		
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
		fm.submit();
	}
	
//-->
</script>
</head>

<body>
<div class="navigation">
	<span class=style1>ADMIN ></span><span class=style5>담당자배정</span>
</div>
  <form name='form1' action='' method='post' enctype="multipart/form-data">
    <table border="0" cellspacing="0" cellpadding="0" width=100%>

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
                <tr>
                    <td class='title'>구분</td>
                    <td>&nbsp;
			        <input type="radio" name="gubun1" value="1" >
                    영업담당자 변경
			        <input type="radio" name="gubun1" value="2" >
                    예비관리담당자 변경
					<input type="radio" name="gubun1" value="3" >
                    예비관리담당자를 영업담당자+관리담당자로 변경
			        </td>
                </tr>
            </table>
		</td>
    </tr>
    <tr>
        <td align=right>* 파일확장자 <b>*.xls</b> 인 파일만 가능합니다.</td>
    </tr>	  
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>엑셀폼</span></td>
    </tr>    
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                	  <td class=title width=30%>구분</td>
                    <td class=title width=10%>A</td>
                    <td class=title width=10%>B</td>
                    <td class=title width=50%>-</td>
                </tr>
                <tr> 
                	  <td class=title>영업담당자 변경</td>
                    <td align='center'>rent_l_cd</td>
                    <td align='center'>bus_nm2</td>
                    <td align='center'>-</td>
                </tr>          
                <tr> 
                	  <td class=title>예비관리담당자 변경</td>
                    <td align='center'>rent_l_cd</td>
                    <td align='center'>mng_nm2</td>
                    <td align='center'>(고객 문자발송 없음)</td>
                </tr>       
                <tr> 
                	  <td class=title>예비관리담당자를 영업담당자+계약담당자로 변경</td>
                    <td align='center'>rent_l_cd</td>
                    <td align='center'>mng_nm2</td>
                    <td align='center'>-</td>
                </tr>                                             
            </table>
	    </td>
    </tr>    
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right"><input type="checkbox" name="sms_ok" value="Y" checked >고객에게 담당자 변경문자를 보냅니다.<br/><a href='javascript:save()'><img src="/acar/images/center/button_reg.gif"  align="absmiddle" border="0"></a>&nbsp;		
		</td>
    </tr>
  </table>
  </form>
</center>
</body>
</html>
