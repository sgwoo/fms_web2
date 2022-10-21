<%@ page language="java" import="java.util.*, acar.common.*, acar.util.*" contentType="text/html;charset=euc-kr"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>
<%
	int tot_amt_tm		= request.getParameter("t_tot_amt_tm").equals("")?0:Integer.parseInt(request.getParameter("t_tot_amt_tm"));//회차
	String est_dt		= request.getParameter("t_fst_pay_dt")==null?"":request.getParameter("t_fst_pay_dt");//1회차납입일
	String rtn_est_dt	= request.getParameter("rtn_est_dt")==null?"":request.getParameter("rtn_est_dt");//약정일
	
	String mode	= request.getParameter("mode")==null?"":request.getParameter("mode");

	CommonDataBase c_db = CommonDataBase.getInstance();
%>

<script language='javascript'>
<%	if(!est_dt.equals("") && !rtn_est_dt.equals("")){
		for(int i = 0 ; i < tot_amt_tm ; i++){
			String set_dt = c_db.addMonth(est_dt, i);//1회차납입일+1개월씩 증가
			if(!rtn_est_dt.equals("99")){
				if(!set_dt.substring(5,10).equals("02-28") && !set_dt.substring(5,10).equals("02-29")){
					set_dt=set_dt.substring(0,8)+AddUtil.addZero(rtn_est_dt);
//					set_dt=set_dt.substring(0,8)+rtn_est_dt;
				}
			}
/*			if(!rtn_est_dt.equals("말일") && !set_dt.substring(8,10).equals("28")){
				set_dt=set_dt.substring(0,8)+est_dt.substring(8,10);
			}else if(!rtn_est_dt.equals("말일") && est_dt.substring(5,10).equals("02-28") && i>0){
				set_dt=set_dt.substring(0,8)+rtn_est_dt;
			}*/
%>
			
		<%if(mode.equals("etc")){%>		
		parent.form1.t_est_dt[<%=i+1%>].value = '<%=set_dt%>';
		<%}else{%>
		parent.i_in.form1.t_est_dt[<%=i%>].value = '<%=set_dt%>';
		<%}%>
		
<%		}%>
<%	}%>
</script>
</body>
</html>
