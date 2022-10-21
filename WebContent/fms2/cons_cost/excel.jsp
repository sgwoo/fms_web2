<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//등록하기
	function save(){
		var fm = document.form1;
		
		if(fm.filename.value == ''){			alert('파일을 선택하십시오.'); 				return; 	}
		if(fm.filename.value.indexOf('xls') == -1){	alert('엑셀파일이 아닙니다.');				return;		}
		if(fm.filename.value.indexOf('xlsx') != -1){	alert('Excel97-2003통합문서(*.xls)가 아닙니다.');	return;		}
				
		if(fm.gubun1[0].checked == true)			fm.action = 'excel_reg.jsp';	
		else if(fm.gubun1[1].checked == true)			fm.action = 'excel_reg2.jsp';	
			
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
		fm.submit();
	}
//-->
</script>
</head>

<body>
<center>
  <form name='form1' action='' method='post' enctype="multipart/form-data">
    <table border="0" cellspacing="0" cellpadding="0" width=870>
      <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;Master > 출고탁송관리 > <span class=style1><span class=style5>엑셀일괄등록</span></span></td>
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
    			        <input type="file" name="filename" size="50">
                    </td>
                </tr>			
                <tr>
                    <td class='title'>구분</td>
                    <td>&nbsp;
			        <input type="radio" name="gubun1" value="1" checked>
                    출고탁송료
					
				    <input type="radio" name="gubun1" value="2" checked>
                    출고대리인
			        </td>
                </tr>
            </table>
		</td>
    </tr>
    <tr>
        <td align="center">* 파일확장자 <b>*.xls</b> 인 파일만 가능합니다.</td>
    </tr>	  
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right"><a href='javascript:save()'><img src="/acar/images/center/button_reg.gif"  align="absmiddle" border="0"></a>&nbsp;
		<a href='javascript:window.close()'><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a></td>
    </tr>
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
  <tr>
    <td align="center"><span class="style1">- 출고탁송료 양식폼 - </span></td>
  </tr>
  <tr>
    <td class="line">
	  <table width=100% border="0" cellspacing="1" cellpadding="0">
        <tr>
          <td width="10%" class="title">제조사</td>
          <td width="20%" class="title">차명</td>		  
          <td width="10%" class="title">출하장</td>
          <td width="12%" class="title">서울본사</td>
          <td width="12%" class="title">부산지점</td>
          <td width="12%" class="title">대전지점</td>
          <td width="12%" class="title">대구지점</td>
          <td width="12%" class="title">광주지점</td>
        </tr>
      </table></td>
  </tr>  
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">&nbsp;</td>
    </tr>
  <tr>
    <td align="center"><span class="style1">- 출고대리인 양식폼 - </span></td>
  </tr>
  <tr>
    <td class="line">
	  <table width=100% border="0" cellspacing="1" cellpadding="0">
        <tr>
          <td width="20%" class="title">제조사</td>
          <td width="20%" class="title">출고사무소</td>		  
          <td width="20%" class="title">성명</td>
          <td width="20%" class="title">생년월일</td>
          <td width="20%" class="title">전화번호</td>
        </tr>
      </table></td>
  </tr>    
  <tr>
    <td><hr></td>
  </tr>    
  </table>
  </form>
</center>
</body>
</html>
