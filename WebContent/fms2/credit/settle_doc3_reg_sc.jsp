<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.settle_acc.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소	
	
	int count = 0;
	
	int amt3 = 0;
	int amt5 = 0;
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
		window.open("about:blank",'search_open','scrollbars=yes,status=no,resizable=yes,width=800,height=500,left=50,top=50');		
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
		fm.gov_zip.value 	= sh_fm.gov_zip.value;	
		fm.gov_addr.value 	= sh_fm.gov_addr.value;		
		fm.mng_dept.value 	= sh_fm.mng_dept.value;
		fm.title.value 		= sh_fm.title.value;
		fm.end_dt.value 	= sh_fm.end_dt.value;	
		
		
		if(fm.doc_id.value == '')		{ alert('문서번호를 입력하십시오.'); 	return; }
		if(fm.doc_dt.value == '')		{ alert('시행일자를 입력하십시오.'); 	return; }		
		if(fm.gov_id.value == '')		{ alert('수신기관을 선택하십시오.'); 	return; }		
		if(fm.gov_nm.value == '')		{ alert('수신기관을 선택하십시오.'); 	return; }
		if(fm.gov_zip.value == '')		{ alert('우편번호을 선택하십시오.'); 		return; }
		if(fm.gov_addr.value == '')		{ alert('주소를 선택하십시오.'); 		return; }
		if(fm.title.value == '')		{ alert('제목을 선택하십시오.'); 		return; }
		if(fm.end_dt.value == '')		{ alert('유예기간을 입력하십시오.'); 		return; }
			
		if(fm.size.value == '0')		{ alert('휴/대차료를 조회 하십시오.'); return; }
				
		if(!confirm('등록하시겠습니까?')){	return;	}		
		fm.action = "settle_doc3_reg_sc_a.jsp";
		fm.target = "i_no";
		fm.submit()
		
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

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>  

    <tr>
      <td class='line'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width="4%" >연번</td>
            <td class='title' width="10%">차량번호</td>
            <td class='title' width="10%">보험사</td>
            <td class='title' width="6%">사고구분</td>
            <td class='title' width="8%">사고일자</td>			
            <td class='title' width="8%">청구일자</td>						
            <td class='title' width="8%">청구액</td>									
            <td class='title' width="8%">입금일자</td>												
            <td class='title' width="8%">입금액</td>
            <td class='title' width="8%">차액</td>
            <td class='title' width="8%">연체이자</td>
            <td class='title' width="6%">연체일수</td>
            <td class='title' width="8%">총미납금액</td>
          </tr>

<% 	
	//선택리스트	
	String vid[] = request.getParameterValues("cho_id");
	String vid_num="";
	String ch_a_id="";
	String ch_seq="";
	String ch_c_id="";
	String ch_gov_id="";	
	
	int seq_no = 0;		
	
	for(int i=0; i<vid.length;i++){
		vid_num=vid[i];
		
		StringTokenizer token1 = new StringTokenizer(vid_num,"^");
				
		while(token1.hasMoreTokens()) {
				
				ch_a_id = token1.nextToken().trim();	 
				ch_seq = token1.nextToken().trim();	 
				ch_c_id = token1.nextToken().trim();	 
				ch_gov_id = token1.nextToken().trim();	 
											
		}		
			
		seq_no = AddUtil.parseInt(ch_seq);
			
		Hashtable loan = s_db.getInsurHInfo(ch_c_id, ch_a_id, seq_no); 
	   
    	amt3 = AddUtil.parseInt(String.valueOf(loan.get("REQ_AMT")))- AddUtil.parseInt(String.valueOf(loan.get("PAY_AMT"))) ;
    	amt5 = AddUtil.parseInt(String.valueOf(loan.get("REQ_AMT")))- AddUtil.parseInt(String.valueOf(loan.get("PAY_AMT")))+ AddUtil.parseInt(String.valueOf(loan.get("DLY_AMT"))) ;
				
%>		  	
          <tr> 
		   <td align=center><%=i+1%></td>
                <input type='hidden' name='car_mng_id' value='<%=ch_c_id%>'>
        		<input type='hidden' name='accid_id' value='<%=ch_a_id%>'>
        		<input type='hidden' name='seq_no' value='<%=ch_seq%>'>	    		
    	 		<input type='hidden' name='rent_mng_id' value='<%=loan.get("RENT_MNG_ID")%>'>	
    	 		<input type='hidden' name='rent_l_cd' value='<%=loan.get("RENT_L_CD")%>'>
    	 		<input type='hidden' name='firm_nm' value='<%=loan.get("FIRM_NM")%>'>
    	 		<input type='hidden' name='req_dt' value='<%=loan.get("REQ_DT")%>'>
    	 		<input type='hidden' name='pay_dt' value='<%=loan.get("PAY_DT")%>'>
    	 		<input type='hidden' name='req_amt' value='<%=loan.get("REQ_AMT")%>'>
        		<input type='hidden' name='pay_amt' value='<%=loan.get("PAY_AMT")%>'>
        		<input type='hidden' name='amt3' value='<%=amt3%>'>
        		<input type='hidden' name='amt4' value='<%=loan.get("DLY_AMT")%>'>
        		<input type='hidden' name='dly_days' value='<%=loan.get("DLY_DAYS")%>'>
        		<input type='hidden' name='amt5' value='<%=amt5%>'>
    	 		
	        <td align=center><%=loan.get("CAR_NO")%></td>
	        <td align=center><%=loan.get("INS_COM")%></td>
	        <td align=center><%=loan.get("ACCID_ST")%></td>
	        <td align=center><%=loan.get("ACCID_DT")%></td>
	        <td align=center><%=loan.get("REQ_DT")%></td>
	        <td align=right><%=Util.parseDecimal(String.valueOf(loan.get("REQ_AMT")))%></td>
	        <td align=center><%=loan.get("PAY_DT")%></td>
	        <td align=right><%=Util.parseDecimal(String.valueOf(loan.get("PAY_AMT")))%></td>
	        <td align=right><%=Util.parseDecimal(amt3)%></td>
	        <td align=right><%=Util.parseDecimal(String.valueOf(loan.get("DLY_AMT")))%></td>
	        <td align=center><%=loan.get("DLY_DAYS")%></td>
	        <td align=right><%=Util.parseDecimal(amt5)%></td>
	     
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
