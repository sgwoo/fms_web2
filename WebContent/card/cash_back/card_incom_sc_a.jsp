<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*, acar.bill_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="ib_db" scope="page" class="acar.inside_bank.InsideBankDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String card_kind 	= request.getParameter("card_kind")==null?"":request.getParameter("card_kind");
	
	String incom_dt 	= request.getParameter("incom_dt")==null?"":request.getParameter("incom_dt");
	long   incom_amt 	= request.getParameter("incom_amt")==null?0:AddUtil.parseDigit4(request.getParameter("incom_amt"));
	String autodoc_yn = request.getParameter("autodoc_yn")==null?"":request.getParameter("autodoc_yn");
	String tran_date_seq 	= request.getParameter("tran_date_seq")==null?"":request.getParameter("tran_date_seq");
	String acct_seq 	= request.getParameter("acct_seq")==null?"":request.getParameter("acct_seq");
	String bank_id 	= request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	String bank_nm 	= request.getParameter("bank_nm")==null?"":request.getParameter("bank_nm");
	String bank_no 	= request.getParameter("bank_no")==null?"":request.getParameter("bank_no");
	String balance_reg_yn 	= request.getParameter("balance_reg_yn")==null?"":request.getParameter("balance_reg_yn");
	
	
	String size 			= request.getParameter("size")==null?"":request.getParameter("size");
	
	String serial[] 			= request.getParameterValues("serial");
	String tm[] 					= request.getParameterValues("tm");
	String scd_amt[] 			= request.getParameterValues("scd_amt");
	String save_amt[] 		= request.getParameterValues("save_amt");
	String base_incom_amt[] = request.getParameterValues("base_incom_amt");
	String m_amt[] 				= request.getParameterValues("m_amt");
	String rest_amt[] 		= request.getParameterValues("rest_amt");
	String incom_bigo[] 	= request.getParameterValues("incom_bigo");
	String incom_bigo2[] 	= request.getParameterValues("incom_bigo2");
	
	int flag = 0;
	long t_incom_amt = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	
	CardStatBean f_scd_bean = new CardStatBean();
	
	for(int i=0; i < serial.length; i++){
		
		//카드캐쉬백스케줄
		CardStatBean scd_bean = CardDb.getCardStatScd(AddUtil.parseInt(serial[i]), AddUtil.parseInt(tm[i]));
		
		CardStatBean scd_bean2 = scd_bean;
		
		
		
		scd_bean.setIncom_dt		(incom_dt);
		scd_bean.setIncom_seq		(acct_seq+""+incom_dt+""+tran_date_seq);
		scd_bean.setIncom_amt		(base_incom_amt[i]==null?0 :AddUtil.parseDigit4(base_incom_amt[i]));
		scd_bean.setIncom_bigo	(incom_bigo[i]==null?"" :incom_bigo[i]);
		scd_bean.setM_amt				(m_amt[i]==null?0 :AddUtil.parseDigit4(m_amt[i]));
		scd_bean.setBank_id			(bank_id);
		scd_bean.setBank_nm			(bank_nm);
		scd_bean.setBank_no			(bank_no);
		
		//if(scd_bean.getIncom_amt()+scd_bean.getM_amt() >0 || scd_bean.getIncom_amt()+scd_bean.getM_amt() < 0){
		if(scd_bean.getIncom_amt() >0 || scd_bean.getIncom_amt() < 0){			
			//입금처리
			if(!CardDb.updateCardStatScd(scd_bean)) flag += 1;
			
			//System.out.println("입금처리");
			
			t_incom_amt = t_incom_amt+scd_bean.getIncom_amt();
			
			//잔액있으면 회차추가된다.
			if(balance_reg_yn.equals("Y") && scd_bean.getScd_amt() > scd_bean.getIncom_amt() && AddUtil.parseDigit4(rest_amt[i]) >0){
				scd_bean2.setTm					(scd_bean.getTm()+1);
				scd_bean2.setSave_amt		(AddUtil.parseDigit4(rest_amt[i]));
				scd_bean2.setIncom_bigo	(scd_bean2.getTm()+"회차 잔액");
				//잔액스케줄 생성
				if(!CardDb.insertCardStatScd(scd_bean2)) flag += 1;
				
				//System.out.println("잔액스케줄 생성");
			}
			
			f_scd_bean = scd_bean;
			
		}
	}
	
	//if(incom_amt==t_incom_amt){
	
			//은행입금 적용처리
			if(!ib_db.updateIbAcctTallTrDdFmsYnCardCashback(acct_seq+""+AddUtil.getReplace_dt(incom_dt)+""+tran_date_seq)) flag += 1;	
			
			System.out.println("은행입금 적용처리");
			
		
			//자동전표 발행
			if(autodoc_yn.equals("Y")){
			
				//거래처 가져오기
				Hashtable ven_ht = CardDb.getCardVener(f_scd_bean);
				
				System.out.println(String.valueOf(ven_ht.get("N_VEN_CODE")));
				System.out.println(String.valueOf(ven_ht.get("N_VEN_NAME")));
				
				//사용자정보-더존
				Hashtable per = neoe_db.getPerinfoDept(login.getAcarName(ck_acar_id));
				String insert_id = String.valueOf(per.get("SA_CODE"));
				
				//차변 보통예금 10300
				Hashtable ht1 = new Hashtable();
				ht1.put("DEPT_CODE",  	"200");
				ht1.put("INSERT_ID",		insert_id);
				ht1.put("WRITE_DATE", 	incom_dt);
				ht1.put("AMT_GUBUN",  	"3");//차변
				ht1.put("ACCT_CODE",  	"10300");
				ht1.put("DR_AMT",    		String.valueOf(incom_amt));
				ht1.put("CR_AMT",     	"0");
				ht1.put("CHECKD_CODE1",	bank_id);//금융기관
				ht1.put("CHECKD_CODE2",	bank_no);//예적금계좌
				ht1.put("CHECKD_NAME4",	"[캐쉬백]"+c_db.getNameByIdCode("0031", f_scd_bean.getCard_kind(), ""));//적요
				
				//대변 캐쉬백수익 91100
				Hashtable ht2 = new Hashtable();
				ht2.put("DEPT_CODE",  	"200");
				ht2.put("INSERT_ID",		insert_id);
				ht2.put("WRITE_DATE", 	incom_dt);
				ht2.put("AMT_GUBUN",  	"4");//차변
				ht2.put("ACCT_CODE",  	"91100");
				ht2.put("DR_AMT",    		"0");
				ht2.put("CR_AMT",     	String.valueOf(incom_amt));
				ht2.put("CHECKD_CODE1",	String.valueOf(ven_ht.get("N_VEN_CODE")));//거래처
				ht2.put("CHECKD_NAME5",	"[캐쉬백]"+c_db.getNameByIdCode("0031", f_scd_bean.getCard_kind(), ""));//적요
				
				Vector vt = new Vector();
				vt.add(ht1);
				vt.add(ht2);
				
				String row_id = neoe_db.insertDebtSettleAutoDocu(incom_dt, vt);
				
				System.out.println("자동전표 발행");
			}
			
	//}
	
	//카드캐쉬백마감
	String  c_flag =  CardDb.call_sp_card_cont_reg();	
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'card_incom_sc.jsp';
		fm.target = "c_foot";
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
<input type='hidden' name='card_kind' 	value='<%=card_kind%>'>
</form>
<a href="javascript:go_step()">다음으로</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생%>
		alert("에러가 발생하였습니다.");
<%	}else{//정상%>
		alert("처리되었습니다.");
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
