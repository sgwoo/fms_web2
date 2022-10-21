<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.asset.*"%>
<jsp:useBean id="bean" class="acar.asset.AssetMoveBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String asset_code = request.getParameter("asset_code")==null?"":request.getParameter("asset_code");	
	
	String assch_date= request.getParameter("assch_date")==null?"":request.getParameter("assch_date");
	String assch_type= request.getParameter("assch_type")==null?"":request.getParameter("assch_type");
	String assch_rmk= request.getParameter("assch_rmk")==null?"":request.getParameter("assch_rmk");
	
	int s_cnt = 0;
	String s_flag = "";

	AssetDatabase as_db = AssetDatabase.getInstance();
	
	bean.setAsset_code	(asset_code);
	bean.setAssch_date	(assch_date);
	bean.setAssch_type	(assch_type);
	bean.setAssch_rmk	(assch_rmk);
	bean.setCap_amt	(request.getParameter("cap_amt")==null?0:AddUtil.parseDigit(request.getParameter("cap_amt")));//자본적지출
	bean.setSale_quant	(0);
	bean.setSale_amt	(0);
				
	s_cnt = as_db.insertAssetMove(bean);
	System.out.println(s_cnt); 
	System.out.println(asset_code + "|" + assch_date ); 
	

	// 상각 재계산은 별도 처리 (해당 기수에서만 수정 가능함 - 과거는 결산이 끝난 관계로 재계산 할 수 없음)
//	s_flag =  as_db.call_sp_insert_assetmove1(asset_code, s_cnt, user_id );
%>
<script language='javascript'>

<%	if( s_cnt > 0 ){%>
		alert('정상적으로 처리되었습니다. 반드시 상각재계산도 처리하셔야 합니다.');

<%	}else{ //에러%>
		alert('처리되지 않았습니다\n\n에러발생!');
<%	}%>
</script>
</body>
</html>
