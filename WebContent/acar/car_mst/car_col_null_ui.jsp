<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*, acar.common.*" %>
<jsp:useBean id="co_bean" class="acar.car_mst.CarColBean" scope="page"/>
<jsp:useBean id="ce_bean" class="acar.common.CommonEtcBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code 		= request.getParameter("code")==null?"":request.getParameter("code");
	String car_u_seq 	= request.getParameter("car_u_seq")==null?"":request.getParameter("car_u_seq");
	int count = 0;

	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CommonDataBase 	  c_db  = CommonDataBase.getInstance();
	
	if(cmd.equals("i")||cmd.equals("u")||cmd.equals("d")){
		co_bean.setCar_comp_id	(car_comp_id);
		co_bean.setCar_cd		(code);
		co_bean.setCar_u_seq	(car_u_seq);
		co_bean.setUse_yn		(request.getParameter("use_yn")==null?"":request.getParameter("use_yn"));
		co_bean.setCar_c_seq	(request.getParameter("car_c_seq")==null?"":request.getParameter("car_c_seq"));
		co_bean.setCar_c		(request.getParameter("car_c")==null?"":request.getParameter("car_c"));
		co_bean.setCar_c_p		(request.getParameter("car_c_p")==null?0:AddUtil.parseDigit(request.getParameter("car_c_p")));
		co_bean.setCar_c_dt		(request.getParameter("car_c_dt")==null?"":request.getParameter("car_c_dt"));
		co_bean.setEtc			(request.getParameter("etc")==null?"":request.getParameter("etc"));
		co_bean.setCol_st		(request.getParameter("col_st")==null?"":request.getParameter("col_st"));
		co_bean.setJg_opt_st	(request.getParameter("jg_opt_st")==null?"":request.getParameter("jg_opt_st"));
		
	}else if(cmd.equals("file_bigo_i")||cmd.equals("file_bigo_u")){
		ce_bean.setTable_nm		("acar_attach_file");
		ce_bean.setCol_1_nm		("content_code");
		ce_bean.setCol_1_val	("CAR_COL_CAT");
		ce_bean.setCol_2_nm		("content_seq");
		ce_bean.setCol_2_val	(request.getParameter("content_seq")==null?"":request.getParameter("content_seq"));
		ce_bean.setEtc_nm		("FILE_BIGO");
		ce_bean.setEtc_content	(request.getParameter("etc_content")==null?"":request.getParameter("etc_content"));
		ce_bean.setReg_id		(user_id);
	}
	
	if(cmd.equals("i")){
		count = a_cmb.insertCarColTrim(co_bean);
	}else if(cmd.equals("u")){
		count = a_cmb.updateCarColTrim(co_bean);
	}else if(cmd.equals("d")){
		count = a_cmb.deleteCarColTrim(co_bean);
	}else if(cmd.equals("file_bigo_i")){
		count = c_db.insertCommonEtc(ce_bean);
	}else if(cmd.equals("file_bigo_u")){
		count = c_db.updateCommonEtc(ce_bean);
	} else if(cmd.equals("chk_u")){
		String check_value[] = request.getParameterValues("check_value");
		int check_value_length = check_value.length;
		
		for(int i=0; i<check_value_length; i++){
			String check_val = check_value[i];
			
			co_bean.setCar_comp_id	(car_comp_id);
			co_bean.setCar_cd		(code);
			co_bean.setCar_u_seq	(check_val.split("_")[0]);
			co_bean.setUse_yn		(request.getParameter("use_yn")==null?"":request.getParameter("use_yn"));
			co_bean.setCar_c_seq	(check_val.split("_")[1]);
			co_bean.setCar_c		(check_val.split("_")[2]);
			co_bean.setCar_c_p		(Integer.parseInt(check_val.split("_")[3]));
			co_bean.setCar_c_dt	(check_val.split("_")[4]);
			co_bean.setEtc			(check_val.split("_")[5]);
			co_bean.setCol_st		(check_val.split("_")[6]);
			co_bean.setJg_opt_st	(check_val.split("_")[7]);
			
			count = a_cmb.updateCarColTrim(co_bean);
		}
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

<script>
<%if(cmd.equals("u")||cmd.equals("file_bigo_u")|| cmd.equals("chk_u")){
		if(count==1){%>

			alert("정상적으로 수정되었습니다.");
			parent.Search();

<%		}
 }else if(cmd.equals("i")||cmd.equals("file_bigo_i")){
		if(count==1){%>

			alert("정상적으로 등록되었습니다.");
			parent.Search();

<%		}
 }else{
		if(count==1){%>

			alert("정상적으로 삭제되었습니다.");
			parent.Search();

	<%	}
}	%>
</script>
</body>
</html>