<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.call.*,acar.cont.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
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
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "16", "01", "02");
	
	//계약:고객관련
	ContBaseBean base 		= p_db.getContBaseAll(m_id, l_cd);
	
	String h_brch = base.getBrch_id();
	String rent_st = base.getRent_st();
	String bus_st = base.getBus_st();  //6:기존업체
	String ext_st = base.getExt_st();
		
	if (rent_st.equals("2"))
		rent_st = "5";
	else if (rent_st.equals("7"))	
		rent_st = "6";
	
	if (rent_st.equals("6") &&	bus_st.equals("6"))
			rent_st = "8";   // 재리스 기존업체
	
	if (ext_st.equals("연장"))
		rent_st = "5";
		
	
	//car_call정보
 	Vector vt		= p_db.getPollAll(m_id, l_cd);
 	int vt_size = vt.size();

 	//live_poll정보
 	Vector vt_live		= p_db.getPollAll(rent_st, "A", "A");
 	int vt_live_size = vt_live.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript' src='car_rent_base.js'></script>

<script language="JavaScript">
<!--
	//등록하기
	function save()
	{	
		
		var fm = document.form1;
	   	var len = fm.elements.length;
	   	var cnt = 0;
	   	
	   	
<%		for (int j = 0; j < vt_live_size ; j++) { %>
		
			for (var i = 0; i < len ; i++) { 
				var ck = fm.elements[i];
				if (ck.name == "answer<%=j%>") {
					if (ck.checked == true) {
						cnt++;
					}	
				}
			}
			
			
	//	  	alert(cnt);
		  	
		  	if( cnt == 0 ) {
			      alert("<%=j+1%>번 질문에 답변을 다셔야 합니다.!!!");
		       	  return ;
		    	} else { 	  
	 	 	  cnt =0;
	 		} 
		
<% } %>	  	 	  	

  			
		if(confirm('수정하시겠습니까?')){
//			fm.target='nodisplay';
			fm.target='c_foot';
			fm.action='survey_reg_all_u_a.jsp';
			fm.submit();
		}
	}

//-->
</script>
<style type=text/css>

<!--
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->

</style>
</head>
<body leftmargin="15">

    <form action='survey_reg_all_u_a.jsp' name="form1" method='post'>
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
 	
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
     <%//지급수수료:영업소사원
	Hashtable mgrs 		= a_db.getCommiNInfo(m_id, l_cd);
	Hashtable mgr_bus 	= (Hashtable)mgrs.get("BUS");
	Hashtable mgr_dlv 	= (Hashtable)mgrs.get("DLV");%>
	<tr>
        <td class=line2></td>
    </tr>
	<tr> 
        <td class=line colspan="3">
			<table border="0" cellspacing="1" cellpadding='0' width=100%>
				<tr>
					<td class="title">콜관리사항</td>
				</tr>
			</table>
		</td>
    </tr>
	<tr>
        <td class=h></td>
    </tr>
	<tr> 
        <td class=line colspan="3">
			<table border="0" cellspacing="1" cellpadding='0' width=100%>
				<tr>
					<td align="center">콜 항목 등록시 입력한 안내문구 표시</td>
				</tr>
			</table>
		</td>
    </tr>
	
    
  <!--call정보 -loop-->  
<%	if(vt_size > 0){%>
   	<tr> 		
          <td class=line colspan="3"><table border="0" cellspacing="1" cellpadding='0' width=100%>
              <% for (int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
			
					String poll_id_s = ht.get("POLL_ID").toString();
					
					 	//car call live_poll정보
					Vector vt_call	= p_db.getPollAll(poll_id_s);
 					int vt_call_size = vt_call.size();
 					 					 
          	 		for (int j = 0 ; j < vt_call_size ; j++){
					Hashtable ht2 = (Hashtable)vt_call.elementAt(j);			
					
					
			 %>
			
			 <tr> 
            	<td width='15%' class='title'>질문&nbsp;<%=i+1%></td>
            	<td align='left' colspan=5>&nbsp;<input type='hidden' name="poll_id<%=i%>"  value='<%=ht.get("POLL_ID")%>' > 
            	<!--<input type='text' name="question<%=i%>" value='<%=ht.get("QUESTION")%>' size='100' class='redtext' readonly > -->
				<textarea rows="2" cols="100" name="question<%=i%>"  style="color:#FF0000; scrollbar-face-color: #ffffff; scrollbar-shadow-color: #cccccc; scrollbar-highlight-color:#cccccc; scrollbar-3dlight-color: #ffffff; scrollbar-darkshadow-color: #ffffff; scrollbar-track-color: #ffffff; scrollbar-arrow-color: #ffffff; border:0; background-color:transparent; filter: chroma(color=ffffff);"><%=ht.get("QUESTION")%></textarea>
				
           		</td>
          	 </tr>
 
          	 <tr> 
	            <td class='title_g'>답변&nbsp;<%=i+1%></td>
	            <td align='left' colspan=5>
	           	   <input type='radio' name="answer<%=i%>" value='1' <%if(ht.get("ANSWER").equals("1")){ %>checked<%}%>> <%=ht2.get("ANSWER1")%>
	          <% if( ht2.get("ANSWER1_REM").equals("1")   ){ %>  <br>&nbsp;<textarea rows='3' cols='100' name="answer_rem0<%=i%>"><%if(ht.get("ANSWER").equals("1")){ %><%=ht.get("ANSWER_REM")%><%}%></textarea> <% } %>	           
	          <% if( !ht2.get("ANSWER2").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='2' <%if(ht.get("ANSWER").equals("2")){ %>checked<%}%>> <%=ht2.get("ANSWER2")%>  <% } %>
	          <% if( ht2.get("ANSWER2_REM").equals("1")   ){ %>  <br>&nbsp;<textarea rows='3' cols='100' name="answer_rem1<%=i%>"><%if(ht.get("ANSWER").equals("2")){ %><%=ht.get("ANSWER_REM")%><%}%></textarea>  <% } %>  	          
	          <% if( !ht2.get("ANSWER3").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='3' <%if(ht.get("ANSWER").equals("3")){ %>checked<%}%>> <%=ht2.get("ANSWER3")%>   <% } %>
	          <% if( ht2.get("ANSWER3_REM").equals("1")  ){ %>  <br>&nbsp;<textarea rows='3' cols='100' name="answer_rem2<%=i%>"><%if(ht.get("ANSWER").equals("3")){ %><%=ht.get("ANSWER_REM")%><%}%></textarea>  <% } %>
	          <% if( !ht2.get("ANSWER4").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='4' <%if(ht.get("ANSWER").equals("4")){ %>checked<%}%>> <%=ht2.get("ANSWER4")%>   <% } %>
	          <% if( ht2.get("ANSWER4_REM").equals("1")  ){ %>  <br>&nbsp;<textarea rows='3' cols='100' name="answer_rem3<%=i%>"><%if(ht.get("ANSWER").equals("4")){ %><%=ht.get("ANSWER_REM")%><%}%></textarea>  <% } %>
	          <% if( !ht2.get("ANSWER5").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='5' <%if(ht.get("ANSWER").equals("5")){ %>checked<%}%>> <%=ht2.get("ANSWER5")%>   <% } %>
	          <% if( ht2.get("ANSWER5_REM").equals("1")  ){ %>  <br>&nbsp;<textarea rows='3' cols='100' name="answer_rem4<%=i%>"><%if(ht.get("ANSWER").equals("5")){ %><%=ht.get("ANSWER_REM")%><%}%></textarea>  <% } %>
	          <% if( !ht2.get("ANSWER6").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='6' <%if(ht.get("ANSWER").equals("6")){ %>checked<%}%>> <%=ht2.get("ANSWER6")%>   <% } %>
	          <% if( ht2.get("ANSWER6_REM").equals("1")  ){ %>  <br>&nbsp;<textarea rows='3' cols='100' name="answer_rem5<%=i%>"><%if(ht.get("ANSWER").equals("6")){ %><%=ht.get("ANSWER_REM")%><%}%></textarea>  <% } %>
	          <% if( !ht2.get("ANSWER7").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='7' <%if(ht.get("ANSWER").equals("7")){ %>checked<%}%>> <%=ht2.get("ANSWER7")%>   <% } %>
	          <% if( ht2.get("ANSWER7_REM").equals("1")  ){ %>  <br>&nbsp;<textarea rows='3' cols='100' name="answer_rem6<%=i%>"><%if(ht.get("ANSWER").equals("7")){ %><%=ht.get("ANSWER_REM")%><%}%></textarea>  <% } %>
	          <% if( !ht2.get("ANSWER8").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='8' <%if(ht.get("ANSWER").equals("8")){ %>checked<%}%>> <%=ht2.get("ANSWER8")%>   <% } %>
	          <% if( ht2.get("ANSWER8_REM").equals("1")  ){ %>  <br>&nbsp;<textarea rows='3' cols='100' name="answer_rem7<%=i%>"><%if(ht.get("ANSWER").equals("8")){ %><%=ht.get("ANSWER_REM")%><%}%></textarea>  <% } %>
	         <% if( !ht2.get("ANSWER9").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='9' <%if(ht.get("ANSWER").equals("9")){ %>checked<%}%>> <%=ht2.get("ANSWER9")%>   <% } %>
	          <% if( ht2.get("ANSWER9_REM").equals("1")  ){ %>  <br>&nbsp;<textarea rows='3' cols='100' name="answer_rem8<%=i%>"><%if(ht.get("ANSWER").equals("9")){ %><%=ht.get("ANSWER_REM")%><%}%></textarea>  <% } %>
	            </td>
	          </tr>
	          
	         <%}%>
	       <% } %>  
            </table>
        </td>  
    </tr>
<%}%>  
<%	if(vt_size == 0){%>
	<tr> 
        <td class=line colspan="3"> <table border="0" cellspacing="1" cellpadding='0' width=100%>
         <% for (int i = 0 ; i < vt_live_size ; i++){
					Hashtable ht1 = (Hashtable)vt_live.elementAt(i);
					
						
								
		%>
    	  <tr> 
            <td width='15%' class='title'>질문&nbsp;<%=i+1%></td>
            <td align='left' colspan=5>&nbsp;
            <input type='hidden' name="poll_id<%=i%>" value='<%=ht1.get("POLL_ID")%>'  > 
            <!--<input type='text' name="question<%=i%>"  size='100' maxlength='256' value='<%=ht1.get("QUESTION")%>' class='redtext' readonly style="white-space:normal;"> -->
			<textarea rows="2" cols="100" name="question<%=i%>" style="color:#FF0000; scrollbar-face-color: #ffffff; scrollbar-shadow-color: #cccccc; scrollbar-highlight-color:#cccccc; scrollbar-3dlight-color: #ffffff; scrollbar-darkshadow-color: #ffffff; scrollbar-track-color: #ffffff; scrollbar-arrow-color: #ffffff; border:0; background-color:transparent; filter: chroma(color=ffffff);" ><%=ht1.get("QUESTION")%></textarea>
            </td>
          </tr>
          <tr> 
            <td class='title_g'>답변&nbsp;<%=i+1%></td>
            <td align='left' colspan=5>
           	   <input type='radio' name="answer<%=i%>" value='1' ><%=ht1.get("ANSWER1")%>
          <% if( ht1.get("ANSWER1_REM").equals("1") ){ %> <br>&nbsp;<textarea rows='3' cols='100' name="answer_rem0<%=i%>"></textarea>   <% } %>
          
          <% if( !ht1.get("ANSWER2").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='2' ><%=ht1.get("ANSWER2")%>  <% } %>
          <% if( ht1.get("ANSWER2_REM").equals("1") ){ %> <br>&nbsp;<textarea rows='3' cols='100' name="answer_rem1<%=i%>"></textarea></p>  <% } %>  
          
          <% if ( ht1.get("POLL_ST").equals("1")  &&  ht1.get("POLL_SEQ").equals("10") ) {
          	
          		if( !ht1.get("ANSWER3").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='3' <%if ( mgr_bus.get("EMP_ID") == null || mgr_bus.get("EMP_ID").equals("")  ) {%>  <%} else{ %> checked <% } %>><%=ht1.get("ANSWER3")%> <% } %>
       
          <% } else {
          		if( !ht1.get("ANSWER3").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='3' ><%=ht1.get("ANSWER3")%> <% } %>
          
          <% } %>
       
          <% if( ht1.get("ANSWER3_REM").equals("1") ){ %>  <br>&nbsp;<textarea rows='3' cols='100' name="answer_rem2<%=i%>"></textarea></p>  <% } %>                 
          <% if( !ht1.get("ANSWER4").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='4' ><%=ht1.get("ANSWER4")%>   <% } %>
          <% if( ht1.get("ANSWER4_REM").equals("1") ){ %>  <br>&nbsp;<textarea rows='3' cols='100' name="answer_rem3<%=i%>"></textarea></p>  <% } %>
          <% if( !ht1.get("ANSWER5").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='5' ><%=ht1.get("ANSWER5")%>   <% } %>
          <% if( ht1.get("ANSWER5_REM").equals("1") ){ %>  <br>&nbsp;<textarea rows='3' cols='100' name="answer_rem4<%=i%>"></textarea></p>  <% } %>
          <% if( !ht1.get("ANSWER6").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='6' ><%=ht1.get("ANSWER6")%>   <% } %>
          <% if( ht1.get("ANSWER6_REM").equals("1") ){ %>  <br>&nbsp;<textarea rows='3' cols='100' name="answer_rem5<%=i%>"></textarea></p>  <% } %>
          <% if( !ht1.get("ANSWER7").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='7' ><%=ht1.get("ANSWER7")%>   <% } %>
          <% if( ht1.get("ANSWER7_REM").equals("1") ){ %>  <br>&nbsp;<textarea rows='3' cols='100' name="answer_rem6<%=i%>"></textarea></p>  <% } %>
          <% if( !ht1.get("ANSWER8").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='8' ><%=ht1.get("ANSWER8")%>   <% } %>
          <% if( ht1.get("ANSWER8_REM").equals("1") ){ %>  <br>&nbsp;<textarea rows='3' cols='100' name="answer_rem7<%=i%>"></textarea></p>  <% } %>
          <% if( !ht1.get("ANSWER9").equals("") ){ %>  <p><input type='radio' name="answer<%=i%>" value='9' ><%=ht1.get("ANSWER9")%>   <% } %>
          <% if( ht1.get("ANSWER9_REM").equals("1") ){ %>  <br>&nbsp;<textarea rows='3' cols='100' name="answer_rem8<%=i%>"></textarea></p>  <% } %>
            </td>
          </tr>
          <%}%>
    	  </table></td>
    </tr>
 <%}%>  
</table>
</form>  

</body>
</html>

