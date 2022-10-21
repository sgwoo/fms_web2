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
	
	//�α��λ�������� ��������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	//���ȸ��, ������� ��� �� ����
	for(int i=0; i<actnParam.length; i++){
		
		if(((String)actnParam[i]).length() > 8){	//�Ķ���ͱ��̿� ���� �ʱⰪ ���� 
			String[] actnParam_arr 	=	 actnParam[i].split("//");
			car_mng_id = actnParam_arr[0];
			seq = actnParam_arr[1];
		}else{	
			car_mng_id = actnParam[i].replace("//","");
			seq = "";
		} 
		result = 0;
		
		//insert, update �б�
		if(seq.equals("")){		//�̹�ȸ�� ó������ ��� ��ǰ�� ���� ��ǰ��Ȳ���� �Ѿ�� ���
			auction 		= new Offls_auctionBean();
			auction.setCar_mng_id(car_mng_id);
			auction.setDamdang_id("000004");
			result = olaD.insAuction(auction);
			
			if(result == 1){	//��ϵ� �� ���ڵ忡 ������ ���� ������Ʈ
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
<title>FMS - ��ų��� �ϰ����� �˾�</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='javascript'>
	var paramCnt 	= '<%=actnParam.length%>';
	var resultCnt 	= '<%=cnt%>';
	if(paramCnt == resultCnt){
		alert("���� ó�� �Ǿ����ϴ�.");
		parent.window.close();
		parent.opener.location.reload();
		//parent.opener.opener.location.reload();
	}else{
		alert("�ϰ����� �� �����߻�!");
	}
	//window.close();
</script>
</head>
</html>