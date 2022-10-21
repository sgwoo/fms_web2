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
	var theForm = document.ServOffRegForm;

	if(theForm.off_id.value=="")
	{
		alert("상단을 등록후 등록이 가능합니다.");
		return;
	}
	if(arg == 'SERV')
	{
		//parent.c_foot.location ='register_service_id.jsp';
		theForm.action = "./serv_off_serv_list_id.jsp";
		
	}else if(arg == 'CAR'){
		//parent.c_foot.location ='register_change_id.jsp';
		theForm.action = "./serv_off_car_list_id.jsp";	
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
	theForm.action = "./serv_off_main_null_ui.jsp";
	theForm.cmd.value = "i";
	theForm.target = "nodisplay"
	theForm.submit();

}
function ServOffUp()
{
	var theForm = document.ServOffRegForm;
	/*if(!CheckField())
	{
		return;
	}*/
	if(!confirm('수정하시겠습니까?'))
	{
		return;
	}
	theForm.action = "./serv_off_main_null_ui.jsp";
	theForm.cmd.value = "u";
	theForm.target = "nodisplay"
	theForm.submit();

}
//-->
</script>
</head>
<body leftmargin="15">

<table border=0 cellspacing=0 cellpadding=0 width="800">

	<tr>
    	<td><font color="navy">차량관리 -> 정비업소관리 -> </font><font color="red">정비업소등록</font></td>
    </tr>
    <tr>
        <td align="right">
<%
	if(off_id.equals(""))
	{
%>
           <a href="javascript:ServOffReg()">등록</a>&nbsp;
<%
	}else{
%>
			<a href="javascript:ServOffUp()">수정</a>&nbsp;
<%}%> 

        </td>
    </tr>
    <form action="./serv_off_main_null_ui.jsp" name="ServOffRegForm" method="POST" >
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                
                <tr>
                    <td class=title width=80>지정업체</td>
               		<td align=center width=120>
               			<select name="car_comp_id" style="width:100px">
<%
    for(int i=0; i<cc_r.length; i++){
        cc_bean = cc_r[i];
%>
            				<option value="<%= cc_bean.getCode() %>"><%= cc_bean.getNm() %></option>
<%}%>  
               			</select>
<%
	if(!off_id.equals(""))
	{
%>
           				<script language="JavaScript">
               			<!--
               			document.ServOffRegForm.car_comp_id.value = '<%=car_comp_id%>';
               			//-->
               			</script>
<%
	}
%>
               		</td>
               		<td class=title width=80>상호</td>
               		<td align=center width=120><input type="text" name="off_nm" value="<%=off_nm%>" size="18" class=text></td>
               		
            <td class=title width=80>등급</td>
               		<td align=left width=120>
               			<select name="off_st">
               				<option value="1">1급</option>
               				<option value="2">2급</option>
               				<option value="3">3급</option>
               				<option value="4">4급</option>
               				<option value="5">5급</option>
               				<option value="6">기타</option>
               			</select>
<%
	if(!off_id.equals(""))
	{
%>
           				<script language="JavaScript">
               			<!--
               			document.ServOffRegForm.off_st.value = '<%=off_st%>';
               			//-->
               			</script>
<%
	}
%>
               		</td>
               		<td class=title width=80>업태</td>
               		<td align=center width=120><input type="text" name="off_sta" value="<%=off_sta%>" size="18" class=text></td>
               		
                </tr>
                <tr>
                    <td class=title>대표자</td>
               		<td align=center><input type="text" name="own_nm" value="<%=own_nm%>" size="18" class=text></td>
               		<td class=title>사업자번호</td>
               		<td align=center><input type="text" name="ent_no" value="<%=ent_no%>" size="18" class=text></td>
               		
            <td class=title>업종</td>
               		<td align=center><input type="text" name="homepage" value="<%=homepage%>" size="18" class=text></td>
               		<td class=title>종목</td>
               		<td align=center><input type="text" name="off_item" value="<%=off_item%>" size="18" class=text></td>
               		
                </tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('off_post').value = data.zonecode;
								document.getElementById('off_addr').value = data.address;
								
							}
						}).open();
					}
				</script>
				<tr>
                    <td class=title>주소</td>
               		<td align=left colspan=5>
					<input type="text" name='off_post' id="off_post" size="7" value="<%=off_post%>" maxlength='7'>
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;&nbsp;<input type="text" name='off_addr' id="off_addr" value="<%=off_addr%>" size="50">
					</td>
               		<td class=title>사무실전화</td>
               		<td align=center ><input type="text" name="off_tel" value="<%=off_tel%>" size="18" class=text></td>
               		
               	</tr>
                
                <tr>
                    <td class=title>계좌개설은행</td>
               		<td align=center><input type="text" name="bank" value="<%=bank%>" size="18" class=text></td>
               		<td class=title>계좌번호</td>
               		<td align=center><input type="text" name="acc_no" value="<%=acc_no%>" size="18" class=text></td>
               		<td class=title>예금주</td>
               		<td align=center><input type="text" name="acc_nm" value="<%=acc_nm%>" size="18" class=text></td>
               		<td class=title>팩스</td>
               		<td align=center><input type="text" name="off_fax" value="<%=off_fax%>" size="18" class=text></td>
               		
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
    <tr>
    	<td>&nbsp;</td>
    </tr>
</form>    
</table>

<a href="javascript:FootWin('SERV')" onMouseOver="window.status=''; return true">정비리스트</a>&nbsp;|
<a href="javascript:FootWin('CAR')" onMouseOver="window.status=''; return true">차량리스트</a>

</body>
</html>