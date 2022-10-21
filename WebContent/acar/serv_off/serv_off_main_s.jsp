<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.serv_off.*" %>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="so_bean" class="acar.serv_off.ServOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	ServOffDatabase sod = ServOffDatabase.getInstance();
	String auth_rw = "";
	String off_id = ""; 
	String car_comp_id = ""; 
	String off_nm = ""; 
	String off_st = ""; 
	String off_st_nm = "";
	String own_nm = ""; 
	String ent_no = ""; 
	String off_sta = ""; 
	String off_item = ""; 
	String off_tel = ""; 
	String off_fax = ""; 
	String homepage = ""; 
	String off_post = ""; 
	String off_addr = ""; 
	String bank = ""; 
	String acc_no = ""; 
	String acc_nm = ""; 
	String note = "";
	
	
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("off_id") !=null) off_id = request.getParameter("off_id");
	 
	if(!off_id.equals(""))
	{
		so_bean = sod.getServOff(off_id);
		
		car_comp_id = so_bean.getCar_comp_id(); 
		off_nm = so_bean.getOff_nm(); 
		off_st = so_bean.getOff_st();
		off_st_nm = so_bean.getOff_st_nm(); 
		own_nm = so_bean.getOwn_nm(); 
		ent_no = so_bean.getEnt_no(); 
		off_sta = so_bean.getOff_sta(); 
		off_item = so_bean.getOff_item(); 
		off_tel = so_bean.getOff_tel(); 
		off_fax = so_bean.getOff_fax(); 
		homepage = so_bean.getHomepage(); 
		off_post = so_bean.getOff_post(); 
		off_addr = so_bean.getOff_addr(); 
		bank = so_bean.getBank(); 
		acc_no = so_bean.getAcc_no(); 
		acc_nm = so_bean.getAcc_nm(); 
		note = so_bean.getNote();
	}
	
	CarCompBean cc_r [] = umd.getCarCompAll();
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function FootWin(arg)
{
	var theForm = document.ServOffDispForm;

	
	if(arg == 'SERV')
	{
		//parent.c_foot.location ='register_service_id.jsp';
		theForm.action = "./serv_off_serv_list_sd.jsp";
		
	}else if(arg == 'CAR'){
		//parent.c_foot.location ='register_change_id.jsp';
		theForm.action = "./serv_off_car_list_sd.jsp";	
	}
	
	theForm.target = "c_foot";
	theForm.submit();
}
function search_zip()
{
	window.open("./zip_s.jsp", "우편번호검색", "left=100, height=200, height=500, width=400, scrollbars=yes");
}
function ServOffReg()
{
	var theForm = document.ServOffRegForm;
	/*if(!CheckField())
	{
		return;
	}*/
	if(!confirm('등록하시겠습니까?'))
	{
		return;
	}
	theForm.cmd.value = "i";
	theForm.target = "nodisplay"
	theForm.submit();

}
function ServOffUpDisp()
{
	var theForm = document.ServOffDispForm;
	theForm.action = "./serv_off_i_frame.jsp";
	theForm.target = "d_content";
	theForm.submit();
}
//-->
</script>
</head>
<body leftmargin="15">

<table border=0 cellspacing=0 cellpadding=0 width="800">
<form action="" name="ServOffDispForm" method="POST" >
	<tr>
    	<td ><font color="navy">차량관리 -> 정비업소관리 -> </font><font color="red">정비업소등록</font></td>
    </tr>
<%
	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6"))
	{
%>	
	<tr>
        <td align="right">
        <a href="javascript:ServOffUpDisp()" onMouseOver="window.status=''; return true">수정화면</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </td>
    </tr>
<%
	}
%>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                
                <tr>
                    <td class=title width=100>지정업체</td>
               		<td align=center width=120>
               			<select name="car_comp_id" style="width:115 px">
<%
    for(int i=0; i<cc_r.length; i++){
        cc_bean = cc_r[i];
%>
            				<option value="<%= cc_bean.getCode() %>"><%= cc_bean.getNm() %></option>
<%}%>  
               			</select>
               			<script language="JavaScript">
               			<!--
               			document.ServOffDispForm.car_comp_id.value = '<%=car_comp_id%>';
               			//-->
               			</script>	
               		</td>
               		<td class=title width=80>상호</td>
               		<td align=center width=140><%=off_nm%></td>
               		
            <td class=title width=80>등급</td>
               		<td align=center width=100><%=off_st_nm%></td>
               		<td class=title width=80>업태</td>
               		<td align=center width=100><%=off_sta%></td>
               		
                </tr>
                <tr>
                    <td class=title>대표자</td>
               		<td align=center><%=own_nm%></td>
               		<td class=title>사업자번호</td>
               		<td align=center><%=ent_no%></td>
               		
            <td class=title>업종</td>
               		<td align=center><a href="http://<%=homepage%>" target="_blank"><%=homepage%></a></td>
               		<td class=title>종목</td>
               		<td align=center><%=off_item%></td>
               		
                </tr>
				<tr>
                    <td class=title>주소</td>
               		<td align=left colspan=5>&nbsp;<%=off_post%>&nbsp;<%=off_addr%></td>
               		<td class=title>사무실전화</td>
               		<td align=center ><%=off_tel%></td>
               		
               	</tr>
                
                <tr>
                    <td class=title>계좌개설은행</td>
               		<td align=center><%=bank%></td>
               		<td class=title>계좌번호</td>
               		<td align=center><%=acc_no%></td>
               		<td class=title>예금주</td>
               		<td align=center><%=acc_nm%></td>
               		<td class=title>팩스</td>
               		<td align=center><%=off_fax%></td>
               		
                </tr>
                <tr>
                    <td class=title>비고</td>
               		<td align=left colspan=7><textarea name="note" cols="95" rows="4"><%=note%></textarea></td>
               	</tr>
            </table>
            <input type="hidden" name="cmd" value="">
            <input type="hidden" name="off_id" value="<%=off_id%>">
            <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
        </td>
    </tr>
</form>    
</table>

<a href="javascript:FootWin('SERV')" onMouseOver="window.status=''; return true">정비리스트</a>&nbsp;|
<a href="javascript:FootWin('CAR')" onMouseOver="window.status=''; return true">차량리스트</a>


</body>
</html>