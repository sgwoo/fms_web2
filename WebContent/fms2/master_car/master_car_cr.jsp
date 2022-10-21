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
	
	//자동차세 지출처리
	function pay_save(){
		var fm = document.form1;		
		if(fm.gjyj_dt.value == ''){					alert('지출예정일자를 입력하십시오.');				return; 	}		
		if(fm.gj_dt.value == ''){						alert('지출일자를 입력하십시오.');					return; 	}				
		fm.action = 'excel_all_pay_a.jsp';					
		if(!confirm("지출처리하시겠습니까?"))	return;
		fm.submit();
	}	

//-->
</script>
</head>

<body>
<center>
  <form name='form1' action='' method='post' enctype="multipart/form-data">
    <table border="0" cellspacing="0" cellpadding="0" width=100%>
      <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;협력업체 > 긴급출동관리 > 비용처리 > <span class=style1><span class=style5>엑셀파일을 이용한 기타비용 납부처리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동차세 일괄 지출처리</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
                <tr>
                    <td class=title width=20%>지출예정일자</td>
                    <td>&nbsp;<input type='text' name='gjyj_dt' class='text' size='11' maxlength='10' onBlur='javascript:this.value = ChangeDate(this.value);'></td>
                    <td class=title width=20%>지&nbsp;&nbsp;출&nbsp;&nbsp;일&nbsp;&nbsp;자</td>
                    <td>&nbsp;<input type='text' name='gj_dt' class='text' size='11' maxlength='10' onBlur='javascript:this.value = ChangeDate(this.value);'></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td align=right><a href='javascript:pay_save()'><img src=/acar/images/center/button_gccr.gif border=0 align=absmiddle></a></td>	
    </tr>
   
  </table>
  </form>
</center>
</body>
</html>
