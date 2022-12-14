<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*"%>
<%@ page import="acar.client.*, acar.ars_card.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="l_db" scope="page" class="acar.client.ClientDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ar_db" scope="page" class="acar.ars_card.ArsCardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(ck_acar_id, "13", "01", "13");	
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id	= "";
	String rent_l_cd	= "";
	
	
	if(client_id.equals("")) return;
	
	
	//1. 고객 ---------------------------
	
	//고객정보
	ClientBean client = al_db.getNewClient(client_id);
	
	//계약별현황	
	Hashtable client_stat = al_db.getClientListCase(client_id);
	int lt_cnt = AddUtil.parseInt(String.valueOf(client_stat.get("LT_CNT")));
	int st_cnt = AddUtil.parseInt(String.valueOf(client_stat.get("ST_CNT")));
	int ot_cnt = AddUtil.parseInt(String.valueOf(client_stat.get("OT_CNT")));
		
	//당일자 고객 카드결제분 확인
	Vector vt =  ar_db.getArsCardClientList(client_id);
	int vt_size = vt.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	//고객 보기
	function view_client()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("선택된 고객이 없습니다."); return;}	
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//대여료메모
	function view_memo(m_id, l_cd)
	{
		window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw=2&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1&fee_tm=A&tm_st1=0", "CREDIT_MEMO", "left=0, top=0, width=900, height=750, scrollbars=yes");
	}	
	
	//등록
	function save(){
		var fm = document.form1;
				
		if(fm.buyr_name.value == '')			{ alert('계약자명을 입력하십시오.'); 			fm.buyr_name.focus(); 	return; }
		if(fm.buyr_tel2.value == '')			{ alert('휴대폰번호를 입력하십시오.'); 		fm.buyr_tel2.focus(); 	return; }
		if(fm.buyr_mail.value == '')			{ alert('메일주소를 입력하십시오.'); 			fm.buyr_mail.focus(); 	return; }
		if(fm.good_name.value == '')			{ alert('차량번호를 입력하십시오.'); 			fm.good_name.focus(); 	return; }
		if(fm.msg.value == '')					{ alert('내역을 입력하십시오.'); 				fm.msg.focus(); 		return; }
		if(fm.good_mny.value == '0')			{ alert('결제금액을 입력하십시오.'); 			fm.good_mny.focus(); 	return; }
		
		if(fm.app_st[1].checked == true){ 		
			if(fm.card_kind.value == '')			{ alert('카드사를 입력하십시오.'); 			fm.card_kind.focus(); 	return; }
			if(fm.card_no.value == '')				{ alert('카드번호를 입력하십시오.'); 			fm.card_no.focus(); 	return; }
			if(fm.card_no.value != ''){
				if(fm.card_y_mm.value == '')		{ alert('유효기간을 입력하십시오.'); 			fm.card_y_mm.focus(); 	return; }
				if(fm.card_y_yy.value == '')		{ alert('유효기간을 입력하십시오.'); 			fm.card_y_yy.focus(); 	return; }				
			}
		}
		
		if(fm.exempt_yn.checked == true){
			if(fm.exempt_cau.value == '')		{ alert('수수료 면제사유를 입력하십시오.'); 	fm.exempt_cau.focus(); 	return; }
		}
								
		if(confirm('등록하시겠습니까?')){	
			fm.action='ars_card_req_i_a.jsp';		
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}							
	}

	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	
	
	//계약 선택
	function select_cont(){
		var fm = document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		var car_no = "";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					cnt++;
					var ch_split = ck.value.split("/");					
					idnum = ch_split[0];
					if(fm.bus_nm.value==''){
						fm.bus_nm.value = ch_split[1];
					}						
					if(car_no != '') car_no = car_no + " ";
					car_no = car_no + idnum;
				}
			}
		}	
		fm.good_name.value = car_no;
	}	
	
	//금액셋팅
	function set_amt(st){
		var fm = document.form1;	
		//채권금액
		if(st==1){
			//202106 이노페이 2.7%
			fm.card_per.value 	= 2.7; //수수료면제
			fm.card_fee.value 	= parseDecimal( Math.round(toInt(parseDigit(fm.settle_mny.value)) * 2.7 /100 ) );
		}
	
		if(fm.exempt_yn.checked == true){
			fm.m_card_fee.value 	= parseDecimal(-1*toInt(parseDigit(fm.card_fee.value))); //수수료면제				
		}else{
			fm.m_card_fee.value 	= 0; //수수료면제
		}
		
		fm.good_mny.value 	= parseDecimal(toInt(parseDigit(fm.settle_mny.value)) + toInt(parseDigit(fm.card_fee.value)) + toInt(parseDigit(fm.m_card_fee.value)) );
	}	
	
	
	function cng_input(){
		var fm = document.form1;	
		if(fm.app_st[0].checked == true){ 				
			tr_ars.style.display	= 'none';
		}else{											
			tr_ars.style.display	= '';
		}
	}
	
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15">
<form action='ars_card_req_a.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name="client_id" value="<%=client_id%>">
  <input type='hidden' name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" value="<%=rent_l_cd%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">
  <input type='hidden' name="bus_nm" value="">
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title>상호</td>
                    <td>&nbsp;<a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=client.getFirm_nm()%></a></td>
                    <td class=title>대표자</td>
                    <td>&nbsp;<%=client.getClient_nm()%></td>
                </tr>
            </table>
		</td>
    </tr>
    <tr>
		<td align="right">&nbsp;</td>	
    </tr>    
    <%if(lt_cnt >0){
		Vector conts = l_db.getContArsList(client_id);
		int cont_size = conts.size();    				
    %>  
    <tr>
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>장기대여계약</span></td>
    </tr>              
    <tr>
		<td class='line'>
	    	<table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
            	    <td width='3%' class=title>선택</td>
            	    <td width='3%' class=title>연번</td>
            	    <td width='10%' class=title>계약번호</td>
            	    <td width='7%' class=title>계약일</td>
            	    <td width='8%' class=title>차량번호</td>
            	    <td width='12%' class=title>차명</td>
            	    <td width='18%' class=title>계약기간</td>
            	    <td width='6%' class=title>관리구분</td>
            	    <td width='6%' class=title>최초영업</td>
            	    <td width='6%' class=title>영업담당</td>            				    
            	    <td width='13%' class=title>지점</td>
            	    <td width='5%' class=title>통화</td>
            	    <td width='3%' class=title>상태</td>
            	</tr>			
                <%for(int i = 0 ; i < cont_size ; i++){
					Hashtable cont = (Hashtable)conts.elementAt(i);
			
					if(i==0){
						rent_mng_id 	= String.valueOf(cont.get("RENT_MNG_ID"));
						rent_l_cd 		= String.valueOf(cont.get("RENT_L_CD"));
					}
                %>
				<tr>
		    		<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='3%'><input type="checkbox" name="ch_cd" value="<%=cont.get("CAR_NO")%>/<%=cont.get("USER_NM2")%>" onclick="javascript:select_cont();"></td>
		    		<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='3%'><%=i+1%></td>					
		    		<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='10%'><%=cont.get("RENT_L_CD")%></td>
		    		<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='7%'><%=cont.get("RENT_DT")%></td>
		    		<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='8%'><%=cont.get("CAR_NO")%></td>
		    		<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='12%'><%=cont.get("CAR_NM")%></td>
		    		<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='18%'><%=cont.get("RENT_START_DT")%>~<%=cont.get("RENT_END_DT")%></td>
		    		<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='6%'><%=cont.get("RENT_WAY")%></td>
		    		<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='6%'><%=cont.get("USER_NM")%></td>
		    		<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='6%'><%=cont.get("USER_NM2")%></td>					
		    		<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='13%'><%=cont.get("R_SITE")%></td>
		    		<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='5%'><a href="javascript:view_memo('<%=cont.get("RENT_MNG_ID")%>', '<%=cont.get("RENT_L_CD")%>')" onMouseOver="window.status=''; return true" title='스캔관리'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>									
		   	 		<td <%if(String.valueOf(cont.get("IS_RUN")).equals("해약")){%>class=is<%}%> align='center' width='6%'><%=cont.get("IS_RUN")%></td>		
				</tr>
                <%}%>
	    	</table>
		</td>
    </tr>    
    <%}%>
    <%if(st_cnt >0){
    		Vector conts = l_db.getRMContList(client_id);
		int cont_size = conts.size();
    %>     
    <tr>
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>월렌트계약</span></td>
    </tr>          
    <tr>
		<td class='line'>
	    	<table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
            	    <td width='3%' class=title>선택</td>
            	    <td width='3%' class=title>연번</td>
            	    <td width='10%' class=title>계약번호</td>
            	    <td width='7%' class=title>계약일</td>
            	    <td width='8%' class=title>차량번호</td>
            	    <td width='12%' class=title>차명</td>
            	    <td width='18%' class=title>계약기간</td>
            	    <td width='6%' class=title>영업담당</td>
            	    <td width='6%' class=title>관리담당</td>            				    
            	    <td width='13%' class=title>메모</td>
            	    <td width='5%' class=title>통화</td>
            	    <td width='3%' class=title>상태</td>
            	</tr>			
                <%for(int i = 0 ; i < cont_size ; i++){
					Hashtable cont = (Hashtable)conts.elementAt(i);
                %>
				<tr>
		    		<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='3%'><input type="checkbox" name="ch_cd" value="<%=cont.get("CAR_NO")%>" onclick="javascript:select_cont();"></td>
		    		<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='3%'><%=i+1%></td>
		    		<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='10%'><%=cont.get("RENT_S_CD")%></td>
		    		<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='7%'><%=cont.get("RENT_DT")%></td>
		    		<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='8%'><%=cont.get("CAR_NO")%></td>
		    		<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='12%'><%=cont.get("CAR_NM")%></td>
		    		<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='18%'><%=cont.get("RENT_START_DT")%>&nbsp;~&nbsp;<%=cont.get("RENT_END_DT")%>&nbsp;(<%=cont.get("RENT_MONTHS")%>개월<%=cont.get("RENT_DAYS")%>일)</td>					
		    		<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='6%'><%=cont.get("USER_NM")%></td>
		    		<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='6%'><%=cont.get("USER_NM2")%></td>		    
		    		<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='13%'><%=cont.get("ETC")%></td>
		    		<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='5%'><a href="javascript:rm_view_scan('<%=cont.get("CAR_MNG_ID")%>', '<%=cont.get("RENT_S_CD")%>')" onMouseOver="window.status=''; return true" title='스캔관리'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>									
		    		<td <%if(String.valueOf(cont.get("USE_ST")).equals("취소")||String.valueOf(cont.get("USE_ST")).equals("정산")){%>class=is<%}%> align='center' width='3%'><%=cont.get("USE_ST")%></td>		
				</tr>
                <%}%>
	    	</table>
		</td>
    </tr>        
    <%}%>
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>신용카드결제 청구서 등록</span></td>
    </tr>      
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title colspan='3' style="height:30px;">계약자명</td>
                    <td>&nbsp;
                        <input type='text' name='buyr_name' size='30' value='<%=client.getFirm_nm()%>' class='text'></td>
                </tr>								
                <tr> 
                    <td class=title colspan='3'>휴대폰번호</td>
                    <td>&nbsp;
                        <input type='text' name='buyr_tel2' size='30' value='<%=client.getCon_agnt_m_tel()%>' class='text'>(문자발송)</td>
                </tr>								
                <tr> 
                    <td class=title colspan='3' style="height:30px;" >메일주소</td>
                    <td>&nbsp;
                        <input type='text' name='buyr_mail' size='30' value='<%=client.getCon_agnt_email()%>' class='text' style='IME-MODE: inactive'>(신용카드매출전표발송))</td>
                </tr>								
                <tr> 
                    <td class=title colspan='3' style="height:30px;">차량번호</td>
                    <td>&nbsp;
                        <input type='text' name='good_name' size='30' value='' class='text'>
                    	<%if(lt_cnt >0){%>                            
                        <a href="javascript:MM_openBrWindow('/fms2/con_fee/view_sms_msg_4.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>&client_id=<%=client_id%>&from_page=/fms2/ars_card/ars_req_c.jsp','list_id1','scrollbars=yes,status=no,resizable=yes,width=960,height=860,top=50,left=50')"><img src="/acar/images/center/button_in_gj_gjny_lg.gif"  align="absmiddle" border="0" alt="리스트보기" style="height:20px;"></a> 
                        <span style="font-weight:bold; color:red;">(금액은 결제내역조회하기 버튼을 눌러서 등록해주세요.)</span>
                        <%}%>
                    </td>
                </tr>								
                <tr> 
                    <td class=title colspan='3' style="height:30px;">내역</td>
                    <td>&nbsp;
                        <textarea name='msg' rows='5' cols='90' class='text' style='IME-MODE: active'></textarea>
                    </td>
                </tr>		
                <tr>
                	<td class=title width=5% rowspan='8'>정산<br>내역</td>
                	<td class=title width=5% rowspan='3'>대여료</td>
                	<td class=title width=10% style="height:30px;">공급가</td>
                	<td>&nbsp;
                        <input type='text' id="mail_dyr_ggr" name='mail_dyr_ggr' size='30' value='' class='text' style="text-align:right;" readonly></td>
                </tr> 
                <tr>
                	<td class=title style="height:30px;">부가세</td>
                	<td>&nbsp;
                        <input type='text' name='mail_dyr_bgs' size='30' value='' class='text' style="text-align:right;" readonly></td>
                </tr>  
                <tr>
                	<td class=title style="height:30px;">소계</td>
                	<td>&nbsp;
                        <input type='text' name='mail_dyr_hap' size='30' value='' class='text' style="text-align:right;" readonly></td>
                </tr> 
                <tr>
                	<td class=title rowspan='3'>기타<br>(VAT<br>비과세)</td>
                	<td class=title style="height:30px;">과태료 등</td>
                	<td>&nbsp;
                        <input type='text' name='mail_etc_gtr' size='30' value='' class='text' style="text-align:right;" readonly></td>
                </tr>  
                <tr>
                	<td class=title style="height:30px;">연체료</td>
                	<td>&nbsp;
                        <input type='text' name='mail_etc_ycr' size='30' value='' class='text' style="text-align:right;" readonly></td>
                </tr> 
                <tr>
                	<td class=title style="height:30px;">소계</td>
                	<td>&nbsp;
                        <input type='text' name='mail_etc_hap' size='30' value='' class='text' style="text-align:right;" readonly></td>
                </tr> 
                <tr>
                	<td class=title colspan='2' style="height:30px;">합계</td>
                	<td>&nbsp;
                        <input type='text' name='settle_mny' size='30' value='' class='text' style="text-align:right;" readonly></td>
                </tr> 
                <tr>
                	<td class=title colspan='2' style="height:30px;">취급수수료</td>
                	<td>&nbsp;
                        <input type='text' name='card_fee' size='30' value='' class='text' style="text-align:right;" readonly>&nbsp;&nbsp;정산금 합계 x <input type='text' name='card_per' size='3' value='2.7' class='whitetext' style="text-align:right;" readonly>%<input type='hidden' name="r_card_per" value="2.7"><input type='hidden' name="r_card_fee" value=""></td>
                </tr>      
                <tr>
                	<td class=title rowspan='5'>결제<br>금액</td>
                </tr>           
                <tr>
                	<td class=title colspan='2' style="height:30px;">공급가</td>
                	<td>&nbsp;
                        <input type='text' name='kj_ggr' size='30' value='' class='text' style="text-align:right;" readonly>&nbsp;&nbsp;대여료(공급가)+기타+취급수수료</td>
                </tr>  
                <tr>
                	<td class=title colspan='2' style="height:30px;">부가세</td>
                	<td>&nbsp;
                        <input type='text' name='kj_bgs' size='30' value='' class='text' style="text-align:right;" readonly></td>
                </tr>       						
                <tr>
                	<td class=title colspan='2' style="height:30px;">수수료면제</td>
                	<td>&nbsp;
                        <input type='text' name='m_card_fee' size='30' value='' class='text' style="text-align:right;" readonly></td>
                </tr>       						
                <tr>
                	<td class=title colspan='2' style="height:30px;">합계</td>
                	<td>&nbsp;
                        <input type='text' name='good_mny' size='30' value='' class='text' style="text-align:right;font-weight:bold;" readonly></td>
                </tr>
                <tr> 
                    <td class=title colspan='3'>결제방식</td>
                    <td>&nbsp;
                        <input type='radio' name="app_st" value='3' onClick="javascript:cng_input()" checked>
        				SMS결제(고객)
        	      		<input type='radio' name="app_st" value='1' onClick="javascript:cng_input()">
        				ARS결제(아마존카)        						   
                    </td>
                </tr>	
    	    </table>
		</td>
    </tr> 	
    <tr>
        <td class=h></td>
    </tr>  
    <tr id=tr_ars style="display:none">
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>                          
                <tr> 
                    <td class=title width=20% style="height:30px;">카드사</td>
                    <td>&nbsp;
                        <select name="card_kind" onchange="bankCheck()">
			    <option value="">선택</option>
			    <option value="BC카드">BC카드</option>
			    <option value="삼성카드">삼성카드</option>
			    <option value="신한카드">신한카드</option>			                                
			    <option value="외환카드">외환카드</option>
			    <option value="현대카드">현대카드</option>
			    <option value="롯데카드">롯데카드</option>
			    <option value="하나SK카드">하나SK카드</option>
			    <option value="NH채움카드">NH채움카드</option>
			    <option value="KB국민카드">KB국민카드</option>
			</select>                                                
                    </td>
                </tr>								
                <tr> 
                    <td class=title style="height:30px;">카드번호</td>
                    <td>&nbsp;
                        <input type='text' name='card_no' size='20' value='' class='text' maxlength='20' placeholder="숫자만 입력" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');" ></td>
                </tr>								
                <tr> 
                    <td class=title style="height:30px;">유효기간</td>
                    <td>&nbsp;
                        <select name="card_y_mm">
			    <option value="">선택</option>
	          	    <%for(int i=1; i<=12; i++){%>
	          	    <option value="<%=AddUtil.addZero2(i)%>"><%=AddUtil.addZero2(i)%>월</option>
	          	    <%}%>
	        	</select> 
                        <select name="card_y_yy">
                            <option value="">선택</option>			    
			    <%for(int i=AddUtil.getDate2(1); i<=(AddUtil.getDate2(1)+10); i++){%>
			    <option value="<%=i%>" ><%=i%>년</option>
			    <%}%>
			</select>	        			           
                    </td>
                </tr>								
                <tr> 
                    <td class=title style="height:30px;">할부기간</td>
                    <td>&nbsp;
                        <select name="quota">			    
			    <option value="">일시불</option>
	          	    <%for(int i=2; i<=6; i++){%>
	          	    <option value="<%=i%>"><%=i%>개월</option>
	          	    <%}%>
			</select>                                                                    
                        (무이자는 없음)&nbsp;&nbsp;&nbsp;* BC카드 3개월까지만 할부 가능 
                    </td>
                </tr>			                							
    	    </table>
		</td>
    </tr> 	
    <tr>
        <td class=h></td>
    </tr>        
    <tr>
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2> 수수료 면제 </span></td>
    </tr>      
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=20% colspan='3' style="height:30px;">수수료 면제 여부</td>
                    <td>&nbsp;
                        <input type="checkbox" name="exempt_yn" value="Y" onClick="javascript:set_amt(1)"> 수수료 면제 한다. (구두로 사전 결제를 받은 건에 한정)
                    </td>
                </tr>	
                <tr> 
                    <td class=title width=10% colspan='3' style="height:30px;">수수료 면제 사유</td>
                    <td>&nbsp;
                        <textarea name='exempt_cau' rows='5' cols='90' class='text' style='IME-MODE: active'></textarea>
                    </td>
                </tr>	
    	    </table>
		</td>
    </tr> 	  
    <tr>
        <td>* 수수료 면제 요청시 담당자-팀장-총무팀장-대표이사 문서결재시스템 처리</td>
    </tr>
    <!--       
    <tr>
    	<td style="text-align:left;">
    		<input type="checkbox" name="mail_check" value="Y" onclick="">메일 발송하기
    	</td>
    </tr>
     -->                  
    <tr>
        <td class=h></td>
    </tr>
    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
    <tr>
	<td align="right"><a href="javascript:save();"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
    </tr>	
    <%}%>
    
    <%if(vt_size > 0){%>  
    <tr>
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>최근 2일간 카드결제 청구분</span> <Font color=red>(중복등록 안되게 확인하고 처리해주세요.)</Font></td>
    </tr>              
    <tr>
		<td class='line'>
	    	<table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
            	    <td width='5%' class=title>연번</td>
            	    <td width='15%' class=title>청구일</td>
            	    <td width='10%' class=title>청구자</td>
            	    <td width='15%' class=title>상품명</td>
            	    <td width='30%' class=title>내역</td>
            	    <td width='10%' class=title>금액</td>
            	    <td width='15%' class=title>승인일자</td>
            	</tr>			
                <%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);%>
				<tr>
		    		<td align='center' ><%=i+1%></td>					
		    		<td align='center'><%=ht.get("REG_DT")%></td>
		    		<td align='center'><%=ht.get("USER_NM")%></td>
		    		<td align='center'><%=ht.get("GOOD_NAME")%></td>
		    		<td align='center'><%=ht.get("GOOD_CONT")%></td>
		    		<td align='rigth'><%=AddUtil.parseDecimal(String.valueOf(ht.get("GOOD_MNY")))%>원</td>
		    		<td align='center'><%=ht.get("APP_DT")%></td>
				</tr>
                <%}%>
	    	</table>
		</td>
    </tr>    
    <%} %>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	

//-->
</script>
</body>
</html>
