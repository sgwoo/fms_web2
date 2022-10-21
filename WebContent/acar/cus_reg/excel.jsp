<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id 		= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	String gubun1 		= "1";
	
	if(ck_acar_id.equals("000143")){	//정일현대자동차정비공업
		gubun1 = "2";
	}
	if(ck_acar_id.equals("000106")){	//부경자동차정비
		gubun1 = "3";
	}
	if(ck_acar_id.equals("000154")){	//오토크린
		gubun1 = "4";
	}
	
%>
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

		if(fm.filename.value == ''){					alert('파일을 선택하십시오.'); 						return; 	}		
		if(fm.filename.value.indexOf('xls') == -1){		alert('엑셀파일이 아닙니다.');						return;		}		
		if(fm.filename.value.indexOf('xlsx') != -1){	alert('Excel97-2003통합문서(*.xls)가 아닙니다.');	return;		}		
		
		if(!confirm("해당 파일을 등록하시겠습니까?"))	return;
		fm.action = 'excel_item_2010.jsp';		
			
		if(fm.gubun1[0].checked == true)		fm.action = 'excel_item_2010.jsp';		
		else if(fm.gubun1[1].checked == true)	fm.action = 'excel_item_2010_autofor.jsp';		
		else if(fm.gubun1[2].checked == true)	fm.action = 'excel_item_2011_autofor.jsp';		
		else if(fm.gubun1[3].checked == true)	fm.action = 'excel_item_2011_autoseven.jsp';		
		else if(fm.gubun1[4].checked == true)	fm.action = 'excel_item_2016_new.jsp';	
		else if(fm.gubun1[5].checked == true)	fm.action = 'excel_item_2020_new.jsp';		
		else if(fm.gubun1[6].checked == true)	fm.action = 'excel_item_2020_new2.jsp';		
		else if(fm.gubun1[7].checked == true)	fm.action = 'excel_item_2019_new.jsp';	
		else if(fm.gubun1[8].checked == true)	fm.action = 'excel_item_2019_new2.jsp';	
		else if(fm.gubun1[9].checked == true)	fm.action = 'excel_item_2021_new.jsp';	
		
		fm.submit();
	}
//-->
</script>
</head>

<body>
<center>
  <form name='form1' action='' method='post' enctype="multipart/form-data">
  <input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>   
  <input type='hidden' name='serv_id' 		value='<%=serv_id%>'>   
  <input type='hidden' name='user_id' 		value='<%=ck_acar_id%>'>     
<table border="0" cellspacing="0" cellpadding="0" width=570>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>고객지원 > 자동차정비등록 > <span class=style5>엑셀파일을 이용한 청구서 처리</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
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
                 
               	      <input type="radio" name="gubun1" value="1" > 아래콤 AOS 
	    			  <input type="radio" name="gubun1" value="2" > 오토포2010 
	    			  <input type="radio" name="gubun1" value="3" > 오토포2011 
					  <input type="radio" name="gubun1" value="4" > 오토세븐  (오토크린)
	               	  <input type="radio" name="gubun1" value="5" > new 
	               	  <input type="radio" name="gubun1" value="6" > 오토포2020(작업C,수량M,부품Z,공임AD)
	               	  <input type="radio" name="gubun1" value="7" > 오토포2020 new   
	               	  <input type="radio" name="gubun1" value="8" > AOS2019   
	               	  <input type="radio" name="gubun1" value="9" > AOS2019(작업C,수량L,부품W,공임Z)    
	               	  <input type="radio" name="gubun1" value="10" > AOS2021(작업D,수량P,부품AA,공임AD)            
               	          
               	     
				</td>
                </tr>
            </table>
		</td>
    </tr>
    <tr>
        <td>* 파일확장자 <b>*.xls</b> 인 파일만 가능합니다.</td>
    </tr>
    <tr>
        <td>* 오토포 : 엑셀파일로 다운받은것 </td>
    </tr>
    <tr>
        <td align="right"><a href='javascript:save()'><img src=../images/center/button_reg.gif border=0 align=absmiddle></a>
		<a href='javascript:window.close()'><img src=../images/center/button_close.gif border=0 align=absmiddle></a></td>
    </tr>
</table>
  </form>
</center>
</body>
</html>
