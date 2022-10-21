<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	//장기계약 상단정보
	LongRentBean base = ScdMngDb.getScdMngLongRentInfo(rent_mng_id, rent_l_cd);
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel='stylesheet' type='text/css' href='/include/table_t.css'>
<script src='/include/common.js'></script>
<script>
<!--
	function save()
	{
		var fm = document.form1;
		
		if(confirm('등록하시겠습니까?')){
			fm.action = "reg_eco_sticker_req_a.jsp";	
			fm.target='i_no';
			fm.submit();
		}
	}
//-->
</script>
</head>

<body>
<form action='' name='form1' method='post'>
<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
<input type='hidden' name='rent_l_cd' value='<%=rent_l_cd%>'>
<table border=0 cellspacing=0 cellpadding=0 width=600>
	<tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> <span class=style5>저공해스티커 재발급요청</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr> 	
    <tr><td class=line2></td></tr>
    <tr>
    	<td class='line'>
    		<table border=0 cellspacing=1 cellpadding=0 width=100%>
			    <tr>
			    	<td width="80" class='title'>계약번호</td>
			    	<td width="120">&nbsp;<%=rent_l_cd%></td>
			    	<td width="80" class='title'>상호</td>
			    	<td width="320">&nbsp;<%=base.getFirm_nm()%></td>
			    </tr>		
			    <tr>
			    	<td class='title'>차량번호</td>
			    	<td>&nbsp;<%=base.getCar_no()%></td>
			    	<td class='title'>차명</td>
			    	<td>&nbsp;<%=base.getCar_nm()%></td>
			    </tr>
			    <tr>		
			    	<td class='title'>주소종류</td>
			    	<td>&nbsp;
			    		<select name='post_st'>
								<option value='선택안함'>선택</option>
								<option value="사업장" selected>사업장</option>		
								<option value="자택">자택</option>
								<option value="우편물주소지">우편물주소지</option>
								<option value="기타">기타</option>
               			</select>
               		</td>
             		<td class='title'>연락처</td>
			     	<td>&nbsp;<%=base.getM_tel()%></td>
			     </tr>
               	<tr >
            		<td colspan="1" class='title' >비고</td>
			     	<td colspan="3" >&nbsp;<input type="text" name="post_etc" size="50" class="text" value=""></td>
			    </tr>
            	
			</table>
		</td>
	</tr>	
    <tr>
        <td class=h></td>
    </tr> 		
    <tr>
        <td><font color='red'>※ 등기 반송/분실 관련 신청전에 고객이 직접 수령할 주소 확인 필수</font></td>
    </tr> 		    
    <tr>
	    <td align='center'>
	    <a href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp;&nbsp;
        <a href="javascript:window.close()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
	    </td>
	</tr>			
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
			    