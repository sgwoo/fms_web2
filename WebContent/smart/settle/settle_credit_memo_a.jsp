<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.fee.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/smart/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>
<%
	boolean flag = true;
	
	String bus_id2 		= request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	String s_item 		= request.getParameter("s_item")==null?"":request.getParameter("s_item");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm 		= request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String car_no 		= request.getParameter("car_no")==null?"":request.getParameter("car_no");
	String car_nm 		= request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	int    cont_cnt 	= request.getParameter("cont_cnt")==null?0:AddUtil.parseInt(request.getParameter("cont_cnt")); //계약건수
	String st			= request.getParameter("st")==null?"":request.getParameter("st");
	
	String site_seq 	= request.getParameter("site_seq")==null?"":request.getParameter("site_seq");
	String site_nm 		= request.getParameter("site_nm")==null?"":request.getParameter("site_nm");
	
	String rent_st = "1";
	String fee_tm = "A";
	String tm_st1 = "0";
	
	FeeMemoBean memo = new FeeMemoBean();
	memo.setRent_mng_id	(rent_mng_id);
	memo.setRent_l_cd	(rent_l_cd);
	memo.setRent_st		(rent_st);
	memo.setFee_tm		(fee_tm);
	memo.setTm_st1		(tm_st1);
	memo.setReg_id		(user_id);
	memo.setReg_dt		(request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt"));
	memo.setSpeaker		(request.getParameter("speaker")==null?"":request.getParameter("speaker"));
	memo.setContent		(AddUtil.nullToNbsp(request.getParameter("content")));
	
	flag = af_db.insertFeeMemo(memo);
%>
<form name='form1' action='settle_credit_memo.jsp' target='_parent' method="POST">
<%@ include file="/include/search_hidden.jsp" %>
	<input type='hidden' name='bus_id2' 	value='<%=bus_id2%>'>
	<input type='hidden' name='s_item' 		value='<%=s_item%>'>
	<input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
	<input type='hidden' name='rent_l_cd' 	value='<%=rent_l_cd%>'>
	<input type='hidden' name='client_id' 	value='<%=client_id%>'>
	<input type='hidden' name='firm_nm' 	value='<%=firm_nm%>'>
	<input type='hidden' name='car_mng_id' 	value='<%=car_mng_id%>'>
	<input type='hidden' name='car_no' 		value='<%=car_no%>'>
	<input type='hidden' name='car_nm' 		value='<%=car_nm%>'>
	<input type='hidden' name='mode' 		value='<%=mode%>'>	
	<input type='hidden' name='from_page' 	value='<%=from_page%>'>
	<input type='hidden' name='cont_cnt' 	value='<%=cont_cnt%>'>
	<input type='hidden' name='st' 			value='<%=st%>'>	
	<input type='hidden' name='site_seq'	value='<%=site_seq%>'>
	<input type='hidden' name='site_nm'		value='<%=site_nm%>'>	
</form>

<script language='javascript'>
<%	if(!flag){%>
		alert('오류발생!');
<%	}else{%>
		alert('등록되었습니다');
		document.form1.submit();
<%	}%>

</script>
</body>
</html>
