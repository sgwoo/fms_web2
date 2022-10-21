<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	int size = request.getParameter("tot_size")==null?0:AddUtil.parseDigit(request.getParameter("tot_size"));
	String today = AddUtil.getDate(4);
	int flag = 0;
	int flag2 = 0;
	
	flag2 = ad_db.getInsertYn("stat_debt", today);
	
	if(flag2 == 0){
		String cpt_cd[] = request.getParameterValues("cpt_cd");
		String last_mon_amt[] = request.getParameterValues("last_amt");
		String over_mon_amt[] = request.getParameterValues("over_amt");
		String this_mon_new_amt[] = request.getParameterValues("new_amt");
		String this_mon_plan_amt[] = request.getParameterValues("plan_amt");
		String this_mon_pay_amt[] = request.getParameterValues("pay_amt");
		String this_mon_jan_amt[] = request.getParameterValues("jan_amt");
		String whan_amt[] = request.getParameterValues("h_last_amt");
		
		for(int i=0; i<size; i++){
			StatDebtBean sd = new StatDebtBean();
			sd.setSave_dt(today);
			sd.setSeq(AddUtil.addZero2(i));
			sd.setCpt_cd(cpt_cd[i]);
			sd.setLast_mon_amt(AddUtil.parseDigit4(last_mon_amt[i]));
			sd.setOver_mon_amt(AddUtil.parseDigit4(over_mon_amt[i]));
			sd.setThis_mon_new_amt(AddUtil.parseDigit4(this_mon_new_amt[i]));
			sd.setThis_mon_plan_amt(AddUtil.parseDigit4(this_mon_plan_amt[i]));
			sd.setThis_mon_pay_amt(AddUtil.parseDigit4(this_mon_pay_amt[i]));
			sd.setThis_mon_jan_amt(AddUtil.parseDigit4(this_mon_jan_amt[i]));
			sd.setReg_id(user_id);
			sd.setWhan_amt(AddUtil.parseDigit(whan_amt[i]));
			if(!ad_db.insertStatDebt(sd)) flag = 1;
		}
	}
%>
<form name='form1' action='stat_debt_sc.jsp' target='d_content' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=today%>'>
</form>
<script language='javascript'>
	var fm = document.form1;
<%	if(flag2 != 0){%>
	alert('이미 등록되었습니다.\n\n동일일자는 한번만 등록 가능합니다.');
<%	}else{
		if(flag != 0){%>
		alert('등록 오류발생!');
<%		}else{%>
		alert('등록되었습니다.');
		fm.submit();				
<%		}
	}%>
</script>
</body>
</html>