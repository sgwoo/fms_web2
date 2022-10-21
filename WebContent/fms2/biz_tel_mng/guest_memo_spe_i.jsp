<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.user_mng.*" %>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstiSpeBean" scope="page"/>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<%@ include file="/acar/cookies.jsp" %>

<%
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String chk = request.getParameter("chk")==null?"":request.getParameter("chk");  //최초입력 여부
	String bb_chk = request.getParameter("bb_chk")==null?"":request.getParameter("bb_chk");  //부재중 여부
	String t_chk = request.getParameter("t_chk")==null?"":request.getParameter("t_chk");  //상담및 통화
	
	if (!bb_chk.equals("") &&  !t_chk.equals("") ) {
		bb_chk = "";
	}
	
	EstiDatabase e_db = EstiDatabase.getInstance(); 
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	u_bean = umd.getUsersBean(user_id);
	
	e_bean = e_db.getEstiSpeCase(est_id);
	

%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table_t.css">
<script language="JavaScript">
<!--

	function tell_save(gubun){
		var fm = document.form1;
		if(fm.est_id.value == ''){ 	alert('est_id가 없습니다. 확인하십시오.'); return; }
		if(fm.user_id.value == ''){ alert('user_id가 없습니다. 확인하십시오.'); return; }
		
		
		if(gubun=='00')	{
			fm.note.value = "통화함";
			fm.gubun.value = "0";
		} else if(gubun=='01')	{
		   fm.note.value = "부재중";
		   fm.gubun.value = "1";
		} else if(gubun=='02')  {
			fm.note.value = "결번(잘못된번호)";
		 	fm.gubun.value = "2";
		} else if(gubun=='19')  {
		alert(gubun);
			fm.note.value = "부재중 문자발송";
		 	fm.gubun.value = "1";
		}
		
	//	if(!confirm('등록하시겠습니까?')){	return; }	
		fm.action = "guest_memo_null_ui.jsp";		
		fm.target = "i_no";
		fm.submit();
	}
	
	function save(){
		var fm = document.form1;
		if(fm.est_id.value == ''){ 	alert('est_id가 없습니다. 확인하십시오.'); return; }
		if(fm.user_id.value == ''){ alert('user_id가 없습니다. 확인하십시오.'); return; }
		if(fm.note.value == ''){ 	alert('통화내용이 없습니다. 확인하십시오.'); return; }
		if(!confirm('등록하시겠습니까?')){	return; }					
		fm.target = "i_no";
		fm.submit();
	}
	
	function change(arg){
		var fm = document.form1;
		//arg = trim(arg);
	//	if(arg=='00')		fm.note.value = "통화함";
	//	else if(arg=='01')	fm.note.value = "부재중";
	//	else if(arg=='02')	fm.note.value = "결번(잘못된번호)";
		
		
		if(arg=='03')	fm.note.value = "나그네";
		else if(arg=='04')	fm.note.value = "담당자 미확인";
		else if(arg=='05')	fm.note.value = "영업사원";
		else if(arg=='06')	fm.note.value = "기존업체";
		else if(arg=='07')	fm.note.value = "단기대여";
		else if(arg=='08')	fm.note.value = "비교견적중";
		else if(arg=='09')	fm.note.value = "오프리스조회";
		else if(arg=='10')	fm.note.value = "진행업체견적검토용";
		else if(arg=='11')	fm.note.value = "타사렌트(리스)로 계약함";
		else if(arg=='12')	fm.note.value = "할부구매함";
		else if(arg=='13')	fm.note.value = "장기간보류";
		else if(arg=='14')	fm.note.value = "미리검토함";
		else if(arg=='15')	fm.note.value = "검토중임";
		else if(arg=='16')	fm.note.value = "계약체결";
		else if(arg=='17')	fm.note.value = "무관심";
		else if(arg=='18')	fm.note.value = "기타";
		else if(arg=='19')	fm.note.value = "부재중문자발송";
	}
	
	//문자내용 발송하기
function msg_send(){ 
	fm = document.form1;
	
	if(!confirm("[아마존카 상담관련 전화드렸습니다. 문자보시면 연락 부탁드립니다.] 부재중 관련 문자내용을 발송하시겠습니까?"))	return;
	fm.target = "i_no";
		
	fm.action = "send_case.jsp";
	fm.submit();		
	tell_save("19");
}
	
//-->
</script>
</head>
<body leftmargin="15" >
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 견적시스템 > <span class=style5>고객상담내역</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class="line">
    	    <table border="0" cellpadding=0 cellspacing="1" width=100%>
                <tr>
                    <td class=title width=20%>작성자</td>
<%
	UsersBean user_bean = umd.getUsersBean(e_bean.getReg_id());
%>                    
                    <td width=30% >&nbsp;<%=user_bean.getUser_nm()%></td>
                    <td class=title width=20%>작성일자</td>
                    <td width=30% >&nbsp;<%=AddUtil.ChangeDate3(e_bean.getReg_dt())%></td>
                </tr>
          </table>
      </td>
	</tr>
	<tr>
        <td class=h></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class="line">
    	    <table border="0" cellpadding=0 cellspacing="1" width=100%>
                <tr>
                    <td class=title width=20%>성명/법인명</td>
                    <td colspan="3">&nbsp;<%=e_bean.getEst_nm()%></td>
                </tr>
                 <tr>
                    <td class=title width=20%>담당자</td>
                    <td width=30%>&nbsp;<%=e_bean.getEst_agnt()%></td>
                    <td class=title width=20%>전화번호</td>
                    <td width=30%>&nbsp;<%=e_bean.getEst_tel()%></td>
                </tr>
                <tr>
                    <td class=title width=20%>기타요청사항</td>
                    <td colspan="3">
                        <table width=100% border=0 cellspacing=0 cellpadding=5>
                            <tr>
                                <td><%=e_bean.getEtc()%></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    <tr>
    	<td>&nbsp;</td>
    </tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
			    <tr>
                    <td class=line2></td>
                </tr>
				<tr>					
                    <td class='line'> 
                        <table  border=0 cellspacing=1 cellpadding="0" width="100%">
                            <tr> 
                                <td class=title width=22%>날짜</td>
                                <td class=title width=14%>작성자</td>
                                <td class=title width=64%>통화내용</td>
                            </tr>
                        </table>					
                    </td>					
                    <td width=17>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
		<td>
	        <table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td><iframe src="./guest_memo_i_in.jsp?est_id=<%=est_id%>&user_id=<%=user_id%>" name="i_in" width="100%" height="150" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0" scrolling="yes"></iframe></td>
				</tr>								
			</table>
		</td>
	</tr>    
    <tr>
    	<td class=h></td>
    </tr>
<form action="./guest_memo_null_ui.jsp" name="form1" method="POST" >
 <input type="hidden" name="user_id" value="<%=user_id%>">
 <input type="hidden" name="est_id" value="<%=est_id%>">
 <input type="hidden" name="cmd" value="">
 <input type="hidden" name="gubun" value="">
 
<input type="hidden" name="sendname" value="<%=u_bean.getUser_nm()%>">
<input type="hidden" name="sendphone" value="<%=u_bean.getUser_m_tel()%>">
<input type="hidden" name="user_pos" value="<%=u_bean.getUser_pos()%>">
<input type="hidden" name="destphone" value="<%=e_bean.getEst_tel()%>">
<input type="hidden" name="destname" value="<%=e_bean.getEst_agnt()%>">
<input type="hidden" name="msg_type" value="0">
<input type="hidden" name="msgs" value="">
 
<% if ( chk.equals("1") || !bb_chk.equals("")  ) {%> 
 	<tr>
        <td></td>
    </tr>		
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>통화관련 간편 클릭</span></td>
	</tr>
	
    <tr></tr>
    <tr></tr>
    <tr>    	
    <td align="left">   
    <a href="javascript:tell_save('00')"><img src=/acar/images/center/button_call_con.gif align=absmiddle border=0></a>&nbsp;&nbsp; 
    <a href="javascript:tell_save('01')"><img src=/acar/images/center/button_call_bj.gif align=absmiddle border=0></a>&nbsp;&nbsp; 
    <a href="javascript:tell_save('02')"><img src=/acar/images/center/button_call_nnum.gif align=absmiddle border=0></a>&nbsp;&nbsp; 
	<a href="javascript:msg_send()">[부재중문자발송]</a>&nbsp;&nbsp; 
     </td>
    </tr>
    <tr></tr>
	<tr><td><font color=red>***</font>&nbsp;[통화연결]은 통화를 시도하는 시점에 누르지 말고 상담 요청한 고객과 전화로 연결된 순간에 클릭을 하여야 합니다.</td></tr>
	<tr></tr>
<% } %>	
	
	<tr>
    <td></td>
    </tr>		
	<tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>상담결과 입력</span></td>
	</tr>
	
	<tr></tr>
 	<tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=100%>                   
            
                <tr>
                    <td class=title width=18% rowspan="2"></td>
                    <td>&nbsp;<textarea name="note" cols=77 rows=4 onBlur="javascript:change(this.value);" class=default></textarea></td>
                </tr>
                <tr>
                    <td style="font-size:8pt; height:53;">
					&nbsp;03:나그네 04:담당자미확인 05:영업사원 06:기존업체 07:단기대여 08:비교견적中<br> 
					&nbsp;09:오프리스조회 10:진행업체견적검토用 11:타사렌트(리스)로계약함 12:할부구매함<br>
					&nbsp;13:장기간보류 14:미리검토함 15:검토중임 16:계약체결 17:무관심 18:기타 19:부재중문자발송</td>
                </tr>
               			
           </table>
        </td>
    </tr>
    
</form>
	<tr></tr>
	<tr><td><font color=red>***</font>&nbsp;상단의 번호를 사용하시면 편리합니다.</td></tr>
<% if ( chk.equals("1") || !bb_chk.equals("") ) {%> 	
<% } else {%> 
	<tr><td><font color=red>***</font>&nbsp;특별히 입력할 상담결과과 없으면 [닫기]를 바로 클릭하셔도 됩니다.</td></tr>
<% } %>	
    <tr>    	
    <td align="right">   
    <a href="javascript:save()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp; 
    <a href="javascript:self.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    
    </tr>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>