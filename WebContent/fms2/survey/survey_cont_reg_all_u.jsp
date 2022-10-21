<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.call.*,acar.cont.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="p_db" scope="page" class="acar.call.PollDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//검색구분
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id 	= request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String s_bank 	= request.getParameter("s_bank")==null?"":request.getParameter("s_bank");
	String t_wd	 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String cont_st 	= request.getParameter("cont_st")==null?"0":request.getParameter("cont_st");
	String b_lst 	= request.getParameter("b_lst")==null?"":request.getParameter("b_lst");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if (user_id.equals("")) {
		user_id = login.getCookieValue(request, "acar_id");
	}
	
	if (br_id.equals("")) {
		br_id = login.getCookieValue(request, "acar_br");
	}
	
	if (auth_rw.equals("")) {
		auth_rw = rs_db.getAuthRw(user_id, "16", "01", "02");
	}
	
	//계약:고객관련
	ContBaseBean base = p_db.getContBaseAll(m_id, l_cd);
	
	String h_brch = base.getBrch_id();
	String rent_st = base.getRent_st();
	String bus_st = base.getBus_st();  //6:기존업체
	String ext_st = base.getExt_st();
		
	if (rent_st.equals("2")) {
		rent_st = "5";
	} else if (rent_st.equals("7")) {	
		rent_st = "6";
	}
	
	if (rent_st.equals("6") &&	bus_st.equals("6")) {
		rent_st = "8";   // 재리스 기존업체
	}
	
	if (ext_st.equals("연장")) {
		rent_st = "5";
	}
	
	//계약타입
	String poll_st = request.getParameter("poll_st") == null? "" : request.getParameter("poll_st");
	//System.out.println("poll_st = " + poll_st);
	
	//car_call정보
	Vector vt = new Vector();
	
	if (poll_st.equals("")) {
		vt = p_db.getPollAll(m_id, l_cd);
 	} else {
 		vt = p_db.getSurveyContPollAll(m_id, l_cd);
	}
	
	int vt_size = vt.size();
	//System.out.println("vt_size = " + vt_size);

 	//live_poll정보
 	//Vector vt_live = p_db.getPollAll(rent_st, "A", "A");
 	//int vt_live_size = vt_live.size();
	
	//new_car_call정보
 	String rent_dt = request.getParameter("rent_dt")==null?"":request.getParameter("rent_dt");
	//System.out.println("rent_dt = " + rent_dt);
	
	Vector polls = p_db.getSurvey_Play_Q(poll_st, rent_dt);
	
	int poll_size = polls.size();
	
	Hashtable pb = p_db.getSurvey_Play_Basic(poll_st);
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script language="JavaScript">
<!--
	//등록하기
	function save(cmd){	
		
	var fm = document.form1;
	var len = fm.elements.length;
	var cnt = 0;
	var con_mes = '';
	
	if (cmd == 'no') {	
		con_mes = '설문거부로 등록 하시겠습니까?';		
	} else {
	<% for (int j = 0; j < poll_size ; j++) { %>
		
		for (var i = 0; i < len ; i++) {
			var ck = fm.elements[i];
			if (ck.name == "answer<%=j+1%>") {
				if (ck.checked == true) {
					cnt++;
				}	
			}
		}	
		// alert(cnt);
		
		if ( cnt == 0 ) {
			alert("<%=j+1%>번 질문에 답변을 다셔야 합니다.!!!");
			return ;
		} else {
			cnt =0;
		}
			
	<% } %>		
		
		if (cmd == 'i') {
			con_mes = '저장하시겠습니까?';			
		} else if (cmd == 'u') {
			con_mes = '수정하시겠습니까?';
		}
	}
	
	if (confirm(con_mes)) {
		//fm.target='nodisplay';
		fm.cmd.value = cmd;
		fm.target='c_foot';
		fm.action='survey_cont_reg_all_u_a.jsp';
		fm.submit();
	}
}
	
//-->
</script>
<style>
textarea {
    width: 100%;
    height: 50px;
    padding: 12px 20px;
    box-sizing: border-box;
    border: 2px solid #ccc;
    border-radius: 4px;
    background-color: #f8f8f8;
    font-size: 12px;
    resize: none;
}
input[name=poll_title] {
    width: 100%;
    padding: 6px 20px;
    margin: 8px 0;
    box-sizing: border-box;
    border: 1px none ;
    border-radius: 4px;
	text-align: center;	
}
input[name=start_dt], input[name=end_dt], input[name=poll_su]  {
    width: 40%;
    padding: 6px 20px;
    margin: 8px 0;
    box-sizing: border-box;
    border: 1px solid ;
    border-radius: 4px;	
}
</style>
<script>
//리스트 가기	
function list_go(st) {
	var fm = document.form1;
	if (st== 'i') {
		parent.parent.location = "rent_cond_frame.jsp?auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&brch_id=<%=brch_id%>&s_bank=<%=s_bank%>&t_wd=<%=t_wd%>&cont_st=<%=cont_st%>";
	} else {
		parent.parent.location = "call_cond_frame.jsp?auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&brch_id=<%=brch_id%>&s_bank=<%=s_bank%>&t_wd=<%=t_wd%>&cont_st=<%=cont_st%>";
	}
}

function open_msg(cmd) {
	var SUBWIN="./survey_msg_pop.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&cmd="+cmd;  
    window.open(SUBWIN, "pop", "left=100, top=100, width=500, height=500, scrollbars=yes, status=yes");
}
</script>
</head>
<body leftmargin="15">

<form action='survey_cont_reg_all_u_a.jsp' name="form1" method='post' >
<!--구분자-->
<input type='hidden' name="mode" value=''><!--법인차량 관리자 수정,추가 구분자-->
<input type='hidden' name="gubun" value=''>
<input type='hidden' name='use_yn' value='<%=base.getUse_yn()%>'>
<!--정보-->
<input type='hidden' name="h_c_id" value='<%=base.getClient_id()%>'><!-- client id -->
 <input type='hidden' name="h_gbn" value=''>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<!--기초정보-->
<input type='hidden' name="t_con_cd" value=''>
<input type='hidden' name="t_rent_dt" value='<%=base.getRent_dt()%>'>
<input type='hidden' name="s_rent_st" value='<%=base.getRent_st()%>'>
<input type='hidden' name="s_car_st" value='<%=base.getCar_st()%>'>
<input type='hidden' name="t_brch_nm" value=''>
<input type='hidden' name="h_brch" value=''>
<input type='hidden' name="s_bus_id" value=''>
<input type='hidden' name="s_bus_id2" value=''>
<input type='hidden' name="s_mng_id" value=''>
<input type='hidden' name="s_mng_id2" value=''>
<input type='hidden' name="s_dept_id" value=''>
<input type='hidden' name="s_rent_way" value='<%=base.getRent_way()%>'>
<input type='hidden' name="s_bus_st" value=''>
<input type='hidden' name="t_con_mon" value='<%=base.getCon_mon()%>'>
<input type='hidden' name="t_rent_start_dt" value=''>
<input type='hidden' name="t_rent_end_dt" value=''>
<input type='hidden' name="rent_st_ext" value=''>		
<!--검색값-->
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>		
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='s_bank' value='<%=s_bank%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='cont_st' value='<%=cont_st%>'> 
<input type='hidden' name='b_lst' value='<%=b_lst%>'> 
<input type='hidden' name='cmd' value=''>

<input type='hidden' name='poll_st' value='<%=poll_st%>'>
<input type='hidden' name='rent_dt' value='<%=rent_dt%>'> 
<input type="hidden" name="temp" value="">
<input type="hidden" name="temp2" value="">

<table border='0' cellspacing='0' cellpadding='0' width='100%'>

	<tr> 
        <td class="" colspan="3">
			<table border="0" cellspacing="1" cellpadding='0' width=100%>
			<%if (vt_size > 0) {%>
				<tr>
					<td class=""><input type="button" class="button button4" value="수정" onclick="save('u');"/></td>
					<td align="right"><input type="button" class="button button4" value="목록" onclick="list_go('u');"/></td>
				</tr>
			<%} else {%>
				<tr>
					<td class="">
						<input type="button" class="button button4" value="저장" onclick="save('i');"/>
						&nbsp;<input type="button" class="button button4" value="설문거부" onclick="save('no');"/>
						&nbsp;<input type="button" class="button button4" value="계약확인요청" onclick="open_msg('cont');"/>
					</td>
					<td align="right"><input type="button" class="button button4" value="목록" onclick="list_go('i');"/></td>
				</tr>
			<%}%>
			</table>
		</td>
    </tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr> 
        <td class=line colspan="3">
			<table border="0" cellspacing="1" cellpadding='0' width=100%>
				<tr>
					<td class="title">콜관리사항</td>
				</tr>
				<tr>
					<td class=""><input type="text" name="poll_title" id="poll_title" size="100" value="<%=pb.get("POLL_TITLE")%>"></td>
				</tr>
			</table>
		</td>
    </tr>

<%if (vt_size > 0) {%>
	<tr> 
        <td class=line colspan="3">
			<table border="0" cellspacing="1" cellpadding='0' width=100%>
			 <%
			 	for (int i = 0 ; i < vt_size ; i++) {
					Hashtable ht1 = (Hashtable)vt.elementAt(i);
						
					Vector ans = p_db.getSurvey_answer((String)ht1.get("POLL_S_ID"), (String)ht1.get("POLL_ID"));
					int ans_size = ans.size();	
			%>
				<tr> 
					<td width='15%' class='title'>질문 &nbsp;<%=ht1.get("POLL_SEQ")%></td>
					<td align='left' colspan=5>&nbsp;<font color="red"><%=String.valueOf(ht1.get("CONTENT")).trim()%></font>
					<input type='hidden' name="poll_s_id" value='<%=ht1.get("POLL_S_ID")%>'  > 
					<input type='hidden' name='poll_seq<%=i+1%>' value='<%=ht1.get("POLL_SEQ")%>'> 
					<!--<textarea rows="2" name="question<%=i+1%>" style="width:90%; text-align:left; color:#FF0000; scrollbar-face-color: #ffffff; scrollbar-shadow-color: #cccccc; scrollbar-highlight-color:#cccccc; scrollbar-3dlight-color: #ffffff; scrollbar-darkshadow-color: #ffffff; scrollbar-track-color: #ffffff; scrollbar-arrow-color: #ffffff; border:0; background-color:transparent; filter: chroma(color=ffffff);" ></textarea>-->
					</td>
				</tr>
				<tr> 
					<td class='title_g'>답변&nbsp;<%//=ht1.get("POLL_SEQ")%> </td>
					<td align='left' colspan=5>

					<%
					for (int j = 0 ; j < ans_size ; j++) {
						Hashtable answ = (Hashtable)ans.elementAt(j);
					%>

					&nbsp;<%-- <label for="answer<%=i%><%=answ.get("A_SEQ")%>"><input type="radio" name="answer<%=i+1%>" id="answer<%=i%><%=answ.get("A_SEQ")%>" value="<%=answ.get("A_SEQ")%>" <%if(answ.get("A_SEQ").equals(ht1.get("ANSWER"))){%>checked<%}%>><%=answ.get("CONTENT")%></label><br/> --%>
					
					<%
						if (answ.get("MULTI_CHK").equals("Y")) {
							String[] array = ht1.get("ANSWER").toString().split("/");
					%>
					
					<input type="checkbox" name="answer<%=i+1%>" id="answer<%=i%><%=answ.get("A_SEQ")%>" value="<%=answ.get("A_SEQ")%>"
					<%
						for (int z=0; z<array.length; z++) {
							if(answ.get("A_SEQ").equals(array[z])){
					%>
								checked
					<%
							}
						}							
					%>
					>
					<label for="answer<%=i%><%=answ.get("A_SEQ")%>"><%=answ.get("CONTENT")%></label><br/>
					<%} else {%>
					<label for="answer<%=i%><%=answ.get("A_SEQ")%>"><input type="radio" name="answer<%=i+1%>" id="answer<%=i%><%=answ.get("A_SEQ")%>" value="<%=answ.get("A_SEQ")%>" <%if(answ.get("A_SEQ").equals(ht1.get("ANSWER"))){%>checked<%}%>><%=answ.get("CONTENT")%></label><br/>
					<%}%>
					
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<textarea rows="3" name="answer_rem<%=i+1%><%=j+1%>" style=" width: 90%; <%if(!answ.get("CHK").equals("Y")){%> display:none; <%}%>" ><%if(answ.get("A_SEQ").equals(ht1.get("ANSWER"))){%><%=ht1.get("ANSWER_REM")%><%}%></textarea><br/>
					
					<%}%>
					</td>
				</tr>

				<%}%>
			</table>
		</td>
	</tr>
<%}%> 	
	
<%if (vt_size == 0) {%>
	<tr> 
        <td class=line colspan="3">
			<table border="0" cellspacing="1" cellpadding='0' width=100%>
			 <% for (int i = 0 ; i < poll_size ; i++){
						Hashtable ht1 = (Hashtable)polls.elementAt(i);
						
						Vector ans = p_db.getSurvey_answer((String)ht1.get("POLL_ID"), (String)ht1.get("POLL_SEQ"));
						int ans_size = ans.size();	
			%>

			
				<tr> 
					<td width='15%' class='title'>질문 &nbsp;<%=ht1.get("POLL_SEQ")%></td>
					<td align='left' colspan=5>&nbsp;<font color="red"><%=String.valueOf(ht1.get("CONTENT")).trim()%></font>
					<input type='hidden' name="poll_s_id" value='<%=ht1.get("POLL_ID")%>'  > 
					<input type='hidden' name='poll_seq<%=i+1%>' value='<%=ht1.get("POLL_SEQ")%>'> 
					<!--<textarea rows="2" name="question<%=i+1%>" style="  text-align:left; color:#FF0000; scrollbar-face-color: #ffffff; scrollbar-shadow-color: #cccccc; scrollbar-highlight-color:#cccccc; scrollbar-3dlight-color: #ffffff; scrollbar-darkshadow-color: #ffffff; scrollbar-track-color: #ffffff; scrollbar-arrow-color: #ffffff; border:0; background-color:transparent; filter: chroma(color=ffffff);" ></textarea>-->
					</td>
				</tr>
				
				<tr> 
					<td class='title_g'>답변&nbsp;<%//=ht1.get("POLL_SEQ")%> </td>
					<td align='left' colspan=5>

					<%
					for(int j = 0 ; j < ans_size ; j++){
					Hashtable answ = (Hashtable)ans.elementAt(j);
					%>

					&nbsp;<%-- <label for="answer<%=i%><%=answ.get("A_SEQ")%>"><input type="radio" name="answer<%=i+1%>" id="answer<%=i%><%=answ.get("A_SEQ")%>" value="<%=answ.get("A_SEQ")%>" ><%=answ.get("CONTENT")%></label><br/> --%>
					
					<%if(answ.get("MULTI_CHK").equals("Y")){%>
					<input type="checkbox" name="answer<%=i+1%>" id="answer<%=i%><%=answ.get("A_SEQ")%>" value="<%=answ.get("A_SEQ")%>"><label for="answer<%=i%><%=answ.get("A_SEQ")%>"><%=answ.get("CONTENT")%></label><br/>
					<%}else{%>
					<label for="answer<%=i%><%=answ.get("A_SEQ")%>"><input type="radio" name="answer<%=i+1%>" id="answer<%=i%><%=answ.get("A_SEQ")%>" value="<%=answ.get("A_SEQ")%>" ><%=answ.get("CONTENT")%></label><br/>
					<%}%>
					
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<textarea rows="3" name="answer_rem<%=i+1%><%=j+1%>" id="answer_rem<%=i+1%><%=j+1%>" style=" width: 90%; <%if(!answ.get("CHK").equals("Y")){%> display:none; <%}%>" ></textarea><br/>
					
					<%}%>
					</td>
				</tr>

				<%}%>
			</table>
		</td>
	</tr>
 <%}%> 	
	

	<tr> 
        <td class="" colspan="3">
			<table border="0" cellspacing="1" cellpadding='0' width=100%>
				<%if (vt_size > 0) {%>
				<tr>
					<td class=""><input type="button" class="button button4" value="수정" onclick="save('u');"/></td>
					<td align="right"><input type="button" class="button button4" value="목록" onclick="list_go('u');"/></td>
				</tr>
				<%} else {%>
				<tr>
					<td class=""><input type="button" class="button button4" value="저장" onclick="save('i');"/></td>
					<td align="right"><input type="button" class="button button4" value="목록" onclick="list_go('i');"/></td>
				</tr>
				<%}%>
			</table>
		</td>
    </tr>
</table>

</form>  

</body>
</html>

