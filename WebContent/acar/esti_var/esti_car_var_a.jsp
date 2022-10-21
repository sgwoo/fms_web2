<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstiCarVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	
	String a_e = request.getParameter("h_a_e")==null?"":request.getParameter("h_a_e");
	String a_a = request.getParameter("h_a_a")==null?"":request.getParameter("h_a_a");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	int count = 0;
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	bean.setA_e(a_e);
	bean.setA_a(a_a);
	bean.setSeq(seq);
	bean.setA_c(request.getParameter("h_a_c")==null?"":request.getParameter("h_a_c"));
	bean.setM_st(request.getParameter("h_m_st")==null?"":request.getParameter("h_m_st"));
	bean.setS_sd(request.getParameter("s_sd")==null?"":request.getParameter("s_sd"));
	bean.setCars(request.getParameter("cars")==null?"":request.getParameter("cars"));
	bean.setA_j(request.getParameter("a_j")==null?"":request.getParameter("a_j"));
	bean.setS_f(request.getParameter("s_f")==null?0:AddUtil.parseFloat(request.getParameter("s_f"))); //미사용
	bean.setO_2(request.getParameter("o_2")==null?0:AddUtil.parseFloat(request.getParameter("o_2"))); //미사용
	bean.setO_3(request.getParameter("o_3")==null?0:AddUtil.parseDigit(request.getParameter("o_3"))); //미사용
	bean.setO_4(request.getParameter("o_4")==null?0:AddUtil.parseDigit(request.getParameter("o_4"))); //미사용
	bean.setO_5(request.getParameter("o_5")==null?0:AddUtil.parseFloat(request.getParameter("o_5")));
	
	if(request.getParameter("o_6").length() > 4){
		bean.setO_6(request.getParameter("o_6")==null?0:AddUtil.parseDigit(request.getParameter("o_6"))); //미사용
		bean.setO_7(request.getParameter("o_7")==null?0:AddUtil.parseDigit(request.getParameter("o_7"))); //미사용
	}else{
		bean.setO_6(request.getParameter("o_6")==null?0:AddUtil.parseFloat(request.getParameter("o_6"))); //미사용
		bean.setO_7(request.getParameter("o_7")==null?0:AddUtil.parseFloat(request.getParameter("o_7"))); //미사용
	}
	
	bean.setO_11(request.getParameter("o_11")==null?0:AddUtil.parseFloat(request.getParameter("o_11"))); //미사용
	bean.setO_13_1(request.getParameter("o_13_1")==null?0:AddUtil.parseFloat(request.getParameter("o_13_1"))); //미사용
	bean.setO_13_2(request.getParameter("o_13_2")==null?0:AddUtil.parseFloat(request.getParameter("o_13_2"))); //미사용
	bean.setO_13_3(request.getParameter("o_13_3")==null?0:AddUtil.parseFloat(request.getParameter("o_13_3"))); //미사용
	bean.setO_13_4(request.getParameter("o_13_4")==null?0:AddUtil.parseFloat(request.getParameter("o_13_4"))); //미사용
	bean.setO_13_5(request.getParameter("o_13_5")==null?0:AddUtil.parseFloat(request.getParameter("o_13_5"))); //미사용
	bean.setO_13_6(request.getParameter("o_13_6")==null?0:AddUtil.parseFloat(request.getParameter("o_13_6"))); //미사용
	bean.setO_13_7(request.getParameter("o_13_7")==null?0:AddUtil.parseFloat(request.getParameter("o_13_7"))); //미사용
	bean.setO_14(request.getParameter("o_14")==null?0:AddUtil.parseDigit(request.getParameter("o_14")));
	bean.setO_15(request.getParameter("o_15")==null?0:AddUtil.parseDigit(request.getParameter("o_15")));
	bean.setO_a(request.getParameter("o_a")==null?0:AddUtil.parseDigit(request.getParameter("o_a"))); //미사용
	bean.setO_b(request.getParameter("o_b")==null?0:AddUtil.parseDigit(request.getParameter("o_b"))); //미사용
	bean.setO_c(request.getParameter("o_c")==null?0:AddUtil.parseDigit(request.getParameter("o_c"))); //미사용
	bean.setO_d(request.getParameter("o_d")==null?0:AddUtil.parseDigit(request.getParameter("o_d"))); //미사용
	bean.setOa_d(request.getParameter("oa_d")==null?0:AddUtil.parseDigit(request.getParameter("oa_d")));	
	bean.setG_2(request.getParameter("g_2")==null?0:AddUtil.parseDigit(request.getParameter("g_2")));
	bean.setG_4(request.getParameter("g_4")==null?0:AddUtil.parseFloat(request.getParameter("g_4")));
	bean.setG_6(request.getParameter("g_6")==null?0:AddUtil.parseDigit(request.getParameter("g_6"))); //미사용
	bean.setG_7(request.getParameter("g_7")==null?0:AddUtil.parseDigit(request.getParameter("g_7"))); //미사용
	bean.setOa_e_1(request.getParameter("oa_e_1")==null?0:AddUtil.parseDigit(request.getParameter("oa_e_1"))); //미사용
	bean.setOa_e_2(request.getParameter("oa_e_2")==null?0:AddUtil.parseDigit(request.getParameter("oa_e_2"))); //미사용
	bean.setOa_e_3(request.getParameter("oa_e_3")==null?0:AddUtil.parseDigit(request.getParameter("oa_e_3"))); //미사용
	bean.setOa_e_4(request.getParameter("oa_e_4")==null?0:AddUtil.parseDigit(request.getParameter("oa_e_4"))); //미사용
	bean.setOa_e_5(request.getParameter("oa_e_5")==null?0:AddUtil.parseDigit(request.getParameter("oa_e_5"))); //미사용
	bean.setOa_e_6(request.getParameter("oa_e_6")==null?0:AddUtil.parseDigit(request.getParameter("oa_e_6"))); //미사용
	bean.setOa_e_7(request.getParameter("oa_e_7")==null?0:AddUtil.parseDigit(request.getParameter("oa_e_7"))); //미사용
	
	if(cmd.equals("i") || cmd.equals("up")){
		seq = e_db.insertEstiCarVar(bean);
	}else if(cmd.equals("u")){
		count = e_db.updateEstiCarVar(bean);
	}
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="esti_car_var_i.jsp" name="form1" method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">
  <input type="hidden" name="user_id" value="<%=user_id%>">      
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">        
  <input type="hidden" name="a_e" value="<%=a_e%>">
  <input type="hidden" name="a_a" value="<%=a_a%>">
  <input type="hidden" name="seq" value="<%=seq%>">          
  <input type="hidden" name="cmd" value="u">
</form>
<script>
<%	if(cmd.equals("u")){
		if(count==1){%>
		alert("정상적으로 수정되었습니다.");
		document.form1.target='d_content';
		document.form1.submit();		
<%		}else{%>
		alert("에러발생!");
<%		}
	}else{
		if(!seq.equals("")){%>
		alert("정상적으로 등록되었습니다.");
		document.form1.target='d_content';
		document.form1.submit();		
<%		}else{%>
		alert("에러발생!");
<%		}
	}	%>
</script>
</body>
</html>
