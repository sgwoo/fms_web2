<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.common.*, acar.bill_mng.*, acar.user_mng.*"%>
<%@ page import="card.*" %>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>


<%
	gubun1 = "3"; //임/직원지급용
	chk1 = "Y"; //사용
	
	Vector vts = CardDb.getCardMngList(s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
	int vt_size = vts.size();
	
	String buy_user_nm = "";
	int data_no =0;
	int flag = 0;
	String seq = "";
	
	CommonDataBase 		c_db 	= CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase    	umd 	= UserMngDatabase.getInstance();
	
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vts.elementAt(i);
		
		String card_no = String.valueOf(ht.get("CARDNO"));
		
		//카드정보
		CardBean c_bean = CardDb.getCard(card_no);
				
		String neoe_card_nm = neoe_db.getCodeByNm("cardno", card_no);
		
		out.println(card_no+"="+neoe_card_nm+"<br>");
		
		//네오엠에 카드 입력확인후 미등록이면 네오엠에도 카드정보를 등록한다.
		if(neoe_card_nm.equals("")){
			UsersBean user_bean = umd.getUsersBean(c_bean.getCard_mng_id());
			Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
			Hashtable br = c_db.getBranch(user_bean.getBr_id());
			flag = neoe_db.insertCardmana(c_bean, per, br);
		}

			
	}

	int result_cnt = 0;
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<p>엑셀 파일 읽어 보험 등록하기
</p>
<form action="" method='post' name="form1">
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--
	alert('처리되었습니다.');
//-->
</SCRIPT>
</BODY>
</HTML>