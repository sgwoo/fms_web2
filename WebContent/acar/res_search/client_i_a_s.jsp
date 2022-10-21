<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	RentCustBean bean = new RentCustBean();
	int count =0;
	int bad_yn = 0;
	
	bean.setCust_st(request.getParameter("cust_st"));
	bean.setCust_nm(request.getParameter("cust_nm"));
	bean.setFirm_nm(request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm"));
	bean.setSsn(request.getParameter("ssn"));
	bean.setEnp_no(request.getParameter("enp_no")==null?"":request.getParameter("enp_no"));
	bean.setZip(request.getParameter("zip")==null?"":request.getParameter("zip"));
	bean.setAddr(request.getParameter("addr")==null?"":request.getParameter("addr"));
	bean.setLic_no(request.getParameter("lic_no")==null?"":request.getParameter("lic_no"));
	bean.setLic_st(request.getParameter("lic_st")==null?"":request.getParameter("lic_st"));
	bean.setTel(request.getParameter("tel")==null?"":request.getParameter("tel"));
	bean.setM_tel(request.getParameter("m_tel")==null?"":request.getParameter("m_tel"));
	bean.setEmail(request.getParameter("email")==null?"":request.getParameter("email"));
	bean.setEtc(request.getParameter("etc")==null?"":request.getParameter("etc"));
	bean.setReg_id(request.getParameter("user_id"));
	bean.setRank("1");//일반회원
	
	//주민(법인)등록번호 중복체크
	count = rs_db.checkSSN(bean.getSsn());
	
	//불향임차인 확인
	bad_yn = rs_db.checkBadCust(bean.getSsn());
	
	if(count == 0 && bad_yn == 0){ //중복된 고객이 없으면 등록
		bean = rs_db.insertRentCust(bean);
	}
%>
	<script language='javascript'>
<%	if(count == 0 && bad_yn == 0){
		if(bean != null){ //정상%>
		alert('정상적으로 등록되었습니다');
		var fm = parent.opener.form1;

		fm.cust_st.value = '2';		
		<%if(bean.getCust_st().equals("1")){%>				fm.c_cust_st.value = '법인';
		<%}else if(bean.getCust_st().equals("2")){%>		fm.c_cust_st.value = '개인';
		<%}else if(bean.getCust_st().equals("3")){%>		fm.c_cust_st.value = '개인사업자(일반과세)';
		<%}else if(bean.getCust_st().equals("4")){%>		fm.c_cust_st.value = '개인사업자(간이과세)';
		<%}else if(bean.getCust_st().equals("5")){%>		fm.c_cust_st.value = '개인사업자(면세사업자)';										
		<%}%>
		fm.c_cust_id.value = '<%=bean.getCust_id()%>';
		fm.c_cust_nm.value = '<%=bean.getCust_nm()%>';		
		fm.c_firm_nm.value = '<%=bean.getFirm_nm()%>';
		fm.c_ssn.value = '<%=bean.getSsn()%>';
		fm.c_enp_no.value = '<%=bean.getEnp_no()%>';
		fm.c_zip.value = '<%=bean.getZip()%>';		
		fm.c_addr.value = '<%=bean.getAddr()%>';		
		fm.c_lic_no.value = '<%=bean.getLic_no()%>';		
		<%if(bean.getLic_st().equals("1")){%>			fm.c_lic_st.value = '1종보통';
		<%}else if(bean.getLic_st().equals("2")){%>		fm.c_lic_st.value = '2종보통';
		<%}%>		
		fm.c_lic_st.value = '<%=bean.getLic_st()%>';
		fm.c_tel.value = '<%=bean.getTel()%>';
		fm.c_m_tel.value = '<%=bean.getM_tel()%>';
		fm.c_car_no.value = '';
		parent.close();
			
<%		}else{ //에러%>
		alert('등록되지 않았습니다\n\n에러발생!');
<%		}
	}else if(count != 0){%>
		alert('이미 등록된 주민(사업자)번호입니다.\n\n확인하십시오.');
<%	}else{%>
		alert('불량임차인입니다.\n\n확인하십시오.');
<%	}%>
</script>
</body>
</html>
