<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.cus0601.*, acar.partner.*"%>
<jsp:useBean id="cu_db" class="acar.customer.Customer_Database" scope="page"/>
<jsp:useBean id="emp_Bn" class="acar.partner.Serv_EmpBean" scope="page"/>
<jsp:useBean id="c61_soBn" class="acar.cus0601.ServOffBean" scope="page"/>

<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//행수
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//열수
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String result[]  = new String[value_line];
	String value0[]  = request.getParameterValues("value0");//이름
	String value1[]  = request.getParameterValues("value1");//휴대폰
	String value2[]  = request.getParameterValues("value2");//회사
	String value3[]  = request.getParameterValues("value3");//부서
	String value4[]  = request.getParameterValues("value4");//직함
	String value5[]  = request.getParameterValues("value5");//메일
	String value6[]  = request.getParameterValues("value6");//사무실전화
	String value7[]  = request.getParameterValues("value7");//사무실팩스
	String value8[]  = request.getParameterValues("value8");//사무실주소
	String value9[]  = request.getParameterValues("value9");//그룹
	String value10[] = request.getParameterValues("value10");//메모

	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	

	int count = 0;
	
	
	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();
	
	
	String off_id = "";
	String car_comp_id = "";
	String off_nm = "";
	String off_st = "7";
	String off_addr = "";
	String note = "";
	String ccp = ""; //구릅
	String ccp_id = "";
	
	String emp_nm 	= "";
	String dept_nm 	= "";
	String pos 	= "";
	String emp_level = "";
	String emp_tel 	= "";
	String emp_htel = "";
	String emp_fax 	= "";
	String emp_mtel = "";
	String emp_email = "";
	String emp_role = "";
	String emp_valid = "";
	String emp_addr = "";
	String emp_post = "";
	String nm = "";
	
	for(int i=start_row ; i < value_line ; i++){
		
		off_nm 	= value2[i] ==null?"":value2[i];
		ccp 	= value9[i] ==null?"":value9[i];
		
		if(ccp.equals("캐피탈/카드")||ccp.equals("은행")||ccp.equals("저축은행")){
			ccp_id = "0001";
		}else if(ccp.equals("IT")){
			ccp_id = "0002";
		}else if(ccp.equals("정비업체")){
			ccp_id = "0003";
		}else if(ccp.equals("자동차부품")){
			ccp_id = "0004";
		}else if(ccp.equals("협력업체")){
			ccp_id = "0005";
		}else if(ccp.equals("부동산")){
			ccp_id = "0006";
		}else if(ccp.equals("관공서")){
			ccp_id = "0007";
		}else if(ccp.equals("구매")){
			ccp_id = "0008";
		}else if(ccp.equals("매각")||ccp.equals("경매장")){
			ccp_id = "0009";
		}else if(ccp.equals("미분류")||ccp.equals("")){
			ccp_id = "0010";
		}
		
		
		off_id = cu_db.getOff_id(off_nm, "");
		
		if(off_id.equals("")){  //업체 등록
		
			c61_soBn.setOff_nm(off_nm);
			c61_soBn.setReg_id(user_id);
			c61_soBn.setCar_comp_id(ccp_id); 
			c61_soBn.setOff_st("7");
			c61_soBn.setOff_addr(value8[i] ==null?"":value8[i]);
			c61_soBn.setOff_tel(value6[i] ==null?"":value6[i]);
			c61_soBn.setBr_id("B1");
			
			count = se_dt.insertServOff(c61_soBn);
			
		}
		
		off_id = cu_db.getOff_id(off_nm, "");
		emp_nm = value0[i] ==null?"":value0[i];
		nm = cu_db.getEmp_nm(off_id, emp_nm);
		
		//담당자등록
		if(nm.equals("")){
		emp_Bn.setOff_id(off_id);	
		emp_Bn.setEmp_nm(emp_nm);
		emp_Bn.setDept_nm(value3[i] ==null?"":value3[i]);
		emp_Bn.setPos(value4[i] ==null?"":value4[i]);
		emp_Bn.setEmp_tel(value6[i] ==null?"":value6[i]);
		emp_Bn.setEmp_fax(value7[i] ==null?"":value7[i]);
		emp_Bn.setEmp_mtel(value1[i] ==null?"":value1[i]);
		emp_Bn.setEmp_email(value5[i] ==null?"":value5[i].trim());
		emp_Bn.setEmp_addr(value8[i] ==null?"":value8[i]);
		emp_Bn.setEmp_valid("1"); //1:유효, 2:부서변경, 3:퇴직, 4:무효

		
		count = se_dt.insertServEmp(emp_Bn);
		}
		
		if(count > 0 )
			result[i] = "등록했습니다.";
		else
			result[i] = "오류 발생";
	}
	

%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<p>엑셀 파일 읽어 등록하기
</p>
<form action="excel_result.jsp" method='post' name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
<%	for(int i=start_row ; i < value_line ; i++){%>
<input type='hidden' name='emp_nm' value='<%=value0[i] ==null?"":value0[i]%>'>
<input type='hidden' name='off_nm'    value='<%=value2[i] ==null?"":value2[i]%>'>
<input type='hidden' name='result'  value='<%=result[i]%>'>
<%	}%>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--		
		document.form1.submit();			
//-->
</SCRIPT>
</BODY>
</HTML>