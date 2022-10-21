<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.asset.*" %>
<jsp:useBean id="bean" class="acar.asset.AssetMaBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	// 자산 수정  - 자산 수정 이후 해당 기수이후 상각금액 수정되야 함
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String asset_code 			= request.getParameter("asset_code")==null?"":request.getParameter("asset_code");
	String asset_name 			= request.getParameter("asset_name")==null?"":request.getParameter("asset_name");
	
	String gisu 	= request.getParameter("gisu")==null?"":request.getParameter("gisu");
	
	String cmd 		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String s_flag = "";
	String car_mng_id = "";
	
	boolean d_flag = false;
		
	
	//당기 기수
	int count=0;
	int cnt=0;
	
	AssetDatabase as_db = AssetDatabase.getInstance();
	
	bean = as_db.getAssetMa(asset_code);
	
	car_mng_id = bean.getCar_mng_id() ;
	 
	bean.setAsset_code	(asset_code);
	bean.setAsset_name	(asset_name);
	bean.setLife_exist	(request.getParameter("life_exist")==null?0:AddUtil.parseInt(request.getParameter("life_exist")));	//내용연수
	bean.setNdepre_rate	(request.getParameter("ndepre_rate")==null?0.0f:AddUtil.parseFloat(request.getParameter("ndepre_rate"))); //상각율
//	bean.setGet_amt		(request.getParameter("get_amt")==null?0:AddUtil.parseInt(request.getParameter("get_amt")));	//취득금액
			
	if ( cmd.equals("u") ) {		
		count = as_db.updateAssetMa(bean);
//		s_flag =  as_db.call_sp_insert_assetdep(gisu, asset_code, user_id ); //사용못함. 
	}
	
	if ( cmd.equals("d") ) {		
		d_flag = as_db.deleteAssetMa(asset_code, car_mng_id );
	}		
	
	
	if ( cmd.equals("ud") ) {		
		s_flag = as_db.updateAssetMaDeprf_yn(asset_code );
	}		
	
//	System.out.println(s_flag);
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table.css"></link>
<script language="JavaScript">
<!--
	function NullAction(){	
	<%	if( s_flag.equals("0")){%>
 	  			alert("정상적으로 수정되었습니다.");
	 	  		var theForm = document.form1;
	 	  		theForm.target='d_content';
  				theForm.submit();
  	<%}	if( d_flag ){%>
 	  			alert("정상적으로 삭제되었습니다.");
	 	  		var theForm = document.form1;
	 	  		theForm.target='d_content';
  				theForm.submit();			
	<%	}else {%>
 	  			alert("수정 오류!");
	<% } %>
   
   }
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">
<form action="./asset_s_frame.jsp" name="form1" method="post">
<input type="hidden" name="cmd" valaue="nd">
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
</form>
</body>
</html>
