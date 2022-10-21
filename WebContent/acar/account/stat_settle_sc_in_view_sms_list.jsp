<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.settle_acc.*, tax.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<jsp:useBean id="atl_db" scope="page" class="acar.kakao.AlimTalkLogDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
	<title>SMS 발송리스트</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">	
<link rel=stylesheet type="text/css" href="/include/table_t.css">	
<script language='JavaScript' src='/include/common.js'></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<style type="text/css">
	.span_content {
	  overflow: hidden !important; 
	  text-overflow: ellipsis !important;
	  white-space: nowrap !important; 
	  width: 380px !important;
	  height: 20px !important;
	  display: '';
	}
</style>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;		
		fm.action = 'stat_settle_sc_in_view_sms_list.jsp';
		fm.target = '_self';
		fm.submit();
	}
		
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}		
//-->	
</script>
<script language="JavaScript" type="text/JavaScript">
	$(document).ready(function(){
		$("#at_log").find(".log-result").bind('click', function() {

            var temp_content = $(this).find(".span_content"); 
            if (temp_content.hasClass('span_content')) {
            	temp_content.removeClass('span_content');
            } else {
            	$(this).find(".prv_content").addClass('span_content');
            }

        });
		
		$("#biz_log").find(".log-result").bind('click', function() {

            var temp_content = $(this).find(".span_content"); 
            if (temp_content.hasClass('span_content')) {
            	temp_content.removeClass('span_content');
            } else {
            	$(this).find(".prv_content").addClass('span_content');
            }

        });
	})
</script>
</head>

<body>
<%
	String bus_id2 		= request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	String partner_id 	= request.getParameter("partner_id")==null?"":request.getParameter("partner_id");
	String s_day 		= request.getParameter("s_day")==null?"90":request.getParameter("s_day");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String query =  " select nvl(b.user_nm,a.send_name) send_man, "+
					"        a.* "+
					" from   ums_log a, users b, users c, users d "+
					" where  substr(a.send_time,1,8)>to_char(sysdate-"+s_day+",'YYYYMMDD') "+
					" and    a.send_name=b.user_id(+) and a.dest_name=c.user_id(+) and a.dest_name=d.user_nm(+)"+
					" and    a.dest_name is not null and c.user_id is null and d.user_id is null"+
					"";
	
	if(partner_id.equals("")) 	query += " and (nvl(b.user_nm,a.send_name) like '%"+c_db.getNameById(bus_id2,"USER")+"%' or a.etc4='"+bus_id2+"')";
	else						query += " and (nvl(b.user_nm,a.send_name) like '%"+c_db.getNameById(bus_id2,"USER")+"%' or nvl(b.user_nm,a.send_name) like '%"+c_db.getNameById(partner_id,"USER")+"%' or a.etc4='"+bus_id2+"' or nvl(b.user_nm,a.send_name)||a.etc4='"+c_db.getNameById(bus_id2,"USER")+""+partner_id+"')";
					
	query += 		" order by cmid";
	
	Vector vt = IssueDb.getTaxSmsList(query);
	int vt_size = vt.size();
	
	// 알림톡(성공건수)	
	List<AlimTalkLogBean> logList = atl_db.selectByBond("2", "", bus_id2, partner_id);
	// 비즈톡
	List<AlimTalkLogBean> logList2 = atl_db.selectByBondEm("2", "", bus_id2, partner_id);
	
%>
<form name='form1' method='post'>
<input type='hidden' name='bus_id2' value='<%=bus_id2%>'>
<input type='hidden' name='partner_id' value='<%=partner_id%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>경영정보 > 캠페인관리 > <span class=style5><%=c_db.getNameById(bus_id2,"USER")%> SMS 발송리스트 </span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <%-- <td>* <input type='text' name='s_day' size='5' class='num' value='<%=s_day%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>일 이내 발송분</td> --%>
        <td>* 문자 발송내역 (최근 3개월 이내 발송분)</td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tr> 
    <tr> 
        <td  class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=4% class='title'>연번</td>
                    <td width=10% class='title'>발신자</td>
                    <td width=20% class='title'>수신자</td>
                    <td width=15% class='title'>수신번호</td>
                    <td width=35% class='title'>내용</td>
                    <td width=16% class='title'>발송일자</td>					
                </tr>		
<%
	if(vt_size > 0){
		for (int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>				  
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=ht.get("SEND_MAN")%></td>										
                    <td align="center"><%=ht.get("DEST_NAME")%></td>
                    <td align="center"><%=ht.get("DEST_PHONE")%></td>
                    <td>&nbsp;<%=ht.get("MSG_BODY")%></td>
                    <td align="center"><%=AddUtil.ChangeDate3(String.valueOf(ht.get("SEND_TIME")))%></td>													
                </tr>
<%		}%>
<%	}else{ %>		 
				<tr>
				  <td colspan='6' align="center">등록된 데이타가 없습니다.</td>
				</tr>
<%	}%>
            </table>
        </td>
    </tr>
    <tr>
    	<td style="height: 30px;"></td>
    </tr>
    <tr>
    	<td>* 알림톡 발송내역 (최근 3개월 이내 발송분)</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr> 
    <tr>
    	<td class='line'>
    		<table border="0" cellspacing="1" cellpadding="0" width=100% id="at_log">
                <tr> 
                    <td width=4% class='title'>연번</td>
                    <td width=10% class='title'>발신자</td>
                    <td width=20% class='title'>수신자</td>
                    <td width=15% class='title'>수신번호</td>
                    <td width=35% class='title'>내용</td>
                    <td width=16% class='title'>발송일자</td>					
                </tr>	
<%
		if(logList.size() > 0){
			for (int i = 0 ; i < logList.size() ; i++){
				AlimTalkLogBean log = logList.get(i);
%>
                <tr class="log-result">
                	<td align="center"><%=i+1 %></td>
                	<% if (log.getUserNm().equals("SYSTEM")) {%>
	                	<td align="center">아마존카</td>
                	<%} else {%>
	                	<td align="center"><%=log.getUserNm() %></td>
                	<%}%>                	
                	<% if (log.getFirmNm().equals("-")) {%>
	                	<% if (log.getUserNm2().equals("-")) {%>
		                	<td align="center"><%=log.getRecipient_num() %></td>
	                	<%} else {%>
		                	<td align="center"><%=log.getUserNm2() %></td>
	                	<%}%>
                	<%} else {%>
	                	<td align="center"><%=log.getFirmNm() %></td>
                	<%}%>
                	<td align="center"><%=log.getRecipient_num() %></td>
                	<td>
                		<div class="div-class">
                			<span class="span_content prv_content" style="white-space: pre-line; text-align: left">&nbsp;<%=log.getContent() %></span>
                		</div>
                	</td>
                	<td align="center"><%=log.getDate_client_req_str2() %></td>
                </tr>
<%	   }	%>
<%} else {%>
				<tr>
					<td align="center" colspan="6" style="height: 50px;">3개월 이내 발송된 내역이 없습니다.</td>
				</tr>
<%}%>
            </table>
    	</td>
    </tr>
    <tr>
    	<td style="height: 30px;"></td>
    </tr>
    <tr>
    	<td>* 비즈톡 발송내역 (최근 3개월 이내 발송분)</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr> 
    <tr>
    	<td class='line'>
    		<table border="0" cellspacing="1" cellpadding="0" width=100% id="biz_log">
                <tr> 
                    <td width=4% class='title'>연번</td>
                    <td width=10% class='title'>발신자</td>
                    <td width=20% class='title'>수신자</td>
                    <td width=15% class='title'>수신번호</td>
                    <td width=35% class='title'>내용</td>
                    <td width=16% class='title'>발송일자</td>					
                </tr>	
<%
		if(logList2.size() > 0){
			for (int i = 0 ; i < logList2.size() ; i++){
				AlimTalkLogBean log2 = logList2.get(i);
%>
                <tr class="log-result">
                	<td align="center"><%=i+1 %></td>
                	<% if (log2.getUserNm().equals("SYSTEM")) {%>                		
	                	<td align="center">아마존카</td>
                	<%} else {%>
	                	<td align="center"><%=log2.getUserNm() %></td>
                	<%}%>
                	<% if (log2.getFirmNm().equals("-")) {%>
	                	<% if (log2.getUserNm2().equals("-")) {%>
		                	<td align="center"><%=log2.getRecipient_num() %></td>
	                	<%} else {%>
		                	<td align="center"><%=log2.getUserNm2() %></td>
	                	<%}%>
                	<%} else {%>
	                	<td align="center"><%=log2.getFirmNm() %></td>
                	<%}%>
                	<td align="center"><%=log2.getRecipient_num() %></td>
                	<td>
                		<div class="div-class">
                			<span class="span_content prv_content" style="white-space: pre-line; text-align: left;">&nbsp;<%=log2.getContent() %></span>
                		</div>
                	</td>
                	<td align="center"><%=log2.getDate_client_req_str2() %></td>
                </tr>
<%	   }	%>
<%} else {%>
				<tr>
					<td align="center" colspan="6" style="height: 50px;">3개월 이내 발송된 내역이 없습니다.</td>
				</tr>
<%}%>
            </table>
    	</td>
    </tr>
</table>
</form>
</body>
</html>
