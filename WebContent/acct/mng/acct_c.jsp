<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.common.*, acct.* "%>
<jsp:useBean id="at_db" scope="page" class="acct.AcctDatabase"/>
<%@ include file="/acct/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  	==null?"":request.getParameter("br_id");
	
	String save_dt 	= request.getParameter("save_dt")	==null?"":request.getParameter("save_dt");
	String acct_st 	= request.getParameter("acct_st")	==null?"":request.getParameter("acct_st");	
	String s_dt 	= request.getParameter("s_dt")		==null?"":request.getParameter("s_dt");
	String e_dt 	= request.getParameter("e_dt")		==null?"":request.getParameter("e_dt");	
	String seq 	= request.getParameter("seq")		==null?"":request.getParameter("seq");	
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	Hashtable ht = at_db.getStatAcctCase(save_dt, acct_st, s_dt, e_dt, seq);
	
	int value_size = AddUtil.parseInt(String.valueOf(ht.get("VALUE_SIZE")));

	String acc_st_nm = (String)ht.get("ACCT_ST");
	acc_st_nm = acc_st_nm.substring(0,2);
	
	int size = 0;
	
	String content_code = "STAT_ACCT";
	String content_seq  = save_dt+s_dt+e_dt+acct_st+seq;

	Vector attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
	

%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/acct/include/table_t.css"></link>
<script language="JavaScript">
<!--
	//스캔등록
	function reg_file(){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&save_dt=<%=save_dt%>&acct_st=<%=acct_st%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&seq=<%=seq%>", "SCAN", "left=300, top=300, width=620, height=200, scrollbars=yes, status=yes, resizable=yes");
	}	
	
	//심사요청하기
	function app_save()
	{
		var fm = document.form1;
		
		if(fm.result.value == ''){ alert('확인결과를 선택하십시오.'); return; }
		
		if(confirm('심사요청 하시겠습니까?')){	
			fm.target = "i_no";	
			fm.action = "/acct/mng/acct_app_a.jsp";	
			fm.submit();
		}
	}		
	
	//심사완료하기
	function res_save()
	{
		var fm = document.form1;
		
		if(confirm('심사완료 하시겠습니까?')){			
			fm.target = "i_no";	
			fm.action = "/acct/mng/acct_res_a.jsp";	
			fm.submit();
		}
	}			
	
	//프린트하기
	function Print()
	{
		var fm = document.form1;
	//	if(<%//=vt_size%> == 0)		{ alert('검색데이타가 없습니다. 먼저 검색하여 주십시오.'); 	fm.st_dt.focus(); 	return; }	
		//fm.cmd.value="p";
		fm.target = "_blank";
		fm.action = "/acct/<%=acc_st_nm%>/<%=ht.get("ACCT_ST")%>_print.jsp";	
		fm.submit();
	}
	
		//스캔삭제
	function scan_del(){

			var fm = document.form1;
			
			if(!confirm('삭제하시겠습니까?')){		return;	}
			fm.action = "del_scan_a.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&save_dt=<%=save_dt%>&acct_st=<%=acct_st%>";
			fm.target = "i_no";
			fm.submit();		

	}
	//-->
</script>
</head>
<script language="JavaScript" src="/include/common.js"></script>
<body leftmargin="15">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='save_dt' 		value='<%=save_dt%>'>
  <input type='hidden' name='acct_st' 		value='<%=acct_st%>'>
  <input type='hidden' name='s_dt' 		value='<%=s_dt%>'>
  <input type='hidden' name='e_dt' 		value='<%=e_dt%>'>
  <input type='hidden' name='seq' 		value='<%=seq%>'>
  
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
      <td>
        <table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acct/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acct/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>내부통제결과 > <span class=style5>내부통제결과보기</span></span></td>
            <td width=7><img src=/acct/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width=20% class=title>마감일자</td>
                    <td width=80%>&nbsp;<%=ht.get("SAVE_DT")%></td>
                </tr>
                <tr> 
                    <td class=title>평가기간</td>
                    <td>&nbsp;<%=ht.get("S_DT")%>~<%=ht.get("E_DT")%></td>
                </tr>
                <tr> 
                    <td class=title>프로세스구분</td>
                    <td>&nbsp;<%=ht.get("ACCT_ST")%></td>
                </tr>
                <tr> 
                    <td class=title>일련번호</td>
                    <td>&nbsp;<%=ht.get("SEQ")%></td>
                </tr>
                <%//for(int i =0; i<value_size; i++){
				
				if(ht.get("ACCT_ST").equals("rc1_c1")){
				%>
                <tr> 
                    <td class=title>계약번호</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>계약일자</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>계약자</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>외부신용정보조회기관</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
					<td class=title>조회일자</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
					
                </tr>
                <%}else if(ht.get("ACCT_ST").equals("rc1_c2")){%>
				<tr> 
                    <td class=title>계약번호</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>계약일자</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>계약자</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>적용심사등급</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
					<td class=title>승인자</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
                </tr>
				<tr> 
					<td class=title>승인일자</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("rc2_c1")){%>
				<tr> 
                    <td class=title>계약번호</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>계약일자</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>계약자</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>승인자</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
                </tr>
				<tr> 
					<td class=title>승인일자</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("pc1_c4")){%>
				<tr> 
                    <td class=title>계산서작성일자</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>공급받는자</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>전표번호</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("pc2_c1")){%>
				<tr> 
                    <td class=title>계약번호</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>고객</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>승인여부</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("pc2_c2")){%>
				<tr> 
                    <td class=title>계약번호</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>고객</td>
                    <td>&nbsp;<%=ht.get("VALUE7")%></td>
				</tr>
				<tr> 
					<td class=title>전표번호</td>
                    <td>&nbsp;<%=ht.get("VALUE8")%></td>
				</tr>
				<tr> 
					<td class=title>승인여부</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%>&nbsp;<%=ht.get("VALUE5")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("pc3_c1")){%>
				<tr> 
                    <td class=title>계약번호</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>고객</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>승인여부</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%>&nbsp;<%=ht.get("VALUE5")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("pc3_c2")){%>
				<tr> 
                    <td class=title>계약번호</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>고객</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>승인여부</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%>&nbsp;<%=ht.get("VALUE5")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("pc4_c1")){%>
				<tr> 
                    <td class=title>계약번호</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>고객</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>전표번호</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
					<td class=title>승인여부</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("pc4_c2")){%>
				<tr> 
                    <td class=title>계약번호</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>계약자</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>차량번호</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>승인자</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
					<td class=title>승인일자</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("pc5_c1")){%>
				<tr> 
					<td class=title>계약자</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>승인자</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>승인일자</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("rm1_c1")){%>
				<tr> 
                    <td class=title>계약번호</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>계약자</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>차명</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>출고일자</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
					<td class=title>승인자</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
					<td class=title>승인일자</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("rm1_c2")){%>
				<tr> 
                    <td class=title>계약번호</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>계약자</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>차명</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>출고일자</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
					<td class=title>전표번호</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
					<td class=title>승인자</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<tr> 
					<td class=title>승인일자</td>
                    <td>&nbsp;<%=ht.get("VALUE7")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("rm2_c1")){%>
				<tr> 
                    <td class=title>출금일자</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>지출</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>전표번호</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>승인자</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
					<td class=title>승인일자</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("rm3_c1")){%>
				<tr> 
                    <td class=title>날짜</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>확인유무</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("rm4_c1")){%>
				<tr> 
                    <td class=title>날짜</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>확인유무</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("rm5_c1")){%>
				<tr> 
                    <td class=title>경매출품차량</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>경매일자</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>탁송신청서및인수증일치여부</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>전결권자의 날인존재여부</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("rm5_c3")){%>
				<tr> 
                    <td class=title>전표번호</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>처분일자</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>전결권자의 날인존재여부</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("rm6_c1")){%>
				<tr> 
                    <td class=title>출금일자</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>지출처</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>전표번호</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>승인자</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
					<td class=title>승인일자</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("fc1_c2")){%>
				<tr> 
                    <td class=title>총무팀장의 비교대사질문</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("fc1_c3")){%>
				<tr> 
                    <td class=title>전표번호</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>차입일자</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>전결권자승인여부</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("fc2_c2")){%>
				<tr> 
                    <td class=title>출금일자</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>지출처</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>전표번호</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>승인자</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
					<td class=title>승인일자</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
                </tr>
				<%}else if(ht.get("ACCT_ST").equals("fc3_c1")){%>
				<tr> 
                    <td class=title>출금일자</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>지출처</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>현업부서장</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>총무팀장</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("fc3_c2")){%>
				<tr> 
                    <td class=title>접근통제여부</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("fc4_c3")){%>
				<tr> 
                    <td class=title>거래일자</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
					<td class=title>거래처</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
					<td class=title>거래금액</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
					<td class=title>전표확인자</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("fc5_c1")){%>
				<tr> 
                    <td class=title>승인여부</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("fc5_c3")){%>
				<tr> 
                    <td class=title>승인여부</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ac1_c1")){%>
				<tr> 
                    <td class=title>일자</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>계정과목 신설<br/>/변경신청서 존재여부</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>변경전회계정책<br/>/계정과목</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>변경후회계정책<br/>/계정과목</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>변경 사유</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>전결권자 승인여부</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ac2_c1")){%>
				<tr> 
                    <td class=title>일자</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>발행부서</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>전표개수(A)</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>ERP상 전표개수(B)</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>현업부서장 승인여부</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>일치여부(A)=(B)</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ac3_c1")){%>
				<tr> 
                    <td class=title>해당월 or 분기</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>계정</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>금액(A)</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>계정</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>금액(B)</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>일치여부(A)=(B)</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<tr> 
                    <td class=title>승인여부</td>
                    <td>&nbsp;<%=ht.get("VALUE7")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ac4_c2")){%>
				<tr> 
                    <td class=title>일자</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>전표번호</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>전표금액(A)</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>퇴직급여충당금집계표금액(B)</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>일치여부(A)=(B)</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>승인여부</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ac5_c1")){%>
				<tr> 
                    <td class=title>결산보고서(대상기간)</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>전결권자 승인여부</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ac6_c2")){%>
				<tr> 
                    <td class=title>해당분기</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>계정</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>금액(A)</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>계정</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>금액(B)</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>일치여부(A)=(B)</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<tr> 
                    <td class=title>승인여부</td>
                    <td>&nbsp;<%=ht.get("VALUE7")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ac7_c2")){%>
				<tr> 
                    <td class=title>법인세관련 품의서번호</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>법인세관련 품의일자</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>법인세납부 전표의 금액</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>법인세신고 확인증의 금액</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>일치여부</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>전결권자의 승인여부</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ac8_c3")){%>
				<tr> 
                    <td class=title>부가가치세신고 일자</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>사업연도</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>금액</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>전표금액</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>전표승인여부</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>일치여부</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ac10_c4")){%>
				<tr> 
                    <td class=title>취득일자</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>전표번호</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>전결권자의 날인 존재여부</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("hc1_c1")){%>
				<tr> 
                    <td class=title>인사정보변경 품의서 일자</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>전결권자의 날인 존재 여부</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("hc2_c2")){%>
				<tr> 
                    <td class=title>품의번호</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>품의일자</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>전결권자의 날인 존재 여부</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("hc2_c3")){%>
				<tr> 
                    <td class=title>급여지급전표일자</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>전결권자의 날인 존재 여부</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>(A) = (B)인지 여부(*)</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("hc4_c1")){%>
				<tr> 
                    <td class=title>복리후생전표일자</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>복리후생전표승인번호</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>전결권자의 날인 존재 여부</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>관련 증빙 존재 여부</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("mc1_c1")){%>
				<tr> 
                    <td class=title>회기/회차</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>의안</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>상임위원회 승인여부</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ic1_c1")){%>
				<tr> 
                    <td class=title>프로젝트명(개요)</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>기간(from ~ to)</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>문서번호</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>제목</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>작성자</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>작성일</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<tr> 
                    <td class=title>대표이사승인여부</td>
                    <td>&nbsp;<%=ht.get("VALUE7")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ic1_c2")){%>
				<tr> 
                    <td class=title>프로젝트명(개요)</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>기간(from ~ to)</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>(1)</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>(2)</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>(3)</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>(4)</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<tr> 
                    <td class=title>(5)</td>
                    <td>&nbsp;<%=ht.get("VALUE7")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ic4_c1")){%>
				<tr> 
                    <td class=title>영업일</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>작업결과</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>백업담당자</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>백업결과(이상유무)</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>이상이 발생한<br/> 경우 그 원인</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>이상이 발행한 경우<br/> 추후 조치 계획</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<tr> 
                    <td class=title>이상이 발생한 경우<br/> 조치 완료 여부</td>
                    <td>&nbsp;<%=ht.get("VALUE7")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ic4_c2")){%>
				<tr> 
                    <td class=title>복구작업일자</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>복구작업자</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>복구요청자</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>복구요청일</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>복구요청사유</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>복구유무</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<tr> 
                    <td class=title>이상발생시 그 원인</td>
                    <td>&nbsp;<%=ht.get("VALUE7")%></td>
				</tr>
				<tr> 
                    <td class=title>이상발생시 추후 조치 계획</td>
                    <td>&nbsp;<%=ht.get("VALUE8")%></td>
				</tr>
				<tr> 
                    <td class=title>이상발생시 조치 완료 여부</td>
                    <td>&nbsp;<%=ht.get("VALUE9")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ic5_c1")){%>
				<tr> 
                    <td class=title>장애일시</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>기록자</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>장애내역</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>장애발견자</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>조치완료여부</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>조치자</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<tr> 
                    <td class=title>조치사항 기재여부</td>
                    <td>&nbsp;<%=ht.get("VALUE7")%></td>
				</tr>
				<tr> 
                    <td class=title>재발방지대책 기재여부</td>
                    <td>&nbsp;<%=ht.get("VALUE8")%></td>
				</tr>
				<tr> 
                    <td class=title>검토후 확인날인 여부</td>
                    <td>&nbsp;<%=ht.get("VALUE9")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ic6_c1")){%>
				<tr> 
                    <td class=title>문서화된 보안정책 징구여부</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>보안정책 경영진 승인여부</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>보안책임자의 보안정책<br/> 주기적 검토여부</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>보안책임자의 보안정책<br/> 검토주기</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>검토결과가 보안정책에<br/>반영되어 있는지 여부</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ic6_c5")){%>
				<tr> 
                    <td class=title>점검일</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>점검자</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>점검PC</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>점검PC사용자</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>
				<tr> 
                    <td class=title>PC점검결과</td>
                    <td>&nbsp;<%=ht.get("VALUE5")%></td>
				</tr>
				<tr> 
                    <td class=title>점검승인자</td>
                    <td>&nbsp;<%=ht.get("VALUE6")%></td>
				</tr>
				<%}else if(ht.get("ACCT_ST").equals("ic7_c1")){%>
				<tr> 
                    <td class=title>요청일</td>
                    <td>&nbsp;<%=ht.get("VALUE1")%></td>
				</tr>
				<tr> 
                    <td class=title>요청자</td>
                    <td>&nbsp;<%=ht.get("VALUE2")%></td>
				</tr>
				<tr> 
                    <td class=title>현업부서장 승인여부</td>
                    <td>&nbsp;<%=ht.get("VALUE3")%></td>
				</tr>
				<tr> 
                    <td class=title>정보지원부서장 승인여부</td>
                    <td>&nbsp;<%=ht.get("VALUE4")%></td>
				</tr>

				
				<%}%>
                <tr> 
                    <td class=title>마감자</td>
                    <td>&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("REG_ID")),"USER")%> <%=ht.get("REG_DT")%></td>
                </tr>
                <tr> 
                    <td class=title>첨부파일</td>
                    <td>&nbsp;                      
                       
							<%if(attach_vt.size() <= 0){%>
								<a href="javascript:reg_file()"><img src=/acct/images/center/button_in_reg.gif align=absmiddle border=0></a>
							<%}else{%>
								<%for(int i=0; i< attach_vt.size(); i++){
									Hashtable at = (Hashtable)attach_vt.elementAt(i);       
								%>
						
							
							<%if(at.get("FILE_TYPE").equals("image/jpeg")||at.get("FILE_TYPE").equals("image/pjpeg")||at.get("FILE_TYPE").equals("application/pdf")){%>
								<a href="javascript:openPopP('<%=at.get("FILE_TYPE")%>','<%=at.get("SEQ")%>');" title='보기' ><%=at.get("FILE_NAME")%></a>
							<%}else{%>
								<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=at.get("SEQ")%>" target='_blank'><%=at.get("FILE_NAME")%></a>
							<%}%>
								<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=at.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
							<%}%>
                        <%}%>
                      
                    </td>
                </tr>
                <tr> 
                    <td class=title>확인결과</td>
                    <td>&nbsp;
                      <%if(String.valueOf(ht.get("APP_ID")).equals("")){%>
                        <select name="result">
	                  <option value="">선택</option>
                          <option value="Y">적합</option>
                          <option value="N">부적합</option>
                        </select>
                      <%}else{%>
                        <%if(String.valueOf(ht.get("RESULT")).equals("Y")){%>적합<%}%>
                        <%if(String.valueOf(ht.get("RESULT")).equals("N")){%>부적합<%}%>
                      <%}%>
                    </td>
                </tr>                     
                <%if(!String.valueOf(ht.get("APP_ID")).equals("")){%>           
                <tr> 
                    <td class=title>확인자</td>
                    <td>&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("APP_ID")),"USER")%> <%=ht.get("APP_DT")%></td>
                </tr>
                <%}%>
                <%if(!String.valueOf(ht.get("RES_ID")).equals("")){%>           
                <tr> 
                    <td class=title>심사자</td>
                    <td>&nbsp;<%=c_db.getNameById(String.valueOf(ht.get("RES_ID")),"USER")%> <%=ht.get("RES_DT")%></td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <%if(String.valueOf(ht.get("APP_ID")).equals("")){%>
    <tr>
      <td align="right">
        <a href="javascript:app_save()" onMouseOver="window.status=''; return true" onfocus="this.blur()">[평가확인]</a>        
      </td>      
    <tr>   
    <%}%>      
    <%if(!String.valueOf(ht.get("APP_ID")).equals("") && String.valueOf(ht.get("RES_ID")).equals("")){%>
    <tr>
      <td align="right">
        <a href="javascript:res_save()" onMouseOver="window.status=''; return true" onfocus="this.blur()">[심사완료]</a>        
      </td>      
    <tr>   
    <%}%>
	<%if(!String.valueOf(ht.get("APP_ID")).equals("") && !String.valueOf(ht.get("RES_ID")).equals("")){%>
	<tr>
		<td><a href="javascript:Print();"><img src=/acct/images/center/button_print.gif align=absmiddle border=0></a></td>
	</tr>
	<input type='hidden' name='st_dt' 		value='<%=s_dt%>'>
  <input type='hidden' name='end_dt' 		value='<%=e_dt%>'>
  <input type='hidden' name='s_cnt' 		value='1'> 
  <input type='hidden' name="value1" 	value="<%=ht.get("VALUE1")%>">
  <input type='hidden' name="value2" 	value="<%=ht.get("VALUE2")%>">
  <input type='hidden' name="value3" 	value="<%=ht.get("VALUE3")%>">
  <input type='hidden' name="value4" 	value="<%=ht.get("VALUE4")%>">
  <input type='hidden' name="value5" 	value="<%=ht.get("VALUE5")%>">
  <input type='hidden' name="value6" 	value="<%=ht.get("VALUE6")%>">
  <input type='hidden' name="value7" 	value="<%=ht.get("VALUE7")%>">			
  <input type='hidden' name="value8" 	value="<%=ht.get("VALUE8")%>">
  <input type='hidden' name="value9" 	value="<%=ht.get("VALUE9")%>">
  <input type='hidden' name="value10" 	value="<%=ht.get("VALUE10")%>">
  <input type='hidden' name="value11" 	value="<%=ht.get("VALUE11")%>">
  <input type='hidden' name="value12" 	value="<%=ht.get("VALUE12")%>">
  <input type='hidden' name="value13" 	value="<%=ht.get("VALUE13")%>">
  <input type='hidden' name="value14" 	value="<%=ht.get("VALUE14")%>">
  <input type='hidden' name="value15" 	value="<%=ht.get("VALUE15")%>">
  <input type='hidden' name="value16" 	value="<%=ht.get("VALUE16")%>">
  <input type='hidden' name="value17" 	value="<%=ht.get("VALUE17")%>">			
  <input type='hidden' name="value18" 	value="<%=ht.get("VALUE18")%>">
  <input type='hidden' name="value19" 	value="<%=ht.get("VALUE19")%>">
  <input type='hidden' name="value20" 	value="<%=ht.get("VALUE20")%>">
  
	<%}%>
		
</table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>