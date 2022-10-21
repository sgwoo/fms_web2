<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*, acar.util.*"%>
<%@ page import="acar.car_shed.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.car_shed.CarShedDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String brch 	= request.getParameter("brch")==null?"":request.getParameter("brch");
	
	String shed_id = request.getParameter("shed_id")==null?"":request.getParameter("shed_id");
	
	CarShedBean shed = cs_db.getCarShed(shed_id);
	CommonDataBase c_db = CommonDataBase.getInstance();
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function go_to_modify()
	{
		location = '/acar/car_shed/cshed_u.jsp??auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&brch=<%=brch%>&shed_id='+document.form1.shed_id.value;
	}
	
	function go_to_list()
	{
		location = '/acar/car_shed/cshed_frame_s.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&brch=<%=brch%>';
	}
//-->
</script>
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
</head>
<body leftmargin="15">
<form name="form1" method="POST">
<input type='hidden' name='shed_id' value='<%=shed_id%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='brch' value='<%=brch%>'>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영지원 > 임대차관리 > <span class=style5>차고지조회</span></span></td>
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
<%
if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6"))	{
%>	
		<a href="javascript:go_to_modify()" onMouseOver="window.status=''; return true"><img src=../images/center/button_modify_s.gif border=0></a>
<%
	}
%>
	    <a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src=../images/center/button_list.gif border=0></a>
		</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
    	<td class=line>
            <table border="0" cellspacing="1" width=100%>
                <tr>
                    <td width=8% class=title>차고지명칭</td>
                    <td width=17%>&nbsp;<%=shed.getShed_nm()%></td>
                    <td width=8% class=title>관리영업소</td>
                    <td width=17%>&nbsp;<%=c_db.getNameById(shed.getMng_off(), "BRCH")%>
                    </td>
                    <td width=8% class=title>관리담당자</td>
                    <td width=17%>&nbsp;<%=shed.getMng_agnt()%></td>
                    <td width=8% class=title>계약여부</td>
                    <td width=17%>&nbsp;<%if(shed.getUse_yn().equals("Y")){%>진행중<%}else if(shed.getUse_yn().equals("N")){%>계약만료<%}%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td align='left'>  
        <img src=../images/center/icon_arrow.gif align=absmiddle>&nbsp;<a name="car"><b>임대/중개인사항</b></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
    	<td class=line>
    		<table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width=13%>성명</td>
               		<td width=21%>&nbsp;<%=shed.getLea_nm()%></td>
               		<td class=title  width=12%>상호</td>
               		<td width=21%>&nbsp;<%=shed.getLea_comp_nm()%></td>
               		<td class=title width=12%>업태</td>
               		<td width=21%>&nbsp;<%=shed.getLea_sta()%></td>
                </tr>
                <tr>
                    <td class=title>법인등록번호(생년월일)</td>
               		<td>&nbsp;<%if(!shed.getLea_ssn().equals("")){%><%=shed.getLea_ssn().substring(0,6)%><%}%></td>
               		<td class=title>사업자등록번호</td>
               		<td>&nbsp;<%=shed.getLea_ent_no()%></td>
               		<td class=title>종목</td>
               		<td>&nbsp;<%=shed.getLea_item()%></td>
                </tr>
                <tr>
                    <td class=title>임대기간</td>
               		<td colspan=3>&nbsp;<%=shed.getLea_st_dt()%></td>
                    <td class=title>임대구분</td>
               		<td>&nbsp;<%if(shed.getLea_st().equals("0")){%>자가임대
               				  <%}else if(shed.getLea_st().equals("1")){%>재임대
							  <%}else if(shed.getLea_st().equals("2")){%>임대
							  <%}%>
               		</td>
                </tr>
				<tr>
                    <td class=title>등록지주소</td>
               		<td colspan=3><input type='text' size='7' value='<%=shed.getLea_h_post()%>' class='white' readonly>
               		&nbsp;<%=shed.getLea_h_addr()%></td>
               		<td class=title>전화번호(자택)</td>
               		<td>&nbsp;<%=shed.getLea_h_tel()%></td>
                </tr>
                <tr>
                    <td class=title>사업장주소</td>
               		<td colspan=3><input type='text' size='7' value='<%=shed.getLea_o_post()%>' class='white' readonly>
               		&nbsp;<%=shed.getLea_o_addr()%></td>
               		<td class=title>전화번호(사무실)</td>
               		<td>&nbsp;<%=shed.getLea_h_tel()%></td>
                </tr>
                <tr>
                    <td class=title>과세구분</td>
               		<td>&nbsp;<%if(shed.getLea_tax_st().equals("0")){%>과세
               				<%} else if(shed.getLea_tax_st().equals("1")){%>면세 <%}%>
               		</td>
               		<td class=title>FAX</td>
               		<td>&nbsp;<%=shed.getLea_fax()%></td>
               		<td class=title>전화번호(휴대폰)</td>
               		<td>&nbsp;<%=shed.getLea_m_tel()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tR>
        <td></td>
    </tr>
    <tr> 
        <td align='left'>  
        <img src=../images/center/icon_arrow.gif align=absmiddle>&nbsp;<a name="car"><b>토지사항</b></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    </tr>
    	<td class=line>
    		<table border="0" cellspacing="1" width=100%>
                <tr>
                    <td class=title width=13%>토지소유자명</td>
               		<td width=21%>&nbsp;<%=shed.getLend_own_nm()%></td>
               		<td class=title width=12%>상호</td>
               		<td width=21%>&nbsp;<%=shed.getLend_comp_nm()%></td>
               		<td class=title width=12%>업태</td>
               		<td width=21%>&nbsp;<%=shed.getLend_sta()%></td>
                </tr>
                <tr>
                    <td class=title>법인등록번호(생년월일)</td>
               		<td>&nbsp;<%if(!shed.getLend_ssn().equals("")){%><%=shed.getLend_ssn().substring(0,6)%><%}%></td>
               		<td class=title>사업자등록번호</td>
               		<td>&nbsp;<%=shed.getLend_ent_no()%></td>
               		<td class=title>종목</td>
               		<td>&nbsp;<%=shed.getLend_item()%></td>
                </tr>
				<tr>
                    <td class=title>등록지주소</td>
               		<td colspan=3><input type='text' size='7' value='<%=shed.getLend_h_post()%>' class='white' readonly>
               		&nbsp;<%=shed.getLend_h_addr()%></td>
               		<td class=title>전화번호(자택)</td>
               		<td>&nbsp;<%=shed.getLend_h_tel()%></td>
                </tr>
                <tr>
                    <td class=title>사업장주소</td>
               		<td colspan=3><input type='text' size='7' value='<%=shed.getLend_o_post()%>' class='white' readonly>
               		&nbsp;<%=shed.getLend_o_addr()%></td>
               		<td class=title>전화번호(사무실)</td>
               		<td>&nbsp;<%=shed.getLend_o_tel()%></td>
                </tr>
                <tr>
                    <td class=title>토지의 소재지</td>
               		<td colspan=3><input type='text' size='7' value='<%=shed.getLend_post()%>' class='white' readonly>
               		&nbsp;<%=shed.getLend_addr()%></td>
               		<td class=title>전화번호(휴대폰)</td>
               		<td>&nbsp;<%=shed.getLend_m_tel()%></td>
                </tr>
               	<tr>
                    <td class=title>과세구분</td>
               		<td>&nbsp;<%if(shed.getLend_tax().equals("0")){%>과세
               					<%}else if(shed.getLend_tax().equals("1")){%>면세 <%}%>
               		</td>
               		<td class=title>FAX</td>
               		<td colspan='3'>&nbsp;<%=shed.getLend_fax()%></td>
                </tr>
                <tr>
                    <td class=title>총면적</td>
               		<td>&nbsp;<%=shed.getLend_tot_ar()%></td>
               		<td class=title>관리담당자</td>
               		<td>&nbsp;<%=shed.getLend_mng_agnt()%></td>
               		<td class=title>용도지역</td>
               		<td>&nbsp;<%=shed.getLend_region()%></td>
                </tr>
                <tr>
                    <td class=title>수용면적</td>
               		<td>&nbsp;<%=shed.getLend_cap_ar()%></td>
               		<td class=title>관할관청</td>
               		<td>&nbsp;<%=shed.getLend_gov()%></td>
               		<td class=title>토지의지목</td>
               		<td>&nbsp;<%=shed.getLend_cla()%></td>
                </tr>
                <tr>
                    <td class=title>수용대수</td>
               		<td>&nbsp;<%=shed.getLend_cap_car()%> 대</td>
               		<td class=title>계약금액</td>
               		<td>&nbsp;<%=AddUtil.parseDecimal(shed.getCont_amt())%> 원</td>
               		<td class=title>&nbsp;</td>
               		<td>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="200" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>
</body>
</html>