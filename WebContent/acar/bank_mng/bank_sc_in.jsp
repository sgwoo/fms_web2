<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.bank_mng.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	Vector bank_lends = abl_db.getBankLendList2(bank_id, gubun1, gubun);
	int bl_size = bank_lends.size();
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	var popObj = null;
	
	//팝업윈도우 열기
	function ScanOpen(theURL,file_type) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
		if(file_type == ''){
			theURL = "https://fms3.amazoncar.co.kr/data/bank/"+theURL+".pdf";
		}else{			
			theURL = "https://fms3.amazoncar.co.kr/data/bank/"+theURL+""+file_type;		
		}
		if(file_type == '.jpg'){
			theURL = '/fms2/lc_rent/img_scan_view.jsp?img_url='+theURL;
			popObj =window.open('','popwin_in1','scrollbars=yes,status=yes,resizable=yes,width=<%=(2100*0.378)+50%>,height=<%=s_height%>,left=0, top=0');
		}else{
			popObj = window.open('','popwin_in1','scrollbars=no,status=yes,resizable=yes,width=820,height=600,left=50, top=50');
		}					
		popObj.location = theURL;
		popObj.focus();	
	}		
	
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	function init() {		
		setupEvents();
	}	
	
	//스케줄 가기
	function scd_view(idx, lend_id, cont_term){
		fm = document.form1;
		fm.lend_id.value = lend_id;
		fm.cont_term.value = cont_term;		
		
		<% if ( bl_size  <2  ) {%>  
			 fm.scd_yn_r.value = fm.scd_yn.value;
			 fm.rtn_seq_r.value = fm.s_rtn.value;		
		<% }else{ %>  
			fm.scd_yn_r.value = fm.scd_yn[idx].value;
			fm.rtn_seq_r.value = fm.s_rtn[idx].value;		
		<% } %>  
		
		if(fm.scd_yn_r.value == null || fm.scd_yn_r.value == ''){
			fm.action = 'bank_scd_i.jsp';
		}else{//등록
			fm.action = 'bank_scd_u.jsp';
		}
		
		
		fm.target = 'd_content';
		fm.submit();
	}	
	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<body onLoad="javascript:init()">

<form name="form1" method="post" action="">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type='hidden' name='lend_id' value=''>
<input type='hidden' name='rtn_seq' value=''>
<input type='hidden' name='cont_term' value=''>
<input type='hidden' name='scd_yn_r' value=''>
<input type='hidden' name='rtn_seq_r' value=''>
<input type='hidden' name='bank_id' value='<%=bank_id%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<table border="0" cellspacing="0" cellpadding="0" width='1400'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='570' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width=40 class=title >연번</td>	
                    <td width=60 class=title>계약번호</td>
                    <td width=80 class=title>계약일</td>
                    <td width=130 class=title>금융사</td>
                    <td width=60 class=title>계약구분</td>
                    <td width=60 class=title>진행여부</td>					
                    <td width=80 class=title>지점명</td>
                    <td width=60 class=title>담당자</td>
                </tr>
            </table>
        </td>
	<td class='line' width='830'>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=120 class=title>약정금액</td>
                    <td width=120 class=title>대출금액</td>
                    <td width=120 class=title>약정잔액</td>
                    <td width=60 class=title>대출이율</td>
                    <td width=80 class=title>상환개시일</td>
                    <td width=60 class=title>상환기간</td>
                    <td width=120 class=title>상환구분</td>
                    <td width=70 class=title>스케줄</td>
                    <td width=80 class=title>자금관리</td>
                </tr>
            </table>
	</td>
    </tr>
    <%	if(bl_size > 0){%>
    <tr>
	<td class='line' width='570' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <%for(int i = 0 ; i < bl_size ; i++){
			Hashtable bank_lend = (Hashtable)bank_lends.elementAt(i);
		%>
                <tr> 
                    <td width=40 align="center"><%= i+1%></td>
                    <td width=60  align='center'><a href="javascript:parent.view_bank_lend('<%=bank_lend.get("LEND_ID")%>')" onMouseOver="window.status=''; return true"><%=bank_lend.get("LEND_ID")%></a></td>
                    <td width=80  align='center'><%=bank_lend.get("CONT_DT")%></td>
                    <td width=130 align='center'><%=Util.subData(String.valueOf(bank_lend.get("BANK_NM")), 7)%>
			<%if(!String.valueOf(bank_lend.get("ATTACH_SEQ")).equals("") && !String.valueOf(bank_lend.get("ATTACH_SEQ")).equals("null")){%>
			<a href="javascript:openPopP('<%=bank_lend.get("ATTACH_TYPE")%>','<%=bank_lend.get("ATTACH_SEQ")%>');" title='보기' ><img src=/acar/images/center/icon_memo.gif align=absmiddle border="0"></a>
			<%}%>
			<%if(!String.valueOf(bank_lend.get("SCD_REST_AMT")).equals("0")){%>
			<span style="font-size : 6pt;"><font color='Fuchsia'>(잔)</font></span>
			<%}%>
		    </td>
                    <td width=60 align='center'><%=bank_lend.get("CONT_ST")%></td>
		    <td width=60 align='center'><%=bank_lend.get("MOVE_ST")%></td>
                    <td width=80 align='center'><span title='<%=bank_lend.get("BN_BR")%>'><%=Util.subData(String.valueOf(bank_lend.get("BN_BR")), 5)%></span></td>
                    <td width=60  align='center'><%=bank_lend.get("BA_NM")%></td>
                </tr>
                <%}%>
            </table>
		</td>
		<td class='line' width='830'>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
        <%for(int i = 0 ; i < bl_size ; i++){
			Hashtable bank_lend = (Hashtable)bank_lends.elementAt(i);
			String rtn_su = String.valueOf(bank_lend.get("RTN_SU"));
			String rtn_st = String.valueOf(bank_lend.get("RTN_ST"));
			String scd_yn = String.valueOf(bank_lend.get("SCD_YN"));
			String rtn_change = String.valueOf(bank_lend.get("RTN_CHANGE"));%>			
                <tr> 
                  <td width=120 align='right'>
        		  <%if(String.valueOf(bank_lend.get("CONT_BN")).equals("0016") && String.valueOf(bank_lend.get("CONT_AMT")).equals("0")){%>
        			<%=Util.parseDecimalLong(String.valueOf(bank_lend.get("PM_REST_AMT")))%>
        		  <%}else{%>
        		  	<%=Util.parseDecimalLong(String.valueOf(bank_lend.get("CONT_AMT")))%>
        		  <%}%>					  
        		  </td>
                  <td width=120 align='right'><%=Util.parseDecimalLong(String.valueOf(bank_lend.get("PM_REST_AMT")))%></td>
                  <td width=120 align='right'>
        		  <%if(String.valueOf(bank_lend.get("CONT_BN")).equals("0016") && String.valueOf(bank_lend.get("CONT_AMT")).equals("0")){%>		  
        			0
        		  <%}else{%>
        		  	<%if(rtn_change.equals("1")){%><%=Util.parseDecimalLong(String.valueOf(bank_lend.get("ALT_PAY_AMT")))%><%}else{%><%=Util.parseDecimalLong(String.valueOf(bank_lend.get("CHARGE_AMT")))%><%}%>
        		  <%}%>		
        		  </td>
                  <td width=60 align='right'><%=bank_lend.get("LEND_INT")%>%</td>
                  <td width=80 align='center'><%=bank_lend.get("CONT_START_DT")%></td>
                  <td width=60 align='right'><%=bank_lend.get("CONT_TERM")%>개월</td>
                  <td width=60 align='center'><%=bank_lend.get("RTN_ST")%></td>
                  <td width=60 align='center'>
                  <!--
        		  	<%if(!rtn_st.equals("전체") && Integer.parseInt(rtn_su) > 0){%>        		  	
                      <select name="s_rtn">
        			  	<%for(int j=0; j<Integer.parseInt(rtn_su) ; j++){%>
                        <option value="<%=j+1%>"><%=j+1%>차</option>
        				<%}%>
                      </select>
        			<%}else{%><input type='hidden' name='s_rtn' value=''><%}%>
        			-->
        			<input type='hidden' name='s_rtn' value=<%if(!rtn_st.equals("전체") && Integer.parseInt(rtn_su) > 0){%>'1'<%}else{%>''<%}%>>
        			<input type='hidden' name='scd_yn' value='<%=scd_yn%>'>
        			<input type='hidden' name='rtn_su' value='<%=rtn_su%>'>
                  </td>
                  <td align='center' width=70> 
                    <%if(!rtn_st.equals("전체")){%>
                    <a href="javascript:scd_view('<%=i%>','<%=bank_lend.get("LEND_ID")%>','<%=bank_lend.get("CONT_TERM")%>');"><!--<img src=../images/center/button_in_sch.gif align=absmiddle border=0>-->[스케줄]</a>
        			<%}else{%>-<%}%>
                  </td>
                  <td width=80 align='center'><%=bank_lend.get("FUND_NO")%></td>
                </tr>
            <%}%>
            </table>
		</td>
<%	}else{%>                     
	<tr>
		<td class='line' width='570' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		<td class='line' width='820'>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%  }%>
</table>
</form>
</body>
</html>
