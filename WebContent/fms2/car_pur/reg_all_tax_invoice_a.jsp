<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<title>FMS</title>
</head>
<body>
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String fn 		= request.getParameter("fn")==null? "":request.getParameter("fn");
	
	String[] m_id = request.getParameterValues("m_id");		
	String[] l_cd = request.getParameterValues("l_cd");
	
	int cnt = m_id.length;
	boolean flag = false;
	int flagCnt = 0;
	boolean flagReal = false;
	
	if(fn.equals("save_all")){
		String[] dlv_dt_arr = request.getParameterValues("dlv_dt");
		String[] rpt_no_arr = request.getParameterValues("rpt_no");
		//추가
		String[] dlv_est_dt_arr = request.getParameterValues("dlv_est_dt");
		String[] car_tax_dt_arr = request.getParameterValues("car_tax_dt");
		String[] car_amt_dt_arr = request.getParameterValues("car_amt_dt");
		
		for(int i=0; i < cnt; i++){
			String dlv_dt = dlv_dt_arr[i];
			String rpt_no = rpt_no_arr[i];
			String rent_mng_id = m_id[i];
			String rent_l_cd = l_cd[i];
			//추가
			String dlv_est_dt = dlv_est_dt_arr[i];
			String car_tax_dt = car_tax_dt_arr[i];
			String car_amt_dt = car_amt_dt_arr[i];
			
			boolean flag1 = a_db.updateAllParams( dlv_dt, rpt_no, rent_mng_id, rent_l_cd );
			boolean flag2 = a_db.updateAllDlvDt( dlv_dt, rent_mng_id, rent_l_cd );
			boolean flag3 = a_db.updateAllCartax( car_tax_dt, car_amt_dt, rent_mng_id, rent_l_cd );
			if(flag1==true && flag2==true && flag3==true){
				flagCnt++;
			}
		}	
	}
	
	if(flagCnt==cnt){
		flagReal = true;
	}
%>
	<script type="text/javascript" >
		var flagReal = <%=flagReal%>;
		if(flagReal==true){
			alert("수정되었습니다.");
		}else{
			alert("저장 중 오류발생! \n\n관리자에게 문의하세요.");
		}
		window.parent.document.location.reload();		
	</script>
<%	
%>	
</body>
</html>