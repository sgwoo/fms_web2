<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String size		= request.getParameter("size")==null?"":request.getParameter("size");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String call_sp 	= request.getParameter("call_sp")==null?"":request.getParameter("call_sp");
	int idx 		= request.getParameter("idx")==null?0:AddUtil.parseInt(request.getParameter("idx"));
	
	String sort_code[] 		= request.getParameterValues("sort_code");
	String seq[] 			= request.getParameterValues("seq");
	String sort_gubun[] 	= request.getParameterValues("sort_gubun");
	String b_s_st[] 		= request.getParameterValues("b_s_st");
	String b_min_dpm[] 		= request.getParameterValues("b_min_dpm");
	String b_max_dpm[] 		= request.getParameterValues("b_max_dpm");
	String b_mon[] 			= request.getParameterValues("b_mon");
	String b_dist[] 		= request.getParameterValues("b_dist");
	String b_user_per[] 	= request.getParameterValues("b_user_per");
	String reg_dt[] 		= request.getParameterValues("reg_dt");
	String b_day[] 			= request.getParameterValues("b_day");
	String b_mon_only[] 	= request.getParameterValues("b_mon_only");
	String b_dist_only[] 	= request.getParameterValues("b_dist_only");
	
	String r_sort_code = "";
	
	int count = 0;
	
	
	
	int vt_size = sort_code.length;
	
	
	for(int i=0;i < vt_size;i++){
		
		r_sort_code = sort_code[i]==null?"":sort_code[i];
		
		SuiSortVarBean var = rs_db.getSuiSortVar(r_sort_code, AddUtil.parseInt(seq[i]));
		
		var.setSort_gubun	(sort_gubun[i]);
		var.setB_mon		(AddUtil.parseInt(b_mon[i]));
		var.setB_dist		(AddUtil.parseInt(b_dist[i]));
		var.setB_use_per	(AddUtil.parseFloat(b_user_per[i]));
		var.setB_s_st		(b_s_st[i]);
		var.setB_min_dpm	(AddUtil.parseInt(b_min_dpm[i]));
		var.setB_max_dpm	(AddUtil.parseInt(b_max_dpm[i]));
		var.setB_day		(AddUtil.parseInt(b_day[i]));
		var.setB_mon_only	(AddUtil.parseInt(b_mon_only[i]));
		var.setB_dist_only	(AddUtil.parseInt(b_dist_only[i]));
		
		
		if(i == idx || idx == 999){
			
			//등록
			if(mode.equals("i")){
				if(i == idx && var.getSort_code().equals("") && !r_sort_code.equals("")){
					var.setSort_code	(r_sort_code);
					var.setSeq			(AddUtil.parseInt(seq[i]));
					var.setReg_dt		(reg_dt[i]);
					var.setSort_gubun	(sort_gubun[i]);
					
					count = rs_db.insertSuiSortVar(var);
				}
			}
			
			//수정
			if(mode.equals("u")){
				//기준일자 비교하여 업그레이드처리
				if(!var.getReg_dt().equals(reg_dt[i])){
					//업그레이드 등록
					var.setSeq			(AddUtil.parseInt(seq[i])+1);
					var.setReg_dt		(reg_dt[i]);
					
					count = rs_db.insertSuiSortVar(var);
				}else{
					//수정
					count = rs_db.updateSuiSortVar(var);
				}
			}
			
			//삭제
			if(mode.equals("d")){
				if(i == idx){
					count = rs_db.deleteSuiSortVar(var);
				}
			}
		}
	}
	
	if(call_sp.equals("Y")){
		//매각대상선별기준 당일 마감하기
		String  d_flag =  rs_db.call_sp_sui_sort();
	}
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>
<form name='form1' action='sui_sort_frame.jsp' method="POST" target='d_content'>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
	alert("정상적으로 수정되었습니다.");
	parent.location.reload();
	<%if(call_sp.equals("Y")){%>	
	fm.submit();
	<%}%>
//-->
</script>
</body>
</html>
