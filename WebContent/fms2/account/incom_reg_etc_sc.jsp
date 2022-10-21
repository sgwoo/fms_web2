<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
					
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");	
		
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "12", "01");
	
	int count = 0;

	String ven_name = "";
	
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
	
	//등록하기
	function doc_reg(){	
		var fm = document.form1;
		var sh_fm = parent.c_body.document.form1;		
		
		fm.n_ven_code.value 	= sh_fm.n_ven_code.value;
		fm.n_ven_name.value 	= sh_fm.n_ven_name.value;
		fm.ip_acct.value 	= sh_fm.ip_acct.value;	
		if ( sh_fm.acct_gubun[0].checked == true ) { 	fm.acct_gubun.value 	 = 'C';}
		if ( sh_fm.acct_gubun[1].checked == true ) { 	fm.acct_gubun.value 	 = 'D';}					
	
		fm.remark.value 	= sh_fm.remark.value;
		
		if(fm.n_ven_code.value == '') { alert('거래처를 확인하십시오.'); return; }
		if(fm.ip_acct.value == '') { alert('계정과목을 확인하십시오.'); return; }
		if(fm.acct_gubun.value == '') { alert('차/대변을 확인하십시오.'); return; }
	
		if(fm.size.value == '0')		{ alert('입금내역을 조회 하십시오.'); return; }

		if(!confirm('등록하시겠습니까?')){	return;	}
		fm.action = "incom_reg_etc_sc_a.jsp";
		fm.target = "i_no";
		fm.submit()
	}	
//-->
</script>

</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='incom_dt' value=''>
<input type='hidden' name='n_ven_code'   >
<input type='hidden' name='n_ven_name'   >
<input type='hidden' name='ip_acct'   >
<input type='hidden' name='acct_gubun'   >
<input type='hidden' name='remark'   >
 <input type="hidden" name="ip_method" value="1">  
 <input type="hidden" name="incom_gubun" value="1">  

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>  
                     <td class=title width=4%>연번</td>                                
                    <td class=title width=16%>은행코드</td>
                    <td class=title width=20%>계좌번호</td>
                    <td class=title width=10%>거래일</td>
                    <td class=title width=4%>순번</td>  
                    <td class=title width=30%>거래내역</td>   
                    <td class=title width=10%>입금액</td>   
                    <td class=title width=6%>적용</td>   
                </tr>
<% 	
	//선택리스트
	
	String vid[] = request.getParameterValues("pr");
	
	String vid_num="";
	String ch_acct_seq="";
	String ch_tr_date="";
	String ch_tr_date_seq="";
	String ch_naeyoung="";
	String ch_bank_nm="";
	String ch_bank_no="";
	String ch_ip_amt="";
	
	String ch_etc1="";
	String ch_etc2="";

	int tot_incom_amt = 0;
   int ch_bank_amt = 0;
   				
	for(int i=0; i<vid.length;i++){
		vid_num=vid[i];
			
		StringTokenizer token1 = new StringTokenizer(vid_num,"^");
				
		while(token1.hasMoreTokens()) {				
				ch_acct_seq = token1.nextToken().trim();	 
				ch_tr_date= token1.nextToken().trim();	 
				ch_tr_date_seq = token1.nextToken().trim();	 
				ch_naeyoung = token1.nextToken().trim();	 		
				ch_bank_nm = token1.nextToken().trim();	 		
			   ch_bank_no = token1.nextToken().trim();	 		
				ch_ip_amt = token1.nextToken().trim();	 	
				ch_etc1 = token1.nextToken().trim();	 	
				ch_etc2 = token1.nextToken().trim();	 	
				
				ch_bank_amt = AddUtil.parseInt(ch_ip_amt);											
							
		}

	    tot_incom_amt += ch_bank_amt;
%>		  
 		        <tr align="center"> 
                    <td><%=i+1%></td>                    
                		<input type='hidden' name='acct_seq' value='<%=ch_acct_seq%>'>
		        			<input type='hidden' name='tr_date' value='<%=ch_tr_date%>'>
		        			<input type='hidden' name='tr_date_seq' value='<%=ch_tr_date_seq%>'>			
		        			<input type='hidden' name='naeyoung' value='<%=ch_naeyoung%>'>
		        			<input type='hidden' name='bank_nm'  value='<%=ch_bank_nm%>'>
		        			<input type='hidden' name='bank_no' value='<%=ch_bank_no%>'>
		        			<input type='hidden' name='ip_amt'  value='<%=ch_ip_amt%>'>		        			
                
                    <td><%=ch_bank_nm%></td>
                    <td><%=ch_bank_no%></td>
                    <td><%=ch_tr_date%></td>
                    <td><%=ch_tr_date_seq%></td>          
                    <td><%=ch_naeyoung%></td>          
                    <td align=right><%=Util.parseDecimal(ch_bank_amt)%></td>
                    <td align=right></td>
                </tr>

<%		
       count++;
	}%>		
		    <input type='hidden' name='size' value='<%=count%>'>  
				<tr>
					<td colspan="6" class='title'>합계</td>
					<td align=right>
					<%=Util.parseDecimal(tot_incom_amt)%></td>
					 <td></td>
				</tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align="right">&nbsp;</td>
    </tr>
    <tr>
        <td align="right">
	    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	    <a href='javascript:doc_reg()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>
	    <%}%>
	    </td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
