<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*, acar.cont.*,  acar.settle_acc.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");

	//거래처
	ClientBean client = al_db.getClient(client_id);	
	
	//Cont List
	Vector vt = s_db.getContList2(client_id);
	
	int vt_size = vt.size();
	
	
	String p_zip = "";
	String p_addr = "";
	
	if(vt_size > 0) {
		for(int i = 0 ; i < vt_size ; i++) {
			Hashtable ht = (Hashtable)vt.elementAt(i);
			if(!String.valueOf(ht.get("P_ZIP")).equals("")){
				p_zip = String.valueOf(ht.get("P_ZIP"));
			}
			if(!String.valueOf(ht.get("P_ADDR")).equals("")){
				p_addr = String.valueOf(ht.get("P_ADDR"));
			}
			
		}
	}
	
%>

<html>
<head><title>FMS</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--	
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') SearchopenBrWindow();
	}
	//팝업윈도우 열기
	function SearchopenBrWindow() { //v2.0
		fm = document.form1;
		if(fm.gov_nm.value == '') { alert('수신기관을 확인하십시오.'); return; }
		window.open("about:blank",'search_open','scrollbars=yes,status=no,resizable=yes,width=800,height=500,left=50,top=50');		
		fm.action = "../pop_search/s_client.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&t_wd="+fm.gov_nm.value;
		fm.target = "search_open";
		fm.submit();		
	}
	
	//중도해지정산  보기
	function view_settle(m_id, l_cd){
		window.open("/acar/cls_con/cls_settle.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SETTLE", "left=100, top=10, width=700, height=650, scrollbars=yes, status=yes");		
	}	
	
	
	function cng_input(val){
	
		var fm = document.form1;
	
				
		if(val == '사업장'){ 		//사업장 주소
			fm.gov_zip.value= "<%=client.getO_zip()%>";
			fm.gov_addr.value= "<%=client.getO_addr()%>";
		}else if(val == '자택'){ 	//자택	
			fm.gov_zip.value= "<%=client.getRepre_zip()%>";
			fm.gov_addr.value= "<%=client.getRepre_addr()%>";		
		}else if(val == '우편물'){ 	//
			
			fm.gov_zip.value = "<%=p_zip%>";
			fm.gov_addr.value = "<%=p_addr%>";
		}else if(val == '기타'){ 	//
			fm.gov_zip.value = "";
			fm.gov_addr.value = "";
		}
	}
		
	
	//등록
	function doc_reg(){
		var fm = document.form1;		
		   
		if(fm.doc_id.value == '')		{ alert('문서번호를 입력하십시오.'); 	return; }
		if(fm.doc_dt.value == '')		{ alert('시행일자를 입력하십시오.'); 	return; }		
		if(fm.gov_id.value == '')		{ alert('수신기관을 선택하십시오.'); 	return; }		
		if(fm.gov_nm.value == '')		{ alert('수신기관을 선택하십시오.'); 	return; }
		if(fm.title.value == '')		{ alert('제목을 선택하십시오.'); 		return; }
		if(fm.gov_addr.value == '')		{ alert('주소를 입력하십시오.'); 		return; }
		if(fm.end_dt.value == '')		{ alert('유예기간을 입력하십시오.'); 		return; }
		
		<%if(!client_id.equals("")){%>	
				
		if(fm.tax_yn.checked == true && (fm.stop_s_dt.value == '' || fm.stop_e_dt.value == '' || fm.stop_cau.value == '')){ alert('중지기간, 사유를 입력하십시오.'); return; }
		
		if(!list_confirm()){				return;	}
		
		if(fm.title.value == '계약해지 및 차량반납 통보'){ 
			chk_confirm();
		}
		
		if(!confirm('등록하시겠습니까?')){	return;	}		
		fm.action = "settle_doc_reg_sc_a.jsp";
		fm.target = "i_no";
		fm.submit()
		
		<%}%>
	}
	
	//미수채권 선택
	function list_confirm(){
		var fm = document.form1;
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name.indexOf("ch_l_cd") != -1){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		
		if(cnt == 0){
		 	alert("미수채권을 선택하세요.");
			return false;
		}else{
			return true;	
		}				
		
	}			
	
	//계약해지 및 차량반납 통보인경우 대여료 금액 확인 !!!
	function chk_confirm(){
			
			var listLen = $('.checkbox-area').length;	      	
	    	var amt2 ="";	 
	    	var lamt2 ="";	  
	    	var result="";
	    		   	    
	    	for(var i=0; i< listLen; i++){
	    	    
		        if($("#ch_l_cd_"+i).is(":checked")){
		       		amt2 = $("#amt2_"+i).val();		
		        	lamt2 = $("#lamt2_"+i).val();			        	
		        //     alert(amt2);
		        //     alert(lamt2);
		        	if(amt2 != lamt2){
		        		result =  (i+1) + "번째 정산서상의 미납대여료와 차이가 발생되었습니다. 확인 후 진행하세요!!"		      
		           	}		        	
		        
		        }
	    	}
    	    	
	    	if(result){
	    		alert(result);	    
	    	}
					
	}			
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}

		$(document).ready(function(){
				
	    $("input[type='checkbox']").change(function(){
	    	var listLen = $('.checkbox-area').length;
	    	var checkUse ="";	    	
	    	var use_yn ="";	    	
	    	var result="";
	    	
	    	var id = $(this).attr('id');
	    
	    	for(var i=0; i< listLen; i++){
	    	    
		        if($("#ch_l_cd_"+i).is(":checked")){
		        	use_yn = $("#use_yn_"+i).val();		
		        		        	
		        	if(!checkUse){
		        		checkUse = use_yn;
		        		
		        	}else{
		        		if(checkUse != use_yn){
		        			result = "진행 상태와 해지상태를 동시에 등록 할 수 없습니다."
			        		   
		        		}
		        	}		        	
		        
		        }
	    	}
	    	
	    	if(checkUse == "진행"){	    	    
	    	 	$('#title option:last').attr('disabled','disabled').hide();
	    	 	$('#title option:nth-child(2)').removeAttr('disabled').show();
	    	 	$('#title option:nth-child(3)').removeAttr('disabled').show();
	    		  
	    	}else{

	    		$('#title option:nth-child(2)').attr('disabled','disabled').hide();
	    		$('#title option:nth-child(3)').attr('disabled','disabled').hide();
	    		$('#title option:last').removeAttr('disabled').show();
	    		
	    	}
	    	
	    	if(result){
	    		alert(result);
	    		$('#'+id).attr("checked",false);
	    	}
	    	
	    });
	});
		
		
	function print_view(rent_mng_id, rent_l_cd )
	{
		var fm = document.form1;
		var m_id = rent_mng_id;
		var l_cd = rent_l_cd;
		var b_dt=  fm.doc_dt.value;
		var cls_chk;
	    var mode;
	    fm.scd_fee_cnt.value = '1';
	   	
	    
		window.open("/fms2/con_fee/fee_scd_print.jsp?m_id="+m_id+"&l_cd="+l_cd+"&b_dt="+b_dt+"&cls_chk="+cls_chk+"&mode="+mode, "PRINT_VIEW", "left=50, top=50, width=700, height=640, scrollbars=yes");
	}
	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' action='settle_doc_reg_sc_a.jsp' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='size' value=''>


  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class="line"> 
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width="12%">문서번호</td>
            <td>&nbsp; 
              <input type="text" name="doc_id" size="20" class="text" value="<%=FineDocDb.getSettleDocIdNext("채권추심")%>">
            </td>
          </tr>
          <tr> 
            <td class='title'>시행일자</td>
            <td>&nbsp; 
              <input type="text" name="doc_dt" size="11" class="text" value="<%=AddUtil.getDate()%>" onBlur='javscript:this.value = ChangeDate(this.value);'>
            </td>
          </tr>
          <tr> 
            <td rowspan="2" class='title'>수신</td>
            <td>&nbsp;
             <input type="text" name="gov_nm" value="<%=client.getFirm_nm()%>" size="50" class="text" style='IME-MODE: active'>
			  <input type='hidden' name="gov_id" value="<%=client_id%>">			 
			</td>
          </tr>
            <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('gov_zip').value = data.zonecode;
								document.getElementById('gov_addr').value = data.address;
								
							}
						}).open();
					}
				</script>			
				
          <tr>
            <td>&nbsp;
            	<select name="post_st" onchange="javascript:cng_input(this.options[this.selectedIndex].value);">                				
								<option value="사업장" selected>사업장</option>		
								<option value="자택">자택</option>								
								<option value="우편물">우편물</option>								
								<option value="기타">기타</option>		
				  </select>				
				<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>				
				&nbsp;<input type="text" name="gov_zip" id="gov_zip"  size="10" class="text" value="<%=client.getO_zip()%>">
            <input type="text" name="gov_addr"   id="gov_addr"  size="100" class="text" value="<%=client.getO_addr()%>">
              (주소) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
               <a href="javascript:MM_openBrWindow('settle_doc_f_result.jsp?client_id=<%=client_id%>','popwin_vacation','scrollbars=yes,status=no,resizable=yes,width=700,height=300,top=400,left=240')"><img src="/images/esti_detail.gif"  width="15" height="15" align="absmiddle" border="0" alt="반송주소리스트보기"></a>
              
              
              반송주소</td>
          </tr>    
          <tr> 
            <td class='title'>참조</td>
            <td>&nbsp;
              <input type="text" name="mng_dept" size="50" class="text" value="대표이사 <%=client.getClient_nm()%>"> 
              </td>
          </tr>
          <tr> 
            <td class='title'>제목</td>
            <td>&nbsp;&nbsp;<select name='title' id="title">
								<option value=''>선택</option>								
								<option value="계약해지 및 납부최고">계약해지 및 납부최고</option>		
						    	<option value="계약해지 및 차량반납 통보">계약해지 및 차량반납 통보</option>
								<option value="해지통보 및 해지정산금 납입고지">해지통보 및 해지정산금 납입고지</option>
               </select>
			   <input type="text" name="title_sub" size="40" class="text" value="">&nbsp;<font color='#CCCCCC'>(기타일때)</font>
			   </td>
          </tr>
          <tr> 
            <td class='title'>유예기간</td>
            <td>&nbsp;&nbsp;<input type="text" name="end_dt" size="11" class="text" value="" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
          </tr>
  
        </table>
      </td>
    </tr>
    <tr>
        <td></td>
    </tR>
	
	<%if(!client_id.equals("")){%>
    <tr>
      <td>
      	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <font color="red"><b>미수채권</b></font>  
      </td>
    </tr>	
	<%	Vector settles = s_db.getSettleList3_fine("", "", "", "", "", "", "1", client.getFirm_nm());
		int settle_size = settles.size();
		int base1_amt = 0;
	%>
	<script language='javascript'>
	<!--	
		document.form1.size.value = <%=settle_size%>;
	//-->
	</script>
	<tr>
        <td class=line2></td>
    </tR>
    <tr>
      <td class='line'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width="4%" >선택</td>
            <td class='title' width="4%">상태</td>
            <td class='title' width="12%">계약번호</td>
            <td class='title' width="8%">차량번호</td>
            <td class='title' width="8%">만료일</td>
            <td class='title' width="8%">선수금</td>
            <td class='title' width="8%">대여료</td>			
            <td class='title' width="8%">과태료</td>						
            <td class='title' width="8%">면책금</td>									
            <td class='title' width="8%">중도해지위약금</td>												
            <td class='title' width="12%">합계</td>
          </tr>
		  <%	for (int i = 0 ; i < settle_size ; i++){
					Hashtable settle = (Hashtable)settles.elementAt(i);
																						
					//계약기본정보
				    ContBaseBean base = a_db.getCont( String.valueOf(settle.get("RENT_MNG_ID")), String.valueOf(settle.get("RENT_L_CD")) );
				
					int ifee_mon = 0;
					int ifee_day = 0;
					
					int r_mon = 0;
					int r_day = 0;
									
					int s_mon = 0;
					int s_day = 0;
								
					int nfee_mon = 0;
					int nfee_day = 0;
					float nfee_amt = 0;
					int n_nfee_amt = 0;
				
					int	 nfee_s_amt = 0;
					int fee_s_amt   = 0;
					int ifee_s_amt   = 0;
					
					float ifee_tm = 0;
					int i_ifee_tm = 0;
					
					int pay_tm = 0;
					float ifee_ex_amt = 0;
					int	rifee_s_amt = 0;
					int	nfee_ex_amt = 0;
					
					float f_amt2	 = 0;
					int	  lamt_2	 = 0; 
										
					if(!base.getUse_yn().equals("N")){            
					 //차량반납통보시 사용되는 미납대여료 				
					//기본정보  - 해지정산금 관련 작업
						Hashtable base1 = as_db.getSettleBase(String.valueOf(settle.get("RENT_MNG_ID")), String.valueOf(settle.get("RENT_L_CD")), "", "");
																	
						fee_s_amt = AddUtil.parseInt((String)base1.get("FEE_S_AMT")); //월대여료
						
						r_mon = AddUtil.parseInt((String)base1.get("R_MON")); //사용월
						r_day = AddUtil.parseInt((String)base1.get("R_DAY")); //사용일
										
						nfee_mon = AddUtil.parseInt((String)base1.get("S_MON")); //미납월
						nfee_day = AddUtil.parseInt((String)base1.get("S_DAY")); //미납일
						
						if ( ifee_s_amt > 0 ) { //개시대여료
							ifee_tm =  ifee_s_amt / fee_s_amt; //  선수금 / 월대여료
							i_ifee_tm = (int) ifee_tm; 
							pay_tm =  AddUtil.parseInt((String)base1.get("CON_MON"))- i_ifee_tm;
							
							if ( r_mon > pay_tm || (r_mon == pay_tm && r_day > 0) ){
								ifee_mon 	= r_mon - pay_tm;
								ifee_day 	= r_day ;
							}		
							//				(월대여료 * 월별 선수금 ) + (월대여료 / 30 * 일별 선수금)
							ifee_ex_amt	= (fee_s_amt*ifee_mon) + ( fee_s_amt/30 *ifee_day );
							nfee_ex_amt = (int)  ifee_ex_amt;
							rifee_s_amt	=  ifee_s_amt - nfee_ex_amt;						
						}
						
						//스케쥴이 있다는 가정 
						if(ifee_s_amt == 0 ) {
							  if  (  AddUtil.parseInt((String)base1.get("DI_AMT")) > 0  ) {	
										 if ( AddUtil.parseInt((String)base1.get("S_MON"))  - 1  >= 0 ) {
											 nfee_mon 	= 	AddUtil.parseInt((String)base1.get("S_MON")) - 1;  // 잔액이 발생되었기에 1달 빼줌      
										 } 		
						   	    	 	
										 if ( AddUtil.parseInt((String)base1.get("S_DAY")) > 1 &&  AddUtil.parseInt((String)base1.get("S_MON"))  < 1 ) {
									   		  	if ( AddUtil.parseInt((String)base1.get("HS_MON")) < 1  &&  AddUtil.parseInt((String)base1.get("HS_DAY")) > 1 ) {  // 잔액 스케쥴에 해지일이 포함되는 경우
									   		  		nfee_day  = AddUtil.parseInt((String)base1.get("HS_DAY")); 
												 }
									   	 }
										 
						   	    	      //선납이 있다면 
						   	    	     /* 
						   	    	     if (  AddUtil.parseInt((String)base.get("EX_S_AMT")) > 0 ){
						   	    	     	nfee_day = 0;
						   	    	     } else {	
						   	    	     	 if ( AddUtil.parseInt((String)base.get("RENT_END_DT")) <   AddUtil.parseInt(cls_dt) ) { //만기이후	  	    	      
							   	    	  	
							   	    	  		 if  ( AddUtil.parseInt((String)base.get("NFEE_S_AMT"))  == 0 ) {
							   	    	  	 		nfee_day 	= 	r_day;
							   	    	  	 	 }	
							   	    	  	 }  	
							   	    	 }  */
						  	  }  
						
						}   					
					
						//미납대여료												 
					    nfee_amt =  fee_s_amt * ( nfee_mon + (AddUtil.parseFloat(Integer.toString(nfee_day))/30) );
								
						// 개시대여료 있는 경우에 한함. (해지일이 대여기간을 경과한 경우에 한함 )
					  	if ( ifee_s_amt > 0 ) { //개시대여료
					 	   				
					   		if ( rifee_s_amt < 0) {  //개시대여료를 다 소진한 경우
					   	   								
						   	    if ( AddUtil.parseInt((String)base1.get("RENT_END_DT")) <   AddUtil.parseInt((String)base1.get("USE_S_DT")) ) { //만기이후 대여료 스케쥴이 생성된 경우 
						   	       if ( AddUtil.parseInt((String)base1.get("RENT_END_DT"))  >  AddUtil.parseInt((String)base1.get("DLY_S_DT")) ) { //만기일 이전에 미납분이 있는 경우  
						   	      //     alert(" 개시대여료 소진, 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 있는 경우");
						   	       	   nfee_amt =  fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) - ifee_s_amt; 		
						   	        }else {
						   	      //     alert(" 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 없는 경우");
						   	       	  nfee_amt =  fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ); 		
						   	       }
						   	    } else { //만기이후 대여료 스케쥴이 생성이 안된 경우 - 경과 개시대여료 계산하여 미납분 표시 
						   	       if ( AddUtil.parseInt((String)base1.get("RENT_END_DT"))  >  AddUtil.parseInt((String)base1.get("DLY_S_DT")) ) { //만기일 이전에 미납분이 있는 경우
						   	     //  alert(" 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 있는 경우");
						   	           nfee_amt =  fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) - ifee_s_amt; 		// 총미납료에서 - 개시대여료 공제   	   
						   	      }else {
						   	       //    alert(" 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 없는 경우");
						   	       	   nfee_amt	= 	fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) - rifee_s_amt ; 
						   	      	
						   	       }
						   	   }
						    } else {  //개시대여료가 남아있는 경우
						         if ( AddUtil.parseInt((String)base1.get("RENT_END_DT")) <   AddUtil.parseInt((String)base1.get("USE_S_DT")) ) { //만기이후 대여료 스케쥴이 생성된 경우 
						   	        if ( AddUtil.parseInt((String)base1.get("RENT_END_DT"))  >  AddUtil.parseInt((String)base1.get("DLY_S_DT")) ) { //만기일 이전에 미납분이 있는 경우  
						   	       	//   alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 있는 경우");
						   	       	   nfee_amt			= fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) - ifee_ex_amt;	// 총미납료에서 - 개시대여료 공제
						   	       }else {
						   	        //   alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성, 만기일 이전 미납분이 없는 경우");
						   	       	    nfee_amt =  fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ); 	
						   	       }
						   	    } else { //만기이후 대여료 스케쥴이 생성이 안된 경우 - 경과 개시대여료 계산하여 미납분 표시 
						   	       if ( AddUtil.parseInt((String)base1.get("RENT_END_DT"))  >  AddUtil.parseInt((String)base1.get("DLY_S_DT")) ) { //만기일 이전에 미납분이 있는 경우
						   	       //    alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이 있는 경우");
						   	           nfee_amt 	= 	fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) - ifee_ex_amt;	// 총미납료에서 - 개시대여료 공제   	   
						   	      }else {
						   	        //   alert(" 개시대여료 잔액있음, 만기후 대여료스케쥴이 생성 안됨, 만기일 이전 미납분이없는 경우");
						   	       	   nfee_amt 	= 	fee_s_amt * ( nfee_mon + AddUtil.parseFloat(Integer.toString(nfee_day))/30 ) ;
						   	
						   	       }
						   	   }
						    } 
						      
					   	} 
					   	 	
						f_amt2	=	AddUtil.parseInt((String)base1.get("DI_AMT"))  + nfee_amt;  //대여료		    	
			   		//	f_amt2	=	AddUtil.parseInt((String)base.get("DI_AMT")) - AddUtil.parseInt((String)base.get("EX_S_AMT")) + nfee_amt;  //대여료
			   		//	f_amt2	=	FineDocListBn.getAmt2();  //대여료
			   				   			
				 		lamt_2 = ( int ) f_amt2; 		
					
					}	
			%>
			
			<input type='hidden' name='scd_fee_cnt'  value='' >

          <tr class="checkbox-area"> 
		    <input type='hidden' name='c_id_<%=i%>' value='<%=settle.get("CAR_MNG_ID")%>'>
		    <input type='hidden' name='m_id_<%=i%>' value='<%=settle.get("RENT_MNG_ID")%>'>		
		    <input type='hidden' id="lamt2_<%=i%>" name='lamt2_<%=i%>' value='<%=lamt_2%>'>			   
            <td align='center' width="4%" ><input type="checkbox" name="ch_l_cd_<%=i%>"  id="ch_l_cd_<%=i%>" value="Y" ></td>
            <td align='center' width="4%" ><input type="text" name="use_yn_<%=i%>"  size="2" id="use_yn_<%=i%>" class="whitetext" value="<%if(settle.get("USE_YN").equals("Y")){%>진행<%}else{%>해지<%}%>" ></td>
            <td align='center' width="14%"><input type="text" name="l_cd_<%=i%>" size="15" class="whitetext" value="<%=settle.get("RENT_L_CD")%>">&nbsp;&nbsp;
           <%	if(!base.getUse_yn().equals("N")){%>            
             <a href="javascript:view_settle('<%=String.valueOf(settle.get("RENT_MNG_ID"))%>','<%=String.valueOf(settle.get("RENT_L_CD"))%>');"  title='정산하기'><img src=/acar/images/center/button_js.gif align=absmiddle border=0></a>
            <% } %>            
            </td>
            <td align='center' width="8%"><input type="text" name="car_no_<%=i%>" size="11" class="whitetext" value="<%=settle.get("CAR_NO")%>"></td>	    
            <td align='center' width="8%"><input type="text" name="end_dt_<%=i%>" size="12"  id="end_dt_<%=i%>" class="whitetext" value="<%=base.getRent_end_dt()%>"></td>
            <td align='center' width="8%"><input type="text" name="amt1_<%=i%>" size="10" class="whitenum" value="<%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT1")))%>"></td>
            <td align='center' width="8%"><input type="text" id="amt2_<%=i%>" name="amt2_<%=i%>" size="10" class="num" value="<%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT2")))%>">
            	<br><a href="javascript:print_view('<%=String.valueOf(settle.get("RENT_MNG_ID"))%>','<%=String.valueOf(settle.get("RENT_L_CD"))%>');" title='기본' onMouseOver="window.status=''; return true">[스케쥴]</a>
            </td>			
            <td align='center' width="8%"><input type="text" name="amt3_<%=i%>" size="8" class="whitenum" value="<%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT3")))%>"></td>						
            <td align='center' width="8%"><input type="text" name="amt4_<%=i%>" size="8" class="whitenum" value="<%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT4")))%>"></td>									
            <td align='center' width="8%"><input type="text" name="amt5_<%=i%>" size="10" class="whitenum" value="<%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT6")))%>"></td>												
            <td align='center' width="12%"><input type="text" name="amt6_<%=i%>" size="11" class="whitenum" value="<%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT0")))%>"></td>
          </tr>
         
          
		  <%	}%>
        </table>
	  </td>
    </tr>	
    <tr>
        <td></td>
    </tR>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>세금계산서 발행 일시중지 등록</span></td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tR>
    <tr>
	    <td class="line">
	      <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr>
            <td width="12%" class='title'>계산서발행</td>
            <td>&nbsp;
              <input type="checkbox" name="tax_yn" value="Y" >
              중지
            </td>
          </tr>
          <tr>
            <td class='title'>구분</td>
            <td>&nbsp;
              <input type="radio" name="stop_st" value="1" checked>
              연체
            </td>
          </tr>
          <tr>
            <td class='title'>중지기간</td>
            <td><table width="300"  border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td width="135">&nbsp;
				<input type='text' name='stop_s_dt' value='' maxlength='11' size='11' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
                  부터</td>
                <td width="115"><input type='text' name='stop_e_dt' value='' maxlength='11' size='11' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
                  까지</td>
                <td></td>
              </tr>
            </table></td>
          </tr>
          <tr>
            <td class='title'>사유</td>
            <td>&nbsp;
              <textarea name="stop_cau" cols="75" rows="3" class="text"></textarea>
            </td>
          </tr>
        </table>
      </td>
    </tr>	
    <tr>
        <td></td>
    </tR>
  
    <tr>    
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>안내메일 <input type="hidden" name="mail_yn" value="Y" ></span></td>
	<tr>
		
	<tr>
        <td class=line2></td>
    </tR>
    
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>		  
          <tr>
            <td width="12%" class=title>메일주소</td>
            <td>&nbsp;
			  <input type='text' name='email' size='40' value='<%=client.getCon_agnt_email()%>' class='text' style='IME-MODE: inactive'>
			</td>
          </tr>		  	  		  
       	  	  		  
        </table>
      </td>
    </tr>
    
     <tr>
        <td></td>
    </tR>
    <tr>
	  <td align='left'>&nbsp;<font color="#FF0000">***</font> 안내메일은 결과등록시 자동 발송됩니다. </td>
	</tr>	
  
<%}%>	

    <tr>
      <td align="right">
	  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	  <a href='javascript:doc_reg()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>
	  <%}%>
	  </td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
