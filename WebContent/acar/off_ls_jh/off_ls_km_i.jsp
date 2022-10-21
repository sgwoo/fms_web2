<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.watch.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String park_id 	= request.getParameter("park_id")==null?"":request.getParameter("park_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
%>
<HTML>
<HEAD>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table_t.css">

<script language='javascript'>
<!--
function save()
{
	var theForm = document.from;
	if(theForm.km.value == ''||theForm.km.value == '0'||theForm.km.value == ' ')						{	alert('정확한 주행거리를 입력하십시오');			theForm.km.focus(); 		return;	}
	if(theForm.car_arr_id.value == '') {	alert('경매장을 선택하십시오');			theForm.car_arr_id.focus(); 		return;	}
	if(!confirm('등록하시겠습니까?'))
	{
		return;
	}
	
	theForm.target = "i_no";
	theForm.submit();
}

//-->
</script>
<script language="JavaScript" src="/include/common.js"></script>
</HEAD>
<BODY onLoad="javascript:document.from.km.focus();">
<form action="off_ls_km_a.jsp" name='from' method='post'>
    <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">
	<input type="hidden" name="park_id" value="<%=park_id%>">
	<input type="hidden" name="user_id" value="<%=user_id%>">
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>오프리스 > 매각결정차량현황 >  <span class=style5>주행거리 / 경매장 출고 등록</span></span></td>
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
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="" class='title'>경매차량 최종주행거리</td>
                    <td>&nbsp;<input type="text" name="km" value="" class="num">km</td>
                </tr>
				<tr> 
                    <td width="" class='title'>경매장 탁송완료일자</td>
                    <td>&nbsp;<input type="text" name="car_out_dt" value="<%=AddUtil.getDate()%>"></td>
                </tr>
				<tr> 
                    <td width="" class='title'>기타사유</td>
                    <td>&nbsp;<input type="text" name="car_gita" value=""></td>
                </tr>
				<tr> 
                    <td width="" class='title'>경매장</td>
                    <td>&nbsp;
	                    <select name="car_arr_id">
			                <option value="">선택</option>
			                <option value="000502">현대글로비스(주)-시화</option>
							<option value="013011">현대글로비스(주)-분당</option>
			                <option value="020385">에이제이셀카(주)</option>
							<option value="022846">롯데렌탈((구)케이티렌탈)</option>
			           </select>
                    </td>
                </tr>
            </table>
        </td>
	</tr>
	<tr>
		<td align="right"><a href="javascript:save()"><img src=/acar/images/center/button_reg.gif border=0  align=absmiddle></a></td>
	</tr>
</table>

</form>

<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe> 
</BODY>
</HTML>
