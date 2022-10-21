<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.accid.*, acar.car_service.*, tax.*, acar.user_mng.*, acar.cont.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="s_bean2" class="acar.car_service.ServiceBean" scope="page"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"3":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"4":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");	
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String accid_id = request.getParameter("accid_id")==null?"":request.getParameter("accid_id");//사고관리번호
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");//정비관리번호
	String mode = request.getParameter("mode")==null?"7":request.getParameter("mode");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
			
	AccidDatabase as_db = AccidDatabase.getInstance();
	AddCarServDatabase a_csd = AddCarServDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "02", "04");
	
	int acc_size = 0;
	
	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	String client_id = "";
	client_id =  (String)cont.get("CLIENT_ID");
	
	String car_st = "";
	car_st =  (String)cont.get("CAR_ST");
	
	//사고조회
	AccidentBean a_bean = as_db.getAccidentBean(c_id, accid_id);
	
		//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP"); 
	int user_size = users.size();
	
	int  max_nn = 0;
	int nn_cnt = 0;
	
	//정비/점검(면책금)
	ServiceBean s_r [] = as_db.getServiceList(c_id, accid_id);

	if(serv_id.equals("") && s_r.length>0){
		for(int i=0; i<1; i++){
			s_bean2 = s_r[i];
			serv_id = s_bean2.getServ_id();
			
			//선청구분이 있다면
			if ( serv_id.substring(0,2).equals("NN")) {
			      max_nn = AddUtil.parseInt(serv_id.substring(2,6));					      	  			
			}
					
		}
	}
	
	
	// 차량별정비
	acc_size = s_r.length;
	if (acc_size < max_nn ) {
		acc_size = max_nn;
	}	
	
	//면책금 선청구관련 - 일단 막아놓음
	if (serv_id.equals("")) serv_id = "NN0001";

	//정비/점검(면책금)
	ServiceBean s_bean = a_csd.getService(c_id, accid_id, serv_id);	
	
	String bus_id2 = "";
	//면책금 청구일
	String req_dt = s_bean.getCust_req_dt();
		
	if ( !s_bean.getBus_id2().equals("")){
	 	bus_id2 = s_bean.getBus_id2();
	// 	req_dt = s_bean.getCust_req_dt();	 
	} else {
	    if ( !a_bean.getBus_id2().equals("") ) {  //사고시점의 담당자
	  	    bus_id2 = a_bean.getBus_id2();
	    } else {
			bus_id2 = (String)cont.get("BUS_ID2");
		}	
	}
	
	int s_cnt = 0;
	s_cnt = a_csd.getService(c_id, accid_id, serv_id, "1");	
		
	if ( s_cnt < 1) {
		req_dt = AddUtil.getDate();
	}
	
	
	if ( req_dt.equals("")){
		if ( !s_bean.getSac_dt().equals("")){ //
			req_dt = AddUtil.getDate();
		}
	}
	
  //  System.out.println("s_cnt="+s_cnt); 
	
	//청구서발행 조회
	TaxItemListBean ti = IssueDb.getTaxItemListServM(c_id, serv_id, s_bean.getCust_amt());
	
	//거래명세서 조회
	TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(ti.getItem_id());
	
	if(ti_bean.getUse_yn().equals("N")){
		ti = new TaxItemListBean();
	}
	
	//세금계산서 조회
	tax.TaxBean t_bean 		= IssueDb.getTax_itemId(ti.getItem_id());
	
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	
	//면책금청구여부
	Hashtable etc_cms = as_db.getRentCaseClient(m_id, l_cd);
	
	
	//면책금 이중청구 방지위해 - 선청구포함되지 않으면 할수 있도록 함.
	int dup_cnt = 0;
	dup_cnt = a_csd.getServCustCnt(c_id, accid_id);	
//	System.out.println("dup_cnt = " + dup_cnt);	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//수정하기
	function save(cmd){
	
		var fm = document.form1;	
								
		fm.cmd.value = cmd;
		var vat_chk_amt = 0;
		var vat_chk1_amt = 0;
		
			
		//해지정산은 해지시 계산서 발행
		if ( toInt(parseDigit(fm.cls_v_amt.value))  > 0 &&   fm.bill_doc_yn.value == '4'  ) {
		 	  alert("해지정산시 처리된건입니다.  세금계산서 발행구분을 확인하세요!!");
		 	  return;
		} 		
		
		<% if(  nm_db.getWorkAuthUser("전산팀",user_id) ) { %>
		<% } else { %>
			//면책금 선청구는 해지정산 금액 입력 불가 - 20140703 
			if ( fm.serv_id.value.substr(0,2)  =="NN"    &&  toInt(parseDigit(fm.cls_s_amt.value))  > 0  ) {		   
			       alert("면책금선청구건에 해지정산금액을 입력할 수 없습니다.!!");
			       return;
			}
			
			if ( fm.serv_id.value.substr(0,2)  =="NN"    &&  toInt(parseDigit(fm.ext_amt.value))  > 0  ) {		   
			       alert("면책금선청구건에 고객입금액을 입력할 수 없습니다.!!");
			       return;
			}
	
		<%} %>
				
	//	if(fm.serv_id.value=="" || fm.off_id.value=="" ){ alert("물적사고-자차를 먼저 입력해 주세요."); return; }	
					
		//거려명세서 발행의뢰인 경우 공급가, 부가세 금액  - 거래명세서와 상관없이 청구일자 체크 (청구금액이 있다면 )
	//	if ( fm.bill_doc_yn.value == '4') {
		 	
			//해지나 고객입금이 아닌경우 
			if ( toInt(parseDigit(fm.cls_s_amt.value))  > 0   ||  toInt(parseDigit(fm.ext_amt.value))  > 0 || fm.no_dft_yn.checked == true ) {
				
			} else {
			 
			 	if ( fm.cust_req_dt.value == ''  ) {
			 		  alert("청구일자를 확인하세요!!");
			 		  return;
			 	}
			 	
			 	if ( toInt(parseDigit(fm.cust_s_amt.value))  < 1  ) {
			 		  alert("청구공급가액을 확인하세요!!");
			 		  return;
			 	}	
			 		 
			 	if ( toInt(parseDigit(fm.cust_v_amt.value))  > 1  ) {
			 		  alert("청구부가세액을 확인하세요!!");
			 		  return;
			 	}	
			}	      		         			 
	//	}
		
		if ( toInt(parseDigit(fm.cust_s_amt.value))  > 0 &&  toInt(parseDigit(fm.cls_s_amt.value))  > 0  ) {
		 		  alert("청구금액과 해지정산시금액이 이중입력되었습니다. 확인하세요!!");
		 		  return;
		} 	
		
		
		//고객입금액 
		if ( toInt(parseDigit(fm.ext_amt.value))  > 0  ) {
			if ( fm.ext_cau == ''  ) {
		 		  alert("고객입금내역을 확인하세요!!");
		 		  return;
		 	} 	
		}
		
		
		if ( toInt(parseDigit(fm.cust_v_amt.value))  > 1  ) {
		 		  alert("청구부가세액을 확인하세요!!");
		 		  return;
		} 		
	
	
		
		if ( toInt(parseDigit(fm.cls_v_amt.value))  >  1  ) {
		
			//청구부가세액이 10% 여부 확인 
	//	 	vat_chk1_amt 	= toInt(  toInt(parseDigit(fm.cls_s_amt.value)) * 0.1  -   toInt(parseDigit(fm.cls_v_amt.value))) ;
		  		 
		// 	if (vat_chk1_amt == -1 || vat_chk1_amt == 1 || vat_chk1_amt == 0 ) {
		 //	} else {
		 	 	 alert("해지정산부가세액을 확인하세요!!");
		 		 return;
		 //	}		 	
		 } 	
		
		//중복체크 안하게
		if (  fm.user_id.value == '000063' || fm.user_id.value == '000029' ) {
		} else {
			// dup check
			if ( <%=dup_cnt%> > 0  &&  cmd == 'i'  ) {
			 	  alert("이미 면책금을 청구하였습니다. 확인하세요. !!");
				    return;		
			}	
	        }
		
		if ( cmd == 'i' ) {		
			if ( toInt(parseDigit(fm.cust_amt.value))  == 0 && toInt(parseDigit(fm.ext_amt.value))  == 0 && toInt(parseDigit(fm.cls_amt.value))  == 0 && fm.no_dft_cau.value == '') {
			 	 alert("입력내용을 확인하세요!!");
			 	 return;
			}	
		}		
						

		
		//타이어휠타운 면책금 청구시 warning
		if ( fm.off_id.value == '008634') {
			if ( toInt(parseDigit(fm.cust_s_amt.value))  > 1  ) {
				 alert("타이어휠타운에 면책금 청구했습니다. 면책금 청구가 맞는지 다시 한번 확인해서 처리하세요!!!!!!!");	
			} 
		}
				
			//계산서미방행으로만  - 20161201
		if ( fm.bill_doc_yn.value == '1') {
				 alert("면책금은 계산서를 발행할 수 없습니다.!!!!!");
			 	 return;
		}	
				
		if ( fm.bill_doc_yn.value == '') {
				 alert("거래명세서 발행유무를 선택하세요!!!!");
			 	 return;
		}	
				
			
		//청구금액 CHECK
		if(cmd == 'i'){ if(!confirm('등록하시겠습니까?')){return;}}
		else		  {	if(!confirm('수정하시겠습니까?')){return;}}
		
	<% if(ti.getCar_mng_id().equals("")){%>	
		fm.biil_re_yn.value= "R";
	<%} %>	
		fm.target = "i_no";
		fm.action = "accid_u_a.jsp";
		fm.submit();
	}

	function view_serv_accid(serv_id){
		var fm = document.form1;	
	
		fm.serv_id.value = serv_id;
		fm.action='accid_u_in7.jsp';
		fm.target='_self';
		fm.submit();		
	}
	
		//청구금액
	function set_cust_amt(){
		var fm = document.form1;
		
		fm.cust_amt.value 	= parseDecimal( toInt(parseDigit(fm.cust_s_amt.value)) + toInt(parseDigit(fm.cust_v_amt.value)));		
		
	}	
	
	//해지시 포함금액
	function set_cls_amt(){
		var fm = document.form1;
		
		fm.cls_amt.value 	= parseDecimal( toInt(parseDigit(fm.cls_s_amt.value)) + toInt(parseDigit(fm.cls_v_amt.value)));		
		
	}
	
	function reg_save(){
		var fm = document.form1;	
		fm.cmd.value= 'i';
		var s_num = '0000' + <%=acc_size+1%>;		
		var s_str = s_num.substring(s_num.length-4);
	    fm.serv_id.value= 'NN' + s_str ;
		fm.action='accid_u_in7.jsp';
		
		fm.target='_self';
		fm.submit();		
	}		
	
	//면책금 담당자 금액 확정
	function dft_sanction() {
		var fm = document.form1;
					
		if ( toInt(parseDigit(fm.cust_amt.value))  == 0 && toInt(parseDigit(fm.ext_amt.value))  == 0 && toInt(parseDigit(fm.cls_amt.value))  == 0 && fm.no_dft_cau.value == '') {
		 	 alert("입력내용을 확인하세요!!");
		 	 return;
		}	
		
		if ( fm.cust_req_dt.value == ''  ) {
			  alert("청구일자를 확인하세요!!");
			  return;
		}
		 	
		if ( fm.cust_plan_dt.value == ''  ) {
			  alert("입금예정일자를 확인하세요!!");
			  return;
		}
		 	
		 						
		if(confirm('면책금 금액을 확정하시겠습니까?')){	
			fm.action='accid_u_sac_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}		
	}
	
	
	//면책금 삭제 --  정비 데이타가 없는 경우에 한해서 
	function accid_dft_del() {
		var fm = document.form1;
		
		
		//종결된건은 삭제불가 
	 if ( '<%=a_bean.getSettle_st()%>' == '1' ) {
	 	 alert("사고 종결건은 삭제 할 수 없습니다.!!");
		 return;
	 
	 } 
					
		if ( toInt(parseDigit(fm.tot_amt.value)) > 0) {
		 	 alert("정비내역이 있는 경우 삭제불가입니다. 면책금 금액 수정으로 처리하세요!!");
		 	 return;
		}	
				 						
		if(confirm('면책금 삭제하시겠습니까?')){  //거래명세서 발행된건이면 거래명세서도 삭제처리 할 것 	
			fm.action='accid_u_del_sac_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}		
	}
	
	
	//견적서인쇄
	function DocPrint(){
		var fm = document.form1;
		//var SUBWIN="/tax/item_mng/doc_serv_print.jsp?item_id=<%=ti.getItem_id()%>&client_id=<%=cont.get("CLIENT_ID")%>&r_site=&auth_rw=<%=auth_rw%>&car_mng_id=<%=c_id%>&accid_id=<%=accid_id%>&serv_id=<%=serv_id%>";	
		var SUBWIN="/tax/item_mng/doc_print.jsp?item_id=<%=ti.getItem_id()%>&client_id=<%=cont.get("CLIENT_ID")%>&r_site=&auth_rw=<%=auth_rw%>";
		var firm_nm = '<%=cont.get("FIRM_NM")%>';
		var sub_rent_gu = '<%=a_bean.getSub_rent_gu()%>';
		if(firm_nm=='(주)아마존카' && sub_rent_gu =='3'){
			SUBWIN="/tax/item_mng/doc_print.jsp?item_id=<%=ti.getItem_id()%>&client_id=<%=cont.get("CLIENT_ID")%>&r_site=&auth_rw=<%=auth_rw%>&car_mng_id=<%=c_id%>&accid_id=<%=accid_id%>";
		}
		window.open(SUBWIN, "DocPrint", "left=50, top=50, width=700, height=600, scrollbars=yes, status=yes");
	}	
	
	//메일재발송
	function reMail(){
		var SUBWIN="/acar/accid_mng/accid_u_in7_mail.jsp?item_id=<%=ti.getItem_id()%>&client_id=<%=cont.get("CLIENT_ID")%>&r_site=&auth_rw=<%=auth_rw%>&from_page=accid_u_in7_mail.jsp";	
		
		window.open(SUBWIN, "TaxItem", "left=50, top=50, width=900, height=600, scrollbars=yes, status=yes");
	}	

	
	function serv_tax(){
	
		if(<%=s_bean.getCust_amt()%>==0){ alert('청구금액이 없습니다. 청구내용을 먼저 수정하십시오.'); 
		    return;		  
		} else {
			var fm = document.form1;		
		 	var SUBWIN="/tax/issue_3/serv_i_item_a.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=m_id%>&rent_l_cd=<%=l_cd%>&car_mng_id=<%=c_id%>&accid_id=<%=accid_id%>&serv_id=<%=serv_id%>&client_id=<%=cont.get("CLIENT_ID")%>&bus_id2="+fm.bus_id2.value+"&item_id="+fm.item_id.value+"&cmd2=i";	
			window.open(SUBWIN, "DocReg", "left=50, top=50, width=700, height=600, scrollbars=yes, status=yes");
	
		}	
	}
	
	function ViewTaxItem(){		
		var taxItemInvoice = window.open("about:blank", "TaxItem", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=1000px, height=800px");
		var fm = document.form1;
		fm.target="TaxItem";
		fm.action = "/tax/issue_1_tax/tax_item_u.jsp";
		fm.submit();			
	}	
	
	
		//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
	
		
  //면책금 등록전 확인인 경우 
	function get_cust_dt(){
		var fm = document.form1;
		
		if( fm.cust_req_dt.value == ""){ alert('청구날짜가 없습니다!!!.'); 
		    return;		  
		} else {		
			fm.target='i_no';
			fm.action='/acar/accid_mng/get_cust_dt_nodisplay.jsp';
			fm.submit();	
		}	
	}	
		
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
<form action="accid_u_a.jsp" name="form1">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='gubun5' value='<%=gubun5%>'>
<input type='hidden' name='gubun6' value='<%=gubun6%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort' value='<%=sort%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='s_st' value='<%=s_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='serv_tax_url' value=''>

    <input type='hidden' name='m_id' value='<%=m_id%>'>
    <input type='hidden' name='l_cd' value='<%=l_cd%>'>
    <input type='hidden' name='c_id' value='<%=c_id%>'>
    <input type='hidden' name='accid_id' value='<%=accid_id%>'>
    <input type='hidden' name='mode' value='<%=mode%>'>
    <input type='hidden' name='serv_id' value='<%=serv_id%>'>  
    <input type='hidden' name='cmd' value='<%=cmd%>'>
    <input type='hidden' name='go_url' value='<%=go_url%>'>  		
    <input type='hidden' name='l_cd2' value='<%=s_bean.getRent_l_cd()%>'> 
	<input type='hidden' name="item_id" value="<%=ti.getItem_id()%>"> 	
  <input type='hidden' name='client_id' value='<%=client_id%>'>
    <input type='hidden' name='off_id' value='<%=s_bean.getOff_id()%>'> 
      <input type='hidden' name='car_st' value='<%=car_st%>'>
      <input type='hidden' name='sac_yn' value='Y'>  
      <input type='hidden' name='biil_re_yn' value=''>  
 
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width="5%">연번</td>
                    <td class=title width="10%">정비일자</td>
                    <td class=title width="25%">정비업체명</td>
                    <td class=title width="10%">정비금액</td>
                    <td class=title width="10%">청구금액</td>
                    <td class=title width="10%">청구일자</td>
                    <td class=title width="10%">입금금액</td>
                    <td class=title width="10%">입금일자</td>
                    <td class=title width="10%">면제여부</td>					
                </tr>
              <%for(int i=0; i<s_r.length; i++){
        			s_bean2 = s_r[i];%>
                <tr id='tr_one_accid' style="display:''"> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(s_bean2.getServ_dt())%></td>
                    <td align="center">
                    <a href="javascript:view_serv_accid('<%=s_bean2.getServ_id()%>');"><%=s_bean2.getOff_nm()%>&nbsp;                  
                   <%if (  s_bean2.getRep_cont().equals("면책금 선청구분") )  {%><%=s_bean2.getRep_cont()%>&nbsp;  <% } %>
                    </a>                   
                   <%if ( s_bean2.getRep_cont().equals("면책금 선청구분") && s_bean2.getOff_id().equals("")  ) { %>
                   <a href="javascript:MM_openBrWindow('reg_serv_off.jsp?br_id=<%=br_id%>&m_id=<%=m_id%>&l_cd=<%=l_cd%>&c_id=<%=c_id%>&accid_id=<%=accid_id%>&serv_id=<%=s_bean2.getServ_id()%>&mode=<%=mode%>','popwin','scrollbars=no,status=no,resizable=no,left=100,top=120,width=500,height=200')"><img src=../images/center/button_in_search1.gif border=0 align=absmiddle></a>
                  
                   <% } %>
                    </td>
                    <td align="right">
                     <% if ( s_bean2.getR_j_amt() > 0) { %>  
					 <%//=AddUtil.parseDecimal(AddUtil.parseFloatTruncZero(String.valueOf((s_bean2.getR_labor()+s_bean2.getR_j_amt())* 1.1)))%><%=AddUtil.parseDecimal(s_bean2.getTot_amt())%>
	                 <% } else { %>   
	                 <%=AddUtil.parseDecimal(s_bean2.getTot_amt())%>
	                 <% } %>
                    원</td> 
                    <td align="right"><%=AddUtil.parseDecimal(s_bean2.getCust_amt())%>원</td>
                    <td align="center"><%=AddUtil.ChangeDate2(s_bean2.getCust_req_dt())%></td>
                    <td align="right"><%=AddUtil.parseDecimal(s_bean2.getExt_amt())%>원</td>
                    <td align="center"><%=AddUtil.ChangeDate2(s_bean2.getCust_pay_dt())%></td>
                    <td align="center"><%if(s_bean2.getNo_dft_yn().equals("Y")){%>면제<%}%></td>						
                </tr>
              <%	}%>
            </table>
        </td>
    </tr>	
       
    <tr> 
        <td>&nbsp;</td>
        <td align="right"> 
       
           <%	 if( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("면책금관리자",user_id)  || a_bean.getSettle_st().equals("0")  ){%> 
          <a href='javascript:reg_save()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_plus.gif" align="absmiddle" border="0"></a>
          <%    } %> 
        </td>
    </tr>
    	
    <tr>
        <td></td>
    </tr>
    
	<tr><td colspan=2 style='background-color:bebebe; height:1;'></td></tr>
	<tr><td><font color=red>※ 면책금 선청구가 반드시 필수는 아닙니다.  사고정비후  면책금청구시 선청구여부를 반드시 확인하시어, 이중청구되지 않도록 유의하세요!!! <br>
	                       	※  면책금입금예정일은 대여료 인출일로 요청하지 않는 경우 청구일+3일 (working day)입니다 . 
	                                       <!--        ※ 이중청구, 계산서 이중발행 등의 문제로 현재 선청구 불가.(문제해결시까지) --> </font></td>
	       <td>&nbsp;</td>
	
	<%if(!cms.getCms_bank().equals("")){%>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동이체</span></td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                  <tr> 
                    <td class=title width=15%>CMS</td>
                    <td>&nbsp;
					  <b>
						<%if(!cms.getCbit().equals("")){%>[<%=cms.getCbit()%>]<%}%>
								</b>
					  <%=cms.getCms_bank()%> <%=cms.getCms_acc_no()%> : <%=AddUtil.ChangeDate2(cms.getCms_start_dt())%> ~ <%=AddUtil.ChangeDate2(cms.getCms_end_dt())%> (매월 <%=cms.getCms_day()%>일)
					  &nbsp;&nbsp;<a href="/fms2/con_fee/acms_list.jsp?acode=<%=l_cd%>" target="_blank"><img src=/acar/images/center/button_in_acms.gif border=0 align=absmiddle></a>
			
					</td>
					
					<td align="center" width=30%>
					<%if(etc_cms.get("ETC_CMS").equals("N")){%>
						※ 면책금 인출 거부
					<%}else{%>
						※ 면책금 인출 허용
					<%}%>
					</td>
					
                  </tr>
            </table>
        </td>
    </tr>	
     <tr>
        <td class=h></td>
    </tr>  
 <%}%>  	
     
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>면책금</span></td>
        <td align="right"> 
      <%	if( s_cnt < 1 || ( s_bean.getSac_yn().equals("") && s_bean.getSac_dt().equals("") )  ){%>
		<a href='javascript:save("i")' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a> 
      <%	}else{ 
      			if( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id) || nm_db.getWorkAuthUser("스케줄변경담당자",user_id) || nm_db.getWorkAuthUser("면책금관리자",user_id) ){%> 
		<a href='javascript:save("u")' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a>
		&nbsp;&nbsp;&nbsp;
		<% if (  s_bean.getTot_amt() == 0 && s_bean.getCust_pay_dt().equals("")   ) {%>
		<a href='javascript:accid_dft_del()' onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_delete.gif" align="absmiddle" border="0"></a>
		 <% }%>
      <%		   }
      		} %>      
      	  
        </td>
    </tr>
   
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
           	  		
                <tr>                 
                    <td class=title>정비일자</td>
                    <td >&nbsp;<%=AddUtil.ChangeDate2(s_bean.getServ_dt())%></td>
                    <td  class=title>정비업체명</td>
                    <td >&nbsp;<%=s_bean.getOff_nm()%></td>
                    <td class=title>청구구분</td>
                    <td >&nbsp;<select name="paid_st">
                    	<option value="" <%if(s_bean.getPaid_st().equals("")){%>selected<%}%>>-선택-</option>
                        <option value="1" <%if(s_bean.getPaid_st().equals("1")){%>selected<%}%>>고객</option>
                        <option value="2" <%if(s_bean.getPaid_st().equals("2")){%>selected<%}%>>기타</option>
                        </select> 
                    </td>
                     <td class=title>수금방법</td>
                    <td >&nbsp;<select name="paid_type">
                        <option value="" <%if(s_bean.getPaid_type().equals("")){%>selected<%}%>>-선택-</option>
                        <option value="1" <%if(s_bean.getPaid_type().equals("1")){%>selected<%}%>>CMS</option>
                        <option value="2" <%if(s_bean.getPaid_type().equals("2")){%>selected<%}%>>무통장</option>
                        </select> 
                    </td>
                    
                    <td class=title >보험가입면책금</td>
                    <td width=14%>&nbsp; <input type="text" name="car_ja" value='<%=AddUtil.parseDecimal(String.valueOf(cont.get("CAR_JA")))%>' size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value);'> 원<br>&nbsp;&nbsp;(공급가)</td>
              
                </tr>      
                <tr>      
                    <td class=title width=9%>청구일자</td>
                    <td width=12%>&nbsp; <input type="text" name="cust_req_dt"  value="<%=AddUtil.ChangeDate2(req_dt)%>" size="12" class=text  onBlur='javscript:this.value = ChangeDate(this.value);'> 
                    </td>  
                    <td class=title width=9%>청구공급가액</td>
                    <td width=11%>&nbsp; <input type="text" name="cust_s_amt" value="<%=AddUtil.parseDecimal(s_bean.getCust_s_amt())%>" size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_cust_amt();'>
                      원</td>
                    <td class=title width=9%>청구부가세액</td>
                    <td width=10%>&nbsp; <input type="text" name="cust_v_amt" value="<%=AddUtil.parseDecimal(s_bean.getCust_v_amt())%>" size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_cust_amt();'>
                      원</td>
                    <td class=title width=9%>청구금액</td>
                    <td width=11%>&nbsp; <input type="text" name="cust_amt"  readonly value="<%=AddUtil.parseDecimal(s_bean.getCust_amt())%>"" size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                     <td class=title width=9%>입금예정일</td>
                    <td width=14%>&nbsp;                     
                    <input type="text"  name="cust_plan_dt" <% if( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("면책금관리자",user_id) ){%> <% } else { %> readonly <%} %>  value="<%=AddUtil.ChangeDate2(s_bean.getCust_plan_dt())%>" size="12" class=text  onBlur='javscript:this.value = ChangeDate(this.value);'>
                    <% if( s_bean.getCust_plan_dt().equals("")  ) { %>
                    <a href='javascript:get_cust_dt()' onMouseOver="window.status=''; return true" onFocus="this.blur()">[예정일확인]</a>                                
                    <br>&nbsp;&nbsp;<input type='checkbox' name='fee_r_yn' value="Y" >&nbsp;대여료인출일에 출금요청 
                    <% } %> 
                    
                    </td>
               </tr>
               
               <!-- 고객입금액은 담당자 수정못함 --20131017 -->
               <tr>                    
                    <td class=title>고객입금액</td>
                    <td width=12%>&nbsp; <input type="text" name="ext_amt"   <% if( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("면책금관리자",user_id) ){%> <% } else { %> readonly <%} %>  value="<%=AddUtil.parseDecimal(s_bean.getExt_amt())%>"  size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                     원</td>
                    <td class=title>고객입금내역</td>
                    <td colspan=5 >&nbsp; <input type="text" name="ext_cau"   value="<%=s_bean.getExt_cau()%>"  size="80" class=text ></td>                  
                    <td class=title width=9%>입금일</td>
                    <td >&nbsp; <input type="text"  readonly name="cust_pay_dt" value='<%=AddUtil.ChangeDate2(s_bean.getCust_pay_dt())%>' size="12" class=text ></td>                
                </tr>
                
                <!-- serv_st :12 인 경우 담당자가 해지정산금액 입력 가능토록 수정 - 20130726 -->
                <tr>
                    <td class=title>해지정산시<br>공급가액</td>
                    <td >&nbsp; <input type="text" name="cls_s_amt" 
                    <% if(   nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("월렌트관리",user_id) || nm_db.getWorkAuthUser("면책금관리자",user_id)  ){%> <% } else {   if  ( !s_bean.getServ_st().equals("12")    )  { %> readonly
                            <% } }%>   value="<%=AddUtil.parseDecimal(s_bean.getCls_s_amt())%>"  size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                      원</td>  
                    <td class=title>해지정산시<br>부가세액</td>
                    <td >&nbsp; <input type="text" name="cls_v_amt"
                     <% if(   nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("월렌트관리",user_id) || nm_db.getWorkAuthUser("면책금관리자",user_id)   ){%> <% } else {   if  ( !s_bean.getServ_st().equals("12")    )  { %> readonly
                           <% } } %>  value="<%=AddUtil.parseDecimal(s_bean.getCls_v_amt())%>"  size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt();'>
                      원</td>  
                    <td class=title>해지정산시<br>금액</td>
                    <td >&nbsp; <input type="text" name="cls_amt" readonly  value="<%=AddUtil.parseDecimal(s_bean.getCls_amt())%>"  size="9" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td> 
                    <td class=title>비용담당자</td>   
                    <td colspan=3>&nbsp;<select name='bus_id2'>
                        <option value="">미지정</option>
                        <%	if(user_size > 0){
        						for (int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(bus_id2.equals(user.get("USER_ID"))){ out.println("selected");}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
                      </select>
                    </td>   
                      
                </tr>
                <tr> 
                    <td class=title>면제여부</td>
                    <td>&nbsp;   <input type="hidden" name="tot_amt" value="<%=s_bean.getTot_amt()%>" >
                    <% if( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("면책금관리자",user_id) ){%> 
                     <input type='checkbox' name='no_dft_yn' <% if( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("면책금관리자",user_id) ){%> <% } else { %> readonly <%} %> value="Y" <%if(s_bean.getNo_dft_yn().equals("Y")){%> checked<%}%>> 
                     <% } else { %>
                    <input type="checkbox" name="no_dft_yn" value="Y"  onclick="return false;">
                    <% } %>                
                    </td>
                    <td class=title>면제사유</td>
                    <td colspan="7">&nbsp; <input type="text" name="no_dft_cau"   <% if( nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("면책금관리자",user_id) ){%> <% } else { %> readonly <%} %>  value="<%=s_bean.getNo_dft_cau()%>" size="100" class=text> 
                    </td>                 
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>명세서</span></td>
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                  <tr>   <!--bill_doc : 3, 4: 거래명세서발행으로 사용 -->
                    <td class=title width=12%>거래명세서발행요청구분</td>
                    <td width=35%>&nbsp;<select name="bill_doc_yn">
                        <option value="">선택</option>
                        <option value="3" <%if(s_bean.getBill_doc_yn().equals("3")){%>selected<%}%>>미발행</option>
                        <option value="4" <%if(s_bean.getBill_doc_yn().equals("4")){%>selected<%}%>>발행</option> 
                    </select> 
                           
                         <% if(ti.getCar_mng_id().equals("")){%>	
                         	 <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
								<a href="javascript:serv_tax()"><img src="/acar/images/center/button_cgsbh.gif" align="absmiddle" border="0"></a>
							<%}%>
								(부가세가 없는 거래명세서가 발행됩니다.)
						<%} %>
                                  
                      </td>                 
                    <td class=title width=12%>입금표발행요청구분</td>
                    <td width=35%>&nbsp;<select name="saleebill_yn">
                       <option value="">선택</option>
                        <option value="0" <%if(s_bean.getSaleebill_yn().equals("0")){%>selected<%}%>>미발행</option>
                        <option value="1" <%if(s_bean.getSaleebill_yn().equals("1")){%>selected<%}%>>발행</option> 
                        </select> 
                        &nbsp;&nbsp;메일주소: <input type='text' size='40' name='agnt_email' value='<%=s_bean.getAgnt_email()%>'  maxlength='30' class='text' style='IME-MODE: inactive'>                         
                      </td>
                    
                  </tr>
            </table>
        </td>
    </tr>  
    <tr>
        <td colspan="2" align="right"><font color=red>※ 입금표발행요청시 메일주소가 없는 경우 계산서 수신메일로 발행됩니다.!!!</font></td>          					  
    </tr>
  <%  if(!ti.getCar_mng_id().equals("")){%>		
    <tr> 
        <td colspan="2" align="right">
        <a href="javascript:reMail()"><img src="/acar/images/center/button_email_re_send.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
        <a href="javascript:DocPrint()"><img src="/acar/images/center/button_print_cgs.gif" align="absmiddle" border="0"></a>
		<%if(t_bean.getTax_no().equals("") && (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("스케줄변경담당자",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id) || user_id.equals(bus_id2))){%>	  
	  	<!--&nbsp;&nbsp;<a href="javascript:ViewTaxItem()" title='거래명세서수정'><img src=/acar/images/center/button_modify_bill.gif align=absmiddle border=0></a>&nbsp;&nbsp;-->
	  	<%}%>
	</td>
    </tr>	
<% } %>		  

  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</iframe>
</body>
</html>
