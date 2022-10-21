<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.settle_acc.*, tax.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소	
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "03", "11");
	
	int count = 0;
%>

<html>
<head><title>FMS</title>
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
		window.open("about:blank",'search_open','scrollbars=yes,status=yes,resizable=yes,width=800,height=500,left=50,top=50');		
		fm.action = "../pop_search/s_cont.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&t_wd="+fm.gov_nm.value;
		fm.target = "search_open";
		fm.submit();		
	}
	
	//등록
	function doc_reg(){
		var fm = document.form1;
				
		var sh_fm = parent.c_body.document.form1;		
		
		fm.doc_id.value 	= sh_fm.doc_id.value;
		fm.doc_dt.value 	= sh_fm.doc_dt.value;
		fm.gov_id.value 	= sh_fm.gov_id.value;
		fm.gov_nm.value 	= sh_fm.gov_nm.value;	
		fm.gov_zip.value 	= sh_fm.t_zip.value;	
		fm.gov_addr.value 	= sh_fm.t_addr.value;		
		fm.mng_dept.value 	= sh_fm.mng_dept.value;
		fm.mng_nm.value 	= sh_fm.mng_nm.value;
		fm.mng_pos.value 	= sh_fm.mng_pos.value;
		fm.app_docs.value 	= sh_fm.app_docs.value;
		fm.h_mng_id.value 	= sh_fm.h_mng_id.value;
		fm.b_mng_id.value 	= sh_fm.b_mng_id.value;
		fm.ins_com.value 	= sh_fm.ins_com.value;
		
		
		if(fm.doc_id.value == '')		{ alert('문서번호를 입력하십시오.'); 	return; }
		if(fm.doc_dt.value == '')		{ alert('시행일자를 입력하십시오.'); 	return; }		
		if(fm.gov_id.value == '')		{ alert('수신기관을 선택하십시오.'); 	return; }		
		if(fm.gov_nm.value == '')		{ alert('수신기관을 선택하십시오.'); 	return; }
		if(fm.gov_zip.value == '')		{ alert('우편번호을 선택하십시오.'); 	return; }
		if(fm.gov_addr.value == '')		{ alert('주소를 선택하십시오.'); 		return; }
				
		if(fm.size.value == '0')		{ alert('휴/대차료를 조회 하십시오.'); 	return; }
				
		if(!confirm('등록하시겠습니까?')){	return;	}		
		fm.action = "accid_mydoc_reg_sc_a.jsp";
		fm.target = "i_no";
		fm.submit();
		
	}
		
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}

//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' method='post' >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='doc_id' value=''>
<input type='hidden' name='doc_dt' value=''>
<input type='hidden' name='gov_id' value=''>
<input type='hidden' name='gov_nm' value=''>
<input type='hidden' name='mng_dept' value=''>
<input type='hidden' name='title' value=''>
<input type='hidden' name='gov_zip' value=''>
<input type='hidden' name='gov_addr' value=''>
<input type='hidden' name='end_dt' value=''>
<input type='hidden' name='mng_nm' value=''>
<input type='hidden' name='mng_pos' value=''>
<input type='hidden' name='h_mng_id' value=''>
<input type='hidden' name='b_mng_id' value=''>
<input type="hidden" name="app_docs" value="">  
<input type='hidden' name='ins_com' value=''>

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>  

    <tr>
      <td class='line'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td width="5%" rowspan="2" class='title' >연번</td>
            <td width="10%" rowspan="2" class='title'>사고접수번호</td>
            <td colspan="2" class='title'>대차이용자</td>
            <td width="10%" rowspan="2" class='title'>차량번호</td>
            <td width="11%" rowspan="2" class='title'>차명</td>			
            <td colspan="3" class='title'>대차기간</td>						
            <td width="10%" rowspan="2" class='title'>대차료청구금액</td>
            <td width="10%" rowspan="2" class='title'>청구서</td>			
          </tr>
          <tr>
            <td width="10%" class='title'>성명</td>
            <td width="10%" class='title'>사업자/생년월일</td>
            <td width="8%" class='title'>개시일시</td>
            <td width="8%" class='title'>종료일시</td>
            <td width="8%" class='title'>적산일시</td>
          </tr>

<% 	
	//선택리스트	
	String vid[] = request.getParameterValues("cho_id");
	String vid_num="";
	String ch_a_id="";
	String ch_seq="";
	String ch_c_id="";
	String ch_gov_id="";
	
	for(int i=0; i<vid.length;i++){
		
		String value[] = new String[4];
		StringTokenizer st = new StringTokenizer(vid[i],"^");
		int s=0; 
		while(st.hasMoreTokens()){
			value[s] = st.nextToken();
			s++;
		}
		
		ch_a_id 	= value[0];
		ch_seq		= value[1];
		ch_c_id		= value[2];
		ch_gov_id	= value[3];
		
		Hashtable loan = s_db.getInsurHReqDocInfo(ch_c_id, ch_a_id, AddUtil.parseInt(ch_seq)); 
		
		//청구서발행 조회
		TaxItemListBean ti = IssueDb.getTaxItemListMyAccid(ch_c_id, ch_a_id, ch_seq, AddUtil.parseInt(String.valueOf(loan.get("REQ_AMT"))));
%>		  	
          <tr> 
		   <td align=center><%=i+1%></td>
                <input type='hidden' name='car_mng_id' value='<%=ch_c_id%>'>
        		<input type='hidden' name='accid_id' value='<%=ch_a_id%>'>
        		<input type='hidden' name='seq_no' value='<%=ch_seq%>'>	    		
    	 		<input type='hidden' name='rent_mng_id' value='<%=loan.get("RENT_MNG_ID")%>'>	
    	 		<input type='hidden' name='rent_l_cd' value='<%=loan.get("RENT_L_CD")%>'>
				<input type='hidden' name='rent_s_cd' value='<%=loan.get("RENT_S_CD")%>'>
    	 		<input type='hidden' name='firm_nm' value='<%=loan.get("FIRM_NM")%>'>
				<input type='hidden' name='enp_no' value='<%=loan.get("ENP_NO")%>'>
				<input type='hidden' name='ssn' value='<%=loan.get("SSN")%>'>
				<input type='hidden' name='rent_start_dt' value='<%=loan.get("USE_ST")%>'>
				<input type='hidden' name='rent_end_dt' value='<%=loan.get("USE_ET")%>'>
				<input type='hidden' name='use_day' value='<%=loan.get("USE_DAY")%>일<%=loan.get("USE_HOUR")%>시간'>
    	 		<input type='hidden' name='car_no' value='<%=loan.get("CAR_NO")%>'>
				<input type='hidden' name='car_nm' value='<%=loan.get("CAR_NM")%>'>
    	 		<input type='hidden' name='req_amt' value='<%=loan.get("REQ_AMT")%>'>
        		<input type='hidden' name='pay_amt' value='<%=loan.get("PAY_AMT")%>'>
        		<input type='hidden' name='jan_amt' value='<%=loan.get("JAN_AMT")%>'>			
				<input type='hidden' name='o_ins_num' value='<%=loan.get("INS_NUM")%>'>
				<input type='hidden' name='item_id' value='<%=ti.getItem_id()%>'>
				
    	 		
	        <td align=center><input name="ins_num" type="text" class=text id="ins_num" value="<%=loan.get("INS_NUM")%>" size="12" maxlength="50" ></td>
	        <td align=center><%=loan.get("FIRM_NM")%></td>
	        <td align=center><%=AddUtil.ChangeEnp(String.valueOf(loan.get("ENP_NO")))%><%if(String.valueOf(loan.get("ENP_NO")).equals("")){%><%=AddUtil.ChangeEnp(String.valueOf(loan.get("SSN")))%><%}%></td>			
	        <td align=center><%=loan.get("CAR_NO")%></td>
	        <td align=center><%=loan.get("CAR_NM")%></td>
	        <td align=center><%=loan.get("USE_ST")%></td>
	        <td align=center><%=loan.get("USE_ET")%></td>
	        <td align=center><%=loan.get("USE_DAY")%>일<%=loan.get("USE_HOUR")%>시간</td>
	        <td align=right><%=Util.parseDecimal(String.valueOf(loan.get("REQ_AMT")))%>원</td>
	        <td align=center>
			<%if(ti.getCar_mng_id().equals("")){%>
					<select name="item_yn">
                        <option value="Y">발행한다</option>
						<option value="N">발행안한다</option>
					</select>
			<%}else{%>
			<%=ti.getItem_id()%><input type='hidden' name='item_yn' value=''>
			<%}%>

                      </td>
          </tr>
		<%		count++;
	}%>		
		    <input type='hidden' name='size' value='<%=count%>'>  
        </table>
	  </td>
    </tr>	
    <tr>
        <td></td>
    </tr>

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
