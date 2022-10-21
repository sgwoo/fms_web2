<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.stat_total.*"%>
<jsp:useBean id="st_db" scope="page" class="acar.stat_total.StatTotalDatabase"/>


<html><head><title>FMS</title>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String save_dt = request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String gubun_dt = request.getParameter("gubun_dt")==null?"":request.getParameter("gubun_dt");
	int size1 = request.getParameter("total_size1")==null?0:AddUtil.parseDigit(request.getParameter("total_size1"));
	int size2 = request.getParameter("total_size2")==null?0:AddUtil.parseDigit(request.getParameter("total_size2"));	
	int size3 = request.getParameter("total_size3")==null?0:AddUtil.parseDigit(request.getParameter("total_size3"));	
	String today = AddUtil.getDate(4);
	int flag = 0;
	int flag2 = 0;
	
	flag2 = st_db.getInsertYn("stat_total", today);
	
	if(flag2 == 0){
		String bus_id[] = request.getParameterValues("bus_id");
		String tot_ga[] = request.getParameterValues("tot_ga");
		String m_ga[] = request.getParameterValues("m_ga");
		String d_ga[] = request.getParameterValues("d_ga");
		String d_per[] = request.getParameterValues("d_per");
		String b_ga[] = request.getParameterValues("b_ga");
		String avg_ga[] = request.getParameterValues("avg_ga");
		
		for(int i=0; i<size1+size2+size3; i++){
			StatTotalBean bean = new StatTotalBean();
//			bean.setSave_dt(today);
			bean.setSave_dt(gubun_dt);			
			bean.setSeq(AddUtil.addZero2(i));
			bean.setUser_id(bus_id[i]);			
			bean.setMng_ga(AddUtil.parseFloat(m_ga[i]));
			bean.setDly_ga(AddUtil.parseFloat(d_ga[i]));
			bean.setBus_ga(AddUtil.parseFloat(b_ga[i]));
			bean.setTot_ga(AddUtil.parseFloat(tot_ga[i]));
			bean.setAvg_ga(AddUtil.parseFloat(avg_ga[i]));
			bean.setDly_per(AddUtil.parseFloat(d_per[i]));			
			bean.setReg_id(user_id);
			
			if(!st_db.insertStatTotal(bean)) flag = 1;
		}
	}
%>
<form name='form1' action='stat_total_sc.jsp' target='d_content' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='save_dt' value='<%=gubun_dt%>'>
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