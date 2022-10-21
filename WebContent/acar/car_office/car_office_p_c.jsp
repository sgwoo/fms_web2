<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.common.*" %>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="coe_bean" class="acar.car_office.CarOffEmpBean" scope="page"/>
<jsp:useBean id="cd_bean" class="acar.common.CodeBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_office.CommiBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"0":request.getParameter("gubun4");
	
	String emp_id = "";						//영업사원ID
    String car_off_id = "";					//영업소ID
    String car_off_nm = "";					//영업소명칭
    String owner_nm = "";
    String car_comp_id = "";				//자동차회사ID
    String car_comp_nm = "";				//자동차회사 명칭
    String cust_st = "";					//고객구분
    String emp_nm = "";						//성명
    String emp_ssn = "";					//주민등록번호
    String emp_ssn1 = "";
    String emp_ssn2 = "";
    String car_off_tel = "";				//사무실전화
    String car_off_fax = "";				//팩스
    String emp_m_tel = "";					//핸드폰
    String emp_pos = "";					//직위
    String emp_email = "";					//이메일
    String emp_bank = "";					//은행
    String emp_acc_no = "";					//계좌번호
    String emp_acc_nm = "";					//예금주
    String emp_post = "";
    String emp_addr = "";
	String etc = "";
    String cmd = "";
	int count = 0;
	String auth_rw = "";
	
	if(request.getParameter("auth_rw") !=null) auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("cmd") != null)
	{
		cmd = request.getParameter("cmd"); //update, inpsert 구분
	}

	if(request.getParameter("emp_id")!=null)
	{
		emp_id = request.getParameter("emp_id");
		
		coe_bean = cod.getCarOffEmpBean(emp_id);
		
		car_off_id = coe_bean.getCar_off_id();
		car_off_nm = coe_bean.getCar_off_nm();
		car_comp_id = coe_bean.getCar_comp_id();
		car_comp_nm = coe_bean.getCar_comp_nm();
		owner_nm = coe_bean.getOwner_nm();
		cust_st = coe_bean.getCust_st();
		emp_nm = coe_bean.getEmp_nm();
		emp_ssn = coe_bean.getEmp_ssn();
		emp_ssn1 = coe_bean.getEmp_ssn1();
		emp_ssn2 = coe_bean.getEmp_ssn2();
		emp_m_tel = coe_bean.getEmp_m_tel();
		emp_pos = coe_bean.getEmp_pos();
		emp_email = coe_bean.getEmp_email();
		emp_bank = coe_bean.getEmp_bank();
		emp_acc_no = coe_bean.getEmp_acc_no();
		emp_acc_nm = coe_bean.getEmp_acc_nm();
		emp_post = coe_bean.getEmp_post();
		emp_addr = coe_bean.getEmp_addr();
		etc = coe_bean.getEtc();
	}
	
	CodeBean cd_r [] = c_db.getCodeAll("0003");	//은행명을 가져온다.
	//계약현황
	CommiBean cm_r [] = cod.getCommiAll(emp_id);
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table.css"></link>
<script language="JavaScript">
<!--

function CarOffEmpDisp()
{
	var theForm = document.CarOffEmpDispForm;
	
	theForm.submit();
}

//-->
</script>
</head>
<body leftmargin="15">
<form action="./car_office_p_i.jsp" name="CarOffEmpDispForm" method="POST" >
<table border=0 cellspacing=0 cellpadding=0 width="800">
	<tr>
    	<td ><font color="navy">영업지원 -> 자동차영업소관리 -> </font><font color="red">영업사원수정</font></td>
    </tr>
    <tr>
    	<td>
            <table border="0" cellspacing="1" cellpadding="3" width="800">
            	<tr>
			    	<td width=100 align="right">회사명 : </td>
			    	<td width=100><%= car_comp_nm %><input type="hidden" name="car_comp_id" value="<%= car_comp_id %>"></td>
			    	<td width=100 align="right">지점명 : </td>
			        <td width=100><%= owner_nm %></td>
			    	<td width=100 align="right">대리점명 : </td>
			        <td width=100><%= car_off_nm %><input type="hidden" name="car_off_id" value="<%= car_off_id %>"></td>
			    	
			    	<td  width=200 align="right">
<%
if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))	{
%>

			<a href="javascript:CarOffEmpDisp()" onMouseOver="window.status=''; return true">수정화면</a>&nbsp;
<%}%>   			    	
			    	</td>
            	</tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                <tr>
                    <td class=title>고객구분</td>
                    <td align=center colspan=5>
                    	<input type="radio" name="cust_st" value="2"  <% if(cust_st.equals("2")||cust_st.equals("")) out.println("checked"); %>>사업소득&nbsp;
                    	<input type="radio" name="cust_st" value="3"  <% if(cust_st.equals("3")) out.println("checked"); %>>기타사업소득&nbsp;
                    </td>
                    
                    
                </tr>
                <tr>
                    <td class=title width=120>성명</td>
               		<td align=center width=140><%= emp_nm %><input type="hidden" name="emp_id" value="<%= emp_id %>"><input type="hidden" name="emp_nm" value="<%= emp_nm %>"></td>
                    <td class=title width=120>주민등록번호</td>
               		<td align=center width=150><%=emp_ssn1%><input type="hidden" name="emp_ssn1" value="<%=emp_ssn1%>"> - <%=emp_ssn2%><input type="hidden" name="emp_ssn2" value="<%=emp_ssn2%>"><input type="hidden" name="emp_ssn" value="<%= emp_ssn %>"></td>
               		<td class=title width=120>휴대폰</td>
               		<td align=center width=150><%= emp_m_tel %><input type="hidden" name="emp_m_tel" value="<%= emp_m_tel %>"></td>
                </tr>
                <tr>
                    <td class=title width=120>주소</td>
               		<td colspan=5>&nbsp;( <%=emp_post%> ) <%=emp_addr%><input type="hidden" name="emp_post" value="<%= emp_post %>">&nbsp;<input type="hidden" name="emp_addr" value="<%=emp_addr%>"></td>
               	</tr>
                <tr>
                    
               		<td class=title>직위</td>
               		<td align=center><%= emp_pos %><input type="hidden" name="emp_pos" value="<%= emp_pos %>"></td>
               		<td class=title>이메일</td>
               		<td align=center colspan=3><%= emp_email %><input type="hidden" name="emp_email" value="<%= emp_email %>"></td>
                </tr>
                
                <tr>
                    <td class=title>계좌개설은행</td>
               		<td align=center>
						<select name="emp_bank" style="width:135">
							<option value="">선택</option>
<%
    for(int i=0; i<cd_r.length; i++){
        cd_bean = cd_r[i];
%>
            				<option value="<%= cd_bean.getNm() %>"><%= cd_bean.getNm() %></option>
<%}%> 					</select>
						<script>
						document.CarOffEmpDispForm.emp_bank.value = '<%= emp_bank %>';
						</script>
               		</td>
               		<td class=title>계좌번호</td>
               		<td align=center><%= emp_acc_no %><input type="hidden" name="emp_acc_no" value="<%= emp_acc_no %>"></td>
               		<td class=title>예금주</td>
               		<td align=center ><%= emp_acc_nm %><input type="hidden" name="emp_acc_nm" value="<%= emp_acc_nm %>"></td>
                </tr>
                <tr>
                    <td class=title width=120>비고</td>
               		<td colspan=5>&nbsp;<%= etc %><input type="hidden" name="etc" value="<%=etc%>"></td>
               	</tr>				
            </table>
        </td>
    </tr>
    <tr>
    	<td>< 계약현황 ></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=800>
            	<tr>
            		
            		<td class=title>계약번호</td>
            		<td class=title>계약일</td>
            		<td class=title>상호</td>
            		<td class=title>계약자</td>
            		<td class=title>차명</td>
            		<td class=title>차량번호</td>
            		
            		
            		<td class=title>등록일</td>
            		<td class=title>영업담당자</td>

            	</tr>
<%
    for(int i=0; i<cm_r.length; i++){
        cm_bean = cm_r[i];
%>
				<tr>
            		
            		<td align=center><%= cm_bean.getRent_l_cd() %></td>
            		<td align=center><%= cm_bean.getRent_dt() %></td>
            		<td align=center><%= cm_bean.getFirm_nm() %></td>
            		<td align=center><%= cm_bean.getClient_nm() %></td>
            		<td align=center><%= cm_bean.getCar_name() %></td>
            		<td align=center><%= cm_bean.getCar_no() %></td>
            		
            		
            		<td align=center><%= cm_bean.getInit_reg_dt() %></td>
            		<td align=center><%= cm_bean.getUser_nm() %></td>

            	</tr>
<%}%> 	
<% if(cm_r.length == 0) { %>
            <tr>
                <td colspan=8 align=center height=25>등록된 데이타가 없습니다.</td>
            </tr>
<%}%>            	
            </table>
        </td>
    </tr>
</table>
<input type="hidden" name="cmd" value="">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="gubun2" value="<%=gubun2%>">
<input type="hidden" name="gubun3" value="<%=gubun3%>">
<input type="hidden" name="gubun4" value="<%=gubun4%>">
</form>
<form action="./car_off_nodisplay.jsp" name="SelectForm" method="POST">
<input type="hidden" name="h_sel" value="">
<input type="hidden" name="h_car_comp_id" value="">
<input type="hidden" name="h_car_off_id" value="<%= car_off_id %>">
</form>
</body>
</html>
