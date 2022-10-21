<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.estimate_mng.*, acar.user_mng.*" %>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstiSpeBean" scope="page"/>
<jsp:useBean id="shDb" 		class="acar.secondhand.SecondhandDatabase" 	scope="page"/>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<%@ include file="/acar/cookies.jsp" %>

<%
	String est_id 	= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String chk 		= request.getParameter("chk")==null?"":request.getParameter("chk");  //최초입력 여부
	String bb_chk 	= request.getParameter("bb_chk")==null?"":request.getParameter("bb_chk");  //부재중 여부
	String t_chk	= request.getParameter("t_chk")==null?"":request.getParameter("t_chk");  //상담및 통화
	
	if (!bb_chk.equals("") &&  !t_chk.equals("") ) {
		bb_chk = "";
	}
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();

	u_bean = umd.getUsersBean(user_id);

	e_bean = e_db.getEstiSpeCase(est_id);
	
	EstimateBean [] e_r = e_db.getEstiSpeCarList(est_id);
	int size = e_r.length;
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
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
			fm.note.value = "부재중 문자발송";
		 	fm.gubun.value = "1";
		}		
	//	if(!confirm('등록하시겠습니까?')){	return; }		
	
					
		fm.action = "esti_memo_null_ui.jsp";		
		fm.target = "i_no";
		fm.submit();
		
		
	}
	
	function save(){
		var fm = document.form1;
		if(fm.est_id.value == ''){ 	alert('est_id가 없습니다. 확인하십시오.'); return; }
		if(fm.user_id.value == ''){ alert('user_id가 없습니다. 확인하십시오.'); return; }
		if(fm.note.value == ''){ 	alert('통화내용이 없습니다. 확인하십시오.'); return; }
		if(!confirm('등록하시겠습니까?')){	return; }					
		
		var link = document.getElementById("submitLink");
		var originFunc = link.getAttribute("href");
		link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
		
		fm.action = "esti_memo_null_ui.jsp";		
		fm.target = "i_no";
		fm.submit();
		
		link.getAttribute('href',originFunc);
	}
	
	function change(arg){
		var fm = document.form1;
		//arg = trim(arg);
	
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
	
	function EstiATypeReg(st, car_mng_id, seq){
		var fm = document.form1;		
		if(!confirm('견적하시겠습니까?')){	return; }					
		fm.spe_seq.value = seq;
		fm.target = "d_content";
		if(car_mng_id == ''){
			fm.st.value = st;
			fm.est_table.value = 'esti_spe';
			fm.action = "esti_mng_atype_i.jsp";		
			if(st == '2'){
				fm.target = "i_no";
			} 
		}else{
			fm.st.value = '';
			fm.car_mng_id.value = car_mng_id;
			fm.est_table.value = 'esti_spe';	
			fm.action = "/acar/secondhand/secondhand_detail_frame.jsp";				
		}
		fm.submit();
	}	
	
	//문자내용 발송하기
function msg_send(){ 
	fm = document.form1;
	
	if(!confirm("[<%if(!e_bean.getEst_agnt().equals("")){%><%=e_bean.getEst_agnt()%><%} else {%><%=e_bean.getEst_nm()%><%}%> 고객님께서 요청하신 견적 상담을 위해 전화드렸으나 연결이 되지 않아 문자 남깁니다. 언제든 상담이 가능하니 통화 가능하실 때 연락주세요.] 부재중 관련 문자내용을 발송하시겠습니까?"))	return;
	fm.target = "i_no";
		
	fm.action = "send_case.jsp";
	fm.submit();		
	tell_save("19");
}
//-->
</script>
</head>
<body leftmargin="15">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 스마트견적관리 > <span class=style5>통화내역</span></span> : 통화내역</td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
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
                    <td class=title width=18%>성명/법인명</td>
                    <td width=32%>&nbsp;<%=e_bean.getEst_nm()%>&nbsp;<%if(e_bean.getClient_yn().equals("Y")){%> - 기존고객<%}%></td>
                    <td width=18% class=title>생년월일<br>/사업자번호</td>
                    <td width=32%>&nbsp;<%=e_bean.getEst_ssn()%></td>
                </tr>
                <tr>
                    <td class=title>담당자</td>
                    <td>&nbsp;<%=e_bean.getEst_agnt()%></td>
                    <td class=title>전화번호</td>
                    <td>&nbsp;<%=AddUtil.phoneFormat(e_bean.getEst_tel())%>
							
					</td>
                </tr>
                <tr>
                    <td class=title>지역</td>
                    <td>&nbsp;<%=e_bean.getEst_area()%></td>
                    <td class=title>팩스번호</td>
                    <td>&nbsp;<%=e_bean.getEst_fax()%></td>
                </tr>
                <tr>
                    <td class=title>업종</td>
                    <td align="left">&nbsp;<%=e_bean.getEst_bus()%></td>
                    <td class=title>업력</td>
                    <td>&nbsp;<%=e_bean.getEst_year()%></td>
                </tr>
				<tr>
                    <td class=title>이메일</td>
                    <td align="left" colspan="3">&nbsp;<%=e_bean.getEst_email()%></td>
                </tr>
				<%if(size>0){%>
				<%		for(int i=0; i<size; i++){
    						EstimateBean car_bean = e_r[i];
							int a_a_len = car_bean.getA_a().length();
							String a_a[]	= new String[4];
							for(int j=0; j<4; j++){
								a_a[j] = "";
							}
							for(int j=0; j<a_a_len/2; j++){
								a_a[j] = car_bean.getA_a().substring(j*2,(j+1)*2);
							}
							if(!car_bean.getCar_mng_id().equals("")){
								//차량정보
								Hashtable ht = shDb.getShBase(car_bean.getCar_mng_id());
								car_bean.setEst_ssn	(c_db.getNameById(String.valueOf(ht.get("CAR_COMP_ID")), "CAR_COM"));
								car_bean.setCar_nm	(String.valueOf(ht.get("CAR_NAME")));
								car_bean.setOpt		(String.valueOf(ht.get("OPT")));
								car_bean.setCol		(String.valueOf(ht.get("COL")));
							}
							%>
                <tr>
                    <td class=title>희망차종<%=i+1%></td>
                    <td colspan="3">
                        <table width=100% border=0 cellspacing=0 cellpadding=5>
                            <tr>
                                <td>
									<%if(car_bean.getCar_mng_id().equals("")){%>
									[신차]
									<%}else{%>
									[재리스] <%=car_bean.getEst_nm()%> 
									<%}%>
									<%=car_bean.getEst_ssn()%> 
									<%=car_bean.getCar_nm()%> 
									<%=car_bean.getCar_name()%>
									<br>									
									<%=car_bean.getOpt()%> 
									<%=car_bean.getCol()%> 	
									<%if(!car_bean.getOpt().equals("")){%><br><%}%>
									<%for(int j=0; j<4; j++){%>
									<%	if(a_a[j].equals("11")){%>리스일반식 <%}%>
									<%	if(a_a[j].equals("12")){%>리스기본식 <%}%>
									<%	if(a_a[j].equals("21")){%>렌트일반식 <%}%>
									<%	if(a_a[j].equals("22")){%>렌트기본식 <%}%>
									<%}%>
									<%=car_bean.getA_b()%>개월
										
									&nbsp;&nbsp;&nbsp;
									<%if(car_bean.getCar_mng_id().equals("")){%>
									<%	if(!a_a[0].equals("") && !car_bean.getCar_id().equals("") && !car_bean.getCar_seq().equals("")){%>									
									<a href="javascript:EstiATypeReg('2','<%=car_bean.getCar_mng_id()%>','<%=car_bean.getSeq()%>')"><img src=/acar/images/center/button_est_gb.gif align="absmiddle" border="0" alt="기본견적"></a>
									<%	}%>									
									<a href="javascript:EstiATypeReg('3','<%=car_bean.getCar_mng_id()%>','<%=car_bean.getSeq()%>')"><img src=/acar/images/center/button_est_jj.gif align="absmiddle" border="0" alt="조정견적"></a>
									<%	if(car_bean.getCar_id().equals("") && car_bean.getCar_seq().equals("")){%>									
									        <br>* 세부차종 선택이 되지 않았습니다. 조정견적에서 차종 및 세부 조건 맞추어 견적하세요.
									<%	}%>
									<%}else{%>
									<a href="javascript:EstiATypeReg('3','<%=car_bean.getCar_mng_id()%>','<%=car_bean.getSeq()%>')"><img src=/acar/images/center/button_in_esti.gif align=absmiddle border=0></a>
									<%}%>
									
									
								</td>
                            </tr>
                        </table>
                    </td>
                </tr>				
				<%		}%>
				<%}else{%>
				<%		if(e_bean.getCar_nm2().equals("")){%>
                <tr>
                    <td class=title>희망차종</td>
                    <td colspan="3">
                        <table width=100% border=0 cellspacing=0 cellpadding=5>
                            <tr>
                                <td><%=e_bean.getCar_nm()%></td>
                            </tr>
                        </table>
                    </td>
                </tr>
				<%		}else{%>
				<tr>
                    <td class=title>희망차종1</td>
                    <td colspan="3">
                        <table width=100% border=0 cellspacing=0 cellpadding=5>
                            <tr>
                                <td><%=e_bean.getCar_nm()%></td>
                            </tr>
                        </table>
                    </td>
                </tr>
    			<tr>
                    <td class=title>희망차종2</td>
                    <td colspan="3">
                        <table width=100% border=0 cellspacing=0 cellpadding=5>
                            <tr>
                                <td><%=e_bean.getCar_nm2()%></td>
                            </tr>
                        </table>
                    </td>
                </tr>
				<%		}%>
				<%		if(!e_bean.getCar_nm3().equals("")){%>
    			<tr>
                    <td class=title>희망차종3</td>
                    <td colspan="3">
                        <table width=100% border=0 cellspacing=0 cellpadding=5>
                            <tr>
                                <td><%=e_bean.getCar_nm3()%></td>
                            </tr>
                        </table>
                    </td>
                </tr>
				<%		}%>					
				<%}%>

                <tr>
                    <td class=title>기타요청사항</td>
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
    </tr>
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
					<td><iframe src="./esti_memo_i_in.jsp?est_id=<%=est_id%>&user_id=<%=user_id%>" name="i_in" width="100%" height="130" cellpadding="0" cellspacing="0" topmargin=0 marginwidth="0" border="0" frameborder="0" scrolling="yes"></iframe></td>
				</tr>								
			</table>
		</td>
	</tr>    
    <tr>
    	<td class=h></td>
    </tr>
<form action="./esti_memo_null_ui.jsp" name="form1" method="POST" >
 <input type="hidden" name="user_id" value="<%=user_id%>">
 <input type="hidden" name="est_id" value="<%=est_id%>">
 <input type="hidden" name="cmd" value="">
 <input type="hidden" name="gubun" value="">
 <input type="hidden" name="spe_seq" value="">  
 <input type="hidden" name="est_table" value="">   
 <input type="hidden" name="car_mng_id" value="">    
 <input type="hidden" name="st" value="">    
 
<input type="hidden" name="sendname" value="<%=u_bean.getUser_nm()%>">
<input type="hidden" name="sendphone" value="<%=u_bean.getUser_m_tel()%>">
 <input type="hidden" name="user_pos" value="<%=u_bean.getUser_pos()%>">
 <input type="hidden" name="destphone" value="<%=e_bean.getEst_tel()%>">
 <input type="hidden" name="destname" value="<%if(!e_bean.getEst_agnt().equals("")){%>"<%=e_bean.getEst_agnt()%>"<%} else {%>"<%=e_bean.getEst_nm()%>"<%}%>">
 <input type="hidden" name="msg_type" value="5">
 <input type="hidden" name="msgs" value="">
 
 
 
<% if ( chk.equals("1") || !bb_chk.equals("") ) {%> 
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
    <td align="right"><a id="submitLink" href="javascript:save()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;&nbsp;
    <a href="javascript:self.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>