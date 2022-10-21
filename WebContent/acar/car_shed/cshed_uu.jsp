<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.car_shed.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.car_shed.CarShedDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String brch 	= request.getParameter("brch")==null?"":request.getParameter("brch");
	String shed_id = request.getParameter("shed_id")==null?"":request.getParameter("shed_id");
	
	
	Hashtable ht = cs_db.getCarShedlist(shed_id);
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--

	function save()
	{
		if(confirm('등록하시겠습니까?'))
		{
			var fm = document.form1;
			fm.target='i_no';
			fm.submit();
		}
	}
	
	//목록가기
	function go_to_list(){
		var fm = document.form1;
		fm.target = 'd_content';
		fm.action = '/acar/car_shed/cshed_frame_s.jsp';
		fm.submit();
	}	
	
	//금액 셋팅
	function set_amt(){
		var fm = document.form1;	
		
			fm.hsjsg_amt.value 	= toInt(parseDigit(fm.bjg_amt.value)) + (toInt(parseDigit(fm.wsg_amt.value)) * 100);

		}	
//-->
</script>
</head>
<body leftmargin="15">
<form action="/acar/car_shed/cshed_u_a.jsp" name="form1" method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='brch' value='<%=brch%>'>
<input type='hidden' name='shed_id' value='<%=shed_id%>'>
<input type='hidden' name='zip_idx' value=''>
<input type='hidden' name='shed_st' value='2'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > 코드관리 > <span class=style5>사무실계약사항등록</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
	<tr>
        <td></td>
    </tr>
	<tr>
    	<td align=right>
    		<a href="javascript:save()" onMouseOver="window.status=''; return true"><img src=../images/center/button_modify.gif border=0 align=absmiddle></a>
    		<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src=../images/center/button_list.gif border=0 align=absmiddle></a>
    	</td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr>
    	<td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>사무실계약사항</span>&nbsp;&nbsp;&nbsp;&nbsp;</td>

    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
    	<td class=line>
    		<table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width=12%>건물명칭</td>
               		<td width=21%>&nbsp;<input type="text" name="shed_nm" value="<%=ht.get("SHED_NM")%>" size="30" maxlength='20' class=text></td>
               		<td class=title width=12%>소유자(임대인)</td>
               		<td width=20%>&nbsp;<input type="text" name="lea_nm" value="<%=ht.get("LEA_NM")%>" size="30" maxlength='30' class=text></td>
               		<td class=title width=12%>보증금</td>
               		<td width=23%>&nbsp;<input type="text" name="bjg_amt" value="<%=Util.parseDecimal(String.valueOf(ht.get("BJG_AMT")))%>" size="25" maxlength='30' class=num></td>
                </tr>
                <tr>
                    <td class=title>계약기간</td>
               		<td>&nbsp;<input type="text" name="lea_st_dt" value="<%=ht.get("LEA_ST_DT")%>" size=12 maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' class='text'> - <input type="text" name="lea_end_dt" value="<%=ht.get("LEA_END_DT")%>" size=10 maxlength='10' onBlur='javascript:this.value=ChangeDate(this.value)' class='text'></td>
               		<td class=title>임대료지급약정일자</td>
               		<td>&nbsp;<input type="text" name="im_in_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(ht.get("IM_IN_DT")))%>" size="20" maxlength='10' class=text></td>
               		<td class=title>월세금</td>
               		<td>&nbsp;<input type="text" name="wsg_amt" value="<%=Util.parseDecimal(String.valueOf(ht.get("WSG_AMT")))%>" size="25" maxlength='30' class=num onBlur='javascript: set_amt();'></td>
                </tr>
                <tr>
                    <td class=title>지점명</td>
               		<td>&nbsp;<select name="mng_off">
						<option value='' <%if(ht.get("MNG_OFF").equals(""))%> selected <%%>>전체</option>
						<option value='S1' <%if(ht.get("MNG_OFF").equals("S1"))%> selected <%%> >본사</option>
						<option value='K2' <%if(ht.get("MNG_OFF").equals("K2"))%> selected <%%> >포천영업소</option>
						<option value='K1' <%if(ht.get("MNG_OFF").equals("K1"))%> selected <%%> >파주영업소</option>
						<option value='D1' <%if(ht.get("MNG_OFF").equals("D1"))%> selected <%%> >대전지점</option>
						<option value='B1' <%if(ht.get("MNG_OFF").equals("B1"))%> selected <%%> >부산지점</option>
						<option value='N1' <%if(ht.get("MNG_OFF").equals("N1"))%> selected <%%> >김해영업소</option>
						<option value='I1' <%if(ht.get("MNG_OFF").equals("I1"))%> selected <%%> >인천지점</option>
						<option value='S2' <%if(ht.get("MNG_OFF").equals("S2"))%> selected <%%> >강남지점</option>
						<option value='J1' <%if(ht.get("MNG_OFF").equals("J1"))%> selected <%%> >광주지점</option>
						<option value='G1' <%if(ht.get("MNG_OFF").equals("G1"))%> selected <%%> >대구지점</option>
						<option value='K3' <%if(ht.get("MNG_OFF").equals("K3"))%> selected <%%> >수원지점</option>
						</select></td>
                    <td class=title>권역구분</td>
               		<td>&nbsp;<select name="lend_region">
						<option value="수도권" <%if(ht.get("LEND_REGION").equals("수도권"))%> selected <%%>>수도권</option>
						<option value="수도권외" <%if(ht.get("LEND_REGION").equals("수도권외"))%> selected <%%>>수도권외</option>
						</select>
					</td>
					<td class=title>환산전세금</td>
               		<td>&nbsp;<input type="text" name="hsjsg_amt" value="<%=Util.parseDecimal(String.valueOf(ht.get("HSJSG_AMT")))%>" size="25" maxlength='30' class=num></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
        <td></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
    	<td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width=12%>차고지명칭</td>
                    <td width=24%>&nbsp;<input type="text" name="car_lend" value="<%=ht.get("CAR_LEND")%>" size="35" maxlength='120' class=text></td>
                    <td class=title width=12%>임대료(월세금)</td>
                    <td width=20%>&nbsp;<input type="text" name="car_lend_amt" value="<%=Util.parseDecimal(String.valueOf(ht.get("CAR_LEND_AMT")))%>" size="20" maxlength='120' class=num></td>
                    <td class=title width=14%>임대료지급약정일자</td>
                    <td width=18%>&nbsp;<input type="text" name="car_lend_dt" value="<%=AddUtil.ChangeDate2(String.valueOf(ht.get("CAR_LEND_DT")))%>" size="20" maxlength='20' class=text></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
