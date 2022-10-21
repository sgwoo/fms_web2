<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head><title>FMS</title>

<script language='javascript'>
<!--
	function save(work_st)
	{
		var fm = document.form1;
		
		if(work_st == '') { alert('무엇을 작업합니까? 알 수 없습니다.'); return;}
		
		if(work_st == 'search1'){
			fm.action = 'acar_car_excel_list.jsp';
			fm.work_st.value = work_st;
			form1.target = "_blank";
			
		}else if(work_st == 'search2'){
			fm.action = 'acar_car_excel_list2.jsp';
			fm.work_st.value = work_st;
			form1.target = "_blank";
			
		}else if(work_st == 'search3'){
			fm.action = 'acar_car_list.jsp';
			fm.work_st.value = work_st;
			form1.target = "_blank";
		
		}else if(work_st == 'search4'){
			fm.action = 'acar_car_list2.jsp';
			fm.work_st.value = work_st;
			form1.target = "_blank";
			
		}else if(work_st == 'search5'){
			fm.action = 'acar_car_list3.jsp';
			fm.work_st.value = work_st;
			form1.target = "_blank";
			
		}else if(work_st == 'search6'){
			fm.action = 'acar_car_excel_list3.jsp';
			fm.work_st.value = work_st;
			form1.target = "_blank";
		
		}else if(work_st == 'search11'){
			fm.action = 'anycar_excel11.jsp';
			fm.work_st.value = work_st;
			form1.target = "_blank";
		
		}else if(work_st == 'search12'){
			fm.action = 'anycar_excel12.jsp';
			fm.work_st.value = work_st;
			form1.target = "_blank";
		
		}else if(work_st == 'search13'){
			fm.action = 'anycar_excel13.jsp';
			fm.work_st.value = work_st;
			form1.target = "_blank";
			
		}else{
			return;
		}
		
		
			form1.submit();
	}

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String	to_dt 	= AddUtil.getDate(1)+""+AddUtil.getDate(2)+""+AddUtil.getDate(3);		
	String  st_dt = "";
	String  std_dt = "";
	String  end_dt = "";
	
	st_dt = ad_db.getWortPreDay(to_dt, 7);	
	end_dt = ad_db.getWortPreDay(to_dt, 1);				
	
%>
<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='work_st' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>협력업체 > <span class=style5>애니카제출자료</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	    <td>&nbsp;</td>
    </tr>
    <tr>
	    <td><table width=100% border=0 cellspacing=1 cellpadding=0>
          <tr>
            <td width="200" rowspan="5" align="center" valign="middle"><img src=/acar/images/center/anycar_logo.jpg align=absmiddle border=0 width='140' height='45'></td>
            <td><b>·</b> 담당자 : 조상욱 대리 </td>
          </tr>
          <tr>
            <td><b>·</b> TEL : 02-2119-2435 </td>
          </tr>
          <tr>
            <td><b>·</b> H.P : 010-3333-9123 </td>
          </tr>
		  <tr>
            <td><b>·</b> email : crywolf@samsungfire.com </td>
          </tr>
		  <tr>
            <td><b>·</b> 긴급출동 TEL : 02-2119-3117 </td>
          </tr>
          <tr>
            <td align="center" valign="middle"><b>삼성애니카</b></td>

          </tr>
        </table></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>긴급출동 관련리스트 조회</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
                <tr>
                    <td width=5% class=title style='height:30'>1</td> 
	                <td>&nbsp;
                	  <b>현재 보유차량 </b> <font color=red>리스트 조회</font> : 1. 리스트 열기 &nbsp;<a href="javascript:save('search3')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. 엑셀파일 열기 &nbsp;<a href="javascript:save('search1')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
	                </td>
	            </tr>				
	        </table>
	    </td>
    </tr>
    <tr>
	    <td class='h'>&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
                <tr>
                    <td width=5% class=title style='height:30'>2</td> 
	                <td>&nbsp;
                	  <select name="s_kd">
                	
                		<option value="2" >기간</option>
                	  </select>&nbsp;&nbsp;
					  <input type='text' size='11' name='std_dt'   class='text' value='<%=AddUtil.getDate(1)+""+AddUtil.getDate(2)+"01"%>' >
                      ~ 
            		  <input type='text' size='11' name='end_dt'  class='text' value='<%=end_dt%>'>
					 <b> 등록/매각 차량 </b> <font color=red>리스트 조회</font> : 1. 리스트 열기 &nbsp;<a href="javascript:save('search5')" ><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2. 엑셀파일 열기 &nbsp;<a href="javascript:save('search6')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
					 
	                </td>
	            </tr>				
	        </table>
	    </td>
    </tr>
    <tr>
	    <td>&nbsp;</td>
    </tr>
	<tr>
      <td>&nbsp;</td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정비 관련리스트 조회</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
                <tr>
                    <td width=5% class=title style='height:30'>1</td> 
	                <td>&nbsp;
                	  <b>일반식 보유차량 전체</b> <font color=red>리스트 조회</font> : 엑셀파일 열기 &nbsp;<a href="javascript:save('search11')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
	                </td>
	            </tr>				
	        </table>
	    </td>
    </tr>
    <tr>
	    <td class='h'>&nbsp;</td>
    </tr>
		<tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
                <tr>
                    <td width=5% class=title style='height:30'>2</td> 
	                <td>&nbsp;
                	  <select name="s_kd">
                	  	<option value="1" selected>당월</option>
                		<option value="2" >기간</option>
                	  </select>&nbsp;&nbsp;
					  <input type='text' size='11' name='st_dt' class='text' value='<%=AddUtil.getDate(1)+""+AddUtil.getDate(2)+"01"%>'>
                      ~ 
            		  <input type='text' size='11' name='end_dt' class='text' value='<%=end_dt%>'>
					 <b> 신규/해지 일반식 차량 </b> <font color=red>리스트 조회</font> : 엑셀파일 열기 &nbsp;<a href="javascript:save('search12')"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a>
	                </td>
	            </tr>
	        </table>
	    </td>
    </tr>
    <tr>
	    <td>&nbsp;</td>
    </tr>
    <tr>
	    <td>&nbsp;</td>
    </tr>
	<tr> 
        <td class=h></td>
    </tr>
	<%if(!user_id.equals("000141")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>정비내역 등록</span></td>
    </tr>
	<tr>
		
		<td colspan="2">&nbsp;&nbsp;&nbsp;삼성애니카 정비내역 엑셀로 등록 :

            		<a href="javascript:var win=window.open('an_excel.jsp?user_id=<%=user_id%>','popup','left=10, top=10, width=600, height=200, status=no, scrollbars=no, resizable=no');"><img src=/acar/images/center/button_reg_excel.gif align=absmiddle border=0></a>&nbsp;

        </td>
	</tr>
	<%}%>
    <tr> 
        <td class=h></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
