<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.pay_mng.*, acar.inside_bank.*"%>
<%@ include file="/acar/cookies.jsp" %> 

<%	
	PayMngDatabase 			pm_db 	= PayMngDatabase.getInstance();
	PaySearchDatabase 	ps_db 	= PaySearchDatabase.getInstance();	
	InsideBankDatabase 	ib_db 	= InsideBankDatabase.getInstance();

	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height 	= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	int ib_result = 0;
	int flag = 0;
	

	String vid[] 	= request.getParameterValues("ch_cd");
	String actseq 	= "";
	int act_modify = 0;
	
	int vid_size = vid.length;
	
	out.println("선택건수="+vid_size+"<br><br>");
	
	
	for(int i=0;i < vid_size;i++){
		
		actseq = vid[i];
		
		act_modify = 0;
		
		//송금원장
		PayMngActBean act 	= pm_db.getPayAct(actseq);
		
		
		//신한은행 모계좌 출금일때만 처리됨.
		if(!act.getA_bank_no().equals("140-004-023871")){
			out.println("continue 신한은행 모계좌 출금일때만 처리됨");
			continue;
		}
		
		
		//동일계좌가 아닐때		
		if(act.getA_bank_no().equals(act.getBank_no())){
			out.println("continue 동일계좌가 아닐때");
			continue;
		}
		
		
		//송금수수료 처리-원장에서 처리
		Vector vt3 =  pm_db.getPayActList(act.getBank_code(), "", act.getOff_nm(), act.getBank_no(), act.getA_bank_no());
		int vt_size3 = vt3.size();
		
				
		if(vt_size3==0){
			out.println("continue 송금수수료 처리-원장에서 처리");
			continue;
		}
		
		
		
		
		//1. 은행연동테이블 등록-------------------------------------------------------------------------------------------
		
		IbBulkTranBean it = new IbBulkTranBean();
		
		it.setTran_dt							(act.getAct_dt());
		it.setGroup_nm        		(AddUtil.substringb(act.getOff_nm(),30));
		it.setTran_ji_acct_nb			(act.getA_bank_no());
		it.setTran_ip_bank_id 		(act.getBank_cms_bk());
		it.setTran_ip_acct_nb 		(act.getBank_no());
		it.setTran_remittee_nm		(AddUtil.substringb(act.getBank_acc_nm(),20));
		it.setTran_amt_req     		(String.valueOf((long)act.getAmt()));
		it.setTran_ji_naeyong 		("");
		it.setTran_ip_naeyong 		(AddUtil.substringb(act.getBank_memo(),14));
		it.setTran_cms_cd     		(act.getCms_code());
		it.setTran_memo       		(AddUtil.substringb(act.getOff_nm(),20));
		it.setUpche_key       		(actseq);
						
		//차량대금-삼성카드일때는 카드번호를 CMS코드에 넣어줌.
		if(act.getOff_nm().equals("삼성법인(선불)차량대") || act.getOff_nm().equals("삼성카드")){			
			Vector p_vt =  pm_db.getPayActList(act.getBank_code(), "", act.getOff_nm(), act.getBank_no(), act.getA_bank_no());
			int p_vt_size = p_vt.size();			
			if(p_vt_size>0){
				for(int p = 0 ; p < 1 ; p++){
					Hashtable p_ht = (Hashtable)p_vt.elementAt(p);
					it.setTran_cms_cd		(String.valueOf(p_ht.get("CARD_NO")));
					it.setTran_cms_cd		(AddUtil.replace(it.getTran_cms_cd(),"-",""));
				}
			}
		}
		
		//자동차보험료-삼성카드일대는 카드번호를 CMS코드에 넣어줌.
		if(act.getOff_nm().equals("삼성화재")||act.getOff_nm().equals("동부화재")){			
			Vector p_vt =  pm_db.getPayActList(act.getBank_code(), "", act.getOff_nm(), act.getBank_no(), act.getA_bank_no());
			int p_vt_size = p_vt.size();			
			if(p_vt_size>0){
				for(int p = 0 ; p < 1 ; p++){
					Hashtable p_ht = (Hashtable)p_vt.elementAt(p);
					it.setTran_cms_cd		(String.valueOf(p_ht.get("CARD_NO")));
					it.setTran_cms_cd		(AddUtil.replace(it.getTran_cms_cd(),"-",""));
				}
			}
		}
								
		//출금은 무조건 신한은행 계좌		
		act.setA_bank_cms_bk		("026");
		
		if(act.getBank_nm().equals("신한")||act.getBank_nm().equals("신한은행")||act.getBank_nm().equals("조흥")||act.getBank_nm().equals("조흥은행")||act.getBank_nm().equals("신한전산통합")){
			act.setBank_cms_bk		("026");
			it.setTran_ip_bank_id ("026");
		}else if(act.getBank_nm().equals("(구)신한")||act.getBank_nm().equals("(구)신한은행")){
			act.setBank_cms_bk		("026");
			it.setTran_ip_bank_id ("026");
		}else if(act.getBank_nm().equals("(구)조흥")||act.getBank_nm().equals("(구)조흥은행")){
			act.setBank_cms_bk		("021");
			it.setTran_ip_bank_id ("021");
		}
		
		if(act.getBank_nm().equals("농협중앙회"))				act.setBank_nm		("NH농협");
		if(act.getBank_nm().equals("농협중"))					act.setBank_nm		("NH농협");
		if(act.getBank_nm().equals("NH농협은행"))				act.setBank_nm		("NH농협");
		if(act.getBank_nm().equals("시티"))					act.setBank_nm		("한국씨티");
		if(act.getBank_nm().equals("씨티"))					act.setBank_nm		("한국씨티");
		if(act.getBank_nm().equals("SC제일"))					act.setBank_nm		("SC제일");
		if(act.getBank_nm().equals("SC제일은행"))				act.setBank_nm		("SC제일");
		if(act.getBank_nm().equals("스탠다드차타드"))			act.setBank_nm		("SC제일");
		if(act.getBank_nm().equals("수협중앙회"))				act.setBank_nm		("수협");		
		if(act.getBank_nm().equals("신협은행"))				act.setBank_nm		("신협중앙회");
		if(act.getBank_nm().equals("신협"))					act.setBank_nm		("신협중앙회");
		if(act.getBank_nm().equals("새마을금고연합회"))			act.setBank_nm		("새마을금고");
		if(act.getBank_nm().equals("산림조합"))				act.setBank_nm		("산림조합중앙회");
		if(act.getBank_nm().equals("산업"))					act.setBank_nm		("KDB산업");
		if(act.getBank_nm().equals("산업은행"))				act.setBank_nm		("KDB산업");
		if(act.getBank_nm().equals("외환"))					act.setBank_nm		("KEB하나");
		if(act.getBank_nm().equals("외환은행"))				act.setBank_nm		("KEB하나");
		if(act.getBank_nm().equals("케이뱅크"))				act.setBank_nm		("K뱅크");
		if(act.getBank_nm().equals("하나"))					act.setBank_nm		("KEB하나");
		if(act.getBank_nm().equals("하나은행"))				act.setBank_nm		("KEB하나");
		if(act.getBank_nm().equals("기업은행"))				act.setBank_nm		("IBK기업");
		if(act.getBank_nm().equals("지역농축협"))				act.setBank_nm		("단위농협");
		
		
		
		
		
		
		//계좌이체(지출처) 은행코드-code
		if(it.getTran_ip_bank_id().equals("")){
			Hashtable ht = ps_db.getBankCode("", act.getBank_nm());
			if(String.valueOf(ht.get("CMS_BK")).equals("null")){
			}else{
				act.setBank_nm				(String.valueOf(ht.get("NM")));
				act.setBank_cms_bk		(String.valueOf(ht.get("CMS_BK")));				
				it.setTran_ip_bank_id (act.getBank_cms_bk());
				act_modify++;
			}
		}
				
		//out.print("act.getBank_nm()="+act.getBank_nm());
		//out.print("it.getTran_ip_bank_id()="+it.getTran_ip_bank_id()+"<br>");
		
		if(!act.getBank_nm().equals("") && !it.getTran_ip_bank_id().equals("")){
			if(act_modify >0){
				//송금수정
				if(!pm_db.updatePayActBK(act)) flag += 1; //pay_act / pay 처리
			}
						
			it.setTran_ip_acct_nb 		(act.getBank_no());
												
			if(!ib_db.insertIbBulkTran(it)) 	ib_result += 1;
		}
	}
	
	%>
	
<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
	
<script language='javascript'>
<%		if(result>0){	%>	alert('에러입니다.\n\n확인하십시오');					<%		}	%>		
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 		value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 		value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 		value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name="mode" 			value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>"> 
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = '<%=from_page%>';
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>