<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.offls_actn.*"%>
<jsp:useBean id="auction" class="acar.offls_actn.Offls_auctionBean" scope="page"/>
<jsp:useBean id="olaD" class="acar.offls_actn.Offls_actnDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String 	 actn_dt 		= request.getParameter("actn_dt")==null?"":request.getParameter("actn_dt");
	String 	 actn_cnt 		= request.getParameter("actn_cnt")==null?"":request.getParameter("actn_cnt");
	String[] actnParam 		= request.getParameterValues("actnParam");
	String 	 car_mng_id = "";
	String 	 seq = "";
	int cnt = 0;
	int result;
	
	//로그인사용자정보 가져오기
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	//경매회차, 경매일자 등록 및 수정
	for(int i=0; i<actnParam.length; i++){
		
		if(((String)actnParam[i]).length() > 8){	//파라미터길이에 따른 초기값 세팅 
			String[] actnParam_arr 	=	 actnParam[i].split("//");
			car_mng_id = actnParam_arr[0];
			seq = actnParam_arr[1];
		}else{	
			car_mng_id = actnParam[i].replace("//","");
			seq = "";
		} 
		result = 0;
		
		//insert, update 분기
		if(seq.equals("")){		//이번회차 처음으로 경매 출품을 위해 출품현황으로 넘어온 경우
			auction 		= new Offls_auctionBean();
			auction.setCar_mng_id(car_mng_id);
			auction.setDamdang_id("000004");
			result = olaD.insAuction(auction);
			
			if(result == 1){	//등록된 빈 레코드에 나머지 정보 업데이트
				seq = olaD.getAuction_maxSeq(car_mng_id);
				result = olaD.updAuctCntDt(car_mng_id, seq, actn_cnt, actn_dt, user_id);
			}
		}else{
			result = olaD.updAuctCntDt(car_mng_id, seq, actn_cnt, actn_dt, user_id);
		}
		if(result == 1){	cnt++;	}
	}
%>
<html>
<head>
<title>FMS - 경매내용 일괄수정 팝업</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='javascript'>
	var paramCnt 	= '<%=actnParam.length%>';
	var resultCnt 	= '<%=cnt%>';
	if(paramCnt == resultCnt){
		alert("정상 처리 되었습니다.");
		parent.window.close();
		parent.opener.location.reload();
		//parent.opener.opener.location.reload();
	}else{
		alert("일괄수정 중 오류발생!");
	}
	//window.close();
</script>
</head>
</html>