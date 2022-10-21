<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.offls_pre.*, acar.user_mng.*"%>
<jsp:useBean id="olyD" class="acar.offls_pre.Offls_preDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%

	String destphone	= request.getParameter("destphone")==null?"":request.getParameter("destphone");
	String s_destphone_off	= request.getParameter("s_destphone_off")==null?"":request.getParameter("s_destphone_off");

	
	String vid1[] = request.getParameterValues("c_id");
	
	int vid_size = 0;
	vid_size = vid1.length;
	
	String car_mng_id = "";
	
	/*경매장 ID apprsl에 넣기*/
	String actn_id = "";
	int result = 0;
	
	if(destphone.equals("시화") || s_destphone_off.equals("시화 경매장 탁송")){
		actn_id = "000502";
	}else if(destphone.equals("분당") || s_destphone_off.equals("분당 글로비스 탁송")){	
		actn_id = "013011";
	}else if(destphone.equals("양산") || s_destphone_off.equals("양산 글로비스 탁송")){	
		actn_id = "061796";	
	}else if(destphone.equals("010-9026-1853")||destphone.equals("aj") || s_destphone_off.equals("AJ경매장 탁송")){
		actn_id = "020385";
	//}else if(destphone.equals("010-5050-3311")||destphone.equals("엠파크")){
	//	actn_id = "013222";
	}else if(destphone.equals("롯데렌탈") || s_destphone_off.equals("롯데 경매장 탁송")){
		actn_id = "022846";
	}else if(destphone.equals("오산") || destphone.equals("010-5058-1414") || s_destphone_off.equals("Kcar 탁송") ){  //20191014 추가 
		actn_id = "048691";	
	}
	
	
	for(int i=0;i < vid_size;i++){		
		car_mng_id = vid1[i];		
		result = olyD.upApprsl2(car_mng_id, actn_id, ck_acar_id);
		int result2 = olyD.upApprsl2(car_mng_id, actn_id, ck_acar_id);
	  }
	
		
%>
<script language='javascript'>
<!--
<%if(result > 0){%>
	alert('저장되었습니다.');
<%}else{%>
	alert('ERRRRRRRRRRRROOOOOORRRRRRRR.');
<%}%>
//-->
</script>
</body>
</html>