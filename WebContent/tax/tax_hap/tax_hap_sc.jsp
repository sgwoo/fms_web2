<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function view_tax(enp_no, idx){	
	//   alert(enp_no);
		var fm = document.form1;
		fm.s_kd.value = '4';
		fm.t_wd1.value = enp_no;
		fm.idx.value = idx;
		if(fm.gubun1.value != '' && fm.gubun2.value == '' && fm.gubun3.value == '' ){
		  fm.st_dt.value = fm.gubun1.value+'0101';
		  fm.end_dt.value = fm.gubun1.value+'1231';
		}else if(fm.gubun1.value != '' && fm.gubun2.value != '' && fm.gubun3.value == '' ){
		  if(fm.gubun2.value == '1'){
  		  fm.st_dt.value = fm.gubun1.value+'0101';
	  	  fm.end_dt.value = fm.gubun1.value+'0331';
		  }else if(fm.gubun2.value == '2'){
  		  fm.st_dt.value = fm.gubun1.value+'0401';
	  	  fm.end_dt.value = fm.gubun1.value+'0630';
		  }else if(fm.gubun2.value == '3'){
  		  fm.st_dt.value = fm.gubun1.value+'0701';
	  	  fm.end_dt.value = fm.gubun1.value+'0930';
		  }else if(fm.gubun2.value == '4'){
  		  fm.st_dt.value = fm.gubun1.value+'1001';
	  	  fm.end_dt.value = fm.gubun1.value+'1231';
		  }
		}else{
		  fm.st_dt.value = fm.gubun1.value+''+fm.gubun3.value+'01';
		  fm.end_dt.value = fm.gubun1.value+''+fm.gubun3.value+'31';
		}
		fm.gubun1.value = '1';		
		fm.submit();
	}
	function view_tax_popup(enp_no, idx){
		fm = document.form1;
		window.open("about:blank",'view_tax','scrollbars=yes,status=no,resizable=yes,width=900,height=500,left=50,top=50');
		fm.target = "view_tax";
		fm.action = "tax_hap_c.jsp?enp_no="+enp_no;
		fm.submit();
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	int cnt = 5; //현황 출력 영업소 총수
	//if(cnt > 0 && cnt < 5) cnt = 5; //기본 
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*25)-240;//현황 라인수만큼 제한 아이프레임 사이즈
%>
<form name='form1' action='../tax_mng/tax_mng_frame.jsp' method='post' target='d_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='idx' value='<%=idx%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td height="<%=height%>"><iframe src="tax_hap_sc_in.jsp<%=hidden_value%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        </iframe> </td><!--모니터높이 - sh 길이 - 상단메뉴 길이 - (라인수*40)-->
    </tr>  
    <tr> 
        <td class=h></td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr>
        <td class='line'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width="22%" align='center' class="title">구분</td>
                    <td width="19%" align='center' class="title">매출처수</td>
                    <td width="19%" align='center' class="title">매수</td>
                    <td width="20%" align='center' class="title">공급가액</td>
                    <td width="20%" align='center' class="title">세액</td>
                </tr>
                <tr>
                    <td align='center' class="title">합계</td>
                    <td align='center'><input type="text" name="client_cnt" class="whitenum" size="9"></td>
                    <td align='center'><input type="text" name="tax_cnt" class="whitenum" size="9"></td>
                    <td align='center'><input type="text" name="tax_supply" class="whitenum" size="18"></td>
                    <td align='center'><input type="text" name="tax_value" class="whitenum" size="18"></td>
                </tr>
                <tr>
                    <td align='center' class="title">사업자등록번호발행분</td>
                    <td align='center'><input type="text" name="client_cnt" class="whitenum" size="9"></td>
                    <td align='center'><input type="text" name="tax_cnt" class="whitenum" size="9"></td>
                    <td align='center'><input type="text" name="tax_supply" class="whitenum" size="18"></td>
                    <td align='center'><input type="text" name="tax_value" class="whitenum" size="18"></td>
                </tr>
                <tr>
                    <td align='center' class="title">주민등록번호발행분</td>
                    <td align='center'><input type="text" name="client_cnt" class="whitenum" size="9"></td>
                    <td align='center'><input type="text" name="tax_cnt" class="whitenum" size="9"></td>
                    <td align='center'><input type="text" name="tax_supply" class="whitenum" size="18"></td>
                    <td align='center'><input type="text" name="tax_value" class="whitenum" size="18"></td>
                </tr>
            </table>
	    </td>
    </tr>	  	
</table>
</form>
</body>
</html>
