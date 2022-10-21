<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.out_car.*, acar.bill_mng.*, acar.coolmsg.*, acar.user_mng.*"%>
<jsp:useBean id="oc_db" scope="page" class="acar.out_car.OutCarDatabase"/>
<jsp:useBean id="ib_db" scope="page" class="acar.inside_bank.InsideBankDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String car_off_id 	= request.getParameter("car_off_id")==null?"":request.getParameter("car_off_id");
	String size 		= request.getParameter("size")==null?"":request.getParameter("size");
	String incom_st 	= request.getParameter("incom_st")==null?"":request.getParameter("incom_st");
	
	String incom_dt 	= request.getParameter("incom_dt")==null?"":request.getParameter("incom_dt");
	long   incom_amt 	= request.getParameter("incom_amt")==null?0:AddUtil.parseDigit4(request.getParameter("incom_amt"));
	String autodoc_yn 	= request.getParameter("autodoc_yn")==null?"":request.getParameter("autodoc_yn");
		
	//String tran_date_seq 	= request.getParameter("tran_date_seq")==null?"":request.getParameter("tran_date_seq");
	//String acct_seq 	= request.getParameter("acct_seq")==null?"":request.getParameter("acct_seq");
	//String bank_id 	= request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	//String bank_nm 	= request.getParameter("bank_nm")==null?"":request.getParameter("bank_nm");
	//String bank_no 	= request.getParameter("bank_no")==null?"":request.getParameter("bank_no");
	
	String tran_date_seq[] 	= request.getParameterValues("tran_date_seq");
	String acct_seq[] 		= request.getParameterValues("acct_seq");
	String bank_id[] 		= request.getParameterValues("bank_id");
	String bank_nm[] 		= request.getParameterValues("bank_nm");
	String bank_no[] 		= request.getParameterValues("bank_no");
	String bank_incom_dt[] 	= request.getParameterValues("bank_incom_dt");

	String serial[] 		= request.getParameterValues("serial");
	String base_amt[] 		= request.getParameterValues("base_amt");
	String base_incom_amt[] = request.getParameterValues("base_incom_amt");
	String m_amt[] 			= request.getParameterValues("m_amt");
	String rest_amt[] 		= request.getParameterValues("rest_amt");
	String incom_bigo[] 	= request.getParameterValues("incom_bigo");
	String incom_bigo2[] 	= request.getParameterValues("incom_bigo2");
	
	int flag = 0;
	boolean flag2 = true;
	long total_m_amt = 0;
	String cont = "";
	int cnt = 0; 
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	
	OutStatBean f_scd_bean = new OutStatBean();
	
	//사용자정보-더존
	Hashtable per = neoe_db.getPerinfoDept(login.getAcarName(ck_acar_id));
	String insert_id = String.valueOf(per.get("SA_CODE"));
	
	String target_id = nm_db.getWorkAuthUser("자체출고캐쉬백-권명숙고정");
	UsersBean target_bean = umd.getUsersBean(target_id);	
	
	Vector vt = new Vector();
	int vt_size = 0;
	
	for(int i=0; i < serial.length; i++){
		
		//카드캐쉬백스케줄
		OutStatBean scd_bean = oc_db.getCarCashBackBase(AddUtil.parseInt(serial[i]));
		
		scd_bean.setIncom_dt		(incom_dt);
		
		scd_bean.setIncom_amt		(base_incom_amt[i]==null?0 :AddUtil.parseDigit4(base_incom_amt[i]));
		scd_bean.setIncom_bigo		(incom_bigo[i]==null?"" :incom_bigo[i]);
		scd_bean.setM_amt			(m_amt[i]==null?0 :AddUtil.parseDigit4(m_amt[i]));
		
		if(scd_bean.getIncom_amt() == 0 ){
			scd_bean.setM_amt(0);
		}
		
		total_m_amt = total_m_amt + scd_bean.getM_amt();
		
		if(i==0) cont = scd_bean.getBase_bigo();
		
		if(scd_bean.getIncom_amt()+scd_bean.getM_amt() >0 || scd_bean.getIncom_amt()+scd_bean.getM_amt() < 0){
			//묶음
			if(incom_st.equals("2")){
				scd_bean.setIncom_seq		(acct_seq[0]+""+incom_dt+""+tran_date_seq[0]);
				scd_bean.setBank_id			(bank_id[0]);
				scd_bean.setBank_nm			(bank_nm[0]);
				scd_bean.setBank_no			(bank_no[0]);
				
				if(i==0){
					//은행입금 적용처리
					if(!ib_db.updateIbAcctTallTrDdFmsYnCardCashback(acct_seq[0]+""+AddUtil.getReplace_dt(incom_dt)+""+tran_date_seq[0])) flag += 1;
				}
			}else{
				scd_bean.setIncom_seq		(acct_seq[i]+""+incom_dt+""+tran_date_seq[i]);
				scd_bean.setBank_id			(bank_id[i]);
				scd_bean.setBank_nm			(bank_nm[i]);
				scd_bean.setBank_no			(bank_no[i]);	
				
				//if(!bank_incom_dt[i].equals("")){
				//	scd_bean.setIncom_dt	(bank_incom_dt[i]);
				//}
				
				//은행입금 적용처리
				if(!ib_db.updateIbAcctTallTrDdFmsYnCardCashback(acct_seq[i]+""+AddUtil.getReplace_dt(scd_bean.getIncom_dt())+""+tran_date_seq[i])) flag += 1;
			}
				
			//입금처리
			if(!oc_db.updateCarStatScd(scd_bean)) flag += 1;
			
			//자동전표 발행
			if(autodoc_yn.equals("Y")){
							
				//차변 보통예금 10300
				Hashtable ht1 = new Hashtable();
				ht1.put("DEPT_CODE",  	"200");
				ht1.put("INSERT_ID",	insert_id);
				ht1.put("WRITE_DATE", 	scd_bean.getIncom_dt());
				ht1.put("AMT_GUBUN",  	"3");//차변
				ht1.put("ACCT_CODE",  	"10300");
				ht1.put("DR_AMT",    	String.valueOf(base_incom_amt[i]));
				ht1.put("CR_AMT",     	"0");
				ht1.put("CHECKD_CODE1",	scd_bean.getBank_id());//금융기관
				ht1.put("CHECKD_CODE2",	scd_bean.getBank_no());//예적금계좌
				ht1.put("CHECKD_NAME4",	"[미수금]"+scd_bean.getBase_bigo());//적요
				
				//대변 선수금 25900 -> 미수금 12000
				Hashtable ht2 = new Hashtable();
				ht2.put("DEPT_CODE",  	"200");
				ht2.put("INSERT_ID",	insert_id);
				ht2.put("WRITE_DATE", 	scd_bean.getIncom_dt());
				ht2.put("AMT_GUBUN",  	"4");//차변
				ht2.put("ACCT_CODE",  	"12000");
				ht2.put("DR_AMT",    	"0");
				ht2.put("CR_AMT",     	String.valueOf(scd_bean.getBase_amt()));
				ht2.put("CHECKD_CODE1",	scd_bean.getVen_code());//거래처
				ht2.put("CHECKD_NAME4",	"[미수금]"+scd_bean.getBase_bigo());//적요
				
				vt.add(ht1);
				vt.add(ht2);

				//잡손실
				if(scd_bean.getM_amt() > 0 ){
					//차변 잡손실 96000
					Hashtable ht3 = new Hashtable();
					ht3.put("DEPT_CODE",  	"200");
					ht3.put("INSERT_ID",	insert_id);
					ht3.put("WRITE_DATE", 	scd_bean.getIncom_dt());
					ht3.put("AMT_GUBUN",  	"3");//차변
					ht3.put("ACCT_CODE",  	"96000");
					ht3.put("DR_AMT",    	String.valueOf(scd_bean.getM_amt()));
					ht3.put("CR_AMT",     	"0");
					ht3.put("CHECKD_CODE4",	scd_bean.getVen_code());//거래처		
					ht3.put("CHECKD_NAME5",	"[미수금]"+scd_bean.getBase_bigo());//적요		
					vt.add(ht3);
				}
				//잡이익
				if(scd_bean.getM_amt() < 0 ){
					//대변 잡이익 93000
					Hashtable ht3 = new Hashtable();
					ht3.put("DEPT_CODE",  	"200");
					ht3.put("INSERT_ID",	insert_id);
					ht3.put("WRITE_DATE", 	scd_bean.getIncom_dt());
					ht3.put("AMT_GUBUN",  	"4");//차변
					ht3.put("ACCT_CODE",  	"93000");
					ht3.put("DR_AMT",    	"0");
					ht3.put("CR_AMT",     	String.valueOf(-1*scd_bean.getM_amt()));
					ht3.put("CHECKD_CODE4",	scd_bean.getVen_code());//거래처
					ht3.put("CHECKD_NAME5",	"[미수금]"+scd_bean.getBase_bigo());//적요	
					vt.add(ht3);
				}
				
				
				vt_size++;
				
				//String row_id2 = neoe_db.insertDebtSettleAutoDocu(scd_bean.getIncom_dt(), vt);	
				
				//vt = new Vector();
				
				if(scd_bean.getM_amt() > 5000 || scd_bean.getM_amt() < -5000){
					cont = "판매장려금현황 입금 금액이 차이납니다. 확인하십시오.  &lt;br&gt; &lt;br&gt; ["+incom_dt+"] "+ scd_bean.getBase_bigo();
					
					//확인메시지 발송
					String xml_data = "";
					xml_data =  "<COOLMSG>"+
				  				"<ALERTMSG>"+
				  				"    <BACKIMG>4</BACKIMG>"+
				  				"    <MSGTYPE>104</MSGTYPE>"+
				  				"    <SUB>판매장려금</SUB>"+
				  				"    <CONT>"+cont+"</CONT>"+
				 				"    <URL></URL>";
					
					xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
					xml_data += "    <SENDER></SENDER>"+
				  				"    <MSGICON>10</MSGICON>"+
				  				"    <MSGSAVE>1</MSGSAVE>"+
				  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
				  				"    <FLDTYPE>1</FLDTYPE>"+
				  				"  </ALERTMSG>"+
				  				"</COOLMSG>";
					
					CdAlertBean msg = new CdAlertBean();
					msg.setFlddata(xml_data);
					msg.setFldtype("1");
					
					flag2 = cm_db.insertCoolMsg(msg);
					
				}				
				
			}			
		}
	}
	
	if(vt_size>0){
		String row_id = neoe_db.insertDebtSettleAutoDocu(incom_dt, vt);
	}
	
	

	
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'car_cash_back_incom_sc.jsp';
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
<input type='hidden' name='car_off_id' 	value='<%=car_off_id%>'>
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
