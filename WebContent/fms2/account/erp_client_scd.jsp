<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.client.*, acar.incom.*"%>
<%@ page import="acar.cont.*, acar.user_mng.*, acar.fee.*, acar.bill_mng.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "":request.getParameter("t_wd");
		
	String s_cnt 		= request.getParameter("s_cnt")==null?"":request.getParameter("s_cnt");		
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
			
	String incom_dt 		= request.getParameter("incom_dt")==null?"":request.getParameter("incom_dt");
	//int incom_seq			= request.getParameter("incom_seq")==null? 0:AddUtil.parseDigit(request.getParameter("incom_seq"));  //입금매칭처리는 seq를 생성해야 함. 
	long incom_amt			= request.getParameter("incom_amt")==null? 0:AddUtil.parseDigit4(request.getParameter("incom_amt"));
					
	String incom_naeyong 		= request.getParameter("incom_naeyong")==null?"":request.getParameter("incom_naeyong");
	String incom_tr_branch 		= request.getParameter("incom_tr_branch")==null?"":request.getParameter("incom_tr_branch");
	String incom_bank_nm 		= request.getParameter("incom_bank_nm")==null?"":request.getParameter("incom_bank_nm");
	String incom_bank_no 		= request.getParameter("incom_bank_no")==null?"":request.getParameter("incom_bank_no");
	
	String incom_acct_seq			= request.getParameter("incom_acct_seq")==null?"":request.getParameter("incom_acct_seq");  //입금매칭처리는 seq를 생성해야 함. 
	String incom_tr_date_seq			= request.getParameter("incom_tr_date_seq")==null?"":request.getParameter("incom_tr_date_seq");  //입금매칭처리는 seq를 생성해야 함. 			
								
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance(); 
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "12", "01");
	
	int tot_line = 0;	
	long total_amt 	= 0;
		
	//다중선택된 거래처
	String all_cid 	= request.getParameter("all_cid")==null?"":request.getParameter("all_cid");
	
//	out.println("incom_dt=" + incom_dt);
	//보증금
	Vector grt_scds = new Vector();
	
	//선납금
	Vector pp_scds = new Vector();
	
	//개시대여료
	Vector rfee_scds = new Vector();
	
	//승계수수료
	Vector cha_scds = new Vector();
		
	//대여료
	Vector fee_scds = new Vector();
	
	//대여료연체료
	Vector dly_scds = new Vector();
	
		//과태료
	Vector fine_scds = new Vector();	
	
	//면책금
	Vector serv_scds = new Vector();
	
	//휴/대차료
	Vector insh_scds = new Vector();
	
	//해지정산금
	Vector cls_scds = new Vector();
	
		
	//단기 - 1차 월렌트, 정비대차
	Vector rent_scds = new Vector();
	
	
	//친환경차 구맨보조금
	Vector green_scds = new Vector();
	
	
	//연체횟수
	int dly_mon = 0;
	     			
	if (!all_cid.equals("") ) {
	//스케줄
		 grt_scds = in_db.getFeeScdGrtClientList(all_cid);	
		 pp_scds = in_db.getFeeScdPpClientList(all_cid);	
	    rfee_scds = in_db.getFeeScdRfeeClientList(all_cid);	
	    cha_scds = in_db.getFeeScdChaClientList(all_cid);  //승계수수료
	    green_scds = in_db.getFeeScdGreenChaClientList(all_cid);  //구매보조금
		 fee_scds = in_db.getFeeScdSettleClientList(all_cid, s_kd, t_wd);
		 dly_mon =  in_db.getFeeScdDlyClientCnt(all_cid, s_kd, t_wd);  //연체횟수
		 dly_scds = in_db.getFeeScdDlyStatClient(all_cid, s_kd, t_wd);
		 fine_scds = in_db.getFineScdStatClient(all_cid, s_kd, t_wd);
       serv_scds = in_db.getServScdStatClient(all_cid, s_kd, t_wd);
     	insh_scds = in_db.getServScdInshClient(all_cid, s_kd, t_wd); //20100101 부터 처리
       cls_scds = in_db.getServScdClsClient(all_cid);
       rent_scds = in_db.getRentContScdClient(all_cid);  //단기월렌트 (1차로_   
    }

       
   	int scd_size= 0; //total
   
   	int grt_size = grt_scds.size(); //보증금
   	int pp_size = pp_scds.size(); //선납금
   	int rfee_size = rfee_scds.size(); //개시대여료
   	int cha_size = cha_scds.size(); //승계수수료
   	int green_size = green_scds.size(); //구매보조금 
	int fee_size = fee_scds.size(); //전체스케쥴
	int dly_size = dly_scds.size();
	int fine_size = fine_scds.size();
	int serv_size = serv_scds.size();	

	int insh_size = insh_scds.size();
	int cls_size = cls_scds.size();		
	int rent_size = rent_scds.size();	
				
	int chk_size = 0;
				
	if(s_cnt.equals("") || s_cnt.equals("0")){
		if(dly_mon > 30) 		s_cnt=String.valueOf(dly_mon);
		else					s_cnt="30";
	}
		
//	if (fee_size == 0) s_cnt="0";

	if (fee_size <= AddUtil.parseInt(s_cnt) ) s_cnt=Integer.toString(fee_size);
	
	dly_mon = AddUtil.parseInt(s_cnt); // 대여료 부분
 
 	
	scd_size = grt_size + pp_size + rfee_size + cha_size  + green_size + dly_mon + dly_size + fine_size + serv_size + insh_size + cls_size + rent_size;
	

	ClientBean client = new ClientBean();	
	
	String i_agnt_email = "";
	String i_agnt_nm    = "";
	String i_agnt_m_tel = "";	
	
	String ven_code = "";
	String ven_name = "";
	
	String fine_yn = "";
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
		
	function cal_rc_rest(){
		var fm = document.form1;
	
		var scd_size 	= toInt(fm.scd_size.value);	
	       
		var rc_amt 		= toInt(parseDigit(fm.incom_amt.value));  //구좌 입금액
		var t_pay_amt 	= 0;
		
		var est_amt = 0;
		
		if ( scd_size < 2  ) {
			est_amt = toInt(parseDigit(fm.est_amt.value));
			
			if(rc_amt < est_amt){
					fm.pay_amt.value = parseDecimal(rc_amt);
					fm.cls_amt.value = '0';
					rc_amt 		= rc_amt - toInt(parseDigit(fm.pay_amt.value));				
			}else{
					fm.pay_amt.value = parseDecimal(est_amt);
					fm.cls_amt.value = '0';
					rc_amt = rc_amt - toInt(parseDigit(fm.pay_amt.value));				
			}			
			t_pay_amt 	= t_pay_amt + toInt(parseDigit(fm.pay_amt.value));		
		
		} else {
		
			for(var i = 0 ; i < scd_size ; i ++){
	
				est_amt = toInt(parseDigit(fm.est_amt[i].value));				
				
				if(rc_amt < est_amt){
					fm.pay_amt[i].value = parseDecimal(rc_amt);
					fm.cls_amt[i].value = '0';
					rc_amt 		= rc_amt - toInt(parseDigit(fm.pay_amt[i].value));				
				}else{
					fm.pay_amt[i].value = parseDecimal(est_amt);
					fm.cls_amt[i].value = '0';
					rc_amt = rc_amt - toInt(parseDigit(fm.pay_amt[i].value));				
				}			
				t_pay_amt 	= t_pay_amt + toInt(parseDigit(fm.pay_amt[i].value));			
			}
		}
			
		fm.t_pay_amt.value = parseDecimal(t_pay_amt);
		fm.t_jan_amt.value = parseDecimal(toInt(parseDigit(fm.incom_amt.value))-t_pay_amt);
		
	}
	
	function cal_rest(){
		var fm = document.form1;
	
		var scd_size 	= toInt(fm.scd_size.value);		
		
		var rc_amt 		= toInt(parseDigit(fm.incom_amt.value));
		var t_pay_amt 	= 0;

		if ( scd_size < 2  ) {
			t_pay_amt 	= t_pay_amt + toInt(parseDigit(fm.pay_amt.value));		
		} else {
			for(var i = 0 ; i < scd_size ; i ++){
				t_pay_amt 	= t_pay_amt + toInt(parseDigit(fm.pay_amt[i].value));			
			}
		}	
		
	
		fm.t_pay_amt.value = parseDecimal(t_pay_amt);
		fm.t_jan_amt.value = parseDecimal(toInt(parseDigit(fm.incom_amt.value))-t_pay_amt);
	}	
	
	function cal_cls_rest(){
		var fm = document.form1;
		
		var scd_size 	= toInt(fm.scd_size.value);		
		var rc_amt 		= toInt(parseDigit(fm.incom_amt.value));
		var t_pay_amt 	= 0;

		if ( scd_size < 2  ) {
			t_pay_amt 	= t_pay_amt + toInt(parseDigit(fm.pay_amt.value));		
		} else {
			for(var i = 0 ; i < scd_size ; i ++){
				t_pay_amt 	= t_pay_amt + toInt(parseDigit(fm.pay_amt[i].value));			
			}
		}	
		fm.t_pay_amt.value = parseDecimal(t_pay_amt);
		fm.t_jan_amt.value = parseDecimal(toInt(parseDigit(fm.incom_amt.value))-t_pay_amt);
	}	
	
	
	function save()
	{
		var fm = document.form1;
					
		//과태료 선납분 		
		var scd_size 	= toInt(fm.scd_size.value);		
		var fine_chk_amt = 0;
		
		
		var cls_chk_amt = 0;
				
		if( toInt(parseDigit(fm.incom_amt.value)) != toInt(parseDigit(fm.t_pay_amt.value)) ) 
		{
				alert('입금처리금액을 확인하세요');
				return;
		}			
					
		if ( scd_size < 2  ) {
		    if ( scd_size == 0 ) {			    
		    } else { 
			    if ( fm.gubun.value == 'scd_cls') {
			    	 if ( toInt(fm.pay_amt.value) > 0 ) { //청구된건 중에서
				   		 if ( toInt(parseDigit(fm.cls_amt.value)) < 1 ) {
				  			   	  cls_chk_amt = 1;					  			    
				  	   	 }
				  	 }  	 
			    }	
			}    
		} else {
			for(var i = 0 ; i < scd_size ; i ++){			    
			     if ( fm.gubun[i].value == 'scd_cls') {
			    	if ( toInt(fm.pay_amt[i].value) > 0  ) {  //청구된건 중에서
				 		if ( toInt(parseDigit(fm.cls_amt[i].value)) < 1  ) {
			  			        cls_chk_amt = cls_chk_amt + 1;				 
			  			}
			  		}	  
				 }
			}
		}	
		
		if( cls_chk_amt > 0 ) {
			alert('해지정산금을 다시 확인하세요');
			return;
		}	
			
			
		if ( scd_size < 2  ) {
		    if ( scd_size == 0 ) {			    
		    } else { 
			    if ( fm.fine_chk.value == '포함청구') {
			    	 if ( toInt(fm.fine_dt.value) > 0 ) { //청구된건 중에서
				   		 if ( toInt(fm.incom_dt.value) >=  toInt(fm.fine_dt.value) ) {
				  			   if ( toInt(parseDigit(fm.pay_amt.value)) < 1 ) {
				  			   	  fine_chk_amt = 1;	
				  			   } 
				  	   	 }
				  	 }  	 
			    }	
			}    
		} else {
			for(var i = 0 ; i < scd_size ; i ++){			    
			     if ( fm.fine_chk[i].value == '포함청구') {
			    	if ( toInt(fm.fine_dt[i].value) > 0 ) {  //청구된건 중에서
				 		if ( toInt(fm.incom_dt.value) >=  toInt(fm.fine_dt[i].value) ) {
				 			if ( toInt(parseDigit(fm.pay_amt[i].value)) < 1  ) {
			  			         fine_chk_amt = fine_chk_amt + 1;						 
			  			    }
			  			}   
			  		}	  
				 }
			}
		}	
		
		   		   
		if(confirm('입금처리하시겠습니까?'))
		{		
			fm.target = 'i_no';			
			fm.action = 'erp_client_scd_step2_a.jsp'
			fm.submit();
		}		
	}	
			
		
	//해지정산 상세내역
	function detail_list( seq, rent_mng_id, rent_l_cd, incom_amt)
	{
		fm = document.form1;			
		
	
		//채권추심인 경우
		if ( fm.pay_gur[3].checked == true ) { 
			window.open("/fms2/account/cls_sub_list.jsp?pay_gur=Y&scd_size="+fm.scd_size.value+"&seq="+seq+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&incom_amt="+incom_amt, "de_list", "left=10, top=10, width=550, height=550, scrollbars=yes, status=yes, resizable=yes");		
		} else {			
			window.open("/fms2/account/cls_sub_list.jsp?pay_gur=N&scd_size="+fm.scd_size.value+"&seq="+seq+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&incom_amt="+incom_amt, "de_list", "left=10, top=10, width=550, height=550, scrollbars=yes, status=yes, resizable=yes");
		}
	}	
		
	function view_memo(m_id, l_cd)
	{
		window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw=<%=auth_rw%>&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1&fee_tm=A&tm_st1=0", "CREDIT_MEMO", "left=0, top=0, width=900, height=750, resizable=yes, scrollbars=yes, status=yes");
	}	

	function view_dly(m_id, l_cd)
	{
		window.open("/fms2/account/re_cal_dly.jsp?incom_dt=<%=incom_dt%>&m_id="+m_id+"&l_cd="+l_cd, "dly_memo", "left=50, top=150, width=300, height=150, resizable=yes, scrollbars=yes, status=yes");
	}
	
		
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15" >
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'> 
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type="hidden" name="client_id" >
  <input type='hidden' name='scd_size' value='<%=scd_size%>'>
  <input type="hidden" name="t_wd" value="">  
  <input type="hidden" name="incom_dt" 			value="<%=incom_dt%>">
  <input type="hidden" name="incom_amt" 		value="<%=incom_amt%>">
  
   <input type="hidden" name="incom_acct_seq" 		value="<%=incom_acct_seq%>">
   <input type="hidden" name="incom_tr_date_seq" 		value="<%=incom_tr_date_seq%>">
   <input type="hidden" name="incom_naeyong" 		value="<%=incom_naeyong%>">
   <input type="hidden" name="incom_tr_branch" 		value="<%=incom_tr_branch%>">
   <input type="hidden" name="incom_bank_nm" 		value="<%=incom_bank_nm%>">   <!--260:신한 -->
   <input type="hidden" name="incom_bank_no" 		value="<%=incom_bank_no%>">
	
 
  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
  	  
  	 <tr> 
        <td align="right">&nbsp;*입금액: <%=Util.parseDecimal(incom_amt) %>&nbsp;&nbsp;<a href='javascript:cal_rc_rest()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src="/acar/images/center/button_hj_bill.gif" align=absmiddle border="0"></a>&nbsp;&nbsp;(입금예정일, 계약일자순)</td>
    </tr>
      	              
    <tr>
        <td class=line2></td>
    </tr>
    
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                 	<td class="title" width='4%'>연번</td>
                    <td class="title" width='17%'>상호/분할청구</td>
                    <td class="title" width='11%'>차량번호</td>
                    <td class="title" width='21%'>차종/계약번호</td>					
                    <td class="title" width='4%'>회차</td>
                    <td class="title" width='12%'>구분</td>					
                    <td class="title" width='9%'>입금예정일</td>
                    <td class="title" width='11%'>예정금액</td>
                    <td class="title" width='11%'>입금처리금액</td>
                  
                </tr>
				<%	if(grt_size > 0){
						for(int i = 0 ; i < grt_size ; i++){
							Hashtable grt_scd = (Hashtable)grt_scds.elementAt(i);
							total_amt 	= total_amt + Long.parseLong(String.valueOf(grt_scd.get("EXT_AMT")));
					
							client = al_db.getNewClient(String.valueOf(grt_scd.get("CLIENT_ID")));
							i_agnt_nm		= client.getCon_agnt_nm();
							i_agnt_email	= client.getCon_agnt_email();
							i_agnt_m_tel	= client.getCon_agnt_m_tel();												
							scd_size++;
				%>
				<input type='hidden' name='gubun' value='scd_grt'>
				<input type='hidden' name='rent_mng_id' value='<%=grt_scd.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=grt_scd.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_st' value='<%=grt_scd.get("RENT_ST")%>'>
				<input type='hidden' name='rent_seq' value='<%=grt_scd.get("RENT_SEQ")%>'>
				<input type='hidden' name='fee_tm' value='<%=grt_scd.get("EXT_TM")%>'>
				<input type='hidden' name='tm_st1' value='<%=grt_scd.get("EXT_ID")%>'>
				<input type='hidden' name='tm_st2' value='<%=grt_scd.get("EXT_ST")%>'>				
				<input type='hidden' name='car_mng_id' value='<%=grt_scd.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='accid_id' value='<%//=grt_scd.get("ACCID_ID")%>'>
				<input type='hidden' name='rtn_client_id' value='<%=grt_scd.get("CLIENT_ID")%>'>
				<input type='hidden' name='cls_amt' value=''>
				<input type='hidden' name='rent_s_cd' value=''>		
                <tr>
                	<td align="center"><a href="javascript:view_memo('<%=grt_scd.get("RENT_MNG_ID")%>', '<%=grt_scd.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='통화내역'><%=i+1%></a></td>	
                    <td align="center"><input type='hidden' name='fine_chk' value='N'><%=grt_scd.get("FIRM_NM")%></td>		
					<td align="center"><%=grt_scd.get("CAR_NO")%></td>
                    <td align="center"><%=grt_scd.get("CAR_NM")%>&nbsp;<%=grt_scd.get("RENT_L_CD")%></td>					
                    <td align="center"><%=grt_scd.get("EXT_TM")%></td>
                    <td align="center"><%=grt_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><input type='hidden' name='fine_dt' value=''><%=AddUtil.ChangeDate2(String.valueOf(grt_scd.get("EXT_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(grt_scd.get("EXT_AMT")))%>'>원</td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'>원</td>
                   
                </tr>							
				<%		}
					}%>		
				
				<%	if(pp_size > 0){
						for(int i = 0 ; i < pp_size ; i++){
							Hashtable pp_scd = (Hashtable)pp_scds.elementAt(i);
							total_amt 	= total_amt + Long.parseLong(String.valueOf(pp_scd.get("EXT_AMT")));
							scd_size++;
					%>
				<input type='hidden' name='gubun' value='scd_pp'>
				<input type='hidden' name='rent_mng_id' value='<%=pp_scd.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=pp_scd.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_st' value='<%=pp_scd.get("RENT_ST")%>'>
				<input type='hidden' name='rent_seq' value='<%=pp_scd.get("RENT_SEQ")%>'>
				<input type='hidden' name='fee_tm' value='<%=pp_scd.get("EXT_TM")%>'>
				<input type='hidden' name='tm_st1' value='<%=pp_scd.get("EXT_ID")%>'>
				<input type='hidden' name='tm_st2' value='<%=pp_scd.get("EXT_ST")%>'>				
				<input type='hidden' name='car_mng_id' value='<%=pp_scd.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='accid_id' value='<%//=pp_scd.get("ACCID_ID")%>'>
				<input type='hidden' name='rtn_client_id' value='<%=pp_scd.get("CLIENT_ID")%>'>	
				<input type='hidden' name='cls_amt' value=''>	
				<input type='hidden' name='rent_s_cd' value=''>	
                <tr>
                	<td align="center"><a href="javascript:view_memo('<%=pp_scd.get("RENT_MNG_ID")%>', '<%=pp_scd.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='통화내역'><%=grt_size+i+1%></a></td>
                    <td align="center"><input type='hidden' name='fine_chk' value='N'><%=pp_scd.get("FIRM_NM")%></td>		
					<td align="center"><%=pp_scd.get("CAR_NO")%></td>
                    <td align="center"><%=pp_scd.get("CAR_NM")%>&nbsp;<%=pp_scd.get("RENT_L_CD")%></td>					
                    <td align="center"><%=pp_scd.get("EXT_TM")%></td>
                    <td align="center"><%=pp_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><input type='hidden' name='fine_dt' value=''><%=AddUtil.ChangeDate2(String.valueOf(pp_scd.get("EXT_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(pp_scd.get("EXT_AMT")))%>'>원</td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'>원</td>
                   
                </tr>							
				<%		}
					}%>							
			
				<%	if(rfee_size > 0){
						for(int i = 0 ; i < rfee_size ; i++){
							Hashtable rfee_scd = (Hashtable)rfee_scds.elementAt(i);
							total_amt 	= total_amt + Long.parseLong(String.valueOf(rfee_scd.get("EXT_AMT")));
							scd_size++;
					%>
				<input type='hidden' name='gubun' value='scd_rfee'>
				<input type='hidden' name='rent_mng_id' value='<%=rfee_scd.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=rfee_scd.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_st' value='<%=rfee_scd.get("RENT_ST")%>'>
				<input type='hidden' name='rent_seq' value='<%=rfee_scd.get("RENT_SEQ")%>'>
				<input type='hidden' name='fee_tm' value='<%=rfee_scd.get("EXT_TM")%>'>
				<input type='hidden' name='tm_st1' value='<%=rfee_scd.get("EXT_ID")%>'>
				<input type='hidden' name='tm_st2' value='<%=rfee_scd.get("EXT_ST")%>'>				
				<input type='hidden' name='car_mng_id' value='<%=rfee_scd.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='accid_id' value='<%//=rfee_scd.get("ACCID_ID")%>'>
				<input type='hidden' name='rtn_client_id' value='<%=rfee_scd.get("CLIENT_ID")%>'>	
				<input type='hidden' name='cls_amt' value=''>
				<input type='hidden' name='rent_s_cd' value=''>	
                <tr>
                	<td align="center"><a href="javascript:view_memo('<%=rfee_scd.get("RENT_MNG_ID")%>', '<%=rfee_scd.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='통화내역'><%=grt_size+pp_size+i+1%></a></td>	
                    <td align="center"><input type='hidden' name='fine_chk' value='N'><%=rfee_scd.get("FIRM_NM")%></td>		
					<td align="center"><%=rfee_scd.get("CAR_NO")%></td>
                    <td align="center"><%=rfee_scd.get("CAR_NM")%>&nbsp;<%=rfee_scd.get("RENT_L_CD")%></td>					
                    <td align="center"><%=rfee_scd.get("EXT_TM")%></td>
                    <td align="center"><%=rfee_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><input type='hidden' name='fine_dt' value=''><%=AddUtil.ChangeDate2(String.valueOf(rfee_scd.get("EXT_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(rfee_scd.get("EXT_AMT")))%>'>원</td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'>원</td>
                  
                </tr>							
				<%		}
					}%>	
					
					
				<%	if(cha_size > 0){
						for(int i = 0 ; i < cha_size ; i++){
							Hashtable cha_scd = (Hashtable)cha_scds.elementAt(i);
							total_amt 	= total_amt + Long.parseLong(String.valueOf(cha_scd.get("EXT_AMT")));
							scd_size++;
					%>
				<input type='hidden' name='gubun' value='scd_cha'>
				<input type='hidden' name='rent_mng_id' value='<%=cha_scd.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=cha_scd.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_st' value='<%=cha_scd.get("RENT_ST")%>'>
				<input type='hidden' name='rent_seq' value='<%=cha_scd.get("RENT_SEQ")%>'>
				<input type='hidden' name='fee_tm' value='<%=cha_scd.get("EXT_TM")%>'>
				<input type='hidden' name='tm_st1' value='<%=cha_scd.get("EXT_ID")%>'>
				<input type='hidden' name='tm_st2' value='<%=cha_scd.get("EXT_ST")%>'>				
				<input type='hidden' name='car_mng_id' value='<%=cha_scd.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='accid_id' value='<%//=cha_scd.get("ACCID_ID")%>'>
				<input type='hidden' name='rtn_client_id' value='<%=cha_scd.get("CLIENT_ID")%>'>	
				<input type='hidden' name='cls_amt' value=''>
				<input type='hidden' name='rent_s_cd' value=''>	
                <tr>
                	<td align="center"><%=grt_size+pp_size+rfee_size+i+1%></td>	
                    <td align="center"><input type='hidden' name='fine_chk' value='N'><%=cha_scd.get("FIRM_NM")%></td>		
					<td align="center"><%=cha_scd.get("CAR_NO")%></td>
                    <td align="center"><%=cha_scd.get("CAR_NM")%>&nbsp;<%=cha_scd.get("RENT_L_CD")%></td>					
                    <td align="center"><%=cha_scd.get("EXT_TM")%></td>
                    <td align="center"><%=cha_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><input type='hidden' name='fine_dt' value=''><%=AddUtil.ChangeDate2(String.valueOf(cha_scd.get("EXT_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(cha_scd.get("EXT_AMT")))%>'></td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'></td>
                  
                </tr>	
                
                			<%		}
					}%>	
				
				<%	if(fine_size > 0){
						for(int i = 0 ; i < fine_size ; i++){
							Hashtable fine_scd = (Hashtable)fine_scds.elementAt(i);
							
							fine_yn =  ad_db.getClientFineYn(String.valueOf(fine_scd.get("CLIENT_ID")));
														
							if ( String.valueOf(fine_scd.get("V_GUBUN")).equals("3") ) {
								fine_yn = "";
							}					
							
							scd_size++;
					%>
				<input type='hidden' name='gubun' value='scd_fine'>
				<input type='hidden' name='rent_mng_id' value='<%=fine_scd.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=fine_scd.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_st' value=''>
				<input type='hidden' name='rent_seq' value=''>
				<input type='hidden' name='fee_tm' value=''>
				<input type='hidden' name='tm_st1' value=''>
				<input type='hidden' name='tm_st2' value='<%=fine_scd.get("SEQ_NO")%>'>				
				<input type='hidden' name='car_mng_id' value='<%=fine_scd.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='accid_id' value=''>
				<input type='hidden' name='rtn_client_id' value='<%=fine_scd.get("CLIENT_ID")%>'>	
				<input type='hidden' name='cls_amt' value=''>
				<input type='hidden' name='rent_s_cd' value=''>	
				
                <tr>
                	<td align="center"><a href="javascript:view_memo('<%=fine_scd.get("RENT_MNG_ID")%>', '<%=fine_scd.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='통화내역'><%=grt_size+pp_size+rfee_size+cha_size+i+1%></a></td>	
                    <td align="center"><input type='hidden' name='fine_chk' value='<%=fine_yn%>'><%=fine_scd.get("FIRM_NM")%>&nbsp;&nbsp;<%=fine_yn%></td>		
					<td align="center"><%=fine_scd.get("CAR_NO")%></td>
                    <td align="center"><%=fine_scd.get("CAR_NM")%>&nbsp;<%=fine_scd.get("RENT_L_CD")%>&nbsp;<%=fine_scd.get("VIO_CONT")%></td>					
                    <td align="center"><%=fine_scd.get("SEQ_NO")%></td>
                    <td align="center">과태료&nbsp;&nbsp;<%=fine_scd.get("RES_ST")%></td>				
                    <td align="center"><input type='hidden' name='fine_dt' value='<%=String.valueOf(fine_scd.get("PROXY_DT"))%>'><%=AddUtil.ChangeDate2(String.valueOf(fine_scd.get("PROXY_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(fine_scd.get("PAID_AMT")))%>'></td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'></td>
               	
                </tr>	
                	
				<%		}
					}%>										
				
				<%	if(dly_mon > 0){
						if(fee_size > AddUtil.parseInt(s_cnt))	fee_size = AddUtil.parseInt(s_cnt);
						for(int i = 0 ; i <fee_size ; i++){
							Hashtable fee_scd = (Hashtable)fee_scds.elementAt(i);
							total_amt 	= total_amt + Long.parseLong(String.valueOf(fee_scd.get("FEE_AMT")));
							scd_size++;
							
							String fee_ven_code = "";
							String fee_site_id = "";
							
							
							//네오엠거래처
							client = al_db.getNewClient(String.valueOf(fee_scd.get("CLIENT_ID")));
							fee_ven_code = client.getVen_code();
													
							if ( !String.valueOf(fee_scd.get("R_SITE")).equals("") ) {
								//계약기본정보
							//	ContBaseBean base2 = a_db.getCont(String.valueOf(fee_scd.get("RENT_MNG_ID")), String.valueOf(fee_scd.get("RENT_L_CD")));
									
							//	fee_site_id = base2.getR_site();	
							         fee_site_id = String.valueOf(fee_scd.get("R_SITE"));
							         
							       	ClientSiteBean site = al_db.getClientSite(String.valueOf(fee_scd.get("CLIENT_ID")), fee_site_id);
						  		 if (!site.getVen_code().equals("")) fee_ven_code = site.getVen_code();  
							  								
							}
							
						   //연체가 있는지 확인 (대여료 스케쥴 예정일) - 1번						   						   
						   if (  AddUtil.parseInt(String.valueOf(fee_scd.get("R_FEE_EST_DT")))  <=  AddUtil.parseInt(AddUtil.getDate(4))  ) {
					
				%>				
				<input type='hidden' name='gubun' value='scd_fee'>
				<input type='hidden' name='rent_mng_id' value='<%=fee_scd.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=fee_scd.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_st' value='<%=fee_scd.get("RENT_ST")%>'>
				<input type='hidden' name='rent_seq' value='<%=fee_scd.get("RENT_SEQ")%>'>
				<input type='hidden' name='fee_tm' value='<%=fee_scd.get("FEE_TM")%>'>
				<input type='hidden' name='tm_st1' value='<%=fee_scd.get("TM_ST1")%>'>
				<input type='hidden' name='tm_st2' value='<%=fee_scd.get("TM_ST2")%>'>
				<input type='hidden' name='car_mng_id' value='<%=fee_scd.get("CAR_MNG_ID")%>'>	
				<input type='hidden' name='accid_id' value='<%//=serv_scd.get("ACCID_ID")%>'>
				<input type='hidden' name='rtn_client_id' value='<%=fee_scd.get("CLIENT_ID")%>'>	
				<input type='hidden' name='cls_amt' value=''>	
				<input type='hidden' name='rent_s_cd' value=''>			
                <tr>
                    <td align="center"><a href="javascript:view_memo('<%=fee_scd.get("RENT_MNG_ID")%>', '<%=fee_scd.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='통화내역'><%=grt_size+pp_size+rfee_size+cha_size+fine_size+ i+1%></a></td>		
                    <td align="center"><input type='hidden' name='fine_chk' value='N'><%=fee_scd.get("FIRM_NM")%>(<%=fee_ven_code%>)</td>		
                    <td align="center"><%=fee_scd.get("CAR_NO")%></td>
                    <td align="center"><%=fee_scd.get("CAR_NM")%>&nbsp;<%=fee_scd.get("RENT_L_CD")%></td>					
                    <td align="center"><%=fee_scd.get("FEE_TM")%></td>
                    <td align="center"><%=fee_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><input type='hidden' name='fine_dt' value=''><%=AddUtil.ChangeDate2(String.valueOf(fee_scd.get("R_FEE_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' readonly size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(fee_scd.get("FEE_AMT")))%>'></td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'></td>
               		
                </tr>
                
      <%         }   %>
     
     <%		}  //end for 
				}%>
				   
             
       	<%	if(dly_size > 0){
						for(int i = 0 ; i < dly_size ; i++){
							Hashtable dly_scd = (Hashtable)dly_scds.elementAt(i);
						
							int dly_jan_amt = 0;
							
							//	dly_jan_amt = AddUtil.parseInt(String.valueOf(dly_scd.get("JAN_AMT")));
							//	total_amt 	= total_amt + Long.parseLong(String.valueOf(dly_scd.get("JAN_AMT")));
								//연체이자를 입금일로 계산한걸 보여줌 	- 202202-16 수정						
							dly_jan_amt = in_db.getReCalDelayAmt(String.valueOf(dly_scd.get("RENT_MNG_ID")), String.valueOf(dly_scd.get("RENT_L_CD")), incom_dt);		
							total_amt 	= total_amt + Long.parseLong(Integer.toString(dly_jan_amt));
															
							scd_size++;
					%>
				<input type='hidden' name='gubun' value='scd_dly'>
				<input type='hidden' name='rent_mng_id' value='<%=dly_scd.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=dly_scd.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_st' value='<%//=dly_scd.get("RENT_ST")%>'>
				<input type='hidden' name='rent_seq' value='<%//=dly_scd.get("RENT_SEQ")%>'>
				<input type='hidden' name='fee_tm' value='<%//=dly_scd.get("FEE_TM")%>'>
				<input type='hidden' name='tm_st1' value='<%//=dly_scd.get("TM_ST1")%>'>
				<input type='hidden' name='tm_st2' value='<%//=dly_scd.get("TM_ST2")%>'>	
				<input type='hidden' name='car_mng_id' value='<%=dly_scd.get("CAR_MNG_ID")%>'>	
				<input type='hidden' name='accid_id' value='<%//=dly_scd.get("ACCID_ID")%>'>
				<input type='hidden' name='rtn_client_id' value='<%=dly_scd.get("CLIENT_ID")%>'>	
				<input type='hidden' name='cls_amt' value=''>
				<input type='hidden' name='rent_s_cd' value=''>	
							
                <tr>
                    <td align="center"><a href="javascript:view_dly('<%=dly_scd.get("RENT_MNG_ID")%>', '<%=dly_scd.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='연체료계산'><%=grt_size+pp_size+rfee_size+cha_size+fine_size+dly_mon + i+1%></a></td>	
				    <td align="center"><input type='hidden' name='fine_chk' value='N'><%=dly_scd.get("FIRM_NM")%></td>		
                    <td align="center"><%=dly_scd.get("CAR_NO")%>&nbsp;<% if (dly_scd.get("USE_YN").equals("N") ) {%>해지<%} %> </td>
                    <td align="center"><%=dly_scd.get("CAR_NM")%>&nbsp;<%=dly_scd.get("RENT_L_CD")%></td>					
                    <td align="center"><%//=fee_scd.get("FEE_TM")%>-</td>
                    <td align="center"><%//=fee_scd.get("TM_ST1_NM")%>대여료 연체료</td>					
                    <td align="center"><input type='hidden' name='fine_dt' value=''><%//=AddUtil.ChangeDate2(String.valueOf(fee_scd.get("R_FEE_EST_DT")))%>-</td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(dly_jan_amt)%>'></td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'></td>
                	
                </tr>				
                											
				<%		}
					}%>	
					                   							
			
				<%	if(dly_mon > 0){
						if(fee_size > AddUtil.parseInt(s_cnt))	fee_size = AddUtil.parseInt(s_cnt);
						for(int i = 0 ; i <fee_size ; i++){
							Hashtable fee_scd = (Hashtable)fee_scds.elementAt(i);
							total_amt 	= total_amt + Long.parseLong(String.valueOf(fee_scd.get("FEE_AMT")));
							scd_size++;
							
							String fee_ven_code = "";
							String fee_site_id = "";
							
							
							//네오엠거래처
							client = al_db.getNewClient(String.valueOf(fee_scd.get("CLIENT_ID")));
							fee_ven_code = client.getVen_code();
													
							if ( !String.valueOf(fee_scd.get("R_SITE")).equals("") ) {
								//계약기본정보
							//	ContBaseBean base2 = a_db.getCont(String.valueOf(fee_scd.get("RENT_MNG_ID")), String.valueOf(fee_scd.get("RENT_L_CD")));
									
							//	fee_site_id = base2.getR_site();	
							         fee_site_id = String.valueOf(fee_scd.get("R_SITE"));
							         
							       	ClientSiteBean site = al_db.getClientSite(String.valueOf(fee_scd.get("CLIENT_ID")), fee_site_id);
						  		 if (!site.getVen_code().equals("")) fee_ven_code = site.getVen_code();  
							  								
							}
							
						   //연체가 있는지 확인 (대여료 스케쥴 예정일) - 1번						   						   
						   if ( AddUtil.parseInt(String.valueOf(fee_scd.get("R_FEE_EST_DT")))  >  AddUtil.parseInt(AddUtil.getDate(4))  ) {
					
				%>				
				<input type='hidden' name='gubun' value='scd_fee'>
				<input type='hidden' name='rent_mng_id' value='<%=fee_scd.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=fee_scd.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_st' value='<%=fee_scd.get("RENT_ST")%>'>
				<input type='hidden' name='rent_seq' value='<%=fee_scd.get("RENT_SEQ")%>'>
				<input type='hidden' name='fee_tm' value='<%=fee_scd.get("FEE_TM")%>'>
				<input type='hidden' name='tm_st1' value='<%=fee_scd.get("TM_ST1")%>'>
				<input type='hidden' name='tm_st2' value='<%=fee_scd.get("TM_ST2")%>'>
				<input type='hidden' name='car_mng_id' value='<%=fee_scd.get("CAR_MNG_ID")%>'>	
				<input type='hidden' name='accid_id' value='<%//=serv_scd.get("ACCID_ID")%>'>
				<input type='hidden' name='rtn_client_id' value='<%=fee_scd.get("CLIENT_ID")%>'>	
				<input type='hidden' name='cls_amt' value=''>	
				<input type='hidden' name='rent_s_cd' value=''>			
                <tr>
                    <td align="center"><a href="javascript:view_memo('<%=fee_scd.get("RENT_MNG_ID")%>', '<%=fee_scd.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='통화내역'><%=grt_size+pp_size+rfee_size+cha_size+fine_size+ i+1%></a></td>		
                    <td align="center"><input type='hidden' name='fine_chk' value='N'><%=fee_scd.get("FIRM_NM")%>(<%=fee_ven_code%>)</td>		
                    <td align="center"><%=fee_scd.get("CAR_NO")%></td>
                    <td align="center"><%=fee_scd.get("CAR_NM")%>&nbsp;<%=fee_scd.get("RENT_L_CD")%></td>					
                    <td align="center"><%=fee_scd.get("FEE_TM")%></td>
                    <td align="center"><%=fee_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><input type='hidden' name='fine_dt' value=''><%=AddUtil.ChangeDate2(String.valueOf(fee_scd.get("R_FEE_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' readonly size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(fee_scd.get("FEE_AMT")))%>'></td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'></td>
               		
                </tr>
                
      <%         }   %>
     
     <%		}  //end for 
				}%>
							
					
				<%	if(serv_size > 0){
						for(int i = 0 ; i < serv_size ; i++){
							Hashtable serv_scd = (Hashtable)serv_scds.elementAt(i);
							scd_size++;
					%>
				<input type='hidden' name='gubun' value='scd_serv'>
				<input type='hidden' name='rent_mng_id' value='<%=serv_scd.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=serv_scd.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_st' value='<%=serv_scd.get("RENT_ST")%>'>
				<input type='hidden' name='rent_seq' value='<%=serv_scd.get("RENT_SEQ")%>'>
				<input type='hidden' name='fee_tm' value='<%=serv_scd.get("EXT_TM")%>'>
				<input type='hidden' name='tm_st1' value='<%=serv_scd.get("EXT_ID")%>'>
				<input type='hidden' name='tm_st2' value='<%=serv_scd.get("EXT_ST")%>'>				
				<input type='hidden' name='car_mng_id' value='<%=serv_scd.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='accid_id' value='<%=serv_scd.get("ACCID_ID")%>'>
				<input type='hidden' name='rtn_client_id' value='<%=serv_scd.get("CLIENT_ID")%>'>	
				<input type='hidden' name='cls_amt' value=''>
				<input type='hidden' name='rent_s_cd' value=''>	
				
                <tr>
                	<td align="center"><a href="javascript:view_memo('<%=serv_scd.get("RENT_MNG_ID")%>', '<%=serv_scd.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='통화내역'><%=grt_size+pp_size+rfee_size+cha_size+fine_size + dly_mon+dly_size+ i+1%></a></td>	
                    <td align="center"><input type='hidden' name='fine_chk' value='N'><%=serv_scd.get("FIRM_NM")%></td>		
					<td align="center"><%=serv_scd.get("CAR_NO")%></td>
                    <td align="center"><%=serv_scd.get("CAR_NM")%>&nbsp;<%=serv_scd.get("RENT_L_CD")%></td>					
                    <td align="center"><%=serv_scd.get("EXT_TM")%></td>
                    <td align="center"><%=serv_scd.get("TM_ST1_NM")%>&nbsp;&nbsp;<%=serv_scd.get("RES_ST")%></td>					
                    <td align="center"><input type='hidden' name='fine_dt' value=''><%=AddUtil.ChangeDate2(String.valueOf(serv_scd.get("EXT_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(serv_scd.get("EXT_AMT")))%>'></td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'></td>
               	
                </tr>							
				<%		}
					}%>			
				<!--  휴차료는 아마존카 휴대차료, 대차료는 매출 -->	
				<%	if(insh_size > 0){
						for(int i = 0 ; i < insh_size ; i++){
							Hashtable insh_scd = (Hashtable)insh_scds.elementAt(i);
							scd_size++;
					%>
				<input type='hidden' name='gubun' value='scd_insh'>
				<input type='hidden' name='rent_mng_id' value='<%=insh_scd.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=insh_scd.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_st' value='<%=insh_scd.get("RENT_ST")%>'>
				<input type='hidden' name='rent_seq' value='<%=insh_scd.get("RENT_SEQ")%>'>
				<input type='hidden' name='fee_tm' value='<%=insh_scd.get("EXT_TM")%>'>
			<!--	<input type='hidden' name='tm_st1' value='<%=insh_scd.get("EXT_ID")%>'> -->
			<!--	<input type='hidden' name='tm_st2' value='<%=insh_scd.get("EXT_ST")%>'> -->					
				<input type='hidden' name='tm_st2' value='<%=insh_scd.get("SEQ_NO")%>'>				
				<input type='hidden' name='car_mng_id' value='<%=insh_scd.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='accid_id' value='<%=insh_scd.get("ACCID_ID")%>'>
				<input type='hidden' name='rtn_client_id' value='<%=insh_scd.get("CLIENT_ID")%>'>	
				<input type='hidden' name='cls_amt' value='<%=insh_scd.get("ITEM_ID")%>'>  <!--  item_id가 1이면 휴차료 ,2면 대차료   -->	
				<input type='hidden' name='rent_s_cd' value='<%=insh_scd.get("RENT_S_CD")%>'>	
				
                <tr>
                	<td align="center"><a href="javascript:view_memo('<%=insh_scd.get("RENT_MNG_ID")%>', '<%=insh_scd.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='통화내역'><%=grt_size+pp_size+rfee_size+cha_size+fine_size+dly_mon + dly_size+serv_size+i+1%></a></td>	
                    <td align="center"><input type='hidden' name='fine_chk' value='N'><%=insh_scd.get("FIRM_NM")%></td>		
					<td align="center"><%=insh_scd.get("CAR_NO")%></td>
                    <td align="center"><%=insh_scd.get("CAR_NM")%>&nbsp;<%=insh_scd.get("RENT_L_CD")%>-<%=insh_scd.get("REQ_GU")%>-<%=insh_scd.get("INS_COM")%></td>					
                    <td align="center"><%=insh_scd.get("SEQ_NO")%></td>
                    <td align="center"> 
                      <select name="tm_st1">
                        <option value="2">대차료</option>
                        <option value="1">휴차료</option>                      
                      </select>
                      &nbsp;<%=insh_scd.get("TM_ST1_NM")%>
                    </td>					
                    <td align="center"><input type='hidden' name='fine_dt' value=''><%=AddUtil.ChangeDate2(String.valueOf(insh_scd.get("REQ_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(insh_scd.get("REQ_AMT")))%>'></td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'></td>
               		
                </tr>							
				<%		}
					}%>		
							
				<!--  해지정산금일괄입금처리리스트 - 과태료, 면책금, 대여료, 대여료이자, 해지위약금, 차량회수외주비용, 차량회수부대비용, 기타소해배상금 -->	
				<%	if(cls_size > 0){
						for(int i = 0 ; i < cls_size ; i++){
							Hashtable cls_scd = (Hashtable)cls_scds.elementAt(i);
							scd_size++;
					%>
				<input type='hidden' name='gubun' value='scd_cls'>
				<input type='hidden' name='rent_mng_id' value='<%=cls_scd.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=cls_scd.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_st' value=''>
				<input type='hidden' name='rent_seq' value=''>
				<input type='hidden' name='fee_tm' value='<%=cls_scd.get("EXT_TM")%>'>
				<input type='hidden' name='tm_st1' value=''> 
				<input type='hidden' name='tm_st2' value=''>				
				<input type='hidden' name='car_mng_id' value='<%=cls_scd.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='accid_id' value=''>
				<input type='hidden' name='rtn_client_id' value='<%=cls_scd.get("CLIENT_ID")%>'>	
				<input type='hidden' name='cls_amt' value=''>
				<input type='hidden' name='rent_s_cd' value=''>	
				
				
                <tr>
                	<td align="center"><a href="javascript:view_memo('<%=cls_scd.get("RENT_MNG_ID")%>', '<%=cls_scd.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='통화내역'><%=grt_size+pp_size+rfee_size+cha_size+dly_mon+dly_size+fine_size+serv_size+insh_size+i+1%></a></td>	
                    <td align="center"><input type='hidden' name='fine_chk' value='N'><%=cls_scd.get("FIRM_NM")%></td>		
					<td align="center"><%=cls_scd.get("CAR_NO")%></td>
                    <td align="center"><%=cls_scd.get("CAR_NM")%>&nbsp;<%=cls_scd.get("RENT_L_CD")%></td>					
                    <td align="center"><%=cls_scd.get("EXT_TM")%></td>
                    <td align="center"><%=cls_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><input type='hidden' name='fine_dt' value=''><%=AddUtil.ChangeDate2(String.valueOf(cls_scd.get("EXT_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(cls_scd.get("EXT_AMT")))%>'></td>
                    <td align="center"><input type='text' name='pay_amt' size='10' readonly class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    &nbsp;<a href="javascript:detail_list('<%=grt_size+pp_size+rfee_size+cha_size+dly_mon+dly_size+fine_size+serv_size+insh_size+i+1%>','<%=cls_scd.get("RENT_MNG_ID")%>','<%=cls_scd.get("RENT_L_CD")%>', '<%=incom_amt%>' );"><img src="/images/esti_detail.gif" align="absmiddle" border="0" alt="상세내역관리"></a>	
                    </td>
               		
                </tr>		
                					
				<%		}
					}%>	
					
		<!--  월렌트, 정비대차   일괄입금처리리스트 -->	
				<%	if(rent_size > 0){
						for(int i = 0 ; i < rent_size ; i++){
							Hashtable rent_scd = (Hashtable)rent_scds.elementAt(i);
							scd_size++;
					%>
				<input type='hidden' name='gubun' value='scd_rent'>
				<input type='hidden' name='rent_mng_id' value=''>
				<input type='hidden' name='rent_l_cd' value=''>
				<input type='hidden' name='rent_st' value='<%=rent_scd.get("RENT_ST")%>'>
				<input type='hidden' name='rent_seq' value=''>
				<input type='hidden' name='fee_tm' value='<%=rent_scd.get("TM")%>'>
				<input type='hidden' name='tm_st1' value='<%=rent_scd.get("PAID_ST")%>'>  <!--1:현금(이체),  2:카드  -->
				<input type='hidden' name='tm_st2' value=''>				
				<input type='hidden' name='car_mng_id' value='<%=rent_scd.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='accid_id' value=''>
				<input type='hidden' name='rtn_client_id' value='<%=rent_scd.get("CLIENT_ID")%>'>	
				<input type='hidden' name='cls_amt' value=''>
				<input type='hidden' name='rent_s_cd' value='<%=rent_scd.get("RENT_S_CD")%>'>	<!--월렌트 -->
				
				
                <tr>                            
                	<td align="center"><%=grt_size+pp_size+rfee_size+cha_size+dly_mon+dly_size+fine_size+serv_size+insh_size+cls_size+i+1%></td>	
                    <td align="center"><input type='hidden' name='fine_chk' value='N'><%=rent_scd.get("FIRM_NM")%></td>		
					<td align="center"><%=rent_scd.get("CAR_NO")%></td>
                    <td align="center"><%=rent_scd.get("CAR_NM")%>&nbsp;<%=rent_scd.get("RENT_S_CD")%></td>					
                    <td align="center"><%=rent_scd.get("TM")%></td>
                    <td align="center"><%=rent_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><input type='hidden' name='fine_dt' value=''><%=AddUtil.ChangeDate2(String.valueOf(rent_scd.get("EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(rent_scd.get("EXT_AMT")))%>'></td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'></td>
               		
                </tr>							
				<%		}
					}%>	
					
					<!--  구매보조금  일괄입금처리리스트 -->	
				<%	if(green_size > 0){
						for(int i = 0 ; i < green_size ; i++){
							Hashtable green_scd = (Hashtable)green_scds.elementAt(i);
							scd_size++;
					%>
				<input type='hidden' name='gubun' value='scd_green'>
				<input type='hidden' name='rent_mng_id' value='<%=green_scd.get("RENT_MNG_ID")%>'>
				<input type='hidden' name='rent_l_cd' value='<%=green_scd.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_st' value='<%=green_scd.get("RENT_ST")%>'>
				<input type='hidden' name='rent_seq' value='<%=green_scd.get("RENT_SEQ")%>'>
				<input type='hidden' name='fee_tm' value='<%=green_scd.get("EXT_TM")%>'>
				<input type='hidden' name='tm_st1' value='<%=green_scd.get("EXT_ID")%>'>
				<input type='hidden' name='tm_st2' value='<%=green_scd.get("EXT_ST")%>'>				
				<input type='hidden' name='car_mng_id' value='<%=green_scd.get("CAR_MNG_ID")%>'>
				<input type='hidden' name='accid_id' value='<%//=green_scd.get("ACCID_ID")%>'>
				<input type='hidden' name='rtn_client_id' value='<%=green_scd.get("CLIENT_ID")%>'>	
				<input type='hidden' name='cls_amt' value=''>
				<input type='hidden' name='rent_s_cd' value=''>	
                <tr>
                	<td align="center"><%=grt_size+pp_size+rfee_size+cha_size+dly_mon+dly_size+fine_size+serv_size+insh_size+cls_size+rent_size+i+1%></td>	
                    <td align="center"><input type='hidden' name='fine_chk' value='N'><%=green_scd.get("FIRM_NM")%></td>		
					<td align="center"><%=green_scd.get("CAR_NO")%></td>
                    <td align="center"><%=green_scd.get("CAR_NM")%>&nbsp;<%=green_scd.get("RENT_L_CD")%></td>					
                    <td align="center"><%=green_scd.get("EXT_TM")%></td>
                    <td align="center"><%=green_scd.get("TM_ST1_NM")%></td>					
                    <td align="center"><input type='hidden' name='fine_dt' value=''><%=AddUtil.ChangeDate2(String.valueOf(green_scd.get("EXT_EST_DT")))%></td>
                    <td align="center"><input type='text' name='est_amt' size='10' class='num' value='<%=Util.parseDecimal(String.valueOf(green_scd.get("EXT_AMT")))%>'></td>
                    <td align="center"><input type='text' name='pay_amt' size='10' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); cal_rest();'></td>
                  
                </tr>	
				<%		}
					}%>		
					
											
				 <tr>
                    <td colspan="7" class=title>합계</td>
                    <td class=title><input type='text' name='t_est_amt' size='10' class='fixnum' value='<%=Util.parseDecimal(total_amt)%>'></td>
                    <td class=title><input type='text' name='t_pay_amt' size='10' class='fixnum' value=''></td>
                  
               </tr>
               <tr>
                    <td colspan="6" class=title>잔액</td>
                    <td class=title><%if( grt_size > 0 ) { %>
                    <input type="checkbox" name="ebill" value="Y" <%if(!i_agnt_email.equals(""))%>checked<%%>>  입금표발행
                    <%} else { %>&nbsp;<% }%></td>
                    <td class=title><input type="checkbox" name="s_neom" value="Y" checked >전표발행</td>
                    <td class=title><input type='text' name='t_jan_amt' size='10' class='fixnum' value=''></td>                  
                </tr>																																								
               																																		
            </table>
        </td>
    </tr>	
  
    
    <tr>
        <td>&nbsp;</td>
    </tr>    
    
    <tr>
		<td align="right">		
		 <a href="javascript:save();"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>	
		</td>
	</tr>	
    
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--

//-->
</script>
</body>
</html>
