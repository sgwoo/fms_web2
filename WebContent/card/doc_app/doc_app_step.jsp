<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*, acar.bill_mng.*, acar.user_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase 	umd 	= UserMngDatabase.getInstance();
		
		
	out.println("카드전표 자동전표 발행하기 1단계"+"<br><br>");
	
	
	//사용자
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
   int flag = 0;
	int seq = 0;

	String vid[] = request.getParameterValues("ch_l_cd");
	String vid_num="";
	String ch_buy_id="";
	String ch_cardno="";
	int vid_size = vid.length;
	out.println("선택건수="+vid_size+"<br><br>");

	out.println("====================================<br>");

	//[1단계] 선택한 전표 조회

	for(int i=0;i < vid_size;i++){
		vid_num 	= vid[i];
		ch_buy_id 		= vid_num.substring(0,6);
		ch_cardno 		= vid_num.substring(6);
				
//		System.out.println(i+")카드번호="+ch_cardno+",전표번호="+ch_buy_id);
		
	//	out.println("카드번호="+ch_cardno+"<br>");
	//	out.println("전표번호="+ch_buy_id+"<br>");
		
			//카드정보
	 CardDocBean cd_bean = CardDb.getCardDoc(ch_cardno, ch_buy_id);
	 	 
	 String acct_code 	= cd_bean.getAcct_code();
	String acct_code_g 	= cd_bean.getAcct_code_g();
	String acct_code_g2 = cd_bean.getAcct_code_g2();
	String acct_cont 	= cd_bean.getAcct_cont()==null?"":cd_bean.getAcct_cont();

	String item_name	= cd_bean.getItem_name();
	String doc_acct_cont = "";
			
	if(!item_name.equals("") && cd_bean.getItem_name().indexOf("(")!=-1){
		item_name 	= cd_bean.getItem_name().substring(0, cd_bean.getItem_name().indexOf("("));
	}
			
	String user_su 		= cd_bean.getUser_su();
	String user_cont	= cd_bean.getUser_cont();

		//복리후생비
		if(acct_code.equals("00001")){
			if(acct_code_g.equals("1")      && acct_code_g2.equals("1"))	doc_acct_cont = "조식대:"+acct_cont;
			else if(acct_code_g.equals("1") && acct_code_g2.equals("2"))	doc_acct_cont = "중식대:"+acct_cont;
			else if(acct_code_g.equals("1") && acct_code_g2.equals("3"))	doc_acct_cont = "석식대:"+acct_cont;
			else if(acct_code_g.equals("2") && acct_code_g2.equals("4"))	doc_acct_cont = "회사전체모임:"+acct_cont;
			else if(acct_code_g.equals("2") && acct_code_g2.equals("5"))	doc_acct_cont = "부서별정기모임:"+acct_cont;
			else if(acct_code_g.equals("2") && acct_code_g2.equals("6"))	doc_acct_cont = "부서별부정기회식:"+acct_cont;
			else if(acct_code_g.equals("2") && acct_code_g2.equals("15"))	doc_acct_cont = "사내동호회:"+acct_cont;
			else if(acct_code_g.equals("15") )								doc_acct_cont = "경조사:"+acct_cont;
			else if(acct_code_g.equals("30") )								doc_acct_cont = "포상휴가:"+acct_cont;
			else 							 								doc_acct_cont = acct_cont;

		//차량유류비
		}else if(acct_code.equals("00004")){
			if(acct_code_g.equals("13"))			doc_acct_cont = "가솔린";
			else if(acct_code_g.equals("4"))		doc_acct_cont = "디젤";
			else if(acct_code_g.equals("5"))		doc_acct_cont = "LPG";
			else if(acct_code_g.equals("27"))		doc_acct_cont = "전기차충전";	//전기차충전 추가
			
			if(acct_code_g2.equals("11"))			doc_acct_cont = doc_acct_cont+"-"+acct_cont;
			else if(acct_code_g2.equals("12"))		doc_acct_cont = doc_acct_cont+"-"+acct_cont;
			else if(acct_code_g2.equals("13"))		doc_acct_cont = doc_acct_cont+"-"+acct_cont;
			
				
		//차량정비비
		}else if(acct_code.equals("00005")){
			
			if(acct_code_g.equals("6"))				doc_acct_cont = "일반정비:"+acct_cont;
			else if(acct_code_g.equals("7"))		doc_acct_cont = "자동차검사:"+acct_cont;
			else if(acct_code_g.equals("18"))		doc_acct_cont = "번호판대금:"+acct_cont;		
			else if(acct_code_g.equals("21"))		doc_acct_cont = "재리스정비:"+acct_cont;	
			else if(acct_code_g.equals("22"))		doc_acct_cont = acct_cont;	
							
		//사고수리비
		}else if(acct_code.equals("00006")){
		
			doc_acct_cont = acct_cont;			
		
		//여비교통비
		}else if(acct_code.equals("00003")){
		
			//출장비
			if(acct_code_g.equals("9"))				doc_acct_cont = "출장비:"+acct_cont;
			//교통비
			else if(acct_code_g.equals("12"))		doc_acct_cont = "기타교통비:"+acct_cont;
			//하이패스
			else if(acct_code_g.equals("20"))		doc_acct_cont = "하이패스:"+acct_cont;
				//하이패스
			else if(acct_code_g.equals("32"))		doc_acct_cont = "제안참석:"+acct_cont;
		
		//접대비
		}else if(acct_code.equals("00002")){
		
			//식대
			if(acct_code_g.equals("11"))			doc_acct_cont = "식대:"+acct_cont;
			//경조사
			else if(acct_code_g.equals("12"))		doc_acct_cont = "경조사:"+acct_cont;
			//기타
			else if(acct_code_g.equals("14"))		doc_acct_cont = acct_cont;
		
		//통신비
		}else if(acct_code.equals("00009")){
													doc_acct_cont = "통신비:"+acct_cont;
		
		//대여사업차량
		}else if(acct_code.equals("00016")){
			if(acct_code_g.equals("19"))			doc_acct_cont = "차량등록세:"+acct_cont;
		
		//리스사업차량
		}else if(acct_code.equals("00017")){
			if(acct_code_g.equals("19"))			doc_acct_cont = "차량등록세:"+acct_cont;
		
		}else{
		
			doc_acct_cont = acct_cont;
		
		}

		if(!user_cont.equals("")) 		doc_acct_cont = doc_acct_cont+" "+user_cont;
		if(!user_su.equals("")) 		doc_acct_cont = doc_acct_cont+"("+user_su+"명)";
			 
		
	   if(cd_bean.getAcct_cont().equals("")){
    	 if(!CardDb.updateCardDoc(ch_cardno, ch_buy_id, doc_acct_cont) ) flag += 1;	
	  }
			
		//자동전표 프로시저 호출----------------------------------------------------------------------------
		//int flag4 = 0;
	   System.out.println(" 자동전표 프로시저 등록 "+sender_bean.getUser_nm()+" "+ch_cardno+" "+ch_buy_id + " <br>"  );
		String  d_flag1 =  neoe_db.call_sp_card_account(sender_bean.getUser_nm(), "", ch_cardno, ch_buy_id);			
					
	}
%>

<html>
<head><title></title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'doc_app_frame.jsp';
		fm.target = "d_content";
		fm.submit();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
<a href="javascript:go_step()">완료</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생%>
		alert("자동전표 작성중 에러가 발생하였습니다.");
<%	}else{//정상%>
		alert("정상적으로 발행하였습니다.");
		go_step();
<%	}%>
//-->
</script>
</form>
</body>
</html>
